<?php
class Pdf extends Controller 
{
    public function __construct()
    {
        parent::__construct();
            
        // Load model Auth
        $this->load->model('auth');        
        $this->load->model('pdfengine');   
    }

    public function index()
    {    
        $pdf = isset($this->segment[1]) ? $this->segment[1] : false;
        
        if($pdf) {
            $opt = array(
                'filename' => $pdf.'.pdf',
                'html' => App::getFileContents('emails'.DS.'pdfcontent'.DS.$pdf.'.eml'),
                'top' =>"0pt",
                'right' => "0pt",
                'bottom' =>"0pt",
                'left' => "0pt",
            );

            echo $this->pdfengine->generate($opt);
        } else {
            echo 'Please set a file name e.g. http://globalasset.loc/pdf/traditional';
        }
    }
}