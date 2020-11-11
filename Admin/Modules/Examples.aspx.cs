using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Serialization;
using MLE.DB;
using System.Data.Entity;
using MLE.Admin.program;

namespace MLE.Admin.Modules
{
    public partial class Examples : System.Web.UI.Page
    {
        protected List<DB.Type> Types = new List<DB.Type>();
        private int exampleId = 0;
        private static int PId = 0;
        public int Pages = 0;
        private int Skip = 0;
        public int current_page = 1;
        private bool check_page = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateDropdownList();
                PopulateCategoryDropdownList();
                PopulateStatusDropdownList();

                var projectId = "";
                if (Request.QueryString["pId"] != null)
                {
                    projectId = Request.QueryString["pId"].ToString();
                    ddlProjects.SelectedValue = projectId;
                    PId = int.Parse(projectId);
                }
                lbDate.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
            }

            PopulateRepeater(PId);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                exampleId = int.Parse(Request.QueryString["id"].ToString());
                /*if (exampleId == 0)
                    btnDelete.Visible = false;*/
                if (exampleId != 0)
                    GetExampleById(exampleId);
            }
        }

        private List<Example> GetAllExamples(int projectId)
        {
            var _dbExamples = new List<Example>();
            using (var db = new MLEEntities())
            {
                if (projectId == 0)
                {
                    var pId = db.Project.First().Id;
                    _dbExamples = db.Example.Where(x => x.ProjectId == pId).Include(x => x.Project).Include(x => x.Category).ToList();
                    check_page = false;
                }
                else
                    _dbExamples = db.Example.Where(x => x.ProjectId == projectId).Include(x => x.Project).Include(x => x.Category).ToList();

                var number_of_examples = _dbExamples.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)number_of_examples / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                Pager.CreatePager(Pages, current_page, phPager, "Examples", PId);

                _dbExamples = _dbExamples.Skip(Skip).Take(default_by_page).ToList();

                return _dbExamples;
            }
        }

        private void GetExampleById(int id)
        {
            using (var db = new MLEEntities())
            {
                var _dbExample = db.Example.Where(e => e.Id == id).FirstOrDefault();
                if (_dbExample != null)
                {
                    txtContent.Text = _dbExample.Content != null ? _dbExample.Content : "";
                    lbText.Text = _dbExample.Content != null ? _dbExample.Content : "";
                    txtDescription.Text = _dbExample.Description != null ? _dbExample.Description : "";
                    //txtDateCreated.Text = _dbExample.DateCreated != null ? _dbExample.DateCreated.Value.ToString("dd.MM.yyyy") : "";

                    if (!IsPostBack)
                    {
                        projectList.SelectedValue = _dbExample.ProjectId != null ? _dbExample.ProjectId.Value.ToString() : "0";
                        categoryList.SelectedValue = _dbExample.CategoryId != null ? _dbExample.CategoryId.Value.ToString() : "0";
                        statusList.SelectedValue = _dbExample.StatusId != null ? _dbExample.StatusId.Value.ToString() : "0";
                        ddlType.SelectedValue = _dbExample.TypeId != null ? _dbExample.TypeId.Value.ToString() : "0";
                    }
                    //txtTimeSpent.Text = _dbExample.TimeSpent != null ? _dbExample.TimeSpent.ToString() : "";
                    //txtProjectTitle.Text = db.Project.Where(p => p.Id == _dbExample.ProjectId).FirstOrDefault().Name;
                    //txtStatusType.Text = db.Status.Where(p => p.Id == _dbExample.StatusId).FirstOrDefault().Name;
                    //txtCategoryTitle.Text = db.Category.Where(p => p.Id == _dbExample.CategoryId).FirstOrDefault().Name;
                }
            }
        }

        private void PopulateRepeater(int projectId)
        {
            rpt.DataSource = GetAllExamples(projectId);
            rpt.DataBind();
        }

        private IList<Project> PopulateDropdownList()
        {
            IList<Project> _dbProjects = null;
            List<DB.Type> types = new List<DB.Type>();

            using (var db = new MLEEntities())
            {
                _dbProjects = db.Project.ToList();
                types = db.Type.Where(x => x.Active == true).ToList();
            }

            projectList.DataSource = _dbProjects;
            projectList.DataTextField = "Name";
            projectList.DataValueField = "Id";
            projectList.DataBind();
            projectList.SelectedIndex = 0;

            ddlProjects.DataSource = _dbProjects;
            ddlProjects.DataTextField = "Name";
            ddlProjects.DataValueField = "Id";
            ddlProjects.DataBind();
            ddlProjects.SelectedValue = PId.ToString();

            ddlType.DataSource = types;
            ddlType.DataTextField = "Name";
            ddlType.DataValueField = "Id";
            ddlType.DataBind();

            return _dbProjects;
        }

        private IList<Status> PopulateStatusDropdownList()
        {
            IList<Status> _dbStatus = null;

            using (var db = new MLEEntities())
            {
                _dbStatus = db.Status.ToList();
            }

            statusList.DataSource = _dbStatus;
            statusList.DataTextField = "Name";
            statusList.DataValueField = "Id";
            statusList.DataBind();

            statusList.SelectedIndex = 0;

            return _dbStatus;
        }

        private IList<Category> PopulateCategoryDropdownList()
        {
            IList<Category> _dbCategories = null;

            using (var db = new MLEEntities())
            {
                _dbCategories = db.Category.ToList();
            }

            categoryList.DataSource = _dbCategories;
            categoryList.DataTextField = "Name";
            categoryList.DataValueField = "Id";
            categoryList.DataBind();

            categoryList.SelectedIndex = 0;

            return _dbCategories;
        }

        protected void projectList_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void statusList_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void categoryList_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                exampleId = int.Parse(Request.QueryString["id"].ToString());

                using (var db = new MLEEntities())
                {
                    if (exampleId != 0)
                    {
                        var _ = db.Example.FirstOrDefault(x => x.Id == exampleId);
                        if (_ != null)
                        {
                            _.Description = txtDescription.Text;
                            _.Content = txtContent.Text;
                            _.ProjectId = int.Parse(projectList.SelectedValue);
                            _.StatusId = int.Parse(statusList.SelectedValue);
                            _.CategoryId = int.Parse(categoryList.SelectedValue);
                            _.TypeId = int.Parse(ddlType.SelectedValue);

                            db.SaveChanges();
                        }
                    }
                    else
                    {

                        Example _example = new Example()
                        {
                            Content = txtContent.Text,
                            Description = txtDescription.Text,
                            DateCreated = DateTime.Now,
                            TimeSpent = TimeSpan.Zero,
                            ProjectId = int.Parse(projectList.SelectedValue),
                            StatusId = int.Parse(statusList.SelectedValue),
                            CategoryId = int.Parse(categoryList.SelectedValue),
                            TypeId = int.Parse(ddlType.SelectedValue),
                            FileName = ""
                        };

                        db.Example.Attach(_example);
                        db.Example.Add(_example);

                        db.SaveChanges();
                    }

                    Response.Redirect("Examples.aspx");
                }
            }
        }

        protected void ddlProjects_SelectedIndexChanged(object sender, EventArgs e)
        {
            PId = int.Parse(ddlProjects.SelectedValue);
            Response.Redirect("Examples.aspx?pId=" + PId);
            //ddlProjects.SelectedValue = PId.ToString();
            //PopulateRepeater(PId);
        }
    }
}