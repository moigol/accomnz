<?php 
View::$title = 'Region List';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info(); ?>
<!-- page content -->
<div class="content-box-large">
    <div class="panel-heading">
        <div class="panel-title"><?php echo View::$title; ?></div>
    </div>
    <div class="panel-body">

        <?php echo View::getMessage();  ?> 
         <table cellpadding="0" cellspacing="0" border="0" class="datatable table table-striped table-bordered">
            <thead>
                <tr class="headings">
                    <th class="sort-this">Region</th>
                    <th>Island</th>
                    <th>Lng</th>
                    <th>Lat</th>
                    <th>Start Zoom</th> 
                    <th>Page Heading</th> 
                    <th>Page Content</th> 
                    <th>Book It Code</th>  
                    <th class="no-sorting text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                $cntr = 0;
                if(count($regions)) {
                foreach($regions as $reg) { $cntr++;
                ?>
                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                    <td><?php echo $reg->region; ?></td>
                    <td><?php echo $reg->island; ?></td>
                    <td><?php echo $reg->lng; ?></td>
                    <td><?php echo $reg->lat; ?></td>
                    <td><?php echo $reg->startZoom; ?></td>
                    <td><?php echo $reg->list_title; ?></td>
                    <td><?php echo ($reg->list_desc) ? $reg->list_desc : ''; ?></td>
                    <td><?php echo $reg->bookit_code; ?></td>
                    <td class="text-center">
                        <a href="<?php echo View::url('regions/edit/'.$reg->id); ?>" title="Edit" class="green btn-xs btn-warning">Edit</a> 
                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('regions/delete/'.$reg->id); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $reg->region; ?>?');" class="red btn-xs btn-danger">Delete</a>
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
<!-- /page content -->
<?php View::footer(); ?>