using MLE.DB;
using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Admin.Modules
{
    public partial class Users : System.Web.UI.Page
    {

        private int userId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater();

            if (!IsPostBack)
            {
                PopulateDropdownList();
                PopulateExampleList(int.Parse(projectList.SelectedValue));
                PopulateRoleDropdownList();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].FirstOrDefault().ToString();
                userId = int.Parse(str);

                if (userId == 0)
                    btnDelete.Visible = false;
                GetUserById(userId);
            }
        }

        private List<User> GetAllUsers()
        {
            using (var db = new MLEEntities())
            {
                return db.User.ToList();
            }
        }

        /*private User GetUserById(int userId)
        {
            using (var db = new MLEEntities())
            {
                return db.User.Where(u => u.Id == userId).FirstOrDefault();
            }
        }*/

        private List<User> PopulateRepeater()
        {
            rpt.DataSource = GetAllUsers();
            rpt.DataBind();

            return GetAllUsers();
        }

        private void GetUserById(int userId)
        {
            using (var db = new MLEEntities())
            {
                User _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();
                UserRole userRole = null;
                Role role = null;

                if (_dbUser != null)
                {

                    userRole = db.UserRole.Where(u => u.Id == userId).FirstOrDefault();
                    if(userRole != null)
                        role= db.Role.Where(r => r.Id == userRole.RoleId).FirstOrDefault();

                    txtName.Text = _dbUser.FirstName;
                    txtSurname.Text = _dbUser.LastName;
                    txtEmail.Text = _dbUser.E_mail;
                    txtUsername.Text = _dbUser.Username;
                    txtPassword.Text = _dbUser.Password;
                    txtDescription.Text = _dbUser.Description;
                    cbIsActive.Checked = _dbUser.IsActive.Value;
                    roleList.SelectedValue = role != null ? role.Id.ToString() : "1";
                }
            }
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                User _user = new User()
                {
                    FirstName = txtName.Text,
                    LastName = txtSurname.Text,
                    E_mail = txtEmail.Text,
                    Username = txtUsername.Text,
                    Password =  LoginHelper.SHA256(txtPassword.Text),
                    Description = txtDescription.Text,
                    IsActive = cbIsActive.Checked,
                    DateCreated = DateTime.Now
                };

                db.User.Attach(_user);
                db.User.Add(_user);

                db.SaveChanges();

                List<User> users = db.User.OrderByDescending(u => u.Id).Take(1).ToList();

                UserRole _userRole = new UserRole()
                {
                    UserId = users[0].Id,
                    RoleId = int.Parse(roleList.SelectedValue)
                };

                db.UserRole.Attach(_userRole);
                db.UserRole.Add(_userRole);

                db.SaveChanges();               
            }
        }

        private void Update()
        {
            using (var db = new MLEEntities())
            {
                User _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();
                
                if(_dbUser != null)
                {
                    db.User.Attach(_dbUser);

                    _dbUser.FirstName = txtName.Text;
                    _dbUser.LastName = txtSurname.Text;            
                    _dbUser.E_mail = txtEmail.Text;
                    _dbUser.Username = txtUsername.Text;                   
                    _dbUser.Password = txtPassword.Text;
                    _dbUser.Description = txtDescription.Text;
                    _dbUser.IsActive = cbIsActive.Checked;

                    db.SaveChanges();
                }

                UserRole _userRole = db.UserRole.Where(u => u.UserId == _dbUser.Id).FirstOrDefault();

                if(_userRole != null)
                {
                    db.UserRole.Attach(_userRole);

                    _userRole.RoleId = int.Parse(roleList.SelectedValue);
                    _userRole.UserId = _dbUser.Id;

                    db.SaveChanges();
                }
            }
        }

        private void Delete()
        {
            using (var db = new MLEEntities())
            {
                User _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();


                UserRole _userRole = db.UserRole.Where(ur => ur.UserId == _dbUser.Id).FirstOrDefault();

                db.UserRole.Attach(_userRole);
                db.UserRole.Remove(_userRole);

                db.User.Attach(_dbUser);
                db.User.Remove(_dbUser);

                db.SaveChanges();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"]);
            
            if(userId != 0)
                Update();
            else
                Save();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"]);

            if (userId != 0)
                Delete();

            Response.Redirect("Users.aspx");
        }

        private IList<Project> PopulateDropdownList()
        {
            IList<Project> _dbProjects = null;

            using (var db = new MLEEntities())
            {
                _dbProjects = db.Project.ToList();
            }

            projectList.DataSource = _dbProjects;
            projectList.DataTextField = "Name";
            projectList.DataValueField = "Id";
            projectList.DataBind();

            projectList.SelectedIndex = 0;

            return _dbProjects;
        }

        private IList<Example> PopulateExampleList(int projectId)
        {
            IList<Example> _dbExamples = null;

            using (var db = new MLEEntities())
            {
                _dbExamples = db.Example.Where(e => e.ProjectId == projectId).ToList();
            }

           if (_dbExamples.Count != 0)
            {
                exampleChckList.DataSource = _dbExamples;
                exampleChckList.DataTextField = "Name";
                exampleChckList.DataValueField = "Id";
                exampleChckList.DataBind();
            }            

            return _dbExamples;
        }

        private IList<Role> PopulateRoleDropdownList()
        {
            IList<Role> _dbRoles = null;

            using (var db = new MLEEntities())
            {
                _dbRoles = db.Role.ToList();
            }

            roleList.DataSource = _dbRoles;
            roleList.DataTextField = "Name";
            roleList.DataValueField = "Id";
            roleList.DataBind();

            roleList.SelectedIndex = 0;

            return _dbRoles;
        }

        protected void projectList_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateExampleList(int.Parse(projectList.SelectedValue));
            show_content.Value = "yes";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"]);

            IList<UserExample> userExampleList = new List<UserExample>();

            using (var db = new MLEEntities())
            {
                foreach (ListItem example in exampleChckList.Items)
                {
                    if (example.Selected)
                        userExampleList.Add(new UserExample()
                        {
                            UserId = userId,
                            ExampleId = int.Parse(example.Value)
                        });
                }

                db.UserExample.AddRange(userExampleList);
                db.SaveChanges();
            }

            Response.Redirect("Users.aspx");
        }
    }
}