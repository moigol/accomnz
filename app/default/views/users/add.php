<?php 
View::$title = 'Add User';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info();  //print_r(unserialize(base64_decode($_SESSION[SESSIONCODE])));?>
<!-- page content -->
<div class="content-box-large">
    <div class="panel-heading">
        <div class="panel-title"><?php echo View::$title; ?></div>
    </div>
    <div class="panel-body">
        <?php echo View::getMessage();  ?>  
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="adduser" />
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
                    <input type="text" value="" id="fname" name="meta[FirstName]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lname">
                    Last Name <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="lname" name="meta[LastName]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="nname" class="control-label col-md-3 col-sm-3 col-xs-12">Nickname</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="nname" name="meta[NickName]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">
                    Email <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="email" id="EmailChecker" name="user[Email]" class="form-control col-md-7 col-xs-12" value="" required="required">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                    Phone <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="phone" value="" id="phone" name="meta[Phone]" required="required" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                    Gender <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <p> <?php $gender = isset($pdata->Gender) ? $pdata->Gender : 'M'; ?>
                        Male: <input type="radio" class="flat" name="meta[Gender]" id="genderM" value="M" <?php echo $gender == 'M' ? 'checked' : ''; ?> required /> 
                        Female: <input type="radio" class="flat" name="meta[Gender]" id="genderF" value="F" <?php echo $gender == 'F' ? 'checked' : ''; ?> required />
                    </p>
                </div>
            </div>
            <div class="form-group">
                <label for="address" class="control-label col-md-3 col-sm-3 col-xs-12">Address</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="address" name="meta[Address]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="city" class="control-label col-md-3 col-sm-3 col-xs-12">City</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="city" name="meta[City]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label for="state" class="control-label col-md-3 col-sm-3 col-xs-12">State</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="state" name="meta[State]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12">Country</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" name="meta[Country]" id="country" class="form-control col-md-10" />
                  
                </div>
            </div>
            <div class="form-group">
                <label for="postal" class="control-label col-md-3 col-sm-3 col-xs-12">Zip</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="postal" name="meta[PostalCode]" class="form-control col-md-7 col-xs-12">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12">Bio</label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <textarea class="form-control dowysiwyg" name="meta[Bio]"></textarea>
                </div>
            </div>
            <div class="item form-group">
                <label class="control-label col-md-3 col-sm-3 col-xs-12" for="password">
                   Password <span class="required">*</span>
                </label>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <input type="text" value="" id="password" name="user[Password]" required="required" class="form-control col-md-7 col-xs-12" data-validate-length-range="6,30">
                </div>
            </div>
            <div class="ln_solid"></div>
            <div class="form-group">
                <div class="col-md-6 col-md-offset-3">
                    <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning">Cancel</a>
                    <button id="send" type="submit" class="btn btn-success">Submit</button>
                </div>
            </div>
        </form>
                               
        
    </div>
    
</div>
<!-- /page content -->
<?php View::footer(); ?>