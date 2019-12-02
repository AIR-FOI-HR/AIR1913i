<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Menu.ascx.cs" Inherits="MLE.Client.Menu" %>
<link rel="stylesheet" href="/../CSS/client.less" />

<div class="main_menu">
    <div class="menu"><a href="/Client/Home.aspx">Početna</a></div>
    <div class="menu"><a href="/Client/DataImport.aspx">Unos podataka</a></div>
    <div class="menu"><a href="/Client/Examples.aspx">Primjeri</a></div>
    <div class="menu"><asp:LinkButton ID="lbOdjava" OnClick="lbOdjava_Click" runat="server">Odjavi se</asp:LinkButton></div>
</div>
