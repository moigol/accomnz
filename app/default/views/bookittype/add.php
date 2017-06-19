<?php 
View::$title = 'Add Book it type';
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
        <input type="hidden" name="action" value="addbookittype">

            <div class="form-group">
                <label class="col-sm-2 control-label"></label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-6">
                            <label class="control-label">Display Order</label>
                            <input type="text" name="display_order" class="form-control" placeholder="Display Order" value="">
                        </div>
                        <div class="col-sm-6">
                            <label class="control-label">Code</label>
                            <input type="text" name="code" class="form-control" placeholder="Code" value="">
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Name</label>
                <div class="col-sm-10">
                    <input type="text" name="name" class="form-control" placeholder="Name" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Heading</label>
                <div class="col-sm-10">
                    <textarea name="list_title" class="form-control" placeholder="Page Heading"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Content</label>
                <div class="col-sm-10">
                    <textarea name="list_desc"></textarea>
                    <script>
                        CKEDITOR.replace( 'list_desc' );
                    </script>
                </div>
            </div>   
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Title</label>
                <div class="col-sm-10">
                    <textarea name="page_title" class="form-control" placeholder="Page Title"></textarea>
                </div>
            </div>
            

            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Description</label>
                <div class="col-sm-10">
                    <textarea name="page_desc" class="form-control" placeholder="Meta Description"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Key</label>
                <div class="col-sm-10">
                    <textarea name="page_key" class="form-control" placeholder="Meta Key"></textarea>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('bookittype'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Add Book it type</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>