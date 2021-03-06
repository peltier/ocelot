#ifndef ocelot_http_client_h
#define ocelot_http_client_h

#include <iostream>
#include <string>
#include <istream>
#include <ostream>
#include <sstream>
#include <boost/asio.hpp>

#include "config.h"

using boost::asio::ip::tcp;

namespace http {
  static std::string get(std::string path ) {
  
    std::string host = config::get_instance()->host;
    int port = config::get_instance()->port;

    try {
      boost::asio::io_service io_service;
      
      tcp::resolver resolver(io_service);
      tcp::resolver::query query(host, std::to_string(port) );
      tcp::resolver::iterator endpoint_iterator = resolver.resolve(query);
      tcp::resolver::iterator end;
      
      tcp::socket socket(io_service);
      boost::system::error_code error = boost::asio::error::host_not_found;
      while (error && endpoint_iterator != end) {
        socket.close();
        socket.connect(*endpoint_iterator++, error);
      }
      if (error) {
        throw boost::system::system_error(error);
      }
      
      boost::asio::streambuf request;
      std::ostream request_stream(&request);
      request_stream << "GET " << path << " HTTP/1.1\r\n";
      request_stream << "Host: " << host << "\r\n";
      request_stream << "Accept: */*\r\n";
      request_stream << "Connection: close\r\n\r\n";
      
      boost::asio::write(socket, request);
      
      boost::asio::streambuf response_buffer;
      std::string response_string;
      
      while (boost::asio::read(socket, response_buffer, boost::asio::transfer_at_least(1), error)) {
        std::istream response_stream(&response_buffer);
        response_string += std::string( (std::istreambuf_iterator<char>(response_stream)),
                                std::istreambuf_iterator<char>() );
      }
      
      if (error != boost::asio::error::eof) {
        throw boost::system::system_error(error);
      }
      
      return response_string;

    } catch (std::exception &e) {
      std::cout << "Exception: " << e.what() << std::endl;
    }
    
    return "Exception caught!";
  }
}

#endif
