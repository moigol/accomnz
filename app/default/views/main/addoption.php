<?php 
View::$title = 'Add Option';
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
                        <h2><?php echo View::$title; ?></h2>
                        <div class="clearfix"></div>
                    </div>

                    <div class="x_content">
                        
                        <div class="col-md-12 col-sm-12 col-xs-12">
                            <?php echo View::getMessage(); ?>   
                            <form class="form-horizontal form-label-left" enctype="multipart/form-data" method="post" novalidate>
                                <input type="hidden" name="action" value="addoption" />
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">
                                        Group <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <?php
                                            View::form(
                                                'selecta',
                                                array(
                                                    'name'=>'OptionGroupID',
                                                    'options'=>$groups,
                                                    'value'=>isset($groups->OptionGroupID) ? $groups->OptionGroupID : '',
                                                    'class'=>'form-control',
                                                    'custom' => 'required'
                                                )
                                            ); 
                                        ?>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">
                                        Form Type <span class="required">*</span>
                                    </label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <select name="FormType" class="form-control" required="">
                                            <option value="text">Text</option>
                                            <option value="select">Select</option>
                                            <option value="upload">Upload</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Option Key</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="" placeholder="Ex: option_key, logo_title, field_key" name="OptionKey" id="text" class="form-control" required="">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Option Label</label>
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <input type="text" value="" name="OptionLabel" class="form-control" required="">
                                    </div>
                                </div>

                                <div class="ln_solid"></div>
                                <div class="item form-group">
                                    <div class="col-md-6 col-md-offset-3">
                                        <a href="<?php echo View::url('options'); ?>" class="btn btn-warning">Back</a>
                                        <button type="submit" class="btn btn-success">Add Option</button>
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