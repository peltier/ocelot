#include "test_helper.h"

TEST(RouterTests, stops_request_with_incorrect_passcode_format) {
  
  auto bad_announce = "/*****/announce";
  
  auto output = "d14:failure reason18:Malformed announce12:min intervali5400e8:intervali5400ee";
  
  auto response = http::get("localhost", 34000, bad_announce);
  
  EXPECT_TRUE( response.find( output ) != std::string::npos );
}

TEST(RouterTests, no_request_params_renders_html) {
  
  auto bad_announce = "/3f981ffe2XXXXXX7780441XXXXXX6dde/announce";
  
  auto output = "<html><head><meta name=\"robots\" content=\"noindex, nofollow\" /></head><body>Nothing to see here</body></html>";
  
  auto response = http::get("localhost", 34000, bad_announce);
  
  EXPECT_TRUE( response.find( output ) != std::string::npos );
}
