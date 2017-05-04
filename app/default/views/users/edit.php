<?php 
View::$title = 'Edit User';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php //if(User::can('Edit Clients')) echo 'good'; else echo 'not good'; ?>
<!-- page content -->
<div class="content-box-large">
    <div class="panel-heading">
        <div class="panel-title"><?php echo View::$title; ?></div>
    </div>
    <div class="panel-body">
        <?php echo View::getMessage(); ?>                               
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateuser" />
            <input type="hidden" name="userid" value="<?php echo $user->UserID; ?>" />
            <input type="hidden" name="metaid" value="<?php echo $user->UserMetaID; ?>" />
            <input type="hidden" name="avatarid" value="<?php echo $user->Avatar; ?>" />
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12 bottom-align-text" for="fname">&nbsp;</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <?php $avatar = View::common()->getUploadedFiles($user->Avatar);?>
                    <?php View::photo( (($avatar) ? 'files/'.$avatar[0]->FileSlug : 'images/user.png'),"Avatar","img-responsive avatar-view avatar-view2"); ?>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12 bottom-align-text" for="fname"><?php echo Lang::get('USR_ADD_PPCTURE'); ?></label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input id="file-0a" class="file" type="file" data-min-file-count="0" name="Avatar" data-show-upload="false" data-allowed-file-extensions='["jpeg","png","jpg"]'>
                    <span>* Allowed file types: jpeg, jpg, png</span>
                </div>
            </div>
            
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="fname">
                    First Name <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->FirstName; ?>" id="fname" name="meta[FirstName]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lname">
                    Last Name <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->LastName; ?>" id="lname" name="meta[LastName]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="nname" class="control-label col-md-3 col-sm-3 col-xs-12">Nickname</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->NickName; ?>" id="nname" name="meta[NickName]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">
                    Email <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="email" id="EmailChecker" name="user[Email]" class="form-control col-md-7 col-xs-12" value="<?php echo $user->Email; ?>" required="required">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                    Phone <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="phone" value="<?php echo $user->Phone; ?>" id="phone" name="meta[Phone]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                    Gender <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <p> <?php $gender = isset($user->Gender) ? $user->Gender : 'M'; ?>
                        Male: <input type="radio" class="flat" name="meta[Gender]" id="genderM" value="M" <?php echo $gender == 'M' ? 'checked' : ''; ?> required /> 
                        Female: <input type="radio" class="flat" name="meta[Gender]" id="genderF" value="F" <?php echo $gender == 'F' ? 'checked' : ''; ?> required />
                    </p>
                </div>
            </div>
            <div class="form-group">
                <label for="address" class="control-label col-md-3 col-sm-3 col-xs-12">Address</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->Address; ?>" id="address" name="meta[Address]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="city" class="control-label col-md-3 col-sm-3 col-xs-12">City</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->City; ?>" id="city" name="meta[City]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="state" class="control-label col-md-3 col-sm-3 col-xs-12">State</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->State; ?>" id="state" name="meta[State]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12">Country</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->Country; ?>" name="meta[Country]" id="country" class="form-control col-md-10" />
                  
                </div>
            </div>
            <div class="form-group">
                <label for="postal" class="control-label col-md-3 col-sm-3 col-xs-12">Zip</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="<?php echo $user->PostalCode; ?>" id="postal" name="meta[PostalCode]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12">Bio</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <textarea class="form-control dowysiwyg" name="meta[Bio]"><?php echo $user->Bio; ?></textarea>
                </div>
            </div>
            <?php if($user->UserID == User::info('UserID') || 100000 == User::info('UserID')) { ?>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="password">
                   Password <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="password" value="<?php echo View::common()->decrypt($user->Password); ?>" id="password" name="user[Password]" required="required" class="form-control col-md-7 col-xs-12" data-validate-length-range="6,30">
                </div>
            </div>
            <?php } ?>
            <div class="ln_solid"></div>
            <div class="form-group">
                <div class="col-md-6 col-md-offset-3">
                    <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning">Cancel</a>
                    <button id="send" type="submit" class="btn btn-success">Save</button>
                </div>
            </div>
        </form>
    </div>
    
</div>
<!-- /page content -->
<?php View::footer(); ?>
