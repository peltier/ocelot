#include "logger.h"
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/trivial.hpp>

void Logger::trace( std::string message ) {
  BOOST_LOG_TRIVIAL(trace) << message;
}

void Logger::debug( std::string message ) {
  BOOST_LOG_TRIVIAL(debug) << message;
}

void Logger::info( std::string message ) {
  BOOST_LOG_TRIVIAL(info) << message;
}

void Logger::warning( std::string message ) {
  BOOST_LOG_TRIVIAL(warning) << message;
}

void Logger::error( std::string message ) {
  BOOST_LOG_TRIVIAL(error) << message;
}

void Logger::fatal( std::string message ) {
  BOOST_LOG_TRIVIAL(fatal) << message;
}

void Logger::set_log_level( LogLevel level ) {
  auto log_level = boost::log::trivial::info;

  switch(level) {
  case LogLevel::TRACE:
    log_level = boost::log::trivial::trace;
    break;
  case LogLevel::DEBUG:
    log_level = boost::log::trivial::debug;
    break;
  case LogLevel::INFO:
    log_level = boost::log::trivial::info;
    break;
  case LogLevel::WARNING:
    log_level = boost::log::trivial::warning;
    break;
  case LogLevel::ERROR:
    log_level = boost::log::trivial::error;
    break;
  case LogLevel::FATAL:
    log_level = boost::log::trivial::fatal;
    break;
  }

  boost::log::core::get()->set_filter(
    boost::log::trivial::severity >= log_level
  );
}
