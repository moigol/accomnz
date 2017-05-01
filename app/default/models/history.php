<?php
class History_model extends Model 
{
    function __construct() {
        parent::__construct();
        
        View::$footerscripts = array(
            'vendor/jquery/dist/jquery.min.js',
            'vendor/bootstrap/dist/js/bootstrap.min.js',
            'vendor/fastclick/lib/fastclick.js',
            'vendor/nprogress/nprogress.js'
            );
        
        
        View::$styles = array('vendor/bootstrap/dist/css/bootstrap.min.css','vendor/font-awesome/css/font-awesome.min.css','assets/css/custom.css');
        View::$segments = $this->segment;
    }
       
    function getHistory($ID)
    {
        $sql = "SELECT * FROM history WHERE id = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    } 
    
    function getHistoryLogs()
    {
        $sql = "SELECT * FROM history";
       
        
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;			
        }
        unset($query);
        
        return $data;
    } 
    

 
    
    public function log($user_id, $note, $module = '', $moredata=null)
    {
        $moredata = ($moredata) ? print_r($moredata,true) : '';
        $data = [
            'user_id'=>$user_id,
            'note' => $note,
            'module' =>$module,
            'more_data' =>$moredata,
            'created_at'=>date('Y-m-d H:i:s')
        ];
        $history_id = $this->db->insert("history", $data);

        return $history_id;
    }   
    
     function doDelete($ID)
    {
        $where = array('id' => $ID);        
        $this->setSession('message',"Email Template has been deleted!");        
        $rowCount = $this->db->delete("email_templates", $where);
        
    }
  
    
    public function commonAssets()
    {
        View::$footerscripts[] = 'vendor/bootstrap-progressbar/bootstrap-progressbar.min.js';            
        View::$footerscripts[] = 'vendor/switchery/dist/switchery.min.js';
        View::$footerscripts[] = 'vendor/iCheck/icheck.min.js';            
        View::$footerscripts[] = 'vendor/tinymce/tinymce.min.js';            
        View::$footerscripts[] = 'assets/js/fileinput.js';            
        View::$footerscripts[] = 'vendor/devbridge-autocomplete/dist/jquery.autocomplete.min.js';                        

        View::$footerscripts[] = 'vendor/validator/validator.min.js';
        //View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/profile.js';
        View::$footerscripts[] = 'assets/js/pw.js';

        View::$styles[] = 'vendor/iCheck/skins/flat/green.css';
        View::$styles[] = 'assets/css/fileinput.css';
    }
    
    public function indexAssets()
    {
        View::$footerscripts[] = "vendor/datatables.net/js/jquery.dataTables.min.js";
        View::$footerscripts[] = "vendor/datatables.net-bs/js/dataTables.bootstrap.min.js";
        View::$footerscripts[] = "vendor/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js";
        View::$footerscripts[] = "vendor/datatables.net-keytable/js/dataTables.keyTable.min.js";
        View::$footerscripts[] = "vendor/datatables.net-responsive/js/dataTables.responsive.min.js";
        View::$footerscripts[] = "vendor/datatables.net-responsive-bs/js/responsive.bootstrap.js";
        View::$footerscripts[] = "vendor/datatables.net-scroller/js/datatables.scroller.min.js";
        
        View::$footerscripts[] = 'assets/js/moment/moment.min.js';
        View::$footerscripts[] = 'assets/js/datepicker/daterangepicker.js';
        View::$footerscripts[] = 'assets/js/prettyPhoto/jquery.prettyPhoto.js';

        View::$footerscripts[] = "vendor/iCheck/icheck.min.js";

        View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/emailtemplates.js';
        View::$footerscripts[] = 'assets/js/table.js';

        View::$styles[] = "vendor/iCheck/skins/flat/green.css";

        View::$styles[] = "";

        View::$styles[] = "vendor/datatables.net-bs/css/dataTables.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-buttons-bs/css/buttons.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-responsive-bs/css/responsive.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-scroller-bs/css/scroller.bootstrap.min.css";
    }  
}