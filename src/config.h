#ifndef OCELOT_CONFIG_H
#define OCELOT_CONFIG_H

#include <string>
#include <atomic>
#include <iostream>

class config {
  public:
    static config * get_instance() {
      if( !m_config_instance ) {
        m_config_instance = new config();
      }
      
      return m_config_instance;
    }
  
    config();
  
    ~config() { if(m_config_instance) delete m_config_instance; }
  
    // Anything that's required to be thread safe has been wrapped
    // in a std::atomic<>
    std::string host;
    std::atomic<unsigned int> port;
    std::atomic<unsigned int> max_connections;
    std::atomic<unsigned int> max_read_buffer;
    std::atomic<unsigned int> max_request_size;
    std::atomic<unsigned int> timeout_interval;
    std::atomic<unsigned int> schedule_interval;
    std::atomic<unsigned int> max_middlemen;

    std::atomic<unsigned int> announce_interval;
    std::atomic<unsigned int> peers_timeout;

    std::atomic<unsigned int> reap_peers_interval;
    std::atomic<unsigned int> del_reason_lifetime;

    // MySQL
    std::string mysql_db;
    std::string mysql_host;
    std::string mysql_username;
    std::string mysql_password;

    // Site Communication
    std::string site_host;
    std::string site_password;
    std::string site_path;

    std::string report_password;
  
  private:
    static config * m_config_instance;
};

#endif
