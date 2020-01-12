<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MyMoney.About" %>

 

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>My Money</h1>
        <p class="lead">Här kommer jag att lära mig coola saker.</p>
        <p><button type="submit" class="btn btn-primary btn-lg" id="UpdateStockPrice" runat="server" onserverclick="UpdateStockPrice_onclickAsync">Uppdatera kurser &raquo;</button></p>
    
    </div>

    
    <asp:Repeater id="Repeater" runat="server">
        <HeaderTemplate>
                <table class="table table-striped" >
                <tr>
                <th>Aktie</th>
                <th>Antal</th>
                <th>GAVKurs</th>
                <th>Kurs</th>
                <th>Summa</th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
            <td><%# DataBinder.Eval(Container.DataItem,"Investment") %> </td>
            <td><%# DataBinder.Eval(Container.DataItem,"Antal") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"GAVKurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Kurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Summa") %></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>

               

</asp:Content>


