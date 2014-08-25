#include <sstream>

#include "report_controller.h"
#include "config.h"

std::string ReportController::before__authenticate() {
  if( m_request.get_passkey() != config().report_password ) {
    return error("Authentication failure");
  }
  
  return "";
}

std::string ReportController::get_response() {

  // Authenticate
  auto auth_error = before__authenticate();
  if( !auth_error.empty() ) return auth_error;
  
  //
  // Fix params until we can refactor the body
  //
  
  auto params = m_request.get_params();
  
  
  std::stringstream output;
  std::string action = params["get"];
  if (action == "") {
    output << "Invalid action\n";
  } else if (action == "stats") {
    time_t uptime = time(NULL) - stats.start_time;
    int up_d = uptime / 86400;
    uptime -= up_d * 86400;
    int up_h = uptime / 3600;
    uptime -= up_h * 3600;
    int up_m = uptime / 60;
    int up_s = uptime - up_m * 60;
    std::string up_ht = up_h <= 9 ? '0' + std::to_string(up_h) : std::to_string(up_h);
    std::string up_mt = up_m <= 9 ? '0' + std::to_string(up_m) : std::to_string(up_m);
    std::string up_st = up_s <= 9 ? '0' + std::to_string(up_s) : std::to_string(up_s);
    
    output << "Uptime: " << up_d << " days, " << up_ht << ':' << up_mt << ':' << up_st << '\n'
    << stats.opened_connections << " connections opened\n"
    << stats.open_connections << " open connections\n"
    << stats.connection_rate << " connections/s\n"
    << stats.succ_announcements << " successful announcements\n"
    << (stats.announcements - stats.succ_announcements) << " failed announcements\n"
    << stats.scrapes << " scrapes\n"
    << stats.leechers << " leechers tracked\n"
    << stats.seeders << " seeders tracked\n"
    << stats.bytes_read << " bytes read\n"
    << stats.bytes_written << " bytes written\n";
  } else if (action == "user") {
    std::string key = params["key"];
    if (key == "") {
      output << "Invalid action\n";
    } else {
      auto users_vec = UserListCache::find( m_request.get_passkey() );
      if ( !users_vec.empty() ) {
        auto user = users_vec.front();
      
        output << user->get_leeching() << " leeching\n"
        << user->get_seeding() << " seeding\n";
      }
    }
  } else {
    output << "Invalid action\n";
  }
  output << "success";
  return response(output.str(), false, false);
  
}