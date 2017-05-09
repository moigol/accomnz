<?php
class Users_model extends Model
{
    function __construct() {
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
        View::$segments = $this->segment;
    }
    
    function doLogin()
    {
        if(isset($this->post['action']) && $this->post['action'] == 'login') {
            $userdata = User::infoByEmail(false,$this->post['usr']); 
            if($userdata) {
                if($this->decrypt($userdata->Password) == $this->post['pwd']) {
                    //unset($_SESSION[SESSIONCODE]);
                    $udata = (array) $userdata;
                    $this->setSession('loggedin', true);
                    $this->setSession('userdata', $udata);                    
                    $this->setSession('language', $udata['Language']);
                    $this->setSession('message', 'Login sucessful!');
                    //View::redirect();                    
                    User::dashboardRedirect();
                } else {
                    $this->setSession('error', 'Invalid password!');
                }
            } else {
                $this->setSession('error', 'User ID doesn\'t exists!');
            }
        }
    }   

    function doRequest()
    {
        $return = false;
        if(isset($this->post['action']) && $this->post['action'] == 'request') {
            $userdata = User::infoByEmail(false,$this->post['eml']); 
            if(count($userdata)) {
                $return = $userdata;
            } else {
                $this->setSession('error', 'User ID doesn\'t exists!');
            }
        }

        return $return;
    }   
    
    function updateUserInfo()
    {        
        $userdata = User::info(false,User::info('UserID'));
        $udata = (array) $userdata;
        $this->setSession('userdata', $udata);
        $this->setSession('language', $udata['Language']);
    } 
    
    function getUser($ID)
    {
        $sql = "SELECT u.*,um.*,ul.Name,ul.Code, 
        (SELECT CONCAT(uul.Code, uu.UserID) as FirstAgentID FROM users uu LEFT JOIN user_levels uul ON uu.Level = uul.UserLevelID WHERE uu.UserID = u.ReferrerUserID) as FirstAgentID, 
        (SELECT CONCAT(uuul.Code, uuu.UserID) as SecondAgentID FROM users uuu LEFT JOIN user_levels uuul ON uuu.Level = uuul.UserLevelID WHERE uuu.UserID = u.SecondReferrerUserID) as SecondAgentID  
            FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID 
            LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID 
        WHERE u.UserID = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    }

    function validateUniqueEmail($ID, $Email)
    {
        $sql = "SELECT u.UserID, u.Email FROM users u WHERE u.UserID != ".$ID." AND u.Email = '".$Email."' LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    }
    
    function getUserByCode($ID)
    {
        if($ID) {            
        
            $sql = "SELECT u.UserID, um.FirstName, um.LastName, ul.Name as LevelName, CONCAT(ul.Code,u.UserID) as UserCode, a.CompanyName FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID LEFT JOIN accounts a ON a.UserID = u.UserID WHERE CONCAT(ul.Code,u.UserID) = '$ID' OR u.UserID = '$ID' LIMIT 1";

            $query = &$this->db->prepare($sql);
            $query->execute();
            $row = $query->fetch(PDO::FETCH_CLASS);
            unset($query);
            
            return json_encode($row);

        } else {
            return false;
        }
    }

    function getUserCompanyName($ID)
    {
        if($ID) {            
        
            $sql = "SELECT CompanyName FROM accounts WHERE UserID = (SELECT GetAgency(UserID) as ID FROM `users` WHERE UserID = $ID) LIMIT 1";

            $cp = $this->db->get_row($sql);

            return $cp->CompanyName;
        } else {
            return false;
        }
    }
    
    function getUserByClientEmail($email)
    {
        if($email) {            
        
            $sql = "SELECT u.UserID, um.FirstName, um.LastName, ul.Name as LevelName, CONCAT(ul.Code,u.UserID) as UserCode FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID LEFT JOIN accounts a ON a.UserID = u.UserID WHERE a.AccountEmail = '".$email."' LIMIT 1";

            $row = $this->db->get_row($sql);
            
            return $row;

        } else {
            return false;
        }
    }
    
    function getUsers($inactive = '')
    {
        
        $sql = "SELECT u.*,um.*,ul.Name,ul.Code FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON u.Level = ul.UserLevelID";
        $where = " WHERE u.Active = 1";
        if($inactive == 'yes') {
            $where = " WHERE u.Active != 1";
        } 
        $sql .= $where;
        $sql .= " ORDER BY u.UserID";
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;			
        }
        unset($query);
        
        return $data;
    } 
    
    function getTrashedUsers()
    {
        return $this->getUsers('yes');
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
    
    function getCapabilities()
    {
        // WHERE uc.UserCapabilityGroupID > 0
        $data = array();
        $sql = "SELECT uc.*, ucg.Name as GroupName FROM user_capabilities uc LEFT JOIN user_capability_groups ucg ON uc.UserCapabilityGroupID = ucg.UserCapabilityGroupID ORDER BY ucg.UserCapabilityGroupID ASC";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->GroupName][$row->UserCapabilityID] = $row;
        }
        unset($query);
        
        return $data;
    }
    
    function doSave()
    {
        if(isset($this->post['action'])) {
            switch($this->post['action']) {
                case "updateuser": {

                    $this->setSession('message',"User has been updated!");                            

                    $data = $this->post;                    
                    $uwhere = array('UserID' => $this->post['userid']);
                    $mwhere = array('UserMetaID' => $this->post['metaid']);

                    $user = $this->post['user'];
                    $meta = $this->post['meta'];

                    unset($data['action']);

                    if(isset($this->post['Password']) && $this->post['Password'] != '') {
                        $pass = $this->encrypt($this->post['Password']);
                        $user['Password'] = $pass;
                    } else {
                        $user['Password'] = $this->encrypt($user['Password']);
                    }

                    $userID = $this->db->update("users", $user, $uwhere);
                    $metaID = $this->db->update("user_meta", $meta, $mwhere);

                    if($this->file['Avatar']['name'] != '') {                        
                        $filedata = $this->fileUpload($this->file,$this->post['userid']);
                        if(count($filedata)) {
                            $this->removeUploadedFiles($this->post['avatarid']);
                            $rowCount = $this->db->update("user_meta", $filedata, $mwhere);
                        }
                    }

                    $this->updateUserInfo();
                    Lang::init();
                    
                    App::activityLog("Updated User #".$this->post['userid'].'.');

                } break;
                case "adduser": {

                    $data = $this->post;                    
                    $user = $this->post['user'];
                    $meta = $this->post['meta'];

                    unset($data['action']);

                    $user['Password'] = $this->encrypt($user['Password']);
                    $user['Active'] = 1;
                    $user['Level'] = 1;
                    $user['HashKey'] = md5(microtime());
                    $user['DateAdded'] = date('Y-m-d H:i:s');
                    $user['Capability']=Level::info('Capability',isset($user['Level']) ? $user['Level'] : Option::get('new_user_role'));

                    
                    if(User::infoByEmail('UserID',$user['Email'])) {
                        $this->setSession('error', "Email already exists");
                        $this->setSession('message',"");
                        View::redirect('users/add');
                    }

                    $userID = $this->db->insert("users", $user);

                    if($userID) {
                        $this->setSession('message',"New user has been added!");

                        $where = array('UserID' => $userID);

                        // TO DO: send email
                        //$filedata = $this->sendEmail($userID);
                        $meta['UserID'] = $userID;
                        $metaID = $this->db->insert("user_meta", $meta);

                        if($this->file['Avatar']['name'] != '') {
                            $filedata = $this->fileUpload($this->file,$userID);

                            if(count($filedata)) {
                                $rowCount = $this->db->update("user_meta", $filedata, $where);
                            }
                        }
                    }
                    
                    App::activityLog("Added User #".$userID.'.');
                    
                    View::redirect('users');
                } break;
                case "savepassword" : {
                    $sql = "SELECT * FROM users WHERE UserID = '".$this->post['userid']."' LIMIT 1";
                    $userdata = $this->db->get_row($sql);

                    if($userdata) {
                        if($this->decrypt($userdata->Password) == $this->post['OldPassword']) {
                            $where = array('UserID' => $this->post['userid']);
                            $data = array('Password' => $this->encrypt($this->post['NewPasswordConfirm']));
                            $this->db->update("users", $data, $where);  
                            $this->setSession('message', 'Login sucessful!');                   
                        } else {
                            $this->setSession('error', 'Invalid password!');
                        }
                    }
                } break;
            } 
        }
        return (object) $this->post;
        
    }
    
    function doDelete($UserID)
    {
        $where = array('UserID' => $UserID);
        $rowCount = $this->db->delete("users", $where);
        $rowCount = $this->db->delete("user_meta", $where);
        
        App::activityLog("Deleted User #".$UserID.'.');
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
    
    function doLogout()
    {
        unset($_SESSION[SESSIONCODE]);
        session_destroy();
        View::redirect('users/login');
    }   
}