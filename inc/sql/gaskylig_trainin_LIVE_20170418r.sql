-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 18, 2017 at 08:24 PM
-- Server version: 5.5.54-cll
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gaskylig_trainin`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetAgency` (`GivenID` INT) RETURNS TEXT CHARSET utf8 BEGIN
  DECLARE rv VARCHAR(1024); 
  DECLARE cm CHAR(1); 
  DECLARE ch,ul,ui INT; 
  SET ul = 3; 
  SET rv = ''; 
  SET cm = ''; 
  SET ui = 100001; 
  SET ch = GivenID; 
  SELECT min(UserID) INTO ui FROM users;
  
  GetAgency: WHILE (ch > ui) DO 
    SELECT IFNULL(ReferrerUserID,100001) INTO ch FROM (SELECT ReferrerUserID FROM users WHERE UserID = ch) A; 
    SELECT IFNULL(Level,4) INTO ul FROM (SELECT Level FROM users WHERE UserID = ch) B; 

    IF ch > ui AND ul = 3 THEN 
      SET rv = CONCAT(rv,cm,ch); SET cm = ','; 
      LEAVE GetAgency; 
    END IF; 
  END WHILE; 
  RETURN rv; 
END$$

CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetAgents` (`GivenID` INT) RETURNS TEXT CHARSET latin1 BEGIN
    DECLARE rv,q,queue,queue_children TEXT;
    DECLARE queue_length,front_id,pos INT;
    SET rv = '';
    SET queue = GivenID;
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = queue;
        IF queue_length = 1 THEN
            SET queue = '';
        ELSE
            SET pos = LOCATE(',',queue) + 1;
            SET q = SUBSTR(queue,pos);
            SET queue = q;
        END IF;
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(UserID) AS qc
        FROM `users` WHERE `ReferrerUserID` = front_id AND `Level`=4) A ;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                SET rv = queue_children;
            ELSE
                SET rv = CONCAT(rv,',',queue_children);
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    RETURN rv;
END$$

CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetAncestry` (`GivenID` INT) RETURNS VARCHAR(1024) CHARSET utf8 BEGIN
    DECLARE rv VARCHAR(1024);
    DECLARE cm CHAR(1);
    DECLARE ch,ui INT;

    SET rv = '';
    SET cm = '';
    SET ui = 100001;
    SET ch = GivenID;
    SELECT min(UserID) INTO ui FROM users;
    WHILE ch > ui DO
        SELECT IFNULL(ReferrerUserID,-1) INTO ch FROM
        (SELECT ReferrerUserID FROM users WHERE UserID = ch) A;
        IF ch > 0 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;
    RETURN rv;
END$$

CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetChildrenByID` (`GivenID` INT) RETURNS TEXT CHARSET latin1 BEGIN
    DECLARE rv,q,queue,queue_children TEXT;
    DECLARE queue_length,front_id,pos INT;
    SET rv = '';
    SET queue = GivenID;
    SET queue_length = 1;
    WHILE queue_length > 0 DO
        SET front_id = queue;
        IF queue_length = 1 THEN
            SET queue = '';
        ELSE
            SET pos = LOCATE(',',queue) + 1;
            SET q = SUBSTR(queue,pos);
            SET queue = q;
        END IF;
        SET queue_length = queue_length - 1;
        SELECT IFNULL(qc,'') INTO queue_children
        FROM (SELECT GROUP_CONCAT(UserID) AS qc
        FROM `users` WHERE `ReferrerUserID` = front_id AND `Level` IN (3,4)) A ;
        IF LENGTH(queue_children) = 0 THEN
            IF LENGTH(queue) = 0 THEN
                SET queue_length = 0;
            END IF;
        ELSE
            IF LENGTH(rv) = 0 THEN
                SET rv = queue_children;
            ELSE
                SET rv = CONCAT(rv,',',queue_children);
            END IF;
            IF LENGTH(queue) = 0 THEN
                SET queue = queue_children;
            ELSE
                SET queue = CONCAT(queue,',',queue_children);
            END IF;
            SET queue_length = LENGTH(queue) - LENGTH(REPLACE(queue,',','')) + 1;
        END IF;
    END WHILE;
    RETURN rv;
END$$

CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetParents` (`GivenID` INT) RETURNS TEXT CHARSET utf8 BEGIN
    DECLARE rv VARCHAR(1024);
    DECLARE cm CHAR(1);
    DECLARE ch,ul,ui INT;

    SET ul = 3;
    SET rv = '';
    SET cm = '';
    SET ch = GivenID;

    SET ui = 100001;     
    SELECT min(UserID) INTO ui FROM users;

    WHILE (ch > ui) DO
        SELECT IFNULL(ReferrerUserID,100001) INTO ch FROM (SELECT ReferrerUserID FROM users WHERE UserID = ch) A;
        SELECT IFNULL(Level,4) INTO ul FROM (SELECT Level FROM users WHERE UserID = ch) B;
        IF ch > ui AND ul = 3 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;
    RETURN rv;
END$$

CREATE DEFINER=`gaskylight`@`localhost` FUNCTION `GetSale` (`GivenID` INT) RETURNS TEXT CHARSET utf8 BEGIN
  DECLARE rv VARCHAR(1024); 
  DECLARE ai,sr,sl,ui INT;
  SET rv = '';
  SET ai = GivenID;
  SET ui = 0;
  SET sr = 0;
  SET sl = 0;
  
  SELECT IFNULL(DepositedAmount,0) INTO sl FROM (SELECT DepositedAmount FROM accounts WHERE AccountID = ai) A;  
  SELECT IFNULL(UserID,0) INTO ui FROM (SELECT UserID FROM accounts WHERE AccountID = ai) B;  
  SELECT IFNULL(SecondReferrerUserID,0) INTO sr FROM (SELECT SecondReferrerUserID FROM users WHERE UserID = ui) C;  
  
  IF sr = 0 THEN 
      SET rv = sl;
  ELSE 
  	  SET rv = (sl / 2);
  END IF;
  
  RETURN rv; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `AccountID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `AccessUserID` text NOT NULL,
  `AccountMetaID` int(21) NOT NULL,
  `BankAccountID` int(21) NOT NULL,
  `AccountType` varchar(128) NOT NULL,
  `AccountTitle` varchar(128) NOT NULL,
  `AccountEmail` varchar(256) NOT NULL,
  `CommissionLevel` int(11) NOT NULL DEFAULT '1',
  `Commission` varchar(32) NOT NULL DEFAULT '7',
  `CommissionTwo` varchar(32) NOT NULL DEFAULT '12',
  `CompanyName` varchar(128) NOT NULL,
  `CompanyDocument` text NOT NULL,
  `PhotoId` text NOT NULL,
  `Agreement` text NOT NULL,
  `Proofresidency` int(21) DEFAULT '0',
  `BankAccountProof` text NOT NULL,
  `RegistrationNo` varchar(64) NOT NULL,
  `RegistrationAddress` varchar(256) NOT NULL,
  `RegistrationCountry` varchar(64) NOT NULL,
  `RegistrationTelephone` varchar(32) NOT NULL,
  `BusinessAddress` varchar(256) NOT NULL,
  `BusinessCountry` varchar(128) NOT NULL,
  `ApplicationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AccountStatus` varchar(32) NOT NULL DEFAULT 'Pending',
  `ProductID` int(11) NOT NULL,
  `ProductItemID` int(11) NOT NULL,
  `PaymentReceived` date NOT NULL,
  `ReceivedAmount` float NOT NULL,
  `OpeningFee` varchar(512) NOT NULL,
  `OpeningFeePromo` varchar(512) NOT NULL,
  `ManagementFee` varchar(512) NOT NULL,
  `ManagementFeeWaiver` varchar(512) NOT NULL,
  `CashAmount` float NOT NULL,
  `CommencementDate` date NOT NULL,
  `EmailSent` datetime NOT NULL,
  `EmailSentBy` int(21) NOT NULL,
  `MaturityDate` date NOT NULL,
  `ApprovedBy` varchar(128) NOT NULL,
  `ApprovedDate` date NOT NULL,
  `DepositedAmount` float NOT NULL,
  `TransactionDate` date NOT NULL,
  `FormType` varchar(128) NOT NULL DEFAULT 'Traditional',
  `CourierStatus` varchar(215) NOT NULL,
  `Active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`AccountID`, `UserID`, `AccessUserID`, `AccountMetaID`, `BankAccountID`, `AccountType`, `AccountTitle`, `AccountEmail`, `CommissionLevel`, `Commission`, `CommissionTwo`, `CompanyName`, `CompanyDocument`, `PhotoId`, `Agreement`, `Proofresidency`, `BankAccountProof`, `RegistrationNo`, `RegistrationAddress`, `RegistrationCountry`, `RegistrationTelephone`, `BusinessAddress`, `BusinessCountry`, `ApplicationDate`, `AccountStatus`, `ProductID`, `ProductItemID`, `PaymentReceived`, `ReceivedAmount`, `OpeningFee`, `OpeningFeePromo`, `ManagementFee`, `ManagementFeeWaiver`, `CashAmount`, `CommencementDate`, `EmailSent`, `EmailSentBy`, `MaturityDate`, `ApprovedBy`, `ApprovedDate`, `DepositedAmount`, `TransactionDate`, `FormType`, `CourierStatus`, `Active`) VALUES
(10038, 100065, '100086', 10026, 46, 'Individual', '', '123@gmail.com', 1, '6', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Hong Kong', '2016-10-07 16:00:00', 'Approved', 210001, 10037, '2016-10-11', 30950, '1000', '', '2%', '', 950, '2016-10-10', '0000-00-00 00:00:00', 0, '2019-10-09', 'LAI YUN TZU', '2016-10-08', 30000, '2016-10-11', 'Simplified', '', 1),
(10048, 100078, '100086', 10036, 59, 'Corporate', '', 'opopo@gmail.com', 1, '6', '12', 'Sun Ying Enterprise Management Consulting Co.Ltd', '', '', '', 0, '', '54093933', '彰化縣和美鎮和光路250號1樓', 'Taiwan', '04-24524777', '', 'Taiwan', '2016-10-25 16:00:00', 'Approved', 210001, 10037, '2016-10-26', 21270, '', '', '', '', 1270, '2016-10-31', '0000-00-00 00:00:00', 0, '2018-10-30', 'Vicky ', '2016-10-26', 20000, '0000-00-00', 'Traditional', '', 1),
(10050, 100033, '', 0, 61, 'Individual', '', 'kid720401@gmail.com', 1, '6', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-11-22 09:54:09', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10053, 100084, '', 0, 65, 'Individual', '', 'odeon@odeonco.com', 1, '10', '12', 'Global Assets Inc. Ltd.', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-07 07:29:22', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10054, 100081, '', 0, 68, 'Individual', '', 'Hao@gmail.com', 2, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-07 07:33:10', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10055, 100001, '', 0, 0, 'Individual', '', 'trust@odeonco.com', 1, '7', '12', 'Odeon & Co', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-09 09:19:36', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10056, 100085, '', 0, 71, 'Individual', '', 'support@appextended.com', 1, '7', '12', 'AppExtended Inc', '2710', '', '', 0, '', '', '', '', '', '', '', '2016-12-09 14:01:33', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10057, 100086, '', 0, 74, 'Individual', '', 'ryanbang@banginc.com', 1, '7', '12', 'Bang Inc', '2713', '', '', 0, '', '', '', '', '', '', '', '2016-12-09 14:21:59', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10063, 100098, '', 0, 80, 'Individual', '', 'abc@abc.com', 1, '7', '12', 'Testing Corp', '3538', '', '', 0, '', '', '', '', '', '', '', '2016-12-14 04:44:12', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10064, 100099, '', 10042, 81, 'Individual', '', 'chowlyechoo@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Malaysia', '2016-12-20 05:52:02', 'Pending', 210001, 10029, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', 'Joanna Chow', '2016-12-20', 1000000, '0000-00-00', 'Traditional', '', 0),
(10065, 100105, '', 10043, 82, 'Individual', '', 'ryandumajil@gmail.com', 2, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'China', '2015-12-31 16:00:00', 'Approved', 210001, 10038, '2016-12-17', 0, '', '', '', '', 0, '2017-02-27', '2017-02-07 16:05:48', 100000, '2020-02-26', 'dfgdfg', '2017-01-23', 500000, '0000-00-00', 'Traditional', 'Waiting', 1),
(10066, 100107, '', 0, 83, 'Individual', '', 'abc@123.com', 1, '6', '12', '', '', '3732', '', 0, '', '', '', '', '', '', '', '2017-02-13 00:04:32', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10067, 100108, '', 0, 84, 'Individual', '', 'abc@qwe.com', 2, '7', '12', 'Singapore', '3735', '', '', 0, '', '', '', '', '', '', '', '2017-02-13 01:46:50', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10068, 100110, '', 0, 85, 'Individual', '', 'jeff@attrust.com', 1, '6', '12', 'Jeffro Pte Ltd', '3749', '', '', 0, '', '', '', '', '', '', '', '2017-02-21 09:32:06', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10069, 100111, '', 0, 86, 'Individual', '', 'weh@weah.com', 3, '8', '12', '', '', '3750', '', 0, '', '', '', '', '', '', '', '2017-02-21 09:42:12', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10070, 100112, '100085', 10044, 87, 'Individual', '', 'diao@diaoni.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Taiwan', '2017-02-21 16:00:00', 'Approved', 210001, 10037, '2017-02-24', 60354, '1000', '500', '2%', '1%', 0, '2017-02-27', '0000-00-00 00:00:00', 0, '2020-02-26', '', '2017-02-22', 60000, '0000-00-00', 'Traditional', '', 1),
(10071, 100113, '', 0, 88, 'Individual', '', '', 1, '7', '12', 'The Corp Agency', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:20:55', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10072, 100114, '', 0, 89, 'Individual', '', '', 3, '10', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:26:02', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10073, 100115, '', 0, 90, 'Individual', '', '', 2, '9', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:26:54', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10074, 100116, '', 0, 91, 'Individual', '', '', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:27:37', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10075, 100117, '', 0, 92, 'Individual', '', '', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:28:10', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10076, 100118, '', 0, 93, 'Individual', '', '', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-03-02 04:28:35', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10077, 100122, '', 10045, 94, 'Individual', '', 'shanying_yap@hotmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Hong Kong', '2017-03-10 04:54:22', 'Approved', 210001, 10037, '0000-00-00', 0, '', '', '', '', 0, '2017-03-20', '0000-00-00 00:00:00', 0, '2020-03-19', '', '1970-01-01', 30000, '0000-00-00', 'Traditional', '', 1),
(10078, 100123, '', 10046, 95, 'Individual', '', 'shanying_yap@hotmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Hong Kong', '2017-03-09 16:00:00', 'Approved', 210001, 10037, '0000-00-00', 0, '', '', '', '', 0, '2017-03-20', '0000-00-00 00:00:00', 0, '2020-03-19', '', '2017-03-10', 90000, '0000-00-00', 'Traditional', '', 1),
(10079, 100124, '', 10047, 96, 'Corporate', '', 'shanying_yap@hotmail.com', 1, '7', '12', 'AT Company', '', '', '', 0, '', '505-101-303879', 'Hong Kong', 'Hong Kong', '23416622', '', 'Hong Kong', '2017-03-10 05:41:08', 'Approved', 210002, 10042, '0000-00-00', 0, '', '', '', '', 0, '2017-03-20', '0000-00-00 00:00:00', 0, '2020-03-19', '', '2017-03-10', 1000000, '0000-00-00', 'Traditional', '', 1),
(10080, 100125, '', 10048, 97, 'Individual', '', 'chrischuasg@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Hong Kong', '2017-03-31 16:00:00', 'Approved', 210002, 10042, '2017-04-03', 653123, '1000', '500', '2%', '2%', 0, '2017-04-03', '2017-04-01 03:47:27', 100079, '2022-04-02', 'asdfdasf', '2017-04-01', 650000, '0000-00-00', 'Traditional', '', 1),
(10081, 100126, '', 10049, 98, 'Individual', '', 'ryandsdsdsaumajil@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'China', '2017-03-31 19:10:02', 'Pending', 210001, 10038, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '1970-01-01', 100000, '0000-00-00', 'Traditional', '', 1),
(10082, 100127, '', 10050, 99, 'Individual', '', 'hffghvx@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'Philippines', '2017-04-01 11:55:53', 'Pending', 210001, 10038, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '1970-01-01', 100000, '0000-00-00', 'Traditional', '', 1),
(10083, 100128, '', 10051, 100, 'Individual', '', 'hffghvx@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'Philippines', '2017-04-01 12:05:06', 'Approved', 210001, 10039, '2017-04-04', 102000, '1000', '1000', '2', '2', 0, '2017-04-03', '0000-00-00 00:00:00', 0, '2020-04-02', '', '1970-01-01', 100000, '0000-00-00', 'Traditional', '', 1),
(10084, 100129, '', 0, 101, 'Individual', '', '', 1, '12', '12', 'the pong kwayla', '4013', '', '', 0, '', '', '', '', '', '', '', '2017-04-03 08:47:37', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10085, 100130, '', 0, 102, 'Individual', '', '', 1, '7', '12', '', '', '4014', '', 0, '', '', '', '', '', '', '', '2017-04-03 08:50:02', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10086, 100131, '100085', 10052, 103, 'Individual', '', 'smileatchris@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', 'China', '', '', 'China', '2017-04-02 16:00:00', 'Approved', 210002, 10041, '2017-04-04', 620100, '2000', '500', '2', '0', 0, '2017-04-10', '2017-04-03 09:30:43', 100079, '2022-04-09', 'JEFF', '2017-04-03', 620000, '0000-00-00', 'Traditional', '', 1),
(10087, 100132, '', 10053, 104, 'Individual', '', 'dstrout111@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'China', '2017-04-03 13:28:00', 'Approved', 210002, 10042, '2017-04-03', 250000, '2000', '', '', '', 0, '2017-04-10', '2017-04-03 14:08:24', 100086, '2022-04-09', 'dasdasdas asdasdas', '2017-04-03', 500000, '0000-00-00', 'Traditional', '', 1),
(10088, 100133, '', 10054, 105, 'Individual', '', 'ryasdsssadsdanajsd@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'China', '2017-04-04 15:17:50', 'Approved', 210002, 10042, '0000-00-00', 0, '', '', '', '', 0, '2017-04-10', '2017-04-05 06:16:06', 100086, '2022-04-09', 'dsadas', '2017-04-04', 500000, '0000-00-00', 'Traditional', '', 1),
(10089, 100134, '', 0, 106, 'Individual', '', '', 1, '12', '12', 'da pong kwaylaaaaa', '4087', '', '', 0, '', '', '', '', '', '', '', '2017-04-06 06:52:29', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10090, 100135, '', 10055, 107, 'Individual', '', 'champagne241@gmail.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'China', '2017-04-06 07:06:02', 'Approved', 210002, 10041, '0000-00-00', 0, '', '', '', '', 0, '2017-04-10', '2017-04-07 05:17:18', 100086, '2020-04-09', 'oifdygjdsfggf', '2017-04-06', 500000, '0000-00-00', 'Traditional', 'Processing', 1);

-- --------------------------------------------------------

--
-- Table structure for table `account_beneficiaries`
--

CREATE TABLE `account_beneficiaries` (
  `BeneficiaryID` int(21) NOT NULL,
  `AccountID` int(21) NOT NULL,
  `UserID` int(15) NOT NULL,
  `ABFirstName` varchar(128) CHARACTER SET utf8 NOT NULL,
  `ABLastName` varchar(128) CHARACTER SET utf8 NOT NULL,
  `ABPhone` varchar(32) CHARACTER SET utf8 NOT NULL,
  `ABEmail` varchar(64) CHARACTER SET utf8 NOT NULL,
  `ABRelationship` varchar(64) CHARACTER SET utf32 NOT NULL,
  `ABAddress1` varchar(256) CHARACTER SET utf8 NOT NULL,
  `ABPercentage` varchar(64) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `account_beneficiaries`
--

INSERT INTO `account_beneficiaries` (`BeneficiaryID`, `AccountID`, `UserID`, `ABFirstName`, `ABLastName`, `ABPhone`, `ABEmail`, `ABRelationship`, `ABAddress1`, `ABPercentage`) VALUES
(1, 10080, 100125, '', '', '', '', '', '', ''),
(2, 10080, 100125, '', '', '', '', '', '', ''),
(3, 10081, 100126, 'sadasdasd', 'adsdasd', '23232', 'dasdasdsada@gmail.com', '摳', 'dasdas', '23'),
(4, 10081, 100126, '', '', '', '', '', '', ''),
(5, 10082, 100127, 'Fhgdgh', 'Vgyhfvn', '24566', 'Gffgf@gmail.com', 'R', '', '2'),
(6, 10082, 100127, '', '', '', '', '', '', ''),
(7, 10083, 100128, 'Fhgdgh', 'Vgyhfvn', '24566', 'Gffgf@gmail.com', 'R', '', '2'),
(8, 10083, 100128, '', '', '', '', '', '', ''),
(9, 10086, 100131, '', '', '', '', '', '', ''),
(10, 10086, 100131, '', '', '', '', '', '', ''),
(11, 10087, 100132, 'dasdasdasdad', 'sadasdas', '123123', 'asdasdaddad@gmail.com', '慳', 'dasda', '23'),
(12, 10087, 100132, 'sdadsadasdas', 'asdasdasd', '2312312', 'dsadasda@gmail.com', '', 'sadasd', '3'),
(13, 10088, 100133, 'sdadsadasd', 'asdasdas', '23232', 'asdasdasdad@gmail.com', '', 'sdasda', '19'),
(14, 10088, 100133, '', '', '', '', '', '', ''),
(15, 10090, 100135, 'qwehghdgfdg', 'dasdasdadfsdfsd', '1321321', 'asdadaasdasdad@gmail.com', 'a', 'dasdasdasda', '50'),
(16, 10090, 100135, '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `account_meta`
--

CREATE TABLE `account_meta` (
  `AccountMetaID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `HasNominatedBeneficiaries` varchar(8) NOT NULL,
  `UBOName` varchar(64) NOT NULL,
  `UBOAddress` varchar(256) NOT NULL,
  `UBOEmploymentIncome` int(21) NOT NULL,
  `UBOCommission` int(21) NOT NULL,
  `UBOBusiness` int(21) NOT NULL,
  `UBOInheritance` int(21) NOT NULL,
  `UBOGift` int(21) NOT NULL,
  `UBOSales` int(21) NOT NULL,
  `UBOOther` int(21) NOT NULL,
  `PrimaryTaxResidency` varchar(128) NOT NULL,
  `TaxIdNumber` varchar(128) NOT NULL,
  `NeedCoolingOff` varchar(16) NOT NULL,
  `BeneficiariesForm` int(21) NOT NULL,
  `IAPhotoid` int(21) NOT NULL,
  `IAProofresidency` int(21) NOT NULL,
  `IABankstatement` int(21) NOT NULL,
  `IASpecimensign` int(21) NOT NULL,
  `IAProofOfPayment` int(21) NOT NULL,
  `CACertincorporation` int(21) NOT NULL,
  `CANamechange` int(21) NOT NULL,
  `CAGoodstand` int(21) NOT NULL,
  `CARegdirector` int(21) NOT NULL,
  `CAProofbusadd` int(21) NOT NULL,
  `CAMemorandumaa` int(21) NOT NULL,
  `CARecentfinancialstatement` int(21) NOT NULL,
  `CADirectorsid` int(21) NOT NULL,
  `CACompanysign` int(21) NOT NULL,
  `CAShareholders` int(21) NOT NULL,
  `CADirectorsproof` int(21) NOT NULL,
  `CACompanysignproof` int(21) NOT NULL,
  `CAShareholdersproof` int(21) NOT NULL,
  `CAAuthorizedone` int(21) NOT NULL,
  `CAAuthorizedonename` varchar(64) NOT NULL,
  `CAAuthorizedonetitle` varchar(64) NOT NULL,
  `CAAuthorizedtwo` int(21) NOT NULL,
  `CAAuthorizedtwoname` varchar(64) NOT NULL,
  `CAAuthorizedtwotitle` varchar(64) NOT NULL,
  `CAAuthorizedthree` int(21) NOT NULL,
  `CAAuthorizedthreename` varchar(64) NOT NULL,
  `CAAuthorizedthreetitle` varchar(64) NOT NULL,
  `CAAuthorizedfour` int(21) NOT NULL,
  `CAAuthorizedfourname` varchar(64) NOT NULL,
  `CAAuthorizedfourtitle` varchar(64) NOT NULL,
  `CAProofOfPayment` int(21) NOT NULL,
  `POADate` date NOT NULL,
  `POAFirstName` varchar(128) NOT NULL,
  `POALastName` varchar(128) NOT NULL,
  `POACompanyName` varchar(256) NOT NULL,
  `POACompanyNumber` varchar(64) NOT NULL,
  `POACompanyCountry` varchar(64) NOT NULL,
  `POACompanyAddress` varchar(256) NOT NULL,
  `POACompanyCity` varchar(64) NOT NULL,
  `POACompanyState` varchar(64) NOT NULL,
  `POAAppointor` varchar(256) NOT NULL,
  `POAAppointorIdNumber` varchar(64) NOT NULL,
  `POACorporateSeal` int(21) NOT NULL,
  `POADirectorName` varchar(128) NOT NULL,
  `POADirectorSign` int(21) NOT NULL,
  `POASecretaryName` varchar(128) NOT NULL,
  `POASecretarySign` int(21) NOT NULL,
  `TelegraphicTransfer` int(21) NOT NULL,
  `SubsDecName` varchar(255) NOT NULL,
  `SubsDecSignature` int(15) NOT NULL,
  `SubsDecDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `account_meta`
--

INSERT INTO `account_meta` (`AccountMetaID`, `UserID`, `HasNominatedBeneficiaries`, `UBOName`, `UBOAddress`, `UBOEmploymentIncome`, `UBOCommission`, `UBOBusiness`, `UBOInheritance`, `UBOGift`, `UBOSales`, `UBOOther`, `PrimaryTaxResidency`, `TaxIdNumber`, `NeedCoolingOff`, `BeneficiariesForm`, `IAPhotoid`, `IAProofresidency`, `IABankstatement`, `IASpecimensign`, `IAProofOfPayment`, `CACertincorporation`, `CANamechange`, `CAGoodstand`, `CARegdirector`, `CAProofbusadd`, `CAMemorandumaa`, `CARecentfinancialstatement`, `CADirectorsid`, `CACompanysign`, `CAShareholders`, `CADirectorsproof`, `CACompanysignproof`, `CAShareholdersproof`, `CAAuthorizedone`, `CAAuthorizedonename`, `CAAuthorizedonetitle`, `CAAuthorizedtwo`, `CAAuthorizedtwoname`, `CAAuthorizedtwotitle`, `CAAuthorizedthree`, `CAAuthorizedthreename`, `CAAuthorizedthreetitle`, `CAAuthorizedfour`, `CAAuthorizedfourname`, `CAAuthorizedfourtitle`, `CAProofOfPayment`, `POADate`, `POAFirstName`, `POALastName`, `POACompanyName`, `POACompanyNumber`, `POACompanyCountry`, `POACompanyAddress`, `POACompanyCity`, `POACompanyState`, `POAAppointor`, `POAAppointorIdNumber`, `POACorporateSeal`, `POADirectorName`, `POADirectorSign`, `POASecretaryName`, `POASecretarySign`, `TelegraphicTransfer`, `SubsDecName`, `SubsDecSignature`, `SubsDecDate`) VALUES
(10026, 100065, '', 'LEE KING KI', 'FLAT 1A, 15/F, KAM LING COURT, 1-3, WOO HOP STREET, HONG KONG', 0, 0, 0, 0, 0, 0, 1588, 'HONG KONG', 'N/A', 'Y', 0, 1589, 1590, 1591, 1592, 1593, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10036, 100078, '', 'Hsieh, Tsung-Yen', '彰化縣和美鎮和光路250號1樓', 0, 0, 2315, 0, 0, 0, 0, 'Taiwan', 'Taiwan', 'Y', 0, 0, 0, 0, 0, 0, 2325, 0, 0, 2328, 0, 0, 2396, 2332, 2333, 0, 2400, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 2338, '2012-11-26', 'Tsung-Yen', 'Hsieh', 'Sun Ying Enterprise Management Consulting Co.Ltd', '54093933', 'Taiwan', '彰化縣和美鎮和光路250號1樓', '台中', '台北', 'Hsieh, Tsung-Yen', '311773455', 2311, '', 2312, '', 0, 0, '', 0, '0000-00-00'),
(10042, 100099, '', 'Pook Swee Han', '1, Regat Pasir Puteh 31650 Ipoh Perak', 3541, 0, 0, 0, 0, 0, 0, '88888888', '8888888888888', '', 0, 3548, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10043, 100105, '', 'test', 'fdfsf', 0, 0, 0, 0, 0, 4009, 0, 'sdfsdf', 'sdfsff', 'Y', 0, 3989, 0, 0, 3973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 4012, '0000-00-00'),
(10044, 100112, '', 'hao hao', 'orchard', 0, 3764, 3789, 0, 3767, 0, 0, 'sdfsdfsdf', '566574657', 'Y', 0, 3770, 0, 3772, 3786, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10045, 100122, '', 'Lee Shan Shan', 'Hong Kong', 3838, 0, 0, 0, 0, 0, 0, 'Hong Kong', 'A7773777', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10046, 100123, '', 'Lee Shan Shan', 'Hong Kong', 3850, 0, 0, 0, 0, 0, 0, 'Hong Kong', 'A7773777', 'Y', 0, 0, 0, 0, 0, 3860, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '1970-01-01', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10047, 100124, '', 'Lee Wen Zhi', 'Hong Kong', 0, 0, 0, 0, 0, 0, 0, 'Hong Kong', '12345678', 'N', 0, 0, 0, 0, 0, 0, 3885, 3894, 3895, 3896, 0, 0, 0, 3900, 3904, 0, 3902, 3905, 0, 3906, '', '', 3907, '', '', 3908, '', '', 3909, '', '', 0, '2017-03-13', 'Shan Ying', 'Yap', 'AT Company  Pte Ltd', '505-101-303879', 'Hong Kong', 'central', 'central', 'central ,hong kong', 'Lee Wen Zhi', 'Lee Wen Zhi', 3873, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10048, 0, '', 'sdfdsf', 'sdfsdg', 0, 0, 0, 0, 0, 0, 0, 'sdfdsf', 'sdfsdf', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10049, 0, '', 'dasda', 'dasdas', 3926, 0, 0, 0, 0, 3931, 0, 'dsadasd', '2323', '', 0, 0, 0, 3925, 3933, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, 'sdadasdas', 3934, '2017-04-01'),
(10050, 0, '', 'Ryan Dumajil', 'Dytdd', 0, 0, 0, 0, 0, 3943, 0, 'Hhfgj', '5775', '', 0, 0, 0, 0, 3945, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, 'Chfcgbnv', 3946, '2017-04-01'),
(10051, 0, '', 'Ryan Dumajil', 'Dytdd', 0, 0, 0, 0, 0, 0, 0, '', '', '', 0, 4030, 0, 0, 4045, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, 'Chfcgbnv', 3957, '2017-04-01'),
(10052, 0, '', '234', '1244321', 0, 4021, 0, 0, 0, 0, 0, 'dfsdfsd', '21312', '', 0, 4017, 0, 0, 4027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', 'China', '', '', '', '', '', 0, '', 0, '', 0, 0, '', 0, '0000-00-00'),
(10053, 0, '', 'dasdsadsa', 'dasdasdas', 4050, 0, 0, 0, 0, 0, 4056, 'sadsadsada', '2323', '', 0, 4046, 4047, 4048, 4072, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, 'dasfsdgdfbdf dfgdfgsdf', 4049, '2017-04-03'),
(10054, 0, '', 'dsadasdasdas', 'asdasdasdasda', 0, 4080, 4081, 0, 0, 0, 0, 'dsadsadas', '23232', '', 0, 4075, 0, 0, 4086, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, 'asdasdasdasdasd', 4078, '2017-04-04'),
(10055, 0, 'yes', 'kghjghjhgj', 'ghfghfghfg', 4092, 0, 0, 0, 0, 0, 0, 'ghjghjfhdfhdfg', '3423423423', '', 0, 4088, 4089, 4090, 4091, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, 'odoifhsdkghk sadsdasd', 4099, '2017-04-06');

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `ActivityID` int(21) NOT NULL,
  `ActivityDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ActivityDescription` text NOT NULL,
  `UserID` int(21) NOT NULL,
  `UserName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`ActivityID`, `ActivityDate`, `ActivityDescription`, `UserID`, `UserName`) VALUES
(1, '2017-02-07 00:37:32', 'Update Casefile #GA-CF-10043', 100000, ''),
(2, '2017-02-07 01:10:02', 'Updated Casefile #GA-CF-10043Step 5: Set account status to Pending', 100000, 'Moises Goloyugo'),
(3, '2017-02-07 01:11:58', 'Updated Casefile #GA-CF-10043\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(4, '2017-02-07 01:13:42', 'Updated Casefile #GA-CF-10043\r\nStep 5: Set account status to Pending', 100000, 'Moises Goloyugo'),
(5, '2017-02-07 01:18:11', 'Updated Casefile #GA-CF-10043\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(6, '2017-02-07 01:29:05', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(7, '2017-02-07 01:47:45', 'Updated Casefile #GA-CF-10043\r\nStep 4', 100000, 'Moises Goloyugo'),
(8, '2017-02-07 15:40:44', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(9, '2017-02-07 15:42:14', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(10, '2017-02-07 15:45:22', 'Updated Casefile #GA-CF-10043\r\nStep 2', 100000, 'Moises Goloyugo'),
(11, '2017-02-07 15:59:47', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(12, '2017-02-07 16:01:18', 'Updated Casefile #GA-CF-10043\r\nStep 3', 100000, 'Moises Goloyugo'),
(13, '2017-02-07 16:02:02', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(14, '2017-02-07 16:03:45', 'Add payment transaction for Casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(15, '2017-02-07 16:03:57', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(16, '2017-02-07 16:05:48', 'Sent client commencement letter with casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(17, '2017-02-07 16:05:48', 'Sent commencement email letter for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(18, '2017-02-07 16:08:05', 'Updated Casefile #GA-CF-10043\r\nStep 6: Set courier status to Processing', 100000, 'Moises Goloyugo'),
(19, '2017-02-07 16:08:36', 'Updated Casefile #GA-CF-10043\r\nStep 6: Set courier status to Delivered', 100000, 'Moises Goloyugo'),
(20, '2017-02-07 16:10:02', 'Updated Casefile #GA-CF-10043\r\nStep 6: Set courier status to Waiting', 100000, 'Moises Goloyugo'),
(21, '2017-02-07 16:13:21', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(22, '2017-02-09 06:34:57', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(23, '2017-02-09 06:48:37', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(24, '2017-02-09 06:53:39', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(25, '2017-02-09 06:54:41', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(26, '2017-02-12 23:29:47', 'Updated Casefile #GA-CF-10043\r\nStep 5: Set account status to Pending', 100000, 'Moises Goloyugo'),
(27, '2017-02-16 11:00:47', 'Updated Agency #GAA-100084.', 100000, 'Moises Goloyugo'),
(28, '2017-02-16 12:03:41', 'Updated User #100084.', 100000, 'Moises Goloyugo'),
(29, '2017-02-16 15:00:55', 'Added Capability #51.', 100000, 'Moises Goloyugo'),
(30, '2017-02-16 15:01:26', 'Added Capability #52.', 100000, 'Moises Goloyugo'),
(31, '2017-02-16 15:01:41', 'Added Capability #53.', 100000, 'Moises Goloyugo'),
(32, '2017-02-16 15:01:55', 'Added Capability #54.', 100000, 'Moises Goloyugo'),
(33, '2017-02-16 15:02:28', 'Updated Capability #51.', 100000, 'Moises Goloyugo'),
(34, '2017-02-16 15:04:07', 'Updated Capability #31.', 100000, 'Moises Goloyugo'),
(35, '2017-02-16 15:06:18', 'Updated Role #1.', 100000, 'Moises Goloyugo'),
(36, '2017-02-16 15:06:38', 'Updated Role #1.', 100000, 'Moises Goloyugo'),
(37, '2017-02-16 15:07:28', 'Updated Capability #32.', 100000, 'Moises Goloyugo'),
(38, '2017-02-16 15:08:03', 'Deleted Capability #52.', 100000, 'Moises Goloyugo'),
(39, '2017-02-16 15:08:12', 'Deleted Capability #53.', 100000, 'Moises Goloyugo'),
(40, '2017-02-16 15:08:20', 'Deleted Capability #54.', 100000, 'Moises Goloyugo'),
(41, '2017-02-16 15:16:08', 'Updated Role #1.', 100000, 'Moises Goloyugo'),
(42, '2017-02-16 15:26:33', 'Updated User #100000.', 100000, 'Moises Goloyugo'),
(43, '2017-02-16 15:27:35', 'Updated User #100079.', 100000, 'Moises Goloyugo'),
(44, '2017-02-16 15:28:48', 'Updated User #100086.', 100000, 'Moises Goloyugo'),
(45, '2017-02-16 15:30:05', 'Updated User #100086.', 100000, 'Moises Goloyugo'),
(46, '2017-02-16 15:31:51', 'Updated User #100086.', 100000, 'Moises Goloyugo'),
(47, '2017-02-16 15:33:45', 'Updated Role #3.', 100000, 'Moises Goloyugo'),
(48, '2017-02-16 15:34:04', 'Updated Role #3.', 100000, 'Moises Goloyugo'),
(49, '2017-02-16 15:48:00', 'Updated User #100000.', 100000, 'Moises Goloyugo'),
(50, '2017-02-16 15:54:54', 'Updated User #100000.', 100000, 'Moises Goloyugo'),
(51, '2017-02-16 15:58:17', 'Updated User #100086.', 100000, 'Moises Goloyugo'),
(52, '2017-02-16 16:07:59', 'Updated User #100001.', 100000, 'Moises Goloyugo'),
(53, '2017-02-16 17:39:49', 'Updated User #100086.', 100086, 'Ryan Dumajil'),
(54, '2017-02-16 17:48:48', 'Updated User #100086.', 100086, 'Ryan Dumajil'),
(55, '2017-02-16 17:50:38', 'Updated User #100001.', 100086, 'Ryan Dumajil'),
(56, '2017-02-16 17:50:54', 'Updated User #100001.', 100086, 'Ryan Dumajil'),
(57, '2017-02-16 17:51:08', 'Updated User #100084.', 100086, 'Ryan Dumajil'),
(58, '2017-02-16 17:51:21', 'Updated User #100095.', 100086, 'Ryan Dumajil'),
(59, '2017-02-20 14:52:41', 'Updated Casefile #GA-CF-10026\r\nStep 4', 100079, 'Chris Chua'),
(60, '2017-02-21 09:04:24', 'Added User #100109.', 100079, 'Chris Chua'),
(61, '2017-02-21 09:05:22', 'Updated User #100109.', 100079, 'Chris Chua'),
(62, '2017-02-21 09:32:06', 'Added Agency #GAA-100110.', 100109, 'jeff goh wei ming'),
(63, '2017-02-21 09:34:28', 'Approved client file #GA-UF-237.', 100109, 'jeff goh wei ming'),
(64, '2017-02-21 09:42:12', 'Added Agent #GA-100111.', 100109, 'jeff goh wei ming'),
(65, '2017-02-21 09:42:45', 'Approved client file #GA-UF-238.', 100109, 'jeff goh wei ming'),
(66, '2017-02-22 05:52:08', 'Updated Role #3.', 100079, 'Chris Chua'),
(67, '2017-02-22 06:00:48', 'Updated User #100110.', 100110, 'Jeff Humsap Pte Ltd'),
(68, '2017-02-22 06:17:11', 'Updated Casefile #GA-CF-10044\r\nStep 3', 100079, 'Chris Chua'),
(69, '2017-02-22 06:18:11', 'Updated Casefile #GA-CF-10044\r\nStep 4', 100079, 'Chris Chua'),
(70, '2017-02-22 06:18:27', 'Sent demand note email for casefile #GA-CF-10070.', 100079, 'Chris Chua'),
(71, '2017-02-22 06:19:00', 'Sent demand note email for casefile #GA-CF-10070.', 100079, 'Chris Chua'),
(72, '2017-02-22 06:20:03', 'Add payment transaction for Casefile #GA-CF-10070.', 100079, 'Chris Chua'),
(73, '2017-02-22 06:22:31', 'Add payment transaction for Casefile #GA-CF-10070.', 100079, 'Chris Chua'),
(74, '2017-02-22 06:22:42', 'Sent acknowledment receipt email for casefile #GA-CF-10070.', 100079, 'Chris Chua'),
(75, '2017-02-22 06:23:55', 'Updated Casefile #GA-CF-10044\r\nStep 5: Set account status to Approved', 100079, 'Chris Chua'),
(76, '2017-02-23 09:30:48', 'Updated Role #4.', 100079, 'Chris Chua'),
(77, '2017-02-23 09:32:23', 'Updated Role #1.', 100079, 'Chris Chua'),
(78, '2017-02-23 09:33:24', 'Updated User #100079.', 100079, 'Chris Chua'),
(79, '2017-02-23 10:13:22', 'Updated User #100079.', 100079, 'Global Asset'),
(80, '2017-02-23 10:30:33', 'Updated User #100079.', 100079, 'Global Asset'),
(81, '2017-02-23 10:31:12', 'Updated User #100033.', 100079, 'Global Asset'),
(82, '2017-02-23 11:59:59', 'Updated User #100079.', 100000, 'Moises Goloyugo'),
(83, '2017-02-23 12:53:02', 'Updated User #100086.', 100000, 'Moises Goloyugo'),
(84, '2017-02-23 13:11:40', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(85, '2017-02-23 13:42:03', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100081, 'HAO LEE'),
(86, '2017-02-23 13:54:13', 'Updated Casefile #GA-CF-10043\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(87, '2017-02-23 14:42:31', 'Updated Casefile #GA-CF-10043\r\nStep 1', 100000, 'Moises Goloyugo'),
(88, '2017-02-23 14:48:41', 'Updated Role #3.', 100000, 'Moises Goloyugo'),
(89, '2017-03-01 07:51:20', 'Added Media File.', 100000, 'Moises Goloyugo'),
(90, '2017-03-02 04:20:55', 'Added Agency #GAA-100113.', 100086, 'Ryan Dumajil'),
(91, '2017-03-02 04:23:47', 'Updated Agency #GAA-100113.', 100086, 'Ryan Dumajil'),
(92, '2017-03-02 04:24:48', 'Updated Agency #GAA-100113.', 100086, 'Ryan Dumajil'),
(93, '2017-03-02 04:26:02', 'Added Agent #GA-100114.', 100086, 'Ryan Dumajil'),
(94, '2017-03-02 04:26:54', 'Added Agent #GA-100115.', 100086, 'Ryan Dumajil'),
(95, '2017-03-02 04:27:37', 'Added Agent #GA-100116.', 100086, 'Ryan Dumajil'),
(96, '2017-03-02 04:28:10', 'Added Agent #GA-100117.', 100086, 'Ryan Dumajil'),
(97, '2017-03-02 04:28:35', 'Added Agent #GA-100118.', 100086, 'Ryan Dumajil'),
(98, '2017-03-02 04:29:19', 'Updated Agent #GA-100114.', 100086, 'Ryan Dumajil'),
(99, '2017-03-02 04:30:09', 'Updated Agent #GA-100114.', 100086, 'Ryan Dumajil'),
(100, '2017-03-02 04:32:59', 'Updated Agent #GA-100116.', 100086, 'Ryan Dumajil'),
(101, '2017-03-02 04:33:38', 'Updated Agent #GA-100116.', 100086, 'Ryan Dumajil'),
(102, '2017-03-02 04:34:21', 'Updated Agent #GA-100117.', 100086, 'Ryan Dumajil'),
(103, '2017-03-02 04:35:32', 'Updated Agent #GA-100118.', 100086, 'Ryan Dumajil'),
(104, '2017-03-07 06:39:34', 'Sent demand note email for casefile #GA-CF-10070.', 100000, 'Moises Goloyugo'),
(105, '2017-03-07 06:40:00', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100086, 'Ryan Dumajil'),
(106, '2017-03-07 06:40:49', 'Sent commencement email letter for casefile #GA-CF-10065.', 100086, 'Ryan Dumajil'),
(107, '2017-03-07 06:41:48', 'Sent acknowledment receipt email for casefile #GA-CF-10070.', 100000, 'Moises Goloyugo'),
(108, '2017-03-08 05:07:55', 'Updated User #100095.', 100079, 'Global Asset'),
(109, '2017-03-08 05:10:26', 'Updated User #100095.', 100079, 'Global Asset'),
(110, '2017-03-08 05:10:56', 'Approved client file #GA-UF-246.', 100095, 'sy yap'),
(111, '2017-03-08 05:15:34', 'Added User #100119.', 100079, 'Global Asset'),
(112, '2017-03-08 05:16:28', 'Updated User #100119.', 100079, 'Global Asset'),
(113, '2017-03-08 05:17:16', 'Added User #100120.', 100079, 'Global Asset'),
(114, '2017-03-08 05:17:39', 'Updated User #100120.', 100079, 'Global Asset'),
(115, '2017-03-08 05:18:21', 'Added User #100121.', 100079, 'Global Asset'),
(116, '2017-03-08 05:18:58', 'Updated User #100121.', 100079, 'Global Asset'),
(117, '2017-03-08 05:26:08', 'Updated Agency #GAA-100110.', 100121, 'Louis Yap'),
(118, '2017-03-14 07:43:10', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(119, '2017-03-14 07:44:46', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(120, '2017-03-14 07:47:00', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(121, '2017-03-14 07:49:17', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(122, '2017-03-14 09:29:31', 'Sent acknowledment receipt email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(123, '2017-03-14 09:32:20', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(124, '2017-03-14 09:35:37', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(125, '2017-03-14 09:42:37', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(126, '2017-03-14 10:36:18', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(127, '2017-03-14 10:40:01', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(128, '2017-03-14 10:41:47', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(129, '2017-03-14 10:44:15', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(130, '2017-03-14 10:46:05', 'Sent commencement email letter for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(131, '2017-03-14 10:51:09', 'Sent commencement email letter for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(132, '2017-03-14 11:22:57', 'Sent commencement email letter for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(133, '2017-03-14 12:26:36', 'Updated Agent #GA-100118.', 100000, 'Moises Goloyugo'),
(134, '2017-03-16 17:04:26', 'Updated Casefile #GA-CF-10046\r\nStep 1', 100000, 'Moises Goloyugo'),
(135, '2017-03-16 17:04:34', 'Updated Casefile #GA-CF-10045\r\nStep 1', 100000, 'Moises Goloyugo'),
(136, '2017-03-16 17:04:47', 'Updated Casefile #GA-CF-10047\r\nStep 1', 100000, 'Moises Goloyugo'),
(137, '2017-03-16 17:06:11', 'Updated Casefile #GA-CF-10044\r\nStep 1', 100000, 'Moises Goloyugo'),
(138, '2017-03-16 17:08:11', 'Updated Agent #GA-100115.', 100000, 'Moises Goloyugo'),
(139, '2017-03-16 17:08:34', 'Updated Agent #GA-100114.', 100000, 'Moises Goloyugo'),
(140, '2017-03-16 17:13:43', 'Updated Casefile #GA-CF-10045\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(141, '2017-03-16 17:13:59', 'Updated Casefile #GA-CF-10047\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(142, '2017-03-16 17:14:10', 'Updated Casefile #GA-CF-10046\r\nStep 5: Set account status to Approved', 100000, 'Moises Goloyugo'),
(143, '2017-03-16 17:14:52', 'Updated Casefile #GA-CF-10046\r\nStep 4', 100000, 'Moises Goloyugo'),
(144, '2017-03-16 17:37:24', 'Updated User #100114.', 100000, 'Moises Goloyugo'),
(145, '2017-03-16 17:37:35', 'Updated User #100115.', 100000, 'Moises Goloyugo'),
(146, '2017-03-16 17:37:46', 'Updated User #100116.', 100000, 'Moises Goloyugo'),
(147, '2017-03-20 06:32:02', 'Updated Role #3.', 100086, 'Ryan Dumajil'),
(148, '2017-03-20 06:32:18', 'Updated Role #4.', 100086, 'Ryan Dumajil'),
(149, '2017-03-20 13:09:49', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(150, '2017-03-20 13:18:15', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(151, '2017-03-20 13:18:56', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(152, '2017-03-20 13:19:18', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(153, '2017-03-20 14:07:40', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(154, '2017-03-20 14:09:36', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(155, '2017-03-20 14:18:06', 'Updated commission scheme.', 100084, 'Global Assets Core'),
(156, '2017-03-20 15:00:48', 'Added Capability #52.', 100000, 'Moises Goloyugo'),
(157, '2017-03-20 15:01:35', 'Updated Capability #18.', 100000, 'Moises Goloyugo'),
(158, '2017-03-20 15:01:54', 'Deleted Capability #52.', 100000, 'Moises Goloyugo'),
(159, '2017-03-20 15:04:07', 'Updated User #100000.', 100000, 'Moises Goloyugo'),
(160, '2017-03-20 15:06:19', 'Updated User #100084.', 100000, 'Moises Goloyugo'),
(161, '2017-03-20 15:06:40', 'Updated User #100084.', 100000, 'Moises Goloyugo'),
(162, '2017-03-20 15:07:29', 'Updated Role #3.', 100000, 'Moises Goloyugo'),
(163, '2017-03-20 15:07:56', 'Updated User #100084.', 100084, 'Global Assets Core'),
(164, '2017-03-21 11:59:07', 'Updated Product #PRD-210001.', 100086, 'Ryan Dumajil'),
(165, '2017-03-21 12:02:49', 'Updated Product #PRD-210002.', 100086, 'Ryan Dumajil'),
(166, '2017-03-21 12:03:50', 'Trashed Product item #PIT-10044.', 100086, 'Ryan Dumajil'),
(167, '2017-03-21 12:03:57', 'Trashed Product item #PIT-10043.', 100086, 'Ryan Dumajil'),
(168, '2017-03-21 12:04:19', 'Updated Product #PRD-210007.', 100086, 'Ryan Dumajil'),
(169, '2017-03-21 12:07:37', 'Added Product item #PIT-10047.', 100086, 'Ryan Dumajil'),
(170, '2017-03-21 12:08:20', 'Updated Product #PRD-210008.', 100086, 'Ryan Dumajil'),
(171, '2017-03-21 12:08:24', 'Trashed Product item #PIT-10046.', 100086, 'Ryan Dumajil'),
(172, '2017-03-21 12:08:52', 'Updated Product item #PIT-10045.', 100086, 'Ryan Dumajil'),
(173, '2017-03-21 12:09:24', 'Updated Product item #PIT-10045.', 100086, 'Ryan Dumajil'),
(174, '2017-03-21 12:10:50', 'Deleted Product item #PIT-10044.', 100086, 'Ryan Dumajil'),
(175, '2017-03-21 12:10:56', 'Deleted Product item #PIT-10043.', 100086, 'Ryan Dumajil'),
(176, '2017-03-21 12:11:00', 'Deleted Product item #PIT-10046.', 100086, 'Ryan Dumajil'),
(177, '2017-03-24 07:14:31', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(178, '2017-03-24 07:58:15', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(179, '2017-03-24 08:09:02', 'Sent demand note email for casefile #GA-CF-10065.', 100000, 'Moises Goloyugo'),
(180, '2017-03-27 13:48:01', 'Sent demand note email for casefile #GA-CF-10070.', 100000, 'Moises Goloyugo'),
(181, '2017-03-28 09:08:20', 'Sent demand note email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(182, '2017-03-28 09:12:17', 'Sent demand note email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(183, '2017-03-28 09:15:49', 'Sent demand note email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(184, '2017-03-28 09:20:42', 'Updated User #100086.', 100086, 'Ryan Dumajil'),
(185, '2017-03-28 09:24:38', 'Sent demand note email for casefile #GA-CF-10078.', 100000, 'Moises Goloyugo'),
(186, '2017-03-28 09:25:34', 'Sent demand note email for casefile #GA-CF-10078.', 100000, 'Moises Goloyugo'),
(187, '2017-03-28 09:27:28', 'Updated Casefile #GA-CF-10047\r\nStep 1', 100086, 'Ryan Dumajil'),
(188, '2017-03-28 12:38:12', 'Sent demand note email for casefile #GA-CF-10078.', 100000, 'Moises Goloyugo'),
(189, '2017-03-28 13:27:32', 'Sent demand note email for casefile #GA-CF-10078.', 100000, 'Moises Goloyugo'),
(190, '2017-03-28 13:36:25', 'Sent demand note email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(191, '2017-03-28 13:43:46', 'Sent acknowledment receipt email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(192, '2017-03-28 13:52:20', 'Sent commencement email letter for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(193, '2017-03-28 14:56:54', 'Sent commencement email letter for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(194, '2017-03-28 15:15:40', 'Sent commencement email letter for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(195, '2017-03-31 15:08:14', 'Sent demand note email for casefile #GA-CF-10038.', 100000, 'Moises Goloyugo'),
(196, '2017-03-31 15:30:37', 'Sent acknowledment receipt email for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(197, '2017-03-31 15:31:21', 'Sent commencement email letter for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(198, '2017-03-31 15:35:04', 'Updated Casefile #GA-CF-10047\r\nStep 2', 100000, 'Moises Goloyugo'),
(199, '2017-03-31 15:35:16', 'Approved client file #GA-UF-255.', 100000, 'Moises Goloyugo'),
(200, '2017-03-31 15:35:18', 'Approved client file #GA-UF-256.', 100000, 'Moises Goloyugo'),
(201, '2017-03-31 15:35:21', 'Approved client file #GA-UF-261.', 100000, 'Moises Goloyugo'),
(202, '2017-03-31 15:35:23', 'Approved client file #GA-UF-263.', 100000, 'Moises Goloyugo'),
(203, '2017-03-31 15:35:26', 'Approved client file #GA-UF-262.', 100000, 'Moises Goloyugo'),
(204, '2017-03-31 15:37:20', 'Sent commencement email letter for casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(205, '2017-03-31 16:31:48', 'Updated Casefile #GA-CF-10048\r\nStep 1', 100079, 'Global Asset'),
(206, '2017-03-31 16:32:05', 'Sent demand note email for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(207, '2017-03-31 16:33:36', 'Updated Casefile #GA-CF-10026\r\nStep 1', 100079, 'Global Asset'),
(208, '2017-03-31 16:34:17', 'Updated Casefile #GA-CF-10048\r\nStep 1', 100086, 'Ryan Dumajil'),
(209, '2017-03-31 16:38:08', 'Updated Casefile #GA-CF-10048\r\nStep 4', 100079, 'Global Asset'),
(210, '2017-03-31 16:38:29', 'Add payment transaction for Casefile #GA-CF-10080.', 100079, 'Global Asset'),
(211, '2017-03-31 16:38:47', 'Add payment transaction for Casefile #GA-CF-10080.', 100079, 'Global Asset'),
(212, '2017-03-31 16:39:19', 'Add payment transaction for Casefile #GA-CF-10080.', 100079, 'Global Asset'),
(213, '2017-03-31 16:39:32', 'Sent acknowledment receipt email for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(214, '2017-03-31 16:41:26', 'Updated Casefile #GA-CF-10048\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(215, '2017-03-31 16:42:24', 'Sent client commencement letter with casefile #GA-CF-10080.', 100079, 'Global Asset'),
(216, '2017-03-31 16:42:24', 'Sent commencement email letter for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(217, '2017-03-31 16:49:44', 'Sent demand note email for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(218, '2017-03-31 16:51:59', 'Sent demand note email for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(219, '2017-03-31 16:55:03', 'Sent acknowledment receipt email for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(220, '2017-03-31 16:58:27', 'Sent client commencement letter with casefile #GA-CF-10080.', 100079, 'Global Asset'),
(221, '2017-03-31 16:58:27', 'Sent commencement email letter for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(222, '2017-03-31 18:52:25', 'Add payment transaction for Casefile #GA-CF-10079.', 100000, 'Moises Goloyugo'),
(223, '2017-04-01 03:47:06', 'Sent client commencement letter with casefile #GA-CF-10080.', 100079, 'Global Asset'),
(224, '2017-04-01 03:47:06', 'Sent commencement email letter for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(225, '2017-04-01 03:47:27', 'Sent client commencement letter with casefile #GA-CF-10080.', 100079, 'Global Asset'),
(226, '2017-04-01 03:47:27', 'Sent commencement email letter for casefile #GA-CF-10080.', 100079, 'Global Asset'),
(227, '2017-04-01 04:57:08', 'Sent commencement email letter for casefile #GA-CF-10080.', 100000, 'Moises Goloyugo'),
(228, '2017-04-01 04:58:28', 'Sent acknowledment receipt email for casefile #GA-CF-10080.', 100000, 'Moises Goloyugo'),
(229, '2017-04-01 14:01:41', 'Updated Casefile #GA-CF-10043\r\nStep 2', 100086, 'Ryan Dumajil'),
(230, '2017-04-01 14:02:10', 'Updated Casefile #GA-CF-10043\r\nStep 2', 100086, 'Ryan Dumajil'),
(231, '2017-04-01 14:02:46', 'Updated Casefile #GA-CF-10043\r\nStep 2', 100086, 'Ryan Dumajil'),
(232, '2017-04-01 14:03:05', 'Updated Casefile #GA-CF-10043\r\nStep 3', 100086, 'Ryan Dumajil'),
(233, '2017-04-01 14:03:37', 'Sent commencement email letter for casefile #GA-CF-10065.', 100086, 'Ryan Dumajil'),
(234, '2017-04-03 08:47:37', 'Added Agency #GAA-100129.', 100086, 'Ryan Dumajil'),
(235, '2017-04-03 08:50:02', 'Added Agent #GA-100130.', 100079, 'Global Asset'),
(236, '2017-04-03 08:58:56', 'Updated Casefile #GA-CF-10052\r\nStep 1', 100079, 'Global Asset'),
(237, '2017-04-03 09:01:06', 'Sent demand note email for casefile #GA-CF-10086.', 100079, 'Global Asset'),
(238, '2017-04-03 09:04:28', 'Add payment transaction for Casefile #GA-CF-10086.', 100079, 'Global Asset'),
(239, '2017-04-03 09:06:35', 'Add payment transaction for Casefile #GA-CF-10086.', 100079, 'Global Asset'),
(240, '2017-04-03 09:08:20', 'Add payment transaction for Casefile #GA-CF-10086.', 100079, 'Global Asset'),
(241, '2017-04-03 09:08:43', 'Updated Casefile #GA-CF-10052\r\nStep 4', 100079, 'Global Asset'),
(242, '2017-04-03 09:08:54', 'Sent acknowledment receipt email for casefile #GA-CF-10086.', 100079, 'Global Asset'),
(243, '2017-04-03 09:10:55', 'Updated Casefile #GA-CF-10052\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(244, '2017-04-03 09:11:32', 'Sent client commencement letter with casefile #GA-CF-10086.', 100079, 'Global Asset'),
(245, '2017-04-03 09:11:32', 'Sent commencement email letter for casefile #GA-CF-10086.', 100079, 'Global Asset'),
(246, '2017-04-03 09:30:20', 'Updated Casefile #GA-CF-10052\r\nStep 4', 100079, 'Global Asset'),
(247, '2017-04-03 09:30:43', 'Sent client commencement letter with casefile #GA-CF-10086.', 100079, 'Global Asset'),
(248, '2017-04-03 09:30:43', 'Sent commencement email letter for casefile #GA-CF-10086.', 100079, 'Global Asset'),
(249, '2017-04-03 11:20:27', 'Updated Role #4.', 100086, 'Ryan Dumajil'),
(250, '2017-04-03 11:20:35', 'Updated Role #3.', 100086, 'Ryan Dumajil'),
(251, '2017-04-03 11:20:39', 'Updated Role #3.', 100086, 'Ryan Dumajil'),
(252, '2017-04-03 13:23:39', 'Updated Casefile #GA-CF-10051\r\nStep 1', 100033, 'GA Testing Agent'),
(253, '2017-04-03 13:24:48', 'Updated Casefile #GA-CF-10051\r\nStep 2', 100033, 'GA Testing Agent'),
(254, '2017-04-03 13:29:45', 'Sent demand note email for casefile #GA-CF-10087.', 100033, 'GA Testing Agent'),
(255, '2017-04-03 13:31:36', 'Updated Casefile #GA-CF-10053\r\nStep 5: Set account status to Approved', 100086, 'Ryan Dumajil'),
(256, '2017-04-03 13:32:21', 'Sent client commencement letter with casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(257, '2017-04-03 13:32:21', 'Sent commencement email letter for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(258, '2017-04-03 13:34:41', 'Updated Casefile #GA-CF-10053\r\nStep 2', 100086, 'Ryan Dumajil'),
(259, '2017-04-03 13:37:03', 'Sent demand note email for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(260, '2017-04-03 13:42:53', 'Updated Casefile #GA-CF-10053\r\nStep 4', 100086, 'Ryan Dumajil'),
(261, '2017-04-03 13:43:17', 'Add payment transaction for Casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(262, '2017-04-03 13:43:28', 'Add payment transaction for Casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(263, '2017-04-03 13:43:53', 'Add payment transaction for Casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(264, '2017-04-03 13:44:13', 'Sent acknowledment receipt email for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(265, '2017-04-03 13:47:29', 'Sent client commencement letter with casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(266, '2017-04-03 13:47:29', 'Sent commencement email letter for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(267, '2017-04-03 13:59:51', 'Updated Casefile #GA-CF-10036\r\nStep 4', 100000, 'Moises Goloyugo'),
(268, '2017-04-03 14:00:52', 'Updated Casefile #GA-CF-10047\r\nStep 4', 100000, 'Moises Goloyugo'),
(269, '2017-04-03 14:07:38', 'Sent demand note email for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(270, '2017-04-03 14:08:02', 'Sent acknowledment receipt email for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(271, '2017-04-03 14:08:24', 'Sent client commencement letter with casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(272, '2017-04-03 14:08:24', 'Sent commencement email letter for casefile #GA-CF-10087.', 100086, 'Ryan Dumajil'),
(273, '2017-04-04 08:30:29', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100079, 'Global Asset'),
(274, '2017-04-04 08:30:41', 'Sent acknowledment receipt email for casefile #GA-CF-10083.', 100079, 'Global Asset'),
(275, '2017-04-04 08:31:01', 'Add payment transaction for Casefile #GA-CF-10083.', 100079, 'Global Asset'),
(276, '2017-04-04 08:39:14', 'Add payment transaction for Casefile #GA-CF-10083.', 100079, 'Global Asset'),
(277, '2017-04-04 08:39:29', 'Add payment transaction for Casefile #GA-CF-10083.', 100079, 'Global Asset'),
(278, '2017-04-04 08:40:04', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100079, 'Global Asset'),
(279, '2017-04-04 08:40:13', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100079, 'Global Asset'),
(280, '2017-04-04 08:42:28', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100079, 'Global Asset'),
(281, '2017-04-04 08:42:42', 'Updated Casefile #GA-CF-10051\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(282, '2017-04-04 09:49:17', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100000, 'Moises Goloyugo'),
(283, '2017-04-04 10:14:21', 'Updated User #100079.', 100000, 'Moises Goloyugo'),
(284, '2017-04-04 10:23:52', 'Updated Agency #GAA-100084.', 100079, 'Global Asset'),
(285, '2017-04-04 10:33:49', 'Updated Agency #GAA-100084.', 100079, 'Global Asset'),
(286, '2017-04-04 10:37:31', 'Updated Casefile #GA-CF-10052\r\nStep 4', 100079, 'Global Asset'),
(287, '2017-04-04 10:49:42', 'Updated Casefile #GA-CF-10051\r\nStep 4', 100079, 'Global Asset'),
(288, '2017-04-04 15:18:44', 'Updated Casefile #GA-CF-10054\r\nStep 5: Set account status to Approved', 100086, 'Ryan Dumajil'),
(289, '2017-04-04 15:19:34', 'Sent client commencement letter with casefile #GA-CF-10088.', 100086, 'Ryan Dumajil'),
(290, '2017-04-04 15:19:34', 'Sent commencement email letter for casefile #GA-CF-10088.', 100086, 'Ryan Dumajil'),
(291, '2017-04-05 06:11:37', 'Updated User #100086.', 100086, 'Ryan Dumajil'),
(292, '2017-04-05 06:11:54', 'Updated User #100086.', 100086, 'Ryan Dumajil'),
(293, '2017-04-05 06:16:06', 'Sent client commencement letter with casefile #GA-CF-10088.', 100086, 'Ryan Dumajil'),
(294, '2017-04-05 06:16:06', 'Sent commencement email letter for casefile #GA-CF-10088.', 100086, 'Ryan Dumajil'),
(295, '2017-04-06 06:52:29', 'Added Agency #GAA-100134.', 100086, 'Ryan Dumajil'),
(296, '2017-04-06 06:54:55', 'Updated User #100113.', 100086, 'Ryan Dumajil'),
(297, '2017-04-06 06:58:52', 'Updated User #100114.', 100086, 'Ryan Dumajil'),
(298, '2017-04-06 07:11:47', 'Add payment transaction for Casefile #GA-CF-10090.', 100086, 'Ryan Dumajil'),
(299, '2017-04-06 07:12:12', 'Sent acknowledment receipt email for casefile #GA-CF-10090.', 100086, 'Ryan Dumajil'),
(300, '2017-04-06 07:13:10', 'Sent demand note email for casefile #GA-CF-10090.', 100086, 'Ryan Dumajil'),
(301, '2017-04-06 07:29:40', 'Updated Casefile #GA-CF-10055\r\nStep 6: Set courier status to Processing', 100086, 'Ryan Dumajil'),
(302, '2017-04-06 07:41:58', 'Updated User #100114.', 100086, 'Ryan Dumajil'),
(303, '2017-04-06 07:45:24', 'Added Media File.', 100086, 'Ryan Dumajil'),
(304, '2017-04-07 05:16:45', 'Updated Casefile #GA-CF-10055\r\nStep 5: Set account status to Approved', 100086, 'Ryan Dumajil'),
(305, '2017-04-07 05:17:18', 'Sent client commencement letter with casefile #GA-CF-10090.', 100086, 'Ryan Dumajil'),
(306, '2017-04-07 05:17:18', 'Sent commencement email letter for casefile #GA-CF-10090.', 100086, 'Ryan Dumajil'),
(307, '2017-04-10 04:39:34', 'Updated Role #4.', 100086, 'Ryan Dumajil'),
(308, '2017-04-18 11:43:26', 'Added Media Category #FileSubCategoryID1.', 100000, 'Moises Goloyugo');

-- --------------------------------------------------------

--
-- Table structure for table `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `BankAccountID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `Address` varchar(128) CHARACTER SET utf8 NOT NULL,
  `SwiftCode` varchar(64) CHARACTER SET utf8 NOT NULL,
  `DateAdded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Name` varchar(64) CHARACTER SET utf8 NOT NULL,
  `AccountNumber` varchar(32) CHARACTER SET utf8 NOT NULL,
  `AccountName` varchar(64) CHARACTER SET utf8 NOT NULL,
  `TrustAccount` varchar(3) CHARACTER SET utf8 NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bank_accounts`
--

INSERT INTO `bank_accounts` (`BankAccountID`, `UserID`, `Address`, `SwiftCode`, `DateAdded`, `Name`, `AccountNumber`, `AccountName`, `TrustAccount`) VALUES
(46, 100065, 'FLAT 1A, 15/F, KAM LING COURT, 1-3, WOO HOP STREET, HONG KONG', 'HASEHKHH', '2016-11-25 10:17:08', 'HANG SENG BANK LIMITED', '2341027221', 'LEE KING KI', 'N'),
(59, 100078, '彰化縣和美鎮和光路250號1樓', '013', '2016-11-29 09:15:59', 'Client', '239-03-501868-1', 'Sun Ying Enterprise Management Consulting Co.Ltd', 'N'),
(61, 100033, 'Taiwan', '232', '2016-12-06 11:04:40', 'Agent', '1234567890', 'Vicky Lai', 'N'),
(64, 100082, 'Dasmarinas', '280', '2016-11-29 08:56:28', 'Union Bank', '19013265566', 'San Yang', 'N'),
(65, 100084, 'Harbinger', '1234', '2016-12-07 07:45:25', 'Hong Kong Bank', '00000000000000', 'Odeon & Co', 'N'),
(68, 100081, 'qweasdfsadfdfghjkjhgfdsdfghjhgfd', 'sadf', '2016-12-07 07:33:48', 'Agent', 'sadf', 'sadf', 'N'),
(69, 100001, '', '', '2016-12-09 09:17:38', '', '', '', 'N'),
(71, 100085, '', '', '2016-12-09 14:01:33', '', '', '', 'N'),
(74, 100086, '', '', '2016-12-09 14:21:59', '', '', '', 'N'),
(75, 100087, 'ti wang da xia', 'hakkehk', '2016-12-13 04:23:33', 'ICBC', '6666554321', 'sy', 'N'),
(76, 100088, 'china', 'ICBCCNDW', '2016-12-13 04:36:48', 'ICBC', '606487875542', 'WONG SHIQI', 'N'),
(77, 100089, 'taiwan', 'hsbctwtw', '2016-12-13 05:02:44', 'hsbc', '11554422333', 'lee wen hong', 'N'),
(78, 100092, 'hong kong', 'hsbchkhk', '2016-12-13 06:31:03', 'HSBC', '606487875542', 'Victor Albee Wong', 'N'),
(79, 100094, 'hong kong', 'HSBBHHS', '2016-12-13 06:45:33', 'hang seng bank', '787454323', 'Chow Xiao Mi', 'N'),
(80, 100098, '', '', '2016-12-14 04:44:12', '', '', '', 'N'),
(81, 100099, '25-A, Jalan Arab', 'muar', '2016-12-20 05:52:01', 'Joanna', '88888888888', 'Chow', 'N'),
(82, 100105, 'No. 28 Leaf Village', 'sdfsdf', '2017-01-24 10:51:29', 'sdfsdf', 'sdfsdf', 'sdfsdf', 'N'),
(83, 100107, '123123', '213123', '2017-02-13 00:24:23', 'Agent', '123123', '123123', 'N'),
(84, 100108, '', '', '2017-02-13 01:46:50', '', '', '', 'N'),
(85, 100110, '', '', '2017-02-21 09:32:06', '', '', '', 'N'),
(86, 100111, '', '', '2017-02-21 09:42:12', '', '', '', 'N'),
(87, 100112, 'Orchard', 'dfgfghdfhg', '2017-02-22 06:18:11', 'DBS BANK', '465673254', 'haohao', 'N'),
(88, 100113, '', '', '2017-03-02 04:20:55', '', '', '', 'N'),
(89, 100114, '', '', '2017-03-02 04:26:01', '', '', '', 'N'),
(90, 100115, '', '', '2017-03-02 04:26:54', '', '', '', 'N'),
(91, 100116, '', '', '2017-03-02 04:27:37', '', '', '', 'N'),
(92, 100117, '', '', '2017-03-02 04:28:10', '', '', '', 'N'),
(93, 100118, '', '', '2017-03-02 04:28:35', '', '', '', 'N'),
(94, 100122, 'HSBC Hong Kong', '1001', '2017-03-10 04:54:22', 'HSBC', '10133556789', 'Lee Shan Shan', 'N'),
(95, 100123, 'hong kong', '1001', '2017-03-16 17:14:52', 'HSBC', '10133556789', 'Lee Shan Shan', 'N'),
(96, 100124, 'hong kong', '100033', '2017-04-03 14:00:52', 'HSBC', '101787855666', 'Lee Wen Zhi', 'N'),
(97, 100125, 'ssdsdf', 'asdfsf', '2017-03-31 16:38:08', 'sdfsdf', 'asdfdasf', 'sdfsdf', 'N'),
(98, 100126, 'sdadasd', '3232', '2017-03-31 19:10:02', 'asdasdasda', '23232', 'dsadasdas', 'N'),
(99, 100127, 'Bbfbvxf', '4753', '2017-04-01 11:55:53', 'Fhhdh', '5854', 'Hncc', 'N'),
(100, 100128, 'Ghgfgh', 'sdfgdfg', '2017-04-04 08:30:29', 'werfgs', 'sdfgf', 'sdfgsdg', 'N'),
(101, 100129, 'adas', '123123', '2017-04-03 08:47:37', 'dasdas', '123123', 'asdas', 'N'),
(102, 100130, '', '', '2017-04-03 08:50:02', '', '', '', 'N'),
(103, 100131, 'asdfdf', 'asdfadsf', '2017-04-03 09:08:43', 'asdfdaf', 'adfdf', 'sdafdf', 'N'),
(104, 100132, 'asdsad', '2323', '2017-04-03 13:42:53', 'asdasdasdas', '232323', 'dsadsad', 'N'),
(105, 100133, 'sadasda', '232', '2017-04-04 15:17:50', 'dasdasd', '323232', 'sdasdas', 'N'),
(106, 100134, 'sadsadas', '2323', '2017-04-06 06:52:29', 'dasdas', '23232', 'asdasd', 'N'),
(107, 100135, 'sdfghdfhdhdfgfd dfgdfsgds', '3423432432', '2017-04-06 07:06:02', 'gdsfgdfgds', '4343434', 'dfgdfgdfgdfsgd', 'N');

-- --------------------------------------------------------

--
-- Table structure for table `commission_overriding`
--

CREATE TABLE `commission_overriding` (
  `CommOverideID` int(15) NOT NULL,
  `CODate` date NOT NULL,
  `COAccountID` int(15) NOT NULL,
  `COPdtType` varchar(264) CHARACTER SET utf8 NOT NULL,
  `COSalesAmt` int(128) NOT NULL,
  `COCommRate` int(128) NOT NULL,
  `COCommPayable` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `commission_personal`
--

CREATE TABLE `commission_personal` (
  `CommPersonalID` int(15) NOT NULL,
  `CPDate` date NOT NULL,
  `CPAccountID` int(15) NOT NULL,
  `CPPdtType` varchar(264) CHARACTER SET utf8 NOT NULL,
  `CPSalesAmt` int(128) NOT NULL,
  `CPCommRate` int(128) NOT NULL,
  `CPCommPayable` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `commission_scheme`
--

CREATE TABLE `commission_scheme` (
  `SchemeID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `Level1` varchar(16) NOT NULL,
  `Level2` varchar(16) NOT NULL,
  `Level3` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `commission_scheme`
--

INSERT INTO `commission_scheme` (`SchemeID`, `UserID`, `Level1`, `Level2`, `Level3`) VALUES
(1, 100113, '7', '9', '10'),
(2, 100084, '6', '7', '8');

-- --------------------------------------------------------

--
-- Table structure for table `commission_statements`
--

CREATE TABLE `commission_statements` (
  `CommStatementID` int(21) NOT NULL,
  `CommPersonalID` int(21) NOT NULL,
  `AccountID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `ReferrerUserID` int(21) NOT NULL,
  `PayeeName` varchar(128) CHARACTER SET utf8 NOT NULL,
  `TerritoryID` int(21) NOT NULL,
  `Currency` int(21) NOT NULL,
  `PlantID` int(21) NOT NULL,
  `CommencementDate` date NOT NULL,
  `Position` varchar(128) CHARACTER SET utf8 NOT NULL,
  `FiscalYear` year(4) NOT NULL,
  `GrossPayoutAmt` int(128) NOT NULL,
  `DrawAdjustment` int(128) NOT NULL,
  `CapAdjustment` int(128) NOT NULL,
  `MinimumPayAdjustment` int(128) NOT NULL,
  `OtherAdjustment` int(128) NOT NULL,
  `Balance` int(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `email_queue`
--

CREATE TABLE `email_queue` (
  `EmailQueueID` int(21) NOT NULL,
  `EmailType` varchar(255) NOT NULL,
  `AccountID` int(21) NOT NULL,
  `Proccessed` int(11) NOT NULL DEFAULT '0',
  `Notes` int(11) NOT NULL,
  `DateQueued` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateSent` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` int(5) NOT NULL,
  `name` varchar(150) CHARACTER SET utf8 NOT NULL,
  `description` text CHARACTER SET utf8,
  `filename` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `email_templates`
--

INSERT INTO `email_templates` (`id`, `name`, `description`, `filename`, `created_at`, `updated_at`) VALUES
(1, 'Admin Received Notes', NULL, 'adminreceivednote.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(2, 'Commencement', NULL, 'commencement.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(3, 'Received Note', NULL, 'receivednote.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(4, 'Request Password', NULL, 'requestpw.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(5, 'Simplified', NULL, 'simplified.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(6, 'Traditional', NULL, 'traditional.eml', '2017-01-12 16:00:00', '2017-01-12 16:00:00'),
(7, 'Welcome email', NULL, 'welcome.eml', '2017-01-11 16:00:00', '2017-01-12 16:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `FileID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `FileCategoryID` int(21) NOT NULL DEFAULT '0',
  `FileSubCategoryID` int(11) NOT NULL DEFAULT '0',
  `FileAccess` text CHARACTER SET utf8 NOT NULL,
  `DateAdded` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`FileID`, `UserID`, `FileCategoryID`, `FileSubCategoryID`, `FileAccess`, `DateAdded`) VALUES
(175, 100047, 0, 0, '', '2016-09-05 11:27:11'),
(202, 100048, 0, 0, '', '2016-09-05 12:02:30'),
(233, 100049, 0, 0, '', '2016-09-05 12:26:25'),
(696, 100049, 0, 0, '', '2016-09-06 10:48:17'),
(751, 100001, 0, 0, '', '2016-09-08 09:13:04'),
(786, 100052, 0, 0, '', '2016-09-23 07:31:13'),
(817, 100053, 0, 0, '', '2016-09-23 09:07:21'),
(848, 100054, 0, 0, '', '2016-09-24 07:14:23'),
(1477, 100060, 0, 0, '', '2016-09-28 06:42:55'),
(1588, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1589, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1590, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1591, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1592, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1593, 100065, 0, 0, '', '2016-10-08 06:30:03'),
(1618, 100066, 0, 0, '', '2016-10-10 03:56:00'),
(1622, 100066, 0, 0, '', '2016-10-10 03:56:00'),
(1648, 100067, 0, 0, '', '2016-10-10 05:17:28'),
(1657, 100067, 0, 0, '', '2016-10-10 05:17:28'),
(1658, 100067, 0, 0, '', '2016-10-10 05:17:28'),
(1659, 100067, 0, 0, '', '2016-10-10 05:17:28'),
(2056, 100071, 0, 0, '', '2016-10-24 06:42:21'),
(2060, 100071, 0, 0, '', '2016-10-24 06:42:21'),
(2063, 100071, 0, 0, '', '2016-10-24 06:42:21'),
(2078, 100071, 0, 0, '', '2016-10-24 06:42:21'),
(2127, 100072, 0, 0, '', '2016-10-24 08:45:53'),
(2311, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2312, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2315, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2325, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2328, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2332, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2333, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2338, 100078, 0, 0, '', '2016-10-26 04:52:29'),
(2396, 100078, 0, 0, '', '2016-10-27 05:37:45'),
(2400, 100078, 0, 0, '', '2016-10-27 05:37:45'),
(2407, 100079, 0, 0, '', '2016-10-27 07:23:28'),
(2408, 100079, 0, 0, '', '2016-10-27 07:23:28'),
(2411, 100079, 0, 0, '', '2016-10-27 07:23:28'),
(2415, 100079, 0, 0, '', '2016-10-27 07:23:29'),
(2421, 100079, 0, 0, '', '2016-10-27 07:23:32'),
(2424, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2425, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2427, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2428, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2429, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2430, 100079, 0, 0, '', '2016-10-27 07:23:33'),
(2434, 100079, 0, 0, '', '2016-10-27 07:23:34'),
(2435, 100079, 0, 0, '', '2016-10-27 07:23:34'),
(2437, 100079, 0, 0, '', '2016-10-27 07:23:34'),
(2438, 100080, 0, 0, '', '2016-10-27 07:23:36'),
(2439, 100080, 0, 0, '', '2016-10-27 07:23:36'),
(2442, 100080, 0, 0, '', '2016-10-27 07:23:36'),
(2446, 100080, 0, 0, '', '2016-10-27 07:23:37'),
(2452, 100080, 0, 0, '', '2016-10-27 07:23:43'),
(2455, 100080, 0, 0, '', '2016-10-27 07:23:43'),
(2456, 100080, 0, 0, '', '2016-10-27 07:23:43'),
(2458, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2459, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2460, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2461, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2465, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2466, 100080, 0, 0, '', '2016-10-27 07:23:44'),
(2468, 100080, 0, 0, '', '2016-10-27 07:23:45'),
(2469, 100080, 0, 0, '', '2016-10-27 07:29:10'),
(2470, 100080, 0, 0, '', '2016-10-27 07:29:10'),
(2500, 100081, 0, 0, '', '2016-10-27 07:33:24'),
(2501, 100081, 0, 0, '', '2016-10-27 07:33:25'),
(2504, 100081, 0, 0, '', '2016-10-27 07:33:25'),
(2508, 100081, 0, 0, '', '2016-10-27 07:33:27'),
(2514, 100081, 0, 0, '', '2016-10-27 07:33:27'),
(2517, 100081, 0, 0, '', '2016-10-27 07:33:28'),
(2518, 100081, 0, 0, '', '2016-10-27 07:33:28'),
(2520, 100081, 0, 0, '', '2016-10-27 07:33:29'),
(2521, 100081, 0, 0, '', '2016-10-27 07:33:29'),
(2522, 100081, 0, 0, '', '2016-10-27 07:33:29'),
(2523, 100081, 0, 0, '', '2016-10-27 07:33:29'),
(2556, 100000, 0, 0, '', '2016-11-02 14:59:17'),
(2558, 100000, 0, 0, '', '2016-11-02 14:59:17'),
(2560, 100000, 0, 0, '', '2016-11-02 14:59:43'),
(2572, 100082, 0, 0, '', '2016-11-02 15:12:24'),
(2576, 100001, 0, 0, '', '2016-11-16 03:40:55'),
(2578, 100000, 0, 0, '', '2016-11-16 03:45:48'),
(2675, 100081, 0, 0, '', '2016-11-26 16:20:36'),
(2710, 100085, 0, 0, '', '2016-12-09 06:01:33'),
(2713, 100086, 0, 0, '', '2016-12-09 06:21:59'),
(3073, 100087, 0, 0, '', '2016-12-13 04:23:33'),
(3080, 100087, 0, 0, '', '2016-12-13 04:23:33'),
(3081, 100087, 0, 0, '', '2016-12-13 04:23:33'),
(3082, 100087, 0, 0, '', '2016-12-13 04:23:33'),
(3083, 100087, 0, 0, '', '2016-12-13 04:23:33'),
(3107, 100087, 0, 0, '', '2016-12-13 04:24:22'),
(3156, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3162, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3163, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3164, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3165, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3166, 100088, 0, 0, '', '2016-12-13 04:30:46'),
(3253, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3258, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3259, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3260, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3261, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3262, 100089, 0, 0, '', '2016-12-13 05:02:44'),
(3284, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3290, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3291, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3292, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3293, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3294, 100092, 0, 0, '', '2016-12-13 06:28:19'),
(3441, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3442, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3443, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3455, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3456, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3457, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3458, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3459, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3460, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3461, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3462, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3463, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3468, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3469, 100094, 0, 0, '', '2016-12-13 06:44:37'),
(3538, 100098, 0, 0, '', '2016-12-14 04:44:12'),
(3541, 100099, 0, 0, '', '2016-12-20 05:52:01'),
(3548, 100099, 0, 0, '', '2016-12-20 05:52:01'),
(3703, 100105, 0, 0, '', '2017-01-23 16:37:16'),
(3704, 100105, 0, 0, '', '2017-01-26 02:56:08'),
(3708, 100000, 0, 0, '', '2017-02-07 04:16:29'),
(3709, 100000, 0, 0, '', '2017-02-07 04:16:29'),
(3710, 100000, 0, 0, '', '2017-02-07 04:16:29'),
(3711, 100000, 0, 0, '', '2017-02-07 04:24:35'),
(3712, 100000, 0, 0, '', '2017-02-07 04:24:35'),
(3713, 100000, 0, 0, '', '2017-02-07 04:24:35'),
(3714, 100107, 0, 0, '', '2017-02-13 00:04:32'),
(3720, 100079, 0, 0, '', '2017-02-13 00:24:23'),
(3723, 100079, 0, 0, '', '2017-02-13 00:24:36'),
(3726, 100079, 0, 0, '', '2017-02-13 00:25:08'),
(3729, 100079, 0, 0, '', '2017-02-13 00:25:21'),
(3732, 100079, 0, 0, '', '2017-02-13 01:35:50'),
(3735, 100108, 0, 0, '', '2017-02-13 01:46:50'),
(3736, 100001, 0, 0, '', '2017-02-15 00:29:30'),
(3737, 100001, 0, 0, '', '2017-02-15 00:30:47'),
(3744, 100086, 0, 0, '', '2017-02-16 17:48:48'),
(3745, 100001, 0, 0, '', '2017-02-16 17:50:54'),
(3746, 100084, 0, 0, '', '2017-02-16 17:51:08'),
(3747, 100095, 0, 0, '', '2017-02-16 17:51:21'),
(3748, 100109, 0, 0, '', '2017-02-21 09:04:24'),
(3749, 100110, 0, 0, '', '2017-02-21 09:32:06'),
(3750, 100111, 0, 0, '', '2017-02-21 09:42:12'),
(3753, 100086, 0, 0, '', '2017-02-21 13:14:33'),
(3754, 100086, 0, 0, '', '2017-02-21 13:14:33'),
(3755, 100086, 0, 0, '', '2017-02-21 13:14:33'),
(3756, 100000, 0, 0, '', '2017-02-21 04:36:17'),
(3759, 100000, 0, 0, '', '2017-02-21 04:40:18'),
(3764, 100112, 0, 0, '', '2017-02-22 06:04:25'),
(3767, 100112, 0, 0, '', '2017-02-22 06:04:25'),
(3770, 100112, 0, 0, '', '2017-02-22 06:04:25'),
(3772, 100112, 0, 0, '', '2017-02-22 06:04:25'),
(3786, 100112, 0, 0, '', '2017-02-22 06:04:25'),
(3789, 100112, 0, 0, '', '2017-02-22 06:17:10'),
(3795, 100079, 0, 0, '', '2017-02-23 10:13:22'),
(3799, 100000, 1, 0, '', '2017-03-01 07:51:20'),
(3838, 100122, 0, 0, '', '2017-03-10 04:54:22'),
(3850, 100123, 0, 0, '', '2017-03-10 04:54:22'),
(3860, 100123, 0, 0, '', '2017-03-10 04:54:22'),
(3873, 100124, 0, 0, '', '2017-03-10 05:41:08'),
(3885, 100124, 0, 0, '', '2017-03-10 05:41:08'),
(3888, 100124, 0, 0, '', '2017-03-10 05:41:08'),
(3894, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3895, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3896, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3900, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3902, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3904, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3905, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3906, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3907, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3908, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3909, 100124, 0, 0, '', '2017-03-31 15:35:04'),
(3925, 100126, 0, 0, '', '2017-03-31 19:10:02'),
(3926, 100126, 0, 0, '', '2017-03-31 19:10:02'),
(3931, 100126, 0, 0, '', '2017-03-31 19:10:02'),
(3933, 100126, 0, 0, '', '2017-03-31 19:10:02'),
(3934, 100126, 0, 0, '', '2017-03-31 19:10:02'),
(3943, 100127, 0, 0, '', '2017-04-01 11:55:53'),
(3945, 100127, 0, 0, '', '2017-04-01 11:55:53'),
(3946, 100127, 0, 0, '', '2017-04-01 11:55:53'),
(3956, 100128, 0, 0, '', '2017-04-01 12:05:06'),
(3957, 100128, 0, 0, '', '2017-04-01 12:05:06'),
(3973, 100105, 0, 0, '', '2017-04-01 14:01:41'),
(3974, 100105, 0, 0, '', '2017-04-01 14:02:10'),
(3989, 100105, 0, 0, '', '2017-04-01 14:02:46'),
(4009, 100105, 0, 0, '', '2017-04-01 14:03:05'),
(4012, 100105, 0, 0, '', '2017-04-01 14:03:05'),
(4013, 100129, 0, 0, '', '2017-04-03 08:47:37'),
(4014, 100130, 0, 0, '', '2017-04-03 08:50:02'),
(4017, 100131, 0, 0, '', '2017-04-03 08:53:21'),
(4021, 100131, 0, 0, '', '2017-04-03 08:53:21'),
(4027, 100131, 0, 0, '', '2017-04-03 08:53:22'),
(4030, 100128, 0, 0, '', '2017-04-03 13:24:48'),
(4045, 100128, 0, 0, '', '2017-04-03 13:24:48'),
(4046, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4047, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4048, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4049, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4050, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4056, 100132, 0, 0, '', '2017-04-03 13:28:00'),
(4072, 100132, 0, 0, '', '2017-04-03 13:34:41'),
(4075, 100133, 0, 0, '', '2017-04-04 15:17:50'),
(4078, 100133, 0, 0, '', '2017-04-04 15:17:50'),
(4080, 100133, 0, 0, '', '2017-04-04 15:17:50'),
(4081, 100133, 0, 0, '', '2017-04-04 15:17:50'),
(4086, 100133, 0, 0, '', '2017-04-04 15:17:50'),
(4087, 100134, 0, 0, '', '2017-04-06 06:52:29'),
(4088, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4089, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4090, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4091, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4092, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4099, 100135, 0, 0, '', '2017-04-06 07:06:02'),
(4100, 100086, 2, 0, '', '2017-04-06 07:45:24');

-- --------------------------------------------------------

--
-- Table structure for table `file_categories`
--

CREATE TABLE `file_categories` (
  `FileCategoryID` int(21) NOT NULL,
  `FileCategoryName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FileCategoryDescription` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `file_categories`
--

INSERT INTO `file_categories` (`FileCategoryID`, `FileCategoryName`, `FileCategoryDescription`) VALUES
(1, 'Marketing Materials', ''),
(2, 'Important Forms', ''),
(3, 'Investment Reports', ''),
(4, 'Others', '');

-- --------------------------------------------------------

--
-- Table structure for table `file_items`
--

CREATE TABLE `file_items` (
  `FileItemID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `FileID` int(21) NOT NULL,
  `FileDescription` varchar(64) CHARACTER SET utf8 NOT NULL,
  `FileName` text CHARACTER SET utf8 NOT NULL,
  `FileNameC` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FilePath` text CHARACTER SET utf8 NOT NULL,
  `FileSlug` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `file_items`
--

INSERT INTO `file_items` (`FileItemID`, `UserID`, `FileID`, `FileDescription`, `FileName`, `FileNameC`, `FilePath`, `FileSlug`, `Active`) VALUES
(15, 100000, 11, 'Avatar', '656ea727_trio.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\02\\656ea727_trio.jpg', '/2016/09/02/656ea727_trio.jpg', 1),
(16, 100000, 12, 'Avatar', '3ddab30d_web.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\02\\3ddab30d_web.jpg', '/2016/09/02/3ddab30d_web.jpg', 1),
(17, 100000, 13, 'Avatar', 'cd5601a2_portrait.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\02\\cd5601a2_portrait.jpg', '/2016/09/02/cd5601a2_portrait.jpg', 1),
(19, 100000, 15, 'Avatar', '89fb1c13_charcoal.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\02\\89fb1c13_charcoal.jpg', '/2016/09/02/89fb1c13_charcoal.jpg', 1),
(29, 100047, 175, 'UBOGift', 'c449ddc2_banner.png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\05\\c449ddc2_banner.png', '/2016/09/05/c449ddc2_banner.png', 0),
(34, 100048, 202, 'UBOEmploymentIncome', 'cff6e379_profile.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\05\\cff6e379_profile.jpg', '/2016/09/05/cff6e379_profile.jpg', 1),
(39, 100049, 233, 'UBOEmploymentIncome', '87f3097c_profile.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\05\\87f3097c_profile.jpg', '/2016/09/05/87f3097c_profile.jpg', 2),
(49, 100049, 696, 'IAPhotoid', 'ed7431fa_sevices2.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\default\\assets\\files\\2016\\09\\06\\ed7431fa_sevices2.jpg', '/2016/09/06/ed7431fa_sevices2.jpg', 0),
(52, 100001, 751, 'Avatar', 'e6534338_odeonlogo.PNG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/09/08/e6534338_odeonlogo.PNG', '/2016/09/08/e6534338_odeonlogo.PNG', 0),
(54, 100052, 786, 'UBOEmploymentIncome', '6c634e96_é•·æ¦®è²´è³“å¡.png', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/09/23/6c634e96_é•·æ¦®è²´è³“å¡.png', '/2016/09/23/6c634e96_é•·æ¦®è²´è³“å¡.png', 0),
(55, 100053, 817, 'UBOEmploymentIncome', 'd0deca89_é•·æ¦®è²´è³“å¡.png', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/09/23/d0deca89_é•·æ¦®è²´è³“å¡.png', '/2016/09/23/d0deca89_é•·æ¦®è²´è³“å¡.png', 0),
(56, 100054, 848, 'UBOEmploymentIncome', 'efabf705_é•·æ¦®è²´è³“å¡.png', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/09/24/efabf705_é•·æ¦®è²´è³“å¡.png', '/2016/09/24/efabf705_é•·æ¦®è²´è³“å¡.png', 0),
(61, 100060, 1477, 'UBOEmploymentIncome', '8f0b4dc5_é•·æ¦®è²´è³“å¡.png', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/09/28/8f0b4dc5_é•·æ¦®è²´è³“å¡.png', '/2016/09/28/8f0b4dc5_é•·æ¦®è²´è³“å¡.png', 0),
(64, 100065, 1588, 'UBOOther', '33e698ac_BankAcc_01a.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/33e698ac_BankAcc_01a.jpg', '/2016/10/08/33e698ac_BankAcc_01a.jpg', 1),
(65, 100065, 1588, 'UBOOther', '88b51028_BankAcc_01b.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/88b51028_BankAcc_01b.jpg', '/2016/10/08/88b51028_BankAcc_01b.jpg', 1),
(66, 100065, 1588, 'UBOOther', '61a02b9e_LL.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/61a02b9e_LL.JPG', '/2016/10/08/61a02b9e_LL.JPG', 1),
(67, 100065, 1589, 'IAPhotoid', 'a10440b8_Passport_01.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/a10440b8_Passport_01.jpg', '/2016/10/08/a10440b8_Passport_01.jpg', 1),
(68, 100065, 1590, 'IAProofresidency', '44645e9f_MasterCard_01.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/44645e9f_MasterCard_01.jpg', '/2016/10/08/44645e9f_MasterCard_01.jpg', 1),
(69, 100065, 1591, 'IABankstatement', 'f39050d8_BankAcc_01a.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/f39050d8_BankAcc_01a.jpg', '/2016/10/08/f39050d8_BankAcc_01a.jpg', 1),
(70, 100065, 1591, 'IABankstatement', '038d2657_BankAcc_01b.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/038d2657_BankAcc_01b.jpg', '/2016/10/08/038d2657_BankAcc_01b.jpg', 1),
(71, 100065, 1591, 'IABankstatement', 'cb2310a4_LL.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/cb2310a4_LL.JPG', '/2016/10/08/cb2310a4_LL.JPG', 1),
(72, 100065, 1592, 'IASpecimensign', '05d5e85d_Sign_0120161008.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/05d5e85d_Sign_0120161008.jpg', '/2016/10/08/05d5e85d_Sign_0120161008.jpg', 1),
(73, 100065, 1593, 'IAProofOfPayment', '94310a57_BankReceipt_01b.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/94310a57_BankReceipt_01b.jpg', '/2016/10/08/94310a57_BankReceipt_01b.jpg', 2),
(74, 100065, 1593, 'IAProofOfPayment', '71d16019_BankReceipt_01a.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/08/71d16019_BankReceipt_01a.jpg', '/2016/10/08/71d16019_BankReceipt_01a.jpg', 1),
(75, 100066, 1618, 'UBOInheritance', 'c844b06d_MacBookReceipt.pdf', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/c844b06d_MacBookReceipt.pdf', '/2016/10/10/c844b06d_MacBookReceipt.pdf', 0),
(77, 100066, 1622, 'IAPhotoid', 'b570c29b_error.PNG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/b570c29b_error.PNG', '/2016/10/10/b570c29b_error.PNG', 0),
(78, 100067, 1648, 'UBOEmploymentIncome', '0246fd13_20160904-Book-HKD128.PDF', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/0246fd13_20160904-Book-HKD128.PDF', '/2016/10/10/0246fd13_20160904-Book-HKD128.PDF', 0),
(81, 100067, 1657, 'IABankstatement', '4936579b_20160904-Book-HKD128.PDF', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/4936579b_20160904-Book-HKD128.PDF', '/2016/10/10/4936579b_20160904-Book-HKD128.PDF', 0),
(82, 100067, 1658, 'IASpecimensign', '0c966119_20160904-Book-HKD128.PDF', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/0c966119_20160904-Book-HKD128.PDF', '/2016/10/10/0c966119_20160904-Book-HKD128.PDF', 0),
(83, 100067, 1659, 'IAProofOfPayment', '0bcb73ee_20160904-Book-HKD128.PDF', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/10/0bcb73ee_20160904-Book-HKD128.PDF', '/2016/10/10/0bcb73ee_20160904-Book-HKD128.PDF', 0),
(91, 100071, 2056, 'POACorporateSeal', '6690bfbb_11.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/6690bfbb_11.JPG', '/2016/10/24/6690bfbb_11.JPG', 0),
(93, 100071, 2060, 'UBOCommission', '3eab86bb_1.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/3eab86bb_1.jpg', '/2016/10/24/3eab86bb_1.jpg', 0),
(94, 100071, 2063, 'UBOGift', 'de375a88_HI4D4D_18B944F9DB6945428E0FDEC6E4B11B7C.pdf', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/de375a88_HI4D4D_18B944F9DB6945428E0FDEC6E4B11B7C.pdf', '/2016/10/24/de375a88_HI4D4D_18B944F9DB6945428E0FDEC6E4B11B7C.pdf', 0),
(97, 100071, 2078, 'CADirectorsid', '527d4b4f_11.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/527d4b4f_11.JPG', '/2016/10/24/527d4b4f_11.JPG', 0),
(100, 100072, 2127, 'UBOBusiness', '36972b4a_504810634370893849.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/36972b4a_504810634370893849.jpg', '/2016/10/24/36972b4a_504810634370893849.jpg', 0),
(101, 100072, 2127, 'UBOBusiness', 'bd88768c_516383187410999935.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/24/bd88768c_516383187410999935.jpg', '/2016/10/24/bd88768c_516383187410999935.jpg', 0),
(102, 100078, 2311, 'POACorporateSeal', '3928da59_167186290329325228.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/3928da59_167186290329325228.jpg', '/2016/10/26/3928da59_167186290329325228.jpg', 1),
(103, 100078, 2312, 'POADirectorSign', 'b7bf528b_390321346766419975.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/b7bf528b_390321346766419975.jpg', '/2016/10/26/b7bf528b_390321346766419975.jpg', 1),
(104, 100078, 2315, 'UBOBusiness', 'd0153927_516383187410999935.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/d0153927_516383187410999935.jpg', '/2016/10/26/d0153927_516383187410999935.jpg', 1),
(105, 100078, 2325, 'CACertincorporation', '3453ed84_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/3453ed84_124209.JPG', '/2016/10/26/3453ed84_124209.JPG', 1),
(106, 100078, 2328, 'CARegdirector', '913ace83_124515.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/913ace83_124515.JPG', '/2016/10/26/913ace83_124515.JPG', 0),
(107, 100078, 2332, 'CADirectorsid', '67af6e5e_135735.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/67af6e5e_135735.JPG', '/2016/10/26/67af6e5e_135735.JPG', 1),
(108, 100078, 2333, 'CACompanysign', '7d0ccc76_390321346766419975.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/7d0ccc76_390321346766419975.jpg', '/2016/10/26/7d0ccc76_390321346766419975.jpg', 1),
(109, 100078, 2338, 'CAProofOfPayment', 'd57133be_124600.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/26/d57133be_124600.JPG', '/2016/10/26/d57133be_124600.JPG', 1),
(110, 100078, 2396, 'CARecentfinancialstatement', '9e23b755_44563768.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/9e23b755_44563768.jpg', '/2016/10/27/9e23b755_44563768.jpg', 0),
(111, 100078, 2400, 'CADirectorsproof', 'ef054e5f_268576663.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/ef054e5f_268576663.jpg', '/2016/10/27/ef054e5f_268576663.jpg', 1),
(112, 100079, 2407, 'POACorporateSeal', '8569a2fe_CompanyStamp.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/8569a2fe_CompanyStamp.jpg', '/2016/10/27/8569a2fe_CompanyStamp.jpg', 0),
(113, 100079, 2408, 'POADirectorSign', 'f4fb3eb0_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/f4fb3eb0_Signature.jpg', '/2016/10/27/f4fb3eb0_Signature.jpg', 0),
(114, 100079, 2411, 'UBOBusiness', '07ecc003_bankStatement.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/07ecc003_bankStatement.jpg', '/2016/10/27/07ecc003_bankStatement.jpg', 0),
(115, 100079, 2415, 'UBOOther', '36227079_753002195.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/36227079_753002195.jpg', '/2016/10/27/36227079_753002195.jpg', 0),
(116, 100079, 2421, 'CACertincorporation', '036a23b3_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/036a23b3_124209.JPG', '/2016/10/27/036a23b3_124209.JPG', 0),
(117, 100079, 2424, 'CARegdirector', '1446d121_124515.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/1446d121_124515.JPG', '/2016/10/27/1446d121_124515.JPG', 0),
(118, 100079, 2425, 'CAProofbusadd', '458bce31_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/458bce31_124209.JPG', '/2016/10/27/458bce31_124209.JPG', 0),
(119, 100079, 2427, 'CARecentfinancialstatement', '29713d38_IncomeTax.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/29713d38_IncomeTax.jpg', '/2016/10/27/29713d38_IncomeTax.jpg', 0),
(120, 100079, 2428, 'CADirectorsid', '8553fcbc_Passport.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/8553fcbc_Passport.JPG', '/2016/10/27/8553fcbc_Passport.JPG', 0),
(121, 100079, 2429, 'CACompanysign', 'a9c9fb01_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/a9c9fb01_Signature.jpg', '/2016/10/27/a9c9fb01_Signature.jpg', 0),
(122, 100079, 2430, 'CAShareholders', '72684ec8_Shen,Jyun-LiangPassport.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/72684ec8_Shen,Jyun-LiangPassport.jpg', '/2016/10/27/72684ec8_Shen,Jyun-LiangPassport.jpg', 0),
(123, 100079, 2434, 'CAProofOfPayment', '1359e90f_124600.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/1359e90f_124600.JPG', '/2016/10/27/1359e90f_124600.JPG', 0),
(124, 100079, 2435, 'CAAuthorizedone', 'c3e4024f_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/c3e4024f_Signature.jpg', '/2016/10/27/c3e4024f_Signature.jpg', 0),
(125, 100079, 2437, 'CAAuthorizedthree', '96c07a53_æ²ˆä¿Šè‰¯signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/96c07a53_æ²ˆä¿Šè‰¯signature.jpg', '/2016/10/27/96c07a53_æ²ˆä¿Šè‰¯signature.jpg', 0),
(126, 100080, 2438, 'POACorporateSeal', '488fe1f9_CompanyStamp.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/488fe1f9_CompanyStamp.jpg', '/2016/10/27/488fe1f9_CompanyStamp.jpg', 0),
(127, 100080, 2439, 'POADirectorSign', '286825e7_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/286825e7_Signature.jpg', '/2016/10/27/286825e7_Signature.jpg', 0),
(128, 100080, 2442, 'UBOBusiness', '092e93a3_bankStatement.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/092e93a3_bankStatement.jpg', '/2016/10/27/092e93a3_bankStatement.jpg', 0),
(129, 100080, 2446, 'UBOOther', '909bfc5d_753002195.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/909bfc5d_753002195.jpg', '/2016/10/27/909bfc5d_753002195.jpg', 0),
(130, 100080, 2452, 'CACertincorporation', '8275bc67_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/8275bc67_124209.JPG', '/2016/10/27/8275bc67_124209.JPG', 0),
(131, 100080, 2455, 'CARegdirector', '1990e1ef_124515.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/1990e1ef_124515.JPG', '/2016/10/27/1990e1ef_124515.JPG', 0),
(132, 100080, 2456, 'CAProofbusadd', '633dcdf0_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/633dcdf0_124209.JPG', '/2016/10/27/633dcdf0_124209.JPG', 0),
(133, 100080, 2458, 'CARecentfinancialstatement', '35fdaaa3_IncomeTax.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/35fdaaa3_IncomeTax.jpg', '/2016/10/27/35fdaaa3_IncomeTax.jpg', 0),
(134, 100080, 2459, 'CADirectorsid', '8bee4c42_Passport.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/8bee4c42_Passport.JPG', '/2016/10/27/8bee4c42_Passport.JPG', 0),
(135, 100080, 2460, 'CACompanysign', '0b4e8839_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/0b4e8839_Signature.jpg', '/2016/10/27/0b4e8839_Signature.jpg', 0),
(136, 100080, 2461, 'CAShareholders', 'a15f482b_Shen,Jyun-LiangPassport.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/a15f482b_Shen,Jyun-LiangPassport.jpg', '/2016/10/27/a15f482b_Shen,Jyun-LiangPassport.jpg', 0),
(137, 100080, 2465, 'CAProofOfPayment', '858a75b6_124600.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/858a75b6_124600.JPG', '/2016/10/27/858a75b6_124600.JPG', 0),
(138, 100080, 2466, 'CAAuthorizedone', '558021b0_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/558021b0_Signature.jpg', '/2016/10/27/558021b0_Signature.jpg', 0),
(139, 100080, 2468, 'CAAuthorizedthree', 'c77d23e5_æ²ˆä¿Šè‰¯signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/c77d23e5_æ²ˆä¿Šè‰¯signature.jpg', '/2016/10/27/c77d23e5_æ²ˆä¿Šè‰¯signature.jpg', 0),
(140, 100080, 2469, 'POACorporateSeal', '7850242f_CompanyStamp.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/7850242f_CompanyStamp.jpg', '/2016/10/27/7850242f_CompanyStamp.jpg', 0),
(141, 100080, 2470, 'POADirectorSign', 'abd3f1d2_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/abd3f1d2_Signature.jpg', '/2016/10/27/abd3f1d2_Signature.jpg', 0),
(142, 100081, 2500, 'POACorporateSeal', 'a131333c_CompanyStamp.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/a131333c_CompanyStamp.jpg', '/2016/10/27/a131333c_CompanyStamp.jpg', 0),
(143, 100081, 2501, 'POADirectorSign', '56748318_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/56748318_Signature.jpg', '/2016/10/27/56748318_Signature.jpg', 0),
(144, 100081, 2504, 'UBOBusiness', '5e21e907_bankStatement.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/5e21e907_bankStatement.jpg', '/2016/10/27/5e21e907_bankStatement.jpg', 0),
(145, 100081, 2508, 'UBOOther', 'a7e43362_753002195.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/a7e43362_753002195.jpg', '/2016/10/27/a7e43362_753002195.jpg', 0),
(146, 100081, 2514, 'CACertincorporation', '122b1e9e_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/122b1e9e_124209.JPG', '/2016/10/27/122b1e9e_124209.JPG', 0),
(147, 100081, 2517, 'CARegdirector', '279eb511_124515.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/279eb511_124515.JPG', '/2016/10/27/279eb511_124515.JPG', 0),
(148, 100081, 2518, 'CAProofbusadd', '1f5504f9_124209.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/1f5504f9_124209.JPG', '/2016/10/27/1f5504f9_124209.JPG', 0),
(149, 100081, 2520, 'CARecentfinancialstatement', '4b582cbb_IncomeTax.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/4b582cbb_IncomeTax.jpg', '/2016/10/27/4b582cbb_IncomeTax.jpg', 0),
(150, 100081, 2521, 'CADirectorsid', '4c37e59a_Passport.JPG', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/4c37e59a_Passport.JPG', '/2016/10/27/4c37e59a_Passport.JPG', 0),
(151, 100081, 2522, 'CACompanysign', '58739354_Signature.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/58739354_Signature.jpg', '/2016/10/27/58739354_Signature.jpg', 0),
(152, 100081, 2523, 'CAShareholders', 'e194396a_Shen,Jyun-LiangPassport.jpg', '', '/home/odeonco/public_html/portal/app/views/default/assets/files/2016/10/27/e194396a_Shen,Jyun-LiangPassport.jpg', '/2016/10/27/e194396a_Shen,Jyun-LiangPassport.jpg', 0),
(153, 100000, 2556, 'favicon', '4c419d67_logo-s.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/11/02/4c419d67_logo-s.png', '/2016/11/02/4c419d67_logo-s.png', 0),
(154, 100000, 2558, 'site_logo_small', 'bccb65b9_logo-s.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/11/02/bccb65b9_logo-s.png', '/2016/11/02/bccb65b9_logo-s.png', 0),
(155, 100000, 2560, 'site_logo', '3fb364c5_logo.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/11/02/3fb364c5_logo.png', '/2016/11/02/3fb364c5_logo.png', 0),
(159, 100082, 2572, 'IAProofresidency', '667e7394_5.jpg', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/11/02/667e7394_5.jpg', '/2016/11/02/667e7394_5.jpg', 0),
(162, 100001, 2576, 'Avatar', '43bbc74c_odeonlogo.PNG', '', 'C:\\xampp\\htdocs\\odeonco.loc\\app\\views\\odeon\\assets\\files\\2016\\11\\16\\43bbc74c_odeonlogo.PNG', '/2016/11/16/43bbc74c_odeonlogo.PNG', 0),
(164, 100000, 2578, 'Avatar', '6f192427_charcoal.jpg', '', 'C:\\xampp\\htdocs\\odeonco.loc\\app\\views\\odeon\\assets\\files\\2016\\11\\16\\6f192427_charcoal.jpg', '/2016/11/16/6f192427_charcoal.jpg', 0),
(165, 100081, 2675, 'Avatar', '1818be63_JeffProfile.jpg', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/11/26/1818be63_JeffProfile.jpg', '/2016/11/26/1818be63_JeffProfile.jpg', 0),
(166, 100085, 2710, 'CompanyDocument', 'e8d214c6_s.png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\odeon\\assets\\files\\2016\\12\\09\\e8d214c6_s.png', '/2016/12/09/e8d214c6_s.png', 0),
(167, 100086, 2713, 'CompanyDocument', '78d3fa0e_2.png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\odeonco\\app\\views\\odeon\\assets\\files\\2016\\12\\09\\78d3fa0e_2.png', '/2016/12/09/78d3fa0e_2.png', 0),
(168, 100087, 3073, 'UBOEmploymentIncome', '09e1db3d_n.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/09e1db3d_n.JPG', '/2016/12/13/09e1db3d_n.JPG', 0),
(169, 100087, 3080, 'IAPhotoid', 'fa553656_s.jpg', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/fa553656_s.jpg', '/2016/12/13/fa553656_s.jpg', 0),
(170, 100087, 3081, 'IAProofresidency', 'df2e9881_s.jpg', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/df2e9881_s.jpg', '/2016/12/13/df2e9881_s.jpg', 0),
(171, 100087, 3082, 'IABankstatement', '73ce1b8d_1.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/73ce1b8d_1.png', '/2016/12/13/73ce1b8d_1.png', 0),
(172, 100087, 3083, 'IASpecimensign', '1976b560_1.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/1976b560_1.png', '/2016/12/13/1976b560_1.png', 0),
(173, 100087, 3107, 'IAProofOfPayment', '8d66412d_1.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/8d66412d_1.png', '/2016/12/13/8d66412d_1.png', 0),
(174, 100088, 3156, 'UBOCommission', '93680e5a_1.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/93680e5a_1.png', '/2016/12/13/93680e5a_1.png', 0),
(175, 100088, 3162, 'IAPhotoid', '2afeefb1_7.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/2afeefb1_7.PDF', '/2016/12/13/2afeefb1_7.PDF', 0),
(176, 100088, 3163, 'IAProofresidency', '8e7e5ed4_7.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/8e7e5ed4_7.PDF', '/2016/12/13/8e7e5ed4_7.PDF', 0),
(177, 100088, 3164, 'IABankstatement', '6c7ec948_7.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/6c7ec948_7.PDF', '/2016/12/13/6c7ec948_7.PDF', 0),
(178, 100088, 3165, 'IASpecimensign', '40954346_4.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/40954346_4.PDF', '/2016/12/13/40954346_4.PDF', 0),
(179, 100088, 3166, 'IAProofOfPayment', '3777ce51_4.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/3777ce51_4.PDF', '/2016/12/13/3777ce51_4.PDF', 0),
(180, 100089, 3253, 'UBOBusiness', 'ef2694d6_1.png', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/ef2694d6_1.png', '/2016/12/13/ef2694d6_1.png', 0),
(181, 100089, 3258, 'IAPhotoid', 'f103fadc_0.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/f103fadc_0.JPG', '/2016/12/13/f103fadc_0.JPG', 0),
(182, 100089, 3259, 'IAProofresidency', 'e5724de2_0.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/e5724de2_0.JPG', '/2016/12/13/e5724de2_0.JPG', 0),
(183, 100089, 3260, 'IABankstatement', '8462dac2_0.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/8462dac2_0.JPG', '/2016/12/13/8462dac2_0.JPG', 0),
(184, 100089, 3261, 'IASpecimensign', '6c46776a_0.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/6c46776a_0.JPG', '/2016/12/13/6c46776a_0.JPG', 0),
(185, 100089, 3262, 'IAProofOfPayment', 'dc0a108e_0.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/dc0a108e_0.JPG', '/2016/12/13/dc0a108e_0.JPG', 0),
(186, 100092, 3284, 'UBOCommission', 'b3322bd3_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/b3322bd3_9.JPG', '/2016/12/13/b3322bd3_9.JPG', 0),
(187, 100092, 3290, 'IAPhotoid', 'e0dec74b_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/e0dec74b_9.JPG', '/2016/12/13/e0dec74b_9.JPG', 0),
(188, 100092, 3291, 'IAProofresidency', 'ea1321bf_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/ea1321bf_9.JPG', '/2016/12/13/ea1321bf_9.JPG', 0),
(189, 100092, 3292, 'IABankstatement', '84b99d2d_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/84b99d2d_9.JPG', '/2016/12/13/84b99d2d_9.JPG', 0),
(190, 100092, 3293, 'IASpecimensign', 'e0e4a9f4_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/e0e4a9f4_9.JPG', '/2016/12/13/e0e4a9f4_9.JPG', 0),
(191, 100092, 3294, 'IAProofOfPayment', '4b74e03c_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/4b74e03c_9.JPG', '/2016/12/13/4b74e03c_9.JPG', 0),
(192, 100094, 3441, 'POACorporateSeal', 'afa19c5c_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/afa19c5c_9.JPG', '/2016/12/13/afa19c5c_9.JPG', 0),
(193, 100094, 3442, 'POADirectorSign', 'b53634a1_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/b53634a1_9.JPG', '/2016/12/13/b53634a1_9.JPG', 0),
(194, 100094, 3443, 'UBOEmploymentIncome', '40c730c3_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/40c730c3_3.PDF', '/2016/12/13/40c730c3_3.PDF', 0),
(195, 100094, 3455, 'CACertincorporation', 'ed6c8488_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/ed6c8488_3.PDF', '/2016/12/13/ed6c8488_3.PDF', 0),
(196, 100094, 3456, 'CANamechange', 'ba2cc52e_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/ba2cc52e_3.PDF', '/2016/12/13/ba2cc52e_3.PDF', 0),
(197, 100094, 3457, 'CAGoodstand', 'a15ef3db_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/a15ef3db_3.PDF', '/2016/12/13/a15ef3db_3.PDF', 0),
(198, 100094, 3458, 'CARegdirector', '1ae1ed67_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/1ae1ed67_3.PDF', '/2016/12/13/1ae1ed67_3.PDF', 0),
(199, 100094, 3459, 'CAProofbusadd', '839e4275_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/839e4275_3.PDF', '/2016/12/13/839e4275_3.PDF', 0),
(200, 100094, 3460, 'CAMemorandumaa', '43af30b2_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/43af30b2_3.PDF', '/2016/12/13/43af30b2_3.PDF', 0),
(201, 100094, 3461, 'CARecentfinancialstatement', 'd3f88715_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/d3f88715_3.PDF', '/2016/12/13/d3f88715_3.PDF', 0),
(202, 100094, 3462, 'CADirectorsid', '44fa9b51_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/44fa9b51_3.PDF', '/2016/12/13/44fa9b51_3.PDF', 0),
(203, 100094, 3463, 'CACompanysign', '96b0245e_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/96b0245e_9.JPG', '/2016/12/13/96b0245e_9.JPG', 0),
(204, 100094, 3468, 'CAProofOfPayment', '417d535c_3.PDF', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/417d535c_3.PDF', '/2016/12/13/417d535c_3.PDF', 0),
(205, 100094, 3469, 'CAAuthorizedone', '5042b3d4_9.JPG', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/13/5042b3d4_9.JPG', '/2016/12/13/5042b3d4_9.JPG', 0),
(207, 100098, 3538, 'CompanyDocument', '6eba121e_6.pdf', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/14/6eba121e_6.pdf', '/2016/12/14/6eba121e_6.pdf', 0),
(208, 100099, 3541, 'UBOEmploymentIncome', '82e36fe2_P.pdf', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/20/82e36fe2_P.pdf', '/2016/12/20/82e36fe2_P.pdf', 0),
(209, 100099, 3548, 'IAPhotoid', '3edf85f9_P.pdf', '', '/home/odeonco/public_html/portal/app/views/odeon/assets/files/2016/12/20/3edf85f9_P.pdf', '/2016/12/20/3edf85f9_P.pdf', 0),
(210, 100105, 3703, 'IASpecimensign', 'testinga_account1_iaspecimensign_1d228db6.png', '', '/home/gaskylight/public_html/portal/app/views/odeon/assets/files/2017/01/23/testinga_account1_iaspecimensign_1d228db6.png', '/2017/01/23/testinga_account1_iaspecimensign_1d228db6.png', 1),
(211, 100105, 3704, 'IAPhotoid', 'testinga_account1_iaphotoid_2.jpg', '', '/home/gaskylight/public_html/portal/app/views/odeon/assets/files/2017/01/26/testinga_account1_iaphotoid_2.jpg', '/2017/01/26/testinga_account1_iaphotoid_2.jpg', 0),
(212, 100000, 3708, 'favicon', 'moises_goloyugo_favicon_logo-s.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_favicon_logo-s.png', '/2017/02/07/moises_goloyugo_favicon_logo-s.png', 0),
(213, 100000, 3709, 'site_logo', 'moises_goloyugo_site_logo_logo2.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_site_logo_logo2.png', '/2017/02/07/moises_goloyugo_site_logo_logo2.png', 0),
(214, 100000, 3710, 'site_logo_small', 'moises_goloyugo_site_logo_small_logo-s.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_site_logo_small_logo-s.png', '/2017/02/07/moises_goloyugo_site_logo_small_logo-s.png', 0),
(215, 100000, 3711, 'favicon', 'moises_goloyugo_favicon_logo-s.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_favicon_logo-s.png', '/2017/02/07/moises_goloyugo_favicon_logo-s.png', 0),
(216, 100000, 3712, 'site_logo', 'moises_goloyugo_site_logo_logo2.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_site_logo_logo2.png', '/2017/02/07/moises_goloyugo_site_logo_logo2.png', 0),
(217, 100000, 3713, 'site_logo_small', 'moises_goloyugo_site_logo_small_logo.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\views\\odeon\\assets\\files\\2017\\02\\07\\moises_goloyugo_site_logo_small_logo.png', '/2017/02/07/moises_goloyugo_site_logo_small_logo.png', 0),
(218, 100107, 3714, 'PhotoId', 'testing1_2_photoid_4.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/testing1_2_photoid_4.png', '/2017/02/13/testing1_2_photoid_4.png', 0),
(219, 100079, 3720, 'PhotoId', 'chris_chua_photoid_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/chris_chua_photoid_1.png', '/2017/02/13/chris_chua_photoid_1.png', 0),
(220, 100079, 3723, 'PhotoId', 'chris_chua_photoid_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/chris_chua_photoid_1.png', '/2017/02/13/chris_chua_photoid_1.png', 0),
(221, 100079, 3726, 'PhotoId', 'chris_chua_photoid_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/chris_chua_photoid_1.png', '/2017/02/13/chris_chua_photoid_1.png', 0),
(222, 100079, 3729, 'PhotoId', 'chris_chua_photoid_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/chris_chua_photoid_1.png', '/2017/02/13/chris_chua_photoid_1.png', 0),
(223, 100079, 3732, 'PhotoId', 'chris_chua_photoid_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/chris_chua_photoid_1.png', '/2017/02/13/chris_chua_photoid_1.png', 0),
(224, 100108, 3735, 'CompanyDocument', 'abc_abc_companydocument_1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/13/abc_abc_companydocument_1.png', '/2017/02/13/abc_abc_companydocument_1.png', 0),
(225, 100001, 3736, 'Avatar', 'globalassets_trust_avatar_moises_goloyugo_site_logo_logo2[1].png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\globalassetinc\\app\\globalassets\\views\\assets\\files\\2017\\02\\15\\globalassets_trust_avatar_moises_goloyugo_site_logo_logo2[1].png', '/2017/02/15/globalassets_trust_avatar_moises_goloyugo_site_logo_logo2[1].png', 0),
(226, 100001, 3737, 'Avatar', 'globalassets_trust_avatar_moises_goloyugo_favicon_logo-s.png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\globalassetinc\\app\\globalassets\\views\\assets\\files\\2017\\02\\15\\globalassets_trust_avatar_moises_goloyugo_favicon_logo-s.png', '/2017/02/15/globalassets_trust_avatar_moises_goloyugo_favicon_logo-s.png', 0),
(232, 100086, 3744, 'Avatar', 'ryan_dumajil_avatar_ryan.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/ryan_dumajil_avatar_ryan.jpg', '/2017/02/16/ryan_dumajil_avatar_ryan.jpg', 0),
(233, 100001, 3745, 'Avatar', 'globalassets_trust_avatar_user.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/globalassets_trust_avatar_user.png', '/2017/02/16/globalassets_trust_avatar_user.png', 0),
(234, 100084, 3746, 'Avatar', 'globalassets_core_avatar_user.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/globalassets_core_avatar_user.png', '/2017/02/16/globalassets_core_avatar_user.png', 0),
(235, 100095, 3747, 'Avatar', 'sy_yap_avatar_user.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/sy_yap_avatar_user.png', '/2017/02/16/sy_yap_avatar_user.png', 0),
(236, 100109, 3748, 'Avatar', 'jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/21/jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', '/2017/02/21/jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', 0),
(237, 100110, 3749, 'CompanyDocument', 'jeff_goh_companydocument_1.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/21/jeff_goh_companydocument_1.pdf', '/2017/02/21/jeff_goh_companydocument_1.pdf', 1),
(238, 100111, 3750, 'PhotoId', 'weihao_lee_photoid_.jpeg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/21/weihao_lee_photoid_.jpeg', '/2017/02/21/weihao_lee_photoid_.jpeg', 1),
(239, 100086, 3753, 'favicon', 'ryan_dumajil_favicon_logo-s.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\globalassets\\views\\assets\\files\\2017\\02\\21\\ryan_dumajil_favicon_logo-s.png', '/2017/02/21/ryan_dumajil_favicon_logo-s.png', 0),
(240, 100086, 3754, 'site_logo', 'ryan_dumajil_site_logo_logo2.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\globalassets\\views\\assets\\files\\2017\\02\\21\\ryan_dumajil_site_logo_logo2.png', '/2017/02/21/ryan_dumajil_site_logo_logo2.png', 0),
(241, 100086, 3755, 'site_logo_small', 'ryan_dumajil_site_logo_small_logo2.png', '', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\globalassets\\views\\assets\\files\\2017\\02\\21\\ryan_dumajil_site_logo_small_logo2.png', '/2017/02/21/ryan_dumajil_site_logo_small_logo2.png', 0),
(242, 100000, 3756, 'favicon', 'moises_goloyugo_favicon_ga_favicon.jpg', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\globalassetinc\\app\\globalassets\\views\\assets\\files\\2017\\02\\21\\moises_goloyugo_favicon_ga_favicon.jpg', '/2017/02/21/moises_goloyugo_favicon_ga_favicon.jpg', 0),
(243, 100000, 3759, 'favicon', 'moises_goloyugo_favicon_logo-s.png', '', 'C:\\Bitnami\\wamp\\apache2\\htdocs\\globalassetinc\\app\\globalassets\\views\\assets\\files\\2017\\02\\21\\moises_goloyugo_favicon_logo-s.png', '/2017/02/21/moises_goloyugo_favicon_logo-s.png', 0),
(244, 100112, 3764, 'UBOCommission', 'hao_hao_ubocommission_8.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_ubocommission_8.pdf', '/2017/02/22/hao_hao_ubocommission_8.pdf', 0),
(245, 100112, 3767, 'UBOGift', 'hao_hao_ubogift_4.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_ubogift_4.pdf', '/2017/02/22/hao_hao_ubogift_4.pdf', 0),
(246, 100112, 3770, 'IAPhotoid', 'hao_hao_iaphotoid_1.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_iaphotoid_1.pdf', '/2017/02/22/hao_hao_iaphotoid_1.pdf', 1),
(247, 100112, 3772, 'IABankstatement', 'hao_hao_iabankstatement_1.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_iabankstatement_1.pdf', '/2017/02/22/hao_hao_iabankstatement_1.pdf', 0),
(248, 100112, 3786, 'IASpecimensign', 'hao_hao_iaspecimensign_a10d6cfa.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_iaspecimensign_a10d6cfa.png', '/2017/02/22/hao_hao_iaspecimensign_a10d6cfa.png', 0),
(249, 100112, 3789, 'UBOBusiness', 'hao_hao_ubobusiness_4.pdf', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/22/hao_hao_ubobusiness_4.pdf', '/2017/02/22/hao_hao_ubobusiness_4.pdf', 0),
(250, 100079, 3795, 'Avatar', 'global_asset_avatar_logo-globalasset20.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/23/global_asset_avatar_logo-globalasset20.jpg', '/2017/02/23/global_asset_avatar_logo-globalasset20.jpg', 0),
(251, 100000, 3799, 'Ryan', 'Ryan_1.jpg', 'Ryan', '/home/gaspv/public_html/portal/app/globalassets/views/assets/files/downloads/2017/03/01/Ryan_1.jpg', '/2017/03/01/Ryan_1.jpg', 0),
(252, 100122, 3838, 'UBOEmploymentIncome', 'shanshan_lee_uboemploymentincome_0.pdf', 'UBOEmploymentIncome', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/shanshan_lee_uboemploymentincome_0.pdf', '/2017/03/10/shanshan_lee_uboemploymentincome_0.pdf', 0),
(253, 100123, 3850, 'UBOEmploymentIncome', 'shanshan_lee_uboemploymentincome_0.pdf', 'UBOEmploymentIncome', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/shanshan_lee_uboemploymentincome_0.pdf', '/2017/03/10/shanshan_lee_uboemploymentincome_0.pdf', 0),
(254, 100123, 3860, 'IAProofOfPayment', 'shanshan_lee_iaproofofpayment_2.bmp', 'IAProofOfPayment', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/shanshan_lee_iaproofofpayment_2.bmp', '/2017/03/10/shanshan_lee_iaproofofpayment_2.bmp', 0),
(255, 100124, 3873, 'POACorporateSeal', 'wenzhi_lee_poacorporateseal_2.bmp', 'POACorporateSeal', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/wenzhi_lee_poacorporateseal_2.bmp', '/2017/03/10/wenzhi_lee_poacorporateseal_2.bmp', 1),
(256, 100124, 3885, 'CACertincorporation', 'wenzhi_lee_cacertincorporation_2.bmp', 'CACertincorporation', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/wenzhi_lee_cacertincorporation_2.bmp', '/2017/03/10/wenzhi_lee_cacertincorporation_2.bmp', 1),
(257, 100124, 3888, 'CARegdirector', 'wenzhi_lee_caregdirector_4.jpg', 'CARegdirector', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/10/wenzhi_lee_caregdirector_4.jpg', '/2017/03/10/wenzhi_lee_caregdirector_4.jpg', 0),
(258, 100124, 3894, 'CANamechange', 'wenzhi_lee_canamechange_8.png', 'CANamechange', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_canamechange_8.png', '/2017/03/31/wenzhi_lee_canamechange_8.png', 0),
(259, 100124, 3895, 'CAGoodstand', 'wenzhi_lee_cagoodstand_8.png', 'CAGoodstand', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_cagoodstand_8.png', '/2017/03/31/wenzhi_lee_cagoodstand_8.png', 0),
(260, 100124, 3896, 'CARegdirector', 'wenzhi_lee_caregdirector_8.png', 'CARegdirector', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_caregdirector_8.png', '/2017/03/31/wenzhi_lee_caregdirector_8.png', 0),
(261, 100124, 3900, 'CADirectorsid', 'wenzhi_lee_cadirectorsid_8.png', 'CADirectorsid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_cadirectorsid_8.png', '/2017/03/31/wenzhi_lee_cadirectorsid_8.png', 1),
(262, 100124, 3902, 'CADirectorsproof', 'wenzhi_lee_cadirectorsproof_8.png', 'CADirectorsproof', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_cadirectorsproof_8.png', '/2017/03/31/wenzhi_lee_cadirectorsproof_8.png', 1),
(263, 100124, 3904, 'CACompanysign', 'wenzhi_lee_cacompanysign_b738a48d.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_cacompanysign_b738a48d.png', '/2017/03/31/wenzhi_lee_cacompanysign_b738a48d.png', 1),
(264, 100124, 3905, 'CACompanysignproof', 'wenzhi_lee_cacompanysignproof_9b345c86.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_cacompanysignproof_9b345c86.png', '/2017/03/31/wenzhi_lee_cacompanysignproof_9b345c86.png', 0),
(265, 100124, 3906, 'CAAuthorizedone', 'wenzhi_lee_caauthorizedone_4ddb47c7.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_caauthorizedone_4ddb47c7.png', '/2017/03/31/wenzhi_lee_caauthorizedone_4ddb47c7.png', 0),
(266, 100124, 3907, 'CAAuthorizedtwo', 'wenzhi_lee_caauthorizedtwo_2077fd63.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_caauthorizedtwo_2077fd63.png', '/2017/03/31/wenzhi_lee_caauthorizedtwo_2077fd63.png', 0),
(267, 100124, 3908, 'CAAuthorizedthree', 'wenzhi_lee_caauthorizedthree_81552ef4.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_caauthorizedthree_81552ef4.png', '/2017/03/31/wenzhi_lee_caauthorizedthree_81552ef4.png', 0),
(268, 100124, 3909, 'CAAuthorizedfour', 'wenzhi_lee_caauthorizedfour_b0c5c5d2.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/wenzhi_lee_caauthorizedfour_b0c5c5d2.png', '/2017/03/31/wenzhi_lee_caauthorizedfour_b0c5c5d2.png', 0),
(269, 100126, 3925, 'IABankstatement', 'testingacccount_asdasd_iabankstatement_.jpeg', 'IABankstatement', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/testingacccount_asdasd_iabankstatement_.jpeg', '/2017/03/31/testingacccount_asdasd_iabankstatement_.jpeg', 0),
(270, 100126, 3926, 'UBOEmploymentIncome', 'testingacccount_asdasd_uboemploymentincome_2.jpg', 'UBOEmploymentIncome', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/testingacccount_asdasd_uboemploymentincome_2.jpg', '/2017/03/31/testingacccount_asdasd_uboemploymentincome_2.jpg', 0),
(271, 100126, 3931, 'UBOSales', 'testingacccount_asdasd_ubosales_6.jpg', 'UBOSales', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/testingacccount_asdasd_ubosales_6.jpg', '/2017/03/31/testingacccount_asdasd_ubosales_6.jpg', 0),
(272, 100126, 3933, 'IASpecimensign', 'testingacccount_asdasd_iaspecimensign_d6c02eb5.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/testingacccount_asdasd_iaspecimensign_d6c02eb5.png', '/2017/03/31/testingacccount_asdasd_iaspecimensign_d6c02eb5.png', 0),
(273, 100126, 3934, 'SubsDecSignature', 'testingacccount_asdasd_subsdecsignature_6f654c3f.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/03/31/testingacccount_asdasd_subsdecsignature_6f654c3f.png', '/2017/03/31/testingacccount_asdasd_subsdecsignature_6f654c3f.png', 0),
(274, 100127, 3943, 'UBOSales', 'ghefssg_eryui_ubosales_2.jpg', 'UBOSales', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/ghefssg_eryui_ubosales_2.jpg', '/2017/04/01/ghefssg_eryui_ubosales_2.jpg', 0),
(275, 100127, 3945, 'IASpecimensign', 'ghefssg_eryui_iaspecimensign_7a200b96.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/ghefssg_eryui_iaspecimensign_7a200b96.png', '/2017/04/01/ghefssg_eryui_iaspecimensign_7a200b96.png', 0),
(276, 100127, 3946, 'SubsDecSignature', 'ghefssg_eryui_subsdecsignature_0d9fb167.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/ghefssg_eryui_subsdecsignature_0d9fb167.png', '/2017/04/01/ghefssg_eryui_subsdecsignature_0d9fb167.png', 0),
(277, 100128, 3956, 'IASpecimensign', 'ghefssg_eryui_iaspecimensign_9e23a203.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/ghefssg_eryui_iaspecimensign_9e23a203.png', '/2017/04/01/ghefssg_eryui_iaspecimensign_9e23a203.png', 0),
(278, 100128, 3957, 'SubsDecSignature', 'ghefssg_eryui_subsdecsignature_6a25e132.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/ghefssg_eryui_subsdecsignature_6a25e132.png', '/2017/04/01/ghefssg_eryui_subsdecsignature_6a25e132.png', 0),
(279, 100105, 3973, 'IASpecimensign', 'testinga_account1_iaspecimensign_6e1539a4.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/testinga_account1_iaspecimensign_6e1539a4.png', '/2017/04/01/testinga_account1_iaspecimensign_6e1539a4.png', 0),
(280, 100105, 3974, 'IAPhotoid', 'testinga_account1_iaphotoid_.jpeg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/testinga_account1_iaphotoid_.jpeg', '/2017/04/01/testinga_account1_iaphotoid_.jpeg', 0),
(281, 100105, 3989, 'IAPhotoid', 'testinga_account1_iaphotoid_5.jpg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/testinga_account1_iaphotoid_5.jpg', '/2017/04/01/testinga_account1_iaphotoid_5.jpg', 0),
(282, 100105, 4009, 'UBOSales', 'testinga_account1_ubosales_o.jpg', 'UBOSales', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/testinga_account1_ubosales_o.jpg', '/2017/04/01/testinga_account1_ubosales_o.jpg', 0),
(283, 100105, 4012, 'SubsDecSignature', 'testinga_account1_subsdecsignature_2dcca4e9.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/01/testinga_account1_subsdecsignature_2dcca4e9.png', '/2017/04/01/testinga_account1_subsdecsignature_2dcca4e9.png', 0),
(284, 100129, 4013, 'CompanyDocument', 'qweqweqw_wqeqwe_companydocument_o.jpg', 'CompanyDocument', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/qweqweqw_wqeqwe_companydocument_o.jpg', '/2017/04/03/qweqweqw_wqeqwe_companydocument_o.jpg', 0),
(285, 100130, 4014, 'PhotoId', 'louis_yap_photoid_7.jpg', 'PhotoId', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/louis_yap_photoid_7.jpg', '/2017/04/03/louis_yap_photoid_7.jpg', 0),
(286, 100131, 4017, 'IAPhotoid', 'weeliang_yap_iaphotoid_).png', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/weeliang_yap_iaphotoid_).png', '/2017/04/03/weeliang_yap_iaphotoid_).png', 0),
(287, 100131, 4021, 'UBOCommission', 'weeliang_yap_ubocommission_2.png', 'UBOCommission', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/weeliang_yap_ubocommission_2.png', '/2017/04/03/weeliang_yap_ubocommission_2.png', 0),
(288, 100131, 4027, 'IASpecimensign', 'weeliang_yap_iaspecimensign_01009c16.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/weeliang_yap_iaspecimensign_01009c16.png', '/2017/04/03/weeliang_yap_iaspecimensign_01009c16.png', 0),
(289, 100128, 4030, 'IAPhotoid', 'ghefssg_eryui_iaphotoid_o.jpg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/ghefssg_eryui_iaphotoid_o.jpg', '/2017/04/03/ghefssg_eryui_iaphotoid_o.jpg', 0),
(290, 100128, 4045, 'IASpecimensign', 'ghefssg_eryui_iaspecimensign_4b224562.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/ghefssg_eryui_iaspecimensign_4b224562.png', '/2017/04/03/ghefssg_eryui_iaspecimensign_4b224562.png', 0),
(291, 100132, 4046, 'IAPhotoid', 'tessting_sadsadsa_iaphotoid_6.jpg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_iaphotoid_6.jpg', '/2017/04/03/tessting_sadsadsa_iaphotoid_6.jpg', 0),
(292, 100132, 4047, 'IAProofresidency', 'tessting_sadsadsa_iaproofresidency_5.jpg', 'IAProofresidency', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_iaproofresidency_5.jpg', '/2017/04/03/tessting_sadsadsa_iaproofresidency_5.jpg', 0),
(293, 100132, 4048, 'IABankstatement', 'tessting_sadsadsa_iabankstatement_3.jpg', 'IABankstatement', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_iabankstatement_3.jpg', '/2017/04/03/tessting_sadsadsa_iabankstatement_3.jpg', 0),
(294, 100132, 4049, 'SubsDecSignature', 'tessting_sadsadsa_subsdecsignature_o.jpg', 'SubsDecSignature', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_subsdecsignature_o.jpg', '/2017/04/03/tessting_sadsadsa_subsdecsignature_o.jpg', 0),
(295, 100132, 4050, 'UBOEmploymentIncome', 'tessting_sadsadsa_uboemploymentincome_b.jpg', 'UBOEmploymentIncome', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_uboemploymentincome_b.jpg', '/2017/04/03/tessting_sadsadsa_uboemploymentincome_b.jpg', 0),
(296, 100132, 4056, 'UBOOther', 'tessting_sadsadsa_uboother_6.jpg', 'UBOOther', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_uboother_6.jpg', '/2017/04/03/tessting_sadsadsa_uboother_6.jpg', 0),
(297, 100132, 4072, 'IASpecimensign', 'tessting_sadsadsa_iaspecimensign_710fa9e1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_iaspecimensign_710fa9e1.png', '/2017/04/03/tessting_sadsadsa_iaspecimensign_710fa9e1.png', 0);
INSERT INTO `file_items` (`FileItemID`, `UserID`, `FileID`, `FileDescription`, `FileName`, `FileNameC`, `FilePath`, `FileSlug`, `Active`) VALUES
(298, 100133, 4075, 'IAPhotoid', 'sadasdadas_dsadsada_iaphotoid_5.jpg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/04/sadasdadas_dsadsada_iaphotoid_5.jpg', '/2017/04/04/sadasdadas_dsadsada_iaphotoid_5.jpg', 0),
(299, 100133, 4078, 'SubsDecSignature', 'sadasdadas_dsadsada_subsdecsignature_o.jpg', 'SubsDecSignature', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/04/sadasdadas_dsadsada_subsdecsignature_o.jpg', '/2017/04/04/sadasdadas_dsadsada_subsdecsignature_o.jpg', 0),
(300, 100133, 4080, 'UBOCommission', 'sadasdadas_dsadsada_ubocommission_4.jpg', 'UBOCommission', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/04/sadasdadas_dsadsada_ubocommission_4.jpg', '/2017/04/04/sadasdadas_dsadsada_ubocommission_4.jpg', 0),
(301, 100133, 4081, 'UBOBusiness', 'sadasdadas_dsadsada_ubobusiness_5.jpg', 'UBOBusiness', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/04/sadasdadas_dsadsada_ubobusiness_5.jpg', '/2017/04/04/sadasdadas_dsadsada_ubobusiness_5.jpg', 0),
(302, 100133, 4086, 'IASpecimensign', 'sadasdadas_dsadsada_iaspecimensign_182b6d64.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/04/sadasdadas_dsadsada_iaspecimensign_182b6d64.png', '/2017/04/04/sadasdadas_dsadsada_iaspecimensign_182b6d64.png', 0),
(303, 100134, 4087, 'CompanyDocument', 'testttingname_testttingsurname_companydocument_o.jpg', 'CompanyDocument', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/testttingname_testttingsurname_companydocument_o.jpg', '/2017/04/06/testttingname_testttingsurname_companydocument_o.jpg', 0),
(304, 100135, 4088, 'IAPhotoid', 'faye_champagne_iaphotoid_o.jpg', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_iaphotoid_o.jpg', '/2017/04/06/faye_champagne_iaphotoid_o.jpg', 0),
(305, 100135, 4089, 'IAProofresidency', 'faye_champagne_iaproofresidency_4.jpg', 'IAProofresidency', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_iaproofresidency_4.jpg', '/2017/04/06/faye_champagne_iaproofresidency_4.jpg', 0),
(306, 100135, 4090, 'IABankstatement', 'faye_champagne_iabankstatement_5.jpg', 'IABankstatement', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_iabankstatement_5.jpg', '/2017/04/06/faye_champagne_iabankstatement_5.jpg', 0),
(307, 100135, 4091, 'IASpecimensign', 'faye_champagne_iaspecimensign_.jpeg', 'IASpecimensign', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_iaspecimensign_.jpeg', '/2017/04/06/faye_champagne_iaspecimensign_.jpeg', 0),
(308, 100135, 4092, 'UBOEmploymentIncome', 'faye_champagne_uboemploymentincome_.jpeg', 'UBOEmploymentIncome', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_uboemploymentincome_.jpeg', '/2017/04/06/faye_champagne_uboemploymentincome_.jpeg', 0),
(309, 100135, 4099, 'SubsDecSignature', 'faye_champagne_subsdecsignature_6432c46b.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/06/faye_champagne_subsdecsignature_6432c46b.png', '/2017/04/06/faye_champagne_subsdecsignature_6432c46b.png', 0),
(310, 100086, 4100, 'Testing file', 'Testingfile_o.jpg', 'testtting', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/06/Testingfile_o.jpg', '/2017/04/06/Testingfile_o.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `file_sub_categories`
--

CREATE TABLE `file_sub_categories` (
  `FileSubCategoryID` int(21) NOT NULL,
  `FileCategoryID` int(11) NOT NULL,
  `FileSubCategoryName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FileSubCategoryDescription` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `file_sub_categories`
--

INSERT INTO `file_sub_categories` (`FileSubCategoryID`, `FileCategoryID`, `FileSubCategoryName`, `FileSubCategoryDescription`) VALUES
(1, 4, 'All', '');

-- --------------------------------------------------------

--
-- Table structure for table `options`
--

CREATE TABLE `options` (
  `OptionID` int(11) NOT NULL,
  `OptionGroupID` int(11) NOT NULL,
  `OptionKey` varchar(512) CHARACTER SET utf8 NOT NULL,
  `OptionValue` longtext CHARACTER SET utf8 NOT NULL,
  `OptionLabel` varchar(512) CHARACTER SET utf8 NOT NULL,
  `FormType` varchar(64) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `options`
--

INSERT INTO `options` (`OptionID`, `OptionGroupID`, `OptionKey`, `OptionValue`, `OptionLabel`, `FormType`) VALUES
(1, 1, 'site_title', 'Global Assets', 'Site Title', 'text'),
(2, 1, 'site_tagline', 'Global Assets Inc. Ltd.', 'Site Tagline', 'text'),
(3, 1, 'new_user_role', 'Client', 'New user role', 'select'),
(4, 1, 'time_zone', 'Asia/Singapore', 'Time Zone', 'select'),
(5, 1, 'site_language', 'cn', 'Site Language', 'select'),
(7, 1, 'favicon', '3759', 'Favicon', 'upload'),
(8, 1, 'site_logo', '3754', 'Site Logo', 'upload'),
(10, 1, 'site_logo_small', '3755', 'Site Logo Small (Mobile)', 'upload'),
(11, 3, 'pdf_id', 'harbingerville', 'PDFCrowd API ID', 'text'),
(12, 3, 'pdf_key', '6caa5212c6e3444e6945ad42131a6886', 'PDFCrowd API Key', 'text'),
(13, 2, 'email_from', 'accounts@gaskylight.com', 'From Email', 'text'),
(14, 2, 'email_from_name', 'Global Asset Inc Limited', 'From Name', 'text'),
(15, 2, 'email_cc', 'moises@cutearts.org', 'CC Email', 'text'),
(16, 2, 'email_bcc', 'moises.goloyugo@gmail.com', 'BCC Email', 'text');

-- --------------------------------------------------------

--
-- Table structure for table `option_groups`
--

CREATE TABLE `option_groups` (
  `OptionGroupID` int(11) NOT NULL,
  `GroupName` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Description` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `option_groups`
--

INSERT INTO `option_groups` (`OptionGroupID`, `GroupName`, `Description`) VALUES
(1, 'General', ''),
(2, 'Email', ''),
(3, 'PDF', '');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `PaymentID` int(21) NOT NULL,
  `AccountID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `PaymentType` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Description` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Amount` float NOT NULL,
  `PaymentDate` datetime NOT NULL,
  `Remarks` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`PaymentID`, `AccountID`, `UserID`, `PaymentType`, `Description`, `Amount`, `PaymentDate`, `Remarks`) VALUES
(1, 10065, 100000, 'Initial', 'Deposit test', 100000, '2017-01-17 13:30:14', 'half deposit'),
(2, 10065, 100000, 'Initial', 'kljhgfds', 20000, '2016-12-30 16:02:44', ''),
(3, 10070, 100079, 'Initial', '1st payment', 20000, '2017-02-22 06:19:28', ''),
(4, 10070, 100079, 'Other', 'Remaining payment', 40354, '2017-02-23 06:20:03', ''),
(5, 10080, 100079, 'Initial', '', 100000, '2017-03-31 16:38:08', ''),
(6, 10080, 100079, 'Other', '', 500000, '2017-03-31 16:38:29', ''),
(7, 10080, 100079, 'Other', '', 53123, '2017-03-31 16:38:47', ''),
(8, 10079, 100000, 'Other', '', 1000000, '2017-03-31 18:52:04', ''),
(9, 10086, 100079, 'Initial', '', 300000, '2017-04-03 09:03:32', ''),
(10, 10086, 100079, 'Other', '', 250000, '2017-04-03 09:04:28', ''),
(11, 10086, 100079, 'Other', '', 70100, '2017-04-03 09:06:35', ''),
(12, 10087, 100086, 'Initial', '', 200000, '2017-04-03 13:42:53', ''),
(13, 10087, 100086, 'Initial', '', 50000, '2017-04-03 13:43:17', ''),
(14, 10087, 100086, 'Other', '', 2000, '2017-04-03 13:43:28', ''),
(15, 10083, 100079, 'Initial', '', 88500, '2017-04-04 08:30:41', ''),
(16, 10083, 100079, 'Other', '', 1500, '2017-04-04 08:31:01', ''),
(17, 10083, 100079, 'Other', '', 12000, '2017-04-04 08:39:15', ''),
(18, 10090, 100086, 'Initial', 'initial only', 200000, '2017-04-06 07:11:30', '');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `ProductID` int(21) NOT NULL,
  `ProductName` varchar(128) CHARACTER SET utf8 NOT NULL,
  `ProductDescription` text CHARACTER SET utf8 NOT NULL,
  `DateAdded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ProductLabel` varchar(512) CHARACTER SET utf8 NOT NULL,
  `ProductEmailTemplate` varchar(255) CHARACTER SET utf8 NOT NULL,
  `Active` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`ProductID`, `ProductName`, `ProductDescription`, `DateAdded`, `ProductLabel`, `ProductEmailTemplate`, `Active`) VALUES
(210001, 'Skylight Platinum USD', 'Skylight Platinum USD', '2016-09-11 22:28:45', '', 'ga_term_platinum_usd.pdf', 1),
(210002, 'Skylight Platinum RMB', 'Skylight Platinum RMB', '2016-09-12 09:53:07', '', 'ga_term_platinum_rmb.pdf', 1),
(210007, 'Skylight Private RMB', '', '2017-02-06 04:56:34', '', 'ga_term_private_rmb.pdf', 0),
(210008, 'Skylight Private USD', '', '2017-02-06 04:56:40', '', 'ga_term_private_usd.pdf', 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_items`
--

CREATE TABLE `product_items` (
  `ProductItemID` int(21) NOT NULL,
  `ProductID` int(21) NOT NULL,
  `Code` varchar(512) CHARACTER SET utf8 NOT NULL,
  `ProductItemTitle` varchar(512) CHARACTER SET utf8 NOT NULL,
  `CouponAmount` text CHARACTER SET utf8 NOT NULL,
  `InvestmentAmount` float DEFAULT NULL,
  `StepUp` float DEFAULT NULL,
  `DividendFrequency` int(11) DEFAULT NULL,
  `TenureMonths` int(11) DEFAULT NULL,
  `QuarterlyInterest` float DEFAULT NULL,
  `AnnualInterest` float DEFAULT NULL,
  `StateRepCommission` float NOT NULL,
  `CityRepCommission` float NOT NULL,
  `CoreTeamCommission` float NOT NULL,
  `DateAdded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ItemLabel` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Active` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_items`
--

INSERT INTO `product_items` (`ProductItemID`, `ProductID`, `Code`, `ProductItemTitle`, `CouponAmount`, `InvestmentAmount`, `StepUp`, `DividendFrequency`, `TenureMonths`, `QuarterlyInterest`, `AnnualInterest`, `StateRepCommission`, `CityRepCommission`, `CoreTeamCommission`, `DateAdded`, `ItemLabel`, `Active`) VALUES
(10037, 210001, 'USD', 'USD A3', '1st year: 8% p.a | \r\n2nd Year: 9% p.a | \r\n3rd Year: 10% p.a', 30000, 10000, 0, 36, 0, 0, 0, 0, 0, '2017-02-06 04:48:40', '', 1),
(10038, 210001, 'USD', 'USD B3', '1st year: 10% p.a | \r\n2nd Year: 12% p.a | \r\n3rd Year: 14% p.a', 100000, 10000, 0, 36, 0, 0, 0, 0, 0, '2017-02-06 04:49:06', '', 1),
(10039, 210001, 'USD', 'USD B5', '1st year: 10% p.a | \r\n2nd Year: 12% p.a | \r\n3rd Year: 14% p.a | \r\n4th Year: 16% p.a | \r\n5th Year: 18% p.a', 100000, 10000, 0, 60, 0, 0, 0, 0, 0, '2017-02-06 04:49:22', '', 1),
(10040, 210002, 'RMB', 'RMB A3', '1st year: 7% p.a | \r\n2nd Year: 8% p.a | \r\n3rd Year: 9% p.a ', 150000, 50000, 0, 36, 0, 0, 0, 0, 0, '2017-02-06 04:54:33', '', 1),
(10041, 210002, 'RMB', 'RMB B3', '1st year: 9% p.a | \r\n2nd Year: 11% p.a | \r\n3rd Year: 13% p.a', 500000, 50000, 0, 36, 0, 0, 0, 0, 0, '2017-02-06 04:55:14', '', 1),
(10042, 210002, 'RMB', 'RMB B5', '1st year: 9% p.a | \r\n2nd Year: 11% p.a | \r\n3rd Year: 13% p.a | \r\n4th Year: 15% p.a | \r\n5th Year: 17% p.a ', 500000, 50000, 0, 60, 0, 0, 0, 0, 0, '2017-02-06 04:55:31', '', 1),
(10045, 210008, 'USD', 'USD LP', '1st yr - 7% p.a | \r\n2nd yr - 8% p.a | \r\n3rd yr - 9% p.a', 1000000, 500000, 0, 36, 0, 0, 0, 0, 0, '2017-02-06 04:58:00', '', 0),
(10047, 210007, 'RMB', 'RMB LP', '1st year: 6% p.a | \r\n2nd Year: 7% p.a | \r\n3rd Year: 8% p.a', 5000000, 2500000, 0, 36, 0, 0, 0, 0, 0, '2017-03-21 04:07:37', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(21) NOT NULL,
  `ReferrerUserID` int(21) NOT NULL,
  `SecondReferrerUserID` int(21) NOT NULL,
  `Email` varchar(64) NOT NULL,
  `Password` varchar(128) NOT NULL,
  `Level` int(11) NOT NULL,
  `Capability` longtext NOT NULL,
  `SendEmail` int(1) NOT NULL DEFAULT '0',
  `HashKey` varchar(64) NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '0',
  `DateAdded` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `ReferrerUserID`, `SecondReferrerUserID`, `Email`, `Password`, `Level`, `Capability`, `SendEmail`, `HashKey`, `Active`, `DateAdded`) VALUES
(100000, 100000, 0, 'moises.goloyugo@gmail.com', '14sJP9bm482D8ezUdx7HjLfPZk6+iIL6xOnPWBNiaJE=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 1, '44131823d5de90da3523fab70d081d7b', 1, '2016-07-18 11:16:31'),
(100001, 100079, 0, 'account@gaskylight.com', 'r3NwOxD0AHhRBTb8gph3xrYW6XWa3v4WsU/7+DUvcgE=', 1, 'YTozNjp7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTc6IkNvbW1pc3Npb24gUmVwb3J0IjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 1, '', 1, '2016-06-01 02:04:08'),
(100033, 100084, 0, 'kid720401@gmail.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '0c5884668180982891480d6332b7fdd6', 1, '2016-07-12 01:27:38'),
(100065, 100033, 0, 'lkk110630@gmail.com', 'UZ76bbcKHrkWfxWDluxoHJV9IEGaAASasqov7G8z6YU=', 5, 'YToxOntpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjt9', 0, '12b3ea81ad559418e46a10dc55278d94', 1, '2016-10-08 06:30:03'),
(100078, 100033, 0, 'sunying.co@gmail.com', '/mlp++ZQcWYRjOWAJXDilmz3yKkYcLyGTujgAeHJ2jY=', 5, 'YToxOntpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjt9', 0, 'd0c74ee25d25ce1b3e382dd1fc56cf02', 1, '2016-10-26 04:52:29'),
(100079, 100000, 0, 'chrischuasg@gmail.com', '4jrybdaPGVcpSF+NF1XyDNndlH95P8ph3hbzSfUE2R4=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '89ef343ec32c7fcec6968896f014a81b', 1, '2016-11-16 03:41:26'),
(100081, 100033, 0, 'Hao@gmail.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, 'a304513b919b50f4584eb7b98f576fea', 1, '2016-11-26 16:20:36'),
(100084, 100001, 0, 'core@gaskylight.com', 'PMflVI3YaRtzpg8hDym2DN3K3r0EMR30E/ZYZa/Urw0=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'e2949b85d8ddd12d74d5160dca0f3c9b', 1, '2016-12-06 11:03:49'),
(100085, 100000, 0, 'support@appextended.com', 'IW7yfxFmDoy8WiMi5JfsBc5B4/azQRQH4c0GWE++12c=', 2, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE3OiJDb21taXNzaW9uIFJlcG9ydCI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, 'd50f93d2f110738edc88bb4bb7cbcf9f', 1, '2016-12-09 06:01:33'),
(100086, 100000, 0, 'ryandumajil@gmail.com', 'M+5XjNuzNy0lj83M3AKX6lfa0oPQ5S2bJi8P5Ttk6Eg=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '7f11f5fd4e573fd1ad799787d848a43e', 1, '2016-12-09 06:21:59'),
(100087, 100001, 0, 'sysy@hotmail.com', 'U5/9b5V+p38qBWhX+Nk4ElnfJE0mUM5OprT0sQISE6w=', 5, '', 0, '23be58498b73ede2ce0074903ae0ab14', 0, '2016-12-13 04:23:33'),
(100088, 0, 0, 'wong@hotmail.com', 'vTybv/11wrUYP0fIcGLZm03OccLRjuUCpKv9BORfvRo=', 5, '', 0, '30e5c3a0471c08079ebdcab6029d5901', 0, '2016-12-13 04:30:46'),
(100089, 0, 0, 'lee@gmail.com', 'KxtVjEuMwXs40nlXwfRdrqETNKblto2O7PZVbh7PFmI=', 5, '', 0, 'ec7863937bde491111ab9e5995ec8191', 0, '2016-12-13 05:02:43'),
(100092, 0, 0, 'victor@gmail.com', 'WJ+Ccf6iwUmbosiwy/1zKMYP6oeg+0rRr1Q2KSaxQoQ=', 5, '', 0, '8aad4d77f09e8990c892680cb19ea3fd', 1, '2016-12-13 06:28:19'),
(100094, 100079, 0, 'chowxiaomi_888@gmail.com', 'YAIwgaV+Y7ZbXjeUwfJ+61qP83xDt7N4dZ/UBn4xENg=', 5, '', 0, '7a254af3cc94ba6e10de7994c703c107', 1, '2016-12-13 06:44:37'),
(100095, 100088, 0, 'yapyap@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE3OiJDb21taXNzaW9uIFJlcG9ydCI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'b12a0d8d3b4fb763e3d74617be32e485', 1, '2016-12-13 06:50:40'),
(100098, 100001, 0, 'abc@abc.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '13369485a4b81d5add5d8daba5b1136f', 1, '2016-12-14 04:44:12'),
(100099, 100001, 0, 'chowlyechoo@gmail.com', '/QAgQZIj2xacXwdjLivaIJkCQclJscZLu1Qm0LNjNLw=', 5, '', 0, '60e60bf7402d88bc2a5c8ab29e4d456d', 1, '2016-12-20 05:52:01'),
(100105, 100111, 0, 'smileatchris@gmail.com', 'vLit8w069yleVApDSVtplMKdW3GDQzghbKB84/co2Dc=', 5, '', 0, '094e10e5fa35a5c43c3249c018ad5164', 1, '2017-01-23 16:37:16'),
(100106, 100000, 0, 'ryanck@accountingcompany.com', 'ENqfg+5175l+xB7xLNjAE+zyHLl68EjJ9JKZ+I2+0iE=', 9, 'YToxOntpOjI0O3M6ODoiVmlldyBBUEkiO30=', 0, 'd482556f9870b4baa7e65696aad074a2', 1, '2017-02-10 05:04:56'),
(100107, 100081, 0, 'abc@123.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '500db11148fabb9a273b50f0d93ed0f6', 1, '2017-02-13 00:04:32'),
(100108, 100084, 0, 'abc@qwe.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'd4e472e9ed181e4bebb8049bab7ff564', 1, '2017-02-13 01:46:50'),
(100109, 100079, 0, 'jeff@iglobaltrust.com', 'H0k1oSfauU2YKT2ss3yxMMlVxSINNQyrS11FawGXHMA=', 1, 'YTozNjp7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTc6IkNvbW1pc3Npb24gUmVwb3J0IjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'fab917697d949601f3f03585a1b1669d', 1, '2017-02-21 09:04:24'),
(100110, 100084, 0, 'jeff@attrust.com', 'WVZSM3/PhoqZiS3M1SD3kr+/HhTECvbMjeFAMcXpZao=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '1f8824abe968c42f58528b3c8a7cd633', 1, '2017-02-21 09:32:06'),
(100111, 100110, 0, 'weh@weah.com', 'm3SRncLHiwJzyX4l+BkAaGhg4rdqHwlsaKcK5+1NIUU=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, 'bf9b7f0bb53aec25e79249ab69bfe11e', 1, '2017-02-21 09:42:12'),
(100112, 100115, 0, 'd6f00be35a879012010f2415975dc6fd@gaskylight.com', 'jT6JtBZ1HnZne2zPt8hu1FHcjsiysuxipHx1a38SwBA=', 5, '', 0, 'd6f00be35a879012010f2415975dc6fd', 1, '2017-02-22 06:04:25'),
(100113, 100001, 0, 'sadsad@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'cb72484b2a547c154a47cf6378ce941f', 1, '2017-03-02 04:20:55'),
(100114, 100113, 0, 'agent1@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '212d943e39f0b37c98bab4e3554d941f', 1, '2017-03-02 04:26:01'),
(100115, 100114, 0, 'agent2@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, 'a460a7bb3a4fcd2323b7e36a08b279cd', 1, '2017-03-02 04:26:54'),
(100116, 100115, 0, 'agent3@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '5611ceaeeabc44578e8f4e0bf8dc301d', 1, '2017-03-02 04:27:37'),
(100117, 100116, 0, 'agent4@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, 'dcdddde0efe745931eeac62ba406cc60', 1, '2017-03-02 04:28:10'),
(100118, 100117, 0, 'agent5@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '1119aff0aa7657f8bddc99143f241b2b', 1, '2017-03-02 04:28:35'),
(100119, 100079, 0, 'jo@jo.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE3OiJDb21taXNzaW9uIFJlcG9ydCI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, '32ee7cde3f545e31e9d0a7080f87c543', 1, '2017-03-08 05:15:34'),
(100120, 100079, 0, 'ck@ck.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE3OiJDb21taXNzaW9uIFJlcG9ydCI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'd14ac4eaa57ce3daa688a5b4251641b6', 1, '2017-03-08 05:17:16'),
(100121, 100079, 0, 'lu@lu.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE3OiJDb21taXNzaW9uIFJlcG9ydCI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'a0bf8dc321062f521c2180489b68b2b4', 1, '2017-03-08 05:18:21'),
(100122, 100116, 0, 'd39e846f5f32692c5bb3f8dc9b709235@globalassetspc.com', '6VQG3urH5CZk0UOjMhBI4aQx2jsAlbehpaKpmMR6Gr8=', 5, '', 0, 'd39e846f5f32692c5bb3f8dc9b709235', 1, '2017-03-10 04:54:22'),
(100123, 100116, 100115, '6bcdf9e48f3e541a3e92a56052db887c@globalassetspc.com', 'a94DVJ+1E3qzA4TCDMy5JfQlTY9UXOpkCunsWIHXgfs=', 5, '', 0, '6bcdf9e48f3e541a3e92a56052db887c', 1, '2017-03-10 04:54:22'),
(100124, 100115, 100114, 'e54971b28ba1eac22b2400bc1add3688@globalassetspc.com', 'DtsWS2oDq7S+jboxKETj3ik24by2+nuxP04moG1lzIc=', 5, '', 0, 'e54971b28ba1eac22b2400bc1add3688', 1, '2017-03-10 05:41:08'),
(100125, 100116, 0, '6ae69022212d1bd9fd8ec9bcd27e698e@globalassetspc.com', 'Il7zD2QvGCrKe3qqBKUtF7UkI0+w8cfexciVtmvyPUk=', 5, '', 0, '6ae69022212d1bd9fd8ec9bcd27e698e', 1, '2017-03-31 16:27:12'),
(100126, 100033, 0, '038cda22539df7721e64e4b508da9137@globalassetspc.com', 'eQZnoj7tzYPVC82jzaPi+JtomiemBSTlsXC0yKClY8E=', 5, '', 0, '038cda22539df7721e64e4b508da9137', 1, '2017-03-31 19:10:02'),
(100127, 100033, 0, 'cb6216d9807d3ad9a7d95267e8bffb90@gaskylight.com', '3rmtL6VPdPnwz8s9yotZcp5tBVeyF+6HxaL0fZZdiB4=', 5, '', 0, 'cb6216d9807d3ad9a7d95267e8bffb90', 1, '2017-04-01 11:55:53'),
(100128, 100033, 100115, 'c23fc7e0c38ed45145a9aa1fb35464ef@gaskylight.com', 'zXgwZAdslImW93g9gjkhKJT+QWUgiXUpJqEkf69IH/g=', 5, '', 0, 'c23fc7e0c38ed45145a9aa1fb35464ef', 1, '2017-04-01 12:05:06'),
(100129, 100113, 0, 'sadasent3@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '02f5cffcd66467af7d3a86ce98ee170e', 1, '2017-04-03 08:47:37'),
(100130, 100115, 0, 'louis@abc.com', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '9a7a11b82552a7b6d056c86d8d2692df', 1, '2017-04-03 08:50:02'),
(100131, 100130, 100107, '5940b7f714f8d248f52ffbb499b3feff@gaskylight.com', 'ES2uqt85gsvX75l+JJZcx0lTWyVn0n6vYUrzYG3CqDc=', 5, '', 0, '5940b7f714f8d248f52ffbb499b3feff', 1, '2017-04-03 08:53:21'),
(100132, 100033, 0, '1798c68cf76ea8378014a88ff0a38ccf@gaskylight.com', 'RJ61eRz45RTO/zWHCsOZg9decEPoM6mluHqlPMChtS8=', 5, '', 0, '1798c68cf76ea8378014a88ff0a38ccf', 1, '2017-04-03 13:28:00'),
(100133, 100114, 100115, '04c7f43c07cc2a01502e8ecb8f11fc3a@gaskylight.com', 'W4YMyHREjD7CP8rmeQkOhMcTSN7VuX7UrDHdXv7HpGo=', 5, '', 0, '04c7f43c07cc2a01502e8ecb8f11fc3a', 1, '2017-04-04 15:17:50'),
(100134, 100086, 0, 'asdasdasd@gmail.com', '0zWLsxDJmbCJmjHUpMUjEss8gv+2+DvHs4BJ7MHpR0g=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '7fe60018dd1121515f18bd09325f934e', 1, '2017-04-06 06:52:29'),
(100135, 100114, 100115, '514581129e2e9004c6fb618c93b1bea0@gaskylight.com', '0W43KoYKeD9QjjX2KDZZTGAs8SvgAyW7bdKI+IcRYAw=', 5, '', 0, '514581129e2e9004c6fb618c93b1bea0', 1, '2017-04-06 07:06:02');

-- --------------------------------------------------------

--
-- Table structure for table `user_capabilities`
--

CREATE TABLE `user_capabilities` (
  `UserCapabilityID` int(11) NOT NULL,
  `UserCapabilityGroupID` int(11) NOT NULL,
  `Name` varchar(256) CHARACTER SET utf8 NOT NULL,
  `Description` text CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_capabilities`
--

INSERT INTO `user_capabilities` (`UserCapabilityID`, `UserCapabilityGroupID`, `Name`, `Description`, `Active`) VALUES
(1, 0, 'Administer All', '', 0),
(2, 1, 'Delete Users', '', 0),
(3, 1, 'Edit Users', '', 0),
(4, 1, 'Add Users', '', 0),
(5, 2, 'Delete Clients', '', 0),
(6, 2, 'Edit Clients', '', 1),
(7, 2, 'Add Clients', '', 1),
(8, 3, 'Delete Casefiles', '', 0),
(9, 3, 'Edit Casefiles', '', 1),
(10, 3, 'Add Casefiles', '', 1),
(11, 4, 'Delete Agents', '', 0),
(12, 4, 'Edit Agents', '', 1),
(13, 4, 'Add Agents', '', 1),
(14, 5, 'Delete Agency', '', 0),
(15, 5, 'Edit Agency', '', 1),
(16, 5, 'Add Agency', '', 1),
(17, 6, 'View Network Hierarchy', '', 1),
(18, 6, 'View Commissions', '', 1),
(19, 3, 'Manage Uploaded Documents', '', 1),
(20, 3, 'Manage Application', '', 1),
(21, 3, 'Download Documents', '', 1),
(23, 3, 'Send Email', '', 1),
(24, 7, 'View API', '', 0),
(25, 1, 'View Users', '', 0),
(26, 2, 'View Clients', '', 1),
(27, 3, 'View Casefiles', '', 1),
(28, 4, 'View Agents', '', 1),
(29, 5, 'View Agency', '', 1),
(30, 6, 'View Sales Report', '', 1),
(31, 0, 'Manage Roles', '', 0),
(32, 0, 'Manage Settings', '', 0),
(33, 9, 'View Products', '', 0),
(34, 9, 'Add Product', '', 0),
(35, 9, 'Edit Product', '', 0),
(36, 9, 'Delete Product', '', 0),
(37, 10, 'View Media', '', 0),
(38, 10, 'Add Media', '', 0),
(39, 10, 'Edit Media', '', 0),
(40, 10, 'Delete Media', '', 0),
(41, 6, 'View Reports', '', 1),
(42, 3, 'Edit UBO', '', 0),
(43, 3, 'Edit Banking', '', 0),
(44, 3, 'Edit Investment', '', 0),
(45, 3, 'Edit Profile', '', 0),
(46, 3, 'Assigned Manager', '', 0),
(47, 11, 'View Managers', '', 0),
(48, 11, 'Edit Managers', '', 0),
(49, 11, 'Delete Managers', '', 0),
(50, 11, 'Add Managers', '', 0),
(51, 0, 'Manage Capabilities', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_capability_groups`
--

CREATE TABLE `user_capability_groups` (
  `UserCapabilityGroupID` int(11) NOT NULL,
  `Name` varchar(256) CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_capability_groups`
--

INSERT INTO `user_capability_groups` (`UserCapabilityGroupID`, `Name`, `Active`) VALUES
(0, 'Admin', 1),
(1, 'Users', 1),
(2, 'Clients', 1),
(3, 'Casefiles', 1),
(4, 'Agents', 1),
(5, 'Agency', 1),
(6, 'Reports', 1),
(7, 'API', 1),
(9, 'Products', 1),
(10, 'Media', 1),
(11, 'Manager', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_levels`
--

CREATE TABLE `user_levels` (
  `UserLevelID` int(11) NOT NULL,
  `Code` varchar(32) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Description` text NOT NULL,
  `Link` text NOT NULL,
  `Capability` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_levels`
--

INSERT INTO `user_levels` (`UserLevelID`, `Code`, `Name`, `Description`, `Link`, `Capability`) VALUES
(1, 'ADM', 'Administrator', 'Administrator', '', 'YTozNjp7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTc6IkNvbW1pc3Npb24gUmVwb3J0IjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ=='),
(2, 'MNG', 'Manager', 'State administrator, manage city representative and agents', '', 'YToyNDp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTc6IkNvbW1pc3Npb24gUmVwb3J0IjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjt9'),
(3, 'GAA', 'Agency', 'City representative manage agents', '', 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ=='),
(4, 'GA', 'Agent', 'Agents', '', 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30='),
(5, 'CLN', 'Client', 'Clients ', 'users/profile', 'YToxOntpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjt9'),
(9, 'DEV', 'Developer', 'Developer, API access', 'users/profile', 'YToxOntpOjI0O3M6ODoiVmlldyBBUEkiO30='),
(10, 'USR', 'User', '', '', 'YToyMjp7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTc6IkNvbW1pc3Npb24gUmVwb3J0IjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7fQ==');

-- --------------------------------------------------------

--
-- Table structure for table `user_meta`
--

CREATE TABLE `user_meta` (
  `UserMetaID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `Language` varchar(128) NOT NULL DEFAULT 'en',
  `Sidebar` varchar(255) NOT NULL DEFAULT 'nav-sm',
  `Avatar` int(21) NOT NULL,
  `Salutation` varchar(32) NOT NULL,
  `FirstName` varchar(64) NOT NULL,
  `LastName` varchar(64) NOT NULL,
  `NickName` varchar(128) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `CivilStatus` varchar(64) NOT NULL,
  `Phone` varchar(15) NOT NULL,
  `Mobile` varchar(32) NOT NULL,
  `JobTitle` varchar(64) NOT NULL,
  `Occupation` varchar(64) NOT NULL,
  `Address` varchar(256) NOT NULL,
  `Address2` varchar(256) NOT NULL,
  `Address3` varchar(256) NOT NULL,
  `Address4` varchar(256) NOT NULL,
  `City` varchar(64) NOT NULL,
  `State` varchar(64) NOT NULL,
  `Country` varchar(64) NOT NULL,
  `PostalCode` varchar(16) NOT NULL,
  `Bio` text NOT NULL,
  `IdNumber` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_meta`
--

INSERT INTO `user_meta` (`UserMetaID`, `UserID`, `Language`, `Sidebar`, `Avatar`, `Salutation`, `FirstName`, `LastName`, `NickName`, `DateOfBirth`, `Gender`, `CivilStatus`, `Phone`, `Mobile`, `JobTitle`, `Occupation`, `Address`, `Address2`, `Address3`, `Address4`, `City`, `State`, `Country`, `PostalCode`, `Bio`, `IdNumber`) VALUES
(1, 100000, 'en', 'nav-md', 2578, '', 'Moises', 'Goloyugo', 'Site Administrator', '1986-12-25', 'M', '', '09278585028', '', '', '', 'Bulihan', '', '', '', 'Silang', 'Cavite', 'Philippines', '4118', 'Whatever', ''),
(2, 100001, 'en', 'nav-sm', 3745, '', 'Global Assets', 'Trust', 'OdeonAdmin', '0000-00-00', 'M', '', '0000000', '', '', '', 'Shenzhen', '', '', '', 'Shenzhen', 'Shenzhen', 'China', '000000', 'Admin', '0000000'),
(5, 100033, 'en', 'nav-sm', 0, '', 'GA', 'Testing Agent', '', '0000-00-00', 'M', '', '00000000', '', '', '', 'Taiwan', '', '', '', 'Taiwan', 'Taiwan', 'Taiwan', '000000', '', '134685258-XYZ1'),
(37, 100065, 'en', 'nav-sm', 0, 'Mr', 'KING KI', 'LEE', '', '1981-08-26', 'M', 'SINGLE', '+852 97526817', '+852 97526817', 'PIANO TEACHER (VISIT HOME)', 'SELF EMPLOYED', 'FLAT 1A, 15/F, KAM LING COURT, 1-3, WOO HOP STREET, HONG KONG', '', '', '', '', '', 'China', '', '', 'K01672254'),
(50, 100078, 'en', 'nav-sm', 0, 'Mr', 'Tsung-Yen', 'Hsieh', '', '1984-04-08', 'M', 'SINGLE', '+886978767397', '+886978767397', 'Director', 'Business ', '彰化縣和美鎮和光路250號1樓', '', '', '', '台中', '台北', 'Taiwan', '', '', '311773455'),
(51, 100079, 'zh', 'nav-sm', 3795, 'Mr', 'Global', 'Asset', '', '2000-01-03', 'M', '', '00000000', 'asdf', 'sdafasdf', 'asdfsadf', 'Singapore', 'sadf', 'sasdaf', 'sadfsdaf', 'Singapore', 'Singapore', 'Singapore', '', '', 'dfghjhk'),
(53, 100081, 'en', 'nav-sm', 2675, '', 'HAO', 'LEE', '', '0000-00-00', 'M', '', '1232144', '', '', '', 'Dover', '', '', '', 'Singapore', 'Singapore', 'Singapore', '123456', '', '12345678'),
(55, 100084, 'en', 'nav-sm', 3746, '', 'Global Assets', 'Core', '', '0000-00-00', 'M', '', '123', '', '', '', 'Odeon Co', '', '', '', 'Odeon Co', 'Odeon Co', 'China', '123', '', '123'),
(56, 100085, 'en', 'nav-sm', 0, '', 'App', 'Extended', '', '0000-00-00', 'M', '', '123456', '', '', '', 'App', '', '', '', 'App', 'Ext', 'China', '123456', '', '123456'),
(57, 100086, 'en', 'nav-md', 3744, '', 'Ryan', 'Dumajil', '', '0000-00-00', 'M', '', '3216987', '', '', '', 'Ryan', '', '', '', 'Ryan', 'Ryan', 'Philippines', '4118', '', '134679'),
(58, 100087, 'en', 'nav-sm', 0, 'Mr', 'sy', 'yap', '', '1988-01-01', 'M', 'SINGLE', '', '861135577888', 'Director', 'Finance officer', 'china', '', '', '', '', '', 'China', '', '', 'A1111111'),
(59, 100088, 'en', 'nav-sm', 0, 'Ms', 'wong', 'shi qi', '', '1990-01-10', 'F', 'SINGLE', '', '86133788526', 'Manager', 'consultant ', 'china', '', 'china', '', '', '', 'China', '', '', 'AX87875542'),
(60, 100089, 'tcn', 'nav-sm', 0, 'Mrs', 'wen hong', 'lee', '', '1980-12-12', 'F', 'SINGLE', '', '78785656412', 'Manager ', 'consultant ', 'taiwan', '', '', '', '', '', 'Taiwan', '', '', 'DD745687459'),
(61, 100092, 'tcn', 'nav-sm', 0, 'Mr', 'victor ', 'albee wong', '', '1980-02-12', 'F', 'MARRIED', '', '62991608', 'Executive', 'Marketing management', 'hong kong', '', '', '', '', '', 'Hong Kong', '', '', 'SA'),
(62, 100094, 'en', 'nav-sm', 0, 'Mr', 'Xiao Mi', 'Chow', '', '1982-03-01', 'M', 'MARRIED', '62881688', '96341212', 'CEO', 'Marketing management', 'hong kong', '', '', '', 'hong kong', 'hong kong', 'Hong Kong', '', '', 'm4591221'),
(63, 100095, 'zh', 'nav-sm', 3747, '', 'sy', 'yap', '', '0000-00-00', 'F', '', '96967878', '', '', '', 'hong kong', '', '', '', '', '', 'China', '', '', ''),
(64, 100098, 'en', 'nav-sm', 0, '', 'L', 'T', '', '0000-00-00', 'M', '', '23123123', '', '', '', '123123', '', '', '', 'wdsdsdf', 'sdfsdf', 'Hong Kong', 'sfsdf', '', '12321323'),
(65, 100099, 'en', 'nav-sm', 0, 'Mr', 'Choo- Testing', 'Chow', '', '1988-11-04', 'F', 'SINGLE', '', '0175781231', 'Executive', 'Admin', '1, Regat Pasir Puteh 31650 Ipoh Perak', '', '1, Regat Pasir Puteh 31650 Ipoh Perak', '', '', '', 'Malaysia', '', '', '881104085882'),
(66, 100105, 'en', 'nav-sm', 0, 'Mr', 'TESTINGa', 'ACCOUNT 1', '', '1993-11-19', 'M', 'MARRIED', '0000', '2224', 'MANAGER', 'IT', 'No. 28 Leaf Village', 'w', '', '', 'asdf', '', 'China', '', '', 'dfsdf'),
(67, 100106, 'en', 'nav-sm', 0, '', 'Ryan', 'Ck', 'ck', '0000-00-00', 'M', '', '000000', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(68, 100107, 'en', 'nav-sm', 0, '', 'testing 1', '2', '', '0000-00-00', 'M', '', '213123', '', '', '', '123123', '', '', '', 'wdsdsdf', 'sdfsdf', 'Hong Kong', '23123123', '', '343423'),
(69, 100108, 'en', 'nav-sm', 0, '', 'abc', 'abc', '', '0000-00-00', 'M', '', '232323', '', '', '', '123123', '', '', '', '123123', '213123', 'China', '123123', '', '1234'),
(70, 100109, 'en', 'nav-md', 3748, '', 'jeff', 'goh wei ming', 'jeffro', '0000-00-00', 'M', '', '1213234324', '', '', '', 'orchard road', '', '', '', 'singapore', 'singapore', 'China', '000000', 'humsap lou', ''),
(71, 100110, 'en', 'nav-sm', 0, '', 'Jeff', 'Pte Ltd', '', '0000-00-00', 'M', '', '232344234', '', '', '', 'singapore', '', '', '', 'singapore', 'singapore', 'Hong Kong', '234324', '', 'S1234523G'),
(72, 100111, 'en', 'nav-sm', 0, '', 'wei hao', 'lee', '', '0000-00-00', 'M', '', 'sdfsdfsdf', '', '', '', 'sdfsdf', '', '', '', 'sdfsdf', 'sdfddf', 'Hong Kong', 'sdfsdf', '', '23432423'),
(73, 100112, 'en', 'nav-sm', 0, 'Mr', 'Hao', 'Hao', '', '2005-02-02', 'M', 'SINGLE', '', '123213123123', 'Manager', 'POP', 'Orchard', '', 'Orchard', '', '', '', 'Taiwan', '', '', 'sdsdfsdf'),
(74, 100113, 'en', 'nav-sm', 0, '', 'Agency', 'Agency', '', '0000-00-00', 'M', '', '1234213', '', '', '', 'Agency', '', '', '', 'Agency', 'Agency', 'China', '123', '', '123'),
(75, 100114, 'en', 'nav-sm', 0, '', 'agent 1', 'agent 1', '', '0000-00-00', 'M', '', '123', '', '', '', 'agent 1', '', '', '', 'agent 1', 'agent 1', 'China', '123', '', '123'),
(76, 100115, 'en', 'nav-sm', 0, '', 'agent 2', 'agent 2', '', '0000-00-00', 'M', '', '123', '', '', '', 'agent 2', '', '', '', 'agent 2', 'agent 2', 'China', '123', '', '123'),
(77, 100116, 'en', 'nav-sm', 0, '', 'agent 3', 'agent 3', '', '0000-00-00', 'M', '', '123', '', '', '', 'agent 3', '', '', '', 'agent 3', 'agent 3', 'China', '123', '', '123'),
(78, 100117, 'en', 'nav-sm', 0, '', 'agent 4', 'agent 4', '', '0000-00-00', 'M', '', '123', '', '', '', 'agent 4', '', '', '', 'agent 4', 'agent 4', 'China', '123', '', '12313'),
(79, 100118, 'en', 'nav-sm', 0, '', 'agent 5', 'agent 5', '', '0000-00-00', 'M', '', '123', '', '', '', 'agent 5', '', '', '', 'agent 5', 'agent 5', 'China', '123', '', '123'),
(80, 100119, 'en', 'nav-sm', 0, '', 'Joanna', 'Chow', '', '0000-00-00', 'F', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(81, 100120, 'en', 'nav-sm', 0, '', 'Ck', 'Teo', '', '0000-00-00', 'M', '', '126335', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(82, 100121, 'en', 'nav-sm', 0, '', 'Louis', 'Yap', '', '0000-00-00', 'M', '', '123487', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(83, 100122, 'en', 'nav-sm', 0, 'Ms', 'Shan Shan', 'Lee', '', '1980-01-10', 'F', 'SINGLE', '', '99886566', 'Manager', 'Marketing ', 'hong kong', '', '', '', '', '', 'China', '', '', 'A12345678'),
(84, 100123, 'en', 'nav-sm', 0, 'Ms', 'Shan Shan', 'Lee', '', '1980-01-10', 'F', 'SINGLE', '', '99886566', 'Manager', 'Marketing ', 'hong kong', '', '', '', '', '', 'China', '', '', 'A12345678'),
(85, 100124, 'en', 'nav-sm', 0, 'Mr', 'Wen Zhi', 'Lee', '', '1969-12-31', 'M', 'SINGLE', '', '64433000', 'Director', 'Financial', 'hong kong', '', '', '', '', '', 'Hong Kong', '', '', 'bb5457895'),
(86, 100125, 'en', 'nav-sm', 0, 'Mr', 'today', 'testing', '', '1994-03-04', 'M', 'SINGLE', '42343245', '4234234', 'TESTER', 'APPLE', 'ssdsdf', '', '', '', '', '', 'Hong Kong', '', '', '34324325'),
(87, 100126, 'en', 'nav-sm', 0, 'Mr', 'Testing Acccount', 'asdasd', '', '1990-12-18', 'M', 'SINGLE', '1231', '123123', 'asdas', 'sdad', 'qweqwe', 'qweqwe', '', '', '', '', 'China', '', '', '123123123'),
(88, 100127, 'en', 'nav-sm', 0, 'Mr', 'Ghefssg', 'Eryui', '', '1990-07-07', 'M', 'SINGLE', '+639238133222', '1233t', 'Ggdgbg', 'Fhffv', 'Ghgfgh', 'Htdg', '', '', '', '', 'China', '', '', '1236'),
(89, 100128, 'en', 'nav-sm', 0, 'Mr', 'Ghefssg', 'Eryui', '', '1990-07-07', 'M', 'SINGLE', '+639238133222', '1233t', 'Ggdgbg', 'Fhffv', 'Ghgfgh', 'Htdg', '', '', '', '', 'China', '', '', '1236'),
(90, 100129, 'en', 'nav-sm', 0, '', 'qweqweqw', 'wqeqwe', '', '0000-00-00', 'M', '', '123', '', '', '', 'dsadsadas', '', '', '', 'das', 'sadas', 'China', '123', 'test', '12312'),
(91, 100130, 'en', 'nav-sm', 0, '', 'Louis', 'Yap', '', '0000-00-00', 'M', '', '123212424', '', '', '', 'asdfasdf', '', '', '', 'asdfsdaf', 'sadfasdf', 'Hong Kong', '23123', '', '123123'),
(92, 100131, 'en', 'nav-sm', 0, 'Mr', 'WEELIANG', 'YAP', '', '1992-08-16', 'M', 'SINGLE', '32424', '143', 'MAIN', 'DOTA', 'asdfdf', '', '', '', '', '', 'China', '', '', '2234324'),
(93, 100132, 'en', 'nav-sm', 0, 'Mr', 'Tessting', 'sadsadsa', '', '1996-04-07', 'M', 'SINGLE', '123123', '123123', 'adssad', 'sdadasd', 'asdsad', 'asdasda', '', '', '', '', 'China', '', '', '123123'),
(94, 100133, 'en', 'nav-sm', 0, 'Mr', 'sadasdadas', 'dsadsada', '', '1999-03-06', 'M', 'SINGLE', '213213', '23123', 'dasdasda', 'dsadasd', 'dadas', 'dasdasd', '', '', '', '', 'China', '', '', '12312312'),
(95, 100134, 'en', 'nav-sm', 0, '', 'testtting name', 'testtting surname', '', '0000-00-00', 'M', '', '2312312', '', '', '', 'asdasdas', '', '', '', 'sadasd', 'sadasd', 'China', '2323', 'adsdasdasda', '123123'),
(96, 100135, 'en', 'nav-sm', 0, 'Mr', 'faye', 'champagne', '', '1989-08-12', 'M', 'MARRIED', '31232131231', '12312312312', 'qwertyuiop', 'qwertyuiop', 'qweqweqweqwe', 'qweqweqwe', '', '', '', '', 'China', '', '', '123123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`AccountID`),
  ADD KEY `CaseFileID` (`AccountID`),
  ADD KEY `CaseFileID_2` (`AccountID`);

--
-- Indexes for table `account_beneficiaries`
--
ALTER TABLE `account_beneficiaries`
  ADD PRIMARY KEY (`BeneficiaryID`);

--
-- Indexes for table `account_meta`
--
ALTER TABLE `account_meta`
  ADD PRIMARY KEY (`AccountMetaID`),
  ADD KEY `CaseFileID` (`AccountMetaID`),
  ADD KEY `CaseFileID_2` (`AccountMetaID`);

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`ActivityID`);

--
-- Indexes for table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`BankAccountID`),
  ADD UNIQUE KEY `UserID` (`UserID`),
  ADD KEY `BankAccountID` (`BankAccountID`),
  ADD KEY `BankAccountID_2` (`BankAccountID`);

--
-- Indexes for table `commission_overriding`
--
ALTER TABLE `commission_overriding`
  ADD PRIMARY KEY (`CommOverideID`);

--
-- Indexes for table `commission_personal`
--
ALTER TABLE `commission_personal`
  ADD PRIMARY KEY (`CommPersonalID`);

--
-- Indexes for table `commission_scheme`
--
ALTER TABLE `commission_scheme`
  ADD PRIMARY KEY (`SchemeID`),
  ADD UNIQUE KEY `UserID` (`UserID`),
  ADD KEY `SchemeID` (`SchemeID`);

--
-- Indexes for table `commission_statements`
--
ALTER TABLE `commission_statements`
  ADD PRIMARY KEY (`CommStatementID`);

--
-- Indexes for table `email_queue`
--
ALTER TABLE `email_queue`
  ADD PRIMARY KEY (`EmailQueueID`),
  ADD KEY `EmailQueueID` (`EmailQueueID`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`FileID`),
  ADD KEY `DocumentID` (`FileID`),
  ADD KEY `FileID` (`FileID`);

--
-- Indexes for table `file_categories`
--
ALTER TABLE `file_categories`
  ADD PRIMARY KEY (`FileCategoryID`);

--
-- Indexes for table `file_items`
--
ALTER TABLE `file_items`
  ADD PRIMARY KEY (`FileItemID`),
  ADD KEY `DocumentID` (`FileID`);

--
-- Indexes for table `file_sub_categories`
--
ALTER TABLE `file_sub_categories`
  ADD PRIMARY KEY (`FileSubCategoryID`);

--
-- Indexes for table `options`
--
ALTER TABLE `options`
  ADD PRIMARY KEY (`OptionID`);

--
-- Indexes for table `option_groups`
--
ALTER TABLE `option_groups`
  ADD PRIMARY KEY (`OptionGroupID`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`PaymentID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`ProductID`);

--
-- Indexes for table `product_items`
--
ALTER TABLE `product_items`
  ADD PRIMARY KEY (`ProductItemID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `user_capabilities`
--
ALTER TABLE `user_capabilities`
  ADD PRIMARY KEY (`UserCapabilityID`),
  ADD KEY `UserCapabilityID` (`UserCapabilityID`);

--
-- Indexes for table `user_capability_groups`
--
ALTER TABLE `user_capability_groups`
  ADD PRIMARY KEY (`UserCapabilityGroupID`);

--
-- Indexes for table `user_levels`
--
ALTER TABLE `user_levels`
  ADD PRIMARY KEY (`UserLevelID`);

--
-- Indexes for table `user_meta`
--
ALTER TABLE `user_meta`
  ADD PRIMARY KEY (`UserMetaID`),
  ADD UNIQUE KEY `UserID` (`UserID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `AccountID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10091;
--
-- AUTO_INCREMENT for table `account_beneficiaries`
--
ALTER TABLE `account_beneficiaries`
  MODIFY `BeneficiaryID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `account_meta`
--
ALTER TABLE `account_meta`
  MODIFY `AccountMetaID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10056;
--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `ActivityID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=309;
--
-- AUTO_INCREMENT for table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `BankAccountID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;
--
-- AUTO_INCREMENT for table `commission_overriding`
--
ALTER TABLE `commission_overriding`
  MODIFY `CommOverideID` int(15) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `commission_personal`
--
ALTER TABLE `commission_personal`
  MODIFY `CommPersonalID` int(15) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `commission_scheme`
--
ALTER TABLE `commission_scheme`
  MODIFY `SchemeID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `commission_statements`
--
ALTER TABLE `commission_statements`
  MODIFY `CommStatementID` int(21) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `email_queue`
--
ALTER TABLE `email_queue`
  MODIFY `EmailQueueID` int(21) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `FileID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4101;
--
-- AUTO_INCREMENT for table `file_categories`
--
ALTER TABLE `file_categories`
  MODIFY `FileCategoryID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `file_items`
--
ALTER TABLE `file_items`
  MODIFY `FileItemID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=311;
--
-- AUTO_INCREMENT for table `file_sub_categories`
--
ALTER TABLE `file_sub_categories`
  MODIFY `FileSubCategoryID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `options`
--
ALTER TABLE `options`
  MODIFY `OptionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `option_groups`
--
ALTER TABLE `option_groups`
  MODIFY `OptionGroupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `PaymentID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `ProductID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210009;
--
-- AUTO_INCREMENT for table `product_items`
--
ALTER TABLE `product_items`
  MODIFY `ProductItemID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10048;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100136;
--
-- AUTO_INCREMENT for table `user_capabilities`
--
ALTER TABLE `user_capabilities`
  MODIFY `UserCapabilityID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;
--
-- AUTO_INCREMENT for table `user_capability_groups`
--
ALTER TABLE `user_capability_groups`
  MODIFY `UserCapabilityGroupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `user_levels`
--
ALTER TABLE `user_levels`
  MODIFY `UserLevelID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `user_meta`
--
ALTER TABLE `user_meta`
  MODIFY `UserMetaID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
