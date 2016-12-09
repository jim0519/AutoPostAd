using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;
using Common.Models;
using System.Threading;
using Common;
using System.Windows.Forms;
using System.Net;
using AutoPostAdBusiness.BusinessModels;
using System.IO;
using Newtonsoft.Json;
using System.Web;
using Common.DeathByCaptcha;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;

namespace AutoPostAdBusiness.Handlers
{


    public class AuthenticCookieFetcher : System.Windows.Forms.ApplicationContext
    {
        private AutoResetEvent _eventHandler;
        private WebBrowser webBrowser;
        private Thread thrd;
        public string CookieString { get; set; }

        public AuthenticCookieFetcher(AutoResetEvent resultEvent)
        {
            _eventHandler = resultEvent;
        }

        public void GetAuthenticCookie(string userName,string password)
        {
            LogManager.Instance.Info("Get cookie start");
            thrd = new Thread(new ThreadStart(
            delegate
            {
                RunGetCookie(userName, password);
                System.Windows.Forms.Application.Run(this);
            }));
            // set thread to STA state before starting
            thrd.SetApartmentState(ApartmentState.STA);
            thrd.Start();

        }

        private void RunGetCookie(string userName, string password)
        {
            //Thread.Sleep(20000);
            //CookieString = "Cookie Got";
            //_eventHandler.Set();
            LogManager.Instance.Info("Prepair new web browser");
            webBrowser = new WebBrowser();
            webBrowser.DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(WebBrowser_DocumentCompleted);
            var postData = PreparePostData(userName, password);
            var additionalHeader = PrepareAdditionalData(postData);
            LogManager.Instance.Info("Prepair execute login");
            webBrowser.Navigate(GumtreeURL.Login, null, postData, additionalHeader);
        }



        private void WebBrowser_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            LogManager.Instance.Info("Load document complete");
            HtmlDocument doc = ((WebBrowser)sender).Document;
            if (doc.Url.AbsoluteUri.Contains("m-my-ads"))
            {
                LogManager.Instance.Info("Get cookie string");
                var cookieString = GetUriCookieString(new Uri(GumtreeURL.MyAd));
                if (cookieString != null)
                {
                    CookieString = cookieString;
                }
            }
            _eventHandler.Set();
        }

        private string PrepareAdditionalData(byte[] postData)
        {
            var headerDelimiter = "\r\n";
            //var additionalHeader = "Pragma:no-cache" + headerDelimiter;
            var additionalHeader = "Accept-Language:en-US,en;q=0.8,ja;q=0.6,zh-CN;q=0.4,zh-TW;q=0.2" + headerDelimiter;
            additionalHeader += "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" + headerDelimiter;
            additionalHeader += "Accept-Encoding:gzip, deflate" + headerDelimiter;
            additionalHeader += "User-Agent:"+AutoPostAdConfig.Instance.UserAgent + headerDelimiter;
            //additionalHeader += "Cookie:" + postAdData.Cookie + headerDelimiter;
            additionalHeader += "Content-Length:" + postData.Length + headerDelimiter;
            additionalHeader += "Content-Type:application/x-www-form-urlencoded" + headerDelimiter;
            additionalHeader += "Referer:"+GumtreeURL.LoginForm + headerDelimiter;
            additionalHeader += "Cache-Control:max-age=0" + headerDelimiter;
            additionalHeader += "Upgrade-Insecure-Requests:1" + headerDelimiter;
            additionalHeader += "Host:www.gumtree.com.au" + headerDelimiter;
            additionalHeader += "Origin:"+GumtreeURL.HomePage;

            return additionalHeader;
        }

        private byte[] PreparePostData(string userName, string password)
        {
            var loginData = new List<KeyValuePair<string, string>>();
            loginData.Add(new KeyValuePair<string, string>("targetUrl", ""));
            loginData.Add(new KeyValuePair<string, string>("likingAd", "false"));
            loginData.Add(new KeyValuePair<string, string>("loginMail", userName));
            loginData.Add(new KeyValuePair<string, string>("password", password));
            loginData.Add(new KeyValuePair<string, string>("rememberMe", "true"));
            loginData.Add(new KeyValuePair<string, string>("_rememberMe", "on"));

            var strPostData = "";
            foreach (var nv in loginData)
            {
                strPostData += nv.Key + "=" + nv.Value + "&";
            }
            strPostData = strPostData.Trim('&');

            var encoding = new UTF8Encoding();
            byte[] postData = encoding.GetBytes(strPostData);
            return postData;
        }


        // dipose the WebBrowser control and the form and its controls
        protected override void Dispose(bool disposing)
        {
            if (thrd != null)
            {
                thrd.Abort();
                thrd = null;
                return;
            }
            if (webBrowser != null)
            {
                System.Runtime.InteropServices.Marshal.Release(webBrowser.Handle);
                webBrowser.Dispose();
            }
            base.Dispose(disposing);
        }


        [DllImport("wininet.dll", SetLastError = true)]
        public static extern bool InternetGetCookieEx(
            string url,
            string cookieName,
            StringBuilder cookieData,
            ref int size,
            Int32 dwFlags,
            IntPtr lpReserved);

        private const Int32 InternetCookieHttponly = 0x2000;

        /// <summary>
        /// Gets the URI cookie container.
        /// </summary>
        /// <param name="uri">The URI.</param>
        /// <returns></returns>
        public static string GetUriCookieString(Uri uri)
        {
            var cookieString = string.Empty;
            // Determine the size of the cookie
            int datasize = 8192 * 16;
            StringBuilder cookieData = new StringBuilder(datasize);
            if (!InternetGetCookieEx(uri.ToString(), null, cookieData, ref datasize, InternetCookieHttponly, IntPtr.Zero))
            {
                if (datasize < 0)
                    return null;
                // Allocate stringbuilder large enough to hold the cookie
                cookieData = new StringBuilder(datasize);
                if (!InternetGetCookieEx(
                    uri.ToString(),
                    null, cookieData,
                    ref datasize,
                    InternetCookieHttponly,
                    IntPtr.Zero))
                    return null;
            }
            if (cookieData.Length > 0)
            {
                //cookies = new CookieContainer();
                //cookies.SetCookies(uri, cookieData.ToString().Replace(';', ','));
                cookieString = cookieData.ToString();
            }
            return cookieString;
        }
       
    }
}
