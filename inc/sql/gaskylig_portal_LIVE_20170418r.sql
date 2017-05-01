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
-- Database: `gaskylig_portal`
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
(10098, 100149, '', 0, 118, 'Individual', '', '', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', '', '2017-04-13 05:02:17', 'Pending', 0, 0, '0000-00-00', 0, '', '', '', '', 0, '0000-00-00', '0000-00-00 00:00:00', 0, '0000-00-00', '', '0000-00-00', 0, '0000-00-00', 'Traditional', '', 0),
(10099, 100150, '', 1, 119, 'Individual', '', '1232132131@23123123.com', 1, '7', '12', '', '', '', '', 0, '', '', '', '', '', '', 'China', '2017-04-18 05:54:16', 'Approved', 210001, 10038, '0000-00-00', 0, '1000', '1000', '2%', '1%', 0, '2017-04-24', '0000-00-00 00:00:00', 0, '2020-04-23', '大大妈', '2017-04-18', 200000, '0000-00-00', 'Traditional', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `account_beneficiaries`
--

CREATE TABLE `account_beneficiaries` (
  `BeneficiaryID` int(21) NOT NULL,
  `AccountID` int(21) NOT NULL,
  `UserID` int(15) NOT NULL,
  `ABFirstName` varchar(128) NOT NULL,
  `ABLastName` varchar(128) NOT NULL,
  `ABPhone` varchar(32) NOT NULL,
  `ABEmail` varchar(64) NOT NULL,
  `ABRelationship` varchar(64) NOT NULL,
  `ABAddress1` varchar(256) NOT NULL,
  `ABPercentage` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `account_beneficiaries`
--

INSERT INTO `account_beneficiaries` (`BeneficiaryID`, `AccountID`, `UserID`, `ABFirstName`, `ABLastName`, `ABPhone`, `ABEmail`, `ABRelationship`, `ABAddress1`, `ABPercentage`) VALUES
(17, 10094, 100140, '', '', '', '', '', '', ''),
(18, 10094, 100140, '', '', '', '', '', '', ''),
(19, 10097, 100148, '', '', '', '', '', '', ''),
(20, 10097, 100148, '', '', '', '', '', '', ''),
(21, 10099, 100150, '大大', '妈', '1231231', '3123123@123213123.COM', '123123', '123123', '100'),
(22, 10099, 100150, '', '', '', '', '', '', '');

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
(1, 0, 'yes', '大大妈', '1231231233', 0, 0, 4250, 0, 0, 0, 0, '123123123', '123123123123', 'Y', 0, 4231, 0, 0, 4234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', 0, '', '', 0, '', '', 0, '0000-00-00', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, 0, '大大妈', 4247, '2017-04-18');

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
(355, '2017-04-11 09:23:29', 'Added User #100136.', 100086, 'Ryan Dumajil'),
(356, '2017-04-11 09:24:08', 'Updated User #100136.', 100086, 'Ryan Dumajil'),
(357, '2017-04-11 09:24:36', 'Updated User #100136.', 100086, 'Ryan Dumajil'),
(358, '2017-04-11 09:25:55', 'Updated User #100136.', 100136, 'Jeremiah Togonon'),
(359, '2017-04-12 12:56:35', 'Trashed User #100109.', 100079, 'Global Asset'),
(360, '2017-04-12 12:56:42', 'Trashed User #100095.', 100079, 'Global Asset'),
(361, '2017-04-12 12:56:47', 'Trashed User #100085.', 100079, 'Global Asset'),
(362, '2017-04-12 13:00:35', 'Added Agency #GAA-100137.', 100079, 'Global Asset'),
(363, '2017-04-12 13:03:10', 'Added Agency #GAA-100138.', 100079, 'Global Asset'),
(364, '2017-04-12 13:05:44', 'Added Agent #GA-100139.', 100079, 'Global Asset'),
(365, '2017-04-12 13:08:57', 'Updated Casefile #GA-CF-10056\r\nStep 1', 100138, 'Global Asset'),
(366, '2017-04-12 13:13:41', 'Sent demand note email for casefile #GA-CF-10094.', 100138, 'Global Asset'),
(367, '2017-04-12 13:17:24', 'Add payment transaction for Casefile #GA-CF-10094.', 100079, 'Global Asset'),
(368, '2017-04-12 13:17:39', 'Add payment transaction for Casefile #GA-CF-10094.', 100079, 'Global Asset'),
(369, '2017-04-12 13:18:32', 'Updated Casefile #GA-CF-10056\r\nStep 4', 100079, 'Global Asset'),
(370, '2017-04-12 13:18:42', 'Sent acknowledment receipt email for casefile #GA-CF-10094.', 100079, 'Global Asset'),
(371, '2017-04-12 13:19:26', 'Updated Casefile #GA-CF-10056\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(372, '2017-04-12 13:21:14', 'Updated Casefile #GA-CF-10056\r\nStep 5: Set account status to Pending', 100079, 'Global Asset'),
(373, '2017-04-12 13:21:23', 'Updated Casefile #GA-CF-10056\r\nStep 1', 100079, 'Global Asset'),
(374, '2017-04-12 13:21:44', 'Updated Casefile #GA-CF-10056\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(375, '2017-04-12 13:24:00', 'Updated Casefile #GA-CF-10056\r\nStep 1', 100079, 'Global Asset'),
(376, '2017-04-12 13:24:18', 'Updated Casefile #GA-CF-10056\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(377, '2017-04-12 13:24:34', 'Sent client commencement letter with casefile #GA-CF-10094.', 100079, 'Global Asset'),
(378, '2017-04-12 13:24:34', 'Sent commencement email letter for casefile #GA-CF-10094.', 100079, 'Global Asset'),
(379, '2017-04-12 14:54:06', 'Updated Agency #GAA-100137.', 100086, 'Ryan Dumajil'),
(380, '2017-04-12 14:55:01', 'Updated Agency #GAA-100138.', 100086, 'Ryan Dumajil'),
(381, '2017-04-12 14:55:32', 'Updated Agency #GAA-100138.', 100086, 'Ryan Dumajil'),
(382, '2017-04-12 16:09:01', 'Updated User #100079.', 100000, 'Moises Goloyugo'),
(383, '2017-04-12 16:11:49', 'Updated User #100001.', 100079, 'Global Asset'),
(384, '2017-04-12 16:18:33', 'Sent commencement email letter for casefile #GA-CF-10094.', 100079, 'Global Asset'),
(385, '2017-04-12 16:21:47', 'Sent client commencement letter with casefile #GA-CF-10094.', 100079, 'Global Asset'),
(386, '2017-04-12 16:21:47', 'Sent commencement email letter for casefile #GA-CF-10094.', 100079, 'Global Asset'),
(387, '2017-04-12 16:22:02', 'Updated Casefile #GA-CF-10056\r\nStep 4', 100079, 'Global Asset'),
(388, '2017-04-12 16:22:24', 'Sent client commencement letter with casefile #GA-CF-10094.', 100079, 'Global Asset'),
(389, '2017-04-12 16:22:24', 'Sent commencement email letter for casefile #GA-CF-10094.', 100079, 'Global Asset'),
(390, '2017-04-13 02:19:18', 'Trashed Casefile #GA-CF-10094.', 100079, 'Global Asset'),
(391, '2017-04-13 02:19:24', 'Empty trash bin.', 100079, 'Global Asset'),
(392, '2017-04-13 02:19:32', 'Deleted Agent #GA-100139.', 100079, 'Global Asset'),
(393, '2017-04-13 02:21:13', 'Updated Agency #GAA-100138.', 100079, 'Global Asset'),
(394, '2017-04-13 02:21:58', 'Updated Agency #GAA-100137.', 100079, 'Global Asset'),
(395, '2017-04-13 02:30:16', 'Trashed User #100140.', 100079, 'Global Asset'),
(396, '2017-04-13 02:45:26', 'Updated User #100120.', 100079, 'Global Asset'),
(397, '2017-04-13 02:46:28', 'Updated User #100120.', 100079, 'Global Asset'),
(398, '2017-04-13 02:46:47', 'Updated User #100121.', 100079, 'Global Asset'),
(399, '2017-04-13 02:47:08', 'Updated User #100119.', 100079, 'Global Asset'),
(400, '2017-04-13 02:48:19', 'Added User #100141.', 100079, 'Global Asset'),
(401, '2017-04-13 02:48:34', 'Updated User #100141.', 100079, 'Global Asset'),
(402, '2017-04-13 02:48:48', 'Updated User #100141.', 100079, 'Global Asset'),
(403, '2017-04-13 02:50:42', 'Added User #100142.', 100079, 'Global Asset'),
(404, '2017-04-13 02:51:00', 'Updated User #100142.', 100079, 'Global Asset'),
(405, '2017-04-13 02:51:40', 'Added User #100143.', 100079, 'Global Asset'),
(406, '2017-04-13 02:51:52', 'Updated User #100143.', 100079, 'Global Asset'),
(407, '2017-04-13 02:52:21', 'Added User #100144.', 100079, 'Global Asset'),
(408, '2017-04-13 02:52:46', 'Updated User #100144.', 100079, 'Global Asset'),
(409, '2017-04-13 02:53:30', 'Added User #100145.', 100079, 'Global Asset'),
(410, '2017-04-13 02:53:44', 'Updated User #100145.', 100079, 'Global Asset'),
(411, '2017-04-13 02:54:33', 'Updated User #100120.', 100079, 'Global Asset'),
(412, '2017-04-13 02:54:37', 'Updated User #100141.', 100079, 'Global Asset'),
(413, '2017-04-13 02:54:42', 'Updated User #100142.', 100079, 'Global Asset'),
(414, '2017-04-13 02:57:04', 'Updated Agency #GAA-100137.', 100079, 'Global Asset'),
(415, '2017-04-13 02:58:41', 'Added Agency #GAA-100146.', 100079, 'Global Asset'),
(416, '2017-04-13 02:59:02', 'Updated Agency #GAA-100146.', 100079, 'Global Asset'),
(417, '2017-04-13 02:59:51', 'Added Agent #GA-100147.', 100079, 'Global Asset'),
(418, '2017-04-13 03:00:13', 'Updated Agent #GA-100147.', 100079, 'Global Asset'),
(419, '2017-04-13 03:04:53', 'Trashed Casefile #GA-CF-10097.', 100079, 'Global Asset'),
(420, '2017-04-13 03:04:58', 'Empty trash bin.', 100079, 'Global Asset'),
(421, '2017-04-13 03:08:56', 'Updated User #100137.', 100079, 'Global Asset'),
(422, '2017-04-13 03:09:05', 'Updated User #100138.', 100079, 'Global Asset'),
(423, '2017-04-13 03:51:11', 'Trashed User #100148.', 100086, 'Ryan Dumajil'),
(424, '2017-04-13 03:53:57', 'Deleted User #100085.', 100086, 'Ryan Dumajil'),
(425, '2017-04-13 03:54:00', 'Deleted User #100109.', 100086, 'Ryan Dumajil'),
(426, '2017-04-13 03:54:03', 'Deleted User #100095.', 100086, 'Ryan Dumajil'),
(427, '2017-04-13 05:02:17', 'Added Agent #GA-100149.', 100137, '5 Stones'),
(428, '2017-04-13 08:39:02', 'Updated User #100143.', 100143, 'Jeff Goh'),
(429, '2017-04-13 08:41:05', 'Updated User #100143.', 100079, 'Global Asset'),
(430, '2017-04-14 17:52:44', 'Updated User #100145.', 100145, 'Dr Choo'),
(431, '2017-04-14 17:53:01', 'Updated User #100145.', 100145, 'Dr Choo'),
(432, '2017-04-14 18:19:34', 'Added Media File.', 100079, 'Global Asset'),
(433, '2017-04-14 18:20:10', 'Added Media File.', 100079, 'Global Asset'),
(434, '2017-04-14 18:20:31', 'Added Media File.', 100079, 'Global Asset'),
(435, '2017-04-14 18:20:50', 'Added Media File.', 100079, 'Global Asset'),
(436, '2017-04-14 18:21:23', 'Updated File #4154.', 100079, 'Global Asset'),
(437, '2017-04-14 18:21:45', 'Added Media File.', 100079, 'Global Asset'),
(438, '2017-04-14 18:22:12', 'Added Media File.', 100079, 'Global Asset'),
(439, '2017-04-14 18:24:24', 'Added Media File.', 100079, 'Global Asset'),
(440, '2017-04-14 18:24:45', 'Added Media File.', 100079, 'Global Asset'),
(441, '2017-04-14 18:25:07', 'Added Media File.', 100079, 'Global Asset'),
(442, '2017-04-14 18:25:28', 'Added Media File.', 100079, 'Global Asset'),
(443, '2017-04-14 18:25:43', 'Added Media File.', 100079, 'Global Asset'),
(444, '2017-04-14 18:28:15', 'Added Media File.', 100079, 'Global Asset'),
(445, '2017-04-14 18:28:30', 'Added Media File.', 100079, 'Global Asset'),
(446, '2017-04-14 18:28:50', 'Added Media File.', 100079, 'Global Asset'),
(447, '2017-04-14 18:29:06', 'Added Media File.', 100079, 'Global Asset'),
(448, '2017-04-14 18:29:21', 'Added Media File.', 100079, 'Global Asset'),
(449, '2017-04-14 18:29:34', 'Added Media File.', 100079, 'Global Asset'),
(450, '2017-04-14 18:29:57', 'Added Media File.', 100079, 'Global Asset'),
(451, '2017-04-14 18:30:09', 'Added Media File.', 100079, 'Global Asset'),
(452, '2017-04-14 18:30:20', 'Added Media File.', 100079, 'Global Asset'),
(453, '2017-04-14 18:30:39', 'Added Media File.', 100079, 'Global Asset'),
(454, '2017-04-14 18:30:52', 'Added Media File.', 100079, 'Global Asset'),
(455, '2017-04-14 18:34:16', 'Updated File #4172.', 100079, 'Global Asset'),
(456, '2017-04-17 05:55:26', 'Deleted Product #PRD-210008.', 100086, 'Ryan Dumajil'),
(457, '2017-04-17 05:55:33', 'Deleted Product #PRD-210007.', 100086, 'Ryan Dumajil'),
(458, '2017-04-17 06:29:27', 'Updated File #4172.', 100079, 'Global Asset'),
(459, '2017-04-17 06:29:37', 'Updated File #4172.', 100079, 'Global Asset'),
(460, '2017-04-17 06:29:41', 'Updated File #4171.', 100079, 'Global Asset'),
(461, '2017-04-17 06:30:35', 'Updated File #4171.', 100079, 'Global Asset'),
(462, '2017-04-17 06:45:44', 'Updated File #4158.', 100079, 'Global Asset'),
(463, '2017-04-17 07:19:30', 'Updated File #4158.', 100079, 'Global Asset'),
(464, '2017-04-17 07:19:41', 'Updated File #4157.', 100079, 'Global Asset'),
(465, '2017-04-17 07:29:11', 'Updated File #4172.', 100079, 'Global Asset'),
(466, '2017-04-17 07:48:35', 'Added Media File.', 100079, 'Global Asset'),
(467, '2017-04-17 08:04:12', 'Deleted File #4161.', 100079, 'Global Asset'),
(468, '2017-04-17 08:04:23', 'Deleted File #4165.', 100079, 'Global Asset'),
(469, '2017-04-17 08:04:29', 'Deleted File #4164.', 100079, 'Global Asset'),
(470, '2017-04-17 08:04:38', 'Deleted File #4163.', 100079, 'Global Asset'),
(471, '2017-04-17 08:04:47', 'Deleted File #4162.', 100079, 'Global Asset'),
(472, '2017-04-17 08:05:40', 'Added Media File.', 100079, 'Global Asset'),
(473, '2017-04-17 08:05:55', 'Added Media File.', 100079, 'Global Asset'),
(474, '2017-04-17 08:06:06', 'Added Media File.', 100079, 'Global Asset'),
(475, '2017-04-17 08:06:19', 'Added Media File.', 100079, 'Global Asset'),
(476, '2017-04-17 08:06:30', 'Added Media File.', 100079, 'Global Asset'),
(477, '2017-04-17 08:06:40', 'Added Media File.', 100079, 'Global Asset'),
(478, '2017-04-17 08:28:35', 'Updated File #4170.', 100079, 'Global Asset'),
(479, '2017-04-17 08:28:40', 'Updated File #4169.', 100079, 'Global Asset'),
(480, '2017-04-17 08:28:43', 'Updated File #4168.', 100079, 'Global Asset'),
(481, '2017-04-17 08:28:46', 'Updated File #4167.', 100079, 'Global Asset'),
(482, '2017-04-17 08:28:49', 'Updated File #4166.', 100079, 'Global Asset'),
(483, '2017-04-17 08:28:53', 'Updated File #4160.', 100079, 'Global Asset'),
(484, '2017-04-17 08:32:15', 'Updated File #4156.', 100079, 'Global Asset'),
(485, '2017-04-17 08:32:18', 'Updated File #4155.', 100079, 'Global Asset'),
(486, '2017-04-17 08:32:25', 'Updated File #4154.', 100079, 'Global Asset'),
(487, '2017-04-17 08:32:28', 'Updated File #4153.', 100079, 'Global Asset'),
(488, '2017-04-17 08:32:32', 'Updated File #4152.', 100079, 'Global Asset'),
(489, '2017-04-17 08:32:35', 'Updated File #4151.', 100079, 'Global Asset'),
(490, '2017-04-17 08:35:32', 'Added Media File.', 100079, 'Global Asset'),
(491, '2017-04-18 01:57:13', 'Deleted File #4159.', 100079, 'Global Asset'),
(492, '2017-04-18 05:56:43', 'Approved client file #GA-UF-348.', 100079, 'Global Asset'),
(493, '2017-04-18 05:56:45', 'Approved client file #GA-UF-345.', 100079, 'Global Asset'),
(494, '2017-04-18 05:59:59', 'Updated Casefile #GA-CF-1\r\nStep 4', 100079, 'Global Asset'),
(495, '2017-04-18 06:00:10', 'Add payment transaction for Casefile #GA-CF-10099.', 100079, 'Global Asset'),
(496, '2017-04-18 06:00:33', 'Add payment transaction for Casefile #GA-CF-10099.', 100079, 'Global Asset'),
(497, '2017-04-18 06:01:04', 'Sent acknowledment receipt email for casefile #GA-CF-10099.', 100079, 'Global Asset'),
(498, '2017-04-18 06:02:06', 'Updated Casefile #GA-CF-1\r\nStep 5: Set account status to Approved', 100079, 'Global Asset'),
(499, '2017-04-18 06:03:15', 'Sent commencement email letter for casefile #GA-CF-10099.', 100079, 'Global Asset'),
(500, '2017-04-18 06:14:44', 'Sent demand note email for casefile #GA-CF-10099.', 100000, 'Moises Goloyugo'),
(501, '2017-04-18 08:04:38', 'Updated Casefile #GA-CF-1\r\nStep 2', 100000, 'Moises Goloyugo'),
(502, '2017-04-18 08:06:08', 'Updated Casefile #GA-CF-1\r\nStep 2', 100000, 'Moises Goloyugo'),
(503, '2017-04-18 08:06:38', 'Approved client file #GA-UF-353.', 100000, 'Moises Goloyugo'),
(504, '2017-04-18 08:06:48', 'Approved client file #GA-UF-354.', 100000, 'Moises Goloyugo'),
(505, '2017-04-18 08:07:30', 'Updated Casefile #GA-CF-1\r\nStep 3', 100000, 'Moises Goloyugo'),
(506, '2017-04-18 11:34:28', 'Added Media Category #FileCategoryID5.', 100000, 'Moises Goloyugo');

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
(74, 100086, '', '', '2016-12-09 14:21:59', '', '', '', 'N'),
(108, 100137, '', '', '2017-04-12 13:00:35', '', '', '', 'N'),
(109, 100138, '', '', '2017-04-12 13:03:10', '', '', '', 'N'),
(115, 100146, '', '', '2017-04-13 02:58:41', '', '', '', 'N'),
(116, 100147, '', '', '2017-04-13 02:59:51', '', '', '', 'N'),
(118, 100149, '', '', '2017-04-13 05:02:17', '', '', '', 'N'),
(119, 100150, '大大妈', 'asdasdasd', '2017-04-18 05:59:59', 'asdasd', 'asdasdasd', 'asdasd', 'N');

-- --------------------------------------------------------

--
-- Table structure for table `commission_overriding`
--

CREATE TABLE `commission_overriding` (
  `CommOverideID` int(15) NOT NULL,
  `CODate` date NOT NULL,
  `COAccountID` int(15) NOT NULL,
  `COPdtType` varchar(264) NOT NULL,
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
  `CPPdtType` varchar(264) NOT NULL,
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
  `PayeeName` varchar(128) NOT NULL,
  `TerritoryID` int(21) NOT NULL,
  `Currency` int(21) NOT NULL,
  `PlantID` int(21) NOT NULL,
  `CommencementDate` date NOT NULL,
  `Position` varchar(128) NOT NULL,
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
  `FileSubCategoryID` int(11) DEFAULT '0',
  `FileAccess` text CHARACTER SET utf8 NOT NULL,
  `DateAdded` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`FileID`, `UserID`, `FileCategoryID`, `FileSubCategoryID`, `FileAccess`, `DateAdded`) VALUES
(2578, 100000, 0, 0, '', '2016-11-16 03:45:48'),
(3744, 100086, 0, 0, '', '2017-02-16 17:48:48'),
(3745, 100001, 0, 0, '', '2017-02-16 17:50:54'),
(3747, 100095, 0, 0, '', '2017-02-16 17:51:21'),
(3748, 100109, 0, 0, '', '2017-02-21 09:04:24'),
(3795, 100079, 0, 0, '', '2017-02-23 10:13:22'),
(4111, 100140, 0, 0, '', '2017-04-12 13:08:29'),
(4117, 100140, 0, 0, '', '2017-04-12 13:08:29'),
(4119, 100140, 0, 0, '', '2017-04-12 13:08:29'),
(4150, 100143, 0, 0, '', '2017-04-13 08:39:02'),
(4151, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:19:34'),
(4152, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:20:10'),
(4153, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:20:31'),
(4154, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:20:50'),
(4155, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:21:45'),
(4156, 100079, 3, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:22:12'),
(4157, 100079, 2, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:24:24'),
(4158, 100079, 2, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:24:45'),
(4160, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:25:28'),
(4166, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:29:21'),
(4167, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:29:34'),
(4168, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:29:57'),
(4169, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:30:09'),
(4170, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:30:20'),
(4171, 100079, 4, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:30:39'),
(4172, 100079, 4, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-14 18:30:52'),
(4173, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 07:48:35'),
(4174, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:05:40'),
(4175, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:05:55'),
(4176, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:06:06'),
(4177, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:06:19'),
(4178, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:06:30'),
(4179, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:06:40'),
(4180, 100079, 1, 0, 'YTozOntpOjA7czo2OiIxMDAxMzciO2k6MTtzOjY6IjEwMDEzOCI7aToyO3M6NjoiMTAwMTQ2Ijt9', '2017-04-17 08:35:32'),
(4181, 100150, 0, 0, '', '2017-04-18 05:54:16'),
(4186, 100150, 0, 0, '', '2017-04-18 05:54:16'),
(4191, 100150, 0, 0, '', '2017-04-18 05:54:16'),
(4192, 100150, 0, 0, '', '2017-04-18 05:54:16'),
(4199, 100150, 0, 0, '', '2017-04-18 08:04:04'),
(4202, 100150, 0, 0, '', '2017-04-18 08:04:04'),
(4215, 100150, 0, 0, '', '2017-04-18 08:04:38'),
(4218, 100150, 0, 0, '', '2017-04-18 08:04:38'),
(4231, 100150, 0, 0, '', '2017-04-18 08:06:08'),
(4234, 100150, 0, 0, '', '2017-04-18 08:06:08'),
(4247, 100150, 0, 0, '', '2017-04-18 08:07:30'),
(4250, 100150, 0, 0, '', '2017-04-18 08:07:30');

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
(4, 'Others', ''),
(5, 'Chris', '');

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
(164, 100000, 2578, 'Avatar', '6f192427_charcoal.jpg', '', 'C:\\xampp\\htdocs\\odeonco.loc\\app\\views\\odeon\\assets\\files\\2016\\11\\16\\6f192427_charcoal.jpg', '/2016/11/16/6f192427_charcoal.jpg', 0),
(232, 100086, 3744, 'Avatar', 'ryan_dumajil_avatar_ryan.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/ryan_dumajil_avatar_ryan.jpg', '/2017/02/16/ryan_dumajil_avatar_ryan.jpg', 0),
(233, 100001, 3745, 'Avatar', 'globalassets_trust_avatar_user.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/globalassets_trust_avatar_user.png', '/2017/02/16/globalassets_trust_avatar_user.png', 0),
(235, 100095, 3747, 'Avatar', 'sy_yap_avatar_user.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/16/sy_yap_avatar_user.png', '/2017/02/16/sy_yap_avatar_user.png', 0),
(236, 100109, 3748, 'Avatar', 'jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/21/jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', '/2017/02/21/jeff_gohweiming_avatar_f4dcaf7cf85390b50e4374700540c5f1.jpg', 0),
(250, 100079, 3795, 'Avatar', 'global_asset_avatar_logo-globalasset20.jpg', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/02/23/global_asset_avatar_logo-globalasset20.jpg', '/2017/02/23/global_asset_avatar_logo-globalasset20.jpg', 0),
(311, 100140, 4111, 'IABankstatement', 'testing1_testing1_iabankstatement_8.png', 'IABankstatement', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/12/testing1_testing1_iabankstatement_8.png', '/2017/04/12/testing1_testing1_iabankstatement_8.png', 0),
(312, 100140, 4117, 'UBOSales', 'testing1_testing1_ubosales_m.png', 'UBOSales', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/12/testing1_testing1_ubosales_m.png', '/2017/04/12/testing1_testing1_ubosales_m.png', 0),
(313, 100140, 4119, 'IASpecimensign', 'testing1_testing1_iaspecimensign_2d809be8.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/12/testing1_testing1_iaspecimensign_2d809be8.png', '/2017/04/12/testing1_testing1_iaspecimensign_2d809be8.png', 0),
(314, 100143, 4150, 'Avatar', 'jeff_goh_2.jpg', 'Avatar', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/13/jeff_goh_2.jpg', '/2017/04/13/jeff_goh_2.jpg', 0),
(315, 100079, 4151, 'IGT-InvestmentReport-2015Q4-201601', 'IGT-InvestmentReport-2015Q4-201601_1.pdf', 'IGT-InvestmentReport-2015Q4-201601', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2015Q4-201601_1.pdf', '/2017/04/14/IGT-InvestmentReport-2015Q4-201601_1.pdf', 0),
(316, 100079, 4152, 'IGT-InvestmentReport-2016Q1-201604', 'IGT-InvestmentReport-2016Q1-201604_4.pdf', 'IGT-InvestmentReport-2016Q1-201604', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2016Q1-201604_4.pdf', '/2017/04/14/IGT-InvestmentReport-2016Q1-201604_4.pdf', 0),
(317, 100079, 4153, 'IGT-InvestmentReport-2016Q2-201607', 'IGT-InvestmentReport-2016Q2-201607_7.pdf', 'IGT-InvestmentReport-2016Q2-201607', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2016Q2-201607_7.pdf', '/2017/04/14/IGT-InvestmentReport-2016Q2-201607_7.pdf', 0),
(318, 100079, 4154, 'IGT-InvestmentReport-2016Q3-201610', 'IGT-InvestmentReport-2016Q3-201610_0.pdf', 'IGT-InvestmentReport-2016Q3-201610', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2016Q3-201610_0.pdf', '/2017/04/14/IGT-InvestmentReport-2016Q3-201610_0.pdf', 0),
(319, 100079, 4155, 'IGT-InvestmentReport-2016Q4-201701', 'IGT-InvestmentReport-2016Q4-201701_1.pdf', 'IGT-InvestmentReport-2016Q4-201701', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2016Q4-201701_1.pdf', '/2017/04/14/IGT-InvestmentReport-2016Q4-201701_1.pdf', 0),
(320, 100079, 4156, 'IGT-InvestmentReport-2017Q1-201704', 'IGT-InvestmentReport-2017Q1-201704_4.pdf', 'IGT-InvestmentReport-2017Q1-201704', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/IGT-InvestmentReport-2017Q1-201704_4.pdf', '/2017/04/14/IGT-InvestmentReport-2017Q1-201704_4.pdf', 0),
(321, 100079, 4157, 'GA-Skylight-SubscriptionForm-ENG-SCH', 'GA-Skylight-SubscriptionForm-ENG-SCH_H.pdf', 'GA-Skylight-SubscriptionForm-ENG-SCH', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-SubscriptionForm-ENG-SCH_H.pdf', '/2017/04/14/GA-Skylight-SubscriptionForm-ENG-SCH_H.pdf', 0),
(322, 100079, 4158, 'GA-Skylight-SubscriptionForm-ENG-TCH', 'GA-Skylight-SubscriptionForm-ENG-TCH_H.pdf', 'GA-Skylight-SubscriptionForm-ENG-TCH', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-SubscriptionForm-ENG-TCH_H.pdf', '/2017/04/14/GA-Skylight-SubscriptionForm-ENG-TCH_H.pdf', 0),
(324, 100079, 4160, 'GA-Skylight-Booklet-ENG', 'GA-Skylight-Booklet-ENG_G.pdf', 'GA-Skylight-Booklet-ENG', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-Booklet-ENG_G.pdf', '/2017/04/14/GA-Skylight-Booklet-ENG_G.pdf', 0),
(330, 100079, 4166, 'GA-Skylight-SlideDeck-ENG-201704-LV', 'GA-Skylight-SlideDeck-ENG-201704-LV_V.pdf', 'GA-Skylight-SlideDeck-ENG-201704-LV', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-SlideDeck-ENG-201704-LV_V.pdf', '/2017/04/14/GA-Skylight-SlideDeck-ENG-201704-LV_V.pdf', 0),
(331, 100079, 4167, 'GA-Skylight-SlideDeck-SimCHN-201704-LV', 'GA-Skylight-SlideDeck-SimCHN-201704-LV_V.pdf', 'GA-Skylight-SlideDeck-SimCHN-201704-LV', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-SlideDeck-SimCHN-201704-LV_V.pdf', '/2017/04/14/GA-Skylight-SlideDeck-SimCHN-201704-LV_V.pdf', 0),
(332, 100079, 4168, 'GA-Skylight-SlideDeck-TradCHN-201704-LV', 'GA-Skylight-SlideDeck-TradCHN-201704-LV_V.pdf', 'GA-Skylight-SlideDeck-TradCHN-201704-LV', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-SlideDeck-TradCHN-201704-LV_V.pdf', '/2017/04/14/GA-Skylight-SlideDeck-TradCHN-201704-LV_V.pdf', 0),
(333, 100079, 4169, 'GA-Skylight-StrategicPartners-CHN', 'GA-Skylight-StrategicPartners-CHN_N.pdf', 'GA-Skylight-StrategicPartners-CHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-StrategicPartners-CHN_N.pdf', '/2017/04/14/GA-Skylight-StrategicPartners-CHN_N.pdf', 0),
(334, 100079, 4170, 'GA-Skylight-StrategicPartners-ENG', 'GA-Skylight-StrategicPartners-ENG_G.pdf', 'GA-Skylight-StrategicPartners-ENG', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-Skylight-StrategicPartners-ENG_G.pdf', '/2017/04/14/GA-Skylight-StrategicPartners-ENG_G.pdf', 0),
(335, 100079, 4171, 'GA-CommencementPackage-Sample', 'GA-CommencementPackage-Sample_e.pdf', 'GA-CommencementPackage-Sample', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/GA-CommencementPackage-Sample_e.pdf', '/2017/04/14/GA-CommencementPackage-Sample_e.pdf', 0),
(336, 100079, 4172, 'Marina-GA-Skylight-EscrowTrustOpeningPackage', 'Marina-GA-Skylight-EscrowTrustOpeningPackage_e.pdf', 'Marina-GA-Skylight-EscrowTrustOpeningPackage', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/14/Marina-GA-Skylight-EscrowTrustOpeningPackage_e.pdf', '/2017/04/14/Marina-GA-Skylight-EscrowTrustOpeningPackage_e.pdf', 0),
(337, 100079, 4173, 'GA-Skylight-PresentationDeck-ENG', 'GA-Skylight-PresentationDeck-ENG_G.pdf', 'GA-Skylight-PresentationDeck-ENG', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-PresentationDeck-ENG_G.pdf', '/2017/04/17/GA-Skylight-PresentationDeck-ENG_G.pdf', 0),
(338, 100079, 4174, 'GA-Skylight-Booklet-SimCHN', 'GA-Skylight-Booklet-SimCHN_N.pdf', 'GA-Skylight-Booklet-SimCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-Booklet-SimCHN_N.pdf', '/2017/04/17/GA-Skylight-Booklet-SimCHN_N.pdf', 0),
(339, 100079, 4175, 'GA-Skylight-Booklet-TradCHN', 'GA-Skylight-Booklet-TradCHN_N.pdf', 'GA-Skylight-Booklet-TradCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-Booklet-TradCHN_N.pdf', '/2017/04/17/GA-Skylight-Booklet-TradCHN_N.pdf', 0),
(340, 100079, 4176, 'GA-Skylight-PHS-ENG-SimCHN', 'GA-Skylight-PHS-ENG-SimCHN_N.pdf', 'GA-Skylight-PHS-ENG-SimCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-PHS-ENG-SimCHN_N.pdf', '/2017/04/17/GA-Skylight-PHS-ENG-SimCHN_N.pdf', 0),
(341, 100079, 4177, 'GA-Skylight-PHS-ENG-TradCHN', 'GA-Skylight-PHS-ENG-TradCHN_N.pdf', 'GA-Skylight-PHS-ENG-TradCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-PHS-ENG-TradCHN_N.pdf', '/2017/04/17/GA-Skylight-PHS-ENG-TradCHN_N.pdf', 0),
(342, 100079, 4178, 'GA-Skylight-PresentationDeck-SimCHN', 'GA-Skylight-PresentationDeck-SimCHN_N.pdf', 'GA-Skylight-PresentationDeck-SimCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-PresentationDeck-SimCHN_N.pdf', '/2017/04/17/GA-Skylight-PresentationDeck-SimCHN_N.pdf', 0),
(343, 100079, 4179, 'GA-Skylight-PresentationDeck-TradCHN', 'GA-Skylight-PresentationDeck-TradCHN_N.pdf', 'GA-Skylight-PresentationDeck-TradCHN', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-Skylight-PresentationDeck-TradCHN_N.pdf', '/2017/04/17/GA-Skylight-PresentationDeck-TradCHN_N.pdf', 0),
(344, 100079, 4180, 'GA-RecentInvestmentPerformanceTrackRecords-20170411', 'GA-RecentInvestmentPerformanceTrackRecords-20170411_1.pdf', 'GA-RecentInvestmentPerformanceTrackRecords-20170411', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/17/GA-RecentInvestmentPerformanceTrackRecords-20170411_1.pdf', '/2017/04/17/GA-RecentInvestmentPerformanceTrackRecords-20170411_1.pdf', 0),
(345, 100150, 4181, 'IAPhotoid', '大妈_你_iaphotoid_0.png', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaphotoid_0.png', '/2017/04/18/大妈_你_iaphotoid_0.png', 1),
(346, 100150, 4186, 'UBOBusiness', '大妈_你_ubobusiness_8.png', 'UBOBusiness', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_ubobusiness_8.png', '/2017/04/18/大妈_你_ubobusiness_8.png', 0),
(347, 100150, 4191, 'IASpecimensign', '大妈_你_iaspecimensign_2784a716.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaspecimensign_2784a716.png', '/2017/04/18/大妈_你_iaspecimensign_2784a716.png', 0),
(348, 100150, 4192, 'SubsDecSignature', '大妈_你_subsdecsignature_1056406f.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_subsdecsignature_1056406f.png', '/2017/04/18/大妈_你_subsdecsignature_1056406f.png', 1),
(349, 100150, 4199, 'IAPhotoid', '大妈_你_iaphotoid_0.png', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaphotoid_0.png', '/2017/04/18/大妈_你_iaphotoid_0.png', 0),
(350, 100150, 4202, 'IASpecimensign', '大妈_你_iaspecimensign_6.png', 'IASpecimensign', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaspecimensign_6.png', '/2017/04/18/大妈_你_iaspecimensign_6.png', 0),
(351, 100150, 4215, 'IAPhotoid', '大妈_你_iaphotoid_0.png', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaphotoid_0.png', '/2017/04/18/大妈_你_iaphotoid_0.png', 0),
(352, 100150, 4218, 'IASpecimensign', '大妈_你_iaspecimensign_6.png', 'IASpecimensign', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/大妈_你_iaspecimensign_6.png', '/2017/04/18/大妈_你_iaspecimensign_6.png', 0),
(353, 100150, 4231, 'IAPhotoid', 'CN100150_IAPhotoid_ID4231.png', 'IAPhotoid', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/CN100150_IAPhotoid_ID4231.png', '/2017/04/18/CN100150_IAPhotoid_ID4231.png', 1),
(354, 100150, 4234, 'IASpecimensign', 'CN100150_IASpecimensign_ID4234.png', 'IASpecimensign', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/CN100150_IASpecimensign_ID4234.png', '/2017/04/18/CN100150_IASpecimensign_ID4234.png', 1),
(355, 100150, 4247, 'SubsDecSignature', 'CN100150_SubsDecSignature_ID4247.png', 'SubsDecSignature', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/CN100150_SubsDecSignature_ID4247.png', '/2017/04/18/CN100150_SubsDecSignature_ID4247.png', 0),
(356, 100150, 4250, 'UBOBusiness', 'CN100150_UBOBusiness_ID4250.png', 'UBOBusiness', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/18/CN100150_UBOBusiness_ID4250.png', '/2017/04/18/CN100150_UBOBusiness_ID4250.png', 0);

-- --------------------------------------------------------

--
-- Table structure for table `file_sub_categories`
--

CREATE TABLE `file_sub_categories` (
  `FileSubCategoryID` int(21) NOT NULL,
  `FileCategoryID` int(11) NOT NULL,
  `FileSubCategoryName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FileSubCategoryDescription` text CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
(15, 2, 'email_cc', '', 'CC Email', 'text'),
(16, 2, 'email_bcc', 'admin@gaskylight.com', 'BCC Email', 'text');

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
(19, 10094, 100079, 'Initial', '', 150000, '2017-04-12 13:17:07', ''),
(20, 10094, 100079, 'Other', '', 51000, '2017-04-12 13:17:24', ''),
(21, 10099, 100079, 'Initial', '', 60500, '2017-04-18 05:59:59', ''),
(22, 10099, 100079, 'Other', '', 140500, '2017-04-18 06:00:10', '');

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
(210002, 'Skylight Platinum RMB', 'Skylight Platinum RMB', '2016-09-12 09:53:07', '', 'ga_term_platinum_rmb.pdf', 1);

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
(10042, 210002, 'RMB', 'RMB B5', '1st year: 9% p.a | \r\n2nd Year: 11% p.a | \r\n3rd Year: 13% p.a | \r\n4th Year: 15% p.a | \r\n5th Year: 17% p.a ', 500000, 50000, 0, 60, 0, 0, 0, 0, 0, '2017-02-06 04:55:31', '', 1);

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
(100001, 100079, 0, 'account@gaskylight.com', 'OQ6gnLhgBLMmyooulkcyLSoEF1W4ZxmCRvMIsc80BBI=', 1, 'YTozNjp7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjQ3O3M6MTM6IlZpZXcgTWFuYWdlcnMiO2k6NDg7czoxMzoiRWRpdCBNYW5hZ2VycyI7aTo0OTtzOjE1OiJEZWxldGUgTWFuYWdlcnMiO2k6NTA7czoxMjoiQWRkIE1hbmFnZXJzIjt9', 1, '', 1, '2016-06-01 02:04:08'),
(100079, 100000, 0, 'chrischuasg@gmail.com', '4jrybdaPGVcpSF+NF1XyDNndlH95P8ph3hbzSfUE2R4=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '89ef343ec32c7fcec6968896f014a81b', 1, '2016-11-16 03:41:26'),
(100086, 100000, 0, 'ryandumajil@gmail.com', 'M+5XjNuzNy0lj83M3AKX6lfa0oPQ5S2bJi8P5Ttk6Eg=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '7f11f5fd4e573fd1ad799787d848a43e', 1, '2016-12-09 06:21:59'),
(100106, 100000, 0, 'ryanck@accountingcompany.com', 'ENqfg+5175l+xB7xLNjAE+zyHLl68EjJ9JKZ+I2+0iE=', 9, 'YToxOntpOjI0O3M6ODoiVmlldyBBUEkiO30=', 0, 'd482556f9870b4baa7e65696aad074a2', 1, '2017-02-10 05:04:56'),
(100119, 100079, 0, 'chowlyechoo@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE2OiJWaWV3IENvbW1pc3Npb25zIjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '32ee7cde3f545e31e9d0a7080f87c543', 1, '2017-03-08 05:15:34'),
(100120, 100079, 0, 'shanying_yap@hotmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE2OiJWaWV3IENvbW1pc3Npb25zIjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'd14ac4eaa57ce3daa688a5b4251641b6', 1, '2017-03-08 05:17:16'),
(100121, 100079, 0, 'louis.yapwl@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNjp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjQ7czo5OiJBZGQgVXNlcnMiO2k6MjU7czoxMDoiVmlldyBVc2VycyI7aTo1O3M6MTQ6IkRlbGV0ZSBDbGllbnRzIjtpOjY7czoxMjoiRWRpdCBDbGllbnRzIjtpOjc7czoxMToiQWRkIENsaWVudHMiO2k6MjY7czoxMjoiVmlldyBDbGllbnRzIjtpOjg7czoxNjoiRGVsZXRlIENhc2VmaWxlcyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjIzO3M6MTA6IlNlbmQgRW1haWwiO2k6Mjc7czoxNDoiVmlldyBDYXNlZmlsZXMiO2k6NDI7czo4OiJFZGl0IFVCTyI7aTo0MztzOjEyOiJFZGl0IEJhbmtpbmciO2k6NDQ7czoxNToiRWRpdCBJbnZlc3RtZW50IjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aTo0NjtzOjE2OiJBc3NpZ25lZCBNYW5hZ2VyIjtpOjExO3M6MTM6IkRlbGV0ZSBBZ2VudHMiO2k6MTI7czoxMToiRWRpdCBBZ2VudHMiO2k6MTM7czoxMDoiQWRkIEFnZW50cyI7aToyODtzOjExOiJWaWV3IEFnZW50cyI7aToxNDtzOjEzOiJEZWxldGUgQWdlbmN5IjtpOjE1O3M6MTE6IkVkaXQgQWdlbmN5IjtpOjE2O3M6MTA6IkFkZCBBZ2VuY3kiO2k6Mjk7czoxMToiVmlldyBBZ2VuY3kiO2k6MTc7czoyMjoiVmlldyBOZXR3b3JrIEhpZXJhcmNoeSI7aToxODtzOjE2OiJWaWV3IENvbW1pc3Npb25zIjtpOjMwO3M6MTc6IlZpZXcgU2FsZXMgUmVwb3J0IjtpOjQxO3M6MTI6IlZpZXcgUmVwb3J0cyI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'a0bf8dc321062f521c2180489b68b2b4', 1, '2017-03-08 05:18:21'),
(100136, 100086, 0, 'jetogonon@gmail.com', 'pHK+evwNqlcXRyi4Xsgm0z1u+xCAD8iwdEzA3KAPoCM=', 1, 'YTo0OTp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjMzO3M6MTM6IlZpZXcgUHJvZHVjdHMiO2k6MzQ7czoxMToiQWRkIFByb2R1Y3QiO2k6MzU7czoxMjoiRWRpdCBQcm9kdWN0IjtpOjM2O3M6MTQ6IkRlbGV0ZSBQcm9kdWN0IjtpOjM3O3M6MTA6IlZpZXcgTWVkaWEiO2k6Mzg7czo5OiJBZGQgTWVkaWEiO2k6Mzk7czoxMDoiRWRpdCBNZWRpYSI7aTo0MDtzOjEyOiJEZWxldGUgTWVkaWEiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, '71d5a99d28b2e3bbda23f11cc3665ce1', 1, '2017-04-11 09:23:29'),
(100137, 100001, 0, '5@stones.com', 'SqdnFonbB1MYKikMdrvz5D1JnWuVDBIqaTEGQO/CkgA=', 3, 'YToyNTp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, 'a3063b82618eebefa3e081cbd1a5c1dc', 1, '2017-04-12 13:00:35'),
(100138, 100001, 0, 'i@trading.com', 'aH3QLR7DcopWNBqHduT/XIrM0I++b/Nt5znMb3B6g+U=', 3, 'YToyNTp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '7e6c58e78d8523fc89634e923ee42253', 1, '2017-04-12 13:03:10'),
(100141, 100079, 0, 'kid720401@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNzp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjM7czoxMDoiRWRpdCBVc2VycyI7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NTtzOjE0OiJEZWxldGUgQ2xpZW50cyI7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQyO3M6ODoiRWRpdCBVQk8iO2k6NDM7czoxMjoiRWRpdCBCYW5raW5nIjtpOjQ0O3M6MTU6IkVkaXQgSW52ZXN0bWVudCI7aTo0NTtzOjEyOiJFZGl0IFByb2ZpbGUiO2k6NDY7czoxNjoiQXNzaWduZWQgTWFuYWdlciI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTQ7czoxMzoiRGVsZXRlIEFnZW5jeSI7aToxNTtzOjExOiJFZGl0IEFnZW5jeSI7aToxNjtzOjEwOiJBZGQgQWdlbmN5IjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, '9e08ef95442a406c6c23806c22b6003b', 1, '2017-04-13 02:48:19'),
(100142, 100079, 0, 'katherine.leeqc@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNzp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjM7czoxMDoiRWRpdCBVc2VycyI7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NTtzOjE0OiJEZWxldGUgQ2xpZW50cyI7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQyO3M6ODoiRWRpdCBVQk8iO2k6NDM7czoxMjoiRWRpdCBCYW5raW5nIjtpOjQ0O3M6MTU6IkVkaXQgSW52ZXN0bWVudCI7aTo0NTtzOjEyOiJFZGl0IFByb2ZpbGUiO2k6NDY7czoxNjoiQXNzaWduZWQgTWFuYWdlciI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTQ7czoxMzoiRGVsZXRlIEFnZW5jeSI7aToxNTtzOjExOiJFZGl0IEFnZW5jeSI7aToxNjtzOjEwOiJBZGQgQWdlbmN5IjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'c8523ba0e815e5dc96c73042a00da93b', 1, '2017-04-13 02:50:42'),
(100143, 100079, 0, 'jeff.goh.wm98@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNzp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjM7czoxMDoiRWRpdCBVc2VycyI7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NTtzOjE0OiJEZWxldGUgQ2xpZW50cyI7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQyO3M6ODoiRWRpdCBVQk8iO2k6NDM7czoxMjoiRWRpdCBCYW5raW5nIjtpOjQ0O3M6MTU6IkVkaXQgSW52ZXN0bWVudCI7aTo0NTtzOjEyOiJFZGl0IFByb2ZpbGUiO2k6NDY7czoxNjoiQXNzaWduZWQgTWFuYWdlciI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTQ7czoxMzoiRGVsZXRlIEFnZW5jeSI7aToxNTtzOjExOiJFZGl0IEFnZW5jeSI7aToxNjtzOjEwOiJBZGQgQWdlbmN5IjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'f994ec510220a90734920a724eaf819b', 1, '2017-04-13 02:51:40'),
(100144, 100079, 0, 'leewh1987@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNzp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjM7czoxMDoiRWRpdCBVc2VycyI7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NTtzOjE0OiJEZWxldGUgQ2xpZW50cyI7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQyO3M6ODoiRWRpdCBVQk8iO2k6NDM7czoxMjoiRWRpdCBCYW5raW5nIjtpOjQ0O3M6MTU6IkVkaXQgSW52ZXN0bWVudCI7aTo0NTtzOjEyOiJFZGl0IFByb2ZpbGUiO2k6NDY7czoxNjoiQXNzaWduZWQgTWFuYWdlciI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTQ7czoxMzoiRGVsZXRlIEFnZW5jeSI7aToxNTtzOjExOiJFZGl0IEFnZW5jeSI7aToxNjtzOjEwOiJBZGQgQWdlbmN5IjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, 'b1aafc6567df1e313b90aec36a919524', 1, '2017-04-13 02:52:21'),
(100145, 100079, 0, 'kl@klchoo.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 1, 'YTozNzp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjM7czoxMDoiRWRpdCBVc2VycyI7aTo0O3M6OToiQWRkIFVzZXJzIjtpOjI1O3M6MTA6IlZpZXcgVXNlcnMiO2k6NTtzOjE0OiJEZWxldGUgQ2xpZW50cyI7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo4O3M6MTY6IkRlbGV0ZSBDYXNlZmlsZXMiO2k6OTtzOjE0OiJFZGl0IENhc2VmaWxlcyI7aToxMDtzOjEzOiJBZGQgQ2FzZWZpbGVzIjtpOjE5O3M6MjU6Ik1hbmFnZSBVcGxvYWRlZCBEb2N1bWVudHMiO2k6MjA7czoxODoiTWFuYWdlIEFwcGxpY2F0aW9uIjtpOjIxO3M6MTg6IkRvd25sb2FkIERvY3VtZW50cyI7aToyMztzOjEwOiJTZW5kIEVtYWlsIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQyO3M6ODoiRWRpdCBVQk8iO2k6NDM7czoxMjoiRWRpdCBCYW5raW5nIjtpOjQ0O3M6MTU6IkVkaXQgSW52ZXN0bWVudCI7aTo0NTtzOjEyOiJFZGl0IFByb2ZpbGUiO2k6NDY7czoxNjoiQXNzaWduZWQgTWFuYWdlciI7aToxMTtzOjEzOiJEZWxldGUgQWdlbnRzIjtpOjEyO3M6MTE6IkVkaXQgQWdlbnRzIjtpOjEzO3M6MTA6IkFkZCBBZ2VudHMiO2k6Mjg7czoxMToiVmlldyBBZ2VudHMiO2k6MTQ7czoxMzoiRGVsZXRlIEFnZW5jeSI7aToxNTtzOjExOiJFZGl0IEFnZW5jeSI7aToxNjtzOjEwOiJBZGQgQWdlbmN5IjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6NDc7czoxMzoiVmlldyBNYW5hZ2VycyI7aTo0ODtzOjEzOiJFZGl0IE1hbmFnZXJzIjtpOjQ5O3M6MTU6IkRlbGV0ZSBNYW5hZ2VycyI7aTo1MDtzOjEyOiJBZGQgTWFuYWdlcnMiO30=', 0, '81ddb550b60c4f849417848f0210fe1e', 1, '2017-04-13 02:53:30'),
(100146, 100001, 0, 'smileatchris@gmail.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 3, 'YToyNjp7aTo2O3M6MTI6IkVkaXQgQ2xpZW50cyI7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjI5O3M6MTE6IlZpZXcgQWdlbmN5IjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '386edb9378eae28b3088d64e1f3db2ed', 1, '2017-04-13 02:58:41'),
(100147, 100146, 0, '123@123.com', 'nd7M//N8jMBPs9OE/lpV9TXZ5G6Cu4nRwvHyE9KwDGE=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '0ea2dabdedb91204650c6869488b4c6c', 1, '2017-04-13 02:59:51'),
(100149, 100137, 0, 'terry.iglobal@gmail.com', 'DNJcFrTNW7csDXdlhgQoKgiDI0uMfARYXTLKw5mkqQY=', 4, 'YToxNjp7aTo3O3M6MTE6IkFkZCBDbGllbnRzIjtpOjI2O3M6MTI6IlZpZXcgQ2xpZW50cyI7aTo5O3M6MTQ6IkVkaXQgQ2FzZWZpbGVzIjtpOjEwO3M6MTM6IkFkZCBDYXNlZmlsZXMiO2k6MTk7czoyNToiTWFuYWdlIFVwbG9hZGVkIERvY3VtZW50cyI7aToyMDtzOjE4OiJNYW5hZ2UgQXBwbGljYXRpb24iO2k6MjE7czoxODoiRG93bmxvYWQgRG9jdW1lbnRzIjtpOjI3O3M6MTQ6IlZpZXcgQ2FzZWZpbGVzIjtpOjQ1O3M6MTI6IkVkaXQgUHJvZmlsZSI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE3O3M6MjI6IlZpZXcgTmV0d29yayBIaWVyYXJjaHkiO2k6MTg7czoxNjoiVmlldyBDb21taXNzaW9ucyI7aTozMDtzOjE3OiJWaWV3IFNhbGVzIFJlcG9ydCI7aTo0MTtzOjEyOiJWaWV3IFJlcG9ydHMiO30=', 0, '674bcb9acdf645abb4efc78b73f7f951', 1, '2017-04-13 05:02:17'),
(100150, 100147, 0, '61643a4150cc7fb4004c288b08271c97@gaskylight.com', '7Z6/jrG4rdwGe6mch8CoBbeG28Gh3l/KotOqef/TfuA=', 5, '', 0, '61643a4150cc7fb4004c288b08271c97', 1, '2017-04-18 05:54:16');

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
(2, 100001, 'en', 'nav-sm', 3745, '', 'Global', 'Asset', 'Admin', '0000-00-00', 'M', '', '0000000', '', '', '', 'HK', '', '', '', 'HK', 'HK', 'Hong Kong', '000000', 'Admin', '0000000'),
(51, 100079, 'en', 'nav-sm', 3795, 'Mr', 'Global', 'Asset', '', '2000-01-03', 'M', '', '00000000', 'asdf', 'sdafasdf', 'asdfsadf', 'Singapore', 'sadf', 'sasdaf', 'sadfsdaf', 'Singapore', 'Singapore', 'Singapore', '', '', 'dfghjhk'),
(57, 100086, 'en', 'nav-md', 3744, '', 'Ryan', 'Dumajil', '', '0000-00-00', 'M', '', '3216987', '', '', '', 'Ryan', '', '', '', 'Ryan', 'Ryan', 'Philippines', '4118', '', '134679'),
(67, 100106, 'en', 'nav-sm', 0, '', 'Ryan', 'Ck', 'ck', '0000-00-00', 'M', '', '000000', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(80, 100119, 'en', 'nav-sm', 0, '', 'Joanna', 'Chow', '', '0000-00-00', 'F', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(81, 100120, 'en', 'nav-sm', 0, '', 'Stella', 'Yap', '', '0000-00-00', 'F', '', '126335', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(82, 100121, 'en', 'nav-sm', 0, '', 'Louis', 'Yap', '', '0000-00-00', 'M', '', '123487', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(97, 100136, 'en', 'nav-md', 0, '', 'Jeremiah', 'Togonon', 'Jerry', '0000-00-00', 'M', '', '123', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(98, 100137, 'en', 'nav-sm', 0, '', '5', 'Stones', '', '0000-00-00', 'M', '', '000000', '', '', '', 'TTDI', '', '', '', 'Kuala Lumpur', 'Malaysia', 'Malaysia', '000000', '', '000000'),
(99, 100138, 'en', 'nav-sm', 0, '', 'i-', 'Trading', '', '0000-00-00', 'M', '', '123456789', '', '', '', 'Hong Kong', '', '', '', 'Hong Kong', 'Hong Kong', 'Hong Kong', '000000', '', '000000'),
(101, 100140, 'en', 'nav-sm', 0, 'Mr', 'testing 1', 'testing1', '', '1999-03-02', 'M', 'SINGLE', '23123', 'asdasd', 'abc', 'abc', 'asdsad', '', 'asdasd', '', '', '', 'Hong Kong', '', '', '12312124123'),
(102, 100141, 'en', 'nav-sm', 0, '', 'Vicky', 'Lai', '', '0000-00-00', 'F', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(103, 100142, 'en', 'nav-sm', 0, '', 'Katherine', 'Lee', '', '0000-00-00', 'F', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(104, 100143, 'en', 'nav-sm', 4150, '', 'Jeff', 'Goh', '', '0000-00-00', 'M', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(105, 100144, 'en', 'nav-sm', 0, '', 'Wei Hao', 'Lee', '', '0000-00-00', 'M', '', '123456', '', '', '', '', '', '', '', '', '', 'China', '', '', ''),
(106, 100145, 'en', 'nav-sm', 0, '', 'Dr', 'Choo', '', '0000-00-00', 'M', '', '8879899714', '', '', '', '', '', '', '', '', '', 'Singapore', '', '', ''),
(107, 100146, 'en', 'nav-sm', 0, '', '2AM', 'Core', '', '0000-00-00', 'M', '', '123456', '', '', '', '18 Marina Boulevard', '', '', '', 'Singapore', 'Singapore', 'Singapore', '018980', '', '000000'),
(108, 100147, 'en', 'nav-sm', 0, '', 'Louis', 'Yap', '', '0000-00-00', 'M', '', '123456', '', '', '', '18 Marina Boulevard', '', '', '', 'Singapore', 'Singapore', 'Singapore', '018980', '', '000000'),
(109, 100148, 'en', 'nav-sm', 0, 'Mr', 'Lance', 'Lance', '', '2002-01-04', 'M', 'SINGLE', 'sdfgdsfg', 'sdfgdfg', 'te', 'te', 'sadfdf', '#04-01', '', '', '', '', 'Taiwan', '', '', '123456789'),
(110, 100149, 'en', 'nav-sm', 0, '', 'TERRY KEE LEE', 'yap', '', '0000-00-00', 'M', '', '+60162657999', '', '', '', 'THE RICHMOND KIARA ', '', '', '', 'kuala lumpur', 'wilayah persekutuan', 'Malaysia', '51200', '', '820525-14-5215'),
(111, 100150, 'en', 'nav-sm', 0, 'Mr', '大妈', '你', '', '1992-09-14', 'M', 'SINGLE', '大大妈', '大大妈', '大妈', '大妈', '大大妈', '', '大大妈', '', '', '', 'China', '', '', '213213123');

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
  MODIFY `AccountID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10100;
--
-- AUTO_INCREMENT for table `account_beneficiaries`
--
ALTER TABLE `account_beneficiaries`
  MODIFY `BeneficiaryID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `account_meta`
--
ALTER TABLE `account_meta`
  MODIFY `AccountMetaID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `ActivityID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=507;
--
-- AUTO_INCREMENT for table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `BankAccountID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;
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
  MODIFY `SchemeID` int(21) NOT NULL AUTO_INCREMENT;
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
  MODIFY `FileID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4256;
--
-- AUTO_INCREMENT for table `file_categories`
--
ALTER TABLE `file_categories`
  MODIFY `FileCategoryID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `file_items`
--
ALTER TABLE `file_items`
  MODIFY `FileItemID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=357;
--
-- AUTO_INCREMENT for table `file_sub_categories`
--
ALTER TABLE `file_sub_categories`
  MODIFY `FileSubCategoryID` int(21) NOT NULL AUTO_INCREMENT;
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
  MODIFY `PaymentID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
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
  MODIFY `UserID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100151;
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
  MODIFY `UserMetaID` int(21) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
