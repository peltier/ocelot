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

  auto request = "/"+ config::get_instance()->site_password + "/update?action=add_torrent&info_hash=aaaaaaaaaaaaaaaaaaaa&id=99999999&freetorrent=0";
  
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

TEST(UpdateControllerTests, update_torrent) {

  // Add torrent
  http::get("/" + config::get_instance()->site_password + "/update?action=add_torrent&info_hash=aaaaaaaaaaaaaaaaaaaupdatetorrent&id=99990000&freetorrent=0");

  EXPECT_FALSE( TorrentListCache::find("aaaaaaaaaaaaaaaaaaaupdatetorrent").empty() );

  auto request = "/"+ config::get_instance()->site_password +"/update?action=update_torrent&info_hash=aaaaaaaaaaaaaaaaaaaupdatetorrent&freetorrent=1";

  auto bad_request = "/"+ config::get_instance()->site_password +"/update?action=update_torrent&info_hash=aaaaxxxaaaadoesnotexist&freetorrent=0";

  auto partial_request = "/"+ config::get_instance()->site_password +"/update?action=update_torrent&info_hash=aaaaaaaaaaaaaaaaaaaupdatetorrent";

  // Test for success and error
  EXPECT_TRUE( http::get( request ).find("Updated torrent ") != std::string::npos );

  EXPECT_TRUE( http::get( bad_request ).find("Failed to find torrent ") != std::string::npos );

  auto torrent = TorrentListCache::find("aaaaaaaaaaaaaaaaaaaupdatetorrent").front();

  EXPECT_EQ( FREE, torrent.free_torrent );

  // Test Partial
  EXPECT_TRUE( http::get( partial_request ).find("Updated torrent ") != std::string::npos );

  torrent = TorrentListCache::find("aaaaaaaaaaaaaaaaaaaupdatetorrent").front();

  EXPECT_EQ( NEUTRAL, torrent.free_torrent );
}

TEST(UpdateControllerTests, update_torrents) {

  // Add torrent
  http::get("/" + config::get_instance()->site_password + "/update?action=add_torrent&info_hash=aa1aaaaaaaaaaaaatest&id=99990010&freetorrent=0");
  http::get("/" + config::get_instance()->site_password + "/update?action=add_torrent&info_hash=aa2aaaaaaaaaaaaatest&id=99990020&freetorrent=0");

  EXPECT_FALSE( TorrentListCache::find("aa1aaaaaaaaaaaaatest").empty() );
  EXPECT_FALSE( TorrentListCache::find("aa2aaaaaaaaaaaaatest").empty() );
  EXPECT_TRUE( TorrentListCache::find("aa3adoesnotexisttest").empty() );

  // Do it!
  auto torrent_1 = "aa1aaaaaaaaaaaaatest";
  auto torrent_2 = "aa2aaaaaaaaaaaaatest";
  auto torrent_3 = "aa3adoesnotexisttest";

  auto request = "/"+ config::get_instance()->site_password +"/update?action=update_torrents&info_hashes=" + torrent_1 + torrent_2 + torrent_3 + "&freetorrent=1";

  auto response = http::get( request );

  EXPECT_TRUE( response.find("Updated torrent 99990010") != std::string::npos );
  EXPECT_TRUE( response.find("Updated torrent 99990020") != std::string::npos );
  // There should be one bad torrent in the mix
  EXPECT_TRUE( response.find("Failed to find torrent aa3adoesnotexisttest") != std::string::npos );

  EXPECT_EQ( FREE, TorrentListCache::find("aa1aaaaaaaaaaaaatest").front().free_torrent );
  EXPECT_EQ( FREE, TorrentListCache::find("aa2aaaaaaaaaaaaatest").front().free_torrent );
  EXPECT_TRUE( TorrentListCache::find("aa3adoesnotexisttest").empty() );
}

TEST(UpdateControllerTests, add_token_to_torrent) {

  // Add torrent
  http::get("/" + config::get_instance()->site_password + "/update?action=add_torrent&info_hash=aa1aaaaaaaaaaaatoken&id=90993015&freetorrent=0");

  auto request = "/"+ config::get_instance()->site_password +"/update?action=add_token&info_hash=aa1aaaaaaaaaaaatoken&userid=123456";
  auto request_bad = "/"+ config::get_instance()->site_password +"/update?action=add_token&info_hash=aa1aaaazzzaaaaatoken&userid=123456";

  auto response = http::get( request );

  EXPECT_TRUE( response.find("Added user id 123456 to aa1aaaaaaaaaaaatoken") != std::string::npos );

  EXPECT_EQ( 1, TorrentListCache::find("aa1aaaaaaaaaaaatoken").front().tokened_users.count(123456) );

  EXPECT_TRUE( http::get( request_bad ).find("Failed to find torrent to add a token for user_t 123456") != std::string::npos );
}

TEST(UpdateControllerTests, remove_user) {

  // Add a user
  http::get("/"+ config::get_instance()->site_password +"/update?action=add_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz&id=10123002");

  EXPECT_FALSE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz").empty() );

  auto request = "/"+ config::get_instance()->site_password +"/update?action=remove_user&passkey=aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz";

  EXPECT_TRUE( http::get( request ).find("Removed user_t aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz with id 10123002") != std::string::npos );

  EXPECT_TRUE( UserListCache::find("aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz").empty() );

  EXPECT_TRUE( http::get( request ).find("No such user_t for passkey aaaaaaaaaaaaaaaaaaaaaaaaaaaaazzz") != std::string::npos );
}