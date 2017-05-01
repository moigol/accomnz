<?php
class MediaManager extends Controller
{
    public function __construct()
    {
        parent::__construct();

        // Load model Auth
        $auth = $this->load->model('auth', true);
        if(!$auth->isLoggedIn()) {
            View::redirect('users/login');
        }
        
        // Load vendor class
        $this->load->vendor('gautility');
    }

    public function index()
    {
        $this->model->doSave();

        $this->model->indexAssets();
        $images = $this->model->getFiles();
        View::page('mediamanager/list', get_defined_vars());
    }

    public function delete()
    {
        if(User::can('Delete Media')) {
            $media = $this->model->doDelete($this->segment[2]);
            View::redirect('mediamanager');
        }
    }

    public function edit()
    {
        if(User::can('Edit Media')) {
            $agency = $this->load()->model('agency',true,true);
            $agencies = $agency->getUsers();
            
            $upload = $this->model->doSave();
            
            $fileCategories = $this->model->getFileCategories();
            $this->model->commonAssets();
            $files = $this->model->getFile($this->segment[2]);
            
            View::page('mediamanager/edit', get_defined_vars());
        }
    }

    public function add()
    {
        if(User::can('Add Media')) {
            $agency = $this->load()->model('agency',true,true);
            $agencies = $agency->getUsers();

            $upload = $this->model->doSave();

            $fileCategories = $this->model->getFileCategories();
            $this->model->commonAssets();
            View::page('mediamanager/add', get_defined_vars());
        }
    }

    public function getsubcats()
    {
        $subcats = $this->model->getSubCategoriesRelated($this->segment[2]);
        echo json_encode($subcats);
    }

    public function categories()
    {
        if(User::can('Edit Media')) {
            $this->model->doSave();
            $this->model->indexAssets();
            $categories = $this->model->getFileCategories();
            View::page('mediamanager/categorieslist', get_defined_vars());
        }
    }

    
    public function editcategory()
    {
        if(User::can('Edit Media')) {
            $this->model->doSave();
                
            $this->model->indexAssets();
            $cat = $this->model->getCategory($this->segment[2]);
            $catsubs = $this->model->getSubCategoriesRelated($this->segment[2]); 
            View::page('mediamanager/categoriesedit', get_defined_vars()); 
        }
    }

    public function addcategory()
    {
        if(User::can('Edit Media')) {
            $catdata = $this->model->doSave();            
            $this->model->commonAssets();
            View::page('mediamanager/categoriesadd', get_defined_vars());
        }
    }

    public function deletecategory()
    {
        if(User::can('Edit Media')) {
            $category = $this->model->doDeleteCategory($this->segment[2]);
            View::redirect('mediamanager/categories');
        }
    }

    public function subcategories()
    {
        if(User::can('Edit Media')) {
            $this->model->indexAssets();
            $subcats = $this->model->getSubCategories();
            View::page('mediamanager/subcategorieslist', get_defined_vars());
        }
    }

    public function editsubcategory()
    {
        if(User::can('Edit Media')) {
            $this->model->doSave();
            $CurrentCatID = isset($this->segment[3]) ? $this->segment[3] : '0';    
            $this->model->indexAssets();
            $subcats = $this->model->getSubCategory($this->segment[2]);
            $categories = $this->model->getFileCategories();
            View::page('mediamanager/subcategoriesedit', get_defined_vars()); 
        }
    }

    public function addsubcategory()
    {
        if(User::can('Edit Media')) {
            $CurrentCatID = isset($this->segment[2]) ? $this->segment[2] : '0';
            $subcatdata = $this->model->doSave();            
            $this->model->commonAssets();
            $categories = $this->model->getFileCategories();
            View::page('mediamanager/subcategoriesadd', get_defined_vars());
        }
    }

    public function deletesubcategory()
    {
        if(User::can('Edit Media')) {
            $category = $this->model->doDeleteSubCategory($this->segment[2]);
            View::redirect('mediamanager/editcategory/'.$this->segment[3]);
        }
    }

}