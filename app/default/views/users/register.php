<?php 
View::$title = 'Register an Account';
View::$bodyclass = 'loginpage';
View::header('users'); 
?>
<div class="">
    <a class="hiddenanchor" id="toregister"></a>
    <a class="hiddenanchor" id="tologin"></a>

    <div id="wrapper">
        <div id="register" class=" form">
            <section class="login_content">
                <form>
                    <h1>Register an Account</h1>
                    <div>
                        <input type="text" class="form-control" placeholder="Username" required="" />
                    </div>
                    <div>
                        <input type="email" class="form-control" placeholder="Email" required="" />
                    </div>
                    <div>
                        <input type="password" class="form-control" placeholder="Password" required="" />
                    </div>
                    <div>
                        <a class="btn btn-default submit" href="#">Submit</a>
                    </div>
                    <div class="clearfix"></div>
                    <div class="separator">
                        <p class="change_link">Already a member ?
                            <a href="<?php echo View::url('users/login'); ?>" class="to_register"> Log in </a>
                        </p>
                        <div class="clearfix"></div>
                        <br />
                        <div>
                            <h1><i class="fa fa-paw" style="font-size: 26px;"></i> Odeon & Co.!</h1>

                            <p><?php echo Config::get('SITE_TITLE'); ?></p>
                        </div>
                      </div>
                </form>
            </section>
        </div>
    </div>
</div>
<?php View::footer('users'); ?>