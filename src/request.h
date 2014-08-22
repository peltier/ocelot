#ifndef ocelot_request_h
#define ocelot_request_h

#include "worker.h"

enum action_t {
  INVALID = 0, ANNOUNCE, SCRAPE, UPDATE, REPORT
};

class Request {
  public:
  
    //
    // Constructor
    //
    Request(std::string input, std::string ip_address)
      : m_input(input), m_ip_address(ip_address) {}
  
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
    action_t get_action() const {
      // Lock guard for stats.. yuk!
      std::lock_guard<std::mutex> lock(stats.mutex);
      
      // This is the beginning index for action
      int position = 38;
      
      // Switch on the action by the first char
      switch ( m_input[position] ) {
        case 'a':
          stats.announcements++;
          return ANNOUNCE;
        case 's':
          stats.scrapes++;
          return SCRAPE;
        case 'u':
          return UPDATE;
        case 'r':
          return REPORT;
        default:
          return INVALID;
      }
    }
    
    //
    // Get the pass key from request string
    //
    std::string get_pass_key() const {
      // Get the passkey
      std::string passkey;
      passkey.reserve(32);
      if (m_input[37] != '/') {
        return "";
      }
      
      for (size_t pos = 5; pos < 37; pos++) {
        passkey.push_back(m_input[pos]);
      }
      
      return passkey;
    }
    
    //
    // Get all the request params from a request string
    //
    params_map_t get_request_params() const {
      params_map_t request_params;
      
      // Get the beginning of the params list
      auto index = m_input.find('?');
      
      // Check for lack of params
      if( index == std::string::npos ) {
        return request_params;
      }
      
      // Valid, so we'll advance the index passed `?`
      ++index;
      
      // Go until the params list is done. Assumes no spaces in param list.
      while( m_input.at(index) != ' ' ) {
        
        // Find the key
        std::string key_buffer;
        for(; index < m_input.length(); ++index) {
          auto value_at_index = m_input.at(index);
          
          if(value_at_index == '=') {
            // Found terminator
            ++index;
            break;
          } else {
            // Adding to buffer
            key_buffer.push_back( value_at_index );
          }
        }
        
        // Find the value
        std::string value_buffer;
        for(; index < m_input.length(); ++index) {
          auto value_at_index = m_input.at(index);
          
          if(value_at_index == '&') {
            // Found `&` so we advance the index
            ++index;
            break;
          } else if(value_at_index == ' ') {
            // Param terminator found
            break;
          } else {
            // Adding to buffer
            value_buffer.push_back( value_at_index );
          }
        }
        
        // Save the key / value pair
        request_params[ key_buffer ] = value_buffer;
      }
      
      return request_params;
    }
    
    // Extracted from worker::worker. Not changed
    params_map_t get_request_headers() const {
      
      auto pos = m_input.find( "HTTP/1.1" );
      
      // Offet by 9 for `HTTP/1.1 `. Note the space at the end.
      pos += 9;
      
      // Parse headers
      params_map_t headers;
      bool parsing_key = true;
      bool found_data = false;
      std::string key;
      std::string value;
      
      for (; pos < m_input.length(); ++pos) {
        if (m_input[pos] == ':') {
          parsing_key = false;
          ++pos; // skip space after :
        } else if (m_input[pos] == '\n' || m_input[pos] == '\r') {
          parsing_key = true;
          
          if (found_data) {
            found_data = false; // dodge for getting around \r\n or just \n
            std::transform(key.begin(), key.end(), key.begin(), ::tolower);
            headers[key] = value;
            key.clear();
            value.clear();
          }
        } else {
          found_data = true;
          if (parsing_key) {
            key.push_back(m_input[pos]);
          } else {
            value.push_back(m_input[pos]);
          }
        }
      }
      
      return headers;
    }
    
    std::vector<std::string> get_info_hashes() const {
      std::vector<std::string> info_hashes;
      size_t position = 0;
      
      // This is assuming you can have multiple info_hashes in one SCRAP request
      while( position < m_input.length() ) {
        
        // Find the key index
        auto index_start = m_input.find("info_hash", position);
        
        // Break if we've found all the info_hash hashes
        if( index_start > m_input.size() ) {
          break;
        }
        
        // Icrement passed `info_hash=`
        // TODO: Do we need to worry about a space landing between key and value?
        auto value_index = index_start + 10;
        
        // Get the info_hash value
        std::string info_hash_buffer;
        for(; value_index < m_input.length(); ++value_index) {
          auto value_at_index = m_input.at(value_index);
          // Check for end of value
          if( value_at_index == '&' || value_at_index == ' ' ) {
            break;
          } else {
            info_hash_buffer.push_back( value_at_index );
          }
        }
        
        // Save the info_hash value
        info_hashes.push_back( info_hash_buffer );
        // Increment
        position = value_index;
      }
      
      return info_hashes;
    }
  
  private:
    std::string m_input;
    std::string m_ip_address;
};

#endif
