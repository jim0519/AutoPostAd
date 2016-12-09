using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public sealed class ResultType
    {
        public const string Error = "Error";
        public const string Success = "Success";
    }

    public sealed class GumtreeURL
    {
        public const string SelectCategory = "http://www.gumtree.com.au/p-post-ad.html";
        public const string AdForm = "http://www.gumtree.com.au/p-post-ad2.html?parentCategoryId={0}&categoryId={1}&adType=OFFER";
        public const string VerificationImage = "http://www.gumtree.com.au/bb-image.html";
        public const string UploadImage = "http://www.gumtree.com.au/p-upload-image.html";
        public const string SubmitAd = "http://www.gumtree.com.au/p-submit-ad.html";
        public const string MyAd = "http://www.gumtree.com.au/m-my-ads.html";
        public const string DeleteAd = "http://www.gumtree.com.au/m-delete-ad.html?adId={0}&show=ACTIVE&reason=";
        public const string Login = "https://www.gumtree.com.au/t-login.html";
        public const string LoginForm = "https://www.gumtree.com.au/t-login-form.html";
        public const string HomePage = "https://www.gumtree.com.au";
    }

    public sealed class TemplateFieldType
    {
        public const int AttributeMap = 1;
        public const int ImageList = 2;
        public const int Config = 3;
    }

    public sealed class QuickSaleRelistMode
    {
        public const int AutoRelistOn= 1;
        public const int AutoRelistOff = 2;
    }

    public sealed class CategoryType
    {
        public const int Gumtree = 1;
        public const int eBay = 2;
        public const int QuickSales = 3;
        public const int DropshipZone = 4;
    }

    public sealed class ChannelType
    {
        public const int Gumtree = 1;
        public const int eBayCrazyVictor = 2;
        public const int QuickSales = 3;
        public const int DropshipZone = 4;
        public const int eBayOZPlaza = 5;
        public const int GumtreeSydney = 6;
        public const int QuickSalesSydney = 7;
        public const int eBayCrazyMall = 8;
        public const int GumtreeNopcommerce = 9;
    }

    public sealed class Status
    {
        public const string Active = "A";
        public const string Deleted = "D";
    }

    public sealed class AdType
    {
        public const string Melbourne = "Melbourne";
        public const string Sydney = "Sydney";
        public const string Brisbane = "Brisbane";
    }

    public enum ComponentLifeStyle
    {
        Singleton = 0,
        Transient = 1,
        LifetimeScope = 2
    }

    public sealed class ECMShippingPolicy
    {
        public const string FreeShipping= "F";
        public const string BulkyItemFreeShipping = "BF";
        public const string Freight = "FR";
    }
}
