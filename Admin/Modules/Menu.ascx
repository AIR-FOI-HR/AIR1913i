<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Menu.ascx.cs" Inherits="MLE.Admin.Modules.Menu" %>

<div class="menu">
    <div class="menu_buttons">
        <a id="lbClient" class="ClientMLE" href="/Client/Examples.aspx">MLE</a>
        <a id="lbUsers" href="/Admin/Modules/Users.aspx">Korisnici</a>
        <a id="lbCategories" href="/Admin/Modules/Categories.aspx">Kategorije</a>
        <a id="lbSubCategories" href="/Admin/Modules/Subcategories.aspx">Potkategorije</a>
        <a id="lbProjects" href="/Admin/Modules/Projects.aspx">Projekti</a>
        <a id="lbExamples" href="/Admin/Modules/Examples.aspx">Primjeri</a>
        <a id="lbTypes" href="/Admin/Modules/Type.aspx">Tip</a>
        <asp:LinkButton ID="lbSignOut" runat="server" OnClick="lbSignOut_Click">Odjava</asp:LinkButton>
    </div>
</div>