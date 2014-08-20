#ifndef OCELOT_WORKER_H
#define OCELOT_WORKER_H

#include <string>
#include <vector>
#include <list>
#include <unordered_map>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iostream>
#include <fstream>
#include <mutex>
#include "site_comm.h"
#include "ocelot.h"

enum tracker_status { OPEN, PAUSED, CLOSING }; // tracker status

class worker {
  public:
    worker(torrent_list &torrents, user_list &users, std::vector<std::string> &_whitelist, config * conf_obj, mysql * db_obj, site_comm * sc);
    std::string work(std::string &input, std::string &ip);
    std::string announce(torrent &tor, user_ptr &u, params_type &params, params_type &headers, std::string &ip);
    std::string scrape(const std::list<std::string> &infohashes, params_type &headers);
    std::string update(params_type &params);

    bool signal(int sig);

    tracker_status get_status() { return m_status; }

    void start_reaper();

  private:
    torrent_list m_torrents_list;
    user_list m_users_list;
    std::vector<std::string> m_whitelist;
    std::unordered_map<std::string, del_message> m_del_reasons;
    config * m_conf;
    mysql * m_db;
    tracker_status m_status;
    time_t m_cur_time;
    site_comm * m_site_comm;

    std::mutex m_del_reasons_lock;
    std::mutex m_ustats_lock;

    void do_start_reaper();
    void reap_peers();
    void reap_del_reasons();
    std::string get_del_reason(int code);
    peer_list::iterator add_peer(peer_list &peer_list, std::string &peer_id);
    bool peer_is_visible(user_ptr &u, peer *p);

};

#endif