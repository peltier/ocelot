#ifndef OCELOT_EVENTS_H
#define OCELOT_EVENTS_H

#include <iostream>
#include <string>
#include <cstring>

// Sockets
#include <sys/socket.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>

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
  private:
    int listen_socket;
    sockaddr_in address;
    socklen_t addr_len;
    worker * work;
    config * conf;
    mysql * db;
    site_comm * sc;
    ev::timer schedule_event;

  public:
    connection_mother(worker * worker_obj, config * config_obj, mysql * db_obj, site_comm * sc_obj);
    void handle_connect(ev::io &watcher, int events_flags);
    ~connection_mother();
};

// THE MIDDLEMAN
// Created by connection_mother
// Add their own watchers to see when sockets become readable
class connection_middleman {
  private:
    int connect_sock;
    unsigned int written;
    ev::io read_event;
    ev::io write_event;
    ev::timer timeout_event;
    std::string request;
    std::string response;

    config * conf;
    connection_mother * mother;
    worker * work;
    sockaddr_in client_addr;

  public:
    connection_middleman(int &listen_socket, sockaddr_in &address, socklen_t &addr_len, worker* work, connection_mother * mother_arg, config * config_obj);
    ~connection_middleman();

    void handle_read(ev::io &watcher, int events_flags);
    void handle_write(ev::io &watcher, int events_flags);
    void handle_timeout(ev::timer &watcher, int events_flags);
};

#endif