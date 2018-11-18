using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using HtmlAgilityPack;
using Common;
using AutoPostAdBusiness.Handlers;
using System.Threading;
using AutoPostAdBusiness.Services;
using Common.Infrastructure;
using AutoPostAdBusiness.Task;

namespace AutoPostAdWeb.Controllers
{
    public class HomeController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(FormCollection formData)
        {
            //var resultEvent = new AutoResetEvent(false);
            //var fetcher = new AuthenticCookieFetcher(resultEvent);
            //fetcher.GetAuthenticCookie("LeiXi2003@yahoo.com.au", "MySixthLove20150501");
            //resultEvent.WaitOne();
            //if (!string.IsNullOrEmpty(fetcher.CookieString))
            //{ 
                
            //}

            //var cookieString = "ki_t=1453503651690%3B1453503651690%3B1453503651690%3B1%3B1; ki_r=; machId=e4FCpRSrCOM7uCKvV8O-ShFg9NtQcLj0y45Yq6c39ph7sbyQ6snL8bLr4IHwIjo__NpVEDazltY8OsCqfol0ibV9Y5dKXCHRfrY9; up=%7B%22ln%22%3A%22563950035%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1453503645486r0.02016498341432238; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1946999416.1453503647.1453507196.1453543244.3; __utmz=160852194.1453503647.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1946999416.1453503647; __gads=ID=7744d716de1a8fe0:T=1453460495:S=ALNI_MbiMzOOdFmuYb2HUTJDcWSrJi1Orw; crtg_rta=; bs=%7B%22st%22%3A%7B%7D%7D";
            //var arrString = cookieString.Split(';');
            //cookieString = string.Join(",", arrString);
            //CookieContainer cookieJar = new CookieContainer();
            //cookieJar.SetCookies(new Uri("https://www.gumtree.com.au/t-login.html"), cookieString);
            //using (var wc = new GumtreeLoginWebClient(cookieJar))
            //{
            //    wc.Login("LeiXi2003@yahoo.com.au", "MySixthLove20150501");


            //    //Get Post Ad 2 verification code test
            //    //wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36");
            //    //wc.Encoding = System.Text.Encoding.UTF8;
            //    //var strHtml = wc.DownloadString("http://www.gumtree.com.au/p-post-ad2.html?categoryId=20046&adType=OFFER");
            //    //var htmlDoc = new HtmlDocument();
            //    //htmlDoc.LoadHtml(strHtml);

            //    //var elementToken = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["data-token"] != null).ToList();
            //    //if (elementToken.Count > 0)
            //    //{
            //    //    var verificationToken = elementToken.FirstOrDefault().GetAttributeValue("data-token", string.Empty);
            //    //}


            //}

            //var autoPostAdTask = AutoPostAdContext.Instance.ResolveUnregistered<AutoPostAdTask>();
            //autoPostAdTask.Execute();

            //var 

            return View();
        }


        [HttpPost]
        public ActionResult DeletePostAd(FormCollection formData)
        {
            //var postService = AutoPostAdContext.Instance.Resolve<IAutoPostAdWebPostService>();
            //if (postService.DeleteExistingAd())
            //{
            //    postService.PostActiveAdOnWeb();
            //}

            return View();
        }


        public ActionResult GumtreeAuthentic()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult GumtreeAuthentic(FormCollection formData)
        {
            //var username = formData["userName"];
            //var password = formData["password"];
            //var postService = AutoPostAdContext.Instance.Resolve<IAutoPostAdWebPostService>();
            //if (postService.FetchAndSaveGumtreeCookie(username, password))
            //{
            //    //ViewBag.Message = "Your application description page.";
            //    TempData.Add("Result", "Cookie fetched and saved successfully.");
            //}
            //else
            //{
            //    TempData.Add("Result", "Cookie fetched and saved failed.");
            //}


            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}