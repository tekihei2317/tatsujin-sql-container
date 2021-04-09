-- MySQL dump 10.13  Distrib 8.0.23, for osx10.16 (x86_64)
--
-- Host: localhost    Database: shop
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `shop`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `shop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `shop`;

--
-- Table structure for table `greatest`
--

DROP TABLE IF EXISTS `greatest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `greatest` (
  `id` varchar(10) NOT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `greatest`
--

LOCK TABLES `greatest` WRITE;
/*!40000 ALTER TABLE `greatest` DISABLE KEYS */;
/*!40000 ALTER TABLE `greatest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `hanbai_tanka_average`
--

DROP TABLE IF EXISTS `hanbai_tanka_average`;
/*!50001 DROP VIEW IF EXISTS `hanbai_tanka_average`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hanbai_tanka_average` AS SELECT 
 1 AS `avg(hanbai_tanka)`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `jyushoroku`
--

DROP TABLE IF EXISTS `jyushoroku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jyushoroku` (
  `toroku_bango` int NOT NULL,
  `namae` varchar(128) NOT NULL,
  `jyusho` varchar(128) NOT NULL,
  `tel_no` char(10) DEFAULT NULL,
  `mail_address` char(20) DEFAULT NULL,
  `yubin_bango` char(8) NOT NULL,
  PRIMARY KEY (`toroku_bango`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jyushoroku`
--

LOCK TABLES `jyushoroku` WRITE;
/*!40000 ALTER TABLE `jyushoroku` DISABLE KEYS */;
/*!40000 ALTER TABLE `jyushoroku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `null_table`
--

DROP TABLE IF EXISTS `null_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `null_table` (
  `value` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `null_table`
--

LOCK TABLES `null_table` WRITE;
/*!40000 ALTER TABLE `null_table` DISABLE KEYS */;
INSERT INTO `null_table` VALUES (NULL),(NULL);
/*!40000 ALTER TABLE `null_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int DEFAULT NULL,
  `name` varchar(10) DEFAULT NULL,
  `col` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shohin`
--

DROP TABLE IF EXISTS `shohin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shohin` (
  `shohin_id` char(4) NOT NULL,
  `shohin_mei` varchar(100) NOT NULL,
  `shohin_bunrui` varchar(32) NOT NULL,
  `hanbai_tanka` int DEFAULT NULL,
  `shiire_tanka` int DEFAULT NULL,
  `torokubi` date DEFAULT NULL,
  PRIMARY KEY (`shohin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shohin`
--

LOCK TABLES `shohin` WRITE;
/*!40000 ALTER TABLE `shohin` DISABLE KEYS */;
INSERT INTO `shohin` VALUES ('0001','Tシャツ','衣服',1000,500,'2009-09-20'),('0002','穴あけパンチ','事務用品',500,320,'2009-09-11'),('0003','カッターシャツ','衣服',4000,2800,NULL),('0004','包丁','キッチン用品',3000,2800,'2009-09-20'),('0005','圧力鍋','キッチン用品',6800,5000,'2009-01-15'),('0006','フォーク','キッチン用品',500,NULL,'2009-09-20'),('0007','おろしがね','キッチン用品',880,790,'2008-04-28'),('0008','ボールペン','事務用品',100,NULL,'2009-11-11');
/*!40000 ALTER TABLE `shohin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shohin_bunrui`
--

DROP TABLE IF EXISTS `shohin_bunrui`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shohin_bunrui` (
  `shohin_bunrui` varchar(32) NOT NULL,
  `sum_hanbai_tanka` int NOT NULL,
  `sum_shiire_tanka` int NOT NULL,
  PRIMARY KEY (`shohin_bunrui`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shohin_bunrui`
--

LOCK TABLES `shohin_bunrui` WRITE;
/*!40000 ALTER TABLE `shohin_bunrui` DISABLE KEYS */;
/*!40000 ALTER TABLE `shohin_bunrui` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shohin_saeki`
--

DROP TABLE IF EXISTS `shohin_saeki`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shohin_saeki` (
  `shohin_id` char(4) NOT NULL,
  `shohin_mei` varchar(100) NOT NULL,
  `hanbai_tanka` int DEFAULT NULL,
  `shiire_tanka` int DEFAULT NULL,
  `saeki` int DEFAULT NULL,
  PRIMARY KEY (`shohin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shohin_saeki`
--

LOCK TABLES `shohin_saeki` WRITE;
/*!40000 ALTER TABLE `shohin_saeki` DISABLE KEYS */;
INSERT INTO `shohin_saeki` VALUES ('0001','Tシャツ',500,1000,500),('0002','穴あけパンチ',320,500,180),('0003','カッターシャツ',2800,4000,1200),('0004','包丁',2800,3000,200),('0005','圧力鍋',5000,6800,1800),('0006','フォーク',NULL,500,NULL),('0007','おろしがね',790,880,90),('0008','ボールペン',NULL,100,NULL),('0009','パソコン',NULL,NULL,NULL),('0010','Windows',NULL,NULL,NULL);
/*!40000 ALTER TABLE `shohin_saeki` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `shohin_view`
--

DROP TABLE IF EXISTS `shohin_view`;
/*!50001 DROP VIEW IF EXISTS `shohin_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `shohin_view` AS SELECT 
 1 AS `shohin_mei`,
 1 AS `hanbai_tanka`,
 1 AS `torokubi`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tenpo_shohin`
--

DROP TABLE IF EXISTS `tenpo_shohin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenpo_shohin` (
  `tenpo_id` char(4) NOT NULL,
  `tenpo_mei` varchar(200) NOT NULL,
  `shohin_id` char(4) NOT NULL,
  `suryo` int NOT NULL,
  PRIMARY KEY (`tenpo_id`,`shohin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenpo_shohin`
--

LOCK TABLES `tenpo_shohin` WRITE;
/*!40000 ALTER TABLE `tenpo_shohin` DISABLE KEYS */;
INSERT INTO `tenpo_shohin` VALUES ('000A','東京','0001',30),('000A','東京','0002',50),('000A','東京','0003',15),('000B','名古屋','0002',30),('000B','名古屋','0003',120),('000B','名古屋','0004',20),('000B','名古屋','0006',10),('000B','名古屋','0007',40),('000C','大阪','0003',20),('000C','大阪','0004',50),('000C','大阪','0006',90),('000C','大阪','0007',70),('000D','福岡','0001',100);
/*!40000 ALTER TABLE `tenpo_shohin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `shop`
--

USE `shop`;

--
-- Final view structure for view `hanbai_tanka_average`
--

/*!50001 DROP VIEW IF EXISTS `hanbai_tanka_average`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hanbai_tanka_average` AS select avg(`shohin`.`hanbai_tanka`) AS `avg(hanbai_tanka)` from `shohin` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `shohin_view`
--

/*!50001 DROP VIEW IF EXISTS `shohin_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `shohin_view` AS select `shohin`.`shohin_mei` AS `shohin_mei`,`shohin`.`hanbai_tanka` AS `hanbai_tanka`,`shohin`.`torokubi` AS `torokubi` from `shohin` where ((`shohin`.`hanbai_tanka` >= 1000) and (`shohin`.`torokubi` >= '2009-09-20')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-09 17:38:10
