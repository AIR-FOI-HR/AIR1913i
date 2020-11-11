using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MLE.Admin
{
    public class ExportData
    {
        public int ProjectId { get; set; }
        public int ExampleId { get; set; }
        public int SentenceId { get; set; }
        public int EntityId { get; set; }
        public int SubCategoryId { get; set; }
        public string Sentiment { get; set; }
    }
}