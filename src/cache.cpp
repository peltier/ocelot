#include "cache.h"

// Deletion Cache
std::unordered_map<std::string, deletion_message_t>  DeletionReasonsCache::m_deletion_reasons;
std::mutex DeletionReasonsCache::m_deletion_reasons_mutex;

// Whitelist Cache
std::vector<std::string> WhitelistCache::m_whitelist;
std::mutex WhitelistCache::m_whitelist_mutex;


// User Cache
user_list UserListCache::m_user_list;
std::mutex UserListCache::m_user_list_mutex;

// Torrent List Cache
torrent_list TorrentListCache::m_torrent_list;
std::mutex TorrentListCache::m_torrent_list_mutex;

