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
                    txtName.Text = _dbProject.Name != null ? _dbProject.Name : "";
                    txtDescription.Text = _dbProject.Description != null ? _dbProject.Description : "";
                    txtSpentTime.Text = _dbProject.TimeSpent != null ? _dbProject.TimeSpent.ToString() : "";
                    txtDateCreated.Text = _dbProject.DateCreated != null ? _dbProject.DateCreated.Value.ToString("dd.MM.yyyy") : "";
                    txtStartDate.Text = _dbProject.Start_Date != null ? _dbProject.Start_Date.Value.ToString("dd.MM.yyyy") : "";
                    txtEndDate.Text = _dbProject.End_Date != null ? _dbProject.End_Date.Value.ToString("dd.MM.yyyy") : "";
                    txtStatus.Text = _dbProject.StatusId != null ? _dbProject.StatusId.ToString() : "";
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

                    for(int i = 0; i < _dbMarkedData.Count; i++)
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
    }
}