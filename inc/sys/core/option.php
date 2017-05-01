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
 * @location    /sys/core/option.php
 * @package     sys
 * @version     MyPHPFrame(tm) v2.0
 * @license     MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

class Option
{
    public static function get($key, $default='')
    {
        $db = new DB();
       
        $sql = "SELECT OptionValue FROM options WHERE OptionKey = '".$key."' LIMIT 1";
        $opt = $db->get_row($sql);
       
        return strlen($opt->OptionValue) ? $opt->OptionValue : $default;
    }
    
    public static function set($key, $val='')
    {
        $db = new DB();
        $optns = array('OptionValue' => $val);
        $where = array('OptionKey' => $key);
       
        return $db->update("options", $optns, $where);
    }
    
    public static function getAll($hierarchical = true)
    {
        // $out = hierarchical | match
        $db = new DB();
        
        $sql = "SELECT o.*,og.GroupName FROM options o LEFT JOIN option_groups og ON o.OptionGroupID = og.OptionGroupID";
        $query = &$db->prepare($sql);
        $query->execute();
        if($hierarchical) {
            while ($row = $query->fetch(PDO::FETCH_CLASS)){
                $data[$row->GroupName][$row->OptionKey] = $row;			
            }
        } else {
            while ($row = $query->fetch(PDO::FETCH_CLASS)){
                $data[$row->OptionKey] = $row->OptionValue;			
            }
        }
        unset($query);
        
        return $data;
    }
    
    public static function multiUpdate($optdata =array())
    {
        $db = new DB();
        
        if(count($optdata)) {
            foreach($optdata as $k => $v) {
                $db->update("options", array('OptionValue' => $v), array('OptionKey' => $k));
            }
        }
    }
}