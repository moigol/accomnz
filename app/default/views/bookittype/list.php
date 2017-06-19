<?php 
View::$title = 'Book it Type List';
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
                    <th class="sort-this" width="50">Order</th>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Page Title</th>
                    <th>Meta Desc</th> 
                    <th>Meta Key</th>  
                    <th class="no-sorting text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                $cntr = 0;
                if(count($bookits)) {
                foreach($bookits as $book) { $cntr++;
                ?>
                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                    <td class="text-center"><?php echo $book->display_order; ?></td>
                    <td><?php echo $book->code; ?></td>
                    <td><?php echo $book->name; ?></td>
                    <td><?php echo $book->page_title; ?></td>
                    <td><?php echo $book->page_desc; ?></td>
                    <td><?php echo $book->page_key; ?></td>
                    <td class="text-center">
                        <a href="<?php echo View::url('bookittype/edit/'.$book->id); ?>" title="Edit" class="green btn-xs btn-warning">Edit</a> 
                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('bookittype/delete/'.$book->id); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $book->name; ?>?');" class="red btn-xs btn-danger">Delete</a>
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