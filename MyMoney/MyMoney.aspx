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

        p.one {
            border-style: dotted solid dashed double;
        }
    </style>


</head>


 <%--   <script type="text/javascript">
        google.charts.load("visualization", "1", { packages: ["corechart"] });
        google.charts.setOnLoadCallback(drawMainChart);

        google.charts.setOnLoadCallback(drawKFChart);

        function drawMainChart() {
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

            function drawKFChart() {
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
                url: "MyMoney.aspx/GetKFChartData",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var data = google.visualization.arrayToDataTable(r.d);
                    var chart = new google.visualization.PieChart($("#KFpiechart")[0]);
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
    </script>--%>



       <script type="text/javascript">
           google.charts.load("visualization", "1", { packages: ["corechart"] });
           google.charts.setOnLoadCallback(drawMainChart);

           function drawMainChart() {
               var options = {
                   width: 600,
                   height: 400,
                   chartArea: { left: 20, top: 50, width: '50%', height: '75%' },
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


 

   <!--Load the AJAX API-->
    <script type="text/javascript">

      google.charts.load('current', {'packages':['corechart', 'controls']});
      google.charts.setOnLoadCallback(drawDashboard);

      // Callback that creates and populates a data table, instantiates a dashboard, a range slider and a pie chart, passes in the data and draws it.
      function drawDashboard() {

        
        var dashboard = new google.visualization.Dashboard(document.getElementById('dashboard_div'));

        // Create a range slider, passing some options
        var aktieRangeSlider = new google.visualization.ControlWrapper({
          'controlType': 'NumberRangeFilter',
          'containerId': 'filter_div',
          'options': {
            'filterColumnLabel': 'Summa'
          }
        });

        // Create a pie chart, passing some options
        var pieChart = new google.visualization.ChartWrapper({
          'chartType': 'PieChart',
          'containerId': 'chart_div',
          'options': {
                   width: 600,
                   height: 400,
                   chartArea: { left: 20, top: 50, width: '100%', height: '100%' },
                   bar: { groupWidth: "95%" },
                     isStacked: true
          }
        });

          $.ajax({
                   type: "POST",
                   url: "MyMoney.aspx/GetKFChartData",
                   data: '{}',
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   success: function (r) {
                  var data = google.visualization.arrayToDataTable(r.d);
                  dashboard.bind(aktieRangeSlider, pieChart);
                  dashboard.draw(data);

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
 

 











<%--       <script type="text/javascript">
           $(document).ready(function () {
             $(".btn").click(function () {
         

           google.charts.load("visualization", "1", { packages: ["corechart"] });
           google.charts.setOnLoadCallback(drawKFChart);

           function drawKFChart() {
               var options = {
                   width: 600,
                   height: 400,
                   chartArea: { left: 20, top: 50, width: '50%', height: '75%' },
                   bar: { groupWidth: "95%" },
                   legend: { position: "none" },
                   isStacked: true
               };
               $.ajax({
                   type: "POST",
                   url: "MyMoney.aspx/GetKFChartData",
                   data: '{}',
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   success: function (r) {
                       var data = google.visualization.arrayToDataTable(r.d);
                       var chart = new google.visualization.PieChart($("#KFpiechart")[0]);
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

             });
         });
    </script>--%>


     <script>
         $(document).ready(function () {
             $(".btn").click(function () {
                 google.load("visualization", "1", { packages: ["corechart"], callback: drawChart });
                 function drawChart() {

                     var data = google.visualization.arrayToDataTable([
                         ['Task', 'Hours per Day'],
                         ['Work', 11],
                         ['Eat', 2],
                         ['Commute', 2],
                         ['Watch TV', 2],
                         ['Sleep', 7]
                     ]);

                     var options = {
                         title: 'My Daily Activities'
                     };

                     var chart = new google.visualization.PieChart(document.getElementById('pchart'));

                     chart.draw(data, options);
                 }
             });
         });
    </script>




<script>  
    $(document).ready(function () {
        jQuery('[id$="myBtn"]').click(function () {
            //var customID = $(this).attr('AntalValue');;  
            //var symbol= $(this).attr('SymbolValue');;  
            //alert(customID); 
            $(".modal-header #SymbolV").val($(this).attr('SymbolValue'));
            $(".modal-body #NyttAntal").val($(this).attr('AntalValue'));
            //document.getElementById("Symbol").innerHTML = symbol;

            $("#myModal").modal({ keyboard: true });
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
                 <button type="submit" class="btn btn-primary btn-lg" id="KF" runat="server" onserverclick="ShowTable" >KF</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="ISK" runat="server" onserverclick="ShowTable">ISK</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="IPS" runat="server" onserverclick="ShowTable">IPS</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="TJP" runat="server" onserverclick="ShowTable">TJP</button></p>
                 <p><button type="submit" class="btn btn-primary btn-lg" id="Crypto" runat="server" onserverclick="ShowTable">Krypto</button>
                 <button type="submit" class="btn btn-primary btn-lg" id="Tjanstepension" runat="server" onserverclick="ShowTable">Tjänstepensioner</button></p>
            

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

        <div class="c"> <p class="bg-warning text-white"><asp:Literal ID="tabellrubrik" Text="" runat="server"/></p></div>

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



        <asp:Repeater id="RepeaterPensionTabell" runat="server" OnItemCommand="Repeater_ItemCommand">
        <HeaderTemplate>
                <table class="table table-striped" >
                <tr>
                <th><asp:LinkButton runat="server" ID="SortByAktieButton" CommandName="Sort" Text="Pensionsbolag" CommandArgument="Pensionsbolag" /></th>
   <%--             <th><asp:LinkButton runat="server" ID="SortByAntalButton" CommandName="Sort" Text="Antal" CommandArgument="Antal" /></th>--%>
                <th><asp:LinkButton runat="server" ID="LinkButton1" CommandName="Sort" Text="Försäkringstyp" CommandArgument="Försäkringstyp" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton2" CommandName="Sort" Text="Förvaltningstyp" CommandArgument="Förvaltningstyp" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton5" CommandName="Sort" Text="Intjänathos" CommandArgument="Intjänathos" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton6" CommandName="Sort" Text="Möjligtid" CommandArgument="Möjligtid" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton12" CommandName="Sort" Text="UttagFrom" CommandArgument="UttagFrom" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton11" CommandName="Sort" Text="Avtaladtid" CommandArgument="Avtaladtid" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton7" CommandName="Sort" Text="Skydd" CommandArgument="Skydd" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton8" CommandName="Sort" Text="Skatt" CommandArgument="Skatt" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton9" CommandName="Sort" Text="Utbetalning" CommandArgument="Utbetalning" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton10" CommandName="Sort" Text="Värdedatum" CommandArgument="Värdedatum" /></th>
                <th><asp:LinkButton runat="server" ID="LinkButton3" CommandName="Sort" Text="Summa" CommandArgument="Summa" /></th>
                </tr>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
            <td><%# DataBinder.Eval(Container.DataItem,"Pensionsbolag") %> </td>
     <%--       <td><button type="button" AntalValue ="<%# DataBinder.Eval(Container.DataItem,"Antal") %>" SymbolValue ="<%# DataBinder.Eval(Container.DataItem,"Symbol") %>"  ID="myBtn" ><%# DataBinder.Eval(Container.DataItem,"Antal") %></button> </td>--%>
            <td><%# DataBinder.Eval(Container.DataItem,"Försäkringstyp") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Förvaltningstyp") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Intjänathos") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Möjligtid") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"UttagFrom") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Avtaladtid") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Skydd") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Skatt") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Utbetalning") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Värdedatum") %></td>
            <td><%# DataBinder.Eval(Container.DataItem,"Summa") %></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>


<%-- <div id="KFpiechart" runat="server"></div>
<button class="btn1">Plot chart!</button>
<div id="KFpiechart" class="piechart">Chart would be plotted here</div>--%>


           <!--Div that will hold the dashboard-->
    <div id="dashboard_div">
      <!--Divs that will hold each control and chart-->
      <div id="filter_div"></div>
      <div id="chart_div"></div>
    </div>
 



        </form>
        </div>
        </div>
        </div>






</body>
</html>











