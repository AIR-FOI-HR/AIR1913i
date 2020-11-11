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
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected bool MailSent = false;

        protected void btnSendMail_Click(object sender, EventArgs e)
        {
            using (var db = new MLEEntities())
            {
                var u = db.User.FirstOrDefault(x => x.E_mail == txtForgotMail.Text);

                var f = db.ForgotPassword.FirstOrDefault(x => x.UserId == u.Id);
                if(f != null)
                {
                    f.IsValid = false;
                    db.SaveChanges();
                }

                if (u != null)
                {
                    var fp = new DB.ForgotPassword()
                    {
                        UserId = u.Id,
                        InsertedEmail = u.E_mail,
                        DateTime = DateTime.Now,
                        WrongEmail = false,
                        GeneratedKey = LoginHelper.SHA256(u.Id + u.E_mail + DateTime.Now.Ticks),
                        ValidUntil = DateTime.Now.AddDays(1),
                        IsValid = true,
                        IsUsed = false
                    };

                    db.ForgotPassword.Attach(fp);
                    db.ForgotPassword.Add(fp);
                    db.SaveChanges();

                    var subject = "MLE zaboravljena lozinka";
                    var body = "Da biste promijenili lozinku, potrebno je kliknuti na sljedeću poveznicu: <a href='http://mle.s15.novenaweb.info/Client/ChangePassword.aspx?key=" + fp.GeneratedKey + "'>http://mle.s15.novenaweb.info/Client/ChangePassword.aspx?key=" + fp.GeneratedKey + "</a>.<br>Poveznica neće biti valjana nakon 24 sata.";
                    LoginHelper.SendMail(u.E_mail, subject, body);
                }
                else
                {
                    var fp = new DB.ForgotPassword()
                    {
                        InsertedEmail = txtForgotMail.Text,
                        DateTime = DateTime.Now,
                        Description = "Inserted mail is not existing in database. Key not generated!",
                        WrongEmail = true,
                        IsValid = false,
                        IsUsed = false
                    };

                    db.ForgotPassword.Attach(fp);
                    db.ForgotPassword.Add(fp);
                    db.SaveChanges();
                }
            }
            MailSent = true;
            txtForgotMail.Text = String.Empty;
        }
    }
}