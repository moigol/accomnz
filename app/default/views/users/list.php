<?php 
View::$title = 'Users';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info(); ?>
<!-- page content -->
<div class="right_col" role="main">
    <div class="">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo Lang::get('USR_MNG_TITLE'); ?></h2>
                        <?php //View::template('toolboxnav'); ?>
                        <a class="btn btn-warning btn-default pull-right" href="<?php echo View::url('users/add/'); ?>"><?php echo Lang::get('USR_MNG_ADDBTN'); ?></a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <table id="datatable-responsive" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <!--th class="no-sorting"><input type="checkbox" id="check-all" class="flat"></th-->
                                    <th class="no-sorting"><?php echo Lang::get('USR_MNG_IMG'); ?></th>
                                    <th class="sort-this"><?php echo Lang::get('USR_MNG_UID'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_EML'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_NAME'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_GNDR'); ?></th>                                    
                                    <th><?php echo Lang::get('USR_MNG_PHNE'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_LVL'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_DATE'); ?></th>
                                    <th><?php echo Lang::get('USR_MNG_REFRR'); ?></th>
                                    <th class="no-sorting text-center" style="text-align:center; width: 5%;"><?php echo Lang::get('USR_MNG_ACTN'); ?></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                if(count($users)) {
                                foreach($users as $user) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <?php $avatar = View::common()->getUploadedFiles($user->Avatar); ?>
                                    <td><img src="<?php echo View::url('assets/'. ( ($avatar) ? 'files/'.$avatar[0]->FileSlug : 'images/user.png' )); ?>" style="width:40px;" /></td>
                                    <td><?php echo $user->Code; ?>-<?php echo $user->UserID; ?></td>
                                    <td><?php echo $user->Email; ?></td>
                                    <td><?php echo $user->FirstName; ?> <?php echo $user->LastName; ?></td>
                                    <td><?php echo $user->Gender; ?></td>
                                    <td><?php echo $user->Phone; ?></td>
                                    <td><?php echo $user->Name; ?></td>
                                    <td><?php echo $user->DateAdded; ?></td>
                                    <td><?php $refInfo = User::info(false,$user->ReferrerUserID); echo $refInfo->FirstName.' '.$refInfo->LastName; ?></td>
                                    <td class="text-center">
                                        <a href="<?php echo View::url('users/edit/'.$user->UserID); ?>" title="Edit" class="green"><?php echo Lang::get('USR_MNG_ACTN_EDT'); ?></a> 
                                        <?php if($userinfo->Level == 1) { ?>
                                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('users/trash/'.$user->UserID); ?>" title="Delete" onclick="return confirm('Are you sure you want to put user <?php echo $user->FirstName; ?> <?php echo $user->LastName; ?> to trash bin?');" class="red"><?php echo Lang::get('USR_MNG_ACTN_DEL'); ?></a>
                                        <?php } ?>
                                    </td>
                                </tr>
                                <?php } 
                                } else {?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <!--td class="a-center"><input type="checkbox" name="table_records" value="<?php //echo $user->UserID; ?>" class="flat"></td-->
                                    <td colspan="99">No Data</td>
                                </tr>
                                <?php } ?>
                                
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>