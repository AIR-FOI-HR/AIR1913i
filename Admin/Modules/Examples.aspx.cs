using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using MLE.DB;

namespace MLE.Admin.Modules
{
    public partial class Examples : System.Web.UI.Page
    {
        private int exampleId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].ToString();
                exampleId = int.Parse(str);

                /*if (exampleId == 0)
                    btnDelete.Visible = false;*/
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
                    txtTimeSpent.Text = _dbExample.TimeSpent != null ? _dbExample.TimeSpent.ToString() : "";
                    txtProjectTitle.Text = db.Project.Where(p => p.Id == _dbExample.ProjectId).FirstOrDefault().Name;
                    txtStatusType.Text = db.Status.Where(p => p.Id == _dbExample.StatusId).FirstOrDefault().Name;
                    txtCategoryTitle.Text = db.Category.Where(p => p.Id == _dbExample.CategoryId).FirstOrDefault().Name;

                }
            }
        }

        private IList<ExampleDetail> PopulateRepeater()
        {
            rpt.DataSource = GetAllExamples();
            rpt.DataBind();

            return GetAllExamples();
        }
    }    
}