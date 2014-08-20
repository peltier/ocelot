#ifndef OCELOT_DB_H
#define OCELOT_DB_H
#pragma GCC visibility push(default)

#include <mysql++/mysql++.h>
#include <string>
#include <unordered_map>
#include <queue>
#include <mutex>

class mysql {
  public:
    mysql(std::string mysql_db, std::string mysql_host, std::string username, std::string password);
    bool connected();
    void load_torrents(torrent_list &torrents);
    void load_users(user_list &users);
    void load_tokens(torrent_list &torrents);
    void load_whitelist(std::vector<std::string> &whitelist);

    void record_user(std::string &record); // (id,uploaded_change,downloaded_change)
    void record_torrent(std::string &record); // (id,seeders,leechers,snatched_change,balance)
    void record_snatch(std::string &record, std::string &ip); // (uid,fid,tstamp)
    void record_peer(std::string &record, std::string &ip, std::string &peer_id, std::string &useragent); // (uid,fid,active,peerid,useragent,ip,uploaded,downloaded,upspeed,downspeed,left,timespent,announces,tstamp)
    void record_peer(std::string &record, std::string &peer_id); // (fid,peerid,timespent,announces,tstamp)
    void record_token(std::string &record);

    void flush();

    bool all_clear();

    bool m_verbose_flush;

    // Used outside class; Clean?
    std::mutex m_torrent_list_mutex;

  private:
    mysqlpp::Connection m_connection;
    std::string m_update_user_buffer;
    std::string m_update_torrent_buffer;
    std::string m_update_heavy_peer_buffer;
    std::string m_update_light_peer_buffer;
    std::string m_update_snatch_buffer;
    std::string m_update_token_buffer;

    std::queue<std::string> m_user_queue;
    std::queue<std::string> m_torrent_queue;
    std::queue<std::string> m_peer_queue;
    std::queue<std::string> m_snatch_queue;
    std::queue<std::string> m_token_queue;

    std::string m_db, m_server, m_db_user, m_password;
    bool m_u_active, m_t_active, m_p_active, m_s_active, m_tok_active;

    // These locks prevent more than one thread from reading/writing the buffers.
    // These should be held for the minimum time possible.
    std::mutex m_user_queue_lock;
    std::mutex m_torrent_buffer_lock;
    std::mutex m_torrent_queue_lock;
    std::mutex m_peer_queue_lock;
    std::mutex m_snatch_queue_lock;
    std::mutex m_token_queue_lock;

    void do_flush_users();
    void do_flush_torrents();
    void do_flush_snatches();
    void do_flush_peers();
    void do_flush_tokens();

    void flush_users();
    void flush_torrents();
    void flush_snatches();
    void flush_peers();
    void flush_tokens();
    void clear_peer_data();

};

#pragma GCC visibility pop
#endif
