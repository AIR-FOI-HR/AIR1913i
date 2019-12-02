using MLE.DB;
using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (var db = new MLEEntities())
            {
                if (LoginHelper.LoginChecker(txtUsername.Text, txtPassword.Text))
                {
                    FormsAuthentication.SetAuthCookie(txtUsername.Text, false);
                    Response.Redirect("/Admin/Modules/Users.aspx");
                }
            }
        }
    }
}