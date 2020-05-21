<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="MLE.Client.ChangePassword" %>

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
            <% if (AllowChangingPassword)
                { %>
            <div class="forgot_password_container">
                <div class="logo">
                    <img src="/../Files/Images/home.png" /><div>MLE</div>
                </div>
                <div class="arrow">
                    <img src="/../Files/Images/arrow_left.png" />
                </div>
                <div class="title big">Promijeni lozinka</div>
                <div class="container_username">
                    <div class="center" style="margin-top: 50px;">
                        <asp:TextBox runat="server" CssClass="login_textbox" TextMode="Password" ClientIDMode="Static" placeholder="Lozinka" ID="txtChangePassword"></asp:TextBox>
                    </div>
                    <div class="center" style="margin-top: 10px;">
                        <asp:TextBox runat="server" CssClass="login_textbox" TextMode="Password" ClientIDMode="Static" placeholder="Ponovljena lozinka" ID="txtChangePasswordConf"></asp:TextBox>
                    </div>
                    <div class="right buttons">
                        <asp:Button ID="btnChangePassword" runat="server" Text="Dalje" OnClick="btnChangePassword_Click" OnClientClick="return RestartValidation();" />
                    </div>
                </div>
                <div class="error_fp_container">
                    <div>Greške:</div>
                    <div id="ListOfPasswordErrors"></div>
                </div>
            </div>
            <%} %>
            <% if (Errors.Count > 0)
                {%>
            <div class="forgot_password_container">
                <div class="logo">
                    <img src="/../Files/Images/home.png" /><div>MLE</div>
                </div>
                <div class="arrow">
                    <img src="/../Files/Images/arrow_left.png" />
                </div>
                <div style="margin: 0 auto; width: 100px; padding-top: 70px;">
                    <div>Pogreške:</div>
                    <% for (int i = 0; i < Errors.Count; i++)
                        { %>
                    <div><%= Errors[i] %></div>
                    <%} %>
                    <div class="small margintop"><a href="/Client/Login.aspx">Prijavite se!</a></div>
                </div>
            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
