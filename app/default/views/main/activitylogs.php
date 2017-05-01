<?php 
View::$title = 'Activity Logs';
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
                        
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">

                        <table id="datatable" class="table default-table dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <th class="sort-this text-center">Date Time</th>
                                    <th class="text-center">Activity Description</th>
                                    <th class="text-center">User Name</th>
                                </tr>
                            </thead>
                            </tfoot>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                if(count($logs)) {
                                foreach($logs as $log) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer text-center">
                                    <td><?php echo $log->ActivityDate; ?></td>
                                    <td><?php echo $log->ActivityDescription; ?></td>
                                    <td><?php echo $log->UserName; ?></td>
                                </tr>
                                <?php } 
                                } else {?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
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
