using MLE.DB;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MLE.Client
{
    public partial class DataImport : System.Web.UI.Page
    {
        protected int UploadSuccessful = 0;
        protected int UploadExists = 0;
        protected int UploadError = 0;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLoadData_Click(object sender, EventArgs e)
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
                            var fileIsAlreadyInDB = db.Example.Where(x => x.FileName == file.Name && x.Content == text).FirstOrDefault() != null ? true : false;
                            if (!fileIsAlreadyInDB)
                            {
                                var example = new Example
                                {
                                    FileName = file.Name,
                                    Content = text,
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