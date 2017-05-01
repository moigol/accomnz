<?php 
View::$title = 'Request Password';
View::$bodyclass = 'loginpage';
View::header('users'); 
?>
<div class="">
    <a class="hiddenanchor" id="toregister"></a>
    <a class="hiddenanchor" id="tologin"></a>

    <div id="wrapper">
        <div id="login" class=" form">
            <section class="login_content">
                <form method="post">
                    <input type="hidden" name="action" value="request" />
                    <h1><?php echo Lang::get('RESET_TITLE'); ?><br><?php View::image('logo.png','','big'); ?></h1>
                    <p><?php echo Lang::get('RESET_SUBTITLE'); ?></p>
                     <?php echo View::getMessage(); ?>
                    <div>
                        <input type="text" class="form-control" name="usr" placeholder="<?php echo Lang::get('RESETL_USERLABE'); ?>" required="" />
                    </div>
                    <div>
                        <input type="text" class="form-control" name="eml" placeholder="<?php echo Lang::get('RESET_EMAILLABEL'); ?>" required="" />
                    </div>
                    <div style="text-align: center;">
                        <button type="submit" class="btn btn-default submit" href="#"><?php echo Lang::get('RESET_BUTTON'); ?></button>
                        <br><br><br>
                        <a class="no-margin no-padding" href="<?php echo View::url('users/login'); ?><?php echo isset(View::common()->segment[2]) ? View::common()->segment[2] : ''; ?>"><?php echo Lang::get('RESET_LOGIN'); ?></a>
                    </div>
                    <div class="clearfix"></div>
                    <div class="separator">
                    <div>
                        <select class="form-control" onchange="this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);">
                            <?php foreach(GAUtility::getLanguages() as $k => $v) { ?> 
                                <option value="<?php echo View::url('users/login/'.$k); ?>" <?php echo ($segment == $k) ? 'selected' : ''; ?> ><?php echo $v; ?></option>
                            <?php } ?>
                        </select>
                    </div>
                </form>
            </section>
        </div>
    </div>
</div>
<?php View::footer('users'); ?>