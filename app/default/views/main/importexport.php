<?php 
View::$title = 'Import / Export';
View::$bodyclass = User::info('Sidebar');
View::header(); 
$env = Config::get('ENVIRONMENT');
?>
<?php $userinfo = User::info(); ?>

<!-- page content -->
<div class="right_col" role="main">
    <div class="">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2><?php echo View::$title; ?></h2>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">

                            <div class="odeon-tab" role="tabpanel" data-example-id="togglable-tabs">
                                <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">                                    
                                    <li role="presentation"><a href="#tab1" role="tab" data-toggle="tab" aria-expanded="true">Import</a></li>
                                    <li role="presentation"><a href="#tab2" role="tab" data-toggle="tab" aria-expanded="false">Export</a></li>
                                </ul>
                                <div id="myTabContent" class="tab-content">

                                    <div role="tabpanel" class="tab-pane fade active in" id="tab1" aria-labelledby="tab1">
                                    <form class="form-horizontal form-label-left input_mask" enctype="multipart/form-data" method="post">
                                        <ul class="list-group">
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#casefilesIm"> <strong>Casefiles</strong></label>
                                                </div>
                                                <div id="casefilesIm" class="ubofiles">
                                                    <input class="file" type="file" data-min-file-count="1" data-show-upload="false" data-allowed-file-extensions='["csv","txt","xml"]'>
                                                    <button type="submit" class="btn btn-default">Import</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#OptionsIm"> <strong>Options</strong></label>
                                                </div>
                                                <div id="OptionsIm" class="ubofiles">
                                                    <input class="file" type="file" data-min-file-count="1" data-show-upload="false" data-allowed-file-extensions='["csv","txt","xml"]'>
                                                    <button type="submit" class="btn btn-default">Import</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#UsersIm"> <strong>Users</strong></label>
                                                </div>
                                                <div id="UsersIm" class="ubofiles">
                                                    <input class="file" type="file" data-min-file-count="1" data-show-upload="false" data-allowed-file-extensions='["csv","txt","xml"]'>
                                                    <button type="submit" class="btn btn-default">Import</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#RolesIm"> <strong>Reports</strong></label>
                                                </div>
                                                <div id="RolesIm" class="ubofiles">
                                                    <input class="file" type="file" data-min-file-count="1" data-show-upload="false" data-allowed-file-extensions='["csv","txt","xml"]'>
                                                    <button type="submit" class="btn btn-default">Import</button>
                                                </div>    
                                            </li>
                                        </ul>
                                        
                                    </form>
                                    </div>
                                    
                                    <div role="tabpanel" class="tab-pane fade" id="tab2" aria-labelledby="tab2">
                                        <ul class="list-group">
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#casefilesEx"> <strong>Casefiles</strong></label>
                                                </div>
                                                <div id="casefilesEx" class="ubofiles">
                                                    <button type="submit" class="btn btn-default">Export</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#OptionsEx"> <strong>Options</strong></label>
                                                </div>
                                                <div id="OptionsEx" class="ubofiles">
                                                    <button type="submit" class="btn btn-default">Export</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#UsersEx"> <strong>Users</strong></label>
                                                </div>
                                                <div id="UsersEx" class="ubofiles">
                                                    <button type="submit" class="btn btn-default">Export</button>
                                                </div>    
                                            </li>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="uboswitch" rel="#RolesEx"> <strong>Reports</strong></label>
                                                </div>
                                                <div id="RolesEx" class="ubofiles">
                                                    <button type="submit" class="btn btn-default">Export</button>
                                                </div>    
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="ln_solid"></div>
                                <div class="form-group text-center">

                                    <button type="submit" class="btn btn-success">Save Changes</button>
                                </div>
                            </div> -->

                    </div>
                </div>
            </div>
        </div>
        
    </div>
</div>

<?php View::footer(); ?>