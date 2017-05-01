<?php
class Role_model extends Model
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
    
    function getLevel($ID)
    {
        $sql = "SELECT * FROM user_levels WHERE UserLevelID = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    } 
    
    function getLevels()
    {
        $data = array();
        $sql = "SELECT * FROM user_levels";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;			
        }
        unset($query);
        
        return $data;
    } 
    
    function getCapabilities()
    {
        // WHERE uc.UserCapabilityGroupID > 1
        $data = array();
        $sql = "SELECT uc.*, ucg.Name as GroupName FROM user_capabilities uc LEFT JOIN user_capability_groups ucg ON uc.UserCapabilityGroupID = ucg.UserCapabilityGroupID ORDER BY ucg.UserCapabilityGroupID ASC";
        $query = &$this->db->prepare($sql);
        $query->execute();
        
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[$row->GroupName][$row->UserCapabilityID] = $row;
        }
        unset($query);
        
        return $data;
    } 
    
    function doSave()
    {
        if($this->post) { 
            if(isset($this->post['action'])) {
                switch($this->post['action']) {
                    case "updaterole": {
                        $data = $this->post;                    
                        
                        $data['Capability'] = $this->arrayToString(array('none'));
                        
                        if(isset($data['capabilities']) && count($data['capabilities'])) {
                            $data['Capability'] = $this->arrayToString($data['capabilities']);
                        }
                        
                        $where = array('UserLevelID' => $this->post['roleid']);

                        unset($data['action']);
                        unset($data['roleid']);
                        unset($data['capabilities']);
                        unset($data['applyRoleToUSsers']);
                        
                        $rowCount = $this->db->update("user_levels", $data, $where);
                        
                        if(isset($this->post['applyRoleToUSsers'])) {
                            $rowCount = $this->db->update("users", array('Capability'=>$data['Capability']), array('Level' => $this->post['roleid']));
                        }

                        
                        $this->setSession('message',"User role data has been saved.");
                        
                        App::activityLog("Updated Role #".$this->post['roleid'].'.');

                    } break;
                    case "addrole": {
                        $data = $this->post;                    
                        
                        unset($data['action']);
                        
                        $levelID = $this->db->insert("user_levels", $data);
                        
                        if($levelID) {
                            
                            $this->setSession('message',"New user role has been added!");
                        }
                        
                        App::activityLog("Added Role #".$levelID.'.');
                    } break;
                } 
            }
            return (object) $this->post;
        } else {
            
        }
    } 
    
    function doApplyToUsers($ID=NULL) {
        if($ID) {
            $capa = Level::info('Capability',$ID);
            $rowCount = $this->db->update("users", array('Capability'=>$capa), array('Level' => $ID));              
        }
    }
    
    function doDelete($UserLevelID)
    {
        $where = array('UserLevelID' => $UserLevelID);
        $rowCount = $this->db->delete("user_levels", $where);
        
        App::activityLog("Deleted Role #".$UserLevelID.'.');
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

        View::$footerscripts[] = "vendor/iCheck/icheck.min.js";

        View::$footerscripts[] = 'assets/js/custom.js';
        View::$footerscripts[] = 'assets/js/table.js';

        View::$styles[] = "assets/css/form.css";
        View::$styles[] = "vendor/iCheck/skins/flat/green.css";
        View::$styles[] = 'assets/css/fileinput.css';

        View::$styles[] = "vendor/datatables.net-bs/css/dataTables.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-buttons-bs/css/buttons.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-responsive-bs/css/responsive.bootstrap.min.css";
        View::$styles[] = "vendor/datatables.net-scroller-bs/css/scroller.bootstrap.min.css";
    }
}