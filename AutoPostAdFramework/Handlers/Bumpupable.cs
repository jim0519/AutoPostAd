using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using AutoPostAdData.Models;
using AutoPostAdBusiness.BusinessModels;
using Common.Models.XML;
using Common;
using System.Net;
using OpenQA.Selenium.Chrome;
using System.Threading;
using RestSharp;
using HtmlAgilityPack;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

namespace AutoPostAdBusiness.Handlers
{
    public interface IBumpupable
    {
        void Bumpup(IEnumerable<AutoPostAdPostDataBM> postAdDatas);
    }

    public class Yeeyi : IBumpupable
    {
        private readonly IRepository<Account> _accountRepository;
        private readonly IRepository<AccountAdvertise> _accountAdvertiseRepository;
        public Yeeyi(IRepository<Account> accountRepository,
            IRepository<AccountAdvertise> accountAdvertiseRepository)
        {
            _accountRepository = accountRepository;
            _accountAdvertiseRepository = accountAdvertiseRepository;
        }

        public void Bumpup(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        {
            try
            {
                var currentChannelName = this.GetType().Name;
                var client = new RestClient("http://www.yeeyi.com/");
                //var accountAdvertise = postAdDatas.FirstOrDefault().AccountAdvertises.FirstOrDefault(aa=>aa.AccountObj.ChannelObj.Name.ToLower().Equals(currentChannelName.ToLower()));
                var accountObj = postAdDatas.FirstOrDefault().AccountObj;
                var ruleObj = postAdDatas.FirstOrDefault().ScheduleRuleObj;
                var accountAttr = new YeeyiAccountAttribute();
                var advertiseAttr = new YeeyiAdvertiseAttribute();
                var readAccAttr = CommonFunction.ConvertBinaryToObject<YeeyiAccountAttribute>(accountObj.RefBinary);
                if (readAccAttr != null)
                    accountAttr = readAccAttr;
                
                

                if (accountAttr.LoginCookie == null)
                {
                    var cookieJar = Login(accountObj.UserName, accountObj.Password);
                    if (cookieJar != null)
                        accountAttr.LoginCookie = cookieJar;
                }

                var elaspDay=  (DateTime.Now.Date- ruleObj.LastSuccessTime.Date).TotalDays;
                if (accountAttr.LoginCookie != null && (accountAttr.BumpUpTimesLeft > 0||string.IsNullOrEmpty(accountAttr.LastReturnMessage)|| elaspDay>0))
                {
                    client.CookieContainer = accountAttr.LoginCookie;
                    foreach (var ad in postAdDatas)
                    {
                        try
                        {
                            var accountAdvertise=ad.AccountAdvertises.FirstOrDefault(aa => aa.AccountObj.ChannelObj.Name.ToLower().Equals(currentChannelName.ToLower()));
                            var readAdAttr = JsonConvert.DeserializeObject<YeeyiAdvertiseAttribute>(accountAdvertise.Ref);
                            if (readAdAttr != null)
                                advertiseAttr = readAdAttr;

                            var request = new RestRequest("bbs/forum.php?mod=post&action=refresh&fid={forumID}&id={onlineAdvertiseID}");
                            request.AddUrlSegment("forumID", advertiseAttr.ForumID);
                            request.AddUrlSegment("onlineAdvertiseID", accountAdvertise.OnlineAdvertiseID);
                            var response = client.Execute(request);
                            if (response.StatusCode == HttpStatusCode.OK)
                            {
                                var htmlDoc = new HtmlDocument();
                                htmlDoc.LoadHtml(response.Content);
                                var msgElement = htmlDoc.GetElementbyId("messagetext");
                                if (msgElement != null)
                                {
                                    var msg = msgElement.ChildNodes.FindFirst("p").InnerText;
                                    accountAttr.LastReturnMessage = msg;
                                    advertiseAttr.ReturnMessage = msg;
                                    var matches = Regex.Matches(msg, @"\d{1,2}");
                                    if (matches.Count == 1)
                                    {
                                        accountAttr.BumpUpTimesLeft = Convert.ToInt32(matches[0].Value);
                                    }
                                    else
                                    {
                                        accountAttr.BumpUpTimesLeft = 0;
                                    }

                                    var accAdObj = _accountAdvertiseRepository.GetById(accountAdvertise.ID);
                                    accAdObj.OnlineAdvertiseDate = DateTime.Now;
                                    accAdObj.Ref = JsonConvert.SerializeObject(advertiseAttr);
                                    _accountAdvertiseRepository.Update(accAdObj);
                                }
                            }

                            if (accountAttr.BumpUpTimesLeft > 0)
                                continue;
                            else
                                break;


                        }
                        catch (Exception ex)
                        {
                            LogManager.Instance.Error(ex.Message);
                        }
                    }
                    accountAttr.LastPostTime = DateTime.Now;
                }

                accountObj.RefBinary = CommonFunction.ConvertObjectToBinary(accountAttr);
                _accountRepository.Update(accountObj);
            }
            catch(Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
            }
        }

        private CookieContainer Login(string userName, string password)
        {
            try
            {
                var option = new ChromeOptions();
                option.AddArguments("headless");
                option.UnhandledPromptBehavior = OpenQA.Selenium.UnhandledPromptBehavior.Accept;
                var service = ChromeDriverService.CreateDefaultService();
                service.HideCommandPromptWindow = true;
                CookieContainer retCookieContainer = null;
                using (var browser = new ChromeDriver(service, option))
                {
                    browser.Navigate().GoToUrl("http://www.yeeyi.com/forum/index.php?app=member&act=login");
                    var manager = browser.Manage();
                    var loginUserName = browser.FindElementById("telTxtLogin");
                    var loginPassword = browser.FindElementById("passShow");
                    var chkAutoFlag = browser.FindElementById("cookietime_LAFCI");
                    var loginButton = browser.FindElementById("postBtn");

                    //loginUserName.SendKeys("liang");
                    //loginPassword.SendKeys("Welcome1");
                    loginUserName.SendKeys(userName);
                    loginPassword.SendKeys(password);
                    chkAutoFlag.Click();
                    loginButton.Click();
                    //browser.Navigate().GoToUrl("http://www.yeeyi.com");


                    while (true)
                    {
                        try
                        {
                            Thread.Sleep(5000);
                            var successCookie = manager.Cookies.AllCookies;
                            if (successCookie != null)
                            { break; }
                        }
                        catch (Exception ex)
                        { }
                    }

                    if (manager.Cookies != null)
                    {
                        retCookieContainer = new CookieContainer();
                        for (int i = 0; i < manager.Cookies.AllCookies.Count; i++)
                        {
                            var cookie = manager.Cookies.AllCookies[i];
                            //Console.WriteLine("Cookie name: " + cookie.Name + " Value: " + cookie.Value);
                            retCookieContainer.Add(new Cookie(cookie.Name, cookie.Value, cookie.Path, cookie.Domain));
                        }

                        //WriteCookiesToDisk(cookieFilePath, cookieJar);
                    }

                    return retCookieContainer;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return default(CookieContainer);
            }
        }

        [Serializable]
        protected class YeeyiAccountAttribute
        {
            public int BumpUpTimesLeft { get; set; }
            public CookieContainer LoginCookie { get; set; }
            public string LastReturnMessage { get; set; }
            public DateTime LastPostTime { get; set; }
        }

        [Serializable]
        protected class YeeyiAdvertiseAttribute
        {
            public string ForumID { get; set; }
            public string ReturnMessage { get; set; }
        }
    }
}
