using MLE.DB;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using MLE.Client.program;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using System.Reflection;

namespace MLE.Client
{
    public partial class Examples : System.Web.UI.Page
    {
        public string typeinput = "radio";
        public static string Username = "";
        public static int UserID = 0;
        public static int ProjectID = 0;
        protected static Project First_Project = new Project();

        private int Examples_by_page = 0;
        private int Skip = 0;
        public int Pages = 0;
        public int current_page = 1;
        protected List<Example> Examples_NotFinished = new List<Example>();
        protected List<Example> Examples_Finished = new List<Example>();
        protected string Example_Details = "";
        protected bool Admin = false;
        protected string MarkedJSON = "";
        protected int NotFinishedExamples = 0;
        protected int FinishedExamples = 0;
        private static int pID = 0;
        private bool check_page = true;
        private bool show_only_unfinished = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            var isAdmin = RestrictionHelper.CheckUser();
            if (isAdmin == null)
                Response.Redirect("/Client/Login.aspx");
            Admin = isAdmin.Value;

            using (var db = new MLEEntities())
            {
                var user_project = db.UserProject.Where(x => x.UserId == UserID).Select(x => x.ProjectId).ToList();
                var projects = db.Project.Where(x => user_project.Contains(x.Id)).ToList();

                if (Request.QueryString["unfinished"] != null)
                {
                    bool.TryParse(Request.QueryString["unfinished"].ToString(), out show_only_unfinished);
                    cbUnfinishedOnly.Checked = show_only_unfinished;
                }

                if (Request.QueryString["project"] != null)
                {
                    var _pID = Convert.ToInt32(Request.QueryString["project"].ToString());
                    First_Project = _pID != 0 ? db.Project.FirstOrDefault(x => x.Id == _pID) : First_Project;
                    ddlProject.SelectedValue = First_Project.Id.ToString();
                }
                else
                {
                    First_Project = projects.First();
                    check_page = false;
                }

                if (!IsPostBack)
                    BindDropDown(projects);
                else
                {
                    if (hfProjectID.Value != "")
                    {
                        if (pID != Convert.ToInt32(hfProjectID.Value))
                        {
                            pID = Convert.ToInt32(hfProjectID.Value);
                            First_Project = pID != 0 ? db.Project.FirstOrDefault(x => x.Id == pID) : First_Project;
                            ddlProject.SelectedValue = First_Project.Id.ToString();
                            check_page = false;
                        }
                    }
                }

                // checkbox
                if (hfUnfinished.Value != "")
                {
                    bool.TryParse(hfUnfinished.Value, out bool isChecked);
                    cbUnfinishedOnly.Checked = isChecked;
                    show_only_unfinished = isChecked;
                }

                var all_examples = db.Example.Where(x => x.ProjectId == First_Project.Id && (x.StatusId == 3 || x.StatusId == 2));
                NotFinishedExamples = all_examples.Where(x => x.StatusId == 3).ToList().Count;
                FinishedExamples = all_examples.Where(x => x.StatusId == 2).ToList().Count;
                var eCount = NotFinishedExamples + FinishedExamples;
                //var examples = db.Example.Where(x => x.ProjectId == First_Project.Id && x.StatusId == 3).Include(x => x.Category.Subcategory).Include(x => x.Type).Include(x => x.ExampleCategory).OrderBy(x => x.ProjectId).ThenBy(x => x.DateCreated);

                var default_by_page = 50;
                Examples_by_page = First_Project.PerPage != 0 && First_Project.PerPage != null ? (int)First_Project.PerPage : default_by_page;

                current_page = 1;
                if (check_page)
                    if (Request.QueryString["page"] != null)
                        int.TryParse(Request.QueryString["page"].ToString(), out current_page);

                ProjectID = First_Project.Id;
                var number_of_examples = eCount;
                Pages = (int)Math.Ceiling((double)number_of_examples / (double)Examples_by_page);
                current_page = current_page > Pages ? Pages : current_page;
                Skip = (current_page - 1) * Examples_by_page;
                CreatePager(Pages, current_page);

                if (show_only_unfinished)
                    Examples_NotFinished = db.Example.Where(x => x.ProjectId == First_Project.Id && x.StatusId == 3).Include(x => x.Category.Subcategory).Include(x => x.Type).Include(x => x.ExampleCategory).OrderBy(x => x.ProjectId).ThenBy(x => x.DateCreated).Skip(Skip).Take(Examples_by_page).ToList();
                else
                    Examples_NotFinished = db.Example.Where(x => x.ProjectId == First_Project.Id && (x.StatusId == 3 || x.StatusId == 2)).Include(x => x.Category.Subcategory).Include(x => x.Type).Include(x => x.ExampleCategory).OrderBy(x => x.ProjectId).ThenBy(x => x.DateCreated).Skip(Skip).Take(Examples_by_page).ToList();

                var marked = Examples_NotFinished.Select(y => y.Marked.Select(x => new { EntityId = x.EntityId, ExampleId = x.ExampleId, SentenceId = x.SentenceId, Color = x.Subcategory != null ? x.Subcategory.Color : null, SubCategoryId = x.SubcategoryId, Text = x.Text }).ToList()).ToList();
                MarkedJSON = JsonConvert.SerializeObject(marked);

                Example_Details = JsonConvert.SerializeObject(Examples_NotFinished.Select(x => new { x.Id, x.FileName, x.DateCreated }).ToList());
            }
        }

        private void CreatePager(int pages, int current_page)
        {
            var start = current_page - 4;
            var end = current_page + 4;
            if (start <= 0)
            {
                end += Math.Abs(start) + 1;
                start = 1;
            }

            if (end >= pages)
            {
                start -= end - pages;
                start = start < 0 ? 1 : start;
                end = pages;
            }

            //checkbox unfinished
            var unfinished_query = show_only_unfinished ? "&unfinished=" + show_only_unfinished : "";

            if (current_page != 1)
            {
                var first = new LinkButton();
                first.ID = "lbPFirst";
                first.ControlStyle.CssClass = "Parrow fiarrow";
                first.PostBackUrl = "Examples.aspx?project=" + ProjectID + "&page=" + (1) + unfinished_query;
                phPager.Controls.Add(first);

                var back = new LinkButton();
                back.ID = "lbPBack";
                back.PostBackUrl = "Examples.aspx?project=" + ProjectID + "&page=" + (current_page - 1) + unfinished_query;
                back.ControlStyle.CssClass = "Parrow barrow";
                phPager.Controls.Add(back);
            }

            for (int i = start; i <= end; i++)
            {
                var b = new LinkButton();
                b.ID = "btnPager_" + i;
                b.Text = i.ToString();
                b.PostBackUrl = "Examples.aspx?project=" + ProjectID + "&page=" + i + unfinished_query;
                if (current_page == i)
                    b.ControlStyle.CssClass = "current_page";

                phPager.Controls.Add(b);
            }

            if (current_page != pages)
            {
                var front = new LinkButton();
                front.ID = "lbPFront";
                front.ControlStyle.CssClass = "Parrow frarrow";
                front.PostBackUrl = "Examples.aspx?project=" + ProjectID + "&page=" + (current_page + 1) + unfinished_query;
                phPager.Controls.Add(front);

                var last = new LinkButton();
                last.ID = "lbPLast";
                last.ControlStyle.CssClass = "Parrow larrow";
                last.PostBackUrl = "Examples.aspx?project=" + ProjectID + "&page=" + (pages) + unfinished_query;
                phPager.Controls.Add(last);
            }
        }

        private void PagerClicked(object sender, EventArgs e)
        {
            var unfinished_query = show_only_unfinished ? "&unfinished=" + show_only_unfinished : "";
            var b = (LinkButton)sender;
            var page = Regex.Match(b.ID, @"\d+").Value;
            Response.Redirect("Examples.aspx?pId=" + First_Project.Id + "&page=" + page + unfinished_query);
        }

        /// <summary>
        /// Binds dropdownlist for Projects.
        /// </summary>
        private void BindDropDown(List<Project> projects)
        {
            //var project_ids = examples.Select(x => x.ProjectId).ToList();
            ddlProject.DataSource = projects;
            ddlProject.DataTextField = "Name";
            ddlProject.DataValueField = "Id";
            ddlProject.DataBind();
        }

        /// <summary>
        /// Gets subcategory name.
        /// </summary>
        private static List<Tuple<char, string, Subcategory>> taken_chars = new List<Tuple<char, string, Subcategory>>();
        private static int eId = 0;
        protected Tuple<char, string, Subcategory> GetSubcategory(int id, int exampleId)
        {
            using (var db = new MLEEntities())
            {
                var c = db.Subcategory.Where(x => x.Id == id).Include(x => x.Category.Subcategory).FirstOrDefault();
                var e = db.Example.FirstOrDefault(x => x.Id == exampleId);
                if (c != null)
                {
                    if (taken_chars.Count == 0 || taken_chars.LastOrDefault().Item3.CategoryId != c.CategoryId)
                    {
                        if (/*taken_chars.FirstOrDefault() != null && *//*taken_chars.FirstOrDefault().Item3.CategoryId != c.CategoryId*/ eId != e.Id)
                            taken_chars = new List<Tuple<char, string, Subcategory>>();
                        eId = e.Id;

                        var all_subcategories = c.Category.Subcategory.ToList();
                        foreach (var sub in all_subcategories)
                        {
                            var _name = "";
                            char __char = '\0';
                            int j = 0;
                            for (int i = 0; i < sub.Name.Length; i++)
                            {
                                var _char = sub.Name[i];
                                if (!taken_chars.Select(x => x.Item1).Contains(sub.Name.ToLower()[i]) && j == 0)
                                {
                                    _name += "<u id='FL_" + sub.CategoryId + "_" + sub.Id + "'>" + _char + "</u>";
                                    __char = sub.Name.ToLower()[i];
                                    j++;
                                }
                                else
                                    _name += _char;
                            }

                            if (j == 0)
                            {
                                var k = 0;
                                for (int i = 0; i < sub.Id.ToString().Length; i++)
                                {
                                    var _char = sub.Id.ToString()[i];
                                    if (!taken_chars.Select(x => x.Item1).Contains(_char) && k == 0)
                                    {
                                        _name += "<u id='FL_" + sub.CategoryId + "_" + sub.Id + "'>" + _char + "</u>";
                                        __char = _char;
                                        k++;
                                    }
                                    else
                                        _name += _char;
                                }
                            }

                            taken_chars.Add(new Tuple<char, string, Subcategory>(__char, _name, sub));
                        }
                    }

                    var name = taken_chars.FirstOrDefault(x => x.Item3.Id == c.Id);
                    return name;
                }
                else
                    return null;
            }
        }

        /// <summary>
        /// Gets color of subcategory.
        /// </summary>
        protected string GetColor(int id)
        {
            using (var db = new MLEEntities())
            {
                var c = db.Subcategory.Where(x => x.Id == id).FirstOrDefault();
                if (c != null)
                    return c.Color;
                else
                    return "";
            }
        }

        protected List<Subcategory> GetSubcategories(int? catID)
        {
            if (catID == null)
                return new List<Subcategory>();

            using (var db = new MLEEntities())
                return db.Subcategory.Where(x => x.CategoryId == catID).ToList();
        }

        protected string GetTypeName(int? ID)
        {
            if (ID == null)
                return "";

            using (var db = new MLEEntities())
            {
                var t = db.Type.FirstOrDefault(x => x.Id == ID);
                if (t != null)
                    return db.Type.FirstOrDefault(x => x.Id == ID).HTML_name;
                else
                    return "";
            }
        }

        protected string GetCategoryName(int? ID)
        {
            if (ID == null)
                return "";

            using (var db = new MLEEntities())
            {
                var t = db.Category.FirstOrDefault(x => x.Id == ID);
                if (t != null)
                    return db.Category.FirstOrDefault(x => x.Id == ID).Name;
                else
                    return "";
            }
        }

        protected void ddlProject_SelectedIndexChanged(object sender, EventArgs e)
        {
            var unfinished_query = show_only_unfinished ? "&unfinished=" + show_only_unfinished : "";
            Response.Redirect("Examples.aspx?project=" + ddlProject.SelectedValue + unfinished_query);
        }

        protected void cbUnfinishedOnly_CheckedChanged(object sender, EventArgs e)
        {
            // nije složeno
            var unfinished_query = show_only_unfinished ? "&unfinished=" + show_only_unfinished : "";

            var project = 0;
            if (Request.QueryString["project"] != null)
                int.TryParse(Request.QueryString["project"].ToString(), out project);

            var page = 0;
            if (Request.QueryString["page"] != null)
                int.TryParse(Request.QueryString["page"].ToString(), out page);

            if (project != 0 && page != 0)
                Response.Redirect("Examples.aspx?project=" + project + "&page=" + page + unfinished_query);
            else if (project != 0 && page == 0)
                Response.Redirect("Examples.aspx?project=" + project + unfinished_query);
            else
                Response.Redirect("Examples.aspx?project=" + ddlProject.SelectedValue + unfinished_query);
        }
    }
}