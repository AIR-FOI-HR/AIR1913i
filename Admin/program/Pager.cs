using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace MLE.Admin.program
{
    public class Pager
    {
        public static void CreatePager(int pages, int current_page, PlaceHolder phPager, string page, int PId = 0)
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

            //if (current_page != 1)
            {
                var first = new LinkButton();
                first.ID = "lbPFirst";
                first.ControlStyle.CssClass = current_page != 1 ? "Parrow fiarrow" : "Parrow fiarrow cdisabled";
                first.PostBackUrl = PId != 0 ? page + ".aspx?pId=" + PId + "&page=" + (1) : page + ".aspx?page=" + (1);
                first.Enabled = current_page != 1 ? true : false;
                phPager.Controls.Add(first);

                var back = new LinkButton();
                back.ID = "lbPBack";
                back.PostBackUrl = PId != 0 ? page + ".aspx?pId=" + PId + "&page=" + (current_page - 1) : page + ".aspx?page=" + (current_page - 1);
                back.ControlStyle.CssClass = current_page != 1 ? "Parrow barrow" : "Parrow barrow cdisabled";
                back.Enabled = current_page != 1 ? true : false;
                phPager.Controls.Add(back);
            }

            for (int i = start; i <= end; i++)
            {
                var b = new LinkButton();
                b.ID = "btnPager_" + i;
                b.Text = i.ToString();
                b.PostBackUrl = PId != 0 ? page + ".aspx?pId=" + PId + "&page=" + i : page + ".aspx?page=" + i;
                if (current_page == i)
                    b.ControlStyle.CssClass = "current_page";

                phPager.Controls.Add(b);
            }

            //if (current_page != pages)
            {
                var front = new LinkButton();
                front.ID = "lbPFront";
                front.ControlStyle.CssClass = current_page != pages ? "Parrow frarrow" : "Parrow frarrow cdisabled";
                front.PostBackUrl = PId != 0 ? page + ".aspx?pId=" + PId + "&page=" + (current_page + 1) : page + ".aspx?page=" + (current_page + 1);
                front.Enabled = current_page != pages ? true : false;
                phPager.Controls.Add(front);

                var last = new LinkButton();
                last.ID = "lbPLast";
                last.ControlStyle.CssClass = current_page != pages ? "Parrow larrow" : "Parrow larrow cdisabled";
                last.PostBackUrl = PId != 0 ? page + ".aspx?pId=" + PId + "&page=" + (pages) : page + ".aspx?page=" + (pages);
                last.Enabled = current_page != pages ? true : false;
                phPager.Controls.Add(last);
            }
        }
    }
}