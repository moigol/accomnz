<?php
class Capabilitygroups extends Controller 
{
    public function __construct()
    {
        parent::__construct();
            
        // Load model Auth
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn()) {
            View::redirect('users/login');
        }
        
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {   
        $this->model->indexAssets();
        $groups = $this->model->getCapabilityGroups();        
        View::page('capabilitygroups/list', get_defined_vars());
    }
        
    public function delete()
    {
        $group = $this->model->doDelete($this->segment[2]);
        View::redirect('capabilitygroups');
    }
    
    public function edit()
    {
        $this->model->doSave();
        $this->model->indexAssets();
        $group = $this->model->getCapabilityGroup($this->segment[2]);
        View::page('capabilitygroups/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $group = $this->model->doSave();            
        $this->model->commonAssets();
        View::page('capabilitygroups/add', get_defined_vars());   
    }
}