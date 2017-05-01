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
 * @location      conf/config.php
 * @package       conf
 * @version	  MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

/**
 *  Include the necessary configuration files
 */
require_once CONFPATH.'database.php';
require_once SYSPATH.'core/routes.php';
require_once CONFPATH.'routes.php';

class Config
{
    const configfile = "./mpf";
    
    // Set a global styles and scripts
    static $scripts = array();
    static $styles = array('assets/bootstrap/css/bootstrap.min.css','assets/css/style.css');    
    static $footerscripts = array("assets/bootstrap/js/bootstrap.min.js",'assets/js/custom.js');
    static $footerstyles = array();
    
    /**
     * Read configuration file
     *
     * @access	public, static
     * @return	array
     */
    public static function read($filename)
    {
        $config = array();
        
        $myfile = fopen($filename, "r") or die("Unable to open file!");
        // Output one line until end-of-file
        while($line = fgets($myfile)) {
            if(strlen($line)) {
                $set = explode('=',$line,2);
                if(isset($set[0])) {
                    $config[$set[0]] = isset($set[1]) ? $set[1] : '';
                }
            }
        }
        
        fclose($myfile);
        
        return array_filter($config);
    }
    
    /**
     * Write configuration file
     *
     * @access	public, static
     * @return	void
     */
    public static function write($filename, array $config)
    {
        $config = http_build_query($config,'',"\r\n");
        file_put_contents($filename, "$config\r\n");
    }
    
    /**
     * Get configuration value
     *
     * @access	public, static
     * @return	string
     */
    public static function get($key='All', $default='')
    {
        $conf = self::read(self::configfile);
        
        if($key == 'All') {
            $return = $conf;
        } else {            
            $val = trim($conf[$key]);
            $return = (strlen($val)) ? trim($val) : trim($default);
        }
        return $return;
    }
    
    /**
     * Set configuration value
     *
     * @access	public, static
     * @return	void
     */
    public static function set($key='All', $val='')
    {
        if($key == 'All') {
            if(is_array($val)) {
                self::write(self::configfile,$val);
            }
        } else { 
            $conf = self::read(self::configfile);
            if($val) {
                $conf[$key] = $val;
            }

            self::write(self::configfile,$conf);
        }
    }

    /**
     * Error reporting
     *
     * @access	public, static
     * @return	void
     */
    public static function errorReporting()
    {	
        ini_set("log_errors", 1);
        ini_set("error_log", self::get('TEMPLATE')."-error.log");
                
        switch(strtolower(self::get('ENVIRONMENT')))
        {
            case "development":
            {
                error_reporting(E_ALL);
            } break;
            case "staging":
            {
                error_reporting(1);
            } break;
            case "production":
            {
                error_reporting(0);
            } break;
            default:
            {
                die('Please set your application environtment...');
            } break;
        }
    }
}

define('APPPATH',  APPROOT. Config::get('TEMPLATE'). DS);
define('APPURI',  APPDIR.RDS.Config::get('TEMPLATE'));