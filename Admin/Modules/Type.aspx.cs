using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MLE.Admin.program;
using MLE.DB;

namespace MLE.Admin.Modules
{
    public partial class Type : System.Web.UI.Page
    {
        protected int typeId = 0;
        public int Pages = 0;
        private int Skip = 0;
        public int current_page = 1;
        private bool check_page = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateRepeater(true);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                var str = Request.QueryString["id"].ToString();
                typeId = int.Parse(str);

                if (typeId == 0)
                    btnDelete.Visible = false;
                GetTypeByID(typeId);
            }
        }

        private void GetTypeByID(int id)
        {
            using (var db = new MLEEntities())
            {
                var t = db.Type.Where(x => x.Id == id).FirstOrDefault();
                if (t != null)
                {
                    txtName.Text = t.Name;
                    cbActive.Checked = t.Active ?? false;
                }
            }
        }

        private void PopulateRepeater(bool update_pager)
        {
            rpt.DataSource = GetAllTypes(update_pager);
            rpt.DataBind();
        }

        private object GetAllTypes(bool update_pager)
        {
            using (var db = new MLEEntities())
            {
                var types = db.Type.ToList();
                var count = types.Count;
                var default_by_page = 20;
                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                Pages = (int)Math.Ceiling((double)count / (double)default_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * default_by_page;
                if (update_pager)
                    Pager.CreatePager(Pages, current_page, phPager, "Type");

                types = types.Skip(Skip).Take(default_by_page).ToList();
                return types;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] == null)
                return;

            var str = Request.QueryString["id"].ToString();
            typeId = int.Parse(str);

            using (var db = new MLEEntities())
            {
                if (typeId != 0)
                {
                    var t = db.Type.Where(x => x.Id == typeId).FirstOrDefault();
                    if (t != null)
                    {
                        t.Name = txtName.Text;
                        t.Active = cbActive.Checked;
                        db.SaveChanges();
                    }
                }
                else
                {
                    var t = new MLE.DB.Type()
                    {
                        Name = txtName.Text,
                        Active = cbActive.Checked
                    };

                    db.Type.Add(t);
                    db.SaveChanges();
                }
                PopulateRepeater(false);
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] == null)
                return;

            var str = Request.QueryString["id"].ToString();
            typeId = int.Parse(str);

            using (var db = new MLEEntities())
            {
                var t = db.Type.Where(x => x.Id == typeId).FirstOrDefault();
                if (t != null)
                {
                    db.Type.Remove(t);
                    db.SaveChanges();

                    PopulateRepeater(false);
                    Response.Redirect("Type.aspx");
                }
            }
        }
    }
}