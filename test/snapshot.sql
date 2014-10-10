-- MySQL dump 10.13  Distrib 5.6.19, for osx10.9 (x86_64)
--
-- Host: localhost    Database: gazelle
-- ------------------------------------------------------
-- Server version	5.6.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_applications`
--

DROP TABLE IF EXISTS `api_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_applications` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `UserID` int(10) NOT NULL,
  `Token` char(32) NOT NULL,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_applications`
--

LOCK TABLES `api_applications` WRITE;
/*!40000 ALTER TABLE `api_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_users`
--

DROP TABLE IF EXISTS `api_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_users` (
  `UserID` int(10) NOT NULL,
  `AppID` int(10) NOT NULL,
  `Token` char(32) NOT NULL,
  `State` enum('0','1','2') NOT NULL DEFAULT '0',
  `Time` datetime NOT NULL,
  `Access` text,
  PRIMARY KEY (`UserID`,`AppID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_users`
--

LOCK TABLES `api_users` WRITE;
/*!40000 ALTER TABLE `api_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_alias`
--

DROP TABLE IF EXISTS `artists_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_alias` (
  `AliasID` int(10) NOT NULL AUTO_INCREMENT,
  `ArtistID` int(10) NOT NULL,
  `Name` varchar(200) DEFAULT NULL,
  `Redirect` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AliasID`),
  KEY `ArtistID` (`ArtistID`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_alias`
--

LOCK TABLES `artists_alias` WRITE;
/*!40000 ALTER TABLE `artists_alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_group`
--

DROP TABLE IF EXISTS `artists_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_group` (
  `ArtistID` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) DEFAULT NULL,
  `RevisionID` int(12) DEFAULT NULL,
  `VanityHouse` tinyint(1) DEFAULT '0',
  `LastCommentID` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ArtistID`),
  KEY `Name` (`Name`),
  KEY `RevisionID` (`RevisionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_group`
--

LOCK TABLES `artists_group` WRITE;
/*!40000 ALTER TABLE `artists_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_similar`
--

DROP TABLE IF EXISTS `artists_similar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_similar` (
  `ArtistID` int(10) NOT NULL DEFAULT '0',
  `SimilarID` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ArtistID`,`SimilarID`),
  KEY `ArtistID` (`ArtistID`),
  KEY `SimilarID` (`SimilarID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_similar`
--

LOCK TABLES `artists_similar` WRITE;
/*!40000 ALTER TABLE `artists_similar` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_similar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_similar_scores`
--

DROP TABLE IF EXISTS `artists_similar_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_similar_scores` (
  `SimilarID` int(12) NOT NULL AUTO_INCREMENT,
  `Score` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`SimilarID`),
  KEY `Score` (`Score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_similar_scores`
--

LOCK TABLES `artists_similar_scores` WRITE;
/*!40000 ALTER TABLE `artists_similar_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_similar_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_similar_votes`
--

DROP TABLE IF EXISTS `artists_similar_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_similar_votes` (
  `SimilarID` int(12) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Way` enum('up','down') NOT NULL DEFAULT 'up',
  PRIMARY KEY (`SimilarID`,`UserID`,`Way`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_similar_votes`
--

LOCK TABLES `artists_similar_votes` WRITE;
/*!40000 ALTER TABLE `artists_similar_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_similar_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artists_tags`
--

DROP TABLE IF EXISTS `artists_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artists_tags` (
  `TagID` int(10) NOT NULL DEFAULT '0',
  `ArtistID` int(10) NOT NULL DEFAULT '0',
  `PositiveVotes` int(6) NOT NULL DEFAULT '1',
  `NegativeVotes` int(6) NOT NULL DEFAULT '1',
  `UserID` int(10) DEFAULT NULL,
  PRIMARY KEY (`TagID`,`ArtistID`),
  KEY `TagID` (`TagID`),
  KEY `ArtistID` (`ArtistID`),
  KEY `PositiveVotes` (`PositiveVotes`),
  KEY `NegativeVotes` (`NegativeVotes`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists_tags`
--

LOCK TABLES `artists_tags` WRITE;
/*!40000 ALTER TABLE `artists_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `artists_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bad_passwords`
--

DROP TABLE IF EXISTS `bad_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bad_passwords` (
  `Password` char(32) NOT NULL,
  PRIMARY KEY (`Password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bad_passwords`
--

LOCK TABLES `bad_passwords` WRITE;
/*!40000 ALTER TABLE `bad_passwords` DISABLE KEYS */;
/*!40000 ALTER TABLE `bad_passwords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blog` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Body` text NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ThreadID` int(10) unsigned DEFAULT NULL,
  `Important` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_artists`
--

DROP TABLE IF EXISTS `bookmarks_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_artists` (
  `UserID` int(10) NOT NULL,
  `ArtistID` int(10) NOT NULL,
  `Time` datetime NOT NULL,
  KEY `UserID` (`UserID`),
  KEY `ArtistID` (`ArtistID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_artists`
--

LOCK TABLES `bookmarks_artists` WRITE;
/*!40000 ALTER TABLE `bookmarks_artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_collages`
--

DROP TABLE IF EXISTS `bookmarks_collages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_collages` (
  `UserID` int(10) NOT NULL,
  `CollageID` int(10) NOT NULL,
  `Time` datetime NOT NULL,
  KEY `UserID` (`UserID`),
  KEY `CollageID` (`CollageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_collages`
--

LOCK TABLES `bookmarks_collages` WRITE;
/*!40000 ALTER TABLE `bookmarks_collages` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_collages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_requests`
--

DROP TABLE IF EXISTS `bookmarks_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_requests` (
  `UserID` int(10) NOT NULL,
  `RequestID` int(10) NOT NULL,
  `Time` datetime NOT NULL,
  KEY `UserID` (`UserID`),
  KEY `RequestID` (`RequestID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_requests`
--

LOCK TABLES `bookmarks_requests` WRITE;
/*!40000 ALTER TABLE `bookmarks_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks_torrents`
--

DROP TABLE IF EXISTS `bookmarks_torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks_torrents` (
  `UserID` int(10) NOT NULL,
  `GroupID` int(10) NOT NULL,
  `Time` datetime NOT NULL,
  `Sort` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `groups_users` (`GroupID`,`UserID`),
  KEY `UserID` (`UserID`),
  KEY `GroupID` (`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks_torrents`
--

LOCK TABLES `bookmarks_torrents` WRITE;
/*!40000 ALTER TABLE `bookmarks_torrents` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks_torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendar`
--

DROP TABLE IF EXISTS `calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) DEFAULT NULL,
  `Body` mediumtext,
  `Category` tinyint(1) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `AddedBy` int(10) DEFAULT NULL,
  `Importance` tinyint(1) DEFAULT NULL,
  `Team` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar`
--

LOCK TABLES `calendar` WRITE;
/*!40000 ALTER TABLE `calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changelog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Message` text NOT NULL,
  `Author` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changelog`
--

LOCK TABLES `changelog` WRITE;
/*!40000 ALTER TABLE `changelog` DISABLE KEYS */;
/*!40000 ALTER TABLE `changelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collages`
--

DROP TABLE IF EXISTS `collages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collages` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL DEFAULT '',
  `Description` text NOT NULL,
  `UserID` int(10) NOT NULL DEFAULT '0',
  `NumTorrents` int(4) NOT NULL DEFAULT '0',
  `Deleted` enum('0','1') DEFAULT '0',
  `Locked` enum('0','1') NOT NULL DEFAULT '0',
  `CategoryID` int(2) NOT NULL DEFAULT '1',
  `TagList` varchar(500) NOT NULL DEFAULT '',
  `MaxGroups` int(10) NOT NULL DEFAULT '0',
  `MaxGroupsPerUser` int(10) NOT NULL DEFAULT '0',
  `Featured` tinyint(4) NOT NULL DEFAULT '0',
  `Subscribers` int(10) DEFAULT '0',
  `updated` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `UserID` (`UserID`),
  KEY `CategoryID` (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collages`
--

LOCK TABLES `collages` WRITE;
/*!40000 ALTER TABLE `collages` DISABLE KEYS */;
/*!40000 ALTER TABLE `collages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collages_artists`
--

DROP TABLE IF EXISTS `collages_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collages_artists` (
  `CollageID` int(10) NOT NULL,
  `ArtistID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Sort` int(10) NOT NULL DEFAULT '0',
  `AddedOn` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`CollageID`,`ArtistID`),
  KEY `UserID` (`UserID`),
  KEY `Sort` (`Sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collages_artists`
--

LOCK TABLES `collages_artists` WRITE;
/*!40000 ALTER TABLE `collages_artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `collages_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collages_torrents`
--

DROP TABLE IF EXISTS `collages_torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collages_torrents` (
  `CollageID` int(10) NOT NULL,
  `GroupID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Sort` int(10) NOT NULL DEFAULT '0',
  `AddedOn` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`CollageID`,`GroupID`),
  KEY `UserID` (`UserID`),
  KEY `Sort` (`Sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collages_torrents`
--

LOCK TABLES `collages_torrents` WRITE;
/*!40000 ALTER TABLE `collages_torrents` DISABLE KEYS */;
/*!40000 ALTER TABLE `collages_torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Page` enum('artist','collages','requests','torrents') NOT NULL,
  `PageID` int(10) NOT NULL,
  `AuthorID` int(10) NOT NULL,
  `AddedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Body` mediumtext,
  `EditedUserID` int(10) DEFAULT NULL,
  `EditedTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Page` (`Page`,`PageID`),
  KEY `AuthorID` (`AuthorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_edits`
--

DROP TABLE IF EXISTS `comments_edits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_edits` (
  `Page` enum('forums','artist','collages','requests','torrents') DEFAULT NULL,
  `PostID` int(10) DEFAULT NULL,
  `EditUser` int(10) DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Body` mediumtext,
  KEY `EditUser` (`EditUser`),
  KEY `PostHistory` (`Page`,`PostID`,`EditTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_edits`
--

LOCK TABLES `comments_edits` WRITE;
/*!40000 ALTER TABLE `comments_edits` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_edits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_edits_tmp`
--

DROP TABLE IF EXISTS `comments_edits_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_edits_tmp` (
  `Page` enum('forums','artist','collages','requests','torrents') DEFAULT NULL,
  `PostID` int(10) DEFAULT NULL,
  `EditUser` int(10) DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Body` mediumtext,
  KEY `EditUser` (`EditUser`),
  KEY `PostHistory` (`Page`,`PostID`,`EditTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_edits_tmp`
--

LOCK TABLES `comments_edits_tmp` WRITE;
/*!40000 ALTER TABLE `comments_edits_tmp` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_edits_tmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concerts`
--

DROP TABLE IF EXISTS `concerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concerts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ConcertID` int(10) NOT NULL,
  `TopicID` int(10) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ConcertID` (`ConcertID`),
  KEY `TopicID` (`TopicID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concerts`
--

LOCK TABLES `concerts` WRITE;
/*!40000 ALTER TABLE `concerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `concerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cover_art`
--

DROP TABLE IF EXISTS `cover_art`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cover_art` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `GroupID` int(10) NOT NULL,
  `Image` varchar(255) NOT NULL DEFAULT '',
  `Summary` varchar(100) DEFAULT NULL,
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Time` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `GroupID` (`GroupID`,`Image`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cover_art`
--

LOCK TABLES `cover_art` WRITE;
/*!40000 ALTER TABLE `cover_art` DISABLE KEYS */;
/*!40000 ALTER TABLE `cover_art` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency_conversion_rates`
--

DROP TABLE IF EXISTS `currency_conversion_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency_conversion_rates` (
  `Currency` char(3) NOT NULL,
  `Rate` decimal(9,4) DEFAULT NULL,
  `Time` datetime DEFAULT NULL,
  PRIMARY KEY (`Currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency_conversion_rates`
--

LOCK TABLES `currency_conversion_rates` WRITE;
/*!40000 ALTER TABLE `currency_conversion_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `currency_conversion_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `do_not_upload`
--

DROP TABLE IF EXISTS `do_not_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `do_not_upload` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Comment` varchar(255) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Sequence` mediumint(8) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `do_not_upload`
--

LOCK TABLES `do_not_upload` WRITE;
/*!40000 ALTER TABLE `do_not_upload` DISABLE KEYS */;
/*!40000 ALTER TABLE `do_not_upload` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donations`
--

DROP TABLE IF EXISTS `donations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donations` (
  `UserID` int(10) NOT NULL,
  `Amount` decimal(6,2) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Time` datetime NOT NULL,
  `Currency` varchar(5) NOT NULL DEFAULT 'USD',
  `Source` varchar(30) NOT NULL DEFAULT '',
  `Reason` mediumtext NOT NULL,
  `Rank` int(10) DEFAULT '0',
  `AddedBy` int(10) DEFAULT '0',
  `TotalRank` int(10) DEFAULT '0',
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`),
  KEY `Amount` (`Amount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donations`
--

LOCK TABLES `donations` WRITE;
/*!40000 ALTER TABLE `donations` DISABLE KEYS */;
/*!40000 ALTER TABLE `donations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donations_bitcoin`
--

DROP TABLE IF EXISTS `donations_bitcoin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donations_bitcoin` (
  `BitcoinAddress` varchar(34) NOT NULL,
  `Amount` decimal(24,8) NOT NULL,
  KEY `BitcoinAddress` (`BitcoinAddress`,`Amount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donations_bitcoin`
--

LOCK TABLES `donations_bitcoin` WRITE;
/*!40000 ALTER TABLE `donations_bitcoin` DISABLE KEYS */;
/*!40000 ALTER TABLE `donations_bitcoin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor_forum_usernames`
--

DROP TABLE IF EXISTS `donor_forum_usernames`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donor_forum_usernames` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Prefix` varchar(30) NOT NULL DEFAULT '',
  `Suffix` varchar(30) NOT NULL DEFAULT '',
  `UseComma` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor_forum_usernames`
--

LOCK TABLES `donor_forum_usernames` WRITE;
/*!40000 ALTER TABLE `donor_forum_usernames` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor_forum_usernames` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor_rewards`
--

DROP TABLE IF EXISTS `donor_rewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donor_rewards` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `IconMouseOverText` varchar(200) NOT NULL DEFAULT '',
  `AvatarMouseOverText` varchar(200) NOT NULL DEFAULT '',
  `CustomIcon` varchar(200) NOT NULL DEFAULT '',
  `SecondAvatar` varchar(200) NOT NULL DEFAULT '',
  `CustomIconLink` varchar(200) NOT NULL DEFAULT '',
  `ProfileInfo1` text NOT NULL,
  `ProfileInfo2` text NOT NULL,
  `ProfileInfo3` text NOT NULL,
  `ProfileInfo4` text NOT NULL,
  `ProfileInfoTitle1` varchar(255) NOT NULL,
  `ProfileInfoTitle2` varchar(255) NOT NULL,
  `ProfileInfoTitle3` varchar(255) NOT NULL,
  `ProfileInfoTitle4` varchar(255) NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor_rewards`
--

LOCK TABLES `donor_rewards` WRITE;
/*!40000 ALTER TABLE `donor_rewards` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor_rewards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drives`
--

DROP TABLE IF EXISTS `drives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drives` (
  `DriveID` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Offset` varchar(10) NOT NULL,
  PRIMARY KEY (`DriveID`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drives`
--

LOCK TABLES `drives` WRITE;
/*!40000 ALTER TABLE `drives` DISABLE KEYS */;
/*!40000 ALTER TABLE `drives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dupe_groups`
--

DROP TABLE IF EXISTS `dupe_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dupe_groups` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Comments` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dupe_groups`
--

LOCK TABLES `dupe_groups` WRITE;
/*!40000 ALTER TABLE `dupe_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `dupe_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_blacklist`
--

DROP TABLE IF EXISTS `email_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_blacklist` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `UserID` int(10) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Time` datetime NOT NULL,
  `Comment` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_blacklist`
--

LOCK TABLES `email_blacklist` WRITE;
/*!40000 ALTER TABLE `email_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_albums`
--

DROP TABLE IF EXISTS `featured_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featured_albums` (
  `GroupID` int(10) NOT NULL DEFAULT '0',
  `ThreadID` int(10) NOT NULL DEFAULT '0',
  `Title` varchar(35) NOT NULL DEFAULT '',
  `Started` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Ended` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_albums`
--

LOCK TABLES `featured_albums` WRITE;
/*!40000 ALTER TABLE `featured_albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `featured_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_merch`
--

DROP TABLE IF EXISTS `featured_merch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featured_merch` (
  `ProductID` int(10) NOT NULL DEFAULT '0',
  `Title` varchar(35) NOT NULL DEFAULT '',
  `Image` varchar(255) NOT NULL DEFAULT '',
  `Started` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Ended` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ArtistID` int(10) unsigned DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_merch`
--

LOCK TABLES `featured_merch` WRITE;
/*!40000 ALTER TABLE `featured_merch` DISABLE KEYS */;
/*!40000 ALTER TABLE `featured_merch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums`
--

DROP TABLE IF EXISTS `forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `CategoryID` tinyint(2) NOT NULL DEFAULT '0',
  `Sort` int(6) unsigned NOT NULL,
  `Name` varchar(40) NOT NULL DEFAULT '',
  `Description` varchar(255) DEFAULT '',
  `MinClassRead` int(4) NOT NULL DEFAULT '0',
  `MinClassWrite` int(4) NOT NULL DEFAULT '0',
  `MinClassCreate` int(4) NOT NULL DEFAULT '0',
  `NumTopics` int(10) NOT NULL DEFAULT '0',
  `NumPosts` int(10) NOT NULL DEFAULT '0',
  `LastPostID` int(10) NOT NULL DEFAULT '0',
  `LastPostAuthorID` int(10) NOT NULL DEFAULT '0',
  `LastPostTopicID` int(10) NOT NULL DEFAULT '0',
  `LastPostTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `AutoLock` enum('0','1') DEFAULT '1',
  `AutoLockWeeks` int(3) unsigned NOT NULL DEFAULT '4',
  PRIMARY KEY (`ID`),
  KEY `Sort` (`Sort`),
  KEY `MinClassRead` (`MinClassRead`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums`
--

LOCK TABLES `forums` WRITE;
/*!40000 ALTER TABLE `forums` DISABLE KEYS */;
INSERT INTO `forums` VALUES (1,1,20,'Your Site','Totally rad forum',100,100,100,0,0,0,0,0,'0000-00-00 00:00:00','1',4),(2,5,30,'Chat','Expect this to fill up with spam',100,100,100,0,0,0,0,0,'0000-00-00 00:00:00','1',4),(3,10,40,'Help!','I fell down and I cant get up',100,100,100,0,0,0,0,0,'0000-00-00 00:00:00','1',4),(4,20,100,'Trash','Every thread ends up here eventually',100,500,500,0,0,0,0,0,'0000-00-00 00:00:00','1',4);
/*!40000 ALTER TABLE `forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_categories`
--

DROP TABLE IF EXISTS `forums_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_categories` (
  `ID` tinyint(2) NOT NULL AUTO_INCREMENT,
  `Name` varchar(40) NOT NULL DEFAULT '',
  `Sort` int(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `Sort` (`Sort`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_categories`
--

LOCK TABLES `forums_categories` WRITE;
/*!40000 ALTER TABLE `forums_categories` DISABLE KEYS */;
INSERT INTO `forums_categories` VALUES (1,'Site',1),(5,'Community',5),(8,'Music',8),(10,'Help',10),(20,'Trash',20);
/*!40000 ALTER TABLE `forums_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_last_read_topics`
--

DROP TABLE IF EXISTS `forums_last_read_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_last_read_topics` (
  `UserID` int(10) NOT NULL,
  `TopicID` int(10) NOT NULL,
  `PostID` int(10) NOT NULL,
  PRIMARY KEY (`UserID`,`TopicID`),
  KEY `TopicID` (`TopicID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_last_read_topics`
--

LOCK TABLES `forums_last_read_topics` WRITE;
/*!40000 ALTER TABLE `forums_last_read_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_last_read_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_polls`
--

DROP TABLE IF EXISTS `forums_polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_polls` (
  `TopicID` int(10) unsigned NOT NULL,
  `Question` varchar(255) NOT NULL,
  `Answers` text NOT NULL,
  `Featured` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Closed` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`TopicID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_polls`
--

LOCK TABLES `forums_polls` WRITE;
/*!40000 ALTER TABLE `forums_polls` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_polls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_polls_votes`
--

DROP TABLE IF EXISTS `forums_polls_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_polls_votes` (
  `TopicID` int(10) unsigned NOT NULL,
  `UserID` int(10) unsigned NOT NULL,
  `Vote` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`TopicID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_polls_votes`
--

LOCK TABLES `forums_polls_votes` WRITE;
/*!40000 ALTER TABLE `forums_polls_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_polls_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_posts`
--

DROP TABLE IF EXISTS `forums_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_posts` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `TopicID` int(10) NOT NULL,
  `AuthorID` int(10) NOT NULL,
  `AddedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Body` mediumtext,
  `EditedUserID` int(10) DEFAULT NULL,
  `EditedTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TopicID` (`TopicID`),
  KEY `AuthorID` (`AuthorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_posts`
--

LOCK TABLES `forums_posts` WRITE;
/*!40000 ALTER TABLE `forums_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_specific_rules`
--

DROP TABLE IF EXISTS `forums_specific_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_specific_rules` (
  `ForumID` int(6) unsigned DEFAULT NULL,
  `ThreadID` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_specific_rules`
--

LOCK TABLES `forums_specific_rules` WRITE;
/*!40000 ALTER TABLE `forums_specific_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_specific_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_topic_notes`
--

DROP TABLE IF EXISTS `forums_topic_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_topic_notes` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `TopicID` int(10) NOT NULL,
  `AuthorID` int(10) NOT NULL,
  `AddedTime` datetime NOT NULL,
  `Body` mediumtext,
  PRIMARY KEY (`ID`),
  KEY `TopicID` (`TopicID`),
  KEY `AuthorID` (`AuthorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_topic_notes`
--

LOCK TABLES `forums_topic_notes` WRITE;
/*!40000 ALTER TABLE `forums_topic_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_topic_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums_topics`
--

DROP TABLE IF EXISTS `forums_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums_topics` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Title` varchar(150) NOT NULL,
  `AuthorID` int(10) NOT NULL,
  `IsLocked` enum('0','1') NOT NULL DEFAULT '0',
  `IsSticky` enum('0','1') NOT NULL DEFAULT '0',
  `ForumID` int(3) NOT NULL,
  `NumPosts` int(10) NOT NULL DEFAULT '0',
  `LastPostID` int(10) NOT NULL,
  `LastPostTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LastPostAuthorID` int(10) NOT NULL,
  `StickyPostID` int(10) NOT NULL DEFAULT '0',
  `Ranking` tinyint(2) DEFAULT '0',
  `CreatedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `AuthorID` (`AuthorID`),
  KEY `ForumID` (`ForumID`),
  KEY `IsSticky` (`IsSticky`),
  KEY `LastPostID` (`LastPostID`),
  KEY `Title` (`Title`),
  KEY `CreatedTime` (`CreatedTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums_topics`
--

LOCK TABLES `forums_topics` WRITE;
/*!40000 ALTER TABLE `forums_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `forums_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friends` (
  `UserID` int(10) unsigned NOT NULL,
  `FriendID` int(10) unsigned NOT NULL,
  `Comment` text NOT NULL,
  PRIMARY KEY (`UserID`,`FriendID`),
  KEY `UserID` (`UserID`),
  KEY `FriendID` (`FriendID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geoip_country`
--

DROP TABLE IF EXISTS `geoip_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `geoip_country` (
  `StartIP` int(11) unsigned NOT NULL,
  `EndIP` int(11) unsigned NOT NULL,
  `Code` varchar(2) NOT NULL,
  PRIMARY KEY (`StartIP`,`EndIP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geoip_country`
--

LOCK TABLES `geoip_country` WRITE;
/*!40000 ALTER TABLE `geoip_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `geoip_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_log`
--

DROP TABLE IF EXISTS `group_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_log` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `GroupID` int(10) NOT NULL,
  `TorrentID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Info` mediumtext,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Hidden` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `GroupID` (`GroupID`),
  KEY `TorrentID` (`TorrentID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_log`
--

LOCK TABLES `group_log` WRITE;
/*!40000 ALTER TABLE `group_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invite_tree`
--

DROP TABLE IF EXISTS `invite_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invite_tree` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `InviterID` int(10) NOT NULL DEFAULT '0',
  `TreePosition` int(8) NOT NULL DEFAULT '1',
  `TreeID` int(10) NOT NULL DEFAULT '1',
  `TreeLevel` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`),
  KEY `InviterID` (`InviterID`),
  KEY `TreePosition` (`TreePosition`),
  KEY `TreeID` (`TreeID`),
  KEY `TreeLevel` (`TreeLevel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invite_tree`
--

LOCK TABLES `invite_tree` WRITE;
/*!40000 ALTER TABLE `invite_tree` DISABLE KEYS */;
/*!40000 ALTER TABLE `invite_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invites`
--

DROP TABLE IF EXISTS `invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invites` (
  `InviterID` int(10) NOT NULL DEFAULT '0',
  `InviteKey` char(32) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Reason` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`InviteKey`),
  KEY `Expires` (`Expires`),
  KEY `InviterID` (`InviterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invites`
--

LOCK TABLES `invites` WRITE;
/*!40000 ALTER TABLE `invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_bans`
--

DROP TABLE IF EXISTS `ip_bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_bans` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FromIP` int(11) unsigned NOT NULL,
  `ToIP` int(11) unsigned NOT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FromIP_2` (`FromIP`,`ToIP`),
  KEY `ToIP` (`ToIP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_bans`
--

LOCK TABLES `ip_bans` WRITE;
/*!40000 ALTER TABLE `ip_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `label_aliases`
--

DROP TABLE IF EXISTS `label_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `label_aliases` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `BadLabel` varchar(100) NOT NULL,
  `AliasLabel` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `BadLabel` (`BadLabel`),
  KEY `AliasLabel` (`AliasLabel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `label_aliases`
--

LOCK TABLES `label_aliases` WRITE;
/*!40000 ALTER TABLE `label_aliases` DISABLE KEYS */;
/*!40000 ALTER TABLE `label_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lastfm_users`
--

DROP TABLE IF EXISTS `lastfm_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lastfm_users` (
  `ID` int(10) unsigned NOT NULL,
  `Username` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lastfm_users`
--

LOCK TABLES `lastfm_users` WRITE;
/*!40000 ALTER TABLE `lastfm_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `lastfm_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_contest`
--

DROP TABLE IF EXISTS `library_contest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `library_contest` (
  `UserID` int(10) NOT NULL,
  `TorrentID` int(10) NOT NULL,
  `Points` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`,`TorrentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_contest`
--

LOCK TABLES `library_contest` WRITE;
/*!40000 ALTER TABLE `library_contest` DISABLE KEYS */;
/*!40000 ALTER TABLE `library_contest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Message` varchar(400) NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_attempts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `IP` varchar(15) NOT NULL,
  `LastAttempt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Attempts` int(10) unsigned NOT NULL,
  `BannedUntil` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Bans` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`),
  KEY `IP` (`IP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_info_hashes`
--

DROP TABLE IF EXISTS `new_info_hashes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_info_hashes` (
  `TorrentID` int(11) NOT NULL,
  `InfoHash` binary(20) DEFAULT NULL,
  PRIMARY KEY (`TorrentID`),
  KEY `InfoHash` (`InfoHash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_info_hashes`
--

LOCK TABLES `new_info_hashes` WRITE;
/*!40000 ALTER TABLE `new_info_hashes` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_info_hashes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Body` text NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocelot_query_times`
--

DROP TABLE IF EXISTS `ocelot_query_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocelot_query_times` (
  `buffer` enum('users','torrents','snatches','peers') NOT NULL,
  `starttime` datetime NOT NULL,
  `ocelotinstance` datetime NOT NULL,
  `querylength` int(11) NOT NULL,
  `timespent` int(11) NOT NULL,
  UNIQUE KEY `starttime` (`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocelot_query_times`
--

LOCK TABLES `ocelot_query_times` WRITE;
/*!40000 ALTER TABLE `ocelot_query_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocelot_query_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Level` int(10) unsigned NOT NULL,
  `Name` varchar(25) NOT NULL,
  `Values` text NOT NULL,
  `DisplayStaff` enum('0','1') NOT NULL DEFAULT '0',
  `PermittedForums` varchar(150) NOT NULL DEFAULT '',
  `Secondary` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Level` (`Level`),
  KEY `DisplayStaff` (`DisplayStaff`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (2,100,'User','a:7:{s:10:\"site_leech\";i:1;s:11:\"site_upload\";i:1;s:9:\"site_vote\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:14:\"site_edit_wiki\";i:1;s:19:\"torrents_add_artist\";i:1;}','0','',0),(3,150,'Member','a:10:{s:10:\"site_leech\";i:1;s:11:\"site_upload\";i:1;s:9:\"site_vote\";i:1;s:20:\"site_submit_requests\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:20:\"site_collages_manage\";i:1;s:19:\"site_make_bookmarks\";i:1;s:14:\"site_edit_wiki\";i:1;s:19:\"torrents_add_artist\";i:1;}','0','',0),(4,200,'Power User','a:14:{s:10:\"site_leech\";i:1;s:11:\"site_upload\";i:1;s:9:\"site_vote\";i:1;s:20:\"site_submit_requests\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:20:\"site_torrents_notify\";i:1;s:20:\"site_collages_create\";i:1;s:20:\"site_collages_manage\";i:1;s:19:\"site_make_bookmarks\";i:1;s:14:\"site_edit_wiki\";i:1;s:14:\"zip_downloader\";i:1;s:19:\"forums_polls_create\";i:1;s:19:\"torrents_add_artist\";i:1;} ','0','',0),(5,250,'Elite','a:18:{s:10:\"site_leech\";i:1;s:11:\"site_upload\";i:1;s:9:\"site_vote\";i:1;s:20:\"site_submit_requests\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:20:\"site_torrents_notify\";i:1;s:20:\"site_collages_create\";i:1;s:20:\"site_collages_manage\";i:1;s:19:\"site_advanced_top10\";i:1;s:19:\"site_make_bookmarks\";i:1;s:14:\"site_edit_wiki\";i:1;s:15:\"site_delete_tag\";i:1;s:14:\"zip_downloader\";i:1;s:19:\"forums_polls_create\";i:1;s:13:\"torrents_edit\";i:1;s:19:\"torrents_add_artist\";i:1;s:17:\"admin_clear_cache\";i:1;}','0','',0),(11,800,'Moderator','a:89:{s:26:\"admin_advanced_user_search\";i:1;s:17:\"admin_clear_cache\";i:1;s:18:\"admin_create_users\";i:1;s:9:\"admin_dnu\";i:1;s:15:\"admin_donor_log\";i:1;s:17:\"admin_login_watch\";i:1;s:17:\"admin_manage_blog\";i:1;s:19:\"admin_manage_ipbans\";i:1;s:17:\"admin_manage_news\";i:1;s:18:\"admin_manage_polls\";i:1;s:17:\"admin_manage_wiki\";i:1;s:13:\"admin_reports\";i:1;s:23:\"artist_edit_vanityhouse\";i:1;s:13:\"edit_unknowns\";i:1;s:19:\"forums_polls_create\";i:1;s:21:\"forums_polls_moderate\";i:1;s:12:\"project_team\";i:1;s:17:\"site_admin_forums\";i:1;s:20:\"site_advanced_search\";i:1;s:19:\"site_advanced_top10\";i:1;s:16:\"site_album_votes\";i:1;s:22:\"site_can_invite_always\";i:1;s:20:\"site_collages_create\";i:1;s:20:\"site_collages_delete\";i:1;s:20:\"site_collages_manage\";i:1;s:22:\"site_collages_personal\";i:1;s:21:\"site_collages_recover\";i:1;s:28:\"site_collages_renamepersonal\";i:1;s:23:\"site_collages_subscribe\";i:1;s:18:\"site_delete_artist\";i:1;s:15:\"site_delete_tag\";i:1;s:23:\"site_disable_ip_history\";i:1;s:14:\"site_edit_wiki\";i:1;s:23:\"site_forums_double_post\";i:1;s:10:\"site_leech\";i:1;s:19:\"site_make_bookmarks\";i:1;s:27:\"site_manage_recommendations\";i:1;s:20:\"site_moderate_forums\";i:1;s:22:\"site_moderate_requests\";i:1;s:17:\"site_proxy_images\";i:1;s:18:\"site_recommend_own\";i:1;s:16:\"site_search_many\";i:1;s:27:\"site_send_unlimited_invites\";i:1;s:20:\"site_submit_requests\";i:1;s:21:\"site_tag_aliases_read\";i:1;s:10:\"site_top10\";i:1;s:20:\"site_torrents_notify\";i:1;s:11:\"site_upload\";i:1;s:14:\"site_view_flow\";i:1;s:18:\"site_view_full_log\";i:1;s:28:\"site_view_torrent_snatchlist\";i:1;s:9:\"site_vote\";i:1;s:19:\"torrents_add_artist\";i:1;s:15:\"torrents_delete\";i:1;s:20:\"torrents_delete_fast\";i:1;s:13:\"torrents_edit\";i:1;s:25:\"torrents_edit_vanityhouse\";i:1;s:19:\"torrents_fix_ghosts\";i:1;s:18:\"torrents_freeleech\";i:1;s:17:\"torrents_hide_dnu\";i:1;s:20:\"torrents_search_fast\";i:1;s:18:\"users_delete_users\";i:1;s:17:\"users_disable_any\";i:1;s:19:\"users_disable_posts\";i:1;s:19:\"users_disable_users\";i:1;s:18:\"users_edit_avatars\";i:1;s:18:\"users_edit_invites\";i:1;s:20:\"users_edit_own_ratio\";i:1;s:19:\"users_edit_password\";i:1;s:19:\"users_edit_profiles\";i:1;s:16:\"users_edit_ratio\";i:1;s:21:\"users_edit_reset_keys\";i:1;s:17:\"users_edit_titles\";i:1;s:16:\"users_give_donor\";i:1;s:12:\"users_logout\";i:1;s:20:\"users_make_invisible\";i:1;s:9:\"users_mod\";i:1;s:23:\"users_override_paranoia\";i:1;s:19:\"users_promote_below\";i:1;s:20:\"users_reset_own_keys\";i:1;s:10:\"users_warn\";i:1;s:16:\"users_view_email\";i:1;s:18:\"users_view_friends\";i:1;s:18:\"users_view_invites\";i:1;s:14:\"users_view_ips\";i:1;s:15:\"users_view_keys\";i:1;s:20:\"users_view_seedleech\";i:1;s:19:\"users_view_uploaded\";i:1;s:14:\"zip_downloader\";i:1;}','1','',0),(15,1000,'Sysop','a:100:{s:10:\"site_leech\";i:1;s:11:\"site_upload\";i:1;s:9:\"site_vote\";i:1;s:20:\"site_submit_requests\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:19:\"site_advanced_top10\";i:1;s:16:\"site_album_votes\";i:1;s:20:\"site_torrents_notify\";i:1;s:20:\"site_collages_create\";i:1;s:20:\"site_collages_manage\";i:1;s:20:\"site_collages_delete\";i:1;s:23:\"site_collages_subscribe\";i:1;s:22:\"site_collages_personal\";i:1;s:28:\"site_collages_renamepersonal\";i:1;s:19:\"site_make_bookmarks\";i:1;s:14:\"site_edit_wiki\";i:1;s:22:\"site_can_invite_always\";i:1;s:27:\"site_send_unlimited_invites\";i:1;s:22:\"site_moderate_requests\";i:1;s:18:\"site_delete_artist\";i:1;s:20:\"site_moderate_forums\";i:1;s:17:\"site_admin_forums\";i:1;s:23:\"site_forums_double_post\";i:1;s:14:\"site_view_flow\";i:1;s:18:\"site_view_full_log\";i:1;s:28:\"site_view_torrent_snatchlist\";i:1;s:18:\"site_recommend_own\";i:1;s:27:\"site_manage_recommendations\";i:1;s:15:\"site_delete_tag\";i:1;s:23:\"site_disable_ip_history\";i:1;s:14:\"zip_downloader\";i:1;s:10:\"site_debug\";i:1;s:17:\"site_proxy_images\";i:1;s:16:\"site_search_many\";i:1;s:20:\"users_edit_usernames\";i:1;s:16:\"users_edit_ratio\";i:1;s:20:\"users_edit_own_ratio\";i:1;s:17:\"users_edit_titles\";i:1;s:18:\"users_edit_avatars\";i:1;s:18:\"users_edit_invites\";i:1;s:22:\"users_edit_watch_hours\";i:1;s:21:\"users_edit_reset_keys\";i:1;s:19:\"users_edit_profiles\";i:1;s:18:\"users_view_friends\";i:1;s:20:\"users_reset_own_keys\";i:1;s:19:\"users_edit_password\";i:1;s:19:\"users_promote_below\";i:1;s:16:\"users_promote_to\";i:1;s:16:\"users_give_donor\";i:1;s:10:\"users_warn\";i:1;s:19:\"users_disable_users\";i:1;s:19:\"users_disable_posts\";i:1;s:17:\"users_disable_any\";i:1;s:18:\"users_delete_users\";i:1;s:18:\"users_view_invites\";i:1;s:20:\"users_view_seedleech\";i:1;s:19:\"users_view_uploaded\";i:1;s:15:\"users_view_keys\";i:1;s:14:\"users_view_ips\";i:1;s:16:\"users_view_email\";i:1;s:18:\"users_invite_notes\";i:1;s:23:\"users_override_paranoia\";i:1;s:12:\"users_logout\";i:1;s:20:\"users_make_invisible\";i:1;s:9:\"users_mod\";i:1;s:13:\"torrents_edit\";i:1;s:15:\"torrents_delete\";i:1;s:20:\"torrents_delete_fast\";i:1;s:18:\"torrents_freeleech\";i:1;s:20:\"torrents_search_fast\";i:1;s:17:\"torrents_hide_dnu\";i:1;s:19:\"torrents_fix_ghosts\";i:1;s:17:\"admin_manage_news\";i:1;s:17:\"admin_manage_blog\";i:1;s:18:\"admin_manage_polls\";i:1;s:19:\"admin_manage_forums\";i:1;s:16:\"admin_manage_fls\";i:1;s:13:\"admin_reports\";i:1;s:26:\"admin_advanced_user_search\";i:1;s:18:\"admin_create_users\";i:1;s:15:\"admin_donor_log\";i:1;s:19:\"admin_manage_ipbans\";i:1;s:9:\"admin_dnu\";i:1;s:17:\"admin_clear_cache\";i:1;s:15:\"admin_whitelist\";i:1;s:24:\"admin_manage_permissions\";i:1;s:14:\"admin_schedule\";i:1;s:17:\"admin_login_watch\";i:1;s:17:\"admin_manage_wiki\";i:1;s:18:\"admin_update_geoip\";i:1;s:21:\"site_collages_recover\";i:1;s:19:\"torrents_add_artist\";i:1;s:13:\"edit_unknowns\";i:1;s:19:\"forums_polls_create\";i:1;s:21:\"forums_polls_moderate\";i:1;s:12:\"project_team\";i:1;s:25:\"torrents_edit_vanityhouse\";i:1;s:23:\"artist_edit_vanityhouse\";i:1;s:21:\"site_tag_aliases_read\";i:1;}','1','',0),(19,201,'Artist','a:9:{s:10:\"site_leech\";s:1:\"1\";s:11:\"site_upload\";s:1:\"1\";s:9:\"site_vote\";s:1:\"1\";s:20:\"site_submit_requests\";s:1:\"1\";s:20:\"site_advanced_search\";s:1:\"1\";s:10:\"site_top10\";s:1:\"1\";s:19:\"site_make_bookmarks\";s:1:\"1\";s:14:\"site_edit_wiki\";s:1:\"1\";s:18:\"site_recommend_own\";s:1:\"1\";}','0','',0),(20,202,'Donor','a:9:{s:9:\"site_vote\";i:1;s:20:\"site_submit_requests\";i:1;s:20:\"site_advanced_search\";i:1;s:10:\"site_top10\";i:1;s:20:\"site_torrents_notify\";i:1;s:20:\"site_collages_create\";i:1;s:20:\"site_collages_manage\";i:1;s:14:\"zip_downloader\";i:1;s:19:\"forums_polls_create\";i:1;}','0','',0);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pm_conversations`
--

DROP TABLE IF EXISTS `pm_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm_conversations` (
  `ID` int(12) NOT NULL AUTO_INCREMENT,
  `Subject` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pm_conversations`
--

LOCK TABLES `pm_conversations` WRITE;
/*!40000 ALTER TABLE `pm_conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `pm_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pm_conversations_users`
--

DROP TABLE IF EXISTS `pm_conversations_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm_conversations_users` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `ConvID` int(12) NOT NULL DEFAULT '0',
  `InInbox` enum('1','0') NOT NULL,
  `InSentbox` enum('1','0') NOT NULL,
  `SentDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ReceivedDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `UnRead` enum('1','0') NOT NULL DEFAULT '1',
  `Sticky` enum('1','0') NOT NULL DEFAULT '0',
  `ForwardedTo` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`,`ConvID`),
  KEY `InInbox` (`InInbox`),
  KEY `InSentbox` (`InSentbox`),
  KEY `ConvID` (`ConvID`),
  KEY `UserID` (`UserID`),
  KEY `SentDate` (`SentDate`),
  KEY `ReceivedDate` (`ReceivedDate`),
  KEY `Sticky` (`Sticky`),
  KEY `ForwardedTo` (`ForwardedTo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pm_conversations_users`
--

LOCK TABLES `pm_conversations_users` WRITE;
/*!40000 ALTER TABLE `pm_conversations_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `pm_conversations_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pm_messages`
--

DROP TABLE IF EXISTS `pm_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm_messages` (
  `ID` int(12) NOT NULL AUTO_INCREMENT,
  `ConvID` int(12) NOT NULL DEFAULT '0',
  `SentDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SenderID` int(10) NOT NULL DEFAULT '0',
  `Body` text,
  PRIMARY KEY (`ID`),
  KEY `ConvID` (`ConvID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pm_messages`
--

LOCK TABLES `pm_messages` WRITE;
/*!40000 ALTER TABLE `pm_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `pm_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `push_notifications_usage`
--

DROP TABLE IF EXISTS `push_notifications_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `push_notifications_usage` (
  `PushService` varchar(10) NOT NULL,
  `TimesUsed` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PushService`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `push_notifications_usage`
--

LOCK TABLES `push_notifications_usage` WRITE;
/*!40000 ALTER TABLE `push_notifications_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `push_notifications_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  `ThingID` int(10) unsigned NOT NULL DEFAULT '0',
  `Type` varchar(30) DEFAULT NULL,
  `Comment` text,
  `ResolverID` int(10) unsigned NOT NULL DEFAULT '0',
  `Status` enum('New','InProgress','Resolved') DEFAULT 'New',
  `ResolvedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ReportedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Reason` text NOT NULL,
  `ClaimerID` int(10) unsigned NOT NULL DEFAULT '0',
  `Notes` text NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Status` (`Status`),
  KEY `Type` (`Type`),
  KEY `ResolvedTime` (`ResolvedTime`),
  KEY `ResolverID` (`ResolverID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports_email_blacklist`
--

DROP TABLE IF EXISTS `reports_email_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_email_blacklist` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(4) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Checked` tinyint(4) NOT NULL DEFAULT '0',
  `ResolverID` int(10) DEFAULT '0',
  `Email` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `Time` (`Time`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports_email_blacklist`
--

LOCK TABLES `reports_email_blacklist` WRITE;
/*!40000 ALTER TABLE `reports_email_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports_email_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reportsv2`
--

DROP TABLE IF EXISTS `reportsv2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reportsv2` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ReporterID` int(10) unsigned NOT NULL DEFAULT '0',
  `TorrentID` int(10) unsigned NOT NULL DEFAULT '0',
  `Type` varchar(20) DEFAULT '',
  `UserComment` text,
  `ResolverID` int(10) unsigned NOT NULL DEFAULT '0',
  `Status` enum('New','InProgress','Resolved') DEFAULT 'New',
  `ReportedTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LastChangeTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ModComment` text,
  `Track` text,
  `Image` text,
  `ExtraID` text,
  `Link` text,
  `LogMessage` text,
  PRIMARY KEY (`ID`),
  KEY `Status` (`Status`),
  KEY `Type` (`Type`(1)),
  KEY `LastChangeTime` (`LastChangeTime`),
  KEY `TorrentID` (`TorrentID`),
  KEY `ResolverID` (`ResolverID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reportsv2`
--

LOCK TABLES `reportsv2` WRITE;
/*!40000 ALTER TABLE `reportsv2` DISABLE KEYS */;
/*!40000 ALTER TABLE `reportsv2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL,
  `LastVote` datetime DEFAULT NULL,
  `CategoryID` int(3) NOT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `Image` varchar(255) DEFAULT NULL,
  `Description` text NOT NULL,
  `ReleaseType` tinyint(2) DEFAULT NULL,
  `CatalogueNumber` varchar(50) NOT NULL,
  `BitrateList` varchar(255) DEFAULT NULL,
  `FormatList` varchar(255) DEFAULT NULL,
  `MediaList` varchar(255) DEFAULT NULL,
  `LogCue` varchar(20) DEFAULT NULL,
  `FillerID` int(10) unsigned NOT NULL DEFAULT '0',
  `TorrentID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeFilled` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Visible` binary(1) NOT NULL DEFAULT '1',
  `RecordLabel` varchar(80) DEFAULT NULL,
  `GroupID` int(10) DEFAULT NULL,
  `OCLC` varchar(55) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `Userid` (`UserID`),
  KEY `Name` (`Title`),
  KEY `Filled` (`TorrentID`),
  KEY `FillerID` (`FillerID`),
  KEY `TimeAdded` (`TimeAdded`),
  KEY `Year` (`Year`),
  KEY `TimeFilled` (`TimeFilled`),
  KEY `LastVote` (`LastVote`),
  KEY `GroupID` (`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests_artists`
--

DROP TABLE IF EXISTS `requests_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests_artists` (
  `RequestID` int(10) unsigned NOT NULL,
  `ArtistID` int(10) NOT NULL,
  `AliasID` int(10) NOT NULL,
  `Importance` enum('1','2','3','4','5','6','7') DEFAULT NULL,
  PRIMARY KEY (`RequestID`,`AliasID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests_artists`
--

LOCK TABLES `requests_artists` WRITE;
/*!40000 ALTER TABLE `requests_artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests_tags`
--

DROP TABLE IF EXISTS `requests_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests_tags` (
  `TagID` int(10) NOT NULL DEFAULT '0',
  `RequestID` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TagID`,`RequestID`),
  KEY `TagID` (`TagID`),
  KEY `RequestID` (`RequestID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests_tags`
--

LOCK TABLES `requests_tags` WRITE;
/*!40000 ALTER TABLE `requests_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests_votes`
--

DROP TABLE IF EXISTS `requests_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests_votes` (
  `RequestID` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Bounty` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`RequestID`,`UserID`),
  KEY `RequestID` (`RequestID`),
  KEY `UserID` (`UserID`),
  KEY `Bounty` (`Bounty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests_votes`
--

LOCK TABLES `requests_votes` WRITE;
/*!40000 ALTER TABLE `requests_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `NextHour` int(2) NOT NULL DEFAULT '0',
  `NextDay` int(2) NOT NULL DEFAULT '0',
  `NextBiWeekly` int(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (0,0,0);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_history`
--

DROP TABLE IF EXISTS `site_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_history` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) DEFAULT NULL,
  `Url` varchar(255) NOT NULL DEFAULT '',
  `Category` tinyint(2) DEFAULT NULL,
  `SubCategory` tinyint(2) DEFAULT NULL,
  `Tags` mediumtext,
  `AddedBy` int(10) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Body` mediumtext,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_history`
--

LOCK TABLES `site_history` WRITE;
/*!40000 ALTER TABLE `site_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_a`
--

DROP TABLE IF EXISTS `sphinx_a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_a` (
  `gid` int(11) DEFAULT NULL,
  `aname` text,
  KEY `gid` (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_a`
--

LOCK TABLES `sphinx_a` WRITE;
/*!40000 ALTER TABLE `sphinx_a` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_a` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_delta`
--

DROP TABLE IF EXISTS `sphinx_delta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_delta` (
  `ID` int(10) NOT NULL,
  `GroupID` int(11) NOT NULL DEFAULT '0',
  `GroupName` varchar(255) DEFAULT NULL,
  `ArtistName` varchar(2048) DEFAULT NULL,
  `TagList` varchar(728) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `CatalogueNumber` varchar(50) DEFAULT NULL,
  `RecordLabel` varchar(50) DEFAULT NULL,
  `CategoryID` tinyint(2) DEFAULT NULL,
  `Time` int(12) DEFAULT NULL,
  `ReleaseType` tinyint(2) DEFAULT NULL,
  `Size` bigint(20) DEFAULT NULL,
  `Snatched` int(10) DEFAULT NULL,
  `Seeders` int(10) DEFAULT NULL,
  `Leechers` int(10) DEFAULT NULL,
  `LogScore` int(3) DEFAULT NULL,
  `Scene` tinyint(1) NOT NULL DEFAULT '0',
  `VanityHouse` tinyint(1) NOT NULL DEFAULT '0',
  `HasLog` tinyint(1) DEFAULT NULL,
  `HasCue` tinyint(1) DEFAULT NULL,
  `FreeTorrent` tinyint(1) DEFAULT NULL,
  `Media` varchar(255) DEFAULT NULL,
  `Format` varchar(255) DEFAULT NULL,
  `Encoding` varchar(255) DEFAULT NULL,
  `RemasterYear` varchar(50) NOT NULL DEFAULT '',
  `RemasterTitle` varchar(512) DEFAULT NULL,
  `RemasterRecordLabel` varchar(50) DEFAULT NULL,
  `RemasterCatalogueNumber` varchar(50) DEFAULT NULL,
  `FileList` mediumtext,
  `Description` text,
  `VoteScore` float NOT NULL DEFAULT '0',
  `LastChanged` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `GroupID` (`GroupID`),
  KEY `Size` (`Size`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_delta`
--

LOCK TABLES `sphinx_delta` WRITE;
/*!40000 ALTER TABLE `sphinx_delta` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_delta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_hash`
--

DROP TABLE IF EXISTS `sphinx_hash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_hash` (
  `ID` int(10) NOT NULL,
  `GroupName` varchar(255) DEFAULT NULL,
  `ArtistName` varchar(2048) DEFAULT NULL,
  `TagList` varchar(728) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `CatalogueNumber` varchar(50) DEFAULT NULL,
  `RecordLabel` varchar(50) DEFAULT NULL,
  `CategoryID` tinyint(2) DEFAULT NULL,
  `Time` int(12) DEFAULT NULL,
  `ReleaseType` tinyint(2) DEFAULT NULL,
  `Size` bigint(20) DEFAULT NULL,
  `Snatched` int(10) DEFAULT NULL,
  `Seeders` int(10) DEFAULT NULL,
  `Leechers` int(10) DEFAULT NULL,
  `LogScore` int(3) DEFAULT NULL,
  `Scene` tinyint(1) NOT NULL DEFAULT '0',
  `VanityHouse` tinyint(1) NOT NULL DEFAULT '0',
  `HasLog` tinyint(1) DEFAULT NULL,
  `HasCue` tinyint(1) DEFAULT NULL,
  `FreeTorrent` tinyint(1) DEFAULT NULL,
  `Media` varchar(255) DEFAULT NULL,
  `Format` varchar(255) DEFAULT NULL,
  `Encoding` varchar(255) DEFAULT NULL,
  `RemasterYear` int(4) DEFAULT NULL,
  `RemasterTitle` varchar(512) DEFAULT NULL,
  `RemasterRecordLabel` varchar(50) DEFAULT NULL,
  `RemasterCatalogueNumber` varchar(50) DEFAULT NULL,
  `FileList` mediumtext,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_hash`
--

LOCK TABLES `sphinx_hash` WRITE;
/*!40000 ALTER TABLE `sphinx_hash` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_hash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_index_last_pos`
--

DROP TABLE IF EXISTS `sphinx_index_last_pos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_index_last_pos` (
  `Type` varchar(16) NOT NULL DEFAULT '',
  `ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_index_last_pos`
--

LOCK TABLES `sphinx_index_last_pos` WRITE;
/*!40000 ALTER TABLE `sphinx_index_last_pos` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_index_last_pos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_requests`
--

DROP TABLE IF EXISTS `sphinx_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_requests` (
  `ID` int(10) unsigned NOT NULL,
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeAdded` int(12) unsigned NOT NULL,
  `LastVote` int(12) unsigned NOT NULL,
  `CategoryID` int(3) NOT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `ArtistList` varchar(2048) DEFAULT NULL,
  `ReleaseType` tinyint(2) DEFAULT NULL,
  `CatalogueNumber` varchar(50) NOT NULL,
  `BitrateList` varchar(255) DEFAULT NULL,
  `FormatList` varchar(255) DEFAULT NULL,
  `MediaList` varchar(255) DEFAULT NULL,
  `LogCue` varchar(20) DEFAULT NULL,
  `FillerID` int(10) unsigned NOT NULL DEFAULT '0',
  `TorrentID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeFilled` int(12) unsigned NOT NULL,
  `Visible` binary(1) NOT NULL DEFAULT '1',
  `Bounty` bigint(20) unsigned NOT NULL DEFAULT '0',
  `Votes` int(10) unsigned NOT NULL DEFAULT '0',
  `RecordLabel` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Userid` (`UserID`),
  KEY `Name` (`Title`),
  KEY `Filled` (`TorrentID`),
  KEY `FillerID` (`FillerID`),
  KEY `TimeAdded` (`TimeAdded`),
  KEY `Year` (`Year`),
  KEY `TimeFilled` (`TimeFilled`),
  KEY `LastVote` (`LastVote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_requests`
--

LOCK TABLES `sphinx_requests` WRITE;
/*!40000 ALTER TABLE `sphinx_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_requests_delta`
--

DROP TABLE IF EXISTS `sphinx_requests_delta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_requests_delta` (
  `ID` int(10) unsigned NOT NULL,
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeAdded` int(12) unsigned DEFAULT NULL,
  `LastVote` int(12) unsigned DEFAULT NULL,
  `CategoryID` tinyint(4) DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `TagList` varchar(728) NOT NULL DEFAULT '',
  `Year` int(4) DEFAULT NULL,
  `ArtistList` varchar(2048) DEFAULT NULL,
  `ReleaseType` tinyint(2) DEFAULT NULL,
  `CatalogueNumber` varchar(50) DEFAULT NULL,
  `BitrateList` varchar(255) DEFAULT NULL,
  `FormatList` varchar(255) DEFAULT NULL,
  `MediaList` varchar(255) DEFAULT NULL,
  `LogCue` varchar(20) DEFAULT NULL,
  `FillerID` int(10) unsigned NOT NULL DEFAULT '0',
  `TorrentID` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeFilled` int(12) unsigned DEFAULT NULL,
  `Visible` binary(1) NOT NULL DEFAULT '1',
  `Bounty` bigint(20) unsigned NOT NULL DEFAULT '0',
  `Votes` int(10) unsigned NOT NULL DEFAULT '0',
  `RecordLabel` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Userid` (`UserID`),
  KEY `Name` (`Title`),
  KEY `Filled` (`TorrentID`),
  KEY `FillerID` (`FillerID`),
  KEY `TimeAdded` (`TimeAdded`),
  KEY `Year` (`Year`),
  KEY `TimeFilled` (`TimeFilled`),
  KEY `LastVote` (`LastVote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_requests_delta`
--

LOCK TABLES `sphinx_requests_delta` WRITE;
/*!40000 ALTER TABLE `sphinx_requests_delta` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_requests_delta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_t`
--

DROP TABLE IF EXISTS `sphinx_t`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_t` (
  `id` int(11) NOT NULL,
  `gid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `size` bigint(20) NOT NULL,
  `snatched` int(11) NOT NULL,
  `seeders` int(11) NOT NULL,
  `leechers` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `logscore` smallint(6) NOT NULL,
  `scene` tinyint(4) NOT NULL,
  `haslog` tinyint(4) NOT NULL,
  `hascue` tinyint(4) NOT NULL,
  `freetorrent` tinyint(4) NOT NULL,
  `media` varchar(15) NOT NULL,
  `format` varchar(15) NOT NULL,
  `encoding` varchar(30) NOT NULL,
  `remyear` smallint(6) NOT NULL,
  `remtitle` varchar(80) NOT NULL,
  `remrlabel` varchar(80) NOT NULL,
  `remcnumber` varchar(80) NOT NULL,
  `filelist` mediumtext,
  `remident` int(10) unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `gid_remident` (`gid`,`remident`),
  KEY `format` (`format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_t`
--

LOCK TABLES `sphinx_t` WRITE;
/*!40000 ALTER TABLE `sphinx_t` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_t` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sphinx_tg`
--

DROP TABLE IF EXISTS `sphinx_tg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_tg` (
  `id` int(11) NOT NULL,
  `name` varchar(300) DEFAULT NULL,
  `tags` varchar(500) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `rlabel` varchar(80) DEFAULT NULL,
  `cnumber` varchar(80) DEFAULT NULL,
  `catid` smallint(6) DEFAULT NULL,
  `reltype` smallint(6) DEFAULT NULL,
  `vanityhouse` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sphinx_tg`
--

LOCK TABLES `sphinx_tg` WRITE;
/*!40000 ALTER TABLE `sphinx_tg` DISABLE KEYS */;
/*!40000 ALTER TABLE `sphinx_tg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_answers`
--

DROP TABLE IF EXISTS `staff_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_answers` (
  `QuestionID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Answer` mediumtext,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`QuestionID`,`UserID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_answers`
--

LOCK TABLES `staff_answers` WRITE;
/*!40000 ALTER TABLE `staff_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_blog`
--

DROP TABLE IF EXISTS `staff_blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_blog` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Body` text NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_blog`
--

LOCK TABLES `staff_blog` WRITE;
/*!40000 ALTER TABLE `staff_blog` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_blog_visits`
--

DROP TABLE IF EXISTS `staff_blog_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_blog_visits` (
  `UserID` int(10) unsigned NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `UserID` (`UserID`),
  CONSTRAINT `staff_blog_visits_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_blog_visits`
--

LOCK TABLES `staff_blog_visits` WRITE;
/*!40000 ALTER TABLE `staff_blog_visits` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_blog_visits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_ignored_questions`
--

DROP TABLE IF EXISTS `staff_ignored_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_ignored_questions` (
  `QuestionID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  PRIMARY KEY (`QuestionID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_ignored_questions`
--

LOCK TABLES `staff_ignored_questions` WRITE;
/*!40000 ALTER TABLE `staff_ignored_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_ignored_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_pm_conversations`
--

DROP TABLE IF EXISTS `staff_pm_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_pm_conversations` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Subject` text,
  `UserID` int(11) DEFAULT NULL,
  `Status` enum('Open','Unanswered','Resolved') DEFAULT NULL,
  `Level` int(11) DEFAULT NULL,
  `AssignedToUser` int(11) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Unread` tinyint(1) DEFAULT NULL,
  `ResolverID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `StatusAssigned` (`Status`,`AssignedToUser`),
  KEY `StatusLevel` (`Status`,`Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_pm_conversations`
--

LOCK TABLES `staff_pm_conversations` WRITE;
/*!40000 ALTER TABLE `staff_pm_conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_pm_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_pm_messages`
--

DROP TABLE IF EXISTS `staff_pm_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_pm_messages` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `SentDate` datetime DEFAULT NULL,
  `Message` text,
  `ConvID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_pm_messages`
--

LOCK TABLES `staff_pm_messages` WRITE;
/*!40000 ALTER TABLE `staff_pm_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_pm_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_pm_responses`
--

DROP TABLE IF EXISTS `staff_pm_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_pm_responses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Message` text,
  `Name` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_pm_responses`
--

LOCK TABLES `staff_pm_responses` WRITE;
/*!40000 ALTER TABLE `staff_pm_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_pm_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `styles_backup`
--

DROP TABLE IF EXISTS `styles_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `styles_backup` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `StyleID` int(10) DEFAULT NULL,
  `StyleURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  KEY `StyleURL` (`StyleURL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `styles_backup`
--

LOCK TABLES `styles_backup` WRITE;
/*!40000 ALTER TABLE `styles_backup` DISABLE KEYS */;
/*!40000 ALTER TABLE `styles_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stylesheets`
--

DROP TABLE IF EXISTS `stylesheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stylesheets` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Default` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stylesheets`
--

LOCK TABLES `stylesheets` WRITE;
/*!40000 ALTER TABLE `stylesheets` DISABLE KEYS */;
INSERT INTO `stylesheets` VALUES (2,'Layer cake','Grey stylesheet by Emm','0'),(9,'Proton','Proton by Protiek','0'),(21,'postmod','Upgrade on anorex','1');
/*!40000 ALTER TABLE `stylesheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag_aliases`
--

DROP TABLE IF EXISTS `tag_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_aliases` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `BadTag` varchar(30) DEFAULT NULL,
  `AliasTag` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `BadTag` (`BadTag`),
  KEY `AliasTag` (`AliasTag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_aliases`
--

LOCK TABLES `tag_aliases` WRITE;
/*!40000 ALTER TABLE `tag_aliases` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `TagType` enum('genre','other') NOT NULL DEFAULT 'other',
  `Uses` int(12) NOT NULL DEFAULT '1',
  `UserID` int(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_2` (`Name`),
  KEY `TagType` (`TagType`),
  KEY `Uses` (`Uses`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'rock','genre',0,1),(2,'pop','genre',0,1),(3,'female.fronted.symphonic.death.metal','genre',0,1);
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top10_history`
--

DROP TABLE IF EXISTS `top10_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top10_history` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Type` enum('Daily','Weekly') DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top10_history`
--

LOCK TABLES `top10_history` WRITE;
/*!40000 ALTER TABLE `top10_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `top10_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top10_history_torrents`
--

DROP TABLE IF EXISTS `top10_history_torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top10_history_torrents` (
  `HistoryID` int(10) NOT NULL DEFAULT '0',
  `Rank` tinyint(2) NOT NULL DEFAULT '0',
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `TitleString` varchar(150) NOT NULL DEFAULT '',
  `TagString` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top10_history_torrents`
--

LOCK TABLES `top10_history_torrents` WRITE;
/*!40000 ALTER TABLE `top10_history_torrents` DISABLE KEYS */;
/*!40000 ALTER TABLE `top10_history_torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_snatchers`
--

DROP TABLE IF EXISTS `top_snatchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_snatchers` (
  `UserID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_snatchers`
--

LOCK TABLES `top_snatchers` WRITE;
/*!40000 ALTER TABLE `top_snatchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_snatchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents`
--

DROP TABLE IF EXISTS `torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `GroupID` int(10) NOT NULL,
  `UserID` int(10) DEFAULT NULL,
  `Media` varchar(20) DEFAULT NULL,
  `Format` varchar(10) DEFAULT NULL,
  `Encoding` varchar(15) DEFAULT NULL,
  `Remastered` enum('0','1') NOT NULL DEFAULT '0',
  `RemasterYear` int(4) DEFAULT NULL,
  `RemasterTitle` varchar(80) NOT NULL DEFAULT '',
  `RemasterCatalogueNumber` varchar(80) NOT NULL DEFAULT '',
  `RemasterRecordLabel` varchar(80) NOT NULL DEFAULT '',
  `Scene` enum('0','1') NOT NULL DEFAULT '0',
  `HasLog` enum('0','1') NOT NULL DEFAULT '0',
  `HasCue` enum('0','1') NOT NULL DEFAULT '0',
  `LogScore` int(6) NOT NULL DEFAULT '0',
  `info_hash` blob NOT NULL,
  `FileCount` int(6) NOT NULL,
  `FileList` mediumtext NOT NULL,
  `FilePath` varchar(255) NOT NULL DEFAULT '',
  `Size` bigint(12) NOT NULL,
  `Leechers` int(6) NOT NULL DEFAULT '0',
  `Seeders` int(6) NOT NULL DEFAULT '0',
  `last_action` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `FreeTorrent` enum('0','1','2') NOT NULL DEFAULT '0',
  `FreeLeechType` enum('0','1','2','3') NOT NULL DEFAULT '0',
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Description` text,
  `Snatched` int(10) unsigned NOT NULL DEFAULT '0',
  `balance` bigint(20) NOT NULL DEFAULT '0',
  `LastReseedRequest` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TranscodedFrom` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `InfoHash` (`info_hash`(40)),
  KEY `GroupID` (`GroupID`),
  KEY `UserID` (`UserID`),
  KEY `Media` (`Media`),
  KEY `Format` (`Format`),
  KEY `Encoding` (`Encoding`),
  KEY `Year` (`RemasterYear`),
  KEY `FileCount` (`FileCount`),
  KEY `Size` (`Size`),
  KEY `Seeders` (`Seeders`),
  KEY `Leechers` (`Leechers`),
  KEY `Snatched` (`Snatched`),
  KEY `last_action` (`last_action`),
  KEY `Time` (`Time`),
  KEY `FreeTorrent` (`FreeTorrent`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents`
--

LOCK TABLES `torrents` WRITE;
/*!40000 ALTER TABLE `torrents` DISABLE KEYS */;
INSERT INTO `torrents` VALUES (1,1,1,'media','format','encoding','0',0,'rtitle','cat_num','rec_label','','','',0,'b/e[>…¼<ªäÚÄýiM­K`',2,'','',100,0,0,'2014-08-31 09:33:56','0','0','0000-00-00 00:00:00','some desc',0,0,'0000-00-00 00:00:00',0);
/*!40000 ALTER TABLE `torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_artists`
--

DROP TABLE IF EXISTS `torrents_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_artists` (
  `GroupID` int(10) NOT NULL,
  `ArtistID` int(10) NOT NULL,
  `AliasID` int(10) NOT NULL,
  `UserID` int(10) unsigned NOT NULL DEFAULT '0',
  `Importance` enum('1','2','3','4','5','6','7') NOT NULL DEFAULT '1',
  PRIMARY KEY (`GroupID`,`ArtistID`,`Importance`),
  KEY `ArtistID` (`ArtistID`),
  KEY `AliasID` (`AliasID`),
  KEY `Importance` (`Importance`),
  KEY `GroupID` (`GroupID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_artists`
--

LOCK TABLES `torrents_artists` WRITE;
/*!40000 ALTER TABLE `torrents_artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_bad_files`
--

DROP TABLE IF EXISTS `torrents_bad_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_bad_files` (
  `TorrentID` int(11) NOT NULL DEFAULT '0',
  `UserID` int(11) NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_bad_files`
--

LOCK TABLES `torrents_bad_files` WRITE;
/*!40000 ALTER TABLE `torrents_bad_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_bad_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_bad_folders`
--

DROP TABLE IF EXISTS `torrents_bad_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_bad_folders` (
  `TorrentID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `TimeAdded` datetime NOT NULL,
  PRIMARY KEY (`TorrentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_bad_folders`
--

LOCK TABLES `torrents_bad_folders` WRITE;
/*!40000 ALTER TABLE `torrents_bad_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_bad_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_bad_tags`
--

DROP TABLE IF EXISTS `torrents_bad_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_bad_tags` (
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `TimeAdded` (`TimeAdded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_bad_tags`
--

LOCK TABLES `torrents_bad_tags` WRITE;
/*!40000 ALTER TABLE `torrents_bad_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_bad_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_balance_history`
--

DROP TABLE IF EXISTS `torrents_balance_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_balance_history` (
  `TorrentID` int(10) NOT NULL,
  `GroupID` int(10) NOT NULL,
  `balance` bigint(20) NOT NULL,
  `Time` datetime NOT NULL,
  `Last` enum('0','1','2') DEFAULT '0',
  UNIQUE KEY `TorrentID_2` (`TorrentID`,`Time`),
  UNIQUE KEY `TorrentID_3` (`TorrentID`,`balance`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_balance_history`
--

LOCK TABLES `torrents_balance_history` WRITE;
/*!40000 ALTER TABLE `torrents_balance_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_balance_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_cassette_approved`
--

DROP TABLE IF EXISTS `torrents_cassette_approved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_cassette_approved` (
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `TimeAdded` (`TimeAdded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_cassette_approved`
--

LOCK TABLES `torrents_cassette_approved` WRITE;
/*!40000 ALTER TABLE `torrents_cassette_approved` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_cassette_approved` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_files`
--

DROP TABLE IF EXISTS `torrents_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_files` (
  `TorrentID` int(10) NOT NULL,
  `File` mediumblob NOT NULL,
  PRIMARY KEY (`TorrentID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_files`
--

LOCK TABLES `torrents_files` WRITE;
/*!40000 ALTER TABLE `torrents_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_group`
--

DROP TABLE IF EXISTS `torrents_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_group` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `ArtistID` int(10) DEFAULT NULL,
  `CategoryID` int(3) DEFAULT NULL,
  `Name` varchar(300) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `CatalogueNumber` varchar(80) NOT NULL DEFAULT '',
  `RecordLabel` varchar(80) NOT NULL DEFAULT '',
  `ReleaseType` tinyint(2) DEFAULT '21',
  `TagList` varchar(500) NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `RevisionID` int(12) DEFAULT NULL,
  `WikiBody` text NOT NULL,
  `WikiImage` varchar(255) NOT NULL,
  `VanityHouse` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `ArtistID` (`ArtistID`),
  KEY `CategoryID` (`CategoryID`),
  KEY `Name` (`Name`(255)),
  KEY `Year` (`Year`),
  KEY `Time` (`Time`),
  KEY `RevisionID` (`RevisionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_group`
--

LOCK TABLES `torrents_group` WRITE;
/*!40000 ALTER TABLE `torrents_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_logs_new`
--

DROP TABLE IF EXISTS `torrents_logs_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_logs_new` (
  `LogID` int(10) NOT NULL AUTO_INCREMENT,
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `Log` mediumtext NOT NULL,
  `Details` mediumtext NOT NULL,
  `Score` int(3) NOT NULL,
  `Revision` int(3) NOT NULL,
  `Adjusted` enum('1','0') NOT NULL DEFAULT '0',
  `AdjustedBy` int(10) NOT NULL DEFAULT '0',
  `NotEnglish` enum('1','0') NOT NULL DEFAULT '0',
  `AdjustmentReason` text,
  PRIMARY KEY (`LogID`),
  KEY `TorrentID` (`TorrentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_logs_new`
--

LOCK TABLES `torrents_logs_new` WRITE;
/*!40000 ALTER TABLE `torrents_logs_new` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_logs_new` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_lossymaster_approved`
--

DROP TABLE IF EXISTS `torrents_lossymaster_approved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_lossymaster_approved` (
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `TimeAdded` (`TimeAdded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_lossymaster_approved`
--

LOCK TABLES `torrents_lossymaster_approved` WRITE;
/*!40000 ALTER TABLE `torrents_lossymaster_approved` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_lossymaster_approved` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_lossyweb_approved`
--

DROP TABLE IF EXISTS `torrents_lossyweb_approved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_lossyweb_approved` (
  `TorrentID` int(10) NOT NULL DEFAULT '0',
  `UserID` int(10) NOT NULL DEFAULT '0',
  `TimeAdded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `TimeAdded` (`TimeAdded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_lossyweb_approved`
--

LOCK TABLES `torrents_lossyweb_approved` WRITE;
/*!40000 ALTER TABLE `torrents_lossyweb_approved` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_lossyweb_approved` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_peerlists`
--

DROP TABLE IF EXISTS `torrents_peerlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_peerlists` (
  `TorrentID` int(11) NOT NULL,
  `GroupID` int(11) DEFAULT NULL,
  `Seeders` int(11) DEFAULT NULL,
  `Leechers` int(11) DEFAULT NULL,
  `Snatches` int(11) DEFAULT NULL,
  PRIMARY KEY (`TorrentID`),
  KEY `GroupID` (`GroupID`),
  KEY `Stats` (`TorrentID`,`Seeders`,`Leechers`,`Snatches`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_peerlists`
--

LOCK TABLES `torrents_peerlists` WRITE;
/*!40000 ALTER TABLE `torrents_peerlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_peerlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_peerlists_compare`
--

DROP TABLE IF EXISTS `torrents_peerlists_compare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_peerlists_compare` (
  `TorrentID` int(11) NOT NULL,
  `GroupID` int(11) DEFAULT NULL,
  `Seeders` int(11) DEFAULT NULL,
  `Leechers` int(11) DEFAULT NULL,
  `Snatches` int(11) DEFAULT NULL,
  PRIMARY KEY (`TorrentID`),
  KEY `GroupID` (`GroupID`),
  KEY `Stats` (`TorrentID`,`Seeders`,`Leechers`,`Snatches`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_peerlists_compare`
--

LOCK TABLES `torrents_peerlists_compare` WRITE;
/*!40000 ALTER TABLE `torrents_peerlists_compare` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_peerlists_compare` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_recommended`
--

DROP TABLE IF EXISTS `torrents_recommended`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_recommended` (
  `GroupID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`GroupID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_recommended`
--

LOCK TABLES `torrents_recommended` WRITE;
/*!40000 ALTER TABLE `torrents_recommended` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_recommended` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_tags`
--

DROP TABLE IF EXISTS `torrents_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_tags` (
  `TagID` int(10) NOT NULL DEFAULT '0',
  `GroupID` int(10) NOT NULL DEFAULT '0',
  `PositiveVotes` int(6) NOT NULL DEFAULT '1',
  `NegativeVotes` int(6) NOT NULL DEFAULT '1',
  `UserID` int(10) DEFAULT NULL,
  PRIMARY KEY (`TagID`,`GroupID`),
  KEY `TagID` (`TagID`),
  KEY `GroupID` (`GroupID`),
  KEY `PositiveVotes` (`PositiveVotes`),
  KEY `NegativeVotes` (`NegativeVotes`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_tags`
--

LOCK TABLES `torrents_tags` WRITE;
/*!40000 ALTER TABLE `torrents_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_tags_votes`
--

DROP TABLE IF EXISTS `torrents_tags_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_tags_votes` (
  `GroupID` int(10) NOT NULL,
  `TagID` int(10) NOT NULL,
  `UserID` int(10) NOT NULL,
  `Way` enum('up','down') NOT NULL DEFAULT 'up',
  PRIMARY KEY (`GroupID`,`TagID`,`UserID`,`Way`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_tags_votes`
--

LOCK TABLES `torrents_tags_votes` WRITE;
/*!40000 ALTER TABLE `torrents_tags_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_tags_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torrents_votes`
--

DROP TABLE IF EXISTS `torrents_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `torrents_votes` (
  `GroupID` int(10) NOT NULL,
  `Ups` int(10) unsigned NOT NULL DEFAULT '0',
  `Total` int(10) unsigned NOT NULL DEFAULT '0',
  `Score` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`GroupID`),
  KEY `Score` (`Score`),
  CONSTRAINT `torrents_votes_ibfk_1` FOREIGN KEY (`GroupID`) REFERENCES `torrents_group` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torrents_votes`
--

LOCK TABLES `torrents_votes` WRITE;
/*!40000 ALTER TABLE `torrents_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `torrents_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_questions`
--

DROP TABLE IF EXISTS `user_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_questions` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Question` mediumtext NOT NULL,
  `UserID` int(10) NOT NULL,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_questions`
--

LOCK TABLES `user_questions` WRITE;
/*!40000 ALTER TABLE `user_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_collage_subs`
--

DROP TABLE IF EXISTS `users_collage_subs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_collage_subs` (
  `UserID` int(10) NOT NULL,
  `CollageID` int(10) NOT NULL,
  `LastVisit` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`,`CollageID`),
  KEY `CollageID` (`CollageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_collage_subs`
--

LOCK TABLES `users_collage_subs` WRITE;
/*!40000 ALTER TABLE `users_collage_subs` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_collage_subs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_comments_last_read`
--

DROP TABLE IF EXISTS `users_comments_last_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_comments_last_read` (
  `UserID` int(10) NOT NULL,
  `Page` enum('artist','collages','requests','torrents') NOT NULL,
  `PageID` int(10) NOT NULL,
  `PostID` int(10) NOT NULL,
  PRIMARY KEY (`UserID`,`Page`,`PageID`),
  KEY `Page` (`Page`,`PageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_comments_last_read`
--

LOCK TABLES `users_comments_last_read` WRITE;
/*!40000 ALTER TABLE `users_comments_last_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_comments_last_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_donor_ranks`
--

DROP TABLE IF EXISTS `users_donor_ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_donor_ranks` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Rank` tinyint(2) NOT NULL DEFAULT '0',
  `DonationTime` datetime DEFAULT NULL,
  `Hidden` tinyint(2) NOT NULL DEFAULT '0',
  `TotalRank` int(10) NOT NULL DEFAULT '0',
  `SpecialRank` tinyint(2) DEFAULT '0',
  `InvitesRecievedRank` tinyint(4) DEFAULT '0',
  `RankExpirationTime` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  KEY `DonationTime` (`DonationTime`),
  KEY `SpecialRank` (`SpecialRank`),
  KEY `Rank` (`Rank`),
  KEY `TotalRank` (`TotalRank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_donor_ranks`
--

LOCK TABLES `users_donor_ranks` WRITE;
/*!40000 ALTER TABLE `users_donor_ranks` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_donor_ranks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_downloads`
--

DROP TABLE IF EXISTS `users_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_downloads` (
  `UserID` int(10) NOT NULL,
  `TorrentID` int(1) NOT NULL,
  `Time` datetime NOT NULL,
  PRIMARY KEY (`UserID`,`TorrentID`,`Time`),
  KEY `TorrentID` (`TorrentID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_downloads`
--

LOCK TABLES `users_downloads` WRITE;
/*!40000 ALTER TABLE `users_downloads` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_downloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_dupes`
--

DROP TABLE IF EXISTS `users_dupes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_dupes` (
  `GroupID` int(10) unsigned NOT NULL,
  `UserID` int(10) unsigned NOT NULL,
  UNIQUE KEY `UserID` (`UserID`),
  KEY `GroupID` (`GroupID`),
  CONSTRAINT `users_dupes_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users_main` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `users_dupes_ibfk_2` FOREIGN KEY (`GroupID`) REFERENCES `dupe_groups` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_dupes`
--

LOCK TABLES `users_dupes` WRITE;
/*!40000 ALTER TABLE `users_dupes` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_dupes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_enable_recommendations`
--

DROP TABLE IF EXISTS `users_enable_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_enable_recommendations` (
  `ID` int(10) NOT NULL,
  `Enable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Enable` (`Enable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_enable_recommendations`
--

LOCK TABLES `users_enable_recommendations` WRITE;
/*!40000 ALTER TABLE `users_enable_recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_enable_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_freeleeches`
--

DROP TABLE IF EXISTS `users_freeleeches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_freeleeches` (
  `UserID` int(10) NOT NULL,
  `TorrentID` int(10) NOT NULL,
  `Time` datetime NOT NULL,
  `Expired` tinyint(1) NOT NULL DEFAULT '0',
  `Downloaded` bigint(20) NOT NULL DEFAULT '0',
  `Uses` int(10) NOT NULL DEFAULT '1',
  PRIMARY KEY (`UserID`,`TorrentID`),
  KEY `Time` (`Time`),
  KEY `Expired_Time` (`Expired`,`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_freeleeches`
--

LOCK TABLES `users_freeleeches` WRITE;
/*!40000 ALTER TABLE `users_freeleeches` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_freeleeches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_geodistribution`
--

DROP TABLE IF EXISTS `users_geodistribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_geodistribution` (
  `Code` varchar(2) NOT NULL,
  `Users` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_geodistribution`
--

LOCK TABLES `users_geodistribution` WRITE;
/*!40000 ALTER TABLE `users_geodistribution` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_geodistribution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_history_emails`
--

DROP TABLE IF EXISTS `users_history_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_history_emails` (
  `UserID` int(10) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Time` datetime DEFAULT NULL,
  `IP` varchar(15) DEFAULT NULL,
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_history_emails`
--

LOCK TABLES `users_history_emails` WRITE;
/*!40000 ALTER TABLE `users_history_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_history_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_history_ips`
--

DROP TABLE IF EXISTS `users_history_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_history_ips` (
  `UserID` int(10) NOT NULL,
  `IP` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `StartTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `EndTime` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`,`IP`,`StartTime`),
  KEY `UserID` (`UserID`),
  KEY `IP` (`IP`),
  KEY `StartTime` (`StartTime`),
  KEY `EndTime` (`EndTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_history_ips`
--

LOCK TABLES `users_history_ips` WRITE;
/*!40000 ALTER TABLE `users_history_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_history_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_history_passkeys`
--

DROP TABLE IF EXISTS `users_history_passkeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_history_passkeys` (
  `UserID` int(10) NOT NULL,
  `OldPassKey` varchar(32) DEFAULT NULL,
  `NewPassKey` varchar(32) DEFAULT NULL,
  `ChangeTime` datetime DEFAULT NULL,
  `ChangerIP` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_history_passkeys`
--

LOCK TABLES `users_history_passkeys` WRITE;
/*!40000 ALTER TABLE `users_history_passkeys` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_history_passkeys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_history_passwords`
--

DROP TABLE IF EXISTS `users_history_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_history_passwords` (
  `UserID` int(10) NOT NULL,
  `ChangeTime` datetime DEFAULT NULL,
  `ChangerIP` varchar(15) DEFAULT NULL,
  KEY `User_Time` (`UserID`,`ChangeTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_history_passwords`
--

LOCK TABLES `users_history_passwords` WRITE;
/*!40000 ALTER TABLE `users_history_passwords` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_history_passwords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_info`
--

DROP TABLE IF EXISTS `users_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_info` (
  `UserID` int(10) unsigned NOT NULL,
  `StyleID` int(10) unsigned NOT NULL,
  `StyleURL` varchar(255) DEFAULT NULL,
  `Info` text NOT NULL,
  `Avatar` varchar(255) NOT NULL,
  `AdminComment` text NOT NULL,
  `SiteOptions` text NOT NULL,
  `ViewAvatars` enum('0','1') NOT NULL DEFAULT '1',
  `Donor` enum('0','1') NOT NULL DEFAULT '0',
  `Artist` enum('0','1') NOT NULL DEFAULT '0',
  `DownloadAlt` enum('0','1') NOT NULL DEFAULT '0',
  `Warned` datetime NOT NULL,
  `SupportFor` varchar(255) NOT NULL,
  `TorrentGrouping` enum('0','1','2') NOT NULL COMMENT '0=Open,1=Closed,2=Off',
  `ShowTags` enum('0','1') NOT NULL DEFAULT '1',
  `NotifyOnQuote` enum('0','1','2') NOT NULL DEFAULT '0',
  `AuthKey` varchar(32) NOT NULL,
  `ResetKey` varchar(32) NOT NULL,
  `ResetExpires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `JoinDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Inviter` int(10) DEFAULT NULL,
  `BitcoinAddress` varchar(34) DEFAULT NULL,
  `WarnedTimes` int(2) NOT NULL DEFAULT '0',
  `DisableAvatar` enum('0','1') NOT NULL DEFAULT '0',
  `DisableInvites` enum('0','1') NOT NULL DEFAULT '0',
  `DisablePosting` enum('0','1') NOT NULL DEFAULT '0',
  `DisableForums` enum('0','1') NOT NULL DEFAULT '0',
  `DisableIRC` enum('0','1') DEFAULT '0',
  `DisableTagging` enum('0','1') NOT NULL DEFAULT '0',
  `DisableUpload` enum('0','1') NOT NULL DEFAULT '0',
  `DisableWiki` enum('0','1') NOT NULL DEFAULT '0',
  `DisablePM` enum('0','1') NOT NULL DEFAULT '0',
  `RatioWatchEnds` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `RatioWatchDownload` bigint(20) unsigned NOT NULL DEFAULT '0',
  `RatioWatchTimes` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `BanDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `BanReason` enum('0','1','2','3','4') NOT NULL DEFAULT '0',
  `CatchupTime` datetime DEFAULT NULL,
  `LastReadNews` int(10) NOT NULL DEFAULT '0',
  `HideCountryChanges` enum('0','1') NOT NULL DEFAULT '0',
  `RestrictedForums` varchar(150) NOT NULL DEFAULT '',
  `DisableRequests` enum('0','1') NOT NULL DEFAULT '0',
  `PermittedForums` varchar(150) NOT NULL DEFAULT '',
  `UnseededAlerts` enum('0','1') NOT NULL DEFAULT '0',
  `LastReadBlog` int(10) NOT NULL DEFAULT '0',
  `InfoTitle` varchar(255) NOT NULL,
  UNIQUE KEY `UserID` (`UserID`),
  KEY `SupportFor` (`SupportFor`),
  KEY `DisableInvites` (`DisableInvites`),
  KEY `Donor` (`Donor`),
  KEY `Warned` (`Warned`),
  KEY `JoinDate` (`JoinDate`),
  KEY `Inviter` (`Inviter`),
  KEY `RatioWatchEnds` (`RatioWatchEnds`),
  KEY `RatioWatchDownload` (`RatioWatchDownload`),
  KEY `BitcoinAddress` (`BitcoinAddress`(4)),
  KEY `AuthKey` (`AuthKey`),
  KEY `ResetKey` (`ResetKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_info`
--

LOCK TABLES `users_info` WRITE;
/*!40000 ALTER TABLE `users_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_levels`
--

DROP TABLE IF EXISTS `users_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_levels` (
  `UserID` int(10) unsigned NOT NULL,
  `PermissionID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`,`PermissionID`),
  KEY `PermissionID` (`PermissionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_levels`
--

LOCK TABLES `users_levels` WRITE;
/*!40000 ALTER TABLE `users_levels` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_main`
--

DROP TABLE IF EXISTS `users_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_main` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Username` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PassHash` varchar(60) NOT NULL,
  `Secret` char(32) NOT NULL,
  `IRCKey` char(32) DEFAULT NULL,
  `LastLogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LastAccess` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `IP` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `Class` tinyint(2) NOT NULL DEFAULT '5',
  `Uploaded` bigint(20) unsigned NOT NULL DEFAULT '0',
  `Downloaded` bigint(20) unsigned NOT NULL DEFAULT '0',
  `Title` text NOT NULL,
  `Enabled` enum('0','1','2') NOT NULL DEFAULT '0',
  `Paranoia` text,
  `Visible` enum('1','0') NOT NULL DEFAULT '1',
  `Invites` int(10) unsigned NOT NULL DEFAULT '0',
  `PermissionID` int(10) unsigned NOT NULL,
  `CustomPermissions` text,
  `can_leech` tinyint(4) NOT NULL DEFAULT '1',
  `torrent_pass` char(32) NOT NULL,
  `RequiredRatio` double(10,8) NOT NULL DEFAULT '0.00000000',
  `RequiredRatioWork` double(10,8) NOT NULL DEFAULT '0.00000000',
  `ipcc` varchar(2) NOT NULL DEFAULT '',
  `FLTokens` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Username` (`Username`),
  KEY `Email` (`Email`),
  KEY `PassHash` (`PassHash`),
  KEY `LastAccess` (`LastAccess`),
  KEY `IP` (`IP`),
  KEY `Class` (`Class`),
  KEY `Uploaded` (`Uploaded`),
  KEY `Downloaded` (`Downloaded`),
  KEY `Enabled` (`Enabled`),
  KEY `Invites` (`Invites`),
  KEY `torrent_pass` (`torrent_pass`),
  KEY `RequiredRatio` (`RequiredRatio`),
  KEY `cc_index` (`ipcc`),
  KEY `PermissionID` (`PermissionID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_main`
--

LOCK TABLES `users_main` WRITE;
/*!40000 ALTER TABLE `users_main` DISABLE KEYS */;
INSERT INTO `users_main` VALUES (1,'film42','f@g.com','pass','secret','irckey','0000-00-00 00:00:00','0000-00-00 00:00:00','0.0.0.0',0,3000,3000,'','1','','1',10,10,'',1,'3f981ffe2XXXXXX7780441XXXXXX6dde',99.99999999,0.00000000,'',0),(2,'test','f@g.com','pass','secret','irckey','0000-00-00 00:00:00','0000-00-00 00:00:00','0.0.0.0',0,3000,3000,'','1','','1',10,10,'',1,'3f981ffe2testXX7780441XXXXXX6dde',99.99999999,0.00000000,'',0);
/*!40000 ALTER TABLE `users_main` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_notifications_settings`
--

DROP TABLE IF EXISTS `users_notifications_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_notifications_settings` (
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Inbox` tinyint(1) DEFAULT '1',
  `StaffPM` tinyint(1) DEFAULT '1',
  `News` tinyint(1) DEFAULT '1',
  `Blog` tinyint(1) DEFAULT '1',
  `Torrents` tinyint(1) DEFAULT '1',
  `Collages` tinyint(1) DEFAULT '1',
  `Quotes` tinyint(1) DEFAULT '1',
  `Subscriptions` tinyint(1) DEFAULT '1',
  `SiteAlerts` tinyint(1) DEFAULT '1',
  `RequestAlerts` tinyint(1) DEFAULT '1',
  `CollageAlerts` tinyint(1) DEFAULT '1',
  `TorrentAlerts` tinyint(1) DEFAULT '1',
  `ForumAlerts` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_notifications_settings`
--

LOCK TABLES `users_notifications_settings` WRITE;
/*!40000 ALTER TABLE `users_notifications_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_notifications_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_notify_filters`
--

DROP TABLE IF EXISTS `users_notify_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_notify_filters` (
  `ID` int(12) NOT NULL AUTO_INCREMENT,
  `UserID` int(10) NOT NULL,
  `Label` varchar(128) NOT NULL DEFAULT '',
  `Artists` mediumtext NOT NULL,
  `RecordLabels` mediumtext NOT NULL,
  `Users` mediumtext NOT NULL,
  `Tags` varchar(500) NOT NULL DEFAULT '',
  `NotTags` varchar(500) NOT NULL DEFAULT '',
  `Categories` varchar(500) NOT NULL DEFAULT '',
  `Formats` varchar(500) NOT NULL DEFAULT '',
  `Encodings` varchar(500) NOT NULL DEFAULT '',
  `Media` varchar(500) NOT NULL DEFAULT '',
  `FromYear` int(4) NOT NULL DEFAULT '0',
  `ToYear` int(4) NOT NULL DEFAULT '0',
  `ExcludeVA` enum('1','0') NOT NULL DEFAULT '0',
  `NewGroupsOnly` enum('1','0') NOT NULL DEFAULT '0',
  `ReleaseTypes` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`),
  KEY `FromYear` (`FromYear`),
  KEY `ToYear` (`ToYear`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_notify_filters`
--

LOCK TABLES `users_notify_filters` WRITE;
/*!40000 ALTER TABLE `users_notify_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_notify_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_notify_quoted`
--

DROP TABLE IF EXISTS `users_notify_quoted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_notify_quoted` (
  `UserID` int(10) NOT NULL,
  `QuoterID` int(10) NOT NULL,
  `Page` enum('forums','artist','collages','requests','torrents') NOT NULL,
  `PageID` int(10) NOT NULL,
  `PostID` int(10) NOT NULL,
  `UnRead` tinyint(1) NOT NULL DEFAULT '1',
  `Date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`UserID`,`Page`,`PostID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_notify_quoted`
--

LOCK TABLES `users_notify_quoted` WRITE;
/*!40000 ALTER TABLE `users_notify_quoted` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_notify_quoted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_notify_torrents`
--

DROP TABLE IF EXISTS `users_notify_torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_notify_torrents` (
  `UserID` int(10) NOT NULL,
  `FilterID` int(10) NOT NULL,
  `GroupID` int(10) NOT NULL,
  `TorrentID` int(10) NOT NULL,
  `UnRead` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`UserID`,`TorrentID`),
  KEY `TorrentID` (`TorrentID`),
  KEY `UserID_Unread` (`UserID`,`UnRead`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_notify_torrents`
--

LOCK TABLES `users_notify_torrents` WRITE;
/*!40000 ALTER TABLE `users_notify_torrents` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_notify_torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_points`
--

DROP TABLE IF EXISTS `users_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_points` (
  `UserID` int(10) NOT NULL,
  `GroupID` int(10) NOT NULL,
  `Points` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`UserID`,`GroupID`),
  KEY `UserID` (`UserID`),
  KEY `GroupID` (`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_points`
--

LOCK TABLES `users_points` WRITE;
/*!40000 ALTER TABLE `users_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_points_requests`
--

DROP TABLE IF EXISTS `users_points_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_points_requests` (
  `UserID` int(10) NOT NULL,
  `RequestID` int(10) NOT NULL,
  `Points` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`RequestID`),
  KEY `UserID` (`UserID`),
  KEY `RequestID` (`RequestID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_points_requests`
--

LOCK TABLES `users_points_requests` WRITE;
/*!40000 ALTER TABLE `users_points_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_points_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_push_notifications`
--

DROP TABLE IF EXISTS `users_push_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_push_notifications` (
  `UserID` int(10) NOT NULL,
  `PushService` tinyint(1) NOT NULL DEFAULT '0',
  `PushOptions` text NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_push_notifications`
--

LOCK TABLES `users_push_notifications` WRITE;
/*!40000 ALTER TABLE `users_push_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_push_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_sessions`
--

DROP TABLE IF EXISTS `users_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_sessions` (
  `UserID` int(10) NOT NULL,
  `SessionID` char(32) NOT NULL,
  `KeepLogged` enum('0','1') NOT NULL DEFAULT '0',
  `Browser` varchar(40) DEFAULT NULL,
  `OperatingSystem` varchar(13) DEFAULT NULL,
  `IP` varchar(15) NOT NULL,
  `LastUpdate` datetime NOT NULL,
  `Active` tinyint(4) NOT NULL DEFAULT '1',
  `FullUA` text,
  PRIMARY KEY (`UserID`,`SessionID`),
  KEY `UserID` (`UserID`),
  KEY `LastUpdate` (`LastUpdate`),
  KEY `Active` (`Active`),
  KEY `ActiveAgeKeep` (`Active`,`LastUpdate`,`KeepLogged`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_sessions`
--

LOCK TABLES `users_sessions` WRITE;
/*!40000 ALTER TABLE `users_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_subscriptions`
--

DROP TABLE IF EXISTS `users_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_subscriptions` (
  `UserID` int(10) NOT NULL,
  `TopicID` int(10) NOT NULL,
  PRIMARY KEY (`UserID`,`TopicID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_subscriptions`
--

LOCK TABLES `users_subscriptions` WRITE;
/*!40000 ALTER TABLE `users_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_subscriptions_comments`
--

DROP TABLE IF EXISTS `users_subscriptions_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_subscriptions_comments` (
  `UserID` int(10) NOT NULL,
  `Page` enum('artist','collages','requests','torrents') NOT NULL,
  `PageID` int(10) NOT NULL,
  PRIMARY KEY (`UserID`,`Page`,`PageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_subscriptions_comments`
--

LOCK TABLES `users_subscriptions_comments` WRITE;
/*!40000 ALTER TABLE `users_subscriptions_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_subscriptions_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_torrent_history`
--

DROP TABLE IF EXISTS `users_torrent_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_torrent_history` (
  `UserID` int(10) unsigned NOT NULL,
  `NumTorrents` int(6) unsigned NOT NULL,
  `Date` int(8) unsigned NOT NULL,
  `Time` int(11) unsigned NOT NULL DEFAULT '0',
  `LastTime` int(11) unsigned NOT NULL DEFAULT '0',
  `Finished` enum('1','0') NOT NULL DEFAULT '1',
  `Weight` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`,`NumTorrents`,`Date`),
  KEY `Finished` (`Finished`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_torrent_history`
--

LOCK TABLES `users_torrent_history` WRITE;
/*!40000 ALTER TABLE `users_torrent_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_torrent_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_torrent_history_snatch`
--

DROP TABLE IF EXISTS `users_torrent_history_snatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_torrent_history_snatch` (
  `UserID` int(10) unsigned NOT NULL,
  `NumSnatches` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`),
  KEY `NumSnatches` (`NumSnatches`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_torrent_history_snatch`
--

LOCK TABLES `users_torrent_history_snatch` WRITE;
/*!40000 ALTER TABLE `users_torrent_history_snatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_torrent_history_snatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_torrent_history_temp`
--

DROP TABLE IF EXISTS `users_torrent_history_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_torrent_history_temp` (
  `UserID` int(10) unsigned NOT NULL,
  `NumTorrents` int(6) unsigned NOT NULL DEFAULT '0',
  `SumTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `SeedingAvg` int(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_torrent_history_temp`
--

LOCK TABLES `users_torrent_history_temp` WRITE;
/*!40000 ALTER TABLE `users_torrent_history_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_torrent_history_temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_votes`
--

DROP TABLE IF EXISTS `users_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_votes` (
  `UserID` int(10) unsigned NOT NULL,
  `GroupID` int(10) NOT NULL,
  `Type` enum('Up','Down') DEFAULT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`,`GroupID`),
  KEY `GroupID` (`GroupID`),
  KEY `Type` (`Type`),
  KEY `Time` (`Time`),
  KEY `Vote` (`Type`,`GroupID`,`UserID`),
  CONSTRAINT `users_votes_ibfk_1` FOREIGN KEY (`GroupID`) REFERENCES `torrents_group` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `users_votes_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users_main` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_votes`
--

LOCK TABLES `users_votes` WRITE;
/*!40000 ALTER TABLE `users_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_warnings_forums`
--

DROP TABLE IF EXISTS `users_warnings_forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_warnings_forums` (
  `UserID` int(10) unsigned NOT NULL,
  `Comment` text NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_warnings_forums`
--

LOCK TABLES `users_warnings_forums` WRITE;
/*!40000 ALTER TABLE `users_warnings_forums` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_warnings_forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_aliases`
--

DROP TABLE IF EXISTS `wiki_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_aliases` (
  `Alias` varchar(50) NOT NULL,
  `UserID` int(10) NOT NULL,
  `ArticleID` int(10) DEFAULT NULL,
  PRIMARY KEY (`Alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_aliases`
--

LOCK TABLES `wiki_aliases` WRITE;
/*!40000 ALTER TABLE `wiki_aliases` DISABLE KEYS */;
INSERT INTO `wiki_aliases` VALUES ('wiki',1,1);
/*!40000 ALTER TABLE `wiki_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_articles`
--

DROP TABLE IF EXISTS `wiki_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_articles` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Revision` int(10) NOT NULL DEFAULT '1',
  `Title` varchar(100) DEFAULT NULL,
  `Body` mediumtext,
  `MinClassRead` int(4) DEFAULT NULL,
  `MinClassEdit` int(4) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Author` int(10) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_articles`
--

LOCK TABLES `wiki_articles` WRITE;
/*!40000 ALTER TABLE `wiki_articles` DISABLE KEYS */;
INSERT INTO `wiki_articles` VALUES (1,1,'Wiki','Welcome to your new wiki! Hope this works.',100,475,'2014-08-18 22:35:08',1);
/*!40000 ALTER TABLE `wiki_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_artists`
--

DROP TABLE IF EXISTS `wiki_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_artists` (
  `RevisionID` int(12) NOT NULL AUTO_INCREMENT,
  `PageID` int(10) NOT NULL DEFAULT '0',
  `Body` text,
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Summary` varchar(100) DEFAULT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RevisionID`),
  KEY `PageID` (`PageID`),
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_artists`
--

LOCK TABLES `wiki_artists` WRITE;
/*!40000 ALTER TABLE `wiki_artists` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_revisions`
--

DROP TABLE IF EXISTS `wiki_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_revisions` (
  `ID` int(10) NOT NULL,
  `Revision` int(10) NOT NULL,
  `Title` varchar(100) DEFAULT NULL,
  `Body` mediumtext,
  `Date` datetime DEFAULT NULL,
  `Author` int(10) DEFAULT NULL,
  KEY `ID_Revision` (`ID`,`Revision`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_revisions`
--

LOCK TABLES `wiki_revisions` WRITE;
/*!40000 ALTER TABLE `wiki_revisions` DISABLE KEYS */;
INSERT INTO `wiki_revisions` VALUES (1,1,'Wiki','Welcome to your new wiki! Hope this works.','2014-08-18 22:35:08',1);
/*!40000 ALTER TABLE `wiki_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_torrents`
--

DROP TABLE IF EXISTS `wiki_torrents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_torrents` (
  `RevisionID` int(12) NOT NULL AUTO_INCREMENT,
  `PageID` int(10) NOT NULL DEFAULT '0',
  `Body` text,
  `UserID` int(10) NOT NULL DEFAULT '0',
  `Summary` varchar(100) DEFAULT NULL,
  `Time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RevisionID`),
  KEY `PageID` (`PageID`),
  KEY `UserID` (`UserID`),
  KEY `Time` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_torrents`
--

LOCK TABLES `wiki_torrents` WRITE;
/*!40000 ALTER TABLE `wiki_torrents` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_torrents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xbt_client_whitelist`
--

DROP TABLE IF EXISTS `xbt_client_whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xbt_client_whitelist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `peer_id` varchar(20) DEFAULT NULL,
  `vstring` varchar(200) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `peer_id` (`peer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xbt_client_whitelist`
--

LOCK TABLES `xbt_client_whitelist` WRITE;
/*!40000 ALTER TABLE `xbt_client_whitelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `xbt_client_whitelist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xbt_files_users`
--

DROP TABLE IF EXISTS `xbt_files_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xbt_files_users` (
  `uid` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `announced` int(11) NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `downloaded` bigint(20) NOT NULL,
  `remaining` bigint(20) NOT NULL,
  `uploaded` bigint(20) NOT NULL,
  `upspeed` int(10) unsigned NOT NULL,
  `downspeed` int(10) unsigned NOT NULL,
  `corrupt` bigint(20) NOT NULL DEFAULT '0',
  `timespent` int(10) unsigned NOT NULL,
  `useragent` varchar(51) NOT NULL,
  `connectable` tinyint(4) NOT NULL DEFAULT '1',
  `peer_id` binary(20) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `fid` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `ip` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`peer_id`,`fid`),
  KEY `remaining_idx` (`remaining`),
  KEY `fid_idx` (`fid`),
  KEY `mtime_idx` (`mtime`),
  KEY `uid_active` (`uid`,`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xbt_files_users`
--

LOCK TABLES `xbt_files_users` WRITE;
/*!40000 ALTER TABLE `xbt_files_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `xbt_files_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xbt_snatched`
--

DROP TABLE IF EXISTS `xbt_snatched`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xbt_snatched` (
  `uid` int(11) NOT NULL DEFAULT '0',
  `tstamp` int(11) NOT NULL,
  `fid` int(11) NOT NULL,
  `IP` varchar(15) NOT NULL,
  KEY `fid` (`fid`),
  KEY `tstamp` (`tstamp`),
  KEY `uid_tstamp` (`uid`,`tstamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xbt_snatched`
--

LOCK TABLES `xbt_snatched` WRITE;
/*!40000 ALTER TABLE `xbt_snatched` DISABLE KEYS */;
/*!40000 ALTER TABLE `xbt_snatched` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-31 22:33:01
