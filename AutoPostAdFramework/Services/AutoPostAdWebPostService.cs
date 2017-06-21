using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;
using Common.Models;
using AutoPostAdBusiness.Handlers;
using System.Threading;
using Common;
using AutoPostAdBusiness.BusinessModels;
using AutoPostAdBusiness.MapperInfrastruture;
using Common.DeathByCaptcha;
using System.Net;
using System.Text.RegularExpressions;

namespace AutoPostAdBusiness.Services
{
    public interface IAutoPostAdWebPostService
    {
        bool FetchAndSaveGumtreeCookie(string userName,string password);

        bool PostActiveAdOnWeb();

        bool DeleteExistingAd();

        bool PostAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas);

        bool DeleteAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas);
    }


    public class AutoPostAdWebPostService : GumtreeWebsite,IAutoPostAdWebPostService
    {
        #region Fields

        //private readonly IRepository<AutoPostAdHeader> _autoPostAdHeaderRepository;
        //private readonly IRepository<AutoPostAdLine> _autoPostAdLineRepository;
        private readonly IRepository<Account> _accountRepository;
        //private readonly IRepository<AutoPostAdPostData> _autoPostAdPostDataRepository;
        private readonly IAutoPostAdResultService _autoPostAdResultService;
        private readonly AuthenticCookieFetcher _cookieFetcher;
        private readonly AutoResetEvent _resultEvent;

        #endregion

        #region Ctor

        public AutoPostAdWebPostService(IRepository<Account> accountRepository,
            IRepository<AutoPostAdPostData> autoPostAdPostDataRepository,
            IAutoPostAdResultService autoPostAdResultService,
            Client captchaClient, 
            IDelayable delayController)
            : base(captchaClient, delayController, autoPostAdPostDataRepository)
        {
            _resultEvent = new AutoResetEvent(false);
            _cookieFetcher = new AuthenticCookieFetcher(_resultEvent);
            _accountRepository = accountRepository;
            //_autoPostAdPostDataRepository = autoPostAdPostDataRepository;
            _autoPostAdResultService = autoPostAdResultService;
        }

        #endregion

        //public virtual void InsertAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        //{
        //    if (autoPostAdHeader == null)
        //        throw new ArgumentNullException("autoPostAdHeader");

        //    _autoPostAdHeaderRepository.Insert(autoPostAdHeader);

        //}

        //public virtual void UpdateAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        //{
        //    if (autoPostAdHeader == null)
        //        throw new ArgumentNullException("autoPostAdHeader");

        //    _autoPostAdHeaderRepository.Update(autoPostAdHeader);

        //}

        //public virtual void DeleteAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        //{
        //    if (autoPostAdHeader == null)
        //        throw new ArgumentNullException("autoPostAdHeader");

        //    _autoPostAdHeaderRepository.Delete(autoPostAdHeader);

        //}

        //public virtual AutoPostAdHeader GetAutoPostAdHeaderByID(int ID)
        //{
        //    if (ID == 0)
        //        return null;

        //    return _autoPostAdHeaderRepository.GetById(ID);
        //}

        public bool FetchAndSaveGumtreeCookie(string userName, string password)
        {
            try
            {
                _cookieFetcher.GetAuthenticCookie(userName, password);
                _resultEvent.WaitOne();
                LogManager.Instance.Info("Return main thread");
                if (!string.IsNullOrEmpty(_cookieFetcher.CookieString))
                {
                    var acc = GetAccountByUserName(userName);
                    if (acc != null)
                    {
                        LogManager.Instance.Info("Save cookie");
                        acc.Cookie = _cookieFetcher.CookieString;
                        _accountRepository.Update(acc);
                    }
                    else
                    {
                        throw new Exception("Account does not exist.");
                    }
                }
                else
                {
                    throw new Exception("Cannot get cookie string.");
                }
                

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
                return false;

            }
        }

        private Account GetAccountByUserName(string userName)
        {
            return _accountRepository.Table.FirstOrDefault(a => a.UserName.Equals(userName));
        }


        public bool PostActiveAdOnWeb()
        {
            //get active ads
            var activeAds = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(AutoPostAdPostDataRepository.Table.Where(ad => ad.Status == Status.Active).ToList());
            return this.PostAd(activeAds);
        }

        public bool DeleteExistingAd()
        {
            var existingAd = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(AutoPostAdPostDataRepository.Table.Where(ad => ad.AutoPostAdResults.Any() && ad.Status == Status.Active).ToList());
            return this.DeleteAd(existingAd);
        }

        public override bool PostAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        {
            try
            {
                if (postAdDatas != null && postAdDatas.Count() > 0)
                {
                    var breakLoop = false;
                    int recordCount = postAdDatas.Count();
                    int i = 1;
                    int verificationCodeErr = 0;
                    
                    foreach (var ad in postAdDatas)
                    {
                        if (breakLoop)
                            throw new Exception("Ad post failed due to trying for 3 times, please check if the account is banned.");
                        else if (verificationCodeErr >= recordCount * 0.4)
                            throw new Exception("Ad post failed due to cannot read verification code.");
                        var retry = 0;
                        var needRetry = false;
                        //var verificationCode = string.Empty;
                        while (retry == 0 || needRetry)
                        {
                            try
                            {
                                retry++;
                                if (retry > 3)//max 3 times
                                {
                                    breakLoop = true;
                                    break;
                                }
                                DelayController.StarProcess();
                                //check images
                                var imageInfos = ad.GetImages(ad.ImagesPath);
                                var businessLogoImageInfos = ad.GetImages(ad.BusinessLogoPath);
                                CheckImages(imageInfos, businessLogoImageInfos);

                                //check PostAdData
                                CheckPostAdData(ad);

                                var cookieContainerString = ad.Cookie.Replace(";", ",");

                                var htmlDoc = LoadAdFormHtmlDoc(ad);
                                //get csrft token
                                var ctkNode = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["name"] != null && a.Attributes["name"].Value == "ctk").FirstOrDefault();
                                var csrftNode = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["name"] != null && a.Attributes["name"].Value == "csrft").FirstOrDefault();
                                if (ctkNode != null)
                                    ad.CTK = ctkNode.GetAttributeValue("value", string.Empty);
                                if (csrftNode != null)
                                    ad.CSRFT = csrftNode.GetAttributeValue("value", string.Empty);
                                //get verification code if exist
                                var elementToken = htmlDoc.DocumentNode.Descendants().Where(a => a.Attributes["data-token"] != null).ToList();
                                if (elementToken.Count > 0)
                                {

                                    var verificationToken = elementToken.FirstOrDefault().GetAttributeValue("data-token", string.Empty);
                                    var verificationCode = GetVerificationCode(verificationToken, cookieContainerString,ad.AccountObj.UserAgent);

                                    if (string.IsNullOrEmpty(verificationCode))
                                    {
                                        //breakLoop = true;
                                        verificationCodeErr++;
                                        needRetry = false;
                                        throw new Exception("Cannot read verifcation code");
                                    }

                                    ad.VerificationCode = verificationCode;
                                    ad.Token = verificationToken;

                                }

                                //upload images
                                if (imageInfos != null)
                                {
                                    var uploadedImages = imageInfos.Where(fi => fi != null).Select(fi => UploadFile(fi, ad)).Where(img => img != null).ToList();
                                    ad.ImagesList.Clear();
                                    uploadedImages.ForEach(x =>
                                    {
                                        ad.ImagesList.Add(x.thumbnailUrl);
                                    });
                                }
                                if (businessLogoImageInfos != null)
                                {
                                    var uploadedImages = businessLogoImageInfos.Where(fi => fi != null).Select(fi => UploadFile(fi, ad)).Where(img => img != null).ToList();
                                    uploadedImages.ForEach(x =>
                                    {
                                        ad.BusinessLogoURL = x.thumbnailUrl;
                                    });
                                }

                                //submit request
                                var postAdRefererLink = string.Format(GumtreeURL.AdForm, ad.ProductCategoryObj.ParentCategoryID, ad.ProductCategoryObj.CategoryID);
                                ad.ReturnAdID = SubmitPostRequest(ad, htmlDoc, cookieContainerString, postAdRefererLink);

                                //save post ad result
                                if (!string.IsNullOrEmpty(ad.ReturnAdID))
                                {
                                    //var originAd = (postAdDatas as AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>).OrginalDataSource.FirstOrDefault(o => o.ID == ad.ID);
                                    var originAd = AutoPostAdPostDataRepository.GetById(ad.ID);
                                    originAd.AutoPostAdResults.Add(new AutoPostAdResult()
                                    {
                                        AutoPostAdDataID = ad.ID,
                                        PostDate = DateTime.Now,
                                        AdID = ad.ReturnAdID
                                    });
                                    AutoPostAdPostDataRepository.Update(originAd);
                                }

                                LogManager.Instance.Info("Ad ID:" + ad.ID + " return post ad ID is:" + (string.IsNullOrEmpty(ad.ReturnAdID) ? string.Empty : ad.ReturnAdID));
                                needRetry = false;
                                if (i < recordCount)
                                    DelayController.EndProcess();
                            }
                            catch (Exception ex)
                            {
                                LogManager.Instance.Error(ex.Message);
                                if (ex.Message.Contains("Ad post failed"))
                                    needRetry = true;
                            }
                        }

                        i++;

                    }
                    
                }


                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
                return false;
            }
        }


        public override bool DeleteAd(IEnumerable<AutoPostAdPostDataBM> postAdDatas)
        {
            DelayController.DelaySecondRange = new int[2] { 1, 2 };
            try
            {
                FixAdID(postAdDatas);

                int recordCount = postAdDatas.Count();
                int i = 1;
                int percentage = i;

                foreach (AutoPostAdPostDataBM ad in postAdDatas)
                {
                    try
                    {
                        if (string.IsNullOrEmpty(ad.LastReturnAdID))
                            continue;
                        DelayController.StarProcess();
                        var cookieContainerString = ad.Cookie.Replace(";",",");
                        var deleteAdURL=string.Format( GumtreeURL.DeleteAd ,ad.LastReturnAdID);
                        //CookieContainer cookieDeletAdPage = new CookieContainer();
                        //cookieDeletAdPage.SetCookies(new Uri(deleteAdURL), cookieContainerString);
                        //using (var deleteAdWebClient = new DeleteGumtreeAdClient(cookieDeletAdPage))
                        //{
                        //    deleteAdWebClient.DeleteAd(deleteAdURL);
                        //}
                        SubmitDeleteRequest(ad);
                        _autoPostAdResultService.DeleteAutoPostAdResult(ad.LastReturnAdResult);
                        if (ad.LastReturnAdResult != null)
                        {
                            ad.AutoPostAdResults.Clear();
                        }
                        DelayController.EndProcess();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
                return false;
            }
        }

        #region Private Method

        private string GetVerificationCode(string verificationToken, string cookieContainerString,string userAgent)
        {
            var verificationCode = string.Empty;
            var verificationCodeURL = GumtreeURL.VerificationImage + "?tok=" + verificationToken;

            CookieContainer cookieJar = new CookieContainer();
            cookieJar.SetCookies(new Uri(verificationCodeURL), cookieContainerString);

            byte[] imgByte = null;
            using (DownloadImageWebClient webclient = new DownloadImageWebClient(cookieJar, userAgent))
            {
                imgByte = webclient.DownloadData(verificationCodeURL);
            }

            int retryCaptchaTime = 0;
            //int maliciousRead = 0;
            while (string.IsNullOrEmpty(verificationCode) && retryCaptchaTime < 10)
            {
                try
                {
                    Captcha captchaObj = CaptchaClient.Upload(imgByte);
                    if (null != captchaObj)
                    {
                        int getCaptchaTime = 0;
                        while (captchaObj.Uploaded && !captchaObj.Solved && getCaptchaTime<40)
                        {
                            Thread.Sleep(Client.PollsInterval * 1000);
                            captchaObj = CaptchaClient.GetCaptcha(captchaObj.Id);
                            getCaptchaTime++;
                        }
                        if (captchaObj.Solved)
                        {
                            if (!Regex.IsMatch(captchaObj.Text, @"^[0-9]{4}$"))
                            {
                                //captchaFailTime++;
                                CaptchaClient.Report(captchaObj);
                                //maliciousRead++;
                                //if (retryCaptchaTime >= 4)
                                //    verificationCode = "0000";
                                //continue;
                            }
                            else
                            {
                                verificationCode = captchaObj.Text;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    //throw new Exception(ex.Message);
                }
                retryCaptchaTime++;
            }
            return verificationCode;
                                    
        }


        #endregion

        
        
    }
}
