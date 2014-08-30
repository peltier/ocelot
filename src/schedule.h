#ifndef OCELOT_SCHEDULE_H
#define OCELOT_SCHEDULE_H

#include <ev++.h>
#include <string>
#include <iostream>

class schedule {
  public:
    schedule(worker * worker_obj);
    void handle(ev::timer &watcher, int events_flags);

  private:
    worker * m_worker;
    config * m_conf;
    mysql * m_db;
    site_comm * m_site_comm;
    uint64_t m_last_opened_connections;
    int m_counter;

    time_t m_next_reap_peers;
};

#endif