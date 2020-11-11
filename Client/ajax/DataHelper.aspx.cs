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
using MLE.Global;

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
                var Marked = new Marked()
                {
                    ExampleId = int_ExampleId,
                    SubcategoryId = int_SubcategoryId,
                };

                db.Marked.Add(Marked);
                db.SaveChanges();
                return true;
            }
        }

        [WebMethod]
        public static string Get(string ExampleId)
        {
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            using (var db = new MLEEntities())
            {
                var userId = LoginHelper.GetUserId();
                var e = db.Marked.Include(x => x.Subcategory).Where(x => x.ExampleId == Int_ExampleId && x.UserId == userId).Select(x => new { EntityId = x.EntityId, ExampleId = x.ExampleId, SentenceId = x.SentenceId, Color = x.Subcategory.Color, SubCategoryId = x.SubcategoryId, Text = x.Text }).ToList();

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
                if (e != null)
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
                if (m != null)
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
            using (var db = new MLEEntities())
            {
                var e = db.Example.FirstOrDefault(x => x.Id == Int_ExampleId);
                if (e != null)
                {
                    e.Content = Content;
                    db.SaveChanges();
                }
            }
        }

        [WebMethod]
        public static bool MarkEntity(string EntityId, string ExampleId, string SentenceId, string SubcategoryId, string InputText, bool isChecked)
        {
            var Int_EntityId = Convert.ToInt32(EntityId);
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            var Int_SentenceId = Convert.ToInt32(SentenceId);
            var Int_SubcategoryId = Convert.ToInt32(SubcategoryId);

            var user = LoginHelper.GetUserId();
            if (user == 0)
                return false;

            using (var db = new MLEEntities())
            {
                var catId = db.Subcategory.FirstOrDefault(x => x.Id == Int_SubcategoryId).CategoryId;
                var ExampleCategory = db.ExampleCategory.FirstOrDefault(x => x.ExampleId == Int_ExampleId && x.CategoryId == catId);
                if (ExampleCategory != null)
                {
                    var ml = db.Marked.Include(x => x.Example.ExampleCategory).Where(x => x.ExampleId == Int_ExampleId /*&& x.SubcategoryId == Int_SubcategoryId*/ && x.EntityId == null && x.SentenceId == null).ToList();
                    if (ml.Count > 0)
                    {
                        var subs = db.Subcategory.Where(x => x.CategoryId == catId).Select(x => x.Id).ToList();
                        var _m = ml.Where(x => subs.Contains(x.SubcategoryId.Value)).ToList();
                        if (_m.Count > 0)
                        {
                            //var _ = ml.FirstOrDefault(x => x.SubcategoryId == Int_SubcategoryId);
                            var m = _m.FirstOrDefault();
                            var typeId = m.Example.ExampleCategory.FirstOrDefault(x => x.CategoryId == catId).TypeId;
                            var type = db.Type.FirstOrDefault(x => x.Id == typeId);
                            if (type.HTML_name == "radio")
                            {
                                m.SubcategoryId = Int_SubcategoryId;
                                db.SaveChanges();
                            }
                            else if (type.HTML_name == "checkbox")
                            {
                                if (isChecked)
                                {
                                    var _ = new Marked()
                                    {
                                        EntityId = null,
                                        ExampleId = Int_ExampleId,
                                        SentenceId = null,
                                        SubcategoryId = Int_SubcategoryId,
                                        UserId = user,
                                        Text = InputText
                                    };
                                    db.Marked.Add(_);
                                    db.SaveChanges();
                                }
                                else
                                {
                                    m = _m.FirstOrDefault(x => x.SubcategoryId == Int_SubcategoryId);
                                    db.Marked.Remove(m);
                                    db.SaveChanges();
                                }
                            }
                            else if (type.HTML_name == "text")
                            {
                                m.Text = InputText;
                                db.SaveChanges();
                            }
                        }
                        else
                        {
                            var _ = new Marked()
                            {
                                EntityId = null,
                                ExampleId = Int_ExampleId,
                                SentenceId = null,
                                SubcategoryId = Int_SubcategoryId != 0 ? Int_SubcategoryId : (int?)null,
                                UserId = user,
                                Text = InputText
                            };
                            db.Marked.Add(_);
                            db.SaveChanges();
                        }
                    }
                    else
                    {
                        var _ = new Marked()
                        {
                            EntityId = null,
                            ExampleId = Int_ExampleId,
                            SentenceId = null,
                            SubcategoryId = Int_SubcategoryId != 0 ? Int_SubcategoryId : (int?)null,
                            UserId = user,
                            Text = InputText
                        };
                        db.Marked.Add(_);
                        db.SaveChanges();
                    }
                    return false;
                }
                else
                {
                    var ml = db.Marked.Include(x => x.Example.Type).Where(x => x.EntityId == Int_EntityId && x.ExampleId == Int_ExampleId && x.SentenceId == Int_SentenceId && x.UserId == user).ToList();
                    var ml_U = db.Marked.Include(x => x.Example.Type).FirstOrDefault(x => x.EntityId == Int_EntityId && x.ExampleId == Int_ExampleId && x.SentenceId == Int_SentenceId && x.UserId == null);
                    if (ml.Count > 0)
                    {
                        var m = ml.FirstOrDefault();
                        var type = m.Example.Type;
                        if (type.HTML_name == "radio")
                        {
                            if (m.SubcategoryId == Int_SubcategoryId)
                            {
                                // provjera ako je automatski unos
                                if (ml_U == null)
                                    db.Marked.Remove(m);
                                else
                                    m.SubcategoryId = null;
                            }
                            else
                                m.SubcategoryId = Int_SubcategoryId;
                            db.SaveChanges();
                        }
                        else if (type.HTML_name == "checkbox")
                        {
                            if (isChecked)
                            {
                                var _ = new Marked()
                                {
                                    EntityId = Int_EntityId,
                                    ExampleId = Int_ExampleId,
                                    SentenceId = Int_SentenceId,
                                    SubcategoryId = Int_SubcategoryId,
                                    UserId = user,
                                    Text = InputText
                                };
                                db.Marked.Add(_);
                                db.SaveChanges();
                            }
                            else
                            {
                                m = ml.FirstOrDefault(x => x.SubcategoryId == Int_SubcategoryId);
                                db.Marked.Remove(m);
                                db.SaveChanges();
                            }
                        }
                        else if (type.HTML_name == "text")
                        {
                            m.Text = InputText;
                            db.SaveChanges();
                        }
                    }
                    else
                    {
                        int? subcategory = Int_SubcategoryId;
                        if (ml_U != null)
                            subcategory = null;

                        var _ = new Marked()
                        {
                            EntityId = Int_EntityId,
                            ExampleId = Int_ExampleId,
                            SentenceId = Int_SentenceId,
                            SubcategoryId = subcategory != 0 ? subcategory : null,
                            UserId = user,
                            Text = InputText
                        };
                        db.Marked.Add(_);
                        db.SaveChanges();
                    }
                    return true;
                }
            }
        }

        [WebMethod]
        public static string GetSubcategoryColor(string SubcategoryId)
        {
            var Int_SubcategoryId = Convert.ToInt32(SubcategoryId);
            using (var db = new MLEEntities())
            {
                var s = db.Subcategory.FirstOrDefault(x => x.Id == Int_SubcategoryId);
                if (s != null)
                    return s.Color;
            }
            return "";
        }

        [WebMethod]
        public static bool ChangeStatus(string ExampleId, string StatusId)
        {
            var Int_ExampleId = Convert.ToInt32(ExampleId);
            var Int_StatusId = Convert.ToInt32(StatusId);
            using (var db = new MLEEntities())
            {
                var e = db.Example.FirstOrDefault(x => x.Id == Int_ExampleId);
                if (e != null)
                {
                    e.StatusId = Int_StatusId;
                    db.SaveChanges();
                    return true;
                }
            }
            return false;
        }
    }
}