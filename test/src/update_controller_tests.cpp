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

TEST(UpdateControllerTests, remove_torrent_from_tracker) {

  // FIRST WE ADD A NEW TORRENT
  auto request = "/"+ config::get_instance()->site_password +"/update?action=add_torrent&info_hash=aaaaaaaaaaaaaaaatest&id=99999988&freetorrent=0";
  
  auto response = http::get(request);
  
  EXPECT_TRUE( response.find("Added torrent 99999988. FL: 0 0") != std::string::npos );

  // NOW WE DELETE IT
  auto request_del = "/"+ config::get_instance()->site_password +"/update?action=delete_torrent&info_hash=aaaaaaaaaaaaaaaatest&reason=3";
  
  auto response_del = http::get(request_del);

  EXPECT_TRUE( response_del.find("Deleting torrent 99999988 for the reason 'Bad Folder Names'") != std::string::npos );
  
  // CANNOT DELETE TWICE
  auto request_error = "/"+ config::get_instance()->site_password +"/update?action=delete_torrent&info_hash=aaaaaaaaaaaaaaaatest&reason=3";
  
  auto response_error = http::get(request_del);
  
  EXPECT_TRUE( response_error.find("Failed to find torrent") != std::string::npos );
  EXPECT_TRUE( response_error.find("to delete") != std::string::npos );

}

TEST(UpdateControllerTests, change_a_user_passkey) {

  auto base = "/"+ config::get_instance()->site_password;

  auto request = base + "/update?action=change_passkey&oldpasskey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab&newpasskey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac";

  auto undo_request = base + "/update?action=change_passkey&oldpasskey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac&newpasskey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab";

  auto response = http::get( request );

  EXPECT_TRUE( response.find("Changed passkey from ") != std::string::npos );

  EXPECT_TRUE( http::get( request ).find("No user_t with passkey") != std::string::npos );

  // Undo changes
  EXPECT_TRUE( http::get( undo_request ).find("Changed passkey from ") != std::string::npos );
}
