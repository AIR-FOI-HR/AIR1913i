﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="MLE.Admin.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Uspješan login
            <asp:Button ID="btnOdjava" runat="server" Text="Odjava" OnClick="btnOdjava_Click" />

            <div>
                <% foreach (var item in Examples)
                    { %>
                <div><%= item.Id %></div>
                <%} %>
            </div>
            <div>MARKED
                <% foreach (var item in Marked)
                    { %>
                <div><%= item.Id %></div>
                <%} %>
            </div>
        </div>
    </form>
</body>
</html>
