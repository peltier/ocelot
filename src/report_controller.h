#ifndef __ocelot__report_controller__
#define __ocelot__report_controller__

#include "misc_functions.h"
#include "request.h"
#include "response.h"
#include "cache.h"

class ReportController {
public:
  ReportController(const Request &request) : m_request(request) {}
  
  static std::string on_request(const Request &request) {
    return ReportController( request ).get_response();
  }
  
  std::string get_response();
  
private:
  Request m_request;
  
  std::string before__authenticate();
  
};


#endif /* defined(__ocelot__report_controller__) */
