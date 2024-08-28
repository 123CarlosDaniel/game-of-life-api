CREATE DATABASE  IF NOT EXISTS `game_of_life` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `game_of_life`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: game_of_life
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `providerAccountId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `refresh_token` text COLLATE utf8mb4_unicode_ci,
  `access_token` text COLLATE utf8mb4_unicode_ci,
  `expires_at` int DEFAULT NULL,
  `token_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_token` text COLLATE utf8mb4_unicode_ci,
  `session_state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refresh_token_expires_in` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Account_provider_providerAccountId_key` (`provider`,`providerAccountId`),
  KEY `Account_userId_idx` (`userId`),
  CONSTRAINT `Account_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `opinion` text COLLATE utf8mb4_unicode_ci,
  `ownerId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creationId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Comment_ownerId_fkey` (`ownerId`),
  KEY `Comment_creationId_fkey` (`creationId`),
  CONSTRAINT `Comment_creationId_fkey` FOREIGN KEY (`creationId`) REFERENCES `creation` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Comment_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creation`
--

DROP TABLE IF EXISTS `creation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creation` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ownerId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `data` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Creation_ownerId_fkey` (`ownerId`),
  CONSTRAINT `Creation_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reaction`
--

DROP TABLE IF EXISTS `reaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reaction` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ownerId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creationId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Reaction_ownerId_fkey` (`ownerId`),
  CONSTRAINT `Reaction_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailVerified` datetime(3) DEFAULT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_username_key` (`username`),
  UNIQUE KEY `User_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'game_of_life'
--

--
-- Dumping routines for database 'game_of_life'
--
/*!50003 DROP FUNCTION IF EXISTS `LimitClause` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `LimitClause`(page_number int, per_page int) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	set @limit_clause = case 
    when per_page >= 1 THEN CONCAT(' LIMIT ', per_page, ' OFFSET ', (page_number - 1) * per_page) 
	ELSE ' '
    end;
    return @limit_clause;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `OrderByClause` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `OrderByClause`(table_name varchar(255), column_name varchar(255),  sort_direction varchar(4)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	-- declare order_clause varchar(255);
    set @order_clause = case
		when lower(sort_direction) = 'asc' then concat(' order by ', table_name,'.', column_name, ' ASC')
        when lower(sort_direction) = 'desc' then concat(' order by ', table_name,'.', column_name, ' DESC')
        else ' '
	end;
RETURN @order_clause;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `Pages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `Pages`(total_pages int, per_page int) RETURNS int
    DETERMINISTIC
BEGIN
	set @pages = if(per_page >= 1, ceil(total_pages/per_page), 1);
	RETURN @pages;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creations_get_by_owner_sp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_by_owner_sp`(
 in userId varchar(191),
 in id varchar(191) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci,
 in page_number int, 
 in per_page int, 
 in sort_name varchar(4),
 out pages int)
BEGIN
	declare total_rows int default 0;
    declare is_user_provided boolean default false;
    
    if userId is not null then
		set is_user_provided = true;
	end if;
    
    set @id = id;
    select COUNT(*) into total_rows from creation WHERE ownerId = id;
    set pages = Pages(total_rows, per_page);
    
set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
    '(select COUNT(cm.id) from comment cm where cm.creationId = c.id) AS comments_count, ');
if is_user_provided then
	set @sql_query = concat(@sql_query, ' EXISTS(SELECT 1 FROM reaction WHERE ownerId = "', userId, '" AND creationId = c.id) AS isReactionActive ');
else
	set @sql_query = concat(@sql_query, ' FALSE as isReactionActive ');
end if;
set @sql_query = concat(
	@sql_query,
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'WHERE c.ownerId = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));

    prepare stmt FROM @sql_query;
	execute stmt USING @id;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creations_get_sp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_sp`(
 in userId varchar(191),
 in page_number int,
 in per_page int,
 in sort_name varchar(4), 
 out pages int)
BEGIN
	declare total_rows int default 0;
    
    declare is_user_provided boolean default false;
    if userId is not null then
		set is_user_provided = true;
	end if;
	
    select COUNT(*) into total_rows from creation;
    set pages = Pages(total_rows, per_page);
    set @userId = userId;
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
    '(select COUNT(cm.id) from comment cm where cm.creationId = c.id) AS comments_count, ');
    if is_user_provided then
		set @sql_query = concat(@sql_query, ' EXISTS(SELECT 1 FROM reaction WHERE ownerId = "', userId, '" AND creationId = c.id) AS isReactionActive ');
	else
		set @sql_query = concat(@sql_query, ' FALSE as isReactionActive ');
	end if;
    set @sql_query = concat(
    @sql_query,
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));
    
    prepare stmt FROM @sql_query;
	execute stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creation_get_sp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creation_get_sp`(
in userId varchar(191),
in id varchar(191)
)
BEGIN
declare is_user_provided boolean default false;
	if userId is not null
	then set is_user_provided = true;
end if;
set @id = id;
set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
	'(select COUNT(cm.id) from comment cm where cm.creationId = c.id) as comments_count, ');
if is_user_provided 
then set @sql_query = concat(@sql_query, 'EXISTS(select 1 from reaction  where creationId = c.id and ownerId = "', userId, '" ) as isReactionActive, ');
else set @sql_query = concat(@sql_query, 'FALSE as isReactionActive, ');
end if;
set @sql_query =concat(
		@sql_query,
        '(SELECT JSON_ARRAYAGG(JSON_OBJECT( ',
        '        "comment_id", cm_sub.id, ',
        '        "comment_opinion", cm_sub.opinion, ',
        '        "comment_owner_id", ucm_sub.id, ',
        '        "comment_owner_name", ucm_sub.name, ',
        '        "comment_owner_image", ucm_sub.image, ',
        '        "comment_createdAt", cm_sub.createdAt, ',
        '        "comment_updatedAt", cm_sub.updatedAt ',
        '    )) ',
        ' FROM comment cm_sub ',
        ' LEFT JOIN user ucm_sub ON cm_sub.ownerId = ucm_sub.id ',
        ' WHERE cm_sub.creationId = c.id ',
        ' ) AS comments ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
	'WHERE c.id = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt USING @id; 
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-28 14:21:20
