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
 * @location    /sys/core/message.php
 * @package     sys
 * @version     MyPHPFrame(tm) v2.0
 * @license     MIT License (http://www.opensource.org/licenses/mit-license.php)
 */


class Message
{
    public static function get($path=false,$echo=false)
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        $url = ($path) ? RDS.$path : '';
        
        if($echo) {
            echo Config::get(strtoupper($environment)) .$url;
        } else {
            return Config::get(strtoupper($environment)) .$url;	
        }
    }
}