<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Type.aspx.cs" Inherits="MLE.Admin.Modules.Type" %>

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
                        <a id="link_<%# Eval("Id") %>" href="?id=<%#Eval("Id") %><%= current_page > 1 ? ("&page=" + current_page) : ("")%>">
                            <div class="id"><%# Eval("Id") %></div>
                            <%# Eval("Name") %>
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnSubmit" value="Novi tip" onclick="AddType(); return false;" />
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
                    <th>Aktivan:</th>
                    <td>
                        <asp:CheckBox ID="cbActive" runat="server" />
                    </td>
                </tr>
            </table>
            <div class="buttons">
                <asp:Button ID="btnSave" runat="server" Text="Spremi" OnClick="btnSave_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Obriši" OnClick="btnDelete_Click" />
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    function AddType() {
        location.href = "?id=0";
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
            $("#link_" + id).css("text-decoration", "underline");
        }
        $("#lbTypes").addClass("curr");
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
