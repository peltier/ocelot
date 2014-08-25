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
#include "config.h"
#include "db.h"
#include "worker.h"
#include "site_comm.h"
#include "report.h"
#include "user.h"
#include "logger.h"

std::mutex worker::m_ustats_lock;

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
std::string worker::on_request( const Request &request ) {
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
  
  // Get Info Hashes for SCRAPE
  std::vector<std::string> infohashes;
  if( action == SCRAPE ) {
    infohashes = request.get_info_hashes();
  }
  
  // Get Request Headers
  params_map_t headers = request.get_headers();
  
  // Check integrity and permissions
  if ( params.empty() ) {
    // No parameters given. Probably means we're not talking to a torrent client
    return response("Nothing to see here", false, true);
  }
  
  // Check tracker status
  if (m_status != OPEN && action != UPDATE) {
    return error("The tracker is temporarily unavailable.");
  }
  
  // Check action integrity
  if (action == INVALID) {
    return error("Invalid action");
  }
  
  // Process Actions
  
  if (action == UPDATE) {
    if (passkey == m_conf->site_password) {
      return update(params);
    } else {
      return error("Authentication failure");
    }
  }

  if (action == REPORT) {
    if (passkey == m_conf->report_password) {
      return report(params, m_users_list);
    } else {
      return error("Authentication failure");
    }
  }

  // Either a scrape or an announce

  auto user_it = m_users_list.find(passkey);
  if (user_it == m_users_list.end()) {
    return error("Passkey not found");
  }

  if (action == ANNOUNCE) {
    return AnnounceController::on_request( request );
  } else {
    return ScrapeController::on_request( request );
  }
}

//TODO: Restrict to local IPs
std::string worker::update(params_map_t &params) {
  if (params["action"] == "change_passkey") {
    std::string oldpasskey = params["oldpasskey"];
    std::string newpasskey = params["newpasskey"];
    auto u = m_users_list.find(oldpasskey);
    if (u == m_users_list.end()) {
      std::cout << "No user with passkey " << oldpasskey << " exists when attempting to change passkey to " << newpasskey << std::endl;
    } else {
      m_users_list[newpasskey] = u->second;
      m_users_list.erase(oldpasskey);
      std::cout << "Changed passkey from " << oldpasskey << " to " << newpasskey << " for user " << u->second->get_id() << std::endl;
    }
  } else if (params["action"] == "add_torrent") {
    torrent *t;
    std::string info_hash = params["info_hash"];
    info_hash = hex_decode(info_hash);
    auto i = m_torrents_list.find(info_hash);
    if (i == m_torrents_list.end()) {
      t = &m_torrents_list[info_hash];
      t->id = std::stol(params["id"]);
      t->balance = 0;
      t->completed = 0;
      t->last_selected_seeder = "";
    } else {
      t = &i->second;
    }
    if (params["freetorrent"] == "0") {
      t->free_torrent = NORMAL;
    } else if (params["freetorrent"] == "1") {
      t->free_torrent = FREE;
    } else {
      t->free_torrent = NEUTRAL;
    }
    std::cout << "Added torrent " << t->id << ". FL: " << t->free_torrent << " " << params["freetorrent"] << std::endl;
  } else if (params["action"] == "update_torrent") {
    std::string info_hash = params["info_hash"];
    info_hash = hex_decode(info_hash);
    freetype fl;
    if (params["freetorrent"] == "0") {
      fl = NORMAL;
    } else if (params["freetorrent"] == "1") {
      fl = FREE;
    } else {
      fl = NEUTRAL;
    }
    auto torrent_it = m_torrents_list.find(info_hash);
    if (torrent_it != m_torrents_list.end()) {
      torrent_it->second.free_torrent = fl;
      std::cout << "Updated torrent " << torrent_it->second.id << " to FL " << fl << std::endl;
    } else {
      std::cout << "Failed to find torrent " << info_hash << " to FL " << fl << std::endl;
    }
  } else if (params["action"] == "update_torrents") {
    // Each decoded infohash is exactly 20 characters long.
    std::string info_hashes = params["info_hashes"];
    info_hashes = hex_decode(info_hashes);
    freetype fl;
    if (params["freetorrent"] == "0") {
      fl = NORMAL;
    } else if (params["freetorrent"] == "1") {
      fl = FREE;
    } else {
      fl = NEUTRAL;
    }
    for (unsigned int pos = 0; pos < info_hashes.length(); pos += 20) {
      std::string info_hash = info_hashes.substr(pos, 20);
      auto torrent_it = m_torrents_list.find(info_hash);
      if (torrent_it != m_torrents_list.end()) {
        torrent_it->second.free_torrent = fl;
        std::cout << "Updated torrent " << torrent_it->second.id << " to FL " << fl << std::endl;
      } else {
        std::cout << "Failed to find torrent " << info_hash << " to FL " << fl << std::endl;
      }
    }
  } else if (params["action"] == "add_token") {
    std::string info_hash = hex_decode(params["info_hash"]);
    int userid = atoi(params["userid"].c_str());
    auto torrent_it = m_torrents_list.find(info_hash);
    if (torrent_it != m_torrents_list.end()) {
      torrent_it->second.tokened_users.insert(userid);
    } else {
      std::cout << "Failed to find torrent to add a token for user " << userid << std::endl;
    }
  } else if (params["action"] == "remove_token") {
    std::string info_hash = hex_decode(params["info_hash"]);
    int userid = atoi(params["userid"].c_str());
    auto torrent_it = m_torrents_list.find(info_hash);
    if (torrent_it != m_torrents_list.end()) {
      torrent_it->second.tokened_users.erase(userid);
    } else {
      std::cout << "Failed to find torrent " << info_hash << " to remove token for user " << userid << std::endl;
    }
  } else if (params["action"] == "delete_torrent") {
    std::string info_hash = params["info_hash"];
    info_hash = hex_decode(info_hash);
    int reason = -1;
    auto reason_it = params.find("reason");
    if (reason_it != params.end()) {
      reason = atoi(params["reason"].c_str());
    }
    auto torrent_it = m_torrents_list.find(info_hash);
    if (torrent_it != m_torrents_list.end()) {
      std::cout << "Deleting torrent " << torrent_it->second.id << " for the reason '" << get_deletion_reason(reason) << "'" << std::endl;
      std::unique_lock<std::mutex> stats_lock(stats.mutex);
      stats.leechers -= torrent_it->second.leechers.size();
      stats.seeders -= torrent_it->second.seeders.size();
      stats_lock.unlock();
      std::unique_lock<std::mutex> us_lock(m_ustats_lock);
      for (auto p = torrent_it->second.leechers.begin(); p != torrent_it->second.leechers.end(); ++p) {
        p->second.user->decr_leeching();
      }
      for (auto p = torrent_it->second.seeders.begin(); p != torrent_it->second.seeders.end(); ++p) {
        p->second.user->decr_seeding();
      }
      us_lock.unlock();
      std::unique_lock<std::mutex> dr_lock(m_del_reasons_lock);
      del_message msg;
      msg.reason = reason;
      msg.time = time(NULL);
      m_del_reasons[info_hash] = msg;
      m_torrents_list.erase(torrent_it);
    } else {
      std::cout << "Failed to find torrent " << bintohex(info_hash) << " to delete " << std::endl;
    }
  } else if (params["action"] == "add_user") {
    std::string passkey = params["passkey"];
    unsigned int userid = std::stol(params["id"]);
    auto u = m_users_list.find(passkey);
    if (u == m_users_list.end()) {
      bool protect_ip = params["visible"] == "0";
      user_ptr u(new user(userid, true, protect_ip));
      m_users_list.insert(std::pair<std::string, user_ptr>(passkey, u));
      std::cout << "Added user " << passkey << " with id " << userid << std::endl;
    } else {
      std::cout << "Tried to add already known user " << passkey << " with id " << userid << std::endl;
    }
  } else if (params["action"] == "remove_user") {
    std::string passkey = params["passkey"];
    auto u = m_users_list.find(passkey);
    if (u != m_users_list.end()) {
      std::cout << "Removed user " << passkey << " with id " << u->second->get_id() << std::endl;
      m_users_list.erase(u);
    }
  } else if (params["action"] == "remove_users") {
    // Each passkey is exactly 32 characters long.
    std::string passkeys = params["passkeys"];
    for (unsigned int pos = 0; pos < passkeys.length(); pos += 32) {
      std::string passkey = passkeys.substr(pos, 32);
      auto u = m_users_list.find(passkey);
      if (u != m_users_list.end()) {
        std::cout << "Removed user " << passkey << std::endl;
        m_users_list.erase(passkey);
      }
    }
  } else if (params["action"] == "update_user") {
    std::string passkey = params["passkey"];
    bool can_leech = true;
    bool protect_ip = false;
    if (params["can_leech"] == "0") {
      can_leech = false;
    }
    if (params["visible"] == "0") {
      protect_ip = true;
    }
    user_list::iterator i = m_users_list.find(passkey);
    if (i == m_users_list.end()) {
      std::cout << "No user with passkey " << passkey << " found when attempting to change leeching m_status!" << std::endl;
    } else {
      i->second->set_protected(protect_ip);
      i->second->set_leechstatus(can_leech);
      std::cout << "Updated user " << passkey << std::endl;
    }
  } else if (params["action"] == "add_whitelist") {
    std::string peer_id = params["peer_id"];
    m_whitelist.push_back(peer_id);
    std::cout << "Whitelisted " << peer_id << std::endl;
  } else if (params["action"] == "remove_whitelist") {
    std::string peer_id = params["peer_id"];
    for (unsigned int i = 0; i < m_whitelist.size(); i++) {
      if (m_whitelist[i].compare(peer_id) == 0) {
        m_whitelist.erase(m_whitelist.begin() + i);
        break;
      }
    }
    std::cout << "De-whitelisted " << peer_id << std::endl;
  } else if (params["action"] == "edit_whitelist") {
    std::string new_peer_id = params["new_peer_id"];
    std::string old_peer_id = params["old_peer_id"];
    for (unsigned int i = 0; i < m_whitelist.size(); i++) {
      if (m_whitelist[i].compare(old_peer_id) == 0) {
        m_whitelist.erase(m_whitelist.begin() + i);
        break;
      }
    }
    m_whitelist.push_back(new_peer_id);
    std::cout << "Edited whitelist item from " << old_peer_id << " to " << new_peer_id << std::endl;
  } else if (params["action"] == "update_announce_interval") {
    unsigned int interval = std::stol(params["new_announce_interval"]);
    m_conf->announce_interval = interval;
    std::cout << "Edited announce interval to " << interval << std::endl;
  } else if (params["action"] == "info_torrent") {
    std::string info_hash_hex = params["info_hash"];
    std::string info_hash = hex_decode(info_hash_hex);
    std::cout << "Info for torrent '" << info_hash_hex << "'" << std::endl;
    auto torrent_it = m_torrents_list.find(info_hash);
    if (torrent_it != m_torrents_list.end()) {
      std::cout << "Torrent " << torrent_it->second.id
        << ", freetorrent = " << torrent_it->second.free_torrent << std::endl;
    } else {
      std::cout << "Failed to find torrent " << info_hash_hex << std::endl;
    }
  }
  return response("success", false, false);
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
    std::unique_lock<std::mutex> lock(stats.mutex);
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
