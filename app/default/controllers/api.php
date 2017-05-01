<?php
class Api extends Controller 
{
        
    public function __construct()
    {
        parent::__construct();
         
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {    
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn()) {
            View::redirect('users/login');
        }
    }
    
    public function get()
    {    
        $id  = isset($this->segment[2]) ? $this->segment[2] : 'none';
	$key = isset($this->segment[3]) ? $this->segment[3] : 'none';
	$out = isset($this->segment[4]) ? $this->segment[4] : 'object';
        
        if($this->model->apiConnect($id,$key)) {
            switch(strtolower($out)) {
                case 'json': 
                    echo json_encode($this->model->getAccounts());
                break;
                case 'array': 
                    echo print_r($this->model->getAccounts($out));
                break;
                default: 
                    echo print_r($this->model->getAccounts());
                break;
            }
        } else {
            echo 'Error: Please check the user id and api key is correct, or contact the administrator.';
        }
    }
    
    public function post()
    {    
        $id  = isset($this->post['id']) ? $this->post['id'] : 'none';
	$key = isset($this->post['key']) ? $this->post['key'] : 'none';
	$out = isset($this->post['output']) ? $this->post['output']: 'object';
        
        if($this->model->apiConnect($id,$key)) {
            switch(strtolower($out)) {
                case 'json': 
                    echo json_encode($this->model->getAccounts());
                break;
                case 'array': 
                    print_r((array)$this->model->getAccounts($out));
                break;
                default: 
                    print_r($this->model->getAccounts());
                break;
            }
        } else {
            echo 'Error: Please check the user id and api key is correct, or contact the administrator.';
        }
    }
}