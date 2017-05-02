<?php
class Region extends Controller 
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
        View::page('region/list', get_defined_vars());
    }
    
    public function delete()
    {
        $subbs = $this->model->doDelete($this->segment[2]);
        View::redirect('region');
    }
    
    public function edit()
    {
        $regions = $this->load()->model('regions',true,true);
        $this->model->doSave();
            
        $this->model->indexAssets();
        $subrb = $this->model->getRegion($this->segment[2]);
   
        $regs = $regions->getRegions();
        // $items = $this->model->getProductItemsRelated($this->segment[2]); 
        View::page('region/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $regions = $this->load()->model('regions',true,true);
        $this->model->doSave();
        $this->model->indexAssets();
   
        $regs = $regions->getRegions();
        // $items = $this->model->getProductItemsRelated($this->segment[2]); 
        View::page('region/add', get_defined_vars());  
    }
}