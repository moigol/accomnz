<?php $userinfo = User::info(); ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Meta, title, CSS, favicons, etc. -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
        <?php $favicon = View::common()->getUploadedFiles(Option::get('favicon')); ?>
        <link rel="icon" href="<?php echo View::url('assets/files').$favicon[0]->FileSlug; ?>" type="image/png" sizes="16x16"> 
        <title><?php echo View::$title . ' | '. Option::get('site_title',Config::get('SITE_TITLE')); ?></title>
        <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed" rel="stylesheet"> 
        <?php View::headers(); ?>
    </head>
    <body class="<?php echo View::$bodyclass; ?>">
        <div class="header">
            <div class="container">
                <div class="row">
                    <div class="col-md-10">
                        <!-- Logo -->
                        <div class="logo">
                            <h1><a href="<?php echo View::URL(); ?>"><?php echo Option::get('site_title',Config::get('SITE_TITLE')); ?></a></h1>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="navbar navbar-inverse" role="banner">
                            <nav class="collapse navbar-collapse bs-navbar-collapse navbar-right" role="navigation">
                                <ul class="nav navbar-nav">
                                    <li class="dropdown">
                                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">My Account <b class="caret"></b></a>
                                        <ul class="dropdown-menu animated fadeInUp">
                                            <li><a href="profile.html">Profile</a></li>
                                            <li><a href="login.html">Logout</a></li>
                                        </ul>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="page-content">
            <div class="row">
                <div class="col-md-2">
                     <?php View::sidebar(); ?>
                </div>
                <div class="col-md-10">

                



                