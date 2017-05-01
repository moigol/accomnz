<?php 
View::$title = 'Settings';
View::$bodyclass = User::info('Sidebar');
View::header(); 
$env = Config::get('ENVIRONMENT');
?>
<?php $userinfo = User::info(); ?>

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
                        <?php $settings = Config::get(); ?>
                        <?php foreach($settings as $key => $val) { ?>
                        <div class="form-group">
                            <label class="control-label col-md-2 col-sm-2 col-xs-12" for="SiteTitle"><?php echo $key; ?></label>
                            <div class="col-md-10 col-sm-6 col-xs-12">
                                <input type="text" id="SiteTitle" value="<?php echo $val; ?>" class="form-control col-md-7 col-xs-12" readonly="">
                            </div>
                        </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
</div>

<?php View::footer(); ?>