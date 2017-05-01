<?php 
View::$title = 'User Profile';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info(); ?>
<!-- page content -->
<style type="text/css">
    .ln_solid.diviver {
        margin: 5px 0;
    }
    .block_content p {
        color: #737373;
    }
</style>
<div class="right_col" role="main">

    <div class=""> 
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo Lang::get('USR_PRF_TITLE'); ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">

                        <div class="col-md-2 col-sm-3 col-xs-12 profile_left">
                            <div class="profile_img">

                                <!-- end of image cropping -->
                                <div id="crop-avatar">
                                    <!-- Current avatar -->
                                    <?php $avatar = View::common()->getUploadedFiles($userinfo->Avatar); ?>
                                    <?php View::photo((isset($avatar[0]) ? 'files'.$avatar[0]->FileSlug : '/images/user.png'),"Avatar","img-responsive avatar-view"); ?>
                                    <!-- Cropping modal -->
                                    <div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <form class="avatar-form" action="crop.php" enctype="multipart/form-data" method="post" novalidate>
                                                    <div class="modal-header">
                                                        <button class="close" data-dismiss="modal" type="button">&times;</button>
                                                        <h4 class="modal-title" id="avatar-modal-label">Change Avatar</h4>
                                                    </div>
                                                  <div class="modal-body">
                                                    <div class="avatar-body">

                                                      <!-- Upload image and data -->
                                                      <div class="avatar-upload">
                                                        <input class="avatar-src" name="avatar_src" type="hidden">
                                                        <input class="avatar-data" name="avatar_data" type="hidden">
                                                        <label for="avatarInput">Local upload</label>
                                                        <input class="avatar-input" id="avatarInput" name="avatar_file" type="file">
                                                      </div>

                                                      <!-- Crop and preview -->
                                                      <div class="row">
                                                        <div class="col-md-9">
                                                          <div class="avatar-wrapper"></div>
                                                        </div>
                                                        <div class="col-md-3">
                                                          <div class="avatar-preview preview-lg"></div>
                                                          <div class="avatar-preview preview-md"></div>
                                                          <div class="avatar-preview preview-sm"></div>
                                                        </div>
                                                      </div>

                                                      <div class="row avatar-btns">
                                                        <div class="col-md-9">
                                                          <div class="btn-group">
                                                            <button class="btn btn-primary" data-method="rotate" data-option="-90" type="button" title="Rotate -90 degrees">Rotate Left</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="-15" type="button">-15deg</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="-30" type="button">-30deg</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="-45" type="button">-45deg</button>
                                                          </div>
                                                          <div class="btn-group">
                                                            <button class="btn btn-primary" data-method="rotate" data-option="90" type="button" title="Rotate 90 degrees">Rotate Right</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="15" type="button">15deg</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="30" type="button">30deg</button>
                                                            <button class="btn btn-primary" data-method="rotate" data-option="45" type="button">45deg</button>
                                                          </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                          <button class="btn btn-primary btn-block avatar-save" type="submit">Done</button>
                                                        </div>
                                                      </div>
                                                    </div>
                                                  </div>
                                                  <!-- <div class="modal-footer">
                                                    <button class="btn btn-default" data-dismiss="modal" type="button">Close</button>
                                                  </div> -->
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /.modal -->
                                    <!-- Loading state -->
                                    <div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
                                </div>
                                <!-- end of image cropping -->

                            </div>
                            <h3><?php echo $userinfo->FirstName; ?> <?php echo $userinfo->LastName; ?></h3>

                            <ul class="list-unstyled user_data">
                                <li><i class="fa fa-map-marker user-profile-icon"></i>&nbsp;&nbsp;
                                    <?php echo $userinfo->Address; ?> <?php echo $userinfo->City; ?> 
                                    <?php echo $userinfo->State; ?>, <?php echo $userinfo->Country; ?>
                                </li>
                                <li> <i class="fa fa-envelope user-profile-icon"></i> <?php echo $userinfo->Email; ?></li>
                                <li class="m-top-xs"> <i class="fa fa-phone user-profile-icon"></i> <?php echo $userinfo->Phone; ?></li>
                            </ul>
                            <br />
                        </div>
                        <div class="col-md-10 col-sm-9 col-xs-12">
                            <div class="" role="tabpanel" data-example-id="togglable-tabs">
                                <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                                    <li role="presentation" class="active">
                                        <a href="#editprofile" role="tab" id="profile-editprofile" data-toggle="tab" aria-expanded="true"><?php echo Lang::get('USR_PRF_TAB1'); ?></a>
                                    </li>
                                    <li role="presentation" class="">
                                        <a href="#editpassword" role="tab" id="profile-editpassword" data-toggle="tab" aria-expanded="false"><?php echo Lang::get('USR_PRF_TAB2'); ?></a>
                                    </li>
                                    <?php if(User::can('View API')) : ?>
                                    <li role="presentation" class="">
                                        <a href="#apiview" role="tab" id="profile-apiview" data-toggle="tab" aria-expanded="false"><?php echo Lang::get('USR_PRF_TAB3'); ?></a>
                                    </li>
                                    <?php endif; ?>
                                </ul>
                                <?php echo View::getMessage(); ?>                        
                                <div id="myTabContent" class="tab-content">
                                    <div role="tabpanel" class="tab-pane fade active in" id="editprofile" aria-labelledby="profile-tab">
                                        <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                            <input type="hidden" name="action" value="updateuser" />
                                            <input type="hidden" name="userid" value="<?php echo $userinfo->UserID; ?>" />
                                            <input type="hidden" name="metaid" value="<?php echo $userinfo->UserMetaID; ?>" />
                                            <input type="hidden" name="avatarid" value="<?php echo $userinfo->Avatar; ?>" />
                                            
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12 bottom-align-text" for="fname"><?php echo Lang::get('USR_PRF_PPCTURE'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input id="file-0a" class="file" type="file" data-min-file-count="0" name="Avatar" data-show-upload="false" data-allowed-file-extensions='["jpeg","png","jpg"]'>
                                                    <span>* Allowed file types: jpeg, jpg, png</span>
                                                </div>
                                            </div>
                                                                       
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="fname">
                                                   <?php echo Lang::get('USR_PRF_ROLE'); ?>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo Level::info('Name',$userinfo->Level); ?>" class="form-control col-md-7 col-xs-12" readonly="">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_PLANG'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <?php View::form('selecta',array('name'=>'meta[Language]','options'=>GAUtility::getLanguages(),'class'=>'form-control','value'=>$userinfo->Language)); ?>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12">Default Sidebar</label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <?php View::form('selecta',array('name'=>'meta[Sidebar]','options'=>GAUtility::getSidebars(),'class'=>'form-control','value'=>$userinfo->Sidebar)); ?>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="fname">
                                                    <?php echo Lang::get('USR_PRF_FN'); ?> <span class="required">*</span>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->FirstName; ?>" id="fname" name="meta[FirstName]" required="required" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="lname">
                                                    <?php echo Lang::get('USR_PRF_LN'); ?> <span class="required">*</span>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->LastName; ?>" id="lname" name="meta[LastName]" required="required" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="nname" class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_NN'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->NickName; ?>" id="nname" name="meta[NickName]" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="item form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="email">
                                                    <?php echo Lang::get('USR_PRF_EML'); ?> <span class="required">*</span>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="email" id="EmailChecker2" name="user[Email]" class="form-control col-md-7 col-xs-12" value="<?php echo isset($userinfo->Email) ? $userinfo->Email : ''; ?>" required="required" rel="<?php echo View::url('ajax/checkemail2/'); ?><?php echo isset($userinfo->UserID) ? $userinfo->UserID : ''; ?>/" checkmessage="<?php echo Lang::get('EMAIL_VALIDATION'); ?>" invalidmessage="<?php echo Lang::get('EMAIL_INVALID'); ?>"><span id="emailloading" class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>
                                                </div>
                                            </div>
                                            <div class="item form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="phone">
                                                    <?php echo Lang::get('USR_PRF_PHNE'); ?> <span class="required">*</span>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="phone" value="<?php echo $userinfo->Phone; ?>" id="phone" name="meta[Phone]" required="required" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="item form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="phone">
                                                    <?php echo Lang::get('USR_PRF_GNDR'); ?> <span class="required">*</span>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <p>
                                                        <?php echo Lang::get('USR_PRF_GNDRM'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderM" value="M" <?php echo $userinfo->Gender == 'M' ? 'checked' : ''; ?> required /> 
                                                        <?php echo Lang::get('USR_PRF_GNDRF'); ?>: <input type="radio" class="flat" name="meta[Gender]" id="genderF" value="F" <?php echo $userinfo->Gender == 'F' ? 'checked' : ''; ?> required />
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="address" class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_ADDS'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->Address; ?>" id="address" name="meta[Address]" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="city" class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_CTY'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->City; ?>" id="city" name="meta[City]" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="state" class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_STATES'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo $userinfo->State; ?>" id="state" name="meta[State]" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_CNTRY'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <select name="meta[Country]" class="form-control form-control col-md-10">
                                                        <?php foreach(GAUtility::getCountries() as $country) { ?>
                                                        <option value="<?php echo $country; ?>" <?php echo $userinfo->Country == $country ? 'selected' : ''; ?>><?php echo $country; ?></option>
                                                        <?php } ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="postal" class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_PCODE'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="text" value="<?php echo isset($userinfo->PostalCode) ? $userinfo->PostalCode : ''; ?>" id="postal" name="meta[PostalCode]" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"><?php echo Lang::get('USR_PRF_RMRKS'); ?></label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <textarea class="form-control dowysiwyg" name="meta[Bio]"><?php echo $userinfo->Bio; ?></textarea>
                                                </div>
                                            </div>
                                            <div class="ln_solid"></div>
                                            <div class="form-group">
                                                <div class="col-md-6 col-md-offset-3">
                                                    <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning"><?php echo Lang::get('USR_PRF_CANBTN'); ?></a>
                                                    <button id="send" type="submit" class="btn btn-success"><?php echo Lang::get('USR_PRF_SVBTN'); ?></button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div role="tabpanel" class="tab-pane fade" id="editpassword" aria-labelledby="profile-tab">
                                        <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                            <input type="hidden" name="action" value="savepassword" />
                                            <input type="hidden" name="userid" value="<?php echo $userinfo->UserID; ?>" />
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="oldpassword">
                                                   <?php echo Lang::get('USR_PRF_OPWD'); ?>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="password" value="" id="oldpassword" name="OldPassword" required="required" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="newpassword">
                                                   <?php echo Lang::get('USR_PRF_NPWD'); ?>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="password" value="" id="newpassword" name="NewPassword" required="required" class="form-control col-md-7 col-xs-12" data-validate-length-range="6,30">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="newpasswordconfirm">
                                                   <?php echo Lang::get('USR_PRF_CNPWD'); ?>
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input type="password" value="" id="newpasswordconfirm" name="NewPasswordConfirm" required="required" class="form-control col-md-7 col-xs-12" data-validate-length-range="6,30">
                                                </div>
                                            </div>
                                            <div class="ln_solid"></div>
                                            <div class="form-group">
                                                <div class="col-md-6 col-md-offset-3">
                                                    <a href="<?php echo View::url('users/'); ?>" class="btn btn-warning">Cancel</a>
                                                    <button id="send" type="submit" class="btn btn-success"><?php echo Lang::get('USR_PRF_RESBTN'); ?></button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <?php if(User::can('View API')) : ?>
                                    <div role="tabpanel" class="tab-pane fade" id="apiview" aria-labelledby="profile-tab">
                                        <form class="form-horizontal form-label-left input_mask" onsubmit="return false;">
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="oldpassword">
                                                   User ID
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input readonly="" type="text" value="<?php echo $userinfo->UserID; ?>" id="oldpassword" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12" for="oldpassword">
                                                   API Key
                                                </label>
                                                <div class="col-md-6 col-sm-6 col-xs-12">
                                                    <input readonly="" type="text" value="<?php echo $userinfo->HashKey; ?>" class="form-control col-md-7 col-xs-12">
                                                </div>
                                            </div>
                                            <div class="ln_solid"></div>

                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"></label>
                                                <div class="col-md-6 col-sm-12 col-xs-12">
                                                    <div class="block_content">
                                                        <h2 class="title">
                                                            <a>API Documentation</a>
                                                        </h2>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"></label>
                                                <div class="col-md-6 col-sm-12 col-xs-12">
                                                    <div class="block_content">
                                                        <h2 class="title">
                                                            <a>Parameters</a>
                                                        </h2>
                                                        <p class="excerpt"><b>id:</b> [string] the provided token or access key, default: none</p>
                                                        <p class="excerpt"><b>key:</b> [string] the api key to connect to the database, default: none</p>
                                                        <p class="excerpt"><b>output:</b> [string] the output data options(‘array’,’json’,’object’), default: ‘object’</p>
                                                    </div>
                                                    <div class="ln_solid divider no-margin"></div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"></label>
                                                <div class="col-md-6 col-sm-12 col-xs-12">
                                                    <div class="block_content">
                                                        <h2 class="title">
                                                            <a>Methods</a>
                                                        </h2>
                                                        
                                                    
                                                        <h4>GET</h2>
                                                        <p class="excerpt">Query using a get method:<br>
                                                        <strong>Example:</strong> <?php echo View::url();?>/api/get/id/key/output/</p>
                                                    
                                                        <h4>POST</h4>                                                    
                                                        <p class="excerpt">Query using a post method: (CURL, ajax)<br>
                                                        <strong>Example:</strong> <?php echo View::url();?>/api/post/</p>
                                                    </div>
                                                    <div class="ln_solid divider no-margin"></div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-md-2 col-sm-3 col-xs-12"></label>
                                                <div class="col-md-6 col-sm-12 col-xs-12">
                                                    <div class="block_content">
                                                        <h2 class="title">
                                                            <a>OUTPUT FIELDS</a>
                                                        </h2>
                                                        <p class="excerpt">
                                                            <ul>
                                                                <li>CasefileID</li>
                                                                <li>PolicyNumber</li>                                                                
                                                                <li>Name</li>
                                                                <li>ApplicationDate</li>                                                                
                                                                <li>MaturityDate</li>                                                         
                                                                <li>ApprovedDate</li>                                                                
                                                                <li>Contribution</li>                                                            
                                                                <li>CashAmount</li>                                                                
                                                                <li>ReferrerID</li>                                                                
                                                                <li>ReferrerName</li>                                                                
                                                                <li>Address</li>
                                                            </ul>
                                                        </p>
                                                    </div>
                                                    <div class="ln_solid divider no-margin"></div>
                                                </div>
                                            </div>

                                        </form>
                                    </div>
                                    <?php endif; ?>
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