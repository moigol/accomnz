<?php
class Type_model extends Model 
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
       
    function getType($ID)
    {
        $sql = "SELECT * FROM type WHERE id = ".$ID." LIMIT 1";
        $data = $this->db->get_row($sql);
        
        return $data;
    } 
    
    function getTypes()
    {
        $sql = "SELECT * FROM type";    
        
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
        if($this->post) { 
            if(isset($this->post['action'])) {
                switch($this->post['action']) {
                    case "updatetype": {
                        $typeid = $this->post['typeid'];
                        $data = $this->post;
                        unset($data['action']);
                        unset($data['typeid']);
                        
                        
                        $this->setSession('message',"Type has been updated!");

                        $typeID = $this->db->update("type", $data, array('id' => $typeid));
                        
                        App::activityLog("Updated Type #ID-".$typeid.'.');
                        
                    } break;
                    case "addtype": {

                        $data = $this->post;
                        unset($data['action']);

                        $typeID = $this->db->insert("type", $data);

                        if($typeID) {
                            
                            $this->setSession('message',"Type has been registered!");
                        }

                        App::activityLog("Added Type #ID-".$typeID.'.');
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
        $this->setSession('message',"Type has been deleted!");        
        $rowCount = $this->db->delete("type", $where);
        
        App::activityLog("Deleted type #ID-".$ID.'.');
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