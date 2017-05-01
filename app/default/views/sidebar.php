<?php $userinfo = User::info(); ?>
<div class="col-md-3 left_col">
    <div class="left_col scroll-view">
        <div class="clearfix"></div>
        <!-- menu profile quick info -->
        <div class="profile">
            <div class="profile_pic">
                <?php $avatar = View::common()->getUploadedFiles($userinfo->Avatar); ?>
                <?php View::photo((isset($avatar[0]) ? 'files'.$avatar[0]->FileSlug : '/images/user.png'),"Avatar",'img-circle profile_img'); ?>
            </div>
            <div class="profile_info">
                <span><?php echo $userinfo->FirstName; ?> <?php echo $userinfo->LastName; ?>,</span>
                <h2><?php echo $userinfo->UserLevel; ?></h2>
            </div>
        </div>
        <!-- /menu profile quick info -->
        <div class="clearfix"></div>
        <br />

        <!-- sidebar menu --> 
        <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
            <div class="menu_section">
                <h3>Menu</h3>
                <ul class="nav side-menu">
                    <li><a href="<?php echo View::url(); ?>"><i class="fa fa-home"></i> Dashboard</a></li>

                    <li><a><i class="fa fa-edit"></i> Book Type <span class="fa fa-chevron-down"></span></a>
                        <ul class="nav child_menu">
                            <li><a href="<?php echo View::url(); ?>">Sub 1</a></li>
                            <li><a href="<?php echo View::url(); ?>">Sub 2</a></li>
                            <li><a href="<?php echo View::url(); ?>">Sub 3</a></li>
                        </ul>
                    </li>
                </ul>
            </div>

            <?php if(User::is('Administrator')) { ?>
            <div class="menu_section">
                <h3>Administrator</h3>
                
                <ul class="nav side-menu">
                    

                    <?php if(User::can('Administer All')) { ?>
                    <li><a><i class="fa fa-user"></i> User <span class="fa fa-chevron-down"></span></a>
                        <ul class="nav child_menu">
                            <li><a href="<?php echo View::url('users/'); ?>">Users</a></li>
                            <li><a href="<?php echo View::url('users/add/'); ?>">Add</a></li>
                            <li><a href="<?php echo View::url('users/trashbin/'); ?>">Trash</a></li>
                        </ul>
                    </li>
                    
                    
                    <li><a><i class="fa fa-lock"></i> Role <span class="fa fa-chevron-down"></span></a>
                        <ul class="nav child_menu">
                            <li><a href="<?php echo View::url('role/'); ?>">Roles</a></li>
                            <li><a href="<?php echo View::url('role/add/'); ?>">Add</a></li>
                        </ul>
                    </li>
                    
                    
                    <li><a><i class="fa fa-lock"></i> Capability <span class="fa fa-chevron-down"></span></a>
                        <ul class="nav child_menu">
                            <li><a href="<?php echo View::url('capability/'); ?>">Capabilities</a></li>
                            <li><a href="<?php echo View::url('capability/add/'); ?>">Add Capability</a></li>
                            <li><a href="<?php echo View::url('capabilitygroups/'); ?>">Capability Groups</a></li>
                            <li><a href="<?php echo View::url('capabilitygroups/add/'); ?>">Add Capability Group</a></li>
                        </ul>
                    </li>
                    
                    
                    <li><a><i class="fa fa-gear"></i> Settings <span class="fa fa-chevron-down"></span></a>
                        <ul class="nav child_menu">
                            <?php if(User::can('Manage Settings')) { ?>
                            <li><a href="<?php echo View::url('export/'); ?>">Export</a></li>
                            <li><a href="<?php echo View::url('options/'); ?>">Site Options</a></li>                            
                            <li><a href="<?php echo View::url('manageoptions/'); ?>"> Manage Options</a></li>
                            <li><a href="<?php echo View::url('settings/'); ?>">View Configuration</a></li>
                            <?php } ?>
                            <li><a href="<?php echo View::url('activitylogs/'); ?>">Logs</a></li>
                        </ul>
                    </li>
                    <?php } ?>
                    
                </ul>
            </div>
            <?php } ?>
        </div>
        <!-- /sidebar menu -->

        <!-- /menu footer buttons -->
        <div class="sidebar-footer hidden-small">
            <a data-toggle="tooltip" data-placement="top" title="Logout" href="<?php View::url('user/logout', true) ?>">
                <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
            </a>
        </div>
        <!-- /menu footer buttons -->
    </div>
</div>