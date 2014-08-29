#include <sstream>

#include "report_controller.h"
#include "config.h"

std::string style_sheet() {
  std::string styles;
  
  styles += "<style>";
  styles += "table { border: 1px solid #666; border-collapse: collapse; }";
  styles += "table th { border: 1px solid #666; padding: 4px; background-color: #dedede; }";
  styles += "table td { border: 1px solid #666; padding: 4px; }";
  styles += "</style>";
  
  return styles;
}

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
  
  output << "<h3>Tracker Stats</h3>";
  
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
    
    output
    
    << "<table>"
    
    << "<tr>"
    << "<th><b>Stat</b></th>"
    << "<th><b>Value</b></th>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Uptime" << "</td>"
    << "<td>" << up_d << " days, " << up_ht << ':' << up_mt << ':' << up_st << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Connections Opened" << "</td>"
    << "<td>" << stats.opened_connections << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Open Connection" << "</td>"
    << "<td>" << stats.open_connections << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Connections/s" << "</td>"
    << "<td>" << stats.connection_rate << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Successful Announcements" << "</td>"
    << "<td>" << stats.succ_announcements << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Failed Announcements" << "</td>"
    << "<td>" << (stats.announcements - stats.succ_announcements) << "</td>"
    << "</tr>"

    << "<tr>"
    << "<td>" << "Scrapes" << "</td>"
    << "<td>" << stats.scrapes << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Leechers Tracked" << "</td>"
    << "<td>" << stats.leechers << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Seeders Tracked" << "</td>"
    << "<td>" << stats.seeders << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Bytes Read" << "</td>"
    << "<td>" << stats.bytes_read << "</td>"
    << "</tr>"
    
    << "<tr>"
    << "<td>" << "Bytes Written" << "</td>"
    << "<td>" << stats.bytes_written << "</td>"
    << "</tr>"
    
    << "</table>"
    
    << style_sheet();
    
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
  return html( output.str() );
  
}