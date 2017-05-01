<?php

class ErrorPage extends Controller 
{
    public function __construct()
    {
        parent::__construct();	
        
        View::$footerscripts = array(
            'vendor/jquery/dist/jquery.min.js',
            'vendor/bootstrap/dist/js/bootstrap.min.js',
            'vendor/fastclick/lib/fastclick.js',
            'vendor/nprogress/nprogress.js',
            'assets/js/custom.css');
        View::$segments = $this->segment;
        
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index($error_msg = '')
    {		
        $this->load->view('404', get_defined_vars());
    }
}