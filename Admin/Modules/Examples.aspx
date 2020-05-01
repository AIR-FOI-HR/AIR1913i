<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examples.aspx.cs" Inherits="MLE.Admin.Modules.Examples" %>
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
            <UC:Menu runat="server" ID="menu" />
        </div>
        <div class="selection">
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div id="examples">
                        <a href="?id=<%#Eval("id") %>">
                            <div class="id"><%# Eval("id") %></div>
                            <%# Eval("Name") %>                           
                            <%# Eval("Description") %>
                            <%# Eval("DateCreated") %>                            
                            <%# Eval("ProjectTitle") %>
                            <%# Eval("StatusType") %>
                            <%# Eval("CategoryTitle") %>
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />                        
                    </div>
                </FooterTemplate>                
            </asp:Repeater>
        </div>

        <div id="input_data">
            <table>
                 <tr>
                    <th>Sadržaj:</th>
                    <td>
                        <asp:Literal ID="txtContent" Mode="PassThrough" runat="server"></asp:Literal>                        
                    </td>
                </tr>
                
                <!--<tr>
                    <th>Naziv:</th>
                    <td>
                        <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                    </td>
                </tr>
                 <tr>
                    <th>Opis</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                    </td>
                </tr>
              
                 <tr>
                    <th>Datum kreiranja</th>
                    <td>
                        <asp:TextBox ID="txtDateCreated" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Provedeno vrijeme</th>
                    <td>
                        <asp:TextBox ID="txtTimeSpent" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Naziv projekta</th>
                    <td>
                        <asp:TextBox ID="txtProjectTitle" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <asp:TextBox ID="txtStatusType" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Kategorija</th>
                    <td>
                        <asp:TextBox ID="txtCategoryTitle" runat="server"></asp:TextBox>
                    </td>
                </tr>-->
                
            </table>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();
        }
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
