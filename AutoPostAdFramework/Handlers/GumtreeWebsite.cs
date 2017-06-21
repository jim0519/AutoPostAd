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

namespace AutoPostAdBusiness.Handlers
{
    public class GumtreeWebsite : IListAdAutoPostAdPostDataBMWebsite
    {
        private EventWaitHandle _busy = new AutoResetEvent(false);

        private AutoPostAdController _autoPostAdController;
        private readonly Client _captchaClient;
        //private WebBrowser wb = AutoPostAdContext.Instance.SingleInstance<WebBrowser>();
        private string _verificationCode;
        private string _verificationToken;
        private IDelayable _delayController;
        private readonly IRepository<AutoPostAdPostData> _autoPostAdPostDataRepository;
        public GumtreeWebsite(Client captchaClient, IDelayable delayController, IRepository<AutoPostAdPostData> autoPostAdPostDataRepository)
        {
            _captchaClient = captchaClient;
            _delayController = delayController;
            _autoPostAdPostDataRepository = autoPostAdPostDataRepository;
        }

        public AutoPostAdController Manager
        {
            get
            {
                return _autoPostAdController;
            }
            set
            {
                _autoPostAdController = value;
                _autoPostAdController.NotifyContinueWebsiteProcess += _autoPostAdController_NotifyContinueWebsiteProcess;

            }
        }

        private void _autoPostAdController_NotifyContinueWebsiteProcess(object sender, NotifyContinueWebsiteProcessEventArgs e)
        {
            _verificationCode = e.ReturnObject.ToString();
            _busy.Set();
        }

        #region IWebsite<GumtreePostData> Members

        public virtual bool PostAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        {
            try
            {

                Thread t = new Thread(new ThreadStart(() =>
                {
                    ProgressInfoService.BeginProgressProcess();
                    try
                    {

                        int recordCount = postAdDatas.ToList().Count;
                        
                        //post ad
                        int i = 1;
                        int percentage = i;
                        var breakLoop = false;
                        foreach (AutoPostAdPostDataBM postAdData in postAdDatas)
                        {
                            //AutoPostAdPostDataBM returnPostData = postAdData as AutoPostAdPostDataBM;
                            if (breakLoop)
                                break;
                            //WebBrowser wb = new WebBrowser();
                            //wb.ScriptErrorsSuppressed = true;
                            postAdData.ResultMessage = string.Empty;
                            var postTimes = 1;
                            while (string.IsNullOrEmpty(postAdData.ResultMessage) || postAdData.ResultMessage.Contains("Ad post failed"))
                            {
                                try
                                {
                                    postTimes++;
                                    if (postTimes >= 6)//max 5 times
                                    {
                                        breakLoop = true;
                                        break;
                                    }
                                    _delayController.StarProcess();
                                    //check images
                                    var imageInfos = postAdData.GetImages(postAdData.ImagesPath);
                                    var businessLogoImageInfos = postAdData.GetImages(postAdData.BusinessLogoPath);
                                    CheckImages(imageInfos, businessLogoImageInfos);
                                    //check PostAdData
                                    CheckPostAdData(postAdData);

                                    
                                    _verificationCode = "";
                                    _verificationToken = "";
                                    Dictionary<string, object> message = new Dictionary<string, object>();

                                    var cookieString = postAdData.Cookie;
                                    var arrString= cookieString.Split(';');
                                    cookieString = string.Join(",", arrString);
                                    


                                    //HtmlElementCollection elementToken = wb.Document.All.GetElementsByName("bbToken");
                                    //var elementLinq = wb.Document.All.OfType<HtmlElement>().Where(a=> a.Name.Equals("bbToken")).ToList();
                                    //var elementLinq = wb.Document.All.OfType<HtmlElement>().Where(a => a.Name.Equals("PromoteAd")).ToList();

                                    //DownloadImageWebClient wc = new DownloadImageWebClient();
                                    //var para = "parentCategoryId=" + postAdData.ProductCategoryObj.ParentCategoryID;
                                    //para += "&categoryId=" + postAdData.ProductCategoryObj.CategoryID;
                                    //para += "&adType=OFFER";
                                    //var encoding = new UTF8Encoding();
                                    //byte[] postData = encoding.GetBytes(para);


                                    //wc.Headers["Pragma"] = "no-cache";
                                    //wc.Headers["Accept-Language"] = "en-AU";
                                    //wc.Headers["Accept"] = "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*";
                                    //wc.Headers["Accept-Encoding"] = "gzip, deflate";
                                    //wc.Headers["User-Agent"] = AutoPostAdConfig.Instance.UserAgent;
                                    //wc.Headers["Cookie"] = postAdData.Cookie;
                                    //wc.Headers["Content-Length"] = postData.Length.ToString();
                                    //wc.Headers["Content-Type"] = "application/x-www-form-urlencoded";
                                    //wc.Headers["Referer"] = GumtreeURL.SelectCategory;
                                    //wc.Headers["Connection"] = "Keep-Alive";


                                    //wc.Headers.Add("Pragma", "no-cache");
                                    //wc.Headers.Add("Accept-Language", "en-AU");
                                    //wc.Headers.Add("Accept", "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*");
                                    //wc.Headers.Add("Accept-Encoding", "gzip, deflate");
                                    //wc.Headers.Add("User-Agent", AutoPostAdConfig.Instance.UserAgent);
                                    //wc.Headers.Add("Cookie", postAdData.Cookie);
                                    //wc.Headers.Add("Content-Length", postData.Length.ToString());
                                    //wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                                    //wc.Headers.Add("Referer", GumtreeURL.SelectCategory);
                                    //wc.Headers.Add("Connection", "Keep-Alive");


                                    //wc.Headers[HttpRequestHeader.Pragma] = "no-cache";
                                    //wc.Headers[HttpRequestHeader.AcceptLanguage] = "en-AU";
                                    //wc.Headers[HttpRequestHeader.Accept] = "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*";
                                    //wc.Headers[HttpRequestHeader.AcceptEncoding] = "gzip, deflate";
                                    //wc.Headers[HttpRequestHeader.UserAgent] = AutoPostAdConfig.Instance.UserAgent;
                                    //wc.Headers[HttpRequestHeader.Cookie] = postAdData.Cookie;
                                    ////wc.Headers[HttpRequestHeader.ContentLength] = postData.Length.ToString();
                                    //wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                                    //wc.Headers[HttpRequestHeader.Referer] = GumtreeURL.SelectCategory;
                                    //wc.Headers[HttpRequestHeader.Connection] = "Keep-Alive";

                                    //wc.UploadString(GumtreeURL.AdForm, para);
                                    //string htmlCode = wc.DownloadString(GumtreeURL.AdForm);
                                    //HtmlAgilityPack.HtmlDocument dom = new HtmlAgilityPack.HtmlDocument();
                                    //dom.LoadHtml(htmlCode);


                                    #region Old method for loading Gumtree Ad Page

                                    ////prepare navigate header
                                    //byte[] navigatePostData = PrepareNavigatePostData(postAdData);
                                    //string navigateHeader = PrepareNavigateHeader(navigatePostData, postAdData);
                                    //wb.Navigate(GumtreeURL.AdForm, "", navigatePostData, navigateHeader);
                                    //while (wb.ReadyState != WebBrowserReadyState.Complete)
                                    //{
                                    //    Application.DoEvents();
                                    //}

                                    ////if there is verification code needs to be input
                                    //var elementToken = wb.Document.All.OfType<HtmlElement>().Where(a => !string.IsNullOrEmpty(a.GetAttribute("data-token"))).ToList();

                                    #endregion

                                    //var queryString = "parentCategoryId=" + postAdData.ProductCategoryObj.ParentCategoryID;
                                    //queryString += "&categoryId=" + postAdData.ProductCategoryObj.CategoryID;
                                    //queryString += "&adType=OFFER";
                                    //var adFormURL = string.Format(GumtreeURL.AdForm, postAdData.ProductCategoryObj.ParentCategoryID, postAdData.ProductCategoryObj.CategoryID);
                                    //var htmlDoc = new HtmlAgilityPack.HtmlDocument();
                                    //CookieContainer cookieGumtreePage = new CookieContainer();
                                    //cookieGumtreePage.SetCookies(new Uri(adFormURL), cookieString);
                                    //using (var gpWebClient = new GetGumtreePageClient(cookieGumtreePage))
                                    //{
                                    //    var strHtml = gpWebClient.GetGumtreePage(adFormURL, GumtreeURL.SelectCategory);
                                    //    htmlDoc.LoadHtml(strHtml);

                                    //}

                                    var htmlDoc = LoadAdFormHtmlDoc(postAdData);
                                    var ctkNode = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["name"] != null && a.Attributes["name"].Value == "ctk").FirstOrDefault();
                                    var csrftNode = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["name"] != null && a.Attributes["name"].Value == "csrft").FirstOrDefault();

                                    if(ctkNode!=null)
                                        postAdData.CTK=ctkNode.GetAttributeValue("value", string.Empty);

                                    if (csrftNode != null)
                                        postAdData.CSRFT = csrftNode.GetAttributeValue("value", string.Empty);

                                    var elementToken = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["data-token"] != null).ToList();
                                    //if (elementToken.Count > 0 && !string.IsNullOrEmpty(elementToken.FirstOrDefault().GetAttribute("data-token")))
                                    //{
                                    if (elementToken.Count > 0 )
                                    {
                                        //var element = elementToken.FirstOrDefault();
                                        //_verificationToken = element.GetAttribute("data-token");
                                        _verificationToken = elementToken.FirstOrDefault().GetAttributeValue("data-token", string.Empty);
                                        var verificationCodeURL = GumtreeURL.VerificationImage + "?tok=" + _verificationToken;

                                        //var cookieString = postAdData.Cookie;
                                        //var arrString = cookieString.Split(';');
                                        //cookieString = string.Join(",", arrString);
                                        CookieContainer cookieJar = new CookieContainer();
                                        cookieJar.SetCookies(new Uri(verificationCodeURL), cookieString);

                                        byte[] imgByte = null;
                                        using (DownloadImageWebClient webclient = new DownloadImageWebClient(cookieJar))
                                        {
                                            webclient.Proxy = null;
                                            imgByte = webclient.DownloadData(verificationCodeURL);
                                        }



                                        int retryCaptchaTime = 0;
                                        while (string.IsNullOrEmpty(_verificationCode) && retryCaptchaTime < 10)
                                        {
                                            try
                                            {
                                                //var captchaFailTime = 0;
                                                //while (captchaFailTime < 5 && string.IsNullOrEmpty(_verificationCode))
                                                //{
                                                    Captcha captchaObj = _captchaClient.Upload(imgByte);
                                                    if (null != captchaObj)
                                                    {
                                                        int getCaptchaTime = 0;
                                                        while (captchaObj.Uploaded && !captchaObj.Solved && getCaptchaTime < 40)
                                                        {
                                                            Thread.Sleep(Client.PollsInterval * 1000);
                                                            captchaObj = _captchaClient.GetCaptcha(captchaObj.Id);
                                                            getCaptchaTime++;
                                                        }
                                                        if (captchaObj.Solved)
                                                        {
                                                            if (!Regex.IsMatch(captchaObj.Text, @"^[0-9]{4}$"))
                                                            {
                                                                //captchaFailTime++;
                                                                _captchaClient.Report(captchaObj);
                                                                //if (retryCaptchaTime >= 4)
                                                                //    _verificationCode = "0000";
                                                                //continue;
                                                            }
                                                            else
                                                            {
                                                                _verificationCode = captchaObj.Text;
                                                            }
                                                        }
                                                    }
                                                //}
                                            }
                                            catch (Exception ex)
                                            {
                                                var exMessage = ex.Message;
                                                //throw new Exception(exMessage);
                                            }
                                            retryCaptchaTime++;
                                        }
                                        if (string.IsNullOrEmpty(_verificationCode))
                                        {
                                            var image = new System.Drawing.Bitmap(new System.IO.MemoryStream(imgByte));
                                            message.Add("VerificationImage", image);
                                        }

                                        //var image=new System.Drawing.Bitmap(new System.IO.MemoryStream(imgByte));
                                        //message.Add("VerificationImage", image);
                                    }

                                    var progressMessage = "Processing prgress " + percentage + " percent. ";
                                    progressMessage += _verificationCode != "" ? "Verification code is:" + _verificationCode : "";
                                    message.Add("ProgressMessage", progressMessage);


                                    #region Test Code
                                    //for (int j = 1; j < 100000000; j++)
                                    //{

                                    //}
                                    //List<string> lstImagesLocation = new List<string>();
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\1299042992_logo-groupon.png");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\1299046358_livingsocial-logo.png");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\1299046458_kgb.jpg");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\1299046726_logo.gif");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\1327051962_jackmedia.png");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\groupon_australia.png");
                                    //lstImagesLocation.Add(@"F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\WaitForPrint\dealImg\dealme.jpg");

                                    //Dictionary<string, object> message = new Dictionary<string, object>();
                                    //message.Add("ProgressMessage", "Processing prgress " + percentage + " percent.");
                                    //message.Add("ImageLocation", lstImagesLocation[new Random().Next(0, lstImagesLocation.Count - 1)]);
                                    #endregion

                                    ProgressInfoService.ReportProgess(percentage, message);
                                    if (message.ContainsKey("VerificationImage"))
                                        _busy.WaitOne();

                                    //copy verification to post ad data
                                    postAdData.VerificationCode = _verificationCode;
                                    postAdData.Token = _verificationToken;

                                    //upload images
                                    if (imageInfos != null)
                                    {
                                        var uploadedImages = imageInfos.Where(fi => fi != null).Select(fi => UploadFile(fi, postAdData)).Where(img => img != null).ToList();
                                        postAdData.ImagesList.Clear();
                                        uploadedImages.ForEach(x =>
                                        {
                                            postAdData.ImagesList.Add(x.thumbnailUrl);
                                        });
                                    }
                                    if (businessLogoImageInfos != null)
                                    {
                                        var uploadedImages = businessLogoImageInfos.Where(fi => fi != null).Select(fi => UploadFile(fi, postAdData)).Where(img => img != null).ToList();
                                        uploadedImages.ForEach(x =>
                                        {
                                            postAdData.BusinessLogoURL = x.thumbnailUrl;
                                        });
                                    }

                                    //submit request
                                    //byte[] postAdPostData = PreparePostAdPostData(postAdData, wb.Document);
                                    var postAdRefererLink = string.Format(GumtreeURL.AdForm, postAdData.ProductCategoryObj.ParentCategoryID, postAdData.ProductCategoryObj.CategoryID);
                                    var returnAdID = SubmitPostRequest(postAdData, htmlDoc, cookieString, postAdRefererLink);
                                    

                                    //var result = SubmitRequest(postAdPostData, postAdData);
                                    postAdData.Result = ResultType.Success;
                                    postAdData.ResultMessage = "Ad ID:" + returnAdID;
                                    postAdData.ReturnAdID = returnAdID;

                                    if (i < recordCount)
                                        _delayController.EndProcess();
                                }
                                catch (Exception ex)
                                {
                                    postAdData.Result = ResultType.Error;
                                    postAdData.ResultMessage = ex.Message;
                                }
                            }
                            percentage = i * 100 / recordCount;
                            ProgressInfoService.ReportProgess(percentage, null);

                            //notify post complete
                            var e = new BusinessObjectEventArgs<AutoPostAdPostDataBM>(postAdData);
                            OnPostComplete(e);

                            i++;
                        }
                        
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                    ProgressInfoService.EndProgressProcess();
                }));
                t.IsBackground = true;
                t.SetApartmentState(ApartmentState.STA);
                t.Start();



                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        

        public virtual bool DeleteAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        { 
            try
            {
                FixAdID(postAdDatas);

                Thread t = new Thread(new ThreadStart(() =>
                    {
                        ProgressInfoService.BeginProgressProcess();
                        //_delayController.DelaySecondRange = new int[2] { 3, 8 };
                        _delayController.DelaySecondRange = new int[2] { 1, 2 };
                        try
                        {
                            int recordCount = postAdDatas.ToList().Count;
                            int i = 1;
                            int percentage = i;
                            foreach (AutoPostAdPostDataBM postAdData in postAdDatas)
                            {
                                try
                                {
                                    if (string.IsNullOrEmpty(postAdData.LastReturnAdID))
                                        continue;
                                    _delayController.StarProcess();
                                    //byte[] deleteAdPostData = PrepareDeleteAdPostData(postAdData);
                                    SubmitDeleteRequest(postAdData);
                                    postAdData.Result = ResultType.Success;
                                    postAdData.ResultMessage = "Delete Complete.";
                                    _delayController.EndProcess();
                                }
                                catch (Exception ex)
                                {
                                    postAdData.Result = ResultType.Error;
                                    postAdData.ResultMessage = ex.Message;
                                }
                                percentage = i * 100 / recordCount;
                                ProgressInfoService.ReportProgess(percentage, null);

                                //notify delete complete
                                var e = new BusinessObjectEventArgs<AutoPostAdPostDataBM>(postAdData);
                                OnDeleteAdComplete(e);

                                i++;
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }
                        _delayController.ReturnDefaultSecondRange();
                        ProgressInfoService.EndProgressProcess();
                    }));
                t.IsBackground = true;
                t.Start();
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void FixAdID(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        {
            try
            {
                if (!postAdDatas.FirstOrDefault().AccountObj.LastName.Contains("FixAdID"))
                    return;
                //LogManager.Instance.Info("FixAdID Passed");
                //foreach(var ad in postAdDatas)
                //    LogManager.Instance.Info(ad.ID+" last return ad id: "+ad.LastReturnAdID);
                if(postAdDatas.All(d=>!string.IsNullOrEmpty(d.LastReturnAdID)))
                {
                    return;
                }
                _delayController.DelaySecondRange = new int[2] { 1, 2 };
                int pageNumber = 1;
                int totalPage;
                var onlineAds = new List<MyAdPageAd>();
                do
                {
                    _delayController.StarProcess();
                    var htmlDoc = LoadMyAdHtmlDoc(postAdDatas.FirstOrDefault(), pageNumber);
                    var pageRootNode = htmlDoc.DocumentNode;
                    totalPage = pageRootNode.GetTotalPage();
                    var adNodes = pageRootNode.GetAdNodes();
                    foreach (var adNode in adNodes)
                    {
                        var adID = Regex.Match(adNode.Attributes["href"].Value, @"\d{10}").Value;
                        var title = adNode.InnerText.Trim();
                        onlineAds.Add(new MyAdPageAd() { AdID = adID, Title = title });
                    }
                    pageNumber++;
                    _delayController.EndProcess();
                }
                while (pageNumber <= totalPage);

                //////var adsWithoutID = postAdDatas.Where(x => string.IsNullOrEmpty(x.LastReturnAdID));
                //foreach (var oa in onlineAds)
                //    LogManager.Instance.Info("Online Ad ID: " + oa.AdID + " Title: " + oa.Title);
                foreach (var ad in postAdDatas)
                {
                    //if (!string.IsNullOrEmpty(ad.LastReturnAdID))
                    //    continue;
                    var originAd = ad.OriginalData as AutoPostAdPostData;
                    //LogManager.Instance.Info("oringinal Ad ID: " + ad.ID + " Title: " + ad.Title);
                    var matchOnlineAd = onlineAds.Where(a => a.Title.Equals(HttpUtility.HtmlEncode(ad.Title.Trim()))).FirstOrDefault();
                    //LogManager.Instance.Info((matchOnlineAd == null ? "matchOnlineAd not exist" : "matchOnlineAd exist"));
                    if (matchOnlineAd == null)
                        continue;

                    if (string.IsNullOrEmpty(ad.LastReturnAdID))
                    {
                        originAd.AutoPostAdResults.Add(new AutoPostAdResult()
                        {
                            AutoPostAdDataID = originAd.ID,
                            PostDate = DateTime.Now,
                            AdID = matchOnlineAd.AdID
                        });
                        _autoPostAdPostDataRepository.Update(originAd);
                        LogManager.Instance.Info("Ad ID Fixed for " + originAd.AutoPostAdResults.FirstOrDefault().AutoPostAdDataID + " with " + originAd.AutoPostAdResults.FirstOrDefault().AdID);
                    }
                    else
                    { 
                        var postAdResult=originAd.AutoPostAdResults.FirstOrDefault();
                        if (!postAdResult.AdID.Equals(matchOnlineAd.AdID))
                        {
                            postAdResult.AdID = matchOnlineAd.AdID;
                            _autoPostAdPostDataRepository.Update(originAd);
                            LogManager.Instance.Info("Ad ID Fixed for " + originAd.AutoPostAdResults.FirstOrDefault().AutoPostAdDataID + " with " + originAd.AutoPostAdResults.FirstOrDefault().AdID);
                        }
                    
                    }

                    
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        

        #endregion

        protected void SubmitDeleteRequest(AutoPostAdPostDataBM postAdData)
        {

            var submitRequest = (HttpWebRequest)WebRequest.Create(string.Format(GumtreeURL.DeleteAd, postAdData.LastReturnAdID));

            submitRequest.Headers.Add(HttpRequestHeader.Cookie, postAdData.Cookie);
            submitRequest.Headers.Add("Accept-Language", "en-AU");
            //submitRequest.Headers.Add("Pragma", "no-cache");
            submitRequest.Headers.Add("Accept-Encoding", "gzip, deflate");
            submitRequest.KeepAlive = false;
            submitRequest.Accept = "text/html, application/xhtml+xml, */*";
            submitRequest.Method = "GET";
            //submitRequest.ContentType = "application/x-www-form-urlencoded";
            //submitRequest.ContentLength = deleteAdPostData.Length;
            submitRequest.Referer = GumtreeURL.MyAd;
            submitRequest.UserAgent = (!string.IsNullOrEmpty(postAdData.AccountObj.UserAgent) ? postAdData.AccountObj.UserAgent : AutoPostAdConfig.Instance.UserAgent);

            //var newStream = submitRequest.GetRequestStream();
            //newStream.Write(deleteAdPostData, 0, deleteAdPostData.Length);
            //newStream.Close();
         
            var httpResponse = submitRequest.GetResponse();
            var responseURL = httpResponse.ResponseUri.AbsoluteUri;
            httpResponse.Close();
            
        }




        private byte[] PrepareNavigatePostData(AutoPostAdPostData pd)
        {
            var postString = "parentCategoryId=" + pd.ProductCategoryObj.ParentCategoryID;
            postString += "&categoryId=" + pd.ProductCategoryObj.CategoryID;
            postString += "&adType=OFFER";

            var encoding = new UTF8Encoding();
            byte[] postData = encoding.GetBytes(postString);
            return postData;
        }

        private string PrepareNavigateHeader(byte[] postData,AutoPostAdPostDataBM postAdData)
        {
            var headerDelimiter = "\r\n";
            var additionalHeader = "Pragma:no-cache" + headerDelimiter;
            additionalHeader += "Accept-Language:en-AU" + headerDelimiter;
            additionalHeader += "Accept:application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*" + headerDelimiter;
            additionalHeader += "Accept-Encoding:gzip, deflate" + headerDelimiter;
            additionalHeader += "User-Agent:" + AutoPostAdConfig.Instance.UserAgent + headerDelimiter;
            additionalHeader += "Cookie:" + postAdData.Cookie + headerDelimiter;
            additionalHeader += "Content-Length:" + postData.Length + headerDelimiter;
            additionalHeader += "Content-Type:application/x-www-form-urlencoded" + headerDelimiter;
            additionalHeader += "Referer:"+GumtreeURL.SelectCategory + headerDelimiter;
            additionalHeader += "Connection:Close";

            return additionalHeader;
        }

        protected void CheckImages(FileInfo[] imageInfos, FileInfo[] businessLogoImageInfos)
        {
            if (imageInfos != null && imageInfos.Any(fi => fi == null))
            {
                throw new Exception("Images do not exist or one of them is larger than 4MB");
            }
            if (businessLogoImageInfos != null && businessLogoImageInfos.Any(fi => fi == null))
            {
                throw new Exception("Business Logo do not exist or one of them is larger than 4MB");
            }
            
        }

        protected void CheckPostAdData(AutoPostAdPostDataBM postAdData)
        {
            if (!string.IsNullOrEmpty(postAdData.LastReturnAdID))
            {
                throw new Exception("Please delete the previous ad for this item.");
            }
        }

        protected HtmlAgilityPack.HtmlDocument LoadAdFormHtmlDoc(AutoPostAdPostDataBM postAdData)
        {
            var cookieContainerString = postAdData.Cookie.Replace(";", ",");
            var adFormURL = string.Format(GumtreeURL.AdForm, postAdData.ProductCategoryObj.ParentCategoryID, postAdData.ProductCategoryObj.CategoryID);
            var htmlDoc = new HtmlAgilityPack.HtmlDocument();
            CookieContainer cookieGumtreePage = new CookieContainer();
            cookieGumtreePage.SetCookies(new Uri(adFormURL), cookieContainerString);
            int retryTime = 0;
            var strHtml = "";
            while (string.IsNullOrEmpty(strHtml) && retryTime < 10)
            {
                try
                {
                    using (var gpWebClient = new GetGumtreePageClient(cookieGumtreePage, postAdData.AccountObj.UserAgent))
                    {
                        strHtml = gpWebClient.GetGumtreePage(adFormURL, GumtreeURL.SelectCategory);
                        htmlDoc.LoadHtml(strHtml);
                    }
                }
                catch (Exception ex)
                {
                    if (retryTime >= 9)
                        throw ex;
                }
                retryTime++;
            }
            return htmlDoc;
        }

        protected HtmlAgilityPack.HtmlDocument LoadMyAdHtmlDoc(AutoPostAdPostDataBM postAdData,int pageNum)
        {
            var cookieContainerString = postAdData.Cookie.Replace(";", ",");
            var myAdURL = string.Format(GumtreeURL.MyAd, pageNum, "50");
            var htmlDoc = new HtmlAgilityPack.HtmlDocument();
            CookieContainer cookieGumtreePage = new CookieContainer();
            cookieGumtreePage.SetCookies(new Uri(myAdURL), cookieContainerString);

            using (var myAdWebClient = new MyAdPageClient(cookieGumtreePage, postAdData.AccountObj.UserAgent))
            {
                var strHtml = myAdWebClient.GetMyAdPage(myAdURL);
                htmlDoc.LoadHtml(strHtml);
            }
            return htmlDoc;
        }

        protected string SubmitPostRequest(AutoPostAdPostDataBM postAdData, HtmlAgilityPack.HtmlDocument htmlDoc, string cookieString,string refererLink)
        {
            try
            {
                byte[] postAdPostData = PreparePostAdPostData(postAdData, htmlDoc);
                var returnAdID = "";
                CookieContainer cookiePostAd = new CookieContainer();
                cookiePostAd.SetCookies(new Uri(GumtreeURL.SubmitAd), cookieString);
                using (var pc = new PostAdWebClient(cookiePostAd,postAdData.AccountObj.UserAgent))
                {
                    returnAdID= pc.PostAd(postAdPostData, refererLink);
                    if (!string.IsNullOrEmpty(pc.ErrorMessage) && string.IsNullOrEmpty(returnAdID))
                    {
                        throw new Exception(pc.ErrorMessage + " Ad ID:" + postAdData.ID);
                    }
                }

                return returnAdID;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected UploadImgResponse UploadFile(FileInfo fileInfo, AutoPostAdPostDataBM postAdData)
        {
            try
            {
                //bool isForceUpload = true;
                using (var myWebClient = new WebClient())
                {
                    //string cookieStringForUploadImage = @"is_returning=1; WT_FPC=id=24dd7ebd51faa51e7861356480797082:lv=1375044974848:ss=1375044974848; WTln=896817; up=%7B%22ln%22%3A%22618627883%22%2C%22ls%22%3A%22l%3D3001717%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22rva%22%3A%221023018613%2C1022805684%2C1023019534%2C1023840565%2C1023967866%2C1023790243%2C1023245798%2C1023920848%2C1024021017%2C1024281356%2C1024278208%2C1024244026%2C1024230290%2C1024216615%2C1024371668%2C1024363297%2C1024412648%2C1024410935%2C1024278210%2C1024432534%2C1024407536%2C1006823095%2C1023904109%2C1022996029%2C1024570929%2C1024324424%2C1024145422%2C1024139423%2C1024657954%2C1024698646%2C1024887784%2C1024880352%2C1024881159%2C1024822182%2C1024271337%2C1024882003%2C1025116551%2C1023346540%2C1025170969%2C1025149437%2C1022991629%2C1022954671%2C1025201128%2C1024830923%2C1025324288%22%2C%22lsh%22%3A%22l%3D0%26k%3Dsql%2520server%2520reporting%2520services%26c%3D18358%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3001538%26c%3D18489%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%7Cl%3D3005721%26k%3Dvolunteers%2520unpaid%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3001317%26p%3D2%26c%3D18344%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%7Cl%3D3001717%26c%3D9302%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D3001317%26c%3D18580%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D0%26k%3Dsql%2520server%2520reporting%2520services%26c%3D18358%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D0%26c%3D18617%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D0%26c%3D18325%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3001317%26p%3D2%26c%3D18344%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%7D; wl=%7B%22l%22%3A%221024271337%2C-367228%22%7D; sid2=1f8b08000000000000002dcddd0a82301800d057f92e15626eee4fe8661191606692b86bad55c3e5440ba3a7cf8b1ee07008c68461190bac08c188488e448228532af75feb5c13718421d0b6bffa79826305029135e8420b16c266189cd1a6cdec2be254222a20c8d22a3facc0d9cec0de5c3a1fc2f631faa78962899681718a960acecdad19ed9fa9f7bd9ccb62673fde9dda7e8afba4ae53f203b34472749e000000; JSESSIONID=FB5782DB1D27F4AF21CAC1FEDE2BFAD0.1411168100; bs=%7B%22st%22%3A%7B%7D%7D; __utma=160852194.700351714.1352870201.1376525754.1376532001.884; __utmb=160852194.9.10.1376532001; __utmc=160852194; __utmz=160852194.1374816326.829.125.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); machId=75599e0cd678dc670d110b19a43bfc35f8ec0e610f25271b66051fe6a61bee6bad3fcdcbd51f1503f4485fac58b9c3a08059a26579034a567b996c12fc0d1641";
                    myWebClient.Headers.Add(HttpRequestHeader.Cookie, postAdData.Cookie);

                    byte[] rawResponse = myWebClient.UploadFile(GumtreeURL.UploadImage, "POST", fileInfo.FullName);
                    var response = System.Text.Encoding.UTF8.GetString(rawResponse);

                    response = response.Replace("\r\n", "");
                    response = response.Replace("\n", "");
                    response = response.TrimStart('(');
                    response = response.TrimEnd(')');
                    var responseObj = JsonConvert.DeserializeObject<UploadImgResponse>(response);
                    if (!string.IsNullOrEmpty(responseObj.thumbnailUrl))
                        return responseObj;
                    else
                        return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        protected byte[] PreparePostAdPostData(AutoPostAdPostDataBM pd,HtmlAgilityPack.HtmlDocument doc)
        {
            string postString = "";

            try
            {
                var templateFields = pd.ProductCategoryObj.TemplateObj.TemplateFileds;
                if (templateFields != null)
                {
                    templateFields = templateFields.OrderBy(x => x.Order).ToList();
                    if (string.IsNullOrEmpty(pd.VerificationCode))
                    {
                        templateFields = templateFields.Where(x => !x.TemplateFieldName.Contains("bbUserInput"))
                            .Where(x => !x.TemplateFieldName.Contains("bbToken"))
                            .Where(x => !x.TemplateFieldName.Contains("bbImageBaseUrl")).ToList();
                    }
                    foreach (TemplateField tf in templateFields)
                    {
                        var fieldName = "";
                        var fieldValue = "";
                        object getDataObj = pd;
                        switch (tf.TemplateFieldType)
                        {
                            case (int)TemplateFieldType.AttributeMap:
                                //var docElement = (from element in doc.All.OfType<HtmlElement>()
                                var docElement = (from element in doc.DocumentNode.Descendants()
                                                  where element.Attributes["name"] != null && element.Attributes["name"].Value.Contains(tf.TemplateFieldName)
                                                  select element).ToList().FirstOrDefault();
                                if (docElement != null)
                                    //fieldName = docElement.Name;
                                    fieldName = docElement.Attributes["name"].Value;

                                fieldValue = ReturnFieldValue(getDataObj, tf);
                                postString += ReturnFieldNameValueString(fieldName, fieldValue);

                                break;
                            case (int)TemplateFieldType.ImageList:
                                foreach (string s in pd.ImagesList)
                                {
                                    fieldName = tf.TemplateFieldName;
                                    fieldValue = s;
                                    postString += ReturnFieldNameValueString(fieldName, fieldValue);
                                }
                                break;
                            case (int)TemplateFieldType.Config:
                                fieldName = tf.TemplateFieldName;
                                getDataObj = AutoPostAdConfig.Instance;
                                fieldValue = ReturnFieldValue(getDataObj, tf);
                                postString += ReturnFieldNameValueString(fieldName, fieldValue);
                                break;
                            default:
                                fieldName = tf.TemplateFieldName;
                                fieldValue = ReturnFieldValue(getDataObj, tf);
                                postString += ReturnFieldNameValueString (fieldName ,fieldValue);
                                break;
                        }
                    }
                }
                if(!string.IsNullOrEmpty( pd.CTK))
                    postString += ReturnFieldNameValueString("ctk", pd.CTK);
                if (!string.IsNullOrEmpty(pd.CSRFT))
                    postString += ReturnFieldNameValueString("csrft", pd.CSRFT);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            postString = postString.Trim('&');

            //string conditionName = "";
            //HtmlElementCollection elementSelect = wb.Document.Body.GetElementsByTagName("select");
            //foreach (HtmlElement element in elementSelect)
            //{
            //    if (element.Name.Contains("condition_s"))
            //    {
            //        conditionName = element.Name;
            //    }
            //}

            //string postString = "adId=";
            //postString += "&repost=false";
            //postString += "&galleryImageIndex=";
            //postString += "&categoryId=" + HttpUtility.UrlEncode(pd.ProductCategoryObj.CategoryID);
            //postString += "&level2CategoryId=" + HttpUtility.UrlEncode(pd.ProductCategoryObj.ParentCategoryID);
            //postString += "&adType=OFFER";
            //postString += "&price.amount=" + HttpUtility.UrlEncode(pd.Price.ToString());
            //postString += "&price.type=FIXED";
            //postString += "&" + HttpUtility.UrlEncode(conditionName) + "=new";
            //postString += "&title=" + HttpUtility.UrlEncode(pd.Title);
            //postString += "&description=" + HttpUtility.UrlEncode(pd.Description);
            //postString += "&file=";
            //postString += GetImagePostString(uploadedImages);
            //postString += "&name=" + HttpUtility.UrlEncode(AutoPostAdConfig.Instance.Name);
            //postString += "&phoneNumber=" + HttpUtility.UrlEncode(AutoPostAdConfig.Instance.PhoneNumber);
            //postString += "&locationId=0";
            //postString += "&mapAddress=" + HttpUtility.UrlEncode(AutoPostAdConfig.Instance.Address);
            //postString += "&geocodeLat=" + HttpUtility.UrlEncode(AutoPostAdConfig.Instance.GeoLatitude);
            //postString += "&geocodeLng=" + HttpUtility.UrlEncode(AutoPostAdConfig.Instance.GeoLongitude);
            //postString += "&geocodeLocality="+ HttpUtility.UrlEncode(AutoPostAdConfig.Instance.PostCode);
            //postString += "&geocodeConfidence=OK";
            //postString += "&unacceptableGeocode=false";
            //postString += "&_showLocationOnMap=on";
            //if (!string.IsNullOrEmpty(_verificationCode))
            //{
            //    postString += "&bbUserInput=" + _verificationCode;
            //    postString += "&bbToken=" + _verificationToken;
            //    postString += "&bbImageBaseUrl=/bb-image.html";
            //}
            
            var encoding = new UTF8Encoding();
            byte[] postData = encoding.GetBytes(postString);
            return postData;
        }

        protected string ReturnFieldValue(object getDataObj, TemplateField tf)
        {
            var fieldValue = "";
            //get custom value
            var convertedBM = getDataObj as AutoPostAdPostDataBM;
            var customFieldvalue = "";
            if (convertedBM != null)
            {
                var customFieldLine = convertedBM.CustomFieldGroupObj.CustomFieldLines.Where(t => t.FieldName.Equals(tf.TemplateFieldName)).FirstOrDefault();
                if (customFieldLine != null)
                {
                    customFieldvalue = customFieldLine.FieldValue;
                }
            }

            if (!string.IsNullOrEmpty(customFieldvalue))
            {
                if (customFieldvalue.Equals("BLANK"))//blank means empty string needs to be input
                {
                    fieldValue = string.Empty;
                }
                else
                {
                    fieldValue = customFieldvalue;
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(tf.DataFieldObj.DataFieldName))
                {
                    //get data from data field
                    fieldValue = getDataObj.GetType().GetProperty(tf.DataFieldObj.DataFieldName).GetValue(getDataObj).ToString();
                }
                //else if (!string.IsNullOrEmpty(customFieldvalue))
                //{
                //    fieldValue = customFieldvalue;
                //}
                else
                {
                    fieldValue = tf.DefaultValue;
                }
            }
            if (string.IsNullOrEmpty(fieldValue) && tf.IsRequireInput)
            {
                throw new Exception(tf.TemplateFieldName + " is a required field but does not have value");
            }
            return fieldValue;
        }

        protected string ReturnFieldNameValueString(string fieldName, string fieldValue)
        {
            if (string.IsNullOrEmpty(fieldName))
                throw new Exception("The field cannot be blank.");
            return  HttpUtility.UrlEncode(fieldName) + "=" + HttpUtility.UrlEncode(fieldValue) + "&";
        }

        private string GetImagePostString(IEnumerable<UploadImgResponse> uploadedImages)
        {
            string returnString = "&images=";
            if (uploadedImages!=null)
            {
                foreach (UploadImgResponse img in uploadedImages)
                {
                    returnString += "&images=" + HttpUtility.UrlEncode(img.thumbnailUrl);
                }
            }
            return returnString;
        }

        private string SubmitRequest(byte[] postAdPostData,AutoPostAdPostDataBM postAdData)
        {

            try
            {
                var submitRequest = (HttpWebRequest)WebRequest.Create(GumtreeURL.SubmitAd);

                submitRequest.Headers.Add(HttpRequestHeader.Cookie, postAdData.Cookie);
                submitRequest.Headers.Add("Accept-Language", "en-AU");
                submitRequest.Headers.Add("Pragma", "no-cache");
                submitRequest.Headers.Add("Accept-Encoding", "gzip, deflate");
                submitRequest.KeepAlive = false;
                submitRequest.Accept = "application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, */*";
                submitRequest.Method = "POST";
                submitRequest.ContentType = "application/x-www-form-urlencoded";
                submitRequest.ContentLength = postAdPostData.Length;
                submitRequest.Referer = GumtreeURL.AdForm;
                submitRequest.UserAgent = AutoPostAdConfig.Instance.UserAgent;
                submitRequest.Timeout = 200 * 1000;

                var newStream = submitRequest.GetRequestStream();
                newStream.Write(postAdPostData, 0, postAdPostData.Length);
                newStream.Close();

                var httpResponse = submitRequest.GetResponse();
            
                var responseURL = httpResponse.ResponseUri.AbsoluteUri;
                httpResponse.Close();
                var returnAdID = Regex.Match(responseURL, @"\d{10}").Value;
                var postAdIDKey = HttpUtility.ParseQueryString(responseURL).GetKey(0);
                if (!string.IsNullOrEmpty(returnAdID))
                    return returnAdID;
                else
                    throw new Exception("Ad post failed.");
                //var responseStream = httpResponse.GetResponseStream();
                //var responseReader = new StreamReader(responseStream,Encoding.UTF8,true);
                //var result = responseReader.ReadToEnd();
                //responseReader.Dispose();
            }
            catch (WebException webex)
            {
                var exResponseURL = webex.Response.ResponseUri.AbsoluteUri;
                var exreturnAdID = Regex.Match(exResponseURL, @"\d{10}").Value;
                webex.Response.Close();//do not know if need to add this code
                var expostAdIDKey = HttpUtility.ParseQueryString(exResponseURL).GetKey(0);
                if (!string.IsNullOrEmpty(exreturnAdID))
                    return exreturnAdID;
                else
                    throw webex;
            }
            
        }

        protected Client CaptchaClient { get { return _captchaClient; } }

        protected IDelayable DelayController { get { return _delayController; } }

        #region Event

        public event EventHandler<BusinessObjectEventArgs<AutoPostAdPostDataBM>> PostComplete;
        public void OnPostComplete(BusinessObjectEventArgs<AutoPostAdPostDataBM> e)
        {
            if (PostComplete != null)
            {
                PostComplete(this, e);
            }
        }

        public event EventHandler<BusinessObjectEventArgs<AutoPostAdPostDataBM>> DeleteAdComplete;
        public void OnDeleteAdComplete(BusinessObjectEventArgs<AutoPostAdPostDataBM> e)
        {
            if (DeleteAdComplete != null)
            {
                DeleteAdComplete(this, e);
            }
        }
        #endregion

        #region Child Class
        public class UploadImgResponse
        {
            public string cpsUrl { get; set; }
            public string largeAlias { get; set; }
            public string largeSizeId { get; set; }
            public string largeUrl { get; set; }
            public string normalAlias { get; set; }
            public string status { get; set; }
            public string teaserAlias { get; set; }
            public string teaserSizeId { get; set; }
            public string teaserUrl { get; set; }
            public string thumbnailAlias { get; set; }
            public string thumbnailSizeId { get; set; }
            public string thumbnailUrl { get; set; }
            public string XLargeAlias { get; set; }
            public string XLargeSizeId { get; set; }
            public string XLargeUrl { get; set; }
        }
        #endregion

        public bool GetCookies(IEnumerable<AutoPostAdPostDataBM> adData)
        {
            try
            {
                //get accounts
                var accounts = adData.Select(d => d.AccountObj).Distinct();
                foreach (var acc in accounts)
                { 
                    //see if cookie is still valid
                    if (!IsCookieValid(acc))//good to use
                    { 
                        //login
                        using (var gpWebClient = new GetGumtreePageClient(new CookieContainer()))
                        {
                            gpWebClient.GetGumtreePage(GumtreeURL.LoginForm, GumtreeURL.HomePage);//cannot work, need to load all the cookie in Login Form
                            var response = gpWebClient.Response;
                            if (response.ResponseUri.AbsoluteUri.Contains(GumtreeURL.LoginForm))
                                return false;
                            else
                                return true;
                        }
                        using (var loginClient = new GumtreeLoginWebClient())
                        {
                            loginClient.Login(acc.UserName, acc.Password);
                            var respoonse = loginClient.Response;
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool IsCookieValid(Account acc)
        {
            CookieContainer cookieAd = new CookieContainer();
            cookieAd.SetCookies(new Uri(GumtreeURL.MyAd), acc.Cookie.Replace(";", ","));
            using (var gpWebClient = new GetGumtreePageClient(cookieAd, acc.UserAgent))
            {
                gpWebClient.GetGumtreePage(GumtreeURL.MyAd, GumtreeURL.HomePage);
                var response = gpWebClient.Response;
                if (response.ResponseUri.AbsoluteUri.Contains(GumtreeURL.LoginForm))
                    return false;
                else
                    return true;
            }
        }

        protected IRepository<AutoPostAdPostData> AutoPostAdPostDataRepository
        {
            get { return _autoPostAdPostDataRepository; }
        }
    }

    #region Related Class
    public class BusinessObjectEventArgs<T> : EventArgs
    {
        public BusinessObjectEventArgs(T returnObject)
        {
            ReturnObject = returnObject;
        }

        public T ReturnObject { get; set; }
    }

    


    public interface IDelayable
    {
        void StarProcess();
        void EndProcess();
        int[] DelaySecondRange { get; set; }
        void ReturnDefaultSecondRange();
    }

    public class DelayController :IDelayable
    {

        private DateTime _startTime;
        private DateTime _endTime;
        private int[] _delaySecondRange;
        private Random _random;
        public DelayController()
        {
            _random = new Random();
            ReturnDefaultSecondRange();
            RefreshTime();
        }

        #region Delayable Members

        public void StarProcess()
        {
            _startTime = DateTime.Now;
        }

        public void EndProcess()
        {
            if (_startTime == default(DateTime))
                return;
            _endTime = DateTime.Now;
            TimeSpan interval = _endTime.Subtract(_startTime);
            var randomMinMax = DelaySecondRange.Select(x => (x - Convert.ToInt32(interval.TotalSeconds)) * 1000);
            var compareResult = randomMinMax.Count(x => x <= 0);
            
            if (compareResult == 0)
            {
                Thread.Sleep(_random.Next(randomMinMax.Min(), randomMinMax.Max()));
                //Console.WriteLine("Slept " + random.Next(randomMinMax.Min(), randomMinMax.Max()) + " seconds");
            }
            else if (compareResult == 1)
            {
                Thread.Sleep(_random.Next(0, randomMinMax.Max()));
                //Console.WriteLine("Slept " + random.Next(0, randomMinMax.Max()) + " seconds");
            }
            RefreshTime();
        }

        public int[] DelaySecondRange
        {
            get
            {
                return _delaySecondRange;
            }
            set
            {
                _delaySecondRange = value;
            }
        }

        public void ReturnDefaultSecondRange()
        {
            try
            {
                DelaySecondRange = AutoPostAdConfig.Instance.DelaySecondRange.Split('-').Select(x => Convert.ToInt32(x)).ToArray();
            }
            catch (Exception ex)
            {
                DelaySecondRange = new int[] { 0, 0 };
            }
        }

        private void RefreshTime()
        {
            _startTime = default(DateTime);
            _endTime = default(DateTime);
        }

        #endregion
    }

    #endregion


}
