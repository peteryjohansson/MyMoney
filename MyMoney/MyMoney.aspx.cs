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
           // Repeater.Visible = false;

            if (!IsPostBack)
            {
                ViewState["Sort"]  = "Investment";
                ViewState["SortOder"] = "DESC";
                ViewState["Table"] = new List<String>();
            }

        }


        private void getTable(string table)
        {

            string mysqlcmnd = "SELECT * FROM money." + table + " order by Investment;";
            DataTable dt = new DataTable();
            float rate = 1;
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
                            var Kurs = row[3];
                            string Valuta = row[8].ToString();
                            if (string.Compare(Valuta, "SEK") != 0)
                            {
                                rate = ConvertExchangeRates(Valuta);
                            }

                            float Summa = (float)Antal * (float)Kurs * rate;
                            row[10] = Math.Round(Summa, 0);
                            rate = 1;
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

        private void getMultipleTable(string[] tables)
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
            float rate = 1;

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
                            var Kurs = row[3];
                            string Valuta = row[8].ToString();
                            if (string.Compare(Valuta, "SEK") != 0)
                            {
                                rate = ConvertExchangeRates(Valuta);
                            }

                            float Summa = (float)Antal * (float)Kurs * rate;
                            row[10] = Math.Round(Summa, 0);
                            rate = 1;
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

        public void UpdateStock(string symbol, decimal Kurs)
        {

            string mysqlcmnd = "UPDATE money.ips SET Kurs =  " + Kurs + " WHERE Symbol = " + quote + symbol + quote + ";";

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

        //public void UpdateStockPrice_onclickAV(object sender, EventArgs e)
        //{
        //    //  Welcome to Alpha Vantage! Here is your API key: APA3UI90FWXJA9IM
        //    //  string ApiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=1min&apikey=APA3UI90FWXJA9IM";
        //    //  https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&apikey=xxx&symbols=MSFT,AAPL,FB  Denna fungerar enbart med amerikanska aktier
        //    // NOTERA: För att använda detta så måste stockholms börsens aktier markeras med STO och inte ST

        //    string mysqlcmnd = "SELECT * FROM money.ips;";
        //    DataTable dt = new DataTable();

        //    //var symbol = "TSLA";
        //    var apiKey = "APA3UI90FWXJA9IM";
        //    //var MultiPrices = $"https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&apikey={apiKey}&symbols=MSFT,AAPL,FB&datatype=csv".GetStringFromUrl().FromCsv<List<AlphaVantageBatchData>>();
        //    //var Symb = MultiPrices.First().symbol;


        //    try
        //    {
        //        using (MySqlConnection connection = new MySqlConnection(conString))
        //        {
        //            connection.Open();

        //            using (MySqlCommand myCommand = new MySqlCommand(mysqlcmnd, connection))
        //            {

        //                using (MySqlDataAdapter mysqlDa = new MySqlDataAdapter(myCommand))
        //                mysqlDa.Fill(dt);

        //                foreach (DataRow row in dt.Rows)
        //                {
        //                    string symbol = row[9].ToString();

        //                    try
        //                    {
        //                        var Prices = $"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={symbol}&interval=1min&apikey={apiKey}&datatype=csv".GetStringFromUrl().FromCsv<List<AlphaVantageData>>();
        //                        var CurrentOpenPrice = Prices.First().Open;
        //                        UpdateStock(symbol, CurrentOpenPrice);

        //                        System.Threading.Thread.Sleep(20000);

        //                        Logger("DEBUG", symbol + " " + CurrentOpenPrice);
        //                    }
        //                    catch (Exception ex)
        //                    {
        //                        Logger("ERROR", symbol + " " + ex.Message);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger("ERROR", ex.Message);
        //    }
        //}


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
            
            if (Account.Contains("_"))
            {
                string[] tables = Account.Split('_');
                getMultipleTable(tables);
            }
            else
                getTable(Account);

            Repeater.Visible = true;
        }

        public async void UpdateStockPrice_onclickAsync(object sender, EventArgs e)
        {

            // key: bo5suuvrh5rbvm1sl1t0   https://finnhub.io/dashboard
            // https://finnhub.io/api/v1/quote?symbol=AAPL&token=bo5suuvrh5rbvm1sl1t0


            string mysqlcmnd = "SELECT * FROM money.ips;";
            string apiKey = "";

            DataTable dt = new DataTable();
            HttpClient client = new HttpClient();
            
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
                            string symbol = row[9].ToString();

                            //Logger("DEBUG", "Symbol: " + symbol);

                            try
                            {

                                string url = $"https://finnhub.io/api/v1/quote?symbol={symbol}&token={apiKey}";

                                string responseBody = await client.GetStringAsync(url);
                                FinnhubData StockData = JsonConvert.DeserializeObject<FinnhubData>(responseBody);
                                decimal CurrentOpenPrice = StockData.C;

                                System.Threading.Thread.Sleep(1000);
                                UpdateStock(symbol, CurrentOpenPrice);
                                Logger("DEBUG", symbol + " " + CurrentOpenPrice);
                            }
                            catch (Exception ex)
                            {
                                Logger("ERROR", symbol + " " + ex.Message);
                            }
                        }


                    }
                }
            }
            catch (Exception ex)
            {
                Logger("ERROR", ex.Message);
            }

            // Reload the table
            getTable("ips");
        }

        public float ConvertExchangeRates(string Valuta)
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
                return float.Parse(rate);

            }
            catch (Exception ex)
            {
                Logger("ERROR", "Problem med att hämta Exchange rates " + ex.Message);
                return 0;
            }

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
            // Get the argument.
            String argument = (String)e.CommandArgument;

            ViewState["Sort"] = argument;
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

            string table = ViewState["Table"].ToString();

            if (table.Contains("_"))
            {
                string[] tables = table.Split('_');
                getMultipleTable(tables);
            }
            else
            {
                getTable(table);
            }

        }
    }
}
