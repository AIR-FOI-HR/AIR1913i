using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MLE.Client.program
{
    public static class RestrictionHelper
    {
        public static bool? CheckUser()
        {
            using (var db = new MLEEntities())
            {
                var u = db.User.Where(x => x.Username == HttpContext.Current.User.Identity.Name.ToString()).FirstOrDefault();
                if (u != null)
                {
                    var rID = u.UserRole.Where(x => x.UserId == u.Id).Select(x => x.RoleId).FirstOrDefault();

                    //ADMIN
                    if (rID == 1)
                        return true;
                    //CLIENT
                    else if (rID == 2)
                        return false;
                }
                else
                    return null;
            }

            return null;
        }
    }
}