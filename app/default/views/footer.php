                <!-- footer content -->
                <footer>
                    <div class="container">
                        <p><span class="text-muted">Copyright © <?php echo date('Y'); ?> <a href="<?php echo Config::get('SITE_URI'); ?>"><?php echo Config::get('SITE_TITLE'); ?></a> All rights reserved</span> <span class="text-muted pull-right">MyPHPFrame v<?php echo APPVERSION; ?> beta</span></p>
                    </div>
                    <div class="clearfix"></div>
                </footer>
                <!-- /footer content -->
            </div>
        </div>
        <?php View::footers(); ?>
    </body>
</html>