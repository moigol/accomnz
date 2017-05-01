<?php 
View::$title = 'Welcome to '.Config::get('SITE_TITLE');
View::$bodyclass = User::info('Sidebar');
View::header(); 
?>
<?php $userinfo = User::info(); ?>
<!-- page content -->
<div class="right_col" role="main">        
    <div class="">
        <div class="col-md-12 col-sm-12 col-xs-12">

            <div class="row">

                <div class="col-md-3 col-sm-3 col-xs-6">
                    <a href="#">
                    <div class="dash-stat light-shadow green rounded">
                        <span class="dash-stat-icon"><i class="fa fa-check-square-o"></i></span>
                        <div class="dash-stat-cont">
                            <span class="dash-stat-main">143</span>
                            <span class="dash-stat-sub">Book Type</span>
                            <span class="dash-stat-more">Book Type <i class="fa fa-arrow-right"></i></span>
                        </div>
                    </div>
                    </a>
                </div>

                <div class="col-md-3 col-sm-3 col-xs-6">
                    <a href="#">
                    <div class="dash-stat light-shadow teal rounded">
                        <span class="dash-stat-icon"><i class="fa fa-spinner"></i></span>
                        <div class="dash-stat-cont">
                            <span class="dash-stat-main">143</span>
                            <span class="dash-stat-sub">Book Type</span>
                            <span class="dash-stat-more">Book Type <i class="fa fa-arrow-right"></i></span>
                        </div>
                    </div>
                    </a>
                </div>

                <div class="col-md-3 col-sm-3 col-xs-6">
                    <a href="#">
                    <div class="dash-stat light-shadow blue rounded">
                        <span class="dash-stat-icon"><i class="fa fa-play-circle-o"></i></span>
                        <div class="dash-stat-cont">
                            <span class="dash-stat-main">143</span>
                            <span class="dash-stat-sub">Book Type</span>
                            <span class="dash-stat-more">Book Type <i class="fa fa-arrow-right"></i></span>
                        </div>
                    </div>
                    </a>
                </div>

                <div class="col-md-3 col-sm-3 col-xs-6">
                    <a href="#">
                    <div class="dash-stat light-shadow red rounded">
                        <span class="dash-stat-icon"><i class="fa fa-thumbs-down"></i></span>
                        <div class="dash-stat-cont">
                            <span class="dash-stat-main">143</span>
                            <span class="dash-stat-sub">Book Type</span>
                            <span class="dash-stat-more">Book Type <i class="fa fa-arrow-right"></i></span>
                        </div>
                    </div>
                    </a>
                </div>

            </div>
        </div>

    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>