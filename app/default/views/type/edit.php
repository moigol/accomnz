<?php 
View::$title = 'Edit Type';
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
        <form class="form-horizontal" role="form" method="post">
        <input type="hidden" name="action" value="updatetype">
        <input type="hidden" name="typeid" value="<?php echo $type->id; ?>">

            <div class="form-group">
                <label class="col-sm-2 control-label">Rank</label>
                <div class="col-sm-10">
                    <input type="text" name="rank" class="form-control" placeholder="Rank" value="<?php echo $type->rank; ?>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Name</label>
                <div class="col-sm-10">
                    <input type="text" name="name" class="form-control" placeholder="Name" value="<?php echo $type->name; ?>">
                </div>
            </div>    
            <div class="form-group">
                <label class="col-sm-2 control-label">List Title</label>
                <div class="col-sm-10">
                    <textarea name="list_title" class="form-control" placeholder="Page Title"><?php echo $type->list_title; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">List Description</label>
                <div class="col-sm-10">
                    <textarea name="list_desc" class="form-control" placeholder="Meta Description"><?php echo $type->list_desc; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Title</label>
                <div class="col-sm-10">
                    <input type="text" name="page_title" class="form-control" placeholder="Page Title" value="<?php echo $type->page_title; ?>" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Description</label>
                <div class="col-sm-10">
                    <input type="text" name="page_desc" class="form-control" placeholder="Page Description" value="<?php echo $type->page_desc; ?>" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Key</label>
                <div class="col-sm-10">
                    <input type="text" name="page_key" class="form-control" placeholder="Page Key" value="<?php echo $type->page_key; ?>">
                </div>
            </div>
			
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('type'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Update</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>