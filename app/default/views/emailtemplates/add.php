<?php 
View::$title = 'Add Email Template';
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
                        <h2><?php echo Lang::get('EMAILTPL_ADD_TITLE'); ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left" method="post" novalidate>
                                <input type="hidden" name="action" value="addemailtemplate" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                        <?php echo Lang::get('EMAILTPL_ADD_NAME'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($tpldata->ProductName) ? $pdata->ProductName : ''; ?>" id="name" name="name" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12"><?php echo Lang::get('EMAILTPL_ADD_DESC'); ?></label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <textarea class="form-control dowysiwyg" name="description"><?php echo isset($tpldata->ProductDescription) ? $pdata->ProductDescription : ''; ?></textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">
                                        <?php echo Lang::get('EMAILTPL_ADD_FILENAME'); ?> <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="<?php echo isset($tpldata->ProductName) ? $pdata->ProductName : ''; ?>" id="filename" name="filename" required="required" class="form-control col-md-7 col-xs-12">
                                    </div>
                                </div>
                                <div class="ln_solid"></div>
                                <div class="item form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('emailtemplates'); ?>" class="btn btn-warning"><?php echo Lang::get('PRD_ADD_CANCBTN'); ?></a>
                                        <button id="send" type="submit" class="btn btn-success"><?php echo Lang::get('EMAILTPL_ADD_ADDBTN'); ?></button>
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
<?php View::footer(); ?>