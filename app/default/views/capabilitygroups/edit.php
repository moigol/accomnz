<?php 
View::$title = 'Edit Group';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info();  //print_r(unserialize(base64_decode($_SESSION[SESSIONCODE])));?>
<!-- page content -->
<div class="right_col" role="main">

    <div class=""> 

        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo View::$title; ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                <input type="hidden" name="action" value="updategroup" />
                                <input type="hidden" name="groupid" value="<?php echo $group->UserCapabilityGroupID; ?>" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="Name">
                                        Capability Group Name <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                       <input type="text" value="<?php echo isset($group->Name) ? $group->Name : ''; ?>" name="Name" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                
                                <div class="ln_solid"></div>
                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('capabilitygroups'); ?>" class="btn btn-warning">Back</a>
                                        <button id="send" type="submit" class="btn btn-success">Update Group</button>
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
<!-- /page content -->
<?php View::footer(); ?>