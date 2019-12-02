<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examples.aspx.cs" Inherits="MLE.Admin.Modules.Examples" %>
<%@ Register Src="~/Admin/Modules/Menu.ascx" TagPrefix="UC" TagName="Menu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../../js/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="../../CSS/admin.less" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <UC:Menu runat="server" ID="menu" />
        <div>
        </div>
    </form>
</body>
</html>
