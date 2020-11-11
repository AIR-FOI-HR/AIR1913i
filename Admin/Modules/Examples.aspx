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
            <asp:DropDownList ID="ddlProjects" runat="server" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlProjects_SelectedIndexChanged">
                <%--<asp:ListItem Value="0">All</asp:ListItem>--%>
            </asp:DropDownList>
            <asp:Repeater ID="rpt" runat="server">
                <ItemTemplate>
                    <div>
                        <a id="link_<%# Eval("id") %>" href="?pId=<%# Eval("Project.Id") %>&id=<%#Eval("id") %><%= current_page > 1 ? ("&page=" + current_page) : ("")%>">
                            <%--<div class="id"><%# Eval("id") %></div>--%>
                            <%# Eval("Project.Name") %>, 
                            <%# Eval("id") %>
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
            <%if (Pages > 1)
                { %>
            <div class="pager">
                <asp:PlaceHolder ID="phPager" runat="server"></asp:PlaceHolder>
                <div style="clear: both;"></div>
            </div>
            <%} %>
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
                        <asp:Label ID="lbDate" runat="server"></asp:Label>
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
                    <th>Tip</th>
                    <td>
                        <asp:DropDownList ID="ddlType" runat="server"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlType_SelectedIndexChanged"
                            Height="30px" Width="200px"
                            Style="position: static; margin-bottom: 5px; padding-left: 10px;">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>Tekst:</th>
                    <td style="height: 50px;">
                        <asp:Label ID="lbText" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>Sadržaj:</th>
                    <%--<td>--%>
                    <%--<asp:Literal ID="txtContent" Mode="PassThrough" runat="server"></asp:Literal>--%>
                    <%--</td>--%>
                    <td>
                        <asp:TextBox ID="txtContent" TextMode="MultiLine" Style="height: 421px; width: 500px" runat="server"></asp:TextBox>
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
            $("#link_" + id).css("text-decoration", "underline");
        }

        if (id === "0")
            $("#input_data").show();
        $("#lbExamples").addClass("curr");
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
