<?php $userinfo = User::info(); ?>
<!-- top navigation -->
<div class="top_nav">

    <div class="nav_menu">
        <nav class="" role="navigation">
            <div class="nav toggle menu-toggle">
                <a id="menu_toggle"><i class="fa fa-bars"></i></a>
            </div>
            <div id="site-logo" class="nav_title" style="border: 0;">
                <?php 
                    $sitelogo = View::common()->getUploadedFiles(Option::get('site_logo'));
                    $sitelogos = View::common()->getUploadedFiles(Option::get('site_logo_small'));
                ?>
                <a href="<?php echo User::dashboardLink(); ?>" class="site_title" title="<?php echo Config::get('SITE_TITLE'); ?>"><?php View::photo((isset($sitelogo[0]) ? 'files'.$sitelogo[0]->FileSlug : '/images/logo.png'),'',''); ?></a>

                <!-- <a href="<?php echo User::dashboardLink(); ?>" class="site_title" title="<?php echo Config::get('SITE_TITLE'); ?>"><?php View::photo((isset($sitelogo[0]) ? 'files'.$sitelogo[0]->FileSlug : '/images/logo.png'),'','big'); ?><?php View::photo((($sitelogos[0]) ? 'files'.$sitelogos[0]->FileSlug : '/images/logo-s.png'),'','small'); ?></a> -->
            </div>

            <ul class="nav navbar-nav navbar-right">
                <li class="">
                    <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                      
                        <?php $avatar = View::common()->getUploadedFiles($userinfo->Avatar); ?>
                        <?php View::photo((isset($avatar[0]) ? 'files'.$avatar[0]->FileSlug : '/images/user.png'),"Avatar"); ?>
                        <?php echo $userinfo->FirstName; ?> <?php echo $userinfo->LastName; ?>
                        <span class=" fa fa-angle-down"></span>
                    </a>
                    <ul class="dropdown-menu dropdown-usermenu pull-right">
                      <li><a href="<?php View::url('users/profile', true) ?>">  <?php echo Lang::get('HEADER_PROFILE'); ?></a></li>
                      <li><a href="<?php View::url('users/logout', true) ?>"><i class="fa fa-sign-out pull-right"></i> <?php echo Lang::get('HEADER_LOGOUT'); ?></a>
                      </li>
                    </ul>
                </li>
                <li class="">                    
                    <select class="form-control" name="Language" id="LanguageChanger" rel="<?php echo View::url('changelanguage'); ?>">
                        <?php foreach(Utility::getLanguages() as $k => $v) { ?> 
                            <option value="<?php echo $k; ?>" <?php echo (User::info('Language') == $k) ? 'selected' : ''; ?> ><?php echo $v; ?></option>
                        <?php } ?>
                    </select>
                </li>
            </ul>
        </nav>
    </div>

</div>
<!-- /top navigation -->