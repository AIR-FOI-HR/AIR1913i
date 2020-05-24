<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examples.aspx.cs" Inherits="MLE.Client.Examples" %>

<%@ Register TagName="Menu" TagPrefix="uc" Src="~/Client/Menu.ascx" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>
<script src="/../js/SelectionHelper.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Menu ID="Menu" runat="server" />
        <div class="center content_margins" style="width: 80%;">
            <%--<div class="bold center_text">Primjeri</div>--%>
            <select style="display:none;" id="choose_data" class="center">
                <option value="all">Prikaži sve</option>
                <option value="not_completed" selected="selected">Prikaži u tijeku</option>
                <option value="completed">Prikaži završene</option>
            </select>
            <div class="sidebar">
                <div class="c_sidebar">
                    <div>Hello, <%= Username %>!</div>
                    <div class="help noselect">
                        <span>?</span>
                    </div>
                    <div class="iamhelping noselect">
                        <p>
                            Koristite ENTER / BACKSPACE za skakanje po entitetima!<br />
                            <b>Označi entitete s:</b><br />
                            PLUS +
                            <br />
                            ZERO 0
                            <br />
                            MINUS -
                            <br />
                            Možete koristiti NUMPAD!
                            <br />
                            <b>PageUP</b> i <b>PageDOWN</b> koristite za skakanje po primjerima!
                        </p>
                    </div>

                    <div class="info">
                        <div>
                            <asp:DropDownList ID="ddlProject" runat="server"></asp:DropDownList>
                        </div>
                        <% if (Admin)
                            { %>
                        <div>
                            Uredi entitete
                            <asp:CheckBox ID="cbHandleEntities" ClientIDMode="Static" runat="server" />
                        </div>
                        <%} %>
                        <div>Neoznačeni tekstovi: <%= Examples_NotFinished.Count %></div>
                        <div>Označeni tekstovi: <%= Examples_Finished.Count %></div>
                        <div id="current_example"></div>
                        <div id="current_subcategory"></div>
                    </div>
                </div>
            </div>
            <div>
                <div class="notfinished_left">
                    <div class="custom_margins">
                        <%--<%= Examples_NotFinished.Count > 0 ? "<div class=\"bold u_tijeku\">U TIJEKU</div>" : "" %>--%>
                        <% foreach (var item in Examples_NotFinished)
                            { %>
                        <div class="examples" style="<%= First_Project.Id == item.ProjectId ? "display:block;" : "display:none;" %>">
                            <%= item.Name != null ? "<span class=\"bold\">Naziv: </span>" + item.Name : "" %>
                            <div><span class="bold">Naziv datoteke: </span><%= item.FileName %></div>
                            <div><span class="bold">Kreirano: </span><%= item.DateCreated %></div>
                            <div id="Content_E<%= item.Id %>" data-projectid="<%= item.ProjectId %>" class="content_text"><%= item.Content.Replace(Environment.NewLine, "<br/>") %></div>

                            <div id="Category_E<%= item.Id %>" class="center categories">
                                <% if (item.Category != null && item.Category.Subcategory != null)
                                    { %>
                                <% foreach (var sub in item.Category.Subcategory)
                                    { %>
                                <div id="cat_<%= sub.Id %>" class="category" data-sentiment="<%= sub.Sentiment %>" style="background-color: <%= GetColor(sub.Id) %>"><%= GetSubcategory(sub.Id) %><span style="width: 15px; background-color: lightcyan; float: right;"><%= sub.Sentiment %></span></div>

                                <%} %>
                                <div class="center">
                                    <input class="finish" type="submit" value="Završi" onclick="return FinishExample(<%= item.Id %>);" />
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

<script>
    // handle on keyup
    $(document).on('keydown', function (e) {
        HandleKeyDOWN(e);
    });

    $(document).ready(function () {
        $("#ddlProject").change(function () {
            var projectId = $(this).val();
            $("[id^=Content_E]").each(function () {
                if ($(this).attr('data-projectid') == projectId) {
                    $(this).parent().show();
                }
                else {
                    $(this).parent().hide();
                }
            });
        });

        $(".help").click(function () {
            $(".iamhelping").toggle();
        });

        $(".iamhelping").click(function () {
            $(".iamhelping").toggle();
        });

        // marks marked text from db
        $("div[id^='Content_E']").each(function () {
            var _ = {};
            _.ExampleId = this.id.match(/\d+/).toString();

            $.ajax({
                type: "POST",
                url: "/Client/ajax/DataHelper.aspx/Get",
                data: JSON.stringify(_),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    if (r.d != "") {
                        var obj = jQuery.parseJSON(r.d);
                        for (i = 0; i < obj.length; i++) {
                            $("#Content_E" + obj[i].ExampleId + " #" + obj[i].SentenceId + " #e" + obj[i].EntityId).attr("data-subcategory", obj[i].SubCategoryId);
                            $("#Content_E" + obj[i].ExampleId + " #" + obj[i].SentenceId + " #e" + obj[i].EntityId).css("background-color", obj[i].Color);
                            //$("#Content_E" + obj[i].ExampleId + ":contains('" + obj[i].Text.replace(/[\r\n]+/g, "") + "')").each(function () {
                            //    var regex = new RegExp(obj[i].Text.replace(/[\r\n]+/g, "<br><br>"), 'gi');
                            //    $(this).html($(this).html().replace(regex, "<span style='white-space: pre-line; background-color:" + obj[i].Color + "'>" + obj[i].Text + "</span>"));
                            //});
                        }
                    }
                }
            });
        });

        // marks the word
        WordSelection("content_text");

        $('#choose_data').on('change', function () {
            if (this.value == "all") {
                $(".finished_right").css("display", "table");
                $(".notfinished_left").css("display", "table");
                $(".finished_right").css("width", "50%");
                $(".notfinished_left").css("width", "50%");
            }
            else if (this.value == "completed") {
                $(".notfinished_left").css("display", "none");
                $(".finished_right").css("display", "table");
                $(".finished_right").css("width", "100%");
            }
            else {
                $(".notfinished_left").css("display", "table");
                $(".finished_right").css("display", "none");
                $(".notfinished_left").css("width", "100%");
            }
        });

        // save on category button click
        function Save(id) {
            // no need for this
            return;
            var split = id.split('_');
            var obj = {};
            obj.ExampleId = split[0].match(/\d+/).toString();
            obj.SubcategoryId = split[1].match(/\d+/).toString();
            var color = split[2].toString();
            obj.Selected = getSelectionText(color).toString();

            $.ajax({
                type: "POST",
                url: "/Client/ajax/DataHelper.aspx/Save",
                data: JSON.stringify(obj),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    //alert(r.d);
                }
            });
        }
    });

    // finishes example
    function FinishExample(id) {
        if (confirm('Želite li završiti označavanje?')) {
            var __ = {};
            __.ExampleId = id.toString();

            $.ajax({
                type: "POST",
                url: "/Client/ajax/DataHelper.aspx/Finish",
                data: JSON.stringify(__),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    //alert(r.d);
                    return true;
                }
            });
        }
        else {
            return false;
        }
    }

    function getSelectionText(color) {
        var text = "";
        if (window.getSelection) {
            text = window.getSelection();
        }
        else if (document.selection && document.selection.type != "Control") {
            text = document.selection.createRange().text;
        }

        sel = window.getSelection();
        if (sel.rangeCount && sel.getRangeAt) {
            range = sel.getRangeAt(0);
        }
        // Set design mode to on
        document.designMode = "on";
        if (range) {
            sel.removeAllRanges();
            sel.addRange(range);
        }
        // Colorize text
        document.execCommand("BackColor", false, color);
        // Set design mode to off
        document.designMode = "off";

        return text;
    }
</script>
