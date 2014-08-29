#ifndef OCELOT_RESPONSE_H
#define OCELOT_RESPONSE_H

#include <string>

std::string html(const std::string &body);
std::string response(const std::string &body, bool gzip, bool html);
std::string response_head(bool gzip, bool html);
std::string error(const std::string &err);
std::string warning(const std::string &msg);

#endif