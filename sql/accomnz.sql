-- phpMyAdmin SQL Dump
-- version 4.2.9.1
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: May 01, 2017 at 12:49 AM
-- Server version: 5.5.40
-- PHP Version: 5.4.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `accomnz`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookit_type`
--

CREATE TABLE IF NOT EXISTS `bookit_type` (
  `code` varchar(5) NOT NULL,
  `name` varchar(50) NOT NULL,
  `display_order` int(11) NOT NULL,
  `page_title` varchar(54) NOT NULL,
  `page_desc` varchar(160) NOT NULL,
  `page_key` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bookit_type`
--

INSERT INTO `bookit_type` (`code`, `name`, `display_order`, `page_title`, `page_desc`, `page_key`) VALUES
('APT', 'Apartment', 1, '', '', ''),
('BAK', 'Backpacker', 2, '', '', ''),
('BAB', 'Bed and Breakfast', 3, '', '', ''),
('HSD', 'Holiday House', 4, '', '', ''),
('PRK', 'Holiday Park', 5, '', '', ''),
('HOT', 'Hotel', 6, '', '', ''),
('LOD', 'Lodge', 7, '', '', ''),
('MOT', 'Motel', 8, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE IF NOT EXISTS `country` (
`country_id` int(11) NOT NULL,
  `country` varchar(200) NOT NULL DEFAULT ''
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE IF NOT EXISTS `files` (
`FileID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `FileCategoryID` int(21) NOT NULL DEFAULT '0',
  `FileSubCategoryID` int(11) NOT NULL DEFAULT '0',
  `FileAccess` text CHARACTER SET utf8 NOT NULL,
  `DateAdded` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `file_categories`
--

CREATE TABLE IF NOT EXISTS `file_categories` (
`FileCategoryID` int(21) NOT NULL,
  `FileCategoryName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FileCategoryDescription` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

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

CREATE TABLE IF NOT EXISTS `file_items` (
`FileItemID` int(21) NOT NULL,
  `UserID` int(21) NOT NULL,
  `FileID` int(21) NOT NULL,
  `FileDescription` varchar(64) CHARACTER SET utf8 NOT NULL,
  `FileName` text CHARACTER SET utf8 NOT NULL,
  `FileNameC` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FilePath` text CHARACTER SET utf8 NOT NULL,
  `FileSlug` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=314 DEFAULT CHARSET=latin1;

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
(296, 100132, 4056, 'UBOOther', 'tessting_sadsadsa_uboother_6.jpg', 'UBOOther', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_uboother_6.jpg', '/2017/04/03/tessting_sadsadsa_uboother_6.jpg', 0);
INSERT INTO `file_items` (`FileItemID`, `UserID`, `FileID`, `FileDescription`, `FileName`, `FileNameC`, `FilePath`, `FileSlug`, `Active`) VALUES
(297, 100132, 4072, 'IASpecimensign', 'tessting_sadsadsa_iaspecimensign_710fa9e1.png', '', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/2017/04/03/tessting_sadsadsa_iaspecimensign_710fa9e1.png', '/2017/04/03/tessting_sadsadsa_iaspecimensign_710fa9e1.png', 0),
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
(310, 100086, 4100, 'Testing file', 'Testingfile_o.jpg', 'testtting', '/home/gaskylight/public_html/portal/app/globalassets/views/assets/files/downloads/2017/04/06/Testingfile_o.jpg', '/2017/04/06/Testingfile_o.jpg', 0),
(311, 100126, 4101, 'IAPhotoid', 'CN100126_IAPhotoid_ID4101.png', 'IAPhotoid', '/home/gaskylight/public_html/staging/app/globalassets/views/assets/files/2017/04/18/CN100126_IAPhotoid_ID4101.png', '/2017/04/18/CN100126_IAPhotoid_ID4101.png', 0),
(312, 100086, 4116, 'Chris Profile', 'ChrisProfile.jpg', '克里斯简介', '/home/gaskylight/public_html/staging/app/globalassets/views/assets/files/downloads/2017/04/18/ChrisProfile.jpg', '/2017/04/18/ChrisProfile.jpg', 0),
(313, 100086, 4117, 'sadxfacsmsdl, afhsdfutdsgfudkhsd kfg ydfgsdhfgsd jfhgsjfs', 'sadxfacsmsdl,afhsdfutdsgfudkhsdkfgydfgsdhfgsdjfhgsjfs.jpg', 'sadxfacsmsdl, afhsdfutdsg fudkhsdkfg ydfgsdhfgsdjfhgsjfs', 'C:\\xampp\\htdocs\\globalasset.loc\\app\\globalassets\\views\\assets\\files\\downloads\\2017\\04\\20\\sadxfacsmsdl,afhsdfutdsgfudkhsdkfgydfgsdhfgsdjfhgsjfs.jpg', '/2017/04/20/sadxfacsmsdl,afhsdfutdsgfudkhsdkfgydfgsdhfgsdjfhgsjfs.jpg', 0);

-- --------------------------------------------------------

--
-- Table structure for table `file_sub_categories`
--

CREATE TABLE IF NOT EXISTS `file_sub_categories` (
`FileSubCategoryID` int(21) NOT NULL,
  `FileCategoryID` int(11) NOT NULL,
  `FileSubCategoryName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `FileSubCategoryDescription` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `file_sub_categories`
--

INSERT INTO `file_sub_categories` (`FileSubCategoryID`, `FileCategoryID`, `FileSubCategoryName`, `FileSubCategoryDescription`) VALUES
(1, 5, 'Personal Files', 'IMPORTANT : Lorem ipsum dolor sit amet, his prompta tacimates no'),
(2, 5, 'All', '');

-- --------------------------------------------------------

--
-- Table structure for table `link`
--

CREATE TABLE IF NOT EXISTS `link` (
`id` int(11) NOT NULL,
  `country` varchar(200) NOT NULL DEFAULT '',
  `company_name` varchar(100) NOT NULL DEFAULT '',
  `type` varchar(100) NOT NULL DEFAULT '',
  `url` varchar(100) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `live` varchar(100) NOT NULL DEFAULT '',
  `em` varchar(200) NOT NULL DEFAULT '',
  `rl` varchar(200) NOT NULL DEFAULT ''
) ENGINE=MyISAM AUTO_INCREMENT=1069 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `options`
--

CREATE TABLE IF NOT EXISTS `options` (
`OptionID` int(11) NOT NULL,
  `OptionGroupID` int(11) NOT NULL,
  `OptionKey` varchar(512) CHARACTER SET utf8 NOT NULL,
  `OptionValue` longtext CHARACTER SET utf8 NOT NULL,
  `OptionLabel` varchar(512) CHARACTER SET utf8 NOT NULL,
  `FormType` varchar(64) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `options`
--

INSERT INTO `options` (`OptionID`, `OptionGroupID`, `OptionKey`, `OptionValue`, `OptionLabel`, `FormType`) VALUES
(1, 1, 'site_title', 'Global Asset', 'Site Title', 'text'),
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

CREATE TABLE IF NOT EXISTS `option_groups` (
`OptionGroupID` int(11) NOT NULL,
  `GroupName` varchar(512) CHARACTER SET utf8 NOT NULL,
  `Description` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `option_groups`
--

INSERT INTO `option_groups` (`OptionGroupID`, `GroupName`, `Description`) VALUES
(1, 'General', ''),
(2, 'Email', ''),
(3, 'PDF', '');

-- --------------------------------------------------------

--
-- Table structure for table `regions`
--

CREATE TABLE IF NOT EXISTS `regions` (
  `id` int(11) NOT NULL,
  `region` varchar(100) NOT NULL,
  `island` varchar(100) NOT NULL,
  `lng` float(10,6) NOT NULL,
  `lat` float(10,6) NOT NULL,
  `startZoom` int(11) NOT NULL DEFAULT '11',
  `page_title` varchar(100) NOT NULL,
  `meta_desc` varchar(154) NOT NULL,
  `meta_key` text NOT NULL,
  `bookit_code` varchar(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `regions`
--

INSERT INTO `regions` (`id`, `region`, `island`, `lng`, `lat`, `startZoom`, `page_title`, `meta_desc`, `meta_key`, `bookit_code`) VALUES
(1, 'Northland', 'North', 173.630005, -35.395100, 8, 'northland accommodation,  northland hotel, northland motels', '', 'northland hotel, northland motel, northland accommodation', 'NTH'),
(2, 'Auckland', 'North', 174.765732, -36.847385, 9, '', '', '', 'AUK'),
(3, 'Coromandel', 'North', 175.502228, -36.754879, 10, '', '', '', 'CMD'),
(4, 'Bay of Plenty', 'North', 176.462402, -37.961521, 10, '', '', '', 'BAY'),
(5, 'Waikato', 'North', 175.385742, -38.238178, 9, '', '', '', 'WAI'),
(6, 'Rotorua', 'North', 176.247070, -38.139828, 11, '', '', '', 'ROT'),
(7, 'Eastland', 'North', 177.780762, -38.255436, 9, '', '', '', 'EAS'),
(8, 'Lake Taupo', 'North', 175.913086, -38.805470, 10, '', '', '', 'TAU'),
(9, 'Taranaki', 'North', 174.371994, -39.300201, 9, '', '', '', 'TNK'),
(10, 'Ruapehu', 'North', 175.514832, -39.230125, 10, '', '', '', 'RUA'),
(11, 'Hawkes Bay', 'North', 176.824951, -39.603573, 11, '', '', '', 'HAW'),
(12, 'Manawatu-Wanganui', 'North', 175.317078, -40.204048, 9, '', '', '', 'MAN'),
(13, 'Wairarapa', 'North', 175.660767, -40.948948, 9, '', '', '', 'WPA'),
(14, 'Wellington', 'North', 174.988861, -41.131088, 10, '', '', '', 'WEL'),
(15, 'Nelson', 'South', 173.012360, -41.233414, 9, '', '', '', 'NEL'),
(16, 'Marlborough', 'South', 173.787231, -41.385052, 9, '', '', '', 'MLB'),
(17, 'West Coast', 'South', 170.826416, -42.900112, 8, '', '', '', 'WES'),
(18, 'Canterbury', 'South', 171.707001, -43.525902, 7, '', '', '', 'CAN'),
(19, 'Lake Wanaka', 'South', 169.126297, -44.527637, 10, '', '', '', 'WAN'),
(20, 'Queenstown', 'South', 168.741760, -45.018578, 11, '', '', '', 'ZQN'),
(21, 'Otago', 'South', 169.947510, -45.537136, 8, '', '', '', 'OTA'),
(22, 'Central Otago', 'South', 169.763489, -45.328979, 9, '', '', '', 'OTA'),
(23, 'Fiordland', 'South', 167.614975, -45.564133, 9, '', '', '', 'FIO'),
(24, 'Southland', 'South', 168.743149, -45.902550, 8, '', '', '', 'STH');

-- --------------------------------------------------------

--
-- Table structure for table `suburb`
--

CREATE TABLE IF NOT EXISTS `suburb` (
  `id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `suburb` varchar(100) NOT NULL,
  `lng` float(10,6) NOT NULL,
  `lat` float(10,6) NOT NULL,
  `startZoom` int(11) NOT NULL,
  `page_title` varchar(55) NOT NULL,
  `page_desc` varchar(150) NOT NULL,
  `page_key` text NOT NULL,
  `suburb_code` varchar(5) NOT NULL,
  `region_code` varchar(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `suburb`
--

INSERT INTO `suburb` (`id`, `region_id`, `suburb`, `lng`, `lat`, `startZoom`, `page_title`, `page_desc`, `page_key`, `suburb_code`, `region_code`) VALUES
(1, 1, 'Ahipara', 173.153275, -35.171345, 13, '', '', '', 'AHP', 'NTH'),
(2, 1, 'Bream Bay', 174.501968, -35.910683, 13, '', '', '', 'BRB', 'NTH'),
(3, 1, 'Dargaville', 173.871735, -35.938366, 13, '', '', '', 'DGV', 'NTH'),
(4, 1, 'Doubtless Bay', 173.455948, -34.895851, 11, '', '', '', 'DOU', 'NTH'),
(5, 1, 'Hokianga', 173.545532, -35.393528, 10, '', '', '', 'HHR', 'NTH'),
(6, 1, 'Kaikohe', 173.799774, -35.407536, 11, '', '', '', 'KKH', 'NTH'),
(7, 1, 'Kaitaia', 173.261841, -35.111652, 10, '', '', '', 'KTA', 'NTH'),
(51, 5, 'Hamilton', 175.283890, -37.788261, 12, '', '', '', 'HMZ', 'WAI'),
(9, 1, 'Kerikeri', 173.951324, -35.224522, 13, '', '', '', 'KER', 'NTH'),
(10, 1, 'Mangawhai', 174.574585, -36.126297, 13, '', '', '', 'MGW', 'NTH'),
(11, 1, 'Opua', 174.118576, -35.314140, 12, '', '', '', 'OPA', 'NTH'),
(12, 1, 'Paihia', 174.091049, -35.282089, 11, '', '', '', 'PAI', 'NTH'),
(13, 1, 'Russell', 174.122177, -35.261642, 13, '', '', '', 'RUS', 'NTH'),
(14, 1, 'Tutukaka Coast', 174.511642, -35.572449, 12, '', '', '', 'TKC', 'NTH'),
(15, 1, 'Waipu', 174.447220, -35.984638, 12, '', '', '', 'WPU', 'NTH'),
(16, 1, 'Waitangi', 170.302124, -44.591572, 13, '', '', '', '', ''),
(17, 1, 'Whangarei', 174.322678, -35.722870, 13, '', '', '', 'WEI', 'NTH'),
(18, 1, 'Whangaroa', 173.759079, -35.012001, 12, '', '', '', 'WGA', 'NTH'),
(19, 2, 'Auckland', 174.798660, -36.882915, 12, '', '', '', 'AKL', 'AUK'),
(21, 2, 'Franklin', 175.050659, -37.295906, 10, '', '', '', '', ''),
(22, 2, 'Great Barrier Island', 175.416916, -36.197281, 11, '', '', '', 'GBI', 'AUK'),
(23, 2, 'Helensville', 174.449417, -36.679657, 11, '', '', '', 'HEL', 'AUK'),
(25, 2, 'Hibiscus Coast', 174.755402, -36.548248, 12, '', '', '', 'HIB', 'AUK'),
(26, 2, 'Kawau Island', 174.862000, -36.418098, 13, '', '', '', 'KAW', 'AUK'),
(50, 5, 'Cambridge', 175.469742, -37.891487, 12, '', '', '', 'CAM', 'WAI'),
(28, 2, 'Manukau City', 174.879761, -36.992752, 13, '', '', '', 'MKC', 'AUK'),
(29, 2, 'North Shore City', 174.745667, -36.779221, 11, '', '', '', 'NSH', 'AUK'),
(30, 2, 'Waitakere City', 174.589233, -36.954281, 11, '', '', '', 'WTK', 'AUK'),
(31, 2, 'Warkworth', 174.660767, -36.401726, 11, '', '', '', 'WKW', 'AUK'),
(32, 2, 'Wellsford', 174.523270, -36.295811, 10, '', '', '', 'WEL', 'NTH'),
(33, 3, 'Coromandel', 175.502228, -36.754879, 13, '', '', '', 'COT', 'CMD'),
(34, 3, 'Paeroa', 175.667908, -37.376110, 12, '', '', '', 'PAE', 'CMD'),
(35, 3, 'Tairua', 175.848679, -37.006241, 13, '', '', '', 'TAI', 'CMD'),
(36, 3, 'Thames', 175.542328, -37.142170, 13, '', '', '', 'THA', 'CMD'),
(37, 3, 'Waihi', 175.840347, -37.391411, 11, '', '', '', 'WAH', 'CMD'),
(38, 3, 'Whangamata', 175.872009, -37.213936, 13, '', '', '', 'WHG', 'CMD'),
(39, 3, 'Whitianga', 175.700302, -36.835766, 13, '', '', '', 'THM', 'CMD'),
(43, 4, 'Whakatane', 176.985886, -37.958435, 13, '', '', '', 'WHK', 'BAY'),
(44, 4, 'Te Puke', 176.319489, -37.782227, 13, '', '', '', 'TPK', 'BAY'),
(45, 4, 'Tauranga', 176.166809, -37.687077, 11, '', '', '', 'TNG', 'BAY'),
(46, 4, 'Katikati', 175.917145, -37.553780, 12, '', '', '', 'KTK', 'BAY'),
(47, 4, 'Kawerau', 176.699677, -38.084679, 13, '', '', '', 'KWR', 'BAY'),
(48, 4, 'Mount Maunganui', 176.184723, -37.641094, 13, '', '', '', 'MTM', 'BAY'),
(49, 4, 'Ohope', 177.057251, -37.971725, 13, '', '', '', 'OBH', 'BAY'),
(52, 5, 'Huntly', 175.158783, -37.566727, 13, '', '', '', 'HNT', 'WAI'),
(53, 5, 'Kawhia', 174.820068, -38.064014, 13, '', '', '', '', ''),
(54, 5, 'Matamata', 175.773254, -37.809566, 13, '', '', '', 'MAT', 'WAI'),
(55, 5, 'Morrinsville', 175.530396, -37.656925, 13, '', '', '', '', ''),
(56, 5, 'Ngaruawahia', 175.147629, -37.665489, 13, '', '', '', '', ''),
(57, 5, 'Putaruru', 175.780334, -38.050617, 13, '', '', '', '', ''),
(58, 5, 'Raglan', 174.872604, -37.802570, 12, '', '', '', 'RAG', 'WAI'),
(59, 5, 'Te Aroha', 175.709137, -37.538795, 13, '', '', '', 'TAH', 'WAI'),
(60, 5, 'Te Awamutu', 175.324173, -38.009598, 13, '', '', '', 'TAW', 'WAI'),
(61, 5, 'Te Kuiti', 175.164474, -38.333881, 13, '', '', '', 'TKU', 'WAI'),
(62, 5, 'Tirau', 175.759506, -37.979919, 13, '', '', '', 'TRU', 'WAI'),
(63, 5, 'Tokoroa', 175.870682, -38.218136, 13, '', '', '', 'TOK', 'WAI'),
(64, 5, 'Waitomo', 175.112503, -38.260944, 12, '', '', '', 'WTM', 'WAI'),
(65, 6, 'Murupara', 176.705246, -38.460472, 13, '', '', '', '', ''),
(66, 6, 'Rotorua', 176.247070, -38.139828, 11, '', '', '', 'ROT', 'ROT'),
(67, 7, 'Gisborne', 178.025955, -38.666382, 13, '', '', '', 'GIS', 'EAS'),
(68, 7, 'Opotiki', 177.287109, -38.004208, 13, '', '', '', 'OPO', 'EAS'),
(69, 7, 'Wairoa', 177.425385, -39.039528, 13, '', '', '', 'WAA', 'EAS'),
(70, 8, 'Mangakino', 175.769455, -38.375561, 13, '', '', '', 'MGK', 'TAU'),
(71, 8, 'Taupo', 176.069687, -38.686592, 12, '', '', '', 'TAU', 'TAU'),
(72, 8, 'Turangi', 175.809586, -38.989372, 12, '', '', '', 'TUR', 'TAU'),
(73, 9, 'Eltham', 174.299225, -39.429714, 13, '', '', '', 'ELT', 'TNK'),
(74, 9, 'Hawera', 174.278290, -39.593353, 13, '', '', '', 'Haw', 'TNK'),
(75, 9, 'Inglewood', 174.207230, -39.155987, 12, '', '', '', 'ING', 'TNK'),
(76, 9, 'New Plymouth', 174.076431, -39.058056, 11, '', '', '', 'NPM', 'TNK'),
(77, 9, 'Oakura', 173.954468, -39.117550, 11, '', '', '', 'OAK', 'TNK'),
(78, 9, 'Opunake', 173.854584, -39.452442, 13, '', '', '', '', ''),
(79, 9, 'Patea', 174.476654, -39.757187, 13, '', '', '', '', ''),
(80, 9, 'Stratford', 174.284042, -39.337746, 11, '', '', '', 'STF', 'TNK'),
(81, 9, 'Urenui', 174.390198, -38.997734, 10, '', '', '', 'URE', 'TNK'),
(82, 9, 'Waitara', 174.237305, -39.001270, 13, '', '', '', 'WTA', 'TNK'),
(83, 10, 'National Park', 175.397141, -39.173668, 13, '', '', '', 'NPR', 'RUA'),
(84, 10, 'Ohakune', 175.399643, -39.418652, 12, '', '', '', 'OHA', 'RUA'),
(85, 10, 'Raetihi', 175.281845, -39.427631, 13, '', '', '', '', ''),
(86, 10, 'Taumarunui', 175.262878, -38.883034, 13, '', '', '', 'TNI', 'RUA'),
(87, 10, 'Waiouru', 175.668701, -39.479244, 13, '', '', '', 'WAU', 'RUA'),
(88, 10, 'Whakapapa Village', 175.539398, -39.200611, 13, '', '', '', 'WHV', 'RUA'),
(89, 11, 'Hastings', 176.843201, -39.643532, 12, '', '', '', 'HAS', 'HAW'),
(90, 11, 'Havelock North', 176.878464, -39.672077, 13, '', '', '', 'HAV', 'HAW'),
(91, 11, 'Napier', 176.916275, -39.491734, 11, '', '', '', 'NAP', 'HAW'),
(92, 11, 'Waipukurau', 176.556671, -39.995674, 11, '', '', '', 'WPK', 'HAW'),
(94, 12, 'Dannevirke', 176.104080, -40.207508, 13, '', '', '', 'DAN', 'MAN'),
(93, 12, 'Bulls', 175.384827, -40.174561, 13, '', '', '', 'BUL', 'MAN'),
(95, 12, 'Feilding', 175.568542, -40.224358, 12, '', '', '', 'FEI', 'MAN'),
(96, 12, 'Foxton', 175.285843, -40.471436, 12, '', '', '', '', ''),
(97, 12, 'Levin', 175.286591, -40.621845, 11, '', '', '', 'LEV', 'MAN'),
(98, 12, 'Marton', 175.378418, -40.069042, 13, '', '', '', '', ''),
(99, 12, 'Palmerston North', 175.612183, -40.355747, 13, '', '', '', 'PLN', 'MAN'),
(100, 12, 'Taihape', 175.798126, -39.676804, 11, '', '', '', 'THE', 'MAN'),
(101, 12, 'Wanganui', 175.047668, -39.930325, 13, '', '', '', 'WGI', 'MAN'),
(102, 13, 'Carterton', 175.525299, -41.027264, 13, '', '', '', 'CAR', 'WPA'),
(103, 13, 'Eketahuna', 175.703232, -40.645027, 13, '', '', '', '', ''),
(104, 13, 'Featherston', 175.322647, -41.117027, 13, '', '', '', 'FEA', 'WPA'),
(105, 13, 'Greytown', 175.459686, -41.081013, 13, '', '', '', 'GRE', 'WPA'),
(106, 13, 'Martinborough', 175.459183, -41.218227, 13, '', '', '', 'MBG', 'WPA'),
(107, 13, 'Masterton', 175.660767, -40.948948, 12, '', '', '', 'MAS', 'WPA'),
(108, 14, 'Kapiti Island', 174.914108, -40.851875, 13, '', '', '', '', ''),
(109, 14, 'Lower Hutt', 174.904526, -41.208427, 12, '', '', '', '', ''),
(110, 14, 'Otaki', 175.152435, -40.757786, 12, '', '', '', '', ''),
(111, 14, 'Paraparaumu', 175.008926, -40.913567, 13, '', '', '', 'PAR', 'WEL'),
(112, 14, 'Upper Hutt', 175.069031, -41.124580, 13, '', '', '', 'UPH', 'WEL'),
(113, 14, 'Waikanae', 175.064056, -40.875374, 13, '', '', '', 'WKN', 'WEL'),
(114, 14, 'Wellington', 174.776215, -41.286480, 11, '', '', '', 'WLG', 'WEL'),
(115, 15, 'Golden Bay', 172.729797, -40.657722, 11, '', '', '', 'GLB', 'NEL'),
(116, 15, 'Motueka', 173.011124, -41.110107, 11, '', '', '', 'MOT', 'NEL'),
(117, 15, 'Murchison', 172.329498, -41.800159, 11, '', '', '', 'MUR', 'NEL'),
(118, 15, 'Nelson', 173.283997, -41.270786, 10, '', '', '', 'NEL', 'NEL'),
(119, 15, 'St Arnaud', 172.844330, -41.804379, 13, '', '', '', 'STA', 'NEL'),
(121, 16, 'Blenheim', 173.953232, -41.516457, 11, '', '', '', 'BLE', 'MLB'),
(122, 16, 'Marlborough Sounds', 174.089447, -41.141666, 10, '', '', '', 'MRL', 'MLB'),
(123, 16, 'Picton', 174.005814, -41.292877, 13, '', '', '', 'PIC', 'MLB'),
(124, 17, 'Franz Josef Glacier', 170.176849, -43.399059, 13, '', '', '', 'FRJ', 'WES'),
(125, 17, 'Fox Glacier', 170.017914, -43.464321, 13, '', '', '', 'FOX', 'WES'),
(126, 17, 'Greymouth', 171.205948, -42.457615, 13, '', '', '', 'GRY', 'WES'),
(127, 17, 'Haast', 169.042236, -43.881180, 13, '', '', '', 'HAA', 'WES'),
(128, 17, 'Hokitika', 170.968109, -42.715637, 13, '', '', '', 'HOK', 'WES'),
(129, 17, 'Karamea', 172.111740, -41.247673, 11, '', '', '', '', ''),
(130, 17, 'Moana', 171.486969, -42.585445, 13, '', '', '', '', ''),
(131, 17, 'Punakaiki', 171.336105, -42.108463, 11, '', '', '', 'PUN', 'WES'),
(132, 17, 'Reefton', 171.863022, -42.115105, 13, '', '', '', '', ''),
(133, 17, 'Westport', 171.602249, -41.758053, 10, '', '', '', 'WPT', 'WES'),
(134, 18, 'Akaroa', 172.966568, -43.806030, 13, '', '', '', 'AKR', 'CAN'),
(135, 18, 'Amberley', 172.729935, -43.154697, 10, '', '', '', 'AMB', 'CAN'),
(136, 18, 'Arthurs Pass', 171.566620, -42.930286, 13, '', '', '', 'ART', 'CAN'),
(137, 18, 'Ashburton', 171.749329, -43.902496, 13, '', '', '', 'ASH', 'CAN'),
(138, 18, 'Christchurch', 172.636642, -43.531635, 11, '', '', '', 'CHC', 'CAN'),
(139, 18, 'Fairlie', 170.828888, -44.097717, 13, '', '', '', 'FLE', 'CAN'),
(140, 18, 'Omarama', 169.969543, -44.489281, 13, '', '', '', 'ORA', 'OTA'),
(141, 18, 'Geraldine', 171.242554, -44.093330, 13, '', '', '', 'GDN', 'CAN'),
(142, 18, 'Hanmer Springs', 172.829910, -42.522274, 13, '', '', '', 'HNM', 'CAN'),
(143, 18, 'Kaiapoi', 172.653641, -43.383286, 12, '', '', '', 'KPO', 'CAN'),
(144, 18, 'Kaikoura', 173.680557, -42.402306, 12, '', '', '', 'KAI', 'CAN'),
(145, 18, 'Lake Tekapo', 170.483383, -44.007362, 13, '', '', '', 'TEK', 'CAN'),
(146, 18, 'Lyttelton', 172.721054, -43.601421, 13, '', '', '', 'LYT', 'CAN'),
(147, 18, 'Methven', 171.647018, -43.632759, 13, '', '', '', 'MTV', 'CAN'),
(148, 18, 'Mt Cook Village', 170.121918, -43.759193, 13, '', '', '', '', ''),
(149, 18, 'Rangiora', 172.590561, -43.304039, 13, '', '', '', 'RAN', 'CAN'),
(150, 18, 'Temuka', 171.282074, -44.241821, 13, '', '', '', '', ''),
(151, 18, 'Timaru', 171.250092, -44.396801, 12, '', '', '', 'TIM', 'CAN'),
(152, 18, 'Twizel', 170.099136, -44.258640, 13, '', '', '', 'TZL', 'CAN'),
(153, 18, 'Waimate', 171.046494, -44.734039, 13, '', '', '', '', ''),
(154, 18, 'Waipara', 172.760986, -43.057610, 12, '', '', '', 'WPA', 'CAN'),
(155, 19, 'Wanaka', 169.132889, -44.698666, 13, '', '', '', 'WKA', 'WAN'),
(156, 20, 'Arrowtown', 168.834213, -44.940613, 13, '', '', '', 'ARR', 'ZQN'),
(157, 20, 'Glenorchy', 168.387939, -44.850018, 13, '', '', '', 'GLE', 'ZQN'),
(158, 20, 'Kingston', 168.717499, -45.335190, 13, '', '', '', 'KIN', 'ZQN'),
(159, 20, 'Queenstown', 168.662735, -45.031105, 12, '', '', '', 'ZQN', 'ZQN'),
(160, 21, 'Balclutha', 169.731033, -46.241463, 10, '', '', '', 'BAL', 'OTA'),
(161, 21, 'Dunedin', 170.503387, -45.874561, 12, '', '', '', 'DUN', 'OTA'),
(162, 21, 'Mosgiel', 170.349731, -45.877602, 12, '', '', '', 'MOS', 'OTA'),
(163, 21, 'Oamaru', 170.971008, -45.097679, 12, '', '', '', 'OAM', 'OTA'),
(164, 21, 'Otago Peninsula', 170.698700, -45.899780, 11, '', '', '', 'OTP', 'OTA'),
(165, 21, 'Port Chalmers', 170.621002, -45.816002, 13, '', '', '', '', ''),
(166, 22, 'Alexandra', 169.388504, -45.251667, 12, '', '', '', 'ALX', 'OTA'),
(167, 22, 'Cromwell', 169.196686, -45.042942, 12, '', '', '', 'CRM', 'OTA'),
(168, 22, 'Ranfurly', 170.100647, -45.127995, 11, '', '', '', 'RNF', 'OTA'),
(169, 22, 'Roxburgh', 169.313904, -45.539921, 11, '', '', '', 'ROX', 'OTA'),
(170, 23, 'Manapouri', 167.614975, -45.564133, 13, '', '', '', 'MAN', 'FIO'),
(171, 23, 'Milford Sound', 167.928040, -44.669785, 13, '', '', '', 'MSD', 'FIO'),
(172, 23, 'Te Anau', 167.718140, -45.415081, 13, '', '', '', 'TEA', 'FIO'),
(173, 24, 'Invercargill', 168.356888, -46.413055, 13, '', '', '', 'INV', 'STH'),
(174, 24, 'Stewart Island', 167.837204, -46.997276, 10, '', '', '', 'SIS', 'STH'),
(175, 24, 'Bluff', 168.339447, -46.598568, 13, '', '', '', '', ''),
(176, 24, 'Catlins', 169.304810, -46.564526, 9, '', '', '', 'CLN', 'OTA'),
(177, 2, 'Waiheke Island', 175.195099, -36.796474, 9, '', '', '', 'WAI', 'AUK');

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE IF NOT EXISTS `type` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `rank` int(11) NOT NULL,
  `page_title` varchar(54) NOT NULL,
  `page_desc` varchar(160) NOT NULL,
  `page_key` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `type`
--

INSERT INTO `type` (`id`, `name`, `rank`, `page_title`, `page_desc`, `page_key`) VALUES
(1, 'Hotel', 1, '', '', ''),
(2, 'Motel', 3, '', '', ''),
(27, 'Bed and Breakfast', 2, '', '', ''),
(28, 'Lodge', 5, '', '', ''),
(29, 'Camping Ground', 7, '', '', ''),
(32, 'Backpackers', 6, '', '', ''),
(62, 'Holiday Homes', 3, '', '', ''),
(75, 'Holiday Park', 7, '', '', ''),
(76, 'Apartment Serviced', 10, '', '', ''),
(77, 'Holiday Park Camping', 8, '', '', ''),
(78, 'Farmstay or Homestay', 9, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
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
) ENGINE=InnoDB AUTO_INCREMENT=100002 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `ReferrerUserID`, `SecondReferrerUserID`, `Email`, `Password`, `Level`, `Capability`, `SendEmail`, `HashKey`, `Active`, `DateAdded`) VALUES
(100000, 0, 0, 'moises@cutearts.org', 'gGRYoS2HzgpeBEhjPVTNWcrNHousd3zBbtEYvuv9r/A=', 1, 'YTo1MDp7aToxO3M6MTQ6IkFkbWluaXN0ZXIgQWxsIjtpOjMxO3M6MTI6Ik1hbmFnZSBSb2xlcyI7aTozMjtzOjE1OiJNYW5hZ2UgU2V0dGluZ3MiO2k6NTE7czoxOToiTWFuYWdlIENhcGFiaWxpdGllcyI7aToyO3M6MTI6IkRlbGV0ZSBVc2VycyI7aTozO3M6MTA6IkVkaXQgVXNlcnMiO2k6NDtzOjk6IkFkZCBVc2VycyI7aToyNTtzOjEwOiJWaWV3IFVzZXJzIjtpOjU7czoxNDoiRGVsZXRlIENsaWVudHMiO2k6NjtzOjEyOiJFZGl0IENsaWVudHMiO2k6NztzOjExOiJBZGQgQ2xpZW50cyI7aToyNjtzOjEyOiJWaWV3IENsaWVudHMiO2k6ODtzOjE2OiJEZWxldGUgQ2FzZWZpbGVzIjtpOjk7czoxNDoiRWRpdCBDYXNlZmlsZXMiO2k6MTA7czoxMzoiQWRkIENhc2VmaWxlcyI7aToxOTtzOjI1OiJNYW5hZ2UgVXBsb2FkZWQgRG9jdW1lbnRzIjtpOjIwO3M6MTg6Ik1hbmFnZSBBcHBsaWNhdGlvbiI7aToyMTtzOjE4OiJEb3dubG9hZCBEb2N1bWVudHMiO2k6MjM7czoxMDoiU2VuZCBFbWFpbCI7aToyNztzOjE0OiJWaWV3IENhc2VmaWxlcyI7aTo0MjtzOjg6IkVkaXQgVUJPIjtpOjQzO3M6MTI6IkVkaXQgQmFua2luZyI7aTo0NDtzOjE1OiJFZGl0IEludmVzdG1lbnQiO2k6NDU7czoxMjoiRWRpdCBQcm9maWxlIjtpOjQ2O3M6MTY6IkFzc2lnbmVkIE1hbmFnZXIiO2k6MTE7czoxMzoiRGVsZXRlIEFnZW50cyI7aToxMjtzOjExOiJFZGl0IEFnZW50cyI7aToxMztzOjEwOiJBZGQgQWdlbnRzIjtpOjI4O3M6MTE6IlZpZXcgQWdlbnRzIjtpOjE0O3M6MTM6IkRlbGV0ZSBBZ2VuY3kiO2k6MTU7czoxMToiRWRpdCBBZ2VuY3kiO2k6MTY7czoxMDoiQWRkIEFnZW5jeSI7aToyOTtzOjExOiJWaWV3IEFnZW5jeSI7aToxNztzOjIyOiJWaWV3IE5ldHdvcmsgSGllcmFyY2h5IjtpOjE4O3M6MTY6IlZpZXcgQ29tbWlzc2lvbnMiO2k6MzA7czoxNzoiVmlldyBTYWxlcyBSZXBvcnQiO2k6NDE7czoxMjoiVmlldyBSZXBvcnRzIjtpOjI0O3M6ODoiVmlldyBBUEkiO2k6MzM7czoxMzoiVmlldyBQcm9kdWN0cyI7aTozNDtzOjExOiJBZGQgUHJvZHVjdCI7aTozNTtzOjEyOiJFZGl0IFByb2R1Y3QiO2k6MzY7czoxNDoiRGVsZXRlIFByb2R1Y3QiO2k6Mzc7czoxMDoiVmlldyBNZWRpYSI7aTozODtzOjk6IkFkZCBNZWRpYSI7aTozOTtzOjEwOiJFZGl0IE1lZGlhIjtpOjQwO3M6MTI6IkRlbGV0ZSBNZWRpYSI7aTo0NztzOjEzOiJWaWV3IE1hbmFnZXJzIjtpOjQ4O3M6MTM6IkVkaXQgTWFuYWdlcnMiO2k6NDk7czoxNToiRGVsZXRlIE1hbmFnZXJzIjtpOjUwO3M6MTI6IkFkZCBNYW5hZ2VycyI7fQ==', 0, '7f11f5fd4e573fd1ad799787d848a43e', 1, '2016-12-09 06:21:59');

-- --------------------------------------------------------

--
-- Table structure for table `user_capabilities`
--

CREATE TABLE IF NOT EXISTS `user_capabilities` (
`UserCapabilityID` int(11) NOT NULL,
  `UserCapabilityGroupID` int(11) NOT NULL,
  `Name` varchar(256) CHARACTER SET utf8 NOT NULL,
  `Description` text CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;

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

CREATE TABLE IF NOT EXISTS `user_capability_groups` (
`UserCapabilityGroupID` int(11) NOT NULL,
  `Name` varchar(256) CHARACTER SET utf8 NOT NULL,
  `Active` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

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

CREATE TABLE IF NOT EXISTS `user_levels` (
`UserLevelID` int(11) NOT NULL,
  `Code` varchar(32) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Description` text NOT NULL,
  `Link` text NOT NULL,
  `Capability` longtext NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

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

CREATE TABLE IF NOT EXISTS `user_meta` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_meta`
--

INSERT INTO `user_meta` (`UserMetaID`, `UserID`, `Language`, `Sidebar`, `Avatar`, `Salutation`, `FirstName`, `LastName`, `NickName`, `DateOfBirth`, `Gender`, `CivilStatus`, `Phone`, `Mobile`, `JobTitle`, `Occupation`, `Address`, `Address2`, `Address3`, `Address4`, `City`, `State`, `Country`, `PostalCode`, `Bio`, `IdNumber`) VALUES
(1, 100000, 'en', 'nav-md', 2578, '', 'Moises', 'Goloyugo', 'Site Administrator', '1986-12-25', 'M', '', '09278585028', '', '', '', 'Bulihan', '', '', '', 'Silang', 'Cavite', 'Philippines', '4118', 'Whatever', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookit_type`
--
ALTER TABLE `bookit_type`
 ADD PRIMARY KEY (`code`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
 ADD UNIQUE KEY `country_id` (`country_id`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
 ADD PRIMARY KEY (`FileID`), ADD KEY `DocumentID` (`FileID`), ADD KEY `FileID` (`FileID`);

--
-- Indexes for table `file_categories`
--
ALTER TABLE `file_categories`
 ADD PRIMARY KEY (`FileCategoryID`);

--
-- Indexes for table `file_items`
--
ALTER TABLE `file_items`
 ADD PRIMARY KEY (`FileItemID`), ADD KEY `DocumentID` (`FileID`);

--
-- Indexes for table `file_sub_categories`
--
ALTER TABLE `file_sub_categories`
 ADD PRIMARY KEY (`FileSubCategoryID`);

--
-- Indexes for table `link`
--
ALTER TABLE `link`
 ADD UNIQUE KEY `id` (`id`);

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
-- Indexes for table `regions`
--
ALTER TABLE `regions`
 ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `suburb`
--
ALTER TABLE `suburb`
 ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `type`
--
ALTER TABLE `type`
 ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`UserID`), ADD UNIQUE KEY `Email` (`Email`), ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `user_capabilities`
--
ALTER TABLE `user_capabilities`
 ADD PRIMARY KEY (`UserCapabilityID`), ADD KEY `UserCapabilityID` (`UserCapabilityID`);

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
 ADD PRIMARY KEY (`UserMetaID`), ADD UNIQUE KEY `UserID` (`UserID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
MODIFY `country_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=56;
--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
MODIFY `FileID` int(21) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `file_categories`
--
ALTER TABLE `file_categories`
MODIFY `FileCategoryID` int(21) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `file_items`
--
ALTER TABLE `file_items`
MODIFY `FileItemID` int(21) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=314;
--
-- AUTO_INCREMENT for table `file_sub_categories`
--
ALTER TABLE `file_sub_categories`
MODIFY `FileSubCategoryID` int(21) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `link`
--
ALTER TABLE `link`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1069;
--
-- AUTO_INCREMENT for table `options`
--
ALTER TABLE `options`
MODIFY `OptionID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `option_groups`
--
ALTER TABLE `option_groups`
MODIFY `OptionGroupID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `UserID` int(21) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=100002;
--
-- AUTO_INCREMENT for table `user_capabilities`
--
ALTER TABLE `user_capabilities`
MODIFY `UserCapabilityID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=52;
--
-- AUTO_INCREMENT for table `user_capability_groups`
--
ALTER TABLE `user_capability_groups`
MODIFY `UserCapabilityGroupID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `user_levels`
--
ALTER TABLE `user_levels`
MODIFY `UserLevelID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `user_meta`
--
ALTER TABLE `user_meta`
MODIFY `UserMetaID` int(21) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
