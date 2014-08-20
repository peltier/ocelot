#ifndef MISC_FUNCTIONS_H
#define MISC_FUNCTIONS_H

#include <string>
#include <cstdlib>

long strtolong(const std::string& str);
int64_t strtolonglong(const std::string& str);
std::string inttostr(int i);
std::string hex_decode(const std::string &in);
std::string bintohex(const std::string &in);
int timeval_subtract (timeval* result, timeval* x, timeval* y);

#endif
