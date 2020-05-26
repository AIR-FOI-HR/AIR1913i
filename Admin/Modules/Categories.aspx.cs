using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Admin.Modules
{
    public partial class Categories : System.Web.UI.Page
    {

        private int categoryId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].FirstOrDefault().ToString();
                categoryId = int.Parse(str);

                if (categoryId == 0)
                    btnDelete.Visible = false;

                if(categoryId != 0)
                    GetCategoryById(categoryId);
            }
        }

        private List<Category> GetAllCategories()
        {
            using (var db = new MLEEntities())
            {
                return db.Category.ToList();
            }
        }

        private List<Category> PopulateRepeater()
        {
            rpt.DataSource = GetAllCategories();
            rpt.DataBind();

            return GetAllCategories();
        }

        private void GetCategoryById(int id)
        {
            using (var db = new MLEEntities())
            {
                Category _dbCategory = db.Category.Where(c => c.Id == id).FirstOrDefault();
                if(_dbCategory != null)
                {
                    txtCategoryName.Text = _dbCategory.Name;
                    txtDescription.Text = _dbCategory.Description;
                    cbIsActive.Checked = _dbCategory.isActive.Value;    
                }
            }
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                Category _category = new Category()
                {
                    Name = txtCategoryName.Text,
                    Description = txtDescription.Text,
                    isActive = cbIsActive.Checked,
                    //ExampleId = 2
                };

                db.Category.Attach(_category);
                db.Category.Add(_category);

                db.SaveChanges();
            }
        }    

        private void Update()
        {
            using (var db = new MLEEntities())
            {
                Category _dbCategory = db.Category.Where(u => u.Id == categoryId).FirstOrDefault();

                if (_dbCategory != null)
                {
                    db.Category.Attach(_dbCategory);

                    _dbCategory.Name = txtCategoryName.Text;        
                    _dbCategory.Description = txtDescription.Text;
                    _dbCategory.isActive = cbIsActive.Checked;
                    //_dbCategory.ExampleId = 2;

                    db.SaveChanges();
                }
            }
        }

        private void Delete()
        {
            categoryId = int.Parse(Request.QueryString["id"]);


            using (var db = new MLEEntities())
            {
                Category _dbCategory = db.Category.Where(u => u.Id == categoryId).FirstOrDefault();

                List<Subcategory> subcategories = db.Subcategory.Where(c => c.CategoryId == categoryId).ToList();

                if(subcategories.Count != 0)
                {

                    db.Subcategory.RemoveRange(subcategories);
                    db.SaveChanges();
                }


                if(!db.Example.Any(e => e.CategoryId == categoryId))
                {
                    db.Category.Attach(_dbCategory);
                    db.Category.Remove(_dbCategory);
                }

                db.SaveChanges();
            }
        }


        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Save();
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Delete();
            Response.Redirect("Categories.aspx");

            btnDelete.
        }
    }
}