using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MLE.DB;
using MLE.Global;

namespace MLE.Client
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected bool AllowChangingPassword = false;
        protected string Key = "";
        protected List<string> Errors = new List<string>();
        protected DB.ForgotPassword fp = new DB.ForgotPassword();

        protected void Page_Load(object sender, EventArgs e)
        {
            fp = new DB.ForgotPassword();
            if (Request.QueryString["key"] != null)
            {
                Key = Request.QueryString["key"].ToString();
                using (var db = new MLEEntities())
                {
                    fp = db.ForgotPassword.FirstOrDefault(x => x.GeneratedKey == Key);
                    if (fp != null)
                    {
                        // key exists in database
                        if (fp.IsValid == false)
                            Errors.Add("Key is invalid");

                        if (fp.IsUsed == true)
                            Errors.Add("Key is already used");

                        if (fp.ValidUntil < DateTime.Now)
                            Errors.Add("Key expired");

                        if (Errors.Count == 0)
                            AllowChangingPassword = true;
                    }
                    else
                        RedirectToLogin();
                }
            }
            else
                RedirectToLogin();
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            using (var db = new MLEEntities())
            {
                var u = db.User.FirstOrDefault(x => x.Id == fp.UserId);
                if (u != null)
                {
                    u.Password = LoginHelper.SHA256(txtChangePassword.Text);
                    db.SaveChanges();

                    db.ForgotPassword.Attach(fp);
                    fp.IsUsed = true;
                    fp.IsValid = false;
                    db.SaveChanges();
                }
            }

            RedirectToLogin();
        }

        private void RedirectToLogin()
        {
            Response.Redirect("/Client/Login.aspx");
        }
    }
}