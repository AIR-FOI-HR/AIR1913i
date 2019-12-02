<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Menu.ascx.cs" Inherits="MLE.Admin.Modules.Menu" %>

<div class="menu">
    <div class="menu_buttons">
        <asp:LinkButton ID="lbUsers" runat="server" PostBackUrl="~/Admin/Modules/Users.aspx">Korisnici</asp:LinkButton>
        <asp:LinkButton ID="lbCategories" runat="server" PostBackUrl="~/Admin/Modules/Categories.aspx">Kategorije</asp:LinkButton>
        <asp:LinkButton ID="lbProjects" runat="server" PostBackUrl="~/Admin/Modules/Projects.aspx">Projekti</asp:LinkButton>
        <asp:LinkButton ID="lbExamples" runat="server" PostBackUrl="~/Admin/Modules/Examples.aspx">Primjeri</asp:LinkButton>
        <asp:LinkButton ID="lbSignOut" runat="server" OnClick="lbSignOut_Click" >Odjava</asp:LinkButton>
    </div>
</div>
