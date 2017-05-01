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


class View
{
    public static $scripts = array();
    public static $styles = array();
    public static $footerscripts = array();
    public static $footerstyles = array();
    public static $iescripts = array();
    public static $iestyles = array();
    public static $title = '';
    public static $segments = array();
    public static $bodyclass = '';

    public static function url($path=false,$echo=false)
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        $url = ($path) ? RDS.$path : '';
        
        if($echo) {
            echo Config::get(strtoupper($environment)) .$url;
        } else {
            return Config::get(strtoupper($environment)) .$url;	
        }
    }
    
    public static function image($f=false,$a=false,$c=false,$i=false,$e=true)
    {
        $file = ($f) ? self::url('assets/images/'.$f) : '';
        $alt = ($a) ? 'alt="'.$a.'"' : '';
        $cls = ($c) ? 'class="'.$c.'"' : '';
        $id = ($i) ? 'id="'.$i.'"' : '';
        
        if($e) {
            echo '<img src="'.$file.'" '.$alt.' '.$cls.' '.$id.'>';
        } else {
            return '<img src="'.$file.'" '.$alt.' '.$cls.' '.$id.'>';
        }
    }
    
    public static function photo($f=false,$a=false,$c=false,$i=false,$e=true)
    {
        $file = ($f) ? self::url('assets/'.$f) : '';
        $alt = ($a) ? 'alt="'.$a.'"' : '';
        $cls = ($c) ? 'class="'.$c.'"' : '';
        $id = ($i) ? 'id="'.$i.'"' : '';
        
        if($e) {
            echo '<img src="'.$file.'" '.$alt.' '.$cls.' '.$id.'>';
        } else {
            return '<img src="'.$file.'" '.$alt.' '.$cls.' '.$id.'>';
        }
    }
    
    public static function header($folder=false)
    {        
        $fold = ($folder) ? DS.$folder : '';
        self::fetch(APPPATH.'views'.$fold.DS.'header'.DOT.Config::get('FILE_EXT'), 'ro');
    }
    
    public static function footer($folder=false)
    {
        $fold = ($folder) ? DS.$folder : '';
        self::fetch(APPPATH.'views'.$fold.DS.'footer'.DOT.Config::get('FILE_EXT'), 'ro');
    }
    
    public static function sidebar($folder=false)
    {
        $fold = ($folder) ? DS.$folder : '';
        self::fetch(APPPATH.'views'.$fold.DS.'sidebar'.DOT.Config::get('FILE_EXT'), 'ro');
    }

    public static function template($filename = NULL, $data = array(), $inctype = 'ro')
    {
        self::fetch(APPPATH.'views'.DS.$filename.DOT.Config::get('FILE_EXT'), $inctype, $data);
    }
    
    public static function page($filename = NULL, $data = array())
    {
        self::fetch(APPPATH.'views'.DS.$filename.DOT.Config::get('FILE_EXT'), 'ro', $data);
    }
    
    public static function vendor($filename = NULL)
    {
        self::fetch(APPPATH.'vendors'.DS.$filename.DOT.Config::get('FILE_EXT'), 'ro');
    }
        
    public static function fetch($file = NULL, $load = 'ro', $data = array())
    {            
        if(file_exists($file))
        {
            extract($data);
            
            switch(strtolower($load))
            {
                case 'require':
                case 'r':
                {
                        require($file);
                } break;
                case 'require_once':
                case 'ro':
                {
                        require_once($file);
                } break;
                case 'include':
                case 'i':
                {
                        include($file);
                }
                case 'include_once':
                case 'io':
                {
                        include_once($file);
                }
            }

            return true;
        }
        else 
        {
            return false;
        }
    }
    
    public static function reset($t)
    {
        self::$$t = array();
    }
    
    public static function style($path=false)
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        $url = ($path) ? RDS.$path : '';
        
        echo '<link href="'.self::url(APPURI.'/views'.$url).'" rel="stylesheet" />';
    }
    
    public static function styles($paths=array())
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        if(count($paths)) {
            foreach($paths as $path) {
                $url = ($path) ? RDS.$path : '';        
                echo '<link href="'.self::url(APPURI.'/views'.$url).'" rel="stylesheet" />';
            }
        }
    }
    
    public static function script($path=false)
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        $url = ($path) ? RDS.$path : '';
        
        echo '<script src="'.self::url(APPURI.'/views'.$url).'" tyle="text/javascript"></script>';
    }
    
    public static function scripts($paths=array())
    {
        $environment = strtolower(Config::get('ENVIRONMENT'));
        if(count($paths)) {
            foreach($paths as $path) {
                $url = ($path) ? RDS.$path : '';        
                echo '<script src="'.self::url(APPURI.'/views'.$url).'" tyle="text/javascript"></script>';
            }
        }
    }
    
    public static function headers()
    {
        if(count(self::$styles)) {
            self::styles(self::$styles);
        } else {
            self::styles( (count(Config::$styles) ? Config::$styles : array()) );
        }
        
        if(count(self::$scripts)) {
            self::scripts(self::$scripts);
        } else {
            self::styles( (count(Config::$scripts) ? Config::$scripts : array()) );
        }
    }
    
    public static function footers()
    {
        if(count(self::$footerstyles)) {
            self::styles(self::$footerstyles);
        }
        
        if(count(self::$footerscripts)) {
            self::scripts(self::$footerscripts);
        }
    }
    
    public static function redirect($path=false)
    {
        if($path) {
            $environment = strtolower(Config::get('ENVIRONMENT'));
            $url = ($path) ? $path : '';
        
            header('location: '.self::url($url));
        } else {
            header('location: '.self::url());
        }
    }
    
    public static function common()
    {
        $common = new Common();
                
        return $common;
    }
    
    public static function getError()
    {
        $common = new Common();
        return $common->getSession('error');
    }
    
    public static function getMessage()
    {
        $common = new Common();
        $e = $common->getSession('error');
        $m = $common->getSession('message');
        $r = '';
        if($e) {
            $r .= '<div class="alert alert-danger fade in">'.$e.'</div>';
            $common->setSession('error',false);
        } 
        
        if($m) {
            $r .= '<div class="alert alert-success fade in">'.$m.'</div>';
            $common->setSession('message',false);
        }
        
        return $r;
    }
    
    public static function getCurrentPage()
    {
        $common = new Common();
        return implode('/',$common->segment);
    }

     /**
     * Form field.
     * 
     * @since   revised from Mo's framework
     * @access  public
     */	
    public static function form($type = 'text', $args, $e = true) {
        $label = isset($args['label']) ? '<label>'.$args['label'].'</label>' : '';	
        $name = isset($args['name']) ? ' name="'.$args['name'].'"' : '';	
        $value = isset($args['value']) ? ' value="'.$args['value'].'"' : '';	
        $class = isset($args['class']) ? ' class="'.$args['class'].'"' : '';	
        $id = isset($args['id']) ? ' id="'.$args['id'].'"' : ' id="'.$args['name'].'"';	
        $placeholder = isset($args['placeholder']) ? ' placeholder="'.$args['placeholder'].'"' : '';	
        $options = isset($args['options']) ? $args['options'] : array();	
        $rel = isset($args['rel']) ? ' rel="'.$args['rel'].'"' : '';
        $multi = isset($args['multiple']) ? ' multiple="true"' : '';
        $style = isset($args['style']) ? ' style="'.$args['style'].'"' : '';
        $readonly = isset($args['readonly']) ? ' readonly' : '';
        $disabled = isset($args['disabled']) ? ' disabled' : '';
        $inarray = isset($args['inarray']) ? $args['inarray'] : false;
        $custom = isset($args['custom']) ? $args['custom'] : false;

        switch($type){	
            case 'hidden':	
                    $return = $label.'<input type="hidden"'.$name.$value.$class.$id.' '.$custom.' />';	
            break;

            case 'text':	
                    $return = $label.'<input type="text"'.$name.$value.$class.$id.$rel.$placeholder.$style.$readonly.$disabled.' '.$custom.' />';	
            break;	
            case 'number':    
                    $return = $label.'<input type="number"'.$name.$value.$class.$id.$rel.$placeholder.$style.$readonly.$disabled.' '.$custom.' />'; 
            break;
            case 'textarea':	
                    $thevalue = isset($args['value']) ? $args['value'] : '';
                    $return = $label.'<textarea'.$name.$class.$id.$placeholder.$style.$readonly.$disabled.' '.$custom.' >'.stripslashes($thevalue).'</textarea>';	
            break;	
            case 'select':	
                    $return = $label.'<select'.$name.$id.$class.$rel.$multi.$style.$readonly.$disabled.' '.$custom.' >';	
                    foreach($options as $option) {	
                        $val = explode(':', $option);	
                        $thevalue = isset($args['value']) ? $args['value'] : '';
                        $sel = $thevalue == $val[0] ? 'selected="selected"' : '';					
                        if(count($val) > 1) {	
                            $return .= '<option value="'.$val[0].'" '.$sel.'>'.$val[1].'</option>';	
                        } else {	
                            $return .= '<option value="'.$val[0].'" '.$sel.'>'.$val[0].'</option>';	
                        }	
                    }	
                    $return .= '</select>';	
            break;
            case 'selecta':	
                    $return = $label.'<select'.$name.$id.$class.$rel.$multi.$style.$readonly.$disabled.' '.$custom.' >';	
                    $options = (array) $options;
                    foreach($options as $k => $v) {	
                        $thevalue = isset($args['value']) ? $args['value'] : '';
                        $sel = $thevalue == $k ? 'selected="selected"' : '';
                        if($inarray) {
                            if( (count($inarray) && in_array($k,$inarray)) || count($inarray) < 1 ) {
                                $return .= '<option value="'.$k.'" '.$sel.'>'.$v.'</option>';		
                            }
                        } else {
                            $return .= '<option value="'.$k.'" '.$sel.'>'.$v.'</option>';
                        }
                    }	
                    $return .= '</select>';	
            break;
            case 'upload':
                $return = '<input '.$id.' class="file" type="file" data-min-file-count="0" '.$name.' data-show-upload="false" data-allowed-file-extensions=\'["jpeg","png","jpg"]\'>';
            break;
        }
        $return = $type != 'hidden' ? $return.'<div class="clearfix"></div>' : $return;
        
        if($e) {
            echo $return;
        } else {
            return $return;	
        }
    }
}