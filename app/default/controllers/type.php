<?php
class Type extends Controller 
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
        $types = $this->model->getTypes();        
        View::page('type/list', get_defined_vars());
    }
    
    public function delete()
    {
        $rgions = $this->model->doDelete($this->segment[2]);
        View::redirect('type');
    }
    
    public function edit()
    {
        $this->model->commonAssets();
        $this->model->doSave();   
        $type = $this->model->getType($this->segment[2]);
        View::page('type/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $this->model->doSave();
        $this->model->commonAssets();
        View::page('type/add', get_defined_vars());  
    }
}