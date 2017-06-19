<?php
class Suburb_model extends Model 
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
       
    function getSuburb($ID)
    {
        $sql = "SELECT * FROM suburb WHERE id = ".$ID." LIMIT 1";
        $userdata = $this->db->get_row($sql);
        
        return $userdata;
    } 
    
    function getSuburbs()
    {
        $sql = "SELECT * FROM suburb";    
        
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
                    case "updatesuburb": {
                        $subbid = $this->post['suburbid'];
                        $data = $this->post;
                        unset($data['action']);
                        unset($data['suburbid']);
                        
                        
                        $this->setSession('message',"Suburb has been updated!");

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);

                        $subbID = $this->db->update("suburb", $data, array('id' => $subbid));
                        
                        App::activityLog("Updated Suburb #ID-".$subbid.'.');
                        
                    } break;
                    case "addsuburb": {

                        $data = $this->post;
                        unset($data['action']);

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);
                        
                        $subbid = $this->db->insert("suburb", $data);

                        if($subbid) {
                            
                            $this->setSession('message',"New suburb has been registered!");
                        }

                        App::activityLog("Added suburb #ID-".$subbid.'.');
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