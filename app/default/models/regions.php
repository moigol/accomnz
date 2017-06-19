<?php
class Regions_model extends Model 
{
    function __construct() {
        parent::__construct();
        
        View::$footerscripts = array(
            'assets/jquery/jquery.js',
            'assets/jquery/jquery-ui.js',
            'assets/bootstrap/js/bootstrap.min.js'
            );   

        View::$styles = array(
            'assets/jquery/jquery-ui.css',
            'assets/bootstrap/css/bootstrap.min.css'
            );
        View::$segments = $this->segment;
    }
       
    function getRegion($ID)
    {
        $sql = "SELECT * FROM regions WHERE id = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    } 
    
    function getRegions()
    {
        $sql = "SELECT * FROM regions ORDER BY region";    
        
        $query = &$this->db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;
        }
        unset($query);
        
        return $data;
    }

    function getRegionByID($ID)
    {
        if($ID) {            
        
            $sql = "SELECT * FROM regions WHERE id = '$ID' LIMIT 1";

            $query = &$this->db->prepare($sql);
            $query->execute();
            $row = $query->fetch(PDO::FETCH_CLASS);
            unset($query);
            
            return json_encode($row);

        } else {
            return false;
        }
    }
    
    function doSave()
    {
        if($this->post) { 
            if(isset($this->post['action'])) {
                switch($this->post['action']) {
                    case "updateregion": {
                        $regid = $this->post['regid'];
                        $data = $this->post;
                        unset($data['action']);
                        unset($data['regid']);
                        
                        
                        $this->setSession('message',"Region has been updated!");

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);

                        $regID = $this->db->update("regions", $data, array('id' => $regid));
                        
                        App::activityLog("Updated Region #ID-".$prid.'.');
                        
                    } break;
                    case "addregion": {

                        $data = $this->post;
                        unset($data['action']);

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);
                        
                        $prodID = $this->db->insert("regions", $data);

                        if($prodID) {
                            
                            $this->setSession('message',"New Region has been registered!");
                        }

                        App::activityLog("Added Region #ID-".$prodID.'.');
                    } break;
                } 
            }
            return (object) $this->post;
        } else {
            
        }
    }   
    
    function doDelete($ID)
    {
        $where = array('id' => $ID);        
        $this->setSession('message',"Region has been deleted!");        
        $rowCount = $this->db->delete("regions", $where);
        
        App::activityLog("Deleted Region #ID-".$ID.'.');
    }
    
    public function commonAssets()
    {
        View::$scripts[] = 'assets/js/ckeditor/ckeditor.js';

        View::$footerscripts[] = "vendors/datatables/js/jquery.dataTables.min.js";
        View::$footerscripts[] = "vendors/datatables/dataTables.bootstrap.js";
        View::$footerscripts[] = 'assets/js/tables.js';
        View::$footerscripts[] = 'assets/js/custom.js';

        View::$styles[] = 'assets/css/calendar.css';
        View::$styles[] = 'assets/css/buttons.css';
        View::$styles[] = 'assets/css/forms.css';
        View::$styles[] = 'assets/css/stats.css';
        View::$styles[] = 'assets/css/styles.css';
        View::$styles[] = "vendors/datatables/dataTables.bootstrap.css";
    }

    public function indexAssets()
    {

        View::$footerscripts[] = "vendors/datatables/js/jquery.dataTables.min.js";
        View::$footerscripts[] = "vendors/datatables/dataTables.bootstrap.js";
        View::$footerscripts[] = 'assets/js/tables.js';
        View::$footerscripts[] = 'assets/js/custom.js';

        View::$styles[] = 'assets/css/calendar.css';
        View::$styles[] = 'assets/css/buttons.css';
        View::$styles[] = 'assets/css/forms.css';
        View::$styles[] = 'assets/css/stats.css';
        View::$styles[] = 'assets/css/styles.css';
        View::$styles[] = "vendors/datatables/dataTables.bootstrap.css";

    }
}