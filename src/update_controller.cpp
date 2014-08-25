#include "update_controller.h"
#include "logger.h"
#include "worker.h"

std::string UpdateController::before__authenticate() {
  if ( m_request.get_passkey() == config().site_password) {
    return error("Authentication failure");
  }
  
  return "";
}

//TODO: Restrict to local IPs
std::string UpdateController::get_response() {

  // Authenticate
  auto auth_error = before__authenticate();
  if( !auth_error.empty() ) return auth_error;


  auto params = m_request.get_params();
  
  auto ref_torrent_list = TorrentListCache::get();
  
  auto ref_user_list = UserListCache::get();
  
  auto ref_whitelist = WhitelistCache::get();
  
  auto ref_deletion_reason = DeletionReasonsCache::get();

  //
  // FROM WORKER UDATE METHOD
  //
  
  if (params["action"] == "change_passkey") {
    std::string oldpasskey = params["oldpasskey"];
    std::string newpasskey = params["newpasskey"];
    auto u = ref_user_list.find(oldpasskey);
    if (u == ref_user_list.end()) {
      std::cout << "No user with passkey " << oldpasskey << " exists when attempting to change passkey to " << newpasskey << std::endl;
    } else {
      UserListCache::get()[newpasskey] = u->second;
      ref_user_list.erase(oldpasskey);
      std::cout << "Changed passkey from " << oldpasskey << " to " << newpasskey << " for user " << u->second->get_id() << std::endl;
    }
  } else if (params["action"] == "add_torrent") {
    torrent *t;
    std::string info_hash = params["info_hash"];
    info_hash = hex_decode(info_hash);
    auto i = ref_torrent_list.find(info_hash);
    if (i == ref_torrent_list.end()) {
      t = &ref_torrent_list[info_hash];
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
    auto torrent_it = ref_torrent_list.find(info_hash);
    if (torrent_it != ref_torrent_list.end()) {
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
      auto torrent_it = ref_torrent_list.find(info_hash);
      if (torrent_it != ref_torrent_list.end()) {
        torrent_it->second.free_torrent = fl;
        std::cout << "Updated torrent " << torrent_it->second.id << " to FL " << fl << std::endl;
      } else {
        std::cout << "Failed to find torrent " << info_hash << " to FL " << fl << std::endl;
      }
    }
  } else if (params["action"] == "add_token") {
    std::string info_hash = hex_decode(params["info_hash"]);
    int userid = atoi(params["userid"].c_str());
    auto torrent_it = ref_torrent_list.find(info_hash);
    if (torrent_it != ref_torrent_list.end()) {
      torrent_it->second.tokened_users.insert(userid);
    } else {
      std::cout << "Failed to find torrent to add a token for user " << userid << std::endl;
    }
  } else if (params["action"] == "remove_token") {
    std::string info_hash = hex_decode(params["info_hash"]);
    int userid = atoi(params["userid"].c_str());
    auto torrent_it = ref_torrent_list.find(info_hash);
    if (torrent_it != ref_torrent_list.end()) {
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
    auto torrent_it = ref_torrent_list.find(info_hash);
    if (torrent_it != ref_torrent_list.end()) {
      std::cout << "Deleting torrent " << torrent_it->second.id << " for the reason '" << get_deletion_reason(reason) << "'" << std::endl;
      std::unique_lock<std::mutex> stats_lock(stats.mutex);
      stats.leechers -= torrent_it->second.leechers.size();
      stats.seeders -= torrent_it->second.seeders.size();
      stats_lock.unlock();
      std::unique_lock<std::mutex> us_lock(worker::m_ustats_lock);
      for (auto p = torrent_it->second.leechers.begin(); p != torrent_it->second.leechers.end(); ++p) {
        p->second.user->decr_leeching();
      }
      for (auto p = torrent_it->second.seeders.begin(); p != torrent_it->second.seeders.end(); ++p) {
        p->second.user->decr_seeding();
      }
      us_lock.unlock();
      std::unique_lock<std::mutex> dr_lock(worker::m_del_reasons_lock);
      del_message msg;
      msg.reason = reason;
      msg.time = time(NULL);
      ref_deletion_reason[info_hash] = msg;
      ref_torrent_list.erase(torrent_it);
    } else {
      std::cout << "Failed to find torrent " << bintohex(info_hash) << " to delete " << std::endl;
    }
  } else if (params["action"] == "add_user") {
    std::string passkey = params["passkey"];
    unsigned int userid = std::stol(params["id"]);
    auto u = ref_user_list.find(passkey);
    if (u == ref_user_list.end()) {
      bool protect_ip = params["visible"] == "0";
      user_ptr u(new user(userid, true, protect_ip));
      ref_user_list.insert(std::pair<std::string, user_ptr>(passkey, u));
      std::cout << "Added user " << passkey << " with id " << userid << std::endl;
    } else {
      std::cout << "Tried to add already known user " << passkey << " with id " << userid << std::endl;
    }
  } else if (params["action"] == "remove_user") {
    std::string passkey = params["passkey"];
    auto u = ref_user_list.find(passkey);
    if (u != ref_user_list.end()) {
      std::cout << "Removed user " << passkey << " with id " << u->second->get_id() << std::endl;
      ref_user_list.erase(u);
    }
  } else if (params["action"] == "remove_users") {
    // Each passkey is exactly 32 characters long.
    std::string passkeys = params["passkeys"];
    for (unsigned int pos = 0; pos < passkeys.length(); pos += 32) {
      std::string passkey = passkeys.substr(pos, 32);
      auto u = ref_user_list.find(passkey);
      if (u != ref_user_list.end()) {
        std::cout << "Removed user " << passkey << std::endl;
        ref_user_list.erase(passkey);
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
    user_list::iterator i = ref_user_list.find(passkey);
    if (i == ref_user_list.end()) {
      std::cout << "No user with passkey " << passkey << " found when attempting to change leeching m_status!" << std::endl;
    } else {
      i->second->set_protected(protect_ip);
      i->second->set_leechstatus(can_leech);
      std::cout << "Updated user " << passkey << std::endl;
    }
  } else if (params["action"] == "add_whitelist") {
    std::string peer_id = params["peer_id"];
    ref_whitelist.push_back(peer_id);
    std::cout << "Whitelisted " << peer_id << std::endl;
  } else if (params["action"] == "remove_whitelist") {
    std::string peer_id = params["peer_id"];
    for (unsigned int i = 0; i < ref_whitelist.size(); i++) {
      if (ref_whitelist[i].compare(peer_id) == 0) {
        ref_whitelist.erase(ref_whitelist.begin() + i);
        break;
      }
    }
    std::cout << "De-whitelisted " << peer_id << std::endl;
  } else if (params["action"] == "edit_whitelist") {
    std::string new_peer_id = params["new_peer_id"];
    std::string old_peer_id = params["old_peer_id"];
    for (unsigned int i = 0; i < ref_whitelist.size(); i++) {
      if (ref_whitelist[i].compare(old_peer_id) == 0) {
        ref_whitelist.erase(ref_whitelist.begin() + i);
        break;
      }
    }
    ref_whitelist.push_back(new_peer_id);
    std::cout << "Edited whitelist item from " << old_peer_id << " to " << new_peer_id << std::endl;
  } else if (params["action"] == "update_announce_interval") {
    unsigned int interval = std::stol(params["new_announce_interval"]);
    // TODO: ALLOW ANNOUNCE INTERVAL TO BE CHANGED
    std::cout << "FIX ANNOUNCE INTERVAL TO BE CHANGED" << std::endl;
//    m_conf->announce_interval = interval;
    std::cout << "Edited announce interval to " << interval << std::endl;
  } else if (params["action"] == "info_torrent") {
    std::string info_hash_hex = params["info_hash"];
    std::string info_hash = hex_decode(info_hash_hex);
    std::cout << "Info for torrent '" << info_hash_hex << "'" << std::endl;
    auto torrent_it = ref_torrent_list.find(info_hash);
    if (torrent_it != ref_torrent_list.end()) {
      std::cout << "Torrent " << torrent_it->second.id
      << ", freetorrent = " << torrent_it->second.free_torrent << std::endl;
    } else {
      std::cout << "Failed to find torrent " << info_hash_hex << std::endl;
    }
  }
  
  return response("success", false, false);
  
}