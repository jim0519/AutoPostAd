using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using eBay.Service.Core.Sdk;
using eBay.Service.Core.Soap;
using eBay.Service.Util;

namespace Common
{
    public class AutoPostAdConfig
    {
        private static AutoPostAdConfig _instance;
        private ApiContext _eBayAPIContext;
        private AutoPostAdConfig()
        {
        
        }

        public static AutoPostAdConfig Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new AutoPostAdConfig();
                }
                return _instance;
            }
        }

        public string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["AutoPostAdContext"].ConnectionString;
            }
        }

        public ApiContext eBayAPIContext
        {
            get
            {
                if (_eBayAPIContext != null)
                {
                    return _eBayAPIContext;
                }
                else
                {
                    _eBayAPIContext = new ApiContext();

                    //set Api Server Url
                    _eBayAPIContext.SoapApiServerUrl =
                        ConfigurationManager.AppSettings["eBayApiServiceUrl"];
                    //set Api Token to access eBay Api Server
                    ApiCredential apiCredential = new ApiCredential();
                    apiCredential.eBayToken =
                        ConfigurationManager.AppSettings["eBayApiToken"];
                    _eBayAPIContext.ApiCredential = apiCredential;
                    //set eBay Site target to AU
                    _eBayAPIContext.Site = SiteCodeType.Australia;

                    //set Api logging
                    //_eBayAPIContext.ApiLogManager = new ApiLogManager();
                    //_eBayAPIContext.ApiLogManager.ApiLoggerList.Add(
                    //    new FileLogger("listing_log.txt", true, true, true)
                    //    );
                    //_eBayAPIContext.ApiLogManager.EnableLogging = true;


                    return _eBayAPIContext;
                }
            }
        }

        //public string CookieString
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["CookieString"];
        //    }
        //}

        //public string Address
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["Address"];
        //    }
        //}

        //public string GeoLatitude
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["GeoLatitude"];
        //    }
        //}

        //public string GeoLongitude
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["GeoLongitude"];
        //    }
        //}

        //public string PostCode
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["PostCode"];
        //    }
        //}

        //public string PhoneNumber
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["PhoneNumber"];
        //    }
        //}

        //public string Name
        //{
        //    get
        //    {
        //        return ConfigurationManager.AppSettings["Name"];
        //    }
        //}


        public string UserAgent
        {
            get
            {
                return ConfigurationManager.AppSettings["UserAgent"];
            }
        }

        public string DeathByCaptchaUserName
        {
            get
            {
                return ConfigurationManager.AppSettings["DeathByCaptchaUserName"];
            }
        }

        public string DeathByCaptchaPassword
        {
            get
            {
                return ConfigurationManager.AppSettings["DeathByCaptchaPassword"];
            }
        }

        public string DelaySecondRange
        {
            get
            {
                return ConfigurationManager.AppSettings["DelaySecondRange"];
            }
        }



        public string QuickSaleServiceURL
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleServiceURL"];
            }
        }

        public string QuickSaleDevID
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleDevID"];
            }
        }

        public string QuickSaleDevToken
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleDevToken"];
            }
        }

        public string ImageFilesPath
        {
            get
            {
                return ConfigurationManager.AppSettings["ImageFilesPath"];
            }
        }

        public string DropshipzoneGroupPriceFilePath
        {
            get
            {
                return ConfigurationManager.AppSettings["DropshipzoneGroupPriceFilePath"];
            }
        }

        public string DropshipzoneGroupPostageFilePath
        {
            get
            {
                return ConfigurationManager.AppSettings["DropshipzoneGroupPostageFilePath"];
            }
        }

        public string[] ActiveForms
        {
            get
            {
                return ConfigurationManager.AppSettings["ActiveForms"].Split(',');
            }
        }

        public string QuickSaleLocSuburb
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleLocSuburb"];
            }
        }

        public string QuickSaleLocPostcode
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleLocPostcode"];
            }
        }

        public string QuickSaleLocState
        {
            get
            {
                return ConfigurationManager.AppSettings["QuickSaleLocState"];
            }
        }

        public string ChannelType
        {
            get
            {
                return ConfigurationManager.AppSettings["ChannelType"];
            }
        }

        public string LocalHost
        {
            get
            {
                return ConfigurationManager.AppSettings["LocalHost"];
            }
        }

    }
}
