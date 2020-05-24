<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examples.aspx.cs" Inherits="MLE.Admin.Modules.Examples" ValidateRequest="false" %>

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
            <UC:Menu runat="server" ID="menu" />
        </div>
        <div class="selection">
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div id="examples">
                        <a href="?id=<%#Eval("id") %>">
                            <div class="id"><%# Eval("id") %></div>
                            <%# Eval("Name") %>
                            <%# Eval("Description") %>
                            <%# Eval("DateCreated") %>
                            <%# Eval("ProjectTitle") %>
                            <%# Eval("StatusType") %>
                            <%# Eval("CategoryTitle") %>
                        </a>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <div class="menu_add">
                        <hr />
                        <input type="submit" id="btnAddExample" value="Novi primjer" onclick="AddExample(); return false;" />
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <div id="input_data">
            <table>
                <tr>
                    <th>Naziv:</th>
                    <td>
                        <asp:TextBox ID="txtName" placeholder="Naziv primjera" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <%--<tr>
                    <th>Sadržaj:</th>
                    <td>
                        <asp:TextBox ID="exampleContent" placeholder="Ovdje unosite HTML" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>--%>
                <tr>
                    <th>Opis:</th>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Datum kreiranja</th>
                    <td>
                        <asp:TextBox ID="txtDateCreated" runat="server" TextMode="Date"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Projekt</th>
                    <td>
                        <asp:DropDownList ID="projectList" runat="server"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="projectList_SelectedIndexChanged"
                            Height="30px" Width="200px"
                            Style="position: static; margin-bottom: 5px; padding-left: 10px;">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <asp:DropDownList ID="statusList" runat="server"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="statusList_SelectedIndexChanged"
                            Height="30px" Width="200px"
                            Style="position: static; margin-bottom: 5px; padding-left: 10px;">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>Kategorija</th>
                    <td>
                        <asp:DropDownList ID="categoryList" runat="server"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="categoryList_SelectedIndexChanged"
                            Height="30px" Width="200px"
                            Style="position: static; margin-bottom: 5px; padding-left: 10px;">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>Sadržaj:</th>
                    <td>
                        <asp:Literal ID="txtContent" Mode="PassThrough" runat="server"></asp:Literal>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="hiddenId" runat="server" Value="" />
            <div class="buttons">
                <asp:Button ID="btnSave" runat="server" Text="Spremi" OnClick="btnSave_Click" />
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    function AddExample() {
        location.href = "?id=0";
        //$("#example_content").show();
    }

    $(document).ready(function () {
        var id = getUrlParameter("id");

        if (id != null && id != 0) {
            $("#input_data").show();
        }

        if (id === "0")
            $("#example_content").show();
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
</script>
