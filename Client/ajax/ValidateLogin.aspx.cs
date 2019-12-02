using MLE.DB;
using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Client.ajax
{
    public partial class ValidateLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static bool ValidatePassword(string user, string pass)
        {
            using (var db = new MLEEntities())
                if (LoginHelper.LoginChecker(user, pass))
                    return true;

            return false;
        }
    }
}