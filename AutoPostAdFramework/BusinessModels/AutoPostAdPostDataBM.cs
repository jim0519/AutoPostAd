using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using Common;

namespace AutoPostAdBusiness.BusinessModels
{
    //public partial class AutoPostAdPostDataBM : AutoPostAdPostData
    //{
    //    private string _lastReturnAdID;
    //    public AutoPostAdPostDataBM()
    //    {
    //        ImagesList = new List<string>();
    //        BusinessLogoURL = "";
    //    }

    //    public bool Selected { get; set; }
    //    public string Result { get; set; }
    //    public string ResultMessage { get; set; }
    //    public string ReturnAdID { get; set; }
    //    public string WebsiteCategoryID
    //    {
    //        get 
    //        {
    //            return ProductCategoryObj.CategoryID;
    //        }
    //    }

    //    public string WebsiteCategoryName
    //    {
    //        get
    //        {
    //            return ProductCategoryObj.CategoryName;
    //        }
    //    }

    //    public string WebsiteParentCategoryID
    //    {
    //        get
    //        {
    //            return ProductCategoryObj.ParentCategoryID;
    //        }
    //    }

    //    public ICollection<string> ImagesList
    //    {
    //        get;
    //        set;
    //    }

    //    public string BusinessLogoURL
    //    {
    //        get;
    //        set;
    //    }

    //    public string LastReturnAdID
    //    {
    //        get 
    //        {
    //            //if(_lastReturnAdID ==null)
    //            //{
    //                var lastReturnAdResult=AutoPostAdResults.OrderByDescending(o=>o.PostDate).FirstOrDefault();
    //                _lastReturnAdID = lastReturnAdResult == null ? "" : lastReturnAdResult.AdID;
    //            //}
    //            return _lastReturnAdID;
    //        }
    //    }

    //    public AutoPostAdResult LastReturnAdResult
    //    {
    //        get
    //        {
    //            return AutoPostAdResults.OrderByDescending(o => o.PostDate).FirstOrDefault();
    //        }
    //    }

    //    public string VerificationCode { get; set; }
    //    public string Token { get; set; }
    //    public string CTK { get; set; }
    //    public string CSRFT { get; set; }

    //    #region Address Properties
    //    public string AddressName
    //    {
    //        get 
    //        {
    //            return AddressObj.AddressName;
    //        }
    //    }

    //    public string PostCode
    //    {
    //        get
    //        {
    //            return AddressObj.PostCode;
    //        }
    //    }

    //    public string GeoLatitude
    //    {
    //        get
    //        {
    //            return AddressObj.GeoLatitude;
    //        }
    //    }

    //    public string GeoLongitude
    //    {
    //        get
    //        {
    //            return AddressObj.GeoLongitude;
    //        }
    //    }
    //    #endregion


    //    #region Account Properties
    //    public string UserName
    //    {
    //        get
    //        {
    //            return AccountObj.UserName;
    //        }
    //    }

    //    public string Password
    //    {
    //        get
    //        {
    //            return AccountObj.Password;
    //        }
    //    }

    //    public string FirstName
    //    {
    //        get
    //        {
    //            return AccountObj.FirstName;
    //        }
    //    }

    //    public string LastName
    //    {
    //        get
    //        {
    //            return AccountObj.LastName;
    //        }
    //    }

    //    public string Cookie
    //    {
    //        get
    //        {
    //            return AccountObj.Cookie;
    //        }
    //    }

    //    public string PhoneNumber
    //    {
    //        get
    //        {
    //            return AccountObj.PhoneNumber;
    //        }
    //    }

    //    public string Status
    //    {
    //        get
    //        {
    //            return AccountObj.Status;
    //        }
    //    }

        
    //    #endregion


    //    #region Methods

    //    public FileInfo[] GetImages(string imagesPath)
    //    {
    //        string[] units = new string[] { "byte", "kb", "mb", "gb", "tb" };
    //        string[] imageExtensions = new string[] { ".JPG", ".JPE", ".BMP", ".GIF", ".PNG" };
    //        string unit = "mb";
    //        int size = 4;

    //        Int64 convertedSize = size * new Func<int, int>(x =>
    //        {
    //            int i = 0;
    //            int returnMultuply = 1;
    //            while (i < x)
    //            {
    //                returnMultuply *= 1024;
    //                i++;
    //            }
    //            return returnMultuply;
    //        }).Invoke(units.Select((s, i) =>
    //        {
    //            if (s.ToLowerInvariant() == unit.ToLowerInvariant())
    //                return i;
    //            else
    //                return -1;
    //        }).FirstOrDefault(x => x != -1));

    //        FileInfo[] returnFileInfos = string.IsNullOrEmpty(imagesPath) ? null : imagesPath.Split(';').Select(s =>
    //        {
    //            bool invalid = false;
    //            FileInfo fi = new FileInfo(AutoPostAdConfig.Instance.ImageFilesPath+ s);
    //            if (fi.Exists)
    //            {
    //                if (!imageExtensions.Contains(fi.Extension.ToUpperInvariant()))
    //                    invalid = true;

    //                if (fi.Length >= convertedSize)
    //                    invalid = true;
    //            }
    //            else
    //            {
    //                invalid = true;
    //            }
    //            if (!invalid)
    //                return fi;
    //            else
    //                return null;
    //        }).ToArray();

    //        return returnFileInfos;
    //    }

    //    #endregion
    //}


    public partial class AutoPostAdPostDataBM : AutoPostAdPostData
    {
        private string _lastReturnAdID;
        private AutoPostAdPostData _originalData;
        public AutoPostAdPostDataBM(AutoPostAdPostData originalData)
        {
            ImagesList = new List<string>();
            BusinessLogoURL = "";
            _originalData = originalData;
        }

        public AutoPostAdPostData OriginalData
        {
            get { return _originalData; }
            set { _originalData = value; }
        }

        #region original object properties
        public int ID
        {
            get { return _originalData.ID; }
            set { _originalData.ID = value; }
        }
        public string SKU
        {
            get { return _originalData.SKU; }
            set { _originalData.SKU = value; }
        }
        public decimal Price
        {
            get { return _originalData.Price; }
            set { _originalData.Price = value; }
        }
        public string Title
        {
            get { return _originalData.Title; }
            set { _originalData.Title = value; }
        }
        public string Description
        {
            get { return _originalData.Description; }
            set { _originalData.Description = value; }
        }
        public string ImagesPath
        {
            get { return _originalData.ImagesPath; }
            set { _originalData.ImagesPath = value; }
        }
        public int CategoryID
        {
            get { return _originalData.CategoryID; }
            set { _originalData.CategoryID = value; }
        }
        public int InventoryQty
        {
            get { return _originalData.InventoryQty; }
            set { _originalData.InventoryQty = value; }
        }
        public int AddressID
        {
            get { return _originalData.AddressID; }
            set { _originalData.AddressID = value; }
        }
        public int AccountID
        {
            get { return _originalData.AccountID; }
            set { _originalData.AccountID = value; }
        }
        public int CustomFieldGroupID
        {
            get { return _originalData.CustomFieldGroupID; }
            set { _originalData.CustomFieldGroupID = value; }
        }
        public string BusinessLogoPath
        {
            get { return _originalData.BusinessLogoPath; }
            set { _originalData.BusinessLogoPath = value; }
        }
        public string CustomID
        {
            get { return _originalData.CustomID; }
            set { _originalData.CustomID = value; }
        }
        public string Status
        {
            get { return _originalData.Status; }
            set { _originalData.Status = value; }
        }
        public decimal Postage
        {
            get { return _originalData.Postage; }
            set { _originalData.Postage = value; }
        }
        public string Notes
        {
            get { return _originalData.Notes; }
            set { _originalData.Notes = value; }
        }
        public int AdTypeID
        {
            get { return _originalData.AdTypeID; }
            set { _originalData.AdTypeID = value; }
        }
        public int ScheduleRuleID
        {
            get { return _originalData.ScheduleRuleID; }
            set { _originalData.ScheduleRuleID = value; }
        }
        public ProductCategory ProductCategoryObj
        {
            get { return _originalData.ProductCategoryObj; }
            set { _originalData.ProductCategoryObj = value; }
        }
        public CustomFieldGroup CustomFieldGroupObj
        {
            get { return _originalData.CustomFieldGroupObj; }
            set { _originalData.CustomFieldGroupObj = value; }
        }
        public Address AddressObj
        {
            get { return _originalData.AddressObj; }
            set { _originalData.AddressObj = value; }
        }
        public Account AccountObj
        {
            get { return _originalData.AccountObj; }
            set { _originalData.AccountObj = value; }
        }
        public ScheduleRule ScheduleRuleObj
        {
            get { return _originalData.ScheduleRuleObj; }
            set { _originalData.ScheduleRuleObj = value; }
        }
        public ICollection<AutoPostAdResult> AutoPostAdResults
        {
            get { return _originalData.AutoPostAdResults; }
            set { _originalData.AutoPostAdResults = value; }
        }
        #endregion

        public bool Selected { get; set; }
        public string Result { get; set; }
        public string ResultMessage { get; set; }
        public string ReturnAdID { get; set; }
        public string WebsiteCategoryID
        {
            get
            {
                return _originalData.ProductCategoryObj.CategoryID;
            }
        }

        public string WebsiteCategoryName
        {
            get
            {
                return _originalData.ProductCategoryObj.CategoryName;
            }
        }

        public string WebsiteParentCategoryID
        {
            get
            {
                return _originalData.ProductCategoryObj.ParentCategoryID;
            }
        }

        public ICollection<string> ImagesList
        {
            get;
            set;
        }

        public string BusinessLogoURL
        {
            get;
            set;
        }

        public string LastReturnAdID
        {
            get
            {
                //if(_lastReturnAdID ==null)
                //{
                var lastReturnAdResult = _originalData.AutoPostAdResults.OrderByDescending(o => o.PostDate).FirstOrDefault();
                _lastReturnAdID = lastReturnAdResult == null ? "" : lastReturnAdResult.AdID;
                //}
                return _lastReturnAdID;
            }
        }

        public AutoPostAdResult LastReturnAdResult
        {
            get
            {
                return _originalData.AutoPostAdResults.OrderByDescending(o => o.PostDate).FirstOrDefault();
            }
        }

        public string VerificationCode { get; set; }
        public string Token { get; set; }
        public string CTK { get; set; }
        public string CSRFT { get; set; }

        #region Address Properties
        public string AddressName
        {
            get
            {
                return _originalData.AddressObj.AddressName;
            }
        }

        public string PostCode
        {
            get
            {
                return _originalData.AddressObj.PostCode;
            }
        }

        public string GeoLatitude
        {
            get
            {
                return _originalData.AddressObj.GeoLatitude;
            }
        }

        public string GeoLongitude
        {
            get
            {
                return _originalData.AddressObj.GeoLongitude;
            }
        }
        #endregion


        #region Account Properties
        public string UserName
        {
            get
            {
                return _originalData.AccountObj.UserName;
            }
        }

        public string Password
        {
            get
            {
                return _originalData.AccountObj.Password;
            }
        }

        public string FirstName
        {
            get
            {
                return _originalData.AccountObj.FirstName;
            }
        }

        public string LastName
        {
            get
            {
                return _originalData.AccountObj.LastName;
            }
        }

        public string Cookie
        {
            get
            {
                return _originalData.AccountObj.Cookie;
            }
        }

        public string PhoneNumber
        {
            get
            {
                return _originalData.AccountObj.PhoneNumber;
            }
        }

        public string AccountStatus
        {
            get
            {
                return _originalData.AccountObj.Status;
            }
        }


        #endregion


        #region Methods

        public FileInfo[] GetImages(string imagesPath)
        {
            string[] units = new string[] { "byte", "kb", "mb", "gb", "tb" };
            string[] imageExtensions = new string[] { ".JPG", ".JPE", ".BMP", ".GIF", ".PNG" };
            string unit = "mb";
            int size = 4;

            Int64 convertedSize = size * new Func<int, int>(x =>
            {
                int i = 0;
                int returnMultuply = 1;
                while (i < x)
                {
                    returnMultuply *= 1024;
                    i++;
                }
                return returnMultuply;
            }).Invoke(units.Select((s, i) =>
            {
                if (s.ToLowerInvariant() == unit.ToLowerInvariant())
                    return i;
                else
                    return -1;
            }).FirstOrDefault(x => x != -1));

            FileInfo[] returnFileInfos = string.IsNullOrEmpty(imagesPath) ? null : imagesPath.Split(';').Select(s =>
            {
                bool invalid = false;
                FileInfo fi = new FileInfo(AutoPostAdConfig.Instance.ImageFilesPath + s);
                if (fi.Exists)
                {
                    if (!imageExtensions.Contains(fi.Extension.ToUpperInvariant()))
                        invalid = true;

                    if (fi.Length >= convertedSize)
                        invalid = true;
                }
                else
                {
                    invalid = true;
                }
                if (!invalid)
                    return fi;
                else
                    return null;
            }).ToArray();

            return returnFileInfos;
        }

        #endregion
    }

    public class MyAdPageAd
    {
        public string Title { get; set; }
        public string AdID { get; set; }
        public string Price { get; set; }
        public string Category { get; set; }
        public string PostDate { get; set; }
        public string ExpiredDate { get; set; }
        public string Visits { get; set; }
        public string Replies { get; set; }
        public string OnPage { get; set; }
    }
}
