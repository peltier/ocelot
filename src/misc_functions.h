#ifndef MISC_FUNCTIONS_H
#define MISC_FUNCTIONS_H

#include <string>
#include <cstdlib>

std::string hex_decode(const std::string &in);
std::string bintohex(const std::string &in);
int timeval_subtract (timeval* result, timeval* x, timeval* y);
std::string get_deletion_reason(int code);

#endif
