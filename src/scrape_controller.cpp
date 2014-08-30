#include "scrape_controller.h"

std::string ScrapeController::get_response() {
  
  auto torrent_list = TorrentListCache::get();
  auto headers = m_request.get_headers();
  
  bool gzip = false;
  std::string output = "d5:filesd";
  for (auto infohash : m_request.get_info_hashes() ) {
    
    infohash = hex_decode(infohash);
    
    torrent_list::iterator tor = torrent_list.find(infohash);
    if (tor == torrent_list.end()) {
      continue;
    }
    torrent_t *t = &(tor->second);
    
    output += std::to_string(infohash.length());
    output += ':';
    output += infohash;
    output += "d8:completei";
    output += std::to_string(t->seeders.size());
    output += "e10:incompletei";
    output += std::to_string(t->leechers.size());
    output += "e10:downloadedi";
    output += std::to_string(t->completed);
    output += "ee";
  }
  output += "ee";
  if (headers["accept-encoding"].find("gzip") != std::string::npos) {
    gzip = true;
  }
  return response(output, gzip, false);
  
}