<%@ Page Title="MyMoney" Language="C#"AutoEventWireup="true" CodeBehind="MyMoney.aspx.cs" Inherits="Money._Default" Async="true" %>
<%--
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    
    --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>My Money</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.3/themes/default/style.min.css" />
 <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.3/jstree.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>

</head>
<body>
    <div id="page-wrapper" class="container">
      <div class="panel panel-info">
            <div class="panel-heading">
            </div>
    <div class="panel-body">
    <form role="form" runat="server">
         <div class="row">
             <div class="col-sm-3 col-md-6 col-lg-5">
                <h1>My Money</h1>
                <p class="lead">Här kommer jag att lära mig coola saker.</p>
        
                <p><button  class="btn btn-primary btn-lg" id="AF" runat="server" onserverclick="ShowTable">AF</button>
                  <button type="submit" class="btn btn-primary btn-lg" id="KF" runat="server" onserverclick="ShowTable">KF</button>
                   <button type="submit" class="btn btn-primary btn-lg" id="ISK" runat="server" onserverclick="ShowTable">ISK</button></p>
                <p><button type="submit" class="btn btn-primary btn-lg" id="IPS" runat="server" onserverclick="ShowTable">IPS (Pension)</button>
                   <button type="submit" class="btn btn-primary btn-lg" id="TJP" runat="server" onserverclick="ShowTable">TJP (Pension)</button></p>
                 <button type="submit" class="btn btn-primary btn-lg" id="IPS_TJP" runat="server" onserverclick="ShowTable">All Pension</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="AF_KF_ISK_IPS_TJP" runat="server" onserverclick="ShowTable">Alla Aktier</button>
             </div>
        <div class="col-sm-9 col-md-6 col-lg-7">
              <div class="jumbotron">
                    <asp:Repeater id="RepeaterTS" runat="server"  >
                            <HeaderTemplate>
                            <table class="table table-bordered table-hover table-condensed" >
                                    <tr>
                                    <th><asp:LinkButton runat="server" ID="Depå"  Text="Depå"  /></th>
                                    <th><asp:LinkButton runat="server" ID="Summa"  Text="Summa" /></th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="warning">
                                <td><%# DataBinder.Eval(Container.DataItem,"Depå") %></td>
                                <td><%# DataBinder.Eval(Container.DataItem,"Summa") %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                            </table>
                            </FooterTemplate>
                     </asp:Repeater>
             
            
                  <strong><input type="text" class="well well-sm  alert-success pull-right" id="totalSumField" runat="server" readonly /></strong>
            
             </div>
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
                    <th><asp:LinkButton runat="server" ID="LinkButton4" Text="Uppdatera" /></th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
            <td><%# DataBinder.Eval(Container.DataItem,"Investment") %> </td>
            <td><%# DataBinder.Eval(Container.DataItem,"Antal") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"GAVKurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Kurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Summa") %></td>
            <td><asp:ImageButton ImageUrl="Images\icon.png" runat="server" ID="UpdateInv" Text="Uppdatera Kurs" CommandName="UpdateStockPrice" CommandArgument=<%# DataBinder.Eval(Container.DataItem,"Symbol") %>/>  </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
        </form>
        </div>
</body>
</html>
