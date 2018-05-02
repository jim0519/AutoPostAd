using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Xml.Serialization;
using Autofac;
using log4net;
using System.Drawing;
using System.Drawing.Drawing2D;
using NCalc;
using System.Linq.Expressions;
using System.Collections.Specialized;
using System.Threading;
using System.Management;
using System.Net.NetworkInformation;

namespace Common
{

    #region Log Manager
    public class LogManager
    {
        private static ILog _instance;
        private LogManager()
        {

        }

        public static ILog Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = log4net.LogManager.GetLogger("CustomLogger");
                }
                return _instance;
            }
        }

    }
    #endregion

    #region WebClients

    public class GumtreeWebClient : WebClient
    {
        private string _userAgent;

        protected string UserAgent { get { return !string.IsNullOrEmpty(_userAgent) ? _userAgent : AutoPostAdConfig.Instance.UserAgent; } }

        public CookieContainer CookieContainer { get; set; }
        public WebResponse Response { get; private set; } 

        public GumtreeWebClient()
            : this(new CookieContainer(), AutoPostAdConfig.Instance.UserAgent)
        {
        }

        public GumtreeWebClient(CookieContainer cookies,string userAgent)
        {
            this.CookieContainer = cookies;
            _userAgent = userAgent;
        }

        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest request = base.GetWebRequest(address);
            if (request is HttpWebRequest)
            {
                (request as HttpWebRequest).CookieContainer = this.CookieContainer;
            }
            HttpWebRequest httpRequest = (HttpWebRequest)request;
            httpRequest.Timeout = 200 * 1000;
            

            return httpRequest;
        }

        protected override WebResponse GetWebResponse(WebRequest request)
        {
            WebResponse response = base.GetWebResponse(request);
            String setCookieHeader = response.Headers[HttpResponseHeader.SetCookie];
            this.Response = response;
            if (setCookieHeader != null)
            {
                //do something if needed to parse out the cookie.
                if (setCookieHeader != null)
                {
                    //Cookie cookie = new Cookie(); //create cookie
                    ////cookie.Domain=""
                    //this.CookieContainer.Add(cookie);
                }
            }
            return response;
        }
    }

    public class DownloadImageWebClient : GumtreeWebClient
    {

        public DownloadImageWebClient(CookieContainer cookies)
            : this(cookies, AutoPostAdConfig.Instance.UserAgent)
        {

        }

        public DownloadImageWebClient(CookieContainer cookies,string userAgent)
            : base(cookies, userAgent)
        {

        }

        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest request = base.GetWebRequest(address);
            if (request is HttpWebRequest)
            {
                (request as HttpWebRequest).CookieContainer = this.CookieContainer;
            }
            HttpWebRequest httpRequest = (HttpWebRequest)request;
            httpRequest.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;
            httpRequest.Accept = "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*";
            httpRequest.UserAgent = UserAgent;
            httpRequest.Headers.Add("Accept-Language", "en-AU");
            httpRequest.KeepAlive = false;
            return httpRequest;
        }

    }

    //public class CookieAwareWebClient : WebClient
    //{
    //    public void Login(string loginPageAddress, NameValueCollection loginData)
    //    {
    //        CookieContainer container;

    //        var request = (HttpWebRequest)WebRequest.Create(loginPageAddress);

    //        request.Method = "POST";
    //        request.ContentType = "application/x-www-form-urlencoded";
    //        var buffer = Encoding.ASCII.GetBytes(loginData.ToString());
    //        request.ContentLength = buffer.Length;
    //        var requestStream = request.GetRequestStream();
    //        requestStream.Write(buffer, 0, buffer.Length);
    //        requestStream.Close();

    //        container = request.CookieContainer = new CookieContainer();

    //        var response = request.GetResponse();
    //        response.Close();
    //        CookieContainer = container;
    //    }

    //    public CookieAwareWebClient(CookieContainer container)
    //    {
    //        CookieContainer = container;
    //    }

    //    public CookieAwareWebClient()
    //        : this(new CookieContainer())
    //    { }

    //    public CookieContainer CookieContainer { get; private set; }

    //    protected override WebRequest GetWebRequest(Uri address)
    //    {
    //        var request = (HttpWebRequest)base.GetWebRequest(address);
    //        request.CookieContainer = CookieContainer;
    //        return request;
    //    }
    //}

    public class GumtreeLoginWebClient : GumtreeWebClient
    {
        public GumtreeLoginWebClient():base()
        {
        }

        public GumtreeLoginWebClient(CookieContainer cookies)
        {
            this.CookieContainer = cookies;
        }


        public void Login(string loginMail, string loginPassword)
        {
            var loginData = new List<KeyValuePair<string, string>>();
            loginData.Add(new KeyValuePair<string, string>("targetUrl", ""));
            loginData.Add(new KeyValuePair<string, string>("likingAd", "false"));
            loginData.Add(new KeyValuePair<string, string>("loginMail", loginMail));
            loginData.Add(new KeyValuePair<string, string>("password", loginPassword));
            loginData.Add(new KeyValuePair<string, string>("rememberMe", "true"));
            loginData.Add(new KeyValuePair<string, string>("_rememberMe", "on"));


            var strPostData = "";
            foreach (var nv in loginData)
            {
                strPostData += nv.Key + "=" + nv.Value + "&";
            }
            strPostData = strPostData.Trim('&');
            var buffer = Encoding.ASCII.GetBytes(strPostData);

            CookieContainer container;
            var request = (HttpWebRequest)WebRequest.Create("https://www.gumtree.com.au/t-login.html");
            //request.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            request.Headers.Add("Accept-Encoding", "gzip, deflate");
            //request.Headers.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
            //request.Headers.Add("User-Agent", this.UserAgent);
            request.Headers.Add("Accept-Language", "en-US,en;q=0.8,ja;q=0.6,zh-CN;q=0.4,zh-TW;q=0.2");
            //request.Headers.Add("Referer", "https://www.gumtree.com.au/t-login-form.html");
            request.Headers.Add("Origin", "https://www.gumtree.com.au");
            request.Headers.Add("Upgrade-Insecure-Requests", "1");
            //request.Headers.Add("Host", "www.gumtree.com.au");
            request.Headers.Add("Cache-Control", "max-age=0");
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
            request.UserAgent = this.UserAgent;
            request.Referer = "https://www.gumtree.com.au/t-login-form.html";
            request.Host = "www.gumtree.com.au";
            
            request.ContentLength = buffer.Length;
            var requestStream = request.GetRequestStream();
            requestStream.Write(buffer, 0, buffer.Length);
            requestStream.Close();
            container = request.CookieContainer = new CookieContainer();

            var response = request.GetResponse();
            response.Close();
            this.CookieContainer = container;


            //this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            //this.Headers.Add("Accept-Encoding", "gzip, deflate");
            //this.Headers.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
            ////this.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36");
            ////this.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2");
            //this.Headers.Add("User-Agent",this.UserAgent);
            //this.Headers.Add("Accept-Language", "en-US,en;q=0.8,ja;q=0.6,zh-CN;q=0.4,zh-TW;q=0.2");
            ////this.Headers.Add("Connection", "keep-alive");
            //this.Headers.Add("Referer", "https://www.gumtree.com.au/t-login-form.html");
            //this.Headers.Add("Origin", "https://www.gumtree.com.au");
            //this.Headers.Add("Upgrade-Insecure-Requests", "1");
            //this.Headers.Add("Host", "www.gumtree.com.au");
            //this.Headers.Add("Cache-Control", "max-age=0");

            //this.UploadData("https://www.gumtree.com.au/t-login.html", "POST", buffer);
        }

        protected override WebResponse GetWebResponse(WebRequest request)
        {
            WebResponse response = base.GetWebResponse(request);

            return response;
        }
    }


    public class PostAdWebClient : GumtreeWebClient
    { 
        public string PostAdID { get; set; }
        public string ErrorMessage { get; set; }

        public PostAdWebClient(CookieContainer cookies)
            : this(cookies, AutoPostAdConfig.Instance.UserAgent)
        {

        }

        public PostAdWebClient(CookieContainer cookies, string userAgent)
            : base(cookies, userAgent)
        {

        }

        public string PostAd(string postString, string refererLink)
        { 
            var encoding = new UTF8Encoding();
            byte[] postData = encoding.GetBytes(postString);
            return PostAd(postData, refererLink);
        }

        public string PostAd(byte[] buffer,string refererLink)
        {
            try
            {
                this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                this.Headers.Add("Accept-Encoding", "gzip, deflate");
                this.Headers.Add("Accept", "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*");
                //this.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36");
                //this.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2");
                this.Headers.Add("User-Agent", UserAgent);
                this.Headers.Add("Accept-Language", "en-US");
                this.Headers.Add("Pragma", "no-cache");
                //this.Headers.Add("Connection", "keep-alive");
                this.Headers.Add("Referer", refererLink);
                //this.Headers.Add("Origin", "https://www.gumtree.com.au");
                //this.Headers.Add("Upgrade-Insecure-Requests", "1");
                //this.Headers.Add("Host", "www.gumtree.com.au");
                //this.Headers.Add("Cache-Control", "max-age=0");


                this.UploadData(GumtreeURL.SubmitAd, "POST", buffer);
                return PostAdID;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        
        protected override WebResponse GetWebResponse(WebRequest request)
        {
            
            try
            {
                WebResponse response = base.GetWebResponse(request);
                var responseURL = response.ResponseUri.AbsoluteUri;
                //var returnAdID = Regex.Match(responseURL, @"\d{10}").Value;
                var returnMatches = Regex.Matches(responseURL, @"\d{10}");
                var returnAdID = string.Empty;
                if (returnMatches!=null&&returnMatches.Count>0)
                {
                    returnAdID=returnMatches.OfType<Match>().Select(m => Convert.ToInt64(m.Value)).Max().ToString();
                }
                if (!string.IsNullOrEmpty(returnAdID))
                    PostAdID = returnAdID;
                else
                    ErrorMessage = "Ad post failed.";
                return response;
                
            }
            catch (WebException webex)
            {
                var exResponseURL = webex.Response.ResponseUri.AbsoluteUri;
                //var exreturnAdID = Regex.Match(exResponseURL, @"\d{10}").Value;
                var exReturnMatches = Regex.Matches(exResponseURL, @"\d{10}");
                var exreturnAdID = string.Empty;
                if (exReturnMatches != null && exReturnMatches.Count > 0)
                {
                    exreturnAdID = exReturnMatches.OfType<Match>().Select(m => Convert.ToInt64(m.Value)).Max().ToString();
                }
                webex.Response.Close();//do not know if need to add this code
                var expostAdIDKey = HttpUtility.ParseQueryString(exResponseURL).GetKey(0);
                if (!string.IsNullOrEmpty(exreturnAdID))
                    PostAdID = exreturnAdID;
                else
                    ErrorMessage = "Ad post failed.";
                LogManager.Instance.Error(webex.Message + (!string.IsNullOrEmpty(PostAdID)?" with success Ad ID "+PostAdID:""));
                return webex.Response;
            }
            catch (Exception ex)
            {
                throw ex;
            }
                
            
        }
    }

    public class GetGumtreePageClient :GumtreeWebClient
    {

        public GetGumtreePageClient(CookieContainer cookies)
            : this(cookies, AutoPostAdConfig.Instance.UserAgent)
        {

        }

        public GetGumtreePageClient(CookieContainer cookies, string userAgent)
            : base(cookies, userAgent)
        {

        }

        public string GetGumtreePage(string url,string referURL="")
        {
            this.Headers.Add("Pragma", "no-cache");
            this.Headers.Add("Accept-Language", "en-AU");
            this.Headers.Add("Accept", "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*");
            //this.Headers.Add("Accept-Encoding", "gzip, deflate");
            this.Headers.Add("User-Agent", UserAgent);
            this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            if (!string.IsNullOrEmpty(referURL))
                this.Headers.Add("Referer", referURL);
            ////this.Headers.Add("Connection", "Close");
            this.Encoding = System.Text.Encoding.UTF8;
            //var returnHtml="";
            //int retryTime = 0;
            //while (string.IsNullOrEmpty(returnHtml) && retryTime < 10)
            //{
            //    try
            //    {
            //        returnHtml = DownloadString(url);
            //    }
            //    catch (Exception ex)
            //    {
            //        if (retryTime == 9)
            //            throw ex;
            //    }
            //    retryTime++;
            //}
            var returnHtml = DownloadString(url);
            return returnHtml;
        }
    }

    public class MyAdPageClient : GumtreeWebClient
    {

        public MyAdPageClient(CookieContainer cookies)
            : this(cookies, AutoPostAdConfig.Instance.UserAgent)
        {

        }

        public MyAdPageClient(CookieContainer cookies, string userAgent)
            : base(cookies, userAgent)
        {

        }

        public string GetMyAdPage(string url)
        {
            this.Headers.Add("Cache-Control", "no-cache");
            this.Headers.Add("Pragma", "no-cache");
            this.Headers.Add("Upgrade-Insecure-Requests", "1");
            this.Headers.Add("Accept-Language", "en-US,en;q=0.8,ja;q=0.6,zh-CN;q=0.4,zh-TW;q=0.2");
            this.Headers.Add("Accept-Language", "en-AU");
            this.Headers.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
            //this.Headers.Add("Accept-Encoding", "gzip, deflate, sdch, br");///!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!! Do not add this in the header because it will cause encode problem
            this.Headers.Add("User-Agent", UserAgent);
            this.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            //if (!string.IsNullOrEmpty(referURL))
            //    this.Headers.Add("Referer", referURL);
            ////this.Headers.Add("Connection", "Close");
            this.Encoding = System.Text.Encoding.UTF8;
            //var returnHtml="";
            //int retryTime = 0;
            //while (string.IsNullOrEmpty(returnHtml) && retryTime < 10)
            //{
            //    try
            //    {
            //        returnHtml = DownloadString(url);
            //    }
            //    catch (Exception ex)
            //    {
            //        if (retryTime == 9)
            //            throw ex;
            //    }
            //    retryTime++;
            //}
            var returnHtml = DownloadString(url);
            return returnHtml;
        }
    }


    public class DeleteGumtreeAdClient : GumtreeWebClient
    {

        public DeleteGumtreeAdClient(CookieContainer cookies)
            : this(cookies, AutoPostAdConfig.Instance.UserAgent)
        {

        }

        public DeleteGumtreeAdClient(CookieContainer cookies, string userAgent)
            : base(cookies, userAgent)
        {

        }

        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest request = base.GetWebRequest(address);
            
            HttpWebRequest httpRequest = (HttpWebRequest)request;
            //submitRequest.Headers.Add(HttpRequestHeader.Cookie, postAdData.Cookie);
            httpRequest.Headers.Add("Accept-Language", "en-AU");
            httpRequest.Headers.Add("Accept-Encoding", "gzip, deflate");
            httpRequest.KeepAlive = false;
            httpRequest.Accept = "text/html, application/xhtml+xml, */*";
            httpRequest.Method = "GET";
            httpRequest.Referer = GumtreeURL.MyAd;
            httpRequest.UserAgent = UserAgent;
            
            return httpRequest;
        }

        public void DeleteAd(string url)
        {
            //this.Headers.Add("Accept-Language", "en-AU");
            //this.Headers.Add("Accept-Encoding", "gzip, deflate");
            //this.Headers.Add("Accept", "text/html, application/xhtml+xml, */*");
            //this.Headers.Add("Referer", GumtreeURL.MyAd);
            //this.Headers.Add("User-Agent", AutoPostAdConfig.Instance.UserAgent);
            

            this.DownloadString(url);
        }
    }

    #endregion


    #region NetworkManagement
    public class NetworkManagement
    {
        /// <summary>
        /// Set's a new IP Address and it's Submask of the local machine
        /// </summary>
        /// <param name="ip_address">The IP Address</param>
        /// <param name="subnet_mask">The Submask IP Address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setIP(string ip_address, string subnet_mask)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    try
                    {
                        ManagementBaseObject setIP;
                        ManagementBaseObject newIP =
                            objMO.GetMethodParameters("EnableStatic");

                        newIP["IPAddress"] = new string[] { ip_address };
                        newIP["SubnetMask"] = new string[] { subnet_mask };

                        setIP = objMO.InvokeMethod("EnableStatic", newIP, null);
                    }
                    catch (Exception)
                    {
                        throw;
                    }


                }
            }
        }
        /// <summary>
        /// Set's a new Gateway address of the local machine
        /// </summary>
        /// <param name="gateway">The Gateway IP Address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setGateway(string gateway)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    try
                    {
                        ManagementBaseObject setGateway;
                        ManagementBaseObject newGateway =
                            objMO.GetMethodParameters("SetGateways");

                        newGateway["DefaultIPGateway"] = new string[] { gateway };
                        newGateway["GatewayCostMetric"] = new int[] { 1 };

                        setGateway = objMO.InvokeMethod("SetGateways", newGateway, null);
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                }
            }
        }
        /// <summary>
        /// Set's the DNS Server of the local machine
        /// </summary>
        /// <param name="NIC">NIC address</param>
        /// <param name="DNS">DNS server address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setDNS(string NIC, string DNS)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    // if you are using the System.Net.NetworkInformation.NetworkInterface you'll need to change this line to if (objMO["Caption"].ToString().Contains(NIC)) and pass in the Description property instead of the name 
                    if (objMO["Caption"].Equals(NIC))
                    {
                        try
                        {
                            ManagementBaseObject newDNS =
                                objMO.GetMethodParameters("SetDNSServerSearchOrder");
                            newDNS["DNSServerSearchOrder"] = DNS.Split(',');
                            ManagementBaseObject setDNS =
                                objMO.InvokeMethod("SetDNSServerSearchOrder", newDNS, null);
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Set's WINS of the local machine
        /// </summary>
        /// <param name="NIC">NIC Address</param>
        /// <param name="priWINS">Primary WINS server address</param>
        /// <param name="secWINS">Secondary WINS server address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setWINS(string NIC, string priWINS, string secWINS)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    if (objMO["Caption"].Equals(NIC))
                    {
                        try
                        {
                            ManagementBaseObject setWINS;
                            ManagementBaseObject wins =
                            objMO.GetMethodParameters("SetWINSServer");
                            wins.SetPropertyValue("WINSPrimaryServer", priWINS);
                            wins.SetPropertyValue("WINSSecondaryServer", secWINS);

                            setWINS = objMO.InvokeMethod("SetWINSServer", wins, null);
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        public bool IsNetworkAvailable()
        {
            //return System.Net.NetworkInformation.NetworkInterface.GetIsNetworkAvailable();
            try
            {
                Ping myPing = new Ping();
                String host = "www.google.com.au";
                byte[] buffer = new byte[32];
                int timeout = 1000;
                PingOptions pingOptions = new PingOptions();
                PingReply reply = myPing.Send(host, timeout, buffer, pingOptions);
                if (reply.Status == IPStatus.Success)
                {
                    return true;
                }
                return false;
            }
            catch (PingException pex)
            {
                return false;
            }


        }

        public List<object> GetNICNames()
        {
            var nicNames = new List<object>();

            ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection moc = mc.GetInstances();

            foreach (ManagementObject mo in moc)
            {
                if ((bool)mo["ipEnabled"])
                {
                    nicNames.Add(mo["Caption"]);
                }
            }

            return nicNames;
        }
    }

    #endregion


    #region Check if link valid web client

    public class HeadOnlyWebClient : WebClient
    {
        public bool HeadOnly { get; set; }
        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest req = base.GetWebRequest(address);
            if (HeadOnly && req.Method == "GET")
            {
                req.Method = "HEAD";
            }
            return req;
        }
    }

    #endregion

    #region Common Interface

    public interface IObjectParser
    {
        T ParseStringToObject<T>(string objString);
    }

    public interface ITypeFinder
    {
        IList<Assembly> GetAssemblies();

        IEnumerable<Type> FindClassesOfType(Type assignTypeFrom, bool onlyConcreteClasses = true);

        IEnumerable<Type> FindClassesOfType(Type assignTypeFrom, IEnumerable<Assembly> assemblies, bool onlyConcreteClasses = true);

        IEnumerable<Type> FindClassesOfType<T>(bool onlyConcreteClasses = true);

        IEnumerable<Type> FindClassesOfType<T>(IEnumerable<Assembly> assemblies, bool onlyConcreteClasses = true);

        IEnumerable<Type> FindClassesOfType<T, TAssemblyAttribute>(bool onlyConcreteClasses = true) where TAssemblyAttribute : Attribute;

        IEnumerable<Assembly> FindAssembliesWithAttribute<T>();

        IEnumerable<Assembly> FindAssembliesWithAttribute<T>(IEnumerable<Assembly> assemblies);

        IEnumerable<Assembly> FindAssembliesWithAttribute<T>(DirectoryInfo assemblyPath);
    }

    public interface IDependencyRegistrar
    {
        void Register(ContainerBuilder builder, ITypeFinder typeFinder);

        int Order { get; }
    }

    #endregion

    #region Implementation class

    public class XMLObjectParser : IObjectParser
    {
        public T ParseStringToObject<T>(string objString)
        {
            try
            {
                if (string.IsNullOrEmpty(objString))
                {
                    return default(T);
                }
                var deserializer = new XmlSerializer(typeof(T));
                using (var strReader = new StringReader(objString))
                {
                    var returnObj = (T)deserializer.Deserialize(strReader);
                    return returnObj;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return default(T);
        }
    }

    public class AppDomainTypeFinder : ITypeFinder
    {

        #region Fields

        private bool loadAppDomainAssemblies = true;
        private string assemblySkipLoadingPattern = "^System|^mscorlib|^Microsoft|^CppCodeProvider|^VJSharpCodeProvider|^WebDev|^Castle|^Iesi|^log4net|^NHibernate|^nunit|^TestDriven|^MbUnit|^Rhino|^QuickGraph|^TestFu|^Telerik|^ComponentArt|^MvcContrib|^AjaxControlToolkit|^Antlr3|^Remotion|^Recaptcha|^Zen.Barcode";
        private string assemblyRestrictToLoadingPattern = ".*";
        private IList<string> assemblyNames = new List<string>();

        /// <summary>
        /// Caches attributed assembly information so they don't have to be re-read
        /// </summary>
        private readonly List<AttributedAssembly> _attributedAssemblies = new List<AttributedAssembly>();
        /// <summary>
        /// Caches the assembly attributes that have been searched for
        /// </summary>
        private readonly List<Type> _assemblyAttributesSearched = new List<Type>();

        #endregion

        #region Constructor

        public AppDomainTypeFinder()
        {

        }

        #endregion

        #region Properties

        /// <summary>The app domain to look for types in.</summary>
        public virtual AppDomain App
        {
            get { return AppDomain.CurrentDomain; }
        }

        /// <summary>Gets or sets wether Nop should iterate assemblies in the app domain when loading Nop types. Loading patterns are applied when loading these assemblies.</summary>
        public bool LoadAppDomainAssemblies
        {
            get { return loadAppDomainAssemblies; }
            set { loadAppDomainAssemblies = value; }
        }

        /// <summary>Gets or sets assemblies loaded a startup in addition to those loaded in the AppDomain.</summary>
        public IList<string> AssemblyNames
        {
            get { return assemblyNames; }
            set { assemblyNames = value; }
        }

        /// <summary>Gets the pattern for dlls that we know don't need to be investigated.</summary>
        public string AssemblySkipLoadingPattern
        {
            get { return assemblySkipLoadingPattern; }
            set { assemblySkipLoadingPattern = value; }
        }

        /// <summary>Gets or sets the pattern for dll that will be investigated. For ease of use this defaults to match all but to increase performance you might want to configure a pattern that includes assemblies and your own.</summary>
        /// <remarks>If you change this so that Nop assemblies arn't investigated (e.g. by not including something like "^Nop|..." you may break core functionality.</remarks>
        public string AssemblyRestrictToLoadingPattern
        {
            get { return assemblyRestrictToLoadingPattern; }
            set { assemblyRestrictToLoadingPattern = value; }
        }

        #endregion

        #region ITypeFinder Members

        public virtual IList<Assembly> GetAssemblies()
        {
            var addedAssemblyNames = new List<string>();
            var assemblies = new List<Assembly>();

            if (LoadAppDomainAssemblies)
                AddAssembliesInAppDomain(addedAssemblyNames, assemblies);
            AddConfiguredAssemblies(addedAssemblyNames, assemblies);

            return assemblies;
        }

        public IEnumerable<Type> FindClassesOfType(Type assignTypeFrom, bool onlyConcreteClasses = true)
        {
            return FindClassesOfType(assignTypeFrom, GetAssemblies(), onlyConcreteClasses);
        }

        public IEnumerable<Type> FindClassesOfType(Type assignTypeFrom, IEnumerable<Assembly> assemblies, bool onlyConcreteClasses = true)
        {
            var result = new List<Type>();
            try
            {
                foreach (var a in assemblies)
                {
                    foreach (var t in a.GetTypes())
                    {
                        if (assignTypeFrom.IsAssignableFrom(t) || (assignTypeFrom.IsGenericTypeDefinition && DoesTypeImplementOpenGeneric(t, assignTypeFrom)))
                        {
                            if (!t.IsInterface)
                            {
                                if (onlyConcreteClasses)
                                {
                                    if (t.IsClass && !t.IsAbstract)
                                    {
                                        result.Add(t);
                                    }
                                }
                                else
                                {
                                    result.Add(t);
                                }
                            }
                        }
                    }

                }
            }
            catch (ReflectionTypeLoadException ex)
            {
                var msg = string.Empty;
                foreach (var e in ex.LoaderExceptions)
                    msg += e.Message + Environment.NewLine;

                var fail = new Exception(msg, ex);
                Debug.WriteLine(fail.Message, fail);

                throw fail;
            }
            return result;
        }

        public IEnumerable<Type> FindClassesOfType<T>(bool onlyConcreteClasses = true)
        {
            return FindClassesOfType(typeof(T), onlyConcreteClasses);
        }

        public IEnumerable<Type> FindClassesOfType<T>(IEnumerable<Assembly> assemblies, bool onlyConcreteClasses = true)
        {
            return FindClassesOfType(typeof(T), assemblies, onlyConcreteClasses);
        }

        public IEnumerable<Type> FindClassesOfType<T, TAssemblyAttribute>(bool onlyConcreteClasses = true) where TAssemblyAttribute : Attribute
        {
            var found = FindAssembliesWithAttribute<TAssemblyAttribute>();
            return FindClassesOfType<T>(found, onlyConcreteClasses);
        }

        public IEnumerable<Assembly> FindAssembliesWithAttribute<T>()
        {
            return FindAssembliesWithAttribute<T>(GetAssemblies());
        }

        public IEnumerable<Assembly> FindAssembliesWithAttribute<T>(IEnumerable<Assembly> assemblies)
        {
            //check if we've already searched this assembly);)
            if (!_assemblyAttributesSearched.Contains(typeof(T)))
            {
                var foundAssemblies = (from assembly in assemblies
                                       let customAttributes = assembly.GetCustomAttributes(typeof(T), false)
                                       where customAttributes.Any()
                                       select assembly).ToList();
                //now update the cache
                _assemblyAttributesSearched.Add(typeof(T));
                foreach (var a in foundAssemblies)
                {
                    _attributedAssemblies.Add(new AttributedAssembly { Assembly = a, PluginAttributeType = typeof(T) });
                }
            }

            //We must do a ToList() here because it is required to be serializable when using other app domains.
            return _attributedAssemblies
                .Where(x => x.PluginAttributeType.Equals(typeof(T)))
                .Select(x => x.Assembly)
                .ToList();
        }

        public IEnumerable<Assembly> FindAssembliesWithAttribute<T>(DirectoryInfo assemblyPath)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Iterates all assemblies in the AppDomain and if it's name matches the configured patterns add it to our list.
        /// </summary>
        /// <param name="addedAssemblyNames"></param>
        /// <param name="assemblies"></param>
        private void AddAssembliesInAppDomain(List<string> addedAssemblyNames, List<Assembly> assemblies)
        {
            foreach (Assembly assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                if (Matches(assembly.FullName))
                {
                    if (!addedAssemblyNames.Contains(assembly.FullName))
                    {
                        assemblies.Add(assembly);
                        addedAssemblyNames.Add(assembly.FullName);
                    }
                }
            }
        }

        /// <summary>
        /// Adds specificly configured assemblies.
        /// </summary>
        /// <param name="addedAssemblyNames"></param>
        /// <param name="assemblies"></param>
        protected virtual void AddConfiguredAssemblies(List<string> addedAssemblyNames, List<Assembly> assemblies)
        {
            foreach (string assemblyName in AssemblyNames)
            {
                Assembly assembly = Assembly.Load(assemblyName);
                if (!addedAssemblyNames.Contains(assembly.FullName))
                {
                    assemblies.Add(assembly);
                    addedAssemblyNames.Add(assembly.FullName);
                }
            }
        }

        /// <summary>
        /// Check if a dll is one of the shipped dlls that we know don't need to be investigated.
        /// </summary>
        /// <param name="assemblyFullName">
        /// The name of the assembly to check.
        /// </param>
        /// <returns>
        /// True if the assembly should be loaded into Nop.
        /// </returns>
        protected virtual bool Matches(string assemblyFullName)
        {
            return !Matches(assemblyFullName, AssemblySkipLoadingPattern)
                   && Matches(assemblyFullName, AssemblyRestrictToLoadingPattern);
        }

        /// <summary>
        /// Check if a dll is one of the shipped dlls that we know don't need to be investigated.
        /// </summary>
        /// <param name="assemblyFullName">
        /// The assembly name to match.
        /// </param>
        /// <param name="pattern">
        /// The regular expression pattern to match against the assembly name.
        /// </param>
        /// <returns>
        /// True if the pattern matches the assembly name.
        /// </returns>
        protected virtual bool Matches(string assemblyFullName, string pattern)
        {
            return Regex.IsMatch(assemblyFullName, pattern, RegexOptions.IgnoreCase | RegexOptions.Compiled);
        }

        /// <summary>
        /// Makes sure matching assemblies in the supplied folder are loaded in the app domain.
        /// </summary>
        /// <param name="directoryPath">
        /// The physical path to a directory containing dlls to load in the app domain.
        /// </param>
        protected virtual void LoadMatchingAssemblies(string directoryPath)
        {
            var loadedAssemblyNames = new List<string>();
            foreach (Assembly a in this.GetAssemblies())
            {
                loadedAssemblyNames.Add(a.FullName);
            }

            if (!Directory.Exists(directoryPath))
            {
                return;
            }

            foreach (string dllPath in Directory.GetFiles(directoryPath, "*.dll"))
            {
                try
                {
                    var an = AssemblyName.GetAssemblyName(dllPath);
                    if (Matches(an.FullName) && !loadedAssemblyNames.Contains(an.FullName))
                    {
                        App.Load(an);
                    }
                }
                catch (BadImageFormatException ex)
                {
                    Trace.TraceError(ex.ToString());
                }
            }
        }

        /// <summary>
        /// Does type implement generic?
        /// </summary>
        /// <param name="type"></param>
        /// <param name="openGeneric"></param>
        /// <returns></returns>
        protected virtual bool DoesTypeImplementOpenGeneric(Type type, Type openGeneric)
        {
            try
            {
                var genericTypeDefinition = openGeneric.GetGenericTypeDefinition();
                foreach (var implementedInterface in type.FindInterfaces((objType, objCriteria) => true, null))
                {
                    if (!implementedInterface.IsGenericType)
                        continue;

                    var isMatch = genericTypeDefinition.IsAssignableFrom(implementedInterface.GetGenericTypeDefinition());
                    return isMatch;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        #endregion

        #region Nested classes

        private class AttributedAssembly
        {
            internal Assembly Assembly { get; set; }
            internal Type PluginAttributeType { get; set; }
        }

        #endregion
    }

    public class AppAllDLLTypeFinder : AppDomainTypeFinder
    {
        private bool _binFolderAssembliesLoaded = false;
        #region Ctor

        public AppAllDLLTypeFinder()
        {

        }

        #endregion

        #region Methods

        /// <summary>
        /// Gets a physical disk path of \Bin directory
        /// </summary>
        /// <returns>The physical path. E.g. "c:\inetpub\wwwroot\bin"</returns>
        public virtual string GetBaseDirectory()
        {
            if (HostingEnvironment.IsHosted)
            {
                //hosted
                return HttpRuntime.BinDirectory;
            }
            else
            {
                //not hosted. For example, run either in unit tests
                return AppDomain.CurrentDomain.BaseDirectory;
            }
        }

        public override IList<Assembly> GetAssemblies()
        {
            if (!_binFolderAssembliesLoaded)
            {
                _binFolderAssembliesLoaded = true;
                string binPath = GetBaseDirectory();
                //binPath = _webHelper.MapPath("~/bin");
                LoadMatchingAssemblies(binPath);
            }

            return base.GetAssemblies();
        }

        #endregion
    }

    #endregion

    #region Common Extension Method
    public static class ContainerManagerExtensions
    {
        public static Autofac.Builder.IRegistrationBuilder<TLimit, TActivatorData, TRegistrationStyle> PerLifeStyle<TLimit, TActivatorData, TRegistrationStyle>(this Autofac.Builder.IRegistrationBuilder<TLimit, TActivatorData, TRegistrationStyle> builder, ComponentLifeStyle lifeStyle)
        {
            switch (lifeStyle)
            {
                case ComponentLifeStyle.LifetimeScope:
                    return builder.InstancePerLifetimeScope();
                case ComponentLifeStyle.Transient:
                    return builder.InstancePerDependency();
                case ComponentLifeStyle.Singleton:
                    return builder.SingleInstance();
                default:
                    return builder.SingleInstance();
            }
        }
    }

    public static class CommonExtensions
    {
        //public static string StripHTML(this string source)
        //{
        //    try
        //    {
        //        string result;

        //        // Remove HTML Development formatting
        //        // Replace line breaks with space
        //        // because browsers inserts space
        //        result = source.Replace("\r", " ");
        //        // Replace line breaks with space
        //        // because browsers inserts space
        //        result = result.Replace("\n", " ");
        //        // Remove step-formatting
        //        result = result.Replace("\t", string.Empty);
        //        // Remove repeating spaces because browsers ignore them
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                                                              @"( )+", " ");

        //        // Remove the header (prepare first by clearing attributes)
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*head([^>])*>", "<head>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"(<( )*(/)( )*head( )*>)", "</head>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(<head>).*(</head>)", string.Empty,
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // remove all scripts (prepare first by clearing attributes)
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*script([^>])*>", "<script>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"(<( )*(/)( )*script( )*>)", "</script>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        //result = System.Text.RegularExpressions.Regex.Replace(result,
        //        //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
        //        //         string.Empty,
        //        //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"(<script>).*(</script>)", string.Empty,
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // remove all styles (prepare first by clearing attributes)
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*style([^>])*>", "<style>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"(<( )*(/)( )*style( )*>)", "</style>",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(<style>).*(</style>)", string.Empty,
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // insert tabs in spaces of <td> tags
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*td([^>])*>", "\t",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // insert line breaks in places of <BR> and <LI> tags
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*br( )*>", "\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*li( )*>", "\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // insert line paragraphs (double line breaks) in place
        //        // if <P>, <DIV> and <TR> tags
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*div([^>])*>", "\r\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*tr([^>])*>", "\r\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<( )*p([^>])*>", "\r\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // Remove remaining tags like <a>, links, images,
        //        // comments etc - anything that's enclosed inside < >
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"<[^>]*>", string.Empty,
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // replace special characters:
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @" ", " ",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&bull;", " * ",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&lsaquo;", "<",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&rsaquo;", ">",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&trade;", "(tm)",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&frasl;", "/",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&lt;", "<",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&gt;", ">",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&copy;", "(c)",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&reg;", "(r)",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        // Remove all others. More can be added, see
        //        // http://hotwired.lycos.com/webmonkey/reference/special_characters/
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 @"&(.{2,6});", string.Empty,
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // for testing
        //        //System.Text.RegularExpressions.Regex.Replace(result,
        //        //       this.txtRegex.Text,string.Empty,
        //        //       System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        //        // make line breaking consistent
        //        result = result.Replace("\n", "\r");

        //        // Remove extra line breaks and tabs:
        //        // replace over 2 breaks with 2 and over 4 tabs with 4.
        //        // Prepare first to remove any whitespaces in between
        //        // the escaped characters and remove redundant tabs in between line breaks
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\r)( )+(\r)", "\r\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\t)( )+(\t)", "\t\t",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\t)( )+(\r)", "\t\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\r)( )+(\t)", "\r\t",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        // Remove redundant tabs
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\r)(\t)+(\r)", "\r\r",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        // Remove multiple tabs following a line break with just one tab
        //        result = System.Text.RegularExpressions.Regex.Replace(result,
        //                 "(\r)(\t)+", "\r\t",
        //                 System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        //        // Initial replacement target string for line breaks
        //        string breaks = "\r\r\r";
        //        // Initial replacement target string for tabs
        //        string tabs = "\t\t\t\t\t";
        //        for (int index = 0; index < result.Length; index++)
        //        {
        //            result = result.Replace(breaks, "\r\r");
        //            result = result.Replace(tabs, "\t\t\t\t");
        //            breaks = breaks + "\r";
        //            tabs = tabs + "\t";
        //        }

        //        // That's it.
        //        return result;
        //    }
        //    catch
        //    {
        //        return string.Empty;
        //    }
        //}


        public static string StripHTML(this string source)
        {
            try
            {
                string result;

                // Remove HTML Development formatting
                // Replace line breaks with space
                // because browsers inserts space
                result = source.Replace("\r", " ");
                // Replace line breaks with space
                // because browsers inserts space
                result = result.Replace("\n", " ");
                // Remove step-formatting
                result = result.Replace("\t", string.Empty);
                // Remove repeating spaces because browsers ignore them
                result = System.Text.RegularExpressions.Regex.Replace(result,
                                                                      @"( )+", " ");

                // Remove the header (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*head([^>])*>", "<head>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*head( )*>)", "</head>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(<head>).*(</head>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // remove all scripts (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*script([^>])*>", "<script>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*script( )*>)", "</script>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                //result = System.Text.RegularExpressions.Regex.Replace(result,
                //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
                //         string.Empty,
                //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<script>).*(</script>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // remove all styles (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*style([^>])*>", "<style>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*style( )*>)", "</style>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(<style>).*(</style>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert tabs in spaces of <td> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*td([^>])*>", "\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert line breaks in places of <BR> and <LI> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*br( )*/*>", "\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*li( )*>", "\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert line paragraphs (double line breaks) in place
                // if <P>, <DIV> and <TR> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*div([^>])*>", "\r\n\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*tr([^>])*>", "\r\n\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*p([^>])*>", "\r\n\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove remaining tags like <a>, links, images,
                // comments etc - anything that's enclosed inside < >
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<[^>]*>", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // replace special characters:
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @" ", " ",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&bull;", " * ",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&lsaquo;", "<",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&rsaquo;", ">",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&trade;", "(tm)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&frasl;", "/",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&lt;", "<",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&gt;", ">",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&copy;", "(c)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&reg;", "(r)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                // Remove all others. More can be added, see
                // http://hotwired.lycos.com/webmonkey/reference/special_characters/
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&(.{2,6});", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // for testing
                //System.Text.RegularExpressions.Regex.Replace(result,
                //       this.txtRegex.Text,string.Empty,
                //       System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // make line breaking consistent
                //result = result.Replace("\n", "\r\n");

                // Remove extra line breaks and tabs:
                // replace over 2 breaks with 2 and over 4 tabs with 4.
                // Prepare first to remove any whitespaces in between
                // the escaped characters and remove redundant tabs in between line breaks
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\r\n)( )+(\r\n)", "\r\n\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\t)( )+(\t)", "\t\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\t)( )+(\r\n)", "\t\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\r\n)( )+(\t)", "\r\n\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                // Remove redundant tabs
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\r\n)(\t)+(\r\n)", "\r\n\r\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                // Remove multiple tabs following a line break with just one tab
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\r\n)(\t)+", "\r\n\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                // Initial replacement target string for line breaks
                string breaks = "\r\n\r\n\r\n";
                // Initial replacement target string for tabs
                string tabs = "\t\t\t\t\t";
                for (int index = 0; index < result.Length; index++)
                {
                    result = result.Replace(breaks, "\r\n\r\n");
                    result = result.Replace(tabs, "\t\t\t\t");
                    breaks = breaks + "\r\n";
                    tabs = tabs + "\t";
                }

                // That's it.
                return result;
            }
            catch
            {
                return string.Empty;
            }
        }

        public static Image ResizeImage(this Image image, Size size, bool preserveAspectRatio = true)
        {
            int newWidth;
            int newHeight;
            if (preserveAspectRatio)
            {
                int originalWidth = image.Width;
                int originalHeight = image.Height;
                float percentWidth = (float)size.Width / (float)originalWidth;
                float percentHeight = (float)size.Height / (float)originalHeight;
                float percent = percentHeight < percentWidth ? percentHeight : percentWidth;
                newWidth = (int)(originalWidth * percent);
                newHeight = (int)(originalHeight * percent);
            }
            else
            {
                newWidth = size.Width;
                newHeight = size.Height;
            }
            Image newImage = new Bitmap(newWidth, newHeight);
            using (Graphics graphicsHandle = Graphics.FromImage(newImage))
            {
                graphicsHandle.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphicsHandle.DrawImage(image, 0, 0, newWidth, newHeight);
            }
            return newImage;
        }

        public static IEnumerable<T> ToEnumerable<T>(this T entity)
        {
            yield return entity;
        }

        public static decimal ToeBayCrazyMallPrice(this decimal dsPrice)
        {
            return Convert.ToDecimal(Math.Ceiling((dsPrice + Convert.ToDecimal(0.3)) / Convert.ToDecimal(0.774)) - Convert.ToDecimal(0.05));
        }

        public static decimal ToNopCommerceCrazyMallPrice(this decimal dsPrice)
        {
            return Convert.ToDecimal(Math.Ceiling((dsPrice + Convert.ToDecimal(0.3)) / Convert.ToDecimal(0.904)) - Convert.ToDecimal(0.05));
        }


        #region Name of

        public static string nameof<T, TProp>(this T obj, Expression<Func<T, TProp>> expression)
        {
            return nameof((LambdaExpression)expression);
        }

        private static string nameof(LambdaExpression expression)
        {
            MemberExpression memberExp = expression.Body as MemberExpression;
            if (memberExp != null)
                return memberExp.Member.Name;

            MethodCallExpression methodExp = expression.Body as MethodCallExpression;
            if (methodExp != null)
                return methodExp.Method.Name;

            return string.Empty;
        }

        #endregion

        public static IEnumerable<TSource> TakeSkipWhileRollOver<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, int takeCount)
        {
            if (source.Count() <= takeCount)
                return source;

            var retList = source.SkipWhile(predicate).Take(takeCount);
            if (retList.Count() < takeCount)
            {
                retList=retList.Concat(source.Take(takeCount - retList.Count()));
            }

            return retList;
        }

    }

    
    #endregion

    public class CommonFunction
    {
        public static object EvaluateFormula(IList<KeyValuePair<string,object>> paramNameValues,string formula)
        {
            var e = new NCalc.Expression(formula);
            foreach (var p in paramNameValues)
            {
                e.Parameters.Add(p.Key, p.Value);
            }

            return e.Evaluate();
        }

        public static string GetPublicIPAddress()
        {
            var ipAddress = "";
            try
            {
                using (var wc = new WebClient())
                {
                    //ipAddress = wc.DownloadString("http://bot.whatismyipaddress.com");
                    ipAddress = wc.DownloadString("https://api.ipify.org/");
                }
                return ipAddress;
            }
            catch (WebException wex)
            {
                return ipAddress;
            }
            catch (Exception ex)
            {
                return ipAddress;
            }
        }

        public static bool ChangeIPAddress(string ipAddress, string netmask,string gateway)
        {
            try
            {
                var networkManager = new NetworkManagement();
                networkManager.setIP(ipAddress, netmask);
                networkManager.setGateway(gateway);

                while (!networkManager.IsNetworkAvailable())
                {
                    Thread.Sleep(1000);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static void CopyDir(string sourceDir,string destDir)
        {
            if (!Directory.Exists(sourceDir))
                return;

            //Now Create all of the directories
            foreach (string dirPath in Directory.GetDirectories(sourceDir, "*",
                SearchOption.AllDirectories))
                Directory.CreateDirectory(dirPath.Replace(sourceDir, destDir));

            //Copy all the files & Replaces any files with the same name
            foreach (string newPath in Directory.GetFiles(sourceDir, "*.*",
                SearchOption.AllDirectories))
                File.Copy(newPath, newPath.Replace(sourceDir, destDir), true);
        }
    }
}
