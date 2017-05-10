<?php 
View::$title = 'Edit Book it type';
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
        <input type="hidden" name="action" value="updatebookittype">
        <input type="hidden" name="bookittypeid" value="<?php echo $bookittype->id; ?>">

            <div class="form-group">
                <label class="col-sm-2 control-label"></label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-6">
                            <label class="control-label">Display Order</label>
                            <input type="text" name="display_order" class="form-control" placeholder="Display Order" value="<?php echo $bookittype->display_order; ?>">
                        </div>
                        <div class="col-sm-6">
                            <label class="control-label">Code</label>
                            <input type="text" name="code" class="form-control" placeholder="Code" value="<?php echo $bookittype->code; ?>">
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Name</label>
                <div class="col-sm-10">
                    <input type="text" name="name" class="form-control" placeholder="Name" value="<?php echo $bookittype->name; ?>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">List Title</label>
                <div class="col-sm-10">
                    <textarea name="list_title" class="form-control" placeholder="Page Title"><?php echo $bookittype->list_title; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">List Description</label>
                <div class="col-sm-10">
                    <textarea name="list_desc" class="form-control" placeholder="Meta Description"><?php echo $bookittype->list_desc; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Title</label>
                <div class="col-sm-10">
                    <input type="text" name="page_title" class="form-control" placeholder="Page Title" value="<?php echo $bookittype->page_title; ?>">
                </div>
            </div>
            

            <div class="form-group">
                <label class="col-sm-2 control-label">Page Description</label>
                <div class="col-sm-10">
                    <input type="text" name="page_desc" class="form-control" placeholder="Page Description" value="<?php echo $bookittype->page_desc; ?>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Key</label>
                <div class="col-sm-10">
                    <input type="text" name="page_key" class="form-control" placeholder="Page Key" value="<?php echo $bookittype->page_key; ?>">
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('regions'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Update</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>