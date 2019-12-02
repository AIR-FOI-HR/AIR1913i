<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataImport.aspx.cs" Inherits="MLE.Client.DataImport" %>
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
        <uc:Menu ID="Menu" runat="server" />
        <div class="center center_text content_margins">
            <div class="bold">Data import</div>
            <div class="div_text">Da biste unijeli nove primjere, potrebno je postaviti datoteke (.txt) unutar foldera DataImport koji se nalazi unutar projekta. Nakon toga, kliknite na "Učitaj podatke"!</div>
            <div class="buttons border_button"><asp:Button ID="btnLoadData" runat="server" Text="Učitaj podatke" OnClick="btnLoadData_Click" /></div>
            <div class="content_margins"><%= UploadSuccessful != 0 || UploadError != 0 || UploadExists != 0 ? "Uspješno učitano: " + UploadSuccessful + " datoteka!<br/>Neuspješno učitano: " + UploadError + " datoteka!<br/>Već postoji: " + UploadExists + " datoteka!" : "" %></div>
        </div>
    </form>
</body>
</html>