<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Subcategories.aspx.cs" Inherits="MLE.Admin.Modules.Subcategories" %>

<%@ Register Src="/Admin/Modules/Menu.ascx" TagPrefix="UC" TagName="Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../js/jquery-3.4.1.min.js"></script>
    <script src="../../js/ColorPicker/ColorPicker.js"></script>
    <link rel="stylesheet" href="../../CSS/admin.less" />
    <link rel="stylesheet" href="../../js/ColorPicker/ColorPicker.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <UC:Menu ID="menu" runat="server" />
        </div>
        <div class="selection">
            <asp:DropDownList ID="ddlCategories" runat="server" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged"></asp:DropDownList>
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div>
                        <a id="link_<%# Eval("Id") %>" href="?cId=<%# Eval("Category.Id") %>&id=<%#Eval("id") %><%= current_page > 1 ? ("&page=" + current_page) : ("")%>">
                            <div class="id"><%# Eval("id") %></div>
                            <%# Eval("Name") %>
                            <%# Eval("Description") %>
                            <%--<%# Eval("IsActive").Equals(true) ? "+" : "-" %>--%>   
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnSubmit" value="Dodaj potkategoriju" onclick="AddCategory(); return false;" />
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            <%if (Pages > 1)
                { %>
            <div class="pager">
                <asp:PlaceHolder ID="phPager" runat="server"></asp:PlaceHolder>
                <div style="clear: both;"></div>
            </div>
            <%} %>
        </div>

        <div id="input_data">
            <table>
                <tr>
                    <th>Naziv:</th>
                    <td>
                        <asp:TextBox ID="txtSubcategoryName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>Aktivna:</th>
                    <td>
                        <asp:CheckBox ID="cbIsActive" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th>Opis:</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Boja:</th>
                    <td style="position: relative;">
                        <asp:TextBox ID="txtColor" ClientIDMode="Static" runat="server"></asp:TextBox>
                        <asp:Button ID="btnColor" ClientIDMode="Static" CssClass="colorButton" OnClientClick="return ShowColorEditor();" runat="server"></asp:Button>
                        <div style="position: absolute; right: -135px;">
                            <div id="colorpicker"></div>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="buttons">
                <asp:Button ID="btnAdd" runat="server" Text="Spremi" OnClick="btnAdd_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Obriši" OnClick="btnDelete_Click" />
            </div>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">
    function AddCategory() {
        location.href = "?cId=<%=CId%>&id=0";
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
            $("#link_" + id).css("text-decoration", "underline");
        }
        $("#lbSubCategories").addClass("curr");
    });

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
    };

    function ShowColorEditor() {
        ColorPicker($("#colorpicker"), $("#txtColor"), $("#btnColor"));
        return false;
    }

    $("#txtColor").on('input', function () {
        var hex = $(this).val();
        $("#btnColor").css("background-color", hex);
    });
</script>
