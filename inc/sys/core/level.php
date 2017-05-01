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
 
class Level
{
    /**
     * Get user information
     * 
     * @access public
     * @static
     *
     * @return string or object
     */
    public static function info($key = false,$id = 5)
    {
        $return = false;
        $common = new Common();
        
        $sql = "SELECT * FROM user_levels WHERE UserLevelID = '".$id."' LIMIT 1";
        $lvl = $common->db->get_row($sql);
        $lvlinfo = (array) $lvl;
        
        if($key) {
            $return = isset($lvlinfo[$key]) ? $lvlinfo[$key] : false;
        } else {
            $return = (object) $lvlinfo;
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
    public static function capabilities($id = 5)
    {
        $return = false;
        $common = new Common();        
        $userinfo = self::info('Capability',$id);               
        $return = $common->stringToArray($userinfo); 
        
        return $return;
    }
    
    /**
     * Get specific user capability
     * 
     * @access public
     * @static
     *
     * @return array
     */
    public static function can($capability=false,$id = 5)
    {
        $return = false;
        $capa = self::capabilities($id);
        
        if($capability) {
            if(in_array($capability,$capa)) {
                $return = true;
            } else {
                $return = false;
            }
        }
        
        return $return;
    } 
}