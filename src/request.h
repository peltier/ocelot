#ifndef ocelot_request_h
#define ocelot_request_h

#include <algorithm>

#include "ocelot.h"

enum action_t {
  INVALID = 0, ANNOUNCE, SCRAPE, UPDATE, REPORT
};

class Request {
  public:
  
    //
    // Constructor
    //
    Request(std::string input, std::string ip_address)
      : m_input(input), m_ip_address(ip_address), m_action_cache_saved(false) {}
  
    std::string get_raw_request() const {
      return m_input;
    }
  
    std::string get_ip_address() const {
      return m_ip_address;
    }
  
    bool is_valid() const {
      // Anything less than 60 is too shore to care about
      return m_input.length() > 60;
    }
  
    //
    // Get the request action based on the m_input request string
    //
    action_t get_action();
    
    //
    // Get the pass key from request string
    //
    std::string get_passkey();
    
    //
    // Get all the request params from a request string
    //
    params_map_t get_params();
  
    params_map_t get_headers();
    
    std::vector<std::string> get_info_hashes();

  private:
    std::string m_input;
    std::string m_ip_address;
  
    // Cache Values
    bool m_action_cache_saved;
    action_t m_action_cache;
    std::string m_pass_key_cache;
    params_map_t m_params_cache;
    params_map_t m_headers_cache;
    std::vector< std::string > m_info_hash_cache;

};

#endif
