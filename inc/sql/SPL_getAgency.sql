DELIMITER $$

USE `globalas_portal`$$

DROP FUNCTION IF EXISTS `GetAgency`$$

CREATE FUNCTION `GetAgency`(GivenID INT) RETURNS TEXT CHARSET latin1
    DETERMINISTIC
BEGIN
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

    IF ch > RootID AND ul = 3 THEN 
      SET rv = CONCAT(rv,cm,ch); SET cm = ','; 
      LEAVE GetAgency; 
    END IF; 
  END WHILE; 
  RETURN rv; 
END$$
DELIMITER ; 