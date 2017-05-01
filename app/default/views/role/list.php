<?php 
View::$title = 'Roles';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<!-- page content -->
<div class="right_col" role="main">
    <div class="">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo View::$title; ?></h2>
                        <?php //View::template('toolboxnav'); ?>
                        <a class="btn btn-warning btn-default pull-right" href="<?php echo View::url('role/add'); ?>">Add Role</a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <?php echo View::getMessage(); ?> 
                        <table id="datatable-responsive" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <th class="no-sorting"><input type="checkbox" id="check-all" class="flat"></th>
                                    <th>ID</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Dashboard Link</th>
                                    <th class="no-sorting text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                foreach($roles as $role) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <td class="a-center"><input type="checkbox" name="table_records" value="<?php echo $role->UserLevelID; ?>" class="flat"></td>
                                    
                                    <td><?php echo $role->UserLevelID; ?></td>
                                    <td><?php echo $role->Code; ?></td>
                                    <td><?php echo $role->Name; ?></td>
                                    <td><?php echo $role->Description; ?></td>
                                    <td><?php echo $role->Link; ?></td>
                                    <td class="text-center">
                                        <a href="<?php echo View::url('role/edit/'.$role->UserLevelID); ?>" title="Edit" class="green">Edit</a> &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <a href="<?php echo View::url('role/delete/'.$role->UserLevelID); ?>" title="Delete" class="red" onclick="return confirm('Are you sure you want to delete data?');">Delete</a>
                                    </td>
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