using MLE.DB;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.IO.Compression;

namespace MLE.Global
{
    public class FileHelper
    {
        public static string ZipPath { get; set; }
        //public static string ZipDestination { get; set; }
        public static string ConfigText { get; set; }
        public static List<string> Default_colors = new List<string>() { "#6ebaef", "#f7904a", "#1fc996", "#f95c99", "#b575e8", "#18c5d3", "#6674fc", "#dd47bf", "#87a7b3", "#f98282", "#3b7db8" };

        public class Config
        {
            public string Project { get; set; }
            public List<Examples> Examples { get; set; }
            public LabelingScheme LabelingScheme { get; set; }
            public int PerPage { get; set; }
        }

        public class LabelingScheme
        {
            public Category ForWords { get; set; }
            public List<Category> ForExample = new List<Category>();
        }

        public class Examples
        {
            public string FileName { get; set; }
        }

        public class Category
        {
            public string CategoryName { get; set; }
            public string Type { get; set; }
            public List<Subcategory> Subcategories = new List<Subcategory>();
        }

        public class Subcategory
        {
            public string Name { get; set; }
            public string Color { get; set; }
        }

        public class FileProcess
        {
            public string Name { get; set; }
            public string Text { get; set; }
        }

        //public static void ExtractZIP()
        //{
        //    System.IO.Compression.ZipFile.ExtractToDirectory(ZipPath, ZipDestination);
        //}

        public static List<FileProcess> ExtractZIPv2()
        {
            var rfs = File.OpenRead(ZipPath);
            var ztb = new byte[rfs.Length];

            var fp = new List<FileProcess>();
            using (Stream data = new MemoryStream(ztb))
            {
                rfs.Read(ztb, 0, (int)rfs.Length);
                var archive = new ZipArchive(data);
                foreach (ZipArchiveEntry entry in archive.Entries)
                {
                    if (entry.FullName.EndsWith(".txt", StringComparison.OrdinalIgnoreCase))
                    {
                        var unzippedEntryStream = entry.Open();
                        var text = "";
                        using(TextReader tr = new StreamReader(unzippedEntryStream))
                            text = tr.ReadToEnd();

                        fp.Add(new FileProcess()
                        {
                            Name = entry.Name,
                            Text = text
                        });
                    }
                }
            }

            return fp;
        }

        //public static void DeleteFilesFromFolder()
        //{
        //    var di = new DirectoryInfo(ZipDestination);
        //    foreach (FileInfo file in di.GetFiles())
        //        file.Delete();
        //}

        public static Config ParseText(string text)
        {
            //var text = System.IO.File.ReadAllText(ZipDestination + "/config.txt");
            return JsonConvert.DeserializeObject<Config>(text);
        }
    }
}