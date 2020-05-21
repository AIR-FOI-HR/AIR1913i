<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="MLE.Client.ForgotPassword" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>
<script src="/Client/js/RegistrationHelper.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body class="background">
    <form id="form_forgot_password" runat="server">
        <div>
            <div class="forgot_password_container">
                <div class="logo">
                    <img src="/../Files/Images/home.png" /><div>MLE</div>
                </div>
                <div class="arrow">
                    <img src="/../Files/Images/arrow_left.png" />
                </div>
                <div class="title big">Zaboravljena lozinka</div>
                <div class="container_username">
                    <div class="center" style="margin-top: 50px;">
                        <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="E-Mail" ID="txtForgotMail"></asp:TextBox>
                        <div class="small margintop">Imate račun? <a href="/Client/Login.aspx">Prijavite se!</a></div>
                        <% if (MailSent)
                            { %>
                        <div>Poslan Vam je mail!</div>
                        <%} %>
                    </div>
                    <div class="right buttons">
                        <asp:Button ID="btnSendMail" runat="server" Text="Pošalji" OnClick="btnSendMail_Click" OnClientClick="return MailValidation();" />
                    </div>
                </div>
                <div class="error_fp_container">
                    <div>Greške:</div>
                    <div id="ListOfMailErrors"></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
