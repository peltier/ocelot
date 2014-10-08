#include "update_controller.h"
#include "logger.h"
#include "worker.h"
#include "cache.h"

std::string UpdateController::before__authenticate() {
  if ( m_request.get_passkey() != m_config->site_password ) {
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

  // Spliced from the old worker class
  
  if (params["action"] == "change_passkey") {
  
    return change_passkey();
    
  } else if (params["action"] == "add_torrent") {
    
    return add_torrent();
    
  } else if (params["action"] == "update_torrent") {
    
    return update_torrent();
    
  } else if (params["action"] == "update_torrents") {

    return update_torrents();

  } else if (params["action"] == "add_token") {
    
    return add_token();
    
  } else if (params["action"] == "remove_token") {
    
    return remove_token();
    
  } else if (params["action"] == "delete_torrent") {
    
    return delete_torrent();
    
  } else if (params["action"] == "add_user") {
    
    return add_user();
    
  } else if (params["action"] == "remove_user") {
    
    return remove_user();
    
  } else if (params["action"] == "remove_users") {

    return remove_users();

  } else if (params["action"] == "update_user") {
    
    return update_user();
    
  } else if (params["action"] == "add_whitelist") {

    return add_whitelist();

  } else if (params["action"] == "remove_whitelist") {

    return remove_whitelist();

  } else if (params["action"] == "edit_whitelist") {

    return edit_whitelist();

  } else if (params["action"] == "update_announce_interval") {
    
    return update_announce_interval();
    
  } else if (params["action"] == "info_torrent") {
    
    return torrent_info();
    
  }
  
  return response("success", false, false);
  
}

std::string UpdateController::change_passkey() {
  
  auto params = m_request.get_params();

  if( params.count("oldpasskey") <= 0 ||
      params.count("newpasskey") <= 0) {

    return error("Invalid parameters");
  }
  
  std::string old_passkey = params["oldpasskey"];
  std::string new_passkey = params["newpasskey"];

  auto user_vec = UserListCache::find( old_passkey );
  if ( user_vec.empty() ) {
    auto error_message = "No user_t with passkey " + old_passkey + " exists when attempting to change passkey to " + new_passkey;

    // Return error, we're done
    Logger::error( error_message );
    return error( error_message );

  } else {
    auto user = user_vec.front();

    UserListCache::insert( new_passkey, user );
    UserListCache::remove( old_passkey );

    auto response = "Changed passkey from " + old_passkey + " to " + new_passkey + " for user_t " + std::to_string( user->get_id() );

    // Success
    Logger::info( response );
    return response;
  }
}

std::string UpdateController::add_torrent() {
  
  auto params = m_request.get_params();

  torrent_t t;
  bool save_new_torrent = false;
  std::string info_hash = params["info_hash"];
  info_hash = hex_decode(info_hash);
  auto torrent_vec = TorrentListCache::find(info_hash);
  
  if ( torrent_vec.empty() ) {
    t.id = std::stol(params["id"]);
    t.balance = 0;
    t.completed = 0;
    t.last_selected_seeder = "";
    save_new_torrent = true;
  } else {
    t = torrent_vec.front();
  }
  
  if (params["freetorrent"] == "0") {
    t.free_torrent = NORMAL;
  } else if (params["freetorrent"] == "1") {
    t.free_torrent = FREE;
  } else {
    t.free_torrent = NEUTRAL;
  }
  
  if( save_new_torrent ) {
    TorrentListCache::insert( info_hash, t );
  }
  
  auto success_message = "Added torrent " + std::to_string(t.id) + ". FL: " + std::to_string(t.free_torrent) + " " + params["freetorrent"];
  
  Logger::info( success_message );
  
  return success_message;
}

std::string UpdateController::update_torrent() {

  auto params = m_request.get_params();

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

  auto torrent_vec = TorrentListCache::find(info_hash);

  if ( !torrent_vec.empty() ) {
    auto torrent = torrent_vec.front();

    torrent.free_torrent = fl;

    TorrentListCache::insert( info_hash , torrent );

    auto response = "Updated torrent " + std::to_string(torrent.id) + " to FL " + std::to_string(fl);

    Logger::info(response);
    return response;

  } else {
    auto response = "Failed to find torrent " + info_hash + " to FL " + std::to_string(fl);

    Logger::error(response);
    return error(response);
  }
}

std::string UpdateController::update_torrents() {
  
  auto params = m_request.get_params();

  // Each decoded infohash is exactly 20 characters long.
  std::string info_hashes = params["info_hashes"];
  info_hashes = hex_decode(info_hashes);
  freetype fl;
  if (params.count("freetorrent") > 0 && params["freetorrent"] == "0") {
    fl = NORMAL;
  } else if (params.count("freetorrent") > 0 && params["freetorrent"] == "1") {
    fl = FREE;
  } else {
    fl = NEUTRAL;
  }

  std::string response_combined = "";

  for (unsigned int pos = 0; pos < info_hashes.length(); pos += 20) {
    std::string info_hash = info_hashes.substr(pos, 20);
    auto torrent_vec = TorrentListCache::find(info_hash);
    if ( !torrent_vec.empty() ) {
      auto torrent = torrent_vec.front();
      torrent.free_torrent = fl;

      TorrentListCache::insert( info_hash , torrent );

      auto response = "Updated torrent " + std::to_string(torrent.id) + " to FL " + std::to_string(fl);

      response_combined += response;

      Logger::info(response);

    } else {
      auto response = "Failed to find torrent " + info_hash + " to FL " + std::to_string(fl);

      response_combined += response;

      Logger::error(response);
    }
  }

  return response_combined;
}

std::string UpdateController::delete_torrent() {
  
  auto params = m_request.get_params();
  auto ref_torrent_list = TorrentListCache::get();

  std::string info_hash = params["info_hash"];
  info_hash = hex_decode(info_hash);
  int reason = -1;
  auto reason_it = params.find("reason");
  if (reason_it != params.end()) {
    reason = std::stoi(params["reason"]);
  }
  
  auto torrent_it = ref_torrent_list.find(info_hash);
  if (torrent_it != ref_torrent_list.end()) {
    
    std::string response_message = "Deleting torrent " + std::to_string( torrent_it->second.id ) + " for the reason '" + get_deletion_reason(reason) + "'";
    Logger::info(response_message);
    
    stats.leechers -= torrent_it->second.leechers.size();
    stats.seeders -= torrent_it->second.seeders.size();

    for (auto p = torrent_it->second.leechers.begin(); p != torrent_it->second.leechers.end(); ++p) {
      p->second.user->decr_leeching();
    }
    for (auto p = torrent_it->second.seeders.begin(); p != torrent_it->second.seeders.end(); ++p) {
      p->second.user->decr_seeding();
    }

    deletion_message_t msg;
    msg.reason = reason;
    msg.time = time(NULL);
    
    DeletionReasonsCache::insert( info_hash, msg );
    
    TorrentListCache::remove( torrent_it->first, torrent_it->second );
    
    // Return response
    return response(response_message, false, false);
    
  } else {
  
    std::string response_message = "Failed to find torrent " + bintohex(info_hash) + " to delete";
    
    Logger::error(response_message);
    
    return error(response_message);
  }
}

std::string UpdateController::add_token() {

  auto params = m_request.get_params();

  std::string info_hash = hex_decode(params["info_hash"]);

  // TODO: I'm leaving atoi in most errors it returns 0 #hack
  int user_id = atoi(params["userid"].c_str());

  auto torrent_vec = TorrentListCache::find( info_hash );

  if( !torrent_vec.empty() ) {
    auto torrent = torrent_vec.front();

    // TODO: Thread safety concern?
    torrent.tokened_users.insert(user_id);

    TorrentListCache::insert( info_hash, torrent );

    std::string response = "Added token " + std::to_string(user_id) + " to torrent " + info_hash;

    Logger::info( response );
    return response;

  } else {
    std::string response = "Failed to find torrent to add a token for user_t " + std::to_string(user_id);

    Logger::error( response );
    return error( response );
  }
}

std::string UpdateController::remove_token() {
  
  auto params = m_request.get_params();

  std::string info_hash = hex_decode(params["info_hash"]);
  int userid = atoi(params["userid"].c_str());
  auto torrent_vec = TorrentListCache::find( info_hash );

  if ( !torrent_vec.empty() ) {
    auto torrent = torrent_vec.front();
    torrent.tokened_users.erase(userid);

    TorrentListCache::insert( info_hash, torrent );

    std::string response = "Removed token " + std::to_string(userid) + " from torrent " + info_hash;

    Logger::info( response );
    return response;

  } else {
    std::string response = "Failed to find torrent " + info_hash + " to remove token for user_t " + std::to_string(userid);

    Logger::error( response );

    return error(response);
  }
}

std::string UpdateController::add_user() {

  auto params = m_request.get_params();

  std::string passkey = params["passkey"];
  unsigned int userid = std::stol(params["id"]);
  auto user_vec = UserListCache::find(passkey);
  if ( user_vec.empty() ) {
    bool protect_ip = params["visible"] == "0";
    user_ptr new_user(new User(userid, true, protect_ip));
    
    UserListCache::insert(passkey, new_user);
    
    auto success_message = "Added user_t " + passkey + " with id " + std::to_string(userid);
    
    Logger::info(success_message);
    return success_message;
    
  } else {
    auto error_message = "Tried to add already known user_t " + passkey + " with id " + std::to_string(userid);

    Logger::error(error_message);
    return error_message;
  }
}

std::string UpdateController::update_user() {

  auto params = m_request.get_params();

  std::string passkey = params["passkey"];
  bool can_leech = true;
  bool protect_ip = false;
  if (params["can_leech"] == "0") {
    can_leech = false;
  }
  if (params["visible"] == "0") {
    protect_ip = true;
  }

  auto user_vec = UserListCache::find(passkey);

  if ( user_vec.empty() ) {
    std::string response = "No user_t with passkey " + passkey + " found when attempting to change leeching m_status!";

    Logger::error( response );

    return error(response);

  } else {
    auto user = user_vec.front();

    user->set_protected(protect_ip);
    user->set_leechstatus(can_leech);

    // May not need this; even so, I'm leaving it for now
    UserListCache::insert( passkey , user );

    std::string response = "Updated user_t " + passkey;

    Logger::info( response );
    return response;
  }
}

std::string UpdateController::remove_user() {
  
  auto params = m_request.get_params();

  std::string passkey = params["passkey"];
  auto user_vec = UserListCache::find(passkey);
  if ( !user_vec.empty() ) {

    auto user = user_vec.front();

    UserListCache::remove( passkey );

    std::string response("Removed user_t " + passkey + " with id " + std::to_string(user->get_id()));

    Logger::info(response);
    return response;
  } else {

    std::string response("No such user_t for passkey " + passkey);
    Logger::error( response );

    return response;
  }
}

std::string UpdateController::remove_users() {

  auto params = m_request.get_params();

  std::string response;

  // Each passkey is exactly 32 characters long.
  std::string passkeys = params["passkeys"];


  for (unsigned int pos = 0; pos < passkeys.length(); pos += 32) {
    std::string passkey = passkeys.substr(pos, 32);

    auto user_vec = UserListCache::find( passkey );

    std::string response_partial;

    if( !user_vec.empty() ) {

      UserListCache::remove( passkey );

      response_partial = "Removed user_t " + passkey;

      Logger::info( response_partial );

      response += response_partial;

    } else {

      response_partial = "Could not find user_t " + passkey;

      Logger::error( response_partial );

      response += response_partial;

    }
  }

  return response;
}

std::string UpdateController::add_whitelist() {

  auto params = m_request.get_params();

  std::string peer_id = params["peer_id"];

  WhitelistCache::insert( peer_id );

  auto response = "Whitelisted " + peer_id;

  Logger::info( response );
  return response;
}

std::string UpdateController::edit_whitelist() {

  auto params = m_request.get_params();
  
  std::string new_peer_id = params["new_peer_id"];
  std::string old_peer_id = params["old_peer_id"];

  if( new_peer_id.empty() || old_peer_id.empty() ) {

    std::string response = "New and old peer ids cannot be blank";

    Logger::error( response );
    return error( response );
  }

  WhitelistCache::replace( old_peer_id , new_peer_id );

  std::string response = "Edited whitelist item from " + old_peer_id + " to " + new_peer_id;

  Logger::info(response);
  return response;
}

std::string UpdateController::remove_whitelist() {

  auto params = m_request.get_params();

  std::string peer_id = params["peer_id"];

  WhitelistCache::remove( peer_id );

  std::string response = "De-whitelisted " + peer_id;

  Logger::info( response );
  return response;
}

std::string UpdateController::update_announce_interval() {

  auto params = m_request.get_params();
  
  unsigned int interval = std::stol(params["new_announce_interval"]);

  m_config->announce_interval = interval;

  std::string response = "Edited announce interval to " + std::to_string( interval );

  Logger::info( response );
  return response;
}

std::string UpdateController::torrent_info() {

  auto params = m_request.get_params();

  std::string info_hash_hex = params["info_hash"];
  std::string info_hash = hex_decode(info_hash_hex);


  auto torrent_vec = TorrentListCache::find(info_hash);

  if( !torrent_vec.empty() ) {

    auto torrent = torrent_vec.front();

    std::string response = "Info for torrent '" + info_hash_hex + "'";
    response += "Torrent " + std::to_string( torrent.id );
    response += ", freetorrent = " + std::to_string( (int)torrent.free_torrent );

    Logger::info( response );
    return response;

  } else {
    std::string response = "Failed to find torrent " + info_hash_hex;

    Logger::error( response );
    return error(response);
  }
}
