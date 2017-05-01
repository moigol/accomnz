<?php  
/**
 * PHP 5++
 *
 * MyPHPFrame(tm) : Rapid Development Framework
 * Copyright (c) CuteArts Web Solutions (http://cutearts.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @location      /sys/core/Common.php
 * @package       sys
 * @version       MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */


class Common
{
    static $instance;
    public $get;
    public $post;
    public $file;
    public $controller;
    public $method;
    public $segment;
    public $db;
    public $error_msg;
    public $success_msg;
    
    public $view_dir; 
    
    public $upload_error = array(
        0 => "There is no error, the file uploaded with success",
        1 => "The uploaded file exceeds the size limit",
        2 => "The uploaded file exceeds the size limit",
        3 => "The uploaded file was only partially uploaded",
        4 => "No file was uploaded",
        6 => "Missing a temporary folder"
    );
    
    function __construct()  
    {
        if($_REQUEST) {
            $this->sanitizeRequest();
        }
        
        $this->parseSegment();
        $this->db = new DB();
        
        $this->view_dir = APPPATH.'views'.DS;
        
        
    }

    function sanitizeRequest()  
    {
        $this->get = isset($_GET) ? $this->cleanArrayData($_GET) : NULL;
        $this->post = isset($_POST) ? $this->cleanArrayData($_POST) : NULL;
        $this->file = isset($_FILES) ? $_FILES : NULL;
        
        return true;
    }

    function parseSegment($default = false)
    {
        $segment = array();

        /**
         *  Parse uri query string
         */     
        if($this->get != NULL)
        {
            $segments = array_filter(explode('/',$this->get['appsegment']));

            foreach($segments as $key => $val)
            {
                switch($key)
                {
                    case 0:
                    {
                        $this->controller = $val;   
                    } break;
                    case 1:
                    {
                        $this->method = $val;
                    } break;
                }
                
                $segment[] = $val;
            }

            $this->segment = $segment;
        }
    }   

    /**
     * Route the page classes
     *
     * @access  public
     * @return  object
     */
    function pageRouter()
    {
        global $models;

        $models = array();
        $this->error_msg = false;

        $classname      = $this->controller === NULL ? Config::get('CONTROLLER') : $this->controller;
        $methodname     = $this->method === NULL ? 'index' : $this->method;
        
        if($this->load()->controller($classname) === false) {
            $methodtemp = $classname;
            $classname = Config::get('CONTROLLER');
            
            if($loadedClass = $this->load()->controller($classname)) {            
                // Default
                if(method_exists($loadedClass,$methodtemp)) {                
                    $classname = Config::get('CONTROLLER');
                    $methodname = $methodtemp;
                } else {
                    $this->error_msg = 'Unable to locate class.';
                    $classname = Config::get('NOPAGE');
                    $methodname = 'index';
                }
            } else {
                $this->error_msg = 'Unable to locate class.';
                $classname = Config::get('NOPAGE');
                $methodname = 'index';
            }
        }
        
        // Start routing to controller
        if($loadedClass = $this->load()->controller($classname)){
            
            // Auto assign controller's _model
            $this->load()->model($classname);

            if(!$loadedClass === false)
            {
                foreach($models as $k => $model)
                {
                    $modelName      = strtolower($model);
                    $modelNameCall  = $modelName;
                    $modelKey       = $k;

                    if(strtolower($classname) == $modelName)
                    {
                        $modelNameCall  = $modelName.'_model';
                        $modelKey       = 'model';
                    }

                    if(class_exists($modelNameCall))
                    {
                        $loadedClass->$modelKey = new $modelNameCall();                     
                    }
                }
                
                if(method_exists($loadedClass,$methodname)) {
                    if($this->error_msg) {
                        $loadedClass->index($this->error_msg);
                    } else {
                        $loadedClass->$methodname();
                    }
                } else {
                    $loadedClass->index('Unable to locate method in class.');
                }
            } else {
                
            }
        }
    }

    /**
     * Load called controller/model class
     *
     * @access  public
     * @return  object
     */
    public function load()
    {
        if(class_exists('Loader'))
        {
            return new Loader();        
        }
    }

    /**
     * Load db class
     *
     * @access  public
     * @return  object
     */
    public function db()
    {
        if(class_exists('DB'))
        {
            return new DB();        
        }
    }
    
    /**
     * Clean data
     *
     * @access  public
     * @return  array
     */
    public function cleanArrayData($arr)
    {
        if(count($arr))
        {
            return filter_var_array($arr, FILTER_SANITIZE_STRING);
        } else {
            return $arr;
        }
    }
    
    /**
     * Do session
     *
     * @access  public
     * @return  string
     */
    function setSession($k,$v)
    {
        $currentSession = array();
        
        if(isset($_SESSION[SESSIONCODE])) {
            $currentSession = $this->stringToArray($_SESSION[SESSIONCODE]);
        } else {
            $_SESSION[SESSIONCODE] = $this->arrayToString(array('loggedin'=>false,'error'=>false,'message'=>false));
            $currentSession = $this->stringToArray($_SESSION[SESSIONCODE]);            
        }
        
        $currentSession[$k] = $v;
        
        $_SESSION[SESSIONCODE] = $this->arrayToString($currentSession);
    }
    
    /**
     * Get session
     *
     * @access  public
     * @return  string
     */
    function getSession($k)
    {
        $currentSession = array();
        
        if(isset($_SESSION[SESSIONCODE])) {
            $currentSession = $this->stringToArray($_SESSION[SESSIONCODE]);
        } else {
            $_SESSION[SESSIONCODE] = $this->arrayToString(array('loggedin'=>false,'error'=>false,'message'=>false));
            $currentSession = $this->stringToArray($_SESSION[SESSIONCODE]);            
        }
        
        return isset($currentSession[$k]) ? $currentSession[$k] : false;
    }
    
    /**
     * Array to string
     *
     * @access  public
     * @return  string
     */
    function arrayToString($arr)
    {
        $arrs = is_array($arr) ? base64_encode(serialize($arr)) : false;
        return $arrs;
    }
    
    /**
     * String to array
     *
     * @access  public
     * @return  string
     */
    function stringToArray($str)
    {
        $strs = strlen($str)>0 ? unserialize(base64_decode($str)) : false;
        return $strs;
    }
    
    /**
     * Encrypt string mapper
     *
     * @access  public
     * @return  string
     */
    function encrypt($str = '')
    {
        return $this->hashedit($str);
    }
    
    /**
     * Decrypt string mapper
     *
     * @access  public
     * @return  string
     */
    function decrypt($str = '')
    {
        return $this->dehashedit($str);
    }
    
    /**
     * Encrypt string
     *
     * @access  private
     * @return  string
     */
    private function hashedIt($q) 
    {
        $cryptKey  = HASHPHRASE;
        $qEncoded  = base64_encode( mcrypt_encrypt( MCRYPT_RIJNDAEL_256, md5( $cryptKey ), $q, MCRYPT_MODE_CBC, md5( md5( $cryptKey ) ) ) );
        return( $qEncoded );
    }
    
    /**
     * Decrypt string
     *
     * @access  private
     * @return  string
     */
    private function dehashedIt($q) 
    {
        $cryptKey  = HASHPHRASE;
        $qDecoded  = rtrim( mcrypt_decrypt( MCRYPT_RIJNDAEL_256, md5( $cryptKey ), base64_decode( $q ), MCRYPT_MODE_CBC, md5( md5( $cryptKey ) ) ), "\0");
        return( $qDecoded );
    }

    public function assets()
    {
        $thepath = $this->buildAssetPath();
        if($thepath) {
            
            $fileext = array(
                'css'=>'text/css',
                'js'=>'application/javascript',
                'txt'=>'text/plain',
                'png'=>'image/png',
                'PNG'=>'image/png',
                'jpg'=>'image/jpeg',
                'jpeg'=>'image/jpeg',
                'JPG'=>'image/jpeg',
                'JPEG'=>'image/jpeg',
                'ico'=>'image/x-icon',
                'pdf'=>'application/pdf'
            );
            $path_parts = pathinfo($thepath);            
            
            $file = basename($thepath);
            ignore_user_abort(true);
            set_time_limit(0); // disable the time limit for this script

            $path = $this->view_dir."assets".dirname($thepath).DS;
            $dl_file = preg_replace("([^\w\s\d\-_~,;:\[\]\(\].]|[\.]{2,})", '',$file); // simple file name validation
            $dl_file = filter_var($dl_file, FILTER_SANITIZE_URL); // Remove (more) invalid characters

            $fullPath = $path.$dl_file;
            
            if(file_exists($fullPath)) {   
                if(isset($fileext[$path_parts['extension']])) {
                    $fp = fopen($fullPath, 'rb');            
                    header("HTTP/1.1 200 OK");
                    header('Content-Type: '.$fileext[$path_parts['extension']]);
                    header('Content-Length: '.filesize($fullPath));
                    fpassthru($fp);
                    exit;
                } else {
                    echo  "<script type='text/javascript'> alert('File type not allowed!'); window.close(); </script>";
                }
            } else {
                echo  "<script type='text/javascript'> alert('File doesn\'t exists!'); window.close(); </script>";
            }
        } else {
            echo  "<script type='text/javascript'> alert('Direct access is not allowed!'); window.close(); </script>";
        }
    }

    /**
    *  Build public path.
    * 
    *  @return     path
    *  @access     Public
    */
    public function buildAssetPath()
    {
        $ppath = '';
        for($i = 1; $i < count($this->segment); $i++) {
            $ppath .= DS.$this->segment[$i];
        }
        if($ppath) {
            return $ppath;
        } else {
            return false;
        }
    }
    
    /**
    *  Generate password.
    * 
    *  @return     path
    *  @access     Public
    */
    public function generatePw($length = 9, $add_dashes = false, $available_sets = 'luds')
    {
        return $this->hashedit($this->generatePassword($length,$add_dashes,$available_sets));
    }
    
     /**
    *  Generate hashed filename.
    * 
    *  @return     path
    *  @access     Public
    */
    public function generateFileName($length = 9, $add_dashes = false, $available_sets = 'luds')
    {
        return $this->hashedit($this->generatePassword($length,$add_dashes,$available_sets));
    }
    
    /**
    *  File Upload.
    * 
    *  @return     path
    *  @access     Public
    *  
    *  TO DO: move this outside the core files.
    */
    public function fileUpload($files = false, $userID = NULL, $folder = '', $filename = false, $category = false, $subcategory = false, $filenamec = false, $access = false) 
    {
        $db = new DB();
        $filedata = array();
        $fileitemdata = array();
        $files = ($files) ? $files : $_FILES;
        $root_path = $this->view_dir."assets".DS.'files'.$folder;
        
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
        
        $file_path = $root_path.$subfolder;
        
        $ui = User::info(false,$userID);
        $userID = ($userID) ? $userID : User::info('UserID');
        
        foreach($files as $key => $file) {      
            $f['UserID'] = $userID;
            $f['DateAdded'] = date('Y-m-d H:i:s');
            
            if($category){
                $f['FileCategoryID'] = $category;
            }

            if($subcategory){
                $f['FileSubCategoryID'] = $subcategory;
            }
            
            if($access){
                $f['FileAccess'] = $this->arrayToString($access);
            }
            
            $fileID = $db->insert("files", $f);
            
            $uploadedfile = 0;
            if (is_array($files[$key]['name'])) {
                $num_files = count($files[$key]['tmp_name']);                
                for($i=0; $i < $num_files;$i++)
                {
                    if (isset($files[$key]['name'][$i]) && strlen($files[$key]['name'][$i])) {
                        if($files[$key]['error'][$i] > 0){
                            $error_array = $this->upload_error;
                            $this->setSession('error', "There was an error uploading the file.  Error: ".$error_array[$files[$key]['error'][$i]]);                    
                        } else {
                            $ext = pathinfo($files[$key]['name'][$i], PATHINFO_EXTENSION);
                            $file_name = ($filename) ? str_replace(' ','',$filename.'.'.$ext) : str_replace(' ','','CN'.$ui->UserID.'_'.$key.'_ID'.$fileID.'.'.$ext);

                            if (move_uploaded_file($files[$key]['tmp_name'][$i], $file_path . $file_name)) {
                                $fitems['FileID'] = $fileID;
                                $fitems['UserID'] = $userID;
                                $fitems['FileName'] = $file_name;
                                $fitems['FileDescription'] = ($filename) ? $filename : $key;
                                $fitems['FileNameC'] = ($filenamec) ? $filenamec : '';
                                $fitems['FilePath'] = $file_path . $file_name;
                                $fitems['FileSlug'] = str_replace(DS,'/',$subfolder) . $file_name;
                                $fitemID = $db->insert("file_items", $fitems);
                                $fileitemdata[$key]= $fitemID;
                                $uploadedfile++;

                            }else{
                                $this->setSession('error', "Unable upload the file to our system.  Please try again later.");
                            }
                        }
                    }
                    
                }
                
            } else {
            
                if (strlen($files[$key]['name'])) {
                    if($files[$key]['error'] > 0){
                        $error_array = $this->upload_error;
                        $this->setSession('error', "There was an error uploading the file.  Error: ".$error_array[$files[$key]['error']]);                    
                    } else {
                        
                        //$file_name = ($filename) ? str_replace(' ','',$filename.'_'.substr($files[$key]['name'],-5)) : str_replace(' ','',strtolower($ui->FirstName."_".$ui->LastName.'_'.substr($files[$key]['name'],-5)));
                        
                        $ext = pathinfo($files[$key]['name'], PATHINFO_EXTENSION);
                        $file_name = ($filename) ? str_replace(' ','',$filename.'.'.$ext) : str_replace(' ','','CN'.$ui->UserID.'_'.$key.'_ID'.$fileID.'.'.$ext);
                        
                        if (move_uploaded_file($files[$key]['tmp_name'], $file_path . $file_name)) {
                            $fitems['FileID'] = $fileID;
                            $fitems['UserID'] = $userID;
                            $fitems['FileName'] = $file_name;
                            $fitems['FileDescription'] = ($filename) ? $filename : $key;
                            $fitems['FileNameC'] = ($filenamec) ? $filenamec : '';
                            $fitems['FilePath'] = $file_path . $file_name;
                            $fitems['FileSlug'] = str_replace(DS,'/',$subfolder) . $file_name;
                            $fitemID = $db->insert("file_items", $fitems);
                            $fileitemdata[$key]= $fitemID;
                            $uploadedfile++;
                        }else{
                            $this->setSession('error', "Unable upload the file to our system.  Please try again later.");
                        }
                    }
                }
            }
            
            if($uploadedfile) {
                $filedata[$key]=$fileID;
            } else {
                $db->delete("files", array('FileID' => $fileID));
            }
        }
        
        if(count($fileitemdata)) {
            return $filedata;
        } else {
            return array();
        }
    }
    
    public function signUpload($files = false, $userID = NULL, $folder = '') 
    {
        $db = new DB();
        $filedata = array();
        $fileitemdata = array();
        $files = ($files) ? $files : false;
        $root_path = $this->view_dir."assets".DS.'files'.$folder;
        
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
        
        $file_path = $root_path.$subfolder;
        
        $ui = User::info(false,$userID);
        $userID = ($userID) ? $userID : User::info('UserID');
        
        foreach($files as $key => $file) {      
            $f['UserID'] = $userID;
            $f['DateAdded'] = date('Y-m-d H:i:s');
            $fileID = $db->insert("files", $f);
            
            $data = $file;
            list($type, $data) = explode(';', $data);
            list(, $data)      = explode(',', $data);
            $data = base64_decode($data);
            
            $file_name = str_replace(' ','',strtolower($ui->FirstName."_".$ui->LastName.'_'.$key.'_'.substr(sha1(microtime()), -8).'.png'));
            file_put_contents($file_path . $file_name, $data);
            
            $fitems['FileID'] = $fileID;
            $fitems['UserID'] = $userID;
            $fitems['FileName'] = $file_name;
            $fitems['FileDescription'] = $key;
            $fitems['FilePath'] = $file_path . $file_name;
            $fitems['FileSlug'] = str_replace(DS,'/',$subfolder) . $file_name;
            $fitemID = $db->insert("file_items", $fitems);
            $fileitemdata[$key]= $fileID;
        }
        
        return $fileitemdata;
    }
    
    public function getUploadedFiles($fileID = NULL) 
    {
        $db = new DB();
        $sql = "SELECT * FROM file_items WHERE FileID = ".$fileID;
        $query = &$db->prepare($sql);
        $query->execute();
        $data = array();
        while ($row = $query->fetch(PDO::FETCH_CLASS)){
            $data[] = $row;         
        }
        unset($query);
       
        return $data;
    }
    
    public function removeUploadedFiles($fileID = NULL) 
    {
        $db = new DB();
        $where = array('FileID'=>$fileID);
        $db->delete('files', $where);
        $db->delete('file_items', $where);
       
        return true;
    }
    
    /**
    *  Generate password.
    * 
    *  @return     path
    *  @access     Public
    */
    private function generatePassword($length = 9, $add_dashes = false, $available_sets = 'luds')
    {
        $sets = array();
        if(strpos($available_sets, 'l') !== false)
                $sets[] = 'abcdefghjkmnpqrstuvwxyz';
        if(strpos($available_sets, 'u') !== false)
                $sets[] = 'ABCDEFGHJKMNPQRSTUVWXYZ';
        if(strpos($available_sets, 'd') !== false)
                $sets[] = '23456789';
        if(strpos($available_sets, 's') !== false)
                $sets[] = '!@#$%&*?';
        $all = '';
        $password = '';
        foreach($sets as $set)
        {
            $password .= $set[array_rand(str_split($set))];
            $all .= $set;
        }
        $all = str_split($all);
        for($i = 0; $i < $length - count($sets); $i++)
            $password .= $all[array_rand($all)];
        $password = str_shuffle($password);
        if(!$add_dashes)
            return $password;
        $dash_len = floor(sqrt($length));
        $dash_str = '';
        while(strlen($password) > $dash_len)
        {
            $dash_str .= substr($password, 0, $dash_len) . '-';
            $password = substr($password, $dash_len);
        }
        $dash_str .= $password;
        return $dash_str;
    }
    
    /**
     * Instanciate the called class
     *
     * @access  public, static
     * @return  void
     */
    public static function initialize()
    {
        if(function_exists('get_called_class'))
        {
            $calledClass = get_called_class();
        }
        else
        {
            $calledClass = Common::getCalledClass();
        }

        if(!self::$instance instanceof $calledClass)
        {
            self::$instance = new $calledClass();   
        }

        return self::$instance;         
    }
    
    /**
    *  Back trace the called class.
    * 
    *  @return     Name of the called class
    *  @access     Public
    */
    public static function getCalledClass()
    {

        $arr = array(); 
        $arrTraces = debug_backtrace();
        foreach ($arrTraces as $arrTrace)
        {
           if(!array_key_exists("class", $arrTrace)) continue;

           if(count($arr)==0)
           {
                $arr[] = $arrTrace['class'];
           }
           else if(get_parent_class($arrTrace['class'])==end($arr)) 
           { 
                $arr[] = $arrTrace['class'];
           }
        }

        return end($arr);   
    }
}

/**
*  Backward compatibility for PHP <= 5.2
*/
if(!function_exists('get_called_class'))
{
    function get_called_class()
    {
        return Common::getCalledClass();
    }
}