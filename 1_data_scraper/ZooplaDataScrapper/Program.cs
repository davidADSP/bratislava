using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.IO;
using Newtonsoft.Json.Linq;

namespace ZooplaDataScrapper
{
    class Program
    {
        static void Main(string[] args)
        {
            // ScrapData();
            MergeCsvFiles();
        }


        public static void ParseJsonFiles()
        {
            var files = System.IO.Directory.GetFiles(System.IO.Directory.GetCurrentDirectory(), "*.json");
            foreach (var fileName in files)
            {
                Console.WriteLine(fileName);
                ParseJsonFile(fileName);
            }
        }

        public static void ParseJsonFile(string fileName)
        {
            StreamReader sr = new StreamReader(fileName);
            string jsonString = sr.ReadToEnd();
            sr.Close();

            JObject jsonObj = JObject.Parse(jsonString);
            var listings = jsonObj["listing"];
            StringBuilder sb = new StringBuilder();
            string header = "listing_id,agent_name,agent_phone,category,description,displayable_address,first_publish_date,image_url,last_publish_date,latitude,listing_status,longitude,new_home,num_bathrooms,num_beedrooms,num_floors,num_recepts,outcode,post_town,price,price_change,property_type,status,street_name".Replace(",", ";");
            sb.Append(header);
            sb.Append("\r");
            foreach (var listing in listings)
            {
                string agent_address = listing["agent_address"].ToString().Replace(';',' ');
                string agent_name = listing["agent_name"].ToString().Replace(';', ' ');
                string agent_phone = listing["agent_phone"].ToString().Replace(';', ' ');
                string category = listing["category"].ToString().Replace(';', ' ');
                string description = listing["description"].ToString().Replace('\n', ' ').Replace('\r', ' ').Replace(';', ' ');
                string displayable_address = listing["displayable_address"].ToString().Replace(';', ' ');
                string first_publish_date = listing["first_published_date"].ToString().Replace(';', ' ');
                string image_url = listing["image_url"].ToString().Replace(';', ' ');
                string last_publish_date = listing["last_published_date"].ToString().Replace(';', ' ');
                string latitude = listing["latitude"].ToString().Replace(';', ' ');
                string listing_id = listing["listing_id"].ToString().Replace(';', ' ');
                string listing_status = listing["listing_status"].ToString().Replace(';', ' ');
                string longitude = listing["longitude"].ToString().Replace(';', ' ');
                string new_home = "false";
                try
                {
                    new_home = listing["new_home"].ToString().Replace(';', ' ');
                }
                catch
                {

                }
                string num_bathrooms = listing["num_bathrooms"].ToString().Replace(';', ' ');
                string num_beedrooms = listing["num_bedrooms"].ToString().Replace(';', ' ');
                string num_floors = listing["num_floors"].ToString().Replace(';', ' ');
                string num_recepts = listing["num_recepts"].ToString().Replace(';', ' ');
                string outcode = listing["outcode"].ToString().Replace(';', ' ');
                string post_town = listing["post_town"].ToString().Replace(';', ' ');
                string price = listing["price"].ToString().Replace(';', ' ');
                string price_change = "";
                try
                {
                    listing["price_change"].ToString().Replace(';', ' ');
                }
                catch(Exception ex)
                {

                }
                price_change = price_change.Replace('\n', ' ').Replace('\r', ' ').Replace(';',' ');
                string property_type = listing["property_type"].ToString().Replace(';', ' ');
                string short_description = listing["short_description"].ToString().Replace(';', ' ');
                string status = listing["status"].ToString().Replace(';', ' ');
                string street_name = listing["street_name"].ToString().Replace(';', ' ');

                sb.Append(listing_id).Append(";").Append(agent_name).Append(";");
                sb.Append(agent_phone).Append(";").Append(category).Append(";");
                sb.Append(description.Replace(";", " ")).Append(displayable_address).Append(";");
                sb.Append(first_publish_date).Append(";").Append(image_url).Append(";");
                sb.Append(last_publish_date).Append(";").Append(latitude).Append(";");
                sb.Append(latitude).Append(";").Append(listing_status).Append(";");
                sb.Append(longitude).Append(";").Append(new_home).Append(";");
                sb.Append(num_bathrooms).Append(";").Append(num_beedrooms).Append(";");
                sb.Append(num_floors).Append(";").Append(num_recepts).Append(";");
                sb.Append(outcode).Append(";").Append(post_town).Append(";");
                sb.Append(price).Append(";").Append(price_change).Append(";");
                sb.Append(property_type).Append(";");
                sb.Append(status).Append(";").Append(street_name);
                sb.Append("\r");
            }
            int ii = 0;
            StreamWriter sw = new StreamWriter(fileName.Replace("json","csv"));
            sw.Write(sb.ToString());
            sw.Close();

        }


        public static void ScrapData()
        {
            string uri = "http://api.zoopla.co.uk/api/v1/property_listings.json?area=LONDON&api_key=dn4nfadswd4fe2x9e9bknaq6&page_size=100&listing_status=sale&include_sold=1&order_by=age&page_number=#pagenum#";
            for (int i = 0; i < 100; i++)
            {
                string pageUri = uri.Replace("#pagenum#", (i + 1).ToString());
                string response = GetResponseFromZoopla(pageUri);
                System.IO.StreamWriter sw = new System.IO.StreamWriter("requst_" + i.ToString() + ".json");
                sw.Write(response);
                sw.Close();
                ParseJsonFile("requst_" + i.ToString() + ".json");
                Console.WriteLine(i.ToString() + "/ 100");
            }
        }


        public static string GetResponseFromZoopla(string uri)
        {
            System.Net.WebRequest wr = System.Net.WebRequest.Create(uri);
            var response = wr.GetResponse();
            var stream = response.GetResponseStream();
            var encoding = ASCIIEncoding.ASCII;
            System.IO.StreamReader reader = new System.IO.StreamReader(stream, encoding);
            // Read the content.
            string res = reader.ReadToEnd();
            reader.Close();
            stream.Close();
            return res;
        }

        public static void MergeCsvFiles()
        {
            var files = System.IO.Directory.GetFiles(System.IO.Directory.GetCurrentDirectory(), "*.csv");
            StringBuilder sb = new StringBuilder();
            foreach (var fileName in files)
            {
                StreamReader sr = new StreamReader(fileName);
                //skip the header
                string line = sr.ReadLine();
                if (sb.Length == 0) sb.Append(line).Append('\r');
                line = sr.ReadLine();
                while (line != null)
                {
                    sb.Append(line);
                    sb.Append('\r');
                    line = sr.ReadLine();
                }
                sr.Close();
                Console.WriteLine(fileName);
            }
            StreamWriter sw = new StreamWriter("data_04_0" + DateTime.Now.Day + "_2017.csv");
            sw.Write(sb.ToString());
            sw.Close();
        }
    }
}
