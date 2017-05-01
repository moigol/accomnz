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
 * @location    /sys/core/view.php
 * @package     sys
 * @version     MyPHPFrame(tm) v2.0
 * @license     MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

class App
{    
    static $views;
    static $language;
    static $emails;
    static $controllers;
    static $models;
    static $vendors;
    
    public static function init() {        
        self::$views = APPPATH.'views'.DS;
        self::$language = APPPATH.'language'.DS;
        self::$emails = APPPATH.'emails'.DS;
        self::$controllers = APPPATH.'controllers'.DS;
        self::$models = APPPATH.'models'.DS;
        self::$vendors = APPPATH.'vendors'.DS;        
    }    

    public static function load($filename = NULL, $init = false)
    {
        // self::fetch(APPPATH.$filename.DOT.Config::get('FILE_EXT'), 'ro');
        // if($init) {
        //     return new $filename();
        // }
        if(class_exists('Loader'))
        {
            return new Loader();        
        }
    }
    
    public static function vendor($filename = NULL)
    {
        self::fetch(APPPATH.'vendors'.DS.$filename.DOT.Config::get('FILE_EXT'), 'ro');        
    }
    
    public static function model($filename = NULL, $init = false)
    {
        self::fetch(APPPATH.'models'.DS.$filename.DOT.Config::get('FILE_EXT'), 'ro');        
        if($init) {
            return new $filename();
        }
    }
    
    public static function getUploadedFiles($fileID = NULL) {
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
    
    public static function getUploadedFile($fileID = NULL) {
        
        if($fileID) {
            $db = new DB();
            $sql = "SELECT * FROM file_items WHERE FileID = ".$fileID." ORDER BY FileItemID ASC LIMIT 1";
            $data = $db->get_row($sql);        

            return $data;
        } else {
            return false;
        }
    }
    
    public static function outputImage($path,$attr=array()) {
        $att = array(
            'width' => isset($attr['width']) ? ' width="'.$attr['width'].'" ' : '',
            'height' => isset($attr['height']) ? ' height="'.$attr['height'].'" ' : '',
            'id' => isset($attr['id']) ? ' id="'.$attr['id'].'" ' : '',
            'class' => isset($attr['class']) ? ' class="'.$attr['class'].'" ' : '',
            'style' => isset($attr['style']) ? ' style="'.$attr['style'].'" ' : '',
        );
        
        $atts = array_filter($att);
        $atts_tags = '';
        foreach($atts as $at) {
            $atts_tags .= $at;
        }
        
        return '<img src="'.View::url('assets/files'.$path).'" '.$atts_tags.'/>';
    }
    
    public static function outputUploadedFile($fileID = NULL,$attr=array()) {
        
        $file = self::getUploadedFile($fileID);
        
        $att = array(
            'width' => isset($attr['width']) ? ' width="'.$attr['width'].'" ' : '',
            'height' => isset($attr['height']) ? ' height="'.$attr['height'].'" ' : '',
            'id' => isset($attr['id']) ? ' id="'.$attr['id'].'" ' : '',
            'class' => isset($attr['class']) ? ' class="'.$attr['class'].'" ' : '',
            'style' => isset($attr['style']) ? ' style="'.$attr['style'].'" ' : '',
        );
        
        $atts = array_filter($att);
        $atts_tags = '';
        foreach($atts as $at) {
            $atts_tags .= $at;
        }
        
        return '<img src="'.View::url('assets/files'.$file->FileSlug).'" '.$atts_tags.'/>';        
    }
        
    public static function fetch($file = NULL, $load = 'ro', $data = array())
    {            
        if(file_exists($file))
        {
            extract($data);
            
            switch(strtolower($load))
            {
                case 'require':
                case 'r':
                {
                        require($file);
                } break;
                case 'require_once':
                case 'ro':
                {
                        require_once($file);
                } break;
                case 'include':
                case 'i':
                {
                        include($file);
                }
                case 'include_once':
                case 'io':
                {
                        include_once($file);
                }
            }

            return true;
        }
        else 
        {
            return false;
        }
    }
    
    public static function common()
    {
        $common = new Common();
                
        return $common;
    }
    
    public static function getCurrentPage()
    {
        $common = new Common();
        return implode('/',$common->segment);
    }
    
    public static function getFileContents($filename='dummy.txt') 
    {        
        $root = APPPATH;
        
        if(file_exists($root.$filename)) {
            return file_get_contents($root.$filename);
        } else {
            return false;
        }
    }

    public static function setFileContents($filename='dummy.txt',$html = '') 
    {        
        $root = APPPATH;        
        return file_put_contents($root.$filename, $html);        
    }

    public static function getFilesArray($folder = "") 
    {
        $path = APPPATH.$folder;
        $files = array_diff(scandir($path), array('.', '..'));

        return $files;
    }
    
    public static function currency($int=0) 
    {
        return number_format($int,2,'.',',');
    }
    
    public static function date($date, $format='d/m/Y', $unix = false) 
    {
        $unx = ($unix) ? $date : strtotime($date);
        return date($format,$unx);
    }
    
    public static function can($access='',$condition='or',$redirect='') 
    {
        $accs = explode(',',$access);

        foreach($accs as $acc) {

        }
        
        if(User::can($access) || User::can('Adminster All')) {
            return true;
        } else {
            echo '<script>alert("You do not have access to this page!")</script>';
            View::redirect($redirect);
        }
    }

    public static function text($key="") {
        

        foreach($accs as $acc) {

        }
        
        if(User::can($access) || User::can('Adminster All')) {
            return true;
        } else {
            echo '<script>alert("You do not have access to this page!")</script>';
            View::redirect($redirect);
        }
    }
    
    public static function getTagContent($open='<header>',$close='</header>',$str=false,$wrap=false) 
    {
        $return = '';
        
        if($str) {
            $one = explode($open,$str);
            $two = explode($close,$one[1]);
            
            $return = $two[0];
            if($wrap) {
                $return = $open.$two[0].$close;
            }
        }
        
        return $return;
    }
    
    public static function removeTagContent($open='<header>',$close='</header>',$str=false) 
    {
        $return = '';
        
        if($str) {
            $one = explode($open,$str);
            $return .= $one[0];
            $two = explode($close,$one[1]);            
            $return .= $two[1];            
        }
        
        return $return;
    }
    
    public static function extractTagContent($open='<header>',$close='</header>',$str=false) 
    {
        $return = array('main'=>'','fragment'=>'');
        
        if($str) {
            $one = explode($open,$str);
            $return['main'] .= $one[0];
            $two = explode($close,$one[1]);            
            $return['main'] .= $two[1];               
            $return['fragment'] = $open.$two[0].$close;
        }
        
        return $return;
    }
    
    public static function activityLog($description='') 
    {
        $db = new DB();
        $user = User::info();
        $activity = array(
            'ActivityDescription' => $description,
            'UserID' => $user->UserID,
            'UserName' => $user->FirstName .' '.$user->LastName
        );
        $activityId = $db->insert('activity_logs',$activity); 
    }
    
    public static function exportTables($tables = '*')
    {
        $DB = new Database(strtolower(Config::get('ENVIRONMENT')));

	$link = mysql_connect($DB->host,$DB->user,$DB->pass);
	mysql_select_db($DB->database,$link);
	
        $return = "SET SQL_MODE = \"NO_AUTO_VALUE_ON_ZERO\";\nSET time_zone = \"+00:00\";\n\n/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;\n/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;\n/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;\n/*!40101 SET NAMES utf8mb4 */;\n";
	//get all of the tables
	if($tables == '*')
	{
            $tables = array();
            $result = mysql_query('SHOW TABLES');
            while($row = mysql_fetch_row($result)) {
                $tables[] = $row[0];
            }
	}
	else
	{
            $tables = is_array($tables) ? $tables : explode(',',$tables);
	}
        
	//cycle through
	foreach($tables as $table)
	{
            $result = mysql_query('SELECT * FROM '.$table);
            $num_fields = mysql_num_fields($result);

            $row2 = mysql_fetch_row(mysql_query('SHOW CREATE TABLE '.$table));
            $return.= "\n\n".$row2[1].";\n\n";

            for ($i = 0; $i < $num_fields; $i++) 
            {
                while($row = mysql_fetch_row($result))
                {
                    $return.= 'INSERT INTO '.$table.' VALUES(';
                    for($j=0; $j < $num_fields; $j++) 
                    {
                        $row[$j] = addslashes($row[$j]);
                        $row[$j] = str_replace("\n","\\n",$row[$j]);
                        if (isset($row[$j])) { $return.= '"'.$row[$j].'"' ; } else { $return.= '""'; }
                        if ($j < ($num_fields-1)) { $return.= ','; }
                    }
                    $return.= ");\n";
                }
            }
            $return.="\n\n\n";
	}
	
	//save file
        $filename = 'db-backup-'.date('Ymd').'-'.(md5(microtime())).'.sql';
	$handle = fopen(SQLPATH.DS.$filename,'w+');
	fwrite($handle,$return);
	fclose($handle);
        
        header("Content-Type: application/octet-stream");
        header("Content-Transfer-Encoding: Binary");
        header("Content-disposition: attachment; filename=\"$filename\""); 
        echo readfile(View::url('sql/'.$filename));
    }
}

App::init();