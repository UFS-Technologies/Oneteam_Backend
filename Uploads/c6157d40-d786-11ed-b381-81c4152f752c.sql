-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: jubeerich
-- ------------------------------------------------------
-- Server version	8.0.27

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
-- Table structure for table `account_group`
--

DROP TABLE IF EXISTS `account_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_group` (
  `Account_Group_Id` int NOT NULL,
  `Primary_Id` int DEFAULT NULL,
  `Group_Code` varchar(50) DEFAULT NULL,
  `Group_Name` varchar(2000) DEFAULT NULL,
  `Link_Left` int DEFAULT NULL,
  `Link_Right` int DEFAULT NULL,
  `Under_Group` int DEFAULT NULL,
  `IsPrimary` varchar(1) DEFAULT NULL,
  `CanDelete` varchar(1) DEFAULT NULL,
  `UserId` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Account_Group_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group`
--

LOCK TABLES `account_group` WRITE;
/*!40000 ALTER TABLE `account_group` DISABLE KEYS */;
INSERT INTO `account_group` VALUES (1,2,'','Sundry Creditors',41,0,30,'N','N',12,0),(2,1,'','Employee',39,0,17,'N','N',12,0),(3,1,'SD','Sundry Debtors',13,34,17,'N','N',12,0),(4,2,'Bank Liab','Bank Libalities',1,0,30,'N','N',12,0),(5,1,'Bank Asc','Bank Asset',0,0,11,'N','N',12,0),(7,4,'DE','Direct Expense',9,42,32,'N','N',12,0),(8,3,'DI','Direct Income',10,27,31,'N','N',12,0),(9,4,'IDE','InDirect Expense',0,43,32,'N','N',12,0),(10,3,'IDI','InDirectIncome',0,0,31,'N','N',12,0),(11,1,'CA','Cash In Hand and Bank Bal',16,5,29,'N','N',12,0),(12,1,'COUNTER','Cash Counter',0,0,0,'N','N',12,0),(13,1,'BR','Branch',33,0,17,'N','N',12,0),(14,3,'Sa','Sales',0,0,0,'N','N',12,1),(15,4,'Pu','Purchase',0,0,0,'N','N',12,1),(16,1,'FA','Fixed Asset',17,36,29,'N','N',12,0),(17,1,'CA','Current Asset',0,3,29,'N','N',12,0),(18,2,'CP','Capital',0,0,0,'N','N',12,1),(19,1,'Cq','Cheque',0,0,0,'N','N',12,0),(20,1,'Crd','Card',0,0,0,'N','N',12,1),(21,2,'Ad','Advance Income',0,0,0,'N','N',12,1),(22,2,'TX','Tax',0,0,0,'N','N',12,0),(23,1,'AE','Advance Expence',0,0,0,'N','N',12,1),(24,4,'SR','SalesReutrn',0,0,0,'N','N',12,1),(25,3,'PR','PurchaseReturn',0,0,0,'N','N',12,1),(26,2,'PY','Payable',4,0,30,'N','N',12,0),(27,3,'ST','Stock Tran',0,0,8,'N','N',12,0),(28,2,'HO','HeadOffice',0,0,0,'N','N',12,1),(29,1,'Asset','Asset',0,11,29,'Y','N',12,0),(30,2,'Liability','Liability',0,26,30,'Y','N',12,0),(31,3,'Income','Income',0,8,31,'Y','N',12,0),(32,4,'Expenditure','Expenditure',0,7,32,'Y','N',12,0),(33,4,'','OFFICE EXPENSE',34,0,9,'N','Y',12,0),(34,1,'','SUSPENCE A/C',0,0,17,'N','Y',12,0),(36,1,'','Supplier Foreign',0,0,1,'N','Y',12,0),(37,2,'','Supplier Local',0,0,1,'N','Y',12,0),(38,1,'','Customer Foreign',0,0,1,'N','Y',12,0),(39,1,'','Customer Local',0,0,1,'N','Y',12,0),(40,2,'2','Employee',0,0,9,'N','Y',12,0),(41,2,'1','New GRP',0,0,1,'1','',0,1),(42,2,'1','qqqqq',0,0,1,'','',0,1),(43,2,'2','aaaa',0,0,2,'','',0,1),(44,2,'4','ssss',0,0,4,'','',0,0),(45,2,'2','jITHU',0,0,2,'','',0,1),(46,2,'3','safeeda',0,0,3,'','',0,1),(47,2,'2','Zaina',0,0,2,'','',0,0),(48,2,'2','sss',0,0,2,'','',0,0);
/*!40000 ALTER TABLE `account_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `Accounts_Id` int NOT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  `Client_Id` bigint DEFAULT NULL,
  `Dr` decimal(18,2) DEFAULT NULL,
  `Cr` decimal(18,2) DEFAULT NULL,
  `Tran_Type` varchar(5) DEFAULT NULL,
  `Tran_Id` bigint DEFAULT NULL,
  `Voucher_No` bigint DEFAULT NULL,
  `VoucherType` bigint DEFAULT NULL,
  `Description1` varchar(4000) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `DayBook` varchar(1) DEFAULT NULL,
  `Payment_Status` bigint DEFAULT NULL,
  PRIMARY KEY (`Accounts_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent`
--

DROP TABLE IF EXISTS `agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent` (
  `Agent_Id` int NOT NULL,
  `Agent_Name` varchar(150) DEFAULT NULL,
  `Phone` varchar(45) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Address` varchar(500) DEFAULT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `User_Name` varchar(150) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Enquiry_Source_Id` int DEFAULT NULL,
  `Agent_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Agent_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent`
--

LOCK TABLES `agent` WRITE;
/*!40000 ALTER TABLE `agent` DISABLE KEYS */;
INSERT INTO `agent` VALUES (1,'Krishna Consultants','','','','',0,NULL,NULL,NULL,NULL),(2,'APPLY B','','','','',0,NULL,NULL,NULL,NULL),(3,'DIRECT','','','','',0,NULL,NULL,NULL,NULL),(4,'KANAN','','','','',0,NULL,NULL,NULL,NULL),(5,'ADMISSION DIRECT','','','','',0,NULL,NULL,NULL,NULL),(6,'MSM','','','','',0,NULL,NULL,NULL,NULL),(7,'JUSTIN SWEDEN','','','','',0,NULL,NULL,NULL,NULL),(8,'STUDY GROUP','','','','',0,NULL,NULL,NULL,NULL),(9,'STUDY GROUP1','','','','',0,NULL,NULL,NULL,NULL),(10,'SCHOOL APPLY','','','','',0,NULL,NULL,NULL,NULL),(11,'Study Portal','','','','',0,NULL,NULL,NULL,NULL),(12,'adventus.io','','','','',0,NULL,NULL,NULL,NULL),(13,'Cosmos','','','','',0,NULL,NULL,NULL,NULL),(14,'DIRECT-SF','','','','',0,NULL,NULL,NULL,NULL),(15,'dd','','','','',0,NULL,NULL,NULL,NULL),(16,'r','1231231231','f@dfb','xxx','testvs',0,'testing','123',1,1),(17,'test','7845124710','test123@gmail.com','xxx','testvs',0,'testing','123',1,1),(18,'testqwer','7845125874','testwww123@gmail.com','xxxqwqwq','testvsqwqwwq',0,'testingwqwwq','1234',NULL,1),(19,'testqwervcvcv','7845125874','testwww1c23@gmail.com','xxxqwqwqcvcvc','testvsqwqwwqcccc',0,'testingwqwwqcc','12345',91,1),(20,'Agent1','7845123695','agent123@gmail.com','xxxff','testagent',0,'agent','123@agent',92,1),(21,'fff','7845125875','testff123@gmail.com','ddfd','ffff',0,'testingff','123',93,1),(22,'ffffffffffffffffff','8574123650','fffffffff123@gmail.com','eeee','testvseee',0,'test123','1232',94,1),(23,'ggg','7845125874','gggt123@gmail.com','ggggrrrr','dfdfdfdfd',0,'fgfg','123',96,1),(24,'useragent','8956320014','useragent123@gmail.com','sdds','testvsss',0,'uagent','123@uagent',98,1),(25,'fdff','7845123698','dfsdfs','dfddf','dff',0,'dsfdffff','789',99,1),(26,'sxssxx','8956231478','test12sxsx3@gmail.com','ssssaaaa','ssass',0,'ss','s',100,1),(27,'2903023test','7441525847','2903023test123@gmail.com','dedesdewr','csdsfdrfgrgth',0,'2903023testdddd','ddd',101,1),(28,'dfghij','7485962541','dfghij23@gmail.com','erer','testvs',0,'qw','1',102,1),(29,'enqddd','7845125874','enq','ds','enqfgfg',0,'enq','enq123',104,1),(30,'test3003023','8956235874','test3003023@gmail.com','nbnb','nbnbn',0,'g','1',106,1),(31,'vvv3003023','8956324171','ddd123@gmail.com','xxx;plp[lp[','testvs',0,'testingdddd','1',108,1),(32,'TestAgent3003023','9848651532','TestAgent3003023@gmail.com','xyxyx','test@3003023',0,'test','1',109,1);
/*!40000 ALTER TABLE `agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_country`
--

DROP TABLE IF EXISTS `agent_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_country` (
  `Agent_Country_Id` int NOT NULL,
  `Agent_Country_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Agent_Country_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_country`
--

LOCK TABLES `agent_country` WRITE;
/*!40000 ALTER TABLE `agent_country` DISABLE KEYS */;
INSERT INTO `agent_country` VALUES (1,'UK',0),(2,'Canada',0),(3,'Newyork',0);
/*!40000 ALTER TABLE `agent_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `all_time_departments`
--

DROP TABLE IF EXISTS `all_time_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `all_time_departments` (
  `All_Time_Departments` int NOT NULL AUTO_INCREMENT,
  `Department_Id` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `View` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`All_Time_Departments`)
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `all_time_departments`
--

LOCK TABLES `all_time_departments` WRITE;
/*!40000 ALTER TABLE `all_time_departments` DISABLE KEYS */;
INSERT INTO `all_time_departments` VALUES (270,317,83,1,0),(271,318,83,1,0),(272,322,83,1,0),(273,323,83,1,0),(274,326,83,1,0),(275,327,83,1,0),(276,329,83,1,0),(277,330,83,1,0),(278,332,83,1,0),(279,333,83,1,0),(280,335,83,1,0),(281,343,83,1,0),(282,344,83,1,0),(283,345,83,1,0),(319,348,86,1,0),(321,322,88,1,0),(324,347,91,1,0),(325,348,92,1,0),(326,349,93,1,0),(327,322,94,1,0),(328,317,95,1,0),(329,318,95,1,0),(330,322,95,1,0),(331,323,95,1,0),(332,326,95,1,0),(333,327,95,1,0),(334,329,95,1,0),(335,330,95,1,0),(336,332,95,1,0),(337,333,95,1,0),(338,335,95,1,0),(339,343,95,1,0),(340,344,95,1,0),(341,345,95,1,0),(342,346,95,1,0),(343,347,95,1,0),(344,348,95,1,0),(345,349,95,1,0),(396,317,97,1,0),(397,318,97,1,0),(398,322,97,1,0),(399,323,97,1,0),(400,326,97,1,0),(401,333,97,1,0),(402,335,97,1,0),(403,343,97,1,0),(404,345,97,1,0),(405,346,97,1,0),(406,347,97,1,0),(407,348,97,1,0),(408,349,97,1,0),(409,347,85,1,0),(489,349,87,1,0),(516,317,103,1,0),(517,318,103,1,0),(518,322,103,1,0),(519,323,103,1,0),(520,326,103,1,0),(521,333,103,1,0),(522,335,103,1,0),(523,343,103,1,0),(524,345,103,1,0),(525,317,89,1,0),(526,318,89,1,0),(527,322,89,1,0),(528,323,89,1,0),(529,326,89,1,0),(530,333,89,1,0),(531,335,89,1,0),(532,343,89,1,0),(533,345,89,1,0),(534,346,89,1,0),(535,347,89,1,0),(536,348,89,1,0),(537,349,89,1,0);
/*!40000 ALTER TABLE `all_time_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_condition`
--

DROP TABLE IF EXISTS `application_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_condition` (
  `Application_Condition` int NOT NULL,
  `Application_Condition_Name` varchar(500) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Application_Condition`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_condition`
--

LOCK TABLES `application_condition` WRITE;
/*!40000 ALTER TABLE `application_condition` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_details`
--

DROP TABLE IF EXISTS `application_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_details` (
  `Application_details_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Id` int DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `Country_Name` varchar(1000) DEFAULT NULL,
  `University_Id` int DEFAULT NULL,
  `University_Name` varchar(1000) DEFAULT NULL,
  `Course_Id` int DEFAULT NULL,
  `Course_Name` varchar(1000) DEFAULT NULL,
  `intake_Id` int DEFAULT NULL,
  `intake_Name` varchar(150) DEFAULT NULL,
  `Intake_Year_Id` int DEFAULT NULL,
  `Intake_Year_Name` varchar(45) DEFAULT NULL,
  `Date_Of_Applying` datetime(6) DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Application_status_Id` int DEFAULT NULL,
  `Application_Status_Name` varchar(45) DEFAULT NULL,
  `Agent_Id` int DEFAULT NULL,
  `Agent_Name` varchar(150) DEFAULT NULL,
  `Reference_No` int DEFAULT NULL,
  `Activation_Status` tinyint unsigned DEFAULT NULL,
  `SlNo` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Application_No` varchar(45) DEFAULT NULL,
  `Student_Reference_Id` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Course_Fee` varchar(45) DEFAULT NULL,
  `Living_Expense` varchar(45) DEFAULT NULL,
  `Bph_Approved_Status` tinyint unsigned DEFAULT NULL,
  `Bph_Approved_By` int DEFAULT NULL,
  `Bph_Approved_Date` datetime(6) DEFAULT NULL,
  `Student_Approved_Status` tinyint unsigned DEFAULT NULL,
  `Paid_Status` tinyint unsigned DEFAULT NULL,
  `Application_Fees_Paid` varchar(45) DEFAULT NULL,
  `Preference` varchar(100) DEFAULT NULL,
  `Application_Source` tinyint unsigned DEFAULT NULL,
  `Bph_Remark` varchar(1000) DEFAULT NULL,
  `Portal_User_Name` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Offer_Student_Id` varchar(45) DEFAULT NULL,
  `Fees_Payment_Last_Date` datetime(6) DEFAULT NULL,
  `Feespaymentcheck` tinyint unsigned DEFAULT NULL,
  `Offer_Received` tinyint unsigned DEFAULT NULL,
  `Duration_Id` int DEFAULT NULL,
  `url` longtext,
  `Offerletter_Type_Id` int DEFAULT NULL,
  `Offerletter_Type_Name` varchar(45) DEFAULT NULL,
  `Student_Name` varchar(500) DEFAULT NULL,
  `Is_Entrolled` tinyint DEFAULT NULL,
  `To_User_Id` int DEFAULT NULL,
  PRIMARY KEY (`Application_details_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_details`
--

LOCK TABLES `application_details` WRITE;
/*!40000 ALTER TABLE `application_details` DISABLE KEYS */;
INSERT INTO `application_details` VALUES (1,4,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',8,'July',24,'2033','2023-03-18 00:00:00.000000','11',9,'Visa Completed',3,'DIRECT',NULL,0,1,87,'lujhkjh','',0,'','',1,NULL,NULL,0,NULL,'-1','12',1,NULL,'','','','2023-03-18 00:00:00.000000',0,0,0,NULL,NULL,NULL,'D',1,NULL),(2,3,40,'Australia, Canada, Ireland, NZ, UK',21,'Aston University',22,'Accounting related',15,'November',23,'2032','2023-03-18 00:00:00.000000','w',2,'Lodgment Pending',9,'STUDY GROUP1',NULL,0,1,89,NULL,'',0,'','',1,NULL,NULL,0,NULL,'-1','1',1,NULL,'','','','2023-03-18 00:00:00.000000',0,0,0,NULL,1,'Conditional','C',0,84),(3,2,26,'Bulgaria',9,'Cambrian College',45,'Automotive',14,'October',23,'2032','2023-03-18 00:00:00.000000','f',2,'Lodgment Pending',4,'KANAN',NULL,0,1,89,NULL,'',0,'','',1,NULL,NULL,0,NULL,'-1','f',1,NULL,'','','','2023-03-18 00:00:00.000000',0,0,0,NULL,1,'Conditional','B',0,90),(4,1,50,'Canada, NZ, Australia',20,'Bournemouth University',36,'Autism and Behavioral Therapy',8,'July',23,'2032','2023-03-18 00:00:00.000000','q',9,'Visa Completed',2,'APPLY B',NULL,0,1,87,'12345','',0,'','',1,NULL,NULL,0,NULL,'-1','q',1,NULL,'','','','2023-03-18 00:00:00.000000',0,0,0,NULL,NULL,NULL,'A',1,87),(5,1,53,'Canada, UK, Germany, Switzerland',9,'Cambrian College',36,'Autism and Behavioral Therapy',11,'May',14,'2025','2023-03-18 00:00:00.000000','',1,'Application Created',0,'Select',NULL,0,2,89,'','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-18 00:00:00.000000',0,0,0,NULL,NULL,NULL,'A',1,94),(6,5,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-20 00:00:00.000000','',4,'Offer Pending',3,'DIRECT',NULL,0,1,85,NULL,'',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','D',1,85),(7,6,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',6,'February',23,'2032','2023-03-20 00:00:00.000000','',1,'Application Created',0,'Select',NULL,0,1,83,'','',1,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,NULL,NULL,'bincy',1,94),(8,8,16,'Austria',23,'Regent\'s University London',25,'Accounting and Finance MSc',11,'May',13,'2024','2023-03-20 00:00:00.000000','',5,'Offer Received',1,'Krishna Consultants',NULL,0,1,85,'234','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','F',1,89),(9,8,42,'Canada, Germany',13,' SHEFFIELD HALLAM',22,'Accounting related',10,'Others',10,'2021','2023-03-20 00:00:00.000000','',7,'visa Pending',4,'KANAN',NULL,0,2,86,'234','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','F',1,88),(10,7,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',10,'Others',10,'2021','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',4,'KANAN',NULL,0,1,89,'234','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','E',0,90),(11,7,54,'Australia, Canada',20,'Bournemouth University',36,'Autism and Behavioral Therapy',8,'July',6,'2018','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',6,'MSM',NULL,0,2,89,'123','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,NULL,NULL,'E',0,NULL),(12,9,40,'Australia, Canada, Ireland, NZ, UK',21,'Aston University',36,'Autism and Behavioral Therapy',10,'Others',11,'2022','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',1,'Krishna Consultants',NULL,0,1,84,'s','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','G',1,84),(13,9,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',22,'2031','2023-03-20 00:00:00.000000','',6,'Student Approval',5,'ADMISSION DIRECT',NULL,0,2,89,'1234','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','G',1,86),(14,10,25,'Cyprus',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',13,'2024','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',3,'DIRECT',NULL,0,1,89,'r3','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','H',1,93),(15,11,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-20 00:00:00.000000','',4,'Offer Pending',5,'ADMISSION DIRECT',NULL,0,1,85,'q2w32','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-20 00:00:00.000000',0,0,0,NULL,1,'Conditional','1',1,85),(16,13,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',6,'2018','2023-03-21 00:00:00.000000','',1,'Application Created',0,'Select',NULL,0,1,89,'','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-21 00:00:00.000000',0,0,0,NULL,NULL,NULL,'1',0,NULL),(17,14,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',7,'March',6,'2018','2023-03-21 00:00:00.000000','',2,'Lodgment Pending',2,'APPLY B',NULL,0,1,89,'ff','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-21 00:00:00.000000',0,0,0,NULL,NULL,NULL,'2',1,NULL),(18,15,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',7,'2019','2023-03-21 00:00:00.000000','',2,'Lodgment Pending',2,'APPLY B',NULL,0,1,89,'r4','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-21 00:00:00.000000',0,0,0,NULL,NULL,NULL,'3',1,NULL),(19,16,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',5,'January',6,'2018','2023-03-21 00:00:00.000000','',4,'Offer Pending',5,'ADMISSION DIRECT',NULL,0,1,85,'1332','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-21 00:00:00.000000',0,0,0,NULL,1,'Conditional','4',1,85),(20,21,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-23 00:00:00.000000','5',1,'Application Created',0,'Select',NULL,0,1,89,'','',0,'','',1,NULL,NULL,0,NULL,'-1','e4',1,NULL,'','','','2023-03-23 00:00:00.000000',0,0,0,NULL,NULL,NULL,'xyz',0,NULL),(21,23,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',6,'February',22,'2031','2023-03-23 00:00:00.000000','df',3,'Lodgment',2,'APPLY B',NULL,0,1,84,'7yt','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-23 00:00:00.000000',0,0,0,NULL,1,'Conditional','rst',1,91),(22,24,6,'Australia',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',21,'April',22,'2031','2023-03-23 00:00:00.000000','',3,'Lodgment',4,'KANAN',NULL,0,1,89,'r4','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-23 00:00:00.000000',0,0,0,NULL,1,'Conditional','dd',1,85),(23,28,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',6,'February',5,'2017','2023-03-28 00:00:00.000000','',2,'Lodgment Pending',1,'Krishna Consultants',NULL,0,1,89,'ss','',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-28 00:00:00.000000',0,0,0,NULL,NULL,NULL,'dd1',1,84),(24,29,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',6,'2018','2023-03-28 00:00:00.000000','',2,'Lodgment Pending',0,'Select',NULL,0,1,89,NULL,'',0,'','',1,NULL,NULL,0,NULL,'-1','',1,NULL,'','','','2023-03-28 00:00:00.000000',0,0,0,NULL,NULL,NULL,'qq1',0,90);
/*!40000 ALTER TABLE `application_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_details_history`
--

DROP TABLE IF EXISTS `application_details_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_details_history` (
  `Application_details_history_Id` int NOT NULL AUTO_INCREMENT,
  `Application_details_Id` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `Country_Name` varchar(1000) DEFAULT NULL,
  `University_Id` int DEFAULT NULL,
  `University_Name` varchar(1000) DEFAULT NULL,
  `Course_Id` int DEFAULT NULL,
  `Course_Name` varchar(1000) DEFAULT NULL,
  `intake_Id` int DEFAULT NULL,
  `intake_Name` varchar(150) DEFAULT NULL,
  `Intake_Year_Id` int DEFAULT NULL,
  `Intake_Year_Name` varchar(45) DEFAULT NULL,
  `date_Of_Applying` datetime(6) DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Application_status_Id` int DEFAULT NULL,
  `Application_Status_Name` varchar(45) DEFAULT NULL,
  `Agent_Id` int DEFAULT NULL,
  `Agent_Name` varchar(150) DEFAULT NULL,
  `SlNo` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Activation_Status` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Entry_Date` date DEFAULT NULL,
  `Course_Fee` varchar(45) DEFAULT NULL,
  `Living_Expense` varchar(45) DEFAULT NULL,
  `Bph_Approved_Status` tinyint unsigned DEFAULT NULL,
  `Bph_Approved_By` int DEFAULT NULL,
  `Bph_Approved_Date` datetime(6) DEFAULT NULL,
  `Student_Approved_Status` tinyint unsigned DEFAULT NULL,
  `Paid_Status` tinyint unsigned DEFAULT NULL,
  `Application_Fees_Paid` varchar(45) DEFAULT NULL,
  `Preference` varchar(100) DEFAULT NULL,
  `Bph_Remark` varchar(1000) DEFAULT NULL,
  `url` longtext,
  `Application_No` varchar(45) DEFAULT NULL,
  `Offerletter_Type_Id` int DEFAULT NULL,
  `Offerletter_Type_Name` varchar(45) DEFAULT NULL,
  `Student_Name` varchar(500) DEFAULT NULL,
  `Is_Entrolled` tinyint DEFAULT NULL,
  PRIMARY KEY (`Application_details_history_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_details_history`
--

LOCK TABLES `application_details_history` WRITE;
/*!40000 ALTER TABLE `application_details_history` DISABLE KEYS */;
INSERT INTO `application_details_history` VALUES (1,1,4,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',8,'July',24,'2033','2023-03-18 00:00:00.000000','11',6,'Student Approval',7,'JUSTIN SWEDEN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'12',NULL,NULL,'890',NULL,NULL,'D',0),(2,2,3,40,'Australia, Canada, Ireland, NZ, UK',21,'Aston University',22,'Accounting related',15,'November',23,'2032','2023-03-18 00:00:00.000000','w',2,'Lodgment Pending',9,'STUDY GROUP1',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'1',NULL,NULL,NULL,1,'Conditional','C',0),(3,3,2,26,'Bulgaria',9,'Cambrian College',45,'Automotive',14,'October',23,'2032','2023-03-18 00:00:00.000000','f',2,'Lodgment Pending',4,'KANAN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'f',NULL,NULL,NULL,1,'Conditional','B',0),(4,4,1,50,'Canada, NZ, Australia',20,'Bournemouth University',36,'Autism and Behavioral Therapy',8,'July',23,'2032','2023-03-18 00:00:00.000000','q',6,'Student Approval',2,'APPLY B',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'q',NULL,NULL,'2',NULL,NULL,'A',0),(5,5,1,53,'Canada, UK, Germany, Switzerland',9,'Cambrian College',36,'Autism and Behavioral Therapy',11,'May',14,'2025','2023-03-18 00:00:00.000000','',1,'Application Created',0,'Select',2,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,'A',0),(6,6,5,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-20 00:00:00.000000','',1,'Application Created',0,'Select',1,83,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,1,'Conditional','D',0),(7,7,6,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',6,'February',23,'2032','2023-03-20 00:00:00.000000','',1,'Application Created',0,'Select',1,83,0,1,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,'bincy',0),(8,8,8,16,'Austria',23,'Regent\'s University London',25,'Accounting and Finance MSc',11,'May',13,'2024','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',4,'KANAN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'123as',1,'Conditional','F',0),(9,9,8,42,'Canada, Germany',13,' SHEFFIELD HALLAM',22,'Accounting related',10,'Others',10,'2021','2023-03-20 00:00:00.000000','',6,'Student Approval',7,'JUSTIN SWEDEN',2,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,1,'Conditional','F',0),(10,10,7,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',10,'Others',10,'2021','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',4,'KANAN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'234',1,'Conditional','E',0),(11,11,7,54,'Australia, Canada',20,'Bournemouth University',36,'Autism and Behavioral Therapy',8,'July',6,'2018','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',6,'MSM',2,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'123',NULL,NULL,'E',0),(12,12,9,40,'Australia, Canada, Ireland, NZ, UK',21,'Aston University',36,'Autism and Behavioral Therapy',10,'Others',11,'2022','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',7,'JUSTIN SWEDEN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,1,'Conditional','G',0),(13,13,9,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',22,'2031','2023-03-20 00:00:00.000000','',6,'Student Approval',5,'ADMISSION DIRECT',2,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'1234',1,'Conditional','G',0),(14,14,10,25,'Cyprus',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',13,'2024','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',3,'DIRECT',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'r3',1,'Conditional','H',0),(15,15,11,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-20 00:00:00.000000','',2,'Lodgment Pending',6,'MSM',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'123ertret',1,'Conditional','1',0),(16,16,13,54,'Australia, Canada',19,'	Regent\'s University London',25,'Accounting and Finance MSc',5,'January',6,'2018','2023-03-21 00:00:00.000000','',1,'Application Created',0,'Select',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,'1',0),(17,17,14,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',7,'March',6,'2018','2023-03-21 00:00:00.000000','',2,'Lodgment Pending',2,'APPLY B',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'ff',NULL,NULL,'2',1),(18,18,15,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',7,'2019','2023-03-21 00:00:00.000000','',2,'Lodgment Pending',2,'APPLY B',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'r4',NULL,NULL,'3',1),(19,19,16,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',5,'January',6,'2018','2023-03-21 00:00:00.000000','',2,'Lodgment Pending',3,'DIRECT',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'r4',1,'Conditional','4',1),(20,20,21,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',5,'January',24,'2033','2023-03-23 00:00:00.000000','5',1,'Application Created',0,'Select',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'e4',NULL,NULL,NULL,NULL,NULL,'xyz',0),(21,21,23,54,'Australia, Canada',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',6,'February',22,'2031','2023-03-23 00:00:00.000000','df',2,'Lodgment Pending',1,'Krishna Consultants',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'j6',1,'Conditional','rst',1),(22,22,24,6,'Australia',13,' SHEFFIELD HALLAM',25,'Accounting and Finance MSc',21,'April',22,'2031','2023-03-23 00:00:00.000000','',3,'Lodgment',4,'KANAN',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'r4',1,'Conditional','dd',1),(23,23,28,6,'Australia',19,'	Regent\'s University London',25,'Accounting and Finance MSc',6,'February',5,'2017','2023-03-28 00:00:00.000000','',2,'Lodgment Pending',1,'Krishna Consultants',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,'ss',NULL,NULL,'dd1',1),(24,24,29,54,'Australia, Canada',13,' SHEFFIELD HALLAM',22,'Accounting related',6,'February',6,'2018','2023-03-28 00:00:00.000000','',2,'Lodgment Pending',0,'Select',1,89,0,0,NULL,'','',1,NULL,NULL,0,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,'qq1',0);
/*!40000 ALTER TABLE `application_details_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_document`
--

DROP TABLE IF EXISTS `application_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_document` (
  `Application_Document_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` date DEFAULT NULL,
  `ApplicationFile_Name` varchar(500) DEFAULT NULL,
  `ApplicationDocument_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `ApplicationDocument_Name` varchar(500) DEFAULT NULL,
  `ApplicationDocument_File_Name` varchar(500) DEFAULT NULL,
  `Application_details_Id` int DEFAULT NULL,
  PRIMARY KEY (`Application_Document_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_document`
--

LOCK TABLES `application_document` WRITE;
/*!40000 ALTER TABLE `application_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_group`
--

DROP TABLE IF EXISTS `application_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_group` (
  `Application_Group_Id` int NOT NULL,
  `Application_Group_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Application_Group_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_group`
--

LOCK TABLES `application_group` WRITE;
/*!40000 ALTER TABLE `application_group` DISABLE KEYS */;
INSERT INTO `application_group` VALUES (1,'AG1',0),(2,'AG2',0),(3,'AG3',0),(4,'AG4',0),(5,'AG5',0),(6,'AG6',0),(7,'AG7',0),(8,'AG8',0),(9,'AG9',0),(10,'AG10',0),(11,'AG11',0),(12,'Student',0);
/*!40000 ALTER TABLE `application_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_master`
--

DROP TABLE IF EXISTS `application_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_master` (
  `Application_Master_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Student_Number` varchar(50) DEFAULT NULL,
  `Proceeding_University_Id` int DEFAULT NULL,
  `Total_Fees` decimal(18,2) DEFAULT NULL,
  `scholarship` decimal(18,2) DEFAULT NULL,
  `Net_Fees_To_Pay` decimal(18,2) DEFAULT NULL,
  `Paid_Fees` decimal(18,2) DEFAULT NULL,
  `Fee_Paid_Status` tinyint unsigned DEFAULT NULL,
  `Fee_Paid_Date` date DEFAULT NULL,
  `Balance_Fee` decimal(18,2) DEFAULT NULL,
  `Course_Start_Status` tinyint unsigned DEFAULT NULL,
  `Course_Start_Date` date DEFAULT NULL,
  `Extension_Status` tinyint unsigned DEFAULT NULL,
  `Extension_Date` date DEFAULT NULL,
  `Expected_Visa_Status` tinyint unsigned DEFAULT NULL,
  `Relationship_with_Sponser` varchar(150) DEFAULT NULL,
  `Condition_To_Meet` varchar(150) DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `Course_Id` int DEFAULT NULL,
  `Intake_Id` int DEFAULT NULL,
  `Joining_Year` varchar(10) DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `Currency` varchar(50) DEFAULT NULL,
  `Partner_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Intake_Name` varchar(45) DEFAULT NULL,
  `Year_Name` varchar(45) DEFAULT NULL,
  `Partner_Name` varchar(45) DEFAULT NULL,
  `Country_Name` varchar(100) DEFAULT NULL,
  `Course_Name` varchar(500) DEFAULT NULL,
  `University_Name` varchar(500) DEFAULT NULL,
  `Year_Id` int DEFAULT NULL,
  PRIMARY KEY (`Application_Master_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_master`
--

LOCK TABLES `application_master` WRITE;
/*!40000 ALTER TABLE `application_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_settings`
--

DROP TABLE IF EXISTS `application_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_settings` (
  `Application_Settings_Id` int NOT NULL,
  `Settings_Group_Id` int DEFAULT NULL,
  `Settings_Name` varchar(45) DEFAULT NULL,
  `Settings_Value` varchar(45) DEFAULT NULL,
  `Editable` tinyint DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Register_Transfer_Status` tinyint DEFAULT NULL,
  `Department_Id_Created` int DEFAULT NULL,
  `Created_Transfer_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Application_Settings_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_settings`
--

LOCK TABLES `application_settings` WRITE;
/*!40000 ALTER TABLE `application_settings` DISABLE KEYS */;
INSERT INTO `application_settings` VALUES (1,1,'Calling','1',1,0,348,1,348,1);
/*!40000 ALTER TABLE `application_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_status`
--

DROP TABLE IF EXISTS `application_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_status` (
  `Application_status_Id` int NOT NULL,
  `Application_Status_Name` varchar(45) DEFAULT NULL,
  `Application_Group_Id` int DEFAULT NULL,
  `Application_Group_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Notification_Department_Id` int DEFAULT NULL,
  `Notification_Department_Name` varchar(45) DEFAULT NULL,
  `Transfer_Department_Id` int DEFAULT NULL,
  `Transfer_Department_Name` varchar(45) DEFAULT NULL,
  `Transfer_Status` tinyint DEFAULT NULL,
  `Notification_Status` tinyint DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Group_Restriction` int DEFAULT NULL,
  PRIMARY KEY (`Application_status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_status`
--

LOCK TABLES `application_status` WRITE;
/*!40000 ALTER TABLE `application_status` DISABLE KEYS */;
INSERT INTO `application_status` VALUES (1,'Application Created',1,'AG1',0,0,'Select',0,'Select',0,0,NULL,0),(2,'Lodgment Pending',2,'AG2',0,346,'Lodgment',346,'Lodgment',1,1,NULL,0),(3,'Lodgment',2,'AG2',0,347,'Offer Chase',347,'Offer Chase',1,1,NULL,0),(4,'Offer Pending',3,'AG3',0,347,'Offer Chase',347,'Offer Chase',1,1,NULL,0),(5,'Offer Received',3,'AG3',0,317,'Admissions',317,'Admissions',1,1,NULL,12),(6,'Student Approval',12,'Student',0,348,'Offer Clearence',348,'Offer Clearence',1,1,NULL,0),(7,'visa Pending',9,'AG9',0,322,'Visa',322,'Visa',1,1,NULL,0),(8,'Visa Approved',10,'AG10',0,349,'Review',349,'Review',1,1,NULL,0),(9,'Visa Completed',11,'AG11',0,349,'Review',349,'Review',1,1,NULL,0),(10,'test',1,'AG1',1,0,'Select',0,'Select',0,0,NULL,0),(11,'Student Rejected',12,'Student',0,0,'Select',0,'Select',0,0,NULL,0),(12,'Student Holding',12,'Student',0,0,'Select',0,'Select',0,0,NULL,0),(13,'4',1,'AG1',1,0,'Select',0,'Select',1,0,NULL,0),(14,'g',1,'AG1',1,0,'Select',0,'Select',0,0,NULL,0),(15,'1',1,'AG1',0,0,'Select',0,'Select',0,0,NULL,0),(16,'Application Created111',1,'AG1',0,0,'Select',0,'Select',1,0,NULL,0),(17,'1',10,'AG10',0,0,'Select',0,'Select',1,0,NULL,0),(18,'44',10,'AG10',0,0,'Select',0,'Select',1,1,NULL,0);
/*!40000 ALTER TABLE `application_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bph_status`
--

DROP TABLE IF EXISTS `bph_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bph_status` (
  `Bph_Status_Id` int NOT NULL,
  `Bph_Status_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Bph_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bph_status`
--

LOCK TABLES `bph_status` WRITE;
/*!40000 ALTER TABLE `bph_status` DISABLE KEYS */;
INSERT INTO `bph_status` VALUES (1,'Pending',0),(2,'Approved',0),(3,'Rejected',0);
/*!40000 ALTER TABLE `bph_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `Branch_Id` int NOT NULL,
  `Branch_Name` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `District` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `PinCode` varchar(50) DEFAULT NULL,
  `Phone_Number` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Branch_Code` varchar(10) DEFAULT NULL,
  `Company` int DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  `Default_Department_Id` int DEFAULT NULL,
  `Default_Department_Name` varchar(250) DEFAULT NULL,
  `Default_User_Id` int DEFAULT NULL,
  `Default_User_Name` varchar(250) DEFAULT NULL,
  `Default_Status_Id` int DEFAULT NULL,
  `Default_Status_Name` varchar(250) DEFAULT NULL,
  `Is_FollowUp` tinyint DEFAULT NULL,
  PRIMARY KEY (`Branch_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (36,'Kochin','edabroad','Mangalath Building','Panampilly Nagar','Cochin-36','','','987456123','kochi@royaleducationgroup.com','',0,0,343,'Tele Caller',NULL,NULL,154,'New lead',NULL),(38,'Kottayam','A2','L2','D2','S2','C2','456789','654789123','studyabroad@royaleducationgroup.com','',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(41,'Angamaly','A3','L3','D3','S3','C3','654123','658974562','angamaly@royaleducationgroup.com','',0,0,322,'Visa',88,'Bincy',183,'Visa submitted',1),(43,'Thrissur','Thrissur','Thrissur','Thrissur','kerala','India',' ','9526250005','info@royaleducationgroup.com','',0,0,343,'Tele Caller',NULL,NULL,154,'New lead',NULL),(44,'Trivandrum','REG','Lenskart Building','Pattom','Kerala','India','','9288014907','aum@regimmigration.com','',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(45,'Thodupuzha','First Floor, Ellickal building','Thodupuzha','Idukki','Kerala','India','','9288014907','aum@regimmigration.com','',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(46,'Kozhikode','REG Immigration and Education','Lenskart Building','Kozhikode','Kerala','India','','','','',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(47,'Test123','','','','','','','','','',0,1,343,'Tele Caller',112,'Roshan',154,'New lead',1),(49,'ererette','','','','','','','','','',0,1,317,'Admissions',NULL,NULL,160,'Application follow up',1),(50,'uiuou','','','','','','','','','',0,1,322,'Visa',0,'',183,'Visa submitted',1),(51,'cccc','','','','','','','','','',0,1,318,'Accounts',NULL,NULL,172,'Call not connected',1),(52,'Kochi11','','','','','','','','','',0,1,317,'Admissions',NULL,NULL,160,'Application follow up',1),(53,'s','','','','','','','','','',0,1,317,'Admissions',NULL,NULL,160,'Application follow up',1);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch_department`
--

DROP TABLE IF EXISTS `branch_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch_department` (
  `Branch_Department_Id` int NOT NULL AUTO_INCREMENT,
  `Branch_Id` int DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Is_Delete` tinyint DEFAULT NULL,
  PRIMARY KEY (`Branch_Department_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch_department`
--

LOCK TABLES `branch_department` WRITE;
/*!40000 ALTER TABLE `branch_department` DISABLE KEYS */;
INSERT INTO `branch_department` VALUES (4,56,333,0),(5,56,345,0),(10,48,323,0),(44,41,347,0),(45,41,333,0),(46,41,335,0),(47,41,323,0),(48,41,345,0),(49,41,346,0),(50,41,317,0),(51,41,348,0),(52,41,318,0),(53,41,322,0),(54,41,349,0),(55,41,326,0),(56,41,343,0);
/*!40000 ALTER TABLE `branch_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_list`
--

DROP TABLE IF EXISTS `check_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_list` (
  `Check_List_Id` int NOT NULL,
  `Check_List_Name` varchar(100) DEFAULT NULL,
  `Applicable` tinyint unsigned DEFAULT NULL,
  `Checklist_Status` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Check_List_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_list`
--

LOCK TABLES `check_list` WRITE;
/*!40000 ALTER TABLE `check_list` DISABLE KEYS */;
INSERT INTO `check_list` VALUES (46,'10TH GRADE',0,0,0),(47,'12TH Grade',0,0,0),(48,'Semester 1',0,0,0),(49,'U G Certificate',0,0,0),(50,'P.G Certificate',0,0,0),(51,'SOP',0,0,0),(52,'L O R',0,0,0),(53,'U G Mark list',0,0,0),(54,'P.G. Mark list',0,0,0);
/*!40000 ALTER TABLE `check_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklist`
--

DROP TABLE IF EXISTS `checklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklist` (
  `Checklist_Id` int NOT NULL,
  `Checklist_Name` varchar(100) DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Checklist_Type` int DEFAULT NULL,
  `Checklist_Type_Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Checklist_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklist`
--

LOCK TABLES `checklist` WRITE;
/*!40000 ALTER TABLE `checklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `checklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `Class_Id` int NOT NULL,
  `Class_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Class_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (303,'Followup Needed',1),(304,'Probable (0-30)%',0),(305,'Potential (30-70)%',0),(306,'Firm (70-99)%',0),(307,'Closed',0),(309,'No Follow Up Needed',1),(310,'Current Status Check',1),(311,'Transfer',1),(312,'New Lead',0),(313,'Process Completed(100)%',0);
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_accounts`
--

DROP TABLE IF EXISTS `client_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_accounts` (
  `Client_Accounts_Id` int NOT NULL,
  `Account_Group_Id` bigint DEFAULT NULL,
  `Client_Accounts_Code` varchar(50) DEFAULT NULL,
  `Client_Accounts_Name` varchar(500) DEFAULT NULL,
  `Client_Accounts_No` varchar(50) DEFAULT NULL,
  `Address1` varchar(250) DEFAULT NULL,
  `Address2` varchar(250) DEFAULT NULL,
  `Address3` varchar(250) DEFAULT NULL,
  `Address4` varchar(250) DEFAULT NULL,
  `PinCode` varchar(50) DEFAULT NULL,
  `StateCode` varchar(50) DEFAULT NULL,
  `GSTNo` varchar(50) DEFAULT NULL,
  `PanNo` varchar(50) DEFAULT NULL,
  `State` varchar(1000) DEFAULT NULL,
  `Country` varchar(1000) DEFAULT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Mobile` varchar(50) DEFAULT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `Opening_Balance` decimal(18,2) DEFAULT NULL,
  `Description1` varchar(1000) DEFAULT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  `LedgerInclude` varchar(50) DEFAULT NULL,
  `CanDelete` varchar(2) DEFAULT NULL,
  `Commision` decimal(18,2) DEFAULT NULL,
  `Opening_Type` int DEFAULT NULL,
  `Employee_Id` bigint DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Client_Accounts_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_accounts`
--

LOCK TABLES `client_accounts` WRITE;
/*!40000 ALTER TABLE `client_accounts` DISABLE KEYS */;
INSERT INTO `client_accounts` VALUES (1,3,'1','Cash Sale','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(2,29,'CP','Counter Purchase','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,4,0),(3,11,'3','Cash','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(4,2,'0','SalesMan','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(5,8,'S','Sales','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(6,7,'P','Purchase','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(7,8,'SR','SalesReturn','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(8,7,'PR','PurchaseReturn','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(9,27,'OUT','Stock Tran Out','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(10,27,'IN','Stock Tran In','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(11,27,'OTM','Stock Tran Out Missing','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(12,27,'INM','Stock Tran In Missing','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(13,19,'Cq','Cheque In Hand','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(14,20,'Crd','Card','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(15,9,'DisAll','DiscountAllowed','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(16,10,'DisRec','Discount And Incentive Received','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(17,9,'RoO','RoundOff','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(18,22,'Tx','SGST','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(19,10,'21','OTHER INCOME','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(20,9,'OCE','OtherCharges(Expense)','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(21,21,'Ad','Advance Income','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(22,11,'TC','TempCash','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(23,18,'CP','Capital','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(24,23,'AE','Advance Expene','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(25,22,'PT','CGST','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(26,7,'SA','Suspence Account','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(27,29,'RV','Profit Recievale','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(28,30,'PV','Profit  Payable','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(29,9,'CsE','IGST','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(30,10,'CsI','Cess','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(31,32,'SP','Salary Payable','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(32,31,'Sr','Salary Recievable','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(33,7,'SM','Stock Missing','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(34,2,'SE','Stock Excess','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','N',0.00,1,1,0),(35,11,'39','Head Cash','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','Y',0.00,1,1,0),(36,1,'36','Direct','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0.00,'0',NULL,83,'Y','Y',0.00,1,1,0);
/*!40000 ALTER TABLE `client_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colors`
--

DROP TABLE IF EXISTS `colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colors` (
  `Colors_Id` int NOT NULL,
  `Colors_Name` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Colors_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colors`
--

LOCK TABLES `colors` WRITE;
/*!40000 ALTER TABLE `colors` DISABLE KEYS */;
INSERT INTO `colors` VALUES (1,'Red',0),(2,'Blue',0),(3,'Green',0);
/*!40000 ALTER TABLE `colors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `Company_Id` int NOT NULL,
  `companyname` varchar(45) DEFAULT NULL,
  `Phone1` varchar(45) DEFAULT NULL,
  `Phone2` varchar(45) DEFAULT NULL,
  `Mobile` varchar(45) DEFAULT NULL,
  `Website` varchar(500) DEFAULT NULL,
  `Email` varchar(500) DEFAULT NULL,
  `Address1` varchar(1000) DEFAULT NULL,
  `Address2` varchar(1000) DEFAULT NULL,
  `Address3` varchar(1000) DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  `Logo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Company_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (197,'Royal Education Group','0481 2568182','','9526250005','www.royaleducationgroup.com','info@royaleducationgroup.com','1st Floor, Manorajayam Building','Near Hotel Aida','M C Road Kottayam',0,'');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conditions` (
  `Conditions_Id` int NOT NULL AUTO_INCREMENT,
  `Conditions_Name` varchar(500) DEFAULT NULL,
  `Application_details_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `Condition_Remark` text,
  `Student_Id` int DEFAULT NULL,
  PRIMARY KEY (`Conditions_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conditions`
--

LOCK TABLES `conditions` WRITE;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` VALUES (6,'xxx',119451,0,NULL,NULL),(7,'T1',14,0,'approved',10),(8,'T2',14,0,'holding',10),(9,'yjghhg',15,0,NULL,11),(10,'hjgh',13,0,NULL,9),(11,'45',13,0,NULL,9),(12,'45',13,0,NULL,9),(13,'gergr',15,0,NULL,11),(14,'65656',6,0,NULL,5),(15,'65656',15,0,NULL,11),(16,'rhtr',15,0,NULL,11),(17,'dfdfd',8,0,NULL,8),(18,'ghgfh',8,0,NULL,8),(19,'dsd',8,0,NULL,8),(20,'65656',9,0,NULL,8),(21,'65656fg',13,0,NULL,9),(22,'ghgfh',9,0,NULL,8),(23,'ghgfh',3,0,NULL,2),(24,'ghgfh',2,0,NULL,3),(25,'ghgfh',12,0,NULL,9),(26,'65656',10,0,NULL,7),(27,'65656',10,0,NULL,7),(28,'65656',10,0,NULL,7),(29,NULL,19,0,NULL,16),(30,'h',19,0,NULL,16),(31,'h',19,0,NULL,16),(32,'h',19,0,NULL,16),(33,'h',19,0,NULL,16),(34,'12',19,0,NULL,16),(35,'45435',15,0,NULL,11),(36,'gfd',15,0,NULL,11),(37,'fgh',19,0,NULL,16),(38,'j',21,0,NULL,23),(39,'r5',6,0,NULL,5),(40,'uuy',22,0,NULL,24),(41,'uuy',22,0,NULL,24);
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `Country_Id` int NOT NULL,
  `Country_Name` varchar(1000) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Country_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (2,'U K',0),(3,'Canada',0),(4,'Poland ',0),(5,'Sweden',0),(6,'Australia',0),(9,'New zealand',0),(10,'France',0),(11,'U S A',0),(12,'Singapore',0),(13,'Ireland',0),(14,'Germany',0),(16,'Austria',0),(17,'Finland',0),(18,'Hungary',0),(19,'Spain',0),(20,'Netherlands',0),(21,'Denmark',0),(22,'Italy',0),(23,'Switzerland',0),(24,'Lithuania',0),(25,'Cyprus',0),(26,'Bulgaria',0),(27,'Malaysia',0),(28,'Mauritus',0),(29,'Hong Kong',0),(30,'Czech Republic',0),(31,'Dubai',0),(32,'China',0),(33,'South Africa',0),(34,'Malta',0),(35,'Latvia',0),(36,'India',0),(37,'UK',0),(38,'Malta, UK, Canada',0),(39,'Ireland, Canada',0),(40,'Australia, Canada, Ireland, NZ, UK',0),(41,'Canada, UK',0),(42,'Canada, Germany',0),(43,'Canada, suggested UK, NZ',0),(44,'UK, Germany',0),(45,'Canada- Cambrian, Georgian, Conestoga',0),(46,'UK, DMU',0),(47,'',0),(48,'Netherland Sweden',0),(49,'UK, Canada',0),(50,'Canada, NZ, Australia',0),(51,'Any',0),(52,'Sweden, Canada',0),(53,'Canada, UK, Germany, Switzerland',0),(54,'Australia, Canada',0),(55,'Spain Italy',0),(56,'ggw',1),(57,'frgdfgd',1);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `Course_Id` int NOT NULL,
  `Course_Name` varchar(1000) DEFAULT NULL,
  `Course_Code` varchar(10) DEFAULT NULL,
  `Subject_Id` int DEFAULT NULL,
  `Duration_Id` int DEFAULT NULL,
  `Level_Id` int DEFAULT NULL,
  `Ielts_Minimum_Score` varchar(500) DEFAULT NULL,
  `internship_Id` int DEFAULT NULL,
  `Notes` varchar(2000) DEFAULT NULL,
  `Details` varchar(2000) DEFAULT NULL,
  `Application_Fees` varchar(500) DEFAULT NULL,
  `University_Id` int DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `Tag` varchar(2000) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Course_Status` int DEFAULT NULL,
  `intake_Name` varchar(200) DEFAULT NULL,
  `Tution_Fees` varchar(200) DEFAULT NULL,
  `Entry_Requirement` varchar(500) DEFAULT NULL,
  `IELTS_Name` varchar(500) DEFAULT NULL,
  `Duration` varchar(50) DEFAULT NULL,
  `Living_Expense` varchar(100) DEFAULT NULL,
  `Work_Experience` varchar(500) DEFAULT NULL,
  `Registration_Fees` varchar(45) DEFAULT NULL,
  `date_Charges` varchar(45) DEFAULT NULL,
  `Bank_Statements` varchar(45) DEFAULT NULL,
  `Insurance` varchar(45) DEFAULT NULL,
  `VFS_Charges` varchar(45) DEFAULT NULL,
  `Apostille` varchar(45) DEFAULT NULL,
  `Other_Charges` varchar(45) DEFAULT NULL,
  `Sub_Section_Id` varchar(45) DEFAULT NULL,
  `SubjectName` varchar(200) DEFAULT NULL,
  `DurationName` varchar(200) DEFAULT NULL,
  `Level_DetailName` varchar(200) DEFAULT NULL,
  `internshipName` varchar(200) DEFAULT NULL,
  `UniversityName` varchar(1000) DEFAULT NULL,
  `CountryName` varchar(1000) DEFAULT NULL,
  `Sub_SectionName` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Course_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (1,'Electronics and computer engineering','',0,0,4,'',0,'','Plus 2 with 60%','200',4,4,'',0,47,'','3,000','','','','','','','','','','','','','','','','','','','',''),(2,'Applied computer science','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(3,'Management','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(4,'Mechnical engineering','',0,0,4,'',0,'','Plus 2 with 60%','200',4,4,'',0,46,'','3,000','','','','','','','','','','','','','','','','','','','',''),(5,'Civil engineering','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(6,'Biotechnology','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(7,'Chemical and Process engineering','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(8,'Chemical technology','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(9,'Chemistry','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(10,'Chemistry and engineering of materials','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(11,'Electrical engineering','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(12,'Environmental engineering','',0,0,5,'',0,'','Bachelor with 60%','200',4,4,'',0,46,'','4,000','','','','','','','','','','','','','','','','','','','',''),(13,'sa','',0,0,4,'',0,'','','',1,1,'',0,46,'','','','','','','','','','','','','','','','','','','','','',''),(14,'nursing','',0,0,0,'0',0,'','','',NULL,6,'',0,NULL,'','','','0','','','','','','','','','','','0','','','','','','',''),(15,'MSc International Business Management (Work Experience) ','',0,0,0,'0',0,'','','',13,2,'',0,NULL,'September','','','0','','','','','','','','','','','0','','','','','','',''),(16,'Heating and Ventilation','',0,0,0,'0',0,'','','',NULL,3,'',0,NULL,'','','','0','','','','','','','','','','','0','','','','','','',''),(17,'E Commerce and online Management - Montreal','',0,0,0,'0',0,'','','',15,3,'',0,NULL,'January','','','0','','','','','','','','','','','0','','','','','','',''),(18,'Graduate Certificate in Environmental Sustainability Analysis','',0,0,0,'0',0,'','','',16,3,'',0,NULL,'September','','','0','','','','','','','','','','','0','','','','','','',''),(19,'PUBLIC RELATIONS - CORPORATE COMMUNICATIONS',NULL,0,0,0,'0',0,NULL,NULL,NULL,17,3,NULL,0,NULL,'September',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,'Master of Business (Accounting)',NULL,0,0,0,'0',0,NULL,NULL,NULL,18,6,NULL,0,NULL,'February',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,'Hospitality',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,38,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,'Accounting related',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,40,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,'MA Management and Finance',NULL,0,0,0,'0',0,NULL,NULL,NULL,19,37,NULL,0,NULL,'September',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,'MSc International Accounting & Finance',NULL,0,0,0,'0',0,NULL,NULL,NULL,20,37,NULL,0,NULL,'September',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,'Accounting and Finance MSc',NULL,0,0,0,'0',0,NULL,NULL,NULL,21,37,NULL,0,NULL,'September',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,'Physiotherapy MS',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,41,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,'Business or Accounting related',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,43,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,'MSW',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,37,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,'IBM',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,'cloud computing',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(31,'Biology related',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,14,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,'Mech Related',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,'Data science, Data Analytics',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,5,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(34,'FINANCE AND ACCOUNTING',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,13,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(35,'IT related course',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,6,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(36,'Autism and Behavioral Therapy',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,0,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(37,'MBA',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,41,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(38,'MBA, MPH',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,48,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(39,'MBA, Business, Marketing',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,49,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(40,'Business, Accounting',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,49,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(41,'journalism',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(42,'journalism, graphics',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(43,'COMMERCIAL PILOT',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(44,'INTERNATIONAL BUSINESS MANAGMENT / MARKETING',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(45,'Automotive',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(46,'IT',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(47,'Supply chain and logistics// Business Analytics',NULL,0,0,0,'0',0,NULL,NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(48,'INTERNATIONAL BUSINESS MANAGEMENT MSC 1 YEAR',NULL,0,0,0,'0',0,NULL,NULL,NULL,22,2,NULL,0,NULL,'September',NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_intake`
--

DROP TABLE IF EXISTS `course_intake`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_intake` (
  `course_intake_id` int NOT NULL,
  `Course_Id` int DEFAULT NULL,
  `intake_Id` int DEFAULT NULL,
  `intake_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`course_intake_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_intake`
--

LOCK TABLES `course_intake` WRITE;
/*!40000 ALTER TABLE `course_intake` DISABLE KEYS */;
INSERT INTO `course_intake` VALUES (2,2,4,1),(4,4,4,1),(5,5,4,1),(6,6,4,1),(7,7,4,1),(8,8,4,1),(9,9,4,1),(10,10,4,1),(11,11,4,1),(12,12,4,1),(13,1,4,1),(14,3,1,1),(15,3,2,1),(16,3,3,1),(17,3,4,1);
/*!40000 ALTER TABLE `course_intake` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_sub_section`
--

DROP TABLE IF EXISTS `course_sub_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_sub_section` (
  `course_sub_section_id` int NOT NULL,
  `Course_Id` int DEFAULT NULL,
  `Sub_Section_Id` int DEFAULT NULL,
  `Sub_Section_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`course_sub_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_sub_section`
--

LOCK TABLES `course_sub_section` WRITE;
/*!40000 ALTER TABLE `course_sub_section` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_sub_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_log_`
--

DROP TABLE IF EXISTS `data_log_`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_log_` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Description_` longtext,
  `data_val` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_log_`
--

LOCK TABLES `data_log_` WRITE;
/*!40000 ALTER TABLE `data_log_` DISABLE KEYS */;
INSERT INTO `data_log_` VALUES (2,'0',''),(3,'1',''),(4,'1',''),(5,'1',''),(6,'1',''),(7,'1',''),(8,'1',''),(9,'1',''),(10,'1',''),(11,'0',''),(12,'1',''),(13,'0','');
/*!40000 ALTER TABLE `data_log_` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_logs`
--

DROP TABLE IF EXISTS `data_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Description_` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_logs`
--

LOCK TABLES `data_logs` WRITE;
/*!40000 ALTER TABLE `data_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `Department_Id` int NOT NULL,
  `Department_Name` varchar(50) DEFAULT NULL,
  `FollowUp` tinyint unsigned DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Department_Order` int DEFAULT NULL,
  `Color` varchar(50) DEFAULT NULL,
  `Department_Status_Id` int DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  `Current_User_Index` varchar(45) DEFAULT NULL,
  `Total_User` varchar(45) DEFAULT NULL,
  `Transfer_Method_Id` int DEFAULT NULL,
  `Color_Type_Id` int DEFAULT NULL,
  `Color_Type_Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Department_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (317,'Admissions',1,'active',3,'',135,0,'4','3',2,1,'#aef4cc'),(318,'Accounts',1,'active',4,'',199,0,'1','2',2,0,'#da0bc9'),(322,'Visa',1,'active',5,'',183,0,'1','2',1,NULL,'#20c214'),(323,'Counsellor',1,'active',1,'',149,0,'17','27',2,NULL,'#0a07ab'),(326,'Closed',1,'active',9,'',136,0,'1','0',2,NULL,NULL),(327,'Fee - GIC- Visa Docs',1,'active',4,'',160,1,'2','0',NULL,NULL,NULL),(329,'Customer Success',1,'active',8,'',152,1,'1','1',NULL,NULL,NULL),(330,'Pre-Admissions',1,'active',2,'',148,1,'2','1',NULL,NULL,NULL),(331,'Travel Authorization',1,'active',7,'',166,1,'2','0',NULL,NULL,NULL),(332,'Pre-Visa',1,'active',0,'',160,1,'2','2',NULL,NULL,NULL),(333,'BPH',1,'active',0,'',135,0,'1','3',1,1,'#8400f0'),(334,'Refund',1,'active',0,'',155,1,'2','1',NULL,NULL,NULL),(335,'Application',1,'active',0,'',160,0,'1','1',2,NULL,NULL),(336,'Counsellor',1,'active',0,'',135,1,'2','0',NULL,NULL,NULL),(337,'CAS',1,'active',0,'',138,1,'2','1',NULL,NULL,NULL),(338,'Visa Rejection',1,'active',0,'',168,1,'2','0',NULL,NULL,NULL),(339,'Pre Application',1,'active',0,'',168,1,'2','1',NULL,NULL,NULL),(340,'test',1,'active',0,'',154,1,'2','0',NULL,NULL,NULL),(341,'d23',1,'active',0,'',135,1,'2','0',NULL,NULL,NULL),(342,'Tele - Sales',1,'active',10,'',154,1,'2','0',NULL,NULL,NULL),(343,'Tele Caller',1,'active',10,'',135,0,'4','1',2,0,'#5a06c1'),(344,'Management',1,'active',0,'',155,1,'2','4',0,NULL,NULL),(345,'RRR',1,'',1,'',135,0,'1','0',1,1,'#cd680a'),(346,'Lodgment',1,'',3,'',160,0,'1','2',1,NULL,'#34a0a2'),(347,'Offer Chase',1,'',0,'',148,0,'2','2',1,NULL,'#69d70f'),(348,'Offer Clearence',1,'',4,'',135,0,'1','2',1,NULL,'#e5938a'),(349,'Review',1,'',5,'',135,0,'1','2',1,NULL,'#dcb2da'),(350,'testjj',1,'',0,'',177,1,'1','0',0,0,'#da0bc9'),(351,'testjj',1,'',0,'',182,1,'1','0',1,NULL,NULL),(352,'ffedgft',1,'',0,'',135,1,'1','0',1,NULL,NULL),(353,'ffferrewrere',1,'',0,'',142,1,'1','0',1,NULL,NULL),(354,'w',1,'',0,'',135,1,'1','0',2,NULL,''),(355,'44',1,'',0,'',135,0,'1','0',2,NULL,'#f3f5f6');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_status`
--

DROP TABLE IF EXISTS `department_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_status` (
  `Department_Status_Id` int NOT NULL,
  `Department_Status_Name` varchar(50) DEFAULT NULL,
  `Status_Order` int DEFAULT NULL,
  `Editable` tinyint unsigned DEFAULT NULL,
  `Color` varchar(50) DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  `Status_Type_Id` int DEFAULT NULL,
  `Status_Type_Name` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Department_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_status`
--

LOCK TABLES `department_status` WRITE;
/*!40000 ALTER TABLE `department_status` DISABLE KEYS */;
INSERT INTO `department_status` VALUES (135,'Interested',0,1,'',0,1,'Positive'),(136,'Not interested',0,1,'',0,2,'Negative'),(138,'Fee Payment Received',0,1,'',1,NULL,NULL),(139,'Fee Payment Pending',0,1,'',1,NULL,NULL),(140,'Invoice Pending',0,1,'',1,NULL,NULL),(141,'Fund Problem',0,1,'',1,NULL,NULL),(142,'Not eligible',0,1,'',1,NULL,NULL),(143,'Looking for Work Visa',0,1,'',1,NULL,NULL),(144,'Process Completed',0,1,'',1,NULL,NULL),(145,'Potential (30-70)%',0,1,'',1,NULL,NULL),(146,'Probable (0-30)%',0,1,'',1,NULL,NULL),(147,'Firm (70-100)%',0,1,'',1,NULL,NULL),(148,'Verification',0,1,'',1,NULL,NULL),(149,'Follow up needed',0,1,'',0,2,'Negative'),(150,'Application submitted',0,1,'',0,1,'Positive'),(151,'Visa Application Submitted',0,1,'',1,NULL,NULL),(152,'Feedback',0,1,'',1,NULL,NULL),(153,'Pre Departure Briefing',0,1,'',1,NULL,NULL),(154,'New lead',0,1,'',0,1,'Positive'),(155,'For closure',0,1,'',1,2,'Negative'),(156,'ATIP Submitted',0,1,'',1,NULL,NULL),(157,'Certificate Creation',0,1,'',1,NULL,NULL),(158,'Invoice Released',0,1,'',1,NULL,NULL),(159,'Visa Approved',0,1,'',1,NULL,NULL),(160,'Application follow up',0,1,'',0,NULL,NULL),(161,'Visa-Follow up Needed',0,1,'',1,NULL,NULL),(162,'Visa process (re)initiated',0,1,'',0,NULL,NULL),(163,'Clear for Submission',0,1,'',1,NULL,NULL),(164,'GIC Payment Pending',0,1,'',1,NULL,NULL),(165,'GIC Payment Received',0,1,'',1,NULL,NULL),(166,'Travel Authorization Pending',0,1,'',1,NULL,NULL),(167,'Bph pending',0,0,'',1,NULL,NULL),(168,'pre application pending',0,0,'',1,NULL,NULL),(169,'test',0,0,'',1,NULL,NULL),(170,'Refund Pending',0,0,'',1,NULL,NULL),(171,'ds23',0,0,'',1,NULL,NULL),(172,'Call not connected',0,0,'',0,NULL,NULL),(173,'Application on hold',0,0,'',0,NULL,NULL),(174,'Application rejected',0,0,'',0,NULL,NULL),(175,'Application cancelled',0,0,'',0,NULL,NULL),(176,'Offer received',0,0,'',0,NULL,NULL),(177,'Offer rejected',0,0,'',0,NULL,NULL),(178,'Offer accepted',0,0,'',0,NULL,NULL),(179,'Offer received -couns',0,0,'',1,NULL,NULL),(180,'Offer rejected -couns',0,0,'',1,NULL,NULL),(181,'Registration pending',0,0,'',1,NULL,NULL),(182,'Registered',0,0,'',1,NULL,NULL),(183,'Visa submitted',0,0,'',0,NULL,NULL),(184,'Visa rejected',0,0,'',0,NULL,NULL),(185,'Visa resubmitted',0,0,'',0,NULL,NULL),(186,'Visa page collection',0,0,'',1,NULL,NULL),(187,'Predeparture proceeding',0,0,'',1,NULL,NULL),(188,'Positive',0,0,'',1,NULL,NULL),(189,'Negative',0,0,'',1,NULL,NULL),(190,'XXX',0,0,'',1,NULL,NULL),(191,'XXX1',0,0,'',1,2,'Negative'),(192,'test',0,0,'',1,1,NULL),(193,'abc',0,0,'',1,2,NULL),(194,'joined',0,0,'',1,0,'Select'),(195,'TOTAL FEES',0,0,'',1,0,'Select'),(196,'ghd',0,0,'',1,2,'Negative'),(197,'gg',0,0,'',1,1,'Positive'),(198,'Fee Payment Received',0,0,'',0,1,'Positive'),(199,'Application submitted to Admission',0,0,'',0,1,'Positive'),(200,'Documents pending',0,0,'',0,1,'Positive'),(201,'Not Eligible',0,0,'',0,2,'Negative');
/*!40000 ALTER TABLE `department_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document` (
  `Document_Id` int NOT NULL,
  `Document_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Document_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
INSERT INTO `document` VALUES (7,'SSLC Certificate',0),(8,'+2 Certificate',0),(9,'U .G Certificate',0),(10,'P.G  Certificate',0),(81,'Diploma Certificate',0),(82,'CV/Resume',0),(83,'ddd12',1),(84,'dwedwewe',1),(85,'10th Certificate',0),(86,'Birth Certificate',0),(87,'Degree Certificate',0),(88,'IELTS/PTE Score Sheet',0),(89,'Mark List',0),(90,'Passport Front and Back',0),(91,'Provisional Certificate',0),(92,'Work Experience Certificate',0);
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `duplicate_students`
--

DROP TABLE IF EXISTS `duplicate_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `duplicate_students` (
  `Duplicate_student_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Id` int DEFAULT NULL,
  `Student_Name` varchar(100) DEFAULT NULL,
  `Mobile` varchar(100) DEFAULT NULL,
  `By_User_Name` varchar(100) DEFAULT NULL,
  `Master_Id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Duplicate_student_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `duplicate_students`
--

LOCK TABLES `duplicate_students` WRITE;
/*!40000 ALTER TABLE `duplicate_students` DISABLE KEYS */;
/*!40000 ALTER TABLE `duplicate_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `duration`
--

DROP TABLE IF EXISTS `duration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `duration` (
  `Duration_Id` int NOT NULL,
  `Duration_Name` varchar(50) DEFAULT NULL,
  `Selection` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Duration_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `duration`
--

LOCK TABLES `duration` WRITE;
/*!40000 ALTER TABLE `duration` DISABLE KEYS */;
/*!40000 ALTER TABLE `duration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_details` (
  `Employee_Details_Id` int NOT NULL,
  `Client_Accounts_Id` bigint DEFAULT NULL,
  `Level_Id` bigint DEFAULT NULL,
  `DesigId` bigint DEFAULT NULL,
  `dateOfBirth` datetime(6) DEFAULT NULL,
  `dateOfJoin` datetime(6) DEFAULT NULL,
  `Releivedate` datetime(6) DEFAULT NULL,
  `WorkingStatus` varchar(100) DEFAULT NULL,
  `Locations` varchar(4000) DEFAULT NULL,
  `Manager_Id` int DEFAULT NULL,
  `Is_SalesMan` tinyint unsigned DEFAULT NULL,
  `Can_Delete` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Employee_Details_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_details`
--

LOCK TABLES `employee_details` WRITE;
/*!40000 ALTER TABLE `employee_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiry_for`
--

DROP TABLE IF EXISTS `enquiry_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiry_for` (
  `Enquiryfor_Id` int NOT NULL,
  `Enquirfor_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Enquiryfor_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiry_for`
--

LOCK TABLES `enquiry_for` WRITE;
/*!40000 ALTER TABLE `enquiry_for` DISABLE KEYS */;
INSERT INTO `enquiry_for` VALUES (1,'MIGRATE TO CANADA',0),(2,'STUDY ABROAD',0),(3,'IELTS + STUDY',0);
/*!40000 ALTER TABLE `enquiry_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiry_mode`
--

DROP TABLE IF EXISTS `enquiry_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiry_mode` (
  `Enquiry_Mode_Id` int NOT NULL,
  `Enquiry_Mode_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Enquiry_Mode_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiry_mode`
--

LOCK TABLES `enquiry_mode` WRITE;
/*!40000 ALTER TABLE `enquiry_mode` DISABLE KEYS */;
INSERT INTO `enquiry_mode` VALUES (1,'Walkin',0),(2,'Phone',0),(3,'Web',0);
/*!40000 ALTER TABLE `enquiry_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiry_source`
--

DROP TABLE IF EXISTS `enquiry_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiry_source` (
  `Enquiry_Source_Id` int NOT NULL,
  `Enquiry_Source_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Agent_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Enquiry_Source_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiry_source`
--

LOCK TABLES `enquiry_source` WRITE;
/*!40000 ALTER TABLE `enquiry_source` DISABLE KEYS */;
INSERT INTO `enquiry_source` VALUES (32,'Website',0,NULL),(33,'Phone Call Enquiry',0,NULL),(40,'FB, Insta, Twitter',0,NULL),(45,'Walkin',0,NULL),(46,'Whats App',0,NULL),(47,'Reference Febin',0,NULL),(48,'Reference Ciril',0,NULL),(49,'Reference Bibin',0,NULL),(51,'IELTS Institute Kottayam (Royal)',0,NULL),(52,'Reference Jose',0,NULL),(53,'Reference Student',0,NULL),(54,'SELF REFRENCE (Counsellor)',0,NULL),(55,'IELTS DATA COLLECTION',0,NULL),(56,'GLEN REFERENCE (IELTS)',0,NULL),(57,'Reference Biju Canada',0,NULL),(58,'Reference Jaseem (TVM)',0,NULL),(60,'SMART Academy Kalady',0,NULL),(63,'Royal Institute Data Collection',0,NULL),(65,'Manorama Horizon Data Aug 01 2022',0,NULL),(66,'Evoke Study Data',0,NULL),(67,'Jerin Francis Video Enquiry',0,NULL),(68,'Sreedevi Santhosh Data',0,NULL),(69,'FB DATA PURCHASE',0,NULL),(70,'IELTS EXAM DATA',0,NULL),(71,'IELTS Exam Conducted on 30/7/22',0,NULL),(72,'IELTS Data collected on 28/07/2022',0,NULL),(73,'IELTS Exam Conducted on 06/08/22',0,NULL),(74,'IELTS Data collected on 16/07/22',0,NULL),(75,'IELTS Data collected on 19/07/22',0,NULL),(76,'IELTS Data collected on 20/07/22',0,NULL),(77,'GEEBEE EXPO 07/08/2022',0,NULL),(78,'IELTS data collected on 23/07/2022',0,NULL),(79,'IELTS data collected on 27/07/2022',0,NULL),(80,'IELTS data collected on 01/08/2022',0,NULL),(81,'IELTS data collected on 06/08/2022',0,NULL),(82,'IELTS exam data collected on 11/08/2022',0,NULL),(83,'IELTS data collected on 9/08/2022',0,NULL),(84,'st. sebastians IELTS',0,NULL),(85,'IELTS data collected on 26/08/2022',0,NULL),(86,'IELTS data collected on 29/08/2022',0,NULL),(87,'Sherinz Vlog',0,NULL),(88,'Iype Vellikadan',0,NULL),(89,NULL,0,NULL),(90,NULL,0,NULL),(91,'testqwervcvcv',0,NULL),(92,'Agent1',0,NULL),(93,'fff',0,NULL),(94,'ffffffffffffffffff',0,1),(95,'dtt',0,NULL),(96,'ggg',0,1),(97,'cxccvc',0,NULL),(98,'useragent',0,1),(99,'fdff',0,1),(100,'sxssxx',0,1),(101,'2903023test',0,1),(102,'dfghij',0,1),(103,'fvff',0,0),(104,'enqddd',0,1),(105,'  fgfgfggffgbbb',0,0),(106,'test3003023',0,1),(107,'cvvcv1233003023',0,0),(108,'vvv3003023',0,1),(109,'TestAgent3003023',0,1);
/*!40000 ALTER TABLE `enquiry_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees`
--

DROP TABLE IF EXISTS `fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees` (
  `Fees_Id` int NOT NULL,
  `Fees_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Fees_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees`
--

LOCK TABLES `fees` WRITE;
/*!40000 ALTER TABLE `fees` DISABLE KEYS */;
INSERT INTO `fees` VALUES (1,'Initial Registration Fee',0),(2,'Application Fee',0),(3,'Visa Fee',0),(4,'SOP Fee',0),(5,'College Fee',0),(6,'Semester Fee',0);
/*!40000 ALTER TABLE `fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees_receipt`
--

DROP TABLE IF EXISTS `fees_receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees_receipt` (
  `Fees_Receipt_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` datetime(6) NOT NULL,
  `User_Id` int DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `Fees_Id` int DEFAULT NULL,
  `Amount` int DEFAULT NULL,
  `Actual_Entry_date` datetime(6) DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  `Fee_Receipt_Branch` int DEFAULT NULL,
  `Voucher_No` int DEFAULT NULL,
  `Currency` varchar(45) DEFAULT NULL,
  `To_Account_Id` int DEFAULT NULL,
  `To_Account_Name` varchar(100) DEFAULT NULL,
  `Application_details_Id` int DEFAULT NULL,
  `Course_Name` varchar(500) DEFAULT NULL,
  `Fees_Receipt_Status` varchar(45) DEFAULT NULL,
  `Refund_Requested_On` datetime(6) DEFAULT NULL,
  `Refund_Requested_By` int DEFAULT NULL,
  `Refund_Request_Status` int DEFAULT NULL,
  `Comment` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`Fees_Receipt_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees_receipt`
--

LOCK TABLES `fees_receipt` WRITE;
/*!40000 ALTER TABLE `fees_receipt` DISABLE KEYS */;
INSERT INTO `fees_receipt` VALUES (1,5,'2023-03-20 00:00:00.000000',83,'',5,8,'2023-03-20 10:20:09.000000',0,38,1,'',3,'Cash',0,'','1','2023-03-20 10:20:09.000000',83,1,NULL);
/*!40000 ALTER TABLE `fees_receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees_receipt_status`
--

DROP TABLE IF EXISTS `fees_receipt_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees_receipt_status` (
  `Fees_Receipt_Status_Id` int NOT NULL,
  `Fees_Receipt_Status_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Fees_Receipt_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees_receipt_status`
--

LOCK TABLES `fees_receipt_status` WRITE;
/*!40000 ALTER TABLE `fees_receipt_status` DISABLE KEYS */;
INSERT INTO `fees_receipt_status` VALUES (1,'Not Confirmed',0),(2,'Confirmed',0),(3,'Auditor Approval pending',0),(4,'Auditor Approved',0),(5,'Accounts Rejected',0),(6,'Accounts Confirmed',0),(7,'Team Lead Rejected',0);
/*!40000 ALTER TABLE `fees_receipt_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feesreceipt_document`
--

DROP TABLE IF EXISTS `feesreceipt_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feesreceipt_document` (
  `Feesreceipt_document_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` date DEFAULT NULL,
  `FeesreceiptFile_Name` varchar(500) DEFAULT NULL,
  `FeesreceiptDocument_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `FeesreceiptDocument_Name` varchar(500) DEFAULT NULL,
  `FeesreceiptDocument_File_Name` varchar(500) DEFAULT NULL,
  `Fees_Receipt_Id` int DEFAULT NULL,
  PRIMARY KEY (`Feesreceipt_document_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feesreceipt_document`
--

LOCK TABLES `feesreceipt_document` WRITE;
/*!40000 ALTER TABLE `feesreceipt_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `feesreceipt_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ielts`
--

DROP TABLE IF EXISTS `ielts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ielts` (
  `Ielts_Id` int NOT NULL,
  `Ielts_Name` varchar(500) DEFAULT NULL,
  `Minimum_Score` varchar(500) DEFAULT NULL,
  `Maximum_Score` varchar(500) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Ielts_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ielts`
--

LOCK TABLES `ielts` WRITE;
/*!40000 ALTER TABLE `ielts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ielts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ielts_details`
--

DROP TABLE IF EXISTS `ielts_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ielts_details` (
  `Ielts_Details_Id` int NOT NULL AUTO_INCREMENT,
  `Slno` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Exam_Date_Status` tinyint DEFAULT NULL,
  `Exam_Date` datetime(6) DEFAULT NULL,
  `Fees_Payment_Status` tinyint DEFAULT NULL,
  `Fees_Payment_Date` date DEFAULT NULL,
  `Fees_Payment_Amount` decimal(18,2) DEFAULT NULL,
  `Speaking_Status` tinyint DEFAULT NULL,
  `Speaking_Date` date DEFAULT NULL,
  `Listening` varchar(45) DEFAULT NULL,
  `Reading` varchar(45) DEFAULT NULL,
  `Writing` varchar(45) DEFAULT NULL,
  `Speaking` varchar(45) DEFAULT NULL,
  `Overall` varchar(45) DEFAULT NULL,
  `Course_Type` int DEFAULT NULL,
  `Batch` int DEFAULT NULL,
  `Course_Status` int DEFAULT NULL,
  `Exam_Booked_With` int DEFAULT NULL,
  `Exam_Centre` varchar(1000) DEFAULT NULL,
  `Ielts_Type` int DEFAULT NULL,
  `Registration_Date` date DEFAULT NULL,
  `Starting_Date` date DEFAULT NULL,
  `Ending_Date` date DEFAULT NULL,
  `datequery` date DEFAULT NULL,
  `Starting_Date_Status` tinyint DEFAULT NULL,
  `Ending_Date_Status` tinyint DEFAULT NULL,
  `Registration_Date_Status` tinyint DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `Ielts_Type_Name` varchar(45) DEFAULT NULL,
  `Exam_Check` tinyint DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Ielts_Details_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ielts_details`
--

LOCK TABLES `ielts_details` WRITE;
/*!40000 ALTER TABLE `ielts_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `ielts_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ielts_mode`
--

DROP TABLE IF EXISTS `ielts_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ielts_mode` (
  `Ielts_Id` int NOT NULL,
  `Ielts_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Ielts_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ielts_mode`
--

LOCK TABLES `ielts_mode` WRITE;
/*!40000 ALTER TABLE `ielts_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `ielts_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ielts_status`
--

DROP TABLE IF EXISTS `ielts_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ielts_status` (
  `Ielts_Status_Id` int NOT NULL,
  `Ielts_Status_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Ielts_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ielts_status`
--

LOCK TABLES `ielts_status` WRITE;
/*!40000 ALTER TABLE `ielts_status` DISABLE KEYS */;
INSERT INTO `ielts_status` VALUES (1,'Pass',0),(2,'Fail',0);
/*!40000 ALTER TABLE `ielts_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ielts_type`
--

DROP TABLE IF EXISTS `ielts_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ielts_type` (
  `Ielts_Type` int NOT NULL,
  `Ielts_Type_Name` varchar(250) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Ielts_Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ielts_type`
--

LOCK TABLES `ielts_type` WRITE;
/*!40000 ALTER TABLE `ielts_type` DISABLE KEYS */;
INSERT INTO `ielts_type` VALUES (50,'IELTS',0),(51,'OET',0),(54,'DUOLINGO',0),(55,'TOFFEL',0),(56,'GRE',0);
/*!40000 ALTER TABLE `ielts_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_detail`
--

DROP TABLE IF EXISTS `import_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_detail` (
  `Import_Detail_Id` int NOT NULL,
  `Import_Master_Id` int DEFAULT NULL,
  `Course_Id` int DEFAULT NULL,
  PRIMARY KEY (`Import_Detail_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_detail`
--

LOCK TABLES `import_detail` WRITE;
/*!40000 ALTER TABLE `import_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_master`
--

DROP TABLE IF EXISTS `import_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_master` (
  `Import_Master_Id` int NOT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Import_Master_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_master`
--

LOCK TABLES `import_master` WRITE;
/*!40000 ALTER TABLE `import_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_students_master`
--

DROP TABLE IF EXISTS `import_students_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_students_master` (
  `Master_Id` int NOT NULL,
  `By_User_Id` int DEFAULT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Master_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_students_master`
--

LOCK TABLES `import_students_master` WRITE;
/*!40000 ALTER TABLE `import_students_master` DISABLE KEYS */;
INSERT INTO `import_students_master` VALUES (1,89,'2023-03-23 00:00:00.000000'),(2,89,'2023-03-23 00:00:00.000000'),(3,89,'2023-03-28 00:00:00.000000');
/*!40000 ALTER TABLE `import_students_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intake`
--

DROP TABLE IF EXISTS `intake`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intake` (
  `intake_Id` int NOT NULL,
  `intake_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`intake_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intake`
--

LOCK TABLES `intake` WRITE;
/*!40000 ALTER TABLE `intake` DISABLE KEYS */;
INSERT INTO `intake` VALUES (5,'January',0),(6,'February',0),(7,'March',0),(8,'July',1),(10,'Others',1),(11,'May',1),(12,'June',1),(13,'August',1),(14,'October',1),(15,'November',1),(16,'December',1),(18,'October & February',1),(19,'September',1),(20,'',1),(21,'April',0),(22,'May',0),(23,'June',0),(24,'July',0);
/*!40000 ALTER TABLE `intake` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intake_year`
--

DROP TABLE IF EXISTS `intake_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intake_year` (
  `Intake_Year_Id` int NOT NULL,
  `Intake_Year_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Intake_Year_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intake_year`
--

LOCK TABLES `intake_year` WRITE;
/*!40000 ALTER TABLE `intake_year` DISABLE KEYS */;
INSERT INTO `intake_year` VALUES (5,'2017',0),(6,'2018',0),(7,'2019',0),(8,'2020',0),(10,'2021',0),(11,'2022',0),(12,'2023',0),(13,'2024',0),(14,'2025',0),(15,'2026',0),(16,'2027',0),(18,'2028',0),(19,'2029',0),(20,'',0),(21,'2030',0),(22,'2031',0),(23,'2032',0),(24,'2033',0),(25,'2034',0),(26,'2035',0),(27,'2036',0),(28,'2037',0),(29,'2038',0),(30,'2039',0),(31,'2040',0),(32,'2041',0),(33,'2042',0),(34,'2043',0),(35,'2044',0),(36,'2045',0),(37,'2046',0),(38,'2047',0),(39,'2048',0),(40,'2049',0),(41,'2050',0),(42,'2051',0),(43,'2052',0),(44,'2053',0),(45,'2054',0),(46,'2055',0),(47,'2056',0),(48,'2057',0),(49,'2058',0),(50,'2059',0),(51,'2060',0),(52,'2061',0),(53,'2062',0),(54,'2063',0),(55,'2064',0),(56,'2065',0),(57,'2066',0),(58,'2067',0),(59,'2068',0),(60,'2069',0),(61,'2070',0);
/*!40000 ALTER TABLE `intake_year` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internship`
--

DROP TABLE IF EXISTS `internship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internship` (
  `internship_Id` int NOT NULL,
  `internship_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`internship_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internship`
--

LOCK TABLES `internship` WRITE;
/*!40000 ALTER TABLE `internship` DISABLE KEYS */;
/*!40000 ALTER TABLE `internship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `Invoice_Id` int NOT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Amount` decimal(18,2) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Invoice_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_document`
--

DROP TABLE IF EXISTS `invoice_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_document` (
  `Invoice_Document_Id` int NOT NULL,
  `Invoice_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `Invoice_Document_Name` varchar(100) DEFAULT NULL,
  `Invoice_Document_File_Name` varchar(100) DEFAULT NULL,
  `Invoice_File_Name` varchar(100) DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Invoice_Document_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_document`
--

LOCK TABLES `invoice_document` WRITE;
/*!40000 ALTER TABLE `invoice_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `level_detail`
--

DROP TABLE IF EXISTS `level_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `level_detail` (
  `Level_Detail_Id` int NOT NULL,
  `Level_Detail_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Level_Detail_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `level_detail`
--

LOCK TABLES `level_detail` WRITE;
/*!40000 ALTER TABLE `level_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `level_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lor_1_mode`
--

DROP TABLE IF EXISTS `lor_1_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lor_1_mode` (
  `LOR_1_Id` int NOT NULL,
  `LOR_1_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`LOR_1_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lor_1_mode`
--

LOCK TABLES `lor_1_mode` WRITE;
/*!40000 ALTER TABLE `lor_1_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `lor_1_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lor_2_mode`
--

DROP TABLE IF EXISTS `lor_2_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lor_2_mode` (
  `LOR_2_Id` int NOT NULL,
  `LOR_2_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`LOR_2_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lor_2_mode`
--

LOCK TABLES `lor_2_mode` WRITE;
/*!40000 ALTER TABLE `lor_2_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `lor_2_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marital_status`
--

DROP TABLE IF EXISTS `marital_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marital_status` (
  `Marital_Status_Id` int NOT NULL,
  `Marital_Status_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Marital_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marital_status`
--

LOCK TABLES `marital_status` WRITE;
/*!40000 ALTER TABLE `marital_status` DISABLE KEYS */;
INSERT INTO `marital_status` VALUES (1,'Single',0),(2,'Married',0);
/*!40000 ALTER TABLE `marital_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `Menu_Id` bigint NOT NULL,
  `Menu_Name` varchar(250) DEFAULT NULL,
  `Menu_Order` bigint DEFAULT NULL,
  `Menu_Order_Sub` bigint DEFAULT NULL,
  `IsEdit` tinyint unsigned DEFAULT NULL,
  `IsSave` tinyint unsigned DEFAULT NULL,
  `IsDelete` tinyint unsigned DEFAULT NULL,
  `IsView` tinyint unsigned DEFAULT NULL,
  `Menu_Status` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Menu_Type` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Menu_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'User details',32,1,1,1,1,1,1,0,1),(2,'Country',37,1,1,1,1,1,1,0,1),(3,'Course',39,1,1,1,1,1,1,0,1),(4,'Document',8,0,0,0,0,0,0,0,0),(5,'Student',1,0,1,1,1,1,1,0,1),(6,'Subject',9,0,1,1,1,1,0,0,1),(7,'University',38,1,1,1,1,1,1,0,1),(8,'Home Page',2,1,1,1,1,1,0,0,1),(9,'Dashboard',13,1,0,0,0,1,1,0,1),(10,'Course Import',2,2,1,1,1,1,0,0,1),(11,'Account Group',11,0,1,1,1,1,0,0,1),(12,'Client Accounts',12,0,1,1,1,1,0,0,1),(13,'Agent',13,0,1,1,1,1,0,0,1),(14,'Department',29,1,1,1,0,1,1,0,1),(15,'Branch',30,1,1,1,1,1,1,0,1),(16,'Department Status',28,1,1,1,1,1,1,0,1),(17,'Student Report',23,1,0,0,0,1,1,0,1),(18,'Remarks',35,1,1,1,1,1,1,0,1),(19,'Work report',21,1,0,0,0,1,1,0,1),(20,'Enquiry Source',34,1,1,1,1,1,1,0,1),(21,'Time Track',14,1,0,0,0,1,1,0,1),(22,'Enroll',3,1,1,1,1,1,1,0,0),(23,'Remove Enrollment',4,1,1,1,1,1,1,0,0),(24,'Enrollment Report',24,0,0,0,0,0,0,0,0),(25,'Enquiry Source Report',25,0,0,0,0,0,0,0,1),(26,'Efficiency Report',26,0,0,1,0,1,0,0,1),(27,'Student Import',43,1,1,1,1,1,1,0,1),(28,'Pending FollowUp',26,1,0,0,0,1,1,0,1),(29,'Fees',33,1,1,1,1,1,1,0,1),(30,'Fees Receipt Report',30,0,0,0,0,0,0,0,0),(31,'Fees Collection',6,1,1,1,1,1,1,0,0),(32,'Enquiry Source Summary',15,1,0,0,0,1,1,0,1),(33,'Counselor Fees  Receipt Report',33,0,0,1,0,1,0,0,1),(34,'Counselor Enrollment Report',34,2,0,1,0,1,0,0,1),(35,'Student Summary Report',24,1,0,0,0,1,1,0,1),(36,'Staff Target Report',36,0,0,1,0,1,0,0,1),(37,'Public Search Search',44,1,1,1,1,1,1,0,1),(38,'Export Permission',27,1,0,0,0,1,1,0,0),(39,'Work Summary',39,0,1,1,1,1,0,0,1),(40,'Course History',40,0,0,0,0,0,0,0,0),(41,'Search Course Tab',41,0,0,0,0,0,0,0,0),(42,'Fees Collection Tab',5,1,1,0,0,1,0,0,0),(43,'Userwise Receipt Summary',43,0,1,1,1,1,0,0,1),(44,'branchwise Summary',44,0,1,1,1,1,0,0,1),(45,'Statistics Tab',45,0,0,0,0,0,0,0,0),(46,'PageA',46,0,1,1,1,1,0,0,0),(47,'PageB',47,0,1,1,1,1,0,0,0),(48,'PageC',48,0,1,1,1,1,0,0,0),(49,'Document View',12,1,0,0,0,1,0,0,0),(50,'Receipt Summary Report',19,1,0,0,0,1,1,0,1),(51,'Enrollment Summary',17,1,0,0,0,1,1,0,1),(52,'Enquiry Conversion',16,1,0,0,0,1,1,0,1),(53,'Employee Summary',25,1,0,0,0,1,1,0,1),(54,'User Role',31,1,1,1,1,1,1,0,1),(55,'Company',41,1,1,1,1,1,1,0,1),(56,'General Settings',42,1,0,0,1,0,1,0,1),(57,'Documnetation Report',13,0,0,0,0,0,0,0,0),(58,'Work History',22,1,0,0,0,1,1,0,1),(59,'Enrollment By EnquirySource',18,1,0,0,0,1,1,0,1),(60,'Applications Tab',8,1,1,1,1,1,1,0,1),(61,'Checklist Tab',61,0,0,0,0,0,0,0,0),(62,'Checklist',62,1,1,1,1,1,0,0,0),(63,'Active',9,1,1,1,1,1,0,0,0),(64,'Deactive',10,1,1,1,1,1,0,0,0),(65,'AgentView',11,1,1,1,1,1,1,0,1),(66,'Agent Details',36,1,1,1,1,1,1,0,1),(67,'Application Report',20,1,0,0,0,1,1,0,1),(68,'Invoice Tab',68,0,1,1,1,1,0,0,1),(69,'Visa Tab',7,1,1,1,1,1,1,0,1),(70,'Intake',40,1,1,1,1,1,1,0,1),(71,'Task',71,0,1,1,1,1,1,1,1),(72,'Customer Success',72,0,1,1,1,1,1,0,1),(73,'Pre visa',73,0,1,1,1,1,0,0,1),(74,'Notification',74,0,1,1,1,1,1,0,1),(75,'Change Status Button',75,0,1,1,1,1,1,0,1),(76,'Student Approve Button',76,0,1,1,1,1,1,0,1),(77,'Remove Approval Button',77,0,1,1,1,1,1,0,1),(78,'Application Active Button',78,0,1,1,1,1,1,0,1),(79,'Application Deactive Button',79,0,1,1,1,1,1,0,1),(80,'Move To Pre Application Button',80,0,1,1,1,1,0,0,1),(81,'Send To Bph Button',81,0,1,1,1,1,0,0,1),(82,'Tele sales transfer button',82,0,1,1,1,1,0,0,1),(83,'customer success transfer button',83,0,1,1,1,1,0,0,1),(84,'accounts transfer button',84,0,1,1,1,1,0,0,1),(85,'Counsilor Transfer Button',85,0,1,1,1,1,0,0,1),(86,'auditor transfer button',86,0,1,1,1,1,0,0,1),(87,'Admission Transfer Button',87,0,1,1,1,1,0,0,1),(88,'PreAdmission Transfer Button',88,0,1,1,1,1,0,0,1),(89,'PreVisa Transfer Button',89,0,1,1,1,1,0,0,1),(90,'Visa Transfer Button',90,0,1,1,1,1,0,0,1),(91,'Receipt Confirmation',91,1,1,1,1,1,1,0,1),(92,'Refund Confirmation',92,1,1,1,1,1,1,0,1),(93,'Refund Approval',93,1,1,1,1,1,1,0,1),(94,'Application Dashboard',94,1,0,0,0,1,1,0,1),(95,'Task',95,1,1,1,1,1,1,0,1),(96,'Passport Expiry Report',96,1,0,0,0,1,1,0,1),(97,'Pre Admission',97,1,1,1,1,1,0,0,1),(98,'Language Tab',98,1,1,1,1,1,1,0,1),(99,'Qualification Tab',99,1,1,1,1,1,1,0,1),(100,'Application Status',100,1,1,1,1,1,1,0,1),(101,'Task Item',101,1,1,1,1,1,1,0,1),(102,'Closed Transfer Button',102,1,1,1,1,1,0,0,1),(103,'New Task',103,1,1,1,1,1,1,0,1),(104,'Application List',104,1,1,1,1,1,1,0,1),(105,'Application Settings',105,1,1,1,1,1,1,0,1),(106,'Create New application',106,1,0,0,0,1,1,0,1),(107,'Application List Section',107,1,0,0,0,1,1,0,1),(108,'Application List Offerchasing Section',108,1,0,0,0,1,1,0,1),(109,'Documents',109,1,1,1,1,1,1,0,1),(110,'Enrolled Application Only',110,1,0,0,0,1,1,0,1),(111,'Document Name',111,1,1,1,1,1,1,0,1),(112,'Application History Delete',112,1,0,0,1,0,1,0,1),(113,'News',113,1,1,1,1,1,1,0,1);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moi_mode`
--

DROP TABLE IF EXISTS `moi_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moi_mode` (
  `MOI_Id` int NOT NULL,
  `MOI_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`MOI_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moi_mode`
--

LOCK TABLES `moi_mode` WRITE;
/*!40000 ALTER TABLE `moi_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `moi_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_document`
--

DROP TABLE IF EXISTS `news_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_document` (
  `News_Document_Id` int NOT NULL AUTO_INCREMENT,
  `Entry_date` date DEFAULT NULL,
  `File_Name` varchar(500) DEFAULT NULL,
  `Image` varchar(500) DEFAULT NULL,
  `Description` text,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`News_Document_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_document`
--

LOCK TABLES `news_document` WRITE;
/*!40000 ALTER TABLE `news_document` DISABLE KEYS */;
INSERT INTO `news_document` VALUES (7,'2023-03-30','zenestyregrptsp.txt','079c66c0-cee0-11ed-bf9a-01311865e912.txt','test1',1),(8,'2023-03-30','gcapi.dll','ab060570-cee3-11ed-bf9a-01311865e912.dll','t2FFFggg',0),(9,'2023-03-30','Student_Excel_Format (40).xlsx','1934cbc0-cee0-11ed-bf9a-01311865e912.xlsx','t3DFFD',0),(10,'2023-03-30','largedatacheck.xlsx','d0526e60-cee1-11ed-bf9a-01311865e912.xlsx','EFDDDZ',0),(11,'2023-03-30','JUBEERICH-PROFILE-PIC3 (4) (1).png','781e8dc0-ceee-11ed-a618-99b0ed64f508.png','xx',0);
/*!40000 ALTER TABLE `news_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `Notification_Id` int NOT NULL,
  `From_User` int DEFAULT NULL,
  `From_User_Name` varchar(45) DEFAULT NULL,
  `To_User` int DEFAULT NULL,
  `To_User_Name` varchar(45) DEFAULT NULL,
  `Status_Id` varchar(45) DEFAULT NULL,
  `Status_Name` varchar(45) DEFAULT NULL,
  `View_Status` int DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Student_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Read_Status` tinyint unsigned DEFAULT NULL,
  `Entry_Type` int DEFAULT NULL,
  `Description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Notification_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,'','2023-03-18 15:03:00.000000',1,'A',0,1,1,'Transfer'),(2,89,'Sudheesh',94,'visa user 2','183','Visa submitted',1,'','2023-03-18 15:08:07.000000',1,'A',0,NULL,1,'Transfer'),(3,84,'Sreekesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-18 15:18:00.000000',1,'A',0,1,1,'Transfer'),(4,89,'Sudheesh',86,'V.Lakshmy','6','Student Approval',1,'','2023-03-18 15:20:51.000000',1,'A',0,1,1,'Transfer'),(5,86,'V.Lakshmy',94,'visa user 2','4','visa Pending',1,NULL,'2023-03-18 15:21:59.000000',1,'A',0,NULL,1,'Transfer'),(6,86,'V.Lakshmy',94,'visa user 2','7','visa Pending',1,'','2023-03-18 15:22:00.000000',1,'A',0,NULL,1,'Transfer'),(7,88,'Bincy',87,'Jesna','8','Visa Approved',1,'','2023-03-18 15:23:23.000000',1,'A',0,1,1,'Transfer'),(8,83,'Ashok',88,'Bincy','183','Visa submitted',1,'','2023-03-20 10:21:16.000000',5,'D',0,1,1,'Transfer'),(9,83,'Ashok',94,'visa user 2','183','Visa submitted',1,'','2023-03-20 11:23:06.000000',6,'bincy',1,NULL,1,'Transfer'),(10,89,'Sudheesh',88,'Bincy','183','Visa submitted',1,'','2023-03-20 14:11:38.000000',8,'F',0,1,1,'Transfer'),(11,89,'Sudheesh',84,'Sreekesh','14','Lodgment Pending',1,NULL,'2023-03-20 15:03:01.000000',10,'H',0,1,1,'Transfer'),(12,89,'Sudheesh',90,'Lodgment user2','2','Lodgment Pending',1,'','2023-03-20 15:03:02.000000',10,'H',0,1,1,'Transfer'),(13,89,'Sudheesh',94,'visa user 2','183','Visa submitted',1,'','2023-03-20 15:07:01.000000',10,'H',0,NULL,1,'Transfer'),(14,84,'Sreekesh',85,'S.Lakshmy','14','Lodgment',1,NULL,'2023-03-20 15:10:38.000000',10,'H',0,1,1,'Transfer'),(15,84,'Sreekesh',91,'Offer Chase User 2','3','Lodgment',1,'','2023-03-20 15:10:39.000000',10,'H',0,NULL,1,'Transfer'),(16,85,'S.Lakshmy',89,'Sudheesh','14','Offer Received',1,NULL,'2023-03-20 15:14:12.000000',10,'H',0,1,1,'Transfer'),(17,85,'S.Lakshmy',89,'Sudheesh','5','Offer Received',1,'','2023-03-20 15:14:13.000000',10,'H',0,1,1,'Transfer'),(18,89,'Sudheesh',86,'V.Lakshmy','14','Student Approval',1,NULL,'2023-03-20 15:16:56.000000',10,'H',0,1,1,'Transfer'),(19,89,'Sudheesh',92,'Offer clearance user 2','6','Student Approval',1,'','2023-03-20 15:16:56.000000',10,'H',0,NULL,1,'Transfer'),(20,86,'V.Lakshmy',94,'visa user 2','14','visa Pending',1,NULL,'2023-03-20 15:18:48.000000',10,'H',0,NULL,1,'Transfer'),(21,86,'V.Lakshmy',94,'visa user 2','7','visa Pending',1,'','2023-03-20 15:18:49.000000',10,'H',0,NULL,1,'Transfer'),(22,88,'Bincy',87,'Jesna','14','Visa Approved',1,NULL,'2023-03-20 15:20:33.000000',10,'H',0,1,1,'Transfer'),(23,88,'Bincy',93,'review user 2','8','Visa Approved',1,'','2023-03-20 15:20:34.000000',10,'H',0,NULL,1,'Transfer'),(24,87,'Jesna',93,'review user 2','9','Visa Completed',1,'','2023-03-20 15:23:12.000000',10,'H',0,NULL,1,'Transfer'),(25,89,'Sudheesh',86,'V.Lakshmy','135','Interested',1,'','2023-03-20 15:24:50.000000',9,'G',0,1,1,'Transfer'),(26,89,'Sudheesh',92,'Offer clearance user 2','135','Interested',1,'','2023-03-20 15:50:42.000000',11,'1',0,NULL,1,'Transfer'),(27,89,'Sudheesh',86,'V.Lakshmy','135','Interested',1,'','2023-03-20 15:53:51.000000',12,'2',0,1,1,'Transfer'),(28,89,'Sudheesh',85,'S.Lakshmy','15','Lodgment',1,NULL,'2023-03-20 17:21:36.000000',11,'1',0,1,1,'Transfer'),(29,89,'Sudheesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-20 17:21:36.000000',11,'1',0,1,1,'Transfer'),(30,89,'Sudheesh',84,'Sreekesh','13','Lodgment Pending',1,NULL,'2023-03-20 17:25:48.000000',9,'G',0,1,1,'Transfer'),(31,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,'','2023-03-20 17:25:49.000000',9,'G',0,1,1,'Transfer'),(32,84,'Sreekesh',85,'S.Lakshmy','13','Lodgment',1,NULL,'2023-03-20 17:30:16.000000',9,'G',0,1,1,'Transfer'),(33,84,'Sreekesh',91,'Offer Chase User 2','3','Lodgment',1,'','2023-03-20 17:30:16.000000',9,'G',0,NULL,1,'Transfer'),(34,85,'S.Lakshmy',89,'Sudheesh','13','Offer Received',1,NULL,'2023-03-20 17:32:30.000000',9,'G',0,1,1,'Transfer'),(35,85,'S.Lakshmy',89,'Sudheesh','5','Offer Received',1,'','2023-03-20 17:32:30.000000',9,'G',0,1,1,'Transfer'),(36,85,'S.Lakshmy',89,'Sudheesh','15','Offer Received',1,NULL,'2023-03-20 17:49:03.000000',11,'1',0,1,1,'Transfer'),(37,85,'S.Lakshmy',89,'Sudheesh','5','Offer Received',1,'','2023-03-20 17:49:03.000000',11,'1',0,1,1,'Transfer'),(38,89,'Sudheesh',85,'S.Lakshmy','6','Lodgment',1,NULL,'2023-03-20 17:50:02.000000',5,'D',0,1,1,'Transfer'),(39,89,'Sudheesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-20 17:50:02.000000',5,'D',0,1,1,'Transfer'),(40,89,'Sudheesh',84,'Sreekesh','15','Lodgment Pending',1,NULL,'2023-03-20 17:50:51.000000',11,'1',0,1,1,'Transfer'),(41,89,'Sudheesh',90,'Lodgment user2','2','Lodgment Pending',1,'','2023-03-20 17:50:51.000000',11,'1',0,1,1,'Transfer'),(42,84,'Sreekesh',85,'S.Lakshmy','15','Lodgment',1,NULL,'2023-03-20 17:51:12.000000',11,'1',0,1,1,'Transfer'),(43,84,'Sreekesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-20 17:51:12.000000',11,'1',0,1,1,'Transfer'),(44,89,'Sudheesh',84,'Sreekesh','8','Lodgment Pending',1,NULL,'2023-03-21 09:48:23.000000',8,'F',0,1,1,'Transfer'),(45,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,'','2023-03-21 09:48:24.000000',8,'F',0,1,1,'Transfer'),(46,84,'Sreekesh',85,'S.Lakshmy','8','Lodgment',1,NULL,'2023-03-21 09:51:21.000000',8,'F',0,1,1,'Transfer'),(47,84,'Sreekesh',91,'Offer Chase User 2','3','Lodgment',1,'','2023-03-21 09:51:21.000000',8,'F',0,NULL,1,'Transfer'),(48,85,'S.Lakshmy',89,'Sudheesh','8','Offer Received',1,NULL,'2023-03-21 09:52:16.000000',8,'F',0,1,1,'Transfer'),(49,85,'S.Lakshmy',89,'Sudheesh','5','Offer Received',1,'','2023-03-21 09:52:16.000000',8,'F',0,1,1,'Transfer'),(50,89,'Sudheesh',86,'V.Lakshmy','9','Student Approval',1,NULL,'2023-03-21 09:58:13.000000',8,'F',0,1,1,'Transfer'),(51,89,'Sudheesh',92,'Offer clearance user 2','6','Student Approval',1,'','2023-03-21 09:58:13.000000',8,'F',0,NULL,1,'Transfer'),(52,89,'Sudheesh',86,'V.Lakshmy','13','Student Approval',1,NULL,'2023-03-21 10:14:53.000000',9,'G',0,1,1,'Transfer'),(53,89,'Sudheesh',86,'V.Lakshmy','6','Student Approval',1,'','2023-03-21 10:14:53.000000',9,'G',0,1,1,'Transfer'),(54,86,'V.Lakshmy',94,'visa user 2','9','visa Pending',1,NULL,'2023-03-21 10:29:41.000000',8,'F',0,NULL,1,'Transfer'),(55,86,'V.Lakshmy',88,'Bincy','7','visa Pending',1,'','2023-03-21 10:29:41.000000',8,'F',0,1,1,'Transfer'),(56,89,'Sudheesh',84,'Sreekesh','3','Lodgment Pending',1,NULL,'2023-03-21 12:05:55.000000',2,'B',0,1,1,'Transfer'),(57,89,'Sudheesh',90,'Lodgment user2','2','Lodgment Pending',1,'','2023-03-21 12:05:55.000000',2,'B',0,1,1,'Transfer'),(58,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,NULL,'2023-03-21 12:06:57.000000',3,'C',0,1,1,'Transfer'),(59,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,'','2023-03-21 12:06:57.000000',3,'C',0,1,1,'Transfer'),(60,89,'Sudheesh',84,'Sreekesh','12','Lodgment Pending',1,NULL,'2023-03-21 12:07:16.000000',9,'G',0,1,1,'Transfer'),(61,89,'Sudheesh',84,'Sreekesh','2','Lodgment Pending',1,'','2023-03-21 12:07:16.000000',9,'G',0,1,1,'Transfer'),(62,89,'Sudheesh',84,'Sreekesh','10','Lodgment Pending',1,NULL,'2023-03-21 13:33:52.000000',7,'E',0,1,1,'Transfer'),(63,89,'Sudheesh',90,'Lodgment user2','2','Lodgment Pending',1,'','2023-03-21 13:33:52.000000',7,'E',0,NULL,1,'Transfer'),(64,89,'Sudheesh',84,'Sreekesh','10','Lodgment Pending',1,NULL,'2023-03-21 13:34:32.000000',7,'E',0,1,1,'Transfer'),(65,89,'Sudheesh',90,'Lodgment user2','2','Lodgment Pending',1,'','2023-03-21 13:34:32.000000',7,'E',0,NULL,1,'Transfer'),(66,89,'Sudheesh',84,'Sreekesh','10','Lodgment Pending',1,NULL,'2023-03-21 13:35:10.000000',7,'E',0,1,1,'Transfer'),(67,89,'Sudheesh',84,'Sreekesh','14','Lodgment Pending',1,NULL,'2023-03-21 13:40:34.000000',10,'H',0,1,1,'Transfer'),(68,89,'Sudheesh',86,'V.Lakshmy','135','Interested',1,'','2023-03-21 13:41:35.000000',14,'2',0,1,1,'Transfer'),(69,89,'Sudheesh',84,'Sreekesh','17','Lodgment Pending',1,NULL,'2023-03-21 13:42:19.000000',14,'2',0,1,1,'Transfer'),(70,89,'Sudheesh',92,'Offer clearance user 2','135','Interested',1,'','2023-03-21 13:43:00.000000',15,'3',0,NULL,1,'Transfer'),(71,89,'Sudheesh',84,'Sreekesh','18','Lodgment Pending',1,NULL,'2023-03-21 13:43:45.000000',15,'3',0,1,1,'Transfer'),(72,89,'Sudheesh',86,'V.Lakshmy','135','Interested',1,'','2023-03-21 13:44:26.000000',16,'4',0,1,1,'Transfer'),(73,89,'Sudheesh',84,'Sreekesh','19','Lodgment Pending',1,NULL,'2023-03-21 13:45:38.000000',16,'4',0,1,1,'Transfer'),(74,84,'Sreekesh',85,'S.Lakshmy','19','Lodgment',1,NULL,'2023-03-21 13:46:20.000000',16,'4',0,1,1,'Transfer'),(75,84,'Sreekesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-21 13:46:20.000000',16,'4',0,1,1,'Transfer'),(76,89,'Sudheesh',84,'Sreekesh','1','Pending',1,'dd','2023-03-21 17:04:40.000000',3,'C',0,1,8,'Task'),(77,89,'Sudheesh',NULL,NULL,'2','Completed',1,'a','2023-03-21 17:15:51.000000',2,'B',0,NULL,8,'Task Completed'),(78,89,'Sudheesh',86,'V.Lakshmy','1','Pending',1,'','2023-03-22 15:52:45.000000',9,'G',0,1,8,'Task'),(79,89,'Sudheesh',84,'Sreekesh','11','Lodgment Pending',1,NULL,'2023-03-22 17:52:27.000000',7,'E',0,1,1,'Transfer'),(80,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'rt','2023-03-23 14:46:16.000000',21,'xyz',0,1,8,'Task Completed'),(81,89,'Sudheesh',89,'Sudheesh','1','Pending',1,'','2023-03-23 14:57:19.000000',21,'xyz',0,1,8,'Task'),(82,89,'Sudheesh',89,'Sudheesh','1','Pending',1,'','2023-03-23 14:57:57.000000',21,'xyz',0,1,8,'Task'),(83,89,'Sudheesh',89,'Sudheesh','1','Pending',1,'','2023-03-23 15:08:23.000000',21,'xyz',0,1,8,'Task'),(84,89,'Sudheesh',89,'Sudheesh','1','Pending',1,'','2023-03-23 15:10:41.000000',21,'xyz',0,1,8,'Task'),(85,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'dd','2023-03-23 15:16:06.000000',21,'xyz',0,1,8,'Task Completed'),(86,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'78','2023-03-23 15:19:06.000000',21,'xyz',0,1,8,'Task Completed'),(87,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'mop','2023-03-23 15:19:31.000000',21,'xyz',0,1,8,'Task Completed'),(88,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'dd','2023-03-23 15:21:24.000000',21,'xyz',0,1,8,'Task Completed'),(89,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'rty','2023-03-23 15:21:52.000000',21,'xyz',0,1,8,'Task Completed'),(90,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'tyuiop','2023-03-23 15:22:51.000000',21,'xyz',0,1,8,'Task Completed'),(91,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'cvb','2023-03-23 15:23:38.000000',21,'xyz',0,1,8,'Task Completed'),(92,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'test','2023-03-23 15:24:20.000000',21,'xyz',0,1,8,'Task Completed'),(93,89,'Sudheesh',89,'Sudheesh','2','Completed',1,'','2023-03-23 15:24:58.000000',21,'xyz',0,1,8,'Task'),(94,89,'Sudheesh',92,'Offer clearance user 2','135','Interested',1,'','2023-03-23 17:14:51.000000',23,'rst',0,NULL,1,'Transfer'),(95,89,'Sudheesh',84,'Sreekesh','21','Lodgment Pending',1,NULL,'2023-03-23 17:18:25.000000',23,'rst',0,1,1,'Transfer'),(96,84,'Sreekesh',85,'S.Lakshmy','21','Lodgment',1,NULL,'2023-03-23 17:22:09.000000',23,'rst',0,1,1,'Transfer'),(97,84,'Sreekesh',91,'Offer Chase User 2','3','Lodgment',1,'','2023-03-23 17:22:09.000000',23,'rst',0,NULL,1,'Transfer'),(98,89,'Sudheesh',86,'V.Lakshmy','135','Interested',1,'','2023-03-23 17:32:49.000000',24,'dd',0,NULL,1,'Transfer'),(99,89,'Sudheesh',84,'Sreekesh','22','Lodgment Pending',1,NULL,'2023-03-23 17:39:13.000000',24,'dd',0,1,1,'Transfer'),(100,89,'Sudheesh',85,'S.Lakshmy','22','Lodgment',1,NULL,'2023-03-28 11:36:37.000000',24,'dd',0,NULL,1,'Transfer'),(101,89,'Sudheesh',85,'S.Lakshmy','3','Lodgment',1,'','2023-03-28 11:36:37.000000',24,'dd',0,NULL,1,'Transfer'),(102,89,'Sudheesh',92,'Offer clearance user 2','135','135',1,'','2023-03-28 12:08:27.000000',28,'dd1',0,NULL,1,'Transfer'),(103,89,'Sudheesh',84,'Sreekesh','23','Lodgment Pending',1,NULL,'2023-03-28 12:09:12.000000',28,'dd1',0,NULL,1,'Transfer'),(104,89,'Sudheesh',84,'Sreekesh','135','135',1,'closed','2023-03-28 12:10:05.000000',28,'dd1',0,NULL,1,'Transfer'),(105,89,'Sudheesh',90,'Lodgment user2','135','Interested',1,'closed','2023-03-28 12:11:09.000000',29,'qq1',0,NULL,1,'Transfer'),(106,89,'Sudheesh',84,'Sreekesh','24','Lodgment Pending',1,NULL,'2023-03-28 12:14:45.000000',29,'qq1',0,NULL,1,'Transfer'),(107,89,'Sudheesh',90,'Lodgment user2','160','Application follow up',1,'','2023-03-28 12:14:45.000000',29,'qq1',0,NULL,1,'Transfer'),(108,89,'Sudheesh',84,'Sreekesh','24','Lodgment Pending',1,NULL,'2023-03-28 13:20:49.000000',29,'qq1',0,NULL,1,'Transfer'),(109,89,'Sudheesh',90,'Lodgment user2','160','Application follow up',1,'','2023-03-28 13:20:49.000000',29,'qq1',0,NULL,1,'Transfer'),(110,108,'TestAgent3003023',86,'V.Lakshmy','135','Interested',1,'','2023-03-30 17:54:02.000000',40,'neenu',0,NULL,1,'Transfer'),(111,108,'TestAgent3003023',92,'Offer clearance user 2','135','Interested',1,'','2023-03-30 17:54:44.000000',41,'gdfg',0,NULL,1,'Transfer');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_type`
--

DROP TABLE IF EXISTS `notification_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_type` (
  `Notification_Type_Id` int NOT NULL,
  `Notification_Type_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Notification_Type_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_type`
--

LOCK TABLES `notification_type` WRITE;
/*!40000 ALTER TABLE `notification_type` DISABLE KEYS */;
INSERT INTO `notification_type` VALUES (1,'Transfer',0),(2,'Application',0),(3,'Activation/Deactivation',0),(4,'Receipt',0),(5,'Receipt Confirmation',0),(6,'Refund Request',0),(7,'Refund Confirmation',0),(8,'Task',0),(9,'Refund Approval Remove',0),(10,'Refund Confirmation Removal',0),(11,'Refund Approval',0),(12,'Task Completed',0);
/*!40000 ALTER TABLE `notification_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offerletter_type`
--

DROP TABLE IF EXISTS `offerletter_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offerletter_type` (
  `Offerletter_Type_Id` int NOT NULL,
  `Offerletter_Type_Name` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Offerletter_Type_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offerletter_type`
--

LOCK TABLES `offerletter_type` WRITE;
/*!40000 ALTER TABLE `offerletter_type` DISABLE KEYS */;
INSERT INTO `offerletter_type` VALUES (1,'Conditional',0),(2,'Un Conditional',0);
/*!40000 ALTER TABLE `offerletter_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passport_mode`
--

DROP TABLE IF EXISTS `passport_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passport_mode` (
  `Passport_Id` int NOT NULL,
  `Passport_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Passport_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passport_mode`
--

LOCK TABLES `passport_mode` WRITE;
/*!40000 ALTER TABLE `passport_mode` DISABLE KEYS */;
INSERT INTO `passport_mode` VALUES (1,'Yes',0),(2,'No',0);
/*!40000 ALTER TABLE `passport_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_visa`
--

DROP TABLE IF EXISTS `pre_visa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pre_visa` (
  `Pre_Visa_Id` int NOT NULL,
  `IELTS` tinyint unsigned DEFAULT NULL,
  `Plustwo` tinyint unsigned DEFAULT NULL,
  `Degree` tinyint unsigned DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Pre_Visa_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_visa`
--

LOCK TABLES `pre_visa` WRITE;
/*!40000 ALTER TABLE `pre_visa` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_visa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `primary_details`
--

DROP TABLE IF EXISTS `primary_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primary_details` (
  `Primary_Details_Id` bigint NOT NULL,
  `Primary_Code` varchar(50) DEFAULT NULL,
  `Primary_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Primary_Details_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `primary_details`
--

LOCK TABLES `primary_details` WRITE;
/*!40000 ALTER TABLE `primary_details` DISABLE KEYS */;
INSERT INTO `primary_details` VALUES (1,'','ASSET',0),(2,'','LIABILITY',0),(3,'','INCOME',0),(4,'','EXPENDITURE',0);
/*!40000 ALTER TABLE `primary_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualification`
--

DROP TABLE IF EXISTS `qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualification` (
  `Qualification_Id` int NOT NULL AUTO_INCREMENT,
  `slno` int DEFAULT NULL,
  `Student_id` int DEFAULT NULL,
  `Credential` varchar(500) DEFAULT NULL,
  `school` varchar(1000) DEFAULT NULL,
  `MarkPer` varchar(50) DEFAULT NULL,
  `Fromyear` varchar(25) DEFAULT NULL,
  `Toyear` varchar(25) DEFAULT NULL,
  `result` varchar(200) DEFAULT NULL,
  `Field` varchar(1000) DEFAULT NULL,
  `Backlog_History` varchar(1000) DEFAULT NULL,
  `Year_of_passing` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Qualification_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualification`
--

LOCK TABLES `qualification` WRITE;
/*!40000 ALTER TABLE `qualification` DISABLE KEYS */;
/*!40000 ALTER TABLE `qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_request`
--

DROP TABLE IF EXISTS `refund_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_request` (
  `refund_request_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Fees_Receipt_Id` int DEFAULT NULL,
  `Reason` longtext,
  `Remark` longtext,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`refund_request_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_request`
--

LOCK TABLES `refund_request` WRITE;
/*!40000 ALTER TABLE `refund_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remarks`
--

DROP TABLE IF EXISTS `remarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remarks` (
  `Remarks_Id` int NOT NULL,
  `Remarks_Name` varchar(150) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Remarks_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remarks`
--

LOCK TABLES `remarks` WRITE;
/*!40000 ALTER TABLE `remarks` DISABLE KEYS */;
INSERT INTO `remarks` VALUES (1,'Call back Requested',1),(2,'test2',1),(3,'custom remark',1),(4,'Call back Requested',0),(5,'facebook',1),(6,'Course details send',0),(7,'test remark',1),(8,'test remark',1),(9,'test',1),(10,'Temporarily unavailable',0),(11,'Not responding',0);
/*!40000 ALTER TABLE `remarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resume_mode`
--

DROP TABLE IF EXISTS `resume_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resume_mode` (
  `Resume_Id` int NOT NULL,
  `Resume_Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Resume_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resume_mode`
--

LOCK TABLES `resume_mode` WRITE;
/*!40000 ALTER TABLE `resume_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `resume_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `Review_Id` int NOT NULL,
  `Facebook` tinyint unsigned DEFAULT NULL,
  `Instagram` tinyint unsigned DEFAULT NULL,
  `Gmail` tinyint unsigned DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Facebook_Date` datetime(6) DEFAULT NULL,
  `Instagram_Date` datetime(6) DEFAULT NULL,
  `Google_Date` datetime(6) DEFAULT NULL,
  `Checklist` tinyint unsigned DEFAULT NULL,
  `Kit` tinyint unsigned DEFAULT NULL,
  `Ticket` tinyint unsigned DEFAULT NULL,
  `Accomodation` tinyint unsigned DEFAULT NULL,
  `Airport_Pickup` tinyint unsigned DEFAULT NULL,
  `Checklist_Date` datetime(6) DEFAULT NULL,
  `Kit_Date` datetime(6) DEFAULT NULL,
  `Ticket_Date` datetime(6) DEFAULT NULL,
  `Accomodation_Date` datetime(6) DEFAULT NULL,
  `Airport_Pickup_Date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Review_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,0,0,1,83,5,'2023-03-20 10:19:22.000000',0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000',0,0,0,0,0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000'),(2,0,1,0,83,6,'2023-03-20 11:21:56.000000',0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000',0,0,0,0,0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000'),(3,1,0,0,89,14,'2023-03-21 15:10:40.000000',0,'2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000',0,0,0,0,0,'2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000'),(4,1,0,1,89,17,'2023-03-23 10:07:23.000000',0,'2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000',0,0,0,0,0,'2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000'),(5,1,0,0,89,21,'2023-03-23 14:50:31.000000',0,'2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000',0,0,0,0,0,'2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000','2023-03-23 00:00:00.000000');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings_table`
--

DROP TABLE IF EXISTS `settings_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings_table` (
  `Settings_Id` int NOT NULL,
  `Settings_Group_Id` int DEFAULT NULL,
  `Settings_Caption` varchar(45) DEFAULT NULL,
  `Settings_Value` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Settings_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings_table`
--

LOCK TABLES `settings_table` WRITE;
/*!40000 ALTER TABLE `settings_table` DISABLE KEYS */;
INSERT INTO `settings_table` VALUES (49,18,'User_count','200',0);
/*!40000 ALTER TABLE `settings_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shore`
--

DROP TABLE IF EXISTS `shore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shore` (
  `Shore_Id` int NOT NULL,
  `Shore_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Shore_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shore`
--

LOCK TABLES `shore` WRITE;
/*!40000 ALTER TABLE `shore` DISABLE KEYS */;
INSERT INTO `shore` VALUES (1,'Off Shore',0),(2,'On Shore',0);
/*!40000 ALTER TABLE `shore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sop_mode`
--

DROP TABLE IF EXISTS `sop_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sop_mode` (
  `SOP_Id` int NOT NULL,
  `SOP_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`SOP_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sop_mode`
--

LOCK TABLES `sop_mode` WRITE;
/*!40000 ALTER TABLE `sop_mode` DISABLE KEYS */;
/*!40000 ALTER TABLE `sop_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sort_by`
--

DROP TABLE IF EXISTS `sort_by`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sort_by` (
  `Sort_By_Id` int NOT NULL,
  `Sort_By_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Sort_By_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sort_by`
--

LOCK TABLES `sort_by` WRITE;
/*!40000 ALTER TABLE `sort_by` DISABLE KEYS */;
/*!40000 ALTER TABLE `sort_by` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `Status_Id` int NOT NULL,
  `Status_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (135,'Interested',0),(136,'Not Interested',0),(138,'Fee Payment Received',0),(139,'Fee Payment Pending',0),(140,'Invoice Pending',0),(141,'Fund Problem',0),(142,'Not Eligible',0),(143,'Looking for Work Visa',0),(144,'Process Completed',0),(145,'Potential (30-70)%',0),(146,'Probable (0-30)%',0),(147,'Firm (70-100)%',0),(148,'Verification',0),(149,'Follow UP Needed',0),(150,'University Application Submitted',0),(151,'Visa Application Submitted',0),(152,'Feed Back',0),(153,'Pre Departure Briefing',0),(154,'New Lead',0),(155,'For Closure',0),(156,'ATIP Submitted',0),(157,'Certificate Creation',0),(158,'Invoice Released',0),(159,'Visa Approved',0),(160,'Application-Follow up Needed',0),(161,'Visa-Follow up Needed',0),(162,'Visa Process Initiated',0),(163,'Clear for Submission',0),(164,'GIC Payment Pending',0),(165,'GIC Payment Received',0),(166,'Travel Authorization Pending',0);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_selection`
--

DROP TABLE IF EXISTS `status_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_selection` (
  `Status_Selection_Id` int NOT NULL AUTO_INCREMENT,
  `Department_Id` int DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `Is_Delete` tinyint DEFAULT NULL,
  PRIMARY KEY (`Status_Selection_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=746 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_selection`
--

LOCK TABLES `status_selection` WRITE;
/*!40000 ALTER TABLE `status_selection` DISABLE KEYS */;
INSERT INTO `status_selection` VALUES (2,0,0,0),(4,0,0,0),(5,0,0,0),(6,0,0,0),(7,0,0,0),(9,0,149,0),(25,0,154,0),(26,0,149,0),(27,0,149,0),(30,0,0,0),(31,0,0,0),(32,0,154,0),(36,0,0,0),(37,0,0,0),(38,0,0,0),(42,0,0,0),(672,347,136,0),(673,347,142,0),(674,347,148,0),(712,345,135,0),(713,326,136,0),(714,326,142,0),(715,323,135,0),(716,323,149,0),(717,323,154,0),(718,323,172,0),(719,322,162,0),(720,322,183,0),(721,322,184,0),(722,322,185,0),(723,335,150,0),(724,335,160,0),(725,335,173,0),(726,335,174,0),(729,318,199,0),(730,318,200,0),(731,318,198,0),(732,317,135,0),(733,333,135,0),(737,349,135,0),(738,349,136,0),(740,343,135,0),(741,343,136,0),(742,355,135,0),(743,355,136,0),(744,346,160,0),(745,348,135,0);
/*!40000 ALTER TABLE `status_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_type`
--

DROP TABLE IF EXISTS `status_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_type` (
  `Status_Type_Id` int NOT NULL,
  `Status_Type_Name` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`Status_Type_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_type`
--

LOCK TABLES `status_type` WRITE;
/*!40000 ALTER TABLE `status_type` DISABLE KEYS */;
INSERT INTO `status_type` VALUES (1,'Positive',0),(2,'Negative',0),(3,'Hot',1),(4,'Cold',1);
/*!40000 ALTER TABLE `status_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `Student_Id` int NOT NULL,
  `Agent_Id` int DEFAULT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  `Student_Name` varchar(500) DEFAULT NULL,
  `Address1` varchar(200) DEFAULT NULL,
  `Address2` varchar(200) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone_Number` varchar(25) DEFAULT NULL,
  `Dob` varchar(45) DEFAULT NULL,
  `Country_Name` varchar(1000) DEFAULT NULL,
  `Student_Status_Id` int DEFAULT NULL,
  `Student_FollowUp_Id` int DEFAULT NULL,
  `Next_FollowUp_date` date DEFAULT NULL,
  `Followup_Department_Id` int DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `To_User_Id` int DEFAULT NULL,
  `To_User_Name` varchar(250) DEFAULT NULL,
  `Followup_Branch_Id` int DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Remark_Id` int DEFAULT NULL,
  `By_User_Id` int DEFAULT NULL,
  `By_UserName` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Enquiry_Source_Id` int DEFAULT NULL,
  `Alternative_Phone_Number` varchar(45) DEFAULT NULL,
  `Alternative_Email` varchar(100) DEFAULT NULL,
  `Whatsapp` varchar(45) DEFAULT NULL,
  `Is_Registered` tinyint unsigned DEFAULT NULL,
  `Registered_By` int DEFAULT NULL,
  `Registered_On` datetime(6) DEFAULT NULL,
  `Created_By` int DEFAULT NULL,
  `Registration_Target` int DEFAULT NULL,
  `FollowUp_Count` int DEFAULT NULL,
  `FollowUp_Entrydate` datetime(6) DEFAULT NULL,
  `Registration_Branch` int DEFAULT NULL,
  `Entry_Type` int DEFAULT NULL,
  `First_Followup_Status` tinyint unsigned DEFAULT NULL,
  `First_Followup_Date` datetime(6) DEFAULT NULL,
  `Programme_Course` longtext,
  `Program_Course_Id` int DEFAULT NULL,
  `Agent` varchar(45) DEFAULT NULL,
  `Student_Remark` varchar(45) DEFAULT NULL,
  `Send_Welcome_Mail_Status` varchar(45) DEFAULT NULL,
  `Passport_No` varchar(45) DEFAULT NULL,
  `Passport_fromdate` date DEFAULT NULL,
  `Passport_Todate` date DEFAULT NULL,
  `Passport_Id` int DEFAULT NULL,
  `Student_Registration_Id` int DEFAULT NULL,
  `Followup_Department_Name` varchar(50) DEFAULT NULL,
  `FollowUp` tinyint unsigned DEFAULT NULL,
  `Followup_Branch_Name` varchar(50) DEFAULT NULL,
  `Client_Accounts_Name` varchar(500) DEFAULT NULL,
  `Agent_Name` varchar(150) DEFAULT NULL,
  `Department_Status_Name` varchar(50) DEFAULT NULL,
  `Role_Id` int DEFAULT NULL,
  `Enquiry_Source_Name` varchar(100) DEFAULT NULL,
  `Reference` varchar(45) DEFAULT NULL,
  `Created_User` longtext,
  `Registered_User` longtext,
  `Registered_Branch` longtext,
  `Marital_Status_Id` int DEFAULT NULL,
  `Marital_Status_Name` varchar(45) DEFAULT NULL,
  `Profile_University_Id` int DEFAULT NULL,
  `Profile_Country_Id` int DEFAULT NULL,
  `Created_On` datetime(6) DEFAULT NULL,
  `Enquiryfor_Id` int DEFAULT NULL,
  `Enquirfor_Name` varchar(45) DEFAULT NULL,
  `Shore_Id` int DEFAULT NULL,
  `Shore_Name` varchar(45) DEFAULT NULL,
  `Spouse_Name` varchar(45) DEFAULT NULL,
  `date_of_Marriage` varchar(45) DEFAULT NULL,
  `Spouse_Occupation` varchar(45) DEFAULT NULL,
  `Spouse_Qualification` varchar(45) DEFAULT NULL,
  `Dropbox_Link` varchar(1000) DEFAULT NULL,
  `No_of_Kids_and_Age` varchar(45) DEFAULT NULL,
  `Previous_Visa_Rejection` longtext,
  `Enquiry_Mode_Id` int DEFAULT NULL,
  `Enquiry_Mode_Name` varchar(45) DEFAULT NULL,
  `Branch_Id` int DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Visa_User` int DEFAULT NULL,
  `Pre_Visa_User` int DEFAULT NULL,
  `Pre_Admission_User` int DEFAULT NULL,
  `Admission_User` int DEFAULT NULL,
  `Applicaton_User` int DEFAULT NULL,
  `Counsilor_User` int DEFAULT NULL,
  `Refund_user` int DEFAULT NULL,
  `Cas_User` int DEFAULT NULL,
  `Visa_Rejection_User` int DEFAULT NULL,
  `Pre_Application_User` int DEFAULT NULL,
  `Bph_User` int DEFAULT NULL,
  `Unique_Id` varchar(200) DEFAULT NULL,
  `Class_Id` int DEFAULT NULL,
  `Class_Name` varchar(200) DEFAULT NULL,
  `Proceeding_Intake_Id` int DEFAULT NULL,
  `Proceeding_Intake_Name` varchar(100) DEFAULT NULL,
  `Proceeding_Year_Id` int DEFAULT NULL,
  `Proceeding_Year_Name` varchar(100) DEFAULT NULL,
  `Proceeding_Partner_Id` int DEFAULT NULL,
  `Proceeding_Partner_Name` varchar(100) DEFAULT NULL,
  `Proceeding_Country_Id` int DEFAULT NULL,
  `Proceeding_Country_Name` varchar(100) DEFAULT NULL,
  `Proceeding_Course_Id` int DEFAULT NULL,
  `Proceeding_Course_Name` varchar(100) DEFAULT NULL,
  `Proceeding_University_Id` int DEFAULT NULL,
  `Proceeding_University_Name` varchar(100) DEFAULT NULL,
  `Guardian_telephone` varchar(25) DEFAULT NULL,
  `Link_Send_By` varchar(500) DEFAULT NULL,
  `Link_Send_On` varchar(500) DEFAULT NULL,
  `Status_Student_Fill` int DEFAULT NULL,
  `Counsilor_Note` longtext,
  `BPH_Note` longtext,
  `Pre_Visa_Note` longtext,
  `Closed_User` int DEFAULT NULL,
  `Sub_Status_Id` int DEFAULT NULL,
  `Sub_Status_Name` varchar(100) DEFAULT NULL,
  `Status_Type_Id` int DEFAULT NULL,
  `Status_Type_Name` varchar(45) DEFAULT NULL,
  `Color` varchar(45) DEFAULT NULL,
  `User_List` text,
  `Student_Agent_Country_Id` int DEFAULT NULL,
  `Agent_Country_Id` int DEFAULT NULL,
  `Agent_Country_Name` varchar(100) DEFAULT NULL,
  `Exam_Date_Status` tinyint DEFAULT NULL,
  `Exam_Date` varchar(100) DEFAULT NULL,
  `Ielts_Status_Id` int DEFAULT NULL,
  `Ielts_Status_Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Student_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,1,'2023-03-18 11:03:48.000000','A','','','','1231231231','','',1,13,'2023-03-18',349,9,87,'Jesna',41,'',0,87,'Jesna',0,80,'','','1231231231',1,89,'2023-03-18 15:08:06.000000',89,NULL,1,'2023-03-18 11:03:48.000000',41,1,1,'2023-03-18 11:03:48.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,2,'Review',1,'Angamaly',NULL,NULL,'Visa Completed',32,'IELTS data collected on 01/08/2022','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-18 11:03:48.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'75105900-c54e-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1231231230','0',NULL,0,'','','',0,0,'',NULL,NULL,'#dcb2da','0,*89*,*86*,*88*,*87*,*87*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,1,'2023-03-18 11:43:15.000000','B','','','','7897897897','','',1,50,'2023-03-21',346,2,90,'Lodgment user2',41,'',0,89,'Sudheesh',0,56,'','','7897897897',0,NULL,NULL,89,NULL,1,'2023-03-18 11:43:15.000000',NULL,1,1,'2023-03-18 11:43:15.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Lodgment',1,'Angamaly',NULL,NULL,'Lodgment Pending',31,'GLEN REFERENCE (IELTS)','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-18 11:43:15.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'f84fcc10-c553-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#34a0a2','*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,1,'2023-03-18 11:43:34.000000','C','','','','8529637412','','',1,51,'2023-03-21',346,2,84,'Sreekesh',41,'',0,89,'Sudheesh',0,40,'','','8529637412',0,NULL,NULL,89,NULL,1,'2023-03-18 11:43:34.000000',NULL,1,1,'2023-03-18 11:43:34.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Lodgment',1,'Angamaly',NULL,NULL,'Lodgment Pending',31,'FB, Insta, Twitter','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-18 11:43:34.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'03a05f80-c554-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#34a0a2','*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,1,'2023-03-18 11:44:51.000000','D','','','','8545021365','','',1,4,'2023-03-18',317,160,89,'Sudheesh',41,'Course details send',6,89,'Sudheesh',0,76,'','','8545021365',1,89,'2023-03-18 12:04:16.000000',89,NULL,1,'2023-03-18 11:44:51.000000',41,1,1,'2023-03-18 11:44:51.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,1,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'IELTS Data collected on 20/07/22','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-18 11:44:51.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'315c2300-c554-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,1,'2023-03-20 10:15:20.000000','D','','','','1112223331','','',1,84,'2023-03-23',347,4,85,'S.Lakshmy',41,'',0,85,'S.Lakshmy',0,56,'','','1112223331',1,83,'2023-03-20 10:21:16.000000',83,0,1,'2023-03-20 10:15:20.000000',38,1,1,'2023-03-20 10:15:20.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,3,'Offer Chase',1,'Angamaly',NULL,NULL,'Offer Pending',31,'GLEN REFERENCE (IELTS)','','Ashok','Ashok','Kottayam',0,'Select',NULL,0,'2023-03-20 10:15:20.000000',0,'Select',0,'Select','','','','','','','',0,'Select',38,318,0,0,0,0,0,0,83,0,0,0,0,'04bb0910-c6da-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','83','2023-03-20 10:21:25',0,'','','',0,0,'',NULL,NULL,'#69d70f','*83*,*83*,*89*,*85*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,1,'2023-03-20 11:20:44.000000','bincy','','','','9447188701','','',1,17,'2023-03-20',322,183,94,'visa user 2',41,'',0,83,'Ashok',1,69,'','','9447188701',1,83,'2023-03-20 11:23:05.000000',83,0,1,'2023-03-20 11:20:44.000000',38,1,1,'2023-03-20 11:20:44.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,4,'Visa',1,'Angamaly',NULL,NULL,'Visa submitted',31,'FB DATA PURCHASE','','Ashok','Ashok','Kottayam',0,'Select',NULL,0,'2023-03-20 11:20:44.000000',0,'Select',0,'Select','','','','','','','',0,'Select',38,318,0,0,0,0,0,0,83,0,0,0,0,'279f4aa0-c6e3-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#20c214','*83*,*83*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,1,'2023-03-20 13:33:16.000000','E','','','','5231452154','','',1,54,'2023-03-21',346,2,90,'Lodgment user2',41,'',0,89,'Sudheesh',0,75,'','','5231452154',0,NULL,NULL,89,NULL,1,'2023-03-20 13:33:16.000000',NULL,1,1,'2023-03-20 13:33:16.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Lodgment',1,'Angamaly',NULL,NULL,'Lodgment Pending',31,'IELTS Data collected on 19/07/22','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-20 13:33:16.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'abbd7200-c6f5-11ed-9929-353fa6a7c350',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#34a0a2','*89*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,1,'2023-03-20 13:36:37.000000','F','','','','852147845','','',1,49,'2023-03-21',322,7,88,'Bincy',41,'',0,86,'V.Lakshmy',0,76,'','','852147845',1,89,'2023-03-20 14:11:37.000000',89,NULL,1,'2023-03-20 13:36:37.000000',41,1,1,'2023-03-20 13:36:37.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,5,'Visa',1,'Angamaly',NULL,NULL,'visa Pending',31,'IELTS Data collected on 20/07/22','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-20 13:36:37.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'238051e0-c6f6-11ed-bc5a-79ce726b549d',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','89','2023-03-20 14:05:32',0,'','','',0,0,'',NULL,NULL,'#20c214','0,*85*,*89*,*86*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,1,'2023-03-20 14:26:33.000000','G','','','','7854521236','','',1,52,'2023-03-21',346,2,84,'Sreekesh',41,'',0,89,'Sudheesh',0,75,'','','7854521236',1,89,'2023-03-20 15:24:50.000000',89,NULL,1,'2023-03-20 14:26:33.000000',41,1,1,'2023-03-20 14:26:33.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,7,'Lodgment',1,'Angamaly',NULL,NULL,'Lodgment Pending',31,'IELTS Data collected on 19/07/22','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-20 14:26:33.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'1cd85ac0-c6fd-11ed-b857-534c74b0811e',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','89','2023-03-20 14:29:18',0,'','','',0,0,'',NULL,NULL,'#34a0a2','0,*85*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,1,'2023-03-20 15:01:15.000000','H','','','','789456781','','',1,30,'2023-03-20',349,9,93,'review user 2',41,'',0,87,'Jesna',0,77,'','','789456781',1,89,'2023-03-20 15:07:00.000000',89,NULL,1,'2023-03-20 15:01:15.000000',41,1,1,'2023-03-20 15:01:15.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,6,'Review',1,'Angamaly',NULL,NULL,'Visa Completed',31,'GEEBEE EXPO 07/08/2022','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-20 15:01:15.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'f5d009a0-c701-11ed-b857-534c74b0811e',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#dcb2da','0,*85*,*89*,*86*,*88*,*87*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,1,'2023-03-20 15:50:12.000000','1','','','','9497150217','','',1,70,'2023-03-21',347,4,85,'S.Lakshmy',41,'',0,85,'S.Lakshmy',0,66,'','','9497150217',1,89,'2023-03-20 15:50:41.000000',89,NULL,1,'2023-03-20 15:50:12.000000',41,1,1,'2023-03-20 15:50:12.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,8,'Offer Chase',1,'Angamaly',NULL,NULL,'Offer Pending',31,'Evoke Study Data','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-20 15:50:12.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'ccc7def0-c708-11ed-b857-534c74b0811e',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#69d70f','0,*85*,*85*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,1,'2023-03-20 15:53:31.000000','2','','','','8606179611','','',1,35,'2023-03-20',348,135,86,'V.Lakshmy',41,'',0,89,'Sudheesh',0,56,'','','8606179611',1,89,'2023-03-20 15:53:50.000000',89,NULL,1,'2023-03-20 15:53:31.000000',41,1,1,'2023-03-20 15:53:31.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,9,'Offer Clearence',1,'Angamaly',NULL,NULL,'Interested',31,'GLEN REFERENCE (IELTS)','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-20 15:53:31.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'433540f0-c709-11ed-b857-534c74b0811e',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#e5938a','*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,1,'2023-03-21 13:38:24.000000','1','','','','1234567890','','',1,55,'2023-03-21',317,160,89,'Sudheesh',41,'Call back Requested',4,89,'Sudheesh',0,66,'','','1234567890',0,NULL,NULL,89,NULL,1,'2023-03-21 13:38:24.000000',NULL,1,1,'2023-03-21 13:38:24.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'Evoke Study Data','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-21 13:38:24.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'8d373580-c7bf-11ed-ac71-779a75f33f43',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,1,'2023-03-21 13:41:21.000000','2','','','','1234567809','','',1,57,'2023-03-21',348,135,86,'V.Lakshmy',41,'',0,89,'Sudheesh',0,40,'','','1234567809',1,89,'2023-03-21 13:41:35.000000',89,NULL,1,'2023-03-21 13:41:21.000000',41,1,1,'2023-03-21 13:41:21.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,10,'Offer Clearence',1,'Angamaly',NULL,NULL,'Interested',31,'FB, Insta, Twitter','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-21 13:41:21.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'f73a7dc0-c7bf-11ed-ac71-779a75f33f43',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#e5938a','*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,1,'2023-03-21 13:42:52.000000','3','','','','1234567899','','',1,59,'2023-03-21',348,135,92,'Offer clearance user 2',41,'',0,89,'Sudheesh',0,40,'','','1234567899',1,89,'2023-03-21 13:43:00.000000',89,NULL,1,'2023-03-21 13:42:52.000000',41,1,1,'2023-03-21 13:42:52.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,11,'Offer Clearence',1,'Angamaly',NULL,NULL,'Interested',31,'FB, Insta, Twitter','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-21 13:42:52.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'2d550bf0-c7c0-11ed-ac71-779a75f33f43',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#e5938a','*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,1,'2023-03-21 13:44:18.000000','4','','','','1234567812','','',1,71,'2023-03-21',347,4,85,'S.Lakshmy',41,'',0,85,'S.Lakshmy',0,77,'','','1234567812',1,89,'2023-03-21 13:44:26.000000',89,NULL,1,'2023-03-21 13:44:18.000000',41,1,1,'2023-03-21 13:44:18.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,12,'Offer Chase',1,'Angamaly',NULL,NULL,'Offer Pending',31,'GEEBEE EXPO 07/08/2022','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-21 13:44:18.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'60a640f0-c7c0-11ed-ac71-779a75f33f43',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#69d70f','0,*85*,*85*,*85*,*85*,*85*,*85*,*85*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,1,'2023-03-23 09:30:42.000000','test','','','','1234567877','','',1,72,'2023-03-23',317,160,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,77,'','','1234567877',0,NULL,NULL,89,NULL,1,'2023-03-23 09:30:42.000000',NULL,1,1,'2023-03-23 09:30:42.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'GEEBEE EXPO 07/08/2022','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-23 09:30:42.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'47e1ce20-c92f-11ed-9929-cda01a467c59',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(18,1,'2023-03-23 13:24:56.000000','33','','','','4444567812','','',1,73,'2023-03-23',317,160,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,77,'','','4444567812',0,NULL,NULL,89,NULL,1,'2023-03-23 13:24:56.000000',NULL,1,1,'2023-03-23 13:24:56.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'GEEBEE EXPO 07/08/2022','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-23 13:24:56.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'00ff2040-c950-11ed-9e7f-af031bdf83da',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,1,'2023-03-23 13:25:49.000000','44','','','','5554567812','','',1,74,'2023-03-23',317,160,89,'Sudheesh',41,'Temporarily unavailable',10,89,'Sudheesh',0,56,'','','5554567812',0,NULL,NULL,89,NULL,1,'2023-03-23 13:25:49.000000',NULL,1,1,'2023-03-23 13:25:49.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'GLEN REFERENCE (IELTS)','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-23 13:25:49.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'208cf9f0-c950-11ed-9e7f-af031bdf83da',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,1,'2023-03-23 14:06:28.000000','abc','','','','1234567333','','',1,75,'2023-03-23',317,160,89,'Sudheesh',41,'Temporarily unavailable',10,89,'Sudheesh',0,69,'','','1234567333',0,NULL,NULL,89,NULL,1,'2023-03-23 14:06:28.000000',NULL,1,1,'2023-03-23 14:06:28.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'FB DATA PURCHASE','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-23 14:06:28.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'ce1a59f0-c955-11ed-8a97-f37ea2e510fa',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,1,'2023-03-23 14:12:14.000000','xyz','','','','1234567833','','',1,76,'2023-03-23',317,160,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,40,'','','1234567833',0,NULL,NULL,89,NULL,1,'2023-03-23 14:12:14.000000',NULL,1,1,'2023-03-23 14:12:14.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Application follow up',31,'FB, Insta, Twitter','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-23 14:12:14.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'9c89cb40-c956-11ed-8a97-f37ea2e510fa',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','89','2023-03-23 17:50:19',0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,1,'2023-03-23 15:23:11.000000','r','','','','1234567111','','',1,80,'2023-03-23',343,136,98,'telecaller1',41,'tesyt',0,98,'telecaller1',0,56,'','','1234567111',0,NULL,NULL,98,NULL,1,'2023-03-23 15:23:11.000000',NULL,1,1,'2023-03-23 15:23:11.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Tele Caller',1,'Angamaly',NULL,NULL,'Not interested',34,'GLEN REFERENCE (IELTS)','','telecaller1',NULL,NULL,0,'Select',NULL,0,'2023-03-23 15:23:11.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,343,0,0,0,0,0,0,0,0,98,0,0,'85d49ba0-c960-11ed-8a97-f37ea2e510fa',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',2,'Negative','#5a06c1','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,1,'2023-03-23 17:14:39.000000','rst','','','','7734567812','','',1,83,'2023-03-23',347,3,91,'Offer Chase User 2',41,'',0,84,'Sreekesh',0,40,'','','7734567812',1,89,'2023-03-23 17:14:51.000000',89,NULL,1,'2023-03-23 17:14:39.000000',41,1,1,'2023-03-23 17:14:39.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,13,'Offer Chase',1,'Angamaly',NULL,NULL,'Lodgment',31,'FB, Insta, Twitter','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-23 17:14:39.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'17d1f7f0-c970-11ed-8a97-f37ea2e510fa',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',1,'Positive','#69d70f','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,1,'2023-03-23 17:31:20.000000','dd','','','','41234567812','','',1,90,'2023-03-28',347,3,85,'S.Lakshmy',41,'',0,89,'Sudheesh',0,69,'','','41234567812',1,89,'2023-03-23 17:32:49.000000',89,NULL,1,'2023-03-23 17:31:20.000000',41,1,1,'2023-03-23 17:31:20.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,14,'Offer Chase',1,'Angamaly',NULL,NULL,'Lodgment',31,'FB DATA PURCHASE','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-23 17:31:20.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'6cc18530-c972-11ed-8a97-f37ea2e510fa',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','89','2023-03-23 17:50:02',0,'','','',0,0,'',1,'Positive','#69d70f','*89*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,1,'2023-03-23 17:51:30.000000','Full Name','','','xxxxxx@gmail.com','91984xxxxxxx','2023-03-23 17:51:30','',0,87,'2023-03-23',317,135,89,'Sudheesh',41,'',0,89,'Sudheesh',0,66,'','','',0,0,NULL,89,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'','0',NULL,'2023-03-23','2023-03-23',NULL,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'Evoke Study Data','','Sudheesh',NULL,NULL,NULL,NULL,NULL,NULL,'2023-03-23 17:51:30.000000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'#aef4cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,1,'2023-03-28 10:23:19.000000','g','','','','2343455441','','',1,88,'2023-03-28',317,135,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,80,'','','2343455441',0,NULL,NULL,89,NULL,1,'2023-03-28 10:23:19.000000',NULL,1,1,'2023-03-28 10:23:19.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'IELTS data collected on 01/08/2022','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-28 10:23:19.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'75ef57d0-cd24-11ed-a377-0d6eab066ed5',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,1,'2023-03-28 10:29:58.000000','V','','','','2342344567','','',1,89,'2023-03-28',317,135,89,'Sudheesh',41,'Temporarily unavailable',10,89,'Sudheesh',0,94,'','','2342344567',0,NULL,NULL,89,NULL,1,'2023-03-28 10:29:58.000000',NULL,1,1,'2023-03-28 10:29:58.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'ffffffffffffffffff','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-29 13:59:56.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'6343dfb0-cd25-11ed-a377-0d6eab066ed5',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,NULL,'*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,1,'2023-03-28 12:07:40.000000','dd1','','','','1234567811','','',1,93,'2023-03-28',346,135,84,'Sreekesh',41,'closed',0,89,'Sudheesh',0,40,'','','1234567811',1,89,'2023-03-28 12:08:27.000000',89,NULL,1,'2023-03-28 12:07:40.000000',41,1,1,'2023-03-28 12:07:40.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,15,'Lodgment',1,'Angamaly',NULL,NULL,'135',31,'FB, Insta, Twitter','','Sudheesh','Sudheesh','Angamaly',0,'Select',NULL,0,'2023-03-28 12:07:53.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'09c31740-cd33-11ed-bbe5-335f862aa7cf',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#34a0a2','*89*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,1,'2023-03-28 12:10:57.000000','qq1','','','','1234569811','','',1,98,'2023-03-28',346,160,90,'Lodgment user2',41,'',0,89,'Sudheesh',0,77,'','','1234569811',0,NULL,NULL,89,NULL,1,'2023-03-28 12:10:57.000000',NULL,1,1,'2023-03-28 12:10:57.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Lodgment',1,'Angamaly',NULL,NULL,'Application follow up',31,'GEEBEE EXPO 07/08/2022','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-28 12:10:57.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'7ed55610-cd33-11ed-bbe5-335f862aa7cf',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,0,'',NULL,NULL,'#34a0a2','*89*,*89*,*89*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,1,'2023-03-28 13:41:40.000000','Full Name','','','xxxxxx@gmail.com','784258471','2023-03-28 13:41:40','',0,99,'2023-03-28',317,135,89,'Sudheesh',41,'',0,89,'Sudheesh',0,40,'','','1234',0,0,NULL,89,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'','0',NULL,'2023-03-28','2023-03-28',NULL,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'FB, Insta, Twitter','','Sudheesh',NULL,NULL,NULL,NULL,NULL,NULL,'2023-03-28 13:41:40.000000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'#aef4cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(31,1,'2023-03-28 13:41:40.000000','jk','','',NULL,'342343421','2023-03-28 13:41:40','',0,100,'2023-03-28',317,135,89,'Sudheesh',41,'',0,89,'Sudheesh',0,40,'','','859',0,0,NULL,89,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'','0',NULL,'2023-03-28','2023-03-28',NULL,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'FB, Insta, Twitter','','Sudheesh',NULL,NULL,NULL,NULL,NULL,NULL,'2023-03-28 13:41:40.000000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'#aef4cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,1,'2023-03-28 13:41:40.000000','lm','','','dsfsd','3454656546','2023-03-28 13:41:40','',0,101,'2023-03-28',317,135,89,'Sudheesh',41,'',0,89,'Sudheesh',0,40,'','','v',0,0,NULL,89,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,'','0',NULL,'2023-03-28','2023-03-28',NULL,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'FB, Insta, Twitter','','Sudheesh',NULL,NULL,NULL,NULL,NULL,NULL,'2023-03-28 13:41:40.000000',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'#aef4cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,1,'2023-03-29 16:45:30.000000','Unni Ajijjjjj','','','','9961808010','','',1,102,'2023-03-29',317,135,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,78,'','','9961808010',0,NULL,NULL,89,NULL,1,'2023-03-29 16:45:30.000000',NULL,1,1,'2023-03-29 16:45:30.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'IELTS data collected on 23/07/2022','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-29 16:45:30.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'044659d0-ce23-11ed-bcf3-091a550e3888',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(34,1,'2023-03-29 17:00:04.000000','ggg','','','','9961108051','','',1,103,'2023-03-29',317,135,89,'Sudheesh',41,'Call back Requested',4,89,'Sudheesh',0,96,'','','9961108051',0,NULL,NULL,89,NULL,1,'2023-03-29 17:00:04.000000',NULL,1,1,'2023-03-29 17:00:04.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'ggg','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-29 17:00:04.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'0d0e0d90-ce25-11ed-bcf3-091a550e3888',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(35,1,'2023-03-30 09:46:36.000000','ttt','','','','7845120178','','',1,104,'2023-03-30',317,135,89,'Sudheesh',41,'Call back Requested',4,89,'Sudheesh',0,94,'','','7845120178',0,NULL,NULL,89,NULL,1,'2023-03-30 09:46:36.000000',NULL,1,1,'2023-03-30 09:46:36.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'ffffffffffffffffff','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-30 11:49:28.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'a968bbe0-ceb1-11ed-b866-5f6f2b3ce9db',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',NULL,NULL,'#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(36,1,'2023-03-30 10:01:34.000000','gfhgfhgf','','','','7845125874','','',1,105,'2023-03-30',317,135,89,'Sudheesh',41,'Call back Requested',4,89,'Sudheesh',0,94,'','','7845125874',0,NULL,NULL,89,NULL,1,'2023-03-30 10:01:34.000000',NULL,1,1,'2023-03-30 10:01:34.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'ffffffffffffffffff','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-30 10:01:34.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'c05c5da0-ceb3-11ed-b866-5f6f2b3ce9db',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(37,1,'2023-03-30 10:05:45.000000','uuu','','','','7845986525','','',1,109,'2023-03-30',317,135,89,'Sudheesh',41,'Not responding',11,89,'Sudheesh',0,94,'','','7845986525',0,NULL,NULL,89,NULL,1,'2023-03-30 10:05:45.000000',NULL,1,1,'2023-03-30 10:05:45.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'ffffffffffffffffff','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-30 16:41:00.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'56351d30-ceb4-11ed-8821-b193ac3b089c',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*,*89*,*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(38,1,'2023-03-30 16:40:41.000000','vgbcb','','','','7845125123','','',1,107,'2023-03-30',317,135,89,'Sudheesh',41,'Call back Requested',4,89,'Sudheesh',0,105,'','','7845125123',0,NULL,NULL,89,NULL,1,'2023-03-30 16:40:41.000000',NULL,1,1,'2023-03-30 16:40:41.000000','',0,NULL,NULL,NULL,'',NULL,NULL,0,NULL,'Admissions',1,'Angamaly',NULL,NULL,'Interested',31,'  fgfgfggffgbbb','','Sudheesh',NULL,NULL,0,'Select',NULL,0,'2023-03-30 16:40:41.000000',0,'Select',0,'Select','','','','','','','',0,'Select',41,317,0,0,0,89,0,0,0,0,0,0,0,'822d59c0-ceeb-11ed-bf9a-01311865e912',0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','0',NULL,0,'','','',0,1,'',1,'Positive','#aef4cc','*89*',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(39,1,'2023-03-30 17:32:18.000000','Pallavi','kochi',NULL,'pallavi@gmail.com','9074018372',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,108,NULL,NULL,NULL,NULL,NULL,NULL,108,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TestAgent3003023',NULL,'TestAgent3003023',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2023-03-31',1,'Pass'),(40,NULL,'2023-03-30 17:52:10.000000','neenu','',NULL,'','1230456987',NULL,NULL,NULL,112,'2023-03-30',348,135,86,'V.Lakshmy',41,'Call back Requested',4,89,'Sudheesh',0,108,NULL,NULL,NULL,NULL,NULL,NULL,108,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Offer Clearence',1,'Angamaly',NULL,NULL,'Interested',31,'TestAgent3003023',NULL,'TestAgent3003023',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'Select',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'',1,'Positive','#e5938a','0,*89*',NULL,NULL,NULL,0,'',0,''),(41,NULL,'2023-03-30 17:54:44.000000','gdfg','',NULL,'','2222222222',NULL,NULL,NULL,111,'2023-03-30',348,135,92,'Offer clearance user 2',41,'',0,108,'TestAgent3003023',0,108,NULL,NULL,NULL,NULL,NULL,NULL,108,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Offer Clearence',1,'Angamaly',NULL,NULL,'Interested',31,'TestAgent3003023',NULL,'TestAgent3003023',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'',NULL,NULL,'#e5938a','0',NULL,NULL,NULL,0,'',0,'');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_agent_country`
--

DROP TABLE IF EXISTS `student_agent_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_agent_country` (
  `Student_Agent_Country_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Id` int DEFAULT NULL,
  `Agent_Id` int DEFAULT NULL,
  `Agent_Country_Id` int DEFAULT NULL,
  `Agent_Country_Name` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Student_Agent_Country_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_agent_country`
--

LOCK TABLES `student_agent_country` WRITE;
/*!40000 ALTER TABLE `student_agent_country` DISABLE KEYS */;
INSERT INTO `student_agent_country` VALUES (13,37,94,1,'UK',0),(14,37,94,2,'Canada',0),(15,35,94,3,'Newyork',0),(16,-1,105,1,'UK',0),(17,-1,105,2,'Canada',0),(18,-1,105,3,'Newyork',0),(19,38,105,1,'UK',0),(20,38,105,2,'Canada',0),(21,38,105,3,'Newyork',0),(22,37,94,1,'UK',0),(23,37,94,2,'Canada',0),(24,39,108,1,'UK',0),(25,39,108,3,'Newyork',0),(26,40,108,1,'UK',0),(27,40,108,1,'UK',0),(28,40,108,3,'Newyork',0),(29,41,108,1,'UK',0),(30,41,108,2,'Canada',0);
/*!40000 ALTER TABLE `student_agent_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_approve_status`
--

DROP TABLE IF EXISTS `student_approve_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_approve_status` (
  `Student_Approve_Status_Id` int NOT NULL,
  `Status_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Approve_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_approve_status`
--

LOCK TABLES `student_approve_status` WRITE;
/*!40000 ALTER TABLE `student_approve_status` DISABLE KEYS */;
INSERT INTO `student_approve_status` VALUES (0,'Student Approval Pending',0),(1,'Student Approved',0);
/*!40000 ALTER TABLE `student_approve_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_checklist`
--

DROP TABLE IF EXISTS `student_checklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_checklist` (
  `Student_Checklist_Id` int NOT NULL,
  `Check_List_Id` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Applicable` tinyint unsigned DEFAULT NULL,
  `Checklist_Status` tinyint unsigned DEFAULT NULL,
  `Description` varchar(150) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Checklist_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_checklist`
--

LOCK TABLES `student_checklist` WRITE;
/*!40000 ALTER TABLE `student_checklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_checklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_checklist_details`
--

DROP TABLE IF EXISTS `student_checklist_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_checklist_details` (
  `Student_Checklist_Details_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Checklist_Master_Id` int DEFAULT NULL,
  `Checklist_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Student_Checklist_Details_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_checklist_details`
--

LOCK TABLES `student_checklist_details` WRITE;
/*!40000 ALTER TABLE `student_checklist_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_checklist_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_checklist_master`
--

DROP TABLE IF EXISTS `student_checklist_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_checklist_master` (
  `Student_Checklist_Master_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Checklist_Master_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_checklist_master`
--

LOCK TABLES `student_checklist_master` WRITE;
/*!40000 ALTER TABLE `student_checklist_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_checklist_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_course_apply`
--

DROP TABLE IF EXISTS `student_course_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_course_apply` (
  `Student_Course_Apply_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `Paid_On` date DEFAULT NULL,
  `Description1` varchar(50) DEFAULT NULL,
  `Description2` varchar(50) DEFAULT NULL,
  `Total_Course` int DEFAULT NULL,
  `Paid_Fees` varchar(45) DEFAULT NULL,
  `User_id` int DEFAULT NULL,
  PRIMARY KEY (`Student_Course_Apply_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_course_apply`
--

LOCK TABLES `student_course_apply` WRITE;
/*!40000 ALTER TABLE `student_course_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_course_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_course_selection`
--

DROP TABLE IF EXISTS `student_course_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_course_selection` (
  `Student_Course_Selection_Id` int NOT NULL,
  `Course_Id` int DEFAULT NULL,
  `Fees` bigint DEFAULT NULL,
  `Student_Course_Apply_Id` int DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `Paid_On` date DEFAULT NULL,
  `Description1` varchar(50) DEFAULT NULL,
  `Description2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Student_Course_Selection_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_course_selection`
--

LOCK TABLES `student_course_selection` WRITE;
/*!40000 ALTER TABLE `student_course_selection` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_course_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_document`
--

DROP TABLE IF EXISTS `student_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_document` (
  `Student_Document_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` date DEFAULT NULL,
  `File_Name` varchar(500) DEFAULT NULL,
  `Document_Id` int DEFAULT NULL,
  `Document_Name` varchar(500) DEFAULT NULL,
  `Image` varchar(500) DEFAULT NULL,
  `Description` text,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Document_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_document`
--

LOCK TABLES `student_document` WRITE;
/*!40000 ALTER TABLE `student_document` DISABLE KEYS */;
INSERT INTO `student_document` VALUES (4,14,'2023-03-21','julian-wan-WNoLnJo7tS8-unsplash.jpg',8,'+2 Certificate',NULL,'h',0),(12,9,'2023-03-22','julian-wan-WNoLnJo7tS8-unsplash.jpg',8,'+2 Certificate','9db6bd20-c893-11ed-9254-f175d82fe9d9.jpg','kj,jj',1),(13,9,'2023-03-22','julian-wan-WNoLnJo7tS8-unsplash.jpg',10,'P.G  Certificate',NULL,'qwqw',0),(14,9,'2023-03-22','google.png',7,'SSLC Certificate','9e23f680-c896-11ed-bd35-d390d963cd7b.xlsx','lpo',0),(15,9,'2023-03-22','star.png',8,'+2 Certificate','95390350-c894-11ed-9254-f175d82fe9d9.png','vbn',0),(16,9,'2023-03-22','CATALOGUE DEPARTMENT PROCESS.pdf',84,'dwedwewe','6d3e4dd0-c897-11ed-94c5-f3e6b5e3a710.png','zczxc',0),(17,9,'2023-03-22','icon-logo.png',10,'P.G  Certificate','7ea5ad30-c896-11ed-bd35-d390d963cd7b.03.55 PM (1).jpeg','qwqw',0),(18,8,'2023-03-22','bg-2.png',7,'SSLC Certificate','9c93eb30-c897-11ed-94c5-f3e6b5e3a710.png','123',0),(19,8,'2023-03-22','bg-4.jpg',82,'Resume','acf9c3a0-c897-11ed-94c5-f3e6b5e3a710.png','890',0),(20,17,'2023-03-23','bg-1.png',88,'IELTS/PTE Score Sheet','204ccd60-c934-11ed-9929-cda01a467c59.png','ty5',0),(21,17,'2023-03-23','Logo-1.png',7,'SSLC Certificate','b9632cf0-c94e-11ed-9e7f-af031bdf83da.png','test',0),(22,17,'2023-03-23','Logo-1.png',9,'U .G Certificate','346de4d0-c94f-11ed-9e7f-af031bdf83da.png','h6',0),(23,17,'2023-03-23','Logo-1.png',81,'Diploma Certificate','41c43350-c94f-11ed-9e7f-af031bdf83da.png','f5',0),(24,17,'2023-03-23','Logo-2.png',85,'10th Certificate','4f50fb20-c94f-11ed-9e7f-af031bdf83da.png','fg',0),(25,17,'2023-03-23','Logo-2.png',85,'10th Certificate','4ee1e5a0-c94f-11ed-9e7f-af031bdf83da.png','fg',0),(26,17,'2023-03-23','Logo-2.png',88,'IELTS/PTE Score Sheet','4fee73a0-c94f-11ed-9e7f-af031bdf83da.png','fg5',0),(27,18,'2023-03-23','Logo-1.png',7,'SSLC Certificate','0dcba550-c950-11ed-9e7f-af031bdf83da.png','test',0),(28,18,'2023-03-23','Logo-1.png',8,'+2 Certificate','2e5d3360-c950-11ed-9e7f-af031bdf83da.png','ggg',0),(29,21,'2023-03-23','blog.html',7,'SSLC Certificate','3618a310-c959-11ed-8a97-f37ea2e510fa.html',';',0),(30,21,'2023-03-23','blog.html',8,'+2 Certificate','a3922220-c960-11ed-8a97-f37ea2e510fa.html','f',0),(31,33,'2023-03-29','zenestyregrptsp.txt',9,'U .G Certificate','708e7d70-ce2d-11ed-bcf3-091a550e3888.txt','tt',0),(32,37,'2023-03-30','zenestyregrptsp.txt',7,'SSLC Certificate','753edd80-ceda-11ed-968d-d3956bd0ba19.txt','bvbv',0);
/*!40000 ALTER TABLE `student_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_followup`
--

DROP TABLE IF EXISTS `student_followup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_followup` (
  `Student_FollowUp_Id` int NOT NULL AUTO_INCREMENT,
  `Student_Id` int DEFAULT NULL,
  `Entry_date` datetime(6) DEFAULT NULL,
  `Next_FollowUp_date` datetime(6) DEFAULT NULL,
  `FollowUp_Difference` int DEFAULT NULL,
  `Department` int DEFAULT NULL,
  `Status` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Branch` int DEFAULT NULL,
  `Remark` varchar(4000) DEFAULT NULL,
  `Remark_Id` int DEFAULT NULL,
  `By_User_Id` int DEFAULT NULL,
  `Class_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `FollowUP_Time` datetime(6) DEFAULT NULL,
  `Actual_FollowUp_date` datetime(6) DEFAULT NULL,
  `Entry_Type` int DEFAULT NULL,
  `Branch_Name` varchar(100) DEFAULT NULL,
  `UserName` varchar(100) DEFAULT NULL,
  `ByUserName` varchar(100) DEFAULT NULL,
  `Dept_StatusName` varchar(100) DEFAULT NULL,
  `Dept_Name` varchar(100) DEFAULT NULL,
  `Student` varchar(100) DEFAULT NULL,
  `FollowupBranch` varchar(100) DEFAULT NULL,
  `Remark_Name` varchar(200) DEFAULT NULL,
  `FollowUp` tinyint DEFAULT NULL,
  `Class_Name` varchar(200) DEFAULT NULL,
  `Sub_Status_Id` int DEFAULT NULL,
  `Sub_Status_Name` varchar(100) DEFAULT NULL,
  `Status_Type_Id` int DEFAULT NULL,
  `Status_Type_Name` varchar(45) DEFAULT NULL,
  `First_Time_Dept` tinyint DEFAULT NULL,
  PRIMARY KEY (`Student_FollowUp_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_followup`
--

LOCK TABLES `student_followup` WRITE;
/*!40000 ALTER TABLE `student_followup` DISABLE KEYS */;
INSERT INTO `student_followup` VALUES (1,1,'2023-03-18 11:03:48.000000','2023-03-18 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-18 11:03:48.000000','2023-03-18 11:03:48.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','A',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(2,2,'2023-03-18 11:43:15.000000','2023-03-18 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-18 11:43:15.000000','2023-03-18 11:43:15.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','B',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(3,3,'2023-03-18 11:43:34.000000','2023-03-18 00:00:00.000000',0,317,160,89,41,'Not responding',11,89,0,0,'2023-03-18 11:43:34.000000','2023-03-18 11:43:34.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','C',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(4,4,'2023-03-18 11:44:51.000000','2023-03-18 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-18 11:44:51.000000','2023-03-18 11:44:51.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','D',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(5,1,'2023-03-18 15:03:00.000000','2023-03-18 15:03:00.000000',0,346,2,84,41,'',0,89,1,0,'2023-03-18 15:03:00.000000','2023-03-18 15:03:00.000000',3,'Angamaly','Sreekesh','Sudheesh','Lodgment Pending','Lodgment','A',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(6,1,'2023-03-18 15:08:07.000000','2023-03-18 15:08:07.000000',0,322,183,94,41,'',0,89,1,0,'2023-03-18 15:08:07.000000','2023-03-18 15:08:07.000000',3,'Angamaly','visa user 2','Sudheesh','Visa submitted','Visa','A',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(7,1,'2023-03-18 15:08:31.000000','2023-03-18 15:08:31.000000',0,346,3,84,41,'',0,84,1,0,'2023-03-18 15:08:31.000000','2023-03-18 15:08:31.000000',3,'Angamaly','Sreekesh','Sreekesh','Lodgment','Lodgment','A',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(8,1,'2023-03-18 15:18:00.000000','2023-03-18 15:18:00.000000',0,347,3,85,41,'',0,84,1,0,'2023-03-18 15:18:00.000000','2023-03-18 15:18:00.000000',3,'Angamaly','S.Lakshmy','Sreekesh','Lodgment','Offer Chase','A',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(9,1,'2023-03-18 15:20:51.000000','2023-03-18 15:20:51.000000',0,348,6,86,41,'',0,89,1,0,'2023-03-18 15:20:51.000000','2023-03-18 15:20:51.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Student Approval','Offer Clearence','A',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(10,1,'2023-03-18 15:22:00.000000','2023-03-18 15:22:00.000000',0,322,7,94,41,'',0,86,1,0,'2023-03-18 15:22:00.000000','2023-03-18 15:22:00.000000',3,'Angamaly','visa user 2','V.Lakshmy','visa Pending','Visa','A',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(11,1,'2023-03-18 15:23:23.000000','2023-03-18 15:23:23.000000',0,349,8,87,41,'',0,88,1,0,'2023-03-18 15:23:23.000000','2023-03-18 15:23:23.000000',3,'Angamaly','Jesna','Bincy','Visa Approved','Review','A',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(12,1,'2023-03-18 15:23:43.000000','2023-03-18 15:23:43.000000',0,349,9,87,41,'',0,87,1,0,'2023-03-18 15:23:43.000000','2023-03-18 15:23:43.000000',3,'Angamaly','Jesna','Jesna','Visa Completed','Review','A',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(13,1,'2023-03-18 15:23:53.000000','2023-03-18 15:23:53.000000',0,349,9,87,41,'',0,87,1,0,'2023-03-18 15:23:53.000000','2023-03-18 15:23:53.000000',3,'Angamaly','Jesna','Jesna','Visa Completed','Review','A',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(14,5,'2023-03-20 10:15:20.000000','2023-03-20 00:00:00.000000',0,318,172,83,38,'Call back Requested',4,83,0,0,'2023-03-20 10:15:20.000000','2023-03-20 10:15:20.000000',1,'Kottayam','Ashok','Ashok','Call not connected','Accounts','D',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(15,5,'2023-03-20 10:21:16.000000','2023-03-20 10:21:16.000000',0,322,183,88,41,'',0,83,1,0,'2023-03-20 10:21:16.000000','2023-03-20 10:21:16.000000',3,'Angamaly','Bincy','Ashok','Visa submitted','Visa','D',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(16,6,'2023-03-20 11:20:44.000000','2023-03-20 00:00:00.000000',0,318,172,83,38,'Course details send',6,83,0,1,'2023-03-20 11:20:44.000000','2023-03-20 11:20:44.000000',1,'Kottayam','Ashok','Ashok','Call not connected','Accounts','bincy',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(17,6,'2023-03-20 11:23:06.000000','2023-03-20 11:23:06.000000',0,322,183,94,41,'',0,83,1,1,'2023-03-20 11:23:06.000000','2023-03-20 11:23:06.000000',3,'Angamaly','visa user 2','Ashok','Visa submitted','Visa','bincy',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(18,7,'2023-03-20 13:33:16.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-20 13:33:16.000000','2023-03-20 13:33:16.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','E',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(19,8,'2023-03-20 13:36:37.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-20 13:36:37.000000','2023-03-20 13:36:37.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','F',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(20,8,'2023-03-20 14:11:38.000000','2023-03-20 14:11:38.000000',0,322,183,88,41,'',0,89,1,0,'2023-03-20 14:11:38.000000','2023-03-20 14:11:38.000000',3,'Angamaly','Bincy','Sudheesh','Visa submitted','Visa','F',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(21,9,'2023-03-20 14:26:33.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-20 14:26:33.000000','2023-03-20 14:26:33.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','G',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(22,10,'2023-03-20 15:01:15.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-20 15:01:15.000000','2023-03-20 15:01:15.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','H',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(23,10,'2023-03-20 15:03:02.000000','2023-03-20 15:03:02.000000',0,346,2,90,41,'',0,89,1,0,'2023-03-20 15:03:02.000000','2023-03-20 15:03:02.000000',3,'Angamaly','Lodgment user2','Sudheesh','Lodgment Pending','Lodgment','H',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(24,10,'2023-03-20 15:07:01.000000','2023-03-20 15:07:01.000000',0,322,183,94,41,'',0,89,1,0,'2023-03-20 15:07:01.000000','2023-03-20 15:07:01.000000',3,'Angamaly','visa user 2','Sudheesh','Visa submitted','Visa','H',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(25,10,'2023-03-20 15:10:39.000000','2023-03-20 15:10:39.000000',0,347,3,91,41,'',0,84,1,0,'2023-03-20 15:10:39.000000','2023-03-20 15:10:39.000000',3,'Angamaly','Offer Chase User 2','Sreekesh','Lodgment','Offer Chase','H',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(26,10,'2023-03-20 15:14:13.000000','2023-03-20 15:14:13.000000',0,317,5,89,41,'',0,85,1,0,'2023-03-20 15:14:13.000000','2023-03-20 15:14:13.000000',3,'Angamaly','Sudheesh','S.Lakshmy','Offer Received','Admissions','H',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(27,10,'2023-03-20 15:16:56.000000','2023-03-20 15:16:56.000000',0,348,6,92,41,'',0,89,1,0,'2023-03-20 15:16:56.000000','2023-03-20 15:16:56.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','Student Approval','Offer Clearence','H',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(28,10,'2023-03-20 15:18:49.000000','2023-03-20 15:18:49.000000',0,322,7,94,41,'',0,86,1,0,'2023-03-20 15:18:49.000000','2023-03-20 15:18:49.000000',3,'Angamaly','visa user 2','V.Lakshmy','visa Pending','Visa','H',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(29,10,'2023-03-20 15:20:34.000000','2023-03-20 15:20:34.000000',0,349,8,93,41,'',0,88,1,0,'2023-03-20 15:20:34.000000','2023-03-20 15:20:34.000000',3,'Angamaly','review user 2','Bincy','Visa Approved','Review','H',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(30,10,'2023-03-20 15:23:12.000000','2023-03-20 15:23:12.000000',0,349,9,93,41,'',0,87,1,0,'2023-03-20 15:23:12.000000','2023-03-20 15:23:12.000000',3,'Angamaly','review user 2','Jesna','Visa Completed','Review','H',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(31,9,'2023-03-20 15:24:50.000000','2023-03-20 15:24:50.000000',0,348,135,86,41,'',0,89,1,0,'2023-03-20 15:24:50.000000','2023-03-20 15:24:50.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','G',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(32,11,'2023-03-20 15:50:12.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-20 15:50:12.000000','2023-03-20 15:50:12.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','1',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(33,11,'2023-03-20 15:50:42.000000','2023-03-20 15:50:42.000000',0,348,135,92,41,'',0,89,1,0,'2023-03-20 15:50:42.000000','2023-03-20 15:50:42.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','Interested','Offer Clearence','1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(34,12,'2023-03-20 15:53:31.000000','2023-03-20 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-20 15:53:31.000000','2023-03-20 15:53:31.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','2',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(35,12,'2023-03-20 15:53:51.000000','2023-03-20 15:53:51.000000',0,348,135,86,41,'',0,89,1,0,'2023-03-20 15:53:51.000000','2023-03-20 15:53:51.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','2',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(36,11,'2023-03-20 17:21:36.000000','2023-03-20 17:21:36.000000',0,347,3,85,41,'',0,89,1,0,'2023-03-20 17:21:36.000000','2023-03-20 17:21:36.000000',3,'Angamaly','S.Lakshmy','Sudheesh','Lodgment','Offer Chase','1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(37,9,'2023-03-20 17:25:49.000000','2023-03-20 17:25:49.000000',0,346,2,84,41,'',0,89,1,0,'2023-03-20 17:25:49.000000','2023-03-20 17:25:49.000000',3,'Angamaly','Sreekesh','Sudheesh','Lodgment Pending','Lodgment','G',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(38,9,'2023-03-20 17:30:16.000000','2023-03-20 17:30:16.000000',0,347,3,91,41,'',0,84,1,0,'2023-03-20 17:30:16.000000','2023-03-20 17:30:16.000000',3,'Angamaly','Offer Chase User 2','Sreekesh','Lodgment','Offer Chase','G',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(39,9,'2023-03-20 17:32:30.000000','2023-03-20 17:32:30.000000',0,317,5,89,41,'',0,85,1,0,'2023-03-20 17:32:30.000000','2023-03-20 17:32:30.000000',3,'Angamaly','Sudheesh','S.Lakshmy','Offer Received','Admissions','G',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(40,11,'2023-03-20 17:49:03.000000','2023-03-20 17:49:03.000000',0,317,5,89,41,'',0,85,1,0,'2023-03-20 17:49:03.000000','2023-03-20 17:49:03.000000',3,'Angamaly','Sudheesh','S.Lakshmy','Offer Received','Admissions','1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(41,5,'2023-03-20 17:50:02.000000','2023-03-20 17:50:02.000000',0,347,3,85,41,'',0,89,1,0,'2023-03-20 17:50:02.000000','2023-03-20 17:50:02.000000',3,'Angamaly','S.Lakshmy','Sudheesh','Lodgment','Offer Chase','D',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(42,11,'2023-03-20 17:50:51.000000','2023-03-20 17:50:51.000000',0,346,2,90,41,'',0,89,1,0,'2023-03-20 17:50:51.000000','2023-03-20 17:50:51.000000',3,'Angamaly','Lodgment user2','Sudheesh','Lodgment Pending','Lodgment','1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(43,11,'2023-03-20 17:51:12.000000','2023-03-20 17:51:12.000000',0,347,3,85,41,'',0,84,1,0,'2023-03-20 17:51:12.000000','2023-03-20 17:51:12.000000',3,'Angamaly','S.Lakshmy','Sreekesh','Lodgment','Offer Chase','1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(44,8,'2023-03-21 09:48:23.000000','2023-03-21 09:48:23.000000',0,346,2,84,41,'',0,89,1,0,'2023-03-21 09:48:23.000000','2023-03-21 09:48:23.000000',3,'Angamaly','Sreekesh','Sudheesh','Lodgment Pending','Lodgment','F',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(45,8,'2023-03-21 09:51:21.000000','2023-03-21 09:51:21.000000',0,347,3,91,41,'',0,84,1,0,'2023-03-21 09:51:21.000000','2023-03-21 09:51:21.000000',3,'Angamaly','Offer Chase User 2','Sreekesh','Lodgment','Offer Chase','F',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(46,8,'2023-03-21 09:52:16.000000','2023-03-21 09:52:16.000000',0,317,5,89,41,'',0,85,1,0,'2023-03-21 09:52:16.000000','2023-03-21 09:52:16.000000',3,'Angamaly','Sudheesh','S.Lakshmy','Offer Received','Admissions','F',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(47,8,'2023-03-21 09:58:13.000000','2023-03-21 09:58:13.000000',0,348,6,92,41,'',0,89,1,0,'2023-03-21 09:58:13.000000','2023-03-21 09:58:13.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','Student Approval','Offer Clearence','F',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(48,9,'2023-03-21 10:14:53.000000','2023-03-21 10:14:53.000000',0,348,6,86,41,'',0,89,1,0,'2023-03-21 10:14:53.000000','2023-03-21 10:14:53.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Student Approval','Offer Clearence','G',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(49,8,'2023-03-21 10:29:41.000000','2023-03-21 10:29:41.000000',0,322,7,88,41,'',0,86,1,0,'2023-03-21 10:29:41.000000','2023-03-21 10:29:41.000000',3,'Angamaly','Bincy','V.Lakshmy','visa Pending','Visa','F',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(50,2,'2023-03-21 12:05:55.000000','2023-03-21 12:05:55.000000',0,346,2,90,41,'',0,89,1,0,'2023-03-21 12:05:55.000000','2023-03-21 12:05:55.000000',3,'Angamaly','Lodgment user2','Sudheesh','Lodgment Pending','Lodgment','B',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(51,3,'2023-03-21 12:06:57.000000','2023-03-21 12:06:57.000000',0,346,2,84,41,'',0,89,1,0,'2023-03-21 12:06:57.000000','2023-03-21 12:06:57.000000',3,'Angamaly','Sreekesh','Sudheesh','Lodgment Pending','Lodgment','C',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(52,9,'2023-03-21 12:07:16.000000','2023-03-21 12:07:16.000000',0,346,2,84,41,'',0,89,1,0,'2023-03-21 12:07:16.000000','2023-03-21 12:07:16.000000',3,'Angamaly','Sreekesh','Sudheesh','Lodgment Pending','Lodgment','G',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(53,7,'2023-03-21 13:33:52.000000','2023-03-21 13:33:52.000000',0,346,2,90,41,'',0,89,1,0,'2023-03-21 13:33:52.000000','2023-03-21 13:33:52.000000',3,'Angamaly','Lodgment user2','Sudheesh','Lodgment Pending','Lodgment','E',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(54,7,'2023-03-21 13:34:32.000000','2023-03-21 13:34:32.000000',0,346,2,90,41,'',0,89,1,0,'2023-03-21 13:34:32.000000','2023-03-21 13:34:32.000000',3,'Angamaly','Lodgment user2','Sudheesh','Lodgment Pending','Lodgment','E',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(55,13,'2023-03-21 13:38:24.000000','2023-03-21 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-21 13:38:24.000000','2023-03-21 13:38:24.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','1',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(56,14,'2023-03-21 13:41:21.000000','2023-03-21 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-21 13:41:21.000000','2023-03-21 13:41:21.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','2',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(57,14,'2023-03-21 13:41:35.000000','2023-03-21 13:41:35.000000',0,348,135,86,41,'',0,89,1,0,'2023-03-21 13:41:35.000000','2023-03-21 13:41:35.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','2',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(58,15,'2023-03-21 13:42:52.000000','2023-03-21 00:00:00.000000',0,317,160,89,41,'Call back Requested',4,89,0,0,'2023-03-21 13:42:52.000000','2023-03-21 13:42:52.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','3',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(59,15,'2023-03-21 13:43:00.000000','2023-03-21 13:43:00.000000',0,348,135,92,41,'',0,89,1,0,'2023-03-21 13:43:00.000000','2023-03-21 13:43:00.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','Interested','Offer Clearence','3',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(60,16,'2023-03-21 13:44:18.000000','2023-03-21 00:00:00.000000',0,317,160,89,41,'Course details send',6,89,0,0,'2023-03-21 13:44:18.000000','2023-03-21 13:44:18.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','4',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(61,16,'2023-03-21 13:44:26.000000','2023-03-21 13:44:26.000000',0,348,135,86,41,'',0,89,1,0,'2023-03-21 13:44:26.000000','2023-03-21 13:44:26.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','4',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(62,16,'2023-03-21 13:46:20.000000','2023-03-21 13:46:20.000000',0,347,3,85,41,'',0,84,1,0,'2023-03-21 13:46:20.000000','2023-03-21 13:46:20.000000',3,'Angamaly','S.Lakshmy','Sreekesh','Lodgment','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(63,16,'2023-03-21 13:51:18.000000','2023-03-21 13:51:18.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:51:18.000000','2023-03-21 13:51:18.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(64,16,'2023-03-21 13:51:33.000000','2023-03-21 13:51:33.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:51:33.000000','2023-03-21 13:51:33.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(65,16,'2023-03-21 13:51:48.000000','2023-03-21 13:51:48.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:51:48.000000','2023-03-21 13:51:48.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(66,16,'2023-03-21 13:53:08.000000','2023-03-21 13:53:08.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:53:08.000000','2023-03-21 13:53:08.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(67,16,'2023-03-21 13:54:11.000000','2023-03-21 13:54:11.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:54:11.000000','2023-03-21 13:54:11.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(68,16,'2023-03-21 13:57:43.000000','2023-03-21 13:57:43.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 13:57:43.000000','2023-03-21 13:57:43.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(69,11,'2023-03-21 14:03:16.000000','2023-03-21 14:03:16.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 14:03:16.000000','2023-03-21 14:03:16.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(70,11,'2023-03-21 14:06:50.000000','2023-03-21 14:06:50.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 14:06:50.000000','2023-03-21 14:06:50.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(71,16,'2023-03-21 14:08:00.000000','2023-03-21 14:08:00.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-21 14:08:00.000000','2023-03-21 14:08:00.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','4',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(72,17,'2023-03-23 09:30:42.000000','2023-03-23 00:00:00.000000',0,317,160,89,41,'Not responding',11,89,0,0,'2023-03-23 09:30:42.000000','2023-03-23 09:30:42.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','test',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(73,18,'2023-03-23 13:24:56.000000','2023-03-23 00:00:00.000000',0,317,160,89,41,'Not responding',11,89,0,0,'2023-03-23 13:24:56.000000','2023-03-23 13:24:56.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','33',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(74,19,'2023-03-23 13:25:49.000000','2023-03-23 00:00:00.000000',0,317,160,89,41,'Temporarily unavailable',10,89,0,0,'2023-03-23 13:25:49.000000','2023-03-23 13:25:49.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','44',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(75,20,'2023-03-23 14:06:28.000000','2023-03-23 00:00:00.000000',0,317,160,89,41,'Temporarily unavailable',10,89,0,0,'2023-03-23 14:06:28.000000','2023-03-23 14:06:28.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','abc',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(76,21,'2023-03-23 14:12:14.000000','2023-03-23 00:00:00.000000',0,317,160,89,41,'Not responding',11,89,0,0,'2023-03-23 14:12:14.000000','2023-03-23 14:12:14.000000',1,'Angamaly','Sudheesh','Sudheesh','Application follow up','Admissions','xyz',NULL,NULL,1,'Select',1,'',NULL,NULL,1),(77,22,'2023-03-23 15:23:11.000000','2023-03-23 00:00:00.000000',0,343,135,98,41,'Call back Requested',4,98,0,0,'2023-03-23 15:23:11.000000','2023-03-23 15:23:51.000000',1,'Angamaly','telecaller1','telecaller1','Interested','Tele Caller','r',NULL,NULL,1,'Select',1,'',1,'Positive',1),(78,22,'2023-03-23 15:23:51.000000','2023-03-23 00:00:00.000000',0,343,135,98,41,'Call back Requested',4,98,0,0,'2023-03-23 15:23:51.000000','2023-03-23 15:25:05.000000',1,'Angamaly','telecaller1','telecaller1','Interested','Tele Caller','',NULL,NULL,1,'Select',NULL,NULL,1,'Positive',0),(79,22,'2023-03-23 15:25:05.000000','2023-03-23 00:00:00.000000',0,343,135,98,41,'Course details send',6,98,0,0,'2023-03-23 15:25:05.000000','2023-03-23 15:27:43.000000',1,'Angamaly','telecaller1','telecaller1','Interested','Tele Caller','',NULL,NULL,1,'Select',NULL,NULL,1,'Positive',0),(80,22,'2023-03-23 15:27:43.000000','2023-03-23 00:00:00.000000',0,343,136,98,41,'tesyt',0,98,0,0,'2023-03-23 15:27:43.000000','2023-03-23 15:27:43.000000',1,'Angamaly','telecaller1','telecaller1','Not interested','Tele Caller','',NULL,NULL,1,'Select',1,'',2,'Negative',0),(81,23,'2023-03-23 17:14:39.000000','2023-03-23 00:00:00.000000',0,317,135,89,41,'Not responding',11,89,0,0,'2023-03-23 17:14:39.000000','2023-03-23 17:14:39.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','rst',NULL,NULL,1,'Select',1,'',1,'Positive',1),(82,23,'2023-03-23 17:14:51.000000','2023-03-23 17:14:51.000000',0,348,135,92,41,'',0,89,1,0,'2023-03-23 17:14:51.000000','2023-03-23 17:14:51.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','Interested','Offer Clearence','rst',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(83,23,'2023-03-23 17:22:09.000000','2023-03-23 17:22:09.000000',0,347,3,91,41,'',0,84,1,0,'2023-03-23 17:22:09.000000','2023-03-23 17:22:09.000000',3,'Angamaly','Offer Chase User 2','Sreekesh','Lodgment','Offer Chase','rst',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(84,5,'2023-03-23 17:26:13.000000','2023-03-23 17:26:13.000000',0,347,4,85,41,'',0,85,1,0,'2023-03-23 17:26:13.000000','2023-03-23 17:26:13.000000',3,'Angamaly','S.Lakshmy','S.Lakshmy','Offer Pending','Offer Chase','D',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(85,24,'2023-03-23 17:31:20.000000','2023-03-23 00:00:00.000000',0,317,135,89,41,'Course details send',6,89,0,0,'2023-03-23 17:31:20.000000','2023-03-23 17:31:20.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','dd',NULL,NULL,1,'Select',1,'',1,'Positive',1),(86,24,'2023-03-23 17:32:49.000000','2023-03-23 17:32:49.000000',0,348,135,86,41,'',0,89,1,0,'2023-03-23 17:32:49.000000','2023-03-23 17:32:49.000000',3,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','dd',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(87,25,'2023-03-23 17:51:30.000000','2023-03-23 00:00:00.000000',0,317,135,89,41,'0',0,89,1,0,'2023-03-23 17:51:30.000000','2023-03-23 17:51:30.000000',NULL,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(88,26,'2023-03-28 10:23:19.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'Not responding',11,89,0,0,'2023-03-28 10:23:19.000000','2023-03-28 10:23:19.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','g',NULL,NULL,1,'Select',1,'',1,'Positive',1),(89,27,'2023-03-28 10:29:58.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'Temporarily unavailable',10,89,0,0,'2023-03-28 10:29:58.000000','2023-03-28 10:29:58.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','V',NULL,NULL,1,'Select',1,'',1,'Positive',1),(90,24,'2023-03-28 11:36:37.000000','2023-03-28 11:36:37.000000',0,347,3,85,41,'',0,89,1,0,'2023-03-28 11:36:37.000000','2023-03-28 11:36:37.000000',3,'Angamaly','S.Lakshmy','Sudheesh','Lodgment','Offer Chase','dd',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(91,28,'2023-03-28 12:07:40.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'Temporarily unavailable',10,89,0,0,'2023-03-28 12:07:40.000000','2023-03-28 12:07:40.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','dd',NULL,NULL,1,'Select',1,'',1,'Positive',1),(92,28,'2023-03-28 12:08:27.000000','2023-03-28 12:08:27.000000',0,348,135,92,41,'',0,89,1,0,'2023-03-28 12:08:27.000000','2023-03-28 12:08:27.000000',3,'Angamaly','Offer clearance user 2','Sudheesh','135','Offer Clearence','dd1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(93,28,'2023-03-28 12:10:05.000000','2023-03-28 12:10:05.000000',0,346,135,84,41,'closed',0,89,1,0,'2023-03-28 12:10:05.000000','2023-03-28 12:10:05.000000',3,'Angamaly','Sreekesh','Sudheesh','135','Lodgment','dd1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(94,29,'2023-03-28 12:10:57.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'Temporarily unavailable',10,89,0,0,'2023-03-28 12:10:57.000000','2023-03-28 12:10:57.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','qq1',NULL,NULL,1,'Select',1,'',1,'Positive',1),(95,29,'2023-03-28 12:11:09.000000','2023-03-28 12:11:09.000000',0,346,135,90,41,'closed',0,89,1,0,'2023-03-28 12:11:09.000000','2023-03-28 12:11:09.000000',3,'Angamaly','Lodgment user2','Sudheesh','Interested','Lodgment','qq1',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(96,29,'2023-03-28 12:14:45.000000','2023-03-28 12:14:45.000000',0,346,160,90,41,'',0,89,1,0,'2023-03-28 12:14:45.000000','2023-03-28 12:15:51.000000',3,'Angamaly','Lodgment user2','Sudheesh','Application follow up','Lodgment','qq1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(97,29,'2023-03-28 12:15:51.000000','2023-03-27 00:00:00.000000',0,346,160,90,41,'Course details send',6,89,0,0,'2023-03-28 12:15:51.000000','2023-03-28 12:15:51.000000',1,'Angamaly','Lodgment user2','Sudheesh','Application follow up','Lodgment','',NULL,NULL,1,'Select',NULL,NULL,NULL,NULL,0),(98,29,'2023-03-28 13:20:49.000000','2023-03-28 13:20:49.000000',0,346,160,90,41,'',0,89,1,0,'2023-03-28 13:20:49.000000','2023-03-28 13:20:49.000000',3,'Angamaly','Lodgment user2','Sudheesh','Application follow up','Lodgment','qq1',NULL,NULL,1,NULL,0,'',NULL,NULL,0),(99,30,'2023-03-28 13:41:40.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'0',0,89,1,0,'2023-03-28 13:41:40.000000','2023-03-28 13:41:40.000000',NULL,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(100,31,'2023-03-28 13:41:40.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'0',0,89,1,0,'2023-03-28 13:41:40.000000','2023-03-28 13:41:40.000000',NULL,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(101,32,'2023-03-28 13:41:40.000000','2023-03-28 00:00:00.000000',0,317,135,89,41,'0',0,89,1,0,'2023-03-28 13:41:40.000000','2023-03-28 13:41:40.000000',NULL,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(102,33,'2023-03-29 16:45:30.000000','2023-03-29 00:00:00.000000',0,317,135,89,41,'Not responding',11,89,0,0,'2023-03-29 16:45:30.000000','2023-03-29 16:45:30.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','Unni Ajijjjjj',NULL,NULL,1,'Select',1,'',1,'Positive',1),(103,34,'2023-03-29 17:00:04.000000','2023-03-29 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-29 17:00:04.000000','2023-03-29 17:00:04.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','ggg',NULL,NULL,1,'Select',1,'',1,'Positive',1),(104,35,'2023-03-30 09:46:36.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-30 09:46:36.000000','2023-03-30 09:46:36.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','ttt',NULL,NULL,1,'Select',1,'',1,'Positive',1),(105,36,'2023-03-30 10:01:34.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-30 10:01:34.000000','2023-03-30 10:01:34.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','gfhgfhgf',NULL,NULL,1,'Select',1,'',1,'Positive',1),(106,37,'2023-03-30 10:05:45.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-30 10:05:45.000000','2023-03-30 16:40:50.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','uuu',NULL,NULL,1,'Select',1,'',1,'Positive',1),(107,38,'2023-03-30 16:40:41.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-30 16:40:41.000000','2023-03-30 16:40:41.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','vgbcb',NULL,NULL,1,'Select',1,'',1,'Positive',1),(108,37,'2023-03-30 16:40:50.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Call back Requested',4,89,0,0,'2023-03-30 16:40:50.000000','2023-03-30 16:41:00.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','',NULL,NULL,1,'Select',1,'',1,'Positive',0),(109,37,'2023-03-30 16:41:00.000000','2023-03-30 00:00:00.000000',0,317,135,89,41,'Not responding',11,89,0,0,'2023-03-30 16:41:00.000000','2023-03-30 16:41:00.000000',1,'Angamaly','Sudheesh','Sudheesh','Interested','Admissions','uuu',NULL,NULL,1,'Select',1,'',1,'Positive',0),(110,40,'2023-03-30 17:54:02.000000','2023-03-30 17:54:02.000000',0,348,135,86,41,'',0,108,1,0,'2023-03-30 17:54:02.000000','2023-03-30 18:18:11.000000',3,'Angamaly','V.Lakshmy','TestAgent3003023','Interested','Offer Clearence','neenu',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(111,41,'2023-03-30 17:54:44.000000','2023-03-30 17:54:44.000000',0,348,135,92,41,'',0,108,1,0,'2023-03-30 17:54:44.000000','2023-03-30 17:54:44.000000',3,'Angamaly','Offer clearance user 2','TestAgent3003023','Interested','Offer Clearence','gdfg',NULL,NULL,1,NULL,0,'',NULL,NULL,1),(112,40,'2023-03-30 18:18:11.000000','2023-03-30 00:00:00.000000',0,348,135,86,41,'Call back Requested',4,89,0,0,'2023-03-30 18:18:11.000000','2023-03-30 18:18:11.000000',1,'Angamaly','V.Lakshmy','Sudheesh','Interested','Offer Clearence','',NULL,NULL,1,'Select',1,'',1,'Positive',0);
/*!40000 ALTER TABLE `student_followup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_message`
--

DROP TABLE IF EXISTS `student_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_message` (
  `Student_Message_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Message_Detail` varchar(2000) DEFAULT NULL,
  `Entry_date` date DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Message_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_message`
--

LOCK TABLES `student_message` WRITE;
/*!40000 ALTER TABLE `student_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_preadmission_checklist_details`
--

DROP TABLE IF EXISTS `student_preadmission_checklist_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_preadmission_checklist_details` (
  `Student_Preadmission_Checklist_Details_Id` int NOT NULL,
  `Student_Preadmission_Checklist_Master_Id` int DEFAULT NULL,
  `Checklist_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Preadmission_Checklist_Details_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_preadmission_checklist_details`
--

LOCK TABLES `student_preadmission_checklist_details` WRITE;
/*!40000 ALTER TABLE `student_preadmission_checklist_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_preadmission_checklist_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_preadmission_checklist_master`
--

DROP TABLE IF EXISTS `student_preadmission_checklist_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_preadmission_checklist_master` (
  `Student_Preadmission_Checklist_Master_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Preadmission_Checklist_Master_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_preadmission_checklist_master`
--

LOCK TABLES `student_preadmission_checklist_master` WRITE;
/*!40000 ALTER TABLE `student_preadmission_checklist_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_preadmission_checklist_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_status`
--

DROP TABLE IF EXISTS `student_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_status` (
  `Student_Status_Id` int NOT NULL,
  `Student_Status_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Student_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_status`
--

LOCK TABLES `student_status` WRITE;
/*!40000 ALTER TABLE `student_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_task`
--

DROP TABLE IF EXISTS `student_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_task` (
  `Student_Task_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Student_Name` varchar(100) DEFAULT NULL,
  `Followup_Date` date DEFAULT NULL,
  `To_User_Name` varchar(200) DEFAULT NULL,
  `Task_Status` int DEFAULT NULL,
  `Status_Name` varchar(20) DEFAULT NULL,
  `Remark` varchar(2000) DEFAULT NULL,
  `To_User` int DEFAULT NULL,
  `Task_Item_Id` int DEFAULT NULL,
  `Department_Id` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `Task_Group_Id` int DEFAULT NULL,
  `Entry_date` datetime DEFAULT NULL,
  `By_User_Id` int DEFAULT NULL,
  `By_User_Name` varchar(100) DEFAULT NULL,
  `Department_Name` varchar(250) DEFAULT NULL,
  `Task_Details` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Student_Task_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_task`
--

LOCK TABLES `student_task` WRITE;
/*!40000 ALTER TABLE `student_task` DISABLE KEYS */;
INSERT INTO `student_task` VALUES (1,5,'D','2023-03-20','Ashok',0,'Select','',83,7,'318',0,4,'2023-03-20 10:18:34',83,'Ashok','Accounts',''),(2,5,'D','2023-03-20','Ashok',1,'Pending','h',83,6,'318',0,3,'2023-03-20 10:19:57',NULL,NULL,NULL,NULL),(3,6,'bincy','2023-03-20','Ashok',1,'Pending','dd',83,7,'318',1,4,'2023-03-20 11:21:45',83,'Ashok','Accounts','4o'),(4,6,'bincy','2023-03-20','Ashok',1,'Pending','78',83,6,'318',1,3,'2023-03-20 11:22:21',NULL,NULL,NULL,NULL),(5,14,'2','2023-03-21','Sudheesh',1,'Pending','tr',89,7,'317',0,4,'2023-03-21 15:09:33',89,'Sudheesh','Admissions','test'),(6,14,'2','2023-03-21','Sudheesh',1,'Pending','test',89,5,'317',0,1,'2023-03-21 15:11:15',NULL,NULL,NULL,NULL),(7,9,'G','2023-03-24','Sudheesh',1,'Pending','test',89,9,'317',0,1,'2023-03-21 15:25:59',NULL,NULL,NULL,NULL),(8,9,'G','2023-03-21','Sudheesh',1,'Pending','a',89,7,'317',0,4,'2023-03-21 15:39:31',89,'Sudheesh','Admissions','4o'),(9,7,'E','2023-03-21','Sudheesh',1,'Pending','dddddd',89,7,'317',0,4,'2023-03-21 15:57:36',89,'Sudheesh','Admissions','ddddddddddd'),(10,7,'E','2023-03-21','Sudheesh',1,'Pending','s',89,7,'317',0,4,'2023-03-21 17:03:55',89,'Sudheesh','Admissions','test'),(11,3,'C','2023-03-21','Sreekesh',1,'Pending','dd',84,7,'346',0,4,'2023-03-21 17:04:40',89,'Sudheesh','Lodgment','test'),(12,2,'B','2023-03-21','Sudheesh',1,'Pending','78',89,7,'317',0,4,'2023-03-21 17:06:15',89,'Sudheesh','Admissions','test'),(13,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,7,'317',0,4,'2023-03-21 17:06:32',89,'Sudheesh','Admissions','qw'),(14,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,'317',0,3,'2023-03-21 17:15:30',NULL,NULL,NULL,NULL),(15,2,'B','2023-03-21','Sudheesh',2,'Completed','a',89,6,'317',0,3,'2023-03-21 17:15:51',NULL,NULL,NULL,NULL),(16,2,'B','2023-03-21','Sudheesh',1,'Pending','a',89,6,'317',0,3,'2023-03-21 17:17:54',NULL,NULL,NULL,NULL),(17,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,'317',0,3,'2023-03-21 17:18:51',NULL,NULL,NULL,NULL),(18,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,'317',0,3,'2023-03-21 17:19:00',NULL,NULL,NULL,NULL),(19,9,'G','2023-03-21','Sudheesh',0,'Select','',89,7,'317',0,4,'2023-03-21 18:03:45',89,'Sudheesh','Admissions',''),(20,9,'G','2023-03-21','Sudheesh',1,'Pending','123',89,7,'317',0,4,'2023-03-21 18:06:42',89,'Sudheesh','Admissions','test1'),(21,9,'G','2023-03-22','V.Lakshmy',1,'Pending','',86,7,'348',0,4,'2023-03-22 15:52:45',89,'Sudheesh','Offer Clearence','test'),(22,9,'G','2023-03-22','Sudheesh',1,'Pending','',89,7,'317',0,4,'2023-03-22 17:15:17',89,'Sudheesh','Admissions','test'),(23,17,'test','2023-03-23','Sudheesh',1,'Pending','',89,7,'317',0,4,'2023-03-23 10:07:14',89,'Sudheesh','Admissions','4o'),(24,17,'test','2023-03-24','Sudheesh',1,'Pending','',89,7,'317',0,4,'2023-03-23 13:35:40',89,'Sudheesh','Admissions','rr'),(25,17,'test','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:01:08',89,'Sudheesh','Admissions','ttest'),(26,17,'test','2023-03-24','Sudheesh',1,'Pending','',89,12,'317',0,4,'2023-03-23 14:02:23',89,'Sudheesh','Admissions','test677'),(27,20,'abc','2023-03-24','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:07:32',89,'Sudheesh','Admissions','4o'),(28,20,'abc','2023-03-24','Sudheesh',1,'Pending','',89,11,'317',1,4,'2023-03-23 14:08:27',89,'Sudheesh','Admissions','testqw'),(29,21,'xyz','2023-03-23','Sudheesh',2,'Completed','rty',89,11,'317',0,4,'2023-03-23 14:13:01',89,'Sudheesh','Admissions','t'),(30,21,'xyz','2023-03-23','Sudheesh',2,'Completed','',89,11,'317',0,4,'2023-03-23 14:25:11',89,'Sudheesh','Admissions','rt'),(31,21,'xyz','2023-03-23','Sudheesh',2,'Completed','rt',89,12,'317',0,4,'2023-03-23 14:45:26',89,'Sudheesh','Admissions','ggg'),(32,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:47:45',89,'Sudheesh','Admissions','4o'),(33,21,'xyz','2023-03-23','Sudheesh',2,'Completed','dd',89,11,'317',0,4,'2023-03-23 14:48:51',89,'Sudheesh','Admissions','ddddddddddd'),(34,21,'xyz','2023-03-23','Sudheesh',2,'Completed','mop',89,11,'317',0,4,'2023-03-23 14:49:04',89,'Sudheesh','Admissions','ddddddddddd'),(35,21,'xyz','2023-03-23','Sudheesh',2,'Completed','78',89,11,'317',0,4,'2023-03-23 14:50:53',89,'Sudheesh','Admissions','test'),(36,21,'xyz','2023-03-23','Sudheesh',2,'Completed','dd',89,11,'317',0,4,'2023-03-23 14:51:06',89,'Sudheesh','Admissions','qw'),(37,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:52:19',89,'Sudheesh','Admissions','4o'),(38,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:52:30',89,'Sudheesh','Admissions','4o'),(39,21,'xyz','2023-03-23','Sudheesh',2,'Completed','',89,11,'317',0,4,'2023-03-23 14:53:22',89,'Sudheesh','Admissions','ddddddddddd'),(40,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 14:57:19',89,'Sudheesh','Admissions','ddddddddddd'),(41,21,'xyz','2023-03-23','Sudheesh',2,'Completed','test',89,11,'317',0,4,'2023-03-23 14:57:57',89,'Sudheesh','Admissions','ddddddddddd'),(42,21,'xyz','2023-03-23','Sudheesh',2,'Completed','cvb',89,11,'317',0,4,'2023-03-23 15:08:23',89,'Sudheesh','Admissions','ddddddddddd'),(43,21,'xyz','2023-03-23','Sudheesh',2,'Completed','tyuiop',89,11,'317',0,4,'2023-03-23 15:10:41',89,'Sudheesh','Admissions','4o'),(44,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 15:13:44',89,'Sudheesh','Admissions','test'),(45,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 15:14:01',89,'Sudheesh','Admissions','qw'),(46,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 15:15:23',89,'Sudheesh','Admissions','test1'),(47,21,'xyz','2023-03-23','Sudheesh',1,'Pending','',89,11,'317',0,4,'2023-03-23 15:15:38',89,'Sudheesh','Admissions','ddddddddddd');
/*!40000 ALTER TABLE `student_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_task_followup`
--

DROP TABLE IF EXISTS `student_task_followup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_task_followup` (
  `Student_Task_Followup_Id` int NOT NULL,
  `Student_Task_Id` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Student_Name` varchar(100) DEFAULT NULL,
  `Followup_Date` date DEFAULT NULL,
  `To_User_Name` varchar(200) DEFAULT NULL,
  `Task_Status` int DEFAULT NULL,
  `Status_Name` varchar(20) DEFAULT NULL,
  `Remark` varchar(2000) DEFAULT NULL,
  `To_User` int DEFAULT NULL,
  `Task_Item_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Entry_date` datetime DEFAULT NULL,
  `By_User_Id` int DEFAULT NULL,
  `By_User_Name` varchar(100) DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Department_Name` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Student_Task_Followup_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_task_followup`
--

LOCK TABLES `student_task_followup` WRITE;
/*!40000 ALTER TABLE `student_task_followup` DISABLE KEYS */;
INSERT INTO `student_task_followup` VALUES (1,1,5,'D','2023-03-20','Ashok',NULL,'Select','',83,7,0,'2023-03-20 10:18:34',83,'Ashok',318,'Accounts'),(2,2,5,'D','2023-03-20','Ashok',1,'Pending','h',83,6,0,'2023-03-20 10:19:57',NULL,NULL,NULL,NULL),(3,3,6,'bincy','2023-03-20','Ashok',NULL,'Pending','dd',83,7,1,'2023-03-20 11:21:45',83,'Ashok',318,'Accounts'),(4,4,6,'bincy','2023-03-20','Ashok',1,'Pending','78',83,6,1,'2023-03-20 11:22:21',NULL,NULL,NULL,NULL),(5,5,14,'2','2023-03-21','Sudheesh',NULL,'Select','',89,7,0,'2023-03-21 15:09:33',89,'Sudheesh',317,'Admissions'),(6,5,14,'2','2023-03-21','Sudheesh',NULL,'Pending','tr',89,7,0,'2023-03-21 15:10:25',89,'Sudheesh',317,'Admissions'),(7,6,14,'2','2023-03-21','Sudheesh',1,'Pending','test',89,5,0,'2023-03-21 15:11:15',NULL,NULL,NULL,NULL),(8,7,9,'G','2023-03-21','Sudheesh',1,'Pending','a',89,9,0,'2023-03-21 15:25:59',NULL,NULL,NULL,NULL),(9,8,9,'G','2023-03-21','Sudheesh',NULL,'Pending','a',89,7,0,'2023-03-21 15:39:31',89,'Sudheesh',317,'Admissions'),(10,9,7,'E','2023-03-21','Sudheesh',NULL,'Pending','dddddd',89,7,0,'2023-03-21 15:57:36',89,'Sudheesh',317,'Admissions'),(11,10,7,'E','2023-03-21','Sudheesh',NULL,'Pending','s',89,7,0,'2023-03-21 17:03:55',89,'Sudheesh',317,'Admissions'),(12,11,3,'C','2023-03-21','Sreekesh',NULL,'Pending','dd',84,7,0,'2023-03-21 17:04:40',89,'Sudheesh',346,'Lodgment'),(13,12,2,'B','2023-03-21','Sudheesh',NULL,'Pending','78',89,7,0,'2023-03-21 17:06:15',89,'Sudheesh',317,'Admissions'),(14,13,2,'B','2023-03-21','Sudheesh',NULL,'Pending','dd',89,7,0,'2023-03-21 17:06:32',89,'Sudheesh',317,'Admissions'),(15,14,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,0,'2023-03-21 17:15:30',NULL,NULL,NULL,NULL),(16,15,2,'B','2023-03-21','Sudheesh',2,'Completed','a',89,6,0,'2023-03-21 17:15:51',NULL,NULL,NULL,NULL),(17,16,2,'B','2023-03-21','Sudheesh',1,'Pending','a',89,6,0,'2023-03-21 17:17:54',NULL,NULL,NULL,NULL),(18,17,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,0,'2023-03-21 17:18:51',NULL,NULL,NULL,NULL),(19,18,2,'B','2023-03-21','Sudheesh',1,'Pending','dd',89,6,0,'2023-03-21 17:19:00',NULL,NULL,NULL,NULL),(20,19,9,'G','2023-03-21','Sudheesh',NULL,'Select','',89,7,0,'2023-03-21 18:03:45',89,'Sudheesh',317,'Admissions'),(21,20,9,'G','2023-03-21','Sudheesh',NULL,'Pending','test2',89,7,0,'2023-03-21 18:06:42',89,'Sudheesh',317,'Admissions'),(22,20,9,'G','2023-03-21','Sudheesh',1,'Pending','dd',89,7,0,'2023-03-21 18:07:11',NULL,NULL,NULL,NULL),(23,20,9,'G','2023-03-21','Sudheesh',1,'Pending','123',89,7,0,'2023-03-21 18:07:29',NULL,NULL,NULL,NULL),(24,21,9,'G','2023-03-22','V.Lakshmy',NULL,'Pending','',86,7,0,'2023-03-22 15:52:45',89,'Sudheesh',348,'Offer Clearence'),(25,22,9,'G','2023-03-22','Sudheesh',NULL,'Pending','',89,7,0,'2023-03-22 17:15:17',89,'Sudheesh',317,'Admissions'),(26,23,17,'test','2023-03-23','Sudheesh',NULL,'Pending','',89,7,0,'2023-03-23 10:07:14',89,'Sudheesh',317,'Admissions'),(27,24,17,'test','2023-03-24','Sudheesh',NULL,'Pending','',89,7,0,'2023-03-23 13:35:40',89,'Sudheesh',317,'Admissions'),(28,7,9,'G','2023-03-24','Sudheesh',1,'Pending','test',89,9,0,'2023-03-23 13:58:34',NULL,NULL,NULL,NULL),(29,25,17,'test','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:01:08',89,'Sudheesh',317,'Admissions'),(30,26,17,'test','2023-03-24','Sudheesh',NULL,'Pending','',89,12,0,'2023-03-23 14:02:23',89,'Sudheesh',317,'Admissions'),(31,27,20,'abc','2023-03-24','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:07:32',89,'Sudheesh',317,'Admissions'),(32,28,20,'abc','2023-03-24','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:08:27',89,'Sudheesh',317,'Admissions'),(33,29,21,'xyz','2023-03-24','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:13:01',89,'Sudheesh',317,'Admissions'),(34,29,21,'xyz','2023-03-25','Sudheesh',1,'Pending','g',89,11,0,'2023-03-23 14:14:49',NULL,NULL,NULL,NULL),(35,30,21,'xyz','2023-03-23','Sudheesh',NULL,'Completed','',89,11,0,'2023-03-23 14:25:11',89,'Sudheesh',317,'Admissions'),(36,31,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,12,0,'2023-03-23 14:45:26',89,'Sudheesh',317,'Admissions'),(37,31,21,'xyz','2023-03-23','Sudheesh',2,'Completed','rt',89,12,0,'2023-03-23 14:46:16',NULL,NULL,NULL,NULL),(38,32,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:47:45',89,'Sudheesh',317,'Admissions'),(39,33,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:48:51',89,'Sudheesh',317,'Admissions'),(40,34,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:49:05',89,'Sudheesh',317,'Admissions'),(41,35,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:50:53',89,'Sudheesh',317,'Admissions'),(42,36,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:51:06',89,'Sudheesh',317,'Admissions'),(43,37,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:52:19',89,'Sudheesh',317,'Admissions'),(44,38,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:52:30',89,'Sudheesh',317,'Admissions'),(45,39,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:53:22',89,'Sudheesh',317,'Admissions'),(46,40,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:57:19',89,'Sudheesh',317,'Admissions'),(47,41,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 14:57:57',89,'Sudheesh',317,'Admissions'),(48,42,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:08:23',89,'Sudheesh',317,'Admissions'),(49,43,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:10:41',89,'Sudheesh',317,'Admissions'),(50,44,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:13:44',89,'Sudheesh',317,'Admissions'),(51,45,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:14:01',89,'Sudheesh',317,'Admissions'),(52,46,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:15:23',89,'Sudheesh',317,'Admissions'),(53,47,21,'xyz','2023-03-23','Sudheesh',NULL,'Pending','',89,11,0,'2023-03-23 15:15:38',89,'Sudheesh',317,'Admissions'),(54,36,21,'xyz','2023-03-22','Sudheesh',1,'Pending','dd',89,11,0,'2023-03-23 15:15:57',NULL,NULL,NULL,NULL),(55,36,21,'xyz','2023-03-23','Sudheesh',2,'Completed','dd',89,11,0,'2023-03-23 15:16:06',NULL,NULL,NULL,NULL),(56,35,21,'xyz','2023-03-23','Sudheesh',2,'Completed','78',89,11,0,'2023-03-23 15:19:06',NULL,NULL,NULL,NULL),(57,34,21,'xyz','2023-03-23','Sudheesh',2,'Completed','mop',89,11,0,'2023-03-23 15:19:31',NULL,NULL,NULL,NULL),(58,33,21,'xyz','2023-03-23','Sudheesh',2,'Completed','dd',89,11,0,'2023-03-23 15:21:24',NULL,NULL,NULL,NULL),(59,29,21,'xyz','2023-03-23','Sudheesh',2,'Completed','rty',89,11,0,'2023-03-23 15:21:52',NULL,NULL,NULL,NULL),(60,43,21,'xyz','2023-03-23','Sudheesh',2,'Completed','tyuiop',89,11,0,'2023-03-23 15:22:51',NULL,NULL,NULL,NULL),(61,42,21,'xyz','2023-03-23','Sudheesh',2,'Completed','cvb',89,11,0,'2023-03-23 15:23:38',NULL,NULL,NULL,NULL),(62,41,21,'xyz','2023-03-23','Sudheesh',2,'Completed','test',89,11,0,'2023-03-23 15:24:20',NULL,NULL,NULL,NULL),(63,39,21,'xyz','2023-03-23','Sudheesh',NULL,'Completed','',89,11,0,'2023-03-23 15:24:58',89,'Sudheesh',317,'Admissions');
/*!40000 ALTER TABLE `student_task_followup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_temp`
--

DROP TABLE IF EXISTS `student_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_temp` (
  `Student_Temp` int NOT NULL,
  `Student_Id` int DEFAULT NULL,
  `Followup_Id` int DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Department_id` int DEFAULT NULL,
  PRIMARY KEY (`Student_Temp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_temp`
--

LOCK TABLES `student_temp` WRITE;
/*!40000 ALTER TABLE `student_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_section`
--

DROP TABLE IF EXISTS `sub_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_section` (
  `Sub_Section_Id` int NOT NULL,
  `Sub_Section_Name` varchar(500) DEFAULT NULL,
  `Selection` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Sub_Section_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_section`
--

LOCK TABLES `sub_section` WRITE;
/*!40000 ALTER TABLE `sub_section` DISABLE KEYS */;
/*!40000 ALTER TABLE `sub_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_status`
--

DROP TABLE IF EXISTS `sub_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_status` (
  `Sub_Status_Id` int NOT NULL,
  `Sub_Status_Name` varchar(100) DEFAULT NULL,
  `Status_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `FollowUp` tinyint unsigned DEFAULT NULL,
  `Duration` int DEFAULT NULL,
  PRIMARY KEY (`Sub_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_status`
--

LOCK TABLES `sub_status` WRITE;
/*!40000 ALTER TABLE `sub_status` DISABLE KEYS */;
INSERT INTO `sub_status` VALUES (1,'',1,0,1,1),(2,'Follow UP Needed',148,1,1,1),(3,'test',149,1,1,2),(4,'ref sub',170,1,1,1),(5,'ref sub2',170,1,1,1),(6,'N sub1',142,1,1,1),(7,'Fund Problem',136,1,1,1),(8,'Interested  Sub Status',171,0,1,1),(9,'Pre Departure Briefing',140,1,1,1),(10,'Clear for Submission',164,1,1,1),(11,'Visa Approved',162,1,1,0),(12,'Interested',155,1,1,1),(13,'Invoice Pending',138,1,1,1),(14,'Visa Approved',151,0,1,1),(15,'Interested',152,0,1,1),(16,'Not Eligible',141,0,1,1),(17,'Travel Authorization Pending',164,0,1,1),(18,'Invoice Pending',138,1,1,1),(19,'Pre Departure Briefing',148,1,1,1),(20,'Certificate Creation',155,1,1,1),(21,'Bph pending',163,0,1,1),(22,'refund pending',168,0,1,1),(23,'Fresh Followup',149,1,1,1),(24,'Course confirmation awaited',149,0,1,5),(25,'Awaiting eligibility for REG registration',154,1,1,30),(26,'Interested in Overseas Education',154,0,1,2),(27,'Information shared for consideration',154,1,1,1),(28,'Number wrong',172,0,0,0),(29,'Number not in use',172,0,0,0),(30,'Call declined',172,0,1,1),(31,'Call not picked up',172,0,1,1),(32,'Call-back requested',172,0,1,1),(33,'Number busy',172,0,1,1),(34,'Out of Coverage ',172,0,1,1),(35,'Switched Off',172,0,1,1),(36,'Awaiting documents for verification',154,1,1,2),(37,'Student plans dropped',155,0,0,0),(38,'Registered with competitor',155,0,0,0),(39,'Study in Canada',135,1,1,2),(40,'Fund Issue',155,0,0,0),(41,'IELTS awaited',149,0,1,15),(42,'IELTS Preparing',149,1,1,30),(43,'Study in UK',135,1,1,2),(44,'Study in Germany',135,1,1,2),(45,'Study in Australia',135,1,1,2),(46,'Study in New Zealand',135,1,1,2),(47,'Canada PR',135,1,0,0),(48,'Study in Poland',135,1,1,2),(49,'Study in Spain',135,1,1,2),(50,'Study in France',135,1,1,2),(51,'Accidental enquiry',136,0,0,0),(52,'Wrong data',136,0,0,0),(53,'Irrelevant country choice',136,0,0,0),(54,'Work visa requirement apart from Canada',136,0,0,0),(55,'Initial payment received',138,0,1,3),(56,'Semester payment received',138,0,1,3),(57,'Study in multiple countries',135,0,1,1),(58,'Already proceeding with competitor',136,0,0,0),(59,'Processing Loan',139,0,1,7),(60,'Provide FOREX link',139,0,1,1),(61,'Encourage fast payment',139,0,1,2),(62,'Awaiting departure',140,0,1,15),(63,'Awaiting pre-departure',140,0,1,15),(64,'Processing Loan',141,0,1,7),(65,'Low score',142,0,0,0),(66,'No funding options',142,0,0,0),(67,'Potential (30-70)%',135,1,1,2),(68,'Probable (0-30)%',135,1,1,2),(69,'Firm (70-100)%',135,1,1,2),(70,'Application Under Processing',151,0,1,3),(71,'Clear for submission',148,0,1,1),(72,'Document pending',148,0,1,4),(73,'Direct',150,0,1,20),(74,'Portal',150,0,1,6),(75,'With Portal',160,0,1,3),(76,'With Institution',160,0,1,3),(77,'Intake not open',173,0,1,7),(78,'Pending documents',173,0,1,3),(79,'By Institution, Student not qualified',174,0,1,1),(80,'By portal, Student not qualified',174,0,1,1),(81,'Cancelled by student',174,0,1,1),(82,'Intake not available',174,0,1,1),(83,'Conditional offer',176,0,1,0),(84,'Unconditional offer',176,0,1,0),(85,'Defer offer',176,0,1,0),(86,'Fund issue',177,0,1,0),(87,'Not interested',177,0,1,0),(88,'Offer revoked',177,0,1,0),(89,'Other offer awaited',179,0,1,2),(90,'Accepted other offer',180,0,0,0),(91,'Not interested',180,0,1,0),(92,'Awaiting initial fee payment',178,0,1,1),(93,'Other offer awaited',176,0,1,2),(94,'Accepted other offer',177,0,0,0),(95,'Initial fee paid',178,0,1,1),(96,'Awaiting semester fee payment',178,0,1,5),(97,'Semester fee paid',178,0,1,5),(98,'Visa documents awaited',178,1,1,3),(99,'Visa documents received',178,1,1,0),(100,'GIC awaited',178,1,1,7),(101,'GIC received',178,1,1,0),(102,'ATAS follow up',178,1,1,15),(103,'Visa documents awaited',162,0,1,3),(104,'Visa documents received',162,0,1,0),(105,'GIC awaited',162,0,1,6),(106,'GIC received',162,0,1,0),(107,'ATAS follow up',162,0,1,15),(108,'ATAS submission',162,0,1,0),(109,'ATIP submission',162,0,1,20),(110,'Student not eligible',155,0,0,0),(111,'Deadline crossed',177,0,1,1),(112,'Interested in Canada PR & Overseas Education',154,0,1,2),(113,'Canada PR & Overseas Education',135,0,1,2),(114,'Study in specified countr(y)ies only',135,0,1,2),(115,'Student awaiting final year exam',181,0,1,60),(116,'Country selection pending',181,0,1,3),(117,'Institution selection pending',181,0,1,3),(118,'Course selection pending',181,0,1,3),(119,'Documents pending',182,0,1,3),(120,'Documents complete',182,0,1,0),(121,'Document pending (UcL)',148,1,1,2),(122,'Annual fee paid',178,0,1,0),(123,'Visa follow up',183,0,1,14),(124,'Informed counsellor',184,0,1,0),(125,'Informed student',184,0,1,0),(126,'Visa follow up',185,0,1,14),(127,'CAS requested',162,0,1,3),(128,'CAS received',162,0,1,0),(129,'Work visa for Canada',135,0,1,0),(130,'Profile documents awaited',149,0,1,2),(131,'Received',186,0,0,0),(132,'Awaiting',186,0,1,1),(133,'Checklist given',187,0,0,0),(134,'Google review received',187,0,1,0),(135,'Doc pending',149,0,1,2),(136,'Cancelled by candidate',175,0,1,1),(137,'Cancelled by portal',175,0,1,2),(138,'Cancelled by institute',175,0,1,2),(139,'Intake not open',175,0,1,2),(140,'Initial fee paid - Defer',178,0,1,3),(141,'Defer',183,0,1,3),(142,'test',135,0,0,0);
/*!40000 ALTER TABLE `sub_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `Subject_Id` int NOT NULL,
  `Subject_Name` varchar(150) DEFAULT NULL,
  `Selection` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Subject_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `Task_Id` int NOT NULL,
  `Task_Details` varchar(2500) DEFAULT NULL,
  `Entry_Date` date DEFAULT NULL,
  `By_User_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Task_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_group`
--

DROP TABLE IF EXISTS `task_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_group` (
  `Task_Group_Id` int NOT NULL,
  `Task_Group_Name` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Task_Group_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_group`
--

LOCK TABLES `task_group` WRITE;
/*!40000 ALTER TABLE `task_group` DISABLE KEYS */;
INSERT INTO `task_group` VALUES (1,'Visa',0),(2,'Pre Visa',0),(3,'Pre Admission',0),(4,'Tasks',0);
/*!40000 ALTER TABLE `task_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_item`
--

DROP TABLE IF EXISTS `task_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_item` (
  `Task_Item_Id` int NOT NULL,
  `Task_Item_Name` varchar(45) DEFAULT NULL,
  `Task_Item_Group` int DEFAULT NULL,
  `Duration` int DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Task_Item_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_item`
--

LOCK TABLES `task_item` WRITE;
/*!40000 ALTER TABLE `task_item` DISABLE KEYS */;
INSERT INTO `task_item` VALUES (1,'Predeparture checklist',1,1,1),(2,'Predeparture event',1,1,1),(3,'Predeparture kit',1,1,1),(4,'Google review ',1,1,1),(5,'Test',1,1,1),(6,'gt44',3,1,1),(7,'testing tasks',4,3,1),(8,'t1',4,4,1),(9,'previsatestf',1,1,1),(10,'rffdrrdg123',4,0,1),(11,'task1',4,0,0),(12,'task2',4,0,0);
/*!40000 ALTER TABLE `task_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_status`
--

DROP TABLE IF EXISTS `task_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_status` (
  `Task_Status_Id` int NOT NULL,
  `Status_Name` varchar(45) DEFAULT NULL,
  `Delete_Status` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Task_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_status`
--

LOCK TABLES `task_status` WRITE;
/*!40000 ALTER TABLE `task_status` DISABLE KEYS */;
INSERT INTO `task_status` VALUES (1,'Pending',0),(2,'Completed',0);
/*!40000 ALTER TABLE `task_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temptable`
--

DROP TABLE IF EXISTS `temptable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temptable` (
  `tempid` int NOT NULL,
  `tempdata` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`tempid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temptable`
--

LOCK TABLES `temptable` WRITE;
/*!40000 ALTER TABLE `temptable` DISABLE KEYS */;
/*!40000 ALTER TABLE `temptable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_history`
--

DROP TABLE IF EXISTS `transaction_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_history` (
  `Transaction_Id` int NOT NULL AUTO_INCREMENT,
  `Entry_date` datetime(6) DEFAULT NULL,
  `User_Id` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Description1` varchar(1000) DEFAULT NULL,
  `Description2` varchar(1000) DEFAULT NULL,
  `Description3` varchar(1000) DEFAULT NULL,
  `Transaction_type` int DEFAULT NULL,
  PRIMARY KEY (`Transaction_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_history`
--

LOCK TABLES `transaction_history` WRITE;
/*!40000 ALTER TABLE `transaction_history` DISABLE KEYS */;
INSERT INTO `transaction_history` VALUES (1,'2023-03-20 00:00:00.000000',83,5,'','','',0);
/*!40000 ALTER TABLE `transaction_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_type`
--

DROP TABLE IF EXISTS `transaction_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_type` (
  `Transaction_TypeId` int NOT NULL,
  `Type_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Transaction_TypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_type`
--

LOCK TABLES `transaction_type` WRITE;
/*!40000 ALTER TABLE `transaction_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `university`
--

DROP TABLE IF EXISTS `university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `university` (
  `University_Id` bigint NOT NULL,
  `University_Name` varchar(1000) DEFAULT NULL,
  `About` varchar(500) DEFAULT NULL,
  `About1` varchar(500) DEFAULT NULL,
  `About2` varchar(500) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `Address` varchar(150) DEFAULT NULL,
  `Founded_In` varchar(50) DEFAULT NULL,
  `Institution_Type` varchar(50) DEFAULT NULL,
  `Cost_Of_Living` varchar(50) DEFAULT NULL,
  `Tution_Fee` varchar(50) DEFAULT NULL,
  `Application_Fee` varchar(50) DEFAULT NULL,
  `Type_Of_Accomodation` varchar(50) DEFAULT NULL,
  `Contact_Number` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Web` varchar(500) DEFAULT NULL,
  `Fb` varchar(500) DEFAULT NULL,
  `Linkedin` varchar(500) DEFAULT NULL,
  `Twitter` varchar(500) DEFAULT NULL,
  `Googlemap` varchar(500) DEFAULT NULL,
  `Status` int DEFAULT NULL,
  `Country_Id` int DEFAULT NULL,
  `Sub_Heading1` varchar(500) DEFAULT NULL,
  `Sub_Heading2` varchar(500) DEFAULT NULL,
  `Sub_Heading3` varchar(500) DEFAULT NULL,
  `School_Rank` varchar(50) DEFAULT NULL,
  `Video_Link` varchar(500) DEFAULT NULL,
  `Sub_Heading_Colored` varchar(500) DEFAULT NULL,
  `Banner_Image` varchar(500) DEFAULT NULL,
  `Level_Detail_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`University_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `university`
--

LOCK TABLES `university` WRITE;
/*!40000 ALTER TABLE `university` DISABLE KEYS */;
INSERT INTO `university` VALUES (3,'Seneca College','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(7,'College of Rockies, B C','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(8,'Conestoga College, Ontario','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(9,'Cambrian College','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(10,'Lakeland College, Alberta','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(11,'Lambton College, Ontrario','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(12,'St. Clair College, Ontario','','','','','','','','','','','','','','','','','','',0,0,'','','','','','','',0,0),(13,' SHEFFIELD HALLAM','','','','','','','','','','','','','','','','','','',NULL,NULL,'','','','','','','',NULL,0),(14,'UNIVERSITY OF CANADA WEST','','','','','','','','','','','','','','','','','','',NULL,NULL,'','','','','','','',NULL,0),(15,'Trebas Institute','','','','','','','','','','','','','','','','','','',NULL,NULL,'','','','','','','',NULL,0),(16,'sault college','','','','','','','','','','','','','','','','','','',NULL,NULL,'','','','','','','',NULL,0),(17,'Fanshawe College',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(18,'Griffith University',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(19,'	Regent\'s University London',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(20,'Bournemouth University',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(21,'Aston University',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(22,'Coventry University',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(23,'Regent\'s University London',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `university` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `university_photos`
--

DROP TABLE IF EXISTS `university_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `university_photos` (
  `University_Photos_Id` int NOT NULL,
  `University_Id` int DEFAULT NULL,
  `University_Image` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`University_Photos_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `university_photos`
--

LOCK TABLES `university_photos` WRITE;
/*!40000 ALTER TABLE `university_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `university_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_application_group`
--

DROP TABLE IF EXISTS `user_application_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_application_group` (
  `User_Application_Group_Id` int NOT NULL AUTO_INCREMENT,
  `User_Id` int DEFAULT NULL,
  `Application_Group_Id` int DEFAULT NULL,
  `Application_Group_Name` varchar(100) DEFAULT NULL,
  `View` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`User_Application_Group_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_application_group`
--

LOCK TABLES `user_application_group` WRITE;
/*!40000 ALTER TABLE `user_application_group` DISABLE KEYS */;
INSERT INTO `user_application_group` VALUES (37,86,9,'AG9',1,0),(39,88,10,'AG10',1,0),(42,90,2,'AG2',1,0),(43,91,3,'AG3',1,0),(44,92,9,'AG9',1,0),(45,93,11,'AG11',1,0),(46,94,10,'AG10',1,0),(47,95,1,'AG1',1,0),(48,95,2,'AG2',1,0),(49,95,3,'AG3',1,0),(50,95,4,'AG4',1,0),(51,95,5,'AG5',1,0),(52,95,6,'AG6',1,0),(53,95,7,'AG7',1,0),(54,95,8,'AG8',1,0),(55,95,9,'AG9',1,0),(56,95,10,'AG10',1,0),(57,95,11,'AG11',1,0),(58,95,12,'Student',1,0),(98,97,1,'AG1',1,0),(99,97,2,'AG2',1,0),(100,97,3,'AG3',1,0),(101,97,4,'AG4',1,0),(102,97,5,'AG5',1,0),(103,97,6,'AG6',1,0),(104,97,7,'AG7',1,0),(105,97,8,'AG8',1,0),(106,97,9,'AG9',1,0),(107,97,10,'AG10',1,0),(108,97,11,'AG11',1,0),(109,97,12,'Student',1,0),(111,84,2,'AG2',1,0),(112,85,3,'AG3',1,0),(186,87,11,'AG11',1,0),(211,103,1,'AG1',1,0),(212,89,1,'AG1',1,0),(213,89,2,'AG2',1,0),(214,89,3,'AG3',1,0),(215,89,4,'AG4',1,0),(216,89,5,'AG5',1,0),(217,89,6,'AG6',1,0),(218,89,7,'AG7',1,0),(219,89,8,'AG8',1,0),(220,89,9,'AG9',1,0),(221,89,10,'AG10',1,0),(222,89,11,'AG11',1,0),(223,89,12,'Student',1,0);
/*!40000 ALTER TABLE `user_application_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_application_status`
--

DROP TABLE IF EXISTS `user_application_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_application_status` (
  `User_Application_Status_Id` int NOT NULL AUTO_INCREMENT,
  `User_Id` int DEFAULT NULL,
  `Application_Status_Id` int DEFAULT NULL,
  `Application_Status_Name` varchar(100) DEFAULT NULL,
  `View` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`User_Application_Status_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_application_status`
--

LOCK TABLES `user_application_status` WRITE;
/*!40000 ALTER TABLE `user_application_status` DISABLE KEYS */;
INSERT INTO `user_application_status` VALUES (36,86,6,'Student Approval',1,0),(38,88,7,'visa Pending',1,0),(41,90,2,'Lodgment Pending',1,0),(42,90,3,'Lodgment',1,0),(43,91,4,'Offer Pending',1,0),(44,92,6,'Student Approval',1,0),(45,93,8,'Visa Approved',1,0),(46,94,7,'visa Pending',1,0),(47,95,1,'Application Created',1,0),(48,95,2,'Lodgment Pending',1,0),(49,95,3,'Lodgment',1,0),(50,95,4,'Offer Pending',1,0),(51,95,5,'Offer Received',1,0),(52,95,6,'Student Approval',1,0),(53,95,7,'visa Pending',1,0),(54,95,8,'Visa Approved',1,0),(55,95,9,'Visa Completed',1,0),(80,96,2,'Lodgment Pending',1,0),(90,97,1,'Application Created',1,0),(91,97,2,'Lodgment Pending',1,0),(92,97,3,'Lodgment',1,0),(93,97,4,'Offer Pending',1,0),(94,97,5,'Offer Received',1,0),(95,97,6,'Student Approval',1,0),(96,97,7,'visa Pending',1,0),(97,97,8,'Visa Approved',1,0),(98,97,9,'Visa Completed',1,0),(100,84,2,'Lodgment Pending',1,0),(101,85,3,'Lodgment',1,0),(102,85,4,'Offer Pending',1,0),(158,87,8,'Visa Approved',1,0),(177,103,1,'Application Created',1,0),(178,89,1,'Application Created',1,0),(179,89,2,'Lodgment Pending',1,0),(180,89,3,'Lodgment',1,0),(181,89,4,'Offer Pending',1,0),(182,89,5,'Offer Received',1,0),(183,89,6,'Student Approval',1,0),(184,89,7,'visa Pending',1,0),(185,89,8,'Visa Approved',1,0),(186,89,9,'Visa Completed',1,0);
/*!40000 ALTER TABLE `user_application_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_department`
--

DROP TABLE IF EXISTS `user_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_department` (
  `User_Department_Id` int NOT NULL AUTO_INCREMENT,
  `User_Id` int DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Branch_Id` int DEFAULT NULL,
  `View_Entry` tinyint DEFAULT NULL,
  `VIew_All` tinyint DEFAULT NULL,
  `Is_Delete` tinyint DEFAULT NULL,
  PRIMARY KEY (`User_Department_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=21597 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_department`
--

LOCK TABLES `user_department` WRITE;
/*!40000 ALTER TABLE `user_department` DISABLE KEYS */;
INSERT INTO `user_department` VALUES (21275,83,323,41,1,1,0),(21276,83,330,41,1,1,0),(21277,83,345,41,1,1,0),(21278,83,322,41,1,1,0),(21279,83,344,51,1,1,0),(21280,83,329,49,1,1,0),(21281,83,323,47,1,1,0),(21282,83,345,47,1,1,0),(21283,83,330,50,1,1,0),(21382,86,348,41,1,1,0),(21384,88,322,41,1,1,0),(21387,90,323,41,1,0,0),(21388,90,346,41,1,1,0),(21389,90,330,41,1,0,0),(21390,90,345,41,1,0,0),(21391,90,322,41,1,0,0),(21392,90,344,51,1,0,0),(21393,90,329,49,1,0,0),(21394,90,323,47,1,0,0),(21395,90,345,47,1,0,0),(21396,90,330,50,1,0,0),(21397,91,323,41,1,0,0),(21398,91,347,41,1,1,0),(21399,91,330,41,1,0,0),(21400,91,345,41,1,0,0),(21401,91,322,41,1,0,0),(21402,91,344,51,1,0,0),(21403,91,329,49,1,0,0),(21404,91,323,47,1,0,0),(21405,91,345,47,1,0,0),(21406,91,330,50,1,0,0),(21407,92,348,41,1,1,0),(21408,93,349,41,1,1,0),(21409,94,322,41,1,1,0),(21410,95,323,41,1,1,0),(21411,95,346,41,1,1,0),(21412,95,347,41,1,1,0),(21413,95,348,41,1,1,0),(21414,95,330,41,1,1,0),(21415,95,349,41,1,1,0),(21416,95,345,41,1,1,0),(21417,95,322,41,1,1,0),(21418,95,344,51,1,1,0),(21419,95,329,49,1,1,0),(21420,95,323,47,1,1,0),(21421,95,345,47,1,1,0),(21422,95,330,50,1,1,0),(21482,96,323,41,1,0,1),(21483,96,346,41,1,0,1),(21484,96,347,41,1,0,1),(21485,96,348,41,1,0,1),(21486,96,330,41,1,0,1),(21487,96,349,41,1,0,1),(21488,96,345,41,1,0,1),(21489,96,322,41,1,0,1),(21490,96,344,51,1,0,1),(21491,96,329,49,1,0,1),(21492,96,318,52,1,0,1),(21493,96,323,47,1,0,1),(21494,96,345,47,1,0,1),(21495,96,330,50,1,0,1),(21503,97,317,41,1,1,0),(21504,97,323,41,1,1,0),(21505,97,346,41,1,1,0),(21506,97,347,41,1,1,0),(21507,97,348,41,1,1,0),(21508,97,349,41,1,1,0),(21509,97,345,41,1,1,0),(21510,97,322,41,1,1,0),(21515,84,323,41,1,0,0),(21516,84,346,41,1,1,0),(21517,84,345,41,1,0,0),(21518,84,322,41,1,0,0),(21519,85,323,41,1,0,0),(21520,85,347,41,1,1,0),(21521,85,345,41,1,0,0),(21522,85,322,41,1,0,0),(21523,98,343,41,1,0,0),(21569,87,349,41,1,1,0),(21586,103,323,41,1,1,0),(21587,103,345,41,1,1,0),(21588,103,322,41,1,1,0),(21589,89,317,41,1,1,0),(21590,89,323,41,1,1,0),(21591,89,346,41,1,1,0),(21592,89,347,41,1,1,0),(21593,89,348,41,1,1,0),(21594,89,349,41,1,1,0),(21595,89,345,41,1,1,0),(21596,89,322,41,1,1,0);
/*!40000 ALTER TABLE `user_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_details`
--

DROP TABLE IF EXISTS `user_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_details` (
  `User_Details_Id` bigint NOT NULL AUTO_INCREMENT,
  `User_Details_Name` varchar(250) DEFAULT NULL,
  `Password` varchar(250) DEFAULT NULL,
  `Working_Status` varchar(250) DEFAULT NULL,
  `User_Type` int DEFAULT NULL,
  `Role_Id` bigint DEFAULT NULL,
  `Branch_Id` int DEFAULT NULL,
  `Address1` varchar(250) DEFAULT NULL,
  `Address2` varchar(250) DEFAULT NULL,
  `Address3` varchar(250) DEFAULT NULL,
  `Address4` varchar(250) DEFAULT NULL,
  `Pincode` varchar(200) DEFAULT NULL,
  `Mobile` varchar(250) DEFAULT NULL,
  `Email` varchar(250) DEFAULT NULL,
  `Employee_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `Registration_Target` int DEFAULT NULL,
  `FollowUp_Target` varchar(250) DEFAULT NULL,
  `User_Typename` varchar(25) DEFAULT NULL,
  `Role_String` varchar(200) DEFAULT NULL,
  `Department_String` varchar(4000) DEFAULT NULL,
  `Department_Id` int DEFAULT NULL,
  `Department_Name` varchar(100) DEFAULT NULL,
  `Sub_Slno` int DEFAULT NULL,
  `Backup_User_Id` int DEFAULT NULL,
  `Backup_User_Name` varchar(45) DEFAULT NULL,
  `Notification_Count` int DEFAULT NULL,
  `Application_View` tinyint DEFAULT NULL,
  `All_Time_Department` tinyint DEFAULT NULL,
  `Default_Application_Status_Id` int DEFAULT NULL,
  `Default_Application_Status_Name` varchar(100) DEFAULT NULL,
  `Updated_Serial_Id` int DEFAULT NULL,
  `Agent_Status` tinyint DEFAULT NULL,
  PRIMARY KEY (`User_Details_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_details`
--

LOCK TABLES `user_details` WRITE;
/*!40000 ALTER TABLE `user_details` DISABLE KEYS */;
INSERT INTO `user_details` VALUES (83,'Ashok','ashok@4568','1',2,31,38,'','','','','','1234567890','1',0,0,0,'1','Admin','31,32,33,34','and((student.Followup_Branch_Id=38 and student.To_User_Id=83 and  Followup_Department_Id in(0)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=51 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=49 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=47 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=50 and  student.Followup_Department_Id in(0)) or ( student.User_List like \'%*83*%\' and  Followup_Department_Id in (0,317,318,322,323,326,327,329,330,332,333,335,343,344,345)))',318,'Accounts',1,0,'',2,1,1,9,'Moved to application',0,0),(84,'Sreekesh','srk','1',2,31,41,'','','','','','1234567891','1234567891',0,0,NULL,'2',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=84 and  Followup_Department_Id in(0,323,346,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,346)) or ( student.User_List like \'%*84*%\' and  Followup_Department_Id in (0)))',346,'Lodgment',1,NULL,NULL,4,1,1,2,'Lodgment Pending',2,0),(85,'S.Lakshmy','s','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'18',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=85 and  Followup_Department_Id in(0,323,347,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,347)) or ( student.User_List like \'%*85*%\' and  Followup_Department_Id in (0,347)))',347,'Offer Chase',1,NULL,NULL,2,1,1,4,'Offer Pending',1,0),(86,'V.Lakshmy','v','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'32',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=86 and  Followup_Department_Id in(0,348)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,348)) or ( student.User_List like \'%*86*%\' and  Followup_Department_Id in (0,348)))',348,'Offer Clearence',1,NULL,NULL,2,1,1,6,'Student Approval',0,0),(87,'Jesna','j','1',2,32,41,'','','','','','1231231231','1231231231',0,0,NULL,'21',NULL,'32,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=87 and  Followup_Department_Id in(0,349)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,349)) or ( student.User_List like \'%*87*%\' and  Followup_Department_Id in (0,349)))',349,'Review',1,NULL,NULL,0,1,1,8,'Visa Approved',2,0),(88,'Bincy','b','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'19',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=88 and  Followup_Department_Id in(0,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,322)) or ( student.User_List like \'%*88*%\' and  Followup_Department_Id in (0,322)))',322,'Visa',1,NULL,NULL,0,1,1,7,'visa Pending',0,0),(89,'Sudheesh','su','1',1,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'21',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=89 and  Followup_Department_Id in(0,317,323,346,347,348,349,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,317,323,346,347,348,349,345,322)) or ( student.User_List like \'%*89*%\' and  Followup_Department_Id in (0,317,318,322,323,326,333,335,343,345,346,347,348,349)))',317,'Admissions',1,NULL,NULL,0,1,1,1,'Application Created',9,0),(90,'Lodgment user2','l2','1',2,31,41,'','','','','','1234567891','1234567891',0,0,NULL,'2',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=90 and  Followup_Department_Id in(0,323,346,330,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,346)) or (student.Followup_Branch_Id=51 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=49 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=47 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=50 and  student.Followup_Department_Id in(0)) or ( student.User_List like \'%*90*%\' and  Followup_Department_Id in (0)))',346,'Lodgment',2,NULL,NULL,5,1,1,2,'Lodgment Pending',0,0),(91,'Offer Chase User 2','o2','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'18',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=91 and  Followup_Department_Id in(0,323,347,330,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,347)) or (student.Followup_Branch_Id=51 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=49 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=47 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=50 and  student.Followup_Department_Id in(0)) or ( student.User_List like \'%*91*%\' and  Followup_Department_Id in (0,347)))',347,'Offer Chase',2,NULL,NULL,4,1,1,4,'Offer Pending',0,0),(92,'Offer clearance user 2','ocl2','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'32',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=92 and  Followup_Department_Id in(0,348)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,348)) or ( student.User_List like \'%*92*%\' and  Followup_Department_Id in (0,348)))',348,'Offer Clearence',2,NULL,NULL,7,1,1,6,'Student Approval',0,0),(93,'review user 2','r2','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'21',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=93 and  Followup_Department_Id in(0,349)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,349)) or ( student.User_List like \'%*93*%\' and  Followup_Department_Id in (0,349)))',349,'Review',2,NULL,NULL,2,1,1,8,'Visa Approved',0,0),(94,'visa user 2','v2','1',2,31,41,'','','','','','1231231231','1231231231',0,0,NULL,'19',NULL,'31,32,33,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=94 and  Followup_Department_Id in(0,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,322)) or ( student.User_List like \'%*94*%\' and  Followup_Department_Id in (0,322)))',322,'Visa',2,NULL,NULL,8,1,1,7,'visa Pending',0,0),(95,'councilor user 2','cu2','1',1,32,41,'','','','','','1231231231','1231231231',0,0,NULL,'21',NULL,'32,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=95 and  Followup_Department_Id in(0,323,346,347,348,330,349,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,323,346,347,348,330,349,345,322)) or (student.Followup_Branch_Id=51 and  student.Followup_Department_Id in(0,344)) or (student.Followup_Branch_Id=49 and  student.Followup_Department_Id in(0,329)) or (student.Followup_Branch_Id=47 and  student.Followup_Department_Id in(0,323,345)) or (student.Followup_Branch_Id=50 and  student.Followup_Department_Id in(0,330)) or ( student.User_List like \'%*95*%\' and  Followup_Department_Id in (0,317,318,322,323,326,327,329,330,332,333,335,343,344,345,346,347,348,349)))',317,'Admissions',2,NULL,NULL,NULL,1,1,1,'Application Created',0,0),(96,'vb','vb','1',1,32,41,'','','','','','1231231231','vb',0,1,NULL,'23',NULL,'32,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=96 and  Followup_Department_Id in(0,323,346,347,348,330,349,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=51 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=49 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=52 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=47 and  student.Followup_Department_Id in(0)) or (student.Followup_Branch_Id=50 and  student.Followup_Department_Id in(0)) or ( student.User_List like \'%*96*%\' and  Followup_Department_Id in (0)))',329,'Customer Success',0,NULL,NULL,0,1,0,2,'Lodgment Pending',0,0),(97,'test','test','1',1,32,41,'','','','','','1231231231','1231231231',0,0,NULL,'21',NULL,'32,34','and((student.Followup_Branch_Id=41 and student.To_User_Id=97 and  Followup_Department_Id in(0,317,323,346,347,348,349,345,322)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,317,323,346,347,348,349,345,322)) or ( student.User_List like \'%*97*%\' and  Followup_Department_Id in (0,317,318,322,323,326,333,335,343,345,346,347,348,349)))',317,'Admissions',3,NULL,NULL,NULL,1,1,1,'Application Created',0,0),(98,'telecaller1','1','1',2,34,41,'','','','','','1234567890','test@gmail.com',0,0,NULL,'1',NULL,'34','and((student.Followup_Branch_Id=41 and student.To_User_Id=98 and  Followup_Department_Id in(0,343)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0)) or ( student.User_List like \'%*98*%\' and  Followup_Department_Id in (0)))',343,'Tele Caller',1,NULL,NULL,NULL,0,0,0,'Select',0,0),(99,'useragent','123@uagent','',0,0,0,'sdds','','','','','8956320014','useragent123@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(100,'fdff','789','1',1,0,41,'dfddf','','','','','7845123698','dfsdfs',0,1,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(101,'sxssxx','s','1',1,0,41,'ssssaaaa','','','','','8956231478','test12sxsx3@gmail.com',0,1,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(102,'2903023test','ddd','1',1,0,41,'dedesdewr','','','','','7441525847','2903023test123@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(103,'eee','e','1',2,31,38,'','','','','','1234567890','1',0,0,0,'1',NULL,'31,32,33,34','and((student.Followup_Branch_Id=38 and student.To_User_Id=103 and  Followup_Department_Id in(0)) or (student.Followup_Branch_Id=41 and  student.Followup_Department_Id in(0,323,345,322)) or ( student.User_List like \'%*103*%\' and  Followup_Department_Id in (0,317,318,322,323,326,333,335,343,345)))',318,'Accounts',2,0,'',NULL,1,1,1,'Application Created',0,0),(104,'dfghij','1','1',1,0,41,'erer','','','','','7485962541','dfghij23@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(105,'enqddd','enq123','1',1,0,41,'ds','','','','','7845125874','enq',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(106,'test3003023','1','1',1,0,41,'nbnb','','','','','8956235874','test3003023@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(107,'vvv3003023','1','1',1,0,41,'xxx;plp[lp[','','','','','8956324171','ddd123@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1),(108,'TestAgent3003023','1','1',1,0,41,'xyxyx','','','','','9848651532','TestAgent3003023@gmail.com',0,0,0,'',NULL,NULL,NULL,0,'',0,0,'',NULL,0,0,0,'',0,1);
/*!40000 ALTER TABLE `user_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_menu_selection`
--

DROP TABLE IF EXISTS `user_menu_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_menu_selection` (
  `User_Menu_Selection_Id` int NOT NULL AUTO_INCREMENT,
  `Menu_Id` bigint DEFAULT NULL,
  `User_Id` bigint DEFAULT NULL,
  `IsEdit` tinyint unsigned DEFAULT NULL,
  `IsSave` tinyint unsigned DEFAULT NULL,
  `IsDelete` tinyint unsigned DEFAULT NULL,
  `IsView` tinyint unsigned DEFAULT NULL,
  `Menu_Status` tinyint unsigned DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`User_Menu_Selection_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=40267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_menu_selection`
--

LOCK TABLES `user_menu_selection` WRITE;
/*!40000 ALTER TABLE `user_menu_selection` DISABLE KEYS */;
INSERT INTO `user_menu_selection` VALUES (36353,5,83,1,1,1,1,0,0),(36354,8,83,1,1,1,1,0,0),(36355,22,83,1,1,1,1,0,0),(36356,23,83,1,1,1,1,0,0),(36357,31,83,1,1,1,1,0,0),(36358,69,83,1,1,1,1,0,0),(36359,60,83,1,1,1,1,0,0),(36360,63,83,1,1,1,1,0,0),(36361,64,83,1,1,1,1,0,0),(36362,65,83,1,1,1,1,0,0),(36363,49,83,1,1,1,1,0,0),(36364,9,83,1,1,1,1,0,0),(36365,21,83,1,1,1,1,0,0),(36366,32,83,1,1,1,1,0,0),(36367,52,83,1,1,1,1,0,0),(36368,51,83,1,1,1,1,0,0),(36369,59,83,1,1,1,1,0,0),(36370,50,83,1,1,1,1,0,0),(36371,67,83,1,1,1,1,0,0),(36372,19,83,1,1,1,1,0,0),(36373,58,83,1,1,1,1,0,0),(36374,17,83,1,1,1,1,0,0),(36375,35,83,1,1,1,1,0,0),(36376,53,83,1,1,1,1,0,0),(36377,28,83,1,1,1,1,0,0),(36378,38,83,1,1,1,1,0,0),(36379,16,83,1,1,1,1,0,0),(36380,14,83,1,1,1,1,0,0),(36381,15,83,1,1,1,1,0,0),(36382,54,83,1,1,1,1,0,0),(36383,1,83,1,1,1,1,0,0),(36384,1,83,1,1,1,1,0,0),(36385,29,83,1,1,1,1,0,0),(36386,20,83,1,1,1,1,0,0),(36387,18,83,1,1,1,1,0,0),(36388,66,83,1,1,1,1,0,0),(36389,2,83,1,1,1,1,0,0),(36390,7,83,1,1,1,1,0,0),(36391,3,83,1,1,1,1,0,0),(36392,70,83,1,1,1,1,0,0),(36393,55,83,1,1,1,1,0,0),(36394,56,83,1,1,1,1,0,0),(36395,27,83,1,1,1,1,0,0),(36396,37,83,1,1,1,1,0,0),(36397,62,83,1,1,1,1,0,0),(36398,72,83,1,1,1,1,0,0),(36399,73,83,1,1,1,1,0,0),(36400,74,83,1,1,1,1,0,0),(36401,75,83,1,1,1,1,0,0),(36402,76,83,1,1,1,1,0,0),(36403,77,83,1,1,1,1,0,0),(36404,78,83,1,1,1,1,0,0),(36405,79,83,1,1,1,1,0,0),(36406,80,83,1,1,1,1,0,0),(36407,81,83,1,1,1,1,0,0),(36408,82,83,1,1,1,1,0,0),(36409,83,83,1,1,1,1,0,0),(36410,84,83,1,1,1,1,0,0),(36411,85,83,1,1,1,1,0,0),(36412,86,83,1,1,1,1,0,0),(36413,87,83,1,1,1,1,0,0),(36414,88,83,1,1,1,1,0,0),(36415,89,83,1,1,1,1,0,0),(36416,90,83,1,1,1,1,0,0),(36417,91,83,1,1,1,1,0,0),(36418,92,83,1,1,1,1,0,0),(36419,93,83,1,1,1,1,0,0),(36420,94,83,1,1,1,1,0,0),(36421,95,83,1,1,1,1,0,0),(36422,96,83,1,1,1,1,0,0),(36423,97,83,1,1,1,1,0,0),(36424,98,83,1,1,1,1,0,0),(36425,99,83,1,1,1,1,0,0),(36426,100,83,1,1,1,1,0,0),(36427,101,83,1,1,1,1,0,0),(36428,102,83,1,1,1,1,0,0),(36429,103,83,1,1,1,1,0,0),(36430,104,83,1,1,1,1,0,0),(36431,105,83,1,1,1,1,0,0),(36432,106,83,1,1,1,1,0,0),(36433,107,83,1,1,1,1,0,0),(36434,108,83,1,1,1,1,0,0),(36435,109,83,1,1,1,1,0,0),(36436,110,83,1,1,1,0,0,0),(37516,5,86,1,1,1,1,0,0),(37517,8,86,1,1,1,1,0,0),(37518,22,86,1,1,1,1,0,0),(37519,23,86,1,1,1,1,0,0),(37520,31,86,1,1,1,1,0,0),(37521,69,86,1,1,1,1,0,0),(37522,60,86,1,1,1,1,0,0),(37523,63,86,1,1,1,1,0,0),(37524,64,86,1,1,1,1,0,0),(37525,65,86,1,1,1,1,0,0),(37526,49,86,1,1,1,1,0,0),(37527,9,86,1,1,1,1,0,0),(37528,21,86,1,1,1,1,0,0),(37529,32,86,1,1,1,1,0,0),(37530,52,86,1,1,1,1,0,0),(37531,51,86,1,1,1,1,0,0),(37532,59,86,1,1,1,1,0,0),(37533,50,86,1,1,1,1,0,0),(37534,67,86,1,1,1,1,0,0),(37535,19,86,1,1,1,1,0,0),(37536,58,86,1,1,1,1,0,0),(37537,17,86,1,1,1,1,0,0),(37538,35,86,1,1,1,1,0,0),(37539,53,86,1,1,1,1,0,0),(37540,28,86,1,1,1,1,0,0),(37541,38,86,1,1,1,1,0,0),(37542,16,86,1,1,1,1,0,0),(37543,14,86,1,1,1,1,0,0),(37544,15,86,1,1,1,1,0,0),(37545,54,86,1,1,1,1,0,0),(37546,1,86,1,1,1,1,0,0),(37547,29,86,1,1,1,1,0,0),(37548,20,86,1,1,1,1,0,0),(37549,18,86,1,1,1,1,0,0),(37550,66,86,1,1,1,1,0,0),(37551,2,86,1,1,1,1,0,0),(37552,7,86,1,1,1,1,0,0),(37553,3,86,1,1,1,1,0,0),(37554,70,86,1,1,1,1,0,0),(37555,55,86,1,1,1,1,0,0),(37556,56,86,1,1,1,1,0,0),(37557,27,86,1,1,1,1,0,0),(37558,37,86,1,1,1,1,0,0),(37559,62,86,1,1,1,1,0,0),(37560,72,86,1,1,1,1,0,0),(37561,73,86,1,1,1,1,0,0),(37562,74,86,1,1,1,1,0,0),(37563,75,86,1,1,1,1,0,0),(37564,76,86,1,1,1,1,0,0),(37565,77,86,1,1,1,1,0,0),(37566,78,86,1,1,1,1,0,0),(37567,79,86,1,1,1,1,0,0),(37568,80,86,1,1,1,1,0,0),(37569,81,86,1,1,1,1,0,0),(37570,82,86,1,1,1,1,0,0),(37571,83,86,1,1,1,1,0,0),(37572,84,86,1,1,1,1,0,0),(37573,85,86,1,1,1,1,0,0),(37574,86,86,1,1,1,1,0,0),(37575,87,86,1,1,1,1,0,0),(37576,88,86,1,1,1,1,0,0),(37577,89,86,1,1,1,1,0,0),(37578,90,86,1,1,1,1,0,0),(37579,91,86,1,1,1,1,0,0),(37580,92,86,1,1,1,1,0,0),(37581,93,86,1,1,1,1,0,0),(37582,94,86,1,1,1,1,0,0),(37583,95,86,1,1,1,1,0,0),(37584,96,86,1,1,1,1,0,0),(37585,97,86,1,1,1,1,0,0),(37586,98,86,1,1,1,1,0,0),(37587,99,86,1,1,1,1,0,0),(37588,100,86,1,1,1,1,0,0),(37589,101,86,1,1,1,1,0,0),(37590,102,86,1,1,1,1,0,0),(37591,103,86,1,1,1,1,0,0),(37592,104,86,1,1,1,1,0,0),(37593,105,86,1,1,1,1,0,0),(37594,106,86,1,1,1,0,0,0),(37595,107,86,1,1,1,1,0,0),(37596,108,86,1,1,1,1,0,0),(37597,109,86,1,1,1,1,0,0),(37598,110,86,1,1,1,1,0,0),(37682,5,88,1,1,1,1,0,0),(37683,8,88,1,1,1,1,0,0),(37684,22,88,1,1,1,1,0,0),(37685,23,88,1,1,1,1,0,0),(37686,31,88,1,1,1,1,0,0),(37687,69,88,1,1,1,1,0,0),(37688,60,88,1,1,1,1,0,0),(37689,63,88,1,1,1,1,0,0),(37690,64,88,1,1,1,1,0,0),(37691,65,88,1,1,1,1,0,0),(37692,49,88,1,1,1,1,0,0),(37693,9,88,1,1,1,1,0,0),(37694,21,88,1,1,1,1,0,0),(37695,32,88,1,1,1,1,0,0),(37696,52,88,1,1,1,1,0,0),(37697,51,88,1,1,1,1,0,0),(37698,59,88,1,1,1,1,0,0),(37699,50,88,1,1,1,1,0,0),(37700,67,88,1,1,1,1,0,0),(37701,19,88,1,1,1,1,0,0),(37702,58,88,1,1,1,1,0,0),(37703,17,88,1,1,1,1,0,0),(37704,35,88,1,1,1,1,0,0),(37705,53,88,1,1,1,1,0,0),(37706,28,88,1,1,1,1,0,0),(37707,38,88,1,1,1,1,0,0),(37708,16,88,1,1,1,1,0,0),(37709,14,88,1,1,1,1,0,0),(37710,15,88,1,1,1,1,0,0),(37711,54,88,1,1,1,1,0,0),(37712,1,88,1,1,1,1,0,0),(37713,29,88,1,1,1,1,0,0),(37714,20,88,1,1,1,1,0,0),(37715,18,88,1,1,1,1,0,0),(37716,66,88,1,1,1,1,0,0),(37717,2,88,1,1,1,1,0,0),(37718,7,88,1,1,1,1,0,0),(37719,3,88,1,1,1,1,0,0),(37720,70,88,1,1,1,1,0,0),(37721,55,88,1,1,1,1,0,0),(37722,56,88,1,1,1,1,0,0),(37723,27,88,1,1,1,1,0,0),(37724,37,88,1,1,1,1,0,0),(37725,62,88,1,1,1,1,0,0),(37726,72,88,1,1,1,1,0,0),(37727,73,88,1,1,1,1,0,0),(37728,74,88,1,1,1,1,0,0),(37729,75,88,1,1,1,1,0,0),(37730,76,88,1,1,1,1,0,0),(37731,77,88,1,1,1,1,0,0),(37732,78,88,1,1,1,1,0,0),(37733,79,88,1,1,1,1,0,0),(37734,80,88,1,1,1,1,0,0),(37735,81,88,1,1,1,1,0,0),(37736,82,88,1,1,1,1,0,0),(37737,83,88,1,1,1,1,0,0),(37738,84,88,1,1,1,1,0,0),(37739,85,88,1,1,1,1,0,0),(37740,86,88,1,1,1,1,0,0),(37741,87,88,1,1,1,1,0,0),(37742,88,88,1,1,1,1,0,0),(37743,89,88,1,1,1,1,0,0),(37744,90,88,1,1,1,1,0,0),(37745,91,88,1,1,1,1,0,0),(37746,92,88,1,1,1,1,0,0),(37747,93,88,1,1,1,1,0,0),(37748,94,88,1,1,1,1,0,0),(37749,95,88,1,1,1,1,0,0),(37750,96,88,1,1,1,1,0,0),(37751,97,88,1,1,1,1,0,0),(37752,98,88,1,1,1,1,0,0),(37753,99,88,1,1,1,1,0,0),(37754,100,88,1,1,1,1,0,0),(37755,101,88,1,1,1,1,0,0),(37756,102,88,1,1,1,1,0,0),(37757,103,88,1,1,1,1,0,0),(37758,104,88,1,1,1,1,0,0),(37759,105,88,1,1,1,1,0,0),(37760,106,88,1,1,1,0,0,0),(37761,107,88,1,1,1,1,0,0),(37762,108,88,1,1,1,1,0,0),(37763,109,88,1,1,1,1,0,0),(37764,110,88,1,1,1,1,0,0),(37931,5,90,1,1,1,1,0,0),(37932,8,90,1,1,1,1,0,0),(37933,22,90,1,1,1,1,0,0),(37934,23,90,1,1,1,1,0,0),(37935,31,90,1,1,1,1,0,0),(37936,69,90,1,1,1,1,0,0),(37937,60,90,1,1,1,1,0,0),(37938,63,90,1,1,1,1,0,0),(37939,64,90,1,1,1,1,0,0),(37940,65,90,1,1,1,1,0,0),(37941,49,90,1,1,1,1,0,0),(37942,9,90,1,1,1,1,0,0),(37943,21,90,1,1,1,1,0,0),(37944,32,90,1,1,1,1,0,0),(37945,52,90,1,1,1,1,0,0),(37946,51,90,1,1,1,1,0,0),(37947,59,90,1,1,1,1,0,0),(37948,50,90,1,1,1,1,0,0),(37949,67,90,1,1,1,1,0,0),(37950,19,90,1,1,1,1,0,0),(37951,58,90,1,1,1,1,0,0),(37952,17,90,1,1,1,1,0,0),(37953,35,90,1,1,1,1,0,0),(37954,53,90,1,1,1,1,0,0),(37955,28,90,1,1,1,1,0,0),(37956,38,90,1,1,1,1,0,0),(37957,16,90,1,1,1,1,0,0),(37958,14,90,1,1,1,1,0,0),(37959,15,90,1,1,1,1,0,0),(37960,54,90,1,1,1,1,0,0),(37961,1,90,1,1,1,1,0,0),(37962,29,90,1,1,1,1,0,0),(37963,20,90,1,1,1,1,0,0),(37964,18,90,1,1,1,1,0,0),(37965,66,90,1,1,1,1,0,0),(37966,2,90,1,1,1,1,0,0),(37967,7,90,1,1,1,1,0,0),(37968,3,90,1,1,1,1,0,0),(37969,70,90,1,1,1,1,0,0),(37970,55,90,1,1,1,1,0,0),(37971,56,90,1,1,1,1,0,0),(37972,27,90,1,1,1,1,0,0),(37973,37,90,1,1,1,1,0,0),(37974,62,90,1,1,1,1,0,0),(37975,72,90,1,1,1,1,0,0),(37976,73,90,1,1,1,1,0,0),(37977,74,90,1,1,1,1,0,0),(37978,75,90,1,1,1,1,0,0),(37979,76,90,1,1,1,1,0,0),(37980,77,90,1,1,1,1,0,0),(37981,78,90,1,1,1,1,0,0),(37982,79,90,1,1,1,1,0,0),(37983,80,90,1,1,1,1,0,0),(37984,81,90,1,1,1,1,0,0),(37985,82,90,1,1,1,1,0,0),(37986,83,90,1,1,1,1,0,0),(37987,84,90,1,1,1,1,0,0),(37988,85,90,1,1,1,1,0,0),(37989,86,90,1,1,1,1,0,0),(37990,87,90,1,1,1,1,0,0),(37991,88,90,1,1,1,1,0,0),(37992,89,90,1,1,1,1,0,0),(37993,90,90,1,1,1,1,0,0),(37994,91,90,1,1,1,1,0,0),(37995,92,90,1,1,1,1,0,0),(37996,93,90,1,1,1,1,0,0),(37997,94,90,1,1,1,1,0,0),(37998,95,90,1,1,1,1,0,0),(37999,96,90,1,1,1,1,0,0),(38000,97,90,1,1,1,1,0,0),(38001,98,90,1,1,1,1,0,0),(38002,99,90,1,1,1,1,0,0),(38003,100,90,1,1,1,1,0,0),(38004,101,90,1,1,1,1,0,0),(38005,102,90,1,1,1,1,0,0),(38006,103,90,1,1,1,1,0,0),(38007,104,90,1,1,1,1,0,0),(38008,105,90,1,1,1,1,0,0),(38009,106,90,1,1,1,0,0,0),(38010,107,90,1,1,1,1,0,0),(38011,108,90,1,1,1,0,0,0),(38012,109,90,1,1,1,1,0,0),(38013,110,90,1,1,1,1,0,0),(38014,5,91,1,1,1,1,0,0),(38015,8,91,1,1,1,1,0,0),(38016,22,91,1,1,1,1,0,0),(38017,23,91,1,1,1,1,0,0),(38018,31,91,1,1,1,1,0,0),(38019,69,91,1,1,1,1,0,0),(38020,60,91,1,1,1,1,0,0),(38021,63,91,1,1,1,1,0,0),(38022,64,91,1,1,1,1,0,0),(38023,65,91,1,1,1,1,0,0),(38024,49,91,1,1,1,1,0,0),(38025,9,91,1,1,1,1,0,0),(38026,21,91,1,1,1,1,0,0),(38027,32,91,1,1,1,1,0,0),(38028,52,91,1,1,1,1,0,0),(38029,51,91,1,1,1,1,0,0),(38030,59,91,1,1,1,1,0,0),(38031,50,91,1,1,1,1,0,0),(38032,67,91,1,1,1,1,0,0),(38033,19,91,1,1,1,1,0,0),(38034,58,91,1,1,1,1,0,0),(38035,17,91,1,1,1,1,0,0),(38036,35,91,1,1,1,1,0,0),(38037,53,91,1,1,1,1,0,0),(38038,28,91,1,1,1,1,0,0),(38039,38,91,1,1,1,1,0,0),(38040,16,91,1,1,1,1,0,0),(38041,14,91,1,1,1,1,0,0),(38042,15,91,1,1,1,1,0,0),(38043,54,91,1,1,1,1,0,0),(38044,1,91,1,1,1,1,0,0),(38045,29,91,1,1,1,1,0,0),(38046,20,91,1,1,1,1,0,0),(38047,18,91,1,1,1,1,0,0),(38048,66,91,1,1,1,1,0,0),(38049,2,91,1,1,1,1,0,0),(38050,7,91,1,1,1,1,0,0),(38051,3,91,1,1,1,1,0,0),(38052,70,91,1,1,1,1,0,0),(38053,55,91,1,1,1,1,0,0),(38054,56,91,1,1,1,1,0,0),(38055,27,91,1,1,1,1,0,0),(38056,37,91,1,1,1,1,0,0),(38057,62,91,1,1,1,1,0,0),(38058,72,91,1,1,1,1,0,0),(38059,73,91,1,1,1,1,0,0),(38060,74,91,1,1,1,1,0,0),(38061,75,91,1,1,1,1,0,0),(38062,76,91,1,1,1,1,0,0),(38063,77,91,1,1,1,1,0,0),(38064,78,91,1,1,1,1,0,0),(38065,79,91,1,1,1,1,0,0),(38066,80,91,1,1,1,1,0,0),(38067,81,91,1,1,1,1,0,0),(38068,82,91,1,1,1,1,0,0),(38069,83,91,1,1,1,1,0,0),(38070,84,91,1,1,1,1,0,0),(38071,85,91,1,1,1,1,0,0),(38072,86,91,1,1,1,1,0,0),(38073,87,91,1,1,1,1,0,0),(38074,88,91,1,1,1,1,0,0),(38075,89,91,1,1,1,1,0,0),(38076,90,91,1,1,1,1,0,0),(38077,91,91,1,1,1,1,0,0),(38078,92,91,1,1,1,1,0,0),(38079,93,91,1,1,1,1,0,0),(38080,94,91,1,1,1,1,0,0),(38081,95,91,1,1,1,1,0,0),(38082,96,91,1,1,1,1,0,0),(38083,97,91,1,1,1,1,0,0),(38084,98,91,1,1,1,1,0,0),(38085,99,91,1,1,1,1,0,0),(38086,100,91,1,1,1,1,0,0),(38087,101,91,1,1,1,1,0,0),(38088,102,91,1,1,1,1,0,0),(38089,103,91,1,1,1,1,0,0),(38090,104,91,1,1,1,1,0,0),(38091,105,91,1,1,1,1,0,0),(38092,106,91,1,1,1,0,0,0),(38093,107,91,1,1,1,1,0,0),(38094,108,91,1,1,1,1,0,0),(38095,109,91,1,1,1,1,0,0),(38096,110,91,1,1,1,1,0,0),(38097,5,92,1,1,1,1,0,0),(38098,8,92,1,1,1,1,0,0),(38099,22,92,1,1,1,1,0,0),(38100,23,92,1,1,1,1,0,0),(38101,31,92,1,1,1,1,0,0),(38102,69,92,1,1,1,1,0,0),(38103,60,92,1,1,1,1,0,0),(38104,63,92,1,1,1,1,0,0),(38105,64,92,1,1,1,1,0,0),(38106,65,92,1,1,1,1,0,0),(38107,49,92,1,1,1,1,0,0),(38108,9,92,1,1,1,1,0,0),(38109,21,92,1,1,1,1,0,0),(38110,32,92,1,1,1,1,0,0),(38111,52,92,1,1,1,1,0,0),(38112,51,92,1,1,1,1,0,0),(38113,59,92,1,1,1,1,0,0),(38114,50,92,1,1,1,1,0,0),(38115,67,92,1,1,1,1,0,0),(38116,19,92,1,1,1,1,0,0),(38117,58,92,1,1,1,1,0,0),(38118,17,92,1,1,1,1,0,0),(38119,35,92,1,1,1,1,0,0),(38120,53,92,1,1,1,1,0,0),(38121,28,92,1,1,1,1,0,0),(38122,38,92,1,1,1,1,0,0),(38123,16,92,1,1,1,1,0,0),(38124,14,92,1,1,1,1,0,0),(38125,15,92,1,1,1,1,0,0),(38126,54,92,1,1,1,1,0,0),(38127,1,92,1,1,1,1,0,0),(38128,29,92,1,1,1,1,0,0),(38129,20,92,1,1,1,1,0,0),(38130,18,92,1,1,1,1,0,0),(38131,66,92,1,1,1,1,0,0),(38132,2,92,1,1,1,1,0,0),(38133,7,92,1,1,1,1,0,0),(38134,3,92,1,1,1,1,0,0),(38135,70,92,1,1,1,1,0,0),(38136,55,92,1,1,1,1,0,0),(38137,56,92,1,1,1,1,0,0),(38138,27,92,1,1,1,1,0,0),(38139,37,92,1,1,1,1,0,0),(38140,62,92,1,1,1,1,0,0),(38141,72,92,1,1,1,1,0,0),(38142,73,92,1,1,1,1,0,0),(38143,74,92,1,1,1,1,0,0),(38144,75,92,1,1,1,1,0,0),(38145,76,92,1,1,1,1,0,0),(38146,77,92,1,1,1,1,0,0),(38147,78,92,1,1,1,1,0,0),(38148,79,92,1,1,1,1,0,0),(38149,80,92,1,1,1,1,0,0),(38150,81,92,1,1,1,1,0,0),(38151,82,92,1,1,1,1,0,0),(38152,83,92,1,1,1,1,0,0),(38153,84,92,1,1,1,1,0,0),(38154,85,92,1,1,1,1,0,0),(38155,86,92,1,1,1,1,0,0),(38156,87,92,1,1,1,1,0,0),(38157,88,92,1,1,1,1,0,0),(38158,89,92,1,1,1,1,0,0),(38159,90,92,1,1,1,1,0,0),(38160,91,92,1,1,1,1,0,0),(38161,92,92,1,1,1,1,0,0),(38162,93,92,1,1,1,1,0,0),(38163,94,92,1,1,1,1,0,0),(38164,95,92,1,1,1,1,0,0),(38165,96,92,1,1,1,1,0,0),(38166,97,92,1,1,1,1,0,0),(38167,98,92,1,1,1,1,0,0),(38168,99,92,1,1,1,1,0,0),(38169,100,92,1,1,1,1,0,0),(38170,101,92,1,1,1,1,0,0),(38171,102,92,1,1,1,1,0,0),(38172,103,92,1,1,1,1,0,0),(38173,104,92,1,1,1,1,0,0),(38174,105,92,1,1,1,1,0,0),(38175,106,92,1,1,1,0,0,0),(38176,107,92,1,1,1,1,0,0),(38177,108,92,1,1,1,1,0,0),(38178,109,92,1,1,1,1,0,0),(38179,110,92,1,1,1,1,0,0),(38180,5,93,1,1,1,1,0,0),(38181,8,93,1,1,1,1,0,0),(38182,22,93,1,1,1,1,0,0),(38183,23,93,1,1,1,1,0,0),(38184,31,93,1,1,1,1,0,0),(38185,69,93,1,1,1,1,0,0),(38186,60,93,1,1,1,1,0,0),(38187,63,93,1,1,1,1,0,0),(38188,64,93,1,1,1,1,0,0),(38189,65,93,1,1,1,1,0,0),(38190,49,93,1,1,1,1,0,0),(38191,9,93,1,1,1,1,0,0),(38192,21,93,1,1,1,1,0,0),(38193,32,93,1,1,1,1,0,0),(38194,52,93,1,1,1,1,0,0),(38195,51,93,1,1,1,1,0,0),(38196,59,93,1,1,1,1,0,0),(38197,50,93,1,1,1,1,0,0),(38198,67,93,1,1,1,1,0,0),(38199,19,93,1,1,1,1,0,0),(38200,58,93,1,1,1,1,0,0),(38201,17,93,1,1,1,1,0,0),(38202,35,93,1,1,1,1,0,0),(38203,53,93,1,1,1,1,0,0),(38204,28,93,1,1,1,1,0,0),(38205,38,93,1,1,1,1,0,0),(38206,16,93,1,1,1,1,0,0),(38207,14,93,1,1,1,1,0,0),(38208,15,93,1,1,1,1,0,0),(38209,54,93,1,1,1,1,0,0),(38210,1,93,1,1,1,1,0,0),(38211,29,93,1,1,1,1,0,0),(38212,20,93,1,1,1,1,0,0),(38213,18,93,1,1,1,1,0,0),(38214,66,93,1,1,1,1,0,0),(38215,2,93,1,1,1,1,0,0),(38216,7,93,1,1,1,1,0,0),(38217,3,93,1,1,1,1,0,0),(38218,70,93,1,1,1,1,0,0),(38219,55,93,1,1,1,1,0,0),(38220,56,93,1,1,1,1,0,0),(38221,27,93,1,1,1,1,0,0),(38222,37,93,1,1,1,1,0,0),(38223,62,93,1,1,1,1,0,0),(38224,72,93,1,1,1,1,0,0),(38225,73,93,1,1,1,1,0,0),(38226,74,93,1,1,1,1,0,0),(38227,75,93,1,1,1,1,0,0),(38228,76,93,1,1,1,1,0,0),(38229,77,93,1,1,1,1,0,0),(38230,78,93,1,1,1,1,0,0),(38231,79,93,1,1,1,1,0,0),(38232,80,93,1,1,1,1,0,0),(38233,81,93,1,1,1,1,0,0),(38234,82,93,1,1,1,1,0,0),(38235,83,93,1,1,1,1,0,0),(38236,84,93,1,1,1,1,0,0),(38237,85,93,1,1,1,1,0,0),(38238,86,93,1,1,1,1,0,0),(38239,87,93,1,1,1,1,0,0),(38240,88,93,1,1,1,1,0,0),(38241,89,93,1,1,1,1,0,0),(38242,90,93,1,1,1,1,0,0),(38243,91,93,1,1,1,1,0,0),(38244,92,93,1,1,1,1,0,0),(38245,93,93,1,1,1,1,0,0),(38246,94,93,1,1,1,1,0,0),(38247,95,93,1,1,1,1,0,0),(38248,96,93,1,1,1,1,0,0),(38249,97,93,1,1,1,1,0,0),(38250,98,93,1,1,1,1,0,0),(38251,99,93,1,1,1,1,0,0),(38252,100,93,1,1,1,1,0,0),(38253,101,93,1,1,1,1,0,0),(38254,102,93,1,1,1,1,0,0),(38255,103,93,1,1,1,1,0,0),(38256,104,93,1,1,1,1,0,0),(38257,105,93,1,1,1,1,0,0),(38258,106,93,1,1,1,0,0,0),(38259,107,93,1,1,1,1,0,0),(38260,108,93,1,1,1,1,0,0),(38261,109,93,1,1,1,1,0,0),(38262,110,93,1,1,1,1,0,0),(38263,5,94,1,1,1,1,0,0),(38264,8,94,1,1,1,1,0,0),(38265,22,94,1,1,1,1,0,0),(38266,23,94,1,1,1,1,0,0),(38267,31,94,1,1,1,1,0,0),(38268,69,94,1,1,1,1,0,0),(38269,60,94,1,1,1,1,0,0),(38270,63,94,1,1,1,1,0,0),(38271,64,94,1,1,1,1,0,0),(38272,65,94,1,1,1,1,0,0),(38273,49,94,1,1,1,1,0,0),(38274,9,94,1,1,1,1,0,0),(38275,21,94,1,1,1,1,0,0),(38276,32,94,1,1,1,1,0,0),(38277,52,94,1,1,1,1,0,0),(38278,51,94,1,1,1,1,0,0),(38279,59,94,1,1,1,1,0,0),(38280,50,94,1,1,1,1,0,0),(38281,67,94,1,1,1,1,0,0),(38282,19,94,1,1,1,1,0,0),(38283,58,94,1,1,1,1,0,0),(38284,17,94,1,1,1,1,0,0),(38285,35,94,1,1,1,1,0,0),(38286,53,94,1,1,1,1,0,0),(38287,28,94,1,1,1,1,0,0),(38288,38,94,1,1,1,1,0,0),(38289,16,94,1,1,1,1,0,0),(38290,14,94,1,1,1,1,0,0),(38291,15,94,1,1,1,1,0,0),(38292,54,94,1,1,1,1,0,0),(38293,1,94,1,1,1,1,0,0),(38294,29,94,1,1,1,1,0,0),(38295,20,94,1,1,1,1,0,0),(38296,18,94,1,1,1,1,0,0),(38297,66,94,1,1,1,1,0,0),(38298,2,94,1,1,1,1,0,0),(38299,7,94,1,1,1,1,0,0),(38300,3,94,1,1,1,1,0,0),(38301,70,94,1,1,1,1,0,0),(38302,55,94,1,1,1,1,0,0),(38303,56,94,1,1,1,1,0,0),(38304,27,94,1,1,1,1,0,0),(38305,37,94,1,1,1,1,0,0),(38306,62,94,1,1,1,1,0,0),(38307,72,94,1,1,1,1,0,0),(38308,73,94,1,1,1,1,0,0),(38309,74,94,1,1,1,1,0,0),(38310,75,94,1,1,1,1,0,0),(38311,76,94,1,1,1,1,0,0),(38312,77,94,1,1,1,1,0,0),(38313,78,94,1,1,1,1,0,0),(38314,79,94,1,1,1,1,0,0),(38315,80,94,1,1,1,1,0,0),(38316,81,94,1,1,1,1,0,0),(38317,82,94,1,1,1,1,0,0),(38318,83,94,1,1,1,1,0,0),(38319,84,94,1,1,1,1,0,0),(38320,85,94,1,1,1,1,0,0),(38321,86,94,1,1,1,1,0,0),(38322,87,94,1,1,1,1,0,0),(38323,88,94,1,1,1,1,0,0),(38324,89,94,1,1,1,1,0,0),(38325,90,94,1,1,1,1,0,0),(38326,91,94,1,1,1,1,0,0),(38327,92,94,1,1,1,1,0,0),(38328,93,94,1,1,1,1,0,0),(38329,94,94,1,1,1,1,0,0),(38330,95,94,1,1,1,1,0,0),(38331,96,94,1,1,1,1,0,0),(38332,97,94,1,1,1,1,0,0),(38333,98,94,1,1,1,1,0,0),(38334,99,94,1,1,1,1,0,0),(38335,100,94,1,1,1,1,0,0),(38336,101,94,1,1,1,1,0,0),(38337,102,94,1,1,1,1,0,0),(38338,103,94,1,1,1,1,0,0),(38339,104,94,1,1,1,1,0,0),(38340,105,94,1,1,1,1,0,0),(38341,106,94,1,1,1,0,0,0),(38342,107,94,1,1,1,1,0,0),(38343,108,94,1,1,1,1,0,0),(38344,109,94,1,1,1,1,0,0),(38345,110,94,1,1,1,1,0,0),(38346,5,95,1,1,1,1,0,0),(38347,8,95,1,1,1,1,0,0),(38348,22,95,1,1,1,1,0,0),(38349,23,95,1,1,1,1,0,0),(38350,31,95,1,1,1,1,0,0),(38351,69,95,1,1,1,1,0,0),(38352,60,95,1,1,1,1,0,0),(38353,63,95,1,1,1,1,0,0),(38354,64,95,1,1,1,1,0,0),(38355,65,95,1,1,1,1,0,0),(38356,49,95,1,1,1,1,0,0),(38357,9,95,1,1,1,1,0,0),(38358,21,95,1,1,1,1,0,0),(38359,32,95,1,1,1,1,0,0),(38360,52,95,1,1,1,1,0,0),(38361,51,95,1,1,1,1,0,0),(38362,59,95,1,1,1,1,0,0),(38363,50,95,1,1,1,1,0,0),(38364,67,95,1,1,1,1,0,0),(38365,19,95,1,1,1,1,0,0),(38366,58,95,1,1,1,1,0,0),(38367,17,95,1,1,1,1,0,0),(38368,35,95,1,1,1,1,0,0),(38369,53,95,1,1,1,1,0,0),(38370,28,95,1,1,1,1,0,0),(38371,38,95,1,1,1,1,0,0),(38372,16,95,1,1,1,1,0,0),(38373,14,95,1,1,1,1,0,0),(38374,15,95,1,1,1,1,0,0),(38375,54,95,1,1,1,1,0,0),(38376,1,95,1,1,1,1,0,0),(38377,29,95,1,1,1,1,0,0),(38378,20,95,1,1,1,1,0,0),(38379,18,95,1,1,1,1,0,0),(38380,66,95,1,1,1,1,0,0),(38381,2,95,1,1,1,1,0,0),(38382,7,95,1,1,1,1,0,0),(38383,3,95,1,1,1,1,0,0),(38384,70,95,1,1,1,1,0,0),(38385,55,95,1,1,1,1,0,0),(38386,56,95,1,1,1,1,0,0),(38387,27,95,1,1,1,1,0,0),(38388,37,95,1,1,1,1,0,0),(38389,62,95,1,1,1,1,0,0),(38390,72,95,1,1,1,1,0,0),(38391,73,95,1,1,1,1,0,0),(38392,74,95,1,1,1,1,0,0),(38393,75,95,1,1,1,1,0,0),(38394,76,95,1,1,1,1,0,0),(38395,77,95,1,1,1,1,0,0),(38396,78,95,1,1,1,1,0,0),(38397,79,95,1,1,1,1,0,0),(38398,80,95,1,1,1,1,0,0),(38399,81,95,1,1,1,1,0,0),(38400,82,95,1,1,1,1,0,0),(38401,83,95,1,1,1,1,0,0),(38402,84,95,1,1,1,1,0,0),(38403,85,95,1,1,1,1,0,0),(38404,86,95,1,1,1,1,0,0),(38405,87,95,1,1,1,1,0,0),(38406,88,95,1,1,1,1,0,0),(38407,89,95,1,1,1,1,0,0),(38408,90,95,1,1,1,1,0,0),(38409,91,95,1,1,1,1,0,0),(38410,92,95,1,1,1,1,0,0),(38411,93,95,1,1,1,1,0,0),(38412,94,95,1,1,1,1,0,0),(38413,95,95,1,1,1,1,0,0),(38414,96,95,1,1,1,1,0,0),(38415,97,95,1,1,1,1,0,0),(38416,98,95,1,1,1,1,0,0),(38417,99,95,1,1,1,1,0,0),(38418,100,95,1,1,1,1,0,0),(38419,101,95,1,1,1,1,0,0),(38420,102,95,1,1,1,1,0,0),(38421,103,95,1,1,1,1,0,0),(38422,104,95,1,1,1,1,0,0),(38423,105,95,1,1,1,1,0,0),(38424,106,95,1,1,1,1,0,0),(38425,107,95,1,1,1,1,0,0),(38426,108,95,1,1,1,1,0,0),(38427,109,95,1,1,1,1,0,0),(38428,110,95,1,1,1,0,0,0),(38848,5,96,1,1,1,1,0,1),(38849,8,96,1,1,1,1,0,1),(38850,22,96,1,1,1,1,0,1),(38851,23,96,1,1,1,1,0,1),(38852,31,96,1,1,1,1,0,1),(38853,69,96,1,1,1,1,0,1),(38854,60,96,1,1,1,1,0,1),(38855,63,96,1,1,1,1,0,1),(38856,64,96,1,1,1,1,0,1),(38857,65,96,1,1,1,1,0,1),(38858,49,96,1,1,1,1,0,1),(38859,9,96,1,1,1,1,0,1),(38860,21,96,1,1,1,1,0,1),(38861,32,96,1,1,1,1,0,1),(38862,52,96,1,1,1,1,0,1),(38863,51,96,1,1,1,1,0,1),(38864,59,96,1,1,1,1,0,1),(38865,50,96,1,1,1,1,0,1),(38866,67,96,1,1,1,1,0,1),(38867,19,96,1,1,1,1,0,1),(38868,58,96,1,1,1,1,0,1),(38869,17,96,1,1,1,1,0,1),(38870,35,96,1,1,1,1,0,1),(38871,53,96,1,1,1,1,0,1),(38872,28,96,1,1,1,1,0,1),(38873,38,96,1,1,1,1,0,1),(38874,16,96,1,1,1,1,0,1),(38875,14,96,1,1,1,1,0,1),(38876,15,96,1,1,1,1,0,1),(38877,54,96,1,1,1,1,0,1),(38878,1,96,1,1,1,1,0,1),(38879,29,96,1,1,1,1,0,1),(38880,20,96,1,1,1,1,0,1),(38881,18,96,1,1,1,1,0,1),(38882,66,96,1,1,1,1,0,1),(38883,2,96,1,1,1,1,0,1),(38884,7,96,1,1,1,1,0,1),(38885,3,96,1,1,1,1,0,1),(38886,70,96,1,1,1,1,0,1),(38887,55,96,1,1,1,1,0,1),(38888,56,96,1,1,1,1,0,1),(38889,27,96,1,1,1,1,0,1),(38890,37,96,1,1,1,1,0,1),(38891,62,96,1,1,1,1,0,1),(38892,72,96,1,1,1,1,0,1),(38893,73,96,1,1,1,1,0,1),(38894,74,96,1,1,1,1,0,1),(38895,75,96,1,1,1,1,0,1),(38896,76,96,1,1,1,1,0,1),(38897,77,96,1,1,1,1,0,1),(38898,78,96,1,1,1,1,0,1),(38899,79,96,1,1,1,1,0,1),(38900,80,96,1,1,1,1,0,1),(38901,81,96,1,1,1,1,0,1),(38902,82,96,1,1,1,1,0,1),(38903,83,96,1,1,1,1,0,1),(38904,84,96,1,1,1,1,0,1),(38905,85,96,1,1,1,1,0,1),(38906,86,96,1,1,1,1,0,1),(38907,87,96,1,1,1,1,0,1),(38908,88,96,1,1,1,1,0,1),(38909,89,96,1,1,1,1,0,1),(38910,90,96,1,1,1,1,0,1),(38911,91,96,1,1,1,1,0,1),(38912,92,96,1,1,1,1,0,1),(38913,93,96,1,1,1,1,0,1),(38914,94,96,1,1,1,1,0,1),(38915,95,96,1,1,1,1,0,1),(38916,96,96,1,1,1,1,0,1),(38917,97,96,1,1,1,1,0,1),(38918,98,96,1,1,1,1,0,1),(38919,99,96,1,1,1,1,0,1),(38920,100,96,1,1,1,1,0,1),(38921,101,96,1,1,1,1,0,1),(38922,102,96,1,1,1,1,0,1),(38923,103,96,1,1,1,1,0,1),(38924,104,96,1,1,1,1,0,1),(38925,105,96,1,1,1,1,0,1),(38926,106,96,1,1,1,1,0,1),(38927,107,96,1,1,1,1,0,1),(38928,108,96,1,1,1,0,0,1),(38929,109,96,1,1,1,1,0,1),(38930,110,96,1,1,1,1,0,1),(38931,111,96,1,1,1,1,0,1),(39016,5,97,1,1,1,1,0,0),(39017,8,97,1,1,1,1,0,0),(39018,22,97,1,1,1,1,0,0),(39019,23,97,1,1,1,1,0,0),(39020,31,97,1,1,1,1,0,0),(39021,69,97,1,1,1,1,0,0),(39022,60,97,1,1,1,1,0,0),(39023,63,97,1,1,1,1,0,0),(39024,64,97,1,1,1,1,0,0),(39025,65,97,1,1,1,1,0,0),(39026,49,97,1,1,1,1,0,0),(39027,9,97,1,1,1,1,0,0),(39028,21,97,1,1,1,1,0,0),(39029,32,97,1,1,1,1,0,0),(39030,52,97,1,1,1,1,0,0),(39031,51,97,1,1,1,1,0,0),(39032,59,97,1,1,1,1,0,0),(39033,50,97,1,1,1,1,0,0),(39034,67,97,1,1,1,1,0,0),(39035,19,97,1,1,1,1,0,0),(39036,58,97,1,1,1,1,0,0),(39037,17,97,1,1,1,1,0,0),(39038,35,97,1,1,1,1,0,0),(39039,53,97,1,1,1,1,0,0),(39040,28,97,1,1,1,1,0,0),(39041,38,97,1,1,1,1,0,0),(39042,16,97,1,1,1,1,0,0),(39043,14,97,1,1,1,1,0,0),(39044,15,97,1,1,1,1,0,0),(39045,54,97,1,1,1,1,0,0),(39046,1,97,1,1,1,1,0,0),(39047,29,97,1,1,1,1,0,0),(39048,20,97,1,1,1,1,0,0),(39049,18,97,1,1,1,1,0,0),(39050,66,97,1,1,1,1,0,0),(39051,2,97,1,1,1,1,0,0),(39052,7,97,1,1,1,1,0,0),(39053,3,97,1,1,1,1,0,0),(39054,70,97,1,1,1,1,0,0),(39055,55,97,1,1,1,1,0,0),(39056,56,97,1,1,1,1,0,0),(39057,27,97,1,1,1,1,0,0),(39058,37,97,1,1,1,1,0,0),(39059,62,97,1,1,1,1,0,0),(39060,72,97,1,1,1,1,0,0),(39061,73,97,1,1,1,1,0,0),(39062,74,97,1,1,1,1,0,0),(39063,75,97,1,1,1,1,0,0),(39064,76,97,1,1,1,1,0,0),(39065,77,97,1,1,1,1,0,0),(39066,78,97,1,1,1,1,0,0),(39067,79,97,1,1,1,1,0,0),(39068,80,97,1,1,1,1,0,0),(39069,81,97,1,1,1,1,0,0),(39070,82,97,1,1,1,1,0,0),(39071,83,97,1,1,1,1,0,0),(39072,84,97,1,1,1,1,0,0),(39073,85,97,1,1,1,1,0,0),(39074,86,97,1,1,1,1,0,0),(39075,87,97,1,1,1,1,0,0),(39076,88,97,1,1,1,1,0,0),(39077,89,97,1,1,1,1,0,0),(39078,90,97,1,1,1,1,0,0),(39079,91,97,1,1,1,1,0,0),(39080,92,97,1,1,1,1,0,0),(39081,93,97,1,1,1,1,0,0),(39082,94,97,1,1,1,1,0,0),(39083,95,97,1,1,1,1,0,0),(39084,96,97,1,1,1,1,0,0),(39085,97,97,1,1,1,1,0,0),(39086,98,97,1,1,1,1,0,0),(39087,99,97,1,1,1,1,0,0),(39088,100,97,1,1,1,1,0,0),(39089,101,97,1,1,1,1,0,0),(39090,102,97,1,1,1,1,0,0),(39091,103,97,1,1,1,1,0,0),(39092,104,97,1,1,1,1,0,0),(39093,105,97,1,1,1,1,0,0),(39094,106,97,1,1,1,1,0,0),(39095,107,97,1,1,1,1,0,0),(39096,108,97,1,1,1,0,0,0),(39097,109,97,1,1,1,1,0,0),(39098,110,97,1,1,1,0,0,0),(39099,111,97,1,1,1,1,0,0),(39183,5,84,1,1,1,1,0,0),(39184,8,84,1,1,1,1,0,0),(39185,22,84,1,1,1,1,0,0),(39186,23,84,1,1,1,1,0,0),(39187,31,84,1,1,1,1,0,0),(39188,69,84,1,1,1,1,0,0),(39189,60,84,1,1,1,1,0,0),(39190,63,84,1,1,1,1,0,0),(39191,64,84,1,1,1,1,0,0),(39192,65,84,1,1,1,1,0,0),(39193,49,84,1,1,1,1,0,0),(39194,9,84,1,1,1,1,0,0),(39195,21,84,1,1,1,1,0,0),(39196,32,84,1,1,1,1,0,0),(39197,52,84,1,1,1,1,0,0),(39198,51,84,1,1,1,1,0,0),(39199,59,84,1,1,1,1,0,0),(39200,50,84,1,1,1,1,0,0),(39201,67,84,1,1,1,1,0,0),(39202,19,84,1,1,1,1,0,0),(39203,58,84,1,1,1,1,0,0),(39204,17,84,1,1,1,1,0,0),(39205,35,84,1,1,1,1,0,0),(39206,53,84,1,1,1,1,0,0),(39207,28,84,1,1,1,1,0,0),(39208,38,84,1,1,1,1,0,0),(39209,16,84,1,1,1,1,0,0),(39210,14,84,1,1,1,1,0,0),(39211,15,84,1,1,1,1,0,0),(39212,54,84,1,1,1,1,0,0),(39213,1,84,1,1,1,1,0,0),(39214,29,84,1,1,1,1,0,0),(39215,20,84,1,1,1,1,0,0),(39216,18,84,1,1,1,1,0,0),(39217,66,84,1,1,1,1,0,0),(39218,2,84,1,1,1,1,0,0),(39219,7,84,1,1,1,1,0,0),(39220,3,84,1,1,1,1,0,0),(39221,70,84,1,1,1,1,0,0),(39222,55,84,1,1,1,1,0,0),(39223,56,84,1,1,1,1,0,0),(39224,27,84,1,1,1,1,0,0),(39225,37,84,1,1,1,1,0,0),(39226,62,84,1,1,1,1,0,0),(39227,72,84,1,1,1,1,0,0),(39228,73,84,1,1,1,1,0,0),(39229,74,84,1,1,1,1,0,0),(39230,75,84,1,1,1,1,0,0),(39231,76,84,1,1,1,1,0,0),(39232,77,84,1,1,1,1,0,0),(39233,78,84,1,1,1,1,0,0),(39234,79,84,1,1,1,1,0,0),(39235,80,84,1,1,1,1,0,0),(39236,81,84,1,1,1,1,0,0),(39237,82,84,1,1,1,1,0,0),(39238,83,84,1,1,1,1,0,0),(39239,84,84,1,1,1,1,0,0),(39240,85,84,1,1,1,1,0,0),(39241,86,84,1,1,1,1,0,0),(39242,87,84,1,1,1,1,0,0),(39243,88,84,1,1,1,1,0,0),(39244,89,84,1,1,1,1,0,0),(39245,90,84,1,1,1,1,0,0),(39246,91,84,1,1,1,1,0,0),(39247,92,84,1,1,1,1,0,0),(39248,93,84,1,1,1,1,0,0),(39249,94,84,1,1,1,1,0,0),(39250,95,84,1,1,1,1,0,0),(39251,96,84,1,1,1,1,0,0),(39252,97,84,1,1,1,1,0,0),(39253,98,84,1,1,1,1,0,0),(39254,99,84,1,1,1,1,0,0),(39255,100,84,1,1,1,1,0,0),(39256,101,84,1,1,1,1,0,0),(39257,102,84,1,1,1,1,0,0),(39258,103,84,1,1,1,1,0,0),(39259,104,84,1,1,1,1,0,0),(39260,105,84,1,1,1,1,0,0),(39261,106,84,1,1,1,0,0,0),(39262,107,84,1,1,1,1,0,0),(39263,108,84,1,1,1,1,0,0),(39264,109,84,1,1,1,1,0,0),(39265,110,84,1,1,1,1,0,0),(39266,5,85,1,1,1,1,0,0),(39267,8,85,1,1,1,1,0,0),(39268,22,85,1,1,1,1,0,0),(39269,23,85,1,1,1,1,0,0),(39270,31,85,1,1,1,1,0,0),(39271,69,85,1,1,1,1,0,0),(39272,60,85,1,1,1,1,0,0),(39273,63,85,1,1,1,1,0,0),(39274,64,85,1,1,1,1,0,0),(39275,65,85,1,1,1,1,0,0),(39276,49,85,1,1,1,1,0,0),(39277,9,85,1,1,1,1,0,0),(39278,21,85,1,1,1,1,0,0),(39279,32,85,1,1,1,1,0,0),(39280,52,85,1,1,1,1,0,0),(39281,51,85,1,1,1,1,0,0),(39282,59,85,1,1,1,1,0,0),(39283,50,85,1,1,1,1,0,0),(39284,67,85,1,1,1,1,0,0),(39285,19,85,1,1,1,1,0,0),(39286,58,85,1,1,1,1,0,0),(39287,17,85,1,1,1,1,0,0),(39288,35,85,1,1,1,1,0,0),(39289,53,85,1,1,1,1,0,0),(39290,28,85,1,1,1,1,0,0),(39291,38,85,1,1,1,1,0,0),(39292,16,85,1,1,1,1,0,0),(39293,14,85,1,1,1,1,0,0),(39294,15,85,1,1,1,1,0,0),(39295,54,85,1,1,1,1,0,0),(39296,1,85,1,1,1,1,0,0),(39297,29,85,1,1,1,1,0,0),(39298,20,85,1,1,1,1,0,0),(39299,18,85,1,1,1,1,0,0),(39300,66,85,1,1,1,1,0,0),(39301,2,85,1,1,1,1,0,0),(39302,7,85,1,1,1,1,0,0),(39303,3,85,1,1,1,1,0,0),(39304,70,85,1,1,1,1,0,0),(39305,55,85,1,1,1,1,0,0),(39306,56,85,1,1,1,1,0,0),(39307,27,85,1,1,1,1,0,0),(39308,37,85,1,1,1,1,0,0),(39309,62,85,1,1,1,1,0,0),(39310,72,85,1,1,1,1,0,0),(39311,73,85,1,1,1,1,0,0),(39312,74,85,1,1,1,1,0,0),(39313,75,85,1,1,1,1,0,0),(39314,76,85,1,1,1,1,0,0),(39315,77,85,1,1,1,1,0,0),(39316,78,85,1,1,1,1,0,0),(39317,79,85,1,1,1,1,0,0),(39318,80,85,1,1,1,1,0,0),(39319,81,85,1,1,1,1,0,0),(39320,82,85,1,1,1,1,0,0),(39321,83,85,1,1,1,1,0,0),(39322,84,85,1,1,1,1,0,0),(39323,85,85,1,1,1,1,0,0),(39324,86,85,1,1,1,1,0,0),(39325,87,85,1,1,1,1,0,0),(39326,88,85,1,1,1,1,0,0),(39327,89,85,1,1,1,1,0,0),(39328,90,85,1,1,1,1,0,0),(39329,91,85,1,1,1,1,0,0),(39330,92,85,1,1,1,1,0,0),(39331,93,85,1,1,1,1,0,0),(39332,94,85,1,1,1,1,0,0),(39333,95,85,1,1,1,1,0,0),(39334,96,85,1,1,1,1,0,0),(39335,97,85,1,1,1,1,0,0),(39336,98,85,1,1,1,1,0,0),(39337,99,85,1,1,1,1,0,0),(39338,100,85,1,1,1,1,0,0),(39339,101,85,1,1,1,1,0,0),(39340,102,85,1,1,1,1,0,0),(39341,103,85,1,1,1,1,0,0),(39342,104,85,1,1,1,1,0,0),(39343,105,85,1,1,1,1,0,0),(39344,106,85,1,1,1,0,0,0),(39345,107,85,1,1,1,1,0,0),(39346,108,85,1,1,1,1,0,0),(39347,109,85,1,1,1,1,0,0),(39348,110,85,1,1,1,1,0,0),(39349,5,98,1,1,1,1,0,0),(39350,8,98,1,1,1,1,0,0),(39351,22,98,1,1,1,1,0,0),(39352,23,98,1,1,1,1,0,0),(39353,31,98,1,1,1,1,0,0),(39354,69,98,1,1,1,1,0,0),(39355,60,98,1,1,1,1,0,0),(39356,63,98,1,1,1,1,0,0),(39357,64,98,1,1,1,1,0,0),(39358,65,98,1,1,1,1,0,0),(39359,49,98,1,1,1,1,0,0),(39360,9,98,1,1,1,1,0,0),(39361,21,98,1,1,1,1,0,0),(39362,32,98,1,1,1,1,0,0),(39363,52,98,1,1,1,1,0,0),(39364,51,98,1,1,1,1,0,0),(39365,59,98,1,1,1,1,0,0),(39366,50,98,1,1,1,1,0,0),(39367,67,98,1,1,1,1,0,0),(39368,19,98,1,1,1,1,0,0),(39369,58,98,1,1,1,1,0,0),(39370,17,98,1,1,1,1,0,0),(39371,35,98,1,1,1,1,0,0),(39372,53,98,1,1,1,1,0,0),(39373,28,98,1,1,1,1,0,0),(39374,38,98,1,1,1,1,0,0),(39375,16,98,1,1,1,1,0,0),(39376,14,98,1,1,1,1,0,0),(39377,15,98,1,1,1,1,0,0),(39378,54,98,1,1,1,1,0,0),(39379,1,98,1,1,1,1,0,0),(39380,29,98,1,1,1,1,0,0),(39381,20,98,1,1,1,1,0,0),(39382,18,98,1,1,1,1,0,0),(39383,66,98,1,1,1,1,0,0),(39384,2,98,1,1,1,1,0,0),(39385,7,98,1,1,1,1,0,0),(39386,3,98,1,1,1,1,0,0),(39387,70,98,1,1,1,1,0,0),(39388,55,98,1,1,1,1,0,0),(39389,56,98,1,1,1,1,0,0),(39390,27,98,1,1,1,1,0,0),(39391,37,98,1,1,1,1,0,0),(39392,62,98,1,1,1,1,0,0),(39393,72,98,1,1,1,1,0,0),(39394,73,98,1,1,1,1,0,0),(39395,74,98,1,1,1,1,0,0),(39396,75,98,1,1,1,1,0,0),(39397,76,98,1,1,1,1,0,0),(39398,77,98,1,1,1,1,0,0),(39399,78,98,1,1,1,1,0,0),(39400,79,98,1,1,1,1,0,0),(39401,80,98,1,1,1,1,0,0),(39402,81,98,1,1,1,1,0,0),(39403,82,98,1,1,1,1,0,0),(39404,83,98,1,1,1,1,0,0),(39405,84,98,1,1,1,1,0,0),(39406,85,98,1,1,1,1,0,0),(39407,86,98,1,1,1,1,0,0),(39408,87,98,1,1,1,1,0,0),(39409,88,98,1,1,1,1,0,0),(39410,89,98,1,1,1,1,0,0),(39411,90,98,1,1,1,1,0,0),(39412,91,98,1,1,1,1,0,0),(39413,92,98,1,1,1,1,0,0),(39414,93,98,1,1,1,1,0,0),(39415,94,98,1,1,1,1,0,0),(39416,95,98,1,1,1,1,0,0),(39417,96,98,1,1,1,1,0,0),(39418,97,98,1,1,1,1,0,0),(39419,98,98,1,1,1,1,0,0),(39420,99,98,1,1,1,1,0,0),(39421,100,98,1,1,1,1,0,0),(39422,101,98,1,1,1,1,0,0),(39423,102,98,1,1,1,1,0,0),(39424,103,98,1,1,1,1,0,0),(39425,104,98,1,1,1,1,0,0),(39426,105,98,1,1,1,1,0,0),(39427,106,98,1,1,1,1,0,0),(39428,107,98,1,1,1,1,0,0),(39429,108,98,1,1,1,1,0,0),(39430,109,98,1,1,1,1,0,0),(39431,110,98,1,1,1,1,0,0),(39432,111,98,1,1,1,1,0,0),(39942,5,87,1,1,1,1,0,0),(39943,22,87,1,1,1,1,0,0),(39944,23,87,1,1,1,1,0,0),(39945,31,87,1,1,1,1,0,0),(39946,69,87,1,1,1,1,0,0),(39947,60,87,1,1,1,1,0,0),(39948,65,87,1,1,1,1,0,0),(39949,9,87,1,1,1,1,0,0),(39950,21,87,1,1,1,1,0,0),(39951,32,87,1,1,1,1,0,0),(39952,52,87,1,1,1,1,0,0),(39953,51,87,1,1,1,1,0,0),(39954,59,87,1,1,1,1,0,0),(39955,50,87,1,1,1,1,0,0),(39956,67,87,1,1,1,1,0,0),(39957,19,87,1,1,1,1,0,0),(39958,58,87,1,1,1,1,0,0),(39959,17,87,1,1,1,1,0,0),(39960,35,87,1,1,1,1,0,0),(39961,53,87,1,1,1,1,0,0),(39962,28,87,1,1,1,1,0,0),(39963,38,87,1,1,1,1,0,0),(39964,16,87,1,1,1,1,0,0),(39965,14,87,1,1,1,1,0,0),(39966,15,87,1,1,1,1,0,0),(39967,54,87,1,1,1,1,0,0),(39968,1,87,1,1,1,1,0,0),(39969,29,87,1,1,1,1,0,0),(39970,20,87,1,1,1,1,0,0),(39971,18,87,1,1,1,1,0,0),(39972,66,87,1,1,1,1,0,0),(39973,2,87,1,1,1,1,0,0),(39974,7,87,1,1,1,1,0,0),(39975,3,87,1,1,1,1,0,0),(39976,70,87,1,1,1,1,0,0),(39977,55,87,1,1,1,1,0,0),(39978,56,87,1,1,1,1,0,0),(39979,27,87,1,1,1,1,0,0),(39980,37,87,1,1,1,1,0,0),(39981,72,87,1,1,1,1,0,0),(39982,74,87,1,1,1,1,0,0),(39983,75,87,1,1,1,1,0,0),(39984,76,87,1,1,1,1,0,0),(39985,77,87,1,1,1,1,0,0),(39986,78,87,1,1,1,1,0,0),(39987,79,87,1,1,1,1,0,0),(39988,91,87,1,1,1,1,0,0),(39989,92,87,1,1,1,1,0,0),(39990,93,87,1,1,1,1,0,0),(39991,94,87,1,1,1,1,0,0),(39992,95,87,1,1,1,1,0,0),(39993,96,87,1,1,1,1,0,0),(39994,98,87,1,1,1,1,0,0),(39995,99,87,1,1,1,1,0,0),(39996,100,87,1,1,1,1,0,0),(39997,101,87,1,1,1,1,0,0),(39998,103,87,1,1,1,1,0,0),(39999,104,87,1,1,1,1,0,0),(40000,105,87,1,1,1,1,0,0),(40001,106,87,1,1,1,0,0,0),(40002,107,87,1,1,1,1,0,0),(40003,108,87,1,1,1,1,0,0),(40004,109,87,1,1,1,1,0,0),(40005,110,87,1,1,1,1,0,0),(40136,5,103,1,1,1,1,0,0),(40137,22,103,1,1,1,1,0,0),(40138,23,103,1,1,1,1,0,0),(40139,31,103,1,1,1,1,0,0),(40140,69,103,1,1,1,1,0,0),(40141,60,103,1,1,1,1,0,0),(40142,65,103,1,1,1,1,0,0),(40143,9,103,1,1,1,1,0,0),(40144,21,103,1,1,1,1,0,0),(40145,32,103,1,1,1,1,0,0),(40146,52,103,1,1,1,1,0,0),(40147,51,103,1,1,1,1,0,0),(40148,59,103,1,1,1,1,0,0),(40149,50,103,1,1,1,1,0,0),(40150,67,103,1,1,1,1,0,0),(40151,19,103,1,1,1,1,0,0),(40152,58,103,1,1,1,1,0,0),(40153,17,103,1,1,1,1,0,0),(40154,35,103,1,1,1,1,0,0),(40155,53,103,1,1,1,1,0,0),(40156,28,103,1,1,1,1,0,0),(40157,38,103,1,1,1,1,0,0),(40158,16,103,1,1,1,1,0,0),(40159,14,103,1,1,1,1,0,0),(40160,15,103,1,1,1,1,0,0),(40161,54,103,1,1,1,1,0,0),(40162,1,103,1,1,1,1,0,0),(40163,1,103,1,1,1,1,0,0),(40164,29,103,1,1,1,1,0,0),(40165,20,103,1,1,1,1,0,0),(40166,18,103,1,1,1,1,0,0),(40167,66,103,1,1,1,1,0,0),(40168,2,103,1,1,1,1,0,0),(40169,7,103,1,1,1,1,0,0),(40170,3,103,1,1,1,1,0,0),(40171,70,103,1,1,1,1,0,0),(40172,55,103,1,1,1,1,0,0),(40173,56,103,1,1,1,1,0,0),(40174,27,103,1,1,1,1,0,0),(40175,37,103,1,1,1,1,0,0),(40176,72,103,1,1,1,1,0,0),(40177,74,103,1,1,1,1,0,0),(40178,75,103,1,1,1,1,0,0),(40179,76,103,1,1,1,1,0,0),(40180,77,103,1,1,1,1,0,0),(40181,78,103,1,1,1,1,0,0),(40182,79,103,1,1,1,1,0,0),(40183,91,103,1,1,1,1,0,0),(40184,92,103,1,1,1,1,0,0),(40185,93,103,1,1,1,1,0,0),(40186,94,103,1,1,1,1,0,0),(40187,95,103,1,1,1,1,0,0),(40188,96,103,1,1,1,1,0,0),(40189,98,103,1,1,1,1,0,0),(40190,99,103,1,1,1,1,0,0),(40191,100,103,1,1,1,1,0,0),(40192,101,103,1,1,1,1,0,0),(40193,103,103,1,1,1,1,0,0),(40194,104,103,1,1,1,1,0,0),(40195,105,103,1,1,1,1,0,0),(40196,106,103,1,1,1,1,0,0),(40197,107,103,1,1,1,1,0,0),(40198,108,103,1,1,1,1,0,0),(40199,109,103,1,1,1,1,0,0),(40200,110,103,1,1,1,0,0,0),(40201,5,89,1,1,1,1,0,0),(40202,22,89,1,1,1,1,0,0),(40203,23,89,1,1,1,1,0,0),(40204,31,89,1,1,1,1,0,0),(40205,69,89,1,1,1,1,0,0),(40206,60,89,1,1,1,1,0,0),(40207,65,89,1,1,1,1,0,0),(40208,9,89,1,1,1,1,0,0),(40209,21,89,1,1,1,1,0,0),(40210,32,89,1,1,1,1,0,0),(40211,52,89,1,1,1,1,0,0),(40212,51,89,1,1,1,1,0,0),(40213,59,89,1,1,1,1,0,0),(40214,50,89,1,1,1,1,0,0),(40215,67,89,1,1,1,1,0,0),(40216,19,89,1,1,1,1,0,0),(40217,58,89,1,1,1,1,0,0),(40218,17,89,1,1,1,1,0,0),(40219,35,89,1,1,1,1,0,0),(40220,53,89,1,1,1,1,0,0),(40221,28,89,1,1,1,1,0,0),(40222,38,89,1,1,1,1,0,0),(40223,16,89,1,1,1,1,0,0),(40224,14,89,1,1,1,1,0,0),(40225,15,89,1,1,1,1,0,0),(40226,54,89,1,1,1,1,0,0),(40227,1,89,1,1,1,1,0,0),(40228,29,89,1,1,1,1,0,0),(40229,20,89,1,1,1,1,0,0),(40230,18,89,1,1,1,1,0,0),(40231,66,89,1,1,1,1,0,0),(40232,2,89,1,1,1,1,0,0),(40233,7,89,1,1,1,1,0,0),(40234,3,89,1,1,1,1,0,0),(40235,70,89,1,1,1,1,0,0),(40236,55,89,1,1,1,1,0,0),(40237,56,89,1,1,1,1,0,0),(40238,27,89,1,1,1,1,0,0),(40239,37,89,1,1,1,1,0,0),(40240,72,89,1,1,1,1,0,0),(40241,74,89,1,1,1,1,0,0),(40242,75,89,1,1,1,1,0,0),(40243,76,89,1,1,1,1,0,0),(40244,77,89,1,1,1,1,0,0),(40245,78,89,1,1,1,1,0,0),(40246,79,89,1,1,1,1,0,0),(40247,91,89,1,1,1,1,0,0),(40248,92,89,1,1,1,1,0,0),(40249,93,89,1,1,1,1,0,0),(40250,94,89,1,1,1,1,0,0),(40251,95,89,1,1,1,1,0,0),(40252,96,89,1,1,1,1,0,0),(40253,98,89,1,1,1,1,0,0),(40254,99,89,1,1,1,1,0,0),(40255,100,89,1,1,1,1,0,0),(40256,101,89,1,1,1,1,0,0),(40257,104,89,1,1,1,1,0,0),(40258,105,89,1,1,1,1,0,0),(40259,106,89,1,1,1,1,0,0),(40260,107,89,1,1,1,1,0,0),(40261,108,89,1,1,1,1,0,0),(40262,109,89,1,1,1,1,0,0),(40263,110,89,1,1,1,0,0,0),(40264,111,89,1,1,1,1,0,0),(40265,112,89,0,0,1,0,0,0),(40266,113,89,1,1,1,1,0,0);
/*!40000 ALTER TABLE `user_menu_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `User_Role_Id` int NOT NULL,
  `User_Role_Name` varchar(50) DEFAULT NULL,
  `Role_Under_Id` int DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`User_Role_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (30,'Director',30,0),(31,'Manager',30,0),(32,'Counsellor',31,0),(33,'Executive',31,0),(34,'Telecaller',32,0);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_status`
--

DROP TABLE IF EXISTS `user_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_status` (
  `User_Status_Id` int NOT NULL,
  `User_Status_Name` varchar(50) DEFAULT NULL,
  `Is_Delete` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`User_Status_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_status`
--

LOCK TABLES `user_status` WRITE;
/*!40000 ALTER TABLE `user_status` DISABLE KEYS */;
INSERT INTO `user_status` VALUES (1,'Working',0),(2,'Resigned',0),(3,'Leave',0);
/*!40000 ALTER TABLE `user_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_type`
--

DROP TABLE IF EXISTS `user_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_type` (
  `User_Type_Id` int NOT NULL,
  `User_Type_Name` varchar(50) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned NOT NULL,
  PRIMARY KEY (`User_Type_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_type`
--

LOCK TABLES `user_type` WRITE;
/*!40000 ALTER TABLE `user_type` DISABLE KEYS */;
INSERT INTO `user_type` VALUES (1,'Admin',0),(2,'User',0);
/*!40000 ALTER TABLE `user_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visa`
--

DROP TABLE IF EXISTS `visa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visa` (
  `Visa_Id` int NOT NULL,
  `Visa_Granted` tinyint unsigned DEFAULT NULL,
  `Approved_Date` datetime(6) DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Application_No` varchar(45) DEFAULT NULL,
  `Visa_Letter` tinyint unsigned DEFAULT NULL,
  `Visa_File` tinyint unsigned DEFAULT NULL,
  `Approved_Date_L` datetime(6) DEFAULT NULL,
  `Approved_Date_F` datetime(6) DEFAULT NULL,
  `Total_Fees` varchar(45) DEFAULT NULL,
  `Scholarship_Fees` varchar(45) DEFAULT NULL,
  `Balance_Fees` varchar(45) DEFAULT NULL,
  `Paid_Fees` varchar(45) DEFAULT NULL,
  `Visa_Type_Id` int DEFAULT NULL,
  `Visa_Type_Name` varchar(45) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  `Username` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Security_Question` varchar(1500) DEFAULT NULL,
  `Visa_Rejected` tinyint unsigned DEFAULT NULL,
  `Visa_Rejected_Date` datetime(6) DEFAULT NULL,
  `ATIP_Submitted` tinyint unsigned DEFAULT NULL,
  `ATIP_Submitted_Date` datetime(6) DEFAULT NULL,
  `ATIP_Received` tinyint unsigned DEFAULT NULL,
  `ATIP_Received_Date` datetime(6) DEFAULT NULL,
  `Visa_Re_Submitted` tinyint unsigned DEFAULT NULL,
  `Visa_Re_Submitted_Date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Visa_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visa`
--

LOCK TABLES `visa` WRITE;
/*!40000 ALTER TABLE `visa` DISABLE KEYS */;
INSERT INTO `visa` VALUES (1,0,'2023-03-20 00:00:00.000000',5,'10',0,0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','0','0','0','0',0,'Select','',0,'','','',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000'),(2,0,'2023-03-20 00:00:00.000000',6,'1234567890',0,0,'2023-03-20 00:00:00.000000','2023-03-20 00:00:00.000000','0','0','0','0',0,'Select','',1,'','','',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000',0,'2023-03-20 00:00:00.000000'),(3,1,'2023-03-21 00:00:00.000000',14,'123ABC',1,1,'2023-03-21 00:00:00.000000','2023-03-21 00:00:00.000000','0','0','0','0',2,'Dependent Visa','',0,'','','',1,'2023-03-21 00:00:00.000000',0,'2023-03-21 00:00:00.000000',0,'2023-03-21 00:00:00.000000',0,'2023-03-21 00:00:00.000000'),(4,1,'2023-03-22 00:00:00.000000',9,'333',1,1,'2023-03-22 00:00:00.000000','2023-03-22 00:00:00.000000','0','0','0','0',2,'Dependent Visa','eee23',0,'test user','we are focused on delivering custom software','hijjk',1,'2023-03-22 00:00:00.000000',1,'2023-03-22 00:00:00.000000',1,'2023-03-22 00:00:00.000000',1,'2023-03-22 00:00:00.000000');
/*!40000 ALTER TABLE `visa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visa_document`
--

DROP TABLE IF EXISTS `visa_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visa_document` (
  `Visa_Document_Id` int NOT NULL,
  `Visa_Id` int DEFAULT NULL,
  `Entry_Date` datetime(6) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `Visa_Document_Name` varchar(100) DEFAULT NULL,
  `Visa_Document_File_Name` varchar(100) DEFAULT NULL,
  `Visa_File_Name` varchar(100) DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Visa_Document_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visa_document`
--

LOCK TABLES `visa_document` WRITE;
/*!40000 ALTER TABLE `visa_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `visa_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visa_type`
--

DROP TABLE IF EXISTS `visa_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visa_type` (
  `Visa_Type_Id` int NOT NULL,
  `Visa_Type_Name` varchar(45) DEFAULT NULL,
  `DeleteStatus` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`Visa_Type_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visa_type`
--

LOCK TABLES `visa_type` WRITE;
/*!40000 ALTER TABLE `visa_type` DISABLE KEYS */;
INSERT INTO `visa_type` VALUES (1,'Student Visa',0),(2,'Dependent Visa',0);
/*!40000 ALTER TABLE `visa_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_experience`
--

DROP TABLE IF EXISTS `work_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_experience` (
  `Work_Experience_Id` int NOT NULL AUTO_INCREMENT,
  `Slno` int DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  `Ex_From` varchar(25) DEFAULT NULL,
  `Ex_To` varchar(25) DEFAULT NULL,
  `Years` varchar(25) DEFAULT NULL,
  `Company` varchar(1000) DEFAULT NULL,
  `Designation` varchar(1000) DEFAULT NULL,
  `Salary` varchar(45) DEFAULT NULL,
  `Salary_Mode` varchar(100) DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  PRIMARY KEY (`Work_Experience_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_experience`
--

LOCK TABLES `work_experience` WRITE;
/*!40000 ALTER TABLE `work_experience` DISABLE KEYS */;
INSERT INTO `work_experience` VALUES (1,1,9,'7','7',NULL,'11234','12345','7','7',0);
/*!40000 ALTER TABLE `work_experience` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-31  9:30:22
