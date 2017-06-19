<?php
class Bookittype extends Controller 
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
        $bookits = $this->model->bookittypes();        
        View::page('bookittype/list', get_defined_vars());
    }
    
    public function delete()
    {
        $rgions = $this->model->doDelete($this->segment[2]);
        View::redirect('bookittype');
    }
    
    public function edit()
    {
        $this->model->commonAssets();
        $this->model->doSave();   
        $bookittype = $this->model->bookittype($this->segment[2]);
        View::page('bookittype/edit', get_defined_vars());  
    }
    
    public function add()
    {
        $this->model->doSave();
        $this->model->commonAssets();
        View::page('bookittype/add', get_defined_vars());  
    }
}