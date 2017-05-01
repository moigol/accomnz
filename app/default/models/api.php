<?php
class Api_model extends Model
{
       
    function apiConnect($id,$key) {
        $sql = "SELECT UserID FROM `users` WHERE UserID = '".$id."' AND HashKey = '".$key."' LIMIT 1";
        $usr = $this->db->get_row($sql);

        if(count($usr)) {
            return $usr->UserID;
        } else {
            return false;
        }
    }
    
    function getAccounts($out='object')
    {
        $sql = "SELECT 
                u.UserID as ClientID, 
                CONCAT(um.FirstName,' ',um.LastName) as Name,
                um.DateOfBirth,
                um.Gender,
                um.CivilStatus as MaritalStatus,
                a.AccountEmail as Email,
                um.Phone,
                CONCAT(um.Address,' ',um.Address2,' ',um.City,' ',um.State,' ',um.Country,' ',um.PostalCode) as Address,
                um.Language as PreferredLanguage,
                a.ApplicationDate as JoinDate,
                a.CompanyName as Agency,
                (SELECT CONCAT(umm.FirstName,' ',umm.LastName) as RName FROM `user_meta` umm WHERE umm.UserID = u.ReferrerUserID) as ReferrerName,
                
                a.AccountID as PolicyID,
                a.CommencementDate,
                a.MaturityDate,
                a.ReceivedAmount as Contribution,
                a.CashAmount,                
                a.ManagementFee,
                a.ManagementFeeWaiver,
                a.OpeningFee,
                a.OpeningFeePromo
                        
                FROM accounts a LEFT 
                JOIN account_meta am ON a.AccountMetaID = am.AccountMetaID 
                LEFT JOIN bank_accounts b ON a.BankAccountID = b.BankAccountID 
                LEFT JOIN users u ON a.UserID = u.UserID 
                LEFT JOIN user_meta um ON u.UserID = um.UserID";
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            if($out == 'array') {
                $data[] = (array)$row;
            } else {
                $data[] = $row;			
            }
        }
        unset($query);
        
        return $data;
    } 
}