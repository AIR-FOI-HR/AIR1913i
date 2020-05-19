<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="MLE.Client.Home" %>
<%@ Register TagName="Menu" TagPrefix="uc" Src="~/Client/Menu.ascx" %>

<!DOCTYPE html>
<link rel="stylesheet" href="/../CSS/client.less" />
<script src="/../js/jquery-3.4.1.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Menu ID="Menu" runat="server"/>
        <div class="main_content">
            <div class="content">Web aplikacija za označavanje jezičnih primjera</div>
            <div class="byprogrammers">By Mihael Lukaš & Tomica Markulin</div>
            <div>
                <a href="https://www.foi.hr" target="_blank"><img class="logo" src="/Files/Images/foi.jpg"/></a>
                <a href="http://www.novena.hr" target="_blank"><img class="logo" src="/Files/Images/novena.png"/></a>
            </div>
        </div>
    </form>
</body>
</html>