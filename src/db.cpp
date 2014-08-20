#include "ocelot.h"
#include "db.h"
#include "user.h"
#include "misc_functions.h"
#include <string>
#include <iostream>
#include <queue>
#include <time.h>
#include <mutex>
#include <thread>
#include <chrono>

#define DB_LOCK_TIMEOUT 50

mysql::mysql(std::string mysql_m_db, std::string mysql_host, std::string username, std::string password) :
  m_db(mysql_m_db), m_server(mysql_host), m_db_user(username), m_password(password),
  m_u_active(false), m_t_active(false), m_p_active(false), m_s_active(false), m_tok_active(false)
{
  try {
    m_connection.connect(mysql_m_db.c_str(), mysql_host.c_str(), username.c_str(), password.c_str(), 0);
  } catch (const mysqlpp::Exception &er) {
    std::cout << "Failed to connect to MySQL (" << er.what() << ')' << std::endl;
    return;
  }

  std::cout << "Connected to MySQL" << std::endl;
  std::cout << "Clearing xbt_files_users and resetting peer counts...";
  std::cout.flush();
  clear_peer_data();
  std::cout << "done" << std::endl;
}

bool mysql::connected() {
  return m_connection.connected();
}

void mysql::clear_peer_data() {
  try {
    mysqlpp::Query query = m_connection.query("TRUNCATE xbt_files_users;");
    if (!query.exec()) {
      std::cerr << "Unable to truncate xbt_files_users!" << std::endl;
    }
    query = m_connection.query("UPDATE torrents SET Seeders = 0, Leechers = 0;");
    if (!query.exec()) {
      std::cerr << "Unable to reset seeder and leecher count!" << std::endl;
    }
  } catch (const mysqlpp::BadQuery &er) {
    std::cerr << "Query error: " << er.what() << " in clear_peer_data" << std::endl;
  } catch (const mysqlpp::Exception &er) {
    std::cerr << "Query error: " << er.what() << " in clear_peer_data" << std::endl;
  }
}

void mysql::load_torrents(torrent_list &torrents) {
  mysqlpp::Query query = m_connection.query("SELECT ID, info_hash, freetorrent, Snatched FROM torrents ORDER BY ID;");
  if (mysqlpp::StoreQueryResult res = query.store()) {
    mysqlpp::String one("1"); // Hack to get around bug in mysql++3.0.0
    mysqlpp::String two("2");
    size_t num_rows = res.num_rows();
    for (size_t i = 0; i < num_rows; i++) {
      std::string info_hash;
      res[i][1].to_string(info_hash);

      torrent t;
      t.id = res[i][0];
      if (res[i][2].compare(one) == 0) {
        t.free_torrent = FREE;
      } else if (res[i][2].compare(two) == 0) {
        t.free_torrent = NEUTRAL;
      } else {
        t.free_torrent = NORMAL;
      }
      t.balance = 0;
      t.completed = res[i][3];
      t.last_selected_seeder = "";
      torrents[info_hash] = t;
    }
  }
}

void mysql::load_users(user_list &users) {
  mysqlpp::Query query = m_connection.query("SELECT ID, can_leech, torrent_pass, visible FROM users_main WHERE Enabled='1';");
  if (mysqlpp::StoreQueryResult res = query.store()) {
    size_t num_rows = res.num_rows();
    for (size_t i = 0; i < num_rows; i++) {
      std::string passkey;
      res[i][2].to_string(passkey);
      bool protect_ip = res[i][3].compare("1") != 0;

      user_ptr u(new user(res[i][0], res[i][1], protect_ip));
      users.insert(std::pair<std::string, user_ptr>(passkey, u));
    }
  }
}

void mysql::load_tokens(torrent_list &torrents) {
  mysqlpp::Query query = m_connection.query("SELECT uf.UserID, t.info_hash FROM users_freeleeches AS uf JOIN torrents AS t ON t.ID = uf.TorrentID WHERE uf.Expired = '0';");
  if (mysqlpp::StoreQueryResult res = query.store()) {
    size_t num_rows = res.num_rows();
    for (size_t i = 0; i < num_rows; i++) {
      std::string info_hash;
      res[i][1].to_string(info_hash);
      torrent_list::iterator it = torrents.find(info_hash);
      if (it != torrents.end()) {
        torrent &tor = it->second;
        tor.tokened_users.insert(res[i][0]);
      }
    }
  }
}


void mysql::load_whitelist(std::vector<std::string> &whitelist) {
  mysqlpp::Query query = m_connection.query("SELECT peer_id FROM xbt_client_whitelist;");
  if (mysqlpp::StoreQueryResult res = query.store()) {
    size_t num_rows = res.num_rows();
    for (size_t i = 0; i<num_rows; i++) {
      whitelist.push_back(res[i][0].c_str());
    }
  }
}

void mysql::record_token(std::string &record) {
  if (m_update_token_buffer != "") {
    m_update_token_buffer += ",";
  }
  m_update_token_buffer += record;
}

void mysql::record_user(std::string &record) {
  if (m_update_user_buffer != "") {
    m_update_user_buffer += ",";
  }
  m_update_user_buffer += record;
}

void mysql::record_torrent(std::string &record) {
  std::unique_lock<std::mutex> tb_lock(m_torrent_buffer_lock);
  if (m_update_torrent_buffer != "") {
    m_update_torrent_buffer += ",";
  }
  m_update_torrent_buffer += record;
}

void mysql::record_peer(std::string &record, std::string &ip, std::string &peer_id, std::string &useragent) {
  if (m_update_heavy_peer_buffer != "") {
    m_update_heavy_peer_buffer += ",";
  }
  mysqlpp::Query q = m_connection.query();
  q << record << mysqlpp::quote << ip << ',' << mysqlpp::quote << peer_id << ',' << mysqlpp::quote << useragent << "," << time(NULL) << ')';

  m_update_heavy_peer_buffer += q.str();
}
void mysql::record_peer(std::string &record, std::string &peer_id) {
  if (m_update_light_peer_buffer != "") {
    m_update_light_peer_buffer += ",";
  }
  mysqlpp::Query q = m_connection.query();
  q << record << mysqlpp::quote << peer_id << ',' << time(NULL) << ')';

  m_update_light_peer_buffer += q.str();
}

void mysql::record_snatch(std::string &record, std::string &ip) {
  if (m_update_snatch_buffer != "") {
    m_update_snatch_buffer += ",";
  }
  mysqlpp::Query q = m_connection.query();
  q << record << ',' << mysqlpp::quote << ip << ')';
  m_update_snatch_buffer += q.str();
}

bool mysql::all_clear() {
  return (m_user_queue.size() == 0 && m_torrent_queue.size() == 0 && m_peer_queue.size() == 0 && m_snatch_queue.size() == 0 && m_token_queue.size() == 0);
}

void mysql::flush() {
  flush_users();
  flush_torrents();
  flush_snatches();
  flush_peers();
  flush_tokens();
}

void mysql::flush_users() {
  std::string sql;
  std::unique_lock<std::mutex> uq_lock(m_user_queue_lock);
  size_t qsize = m_user_queue.size();
  if (m_verbose_flush || qsize > 0) {
    std::cout << "User flush queue size: " << qsize << std::endl;
  }
  if (m_update_user_buffer == "") {
    return;
  }
  sql = "INSERT INTO users_main (ID, Uploaded, Downloaded) VALUES " + m_update_user_buffer +
    " ON DUPLICATE KEY UPDATE Uploaded = Uploaded + VALUES(Uploaded), Downloaded = Downloaded + VALUES(Downloaded)";
  m_user_queue.push(sql);
  m_update_user_buffer.clear();
  if (m_u_active == false) {
    std::thread thread(&mysql::do_flush_users, this);
    thread.detach();
  }
}

void mysql::flush_torrents() {
  std::string sql;
  std::unique_lock<std::mutex> tq_lock(m_torrent_queue_lock);
  std::unique_lock<std::mutex> tb_lock(m_torrent_buffer_lock);
  size_t qsize = m_torrent_queue.size();
  if (m_verbose_flush || qsize > 0) {
    std::cout << "Torrent flush queue size: " << qsize << std::endl;
  }
  if (m_update_torrent_buffer == "") {
    return;
  }
  sql = "INSERT INTO torrents (ID,Seeders,Leechers,Snatched,Balance) VALUES " + m_update_torrent_buffer +
    " ON DUPLICATE KEY UPDATE Seeders=VALUES(Seeders), Leechers=VALUES(Leechers), " +
    "Snatched=Snatched+VALUES(Snatched), Balance=VALUES(Balance), last_action = " +
    "IF(VALUES(Seeders) > 0, NOW(), last_action)";
  m_torrent_queue.push(sql);
  m_update_torrent_buffer.clear();
  sql.clear();
  sql = "DELETE FROM torrents WHERE info_hash = ''";
  m_torrent_queue.push(sql);
  if (m_t_active == false) {
    std::thread thread(&mysql::do_flush_torrents, this);
    thread.detach();
  }
}

void mysql::flush_snatches() {
  std::string sql;
  std::unique_lock<std::mutex> sq_lock(m_snatch_queue_lock);
  size_t qsize = m_snatch_queue.size();
  if (m_verbose_flush || qsize > 0) {
    std::cout << "Snatch flush queue size: " << qsize << std::endl;
  }
  if (m_update_snatch_buffer == "" ) {
    return;
  }
  sql = "INSERT INTO xbt_snatched (uid, fid, tstamp, IP) VALUES " + m_update_snatch_buffer;
  m_snatch_queue.push(sql);
  m_update_snatch_buffer.clear();
  if (m_s_active == false) {
    std::thread thread(&mysql::do_flush_snatches, this);
    thread.detach();
  }
}

void mysql::flush_peers() {
  std::string sql;
  std::unique_lock<std::mutex> pq_lock(m_peer_queue_lock);
  size_t qsize = m_peer_queue.size();
  if (m_verbose_flush || qsize > 0) {
    std::cout << "Peer flush queue size: " << qsize << std::endl;
  }

  // Nothing to do
  if (m_update_light_peer_buffer == "" && m_update_heavy_peer_buffer == "") {
    return;
  }

  if (qsize == 0) {
    sql = "SET session sql_log_bin = 0";
    m_peer_queue.push(sql);
    sql.clear();
  }

  if (m_update_heavy_peer_buffer != "") {
    // Because xfu inserts are slow and ram is not infinite we need to
    // limit this queue's size
    // xfu will be messed up if the light query inserts a new row,
    // but that's better than an oom crash
    if (qsize >= 1000) {
      m_peer_queue.pop();
    }
    sql = "INSERT INTO xbt_files_users (uid,fid,active,uploaded,downloaded,upspeed,downspeed,remaining,corrupt," +
      std::string("timespent,announced,ip,peer_id,useragent,mtime) VALUES ") + m_update_heavy_peer_buffer +
          " ON DUPLICATE KEY UPDATE active=VALUES(active), uploaded=VALUES(uploaded), " +
          "downloaded=VALUES(downloaded), upspeed=VALUES(upspeed), " +
          "downspeed=VALUES(downspeed), remaining=VALUES(remaining), " +
          "corrupt=VALUES(corrupt), timespent=VALUES(timespent), " +
          "announced=VALUES(announced), mtime=VALUES(mtime)";
    m_peer_queue.push(sql);
    m_update_heavy_peer_buffer.clear();
    sql.clear();
  }
  if (m_update_light_peer_buffer != "") {
    // See comment above
    if (qsize >= 1000) {
      m_peer_queue.pop();
    }
    sql = "INSERT INTO xbt_files_users (fid,timespent,announced,peer_id,mtime) VALUES " +
          m_update_light_peer_buffer +
          " ON DUPLICATE KEY UPDATE upspeed=0, downspeed=0, timespent=VALUES(timespent), " +
          "announced=VALUES(announced), mtime=VALUES(mtime)";
    m_peer_queue.push(sql);
    m_update_light_peer_buffer.clear();
    sql.clear();
  }

  if (m_p_active == false) {
    std::thread thread(&mysql::do_flush_peers, this);
    thread.detach();
  }
}

void mysql::flush_tokens() {
  std::string sql;
  std::unique_lock<std::mutex> tq_lock(m_token_queue_lock);
  size_t qsize = m_token_queue.size();
  if (m_verbose_flush || qsize > 0) {
    std::cout << "Token flush queue size: " << qsize << std::endl;
  }
  if (m_update_token_buffer == "") {
    return;
  }
  sql = "INSERT INTO users_freeleeches (UserID, TorrentID, Downloaded) VALUES " + m_update_token_buffer +
    " ON DUPLICATE KEY UPDATE Downloaded = Downloaded + VALUES(Downloaded)";
  m_token_queue.push(sql);
  m_update_token_buffer.clear();
  if (m_tok_active == false) {
    std::thread thread(&mysql::do_flush_tokens, this);
    thread.detach();
  }
}

void mysql::do_flush_users() {
  m_u_active = true;
  try {
    mysqlpp::Connection c(m_db.c_str(), m_server.c_str(), m_db_user.c_str(), m_password.c_str(), 0);
    while (m_user_queue.size() > 0) {
      try {
        std::string sql = m_user_queue.front();
        mysqlpp::Query query = c.query(sql);
        if (!query.exec()) {
          std::cout << "User flush failed (" << m_user_queue.size() << " remain)" << std::endl;
          std::this_thread::sleep_for(std::chrono::seconds(3));
          continue;
        } else {
          std::unique_lock<std::mutex> uq_lock(m_user_queue_lock);
          m_user_queue.pop();
        }
      }
      catch (const mysqlpp::BadQuery &er) {
        std::cerr << "Query error: " << er.what() << " in flush users with a qlength: " << m_user_queue.front().size() << " queue size: " << m_user_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      } catch (const mysqlpp::Exception &er) {
        std::cerr << "Query error: " << er.what() << " in flush users with a qlength: " << m_user_queue.front().size() <<  " queue size: " << m_user_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      }
    }
  }
  catch (const mysqlpp::Exception &er) {
    std::cerr << "MySQL error in flush_users: " << er.what() << std::endl;
    m_u_active = false;
    return;
  }
  m_u_active = false;
}

void mysql::do_flush_torrents() {
  m_t_active = true;
  try {
    mysqlpp::Connection c(m_db.c_str(), m_server.c_str(), m_db_user.c_str(), m_password.c_str(), 0);
    while (m_torrent_queue.size() > 0) {
      try {
        std::string sql = m_torrent_queue.front();
        if (sql == "") {
          m_torrent_queue.pop();
          continue;
        }
        mysqlpp::Query query = c.query(sql);
        if (!query.exec()) {
          std::cout << "Torrent flush failed (" << m_torrent_queue.size() << " remain)" << std::endl;
          std::this_thread::sleep_for(std::chrono::seconds(3));
          continue;
        } else {
          std::unique_lock<std::mutex> tq_lock(m_torrent_queue_lock);
          m_torrent_queue.pop();
        }
      }
      catch (const mysqlpp::BadQuery &er) {
        std::cerr << "Query error: " << er.what() << " in flush torrents with a qlength: " << m_torrent_queue.front().size() << " queue size: " << m_torrent_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      } catch (const mysqlpp::Exception &er) {
        std::cerr << "Query error: " << er.what() << " in flush torrents with a qlength: " << m_torrent_queue.front().size() << " queue size: " << m_torrent_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      }
    }
  }
  catch (const mysqlpp::Exception &er) {
    std::cerr << "MySQL error in flush_torrents: " << er.what() << std::endl;
    m_t_active = false;
    return;
  }
  m_t_active = false;
}

void mysql::do_flush_peers() {
  m_p_active = true;
  try {
    mysqlpp::Connection c(m_db.c_str(), m_server.c_str(), m_db_user.c_str(), m_password.c_str(), 0);
    while (m_peer_queue.size() > 0) {
      try {
        std::string sql = m_peer_queue.front();
        mysqlpp::Query query = c.query(sql);
        if (!query.exec()) {
          std::cout << "Peer flush failed (" << m_peer_queue.size() << " remain)" << std::endl;
          std::this_thread::sleep_for(std::chrono::seconds(3));
          continue;
        } else {
          std::unique_lock<std::mutex> pq_lock(m_peer_queue_lock);
          m_peer_queue.pop();
        }
      }
      catch (const mysqlpp::BadQuery &er) {
        std::cerr << "Query error: " << er.what() << " in flush peers with a qlength: " << m_peer_queue.front().size() << " queue size: " << m_peer_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      } catch (const mysqlpp::Exception &er) {
        std::cerr << "Query error: " << er.what() << " in flush peers with a qlength: " << m_peer_queue.front().size() << " queue size: " << m_peer_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      }
    }
  }
  catch (const mysqlpp::Exception &er) {
    std::cerr << "MySQL error in flush_peers: " << er.what() << std::endl;
    m_p_active = false;
    return;
  }
  m_p_active = false;
}

void mysql::do_flush_snatches() {
  m_s_active = true;
  try {
    mysqlpp::Connection c(m_db.c_str(), m_server.c_str(), m_db_user.c_str(), m_password.c_str(), 0);
    while (m_snatch_queue.size() > 0) {
      try {
        std::string sql = m_snatch_queue.front();
        mysqlpp::Query query = c.query(sql);
        if (!query.exec()) {
          std::cout << "Snatch flush failed (" << m_snatch_queue.size() << " remain)" << std::endl;
          std::this_thread::sleep_for(std::chrono::seconds(3));
          continue;
        } else {
          std::unique_lock<std::mutex> sq_lock(m_snatch_queue_lock);
          m_snatch_queue.pop();
        }
      }
      catch (const mysqlpp::BadQuery &er) {
        std::cerr << "Query error: " << er.what() << " in flush snatches with a qlength: " << m_snatch_queue.front().size() << " queue size: " << m_snatch_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      } catch (const mysqlpp::Exception &er) {
        std::cerr << "Query error: " << er.what() << " in flush snatches with a qlength: " << m_snatch_queue.front().size() << " queue size: " << m_snatch_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      }
    }
  }
  catch (const mysqlpp::Exception &er) {
    std::cerr << "MySQL error in flush_snatches: " << er.what() << std::endl;
    m_s_active = false;
    return;
  }
  m_s_active = false;
}

void mysql::do_flush_tokens() {
  m_tok_active = true;
  try {
    mysqlpp::Connection c(m_db.c_str(), m_server.c_str(), m_db_user.c_str(), m_password.c_str(), 0);
    while (m_token_queue.size() > 0) {
      try {
        std::string sql = m_token_queue.front();
        mysqlpp::Query query = c.query(sql);
        if (!query.exec()) {
          std::cout << "Token flush failed (" << m_token_queue.size() << " remain)" << std::endl;
          std::this_thread::sleep_for(std::chrono::seconds(3));
          continue;
        } else {
          std::unique_lock<std::mutex> tq_lock(m_token_queue_lock);
          m_token_queue.pop();
        }
      }
      catch (const mysqlpp::BadQuery &er) {
        std::cerr << "Query error: " << er.what() << " in flush tokens with a qlength: " << m_token_queue.front().size() << " queue size: " << m_token_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      } catch (const mysqlpp::Exception &er) {
        std::cerr << "Query error: " << er.what() << " in flush tokens with a qlength: " << m_token_queue.front().size() << " queue size: " << m_token_queue.size() << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(3));
        continue;
      }
    }
  }
  catch (const mysqlpp::Exception &er) {
    std::cerr << "MySQL error in flush_tokens: " << er.what() << std::endl;
    m_tok_active = false;
    return;
  }
  m_tok_active = false;
}
