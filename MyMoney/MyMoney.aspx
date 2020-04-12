<%@ Page EnableEventValidation="false" Language="C#"AutoEventWireup="true" CodeBehind="MyMoney.aspx.cs" Inherits="Money._Default" Async="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>My Money</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.3/themes/default/style.min.css" />
   <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

    <style>
            div.c {
              text-align: center;
            }

            p.one {border-style: dotted solid dashed double;}

</style>


</head>


    <script type="text/javascript">
        google.charts.load("visualization", "1", { packages: ["corechart"] });
        google.charts.setOnLoadCallback(drawChart);
        function drawChart() {
            var options = {
                width: 600,
                height: 400,
                chartArea:{left:20,top:50,width:'50%',height:'75%'},
                bar: { groupWidth: "95%" },
                legend: { position: "none" },
                isStacked: true
            };
            $.ajax({
                type: "POST",
                url: "MyMoney.aspx/GetChartData",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var data = google.visualization.arrayToDataTable(r.d);
                    var chart = new google.visualization.PieChart($("#piechart")[0]);
                    chart.draw(data, options);
                },
                failure: function (r) {
                    alert(r);
                },
                error: function (r) {
                    alert(r);
                }
            });
        } 
    </script>

<%--    <script>
    $(document).ready(function ()
    {
        $("#myBtn").click(function ()
        {
            $("#myModal").modal({keyboard: true});
        });
    });
</script>--%>



<script>  
$(document).ready(function() {  
   jQuery('[id$="myBtn"]').click(function() {  
   //var customID = $(this).attr('AntalValue');;  
       //var symbol= $(this).attr('SymbolValue');;  
       //alert(customID); 
        $(".modal-header #SymbolV").val($(this).attr('SymbolValue'));
       $(".modal-body #NyttAntal").val($(this).attr('AntalValue'));
       //document.getElementById("Symbol").innerHTML = symbol;

           $("#myModal").modal({keyboard: true});
        });  
    });  
    </script> 




<body>
    <div  class="container">
      <div class="panel panel-info">
            <div class="panel-heading"> My Money </div>
       
    <div class="panel-body">
    <form role="form" runat="server">
         <div class="row">
        <div class="col-sm-3 col-md-6 col-lg-5">

                <div id="piechart"></div>
                  <br /> <p></p>
                 <p><button  class="btn btn-primary btn-lg" id="AF" runat="server" onserverclick="ShowTable">AF</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="KF" runat="server" onserverclick="ShowTable">KF</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="ISK" runat="server" onserverclick="ShowTable">ISK</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="IPS" runat="server" onserverclick="ShowTable">IPS</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="TJP" runat="server" onserverclick="ShowTable">TJP</button></p>
                 <p><button type="submit" class="btn btn-primary btn-lg" id="Crypto" runat="server" onserverclick="ShowTable">Krypto</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="TjanstePensioner" runat="server" onserverclick="ShowTable">Tjänstepensioner</button></p>
            

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
             
                  <strong><input type="text" class="well well-sm  alert-success pull-left" id="totalKontanterField" runat="server" readonly /></strong>
                  <strong><input type="text" class="well well-sm  alert-success pull-right" id="totalSumField" runat="server" readonly /></strong>
            
             </div>
             </div>
             <div class="col-sm-9 col-md-6 col-lg-7">
                 <div class="text-right mb-3">
                     <button type="submit" class="btn btn-primary btn-lg" id="IPS_TJP" runat="server" onserverclick="ShowTable">All Pension</button>
                     <button type="submit" class="btn btn-primary btn-lg " id="AF_KF_ISK_IPS_TJP" runat="server" onserverclick="ShowTable">Alla Aktier</button>
                 </div>
             </div>
      </div>     


        <!-- Button to Open the Modal -->
<%--        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" >  Open modal </button>--%>
   <%--     <button type="button" class="btn btn-primary" id="myBtn">Open Modal using Java</button>--%>



            <!-- The Modal -->
            <div class="modal" id="myModal">
              <div class="modal-dialog">
                <div class="modal-content">

                  <div class="modal-header">
                    <h4 class="modal-title">My Money</h4>
                     
              <%--      <div class="c"><p id="Symbol" ></p></div>--%>
                      <div class="c"><input type ="text" style="border-bottom" id="SymbolV" readonly runat ="server"/></div>
 
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                  </div>

                  <div class="modal-body">
                      <div class="form-group">
                                    <label " for="NyttAntal"  >Ange antal :</label>
                                     <input type="text"  class="form-control" id="NyttAntal" runat ="server" />
                    </div>
                   </div>

                  <div class="modal-footer">
                     <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" runat ="server" ID="ModalSubmit" onserverclick ="ModalUpdateAntal" >Submit</button>        
                  </div>
    
              </div>
              </div>
            </div>


<%--        <asp:RegularExpressionValidator id="RegularExpressionValidator1" 
            ControlToValidate="NyttAntal"
            ValidationExpression="\d\d*\.?\d*"
            Display="Static"
            ErrorMessage="Ange en antal större än 0"
            runat="server"/>--%>






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
      <%--      <td><asp:LinkButton  runat="server" ID="UpdateAntal" CommandName="UpdateAntal" Text=<%# DataBinder.Eval(Container.DataItem,"Antal") %> CommandArgument=<%# DataBinder.Eval(Container.DataItem,"Symbol") %> /></td>--%>
        <%--    <td><button type="button"  data-toggle="modal" data-target="#myModal"> <%# DataBinder.Eval(Container.DataItem,"Antal") %> </button> </td>--%>
<%--            <td><button type="button" class="btn btn-primary"  id="myBtn"> <%# DataBinder.Eval(Container.DataItem,"Antal") %> </button> </td>  --%>

             <td><button type="button" AntalValue ="<%# DataBinder.Eval(Container.DataItem,"Antal") %>" SymbolValue ="<%# DataBinder.Eval(Container.DataItem,"Symbol") %>"  ID="myBtn" ><%# DataBinder.Eval(Container.DataItem,"Antal") %></button> </td>
            <td><%# DataBinder.Eval(Container.DataItem,"GAVKurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Kurs") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Summa") %></td>
            <td><asp:ImageButton ImageUrl="Images\icon.png" runat="server" ID="UpdateInv" CommandName="UpdateStockPrice" CommandArgument=<%# DataBinder.Eval(Container.DataItem,"Symbol") + "," + DataBinder.Eval(Container.DataItem,"Valuta") %>/>  </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
        </form>
        </div>
        </div>
        </div>
</body>
</html>









