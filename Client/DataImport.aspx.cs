using MLE.DB;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Http;
using Newtonsoft.Json;
using System.Text;
using System.Text.RegularExpressions;
using MLE.Global;
using System.Threading.Tasks;
using System.Drawing;
using System.Threading;
using System.Data.Entity;
using System.Globalization;

namespace MLE.Client
{
    public partial class DataImport : System.Web.UI.Page
    {
        protected int UploadSuccessful = 0;
        protected int UploadExists = 0;
        protected int UploadError = 0;
        private static readonly HttpClient client = new HttpClient();
        private static readonly HttpClient clientS = new HttpClient();

        public class ExampleResponse
        {
            public string[] BreakToSentencesRESTResult { get; set; }
        }

        public class SentenceResponse
        {
            public string[] TokenizeSentenceRESTResult { get; set; }
        }

        protected void btnLoadData_Click(object sender, EventArgs e)
        {
            FileHelper.ZipPath = Server.MapPath("/DataImport/DataImport.zip");
            var fp = FileHelper.ExtractZIPv2();

            var config = fp.First(x => x.Name == "config.txt");
            BreakToSentenceV2Async(FileHelper.ParseText(config.Text), fp);
        }

        private async void BreakToSentenceV2Async(FileHelper.Config conf, List<FileHelper.FileProcess> fp)
        {
            await TokenizationAsync(conf, fp);
        }

        private async Task TokenizationAsync(FileHelper.Config config, List<FileHelper.FileProcess> fp)
        {
            var responseString = "";

            int? ProjectID = null;
            int? CategoryForWords = null;
            int? TypeForWords = null;
            var ExampleCategory = new List<ExampleCategory>();

            using (var db = new MLEEntities())
            {
                var project = new Project();
                project.Name = config.Project;
                project.PerPage = config.PerPage;
                project.Description = "Automatic upload (ZIP)";
                project.DateCreated = DateTime.Now;
                project.Start_Date = DateTime.Now;
                project.StatusId = 3;
                project.IsActive = true;
                db.Project.Add(project);
                db.SaveChanges();

                ProjectID = project.Id;

                ProcessCategory(db, config.LabelingScheme.ForWords, ref TypeForWords, ref CategoryForWords);
                foreach (var item in config.LabelingScheme.ForExample)
                {
                    int? TypeForExample = 0, CategoryForExample = 0;
                    ProcessCategory(db, item, ref TypeForExample, ref CategoryForExample);
                    ExampleCategory.Add(new DB.ExampleCategory { TypeId = TypeForExample, CategoryId = CategoryForExample });
                }
            }

            var counter = 0;
            var list = fp.Where(x => x.Name != "config.txt").OrderBy(x => x.Name.Length).ThenBy(c => c.Name).ToList();
            foreach (var e in list)
            {
                counter++;
                var fname = e.Name;
                var file = fp.FirstOrDefault(x => x.Name == fname);
                //var path = Server.MapPath("/DataImport/export/" + e.FileName);
                if (file != null)
                {
                    var content = POSTOptions(file.Text, false);
                    var response = await client.PostAsync("http://tasservice.s11.novenaweb.info:7777/rest/break-to-sentences", content);
                    //var response = await client.PostAsync("http://tasservice.s11.novenaweb.info:7777/rest/lemmatizes-sentence", content);
                    responseString = await response.Content.ReadAsStringAsync();

                    if (responseString != "")
                    {
                        using (var db = new MLEEntities())
                        {
                            var fileIsAlreadyInDB = db.Example.Where(x => x.FileName == fname && x.ProjectId == ProjectID).FirstOrDefault() != null ? true : false;
                            if (!fileIsAlreadyInDB)
                            {
                                var er = JsonConvert.DeserializeObject<ExampleResponse>(responseString);
                                var example = new Example
                                {
                                    FileName = fname,
                                    //Content = t,
                                    Description = "Automatic upload (ZIP)",
                                    DateCreated = DateTime.Now,
                                    StatusId = 3, // U tijeku
                                    ProjectId = ProjectID,
                                    OrdinalNumber = counter,
                                    // Left sidebar
                                    TypeId = TypeForWords,
                                    CategoryId = CategoryForWords,
                                };

                                db.Example.Attach(example);
                                db.Example.Add(example);
                                db.SaveChanges();

                                // Right sidebar - Fill Example Categories
                                foreach (var item in ExampleCategory)
                                {
                                    var ec = new ExampleCategory();
                                    ec.ExampleId = example.Id;
                                    ec.CategoryId = item.CategoryId;
                                    ec.TypeId = item.TypeId;
                                    db.ExampleCategory.Add(ec);
                                    db.SaveChanges();
                                }

                                string t = "";
                                int startIndex = 0;
                                int endIndex = 0;
                                for (int i = 0; i < er.BreakToSentencesRESTResult.Count(); i++)
                                {
                                    t += "<span id='Content_" + example.Id + "_" + (i + 1) + "'>";

                                    var doc = new HtmlAgilityPack.HtmlDocument();
                                    doc.LoadHtml(er.BreakToSentencesRESTResult[i]);
                                    var nodes = doc.DocumentNode.SelectNodes("//span");

                                    var c = POSTOptions(er.BreakToSentencesRESTResult[i], nodes.Count > 0 ? true : false);
                                    var r = await client.PostAsync("http://tasservice.s11.novenaweb.info:7777/rest/tokenize-sentence", c);
                                    var rs = await r.Content.ReadAsStringAsync();
                                    var sr = JsonConvert.DeserializeObject<SentenceResponse>(rs);

                                    for (int j = 0; j < sr.TokenizeSentenceRESTResult.Count(); j++)
                                    {
                                        var exampleID = example.Id;
                                        var sentenceID = i + 1;
                                        var entityID = j + 1;

                                        var spaceBefore = "<span> </span>";
                                        var spaceAfter = "";
                                        var regex = new Regex(@"[^\w\s]");
                                        int addon = 0;
                                        if (j == 0)
                                        {
                                            spaceBefore = "";
                                            addon = 1;
                                        }

                                        if (regex.Matches(sr.TokenizeSentenceRESTResult[j]).Count == sr.TokenizeSentenceRESTResult[j].Length)
                                            spaceBefore = "";

                                        if (j == sr.TokenizeSentenceRESTResult.Count() - 1)
                                            spaceAfter = "<span> </span>";

                                        endIndex = startIndex + sr.TokenizeSentenceRESTResult[j].Length;

                                        var current_text = sr.TokenizeSentenceRESTResult[j];
                                        var htmldoc = new HtmlAgilityPack.HtmlDocument();
                                        htmldoc.LoadHtml(sr.TokenizeSentenceRESTResult[j]);
                                        var node = htmldoc.DocumentNode.SelectSingleNode("//span");
                                        if (node != null)
                                        {
                                            current_text = node.InnerHtml;
                                            var _class = node.GetClasses().First();
                                            //CategoryForWords
                                            var sc = db.Subcategory.FirstOrDefault(x => x.CategoryId == CategoryForWords && x.Name == _class);
                                            if(sc != null)
                                            {
                                                var m = new Marked()
                                                {
                                                    ExampleId = exampleID,
                                                    SentenceId = sentenceID,
                                                    EntityId = entityID,
                                                    SubcategoryId = sc.Id,
                                                    UserId = null,
                                                    Text = ""
                                                };
                                                db.Marked.Add(m);
                                                db.SaveChanges();
                                            }
                                        }

                                        t += spaceBefore + "<span id='Content_" + exampleID + "_" + sentenceID + "_" + entityID + "' data-startIndex='" + startIndex + "' data-endIndex='" + endIndex + "'>" + current_text + "</span>" + spaceAfter;

                                        var sb = spaceBefore == "<span> </span>" ? 1 : 0;
                                        var sa = spaceAfter == "<span> </span>" ? 1 : 0;

                                        // next start index
                                        startIndex = endIndex + sb + sa + addon;
                                    }

                                    t += "</span>";
                                }

                                db.Example.Attach(example);
                                example.Content = t;
                                db.SaveChanges();

                                UploadSuccessful++;
                            }
                            else
                                UploadExists++;
                        }
                    }
                    else
                        UploadError++;
                }
                else
                    UploadError++;
            }
        }

        private void ProcessPreMarkedWords(string content, MLEEntities db, int exampleID, int sentenceID, int entityID, List<ExampleCategory> exampleCategory, int? categoryForWords)
        {
            var doc = new HtmlAgilityPack.HtmlDocument();
            doc.LoadHtml(content);

            var nodes = doc.DocumentNode.SelectNodes("//span");
            if (nodes == null)
                return;

            foreach (var node in nodes)
            {
                var span_class = node.GetClasses().FirstOrDefault();
                if (span_class != null)
                {
                    var text = node.InnerText;

                    var ec = exampleCategory.Select(x => x.Category.Subcategory).ToList();
                    var cfw = db.Category.Where(x => x.Id == categoryForWords.Value).Select(x => x.Subcategory).ToList();

                    var subcategory = db.Subcategory.FirstOrDefault(x => x.Name == span_class);
                    if (subcategory != null)
                    {
                        var m = new Marked();

                    }
                }
            }
        }

        private void ProcessCategory(MLEEntities db, FileHelper.Category forWords, ref int? TypeID, ref int? CategoryID)
        {
            if (forWords != null)
            {
                var category_name = forWords.CategoryName;
                var type = forWords.Type;

                // FIND type
                var t = db.Type.FirstOrDefault(x => x.HTML_name == type);
                if (t != null)
                    TypeID = t.Id;

                // CHECK and GET / CREATE Category
                var categoryExists = false;
                var categories = db.Category.Include(x => x.Subcategory).Where(x => x.Name == category_name).ToList();
                foreach (var category in categories)
                {
                    if (category != null)
                    {
                        var sub_categories = category.Subcategory.Select(x => x.Name).OrderBy(x => x);
                        var sub_names = forWords.Subcategories.Select(x => x.Name).OrderBy(x => x);
                        if (sub_categories.SequenceEqual(sub_names) || (type == "text" && sub_names.Count() == 0))
                        {
                            categoryExists = true;
                            CategoryID = category.Id;
                            break;
                        }
                    }
                }

                if (CategoryID == null || CategoryID == 0)
                    CreateNewCategory(db, category_name, ref CategoryID);

                if (!categoryExists)
                {
                    if (forWords.Subcategories.Count > 0)
                        // SAVE subcategories only if category is created
                        for (int i = 0; i < forWords.Subcategories.Count; i++)
                            CreateNewSubcategory(db, forWords.Subcategories[i], CategoryID, i + 1);
                    else
                        CreateNewSubcategory(db, null, CategoryID, 0);
                }
            }
        }

        private void CreateNewSubcategory(MLEEntities db, FileHelper.Subcategory subcategory, int? categoryID, int counter)
        {
            var s = new Subcategory();
            var name = "";
            var color = "";
            if (subcategory != null && counter != 0)
            {
                name = subcategory.Name;
                color = subcategory.Color;
                var rnd = new Random();
                if (color == null)
                    if (counter > FileHelper.Default_colors.Count - 1)
                        color = HexConverter(Color.FromArgb(rnd.Next(256), rnd.Next(256), rnd.Next(256)));
                    else
                        color = FileHelper.Default_colors[counter];
            }
            s.Name = name;
            s.Color = color;
            s.CategoryId = categoryID;
            s.Description = "Automatic upload (ZIP)";
            s.isActive = true;
            db.Subcategory.Add(s);
            db.SaveChanges();
        }

        private void CreateNewCategory(MLEEntities db, string category_name, ref int? CategoryID)
        {
            var c = new DB.Category();
            c.isActive = true;
            c.Name = category_name;
            c.Description = "Automatic upload (ZIP)";
            db.Category.Add(c);
            db.SaveChanges();

            CategoryID = c.Id;
        }

        public struct Options
        {
            public string language;
            public bool comprehend_spans;
        }

        private StringContent POSTOptions(string text, bool nodes)
        {
            var data = new Dictionary<string, string>
            {
                { "text", text },
                { "language", "HR" },
                { "comprehend_spans", nodes.ToString().ToLower() }
            };
            return new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
        }

        private static String HexConverter(System.Drawing.Color c)
        {
            return "#" + c.R.ToString("X2") + c.G.ToString("X2") + c.B.ToString("X2");
        }

        private void ImportData()
        {
            var d = new DirectoryInfo(Server.MapPath("/DataImport"));
            var files = d.GetFiles("*.txt");
            foreach (var file in files)
            {
                var path = Server.MapPath("/DataImport/" + file.Name);
                if (File.Exists(path))
                {
                    var reader = File.OpenText(path);
                    var text = reader.ReadToEnd();
                    if (text != null)
                    {
                        using (var db = new MLEEntities())
                        {
                            var fileIsAlreadyInDB = db.Example.Where(x => x.FileName == file.Name || x.Content == text).FirstOrDefault() != null ? true : false;
                            if (!fileIsAlreadyInDB)
                            {
                                var ls = text.Split('.').ToList();
                                var new_text = "";
                                for (int i = 1; i <= ls.Count - 1; i++)
                                    new_text += "<span ID='" + i + "'>" + ls[i] + ".</span>";

                                var example = new Example
                                {
                                    FileName = file.Name,
                                    Content = new_text,
                                    Description = "Uploaded data to Database",
                                    DateCreated = DateTime.Now,
                                    StatusId = 3 // U tijeku
                                };

                                db.Example.Add(example);
                                db.SaveChanges();

                                UploadSuccessful++;
                            }
                            else
                                UploadExists++;
                        }
                    }
                    else
                        UploadError++;
                }
                else
                    UploadError++;
            }
        }
    }
}