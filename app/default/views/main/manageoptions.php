<?php 
View::$title = 'Manage Options';
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
                        <div class="col-md-12 col-sm-12 col-xs-12">

                            <table id="datatable-responsive" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                                <thead>
                                    <tr class="headings">
                                        <!-- <th class="no-sorting"><input type="checkbox" id="check-all" class="flat"></th> -->
                                        <th class="text-center" width="100">Option ID</th>
                                        <th class="text-center">Group Name</th>
                                        <th class="text-center">Form Type</th> 
                                        <th class="text-center">Option Key</th> 
                                        <th class="text-center">Option Label</th>
                                        <th class="no-sorting text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $cntr = 0;
                                    if(count($optionLists)) {
                                    foreach($optionLists as $optionList) { $cntr++;
                                    ?>
                                    <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                        <!-- <td class="a-center"><input type="checkbox" name="table_records" value="<?php echo $item->ProductItemID; ?>" class="flat"></td> -->
                                        <td class="text-center"><?php echo $optionList->OptionID; ?></td>
                                        <td class="text-center"><?php echo ucwords($optionList->GroupName); ?></td>
                                        <td class="text-center"><?php echo ucwords($optionList->FormType); ?></td>
                                        <td class="text-center"><?php echo $optionList->OptionKey; ?></td>
                                        <td class="text-center"><?php echo $optionList->OptionLabel; ?></td>
                                        <td width="120px" class="text-center">
                                            <a href="<?php echo View::url('editOption/'); ?><?php echo $optionList->OptionID; ?>" title="Edit" class="green">Edit</a>
                                            &nbsp;&nbsp;|&nbsp;&nbsp; 
                                            <a href=<?php echo View::url('deleteoption/'); ?><?php echo $optionList->OptionID; ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $optionList->GroupName; ?> : <?php echo $optionList->OptionLabel; ?>?');" class="red">Delete</a>
                                        </td>
                                    </tr>
                                    <?php } 
                                    } else {?>
                                    <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                        <!--td class="a-center"><input type="checkbox" name="table_records" value="<?php //echo $user->ProductID; ?>" class="flat"></td-->
                                        <td class="text-center">No Data</td>
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
</div>

<?php View::footer(); ?>