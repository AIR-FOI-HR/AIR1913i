using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using MLE.Client.program;

namespace MLE.Client
{
    public partial class Examples : System.Web.UI.Page
    {
        public static string Username = "";
        public static int UserID = 0;

        protected List<Example> Examples_NotFinished = new List<Example>();
        protected List<Example> Examples_Finished = new List<Example>();
        protected bool Admin = false;
        protected Project First_Project = new Project();

        protected void Page_Load(object sender, EventArgs e)
        {
            var isAdmin = RestrictionHelper.CheckUser();
            if (isAdmin == null)
                Response.Redirect("/Client/Login.aspx");

            Admin = isAdmin.Value;

            var examples = new List<Example>();
            using (var db = new MLEEntities())
            {
                var ue = db.UserExample.Where(x => x.UserId == UserID).Select(x => x.ExampleId).ToList();
                examples = db.Example.Where(x => ue.Contains(x.Id)).Include(x => x.Category.Subcategory).ToList();

                BindDropDown(db, examples);
            }

            Examples_NotFinished = examples.Where(x => x.StatusId == 3).OrderBy(x => x.DateCreated).ToList();
            Examples_Finished = examples.Where(x => x.StatusId == 2).OrderBy(x => x.DateCreated).ToList();
            cbHandleEntities.Checked = false;
        }

        /// <summary>
        /// Binds dropdownlist for Projects.
        /// </summary>
        private void BindDropDown(MLEEntities db, List<Example> examples)
        {
            var project_ids = examples.Select(x => x.ProjectId).ToList();
            var projects = db.Project.Where(x => project_ids.Contains(x.Id)).ToList();
            First_Project = projects.FirstOrDefault();
            ddlProject.DataSource = projects;
            ddlProject.DataTextField = "Name";
            ddlProject.DataValueField = "Id";
            ddlProject.DataBind();
        }

        /// <summary>
        /// Gets subcategory name.
        /// </summary>
        protected string GetSubcategory(int id)
        {
            using (var db = new MLEEntities())
            {
                var c = db.Subcategory.Where(x => x.Id == id).FirstOrDefault();
                if (c != null)
                    return c.Name;
                else
                    return "";
            }
        }

        /// <summary>
        /// Gets color of subcategory.
        /// </summary>
        protected string GetColor(int id)
        {
            using (var db = new MLEEntities())
            {
                var c = db.Subcategory.Where(x => x.Id == id).FirstOrDefault();
                if (c != null)
                    return c.Color;
                else
                    return "";
            }
        }
    }
}