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
        public static bool Save(string ExampleId, string SubcategoryId, string SentenceId, string EntityId)
        {
            var int_ExampleId = Convert.ToInt32(ExampleId);
            var int_SubcategoryId = Convert.ToInt32(SubcategoryId);

            using (var db = new MLEEntities())
            {
                //if (Selected != "")
                {
                    var Marked = new Marked()
                    {
                        ExampleId = int_ExampleId,
                        SubcategoryId = int_SubcategoryId,
                        //Text = Selected
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
                var e = db.Marked.Include(x => x.Subcategory).Where(x => x.ExampleId == Int_ExampleId).Select(x => new { EntityId = x.EntityId, ExampleId = x.ExampleId, SentenceId = x.SentenceId, Color = x.Subcategory.Color }).ToList();
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
                var e = db.Example.FirstOrDefault(x => x.Id == Int_ExampleId);
                if(e != null)
                {
                    e.StatusId = 2;
                    db.SaveChanges();
                }
            }
        }

        [WebMethod]
        public static void RemoveMarked(string EntityId, string SentenceId, string TextId)
        {
            var Int_EntityId = Convert.ToInt32(EntityId);
            var Int_SentenceId = Convert.ToInt32(SentenceId);
            var Int_ExampleId = Convert.ToInt32(TextId);

            using (var db = new MLEEntities())
            {
                var m = db.Marked.FirstOrDefault(x => x.EntityId == Int_EntityId && x.SentenceId == Int_SentenceId && x.ExampleId == Int_ExampleId);
                if(m != null)
                {
                    db.Marked.Remove(m);
                    db.SaveChanges();
                }
            }
        }

        [WebMethod]
        public static void SaveEntity(string ExampleId, string Content)
        {
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            using(var db = new MLEEntities())
            {
                var e = db.Example.FirstOrDefault(x => x.Id == Int_ExampleId);
                if(e != null)
                {
                    e.Content = Content;
                    db.SaveChanges();
                }
            }
        }

        [WebMethod]
        public static void MarkEntity(string EntityId, string ExampleId, string SentenceId, string SubcategoryId)
        {
            var Int_EntityId = Convert.ToInt32(EntityId);
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            var Int_SentenceId = Convert.ToInt32(SentenceId);
            var Int_SubcategoryId = Convert.ToInt32(SubcategoryId);

            using (var db = new MLEEntities())
            {
                var m = db.Marked.FirstOrDefault(x => x.EntityId == Int_EntityId && x.ExampleId == Int_ExampleId && x.SentenceId == Int_SentenceId);

                if(m != null)
                {
                    m.SubcategoryId = Int_SubcategoryId;
                    db.SaveChanges();
                }
                else
                {
                    var _ = new Marked()
                    {
                        EntityId = Int_EntityId,
                        ExampleId = Int_ExampleId,
                        SentenceId = Int_SentenceId,
                        SubcategoryId = Int_SubcategoryId
                    };
                    db.Marked.Add(_);
                    db.SaveChanges();
                }
            }
        }

        [WebMethod]
        public static string GetSubcategoryColor(string SubcategoryId)
        {
            var Int_SubcategoryId = Convert.ToInt32(SubcategoryId);
            using(var db = new MLEEntities())
            {
                var s = db.Subcategory.FirstOrDefault(x => x.Id == Int_SubcategoryId);
                if (s != null)
                    return s.Color;
            }
            return "";
        }
    }
}