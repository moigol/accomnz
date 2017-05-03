<?php
class Users extends Controller 
{
    public function __construct()
    {
        parent::__construct();
            
        // Load model Auth
        $this->load->model('auth');        
        
        // Load vendor class
        $this->load->vendor('utility');
    }

    public function index()
    {    
        if($this->auth->isLoggedIn()) {
            $this->model->indexAssets();
            $users = $this->model->getUsers();        
            View::page('users/list', get_defined_vars());
        } else {            
            View::redirect('users/login');
        }
    }
    
    public function trashbin()
    {    
        if($this->auth->isLoggedIn()) {
            $this->model->indexAssets();
            $users = $this->model->getTrashedUsers();        
            View::page('users/trashbin', get_defined_vars());
        } else {            
            View::redirect('users/login');
        }
    }
        
    public function login()
    {
        $this->model->indexAssets();
        if($this->auth->isLoggedIn()) {
            View::redirect();
        } else {     
            //$this->model->commonAssets();
            $this->model->doLogin();
            $segment = '';
            if(isset($this->segment[2])){
                $segment = $this->segment[2];
            }
                  
            View::page('users/login', get_defined_vars());
        }   
    }
    
    public function register()
    {
        $this->load->view('users/register', get_defined_vars());

    }
    
    public function profile()
    {
        if($this->auth->isLoggedIn()) {
            
            $this->model->doSave();
            
            $this->model->commonAssets();
            
            $levels = $this->model->getUserLevels();
            View::page('users/profile', get_defined_vars());
            
            $this->model->updateUserInfo();
        } else {       
            View::redirect('users/login');
        }   
    }
        
    public function restore()
    {
        if($this->auth->isLoggedIn()) {
            $user = $this->model->doRestore($this->segment[2]);
            View::redirect('users/');
        } else {       
            View::redirect('users/login');
        }     
        
    }
    
    public function delete()
    {
        if($this->auth->isLoggedIn()) {
            $user = $this->model->doDelete($this->segment[2]);
            View::redirect('users');
        } else {       
            View::redirect('users/login');
        }     
        
    }
    
        
    public function edit()
    {
        //$rolesModel = $this->load->model('role', true, true);
        if($this->auth->isLoggedIn()) {  
            $this->model->doSave();
            $this->model->commonAssets();
            $user = $this->model->getUser($this->segment[2]);
            $levels = $this->model->getUserLevels();
            View::page('users/edit', get_defined_vars());
        } else {       
            View::redirect('users/login');
        }     
        
    }
    
    public function add()
    {
        if($this->auth->isLoggedIn()) {            
            $pdata = $this->model->doSave();            
            $this->model->commonAssets();                        
            $levels = $this->model->getUserLevels();
            View::page('users/add', get_defined_vars());
        } else {       
            View::redirect('users/login');
        }     
        
    }
    
    public function userRole()
    {
        if($this->auth->isLoggedIn()) {
            View::$footerscripts = array('vendor/jquery/dist/jquery.min.js','vendor/bootstrap/dist/js/bootstrap.min.js','vendor/fastclick/lib/fastclick.js','vendor/nprogress/nprogress.js','vendor/raphael/raphael.min.js','vendor/morris.js/morris.min.js','vendor/bootstrap-progressbar/bootstrap-progressbar.min.js','assets/js/moment/moment.min.js','assets/js/datepicker/daterangepicker.js','assets/js/custom.js');
            View::page('user/userrole', get_defined_vars());
        } else {       
            View::redirect();
        }     
        
    }
    
    public function sendLostPasswordEmail($uinfo = false)
    {
        if($uinfo) {
            // Start Email sending
            $eml = $this->load->model('emailengine',true);
            
            $shortcode = array(                
                '[FirstName]',
                '[LastName]',
                '[UserID]',
                '[Password]'
            );
            
            $scvalues = array(
                $uinfo->FirstName,
                $uinfo->LastName,
                $uinfo->UserID,
                $this->decrypt($uinfo->Password)
            );
            
            $to = $uinfo->Email;
            $name = $uinfo->FirstName .' '.$uinfo->LastName;
            $subject = "Request for password recall";
            $content = str_replace($shortcode,$scvalues,App::getFileContents('emails'.DS.'requestpw.eml'));
            
            if($eml->send($to,$name,$subject,$content)) {
                
            }
            // End Email sending
        }    
    }

    public function lostPassword()
    {
        $uinfo = $this->model->doRequest();
        if($uinfo) {
            $this->sendLostPasswordEmail($uinfo);
            $this->setSession('message', 'Email sent!');
        }
        $segment = '';
        if(isset($this->segment[2])){
            $segment = $this->segment[2];
        }

        $this->load->view('users/request', get_defined_vars());
    }
    
    public function logout()
    {
        $this->model->doLogout();
    }
}