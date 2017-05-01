<?php 
View::$title = 'Capability Groups';
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
                        <h2><?php echo View::$title; ?></h2>
                        <?php //View::template('toolboxnav'); ?>
                        <a class="btn btn-warning btn-default pull-right" href="<?php echo View::url('capabilitygroups/add'); ?>">Add Group</a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <?php echo View::getMessage();  ?> 
                        <table id="datatable-responsive" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <th class="sort-this" width="150">Groups ID</th>
                                    <th class="sort-this">Name</th>
                                    <th class="no-sorting text-center" width="150">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                if(count($groups)) {
                                foreach($groups as $group) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <td><?php echo $group->UserCapabilityGroupID; ?></td>
                                    <td><?php echo $group->Name; ?></td>
                                    <td class="text-center">
                                        <a href="<?php echo View::url('capabilitygroups/edit/'.$group->UserCapabilityGroupID); ?>" title="Edit" class="green">Edit</a>
                                        <?php if($userinfo->Level == 1) { ?>
                                         &nbsp;&nbsp; | &nbsp;&nbsp; <a href="<?php echo View::url('capabilitygroups/delete/'.$group->UserCapabilityGroupID); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete the <?php echo $group->Name; ?>?');" class="red">Delete</a>
                                        <?php } ?>
                                    </td>
                                </tr>
                                <?php } 
                                } else {?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <!--td class="a-center"><input type="checkbox" name="table_records" value="<?php //echo $user->ProductID; ?>" class="flat"></td-->
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