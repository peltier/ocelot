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
    Logger() {}

    static void info( std::string message );
    static void warn( std::string message );
    static void error( std::string message );
    static void fail( std::string message );
    static void set_log_level( LogLevel level );
};

#endif
