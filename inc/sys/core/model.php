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
 * @location    /sys/core/model.php
 * @package     sys
 * @version	MyPHPFrame(tm) v2.0
 * @license     MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

class Model extends Common
{
    /**
     * Constructor
     *
     * @access public
     */
    function __construct()
    {
        parent::__construct();
    }

    function __get($key)
    {
        return $this->$key;
    }
        
    function __set($key, $val)
    {
        return $this->$key = $val;
    }
}