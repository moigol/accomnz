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
 * @location      conf/user.php
 * @package       core
 * @version       MyPHPFrame(tm) v2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
 
class User
{
    /**
     * Get user information
     * 
     * @access public
     * @static
     *
     * @return string or object
     */
    public static function info($key = false, $id = false)
    {
        $return = false;
        $common = new Common();
        
        if($id) {
            $sql = "SELECT u.*, um.*, ul.Name as UserLevel, ul.Code FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON ul.UserLevelID = u.Level WHERE u.UserID = '".$id."' LIMIT 1";
            $userdata = $common->db->get_row($sql);
            $userinfo = (count($userdata)) ? (array) $userdata : array();
        } else {
            $userinfo = $common->getSession('userdata');
        }
        
        if($key != false) {
            $return = isset($userinfo[$key]) ? $userinfo[$key] : false;
        } else {
            $return = (count($userinfo)) ? (object) $userinfo : array();
        }
        
        return $return;
    }
    
    /**
     * Get user information by email
     * 
     * @access public
     * @static
     *
     * @return string or object
     */
    public static function infoByEmail($key = false, $email = false)
    {
        $return = false;
        $common = new Common();
        
        if($email) {
            $sql = "SELECT *, ul.Name as UserLevel, ul.Code FROM users u LEFT JOIN user_meta um ON um.UserID = u.UserID LEFT JOIN user_levels ul ON ul.UserLevelID = u.Level WHERE u.Email = '".$email."' LIMIT 1";
            
            $userdata = $common->db->get_row($sql);
            $userinfo = (array) $userdata;
        } else {
            $userinfo = $common->getSession('userdata');
        }
        
        if($key) {
            $return = isset($userinfo[$key]) ? $userinfo[$key] : false;
        } else {
            $return = (object) $userinfo;
        }
        
        return $return;
    }
    
    /**
     * Get user capability
     * 
     * @access public
     * @static
     *
     * @return array
     */
    public static function capabilities($id=false)
    {
        $return = false;
        $common = new Common();        
        $userinfo = self::info('Capability',$id);               
        $return = $common->stringToArray($userinfo); 
        
        return $return;
    }
    
    /**
     * Check if user has capability
     * 
     * @access public
     * @static
     *
     * @return array
     */
    public static function can($capability=false,$id =false)
    {
        $return = false;
        $capa = (array) self::capabilities($id);
        
        if($capability) {
            if(in_array($capability,$capa)) {
                $return = true;
            } else {
                $return = false;
            }
        }
        
        return $return;
    } 
    
    /**
     * Check user role
     * 
     * @access public
     * @static
     *
     * @return boolean
     */
    public static function is($is=false,$id =false)
    {
        $return = false;
        $level = self::info('UserLevel',$id);

        if($level == $is) {
            $return = true;
        }
        
        return $return;
    } 

    /**
     * Get user dashboard link
     * 
     * @access public
     * @static
     *
     * @return string
     */
    public static function dashboardLink()
    {
        $return = false;
        $level = self::info('Level');
        
        $return = View::url(Level::info('Link',$level));
        
        return $return;
    }
    
    /**
     * Redirect user to his dashboard
     * 
     * @access public
     * @static
     *
     * @return void
     */
    public static function dashboardRedirect()
    {
        $return = false;
        $level = self::info('Level');
        
        View::redirect(Level::info('Link',$level));
    }
}