<?php 
View::$title = 'Welcome to '.Config::get('SITE_TITLE');
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info(); ?>

<div class="content-box-large">
    <div class="panel-heading">
        <div class="panel-title">Bootstrap dataTables</div>
    </div>
    <div class="panel-body">
        <table cellpadding="0" cellspacing="0" border="0" class="datatable table table-striped table-bordered" id="example">
            <thead>
                <tr>
                    <th>Page Title</th>
                    <th>Page Slug</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <tr class="odd gradeX">
                    <td>Regions</td>
                    <td><a href="<?php echo View::url('regions'); ?>"><?php echo View::url('regions'); ?></a></td>
                    <td class="text-center" width="180">
                        <a href="<?php echo View::url('regions'); ?>" class="green btn-xs btn-info">View</a>
                    </td>
                </tr>
                <tr class="odd gradeX">
                    <td>Suburb / City</td>
                    <td><a href="<?php echo View::url('suburb'); ?>"><?php echo View::url('suburb'); ?></a></td>
                    <td class="text-center" width="180">
                        <a href="<?php echo View::url('suburb'); ?>" class="green btn-xs btn-info">View</a>
                    </td>
                </tr>
                <tr class="odd gradeX">
                    <td>Book it Type</td>
                    <td><a href="<?php echo View::url('bookittype'); ?>"><?php echo View::url('bookittype'); ?></a></td>
                    <td class="text-center" width="180">
                        <a href="<?php echo View::url('bookittype'); ?>" class="green btn-xs btn-info">View</a>
                    </td>
                </tr>
                <tr class="odd gradeX">
                    <td>Type</td>
                    <td><a href="<?php echo View::url('type'); ?>"><?php echo View::url('type'); ?></a></td>
                    <td class="text-center" width="180">
                        <a href="<?php echo View::url('type'); ?>" class="green btn-xs btn-info">View</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<?php View::footer(); ?>