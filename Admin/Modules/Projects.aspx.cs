using MLE.DB;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using System.Globalization;
using MLE.Admin.program;

namespace MLE.Admin.Modules
{
    public partial class Projects : System.Web.UI.Page
    {
        protected List<DB.Type> Types = new List<DB.Type>();
        protected List<DB.User> Users = new List<DB.User>();
        protected int projectId = 0;
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
                int.TryParse(str, out projectId);

                if (projectId == 0)
                    btnDelete.Visible = false;
                GetProjectById(projectId);
            }
        }

        private void GetTypesOnProject(MLEEntities db, Project project)
        {
            var e = project.Example.ToList();
            var AllTypes = new List<int>();
            foreach (var _ in e)
                AllTypes.Add(_.TypeId ?? 0);

            AllTypes.Distinct();

            Types = db.Type.Where(x => AllTypes.Contains(x.Id)).ToList();
        }

        private void GetUsersOnProject(MLEEntities db, Project project)
        {
            var u = project.UserProject.Select(x => x.UserId).ToList();
            Users = db.User.Where(x => u.Contains(x.Id)).ToList();
        }

        private List<Project> GetAllProjects(bool update_pager)
        {
            using (var db = new MLEEntities())
            {
                var projects = db.Project.Include(x => x.Example).ToList();
                var count = projects.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)count / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                if (update_pager)
                    Pager.CreatePager(Pages, current_page, phPager, "Projects");

                projects = projects.Skip(Skip).Take(default_by_page).ToList();

                return projects;
            }
        }

        private void GetProjectById(int id)
        {
            using (var db = new MLEEntities())
            {
                Project _dbProject = db.Project.Where(p => p.Id == id).FirstOrDefault();

                PopulateDropDowns(db);

                if (_dbProject != null)
                {
                    GetTypesOnProject(db, _dbProject);
                    GetUsersOnProject(db, _dbProject);
                    txtName.Text = _dbProject.Name != null ? _dbProject.Name : "";
                    txtDescription.Text = _dbProject.Description != null ? _dbProject.Description : "";
                    txtSpentTime.Text = _dbProject.TimeSpent != null ? _dbProject.TimeSpent.ToString() : "";
                    txtDateCreated.Text = _dbProject.DateCreated != null ? _dbProject.DateCreated.Value.ToString("dd.MM.yyyy") : "";
                    txtStartDate.Text = _dbProject.Start_Date != null ? _dbProject.Start_Date.Value.ToString("dd.MM.yyyy") : "";
                    txtEndDate.Text = _dbProject.End_Date != null ? _dbProject.End_Date.Value.ToString("dd.MM.yyyy") : "";
                    ddlStatus.SelectedValue = _dbProject.StatusId != null ? _dbProject.StatusId.Value.ToString() : "1";
                }
            }
        }

        private void PopulateDropDowns(MLEEntities db)
        {
            ddlStatus.DataSource = db.Status.ToList();
            ddlStatus.DataValueField = "Id";
            ddlStatus.DataTextField = "Name";
            ddlStatus.DataBind();

            ddlType.DataSource = db.Type.Where(x => x.Active == true).ToList();
            ddlType.DataValueField = "Id";
            ddlType.DataTextField = "Name";
            ddlType.DataBind();

            ddlUser.DataSource = db.User.Where(x => x.IsActive == true).ToList();
            ddlUser.DataValueField = "Id";
            ddlUser.DataTextField = "Username";
            ddlUser.DataBind();
        }

        private void PopulateRepeater(bool update_pager)
        {
            rpt.DataSource = GetAllProjects(update_pager);
            rpt.DataBind();
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                DateTime.TryParse(txtStartDate.Text, out DateTime start_date);

                DateTime.TryParse(txtEndDate.Text, out DateTime end_date);

                Project _project = new Project()
                {
                    Name = txtName.Text,
                    Description = txtDescription.Text,
                    DateCreated = DateTime.Now,
                    TimeSpent = TimeSpan.Zero,
                    Start_Date = start_date,
                    End_Date = end_date.Year == 0001 ? DateTime.Now : end_date,
                    StatusId = int.Parse(ddlStatus.SelectedValue)
                };

                db.Project.Attach(_project);
                db.Project.Add(_project);

                db.SaveChanges();
            }
        }

        private void Update()
        {
            using (var db = new MLEEntities())
            {
                Project _dbProject = db.Project.Where(u => u.Id == projectId).FirstOrDefault();

                if (_dbProject != null)
                {
                    db.Project.Attach(_dbProject);

                    _dbProject.Name = txtName.Text;
                    _dbProject.Description = txtDescription.Text;
                    //_dbProject.DateCreated = DateTime.ParseExact(txtDateCreated.Text, "dd/MM/yyyy", null);
                    _dbProject.TimeSpent = TimeSpan.Zero;
                    //_dbProject.Start_Date = DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", null);
                    //_dbProject.End_Date = DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", null);
                    _dbProject.StatusId = int.Parse(ddlStatus.SelectedValue);

                    db.SaveChanges();
                }
            }
        }

        private void Delete()
        {
            if (Request.QueryString["id"] != null)
            {
                var id = Request.QueryString["id"].ToString();
                projectId = int.Parse(id);
                using (var db = new MLEEntities())
                {
                    var examples = db.Example.Where(x => x.ProjectId == projectId).ToList();
                    foreach (var item in examples)
                    {
                        var marked = db.Marked.Where(x => x.ExampleId == item.Id).ToList();
                        foreach (var i in marked)
                        {
                            db.Marked.Attach(i);
                            db.Marked.Remove(i);
                            db.SaveChanges();
                        }

                        var ec = db.ExampleCategory.Where(x => x.ExampleId == item.Id).ToList();
                        foreach (var i in ec)
                        {
                            db.ExampleCategory.Attach(i);
                            db.ExampleCategory.Remove(i);
                            db.SaveChanges();
                        }

                        db.Example.Attach(item);
                        db.Example.Remove(item);
                        db.SaveChanges();
                    }

                    var userProject = db.UserProject.Where(x => x.ProjectId == projectId).ToList();
                    foreach (var item in userProject)
                    {
                        db.UserProject.Attach(item);
                        db.UserProject.Remove(item);
                        db.SaveChanges();
                    }

                    Project _dbProject = db.Project.Where(u => u.Id == projectId).FirstOrDefault();
                    db.Project.Attach(_dbProject);
                    db.Project.Remove(_dbProject);
                    db.SaveChanges();
                }

                Response.Redirect("Projects.aspx");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var id = Request.QueryString["id"].ToString();
                if (id != "")
                {
                    projectId = int.Parse(id);
                    if (projectId == 0)
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
            Response.Redirect("Projects.aspx");
        }

        private void ExportToJson(int projectId)
        {
            IList<Example> _projectExampleList = null;
            IList<Marked> _dbMarkedData = new List<Marked>();
            List<ExportData> exportDataList = new List<ExportData>();
            Project dbProject = null;

            using (var db = new MLEEntities())
            {
                dbProject = db.Project.Where(p => p.Id == projectId).FirstOrDefault();
                _projectExampleList = db.Example.Where(e => e.ProjectId == projectId).ToList();

                foreach (var item in _projectExampleList)
                {
                    _dbMarkedData = db.Marked.Where(m => m.ExampleId == item.Id).ToList();

                    for (int i = 0; i < _dbMarkedData.Count; i++)
                    {
                        int subcategoryId = _dbMarkedData[i].SubcategoryId.HasValue ? _dbMarkedData[i].SubcategoryId.Value : 1;

                        ExportData exportData = new ExportData();
                        exportData.ProjectId = item.ProjectId.Value;
                        exportData.ExampleId = _dbMarkedData[i].ExampleId.Value;
                        exportData.SentenceId = _dbMarkedData[i].SentenceId.Value;
                        exportData.EntityId = _dbMarkedData[i].EntityId.Value;
                        exportData.SubCategoryId = _dbMarkedData[i].SubcategoryId.Value;
                        exportData.Sentiment = db.Subcategory.Where(su => su.Id == subcategoryId).FirstOrDefault().Sentiment;

                        exportDataList.Add(exportData);
                    }
                }
            }

            var json = JsonConvert.SerializeObject(exportDataList);

            using (var db = new MLEEntities())
            {
                JsonData jdata = new JsonData();
                jdata.Value = json;
                jdata.DateCreated = DateTime.Now;

                db.JsonData.Attach(jdata);
                db.JsonData.Add(jdata);

                db.SaveChanges();

            }
            //string jsonToTxt = JsonConvert.SerializeObject(exportDataList, Formatting.None);

            string fileName = dbProject.Name + " - json - " + DateTime.Now.ToString("yyyy-MM-dd") + ".txt";
            string filePath = Path.Combine(HttpContext.Current.Server.MapPath("~/JsonData/"), fileName);

            File.WriteAllText(filePath, json);

            FileStream fs = null;

            fs = File.Open(filePath, FileMode.Open);

            byte[] byteFile = new byte[fs.Length];
            fs.Read(byteFile, 0, Convert.ToInt32(fs.Length));
            fs.Close();

            HttpContext context = HttpContext.Current;
            context.Response.Buffer = true;
            context.Response.Clear();
            context.Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
            context.Response.BinaryWrite(byteFile);
            context.Response.End();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            int projectID = int.Parse(Request.QueryString["id"].ToString());

            ExportToJson(projectID);
        }

        protected void btnAddType_Click(object sender, EventArgs e)
        {
            projectId = int.Parse(Request.QueryString["id"].ToString());
            var typeId = int.Parse(ddlType.SelectedValue);

            using (var db = new MLEEntities())
            {
                var t = db.Example.Where(x => x.ProjectId == projectId).ToList();
                foreach (var item in t)
                {
                    db.Example.Attach(item);
                    item.TypeId = typeId;
                    db.SaveChanges();
                }
            }
        }

        protected void btnRemoveType_Click(object sender, EventArgs e)
        {
            projectId = int.Parse(Request.QueryString["id"].ToString());
            var typeId = int.Parse(ddlType.SelectedValue);

            using (var db = new MLEEntities())
            {
                var t = db.Example.Where(x => x.ProjectId == projectId).ToList();
                foreach (var item in t)
                {
                    db.Example.Attach(item);
                    item.TypeId = null;
                    db.SaveChanges();
                }
            }
        }

        protected void btnRemoveUser_Click(object sender, EventArgs e)
        {
            projectId = int.Parse(Request.QueryString["id"].ToString());
            var userId = int.Parse(ddlUser.SelectedValue);

            using (var db = new MLEEntities())
            {
                var up = db.UserProject.FirstOrDefault(x => x.ProjectId == projectId && x.UserId == userId);
                if(up != null)
                {
                    db.UserProject.Remove(up);
                    db.SaveChanges();
                }
            }
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            projectId = int.Parse(Request.QueryString["id"].ToString());
            var userId = int.Parse(ddlUser.SelectedValue);

            using (var db = new MLEEntities())
            {
                var up = new UserProject();
                up.ProjectId = projectId;
                up.UserId = userId;
                db.UserProject.Add(up);
                db.SaveChanges();
            }
        }
    }
}