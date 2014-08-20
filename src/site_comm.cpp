#include <iostream>
#include <istream>
#include <ostream>
#include <string>
#include <sstream>
#include <queue>
#include <mutex>
#include <boost/asio.hpp>
#include <thread>

#include "config.h"
#include "site_comm.h"

using boost::asio::ip::tcp;

site_comm::site_comm(config &config)
  : m_conf(config), m_t_active(false) {}

site_comm::~site_comm() {}

bool site_comm::all_clear() {
  return (m_token_queue.size() == 0);
}

void site_comm::expire_token(int torrent, int user)
{
  std::stringstream token_pair;
  token_pair << user << ':' << torrent;
  if (m_expire_token_buffer != "") {
    m_expire_token_buffer += ",";
  }
  m_expire_token_buffer += token_pair.str();
  if (m_expire_token_buffer.length() > 350) {
    std::cout << "Flushing overloaded token buffer" << std::endl;
    std::unique_lock<std::mutex> lock(m_expire_queue_lock);
    m_token_queue.push(m_expire_token_buffer);
    m_expire_token_buffer.clear();
  }
}

void site_comm::flush_tokens()
{
  std::unique_lock<std::mutex> lock(m_expire_queue_lock);
  size_t qsize = m_token_queue.size();
  if (verbose_flush || qsize > 0) {
    std::cout << "Token expire queue size: " << qsize << std::endl;
  }
  if (m_expire_token_buffer == "") {
    return;
  }
  m_token_queue.push(m_expire_token_buffer);
  m_expire_token_buffer.clear();
  if (m_t_active == false) {
    std::thread thread(&site_comm::do_flush_tokens, this);
    thread.detach();
  }
}

void site_comm::do_flush_tokens()
{
  m_t_active = true;
  try {
    while (m_token_queue.size() > 0) {
      boost::asio::io_service io_service;

      tcp::resolver resolver(io_service);
      tcp::resolver::query query(m_conf.site_host, "http");
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
      request_stream << "GET " << m_conf.site_path << "/tools.php?key=" << m_conf.site_password;
      request_stream << "&type=expiretoken&action=ocelot&tokens=" << m_token_queue.front() << " HTTP/1.0\r\n";
      request_stream << "Host: " << m_conf.site_host << "\r\n";
      request_stream << "Accept: */*\r\n";
      request_stream << "Connection: close\r\n\r\n";

      boost::asio::write(socket, request);

      boost::asio::streambuf response;
      boost::asio::read_until(socket, response, "\r\n");

      std::istream response_stream(&response);
      std::string http_version;
      response_stream >> http_version;
      unsigned int status_code;
      response_stream >> status_code;
      std::string status_message;
      std::getline(response_stream, status_message);

      if (!response_stream || http_version.substr(0, 5) != "HTTP/") {
        std::cout << "Invalid response" << std::endl;
        continue;
      }

      if (status_code == 200) {
        std::unique_lock<std::mutex> lock(m_expire_queue_lock);
        m_token_queue.pop();
      } else {
        std::cout << "Response returned with status code " << status_code << " when trying to expire a token!" << std::endl;;
      }
    }
  } catch (std::exception &e) {
    std::cout << "Exception: " << e.what() << std::endl;
  }
  m_t_active = false;
}
