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
    public partial class AutoPostAdPostDataBM : AutoPostAdPostData
    {
        private string _lastReturnAdID;
        public AutoPostAdPostDataBM()
        {
            ImagesList = new List<string>();
            BusinessLogoURL = "";
        }

        public bool Selected { get; set; }
        public string Result { get; set; }
        public string ResultMessage { get; set; }
        public string ReturnAdID { get; set; }
        public string WebsiteCategoryID
        {
            get 
            {
                return ProductCategoryObj.CategoryID;
            }
        }

        public string WebsiteCategoryName
        {
            get
            {
                return ProductCategoryObj.CategoryName;
            }
        }

        public string WebsiteParentCategoryID
        {
            get
            {
                return ProductCategoryObj.ParentCategoryID;
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
                    var lastReturnAdResult=AutoPostAdResults.OrderByDescending(o=>o.PostDate).FirstOrDefault();
                    _lastReturnAdID = lastReturnAdResult == null ? "" : lastReturnAdResult.AdID;
                //}
                return _lastReturnAdID;
            }
        }

        public AutoPostAdResult LastReturnAdResult
        {
            get
            {
                return AutoPostAdResults.OrderByDescending(o => o.PostDate).FirstOrDefault();
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
                return AddressObj.AddressName;
            }
        }

        public string PostCode
        {
            get
            {
                return AddressObj.PostCode;
            }
        }

        public string GeoLatitude
        {
            get
            {
                return AddressObj.GeoLatitude;
            }
        }

        public string GeoLongitude
        {
            get
            {
                return AddressObj.GeoLongitude;
            }
        }
        #endregion


        #region Account Properties
        public string UserName
        {
            get
            {
                return AccountObj.UserName;
            }
        }

        public string Password
        {
            get
            {
                return AccountObj.Password;
            }
        }

        public string FirstName
        {
            get
            {
                return AccountObj.FirstName;
            }
        }

        public string LastName
        {
            get
            {
                return AccountObj.LastName;
            }
        }

        public string Cookie
        {
            get
            {
                return AccountObj.Cookie;
            }
        }

        public string PhoneNumber
        {
            get
            {
                return AccountObj.PhoneNumber;
            }
        }

        public string Status
        {
            get
            {
                return AccountObj.Status;
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
                FileInfo fi = new FileInfo(AutoPostAdConfig.Instance.ImageFilesPath+ s);
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
}
