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
 * @location      conf/routes.php
 * @package       configuration
 * @version       MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
 
class Routes
{
    var $get;
    var $post;
    var $class;
    var $method;
    
    static public function get($class,$method){
        $this->get = isset($_GET) ? $this->cleanArrayData($_GET) : NULL;
        return $class->$method($this->get);
    }
    
    static public function post($class,$method){
        $this->post = isset($_POST) ? $this->cleanArrayData($_POST) : NULL;
        return $class->$method($this->post);
    }
}