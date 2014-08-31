#ifndef OCELOT_EVENTS_H
#define OCELOT_EVENTS_H

#include <iostream>
#include <string>
#include <cstring>

// Sockets
#include <sys/socket.h>
#include <arpa/inet.h>
#include <fcntl.h>

#ifdef __APPLE__
  // libev hack: http://goo.gl/7TjNPD
  #ifdef EV_ERROR
  #undef EV_ERROR
  #endif

  // MSG_NOSIGNAL not available on OSX, but same as MSG_HAVEMORE
  #define MSG_NOSIGNAL MSG_HAVEMORE
#endif

// libev
#include <ev++.h>



/*
TODO find out what these do
#include <netinet/in.h>
#include <netdb.h>
#include <sys/types.h>
*/





/*
We have three classes - the mother, the middlemen, and the worker
THE MOTHER
  The mother is called when a client opens a connection to the server.
  It creates a middleman for every new connection, which will be called
  when its socket is ready for reading.
THE MIDDLEMEN
  Each middleman hang around until data is written to its socket. It then
  reads the data and sends it to the worker. When it gets the response, it
  gets called to write its data back to the client.
THE WORKER
  The worker gets data from the middleman, and returns the response. It
  doesn't concern itself with silly things like sockets.

  see worker.h for the worker.
*/




// THE MOTHER - Spawns connection middlemen
class connection_mother {
  public:
    connection_mother(worker * worker_obj);
    void handle_connect(ev::io &watcher, int events_flags);
    ~connection_mother();

  private:
    int m_listen_socket;
    sockaddr_in m_address;
    socklen_t m_address_length;
    worker * m_worker;
    config * m_config;
    ev::timer m_schedule_event;
};

// THE MIDDLEMAN
// Created by connection_mother
// Add their own watchers to see when sockets become readable
class connection_middleman {
  public:
    connection_middleman(int &listen_socket, sockaddr_in &address, socklen_t &addr_len, worker* work);
    ~connection_middleman();

    void handle_read(ev::io &watcher, int events_flags);
    void handle_write(ev::io &watcher, int events_flags);
    void handle_timeout(ev::timer &watcher, int events_flags);

  private:
    int m_socket_connection;
    unsigned int m_written;
    ev::io m_read_event;
    ev::io m_write_event;
    ev::timer m_timeout_event;
    std::string m_request;
    std::string m_response;

    config * m_config;
    worker * m_worker;
    sockaddr_in m_client_address;
};

#endif