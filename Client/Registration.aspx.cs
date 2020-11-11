using MLE.DB;
using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Client
{
    public partial class Registration : System.Web.UI.Page
    {
        protected bool RegistrationCompleted = false;
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            HandleUser();
            ClearTextboxes();

            RegistrationCompleted = true;
        }

        private void HandleUser()
        {
            using (var db = new MLEEntities())
            {
                var u = new User()
                {
                    Username = txtUsername.Text,
                    Password = LoginHelper.SHA256(txtPassword.Text),
                    FirstName = txtFirstName.Text,
                    LastName = txtLastName.Text,
                    E_mail = txtMail.Text,
                    DateCreated = DateTime.Now,
                    IsActive = true
                };

                db.User.Add(u);
                db.SaveChanges();

                // It's always Client
                // Administator can change it in Admin
                var ur = new UserRole()
                {
                    UserId = u.Id,
                    RoleId = 2
                };

                db.UserRole.Add(ur);
                db.SaveChanges();
            }

            var subject = "MLE registracija";
            var body = "<h3>Da bi se prijavili u sustav, administrator mora pregledati Vašu prijavu!</h3>";
            LoginHelper.SendMail(txtMail.Text, subject, body);
        }

        private void ClearTextboxes()
        {
            txtUsername.Text = String.Empty;
            txtFirstName.Text = String.Empty;
            txtLastName.Text = String.Empty;
            txtMail.Text = String.Empty;
        }

        private void RedirectToLogin()
        {
            Response.Redirect("/Client/Login.aspx");
        }
    }
}