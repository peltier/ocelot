#include "user.h"

User::User(int uid, bool leech, bool protect)
  : m_id(uid), m_leechstatus(leech), m_protect_ip(protect)
{
  m_stats.leeching = 0;
  m_stats.seeding = 0;
}

// TODO: Let's find a way to not lock all the time, yeah?

int User::get_id() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_id;
}

bool User::is_protected() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_protect_ip;
}

void User::set_protected(bool status) {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_protect_ip = status;
}

bool User::can_leech() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_leechstatus;
}

void User::set_leechstatus(bool status) {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_leechstatus = status;
}

// m_Stats methods
unsigned int User::get_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_stats.leeching;
}

unsigned int User::get_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_stats.seeding;
}

void User::decr_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.leeching--;
}

void User::decr_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.seeding--;
}

void User::incr_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.leeching++;
}

void User::incr_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.seeding++;
}
