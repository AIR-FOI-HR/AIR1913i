using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using MLE.Admin.program;

namespace MLE.Admin.Modules
{
    public partial class Categories : System.Web.UI.Page
    {
        protected List<Project> RelatedExamples = new List<Project>();
        protected List<Subcategory> SubCategories = new List<Subcategory>();
        private int categoryId = 0;
        public int Pages = 0;
        private int Skip = 0;
        public int current_page = 1;
        private bool check_page = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater(true);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].ToString();
                categoryId = int.Parse(str);

                if (categoryId == 0)
                    btnDelete.Visible = false;

                if (categoryId != 0)
                {
                    GetCategoryById(categoryId);
                    GetRelatedExamples(categoryId);
                    GetSubcategories(categoryId);
                }
            }
        }

        private void GetSubcategories(int categoryId)
        {
            using (var db = new MLEEntities())
                SubCategories = db.Subcategory.Where(x => x.CategoryId == categoryId).ToList();
        }

        private void GetRelatedExamples(int cId)
        {
            using (var db = new MLEEntities())
            {
                RelatedExamples = db.Example.Include(x => x.Project).Where(x => x.CategoryId == cId).Select(x => x.Project).Distinct().OrderBy(x => x.DateCreated).ToList();
                var ec = db.ExampleCategory.Where(x => x.CategoryId == cId).Select(x => x.Example.Project).OrderBy(x => x.DateCreated).Distinct();
                RelatedExamples.AddRange(ec);
            }
        }

        private List<Category> GetAllCategories(bool update_pager)
        {
            using (var db = new MLEEntities())
            {
                var categories = db.Category.ToList();
                var count = categories.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)count / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                if (update_pager)
                    Pager.CreatePager(Pages, current_page, phPager, "Categories");

                categories = categories.Skip(Skip).Take(default_by_page).ToList();
                return categories;
            }
        }

        private void PopulateRepeater(bool update_pager)
        {
            rpt.DataSource = GetAllCategories(update_pager);
            rpt.DataBind();
        }

        private void GetCategoryById(int id)
        {
            using (var db = new MLEEntities())
            {
                Category _dbCategory = db.Category.Where(c => c.Id == id).FirstOrDefault();
                if (_dbCategory != null)
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

                if (subcategories.Count != 0)
                {
                    db.Subcategory.RemoveRange(subcategories);
                    db.SaveChanges();
                }


                if (!db.Example.Any(e => e.CategoryId == categoryId))
                {
                    db.Category.Attach(_dbCategory);
                    db.Category.Remove(_dbCategory);
                }

                db.SaveChanges();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var id = Request.QueryString["id"].ToString();
                if (id != "")
                {
                    categoryId = int.Parse(id);
                    if (categoryId == 0)
                        Save();
                    else
                        Update();
                }
            }
            PopulateRepeater(false);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Delete();
            Response.Redirect("Categories.aspx");
        }
    }
}