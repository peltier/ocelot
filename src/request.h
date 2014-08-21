#ifndef ocelot_request_h
#define ocelot_request_h

#include "worker.h"

namespace request {
  //
  // Get the request action based on the input request string
  //
  static action_t get_action(std::string &input) {
    // Lock guard for stats.. yuk!
    std::lock_guard<std::mutex> lock(stats.mutex);
    
    // This is the beginning index for action
    int position = 38;
    
    // Switch on the action by the first char
    switch ( input[position] ) {
      case 'a':
        stats.announcements++;
        position += 8;
        return ANNOUNCE;
      case 's':
        stats.scrapes++;
        position += 6;
        return SCRAPE;
      case 'u':
        position += 6;
        return UPDATE;
      case 'r':
        position += 6;
        return REPORT;
      default:
        return INVALID;
    }
  }
  
  //
  // Get the pass key from request string
  //
  static std::string get_pass_key(std::string &input) {
    // Get the passkey
    std::string passkey;
    passkey.reserve(32);
    if (input[37] != '/') {
      return "";
    }
    
    for (size_t pos = 5; pos < 37; pos++) {
      passkey.push_back(input[pos]);
    }
    
    return passkey;
  }
  
  //
  // Get all the request params from a request string
  //
  static params_map_t get_request_params(std::string &input) {
    params_map_t request_params;
    
    // Get the beginning of the params list
    auto index = input.find('?');
    
    // Check for lack of params
    if( index == std::string::npos ) {
      return request_params;
    }
    
    // Valid, so we'll advance the index passed `?`
    ++index;
    
    // Go until the params list is done. Assumes no spaces in param list.
    while( input.at(index) != ' ' ) {
      
      // Find the key
      std::string key_buffer;
      for(; index < input.length(); ++index) {
        auto value_at_index = input.at(index);
        
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
      for(; index < input.length(); ++index) {
        auto value_at_index = input.at(index);
        
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
  static params_map_t get_request_headers(std::string &input) {
    
    auto pos = input.find( "HTTP/1.1" );
    
    // Offet by 9 for `HTTP/1.1 `. Note the space at the end.
    pos += 9;
    
    // Parse headers
    params_map_t headers;
    bool parsing_key = true;
    bool found_data = false;
    std::string key;
    std::string value;
    
    for (; pos < input.length(); ++pos) {
      if (input[pos] == ':') {
        parsing_key = false;
        ++pos; // skip space after :
      } else if (input[pos] == '\n' || input[pos] == '\r') {
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
          key.push_back(input[pos]);
        } else {
          value.push_back(input[pos]);
        }
      }
    }
    
    return headers;
  }
  
  static std::vector<std::string> get_info_hashes(std::string &input) {
    std::vector<std::string> info_hashes;
    int position = 0;
    
    // This is assuming you can have multiple info_hashes in one SCRAP request
    while( position < input.size() ) {
      
      // Find the key index
      auto index_start = input.find("info_hash", position);
      
      // Icrement passed `info_hash=`
      // TODO: Do we need to worry about a space landing between key and value?
      auto value_index = index_start + 10;
      
      // Get the info_hash value
      std::string info_hash_buffer;
      for(; value_index < input.length(); ++value_index) {
        auto value_at_index = input.at(value_index);
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
}

#endif
