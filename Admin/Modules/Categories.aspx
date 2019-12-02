<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="MLE.Admin.Modules.Categories" %>

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
        <div>
            <UC:Menu ID="menu" runat="server" />
        </div>
        <div class="selection">
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div id="categories">
                        <a href="?id=<%#Eval("id") %>">
                            <div class="id"><%# Eval("id") %></div>
                            <%# Eval("Name") %>
                            <%# Eval("Description") %>
                            <%# Eval("IsActive").Equals(true) ? "+" : "-" %>   
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnSubmit" value="Dodaj kategoriju" onclick="AddCategory(); return false;" />
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <div id="input_data">
            <table>
                <tr>
                    <th>Naziv:</th>
                    <td>
                        <asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>Opis:</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Aktivna:</th>
                    <td>
                        <asp:CheckBox ID="cbIsActive" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th>Boja:</th>
                    <td>
                        <asp:TextBox ID="txtColor" runat="server"></asp:TextBox>
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
        location.href = "?id=0";
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
        }

        $("#datetimepicker1").datetimepicker();
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
