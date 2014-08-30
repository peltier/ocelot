#ifndef OCELOT_SITE_COMM_H
#define OCELOT_SITE_COMM_H

#include <iostream>
#include <istream>
#include <ostream>
#include <string>
#include <boost/asio.hpp>
#include <queue>
#include <mutex>

#include "config.h"

using boost::asio::ip::tcp;

class site_comm {
  public:
    site_comm();
    ~site_comm();
  
    static site_comm * get_instance() {
      if( !m_site_comm_instance ) {
        m_site_comm_instance = new site_comm();
      }
      
      return m_site_comm_instance;
    }

    bool verbose_flush;
    bool all_clear();
    void expire_token(int torrent, int user);
    void flush_tokens();
    void do_flush_tokens();

  private:
    static site_comm * m_site_comm_instance;
  
    config * m_conf;
    std::mutex m_expire_queue_lock;
    std::string m_expire_token_buffer;
    std::queue<std::string> m_token_queue;
    bool m_t_active;
};

#endif
