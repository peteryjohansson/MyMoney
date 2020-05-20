using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using ServiceStack;
using ServiceStack.Text;
using System.Web.Services;

//drpDownNames.DataSource = dt;
//drpDownNames.DataTextField = dt.Columns["Investment"].ToString();
//drpDownNames.DataValueField = dt.Columns["Antal"].ToString();
//drpDownNames.DataBind();

namespace Money
{
    public partial class _Default : Page
    {
        string conString = WebConfigurationManager.AppSettings["MySqlConnectionString"];
        const string quote = "\"";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Logger("INFO", "Nu kör vi igång!");
            //Repeater.Visible = false;
            totalSumField.Value = "";
            totalKontanterField.Value = "";

            ShowSummary();

            if (!IsPostBack)
            {
                ViewState["Sort"] = "Investment";
                ViewState["SortOder"] = "DESC";
                ViewState["Table"] = new List<String>();
            }

        }

        [WebMethod]
        public static List<object> GetChartData()
        {
            List<object> chartData = new List<object>();
            chartData.Add(new object[]
            {
            "Depå", "Summa"
            });

            string conString = WebConfigurationManager.AppSettings["MySqlConnectionString"];
            string mysqlcmnd = "CALL `money`.`get_sums`();";
            DataTable dt = new DataTable();
                        
            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();
                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {
                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                        mysqlDa.Fill(dt);

                        var totalsumma =dt.Rows[0][1];
                        var kontantsumma = dt.Rows[1][1];
                        var teslasumma = dt.Rows[2][1];

                       int aktiersumma = Convert.ToInt32(totalsumma) - Convert.ToInt32(kontantsumma);

                        chartData.Add(new object[] { "Aktier", aktiersumma });
                        chartData.Add(new object[] { "Kontanter", kontantsumma });
                        chartData.Add(new object[] { "Tesla", teslasumma });

                    }
                }
            }
            catch (Exception ex)
            {
               // Logger("ERROR", ex.Message);
              // Här måste jag fundera ut hur jag ska fånga ett fel
            }

            return chartData;
        }

        [WebMethod]
        public static List<object> GetKFChartData()
        {
            List<object> chartData = new List<object>();
            chartData.Add(new object[]
            {
            "Depå", "Summa"
            });

            string conString = WebConfigurationManager.AppSettings["MySqlConnectionString"];
            string mysqlcmnd = "SELECT Investment, Antal, SEKKurs FROM money.kf;";
            DataTable dt = new DataTable();

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();
                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {
                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                        mysqlDa.Fill(dt);

                        foreach (DataRow row in dt.Rows)
                        {
                            var Antal = row[1];
                            var Kurs = row[2];

                            int Summa = Convert.ToInt32(Antal) * Convert.ToInt32(Kurs);
                            
                            chartData.Add(new object[] { row[0], Summa});
                        }
                        
                    }
                }
            }
            catch (Exception ex)
            {
                // Logger("ERROR", ex.Message);
                // Här måste jag fundera ut hur jag ska fånga ett fel
            }

            return chartData;
        }


        private void ShowSummary()
        {

            string mysqlcmnd = "SELECT * FROM money.total";
            DataTable dt = new DataTable();
            float totalsumma = 0;
            float kontantsumma = 0;
            
            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();

                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {

                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                        mysqlDa.Fill(dt);
                                                
                        foreach (DataRow row in dt.Rows)
                        {
                            totalsumma +=  (float)row[2];
                            kontantsumma += (float)row[3];
                        }
                        
              

                        totalSumField.Value = "MEGA Summa: " + totalsumma.ToString();
                        totalKontanterField.Value = "Kontanter: " + kontantsumma.ToString();

                        DataView dv = new DataView(dt);

                        RepeaterTS.DataSource = dv;
                        RepeaterTS.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }
        }

        private void GetTable(string table)
        {

            string mysqlcmnd = "SELECT * FROM money." + table + " order by Investment;";
            DataTable dt = new DataTable();
            ViewState["Table"] = table;

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();

                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {

                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                        mysqlDa.Fill(dt);

                        //Repeater.DataSource = dt;
                        dt.Columns.Add("Summa", typeof(float));

                        foreach (DataRow row in dt.Rows)
                        {
                            var Antal = row[2];
                            var Kurs = row[4];
                            
                            float Summa = (float)Antal * (float)Kurs;
                            row[12] = Math.Round(Summa, 0);
                        }

                        DataView dv = new DataView(dt);
                        dv.Sort = ViewState["Sort"].ToString();

                        //Om sortering har blivit begärt så behöver ta reda på i vilken ordning som det ska ske
                        if (!dv.Sort.IsEmpty())
                        {
                            dv.Sort = dv.Sort + " " + ViewState["SortOder"];
                        }
                        Repeater.DataSource = dv;

                        Repeater.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }
        }

        private void GetTjanstPensionTabell(string table)
        {

            string mysqlcmnd = "SELECT * FROM money." + table + " order by Pensionsbolag;";
            DataTable dt = new DataTable();
            ViewState["Table"] = table;
            ViewState["Sort"] = "Pensionsbolag";

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();

                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {

                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                            mysqlDa.Fill(dt);


                        DataView dv = new DataView(dt);
                        dv.Sort = ViewState["Sort"].ToString();

                        //Om sortering har blivit begärt så behöver ta reda på i vilken ordning som det ska ske
                        if (!dv.Sort.IsEmpty())
                        {
                            dv.Sort = dv.Sort + " " + ViewState["SortOder"];
                        }
                        RepeaterPensionTabell.DataSource = dv;
                        RepeaterPensionTabell.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }
        }


        private void GetMultipleTable(string[] tables)
        {

            //Bygg upp SQL kommandot med UNION
            //select * from money.tjp union select * from money.kf; 
            string mysqlcmnd = "SELECT * FROM money." +tables[0];

            ViewState["Table"] = tables[0];

            for (int i = 1; i < tables.Length; i++)
            {
                mysqlcmnd = mysqlcmnd + " union select * from money." + tables[i];
                ViewState["Table"] = ViewState["Table"] + "_" + tables[i];
            }
                
            mysqlcmnd = mysqlcmnd  + " order by Investment;";
            DataTable dt = new DataTable();
            
            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();

                    using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
                    {

                        using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
                            mysqlDa.Fill(dt);

                        //Repeater.DataSource = dt;
                        dt.Columns.Add("Summa", typeof(float));

                        foreach (DataRow row in dt.Rows)
                        {
                            var Antal = row[2];
                            var Kurs = row[4];
                            
                            float Summa = (float)Antal * (float)Kurs;
                            row[12] = Math.Round(Summa, 0);
                        }

                        DataView dv = new DataView(dt);
                        dv.Sort = ViewState["Sort"].ToString();

                        //Om sortering har blivit begärt så behöver ta reda på i vilken ordning som det ska ske
                        if (!dv.Sort.IsEmpty())
                        {
                            dv.Sort = dv.Sort + " " + ViewState["SortOder"];
                        }

                        Repeater.DataSource = dv;
                        Repeater.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }
        }

        public class AlphaVantageData
        {
            public DateTime Timestamp { get; set; }
            public decimal Open { get; set; }

            public decimal High { get; set; }
            public decimal Low { get; set; }

            public decimal Close { get; set; }
            public decimal Volume { get; set; }
        }

        public class AlphaVantageBatchData
        {

            public string symbol { get; set; }
            public decimal price { get; set; }
            public string volume { get; set; }
            public DateTime Timestamp { get; set; }
        }

        public void UpdateInvestment(string symbol, decimal Kurs, decimal rate)
        {
            string table = ViewState["Table"].ToString();
            decimal SEKKurs = Kurs * rate;
            string mysqlcmnd = "UPDATE money." + table + " SET Kurs =  " + Kurs + ", SEKKURS = " + SEKKurs + " WHERE Symbol = " + quote + symbol + quote + ";";

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();
                    MySqlCommand command = new MySqlCommand(mysqlcmnd, connection);
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }

        }
      
        public class FinnhubData
        {
            public decimal C { get; set; }
            public decimal H { get; set; }
            public decimal L { get; set; }
            public decimal O { get; set; }
            public decimal PC { get; set; }
        }

        public class ExchangerateData
        {
            public string b { get; set; }
            DateTime datetime { get; set; }
            public string[] rates { get; set; }
        }

        public void ShowTable(object sender, EventArgs e)
        {
            string Account = sender.GetObjectId().ToString();

            if (Account.Contains("Tjanstepension"))
            {
                GetTjanstPensionTabell(Account);
                Repeater.Visible = false;
                KFpiechart.Visible = false;
                RepeaterPensionTabell.Visible = true;
            }

            else if (Account.Contains("_"))
            {
                string[] tables = Account.Split('_');
                GetMultipleTable(tables);
                Repeater.Visible = true;
                RepeaterPensionTabell.Visible = false;
            }
            else
            {
                GetTable(Account);
                Repeater.Visible = true;
                RepeaterPensionTabell.Visible = false;
            }

            
            tabellrubrik.Text = Account;
            
        }

        public void UpdatePriceSpecial(string symbol, string valuta)
        {
            //  Welcome to Alpha Vantage! Here is your API key: APA3UI90FWXJA9IM
            //  string ApiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=1min&apikey=APA3UI90FWXJA9IM";
            //  https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&apikey=xxx&symbols=MSFT,AAPL,FB  Denna fungerar enbart med amerikanska aktier
            // NOTERA: För att använda detta så måste stockholms börsens aktier markeras med STO och inte ST

            //var symbol = "TSLA";
            var apiKey = "APA3UI90FWXJA9IM";
            decimal rate = 1;
            //var MultiPrices = $"https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&apikey={apiKey}&symbols=MSFT,AAPL,FB&datatype=csv".GetStringFromUrl().FromCsv<List<AlphaVantageBatchData>>();
            //var Symb = MultiPrices.First().symbol;

            try
            {
                var Prices = $"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={symbol}&interval=1min&apikey={apiKey}&datatype=csv".GetStringFromUrl().FromCsv<List<AlphaVantageData>>();
                var CurrentOpenPrice = Prices.First().Open;

                if (string.Compare(valuta, "SEK") != 0)
                {
                    rate = ConvertExchangeRates(valuta);
                }

                UpdateInvestment(symbol, CurrentOpenPrice, rate);
                rate = 1;
                                
                Logger("DEBUG", symbol + " " + CurrentOpenPrice);
            }
            catch (Exception ex)
            {
                Logger("ERROR", symbol + " " + ex.Message);
            }

        }

        public async void UpdatePrice(string symbol, string valuta)
        {

            // key: bo5suuvrh5rbvm1sl1t0   https://finnhub.io/dashboard
            // https://finnhub.io/api/v1/quote?symbol=AAPL&token=bo5suuvrh5rbvm1sl1t0
          
            string apiKey = "bo5suuvrh5rbvm1sl1t0";
            HttpClient client = new HttpClient();
            decimal rate = 1;

            try
            {
                string url = $"https://finnhub.io/api/v1/quote?symbol={symbol}&token={apiKey}";

                string responseBody = await client.GetStringAsync(url);
                FinnhubData StockData = JsonConvert.DeserializeObject<FinnhubData>(responseBody);
                decimal CurrentOpenPrice = StockData.C;

                if (string.Compare(valuta, "SEK") != 0)
                {
                    rate = ConvertExchangeRates(valuta);
                }


                UpdateInvestment(symbol, CurrentOpenPrice, rate);
                rate = 1;
                Logger("DEBUG", symbol + " " + CurrentOpenPrice);
            }

            catch (ArgumentNullException e)
            {
                Logger("ERROR", "UpdatePrice function (argumentnullexception). Symbol: " + symbol + " " + e.Message);
            }

            catch (Exception ex)
            {
                Logger("ERROR", "UpdatePrice function. Symbol: " + symbol + " " + ex.Message);
            }

            
        }

        public decimal ConvertExchangeRates(string Valuta)
        {
            //https://api.exchangeratesapi.io/latest?base=USD

            string url = $"https://api.exchangeratesapi.io/latest?base={Valuta}";
            var client = new System.Net.WebClient();

            try
            {
                string responseBody = client.DownloadString(url);
                int position = responseBody.IndexOf("SEK");
                string substring = responseBody.Substring(position + 5, 20);
                int endposition = substring.IndexOf(",");
                string rate = substring.Substring(0, endposition - 1);
                return decimal.Parse(rate);

            }
            catch (Exception ex)
            {
                Logger("ERROR", "Problem med att hämta Exchange rates " + ex.Message);
                return 0;
            }

        }

        public void UpdateAntal(string symbol, decimal antal)
        {
            string table = ViewState["Table"].ToString();
            
            string mysqlcmnd = "UPDATE money." + table + " SET Antal = " + quote + antal + quote + "WHERE SYMBOL = " + quote + symbol + quote + ";";

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();
                    MySqlCommand command = new MySqlCommand(mysqlcmnd, connection);
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }


        }

        public void ModalUpdateAntal(object sender, EventArgs e)
        {

            string Antal = NyttAntal.Value;
            string sym = SymbolV.Value;
            string table = ViewState["Table"].ToString();

            string mysqlcmnd = "UPDATE money." + table + " SET Antal = " + quote + Antal + quote + "WHERE SYMBOL = " + quote + sym + quote + ";";
            //  string mysqlcmnd = "UPDATE money.kf SET Antal = " + quote + "55" + quote + "WHERE SYMBOL = " + quote + "DIS" + quote + "; ";
            //string mysqlcmnd = "SELECT * FROM money.kf;";

            Logger("INFO", mysqlcmnd);

            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();
                    MySqlCommand command = new MySqlCommand(mysqlcmnd, connection);
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }

            GetTable(table);

        }

        public void Logger(string type, string message)
        {
            try
            {
                using (MySqlConnection connection = new MySqlConnection(conString))
                {
                    connection.Open();

                    string CommandText = "INSERT INTO log set type = @type, message = @message";
                    MySqlCommand command = new MySqlCommand(CommandText, connection);

                    command.Parameters.AddWithValue("@type", type);
                    command.Parameters.AddWithValue("@message", message);
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        protected void Repeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            String action = (String)e.CommandName;
            string table = ViewState["Table"].ToString();

            

            if (action == "Sort")
            {

                String kolumn = e.CommandArgument.ToString();

                ViewState["Sort"] = kolumn;
                string sortorder = ViewState["SortOder"].ToString();

                //Sort out the sort order ;-)

                if (sortorder == "ASC")
                {

                    ViewState["SortOder"] = "DESC";
                }
                else if (sortorder == "DESC")
                {
                    ViewState["SortOder"] = "ASC";
                }

                
                if (table.Contains("_"))
                {
                    string[] tables = table.Split('_');
                    GetMultipleTable(tables);
                }
                else
                {
                    GetTable(table);
                }
            }

            if (action == "UpdateStockPrice")
            {

                String[] arguments = e.CommandArgument.ToString().Split(new char[] { ',' });
                string symbol = arguments[0];
                string valuta = arguments[1];

                string[] Specialaktier = WebConfigurationManager.AppSettings["SpecialAktier"].Split(',');

                bool special = false;

                foreach (string aktie in Specialaktier)
                {
                    if (aktie == symbol)
                    {
                        special = true;
                    }

                }

                if (special == true)
                {
                    UpdatePriceSpecial(symbol, valuta);
                }
                else
                {
                    UpdatePrice(symbol, valuta);
                }


                //Läs in tabellen på nytt
                if (table.Contains("_"))
                {
                    string[] tables = table.Split('_');
                    GetMultipleTable(tables);
                }
                else
                {
                    GetTable(table);
                }
            }

        }

    }
}
