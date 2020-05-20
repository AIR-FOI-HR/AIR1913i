<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="MLE.Client.Registration" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>
<script src="/Client/js/RegistrationHelper.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body class="background">
    <form id="form_registration" runat="server">
        <div class="reg_container">
            <div class="logo">
                <img src="/../Files/Images/home.png" /><div>MLE</div>
            </div>
            <div class="arrow">
                <img src="/../Files/Images/arrow_left.png" />
            </div>
            <div class="title big">Registracija</div>
            <div class="small margintop center">Imate račun? <a href="/Client/Login.aspx">Prijavite se!</a></div>
            <% if (RegistrationCompleted == false)
                { %>
            <div class="container_username">
                <table class="center" style="margin-top: 50px;">
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="Korisničko ime" ID="txtUsername"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" TextMode="Password" placeholder="Lozinka" ID="txtPassword"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" TextMode="Password" placeholder="Potvrđena lozinka" ID="txtConfirmedPassword"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="Ime" ID="txtFirstName"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="Prezime" ID="txtLastName"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="E-Mail" ID="txtMail"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div class="right buttons">
                    <asp:Button ID="btnRegister" runat="server" Text="Registriraj se" OnClick="btnRegister_Click" OnClientClick="return Validation();" />
                </div>
            </div>
            <%}
                else
                { %>
            <div style="text-align:center; padding: 50px;">
                Hvala na registraciji! Da bi se prijavili u sustav, administrator mora pregledati Vašu prijavu!
            </div>
            <%} %>
            <div class="error_container">
                <div>Errors:</div>
                <div id="ListOfErrors"></div>
            </div>
        </div>
    </form>
</body>
</html>
