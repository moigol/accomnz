<?php
class Capability_model extends Model
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
    
    function getCapability($ID)
    {
        $sql = "SELECT * FROM user_capabilities WHERE UserCapabilityID = ".$ID." LIMIT 1";
        $data = $this->db->get_row($sql);
        
        return $data;
    } 
    
    function getCapabilityGroups()
    {
        $sql = "SELECT * FROM user_capability_groups";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->UserCapabilityGroupID] = $row->Name;			
        }
        unset($query);
        
        return $data;
    } 
    
    function getCapabilities()
    {
        $sql = "SELECT uc.*, ucg.Name as GroupName FROM user_capabilities uc LEFT JOIN user_capability_groups ucg ON uc.UserCapabilityGroupID = ucg.UserCapabilityGroupID ORDER BY ucg.UserCapabilityGroupID ASC";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
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
                case "updatecapability": {
                    $data = $this->post;                    
                    $where = array('UserCapabilityID' => $this->post['capabilityid']);

                    unset($data['action']);
                    unset($data['capabilityid']);

                    $rowCount = $this->db->update("user_capabilities", $data, $where);

                    
                    $this->setSession('message',"User capability data has been saved.");
                    
                    App::activityLog("Updated Capability #".$this->post['capabilityid'].'.');

                } break;
                case "addcapability": {
                    $data = $this->post;                    

                    unset($data['action']);

                    $levelID = $this->db->insert("user_capabilities", $data);

                    if($levelID) {
                        
                        $this->setSession('message',"New user capability has been added!");
                    }
                    
                    App::activityLog("Added Capability #".$levelID.'.');

                    View::redirect('capability');
                } break;
            } 
        }
        return (object) $this->post;
    }   
    
    function doDelete($UserCapabilityID)
    {
        $where = array('UserCapabilityID' => $UserCapabilityID);
        $rowCount = $this->db->delete("user_capabilities", $where);
        
        App::activityLog("Deleted Capability #".$UserCapabilityID.'.');
    }
    
    public function commonAssets()
    {
        View::$footerscripts[] = 'vendor/bootstrap-progressbar/bootstrap-progressbar.min.js';            
        View::$footerscripts[] = 'vendor/switchery/dist/switchery.min.js';
        View::$footerscripts[] = 'vendor/iCheck/icheck.min.js';            
        View::$footerscripts[] = 'vendor/tinymce/tinymce.min.js';            
        View::$footerscripts[] = 'assets/js/fileinput.js';            
        View::$footerscripts[] = 'vendor/devbridge-autocomplete/dist/jquery.autocomplete.min.js';                        
        View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/profile.js';

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