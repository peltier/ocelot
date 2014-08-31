#include <sstream>

#include "announce_controller.h"
#include "ocelot.h"
#include "db.h"
#include "site_comm.h"
#include "worker.h"

//
// Private
//
std::string AnnounceController::before__authenticate() {
  auto user_vec = UserListCache::find( m_request.get_passkey() );
  
  if( user_vec.empty() ) {
    return error("Authentication failure");
  }
  
  return "";
}

std::string AnnounceController::before__validate_torrent() {
  auto params = m_request.get_params();
  
  std::string decoded_info_hash = hex_decode(params["info_hash"]);
  
  // See if the torrent exists and is valid
  auto torrent_vec = TorrentListCache::find( decoded_info_hash );
  
  // See if torrent was deleted
  if( torrent_vec.empty() ) {
    auto deletion_reason_vec = DeletionReasonsCache::find( decoded_info_hash );
    
    if( deletion_reason_vec.empty() ) {
      // No such torrent exists!
      return error("Unregistered torrent");
    } else {
      // Torrent was deleted, check if we know why
      auto deletion_reason = deletion_reason_vec.front();
      if( deletion_reason.reason != -1 ) {
        return error("Unregistered torrent: " + get_deletion_reason(deletion_reason.reason));
      }
    }
  }
  
  return "";
}

peer_list::iterator add_peer(peer_list &peer_list, std::string &peer_id) {
  peer new_peer;
  std::pair<peer_list::iterator, bool> insert
  = peer_list.insert(std::pair<std::string, peer>(peer_id, new_peer));
  return insert.first;
}

/* Peers should be invisible if they are a leecher without
 download privs or their IP is invalid */
bool peer_is_visible(user_ptr &u, peer *p) {
  return (p->left == 0 || u->can_leech()) && !p->invalid_ip;
}

//
// Public
//
std::string AnnounceController::get_response() {

  // Before we announce, let's authrenticate
  auto auth_error = before__authenticate();
  if( !auth_error.empty() ) {
    return auth_error;
  }
  
  // Before we announce, let's validate the torrent
  auto torrent_error = before__validate_torrent();
  if( !torrent_error.empty() ) {
    return torrent_error;
  }
  
  //
  // FIX OLD PARAMS UNTIL WE CAN REWRITE
  //
  
  auto db = mysql::get_instance();
  
  auto site_communicator = site_comm::get_instance();
  
  auto params = m_request.get_params();
  auto headers = m_request.get_headers();
  auto ip = m_request.get_ip_address();
  
  std::cout << m_request.get_passkey() << std::endl;
  
  // We have validated, so we should be good to go here.
  auto u = UserListCache::find( m_request.get_passkey() ).front();
  
  // TODO: Fix me! Get torrent for now.. this is duplicated and bad!!
  std::string decoded_info_hash = hex_decode(params["info_hash"]);
  auto tor = TorrentListCache::find( decoded_info_hash ).front();
  
  auto whitelist = WhitelistCache::get();
  
  //
  // INSER OLD ANNOUNCE METHOD FROM WORKER
  //
  
  auto current_time = time(NULL);
  
  if (params["compact"] != "1") {
    return error("Your client does not support compact announces");
  }
  bool gzip = false;
  
  int64_t left = std::max((long long)0, std::stoll(params["left"]));
  int64_t uploaded = std::max((long long)0, std::stoll(params["uploaded"]));
  int64_t downloaded = std::max((long long)0, std::stoll(params["downloaded"]));
  int64_t corrupt = 0; // TODO: Is this assumption safe?
  if( params.count("corrupt") > 0 ) {
    std::max((long long)0, std::stoll(params["corrupt"]));
  }
  
  int snatched = 0; // This is the value that gets sent to the database on a snatch
  int active = 1; // This is the value that marks a peer as active/inactive in the database
  bool inserted = false; // If we insert the peer as opposed to update
  bool update_torrent = false; // Whether or not we should update the torrent in the DB
  bool completed_torrent = false; // Whether or not the current announcement is a snatch
  bool stopped_torrent = false; // Was the torrent just stopped?
  bool expire_token = false; // Whether or not to expire a token after torrent completion
  bool peer_changed = false; // Whether or not the peer is new or has changed since the last announcement
  bool invalid_ip = false;
  bool inc_l = false, inc_s = false, dec_l = false, dec_s = false;
  
  auto peer_id_iterator = params.find("peer_id");
  if (peer_id_iterator == params.end()) {
    return error("No peer ID");
  }
  std::string peer_id = peer_id_iterator->second;
  peer_id = hex_decode(peer_id);
  
  if (whitelist.size() > 0) {
    bool found = false; // Found client in whitelist?
    for (unsigned int i = 0; i < whitelist.size(); i++) {
      if (peer_id.find(whitelist[i]) == 0) {
        found = true;
        break;
      }
    }
    if (!found) {
      return error("Your client is not on the whitelist");
    }
  }
  
  if (params["event"] == "completed") {
    // Don't update <snatched> here as we may decide to use other conditions later on
    completed_torrent = (left == 0); // Sanity check just to be extra safe
  } else if (params["event"] == "stopped") {
    stopped_torrent = true;
    peer_changed = true;
    update_torrent = true;
    active = 0;
  }
  int userid = u->get_id();
  peer * p;
  peer_list::iterator peer_it;
  // Insert/find the peer in the torrent list
  if (left > 0) {
    peer_it = tor.leechers.find(peer_id);
    if (peer_it == tor.leechers.end()) {
      // We could search the seed list as well, but the peer reaper will sort things out eventually
      peer_it = add_peer(tor.leechers, peer_id);
      inserted = true;
      inc_l = true;
    }
  } else if (completed_torrent) {
    peer_it = tor.leechers.find(peer_id);
    if (peer_it == tor.leechers.end()) {
      peer_it = tor.seeders.find(peer_id);
      if (peer_it == tor.seeders.end()) {
        peer_it = add_peer(tor.seeders, peer_id);
        inserted = true;
        inc_s = true;
      } else {
        completed_torrent = false;
      }
    } else if (tor.seeders.find(peer_id) != tor.seeders.end()) {
      // If the peer exists in both peer lists, just decrement the seed count.
      // Should be cheaper than searching the seed list in the left > 0 case
      dec_s = true;
    }
  } else {
    peer_it = tor.seeders.find(peer_id);
    if (peer_it == tor.seeders.end()) {
      peer_it = tor.leechers.find(peer_id);
      if (peer_it == tor.leechers.end()) {
        peer_it = add_peer(tor.seeders, peer_id);
        inserted = true;
      } else {
        p = &peer_it->second;
        std::pair<peer_list::iterator, bool> insert
        = tor.seeders.insert(std::pair<std::string, peer>(peer_id, *p));
        tor.leechers.erase(peer_it);
        peer_it = insert.first;
        peer_changed = true;
        dec_l = true;
      }
      inc_s = true;
    }
  }
  p = &peer_it->second;
  
  int64_t upspeed = 0;
  int64_t downspeed = 0;
  if (inserted || params["event"] == "started") {
    // New peer on this torrent (maybe)
    update_torrent = true;
    if (inserted) {
      // If this was an existing peer, the user_t pointer will be corrected later
      p->user = u;
    }
    p->first_announced = current_time;
    p->last_announced = 0;
    p->uploaded = uploaded;
    p->downloaded = downloaded;
    p->corrupt = corrupt;
    p->announces = 1;
    peer_changed = true;
  } else if (uploaded < p->uploaded || downloaded < p->downloaded) {
    p->announces++;
    p->uploaded = uploaded;
    p->downloaded = downloaded;
    peer_changed = true;
  } else {
    int64_t uploaded_change = 0;
    int64_t downloaded_change = 0;
    int64_t corrupt_change = 0;
    p->announces++;
    
    if (uploaded != p->uploaded) {
      uploaded_change = uploaded - p->uploaded;
      p->uploaded = uploaded;
    }
    if (downloaded != p->downloaded) {
      downloaded_change = downloaded - p->downloaded;
      p->downloaded = downloaded;
    }
    if (corrupt != p->corrupt) {
      corrupt_change = corrupt - p->corrupt;
      p->corrupt = corrupt;
      tor.balance -= corrupt_change;
      update_torrent = true;
    }
    peer_changed = peer_changed || uploaded_change || downloaded_change || corrupt_change;
    
    if (uploaded_change || downloaded_change) {
      tor.balance += uploaded_change;
      tor.balance -= downloaded_change;
      update_torrent = true;
      
      if (current_time > p->last_announced) {
        upspeed = uploaded_change / (current_time - p->last_announced);
        downspeed = downloaded_change / (current_time - p->last_announced);
      }
      std::set<int>::iterator sit = tor.tokened_users.find(userid);
      if (tor.free_torrent == NEUTRAL) {
        downloaded_change = 0;
        uploaded_change = 0;
      } else if (tor.free_torrent == FREE || sit != tor.tokened_users.end()) {
        if (sit != tor.tokened_users.end()) {
          expire_token = true;
          std::stringstream record;
          record << '(' << userid << ',' << tor.id << ',' << downloaded_change << ')';
          std::string record_str = record.str();
          db->record_token(record_str);
        }
        downloaded_change = 0;
      }
      
      if (uploaded_change || downloaded_change) {
        std::stringstream record;
        record << '(' << userid << ',' << uploaded_change << ',' << downloaded_change << ')';
        std::string record_str = record.str();
        db->record_user(record_str);
      }
    }
  }
  p->left = left;
  
  auto param_ip = params.find("ip");
  if (param_ip != params.end()) {
    ip = param_ip->second;
  } else if ((param_ip = params.find("ipv4")) != params.end()) {
    ip = param_ip->second;
  } else {
    auto head_itr = headers.find("x-forwarded-for");
    if (head_itr != headers.end()) {
      size_t ip_end_pos = head_itr->second.find(',');
      if (ip_end_pos != std::string::npos) {
        ip = head_itr->second.substr(0, ip_end_pos);
      } else {
        ip = head_itr->second;
      }
    }
  }
  
  unsigned int port = std::stol(params["port"]);
  // Generate compact ip/port string
  if (inserted || port != p->port || ip != p->ip) {
    p->port = port;
    p->ip = ip;
    p->ip_port = "";
    char x = 0;
    for (size_t pos = 0, end = ip.length(); pos < end; pos++) {
      if (ip[pos] == '.') {
        p->ip_port.push_back(x);
        x = 0;
        continue;
      } else if (!isdigit(ip[pos])) {
        invalid_ip = true;
        break;
      }
      x = x * 10 + ip[pos] - '0';
    }
    if (!invalid_ip) {
      p->ip_port.push_back(x);
      p->ip_port.push_back(port >> 8);
      p->ip_port.push_back(port & 0xFF);
    }
    if (p->ip_port.length() != 6) {
      p->ip_port.clear();
      invalid_ip = true;
    }
    p->invalid_ip = invalid_ip;
  } else {
    invalid_ip = p->invalid_ip;
  }
  
  // Update the peer
  p->last_announced = current_time;
  p->visible = peer_is_visible(u, p);
  
  // Add peer data to the database
  std::stringstream record;
  if (peer_changed) {
    record << '(' << userid << ',' << tor.id << ',' << active << ',' << uploaded << ',' << downloaded << ',' << upspeed << ',' << downspeed << ',' << left << ',' << corrupt << ',' << (current_time - p->first_announced) << ',' << p->announces << ',';
    std::string record_str = record.str();
    std::string record_ip;
    if (u->is_protected()) {
      record_ip = "";
    } else {
      record_ip = ip;
    }
    db->record_peer(record_str, record_ip, peer_id, headers["user_t-agent"]);
  } else {
    record << '(' << tor.id << ',' << (current_time - p->first_announced) << ',' << p->announces << ',';
    std::string record_str = record.str();
    db->record_peer(record_str, peer_id);
  }
  
  // Select peers!
  unsigned int numwant;
  auto param_numwant = params.find("numwant");
  if (param_numwant == params.end()) {
    numwant = 50;
  } else {
    numwant = std::min(50l, std::stol(param_numwant->second));
  }
  
  if (stopped_torrent) {
    numwant = 0;
    if (left > 0) {
      dec_l = true;
    } else {
      dec_s = true;
    }
  } else if (completed_torrent) {
    snatched = 1;
    update_torrent = true;
    tor.completed++;
    
    std::stringstream record;
    std::string record_ip;
    if (u->is_protected()) {
      record_ip = "";
    } else {
      record_ip = ip;
    }
    record << '(' << userid << ',' << tor.id << ',' << current_time;
    std::string record_str = record.str();
    db->record_snatch(record_str, record_ip);
    
    // User is a seeder now!
    if (!inserted) {
      std::pair<peer_list::iterator, bool> insert
      = tor.seeders.insert(std::pair<std::string, peer>(peer_id, *p));
      tor.leechers.erase(peer_it);
      peer_it = insert.first;
      p = &peer_it->second;
      dec_l = inc_s = true;
    }
    if (expire_token) {
      site_communicator->expire_token(tor.id, userid);
      tor.tokened_users.erase(userid);
    }
  } else if (!u->can_leech() && left > 0) {
    numwant = 0;
  }
  
  std::string peers;
  if (numwant > 0) {
    peers.reserve(numwant*6);
    unsigned int found_peers = 0;
    if (left > 0) { // Show seeders to leechers first
      if (tor.seeders.size() > 0) {
        // We do this complicated stuff to cycle through the seeder list, so all seeders will get shown to leechers
        
        // Find out where to begin in the seeder list
        peer_list::const_iterator i;
        if (tor.last_selected_seeder == "") {
          i = tor.seeders.begin();
        } else {
          i = tor.seeders.find(tor.last_selected_seeder);
          if (i == tor.seeders.end() || ++i == tor.seeders.end()) {
            i = tor.seeders.begin();
          }
        }
        
        // Find out where to end in the seeder list
        peer_list::const_iterator end;
        if (i == tor.seeders.begin()) {
          end = tor.seeders.end();
        } else {
          end = i;
          if (--end == tor.seeders.begin()) {
            ++end;
            ++i;
          }
        }
        
        // Add seeders
        while (i != end && found_peers < numwant) {
          if (i == tor.seeders.end()) {
            i = tor.seeders.begin();
          }
          // Don't show users themselves
          if (i->second.user->get_id() == userid || !i->second.visible) {
            ++i;
            continue;
          }
          peers.append(i->second.ip_port);
          found_peers++;
          tor.last_selected_seeder = i->first;
          ++i;
        }
      }
      
      if (found_peers < numwant && tor.leechers.size() > 1) {
        for (peer_list::const_iterator i = tor.leechers.begin(); i != tor.leechers.end() && found_peers < numwant; ++i) {
          // Don't show users themselves or leech disabled users
          if (i->second.ip_port == p->ip_port || i->second.user->get_id() == userid || !i->second.visible) {
            continue;
          }
          found_peers++;
          peers.append(i->second.ip_port);
        }
        
      }
    } else if (tor.leechers.size() > 0) { // User is a seeder, and we have leechers!
      for (peer_list::const_iterator i = tor.leechers.begin(); i != tor.leechers.end() && found_peers < numwant; ++i) {
        // Don't show users themselves or leech disabled users
        if (i->second.user->get_id() == userid || !i->second.visible) {
          continue;
        }
        found_peers++;
        peers.append(i->second.ip_port);
      }
    }
  }
  
  // Update the stats
  stats.succ_announcements++;
  if (dec_l || dec_s || inc_l || inc_s) {
    if (inc_l) {
      p->user->incr_leeching();
      stats.leechers++;
    }
    if (inc_s) {
      p->user->incr_seeding();
      stats.seeders++;
    }
    if (dec_l) {
      p->user->decr_leeching();
      stats.leechers--;
    }
    if (dec_s) {
      p->user->decr_seeding();
      stats.seeders--;
    }
  }
  
  // Correct the stats for the old user_t if the peer's user_t link has changed
  if (p->user != u) {
    if (!stopped_torrent) {
      if (left > 0) {
        u->incr_leeching();
        p->user->decr_leeching();
      } else {
        u->incr_seeding();
        p->user->decr_seeding();
      }
    }
    p->user = u;
  }
  
  // Delete peers as late as possible to prevent access problems
  if (stopped_torrent) {
    if (left > 0) {
      tor.leechers.erase(peer_it);
    } else {
      tor.seeders.erase(peer_it);
    }
  }
  
  // Putting this after the peer deletion gives us accurate swarm sizes
  if (update_torrent || tor.last_flushed + 3600 < current_time) {
    tor.last_flushed = current_time;
    
    std::stringstream record;
    record << '(' << tor.id << ',' << tor.seeders.size() << ',' << tor.leechers.size() << ',' << snatched << ',' << tor.balance << ')';
    std::string record_str = record.str();
    db->record_torrent(record_str);
  }
  
  if (!u->can_leech() && left > 0) {
    return error("Access denied, leeching forbidden");
  }
  
  auto global_config = config::get_instance();
  
  std::string output = "d8:completei";
  output.reserve(350);
  output += std::to_string(tor.seeders.size());
  output += "e10:downloadedi";
  output += std::to_string(tor.completed);
  output += "e10:incompletei";
  output += std::to_string(tor.leechers.size());
  output += "e8:intervali";
  output += std::to_string(global_config->announce_interval+std::min((size_t)600, tor.seeders.size())); // ensure a more even distribution of announces/second
  output += "e12:min intervali";
  output += std::to_string(global_config->announce_interval);
  output += "e5:peers";
  if (peers.length() == 0) {
    output += "0:";
  } else {
    output += std::to_string(peers.length());
    output += ":";
    output += peers;
  }
  if (invalid_ip) {
    output += warning("Illegal character found in IP address. IPv6 is not supported");
  }
  output += 'e';
  
  /* gzip compression actually makes announce returns larger from our
   * testing. Feel free to enable this here if you'd like but be aware of
   * possibly inflated return size
   */
  /*if (headers["accept-encoding"].find("gzip") != std::string::npos) {
   gzip = true;
   }*/
  return response(output, gzip, false);
}