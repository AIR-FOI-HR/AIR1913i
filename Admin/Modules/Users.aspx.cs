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
                if (_dbUser != null)
                {
                    txtName.Text = _dbUser.FirstName;
                    txtSurname.Text = _dbUser.LastName;
                    txtEmail.Text = _dbUser.E_mail;
                    txtUsername.Text = _dbUser.Username;
                    txtPassword.Text = _dbUser.Password;
                    txtDescription.Text = _dbUser.Description;
                    cbIsActive.Checked = _dbUser.IsActive.Value;                   
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
            }
        }

        private void Delete()
        {
            using (var db = new MLEEntities())
            {
                User _dbUser = db.User.Where(u => u.Id == userId).FirstOrDefault();
                db.User.Attach(_dbUser);
                db.User.Remove(_dbUser);

                db.SaveChanges();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if(userId != 0)
                Update();
            else
                Save();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (userId != 0)
                Delete();
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

                //db.UserExample.Attach(_userExample);
                //db.UserExample.Add(_userExample);

                db.UserExample.AddRange(userExampleList);
                db.SaveChanges();
            }

            Response.Redirect("Users.aspx");
        }
    }
}