#include "user.h"

user::user(int uid, bool leech, bool protect)
  : m_id(uid), m_leechstatus(leech), m_protect_ip(protect)
{
  m_stats.leeching = 0;
  m_stats.seeding = 0;
}

int user::get_id() {
  return m_id;
}

bool user::is_protected() {
  return m_protect_ip;
}

void user::set_protected(bool status) {
  m_protect_ip = status;
}

bool user::can_leech() {
  return m_leechstatus;
}

void user::set_leechstatus(bool status) {
  m_leechstatus = status;
}

// m_Stats methods
unsigned int user::get_leeching() {
  return m_stats.leeching;
}

unsigned int user::get_seeding() {
  return m_stats.seeding;
}

void user::decr_leeching() {
  m_stats.leeching--;
}

void user::decr_seeding() {
  m_stats.seeding--;
}

void user::incr_leeching() {
  m_stats.leeching++;
}

void user::incr_seeding() {
  m_stats.seeding++;
}
