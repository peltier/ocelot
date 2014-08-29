#ifndef OCELOT_H
#define OCELOT_H

#include <string>
#include <map>
#include <vector>
#include <unordered_map>
#include <set>
#include <memory>
#include <mutex>
#include <atomic>

#include <boost/date_time/posix_time/posix_time.hpp>

#define BENCHMARK(x) \
  auto before = boost::posix_time::microsec_clock::local_time(); \
  x; \
  auto after = boost::posix_time::microsec_clock::local_time(); \
  std::cout << "BENCHMARK: " << ( after - before ).total_microseconds() << " μs" << std::endl;

class user;
typedef std::shared_ptr<user> user_ptr;

struct peer {
  unsigned int port;
  int64_t uploaded;
  int64_t downloaded;
  int64_t corrupt;
  int64_t left;
  time_t last_announced;
  time_t first_announced;
  unsigned int announces;
  bool visible;
  bool invalid_ip;
  user_ptr user;
  std::string ip_port;
  std::string ip;
};

// TODO: Let's put this in a Trie, no?
typedef std::map<std::string, peer> peer_list;

enum freetype { NORMAL, FREE, NEUTRAL };

struct torrent {
  int id;
  int64_t balance;
  int completed;
  freetype free_torrent;
  time_t last_flushed;
  peer_list seeders;
  peer_list leechers;
  std::string last_selected_seeder;
  std::set<int> tokened_users;
};

enum {
  DUPE, // 0
  TRUMP, // 1
  BAD_FILE_NAMES, // 2
  BAD_FOLDER_NAMES, // 3
  BAD_TAGS, // 4
  BAD_FORMAT, // 5
  DISCS_MISSING, // 6
  DISCOGRAPHY,// 7
  EDITED_LOG,// 8
  INACCURATE_BITRATE, // 9
  LOW_BITRATE, // 10
  MUTT_RIP,// 11
  BAD_SOURCE,// 12
  ENCODE_ERRORS,// 13
  BANNED, // 14
  TRACKS_MISSING,// 15
  TRANSCODE, // 16
  CASSETTE, // 17
  UNSPLIT_ALBUM, // 18
  USER_COMPILATION, // 19
  WRONG_FORMAT, // 20
  WRONG_MEDIA, // 21
  AUDIENCE // 22
};

struct del_message {
  int reason;
  time_t time;
};

typedef std::unordered_map<std::string, torrent> torrent_list;
typedef std::unordered_map<std::string, user_ptr> user_list;
typedef std::unordered_map<std::string, std::string> params_map_t;

struct stats_t {
  std::atomic<uint64_t> open_connections;
  std::atomic<uint64_t> opened_connections;
  std::atomic<uint64_t> connection_rate;
  std::atomic<uint64_t> leechers;
  std::atomic<uint64_t> seeders;
  std::atomic<uint64_t> announcements;
  std::atomic<uint64_t> succ_announcements;
  std::atomic<uint64_t> scrapes;
  std::atomic<uint64_t> bytes_read;
  std::atomic<uint64_t> bytes_written;
  std::atomic<time_t> start_time;
};

extern struct stats_t stats;

#endif
