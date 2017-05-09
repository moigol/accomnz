<?php 
View::$title = 'Request Password';
View::$bodyclass = 'loginpage';
View::header('users'); 
?>
<div class="page-content container">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="login-wrapper">
                <div class="box">
                    <div class="content-wrap">
                        <h6>Password Recall</h6>
                        <?php echo View::getMessage(); ?>
                        <form method="post">
                            <input type="hidden" name="action" value="request" />
                            <input class="form-control" type="text" placeholder="<?php echo Lang::get('RESET_EMAILLABEL'); ?>" name="eml">
                            <div class="action">
                                <button type="submit" class="btn btn-default submit" href="#">Send a recall email</button>
                            </div>                              
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php View::footer('users'); ?>