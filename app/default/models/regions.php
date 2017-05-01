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
        $sql = "SELECT * FROM suburb WHERE id = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    } 
    
    function getRegions()
    {
        $sql = "SELECT * FROM regions";    
        
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
                    case "updateproduct": {
                        $prid = $this->post['prid'];
                        $data = $this->post;
                        unset($data['action']);
                        unset($data['prid']);
                        
                        
                        $this->setSession('message',"Product has been updated!");

                        $prodID = $this->db->update("products", $data, array('ProductID' => $prid));
                        
                        App::activityLog("Updated Product #PRD-".$prid.'.');
                        
                    } break;
                    case "addproduct": {

                        $data = $this->post;
                        unset($data['action']);

                        $prodID = $this->db->insert("products", $data);

                        if($prodID) {
                            
                            $this->setSession('message',"New product has been registered!");
                        }

                        App::activityLog("Added Product #PRD-".$prodID.'.');
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
        $this->setSession('message',"Suburb has been deleted!");        
        $rowCount = $this->db->delete("suburb", $where);
        
        App::activityLog("Deleted Suburb #ID-".$ID.'.');
    }
    
    public function commonAssets()
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