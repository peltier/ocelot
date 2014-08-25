#ifndef __ocelot__scrape_controller__
#define __ocelot__scrape_controller__

#include "misc_functions.h"
#include "request.h"
#include "response.h"
#include "cache.h"

class ScrapeController {
  public:
    ScrapeController(const Request &request) : m_request(request) {}
    
    static std::string on_request(const Request &request) {
      return ScrapeController( request ).get_response();
    }
    
    std::string get_response();
  
  private:
    Request m_request;
  
};

#endif /* defined(__ocelot__scrape_controller__) */
