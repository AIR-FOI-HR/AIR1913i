using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Serialization;
using MLE.DB;

namespace MLE.Admin.Modules
{
    public partial class Examples : System.Web.UI.Page
    {
        private int exampleId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater();

            if (!IsPostBack)
            {
                PopulateDropdownList();
                PopulateCategoryDropdownList();
                PopulateStatusDropdownList();

                txtDateCreated.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {    

            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].ToString();
                exampleId = int.Parse(str);

                /*if (exampleId == 0)
                    btnDelete.Visible = false;*/
                if(exampleId != 0)
                    GetExampleById(exampleId);
            }
        }

        private IList<ExampleDetail> GetAllExamples()
        {
            List<Example> _dbExamples = null;
            IList<ExampleDetail> _exampleDetails = new List<ExampleDetail>();

            using (var db = new MLEEntities())
            {
                _dbExamples = db.Example.ToList();

                foreach (var item in _dbExamples)
                {
                    _exampleDetails.Add(new ExampleDetail()
                    {
                        Id = item.Id,
                        Name = item.Name != null ? item.Name : "",
                        Content = item.Content != null ? item.Content : "",
                        Description = item.Description != null ? item.Description : "",
                        DateCreated = item.DateCreated.Value,
                        ProjectTitle = db.Project.Where(p => p.Id == item.ProjectId).FirstOrDefault().Name,
                        StatusType = db.Status.Where(s => s.Id == item.StatusId).FirstOrDefault().Name,
                        CategoryTitle = db.Category.Where(c => c.Id == item.CategoryId).FirstOrDefault().Name     
                    });
                }

                return _exampleDetails;
            }
        }

        private void GetExampleById(int id)
        {
            using (var db = new MLEEntities())
            {
                Example _dbExample = db.Example.Where(e => e.Id == id).FirstOrDefault();

                if (_dbExample != null)
                {
                    txtName.Text = _dbExample.Name != null ? _dbExample.Name : "";
                    txtContent.Text = _dbExample.Content != null ? _dbExample.Content : "";
                    txtDescription.Text = _dbExample.Description != null ? _dbExample.Description : "";
                    txtDateCreated.Text = _dbExample.DateCreated != null ? _dbExample.DateCreated.Value.ToString("dd.MM.yyyy") : "";
                    //txtTimeSpent.Text = _dbExample.TimeSpent != null ? _dbExample.TimeSpent.ToString() : "";
                    //txtProjectTitle.Text = db.Project.Where(p => p.Id == _dbExample.ProjectId).FirstOrDefault().Name;
                    //txtStatusType.Text = db.Status.Where(p => p.Id == _dbExample.StatusId).FirstOrDefault().Name;
                    //txtCategoryTitle.Text = db.Category.Where(p => p.Id == _dbExample.CategoryId).FirstOrDefault().Name;

                }
            }
        }

        private IList<ExampleDetail> PopulateRepeater()
        {
            rpt.DataSource = GetAllExamples();
            rpt.DataBind();

            return GetAllExamples();
        }      
        
        private IList<Project> PopulateDropdownList()
        {
            IList<Project> _dbProjects = null;

            using (var db = new MLEEntities())
            {
                _dbProjects =  db.Project.ToList();
            }

            projectList.DataSource = _dbProjects;
            projectList.DataTextField = "Name";
            projectList.DataValueField = "Id";
            projectList.DataBind();

            projectList.SelectedIndex = 0;

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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (var db = new MLEEntities())
            {
                Example _example = new Example()
                {
                    Name = txtName.Text,
                    Content = exampleContent.Text,
                    Description = txtDescription.Text,
                    DateCreated = DateTime.Now,
                    TimeSpent = TimeSpan.Zero,
                    ProjectId = int.Parse(projectList.SelectedValue),
                    StatusId = int.Parse(statusList.SelectedValue),
                    CategoryId = int.Parse(categoryList.SelectedValue),
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