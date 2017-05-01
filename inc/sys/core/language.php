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

class Lang
{    
    static $package;
    
    static $rootfile;
    const ext = ".txt";
    
    public static function init() {
        self::$rootfile = "./app/".Config::get('TEMPLATE')."/language/";
        $langfile = App::common()->getSession('language');
        
        if(file_exists(self::$rootfile.$langfile.self::ext)) {
            self::$package = Config::read(self::$rootfile.$langfile.self::ext);
        } else {
            $langfile = isset(App::common()->segment[2]) ? App::common()->segment[2] : 'en';
            if(file_exists(self::$rootfile.$langfile.self::ext)) {
                self::$package = Config::read(self::$rootfile.$langfile.self::ext);
            }
        }
    }
    
    public static function get($key='All', $default='', $filename=NULL) {
        
        $return = false;        
        $lang   = self::$package;
        $rootfile = "./app/".Config::get('TEMPLATE')."/language/";

        if($filename) {            
            $lang = Config::read(self::$rootfile.$filename.self::ext);
        } 
        
        if($key == 'All') {
            $return = $lang;
        } else {            
            $val = trim($lang[$key]);
            $return = (strlen($val)) ? trim($val) : trim($default);
        }
        
        return $return;
    }
}

Lang::init();