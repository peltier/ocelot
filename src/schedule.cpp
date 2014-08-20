#include "ocelot.h"
#include "config.h"
#include "db.h"
#include "worker.h"
#include "events.h"
#include "schedule.h"


schedule::schedule(worker* worker_obj, config* conf_obj, mysql * db_obj, site_comm * sc_obj)
  : m_worker(worker_obj), m_conf(conf_obj), m_db(db_obj), m_site_comm(sc_obj)
{
  m_counter = 0;
  m_last_opened_connections = 0;

  m_next_reap_peers = time(NULL) + m_conf->reap_peers_interval + 40;
}
//---------- Schedule - gets called every schedule_interval seconds
void schedule::handle(ev::timer &watcher, int events_flags) {
  stats.connection_rate = (stats.opened_connections - m_last_opened_connections) / m_conf->schedule_interval;
  if (m_counter % 20 == 0) {
    std::cout << "Schedule run #" << m_counter << " - open: " << stats.open_connections << ", opened: "
    << stats.opened_connections << ", speed: "
    << stats.connection_rate << "/s" << std::endl;
  }

  if (m_worker->get_status() == CLOSING && m_db->all_clear() && m_site_comm->all_clear()) {
    std::cout << "all clear, shutting down" << std::endl;
    exit(0);
  }

  m_last_opened_connections = stats.opened_connections;

  m_db->flush();
  m_site_comm->flush_tokens();

  time_t cur_time = time(NULL);

  if (cur_time > m_next_reap_peers) {
    m_worker->start_reaper();
    m_next_reap_peers = cur_time + m_conf->reap_peers_interval;
  }

  m_counter++;
}
