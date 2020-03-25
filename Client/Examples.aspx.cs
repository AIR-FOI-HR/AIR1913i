using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;

namespace MLE.Client
{
    public partial class Examples : System.Web.UI.Page
    {
        protected List<Example> Examples_NotFinished = new List<Example>();
        protected List<Example> Examples_Finished = new List<Example>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // provjeravati koje projekte ima korisnik i prema tome prikazati primjere!! 
            using(var db = new MLEEntities())
            {
                var u = db.User.Where(x => x.Username == HttpContext.Current.User.Identity.Name.ToString()).FirstOrDefault();
                if (u != null)
                {
                    var rID = u.UserRole.Where(x => x.UserId == u.Id).Select(x => x.RoleId).FirstOrDefault();

                    //ADMIN
                    if(rID == 1)
                    {
                        var examples = db.Example.Include(x => x.Category.Subcategory).ToList();
                        Examples_NotFinished = examples.Where(x => x.StatusId == 3).OrderBy(x => x.DateCreated).ToList();
                        Examples_Finished = examples.Where(x => x.StatusId == 2).OrderBy(x => x.DateCreated).ToList();
                    }
                    //CLIENT
                    else if(rID == 2)
                    {

                    }
                }
                else
                    Response.Redirect("/Client/Login.aspx");
            }
        }

        protected string GetSubcategory(int id)
        {
            using(var db = new MLEEntities())
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