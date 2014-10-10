#ifndef __ocelot__update_controller__
#define __ocelot__update_controller__

#include "misc_functions.h"
#include "request.h"
#include "response.h"
#include "cache.h"
#include "config.h"

class UpdateController {
  public:
    UpdateController(const Request &request)
      : m_request(request), m_config( config::get_instance() ) {}
    
    static std::string on_request(const Request &request) {
      return UpdateController( request ).get_response();
    }
    
    std::string get_response();
    
  private:
    Request m_request;
  
    config * m_config;
  
    std::string before__authenticate();
  
    std::string change_passkey();
    std::string add_torrent();
    std::string update_torrent();
    std::string update_torrents();
    std::string delete_torrent();
    std::string add_token();
    std::string remove_token();
    std::string add_user();
    std::string update_user();
    std::string remove_user();
    std::string remove_users();
    std::string add_whitelist();
    std::string edit_whitelist();
    std::string remove_whitelist();
    std::string update_announce_interval();
    std::string torrent_info();
};

#endif /* defined(__ocelot__update_controller__) */
