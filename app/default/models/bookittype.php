<?php
class Bookittype_model extends Model 
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
       
    function bookittype($ID)
    {
        $sql = "SELECT * FROM bookit_type WHERE id = ".$ID." LIMIT 1";
        $data = $this->db->get_row($sql);
        
        return $data;
    } 
    
    function bookittypes()
    {
        $sql = "SELECT * FROM bookit_type ORDER BY display_order";    
        
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
                    case "updatebookittype": {
                        $bookittypeid = $this->post['bookittypeid'];
                        $data = $this->post;
                        unset($data['action']);
                        unset($data['bookittypeid']);
                        
                        
                        $this->setSession('message',"Region has been updated!");

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);

                        $bookittypeID = $this->db->update("bookit_type", $data, array('id' => $bookittypeid));
                        
                        App::activityLog("Updated Book it type #ID-".$bookittypeid.'.');
                        
                    } break;
                    case "addbookittype": {

                        $data = $this->post;
                        unset($data['action']);

                        //$data['list_desc'] = $this->encrypt($data['list_desc']);

                        $bookittypeID = $this->db->insert("bookit_type", $data);

                        if($bookittypeID) {
                            
                            $this->setSession('message',"New Book it type has been registered!");
                        }

                        App::activityLog("Added Book it type #ID-".$bookittypeID.'.');
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
        $this->setSession('message',"Book it type has been deleted!");        
        $rowCount = $this->db->delete("bookit_type", $where);
        
        App::activityLog("Deleted Book it type #ID-".$ID.'.');
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