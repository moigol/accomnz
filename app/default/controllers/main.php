<?php
class Main extends Controller 
{
    public function __construct()
    {
        parent::__construct();
            
        // Protected yes
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn() && $this->segment[0] != 'assets') {
            View::redirect('users/login');
        }
        
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {   
        $loggedinID = User::info('UserID');
        // Table
        $this->model->indexAssets();        
        View::page('dashboard', get_defined_vars());
    }
        
    public function activitylogs()
    {
        $this->model->indexAssets();

        if(User::can('Administer All')){
            $logs = $this->model->getActivityLogs();
        }else{
            View::redirect('clients'); 
        }
        
        View::page('main/activitylogs', get_defined_vars());
    }

    public function settings()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }

            $this->model->indexAssets();            
            View::page('main/settings');
        } else {
            View::redirect('users/login');
        }
    }

    public function options()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }
            $this->model->doSave();
            $this->model->indexAssets();            
            $levels = $this->model->getUserLevels();
            $options = Option::getAll();
            $optionLists = $this->model->getOptionsList();
            View::page('main/options', get_defined_vars());
        } else {
            View::redirect('users/login');
        }
    }

    public function manageoptions()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }
            $this->model->doSave();
            $this->model->indexAssets();            
            $optionLists = $this->model->getOptionsList();
            View::page('main/manageoptions', get_defined_vars());
        } else {
            View::redirect('users/login');
        }
    }

    public function addOption()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }
            $this->model->doSave();
            $this->model->indexAssets();
            $groups = $this->model->getOptionGroups();
            View::page('main/addoption', get_defined_vars());
        } else {
            View::redirect('users/login');
        }
    }

    public function editOption()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }
            $this->model->doSave();
            $this->model->indexAssets();
            $groups = $this->model->getOptionGroups();
            $options = $this->model->getOption($this->segment[1]);
            View::page('main/editOption', get_defined_vars());
        } else {
            View::redirect('users/login');
        }
    }

    public function deleteoption()
    {
        $option = $this->model->doDeleteOption($this->segment[1]);
        View::redirect('manageoptions');
    }

    public function importexport()
    {
        $this->model->indexAssets();
        View::page('main/importexport', get_defined_vars());
    }
    
    public function ajax()
    {
        echo $this->model->getUserByCode($this->post['ID']);
    }
    
    public function checkemail()
    {
        echo User::infoByEmail('UserID',$this->post['email']);
    }
    
    public function changelanguage()
    {
        $u = $this->load->model('users', true, true);
        $this->model->updateLanguage($this->post['ID']);
        
        $u->updateUserInfo();
        Lang::init();
    }
    
    public function export()
    {
        if($this->auth->isLoggedIn()) {
            if(!User::can('Administer All')){
                View::redirect('clients'); 
            }
            App::exportTables();
        } else {
            View::redirect('users/login');
        }
        
    }    
}