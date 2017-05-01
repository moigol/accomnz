<?php
class PdfEngine extends Model
{
    function generate($arg=array())
    {
        App::vendor('pdfcrowd');
        
        $opt = array(
            'filename' => isset($arg['filename']) ? $arg['filename'] : date('Y_m_d_H_i_s').".pdf",
            'html' => isset($arg['html']) ? $arg['html'] : false,
            'header' => isset($arg['header']) ? $arg['header'] : false,
            'footer' => isset($arg['footer']) ? $arg['footer'] : false,
            'width' => isset($arg['width']) ? $arg['width'] : "8.268in",
            'height' => isset($arg['height']) ? $arg['height'] : "11.693in",
            'top' => isset($arg['top']) ? $arg['top'] : "20pt",
            'right' => isset($arg['right']) ? $arg['right'] : "20pt",
            'bottom' => isset($arg['bottom']) ? $arg['bottom'] : "20pt",
            'left' => isset($arg['left']) ? $arg['left'] : "20pt",
        );
        
        $pdfId = (Option::get('pdf_id')) ? Option::get('pdf_id') : Config::get('PDFCROWDID'); 
        $pdfKey = (Option::get('pdf_key')) ? Option::get('pdf_key') : Config::get('PDFCROWDKEY');
        
        $filename = $opt['filename'];
        
        $root_path = APPPATH."views".DS."assets".DS.'pdf';
        
        $year = date('Y');
                
        if (!file_exists($root_path.DS.$year)) {
            mkdir($root_path.DS.$year, 0777, true);            
            chmod($root_path.DS.$year, 0777);
        }

        $month = date('m');

        if (!file_exists($root_path.DS.$year.DS.$month)) {
            mkdir($root_path.DS.$year.DS.$month.DS, 0777, true);  
            chmod($root_path.DS.$year.DS.$month.DS, 0777); 
        }

        $day = date('d');

        if (!file_exists($root_path.DS.$year.DS.$month.DS.$day)) {
            mkdir($root_path.DS.$year.DS.$month.DS.$day.DS, 0777, true);   
            chmod($root_path.DS.$year.DS.$month.DS.$day.DS, 0777); 
        }

        $subfolder = DS.$year.DS.$month.DS.$day.DS; 
        
        $path = $root_path.$subfolder;
        
        try
        {   
            // create an API client instance
            $pdfc = new Pdfcrowd($pdfId,$pdfKey);

            $pdfc->setPageWidth($opt['width']);
            $pdfc->setPageHeight($opt['height']);

            if($opt['header']) {
                $pdfc->setHeaderHtml($opt['header']);
            }

            if($opt['footer']) {
                $pdfc->setFooterHtml($opt['footer']);
            }
            
            $pdfc->setPageMargins($opt['top'], $opt['right'], $opt['bottom'], $opt['right']);
            $pdfc->usePrintMedia(true);
            $pdfc->enableImages(true);
            
            $pdf = $pdfc->convertHtml($opt['html']);
            file_put_contents($path.$filename, $pdf); 
            
            return $path.$filename;
        }
        catch(PdfcrowdException $why)
        {
            return "Pdfcrowd Error: " . $why;
        }
    }
}