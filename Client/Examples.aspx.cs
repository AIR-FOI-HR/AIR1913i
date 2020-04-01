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
        protected List<Example> Examples_NotFinished = new List<Example>();
        protected List<Example> Examples_Finished = new List<Example>();
        protected bool Admin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            // provjeravati koje projekte ima korisnik i prema tome prikazati primjere!! 
            var isAdmin = RestrictionHelper.CheckUser();

            if(isAdmin == null)
                Response.Redirect("/Client/Login.aspx");

            Admin = isAdmin.Value;

            if (Admin)
            {
                var examples = new List<Example>();
                using (var db = new MLEEntities())
                    examples = db.Example.Include(x => x.Category.Subcategory).ToList();

                Examples_NotFinished = examples.Where(x => x.StatusId == 3).OrderBy(x => x.DateCreated).ToList();
                Examples_Finished = examples.Where(x => x.StatusId == 2).OrderBy(x => x.DateCreated).ToList();
                cbHandleEntities.Checked = true;
            }
            else
            {
                // Client
                // TODO:
                // * Get all projects from user
                // * Show examples inside project
            }
        }

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