#include "test_helper.h"

TEST(ScrapeControllerTests, can_scrape_a_torrent) {
  
  auto successful_scrape = "/3f981ffe2XXXXXX7780441XXXXXX6dde/scrape?info_hash=b%2f%04e%5b%3e%85%bc%3c%17%aa%e4%da%c4%fdiM%adK%60";
  
  auto response = http::get( successful_scrape );
  
  auto head = "d5:filesd20:";
  auto body = "d8:completei0e10:incompletei0e10:downloadedi0eeee";

  EXPECT_TRUE( response.find( head ) != std::string::npos );
  EXPECT_TRUE( response.find( body ) != std::string::npos );
}

TEST(ScrapeControllerTests, fails_when_torrent_doesnt_exist) {
  
  auto successful_scrape = "/3f981ffe2XXXXXX7780441XXXXXX6dde/scrape?info_hash=b%2f%04e%5b%3e%BADBAD3c%17%aa%e4%da%c4***iM%adK%60";
  
  auto response = http::get( successful_scrape );
  
  EXPECT_TRUE( response.find("d5:filesdee") != std::string::npos );
}

TEST(ScrapeControllerTests, can_use_multiple_info_hashes) {
  
  auto successful_scrape = "/3f981ffe2XXXXXX7780441XXXXXX6dde/scrape?info_hash=b%2f%04e%5b%3e%85%bc%3c%17%aa%e4%da%c4%fdiM%adK%60&info_hash=b%2f%04e%5b%3e%85%bc%3c%17%aa%e4%da%c4%fdiM%adK%60&";
  
  auto response = http::get( successful_scrape );
  
  auto head = "d5:filesd20:";
  auto body = "d8:completei0e10:incompletei0e10:downloadedi0eeee";
  
  EXPECT_TRUE( response.find( head ) != std::string::npos );
  EXPECT_TRUE( response.find( body ) != std::string::npos );
  // Can find the second torrent stats
  EXPECT_TRUE( response.find( body, 80 ) != std::string::npos );
}