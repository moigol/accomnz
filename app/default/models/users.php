<?php
class Users_model extends Model
{
    function __construct() {
        parent::__construct();
        
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
            $userdata = User::info(false,$this->post['usr']); 
            if(count($userdata)) {
                if($userdata->Email == $this->post['eml']) {
                    $return = $userdata;
                } else {
                    $this->setSession('error', 'Email address is not valid for this user!');
                }
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

                    if(isset($user['ReferrerUserID'])){
                        $user['ReferrerUserID'] = preg_replace("/[^0-9,.]/", "", $user['ReferrerUserID']);
                    }

                    if(isset($user['SecondReferrerUserID'])){
                        $user['SecondReferrerUserID'] = preg_replace("/[^0-9,.]/", "", $user['SecondReferrerUserID']);
                    }

                    unset($data['action']);

                    if(isset($this->post['Password']) && $this->post['Password'] != '') {
                        $pass = $this->encrypt($this->post['Password']);
                        $user['Password'] = $pass;
                    }

                    if(isset($this->post['capabilities']) && count($this->post['capabilities'])) {
                        $user['Capability'] = $this->arrayToString($this->post['capabilities']);
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

                    $user['Password'] = $this->generatePw(10);
                    $user['Active'] = 1;
                    $user['HashKey'] = md5(microtime());
                    $user['DateAdded'] = date('Y-m-d H:i:s');
                    $user['Capability']=Level::info('Capability',isset($user['Level']) ? $user['Level'] : Option::get('new_user_role'));

                    if(isset($user['ReferrerUserID'])){
                        $user['ReferrerUserID'] = preg_replace("/[^0-9,.]/", "", $user['ReferrerUserID']);
                    }
                    if(isset($user['SecondReferrerUserID'])){
                        $user['SecondReferrerUserID'] = preg_replace("/[^0-9,.]/", "", $user['SecondReferrerUserID']);
                    }

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
    
    function doTrash($UserID)
    {
        $where = array('UserID' => $UserID);
        $data = array('Active' => 0);
        $rowCount = $this->db->update("users",$data, $where);
        $rowCount = $this->db->update("accounts",$data, $where);
        
        
        App::activityLog("Trashed User #".$UserID.'.');
    }
    
    function doRestore($UserID)
    {
        $where = array('UserID' => $UserID);
        $data = array('Active' => 1);
        $rowCount = $this->db->update("users",$data, $where);
        $rowCount = $this->db->update("accounts",$data, $where);
        
        App::activityLog("Restored User #".$UserID.'.');
    }
    
    function doDelete($UserID)
    {
        $where = array('UserID' => $UserID);
        $rowCount = $this->db->delete("users", $where);
        $rowCount = $this->db->delete("user_meta", $where);
        $rowCount = $this->db->delete("accounts", $where);
        $rowCount = $this->db->delete("account_meta", $where);
        $rowCount = $this->db->delete("bank_accounts", $where);
        
        App::activityLog("Deleted User #".$UserID.'.');
    }
    
    function doEmptyTrash($UserID)
    {
        $where = array('Active' => 0);
        $rowCount = $this->db->delete("users", $where);
        $rowCount = $this->db->delete("accounts", $where);
        $rowCount = $this->db->delete("bank_accounts", $where);
        
        App::activityLog("Emptied Trashed users");
    }
    
    public function commonAssets()
    {
        View::$footerscripts[] = 'vendor/bootstrap-progressbar/bootstrap-progressbar.min.js';            
        View::$footerscripts[] = 'vendor/switchery/dist/switchery.min.js';
        View::$footerscripts[] = 'vendor/iCheck/icheck.min.js';            
        View::$footerscripts[] = 'vendor/tinymce/tinymce.min.js';            
        View::$footerscripts[] = 'assets/js/fileinput.js';
        View::$footerscripts[] = 'vendor/devbridge-autocomplete/dist/jquery.autocomplete.min.js';                        
        View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/profile.js';
        View::$footerscripts[] = 'vendor/validator/validator.min.js';
        View::$footerscripts[] = 'assets/js/pw.js';


        View::$styles[] = 'vendor/iCheck/skins/flat/green.css';
        View::$styles[] = 'assets/css/fileinput.css';
    }
    
    public function indexAssets()
    {
        
    }
    
    function doLogout()
    {
        unset($_SESSION[SESSIONCODE]);
        session_destroy();
        View::redirect('users/login');
    }   
}