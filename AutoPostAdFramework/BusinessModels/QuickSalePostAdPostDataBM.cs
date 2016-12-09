using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using Common.Models.XML;
using Common;

namespace AutoPostAdBusiness.BusinessModels
{
    public class QuickSalePostAdPostDataBM : AutoPostAdPostData
    {
        #region Properties
        public string Result { get; set; }
        public string ResultMessage { get; set; }
        public string ReturnAdID { get; set; }
        public bool Selected { get; set; }

        public string LastReturnAdID
        {
            get
            {
                var lastReturnAdResult = AutoPostAdResults.OrderByDescending(o => o.PostDate).FirstOrDefault();
                _lastReturnAdID = lastReturnAdResult == null ? "" : lastReturnAdResult.AdID;
                return _lastReturnAdID;
            }
        }

        public AutoPostAdResult LastReturnAdResult
        {
            get
            {
                return AutoPostAdResults.FirstOrDefault();
            }
        }
        private string _lastReturnAdID;

        public int Category
        {
            get
            {
                return Convert.ToInt32( ProductCategoryObj.CategoryID);
            }
        }

        public string CategoryTypeID
        {
            get
            {
                string categoryType = "";
                switch (ProductCategoryObj.CategoryTypeID)
                { 
                    case CategoryType.Gumtree:
                        categoryType="Gumtree";
                        break;
                    case CategoryType.eBay:
                        categoryType = "eBay";
                        break;
                    case CategoryType.QuickSales:
                        categoryType = "QuickSales";
                        break;
                    default :
                        categoryType = "Gumtree";
                        break;
                }
                return categoryType;
            }
        }

        public string OptionalReference1
        {
            get
            {
                return SKU;
            }
        }

        public DateTime StartTime
        {
            get
            {
                return DateTime.Now;
            }
        }

        public int Duration
        {
            get
            {
                //Todo {Valid values are: 3, 5, 7, 10, 14 and 45} (45 for classified style listings only)
                return 14;
            }
        }

        public decimal BuyNowPrice
        {
            get
            {
                return Price;
            }
        }

        public bool ListAsClassifiedAd
        {
            get 
            {
                //Todo Customize field Possible values: {1 = Yes, 0 = No}
                return false ;
            }
        }

        public int Quantity
        {
            get 
            {
                //Todo Customize field
                return InventoryQty;
            }
        }

        public bool BrandNew
        {
            get 
            {
                return true;
            }
        }

        public int AutoRelistType
        {
            get
            {
                //Todo Customize field {Auto-Relist Until Sold = 1 (Deprecated), Auto-Relist = 2, Do Not Auto-Relist = 3}
                return 2;
            }
        }

        #region Payment Method

        public ICollection<string> PaymentMethods
        {
            get 
            {
                //Todo Customize field {BankCheque,BankDeposit,Cash,COD,CreditCard,Escrow,MoneyOrder,Paymate,PayPal,PersonalCheque,Other,ProvideBankDetailsToBuyer}
                return new List<string>() { "PayPal", "BankDeposit" };
            }
        }

        #endregion

        #region Postage Type

        public int PostageType
        {
            get 
            {
                //Postage type of the listing
                //{Valid values are 1, 2, 3, 4, 5, 6 or 7}
                //Free postage = 1
                //Flat postage = 2
                //Flat postage by location = 3
                //Calculated postage = 4
                //See item description = 5
                //No postage - local pickup only = 6
                //Temando = 7
                return 2;
            }
        }

        public decimal FixedPostage
        {
            get { return Convert.ToDecimal( Postage); }
        }

        public ICollection<string> PostToLocations
        {
            get
            {
                //Todo Customize field {BankCheque,BankDeposit,Cash,COD,CreditCard,Escrow,MoneyOrder,Paymate,PayPal,PersonalCheque,Other,ProvideBankDetailsToBuyer}
                return new List<string>() { "National" };
            }
        }

        #endregion

        public ICollection<string> Pics
        {
            get 
            {
                var pics=new List<string>();
                if (!string.IsNullOrEmpty(ImagesPath))
                    pics.AddRange(ImagesPath.Split(';'));
                return pics;
            }
        }

        #endregion


        public CreateItemRequest FillObjectIntoCreateItemRequest()
        {
            var request = new CreateItemRequest();

            var item = new CreateItemRequestItem();
            //item.SellerID = "jim0519";
            //item.SellerPwd = "Shishiliu-0310";
            item.Title = this.Title;
            if(this.ProductCategoryObj.CategoryTypeID==CategoryType.QuickSales)//QS Category
                item.Category = this.Category.ToString();
            else if (this.ProductCategoryObj.CategoryTypeID == CategoryType.eBay)
                item.eBayCategory = this.Category.ToString();
            item.OptionalReference1 = this.OptionalReference1;
            item.StartTime = this.StartTime.ToString("dd/MM/yyyy HH:mm:ss");
            item.Duration = this.Duration.ToString();
            item.BuyNowPrice = this.BuyNowPrice.ToString();
            item.Description = this.Description;
            item.ListAsClassifiedAd = this.ListAsClassifiedAd.ToIntString();
            item.Quantity = this.Quantity.ToString();
            item.BrandNew = this.BrandNew.ToIntString();
            item.AutoRelistFeatures = new CreateItemRequestItemAutoRelistFeatures() { AutoRelistType=this.AutoRelistType.ToString() };
            //Location
            item.Suburb = AutoPostAdConfig.Instance.QuickSaleLocSuburb;
            item.Postcode = AutoPostAdConfig.Instance.QuickSaleLocPostcode;
            item.State = AutoPostAdConfig.Instance.QuickSaleLocState;

            var paymentMethods = new CreateItemRequestItemPaymentMethods();
            this.PaymentMethods.ToList().ForEach(x => 
            {
                paymentMethods.GetType().GetProperty(x).SetValue(paymentMethods, true.ToIntString());
            });
            item.PaymentMethods = paymentMethods;

            var postage = new CreateItemRequestItemPostage();
            postage.Type = this.PostageType.ToString();
            postage.FixedPostage = FixedPostage.ToString();
            item.Postage = postage;

            var postToLocation = new CreateItemRequestItemPostToLocation(); 
            this.PostToLocations.ToList().ForEach(x =>
            {
                postToLocation.GetType().GetProperty(x).SetValue(postToLocation, true.ToIntString());
            });
            item.PostToLocation = postToLocation;

            int i=1;
            this.Pics.ToList().ForEach(x => 
            {
                var propInfo=item.GetType().GetProperty("Pic" + i);
                if (propInfo != null)
                {
                    propInfo.SetValue(item,x);
                }
                i++;
            });

            request.Item = item;
            
            return request;
        }

        public ReviseItemRequest RelistReviseItemRequest()
        {
            var request = new ReviseItemRequest();
             
            var item = new ReviseItemRequestItem();
            item.ListingID = this.LastReturnAdID;
            request.Item = item;

            request.RelistItem = QuickSaleRelistMode.AutoRelistOn.ToString();
            return request;
        }

        public ReviseItemRequest ReviseInfoReviseItemRequest()
        {
            var request = new ReviseItemRequest();

            var item = new ReviseItemRequestItem();
            item.ListingID = this.LastReturnAdID;

            item.Title = this.Title;
            item.Description = this.Description;
            item.BuyNowPrice = this.BuyNowPrice.ToString();
            item.Quantity = this.Quantity.ToString();
            

            var postage = new ReviseItemRequestItemPostage();
            postage.Type = this.PostageType.ToString();
            postage.FixedPostage = FixedPostage.ToString();
            item.Postage = postage;

            request.Item = item;

            return request;
        }

        public ReviseItemRequest DeleteReviseItemRequest()
        {
            var request = new ReviseItemRequest();
            request.EndItem = true.ToIntString();

            var item = new ReviseItemRequestItem();
            item.ListingID = this.LastReturnAdID;

            request.Item = item;

            return request;
        }
    }

    public class ProductImage
    {
        public string SKU { get; set; }
        public string ImagesPath { get; set; }
    }
}
