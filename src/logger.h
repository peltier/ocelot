#ifndef ocelot_logger_h
#define ocelot_logger_h

#include <iostream>
#include <atomic>
#include <string>

enum class LogLevel {
  INFO,
  WARN,
  ERROR,
  FAIL
};

class Logger {
  public:
    Logger() {
      set_log_level( LogLevel::WARN );
    }
  
    static void info( std::string message ) {
      singleton_logger.log_message( "[INFO] " + message , LogLevel::INFO );
    }
  
    static void warn( std::string message ) {
      singleton_logger.log_message( "[WARN]" + message , LogLevel::WARN );
    }
  
    static void error( std::string message ) {
      singleton_logger.log_message( "[ERROR] " + message , LogLevel::ERROR );
    }
  
    static void fail( std::string message ) {
      singleton_logger.log_message( "[FAILED] " + message , LogLevel::FAIL );
    }
  
    static void set_log_level( LogLevel level ) { singleton_logger.m_level = level; }
  
  private:
  
    static Logger singleton_logger;
  
    std::atomic< LogLevel > m_level;
  
    void log_message( std::string message, LogLevel level ) {
      // Chech if level severity is lower than desired
      if( m_level > level ) {
        return;
      }
      
      std::cout << message << std::endl;
    }
};

#endif
