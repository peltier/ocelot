#ifndef ocelot_logger_h
#define ocelot_logger_h

#include <iostream>
#include <atomic>
#include <string>

enum class LogLevel {
  TRACE,
  DEBUG,
  INFO,
  WARNING,
  ERROR,
  FATAL
};

class Logger {
  public:
    Logger() {}

    static void trace( std::string message );
    static void debug( std::string message );
    static void info( std::string message );
    static void warning( std::string message );
    static void error( std::string message );
    static void fatal( std::string message );
    static void set_log_level( LogLevel level );
};

#endif
