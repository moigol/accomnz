<?php 
View::$title = 'Trashed Products';
View::$bodyclass = User::info('Sidebar');
View::header(); 
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
                        <?php //View::template('toolboxnav'); ?>
                        <a class="btn btn-warning btn-default pull-right" href="<?php echo View::url('products/add'); ?>">Add Product</a>
                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <?php echo View::getMessage();  ?> 
                        <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive bulk_action nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr class="headings">
                                    <th class="no-sorting"><input type="checkbox" id="check-all" class="flat"></th>
                                    <th class="sort-this">Product ID</th>
                                    <th class="sort-this">Name</th>
                                    <th>Description</th> 
                                    <th class="sort-this">Status</th>  
                                    <th>Date</th>
                                    <th class="no-sorting">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $cntr = 0;
                                if(count($prods)) {
                                foreach($prods as $prod) { $cntr++;
                                ?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <td class="a-center"><input type="checkbox" name="table_records" value="<?php echo $prod->ProductID; ?>" class="flat"></td>
                                    <td>PRD-<?php echo $prod->ProductID; ?></td>
                                    <td><?php echo $prod->ProductName; ?></td>
                                    <td><?php echo $prod->ProductDescription; ?></td>
                                    <td><?php echo ($prod->Active == 1) ? 'Active' : 'Inactive'; ?></td>
                                    <td><?php echo $prod->DateAdded; ?></td>
                                    <td width="120px" class="center">
                                        <?php if($userinfo->Level == 1) { ?>
                                        <a href="<?php echo View::url('products/restore/'.$prod->ProductID); ?>" title="Restore" class="mo-icon green"><span class="fa fa-undo"></span></a>
                                        <a href="<?php echo View::url('products/delete/'.$prod->ProductID); ?>" title="Delete" onclick="return confirm('Are you sure you want to delete this product permanently? If you continue you will be able to undo this action!');" class="mo-icon red"><span class="fa fa-remove"></span></a>
                                        <?php } ?>
                                       
                                    </td>
                                </tr>
                                <?php } 
                                } else {?>
                                <tr class="<?php echo ($cntr % 2) == 0 ? 'even' : 'odd'; ?> pointer">
                                    <!--td class="a-center"><input type="checkbox" name="table_records" value="<?php //echo $user->ProductID; ?>" class="flat"></td-->
                                    <td colspan="9">Trash bin is empty</td>
                                </tr>
                                <?php } ?>
                                
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /page content -->
<?php View::footer(); ?>