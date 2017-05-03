<?php $userinfo = User::info(); ?>
<div class="sidebar content-box" style="display: block;">
    <ul class="nav sidebar-menu">
        <!-- Main menu -->
        <li><a href="<?php echo View::url(); ?>"><i class="glyphicon glyphicon-home"></i> Dashboard</a></li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-registration-mark"></i> Regions
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('regions'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('regions/add'); ?>">Add Region</a></li>
            </ul>
        </li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-copyright-mark"></i> Suburb / City
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('suburb'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('suburb/add'); ?>">Add Suburb</a></li>
            </ul>
        </li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-list"></i> Book It Type
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('bookittype'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('bookittype/add'); ?>">Add Bookittype</a></li>
            </ul>
        </li>
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-list"></i> Type
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('type'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('type/add'); ?>">Add Type</a></li>
            </ul>
        </li>
        
        <li class="submenu">
             <a href="#">
                <i class="glyphicon glyphicon-user"></i> Users
                <span class="caret pull-right"></span>
             </a>
             <ul>
                <li><a href="<?php echo View::url('users'); ?>">Manage List</a></li>
                <li><a href="<?php echo View::url('users/add'); ?>">Add User</a></li>
            </ul>
        </li>

    </ul>
 </div>