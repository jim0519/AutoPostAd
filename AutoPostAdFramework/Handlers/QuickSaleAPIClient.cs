using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using Common;
using Common.Models.XML;

namespace AutoPostAdBusiness.Handlers
{
    public class QuickSaleAPIClient:IQuickSaleAPIClient
    {

        public QuickSaleAPIClient()
        { 
        
        }

        #region IAPIClient Members

        public RP GetAPIRequest<RQ, RP>(RQ apiRequest)
        {
            var serviceUrl = AutoPostAdConfig.Instance.QuickSaleServiceURL;
            var xmlText = ConvertObjectToXML(apiRequest);

            var dataLen = Encoding.UTF8.GetByteCount(xmlText);
            var utf8Bytes = new byte[dataLen];
            Encoding.UTF8.GetBytes(xmlText, 0, xmlText.Length, utf8Bytes, 0);

            int maxround = 3, curround = 0;
            while (curround < maxround)
            {
                Stream str = null;

                var webRequest = WebRequest.Create(serviceUrl);

                webRequest.Method = "POST";
                webRequest.ContentType = "text/xml";
                webRequest.ContentLength = utf8Bytes.Length;

                webRequest.Headers.Add("API_Name", typeof(RQ).Name.Replace("Request", string.Empty));
                webRequest.Headers.Add("API_Version", "1");
                webRequest.Headers.Add("DevID", AutoPostAdConfig.Instance.QuickSaleDevID);
                webRequest.Headers.Add("DevToken", AutoPostAdConfig.Instance.QuickSaleDevToken);

                webRequest.Timeout = 30000;

                try
                {
                    //Set the request Stream
                    str = webRequest.GetRequestStream();
                    //Write the equest to the Request Steam
                    str.Write(utf8Bytes, 0, utf8Bytes.Length);
                    str.Close();
                    //Get response into stream
                    WebResponse resp = webRequest.GetResponse();
                    str = resp.GetResponseStream();
                }
                catch (WebException wEx)
                {
                    //Error has occured whilst requesting
                    //Display error message and exit.
                    if (wEx.Status == WebExceptionStatus.Timeout)
                    {
                        //Logger.Default.Write("Request Timed-Out at round " + curround + ".");
                        curround++;
                        if (curround < 5)
                            continue;
                    }
                    else
                    {
                        throw wEx;
                    }
                }

                if (str != null)
                {
                    var reader = new StreamReader(str);
                    var xml = reader.ReadToEnd();
                    try
                    {
                        var deserializer = new XmlSerializer(typeof(RP));
                        var result = (RP)deserializer.Deserialize(new StringReader(xml));
                        return result;
                    }
                    catch (Exception ex)
                    {
                        try
                        {
                            var deserializer = new XmlSerializer(typeof(ErrorResponse));
                            var errorResp = (ErrorResponse)deserializer.Deserialize(new StringReader(xml));
                            var errMsg = "";
                            errMsg += "APICallName: " + errorResp.APICallName + "\r\n";
                            errMsg += "APIVersion: " + errorResp.APIVersion + "\r\n";
                            errMsg += "OnDate: " + errorResp.OnDate + "\r\n";
                            errMsg += "ErrorCode: " + errorResp.ErrorCode + "\r\n";
                            var exCustom = new Exception(ex.Message + "\r\n"+errorResp.ErrorMsg+"\r\n"+errMsg);
                            ex = exCustom;
                        }
                        catch (Exception ex2)
                        {
                            var exCustom = new Exception("Cannot be deserialized exception.");
                            ex = exCustom;
                        }

                        throw ex;
                    }
                }
            }
            return default(RP);
        }

        #endregion

        private string ConvertObjectToXML<T>(T obj)
        {
            XmlSerializer x = new XmlSerializer(typeof(T));
            using (var strWtr = new StringWriter())
            {
                x.Serialize(strWtr, obj);
                return strWtr.ToString();
            }
        }
    }
}
