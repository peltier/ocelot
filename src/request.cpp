#include "request.h"

//
// Get the request action based on the m_input request string
//
action_t Request::get_action() {
  // Check action cache
  if(m_action_cache_saved) {
    return m_action_cache;
  }

  // This is the beginning index for action
  int position = 38;
  
  // Switch on the action by the first char
  switch ( m_input[position] ) {
    case 'a':
      stats.announcements++;
      m_action_cache = ANNOUNCE;
      break;
    case 's':
      stats.scrapes++;
      m_action_cache = SCRAPE;
      break;
    case 'u':
      m_action_cache = UPDATE;
      break;
    case 'r':
      m_action_cache = REPORT;
      break;
    default:
      m_action_cache = INVALID;
      break;
  }
  
  // Set Cache
  m_action_cache_saved = true;
  
  return m_action_cache;
}


//
// Get the pass key from request string
//
std::string Request::get_passkey() {
  // Check passkey cache
  if( !m_pass_key_cache.empty() ) {
    return m_pass_key_cache;
  }

  // Get the passkey
  m_pass_key_cache.reserve(32);
  if (m_input[37] != '/') {
    return "";
  }
  
  for (size_t pos = 5; pos < 37; pos++) {
    m_pass_key_cache.push_back(m_input[pos]);
  }
  
  return m_pass_key_cache;
}

//
// Get all the request params from a request string
//
params_map_t Request::get_params() {
  // Check params cache
  if( !m_params_cache.empty() ) {
    return m_params_cache;
  }
  
  // Get the beginning of the params list
  auto index = m_input.find('?');
  
  // Check for lack of params
  if( index == std::string::npos ) {
    return m_params_cache;
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
    m_params_cache[ key_buffer ] = value_buffer;
  }
  
  return m_params_cache;
}

// Extracted from worker::worker. Not changed
params_map_t Request::get_headers() {
  // Check headers cache
  if( !m_headers_cache.empty() ) {
    return m_headers_cache;
  }
  
  auto pos = m_input.find( "HTTP/1.1" );
  
  // Offet by 9 for `HTTP/1.1 `. Note the space at the end.
  pos += 9;
  
  // Parse headers
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
        m_headers_cache[key] = value;
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
  
  return m_headers_cache;
}

std::vector<std::string> Request::get_info_hashes() {
  // Check headers cache
  if( !m_info_hash_cache.empty() ) {
    return m_info_hash_cache;
  }

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
    m_info_hash_cache.push_back( info_hash_buffer );
    // Increment
    position = value_index;
  }
  
  return m_info_hash_cache;
}