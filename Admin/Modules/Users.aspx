<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="MLE.Admin.Modules.Users" UnobtrusiveValidationMode="None" %>

<%@ Register Src="/Admin/Modules/Menu.ascx" TagPrefix="UC" TagName="Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="../../CSS/admin.less" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <UC:Menu runat="server" ID="Menu" />
        <div>

            <div class="selection">
                <asp:Repeater ID="rpt" runat="server">
                    <ItemTemplate>
                        <div>
                            <a id="link_<%#Eval("Id") %>" href="?id=<%#Eval("id") %><%= current_page > 1 ? ("&page=" + current_page) : ("")%>">
                                <%--<div class="id"><%# Eval("id") %></div>--%>
                                <%# Eval("Username") %>
                            </a>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div class="menu_add">
                            <hr />
                            <input type="submit" id="btnSubmit" value="Dodaj korisnika" onclick="AddUser(); return false;" />
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
            <asp:HiddenField ID="uId" Value="" runat="server" />
            <div id="input_data">
                <table>
                    <tr>
                        <th>Ime:</th>
                        <td>
                            <asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>Prezime:</th>
                        <td>
                            <asp:TextBox ID="txtSurname" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>E-mail:</th>
                        <td>
                            <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>Korisničko ime:</th>
                        <td>
                            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>Lozinka:</th>
                        <td>
                            <asp:TextBox ID="txtPassword" TextMode="Password" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>Opis:</th>
                        <td>
                            <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>Aktivan:</th>
                        <td>
                            <asp:CheckBox ID="cbIsActive" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>Rola korisnika:</th>
                        <td>
                            <asp:DropDownList ID="roleList" runat="server" AutoPostBack="true"
                                Height="30px" Width="215px"
                                Style="position: static; margin-bottom: 5px; padding-left: 10px;">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <th>Dodaj projekt na korisnika:</th>
                        <td>
                            <asp:DropDownList ID="ddlProject" runat="server"></asp:DropDownList>
                            <asp:Button ID="btnAddProject" runat="server" OnClick="btnAddProject_Click" Text="Dodaj" />
                            <asp:Button ID="btnRemoveProject" runat="server" OnClick="btnRemoveProject_Click" Text="Obriši" />
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align: top;">Projekti korisnika:</th>
                        <td>
                            <%foreach (var item in Projects)
                                { %>
                            <a href="Projects.aspx?id=<%= item.Id %>"><%= item.Name %></a>
                            <br />
                            <%} %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                </table>
                <div class="buttons">
                    <asp:Button ID="btnAdd" runat="server" Text="Spremi" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnDelete" runat="server" Text="Obriši" OnClick="btnDelete_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">
    function AddUser() {
        location.href = "?id=0";
    }

    function AddExample() {
        $("#input_data").hide();
        $("#add_example").show();
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
            $("#link_" + id).css("text-decoration", "underline");
        }

        if ($("#show_content").val() === "yes") {
            $("#input_data").hide();
            $("#add_example").show();
        }
        $("#lbUsers").addClass("curr");

        $("#txtPassword").on('mouseup', function () {
            alert("Upozorenje: Promijeniti ćete password odabranog korisnika!")
        });
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
