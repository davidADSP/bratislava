using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace RfacadeTool
{
    public class RRequestParameter
    {
        public string Name;
        public string Value;
    }


    public class RFacade
    {
        public Dictionary<String, string> cache = new Dictionary<string, string>();

        public void ClearCache()
        {
            cache = new Dictionary<string, string>();
        }


        public string MakeRRequest(string methodName, List<RRequestParameter> prms)
        {
            string strToSend = methodName;
            if (prms.Count > 0)
            {
                strToSend += ";" + Newtonsoft.Json.JsonConvert.SerializeObject(prms);

            }
            strToSend += '\n';
            strToSend += '\r';
            if (cache.ContainsKey(strToSend)) return cache[strToSend];

            IPAddress ipAddress = IPAddress.Parse("10.18.0.33");
            IPEndPoint remoteEP = new IPEndPoint(ipAddress, 8089);
            // Create a TCP/IP  socket.  
            Socket sender = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

            sender.Connect(remoteEP);

            

            byte[] msg = Encoding.ASCII.GetBytes(strToSend);
            int bytesSent = sender.Send(msg);
            byte[] messageLengthBytes = new byte[665535];
            int receivedBytes = sender.Receive(messageLengthBytes);
            sender.Close();
            string response = System.Text.ASCIIEncoding.Default.GetString(messageLengthBytes,0,receivedBytes);
            cache[strToSend] = response;
            return response;
        }

    }


}
 