#include "test_helper.h"


TEST(ReportControllerTests, fails_without_get_stats_param) {

  auto bad_request = "/" + config::get_instance()->report_password + "/report";
  
  auto expected_response = "<html><head><meta name=\"robots\" content=\"noindex, nofollow\" /></head><body>Nothing to see here</body></html>";
  
  auto response = http::get(bad_request);
  
  EXPECT_TRUE( response.find( expected_response ) != std::string::npos );
}

TEST(ReportControllerTests, fails_with_bad_report_password) {
  
  auto bad_request = "/***S*bad**12****D****s***bad*bad/report?get=stats";
  
  auto expected_response = "d14:failure reason22:Authentication failure12:min intervali5400e8:intervali5400ee";
  
  auto response = http::get(bad_request);
  
  EXPECT_TRUE( response.find( expected_response ) != std::string::npos );
}

TEST(ReportControllerTests, can_get_successful_tracker_report) {

  auto request = "/" + config::get_instance()->report_password + "/report?get=stats";
  
  auto response = http::get(request);
  
  EXPECT_TRUE( response.find("Uptime") != std::string::npos );
  EXPECT_TRUE( response.find("Connections Opened") != std::string::npos );
  EXPECT_TRUE( response.find("Open Connection") != std::string::npos );
  EXPECT_TRUE( response.find("Connections/s") != std::string::npos );
  EXPECT_TRUE( response.find("Bytes Read") != std::string::npos );
  EXPECT_TRUE( response.find("</table>") != std::string::npos );
  EXPECT_TRUE( response.find("</style>") != std::string::npos );
}

TEST(ReportControllerTests, fails_when_getting_user_t_without_key) {

  auto request = "/" + config::get_instance()->report_password + "/report?get=user_t";
  
  auto response = http::get( request );
  
  EXPECT_TRUE( response.find("Invalid action") != std::string::npos );
}

TEST(ReportControllerTests, failes_when_given_bad_user_key) {
  
  auto request = "/" + config::get_instance()->report_password + "/report?get=user_t&key=3f981ffe2XXXXXbadbadbadbadbadbad";
  
  auto response = http::get( request );
  
  EXPECT_TRUE( response.find("No such user!") != std::string::npos );
}

TEST(ReportControllerTests, can_get_successful_user_report) {
  
  auto request = "/" + config::get_instance()->report_password + "/report?get=user_t&key=3f981ffe2XXXXXX7780441XXXXXX6dde";
  
  auto response = http::get( request );
  
  EXPECT_TRUE( response.find("Leeching") != std::string::npos );
  EXPECT_TRUE( response.find("Seeding") != std::string::npos );
  EXPECT_TRUE( response.find("</table>") != std::string::npos );
  EXPECT_TRUE( response.find("</style>") != std::string::npos );
}
