<?php
class Role extends Controller 
{
    public function __construct()
    {
        parent::__construct();
        // Load model Auth
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn()) {
            View::redirect('user/login');
        } 
        
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {    
        $this->model->indexAssets();
        $roles = $this->model->getLevels();        
        View::page('role/list', get_defined_vars());
    }
   
    public function delete()
    {
        $user = $this->model->doDelete($this->segment[2]);
        View::redirect('role');
    }
    
    public function edit()
    {
        $this->model->doSave();            
        $this->model->indexAssets();
        $role = $this->model->getLevel($this->segment[2]);
        $capabilities = $this->model->getCapabilities();
        
        View::page('role/edit', get_defined_vars());
    }
    
    public function apply()
    {
        $this->model->doApplyToUsers($this->segment[2]); 
        View::redirect('role/edit/'.$this->segment[2]);
    }
    
    public function add()
    {
        $pdata = $this->model->doSave();            
        $this->model->commonAssets();
        View::page('role/add', get_defined_vars());
    }
}