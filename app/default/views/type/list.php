<?php 
View::$title = 'Type List';
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
                    <th width="50">Rank</th>
                    <th>Name</th>
                    <th>Page Title</th> 
                    <th>Meta Desc</th>
                    <th>Meta key</th>
                    <th class="no-sorting text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                $cntr = 0;
                if(count($types)) {
                foreach($types as $type) { $cntr++;
                ?>
                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                    <td class="text-center"><?php echo $type->rank; ?></td>
                    <td><?php echo $type->name; ?></td>
                    <td><?php echo $type->page_title; ?></td>
                    <td><?php echo $type->page_desc; ?></td>
                    <td><?php echo $type->page_key; ?></td>
                    <td class="text-center" width="180">
                        <a href="<?php echo View::url('type/edit/'.$type->id); ?>" title="Edit" class="green btn-xs btn-warning">Edit</a> 
                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('type/delete/'.$type->id); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $type->name; ?>?');" class="red btn-xs btn-danger">Delete</a>
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