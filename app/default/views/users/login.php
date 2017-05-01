<?php 
View::$title = 'User Login';
View::$bodyclass = 'loginpage';
View::header('users'); 
?>
<div class="page-content container">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="login-wrapper">
                <div class="box">
                    <div class="content-wrap">
                        <h6>Sign In</h6>
                        <div class="social">
                            <a class="face_login" href="#">
                                <span class="face_icon">
                                    <?php View::image('facebook.png','','big'); ?>
                                </span>
                                <span class="text">Sign in with Facebook</span>
                            </a>
                            <div class="division">
                                <hr class="left">
                                <span>or</span>
                                <hr class="right">
                            </div>
                        </div>
                        <form method="post">
                            <input type="hidden" name="action" value="login" />
                            <input class="form-control" type="text" placeholder="<?php echo Lang::get('LOGIN_USERLABEL'); ?>" name="usr">
                            <input class="form-control" type="password" placeholder="<?php echo Lang::get('LOGIN_PASSLABEL'); ?>" name="pwd">
                            <div class="action">
                                <button type="submit" class="btn btn-default submit" href="#"><?php echo Lang::get('LOGIN_BUTTON'); ?></button>
                            </div>  
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php View::footer('users'); ?>