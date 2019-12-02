<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="MLE.Admin.Modules.Users" %>
<%@ Register Src="/Admin/Modules/Menu.ascx" TagPrefix="UC" TagName="Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">    
    <script src="../../js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="../../CSS/admin.less"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <UC:Menu runat="server" ID="Menu" />
        <div>
                        
            <div class ="selection">
               <asp:Repeater ID="rpt" runat="server">
                   <ItemTemplate>
                       <div id="users">
                          <a href="?id=<%#Eval("id") %>"><div class="id"><%# Eval("id") %></div>
                            <%# Eval("FirstName") %>
                            <%# Eval("LastName") %>
                            <%# Eval("E_Mail") %>
                            <%# Eval("Username") %>
                            <%# Eval("Description") %>                            
                            <%# Eval("IsActive").Equals(true) ? "+" : "-" %>   
                            <%# DateTime.Parse(Eval("DateCreated").ToString()).ToShortDateString() %>
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
            </div>

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
