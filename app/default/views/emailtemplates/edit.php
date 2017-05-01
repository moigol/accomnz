<?php 
View::$title = 'Edit Email Template';
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info();  //print_r(unserialize(base64_decode($_SESSION[SESSIONCODE])));?>
<!-- page content -->
<div class="right_col" role="main">

    <div class=""> 

        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo Lang::get('EMAILTPL_EDIT_TITLE'); ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left" method="post" id="tplForm" novalidate="novalidate" enctype="" accept-charset="UTF-8">
                                <input type="hidden" name="action" value="updateemailtemplate" />
                                <input type="hidden" name="id" id="tplid" value="<?php echo $etpl->id; ?>" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                        <?php echo Lang::get('EMAILTPL_EDIT_NAME'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($etpl->name) ? $etpl->name : ''; ?>" id="name" name="name" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('EMAILTPL_EDIT_DESC'); ?></label>
                                    <div class="col-md-9 col-sm-9 col-xs-12">
                                        <textarea class="form-control dowysiwyg" name="description" id="description"><?php echo isset($etpl->description) ? $etpl->description : ''; ?></textarea>
                                    </div>
                                </div>
                                 <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                        <?php echo Lang::get('EMAILTPL_ADD_FILENAME'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($etpl->filename) ? $etpl->filename : ''; ?>" id="filename" name="filename" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('EMAILTPL_EDIT_CONTENT'); ?></label>
                                    <div class="col-md-9 col-sm-9 col-xs-12">
                                        <textarea id="filecontent" class="form-control" name="filecontent" ><?php echo isset($fileContent) ? $fileContent : ''; ?></textarea>
                                    </div>
                                </div>
                                <div class="ln_solid"></div>
                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('emailtemplates'); ?>" class="btn btn-warning"><?php echo Lang::get('EMAILTPL_EDIT_BCKBTN'); ?></a>
                                        <button id="send" type="submit" class="btn btn-success"><?php echo Lang::get('EMAILTPL_EDIT_SVBTN'); ?></button>
                                    </div>
                                </div>
                                
                                
                            </form>
                               
                        </div>
                    </div>
                </div>
                               
            </div>
        </div>

        

    </div>
    
</div>
<!-- /page content -->
<script src="http://cdn.ckeditor.com/4.6.1/standard-all/ckeditor.js"></script>
<?php View::footer(); ?>

