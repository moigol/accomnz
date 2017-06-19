<?php 
View::$title = 'Add Suburb';
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
        <input type="hidden" name="action" value="addsuburb">
            <div class="form-group">
                <label class="col-sm-2 control-label">Region / Code</label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-12">
                            <select id="regionSel" name="region_id" class="form-control" rel="<?php echo View::URL('ajax/regionInfo/'); ?>">
                                <option value="">Select Region</option>
                                <?php
                                if($regs){
                                    foreach($regs as $reg){ ?>
                                        <option value="<?php echo $reg->id; ?>"><?php echo $reg->region; ?></option>
                                    <?php }
                                }
                                ?>
                            </select>
                        </div>
                        <div class="col-sm-6">
                            <!-- <input type="text" id="regionCode" name="region_code" class="form-control" value=""> -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Suburb</label>
                <div class="col-sm-10">
                    <input type="text" name="suburb" class="form-control" placeholder="Suburb" value="">
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
                <label class="col-sm-2 control-label">Suburb Code</label>
                <div class="col-sm-10">
                    <input type="text" name="suburb_code" class="form-control" placeholder="Suburb Code" value="">
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('suburb'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Add</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>