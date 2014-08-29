#include "user.h"

user::user(int uid, bool leech, bool protect)
  : m_id(uid), m_leechstatus(leech), m_protect_ip(protect)
{
  m_stats.leeching = 0;
  m_stats.seeding = 0;
}

// TODO: Let's find a way to not lock all the time, yeah?

int user::get_id() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_id;
}

bool user::is_protected() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_protect_ip;
}

void user::set_protected(bool status) {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_protect_ip = status;
}

bool user::can_leech() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_leechstatus;
}

void user::set_leechstatus(bool status) {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_leechstatus = status;
}

// m_Stats methods
unsigned int user::get_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_stats.leeching;
}

unsigned int user::get_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  return m_stats.seeding;
}

void user::decr_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.leeching--;
}

void user::decr_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.seeding--;
}

void user::incr_leeching() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.leeching++;
}

void user::incr_seeding() {
  std::lock_guard< std::mutex > lock(m_stats_mutex);
  m_stats.seeding++;
}
