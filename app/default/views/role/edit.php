<?php 
View::$title = 'Edit Role';
View::$bodyclass = User::info('Sidebar').' client-profile';
View::header(); 
?>
<?php $userinfo = User::info();  //print_r(unserialize(base64_decode($_SESSION[SESSIONCODE])));?>
<!-- page content -->
<div class="right_col" role="main">

    <div class=""> 
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_content">
                    
                        <div class="col-md-12 col-sm-12 col-xs-12">

                            <div class="panel panel-default default-panel">
                                <div class="panel-heading"><?php echo View::$title; ?></div>
                                <div class="panel-body">
                                    <?php echo View::getMessage(); ?>   
                                    <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                        <input type="hidden" name="action" value="updaterole" />
                                        <input type="hidden" name="roleid" value="<?php echo $role->UserLevelID; ?>" />
                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                                Code <span class="required">*</span>
                                            </label>
                                            <div class="col-md-6 col-sm-9 col-xs-12">
                                                <input type="text" value="<?php echo isset($role->Code) ? $role->Code : ''; ?>" id="name" name="Code" required="required" class="form-control col-md-7 col-xs-12">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                                Role Name <span class="required">*</span>
                                            </label>
                                            <div class="col-md-6 col-sm-9 col-xs-12">
                                                <input type="text" value="<?php echo isset($role->Name) ? $role->Name : ''; ?>" id="name" name="Name" required="required" class="form-control col-md-7 col-xs-12">
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                                Dashboard Link <span class="required">*</span>
                                            </label>
                                            <div class="col-md-6 col-sm-9 col-xs-12">
                                                <input type="text" value="<?php echo isset($role->Link) ? $role->Link : ''; ?>" id="link" name="Link" class="form-control col-md-7 col-xs-12">
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-12">Description</label>
                                            <div class="col-md-6 col-sm-9 col-xs-12">
                                                <textarea class="form-control dowysiwyg" name="Description"><?php echo isset($role->Description) ? $role->Description : ''; ?></textarea>
                                            </div>
                                        </div>

                                        
                                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Capabilities</label>
                                        <div class="col-md-6 col-sm-9 col-xs-12"><div class="ln_solid"></div></div>
                                        <div class="clearfix"></div>
                                        <?php $userCapa = isset($role->Capability) ? View::common()->stringToArray($role->Capability) : array(); ?>

                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-3"></label>

                                            <div class="col-md-6 col-sm-9 col-xs-9">
                                                <div class="checkbox col-md-4 col-sm-6 col-xs-12 caplist">
                                                    <label><input type="checkbox" id="check-toggle" value=""> Check All / Uncheck All</label>
                                                </div>
                                            </div>
                                        </div>

                                        <?php 
                                        foreach($capabilities as $ckey => $cval){ 
                                            ?>
                                            <div class="form-group">
                                                <label class="control-label col-md-3 col-sm-3 col-xs-3"><?php echo $ckey; ?></label>
                                                <div class="col-md-6 col-sm-9 col-xs-9">
                                                <?php if(is_array($cval)) { 
                                                    foreach($cval as $citem){ ?>
                                                        <div class="checkbox col-md-4 col-sm-6 col-xs-12 caplist">
                                                            <label><input type="checkbox" id="capability-<?php echo $citem->UserCapabilityID; ?>" name="capabilities[<?php echo $citem->UserCapabilityID; ?>]" <?php echo isset($userCapa[$citem->UserCapabilityID]) ? 'checked' : ''; ?> class="capabilities" value="<?php echo $citem->Name; ?>"> <?php echo $citem->Name; ?></label>
                                                        </div>
                                                    <?php };
                                                }; ?>

                                                </div>
                                            </div>
                                            <?php }                                    
                                        ?>

                                        <div class="ln_solid"></div>
                                        
                                        <div class="clearfix"></div>

                                            <div class="form-group">
                                                <label class="control-label col-md-3 col-sm-3 col-xs-3">On Save</label>
                                                <div class="col-md-6 col-sm-9 col-xs-9">
                                               
                                                        <div class="checkbox col-md-4 col-sm-6 col-xs-12 caplist">
                                                            <label><input type="checkbox" name="applyRoleToUSsers"> Apply to all users in this role</label>
                                                        </div>
                                                   
                                                </div>
                                            </div>
                                            

                                        <div class="ln_solid"></div>
                                        <div class="form-group">
                                            <div class="col-md-6 col-md-offset-3">
                                                <a href="<?php echo View::url('role'); ?>" class="btn btn-warning">Back</a>       
                                                <a href="<?php echo View::url('role/apply/'.$role->UserLevelID); ?>" class="btn btn-info">Apply Current Settings to Users</a>
                                                <button id="send" type="submit" class="btn btn-success">Save Role</button>
                                                
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>

                       

                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>

<!-- /page content -->
<?php View::footer(); ?>