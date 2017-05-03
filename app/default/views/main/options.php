<?php 
View::$title = 'Options';
View::$bodyclass = User::info('Sidebar');
View::header(); 
$env = Config::get('ENVIRONMENT');
?>
<?php $userinfo = User::info(); ?>

<!-- page content -->
<div class="right_col" role="main">

    <div class="">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo View::$title; ?></h2>
                        <a href="<?php echo View::url('addOption'); ?>" class="btn btn-default pull-right">Add Option</a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <?php echo View::getMessage(); 
                        //echo '<pre>';print_r($options);echo '</pre>';
                        $dropdown = array(
                            'new_user_role' => $levels,
                            'time_zone' => $timezones = timezone_identifiers_list(),
                            'site_language' => Utility::getLanguagesAsOption()
                        );
                        ?>
                        <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                            <input type="hidden" name="action" value="updateoptions" />
                            <input type="hidden" name="userid" value="<?php echo $userinfo->UserID; ?>" />
                            <div class="" role="tabpanel" data-example-id="togglable-tabs">
                                <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">                                    
                                    <?php 
                                    $cntr = 0; 
                                    foreach($options as $kk => $vv) { $cntr++;?>
                                    <li role="presentation" class=""><a href="#<?php echo $kk; ?>" role="tab" id="profile-tab5" data-toggle="tab" aria-expanded="<?php echo $cntr <= 1 ? 'true' : 'false'; ?>"><?php echo $kk; ?></a></li>
                                    <?php } ?>
                                </ul>
                                <div id="myTabContent" class="tab-content">
                                    <?php 
                                    $cntr = 0;
                                    foreach($options as $key => $vals) { $cntr++; ?>
                                    <div role="tabpanel" class="tab-pane fade <?php echo $cntr <= 1 ? 'active' : ''; ?> in" id="<?php echo $key; ?>" aria-labelledby="profile-tab1">
                                        <?php foreach($vals as $v) { ?>
                                        <div class="form-group">
                                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="SiteTitle"><?php echo $v->OptionLabel; ?> <span class="required">*</span></label>
                                            <div class="col-md-6 col-sm-7 col-xs-12">
                                                <?php 
                                                    if($v->FormType == 'upload') {
                                                        $f = View::common()->getUploadedFiles($v->OptionValue);
                                                        echo '<div class="col-md-12 col-sm-12"><div class="col-md-4 col-sm-4">'.View::photo( (($f) ? 'files'.$f[0]->FileSlug : ''),($v->OptionValue) ? $v->OptionKey : '',"img-responsive",false,false).'</div></div><p>&nbsp;</p>';
                                                    }
                                                    
                                                    View::form(
                                                        $v->FormType,
                                                        array(
                                                            'name'=> ($v->FormType == 'upload') ? $v->OptionKey : 'settings['.$v->OptionKey.']',
                                                            'value'=>$v->OptionValue,
                                                            'id' => $v->OptionKey,
                                                            'options'=>isset($dropdown[$v->OptionKey]) ? $dropdown[$v->OptionKey] : array(),
                                                            'class'=>'form-control col-md-7 col-xs-12'
                                                        )
                                                    );
                                                ?>
                                            </div>
                                        </div>
                                        <?php } ?>
                                        
                                    </div>
                                    <?php } ?>
                                    
                                </div>
                            </div>

                            <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="ln_solid"></div>
                                <div class="form-group text-center">

                                    <button type="submit" class="btn btn-success">Save Changes</button>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<?php View::footer(); ?>