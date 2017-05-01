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
 * @location      conf/database.php
 * @package       configuration
 * @version		  MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
 
class Database 
{
    const development 	= 'development';
    const staging       = 'staging';
    const production 	= 'production';
    
    var $environment;
    var $host;
    var $user;
    var $pass;
    var $database;
    var $prefix;
    var $encoding;
    
    function __construct($env='development') {
        $this->environment = $env;
        
        $db = $this->info();
        
        $this->host = $db['host'];
        $this->user = $db['user'];
        $this->pass = $db['pass'];
        $this->database = $db['database'];
        $this->prefix = $db['prefix'];
        $this->encoding = $db['encoding'];
    }
            
    function info() {        
        $dbarr = array(
            'production' => array(
                                    'host' 	=> Config::get('DB_HOST','localhost'),
                                    'user' 	=> Config::get('DB_USER','test'),
                                    'pass' 	=> Config::get('DB_PASS','test'),
                                    'database' 	=> Config::get('DB_NAME','myframe'),
                                    'prefix' 	=> '',
                                    'encoding' 	=> 'utf8'
                               ),
            'staging' => array(
                                    'host' 	=> Config::get('STAGE_HOST','localhost'),
                                    'user' 	=> Config::get('STAGE_USER','test'),
                                    'pass' 	=> Config::get('STAGE_PASS','test'),
                                    'database' 	=> Config::get('STAGE_NAME','myframe'),
                                    'prefix' 	=> '',
                                    'encoding' 	=> 'utf8'
                               ),
            'development' => array(
                                    'host' 	=> Config::get('DEV_HOST','localhost'),
                                    'user' 	=> Config::get('DEV_USER','test'),
                                    'pass' 	=> Config::get('DEV_PASS','test'),
                                    'database' 	=> Config::get('DEV_NAME','myframe'),
                                    'prefix' 	=> '',
                                    'encoding' 	=> 'utf8'
                               )
        );
        
        return $dbarr[$this->environment];
    }
}