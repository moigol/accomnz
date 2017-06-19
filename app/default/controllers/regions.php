<?php
class Regions extends Controller 
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
        $this->load->vendor('utility');
    }

    public function index()
    {    
        $this->model->indexAssets();
        $regions = $this->model->getRegions();        
        View::page('regions/list', get_defined_vars());
    }
    
    public function delete()
    {
        $rgions = $this->model->doDelete($this->segment[2]);
        View::redirect('regions');
    }
    
    public function edit()
    {
        $this->model->commonAssets();
        $this->model->doSave();   
        $region = $this->model->getRegion($this->segment[2]);
        View::page('regions/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $this->model->doSave();
        $this->model->commonAssets();
        View::page('regions/add', get_defined_vars());  
    }
}