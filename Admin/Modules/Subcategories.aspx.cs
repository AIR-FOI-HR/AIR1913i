using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using System.Drawing;
using MLE.Admin.program;

namespace MLE.Admin.Modules
{
    public partial class Subcategories : System.Web.UI.Page
    {
        private int subcategoryId = 0;
        protected static int CId = 0;
        public int Pages = 0;
        private int Skip = 0;
        public int current_page = 1;
        private bool check_page = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateDropdownList();
                var categoryId = "";
                if (Request.QueryString["cId"] != null)
                {
                    categoryId = Request.QueryString["cId"].ToString();
                    ddlCategories.SelectedValue = categoryId;
                    CId = int.Parse(categoryId);
                }
            }
            PopulateRepeater(CId, true);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                subcategoryId = int.Parse(Request.QueryString["id"].ToString());
                if (subcategoryId == 0)
                    btnDelete.Visible = false;

                if (subcategoryId != 0)
                    GetSubcategoryById(subcategoryId);
            }
        }

        private void PopulateDropdownList()
        {
            using (var db = new MLEEntities())
            {
                ddlCategories.DataSource = db.Category.ToList();
                ddlCategories.DataTextField = "Name";
                ddlCategories.DataValueField = "Id";
                ddlCategories.DataBind();
                ddlCategories.SelectedValue = CId.ToString();
            }
        }

        private List<Subcategory> GetAllSubcategories(int CId, bool updatePager)
        {
            int id = 0;
            using (var db = new MLEEntities())
            {
                if (CId == 0)
                    id = db.Subcategory.First().Id;
                else
                    id = CId;

                var subcategories = db.Subcategory.Where(x => x.CategoryId == id).Include(x => x.Category).ToList();
                var number_of_examples = subcategories.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)number_of_examples / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                if (updatePager)
                    Pager.CreatePager(Pages, current_page, phPager, "Subcategories", CId);

                subcategories = subcategories.Skip(Skip).Take(default_by_page).ToList();

                return subcategories;
            }
        }

        private void PopulateRepeater(int CId, bool updatePager)
        {
            rpt.DataSource = GetAllSubcategories(CId, updatePager);
            rpt.DataBind();
        }

        private void GetSubcategoryById(int id)
        {
            using (var db = new MLEEntities())
            {
                var _dbSubcategory = db.Subcategory.Where(c => c.Id == id).FirstOrDefault();
                if (_dbSubcategory != null)
                {
                    if (_dbSubcategory.Name != "")
                    {
                        txtSubcategoryName.Text = _dbSubcategory.Name;
                        txtDescription.Text = _dbSubcategory.Description;
                        cbIsActive.Checked = _dbSubcategory.isActive.Value;
                        txtColor.Text = _dbSubcategory.Color;
                        btnColor.BackColor = ColorTranslator.FromHtml(_dbSubcategory.Color);
                    }
                    else
                    {
                        txtSubcategoryName.Text = "TEXT";
                        txtSubcategoryName.Enabled = false;
                        txtDescription.Text = _dbSubcategory.Description;
                        cbIsActive.Checked = _dbSubcategory.isActive.Value;
                        btnColor.BackColor = Color.Transparent;
                        btnColor.Enabled = false;
                        txtColor.Enabled = false;
                    }
                }
            }
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                var sc = new Subcategory()
                {
                    Name = txtSubcategoryName.Text,
                    Description = txtDescription.Text,
                    isActive = cbIsActive.Checked,
                    Color = txtColor.Text,
                    CategoryId = CId
                };

                db.Subcategory.Attach(sc);
                db.Subcategory.Add(sc);
                db.SaveChanges();
            }
        }

        private void Update()
        {
            using (var db = new MLEEntities())
            {
                var sc = db.Subcategory.Where(u => u.Id == subcategoryId).FirstOrDefault();

                if (sc != null)
                {
                    db.Subcategory.Attach(sc);
                    sc.Name = txtSubcategoryName.Text;
                    sc.Description = txtDescription.Text;
                    sc.isActive = cbIsActive.Checked;
                    sc.Color = txtColor.Text;
                    db.SaveChanges();
                }
            }
        }

        private void Delete()
        {
            subcategoryId = int.Parse(Request.QueryString["id"]);
            using (var db = new MLEEntities())
            {
                var sc = db.Subcategory.Where(u => u.Id == subcategoryId).FirstOrDefault();
                db.Subcategory.Remove(sc);
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
                    subcategoryId = int.Parse(id);
                    if (subcategoryId == 0)
                        Save();
                    else
                        Update();
                }
            }
            PopulateRepeater(CId, false);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Delete();
            Response.Redirect("Subcategories.aspx");
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            CId = int.Parse(ddlCategories.SelectedValue);
            Response.Redirect("Subcategories.aspx?cId=" + CId);
        }
    }
}