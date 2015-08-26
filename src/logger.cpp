#include "logger.h"
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/trivial.hpp>

void Logger::info( std::string message ) {
  BOOST_LOG_TRIVIAL(info) << message;
}

void Logger::warn( std::string message ) {
  BOOST_LOG_TRIVIAL(warning) << message;
}

void Logger::error( std::string message ) {
  BOOST_LOG_TRIVIAL(error) << message;
}

void Logger::fail( std::string message ) {
  BOOST_LOG_TRIVIAL(fatal) << message;
}

void Logger::set_log_level( LogLevel level ) {
  auto log_level = boost::log::trivial::info;

  switch(level) {
  case LogLevel::INFO:
    log_level = boost::log::trivial::info;
    break;
  case LogLevel::WARN:
    log_level = boost::log::trivial::warning;
    break;
  case LogLevel::ERROR:
    log_level = boost::log::trivial::error;
    break;
  case LogLevel::FAIL:
    log_level = boost::log::trivial::fatal;
    break;
  }

  boost::log::core::get()->set_filter(
    boost::log::trivial::severity >= log_level
  );
}
