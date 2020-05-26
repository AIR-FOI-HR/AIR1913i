using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MLE.Admin
{
    public class UserDetail
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public string Description { get; set; }
        public bool IsAcitve { get; set; }
        public string RoleTitle { get; set; }
    }
}