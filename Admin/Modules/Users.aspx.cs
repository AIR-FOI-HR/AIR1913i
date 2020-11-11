using MLE.Admin.program;
using MLE.DB;
using MLE.Global;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Admin.Modules
{
    public partial class Users : System.Web.UI.Page
    {
        private int userId = 0;
        protected List<DB.Project> Projects = new List<DB.Project>();
        public int Pages = 0;
        private int Skip = 0;
        public int current_page = 1;
        private bool check_page = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater(true);

            if (!IsPostBack)
            {
                PopulateProjectList();
                PopulateDropdownList();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].ToString();
                userId = int.Parse(str);

                if (userId == 0)
                    btnDelete.Visible = false;

                GetUserById(userId);
            }
        }

        private List<User> GetAllUsers(bool update_pager)
        {
            using (var db = new MLEEntities())
            {
                var users = db.User.ToList();
                var count = users.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)count / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                if (update_pager)
                    Pager.CreatePager(Pages, current_page, phPager, "Users");

                users = users.Skip(Skip).Take(default_by_page).ToList();
                return users;
            }
        }

        private void PopulateRepeater(bool update_pager)
        {
            rpt.DataSource = GetAllUsers(update_pager);
            rpt.DataBind();
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
                    GetProjectsOnUser(db, _dbUser);

                    userRole = db.UserRole.Where(u => u.UserId == userId).FirstOrDefault();
                    if (userRole != null)
                        role = db.Role.Where(r => r.Id == userRole.RoleId).FirstOrDefault();

                    txtName.Text = _dbUser.FirstName;
                    txtSurname.Text = _dbUser.LastName;
                    txtEmail.Text = _dbUser.E_mail;
                    txtUsername.Text = _dbUser.Username;
                    //txtPassword.Text = _dbUser.Password;
                    txtDescription.Text = _dbUser.Description;
                    cbIsActive.Checked = _dbUser.IsActive.Value;

                    if (!IsPostBack)
                        roleList.SelectedValue = role != null ? role.Id.ToString() : "1";
                }
            }
        }

        private void GetProjectsOnUser(MLEEntities db, User _dbUser)
        {
            var u = _dbUser.UserProject.Select(x => x.ProjectId).ToList();
            Projects = db.Project.Where(x => u.Contains(x.Id)).ToList();
        }

        private void Save()
        {
            using (var db = new MLEEntities())
            {
                var _user = new User()
                {
                    FirstName = txtName.Text,
                    LastName = txtSurname.Text,
                    E_mail = txtEmail.Text,
                    Username = txtUsername.Text,
                    Password = LoginHelper.SHA256(txtPassword.Text),
                    Description = txtDescription.Text,
                    IsActive = cbIsActive.Checked,
                    DateCreated = DateTime.Now
                };
                db.User.Attach(_user);
                db.User.Add(_user);
                db.SaveChanges();

                var users = db.User.OrderByDescending(u => u.Id).Take(1).ToList();
                var _userRole = new UserRole()
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
                var _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();
                if (_dbUser != null)
                {
                    db.User.Attach(_dbUser);
                    _dbUser.FirstName = txtName.Text;
                    _dbUser.LastName = txtSurname.Text;
                    _dbUser.E_mail = txtEmail.Text;
                    _dbUser.Username = txtUsername.Text;
                    if (txtPassword.Text != "")
                        _dbUser.Password = LoginHelper.SHA256(txtPassword.Text);
                    _dbUser.Description = txtDescription.Text;
                    _dbUser.IsActive = cbIsActive.Checked;
                    db.SaveChanges();
                }

                var _userRole = db.UserRole.Where(u => u.UserId == _dbUser.Id).FirstOrDefault();
                if (_userRole != null)
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
                var _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();
                var userExamples = db.UserProject.Where(ue => ue.UserId == _dbUser.Id).ToList();

                if (userExamples.Count != 0)
                {
                    db.UserProject.RemoveRange(userExamples);
                    db.SaveChanges();
                }

                var _userRole = db.UserRole.Where(ur => ur.UserId == _dbUser.Id).FirstOrDefault();

                db.UserRole.Attach(_userRole);
                db.UserRole.Remove(_userRole);

                db.User.Attach(_dbUser);
                db.User.Remove(_dbUser);

                db.SaveChanges();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var id = Request.QueryString["id"].ToString();
                if (id != "")
                {
                    userId = int.Parse(id);
                    if (userId == 0)
                        Save();
                    else
                        Update();
                }
            }
            PopulateRepeater(false);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"]);

            if (userId != 0)
                Delete();

            Response.Redirect("Users.aspx");
        }

        private IList<Project> PopulateProjectList()
        {
            IList<Project> _dbProjects = null;
            using (var db = new MLEEntities())
                _dbProjects = db.Project.Where(x => x.IsActive == true).ToList();
            return _dbProjects;
        }

        private void PopulateDropdownList()
        {
            IList<Role> _dbRoles = null;
            var projects = new List<Project>();

            using (var db = new MLEEntities())
            {
                _dbRoles = db.Role.ToList();
                projects = db.Project.Where(x => x.IsActive == true).ToList();
            }

            roleList.DataSource = _dbRoles;
            roleList.DataTextField = "Name";
            roleList.DataValueField = "Id";
            roleList.DataBind();
            roleList.SelectedIndex = 0;

            ddlProject.DataSource = projects;
            ddlProject.DataValueField = "Id";
            ddlProject.DataTextField = "Name";
            ddlProject.DataBind();
        }

        protected void btnAddProject_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"].ToString());
            var projectId = int.Parse(ddlProject.SelectedValue);

            using (var db = new MLEEntities())
            {
                var up = new UserProject();
                up.ProjectId = projectId;
                up.UserId = userId;
                db.UserProject.Add(up);
                db.SaveChanges();
            }
        }

        protected void btnRemoveProject_Click(object sender, EventArgs e)
        {
            userId = int.Parse(Request.QueryString["id"].ToString());
            var projectId = int.Parse(ddlProject.SelectedValue);

            using (var db = new MLEEntities())
            {
                var up = db.UserProject.FirstOrDefault(x => x.ProjectId == projectId && x.UserId == userId);
                if (up != null)
                {
                    db.UserProject.Remove(up);
                    db.SaveChanges();
                }
            }
        }
    }
}