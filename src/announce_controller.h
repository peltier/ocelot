#ifndef __ocelot__announce_controller__
#define __ocelot__announce_controller__

#include "misc_functions.h"
#include "request.h"
#include "response.h"
#include "cache.h"

class AnnounceController {
  public:
    AnnounceController(const Request &request) : m_request(request) {}
    
    static std::string on_request(const Request &request) {
      return AnnounceController( request ).get_response();
    }
    
    std::string get_response();
    
  private:
    std::string before__validate_torrent();
  
    Request m_request;
  
};

#endif /* defined(__ocelot__announce_controller__) */
