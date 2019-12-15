using MLE.DB;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;

namespace MLE.Client.ajax
{
    public partial class DataHelper : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static bool Save(string ExampleId, string CategoryId, string Selected)
        {
            var int_ExampleId = Convert.ToInt32(ExampleId);
            var int_CategoryId = Convert.ToInt32(CategoryId);

            using (var db = new MLEEntities())
            {
                if (Selected != "")
                {
                    var Marked = new Marked()
                    {
                        ExampleId = int_ExampleId,
                        CategoryId = int_CategoryId,
                        Text = Selected
                    };

                    db.Marked.Add(Marked);
                    db.SaveChanges();
                    return true;
                }
                return false;
            }
        }

        [WebMethod]
        public static string Get(string ExampleId)
        {
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            using (var db = new MLEEntities())
            {
                var e = db.Marked.Include(x => x.Category).Where(x => x.ExampleId == Int_ExampleId).Select(x => new { Text = x.Text, ExampleId = x.ExampleId, CategoryId = x.CategoryId, Color = x.Category.Color }).ToList();
                if (e.Count > 0)
                    return JsonConvert.SerializeObject(e);
                else
                    return "";
            }
        }

        [WebMethod]
        public static void Finish(string ExampleId)
        {
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            using (var db = new MLEEntities())
            {
                var e = db.Example.Where(x => x.Id == Int_ExampleId).FirstOrDefault();
                if(e != null)
                {
                    e.StatusId = 2;
                    db.SaveChanges();
                }
            }
        }
    }
}