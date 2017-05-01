<?php
class Capabilitygroups_model extends Model 
{
    function __construct() {
        parent::__construct();
        
        View::$footerscripts = array(
            'vendor/jquery/dist/jquery.min.js',
            'vendor/bootstrap/dist/js/bootstrap.min.js',
            'vendor/fastclick/lib/fastclick.js',
            'vendor/nprogress/nprogress.js'
            );
        
        //View::$styles = array('vendor/bootstrap/dist/css/bootstrap.min.css','vendor/font-awesome/css/font-awesome.min.css','assets/css/custom.css');
        View::$styles = array('vendor/bootstrap/dist/css/bootstrap.min.css','vendor/font-awesome/css/font-awesome.min.css','assets/css/custom.css');
        View::$segments = $this->segment;
    }
       
    function getCapabilityGroup($ID)
    {
        $sql = "SELECT * FROM user_capability_groups WHERE UserCapabilityGroupID = ".$ID." LIMIT 1";
        $groupsdata = $this->db->get_row($sql);
        
        return $groupsdata;
    } 
    
    function getCapabilityGroups($inactive = '')
    {
        $sql = "SELECT * FROM user_capability_groups";
        $where = " WHERE Active = 1";
        if($inactive == 'yes') {
            $where = " WHERE Active != 1";
        }
        $sql .= $where;        
        
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;			
        }
        unset($query);
        
        return $data;
    }
    
    function doSave()
    {
        if(isset($this->post['action'])) {
            switch($this->post['action']) {
                case "updategroup": {
                    $groupid = $this->post['groupid'];
                    $data = $this->post;
                    unset($data['action']);
                    unset($data['groupid']);

                    
                    $this->setSession('message',"Group has been updated!");

                    $grID = $this->db->update("user_capability_groups", $data, array('UserCapabilityGroupID' => $groupid));

                } break;
                case "addgroup": {

                    $data = $this->post;
                    unset($data['action']);

                    $groupid = $this->db->insert("user_capability_groups", $data);

                    if($groupid) {
                        
                        $this->setSession('message',"New group has been registered!");
                    }

                    //View::redirect('agency');
                } break;
            } 
        }
        return (object) $this->post;
    }   
        
    function doDelete($ID)
    {
        $where = array('UserCapabilityGroupID' => $ID);        
        $this->setSession('message',"Group has been deleted!");        
        $rowCount = $this->db->delete("user_capability_groups", $where);
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
        View::$footerscripts[] = 'assets/js/custom.js';
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

        View::$footerscripts[] = "vendor/iCheck/icheck.min.js";

        View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/table.js';

        View::$styles[] = "vendor/iCheck/skins/flat/green.css";

        View::$styles[] = "vendor/datatables.net-bs/css/dataTables.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-buttons-bs/css/buttons.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-responsive-bs/css/responsive.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-scroller-bs/css/scroller.bootstrap.min.css";
    }  
}