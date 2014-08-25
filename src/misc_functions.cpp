#include <string>
#include <iostream>
#include <sstream>

#include "ocelot.h"

std::string hex_decode(const std::string &in) {
  std::string out;
  out.reserve(20);
  unsigned int in_length = in.length();
  for (unsigned int i = 0; i < in_length; i++) {
    unsigned char x = '0';
    if (in[i] == '%' && (i + 2) < in_length) {
      i++;
      if (in[i] >= 'a' && in[i] <= 'f') {
        x = static_cast<unsigned char>((in[i]-87) << 4);
      } else if (in[i] >= 'A' && in[i] <= 'F') {
        x = static_cast<unsigned char>((in[i]-55) << 4);
      } else if (in[i] >= '0' && in[i] <= '9') {
        x = static_cast<unsigned char>((in[i]-48) << 4);
      }

      i++;
      if (in[i] >= 'a' && in[i] <= 'f') {
        x += static_cast<unsigned char>(in[i]-87);
      } else if (in[i] >= 'A' && in[i] <= 'F') {
        x += static_cast<unsigned char>(in[i]-55);
      } else if (in[i] >= '0' && in[i] <= '9') {
        x += static_cast<unsigned char>(in[i]-48);
      }
    } else {
      x = in[i];
    }
    out.push_back(x);
  }
  return out;
}

std::string bintohex(const std::string &in) {
  std::string out;
  out.reserve(40);
  size_t length = in.length();
  for (unsigned int i = 0; i < length; i++) {
    unsigned char x = (unsigned char)in[i] >> 4;
    if (x > 9) {
      x += 'a' - 10;
    } else {
      x += '0';
    }
    out.push_back(x);
    x = in[i] & 0xF;
    if (x > 9) {
      x += 'a' - 10;
    } else {
      x += '0';
    }
    out.push_back(x);
  }
  return out;
}

std::string get_deletion_reason(int code)
{
  switch (code) {
    case DUPE:
      return "Dupe";
    case TRUMP:
      return "Trump";
    case BAD_FILE_NAMES:
      return "Bad File Names";
    case BAD_FOLDER_NAMES:
      return "Bad Folder Names";
    case BAD_TAGS:
      return "Bad Tags";
    case BAD_FORMAT:
      return "Disallowed Format";
    case DISCS_MISSING:
      return "Discs Missing";
    case DISCOGRAPHY:
      return "Discography";
    case EDITED_LOG:
      return "Edited Log";
    case INACCURATE_BITRATE:
      return "Inaccurate Bitrate";
    case LOW_BITRATE:
      return "Low Bitrate";
    case MUTT_RIP:
      return "Mutt Rip";
    case BAD_SOURCE:
      return "Disallowed Source";
    case ENCODE_ERRORS:
      return "Encode Errors";
    case BANNED:
      return "Specifically Banned";
    case TRACKS_MISSING:
      return "Tracks Missing";
    case TRANSCODE:
      return "Transcode";
    case CASSETTE:
      return "Unapproved Cassette";
    case UNSPLIT_ALBUM:
      return "Unsplit Album";
    case USER_COMPILATION:
      return "User Compilation";
    case WRONG_FORMAT:
      return "Wrong Format";
    case WRONG_MEDIA:
      return "Wrong Media";
    case AUDIENCE:
      return "Audience Recording";
    default:
      return "";
  }
}
