using MLE.Client.program;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Client
{
    public partial class Menu : System.Web.UI.UserControl
    {
        protected bool? Admin { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool logged = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
            if (!logged)
                Response.Redirect("/Client/Login.aspx");

            Admin = RestrictionHelper.CheckUser();
        }

        protected void lbOdjava_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();

            var c1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            c1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(c1);

            var sessionStateSection = (SessionStateSection)WebConfigurationManager.GetSection("system.web/sessionState");
            var c2 = new HttpCookie(sessionStateSection.CookieName, "");
            c2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(c2);

            Response.Redirect("/Client/Login.aspx");
        }
    }
}