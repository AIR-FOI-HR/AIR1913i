using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Admin.Modules
{
    public partial class Projects : System.Web.UI.Page
    {
        private int projectId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].FirstOrDefault().ToString();
                projectId = int.Parse(str);

                if (projectId == 0)
                    btnDelete.Visible = false;
                GetProjectById(projectId);
            }
        }

        private List<Project> GetAllProjects()
        {
            using (var db = new MLEEntities())
            {
                return db.Project.ToList();
            }
        }

        private void GetProjectById(int id)
        {
            using (var db = new MLEEntities())
            {
                Project _dbProject =  db.Project.Where(p => p.Id == id).FirstOrDefault();

                if(_dbProject != null)
                {
                    txtName.Text = _dbProject.Name;
                    txtDescription.Text = _dbProject.Description;
                    txtSpentTime.Text = _dbProject.TimeSpent.ToString();
                    txtDateCreated.Text = _dbProject.DateCreated.Value.ToString("dd.MM.yyyy");
                    txtStartDate.Text = _dbProject.Start_Date.Value.ToString("dd.MM.yyyy");
                    txtEndDate.Text = _dbProject.End_Date.Value.ToString("dd.MM.yyyy");
                    txtStatus.Text = _dbProject.StatusId.ToString();
                }
            }
        }

        private List<Project> PopulateRepeater()
        {
            rpt.DataSource = GetAllProjects();
            rpt.DataBind();

            return GetAllProjects();
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                DateTime.TryParse(txtStartDate.Text, out DateTime start_date);

                DateTime.TryParse(txtEndDate.Text, out DateTime end_date);
                int.TryParse(txtStatus.Text, out int status);

                Project _project = new Project()
                {
                    Name = txtName.Text,
                    Description = txtDescription.Text,
                    DateCreated = DateTime.Now,
                    TimeSpent = TimeSpan.Zero,
                    Start_Date = start_date,
                    End_Date = end_date.Year == 0001 ? DateTime.Now : end_date,
                    StatusId = status
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
                    _dbProject.DateCreated = DateTime.Parse(txtDateCreated.Text);
                    _dbProject.TimeSpent = TimeSpan.Zero;
                    _dbProject.Start_Date = DateTime.Parse(txtStartDate.Text);
                    _dbProject.End_Date = DateTime.Parse(txtStartDate.Text);
                    _dbProject.StatusId = 2;

                    db.SaveChanges();
                }
            }
        }

        private void Delete()
        {
            using (var db = new MLEEntities())
            {
                Project _dbProject = db.Project.Where(u => u.Id == projectId).FirstOrDefault();
                db.Project.Attach(_dbProject);
                db.Project.Remove(_dbProject);

                db.SaveChanges();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Save();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Delete();
        }
    }
}