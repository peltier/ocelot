#include <cerrno>
#include <mutex>

#include "ocelot.h"
#include "config.h"
#include "db.h"
#include "worker.h"
#include "events.h"
#include "schedule.h"
#include "response.h"
#include "logger.h"

// Define the connection mother (first half) and connection middlemen (second half)

//TODO Better errors

//---------- Connection mother - spawns middlemen and lets them deal with the connection

connection_mother::connection_mother(worker * worker_obj, config * config_obj, site_comm * sc_obj)
  : m_worker(worker_obj), m_conf(config_obj), m_site_comm(sc_obj)
{
  m_db = mysql::get_instance();

  memset(&m_address, 0, sizeof(m_address));
  m_address_length = sizeof(m_address);

  m_listen_socket = socket(AF_INET, SOCK_STREAM, 0);

  // Stop old sockets from hogging the port
  int yes = 1;
  if (setsockopt(m_listen_socket, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
    std::cout << "Could not reuse socket" << std::endl;
  }

  // Create libev event loop
  ev::io event_loop_watcher;

  event_loop_watcher.set<connection_mother, &connection_mother::handle_connect>(this);
  event_loop_watcher.start(m_listen_socket, ev::READ);

  // Get ready to bind
  m_address.sin_family = AF_INET;
  //m_address.sin_addr.s_addr = inet_addr(m_conf->host.c_str()); // htonl(INADDR_ANY)
  m_address.sin_addr.s_addr = htonl(INADDR_ANY);
  m_address.sin_port = htons(m_conf->port);

  // Bind
  if (bind(m_listen_socket, (sockaddr *) &m_address, sizeof(m_address)) == -1) {
    Logger::error("Bind failed " +  std::to_string( errno ) );
  }

  // Listen
  if (listen(m_listen_socket, m_conf->max_connections) == -1) {
    Logger::error("Listen failed");
  }

  // Set non-blocking
  int flags = fcntl(m_listen_socket, F_GETFL);
  if (flags == -1) {
    Logger::error("Could not get socket flags");
  }
  if (fcntl(m_listen_socket, F_SETFL, flags | O_NONBLOCK) == -1) {
    Logger::error("Could not set non-blocking");
  }

  // Create libev timer
  schedule timer(worker_obj, m_conf, m_db, m_site_comm);

  m_schedule_event.set<schedule, &schedule::handle>(&timer);
  m_schedule_event.set(m_conf->schedule_interval, m_conf->schedule_interval); // After interval, every interval
  m_schedule_event.start();

  Logger::info("Sockets up, starting event loop!");
  ev_loop(ev_default_loop(0), 0);
}


void connection_mother::handle_connect(ev::io &watcher, int events_flags) {
  // Spawn a new middleman
  if (stats.open_connections < m_conf->max_middlemen) {
    stats.opened_connections++;
    new connection_middleman(m_listen_socket, m_address, m_address_length, m_worker, m_conf);
  }
}

connection_mother::~connection_mother()
{
  close(m_listen_socket);
}







//---------- Connection middlemen - these little guys live until their connection is closed

connection_middleman::connection_middleman(int &m_listen_socket, sockaddr_in &m_address, socklen_t &m_address_length, worker * new_work, config * config_obj)
  : m_conf(config_obj), m_worker(new_work)
{
  m_socket_connection = accept(m_listen_socket, (sockaddr *) &m_address, &m_address_length);
  if (m_socket_connection == -1) {
    std::cout << "Accept failed, errno " << errno << ": " << strerror(errno) << std::endl;
    delete this;
    stats.open_connections++; // destructor decrements open connections
    return;
  }

  // Set non-blocking
  int flags = fcntl(m_socket_connection, F_GETFL);
  if (flags == -1) {
    std::cout << "Could not get connect socket flags" << std::endl;
  }
  if (fcntl(m_socket_connection, F_SETFL, flags | O_NONBLOCK) == -1) {
    std::cout << "Could not set non-blocking" << std::endl;
  }

  // Get their info
  if (getpeername(m_socket_connection, (sockaddr *) &m_client_address, &m_address_length) == -1) {
    //std::cout << "Could not get client info" << std::endl;
  }
  m_request.reserve(m_conf->max_read_buffer);
  m_written = 0;

  m_read_event.set<connection_middleman, &connection_middleman::handle_read>(this);
  m_read_event.start(m_socket_connection, ev::READ);

  // Let the socket timeout in timeout_interval seconds
  m_timeout_event.set<connection_middleman, &connection_middleman::handle_timeout>(this);
  m_timeout_event.set(m_conf->timeout_interval, 0);
  m_timeout_event.start();

  stats.open_connections++;
}

connection_middleman::~connection_middleman() {
  close(m_socket_connection);
  stats.open_connections--;
}

// Handler to read data from the socket, called by event loop when socket is readable
void connection_middleman::handle_read(ev::io &watcher, int events_flags) {

  char buffer[ m_conf->max_read_buffer + 1 ];

  memset(buffer, 0, m_conf->max_read_buffer + 1);
  int ret = recv(m_socket_connection, &buffer, m_conf->max_read_buffer, 0);

  if (ret <= 0) {
    delete this;
    return;
  }
  stats.bytes_read += ret;
  m_request.append(buffer, ret);
  size_t m_request_size = m_request.size();
  if (m_request_size > m_conf->max_request_size || (m_request_size >= 4 && m_request.compare(m_request_size - 4, std::string::npos, "\r\n\r\n") == 0)) {
    m_read_event.stop();

    if (m_request_size > m_conf->max_request_size) {
      shutdown(m_socket_connection, SHUT_RD);
      m_response = error("GET string too long");
    } else {
      char ip[INET_ADDRSTRLEN];
      inet_ntop(AF_INET, &(m_client_address.sin_addr), ip, INET_ADDRSTRLEN);
      std::string ip_str = ip;
      
      
      BENCHMARK( m_response = m_worker->on_request( Request(m_request, ip_str) ) );

    }

    // Find out when the socket is writeable.
    // The loop in connection_mother will call handle_write when it is.
    m_write_event.set<connection_middleman, &connection_middleman::handle_write>(this);
    m_write_event.start(m_socket_connection, ev::WRITE);
  }
}

// Handler to write data to the socket, called by event loop when socket is writeable
void connection_middleman::handle_write(ev::io &watcher, int events_flags) {
  int ret = send(m_socket_connection, m_response.c_str()+m_written, m_response.size()-m_written, MSG_NOSIGNAL);
  m_written += ret;
  stats.bytes_written += ret;
  if (m_written == m_response.size()) {
    m_write_event.stop();
    m_timeout_event.stop();
    delete this;
  }
}

// After a middleman has been alive for timout_interval seconds, this is called
void connection_middleman::handle_timeout(ev::timer &watcher, int events_flags) {
  m_timeout_event.stop();
  m_read_event.stop();
  m_write_event.stop();
  delete this;
}
