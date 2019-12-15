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
            <div class="bold center_text">Primjeri</div>
            <select id="choose_data" class="center">
                <option value="all">Prikaži sve</option>
                <option value="not_completed" selected="selected">Prikaži u tijeku</option>
                <option value="completed">Prikaži završene</option>
            </select>
            <hr class="line" />
            <div style="margin-top: 30px;">
                <div class="notfinished_left">
                    <div class="custom_margins">
                        <%= Examples_NotFinished.Count > 0 ? "<div class=\"bold u_tijeku\">U TIJEKU</div>" : "" %>
                        <% foreach (var item in Examples_NotFinished)
                            { %>
                        <div class="examples">
                            <%= item.Name != null ? "<span class=\"bold\">Naziv: </span>" + item.Name + "</div>" : "" %>
                            <div><span class="bold">Naziv datoteke: </span><%= item.FileName %></div>
                            <div><span class="bold">Kreirano: </span><%= item.DateCreated %></div>
                            <div id="Content_E<%= item.Id %>" class="content_text"><%= item.Content.Replace(Environment.NewLine, "<br/>") %></div>
                            <div class="center">
                                <% foreach (var cat in item.ExampleCategory)
                                    { %>
                                <input class="catButtons" style="background-color: <%= GetColor(cat.CategoryId.Value) %>" type="submit" value="<%= GetCategory(cat.CategoryId.Value) %>" onclick="Save('E' + <%= item.Id %> + '_C' + <%= cat.CategoryId %> + '_<%= GetColor(cat.CategoryId.Value) %>'); return false;" />
                                <%} %>
                                <div class="center">
                                    <input class="finish" type="submit" value="Završi" onclick="return FinishExample(<%= item.Id %>);" />
                                </div>
                            </div>
                        </div>
                        <hr />
                        <%} %>
                    </div>
                </div>
                <div class="finished_right">
                    <div class="custom_margins">
                        <%= Examples_Finished.Count > 0 ? "<div class=\"bold zavrseno\">ZAVRŠENI</div>" : "" %>
                        <% foreach (var item in Examples_Finished)
                            { %>
                        <div class="examples">
                            <%= item.Name != null ? "<span class=\"bold\">Naziv: </span>" + item.Name + "</div>" : "" %>
                            <div><span class="bold">Naziv datoteke: </span><%= item.FileName %></div>
                            <div><span class="bold">Kreirano: </span><%= item.DateCreated %></div>
                            <div id="Content_E<%= item.Id %>" class="content_text"><%= item.Content.Replace(Environment.NewLine, "<br/>") %></div>
                            <div class="center">
                                <% foreach (var cat in item.ExampleCategory)
                                    { %>
                                <input class="catButtons" style="background-color: <%= GetColor(cat.CategoryId.Value) %>" type="submit" disabled="disabled" value="<%= GetCategory(cat.CategoryId.Value) %>" onclick="Save('E' + <%= item.Id %> + '_C' + <%= cat.CategoryId %> + '_<%= GetColor(cat.CategoryId.Value) %>'); return false;" />
                                <%} %>
                            </div>
                        </div>
                        <hr />
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

<style>
    .custom_margins {
        margin-top: 15px;
        padding-left: 20px;
        padding-right: 20px;
    }

    .zavrseno {
        color: green;
    }

    .u_tijeku {
        color: red;
    }

    #choose_data {
        width: 200px;
        height: 30px;
        margin-top: 15px;
        border-radius: 10px;
        padding-left: 10px;
        border: 2px solid #2C83D6;
        outline: 0;
        /*background-color: #2C83D6;
        color: white;*/
    }

    .catButtons {
        border-radius: 10px;
        width: 100px;
        margin: 10px;
        cursor: pointer;
        outline: 0;
        display: inline-block;
    }

    .finish {
        border-radius: 10px;
        margin-top: 30px;
        width: 200px;
        height: 40px;
        cursor: pointer;
        outline: 0;
    }

    .entity {
        background-color: #9dc1fa;
    }

    .current {
        background-color: #f7746f;
    }
</style>

<script>
    // handle on keyup
    $(document).on('keyup', function (e) {
        HandleKeyUP(e);
    });

    // marks marked text from db
    $("div[id^='Content_E'").each(function () {
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
                        $("#Content_E" + obj[i].ExampleId + ":contains('" + obj[i].Text.replace(/[\r\n]+/g, "") + "')").each(function () {
                            var regex = new RegExp(obj[i].Text.replace(/[\r\n]+/g, "<br><br>"), 'gi');
                            $(this).html($(this).html().replace(regex, "<span style='white-space: pre-line; background-color:" + obj[i].Color + "'>" + obj[i].Text + "</span>"));
                        });
                    }
                }
            }
        });
    });

    // save on category button click
    function Save(id) {
        //alert(id);
        var split = id.split('_');
        var obj = {};
        obj.ExampleId = split[0].match(/\d+/).toString();
        obj.CategoryId = split[1].match(/\d+/).toString();
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
</script>
