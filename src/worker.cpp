#include <cmath>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <sstream>
#include <vector>
#include <set>
#include <algorithm>
#include <mutex>
#include <thread>
#include <cctype>

#include <netinet/in.h>
#include <arpa/inet.h>

#include "ocelot.h"
#include "scrape_controller.h"
#include "announce_controller.h"
#include "update_controller.h"
#include "report_controller.h"
#include "config.h"
#include "db.h"
#include "worker.h"
#include "site_comm.h"
#include "user.h"
#include "logger.h"

// A worker would protect these.. we're deprecating worker, but these will be here for now.
std::mutex worker::m_ustats_lock;
std::mutex worker::m_del_reasons_lock;

//---------- Worker - does stuff with input
worker::worker(torrent_list &torrents, user_list &users, std::vector<std::string> &_whitelist, config * conf_obj, site_comm * sc)
  : m_torrents_list(torrents), m_users_list(users), m_whitelist(_whitelist),
    m_conf(conf_obj), m_site_comm(sc)
{
  m_status = OPEN;
  m_db = mysql::get_instance();
}

bool worker::signal(int sig) {
  if (m_status == OPEN) {
    m_status = CLOSING;
    Logger::info("closing tracker... press Ctrl-C again to terminate");
    return false;
  } else if (m_status == CLOSING) {
    Logger::warn("shutting down uncleanly");
    return true;
  } else {
    return false;
  }
}

//
// Process Incoming Request
//
std::string worker::on_request( Request request ) {
  // Preliminary check for invalid request
  if ( !request.is_valid() ) {
    return error("GET string too short");
  }
  
  // Get the announce url passkey
  std::string passkey = request.get_passkey();
  
  // Check if passkey is valid
  if( passkey.empty() ) {
    return error("Malformed announce");
  }
  
  // Get Action
  action_t action = request.get_action();

  // Get Request Params
  params_map_t params = request.get_params();
  
  // Check integrity and permissions
  if ( params.empty() ) {
    // No parameters given. Probably means we're not talking to a torrent client
    return response("Nothing to see here", false, true);
  }
  
  // Check tracker status
  if (m_status != OPEN && action != UPDATE) {
    return error("The tracker is temporarily unavailable.");
  }
  
  switch (action) {
    case ANNOUNCE:
      return AnnounceController::on_request( request );
    case SCRAPE:
      return ScrapeController::on_request( request );
    case UPDATE:
      return UpdateController::on_request( request );
    case REPORT:
      return ReportController::on_request( request );
    case INVALID:
      return error("Invalid action");
    default:
      return error("Bad Request");
  }
}

void worker::start_reaper() {
  std::thread thread(&worker::do_start_reaper, this);
  thread.detach();
}

void worker::do_start_reaper() {
  reap_peers();
  reap_del_reasons();
}

void worker::reap_peers() {
  std::cout << "Starting peer reaper" << std::endl;
  m_cur_time = time(NULL);
  unsigned int reaped_l = 0, reaped_s = 0;
  unsigned int cleared_torrents = 0;
  for (auto t = m_torrents_list.begin(); t != m_torrents_list.end(); ++t) {
    bool reaped_this = false; // True if at least one peer was deleted from the current torrent
    auto p = t->second.leechers.begin();
    peer_list::iterator del_p;
    while (p != t->second.leechers.end()) {
      if (p->second.last_announced + m_conf->peers_timeout < m_cur_time) {
        del_p = p++;
        std::unique_lock<std::mutex> us_lock(m_ustats_lock);
        del_p->second.user->decr_leeching();
        us_lock.unlock();
        std::unique_lock<std::mutex> tl_lock(m_db->m_torrent_list_mutex);
        t->second.leechers.erase(del_p);
        reaped_this = true;
        reaped_l++;
      } else {
        ++p;
      }
    }
    p = t->second.seeders.begin();
    while (p != t->second.seeders.end()) {
      if (p->second.last_announced + m_conf->peers_timeout < m_cur_time) {
        del_p = p++;
        std::unique_lock<std::mutex> us_lock(m_ustats_lock);
        del_p->second.user->decr_seeding();
        us_lock.unlock();
        std::unique_lock<std::mutex> tl_lock(m_db->m_torrent_list_mutex);
        t->second.seeders.erase(del_p);
        reaped_this = true;
        reaped_s++;
      } else {
        ++p;
      }
    }
    if (reaped_this && t->second.seeders.empty() && t->second.leechers.empty()) {
      std::stringstream record;
      record << '(' << t->second.id << ",0,0,0," << t->second.balance << ')';
      std::string record_str = record.str();
      m_db->record_torrent(record_str);
      cleared_torrents++;
    }
  }
  if (reaped_l || reaped_s) {
    stats.leechers -= reaped_l;
    stats.seeders -= reaped_s;
  }
  std::cout << "Reaped " << reaped_l << " leechers and " << reaped_s << " seeders. Reset " << cleared_torrents << " torrents" << std::endl;
}

void worker::reap_del_reasons()
{
  std::cout << "Starting del reason reaper" << std::endl;
  time_t max_time = time(NULL) - m_conf->del_reason_lifetime;
  auto it = m_del_reasons.begin();
  unsigned int reaped = 0;
  for (; it != m_del_reasons.end(); ) {
    if (it->second.time <= max_time) {
      auto del_it = it++;
      std::unique_lock<std::mutex> dr_lock(m_del_reasons_lock);
      m_del_reasons.erase(del_it);
      reaped++;
      continue;
    }
    ++it;
  }
  std::cout << "Reaped " << reaped << " del reasons" << std::endl;
}
