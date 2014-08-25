//
//  cache.cpp
//  ocelot
//
//  Created by Garrett Thornburg on 8/24/14.
//
//

#include "cache.h"

// Deletion Cache
std::unordered_map<std::string, del_message>  DeletionReasonsCache::m_deletion_reasons;
std::mutex DeletionReasonsCache::m_deletion_reasons_mutex;

// Whitelist Cache
std::vector<std::string> WhitelistCache::m_whitelist;

// User Cache
user_list UserListCache::m_user_list;
std::mutex UserListCache::m_user_list_mutex;

// Torrent List Cache
torrent_list TorrentListCache::m_torrent_list;
std::mutex TorrentListCache::m_torrent_list_mutex;

