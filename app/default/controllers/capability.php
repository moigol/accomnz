<?php
class Capability extends Controller 
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
        $capabilities = $this->model->getCapabilities();        
        View::page('capability/list', get_defined_vars());
    }
    
    public function capabilities()
    {    
        $this->model->indexAssets();
        $capabilities = $this->model->getCapabilities();        
        View::page('capability/list', get_defined_vars());
    }
    
    public function delete()
    {
        $user = $this->model->doDelete($this->segment[2]);
        View::redirect('capability');
    }
    
    public function edit()
    {
        $this->model->doSave();            
        $this->model->commonAssets();            
        $capgroup = $this->model->getCapabilityGroups();
        $capability = $this->model->getCapability($this->segment[2]);
        View::page('capability/edit', get_defined_vars());
    }
    
    public function add()
    {
        $pdata = $this->model->doSave();            
        $this->model->commonAssets();
        $capgroup = $this->model->getCapabilityGroups();
        View::page('capability/add', get_defined_vars());
    }
}