<?php
class Auth extends Model
{
    function isLoggedIn()
    {
        return ($this->getSession('loggedin') == true) ? true : false;
    }    
    
    function setLoginData($data)
    {
    }
}