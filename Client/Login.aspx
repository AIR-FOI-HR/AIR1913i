<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MLE.Client.Login" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body class="background">
    <form id="form1" runat="server">
        <div>
            <div class="container">
                <div class="logo">
                    <img src="/../Files/Images/home.png" /><div>MLE</div>
                </div>
                <div class="arrow">
                    <img src="/../Files/Images/arrow_left.png" />
                </div>
                <div class="title big">Prijava</div>
                <div class="container_username">
                    <div class="center" style="margin-top: 50px;">
                        <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="Korisničko ime" ID="txtUsername"></asp:TextBox>
                        <div class="small margintop">Nemate račun? <a href="#">Stvorite ga!</a></div>
                    </div>
                    <div class="right buttons">
                        <input type="submit" id="btnNext" value="Dalje" onclick="return false;" />
                    </div>
                </div>
                <div class="container_password">
                    <div class="center" style="margin-top: 50px;">
                        <asp:TextBox runat="server" CssClass="login_textbox" ClientIDMode="Static" placeholder="Lozinka" TextMode="Password" ID="txtPassword"></asp:TextBox>
                        <div class="small margintop"><a href="#">Jeste li zaboravili lozinku?</a></div>
                        <div class="error_circle"></div>
                    </div>
                    <div class="right buttons">
                        <asp:Button ID="btnLogin" runat="server" Text="Prijava" OnClientClick="return LoginValidation();" OnClick="btnLogin_Click" />
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $("#btnNext").click(function () {
                $(".container_username").fadeOut('slow');
                $(".container_username").promise().done(function () {
                    $(".container_password").fadeIn();
                    $(".arrow").fadeIn();
                });
                setTimeout(function () { $("#txtPassword").focus() }, 1000);
            });

            $(".arrow").click(function () {
                $(".container_password").fadeOut('slow');
                $(".arrow").fadeOut('slow');
                $(".container_password").promise().done(function () {
                    $(".container_username").fadeIn();
                });
            });

            $("#txtPassword").keypress(function (e) {
                var key = e.which;
                if (key == 13)
                {
                    $("#btnLogin").click();
                    return false;
                }
            });

            function LoginValidation() {
                var obj = {};
                obj.user = $("#txtUsername").val();
                obj.pass = $("#txtPassword").val();
                var valid = false;
                $.ajax({
                    type: "POST",
                    url: "/Client/ajax/ValidateLogin.aspx/ValidatePassword",
                    data: JSON.stringify(obj),
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        valid = r.d;
                    }
                });
                if (valid == false) {
                    $("#txtPassword").val("");
                    $("#txtPassword").attr("placeholder", "Pogrešno uneseni podaci!");
                    $(".error_circle").fadeIn();
                }
                else {
                    $(".error_circle").fadeOut();
                }

                return valid;
            }
        </script>
    </form>
</body>
</html>
