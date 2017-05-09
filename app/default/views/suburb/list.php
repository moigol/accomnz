<?php 
View::$title = 'Suburbs List';
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
                    <th class="sort-this">Suburb</th>
                    <th>Lng</th>
                    <th>Lat</th> 
                    <th>Suburb Code</th>  
                    <th>Region Code</th>
                    <th>Title</th> 
                    <th>Description</th> 
                    <th class="no-sorting text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                $cntr = 0;
                if(count($suburbs)) {
                foreach($suburbs as $suburb) { $cntr++;
                ?>
                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                    <td><?php echo $suburb->suburb; ?></td>
                    <td><?php echo $suburb->lng; ?></td>
                    <td><?php echo $suburb->lat; ?></td>
                    <td><?php echo $suburb->suburb_code; ?></td>
                    <td><?php echo $suburb->region_code; ?></td>
                    <td><?php echo $suburb->list_title; ?></td>
                    <td><?php echo $suburb->list_desc; ?></td>
                    <td class="text-center">
                        <a href="<?php echo View::url('suburb/edit/'.$suburb->id); ?>" title="Edit" class="green btn-xs btn-warning">Edit</a> 
                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('suburb/delete/'.$suburb->id); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $suburb->suburb; ?>?');" class="red btn-xs btn-danger">Delete</a>
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