<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Projects.aspx.cs" Inherits="MLE.Admin.Modules.Projects" %>
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
        <div>
            <UC:Menu ID="menu" runat="server" />
        </div>
        <div class="selection">
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div id="projects">
                        <a href="?id=<%#Eval("id") %>">
                            <div class="id"><%# Eval("id") %></div>
                            <%# Eval("Name") %>
                            <%# Eval("Description") %>
                            <%# Eval("DateCreated") %>
                            <%# Eval("TimeSpent") %>
                            <%# Eval("Start_Date") %>
                            <%# Eval("End_Date") %>
                            <%# Eval("StatusId") %> 
                        </a>
                        <input type="button" value="Exportaj" id="btnExportToJson" onclick='<%#"ExportToJson("+ Eval("id") + " );" %>' />
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnSubmit" value="Novi projekt" onclick="AddProject(); return false;" />
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <div id="input_data">
            <table>
                <tr>
                    <th>Naziv:</th>
                    <td>
                        <asp:TextBox ID="txtName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>Opis:</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Kreiran:</th>
                    <td>
                        <asp:TextBox ID="txtDateCreated" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Provedeno vrijeme projekta:</th>
                    <td>
                        <asp:TextBox ID="txtSpentTime" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Datum početka:</th>
                    <td>
                        <asp:TextBox ID="txtStartDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td><a class="link" onclick="GetDateStart();" href="#">Danas</a></td>
                </tr>
                <tr>
                    <th>Datum završetka:</th>
                    <td>
                        <asp:TextBox ID="txtEndDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td><a class="link" onclick="GetDateEnd();" href="#">Danas</a></td>
                </tr>
                <tr>
                    <th>Status:</th>
                    <td>
                        <asp:TextBox ID="txtStatus" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div class="buttons">
                <asp:Button ID="btnSave" runat="server" Text="Spremi" OnClick="btnSave_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Obriši" OnClick="btnDelete_Click" />
            </div>
        </div>        
    </form>
</body>
</html>
<script type="text/javascript">
    function GetDateStart() {
        var d = new Date($.now());
        $("#txtStartDate").val(d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes());
    }

    function GetDateEnd() {
        var d = new Date($.now());
        $("#txtEndDate").val(d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes());
    }

    function AddProject() {
        location.href = "?id=0";
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");
        if (id != null) {
            $("#input_data").show();            
        }
    });

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
    };

    function ExportToJson(id) {

        $.ajax({
            type: "POST",
            url: "Projects.aspx/ExportToJson",
            data: JSON.stringify({ projectId: id }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function () {
                alert('uspješno je xportano');
            }
        });
    }
</script>
