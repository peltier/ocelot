#include "test_helper.h"

TEST(AnnounceTests, can_make_successful_announce) {
  
  auto successful_announce = "/3f981ffe2XXXXXX7780441XXXXXX6dde/announce?info_hash=b%2f%04e%5b%3e%85%bc%3c%17%aa%e4%da%c4%fdiM%adK%60&peer_id=-TR2840-0kooa2tum5d1&port=55929&uploaded=0&downloaded=0&left=0&numwant=80&key=55529aaf&compact=1&supportcrypto=1&event=started&ipv6=2601%3A7%3A7d00%3Afe%3Acc1f%3A5b6f%3Ae2b4%3A46bf";
  
  auto output = "d8:completei1e10:downloadedi0e10:incompletei0e8:intervali1801e12:min intervali1800e5:peers0:e";
  
  auto response = http::get("localhost", 34000, successful_announce);
  
  EXPECT_TRUE( response.find( output ) != std::string::npos );
}

TEST(AnnounceTests, cannot_make_unauthorized_announce) {
  
  auto bad_announce = "/3f981ffe2XXXXXX7780441XXXXXX****/announce?info_hash=b%2f%04e%5b%3e%85%bc%3c%17%aa%e4%da%c4%fdiM%adK%60&peer_id=-TR2840-0kooa2tum5d1&port=55929&uploaded=0&downloaded=0&left=0&numwant=80&key=55529aaf&compact=1&supportcrypto=1&event=started&ipv6=2601%3A7%3A7d00%3Afe%3Acc1f%3A5b6f%3Ae2b4%3A46bf";
  
  auto output = "d14:failure reason22:Authentication failure12:min intervali5400e8:intervali5400ee";
  
  auto response = http::get("localhost", 34000, bad_announce);
  
  EXPECT_TRUE( response.find( output ) != std::string::npos );
}
