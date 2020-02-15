<%@ Page Title="MyMoney" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyMoney.aspx.cs" Inherits="Money._Default" Async="true" %>
 
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>My Money</h1>
        <p class="lead">Här kommer jag att lära mig coola saker.</p>
        <p><button type="submit" class="btn btn-primary btn-lg" id="UpdateStockPrice" runat="server" onserverclick="UpdateStockPrice_onclickAsync">Uppdatera kurser &raquo;</button></p>
        <p><button type="submit" class="btn btn-primary btn-lg" id="AF" runat="server" onserverclick="ShowTable">AF</button>
           <button type="submit" class="btn btn-primary btn-lg" id="KF" runat="server" onserverclick="ShowTable">KF</button>
            <button type="submit" class="btn btn-primary btn-lg" id="ISK" runat="server" onserverclick="ShowTable">ISK</button>
        </p>
        <p><button type="submit" class="btn btn-primary btn-lg" id="IPS" runat="server" onserverclick="ShowTable">IPS (Pension)</button>
           <button type="submit" class="btn btn-primary btn-lg" id="TJP" runat="server" onserverclick="ShowTable">TJP (Pension)</button>
           <button type="submit" class="btn btn-primary btn-lg" id="IPS_TJP" runat="server" onserverclick="ShowTable">All Pension</button>
            <button type="submit" class="btn btn-primary btn-lg" id="AF_KF_ISK_IPS_TJP" runat="server" onserverclick="ShowTable">Alla Aktier</button>
        </p>
    
    </div>

    
    <asp:Repeater id="Repeater" runat="server" OnItemCommand="Repeater_ItemCommand">
        <HeaderTemplate>
                <table class="table table-striped" >
                <tr>
                <th><asp:LinkButton runat="server" ID="SortByAktieButton" CommandName="Sort" Text="Aktie" CommandArgument="Investment" /></th>
                <th><asp:LinkButton runat="server" ID="SortByAntalButton" CommandName="Sort" Text="Antal" CommandArgument="Antal" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton1" CommandName="Sort" Text="GAVKurs" CommandArgument="GAVKurs" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton2" CommandName="Sort" Text="Kurs" CommandArgument="Kurs" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton3" CommandName="Sort" Text="Summa" CommandArgument="Summa" /></th>
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




<%--        <div class="form-group">
         <label for="NAnting" class="col-sm-3 control-label" >Aktier:</label>
         <div class="col-sm-8">
                 <asp:DropDownList class="form-control" ID="drpDownNames" value="" runat="server" readonly="true">
                 </asp:DropDownList>
          </div>
   </div>--%>

               

</asp:Content>


