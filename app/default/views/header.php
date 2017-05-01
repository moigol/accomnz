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

        <div class="container body">
            <div class="main_container">
                <?php View::sidebar(); ?>

                <?php View::template('top'); ?>

                