<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Projects.aspx.cs" Inherits="MLE.Admin.Modules.Projects" EnableEventValidation="true" %>

<%@ Register Src="~/Admin/Modules/Menu.ascx" TagPrefix="UC" TagName="Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="../../CSS/admin.less" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <UC:Menu ID="menu" runat="server" />
        </div>
        <div class="selection">
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div>
                        <a id="link_<%# Eval("id") %>" href="?id=<%#Eval("id") %><%= current_page > 1 ? ("&page=" + current_page) : ("")%>">
                            <%--<div class="id"><%# Eval("id") %></div>--%>
                            <%# Eval("Name") %>, 
                            <%# Eval("Example.Count") %>, 
                            <%# DateTime.Parse(Eval("DateCreated").ToString()).ToString("d.M.yyyy.") %>
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnSubmit" value="Novi projekt" onclick="AddProject(); return false;" />
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
                        <asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>Opis:</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Kreiran:</th>
                    <td>
                        <asp:TextBox ID="txtDateCreated" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Provedeno vrijeme projekta:</th>
                    <td>
                        <asp:TextBox ID="txtSpentTime" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Datum početka:</th>
                    <td>
                        <asp:TextBox ID="txtStartDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td><a class="link" onclick="GetDateStart();" href="#">Danas</a></td>
                </tr>
                <tr>
                    <th>Datum završetka:</th>
                    <td>
                        <asp:TextBox ID="txtEndDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td><a class="link" onclick="GetDateEnd();" href="#">Danas</a></td>
                </tr>
                <tr>
                    <th>Status:</th>
                    <td>
                        <asp:DropDownList ID="ddlStatus" runat="server"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td style="padding: 15px 0 10px 0;"><a class="linkbutton" href="/Admin/Modules/Examples.aspx?pId=<%= projectId %>">Prikaži primjere</a></td>
                </tr>
                <tr>
                    <td colspan="2"><hr /></td>
                </tr>
                <tr>
                    <th>Dodaj tip na sve primjere:</th>
                    <td>
                        <asp:DropDownList ID="ddlType" runat="server"></asp:DropDownList>
                        <asp:Button ID="btnAddType" runat="server" OnClick="btnAddType_Click" Text="Dodaj" />
                        <asp:Button ID="btnRemoveType" runat="server" OnClick="btnRemoveType_Click" Text="Obriši" />
                    </td>
                </tr>
                <tr>
                    <th style="vertical-align:top;">Tipovi trenutno na projektu:</th>
                    <td>
                        <%foreach (var item in Types)
                            { %>
                        <%= item.Name %>
                        <br />
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><hr /></td>
                </tr>
                <tr>
                    <th>Dodaj korisnika na projekt:</th>
                    <td>
                        <asp:DropDownList ID="ddlUser" runat="server"></asp:DropDownList>
                        <asp:Button ID="btnAddUser" runat="server" OnClick="btnAddUser_Click" Text="Dodaj" />
                        <asp:Button ID="btnRemoveUser" runat="server" OnClick="btnRemoveUser_Click" Text="Obriši" />
                    </td>
                </tr>
                <tr>
                    <th style="vertical-align:top;">Korisnici trenutno na projektu:</th>
                    <td>
                        <%foreach (var item in Users)
                            { %>
                        <%= item.Username %>
                        <br />
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><hr /></td>
                </tr>
            </table>
            <div class="buttons">
                <asp:Button ID="btnSave" runat="server" Text="Spremi" OnClick="btnSave_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Obriši" OnClientClick="return DeleteAlert();" OnClick="btnDelete_Click" />
                <asp:Button ID="btnExport" runat="server" Text="Export" OnClick="btnExport_Click" />
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    function GetDateStart() {
        var d = new Date($.now());
        $("#txtStartDate").val(d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes());
    }

    function GetDateEnd() {
        var d = new Date($.now());
        $("#txtEndDate").val(d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes());
    }

    function AddProject() {
        location.href = "?id=0";
    }

    function DeleteAlert() {
        if (confirm("Brisanjem ovog projekta ćete obrisati sljedeće stavke vezane za projekt: Primjere, Označene riječi, Kategorije vezane uz primjere (desni sidebar)!"))
            return true;
        else
            return false;
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
            $("#link_" + id).css("text-decoration", "underline");
        }
        $("#lbProjects").addClass("curr");
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
</script>
