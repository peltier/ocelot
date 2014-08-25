#ifndef __ocelot__update_controller__
#define __ocelot__update_controller__

#include "misc_functions.h"
#include "request.h"
#include "response.h"
#include "cache.h"

class UpdateController {
  public:
    UpdateController(const Request &request) : m_request(request) {}
    
    static std::string on_request(const Request &request) {
      return UpdateController( request ).get_response();
    }
    
    std::string get_response();
    
  private:
    Request m_request;

};

#endif /* defined(__ocelot__update_controller__) */
