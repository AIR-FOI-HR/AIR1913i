<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MLE.Admin.Login" %>

<link rel="stylesheet" href="/../CSS/web.less">
<link href="https://fonts.googleapis.com/css?family=PT+Sans&display=swap" rel="stylesheet">
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="center_form">
            <div class="logo"><img src="/../Files/Images/admin.png" /></div>
            <div class="title">Prijava u administraciju</div>
            <table class="login_table">
                <tr>
                    <td>Korisničko ime:</td>
                    <td>
                        <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Lozinka:</td>
                    <td><asp:TextBox ID="txtPassword" TextMode="Password" runat="server"></asp:TextBox></td>
                </tr>
            </table>
            <div class="center"><asp:Button runat="server" ID="btnLogin" CssClass="buttons" Text="Prijavi se" OnClick="btnLogin_Click" /></div>
        </div>
    </form>
</body>
</html>
