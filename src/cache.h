#ifndef __ocelot__cache__
#define __ocelot__cache__

#include <mutex>
#include <vector>

#include "ocelot.h"
#include "user.h"

//
// Deletion Cache
//
class DeletionReasonsCache {
  public:
    static std::vector<del_message> find(std::string decoded_info_hash) {
      std::lock_guard< std::mutex > lock( m_deletion_reasons_mutex );
      std::vector<del_message> result_set;
      
      if( m_deletion_reasons.count( decoded_info_hash ) > 0 ) {
        result_set.push_back( m_deletion_reasons[decoded_info_hash] );
      }
      
      return result_set;
    }
  
    static std::unordered_map<std::string, del_message> & get() {
      return m_deletion_reasons;
    }
    
    static void set( std::unordered_map<std::string, del_message> & delete_map ) {
      m_deletion_reasons = delete_map;
    }
  private:
    static std::unordered_map<std::string, del_message> m_deletion_reasons;
    static std::mutex m_deletion_reasons_mutex;
};


//
// Whitelist Cache
//
class WhitelistCache {
  public:
    static std::vector<std::string> & get() {
      return m_whitelist;
    }
    
    static void set( std::vector<std::string> & w_list ) {
      m_whitelist = w_list;
    }
  private:
    static std::vector<std::string> m_whitelist;
};


//
// User Cache
//
class UserListCache {
  public:
    static std::vector<user_ptr> find(std::string passcode) {
      std::lock_guard< std::mutex > lock( m_user_list_mutex );
      std::vector<user_ptr> result_set;
      
      if( m_user_list.count( passcode ) > 0 ) {
        result_set.push_back( m_user_list[passcode] );
      }
      
      return result_set;
    }
    
    static user_list & get() {
      return m_user_list;
    }
    
    static void set( user_list & u_list ) {
      m_user_list = u_list;
    }
  private:
    static user_list m_user_list;
    static std::mutex m_user_list_mutex;
};


//
// Torrent Cache
//
class TorrentListCache {
  public:
    static std::vector<torrent> find(std::string decoded_info_hash) {
      std::lock_guard< std::mutex > lock( m_torrent_list_mutex );
      std::vector<torrent> result_set;
      
      if( m_torrent_list.count( decoded_info_hash ) > 0 ) {
        result_set.push_back( m_torrent_list[decoded_info_hash] );
      }
      
      return result_set;
    }
  
    static torrent_list & get() {
      return m_torrent_list;
    }
  
    static void set( torrent_list & t_list ) {
      m_torrent_list = t_list;
    }
  private:
    static torrent_list m_torrent_list;
    static std::mutex m_torrent_list_mutex;
};

#endif /* defined(__ocelot__cache__) */
