<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examples.aspx.cs" Inherits="MLE.Client.Examples" %>

<%@ Register TagName="Menu" TagPrefix="uc" Src="~/Client/Menu.ascx" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>
<script src="js/SelectionHelper.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Menu ID="Menu" runat="server" />
        <div class="center content_margins" style="width: 80%;">
            <%--<div class="bold center_text">Primjeri</div>--%>
            <select style="display: none;" id="choose_data" class="center">
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
                        <div>
                            Za pomicanje po riječima koristite strelice na tipkovnici ili miš!<br />
                            Svaka kategorija ima vodeće slovo čijim se pritiskom označava odabrana riječ.<br />
                            Odabir više riječi se vrši pritiskom na SHIFT i pomicanjem strelica (lijevo/desno) ili odabirom teksta mišem.<br />
                            Enterom označavate status primjera na kojem se nalazi kursor - završeno/nezavršeno (klikom mišem na kućicu ili kvačicu također mijenjate status primjera)<br /><br />
                            <b>Komande na tipkovnici:</b><br />
                            PageUP = prethodni primjer<br />
                            PageDOWN = sljedeći primjer<br />
                            HOME = prva riječ u primjeru<br />
                            END = zadnja riječ u primjeru<br />
                            CTRL + HOME = prva riječ u prvom primjeru<br />
                            CTRL + END = prva riječ u zadnjem primjeru<br />
                            SHIFT + ARROW(lijevo/desno) = označavanje više riječi<br />
                            ESC = zatvori helpbar (ili klik mišem na helpbar)
                        </div>
                    </div>

                    <div class="info">
                        <div>
                            <asp:DropDownList ID="ddlProject" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlProject_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <%--<% if (Admin)
                            { %>
                        <div>
                            Uredi entitete
                            <asp:CheckBox ID="cbHandleEntities" ClientIDMode="Static" runat="server" />
                        </div>
                        <%} %>--%>
                        <div>Neoznačeni: <span id="unfinished"><%= NotFinishedExamples %></span></div>
                        <div>Označeni: <span id="finished"><%= FinishedExamples %></span></div>
                        <div>Samo nezavršeni:
                            <asp:CheckBox ID="cbUnfinishedOnly" runat="server" AutoPostBack="true" OnCheckedChanged="cbUnfinishedOnly_CheckedChanged" />
                        </div>
                        <div id="current_example"></div>
                        <div id="current_subcategory"></div>
                    </div>
                </div>
            </div>
            <div>
                <div class="notfinished_left">
                    <div class="custom_margins">
                        <%--<%= Examples_NotFinished.Count > 0 ? "<div class=\"bold u_tijeku\">U TIJEKU</div>" : "" %>--%>
                        <% int? ProjectID = 0;%>
                        <% foreach (var item in Examples_NotFinished)
                            {
                                if (item.ProjectId != ProjectID)
                                    ProjectID = item.ProjectId;
                        %>
                        <div class="examples noselectColor" style="/*<%= First_Project.Id == item.ProjectId ? "display:block;": "display:none;" %>*/">
                            <%--<%= item.Name != null ? "<span class=\"bold\">Naziv: </span>" + item.Name : "" %>--%>
                            <%--<div><span class="bold">Naziv datoteke: </span><%= item.FileName %></div>
                            <div><span class="bold">Kreirano: </span><%= item.DateCreated %></div>--%>
                            <span class="ex_counter_<%= item.Id %> start_number"><span class="arrow_r" style="color: transparent;">⯈</span><%= item.OrdinalNumber %>.</span>
                            <div id="Content_<%= item.Id %>" data-projectid="<%= item.ProjectId %>" class="content_text">
                                <%= item.Content.Replace(Environment.NewLine, "<br/>") %>
                            </div>
                            <div class="ex_status">
                                <span style="position: absolute; bottom: 0;">
                                    <input id="btn_<%= item.Id %>" type="submit" class="button_status noselect" onclick="ChangeStatus(this); return false;" value="<%= item.StatusId == 2 ? "✔" : "☐" %>" />
                                </span>
                            </div>

                            <%-- LEFT SIDEBAR --%>

                            <div id="Category_E<%= item.Id %>" class="center categories">
                                <% if (item.Category != null && item.Category.Subcategory != null)
                                    { %>
                                <% if (item.TypeId == 1)
                                    { %>
                                <div class="category">
                                    <input type="<%= item.Type.HTML_name %>" style="float: right;" oninput="MarkText(this);" id="txt_input" />
                                </div>
                                <%}
                                    else
                                    { %>
                                <% foreach (var sub in item.Category.Subcategory)
                                    { %>
                                <div id="cat_<%= sub.Id %>" class="category" <%--data-sentiment="<%= sub.Sentiment %>"--%> style="background-color: <%= GetColor(sub.Id) %>">
                                    <label for="cat_<%= item.Category.Id%>"></label>
                                    <label class="radioz">
                                        <%= GetSubcategory(sub.Id, item.Id).Item2 %>
                                        <span></span>
                                        <input id="rb_<%= sub.Id %>" type="<%= item.Type.HTML_name %>" onclick="Mark(<%= sub.Id %>, this);" style="float: right;" name="cat_<%= item.Category.Id %>" />
                                    </label>
                                </div>
                                <%} %>
                                <input id="rb_dummy" type="radio" style="display: none;" name="cat_<%= item.Category.Id %>" />
                                <%} %>
                                <%} %>
                            </div>

                            <%-- RIGHT SIDEBAR --%>

                            <div id="rsidebar_<%= item.Id %>" class="center categories_right">
                                <% foreach (var EC in item.ExampleCategory.Where(x => x.ExampleId == item.Id))
                                    { %>
                                <div><%= GetCategoryName(EC.CategoryId) %></div>
                                <% foreach (var C in GetSubcategories(EC.CategoryId))
                                    { %>

                                <div id="cat_<%= C.Id %>" class="categoryR" <%--style="background-color: <%= GetColor(C.Id) %>"--%>>
                                    <label class="radioz">
                                        <input id="rbv_<%= C.Id %>" type="<%= GetTypeName(EC.TypeId) %>" <%= EC.TypeId == 1 ? "oninput=\"MarkTextOnExample(this);\"" : "onclick=\"Mark(" + C.Id + ", this);\"" %> name="ex_<%= item.Id %>_cat_<%= item.Category.Id %>" />
                                        <%= GetSubcategory(C.Id, item.Id).Item2 %><span style="width: 15px; background-color: lightcyan; float: right;"><%= C.Sentiment %></span>
                                    </label>
                                </div>

                                <%} %>
                                <div style="margin-bottom: 20px;"></div>
                                <%} %>
                                <%if (item.ExampleCategory.Where(x => x.ExampleId == item.Id).Count() > 0)
                                    { %>
                                <div style="margin-bottom: 50px;"></div>
                                <%} %>
                                <div id="ex_desc" class="bottom">
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                        </div>
                        <%} %>
                        <div id="Description_MouseOver"></div>
                        <%if (Pages > 1)
                            { %>
                        <div class="pager">
                            <asp:PlaceHolder ID="phPager" runat="server"></asp:PlaceHolder>
                            <div style="clear: both;"></div>
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hfUnfinished" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hfProjectID" ClientIDMode="Static" runat="server" />
    </form>
</body>
</html>

<script>
    // handle on keyup
    $(document).on('keydown', function (e) {
        HandleKeyDOWN(e);
    });

    $(document).on('keyup', function (e) {
        HandleKeyUP(e);
    });

    $(document).keypress(function (e) {
        HandleKeyPress(e);
    });

    var listOfCategories = [];
    $(document).ready(function () {
        $("[id^=FL_]").each(function () {
            var ids = $(this).attr("id").split("_");
            var exampleId = $(this).parent().parent().parent().attr("id").match(/\d+/).toString();
            var shortcut = $(this).text().toLowerCase();
            listOfCategories.push({ ExampleId: exampleId, CategoryID: ids[1], SubCategoryID: ids[2], Shortcut: shortcut });
        });
    });

    var ExampleDetails = [];
    // document load
    $(document).ready(function () {
        ExampleDetails = JSON.parse('<%= Example_Details %>');

        // right sidebar
        for (i = 0; i < ExampleDetails.length; i++) {
            var e = ExampleDetails[i];
            var date = new Date(e.DateCreated);

            var fileName = "<div>" + e.FileName + "</div>";
            var nameAndID = "<div class='other_desc od_t'>ID=" + e.Id + "</div>";
            var created = "<div class='other_desc od_b'>Kreirano: " + date.getDay() + "." + date.getMonth() + "." + date.getFullYear() + " " + date.getHours() + ":" + date.getMinutes() + "</div>";

            $("#rsidebar_" + e.Id + " #ex_desc").html(fileName + nameAndID + created);
            $("#rsidebar_" + e.Id).height($("#rsidebar_" + e.Id).parent().height());
            $("#rsidebar_" + e.Id).parent().find(".ex_status").height($("#rsidebar_" + e.Id).parent().find(".content_text").height());
        }
        $(".ex_status").show();

        $("#ddlProject").change(function () {
            var projectId = $(this).val();
            $("#<%= hfProjectID.ClientID %>").val(projectId.toString());
        });

        $("#cbUnfinishedOnly").change(function () {
            var checked = $(this).is(":checked");
            $("#<%= hfUnfinished.ClientID %>").val(checked);
        });

        $(".content_text").mouseover(function (event) {
            MouseOver(event);
        });

        $(".content_text").mouseout(function (event) {
            RemoveMouseOver(event);
        });

        $(".content_text").mouseup(function (e) {
            var from = $(window.getSelection().anchorNode.parentElement);
            var to = $(window.getSelection().extentNode.parentElement);
            SelectFromTo(e, from, to);
        });

        $(".content_text").mousedown(function (e) {
            StartMousePosition(e);
        });
        //$(".content_text").click(function (event) {
        //    MouseClick(event);
        //});

        $("[id^=rsidebar_]").mouseover(function () {
            var id = $(this).attr("id");
            $("#" + id + " #ex_desc .other_desc").show();
        });

        $("[id^=rsidebar_]").mouseout(function () {
            var id = $(this).attr("id");
            $("#" + id + " #ex_desc .other_desc").hide();
        });

        $(".help").click(function () {
            $(".iamhelping").toggle();
        });

        $(".iamhelping").click(function () {
            $(".iamhelping").toggle();
        });

        SetMarkedText();
        FirstEntity();

        // marks the word (entity change -> do not use)
        //WordSelection("content_text");

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
    });

    function SetMarkedText() {
        $("div[id^='Content_']").each(function () {
            var exampleId = this.id.match(/\d+/).toString();
            var exam = jQuery.parseJSON('<%= MarkedJSON %>');
            for (j = 0; j < exam.length; j++) {
                if (exam[j][0] == undefined)
                    continue;

                if (exam[j][0].ExampleId == exampleId) {
                    var obj = exam[j];
                    for (i = 0; i < obj.length; i++) {
                        if (obj[i].SentenceId != null && obj[i].EntityId != null) {
                            // MARKS words
                            var markit = $("#Content_" + obj[i].ExampleId + "_" + obj[i].SentenceId + "_" + obj[i].EntityId);
                            var color = "";

                            if (obj[i].Text != "" && obj[i].SubCategoryId == null) {
                                color = "#2C83D6";
                                $(markit).attr("data-text", obj[i].Text);
                            }
                            else if (obj[i].SubCategoryId == null) {
                                color = "transparent";
                                $(markit).removeAttr("data-subcategory");
                            }
                            else {
                                if ($(markit).attr("data-subcategory") == undefined) {
                                    $(markit).attr("data-subcategory", obj[i].SubCategoryId);
                                }
                                else {
                                    //var data = $(markit).attr("data-subcategory") + "_" + obj[i].SubCategoryId;
                                    $(markit).attr("data-subcategory", obj[i].SubCategoryId);
                                }
                                color = obj[i].Color;
                            }

                            if ($(markit).next().next().length > 0 && $(markit).next().next().attr("id") != undefined) {
                                var next_entity = $(markit).next().next().attr("id").split("_");
                                if (next_entity[3] != "1") {
                                    for (j = 0; j < obj.length; j++) {
                                        if (obj[j].EntityId == parseInt(next_entity[3]) && obj[j].SentenceId == parseInt(next_entity[2]) && obj[j].ExampleId == parseInt(next_entity[1]) && obj[j].Color == obj[i].Color) {
                                            $(markit).next().css("background-color", color);
                                        }
                                    }
                                }
                                else {
                                    // nova rečenica
                                }
                            }

                            $(markit).css("background-color", color);
                        }
                        else {
                            // MARKS whole text
                            if (obj[i].Text != "")
                                $("#rsidebar_" + obj[i].ExampleId + " #rbv_" + obj[i].SubCategoryId).val(obj[i].Text);
                            else
                                $("#rsidebar_" + obj[i].ExampleId + " #rbv_" + obj[i].SubCategoryId).prop("checked", true);
                        }
                    }
                    break;
                }
            }
        });
    }

    // replaced with another function
    function GetMarkedText() {
        // marks marked text from db
        $("div[id^='Content_']").each(function () {
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
                            if (obj[i].SentenceId != null && obj[i].EntityId != null) {
                                // MARKS words
                                var markit = $("#Content_" + obj[i].ExampleId + "_" + obj[i].SentenceId + "_" + obj[i].EntityId);
                                var color = "";

                                if (obj[i].Text != "" && obj[i].SubCategoryId == null) {
                                    color = "#2C83D6";
                                    $(markit).attr("data-text", obj[i].Text);
                                }
                                else {
                                    if ($(markit).attr("data-subcategory") == undefined) {
                                        $(markit).attr("data-subcategory", obj[i].SubCategoryId);
                                    }
                                    else {
                                        var data = $(markit).attr("data-subcategory") + "_" + obj[i].SubCategoryId;
                                        $(markit).attr("data-subcategory", data);
                                    }
                                    color = obj[i].Color;
                                }

                                if ($(markit).next().next().length > 0 && $(markit).next().next().attr("id") != undefined) {
                                    var next_entity = $(markit).next().next().attr("id").split("_");
                                    if (next_entity[3] != "1") {
                                        for (j = 0; j < obj.length; j++) {
                                            if (obj[j].EntityId == parseInt(next_entity[3]) && obj[j].SentenceId == parseInt(next_entity[2]) && obj[j].ExampleId == parseInt(next_entity[1]) && obj[j].Color == obj[i].Color) {
                                                $(markit).next().css("background-color", color);
                                            }
                                        }
                                    }
                                    else {
                                        // nova rečenica
                                    }
                                }

                                $(markit).css("background-color", color);
                            }
                            else {
                                // MARKS whole text
                                if (obj[i].Text != "")
                                    $("#rbv_" + obj[i].SubCategoryId).val(obj[i].Text);
                                else
                                    $("#rbv_" + obj[i].SubCategoryId).prop("checked", true);
                            }
                        }
                    }
                }
            });
        });
    }

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
