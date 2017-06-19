<?php 
View::$title = 'Edit Suburb';
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
        <input type="hidden" name="action" value="updatesuburb">
        <input type="hidden" name="suburbid" value="<?php echo $subrb->id; ?>">
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
                                        <option value="<?php echo $reg->id; ?>" <?php echo ($subrb->region_id == $reg->id) ? "selected" : ""; ?>><?php echo $reg->region; ?></option>
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
                    <input type="text" name="suburb" class="form-control" placeholder="Suburb" value="<?php echo $subrb->suburb; ?>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Lng / Lat</label>
                <div class="col-sm-10">
                    <div class="row">
                        <div class="col-sm-6"><input type="text" name="lng" class="form-control" placeholder="lng" value="<?php echo $subrb->lng; ?>"></div>
                        <div class="col-sm-6"><input type="text" name="lat" class="form-control" placeholder="lat" value="<?php echo $subrb->lat; ?>"></div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">Start Zoom</label>
                <div class="col-sm-10">
                    <input type="text" name="startZoom" class="form-control" placeholder="Start Zoom" value="<?php echo $subrb->startZoom; ?>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Heading</label>
                <div class="col-sm-10">
                    <textarea name="list_title" class="form-control" placeholder="Page Heading"><?php echo $subrb->list_title; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Content</label>
                <div class="col-sm-10">
                    <textarea name="list_desc"><?php echo $subrb->list_desc; ?></textarea>
                    <script>
                        CKEDITOR.replace( 'list_desc' );
                    </script>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Page Title</label>
                <div class="col-sm-10">
                    <textarea name="page_title" class="form-control" placeholder="Page Title"><?php echo $subrb->page_title; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Description</label>
                <div class="col-sm-10">
                    <textarea name="page_desc" class="form-control" placeholder="Meta Description"><?php echo $subrb->page_desc; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Meta Key</label>
                <div class="col-sm-10">
                    <textarea name="page_key" class="form-control" placeholder="Meta Key"><?php echo $subrb->page_key; ?></textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">Suburb Code</label>
                <div class="col-sm-10">
                    <input type="text" name="suburb_code" class="form-control" placeholder="Suburb Code" value="<?php echo $subrb->suburb_code; ?>">
                </div>
            </div>
            
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <a href="<?php echo View::Url('suburb'); ?>" class="btn btn-warning">Back</a>
                    <button type="submit" class="btn btn-success">Update</button>
                </div>
            </div>
        </form>
    
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>