<?php 
View::$title = 'Edit User';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php //if(User::can('Edit Clients')) echo 'good'; else echo 'not good'; ?>
<!-- page content -->
<div class="right_col" role="main">

    <div class=""> 
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo Lang::get('USR_EDIT_TITLE'); ?> - <?php echo $user->Code; ?><?php echo $user->UserID; ?> (<?php echo $user->FirstName; ?> <?php echo $user->LastName; ?>)</h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post" novalidate>
                                <input type="hidden" name="action" value="updateuser" />
                                <input type="hidden" name="userid" value="<?php echo $user->UserID; ?>" />
                                <input type="hidden" name="metaid" value="<?php echo $user->UserMetaID; ?>" />
                                <input type="hidden" name="avatarid" value="<?php echo $user->Avatar; ?>" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 bottom-align-text" for="fname">&nbsp;</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php $avatar = View::common()->getUploadedFiles($user->Avatar); ?>
                                        <?php View::photo( (($avatar) ? 'files/'.$avatar[0]->FileSlug : 'images/user.png'),"Avatar","img-responsive avatar-view avatar-view2"); ?>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 bottom-align-text" for="fname"><?php echo Lang::get('USR_EDIT_PPCTURE'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input id="file-0a" class="file" type="file" data-min-file-count="0" name="Avatar" data-show-upload="false" data-allowed-file-extensions='["jpeg","png","jpg"]'>
                                        <span>* Allowed file types: jpeg, jpg, png</span>
                                    </div>
                                </div>   
                                <?php if(User::can('Administer All')): ?>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('CLN_EDIT_RC'); ?> / <?php echo Lang::get('CLN_EDIT_RN'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <div class="row">
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="ReferrerUserChecker" class="form-control" name="user[ReferrerUserID]" value="<?php echo $user->FirstAgentID; ?>" rel="<?php echo View::url('ajax/userinfo'); ?>"><span id="referrerloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
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
                                                <input type="text" id="ReferrerUserChecker2" class="form-control" name="user[SecondReferrerUserID]" value="<?php echo $user->SecondAgentID; ?>" rel="<?php echo View::url('ajax/userinfo'); ?>"><span id="referrerloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <input type="text" id="referrerdata2" class="form-control" value="" disabled="">
                                            </div>
                                        </div>
                                    </div>                                            
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="fname">
                                       <?php echo Lang::get('USR_EDIT_ULVL'); ?>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php 
                                            View::form(
                                                'selecta',
                                                array(
                                                    'name'=>'user[Level]',
                                                    'options'=>$levels,
                                                    'value'=>$user->Level,
                                                    'class'=>'form-control col-md-7 col-xs-12'
                                                    //'inarray'=>$inarray
                                                )
                                            );  
                                        ?>
                                    </div>
                                </div>
                                <?php endif; ?>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_PLANG'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php View::form('selecta',array('name'=>'meta[Language]','options'=>GAUtility::getLanguages(),'class'=>'form-control','value'=>$user->Language)); ?>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Default Sidebar</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php View::form('selecta',array('name'=>'meta[Sidebar]','options'=>GAUtility::getSidebars(),'class'=>'form-control','value'=>$user->Sidebar)); ?>
                                    </div>
                                </div>                                
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="fname">
                                        <?php echo Lang::get('USR_EDIT_FN'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->FirstName; ?>" id="fname" name="meta[FirstName]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="lname">
                                        <?php echo Lang::get('USR_EDIT_LN'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->LastName; ?>" id="lname" name="meta[LastName]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="nname" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_NN'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->NickName; ?>" id="nname" name="meta[NickName]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">
                                        <?php echo Lang::get('USR_EDIT_EML'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="email" id="EmailChecker2" name="user[Email]" class="form-control col-md-7 col-xs-12" value="<?php echo isset($user->Email) ? $user->Email : ''; ?>" required="required" rel="<?php echo View::url('ajax/checkemail2/'); ?><?php echo isset($user->UserID) ? $user->UserID : ''; ?>/" checkmessage="<?php echo Lang::get('EMAIL_VALIDATION'); ?>" invalidmessage="<?php echo Lang::get('EMAIL_INVALID'); ?>"><span id="emailloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                                        <?php echo Lang::get('USR_EDIT_PHNE'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="phone" value="<?php echo $user->Phone; ?>" id="phone" name="meta[Phone]" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                                        <?php echo Lang::get('USR_EDIT_GNDR'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <p>
                                            <?php echo Lang::get('USR_EDIT_GNDRM'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderM" value="M" <?php echo $user->Gender == 'M' ? 'checked' : ''; ?> required /> 
                                            <?php echo Lang::get('USR_EDIT_GNDRF'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderF" value="F" <?php echo $user->Gender == 'F' ? 'checked' : ''; ?> required />
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="address" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_ADDS'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->Address; ?>" id="address" name="meta[Address]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="city" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_CTY'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->City; ?>" id="city" name="meta[City]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="state" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_STATES'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo $user->State; ?>" id="state" name="meta[State]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_CNTRY'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <select id="Country" name="meta[Country]" class="form-control">
                                            <?php foreach(GAUtility::getCountries() as $country) { ?>
                                            <option value="<?php echo $country; ?>" <?php echo $user->Country == $country ? 'selected' : ''; ?>><?php echo $country; ?></option>
                                            <?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="postal" class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_PCODE'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($user->PostalCode) ? $user->PostalCode : ''; ?>" id="postal" name="meta[PostalCode]" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('USR_EDIT_RMRKS'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <textarea class="form-control dowysiwyg" name="meta[Bio]"><?php echo $user->Bio; ?></textarea>
                                    </div>
                                </div>
                                <?php if(User::can('Administer All')): ?>
                                <div class="form-group">
                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <h2><?php echo Lang::get('USR_EDIT_CAP'); ?></h2>
                                    </div>
                                </div>
                                <div class="ln_solid"></div>
                                <div class="clearfix"></div>
                                
                                
                                <div class="form-group">

                                    <label class="control-label col-md-3 col-sm-3 col-xs-3">Load Default Permissions</label>

                                    <div class="col-md-6 col-sm-9 col-xs-9">
                                        <div class="col-md-12 col-sm-12 col-xs-12 caplist">
                                            <select id="defaultPermissions" class="form-control" onchange="this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);">
                                                <option value="">Select</option>
                                                <?php foreach ($roles as $role) { ?>
                                                    <option value="<?php echo View::url('users/edit/'.$user->UserID.'/'. $role->UserLevelID); ?>"><?php echo isset($role->Name) ? $role->Name : ""; ?></option>
                                                <?php } ?>
                                            </select>
                                            <small class="red">*This will be loaded and check all the default settings as per selected role but will not be saved</small><br>
                                        </div>
                                        
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-3"></label>

                                    <div class="col-md-6 col-sm-9 col-xs-9">
                                        <div class="checkbox col-md-4 col-sm-12 col-xs-12 caplist">
                                            <label><input type="checkbox" id="check-toggle" value=""> Check All / Uncheck All</label>
                                        </div>
                                    </div>
                                </div>
                                <?php 
                                if($loadedcapa) {
                                    $userCapa = $loadedcapa;  
                                } else { 
                                    $userCapa = isset($user->Capability) ? View::common()->stringToArray($user->Capability) : array(); 
                                } 
                                foreach($capabilities as $ckey => $cval){ 
                                    ?>
                                    <div class="form-group">
                                        <label class="control-label col-md-3 col-sm-3 col-xs-3"><?php echo $ckey; ?></label>
                                        <div class="col-md-6 col-sm-9 col-xs-9">
                                        <?php if(is_array($cval)) { 
                                            foreach($cval as $citem){ ?>
                                                <div class="checkbox col-md-4 col-sm-6 col-xs-12 caplist">
                                                    <label><input type="checkbox" id="capability-<?php echo $citem->UserCapabilityID; ?>" name="capabilities[<?php echo $citem->UserCapabilityID; ?>]" class="capabilities" value="<?php echo $citem->Name; ?>" <?php echo isset($userCapa[$citem->UserCapabilityID]) ? 'checked' : ''; ?> <?php echo $citem->Name == 'Administer All' ? 'readonly="readonly"' : ''; ?>> <?php echo $citem->Name; ?></label>
                                                </div>
                                            <?php };
                                        }; ?>

                                        </div>
                                    </div>
                                    <?php }                                    
                                ?>
                                <?php endif; ?>
                                <div class="form-group">
                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <h2><?php echo Lang::get('USR_EDIT_STATUS'); ?></h2>
                                    </div>
                                </div>
                                <div class="ln_solid"></div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">
                                        <?php echo Lang::get('USR_EDIT_STATUS'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <p>&nbsp;<br><?php $active = $user->Active; ?>
                                            <?php echo Lang::get('USR_EDIT_STATUSA'); ?>: <input type="radio" class="flat" name="user[Active]" id="Active1" value="1" <?php echo $active == 1 ? 'checked' : ''; ?> required /> 
                                            <?php echo Lang::get('USR_EDIT_STATUSI'); ?>: <input type="radio" class="flat" name="user[Active]" id="Active0" value="0" <?php echo $active == 0 ? 'checked' : ''; ?> required />
                                        </p>
                                    </div>
                                </div>
                                <div class="item form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="password">
                                       <?php echo Lang::get('USR_EDIT_PW'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo View::common()->decrypt($user->Password); ?>" id="password" name="Password" required="required" class="form-control col-md-7 col-xs-12" data-validate-length-range="6,30">
                                    </div>
                                </div>

                                </div>
                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning"><?php echo Lang::get('USR_EDIT_BCKBTN'); ?></a>                          
                                        <input id="send" type="submit" class="btn btn-success" value="<?php echo Lang::get('USR_EDIT_SVBTN'); ?>">
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
