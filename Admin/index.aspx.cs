using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using MLE.DB;

namespace MLE.Admin
{
    public partial class index : System.Web.UI.Page
    {
        protected List<Example> Examples = new List<Example>();
        protected List<Marked> Marked = new List<Marked>();

        protected void Page_Load(object sender, EventArgs e)
        {
            var logged_in = LoginHelper.isValidLogin();
            if (!logged_in)
                Response.Redirect("/Admin/Login.aspx");

            using (var db = new MLEEntities())
            {
                Examples = db.Example.Where(x => x.ProjectId == 12).ToList();
                //for(int i = 0; i < Examples.Count; i++)
                //{
                //    db.Example.Attach(Examples[i]);
                //    Examples[i].OrdinalNumber = i + 1;
                //    db.SaveChanges();
                //}
            }
        }

        protected void btnOdjava_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();

            // clear authentication cookie
            HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie1);

            SessionStateSection sessionStateSection = (SessionStateSection)WebConfigurationManager.GetSection("system.web/sessionState");
            HttpCookie cookie2 = new HttpCookie(sessionStateSection.CookieName, "");
            cookie2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie2);

            Response.Redirect("/Admin/Login.aspx");
        }
    }
}