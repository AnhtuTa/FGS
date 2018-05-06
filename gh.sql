-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: guesthouse
-- ------------------------------------------------------
-- Server version	5.7.15-log

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
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hotel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `star` smallint(6) DEFAULT NULL,
  `url` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `district` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `longitude` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reviewPoint` float DEFAULT NULL,
  `numReviews` int(11) DEFAULT NULL,
  `area` float DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel` VALUES (1,'Hanoi Nostalgia Hotel & Spa',4,NULL,NULL,NULL,'20.180971','106.007124',7.6,542,NULL,2139000),(2,'The Queen Hotel & Spa',3,NULL,NULL,NULL,'20.380971','105.967124',8.3,124,NULL,1234000),(3,'Church Legend Hotel Hanoi',4,NULL,NULL,NULL,'20.580971','105.927124',9.1,532,NULL,2153000),(4,'Hanoi Zesty Hotel',5,NULL,NULL,NULL,'20.780971','105.887124',8.7,432,NULL,1986000),(5,'Khách Sạn Hanoi Oriental',4,NULL,NULL,NULL,'21.380971','105.807124',8.3,123,NULL,1676000),(6,'Khách sạn Bách Khoa',4,NULL,NULL,NULL,'21.006419','105.844087',8.9,273,NULL,1982000),(7,'Khách sạn Bưu Chính',5,NULL,NULL,NULL,'20.980971','105.787124',9.2,1029,NULL,2496000);
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'ROLE_ADMIN'),(2,'ROLE_USER');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8 NOT NULL,
  `fullname` varchar(100) CHARACTER SET utf8 NOT NULL,
  `encrypted_password` varchar(200) CHARACTER SET utf8 NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','admin@gmail.com','administrator','$2a$10$WuCcwsvwxd2dHg1Q6Wn7SumIQ8VK34DVSFKOMMYl3OmT9m3faRuwC',1),(3,'huy','huyga@yahoo.com','Huy gà','$2a$10$WuCcwsvwxd2dHg1Q6Wn7SumIQ8VK34DVSFKOMMYl3OmT9m3faRuwC',1),(4,'anhtu','taanhtu@yahoo.com','Tạ Anh Tú','$2a$10$WuCcwsvwxd2dHg1Q6Wn7SumIQ8VK34DVSFKOMMYl3OmT9m3faRuwC',1),(5,'longdragon','long@yahoo.com','Long Dragon','$2a$10$3qyDThAxG/RDfrIjPzXS4elHHgn505rwhAdU0C5lQClnBuRiSzcWe',1),(6,'vegeta','vegeta@saiyan.jp.com','Prince Vegeta','$2a$10$kIQHACk6iyBhj99FyOSiTuchszrQn.6hJKukVpBiY7uhl6QrsAgi.',1),(7,'goku','goku@yahoo.com','Songo Ku','$2a$10$kIQHACk6iyBhj99FyOSiTuchszrQn.6hJKukVpBiY7uhl6QrsAgi.',1),(11,'longdragon2','long2@yahoo.com.vn','Long Dragon','$2a$10$CeyTAmFG0NjhX0HGlT0z8.NLvd.bDDkafHkY.54Zb1w8fxTG/N1Bi',1),(12,'nguyenbka','nguyenbka@hust.edu.vn','hoang trung nguyen','$2a$10$ert4QRHBhmO6gMg8Cl6ZM.fLz9oMju9SUGB0tFfdV7mOorLKOrsZO',1),(21,'dmtoan','toan@demo.com','Thanh Toan','$2a$10$JRtIhb0mpmepdk2ygUIoCuAp6JhHUxnfSc/rnXuIfFUWfxRgCR/p2',1),(22,'wtf','wtf@gmail.com','what the?','$2a$10$JRtIhb0mpmepdk2ygUIoCuAp6JhHUxnfSc/rnXuIfFUWfxRgCR/p2',1),(23,'huyen1','huyen@gmail.com','Huyen','$2a$10$v1Cifd6/3YGtOC5dyzbAJ.0FWB53Ae1cN/5NUpMiU9Ma0T1.LYnAG',1),(24,'phanhlee','phanh@yahoo.com','phuong anh','$2a$10$hpcFdMtAMmK4U6JWNu/wIe21Q4IIpufnYHIaM836XDopXJx/uk/tS',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `guesthouse`.`user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW
BEGIN
	-- gán quyền ROLE_USER cho record vừa được thêm vào 
	INSERT INTO `guesthouse`.`user_role` (`user_id`, `role_id`) VALUES (NEW.id, '2');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id_ur_fk_idx` (`role_id`),
  KEY `user_id_ur_fk_idx` (`user_id`),
  CONSTRAINT `role_id_ur_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `user_id_ur_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1,1),(2,1,2),(3,4,2),(4,5,2),(5,7,2),(6,6,2),(7,3,2),(8,11,2),(9,12,2),(10,21,2),(11,22,2),(12,23,2),(13,24,2);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-05-02  0:45:18
