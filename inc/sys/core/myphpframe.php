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
 * @location      /sys/core/MyPHPFrame.php
 * @package       sys
 * @version	  MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

// Start php session
session_start();

/**
 *  Define version
 */
define('APPVERSION', '1.6');

/**
 *  Define constants for directories
 */
define('APPDIR',  'app');
define('SYSDIR',  'sys');
define('CONFDIR', 'conf');
define('DS', DIRECTORY_SEPARATOR);
define('RDS', '/');
define('DOT', '.');
define('APPROOT',  INSTALLDIR . DS . APPDIR . DS);
define('SYSPATH',  ROOTDIR . DS . SYSDIR . DS);
define('CONFPATH', ROOTDIR . DS . CONFDIR . DS);
define('SQLPATH', ROOTDIR . DS . 'sql' . DS);

/**
 *  Include configuration class
 */
require_once CONFPATH.'configuration.php';

define('HASHPHRASE',Config::get('HASHPHRASE'));
define('SESSIONCODE',Config::get('SESSIONCODE'));

/**
 *  Include database class
 */
require_once SYSPATH.'database/db.php';	

/**
 *  Include common class
 */
require_once SYSPATH.'core/common.php';	

/**
 *  Include option
 */
require_once SYSPATH.'core/option.php';

/**
 *  Include loader
 */
require_once SYSPATH.'core/loader.php';	

/**
 *  Include controller
 */
require_once SYSPATH.'core/controller.php';

/**
 *  Include model
 */
require_once SYSPATH.'core/model.php';

/**
 *  Include view
 */
require_once SYSPATH.'core/view.php';	

/**
 *  Include level
 */
require_once SYSPATH.'core/level.php';

/**
 *  Include user
 */
require_once SYSPATH.'core/user.php';

/**
 *  Include app
 */
require_once SYSPATH.'core/app.php';

/**
 *  Include language
 */
require_once SYSPATH.'core/language.php';

if(!class_exists('MyPHPFrame'))
{
    class MyPHPFrame extends Common
    {
        public $is_connected;
        public $is_reporting;

        function __construct()	
        {
            // Inherit parent construct
            parent::__construct();

            // @return 	true if success or null
            $this->is_reporting = Config::errorReporting();
            $this->pageRouter();	
        }
    }
}

/**
 * Load MyPHPFrame environment
 */
MyPHPFrame::initialize();