using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MLE.Admin
{
    public class ExampleDetail
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Content { get; set; }
        public string Description { get; set; }
        public DateTime DateCreated { get; set; }
        public string ProjectTitle { get; set; }
        public string StatusType { get; set; }
        public string CategoryTitle { get; set; }
    }
}