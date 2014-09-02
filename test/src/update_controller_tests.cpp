#include "test_helper.h"
#include "misc_functions.h"

TEST(UpdateControllerTests, add_user_to_tracker) {
  auto request = "/"+ config::get_instance()->site_password +"/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa&id=10000001";
  
  auto response = http::get(request);
  
  EXPECT_TRUE( response.find("Added user_t aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa with id 10000001") != std::string::npos );
  
  auto user_vec = UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  
  EXPECT_FALSE( user_vec.empty() );
  EXPECT_EQ( user_vec.front()->get_id(), 10000001 );
}

TEST(UpdateControllerTests, fails_when_adds_existing_user) {
  
  // Check to make sure this test comes second
  EXPECT_FALSE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").empty() );

  auto request = "/"+ config::get_instance()->site_password +"/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa&id=10000001";
  
  auto response = http::get(request);
  
  EXPECT_TRUE( response.find("Tried to add already known user_t aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa with id 10000001") != std::string::npos );
}

TEST(UpdateControllerTests, add_three_users_to_tracker) {

  auto base = "/"+ config::get_instance()->site_password;
  
  http::get(base + "/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab&id=10000002");
  http::get(base + "/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac&id=10000003");
  http::get(base + "/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad&id=10000004");
  
  EXPECT_FALSE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab").empty() );
  EXPECT_FALSE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac").empty() );
  EXPECT_FALSE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad").empty() );
}

TEST(UpdateControllerTests, add_torrent_to_tracker) {
  auto request = "/"+ config::get_instance()->site_password +"/update?action=add_torrent&info_hash=aaaaaaaaaaaaaaaaaaaa&id=99999999&freetorrent=0";
  
  auto response = http::get(request);
  
  EXPECT_TRUE( response.find("Added torrent 99999999. FL: 0 0") != std::string::npos );
  
  request = "/"+ config::get_instance()->site_password +"/update?action=add_torrent&info_hash=aaaaaaaaaaaaaaaaaaaa&id=99999999&freetorrent=1";
  
  response = http::get(request);
  
  EXPECT_TRUE( response.find("Added torrent 99999999. FL: 1 1") != std::string::npos );
  
  EXPECT_FALSE( TorrentListCache::find( hex_decode("aaaaaaaaaaaaaaaaaaaa") ).empty() );
}
