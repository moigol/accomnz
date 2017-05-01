<?php 
View::$title = 'Email Templates';
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
                        <h2><?php echo Lang::get('EMAILTPL_TITLE'); ?></h2>
                        <?php //View::template('toolboxnav'); ?>
                        <a class="btn btn-warning btn-default pull-right" href="<?php echo View::url('emailtemplates/add'); ?>"><?php echo Lang::get('EMAILTPL_ADDBTN'); ?></a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <?php echo View::getMessage();  ?> 
                        <table id="datatable-responsive" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <th class="sort-this"><?php echo Lang::get('EMAILTPL_ID'); ?></th>
                                    <th class="sort-this"><?php echo Lang::get('EMAILTPL_NAME'); ?></th>
                                    <th><?php echo Lang::get('EMAILTPL_FILE'); ?></th>                                     
                                    <th><?php echo Lang::get('EMAILTPL_DATEUPDATED'); ?></th>
                                    <th class="no-sorting text-center"><?php echo Lang::get('EMAILTPL_ACTN'); ?></th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                if(count($emTemplates)) {
                                foreach($emTemplates as $etpl) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <td>ETPL-<?php echo $etpl->id; ?></td>
                                    <td><?php echo $etpl->name; ?></td>                                                                     
                                    <td><?php echo $etpl->filename; ?></td>
                                    <td><?php echo $etpl->updated_at; ?></td>
                                    <td class="text-center">
                                        <a href="<?php echo View::url('emailtemplates/edit/'.$etpl->id); ?>" title="Edit" class="green"><?php echo Lang::get('PRD_ACTN_EDT'); ?></a> 
                                        <?php if($userinfo->Level == 1) { ?>
                                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('emailtemplates/delete/'.$etpl->id); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete this Email Template: <?php echo $etpl->name; ?>?');" class="red"><?php echo Lang::get('EMAILTPL_ACTN_DEL'); ?></a>
                                        <?php } ?>
                                    </td>
                                </tr>
                                <?php } 
                                } else {?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">                                    
                                    <td colspan="9">No Data</td>
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