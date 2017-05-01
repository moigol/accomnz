<!DOCTYPE html>
<html>
  <head>
    <title><?php echo View::$title . ' | '. Config::get('SITE_TITLE'); ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <?php View::headers(); ?>
    
  </head>
  <body class="login-bg <?php echo View::$bodyclass; ?>">
  	<div class="header">
	     <div class="container">
	        <div class="row">
	           <div class="col-md-12">
	              <!-- Logo -->
	              <div class="logo">
	                 <h1><a href="<?php echo View::url(); ?>"><?php echo Config::get('SITE_TITLE'); ?></a></h1>
	              </div>
	           </div>
	        </div>
	     </div>
	</div>