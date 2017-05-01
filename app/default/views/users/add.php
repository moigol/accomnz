<?php 
View::$title = 'Add User';
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
                        <h2><?php echo Lang::get('USR_ADD_TITLE'); ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                <input type="hidden" name="action" value="adduser" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 bottom-align-text" for="fname"><?php echo Lang::get('USR_ADD_PPCTURE'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input id="file-0a" class="file" type="file" data-min-file-count="0" name="Avatar" data-show-upload="false" data-allowed-file-extensions='["jpeg","png","jpg"]'>
                                        <span>* Allowed file types: jpeg, jpg, png</span>
                                    </div>
                                </div>
                                
                               <?php if(User::can('Administer All')): ?>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="fname">
                                       <?php echo Lang::get('USR_ADD_ULVL'); ?>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php 
                                            View::form(
                                                'selecta',
                                                array(
                                                    'name'=>'user[Level]',
                                                    'options'=>$levels,
                                                    'value'=>isset($pdata->Level) ? $pdata->Level : '',
                                                    'class'=>'form-control col-md-7 col-xs-12'
                                                    //'inarray'=>$inarray
                                                )
                                            );  
                                        ?>
                                    </div>
                                </div>
                                <?php endif; ?>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('CLN_EDIT_RC'); ?> / <?php echo Lang::get('CLN_EDIT_RN'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <div class="row">
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="ReferrerUserChecker" class="form-control" name="user[ReferrerUserID]" value="<?php echo User::info('UserID'); ?>" rel="<?php echo View::url('ajax/userinfo'); ?>"><span id="referrerloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="referrerdata" class="form-control" value="" disabled="">
                                            </div>
                                        </div>
                                    </div>                                            
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Secondary Agent ID / Agent Name</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <div class="row">
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="ReferrerUserChecker2" class="form-control" name="user[SecondReferrerUserID]" value="" rel="<?php echo View::url('ajax/userinfo'); ?>"><span id="referrerloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="referrerdata2" class="form-control" value="" disabled="">
                                            </div>
                                        </div>
                                    </div>                                            
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_PLANG'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php View::form('selecta',array('name'=>'meta[Language]','options'=>GAUtility::getLanguages(),'class'=>'form-control','value'=>'')); ?>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Default Sidebar</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php View::form('selecta',array('name'=>'meta[Sidebar]','options'=>GAUtility::getSidebars(),'class'=>'form-control','value'=>'nav-sm')); ?>
                                    </div>
                                </div> 
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="fname">
                                        <?php echo Lang::get('USR_ADD_FN'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->FirstName) ? $pdata->FirstName : ''; ?>" id="fname" name="meta[FirstName]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lname">
                                        <?php echo Lang::get('USR_ADD_LN'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->LastName) ? $pdata->LastName : ''; ?>" id="lname" name="meta[LastName]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="nname" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_NN'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->NickName) ? $pdata->NickName : ''; ?>" id="nname" name="meta[NickName]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">
                                        <?php echo Lang::get('USR_ADD_EML'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="email" id="EmailChecker" name="user[Email]" class="form-control col-md-7 col-xs-12" value="" required="required" rel="<?php echo View::url('ajax/checkemail'); ?>" checkmessage="<?php echo Lang::get('EMAIL_VALIDATION'); ?>" invalidmessage="<?php echo Lang::get('EMAIL_INVALID'); ?>"><span id="emailloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                                        <?php echo Lang::get('USR_ADD_PHNE'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="phone" value="<?php echo isset($pdata->Phone) ? $pdata->Phone : ''; ?>" id="phone" name="meta[Phone]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                                        <?php echo Lang::get('USR_ADD_GNDR'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <p> <?php $gender = isset($pdata->Gender) ? $pdata->Gender : 'M'; ?>
                                            <?php echo Lang::get('USR_ADD_GNDRM'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderM" value="M" <?php echo $gender == 'M' ? 'checked' : ''; ?> required /> 
                                            <?php echo Lang::get('USR_ADD_GNDRF'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderF" value="F" <?php echo $gender == 'F' ? 'checked' : ''; ?> required />
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="address" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_ADDS'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->Address) ? $pdata->Address : ''; ?>" id="address" name="meta[Address]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="city" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_CTY'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->City) ? $pdata->City : ''; ?>" id="city" name="meta[City]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="state" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_STATES'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->State) ? $pdata->State : ''; ?>" id="state" name="meta[State]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_CNTRY'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->Country) ? $pdata->Country : ''; ?>" name="meta[Country]" id="autocomplete-custom-append" class="form-control col-md-10" style="float: left;" />
                                      <div id="autocomplete-container" style="position: relative; float: left; width: 400px; margin: 10px;"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="postal" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_PCODE'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($pdata->PostalCode) ? $pdata->PostalCode : ''; ?>" id="postal" name="meta[PostalCode]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_ADD_RMRKS'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <textarea class="form-control dowysiwyg" name="meta[Bio]"><?php echo isset($pdata->Bio) ? $pdata->Bio : ''; ?></textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">&nbsp;</label>
                                    <div class="col-md-9 col-sm-9 col-xs-12">
                                        <p>&nbsp;<br>&nbsp;</p>
                                        <p>* <?php echo Lang::get('USR_ADD_PWINF'); ?></p>
                                    </div>
                                </div>
                                <div class="ln_solid"></div>
                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning"><?php echo Lang::get('USR_ADD_CANBTN'); ?></a>
                                        <button id="send" type="submit" class="btn btn-success"><?php echo Lang::get('USR_ADD_ADDBTN'); ?></button>
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