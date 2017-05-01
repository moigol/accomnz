<?php
class Ajax extends Controller 
{
    public function __construct()
    {
        parent::__construct();

        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {   
        // Protected yes
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn() && $this->segment[0] != 'assets') {
            //View::redirect('users/login');
            echo '{}';
        }
    }
    
    public function userInfo()
    {
        $users = $this->load->model('users',true, true);
        echo $users->getUserByCode($this->post['ID']);
    }

    public function regionInfo()
    {
        $regions = $this->load()->model('regions',true,true);
        echo $regions->getRegionByID($this->post['id']);
    }
    
    public function checkemail()
    {
        $id = User::infoByEmail('UserID',$this->post['email']);
        echo ($id) ? true : false;
    }

    public function checkemail2()
    {
        $users = $this->load->model('users',true, true);
        
        $validate = $users->validateUniqueEmail($this->segment[2], $this->segment[3]);

        echo count($validate) ? true : false;
    }
    
    public function checkclientemail()
    {
        $users = $this->load->model('users',true, true);
        
        $info = $users->getUserByClientEmail($this->post['email']);

        echo count($info) ? true : false;
    }
    
    public function changelanguage()
    {
        $users = $this->load->model('users', true, true);
        $this->model->updateLanguage($this->post['ID']);
        
        $users->updateUserInfo();
        Lang::init();
    }
    
}