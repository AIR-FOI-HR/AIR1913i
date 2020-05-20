using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using MLE.DB;

namespace MLE.Global
{
    public class LoginHelper
    {
        public string username
        {
            get { return HttpContext.Current.User.Identity.Name.ToString(); }
            set { }
        }

        public static bool isValidLogin()
        {
            bool logged = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;

            if (logged == true)
                return true;
            else
                return false;
        }

        public static bool LoginChecker(string user, string pass)
        {
            User User = null;
            using (var db = new MLEEntities())
                User = db.User.Where(x => x.Username == user).FirstOrDefault();

            if(User == null)
                return false;

            if (User.IsActive == false)
                return false;

            if (User.Username == user)
            {
                string passCheck = SHA256(pass);
                if (User.Password == passCheck)
                    return true;
            }

            return false;
        }

        /// <summary>
        /// SHA256 enkripcija
        /// </summary>
        /// <param name="key">Statični ključ</param>
        /// <param name="fields">Password</param>
        /// <returns></returns>
        public static string SHA256(string fields)
        {
            var key = "vmadfklMF45r423dsadbgfs15s";
            var encoding = new ASCIIEncoding();
            var hash = new HMACSHA256(encoding.GetBytes(key));
            var encoding2 = new ASCIIEncoding();

            var array = hash.ComputeHash(encoding2.GetBytes(fields));

            var result = BitConverter.ToString(array).Replace("-", "").ToLower();

            return result;
        }

        public static bool CheckMailAndUsername(string username, string mail)
        {
            using (var db = new MLEEntities())
            {
                var user = db.User.FirstOrDefault(x => x.Username == username || x.E_mail == mail);
                if (user != null)
                    return true;
                else
                    return false;
            }
        }

        public static void SendMail(string mail, string subject, string body)
        {
            MailMessage mailMessage = new MailMessage("tm263327@gmail.com", mail);
            mailMessage.Subject = subject;

            mailMessage.Body = body;
            mailMessage.IsBodyHtml = true;

            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587);
            // LESS SECURE APP ACCESS omogućiti na googleu
            smtpClient.Credentials = new System.Net.NetworkCredential()
            {
                UserName = "tm263327@gmail.com",
                Password = "mailTest321789"
            };
            smtpClient.EnableSsl = true;
            smtpClient.Send(mailMessage);
        }
    }
}