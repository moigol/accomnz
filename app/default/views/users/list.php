<?php 
View::$title = 'Users';
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
                    <th class="sort-this">ID</th>
                    <th>Email</th>
                    <th>Name</th>
                    <th>Level</th>
                    <th>Date</th>  
                    <th class="no-sorting text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                $cntr = 0;
                if(count($users)) {
                foreach($users as $user) { $cntr++;
                ?>
                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                    <td><?php echo $user->UserID; ?></td>
                    <td><?php echo $user->Email; ?></td>
                    <td><?php echo $user->FirstName; ?> <?php echo $user->LastName; ?></td>
                    <td><?php echo $user->Name; ?></td>
                    <td><?php echo $user->DateAdded; ?></td>
                    
                    
                    <td class="text-center">
                        <a href="<?php echo View::url('users/edit/'.$user->UserID); ?>" title="Edit" class="green btn-xs btn-warning">Edit</a> 
                        <?php if($user->UserID != 100000 && $user->UserID != User::info('UserID')) {  ?>
                        &nbsp;&nbsp;|&nbsp;&nbsp; <a href="<?php echo View::url('users/delete/'.$user->UserID); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete <?php echo $user->UserID; ?>?');" class="red btn-xs btn-danger">Delete</a>
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
<!-- /page content -->

<?php View::footer(); ?>