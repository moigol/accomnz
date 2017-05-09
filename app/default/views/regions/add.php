<?php 
View::$title = 'Add Region';
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
        <input type="hidden" name="action" value="addregion">
            <div class="form-group">
                <label class="col-sm-2 control-label">Region</label>
                <div class="col-sm-10">
                    <input type="text" name="region" class="form-control" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Island</label>
                <div class="col-sm-10">
                    <input type="text" name="island" class="form-control" placeholder="island" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Lng / Lat</label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-6"><input type="text" name="lng" class="form-control" placeholder="lng" value=""></div>
                        <div class="col-sm-6"><input type="text" name="lat" class="form-control" placeholder="lat" value=""></div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">Start Zoom</label>
                <div class="col-sm-10">
                    <input type="text" name="startZoom" class="form-control" placeholder="Start Zoom" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">List Title</label>
                <div class="col-sm-10">
                    <textarea name="list_title" class="form-control" placeholder="Page Title"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">List Description</label>
                <div class="col-sm-10">
                    <textarea name="list_desc" class="form-control" placeholder="Meta Description"></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Title</label>
                <div class="col-sm-10">
                    <input type="text" name="page_title" class="form-control" placeholder="Page Title" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Description</label>
                <div class="col-sm-10">
                    <input type="text" name="meta_desc" class="form-control" placeholder="Meta Description" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Key</label>
                <div class="col-sm-10">
                    <input type="text" name="meta_key" class="form-control" placeholder="Meta Key" value="">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Book it Code</label>
                <div class="col-sm-10">
                    <input type="text" name="bookit_code" class="form-control" placeholder="Book it Code" value="">
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('regions'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Add Region</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>