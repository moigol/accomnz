<?php $userinfo = User::info(); ?>
<div class="sidebar content-box" style="display: block;">
    <ul class="nav">
        <!-- Main menu -->
        <li><a href="<?php echo View::url(); ?>"><i class="glyphicon glyphicon-home"></i> Dashboard</a></li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-registration-mark"></i> Regions
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('region'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('region/add'); ?>">Add Region</a></li>
            </ul>
        </li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon glyphicon-copyright-mark"></i> Suburb / City
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('suburb'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('suburb/add'); ?>">Add Suburb</a></li>
            </ul>
        </li>
        <li><a href="<?php echo View::url(); ?>"><i class="glyphicon glyphicon-list"></i> Book It Type</a></li>
        <li><a href="<?php echo View::url(); ?>"><i class="glyphicon glyphicon-record"></i> Book Type</a></li>
        <!-- <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-list"></i> Pages
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="login.html">Login</a></li>
                <li><a href="signup.html">Signup</a></li>
            </ul>
        </li> -->

    </ul>
 </div>