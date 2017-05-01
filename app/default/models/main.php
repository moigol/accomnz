<?php
class Main_model extends Model
{
    public function __construct()
    {
        parent::__construct();
        
        View::$footerscripts = array(
            'assets/jquery/jquery.js',
            'assets/jquery/jquery-ui.js',
            'assets/bootstrap/js/bootstrap.min.js'
            );   

        View::$styles = array(
            'assets/jquery/jquery-ui.css',
            'assets/bootstrap/css/bootstrap.min.css'
            );
    }

    function getCounts($ID = false)
    {
        if($ID) {
            $info = User::info(false,$ID);

            if($info->UserLevel == 'Agency') {
                $groupIDs = GAUtility::getChildren($ID);
                $sql = "SELECT a.AccountStatus, COUNT(*) AS 'count'  FROM accounts a LEFT JOIN users u ON u.UserID = a.UserID WHERE a.AccountStatus IN ('Approved', 'Pending', 'On Hold', 'Rejected') AND a.Active = 1 AND (u.ReferrerUserID IN($groupIDs) OR u.SecondReferrerUserID IN($groupIDs)) GROUP BY a.AccountStatus";

            } else {         
                $sql = "SELECT a.AccountStatus, COUNT(*) AS 'count'  FROM accounts a LEFT JOIN users u ON u.UserID = a.UserID WHERE a.AccountStatus IN ('Approved', 'Pending', 'On Hold', 'Rejected') AND a.Active = 1 AND (u.ReferrerUserID = $ID OR u.SecondReferrerUserID = $ID) GROUP BY a.AccountStatus";
            }
        } else {
            $sql = "SELECT a.AccountStatus, COUNT(*) AS 'count'  FROM accounts a WHERE a.AccountStatus IN ('Approved', 'Pending', 'On Hold', 'Rejected') AND a.Active = 1 GROUP BY a.AccountStatus";
        }
        
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->AccountStatus] = $row;
        }
        unset($query);
        
        return $data;
        
    } 
    
    function getUserByID($ID)
    {
        if($ID) {            
        
            $sql = "SELECT u.UserID, um.FirstName, um.LastName, ul.Name as LevelName FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID WHERE  u.UserID = $ID LIMIT 1";

            $query = &$this->db->prepare($sql);
            $query->execute();
            $row = $query->fetch(PDO::FETCH_CLASS);
            unset($query);
            
            return json_encode($row);

        } else {
            return false;
        }
    }

    function getUserByCode($ID)
    {
        if($ID) {            
        
            $sql = "SELECT u.UserID, um.FirstName, um.LastName, ul.Name as LevelName, CONCAT(ul.Code,u.UserID) as UserCode FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID WHERE CONCAT(ul.Code,u.UserID) = '$ID' OR u.UserID = '$ID' LIMIT 1";

            $query = &$this->db->prepare($sql);
            $query->execute();
            $row = $query->fetch(PDO::FETCH_CLASS);
            unset($query);
            
            return json_encode($row);

        } else {
            return false;
        }
    }
	
    function getUsersCount($level = false, $date = false)
    {
        $dateWhere = '';
        switch ($date) {
            case 'thisweek':
                $from = date( 'Y-m-d 00:00:00', strtotime( 'sunday this week' ) );
                $to = date( 'Y-m-d 59:59:59', strtotime( 'saturday this week' ) );

                $dateWhere = " AND DateAdded BETWEEN '$from' AND '$to'";
                break;
            case 'thismonth':
                $from = date('Y-m-01 00:00:00');
                $to = date('Y-m-t 59:59:59');

                $dateWhere = " AND DateAdded BETWEEN '$from' AND '$to'";
                break;
            default:
                $dateWhere = "";
                break;
        }

        $where = "WHERE Active = 1";
        switch ($level) {
            case 'agent':
                $where .= " AND Level = 4";
                break;
            case 'agency':
                $where .= " AND Level = 3";
                break;
            default:
                break;
        }

		$where .= $dateWhere;

        $sql = "SELECT SUM(Active) as HeadCount FROM users ".$where;
        $data = $this->db->get_row($sql);

        return ($data->HeadCount) ? $data->HeadCount : 0;
    }
    
    function updateLanguage($ID)
    {
        $this->db->update('user_meta',array('Language'=>$ID),array('UserID'=>User::info('UserID')));
    }
	
	function getActivityLogs()
    {
        $sql = "SELECT l.* FROM activity_logs l ORDER BY l.ActivityDate ASC";
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
		
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;
        }
        unset($query);
        
        return $data;
		
    } 

    function getAccounts()
    {
        $sql = "SELECT a.* FROM accounts a WHERE a.Active = 1";
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
		
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;
        }
        unset($query);
        
        return $data;
		
    } 
	
    function getUserLevels()
    {
        $sql = "SELECT UserLevelID,Name FROM user_levels";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->UserLevelID] = $row->Name;			
        }
        unset($query);
        
        return $data;
    }

    function getOptionGroups()
    {
        $sql = "SELECT OptionGroupID, GroupName FROM option_groups";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->OptionGroupID] = $row->GroupName;          
        }
        unset($query);
        
        return $data;
    }

    function getOptionsList()
    {
        $sql = "SELECT o.*,og.GroupName FROM options o LEFT JOIN option_groups og ON o.OptionGroupID = og.OptionGroupID";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;          
        }
        unset($query);
        
        return $data;
    }

    function getOption($ID)
    {
        $sql = "SELECT * FROM options o LEFT JOIN option_groups og ON o.OptionGroupID = og.OptionGroupID WHERE o.OptionID = ".$ID." LIMIT 1";
        $data = $this->db->get_row($sql);
        
        return $data;
    } 

    function doSave()
    {
        if(isset($this->post['action'])) {
            switch($this->post['action']) {
                case "updateoptions": {
                    if(isset($this->post['action'])) {
                        switch($this->post['action']) {
                            case "updateoptions": {

                                $this->setSession('message',"Options has been updated!"); 

                                $settings = $this->post['settings'];
                                // $settings['Redirects'] = $this->arrayToString($settings['Redirects']);

                                $optdata = $settings;

                                $filedata = $this->fileUpload($this->file,$this->post['userid']);
                                if(count($filedata)) {
                                    $optdata = array_merge($settings,$filedata);
                                }

                                Option::multiUpdate($optdata);                                        
                            }
                        }
                    }
                    return (object) $this->post;
                } break;
                case "addoption": {

                    $data = $this->post;
                    unset($data['action']);

                    $optionID = $this->db->insert("options", $data);

                    if($optionID) {
                        $this->setSession('message',"New product item has been registered!");
                    }

                    //View::redirect('agency');
                } break;
                case "editoption": {
                    $optionID = $this->post['optionID'];
                    $data = $this->post;
                    unset($data['action']);
                    unset($data['optionID']);

                    $this->setSession('message',"Option has been updated!");

                    $opID = $this->db->update("options", $data, array('OptionID' => $optionID));

                } break;
            }
        }
        return (object) $this->post;

    }

//    function doDeleteFile($ID)
//    {
//
//        $where = array('FileID' => $ID);
//        $this->setSession('message',"File has been deleted!");
//        $rowCount = $this->db->delete("files", $where);
//        $rowCount = $this->db->delete("file_items", $where);
//
//    }

    function doDeleteOption($ID)
    {
        $where = array('OptionID' => $ID);        
        $this->setSession('message',"Option has been deleted!");        
        $rowCount = $this->db->delete("options", $where);
    }

    public function commonAssets()
    {
        View::$footerscripts[] = "vendors/datatables/js/jquery.dataTables.min.js";
        View::$footerscripts[] = "vendors/datatables/dataTables.bootstrap.js";
        View::$footerscripts[] = 'assets/js/tables.js';
        View::$footerscripts[] = 'assets/js/custom.js';

        View::$styles[] = 'assets/css/calendar.css';
        View::$styles[] = 'assets/css/buttons.css';
        View::$styles[] = 'assets/css/forms.css';
        View::$styles[] = 'assets/css/stats.css';
        View::$styles[] = 'assets/css/styles.css';
        View::$styles[] = "vendors/datatables/dataTables.bootstrap.css";
    }

    public function indexAssets()
    {
        View::$footerscripts[] = "vendors/datatables/js/jquery.dataTables.min.js";
        View::$footerscripts[] = "vendors/datatables/dataTables.bootstrap.js";
        View::$footerscripts[] = 'assets/js/tables.js';
        View::$footerscripts[] = 'assets/js/custom.js';

        View::$styles[] = 'assets/css/calendar.css';
        View::$styles[] = 'assets/css/buttons.css';
        View::$styles[] = 'assets/css/forms.css';
        View::$styles[] = 'assets/css/stats.css';
        View::$styles[] = 'assets/css/styles.css';
        View::$styles[] = "vendors/datatables/dataTables.bootstrap.css";

    }
}