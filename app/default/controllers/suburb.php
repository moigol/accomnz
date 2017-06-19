<?php
class Suburb extends Controller 
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
        $suburbs = $this->model->getSuburbs();        
        View::page('suburb/list', get_defined_vars());
    }
    
    public function delete()
    {
        $subbs = $this->model->doDelete($this->segment[2]);
        View::redirect('suburb');
    }
    
    public function edit()
    {
        $regions = $this->load()->model('regions',true,true);
        $this->model->doSave();
            
        $this->model->commonAssets();
        $subrb = $this->model->getSuburb($this->segment[2]);
   
        $regs = $regions->getRegions();
        // $items = $this->model->getProductItemsRelated($this->segment[2]); 
        View::page('suburb/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $regions = $this->load()->model('regions',true,true);
        $this->model->doSave();
        $this->model->commonAssets();
   
        $regs = $regions->getRegions();
        // $items = $this->model->getProductItemsRelated($this->segment[2]); 
        View::page('suburb/add', get_defined_vars());  
    }
}