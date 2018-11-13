using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eBay.Service.Call;
using eBay.Service.Core.Sdk;
using Common;
using Common.Models;
using eBay.Service.Core.Soap;
using AutoPostAdBusiness.Services;
using AutoPostAdBusiness.DropshipSOAP;
using System.Net;
using System.IO;
using HtmlAgilityPack;
using LINQtoCSV;
using AutoPostAdBusiness.BusinessModels;
using Common.Infrastructure;
using System.Drawing;
using System.Drawing.Imaging;
using System.Management;
using System.Threading;
using System.Net.NetworkInformation;
using System.Text.RegularExpressions;

namespace AutoPostAdBusiness.Handlers
{
    public class DropshipController
    {
        private readonly GetSellerListCall _getSellerListCall;
        private readonly GetMyeBaySellingCall _myeBaySellingCall;
        private readonly GetItemCall _getItemCall;
        private readonly ReviseFixedPriceItemCall _reviseFixedPriceItemCall;
        private readonly IAutoPostAdPostDataService _autoPostAdPostDataService;
        private readonly MagentoService _magentoService;
        private readonly ICacheManager _cacheManager;
        private readonly CsvContext _csvContext;
        private readonly CsvFileDescription _csvFileDescription;
        private readonly au.com.batteryexpert.MagentoService _batteryexpertService;
        public DropshipController(IAutoPostAdPostDataService autoPostAdPostDataService,
            ICacheManager cacheManager)
        {
            _autoPostAdPostDataService = autoPostAdPostDataService;
            _cacheManager = cacheManager;

            _myeBaySellingCall = new GetMyeBaySellingCall(AutoPostAdConfig.Instance.eBayAPIContext);
            
            _myeBaySellingCall.ActiveList = new ItemListCustomizationType();
            _myeBaySellingCall.ActiveList.ListingType = ListingTypeCodeType.FixedPriceItem;
            _myeBaySellingCall.ActiveList.Sort = ItemSortTypeCodeType.ItemID;

            _myeBaySellingCall.ScheduledList = new ItemListCustomizationType();

            _myeBaySellingCall.UnsoldList = new ItemListCustomizationType();
            _myeBaySellingCall.UnsoldList.Sort = ItemSortTypeCodeType.ItemID;

            _myeBaySellingCall.SoldList = new ItemListCustomizationType();


            _myeBaySellingCall.ActiveList.Include = false;
            _myeBaySellingCall.ScheduledList.Include = false;
            _myeBaySellingCall.UnsoldList.Include = false;
            _myeBaySellingCall.SoldList.Include = false;

            _myeBaySellingCall.DetailLevelList = new DetailLevelCodeTypeCollection();
            _myeBaySellingCall.DetailLevelList.Add(DetailLevelCodeType.ReturnAll);


            _getItemCall = new GetItemCall(AutoPostAdConfig.Instance.eBayAPIContext);
            _getItemCall.DetailLevelList.Add(DetailLevelCodeType.ItemReturnDescription);

            _reviseFixedPriceItemCall = new ReviseFixedPriceItemCall(AutoPostAdConfig.Instance.eBayAPIContext);

            _getSellerListCall= new GetSellerListCall(AutoPostAdConfig.Instance.eBayAPIContext);

            _magentoService = new MagentoService();
            _batteryexpertService = new au.com.batteryexpert.MagentoService();

            //Linq to CSV
            _csvContext = new CsvContext();
            _csvFileDescription = new CsvFileDescription() { SeparatorChar = ',', FirstLineHasColumnNames = true, IgnoreUnknownColumns = true, TextEncoding = Encoding.Default };

        }

        #region Public Method
        public bool GetActiveListing()
        {
            try
            {
                int pageNum = 1;
                int totalPage = 1;
                PaginationType pageInfo = new PaginationType();
                pageInfo.PageNumber = pageNum;
                pageInfo.EntriesPerPage = 60;
                _myeBaySellingCall.ActiveList.Pagination = pageInfo;

                _myeBaySellingCall.ActiveList.Include = true;
                _myeBaySellingCall.ScheduledList.Include = false;
                _myeBaySellingCall.UnsoldList.Include = false;
                _myeBaySellingCall.SoldList.Include = false;

                _myeBaySellingCall.GetMyeBaySelling();

                if (_myeBaySellingCall.ActiveListReturn != null && _myeBaySellingCall.ActiveListReturn.PaginationResult != null)
                {
                    totalPage = _myeBaySellingCall.ActiveListReturn.PaginationResult.TotalNumberOfPages;
                }

                for (int i = 1; i <= totalPage; i++)
                {
                    if (i != 1)
                    {
                        pageInfo.PageNumber = i;
                        pageInfo.EntriesPerPage = 60;
                        _myeBaySellingCall.ActiveList.Pagination = pageInfo;
                        _myeBaySellingCall.GetMyeBaySelling();
                    }

                    if (_myeBaySellingCall.ActiveListReturn != null &&
                            _myeBaySellingCall.ActiveListReturn.ItemArray != null &&
                            _myeBaySellingCall.ActiveListReturn.ItemArray.Count > 0)
                    {
                        foreach (ItemType actitem in _myeBaySellingCall.ActiveListReturn.ItemArray)
                        {
                            //IList<string> returnValue = new List<string>();
                            //returnValue.Add(actitem.ItemID);
                            //returnValue.Add( actitem.Title);
                            //if (actitem.SellingStatus != null)
                            //{
                            //    returnValue.Add(actitem.SellingStatus.CurrentPrice.Value.ToString());
                            //    returnValue.Add(actitem.SellingStatus.BidCount.ToString());
                            //    returnValue.Add(actitem.ListingDetails.EndTime.ToString());
                            //}

                            try
                            {

                                var item = _getItemCall.GetItem(actitem.ItemID);
                                if(item != null)
                                { 
                                    AutoPostAdPostData ad = null;
                                    var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID(actitem.SKU, Common.ChannelType.eBayCrazyMall);
                                    if (existingAd != null)
                                    {
                                        ad = existingAd;
                                        ad.Title = item.Title;
                                        ad.Description = (string.IsNullOrEmpty( item.Description)?string.Empty:item.Description);
                                        ad.CustomID = item.ItemID;
                                        if (item.SellingStatus != null)
                                        {
                                            ad.Price = (item.SellingStatus.CurrentPrice != null ? Convert.ToDecimal(item.SellingStatus.CurrentPrice.Value) : 0);
                                            ad.InventoryQty = item.Quantity - item.SellingStatus.QuantitySold;
                                        }
                                        var productCategory = _autoPostAdPostDataService.GetProductCategory(item.PrimaryCategory.CategoryID, Common.CategoryType.eBay);
                                        if (productCategory != null)
                                            ad.CategoryID = productCategory.ID;

                                        if (item.PictureDetails.PictureURL.Count > 0)
                                        {
                                            var imagesPath = "";
                                            foreach (var picURL in item.PictureDetails.PictureURL)
                                            {
                                                imagesPath += picURL + ";";
                                            }
                                            ad.ImagesPath = imagesPath.TrimEnd(';');
                                        }
                                        else
                                        {
                                            ad.ImagesPath = string.Empty;
                                        }

                                        if (item.ShippingDetails != null && item.ShippingDetails.ShippingServiceOptions != null)
                                        {
                                            var shippingServiceOption = item.ShippingDetails.ShippingServiceOptions.ToArray().FirstOrDefault();
                                            if (shippingServiceOption != null)
                                            {
                                                ad.Postage = (shippingServiceOption.ShippingServiceCost != null ? Convert.ToDecimal(shippingServiceOption.ShippingServiceCost.Value) : -1);
                                                ad.Notes = shippingServiceOption.ShippingService;
                                            }
                                            else
                                            {
                                                ad.Postage = -1;
                                            }
                                        }


                                        ad.BusinessLogoPath = item.ListingType.ToString();
                                        ad.Status = Status.Active;

                                        _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                                    }
                                    else
                                    {
                                    
                                        ad = new AutoPostAdPostData();
                                        ad.AdTypeID = Common.ChannelType.eBayCrazyMall;
                                        ad.SKU = (item.SKU == null ? string.Empty : item.SKU);
                                        ad.CustomID = item.ItemID;
                                        ad.Title = item.Title;
                                        ad.Description = (string.IsNullOrEmpty(item.Description) ? string.Empty : item.Description);
                                        if (item.SellingStatus != null)
                                        {
                                            ad.Price = (item.SellingStatus.CurrentPrice != null ? Convert.ToDecimal(item.SellingStatus.CurrentPrice.Value) : 0);
                                            ad.InventoryQty = item.Quantity - item.SellingStatus.QuantitySold;
                                        }
                                        var productCategory = _autoPostAdPostDataService.GetProductCategory(item.PrimaryCategory.CategoryID, Common.CategoryType.eBay);
                                        if (productCategory != null)
                                            ad.CategoryID = productCategory.ID;

                                        if (item.PictureDetails.PictureURL.Count > 0)
                                        {
                                            var imagesPath = "";
                                            foreach (var picURL in item.PictureDetails.PictureURL)
                                            {
                                                imagesPath += picURL + ";";
                                            }
                                            ad.ImagesPath = imagesPath.TrimEnd(';');
                                        }
                                        else
                                        {
                                            ad.ImagesPath = string.Empty;
                                        }

                                        if (item.ShippingDetails != null && item.ShippingDetails.ShippingServiceOptions != null)
                                        {
                                            var shippingServiceOption = item.ShippingDetails.ShippingServiceOptions.ToArray().FirstOrDefault();
                                            if (shippingServiceOption != null)
                                            {
                                                ad.Postage = (shippingServiceOption.ShippingServiceCost != null ? Convert.ToDecimal(shippingServiceOption.ShippingServiceCost.Value) : -1);
                                                ad.Notes = shippingServiceOption.ShippingService;
                                            }
                                            else
                                            {
                                                ad.Postage = -1;
                                            }
                                        }

                                        ad.Status = Status.Active;
                                        ad.AddressID = 1;
                                        ad.AccountID = 1;
                                        ad.CustomFieldGroupID = 1;
                                        ad.BusinessLogoPath = item.ListingType.ToString();
                                        ad.ScheduleRuleID = 1;

                                        if (string.IsNullOrEmpty(ad.Notes))
                                            ad.Notes = string.Empty;

                                        _autoPostAdPostDataService.InsertAutoPostAdPostData(ad);
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                LogManager.Instance.Error(ex.ToString());
                            }
                        }
                    }


                }
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public bool GetUnsoldList()
        {
            try
            {
                int pageNum = 1;
                int totalPage = 1;
                PaginationType pageInfo = new PaginationType();
                pageInfo.PageNumber = pageNum;
                pageInfo.EntriesPerPage = 60;
                _myeBaySellingCall.UnsoldList.Pagination = pageInfo;

                _myeBaySellingCall.ActiveList.Include = false;
                _myeBaySellingCall.ScheduledList.Include = false;
                _myeBaySellingCall.UnsoldList.Include = true;
                _myeBaySellingCall.SoldList.Include = false;

                _myeBaySellingCall.GetMyeBaySelling();

                if (_myeBaySellingCall.UnsoldListReturn != null && _myeBaySellingCall.UnsoldListReturn.PaginationResult != null)
                {
                    totalPage = _myeBaySellingCall.UnsoldListReturn.PaginationResult.TotalNumberOfPages;
                }

                for (int i = 1; i <= totalPage; i++)
                {
                    if (i != 1)
                    {
                        pageInfo.PageNumber = i;
                        pageInfo.EntriesPerPage = 60;
                        _myeBaySellingCall.UnsoldList.Pagination = pageInfo;
                        _myeBaySellingCall.GetMyeBaySelling();
                    }

                    if (_myeBaySellingCall.UnsoldListReturn != null &&
                            _myeBaySellingCall.UnsoldListReturn.ItemArray != null &&
                            _myeBaySellingCall.UnsoldListReturn.ItemArray.Count > 0)
                    {
                        foreach (ItemType unsolditem in _myeBaySellingCall.UnsoldListReturn.ItemArray)
                        {
                            try
                            {
                                ItemType item = _getItemCall.GetItem(unsolditem.ItemID);
                                if(item!=null)
                                { 
                                    AutoPostAdPostData ad = null;
                                    var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataByCustomIDAdTypeID(unsolditem.ItemID, Common.ChannelType.eBayOZPlaza);
                                    if (existingAd != null)
                                    {
                                        ad = existingAd;
                                        ad.Title = item.Title;
                                        ad.Description = (string.IsNullOrEmpty(item.Description) ? string.Empty : item.Description);
                                        if (item.SellingStatus != null)
                                        {
                                            ad.Price = (item.SellingStatus.ConvertedCurrentPrice != null ? Convert.ToDecimal(item.SellingStatus.ConvertedCurrentPrice.Value) : 0);
                                            ad.InventoryQty = item.Quantity - item.SellingStatus.QuantitySold;
                                        }
                                        var productCategory = _autoPostAdPostDataService.GetProductCategory(item.PrimaryCategory.CategoryID, Common.CategoryType.eBay);
                                        if (productCategory != null)
                                            ad.CategoryID = productCategory.ID;

                                        if (item.PictureDetails.PictureURL.Count > 0)
                                        {
                                            var imagesPath = "";
                                            foreach (var picURL in item.PictureDetails.PictureURL)
                                            {
                                                imagesPath += picURL + ";";
                                            }
                                            ad.ImagesPath = imagesPath.TrimEnd(';');
                                        }
                                        else
                                        {
                                            ad.ImagesPath = string.Empty;
                                        }

                                        if (item.ShippingDetails != null&&item.ShippingDetails.ShippingServiceOptions!=null)
                                        {
                                            var shippingServiceOption = item.ShippingDetails.ShippingServiceOptions.ToArray().FirstOrDefault();
                                            if (shippingServiceOption != null)
                                            {
                                                ad.Postage = (shippingServiceOption.ShippingServiceCost != null ? Convert.ToDecimal(shippingServiceOption.ShippingServiceCost.Value) : -1);
                                                ad.Notes = shippingServiceOption.ShippingService;
                                            }
                                            else
                                            {
                                                ad.Postage = -1;
                                            }
                                        }

                                        ad.Status = Status.Deleted;
                                        ad.BusinessLogoPath = item.ListingType.ToString();

                                        _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                                    }
                                    else
                                    {
                                        ad = new AutoPostAdPostData();
                                        ad.AdTypeID = Common.ChannelType.eBayOZPlaza;
                                        ad.SKU = (item.SKU == null ? string.Empty : item.SKU);
                                        ad.CustomID = item.ItemID;
                                        ad.Title = item.Title;
                                        ad.Description = (string.IsNullOrEmpty(item.Description) ? string.Empty : item.Description);
                                        if (item.SellingStatus != null)
                                        {
                                            ad.Price = (item.SellingStatus.ConvertedCurrentPrice != null ? Convert.ToDecimal(item.SellingStatus.ConvertedCurrentPrice.Value) : 0);
                                            ad.InventoryQty = item.Quantity - item.SellingStatus.QuantitySold;
                                        }
                                        var productCategory = _autoPostAdPostDataService.GetProductCategory(item.PrimaryCategory.CategoryID, Common.CategoryType.eBay);
                                        if (productCategory != null)
                                            ad.CategoryID = productCategory.ID;

                                        if (item.PictureDetails.PictureURL.Count > 0)
                                        {
                                            var imagesPath = "";
                                            foreach (var picURL in item.PictureDetails.PictureURL)
                                            {
                                                imagesPath += picURL + ";";
                                            }
                                            ad.ImagesPath = imagesPath.TrimEnd(';');
                                        }
                                        else
                                        {
                                            ad.ImagesPath = string.Empty;
                                        }

                                        if (item.ShippingDetails != null && item.ShippingDetails.ShippingServiceOptions != null)
                                        {
                                            var shippingServiceOption = item.ShippingDetails.ShippingServiceOptions.ToArray().FirstOrDefault();
                                            if (shippingServiceOption != null)
                                            {
                                                ad.Postage = (shippingServiceOption.ShippingServiceCost != null ? Convert.ToDecimal(shippingServiceOption.ShippingServiceCost.Value) : -1);
                                                ad.Notes = shippingServiceOption.ShippingService;
                                            }
                                            else
                                            {
                                                ad.Postage = -1;
                                            }
                                        }

                                        ad.Status = Status.Deleted;
                                        ad.AddressID = 1;
                                        ad.AccountID = 1;
                                        ad.CustomFieldGroupID = 1;
                                        ad.BusinessLogoPath = item.ListingType.ToString();

                                        if (string.IsNullOrEmpty(ad.Notes))
                                            ad.Notes = string.Empty;


                                        _autoPostAdPostDataService.InsertAutoPostAdPostData(ad);
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                LogManager.Instance.Error(ex.ToString());
                            }
                        }
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public bool GetDropshipzoneInfo(bool onlyUpdateInventory=false)
        {
            //var sessionID = _magentoService.login("JimTestSOAPUser", "abc.123");
            var sessionID = _magentoService.login("NewAim", "abc.123");
            try
            {

                var paraFilters = new filters();
                //paraFilters.filter = new associativeEntity[1];
                var lstFilters = new List<associativeEntity>();
                //lstFilters.Add(new associativeEntity() { key = "sku", value = "SCALE-BFAT-WH" });
                paraFilters.filter = lstFilters.ToArray();

                var activeProducts = _magentoService.catalogProductList(sessionID, paraFilters, string.Empty);

                if (!onlyUpdateInventory)
                {
                    //get price list from csv
                    var dropshipzoneGroupPriceList = new List<DropshipzoneGroupPrice>();
                    if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath))
                    {
                        dropshipzoneGroupPriceList = _csvContext.Read<DropshipzoneGroupPrice>(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath, _csvFileDescription).ToList();
                    }

                    //get postage list from csv
                    var dropshipzonePostageList = new List<DropshipzonePostage>();
                    if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath))
                    {
                        dropshipzonePostageList = _csvContext.Read<DropshipzonePostage>(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath, _csvFileDescription).ToList();
                    }



                    foreach (var product in activeProducts)
                    {
                        catalogProductRequestAttributes customAttributes = new catalogProductRequestAttributes();
                        customAttributes.additional_attributes = new string[4] { "rs_fare", "inf_promotions", "group_price", "large_product" };
                        var productInfo = _magentoService.catalogProductInfo(sessionID, product.product_id, string.Empty, customAttributes, string.Empty);

                        if (productInfo != null)
                        {
                            AutoPostAdPostData ad = null;
                            var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID(productInfo.sku, Common.ChannelType.DropshipZone);
                            //get price from csv
                            decimal dropshipzonePrice = -1;
                            if (dropshipzoneGroupPriceList.Count > 0)
                            {
                                var groupPrice = dropshipzoneGroupPriceList.Where(p => p.Sku.ToLower().Equals(productInfo.sku.ToLower())).FirstOrDefault();
                                if (groupPrice != null && !string.IsNullOrEmpty(groupPrice.Standard))
                                {
                                    dropshipzonePrice = Convert.ToDecimal(groupPrice.Standard);
                                }

                            }
                            else
                            {
                                dropshipzonePrice = Convert.ToDecimal(productInfo.price);
                            }
                            //get postage from csv
                            decimal dropshipzonePostage = -1;
                            if (dropshipzonePostageList.Count > 0)
                            {
                                var dropshipzonePostageRow = dropshipzonePostageList.Where(p => p.Sku.ToLower().Equals(productInfo.sku.ToLower()) && p.Group.Equals("Standard")).FirstOrDefault();
                                if (dropshipzonePostageRow != null)
                                {
                                    var pArr = new string[] { dropshipzonePostageRow.VIC, dropshipzonePostageRow.NSW, dropshipzonePostageRow.QLD, dropshipzonePostageRow.SA, dropshipzonePostageRow.TAS, dropshipzonePostageRow.WA, dropshipzonePostageRow.NT };
                                    dropshipzonePostage = pArr.Select(p => Convert.ToDecimal(p)).Max();
                                }
                            }

                            if (existingAd != null)
                            {
                                ad = existingAd;
                                ad.Title = productInfo.name;
                                ad.Status = (productInfo.status.Equals("1") && dropshipzonePrice != -1 ? "1" : "2");
                                ad.Description = productInfo.description;
                                ad.Price = dropshipzonePrice;

                                var postage = productInfo.additional_attributes.FirstOrDefault(a => a.key == "rs_fare");
                                var isFreeShipping = productInfo.additional_attributes.FirstOrDefault(a => a.key == "inf_promotions");
                                var isBulkyItem = productInfo.additional_attributes.FirstOrDefault(a => a.key == "large_product");
                                if (dropshipzonePostage == -1 || dropshipzonePostage == 0)
                                {
                                    if (postage != null)
                                    {
                                        ad.Postage = Convert.ToDecimal(postage.value);
                                    }
                                }
                                else
                                {
                                    ad.Postage = dropshipzonePostage;
                                }
                                ad.Notes = (dropshipzonePostage == 0 ? "FreeShipping" : string.Empty);
                                if (isBulkyItem != null)
                                {
                                    ad.CategoryID = (isBulkyItem.value == "1" ? 1: 0);
                                }
                                if (productInfo.category_ids != null && productInfo.category_ids.Count()>0)
                                    ad.BusinessLogoPath = productInfo.category_ids.Aggregate((current, next) => current + "," + next);

                                _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                            }
                            else
                            {
                                ad = new AutoPostAdPostData();

                                ad.SKU = productInfo.sku;
                                ad.AdTypeID = Common.ChannelType.DropshipZone;
                                ad.Title = productInfo.name;
                                ad.CustomID = productInfo.product_id;
                                ad.Status = (productInfo.status.Equals("1") && dropshipzonePrice != -1 ? "1" : "2");
                                ad.Description = productInfo.description;


                                ad.Price = dropshipzonePrice;
                                var postage = productInfo.additional_attributes.FirstOrDefault(a => a.key == "rs_fare");
                                var isFreeShipping = productInfo.additional_attributes.FirstOrDefault(a => a.key == "inf_promotions");
                                var isBulkyItem = productInfo.additional_attributes.FirstOrDefault(a => a.key == "large_product");
                                if (dropshipzonePostage == -1 || dropshipzonePostage == 0)
                                {
                                    if (postage != null)
                                    {
                                        ad.Postage = Convert.ToDecimal(postage.value);
                                    }
                                }
                                else
                                {
                                    ad.Postage = dropshipzonePostage;
                                }
                                ad.Notes = (dropshipzonePostage == 0 ? "FreeShipping" : string.Empty);
                                if (isBulkyItem != null)
                                {
                                    ad.CategoryID = (isBulkyItem.value == "1" ? 1 : 0);
                                }

                                if (productInfo.category_ids != null && productInfo.category_ids.Count() > 0)
                                    ad.BusinessLogoPath = productInfo.category_ids.Aggregate((current, next) => current + "," + next);
                                else
                                    ad.BusinessLogoPath = string.Empty;

                                //misc
                                ad.ImagesPath = string.Empty;
                                ad.AddressID = 1;
                                ad.AccountID = 1;
                                ad.CustomFieldGroupID = 1;
                                _autoPostAdPostDataService.InsertAutoPostAdPostData(ad);
                            }




                        }

                    }
                }

                //update inventory
                var activeProductIds = activeProducts.Select(p => p.product_id).ToArray();
                var productInventoryInfoList = _magentoService.catalogInventoryStockItemList(sessionID, activeProductIds);

                foreach (var productInventoryInfo in productInventoryInfoList)
                {
                    var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataByCustomIDSKU(productInventoryInfo.product_id, productInventoryInfo.sku);
                    if (existingAd != null)
                    {
                        if (productInventoryInfo.is_in_stock == "0")
                        {
                            existingAd.InventoryQty = 0;
                        }
                        else
                        {
                            existingAd.InventoryQty = Convert.ToInt32(Convert.ToDecimal(productInventoryInfo.qty));
                        }
                        _autoPostAdPostDataService.UpdateAutoPostAdPostData(existingAd);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally 
            {
                _magentoService.endSession(sessionID);
            }
        }

        public void FixDropshipzoneCategoryCustomID()
        {
            //var sessionID = _magentoService.login("JimTestSOAPUser", "abc.123");
            var sessionID = _magentoService.login("NewAim", "abc.123");
            try
            {
                var paraFilters = new filters();
                //paraFilters.filter = new associativeEntity[1];
                var lstFilters = new List<associativeEntity>();
                //lstFilters.Add(new associativeEntity() { key = "sku", value = "SCALE-BFAT-WH" });
                paraFilters.filter = lstFilters.ToArray();

                var activeProducts = _magentoService.catalogProductList(sessionID, paraFilters, string.Empty).Where(p => !string.IsNullOrEmpty(p.sku));

                foreach (var product in activeProducts)
                {
                    AutoPostAdPostData ad = null;
                    var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID(product.sku, Common.ChannelType.DropshipZone);

                    if (existingAd != null&&existingAd.Status=="1")
                    {
                        ad = existingAd;
                        catalogProductRequestAttributes customAttributes = new catalogProductRequestAttributes();
                        var productInfo = _magentoService.catalogProductInfo(sessionID, product.product_id, string.Empty, customAttributes, string.Empty);

                        if (productInfo != null)
                        {
                            ad.CustomID = productInfo.product_id;
                            if (productInfo.category_ids != null && productInfo.category_ids.Count() > 0)
                                ad.BusinessLogoPath = productInfo.category_ids.Aggregate((current, next) => current + "," + next);
                            else
                                ad.BusinessLogoPath = string.Empty;
                            _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                        }
                    }

                    
                }
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
            }
            finally 
            {
                _magentoService.endSession(sessionID);
            }
        }


        //update dropshipzone product info for nopcommerce, e.g businesslogo(categories), customid(dropshipzone productid)
        public void UpdateDropshipzoneInfoForNopcommerce()
        { 
            var sessionID = _magentoService.login("NewAim", "abc.123");
            try
            {
                var paraFilters = new filters();
                //paraFilters.filter = new associativeEntity[1];
                var lstFilters = new List<associativeEntity>();
                //lstFilters.Add(new associativeEntity() { key = "sku", value = "SCALE-BFAT-WH" });
                paraFilters.filter = lstFilters.ToArray();

                var activeProducts = _magentoService.catalogProductList(sessionID, paraFilters, string.Empty).Where(p=>!string.IsNullOrEmpty(p.sku));
                var productsToBeUpdated = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();//use [Add new product for oz crazy mall(nopcommerce)] block

                foreach (var product in activeProducts)
                {
                    var productToBeUpdated=productsToBeUpdated.FirstOrDefault(p => p.SKU.ToUpper().Equals(product.sku.ToUpper()));
                    if (productToBeUpdated == null||!string.IsNullOrEmpty( productToBeUpdated.BusinessLogoPath))
                        continue;
                    catalogProductRequestAttributes customAttributes = new catalogProductRequestAttributes();
                    customAttributes.additional_attributes = new string[4] { "rs_fare", "inf_promotions", "group_price", "large_product" };
                    var productInfo = _magentoService.catalogProductInfo(sessionID, product.product_id, string.Empty, customAttributes, string.Empty);

                    if (productInfo != null)
                    {
                        AutoPostAdPostData ad = null;
                        var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID(productInfo.sku, Common.ChannelType.DropshipZone);

                        if (existingAd != null)
                        {
                            ad = existingAd;
                            ad.CustomID = productInfo.product_id;
                            if (productInfo.category_ids != null && productInfo.category_ids.Count() > 0)
                                ad.BusinessLogoPath = productInfo.category_ids.Aggregate((current, next) => current + "," + next);

                            _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                        }
                        //else
                        //{

                        //}
                    }
                }



            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
            }
            finally
            {
                _magentoService.endSession(sessionID);
            }
        }


        //public void CopyOutImagesToBeUploaded()
        //{ 
        //    try
        //    {
        //        var sourceImageDirRoot = @"G:\Jim\Own\LearningDoc\TempProject\Dropship\Dropship\Content\ItemImages\";
        //        var destImageDirRoot = "TempUploadImages\\";
        //        var productsToBeUpdated = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();//use [Add new product for oz crazy mall(nopcommerce)] block
        //        foreach (var product in productsToBeUpdated)
        //        { 
        //            DirectoryCopy
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        LogManager.Instance.Error(ex.ToString());
        //    }
        //}


        public bool GetDropshipzoneInfoWithFile()
        { 
            try
            {



                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally
            {
               
            }
        }

        public bool UpdateLocalDropshipzoneInfo()
        { 
            try
            {
                var activeProducts = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(ChannelType.DropshipZone, "1");
                //var activeProducts = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID("CAR-ROBAR-A120", ChannelType.DropshipZone).ToEnumerable();
                //get price list from csv
                var dropshipzoneGroupPriceList = new List<DropshipzoneGroupPrice>();
                if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath))
                {
                    dropshipzoneGroupPriceList = _csvContext.Read<DropshipzoneGroupPrice>(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath, _csvFileDescription).ToList();
                }

                //get postage list from csv
                var dropshipzonePostageList = new List<DropshipzonePostage>();
                if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath))
                {
                    dropshipzonePostageList = _csvContext.Read<DropshipzonePostage>(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath, _csvFileDescription).ToList();
                }

                foreach (var product in activeProducts)
                {
                    decimal dropshipzonePrice = -1;
                    if (dropshipzoneGroupPriceList.Count > 0)
                    {
                        var groupPrice = dropshipzoneGroupPriceList.Where(p => p.Sku.ToLower().Equals(product.SKU.ToLower())).FirstOrDefault();
                        if (groupPrice != null && !string.IsNullOrEmpty(groupPrice.Standard))
                        {
                            dropshipzonePrice = Convert.ToDecimal(groupPrice.Standard);
                        }

                    }
                    else
                    {
                        dropshipzonePrice = Convert.ToDecimal(product.Price);
                    }
                    //get postage from csv
                    decimal dropshipzonePostage = -1;
                    if (dropshipzonePostageList.Count > 0)
                    {
                        var dropshipzonePostageRow = dropshipzonePostageList.Where(p => p.Sku.ToLower().Equals(product.SKU.ToLower()) && p.Group.Equals("Standard")).FirstOrDefault();
                        if (dropshipzonePostageRow != null)
                        {
                            var pArr = new string[] { dropshipzonePostageRow.VIC, dropshipzonePostageRow.NSW, dropshipzonePostageRow.QLD, dropshipzonePostageRow.SA, dropshipzonePostageRow.TAS, dropshipzonePostageRow.WA, dropshipzonePostageRow.NT };
                            dropshipzonePostage = pArr.Select(p => Convert.ToDecimal(p)).Max();
                        }
                    }

                    product.Price = dropshipzonePrice;
                    if (dropshipzonePostage != -1 && dropshipzonePostage != 0)
                    {
                        product.Postage = dropshipzonePostage;
                    }
                    product.Notes = (dropshipzonePostage == 0 ? "FreeShipping" : string.Empty);
                    _autoPostAdPostDataService.UpdateAutoPostAdPostData(product);
                }


                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally
            {
                
            }
        }


        public string[] GetRedownloadImageSKUList()
        {
            return _autoPostAdPostDataService.GetRedownloadImageSKUList();
        }

        public void ReDownLoadImages(string[] skus)
        { 
            try
            {
                var skuListFilePath = @"C:\Temp\sku_list.csv";
                var skuList = new List<DropshipzoneSKUModel>();
                int i = 1;
                if (File.Exists(skuListFilePath))
                {
                    skuList = _csvContext.Read<DropshipzoneSKUModel>(skuListFilePath, _csvFileDescription).ToList();
                }
                foreach (var sku in skus)
                {
                    var skuLine = skuList.FirstOrDefault(l => l.SKU.ToUpper().Equals(sku.ToUpper()));
                    if (skuLine == null)
                        continue;
                    //var imagesURL = skuLine.Images.Split(';');
                    var imagesURL = new List<string>();
                    if (!string.IsNullOrEmpty(skuLine.Image1))
                        imagesURL.Add(skuLine.Image1);
                    if (!string.IsNullOrEmpty(skuLine.Image2))
                        imagesURL.Add(skuLine.Image2);
                    if (!string.IsNullOrEmpty(skuLine.Image3))
                        imagesURL.Add(skuLine.Image3);
                    if (!string.IsNullOrEmpty(skuLine.Image4))
                        imagesURL.Add(skuLine.Image4);
                    if (!string.IsNullOrEmpty(skuLine.Image5))
                        imagesURL.Add(skuLine.Image5);
                    if (!string.IsNullOrEmpty(skuLine.Image6))
                        imagesURL.Add(skuLine.Image6);
                    if (!string.IsNullOrEmpty(skuLine.Image7))
                        imagesURL.Add(skuLine.Image7);
                    if (!string.IsNullOrEmpty(skuLine.Image8))
                        imagesURL.Add(skuLine.Image8);
                    if (!string.IsNullOrEmpty(skuLine.Image9))
                        imagesURL.Add(skuLine.Image9);
                    if (!string.IsNullOrEmpty(skuLine.Image10))
                        imagesURL.Add(skuLine.Image10);
                    if (!string.IsNullOrEmpty(skuLine.Image11))
                        imagesURL.Add(skuLine.Image11);
                    if (!string.IsNullOrEmpty(skuLine.Image12))
                        imagesURL.Add(skuLine.Image12);
                    if (!string.IsNullOrEmpty(skuLine.Image13))
                        imagesURL.Add(skuLine.Image13);
                    if (!string.IsNullOrEmpty(skuLine.Image14))
                        imagesURL.Add(skuLine.Image14);
                    if (!string.IsNullOrEmpty(skuLine.Image15))
                        imagesURL.Add(skuLine.Image15);
                    DirectoryInfo di = new DirectoryInfo(AutoPostAdConfig.Instance.ImageFilesPath + skuLine.SKU + "\\");

                    if (!di.Exists)
                    {
                        di.Create();
                    }
                    using (var wc = new WebClient())
                    {
                        foreach (var imageURL in imagesURL)
                        {
                            try
                            {
                                var imageFileName = skuLine.SKU + "-" + i.ToString().PadLeft(2, '0') + ".jpg";
                                var saveImageFileFullName = Path.Combine(di.FullName, imageFileName);

                                wc.DownloadFile(imageURL, saveImageFileFullName);
                            }
                            catch (Exception ex)
                            {
                                LogManager.Instance.Error(imageURL + " download failed. " + ex.Message);
                            }

                            i++;
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
            }
            finally
            {

            }
        }


        //public bool GetDropshipzoneProductImagesPath()
        //{
        //    try
        //    {

        //        var adDatas = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(Common.ChannelType.DropshipZone,"1");
        //        foreach (var data in adDatas)
        //        {
        //            if (string.IsNullOrEmpty(data.ImagesPath))
        //            {
        //                var imagesPath = GetImagesPath(data.SKU);
        //                data.ImagesPath = imagesPath;
        //                _autoPostAdPostDataService.UpdateAutoPostAdPostData(data);
        //            }
        //        }

        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        LogManager.Instance.Error(ex.ToString());
        //        return false;
        //    }
        //}

        public bool GetDropshipzoneProductImagesPath()
        {
            try
            {

                var adDatas = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(Common.ChannelType.DropshipZone, "1");
                var imagesData = _autoPostAdPostDataService.GetImagesData();
                foreach (var data in adDatas)
                {
                    if (string.IsNullOrEmpty(data.ImagesPath))
                    {
                        var images = imagesData.Where(i => i.SKU.ToUpper().Equals(data.SKU.ToUpper()));
                        if (images.Count() > 0)
                        {
                            var imagesPath = images.Select(i => i.ImagePath).Aggregate((current, next) => current + ";" + next);
                            data.ImagesPath = imagesPath;
                            _autoPostAdPostDataService.UpdateAutoPostAdPostData(data);
                        }
                        
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public class ImagesData
        {
            public string SKU { get; set; }
            public string ImagePath { get; set; }
            public int StatusID { get; set; }
            public int DisplayOrder { get; set; }
        }


        public bool GetRealSmartInfo(bool onlyUpdateInventory = false)
        {
            var sessionID = _magentoService.login("AdminIT", "asdf1234");
            try
            {

                var paraFilters = new filters();
                //paraFilters.filter = new associativeEntity[1];
                var lstFilters = new List<associativeEntity>();
                //lstFilters.Add(new associativeEntity() { key = "status", value = "1" });
                paraFilters.filter = lstFilters.ToArray();

                var activeProducts = _magentoService.catalogProductList(sessionID, paraFilters, string.Empty);

                if (!onlyUpdateInventory)
                {
                    //get price list from csv
                    var dropshipzoneGroupPriceList = new List<DropshipzoneGroupPrice>();
                    if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath))
                    {
                        dropshipzoneGroupPriceList = _csvContext.Read<DropshipzoneGroupPrice>(AutoPostAdConfig.Instance.DropshipzoneGroupPriceFilePath, _csvFileDescription).ToList();
                    }

                    //get postage list from csv
                    var dropshipzonePostageList = new List<DropshipzonePostage>();
                    if (File.Exists(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath))
                    {
                        dropshipzonePostageList = _csvContext.Read<DropshipzonePostage>(AutoPostAdConfig.Instance.DropshipzoneGroupPostageFilePath, _csvFileDescription).ToList();
                    }



                    foreach (var product in activeProducts)
                    {
                        catalogProductRequestAttributes customAttributes = new catalogProductRequestAttributes();
                        customAttributes.additional_attributes = new string[3] { "rs_fare", "inf_promotions", "group_price" };
                        var productInfo = _magentoService.catalogProductInfo(sessionID, product.product_id, string.Empty, customAttributes, string.Empty);

                        if (productInfo != null)
                        {
                            AutoPostAdPostData ad = null;
                            var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataBySKUAdTypeID(productInfo.sku, Common.ChannelType.DropshipZone);
                            //get price from csv
                            decimal dropshipzonePrice = -1;
                            if (dropshipzoneGroupPriceList.Count > 0)
                            {
                                var groupPrice = dropshipzoneGroupPriceList.Where(p => p.Sku.ToLower().Equals(productInfo.sku.ToLower())).FirstOrDefault();
                                if (groupPrice != null && !string.IsNullOrEmpty(groupPrice.Standard))
                                {
                                    dropshipzonePrice = Convert.ToDecimal(groupPrice.Standard);
                                }

                            }
                            else
                            {
                                dropshipzonePrice = Convert.ToDecimal(productInfo.price);
                            }
                            //get postage from csv
                            decimal dropshipzonePostage = -1;
                            if (dropshipzonePostageList.Count > 0)
                            {
                                var dropshipzonePostageRow = dropshipzonePostageList.Where(p => p.Sku.ToLower().Equals(productInfo.sku.ToLower()) && p.Group.Equals("Standard")).FirstOrDefault();
                                if (dropshipzonePostageRow != null)
                                {
                                    var pArr = new string[] { dropshipzonePostageRow.VIC, dropshipzonePostageRow.NSW, dropshipzonePostageRow.QLD, dropshipzonePostageRow.SA, dropshipzonePostageRow.TAS, dropshipzonePostageRow.WA, dropshipzonePostageRow.NT };
                                    dropshipzonePostage = pArr.Select(p => Convert.ToDecimal(p)).Max();
                                }
                            }

                            if (existingAd != null)
                            {
                                ad = existingAd;
                                ad.Title = productInfo.name;
                                ad.Status = (productInfo.status.Equals("1") && dropshipzonePrice != -1 ? "1" : "2");
                                ad.Description = productInfo.description;
                                ad.Price = dropshipzonePrice;

                                var postage = productInfo.additional_attributes.FirstOrDefault(a => a.key == "rs_fare");
                                var isFreeShipping = productInfo.additional_attributes.FirstOrDefault(a => a.key == "inf_promotions");
                                if (dropshipzonePostage == -1 || dropshipzonePostage == 0)
                                {
                                    if (postage != null)
                                    {
                                        ad.Postage = Convert.ToDecimal(postage.value);
                                    }
                                }
                                else
                                {
                                    ad.Postage = dropshipzonePostage;
                                }
                                ad.Notes = (dropshipzonePostage == 0 ? "FreeShipping" : string.Empty);
                                //if (isFreeShipping != null)
                                //{
                                //    ad.Notes = (isFreeShipping.value == "10" ? "FreeShipping" : string.Empty);
                                //}

                                _autoPostAdPostDataService.UpdateAutoPostAdPostData(ad);
                            }
                            else
                            {
                                ad = new AutoPostAdPostData();

                                ad.SKU = productInfo.sku;
                                ad.AdTypeID = Common.ChannelType.DropshipZone;
                                ad.Title = productInfo.name;
                                ad.CustomID = productInfo.product_id;
                                ad.Status = (productInfo.status.Equals("1") && dropshipzonePrice != -1 ? "1" : "2");
                                ad.Description = productInfo.description;


                                ad.Price = dropshipzonePrice;
                                var postage = productInfo.additional_attributes.FirstOrDefault(a => a.key == "rs_fare");
                                var isFreeShipping = productInfo.additional_attributes.FirstOrDefault(a => a.key == "inf_promotions");
                                if (dropshipzonePostage == -1 || dropshipzonePostage == 0)
                                {
                                    if (postage != null)
                                    {
                                        ad.Postage = Convert.ToDecimal(postage.value);
                                    }
                                }
                                else
                                {
                                    ad.Postage = dropshipzonePostage;
                                }
                                ad.Notes = (dropshipzonePostage == 0 ? "FreeShipping" : string.Empty);



                                //misc
                                ad.ImagesPath = string.Empty;
                                ad.AddressID = 1;
                                ad.AccountID = 1;
                                ad.CustomFieldGroupID = 1;
                                ad.BusinessLogoPath = string.Empty;
                                _autoPostAdPostDataService.InsertAutoPostAdPostData(ad);
                            }




                        }

                    }
                }

                //update inventory
                var activeProductIds = activeProducts.Select(p => p.product_id).ToArray();
                var productInventoryInfoList = _magentoService.catalogInventoryStockItemList(sessionID, activeProductIds);

                foreach (var productInventoryInfo in productInventoryInfoList)
                {
                    var existingAd = _autoPostAdPostDataService.GetAutoPostAdPostDataByCustomIDSKU(productInventoryInfo.product_id, productInventoryInfo.sku);
                    if (existingAd != null)
                    {
                        if (productInventoryInfo.is_in_stock == "0")
                        {
                            existingAd.InventoryQty = 0;
                        }
                        else
                        {
                            existingAd.InventoryQty = Convert.ToInt32(Convert.ToDecimal(productInventoryInfo.qty));
                        }
                        _autoPostAdPostDataService.UpdateAutoPostAdPostData(existingAd);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally
            {
                _magentoService.endSession(sessionID);
            }
        }

        public bool GenerateCSVFile(string sku="")
        {
            try
            {
                //Get Data from DB
                var adDatas = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(Common.ChannelType.DropshipZone);
                if (!string.IsNullOrEmpty(sku))
                {
                    adDatas = adDatas.Where(n => n.SKU.ToUpper().Equals(sku)).ToList();
                }

                var csvRows = new List<MagentoCSVBM>();

                var itemIndex=1;
                var itemsPerFile = 20;
                var fileDate = DateTime.Now.ToString("yyyyMMddHHmmss");
                var fileNumber=1;
                foreach (var adData in adDatas)
                {
                    if(itemIndex==1)
                        csvRows = new List<MagentoCSVBM>();
                    var desc = ApplyDataToTemplate(adData);

                    MagentoCSVBM csvRowData = null;
                    int i=0;
                    foreach (var imgPath in adData.ImagesPath.Split(';'))
                    {
                        if (i == 0)
                        {
                            csvRowData = new MagentoCSVBM()
                            {
                                sku = adData.SKU,
                                _attribute_set = "Default",
                                _type = "simple",
                                _product_websites = "base",
                                description = desc,
                                enable_googlecheckout = "0",
                                has_options = "0",
                                image = (!string.IsNullOrEmpty(adData.ImagesPath) ? "/" + imgPath.Replace('\\', '/') : string.Empty),
                                postage = (!string.IsNullOrEmpty(adData.Notes) ? "Free Shipping" : "Freight"),
                                msrp_display_actual_price_type = "Use config",
                                msrp_enabled = "Use config",
                                name = adData.Title,
                                options_container = "Block after Info Column",
                                price = adData.Price.ToString(),
                                required_options = "0",
                                short_description = adData.Title,
                                small_image = (!string.IsNullOrEmpty(adData.ImagesPath) ? "/" + imgPath.Replace('\\', '/') : string.Empty),
                                status = "1",
                                tax_class_id = "2",
                                thumbnail = (!string.IsNullOrEmpty(adData.ImagesPath) ? "/" + imgPath.Replace('\\', '/') : string.Empty),
                                updated_at = DateTime.Now.ToString("dd/MM/yyyy HH:mm"),
                                visibility = "4",
                                qty = adData.InventoryQty.ToString(),
                                min_qty = "0",
                                use_config_min_qty = "1",
                                is_qty_decimal = "0",
                                backorders = "0",
                                use_config_backorders = "1",
                                min_sale_qty = "1",
                                use_config_min_sale_qty = "1",
                                max_sale_qty = "0",
                                use_config_max_sale_qty = "1",
                                is_in_stock = "1",
                                use_config_notify_stock_qty = "1",
                                manage_stock = "0",
                                use_config_manage_stock = "1",
                                stock_status_changed_auto = "0",
                                use_config_qty_increments = "1",
                                qty_increments = "0",
                                use_config_enable_qty_inc = "1",
                                enable_qty_increments = "0",
                                _media_attribute_id = "88",
                                _media_image = (!string.IsNullOrEmpty(adData.ImagesPath) ? "/" + imgPath.Replace('\\', '/') : string.Empty),
                                _media_position = i.ToString(),
                                _media_is_disabled = "0",
                                weight = "0"



                            };
                        }
                        else
                        {
                            //continue;
                            csvRowData = new MagentoCSVBM()
                                {
                                    _media_attribute_id = "88",
                                    _media_image = (!string.IsNullOrEmpty(adData.ImagesPath) ? "/" + imgPath.Replace('\\', '/') : string.Empty),
                                    _media_position = i.ToString(),
                                    _media_is_disabled="0"
                                };
                        }

                        csvRows.Add(csvRowData);
                        i++;
                    }

                    if (itemIndex < itemsPerFile)
                        itemIndex++;
                    else
                    {
                        _csvContext.Write<MagentoCSVBM>(csvRows, "DropshipzoneItemFile\\DropshipzoneItem_" + fileDate + "_" + fileNumber + ".csv", _csvFileDescription);
                        fileNumber++;
                        itemIndex = 1;
                    }
                        

                }

                


                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally
            { 
            
            }
            
        }

        public bool GenerateNopcommerceImportCSVFile()
        {
            var reDownloadImageSKUs = new List<string>();
            try
            {
                var adDatas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                var csvRows = new List<NopcommerceCSVBM>();
                var nopCategories = _autoPostAdPostDataService.GetNopcommerceCategories();
                var fileDate = DateTime.Now.ToString("yyyyMMddHHmmss");
                var itemIndex = 1;
                var itemsPerFile = 100;
                var fileNumber = 1;
                var totalFileNumber = Convert.ToInt32(Math.Ceiling(Convert.ToDecimal(adDatas.Count) / Convert.ToDecimal(itemsPerFile)));
                var serverPath = @"C:\HostingSpaces\ozcrazym\www.ozcrazymall.com.au\www\Content\UploadProductImages\";
                //var serverPath = AutoPostAdConfig.Instance.ImageFilesPath;

                foreach (var adData in adDatas)
                {
                    try
                    {
                        if (itemIndex == 1)
                            csvRows = new List<NopcommerceCSVBM>();

                        var csvRowData = new NopcommerceCSVBM();
                        csvRowData.ProductTypeId = 5;
                        csvRowData.ParentGroupedProductId = 0;
                        csvRowData.VisibleIndividually = true.ToString().ToUpper();
                        csvRowData.Name = adData.Title;
                        csvRowData.FullDescription = adData.Description;
                        csvRowData.VendorId = 0;
                        csvRowData.ProductTemplateId = 1;
                        csvRowData.ShowOnHomePage = false.ToString().ToUpper();
                        csvRowData.AllowCustomerReviews = true.ToString().ToUpper();
                        csvRowData.Published = true.ToString().ToUpper();
                        csvRowData.SKU = adData.SKU;
                        csvRowData.IsGiftCard = false.ToString().ToUpper();
                        csvRowData.GiftCardTypeId = 0;
                        csvRowData.RequireOtherProducts = false.ToString().ToUpper();
                        csvRowData.AutomaticallyAddRequiredProducts = false.ToString().ToUpper();
                        csvRowData.IsDownload = false.ToString().ToUpper();
                        csvRowData.DownloadId = 0;
                        csvRowData.UnlimitedDownloads = false.ToString().ToUpper();
                        csvRowData.MaxNumberOfDownloads = 0;
                        csvRowData.DownloadActivationTypeId = 0;
                        csvRowData.HasSampleDownload = false.ToString().ToUpper();
                        csvRowData.SampleDownloadId = 0;
                        csvRowData.HasUserAgreement = false.ToString().ToUpper();
                        csvRowData.IsRecurring = false.ToString().ToUpper();
                        csvRowData.RecurringCycleLength = 0;
                        csvRowData.RecurringCyclePeriodId = 0;
                        csvRowData.RecurringTotalCycles = 0;
                        csvRowData.IsRental = false.ToString().ToUpper();
                        csvRowData.RentalPriceLength = 0;
                        csvRowData.RentalPricePeriodId = 0;
                        csvRowData.IsShipEnabled = true.ToString().ToUpper();
                        csvRowData.IsFreeShipping = (adData.Notes == "FreeShipping" ? true.ToString().ToUpper() : false.ToString().ToUpper());
                        csvRowData.ShipSeparately = false.ToString().ToUpper();
                        csvRowData.AdditionalShippingCharge = adData.Postage;
                        csvRowData.DeliveryDateId = 0;
                        csvRowData.IsTaxExempt = false.ToString().ToUpper();
                        csvRowData.TaxCategoryId = 0;
                        csvRowData.IsTelecommunicationsOrBroadcastingOrElectronicServices = false.ToString().ToUpper();
                        csvRowData.ManageInventoryMethodId = 1;
                        csvRowData.UseMultipleWarehouses = false.ToString().ToUpper();
                        csvRowData.WarehouseId = 0;
                        csvRowData.StockQuantity = adData.InventoryQty;
                        csvRowData.DisplayStockAvailability = true.ToString().ToUpper();
                        csvRowData.DisplayStockQuantity = false.ToString().ToUpper();
                        csvRowData.MinStockQuantity = 10;
                        csvRowData.LowStockActivityId = 1;
                        csvRowData.NotifyAdminForQuantityBelow = 10;
                        csvRowData.BackorderModeId = 0;
                        csvRowData.AllowBackInStockSubscriptions = false.ToString().ToUpper();
                        csvRowData.OrderMinimumQuantity = 1;
                        csvRowData.OrderMaximumQuantity = 10000;
                        csvRowData.AllowAddingOnlyExistingAttributeCombinations = false.ToString().ToUpper();
                        csvRowData.DisableBuyButton = false.ToString().ToUpper();
                        csvRowData.DisableWishlistButton = false.ToString().ToUpper();
                        csvRowData.AvailableForPreOrder = false.ToString().ToUpper();
                        csvRowData.CallForPrice = false.ToString().ToUpper();
                        csvRowData.Price = adData.Price.ToeBayCrazyMallPrice();
                        csvRowData.OldPrice = 0;
                        csvRowData.ProductCost = adData.Price;
                        csvRowData.CustomerEntersPrice = false.ToString().ToUpper();
                        csvRowData.MinimumCustomerEnteredPrice = 0;
                        csvRowData.MaximumCustomerEnteredPrice = 0;
                        csvRowData.Weight = 0;
                        csvRowData.Length = 0;
                        csvRowData.Width = 0;
                        csvRowData.Height = 0;
                        csvRowData.CreatedOnUtc = DateTime.Now.ToOADate();
                        if (!string.IsNullOrEmpty(adData.BusinessLogoPath))
                        {
                            //var categoryIDs = _autoPostAdPostDataService.GetMatchedNopcommerceCategories(adData.BusinessLogoPath);
                            var categoryIDs = nopCategories.Where(c => adData.BusinessLogoPath.Split(',').Contains(c.Description));
                            csvRowData.CategoryIds = categoryIDs.Select(c => c.Id.ToString()).Aggregate((current, next) => current + ";" + next);
                        }
                        var imageFiles = Directory.GetFiles(AutoPostAdConfig.Instance.ImageFilesPath + adData.SKU, "*", SearchOption.AllDirectories);
                        if (imageFiles!=null&& imageFiles.Count()>0)
                        {
                            DirectoryCopy(AutoPostAdConfig.Instance.ImageFilesPath + adData.SKU, Directory.GetCurrentDirectory() + "\\NopcommerceItemFile\\" + adData.SKU, false);

                            int i = 1;
                            foreach (var image in imageFiles)
                            {
                                var imageName = image.Substring(image.IndexOf(adData.SKU), image.Length - image.IndexOf(adData.SKU));
                                switch (i)
                                {
                                    case 1:
                                        csvRowData.Picture1 = serverPath + imageName;
                                        break;
                                    case 2:
                                        csvRowData.Picture2 = serverPath + imageName;
                                        break;
                                    case 3:
                                        csvRowData.Picture3 = serverPath + imageName;
                                        break;
                                    case 4:
                                        csvRowData.Picture4 = serverPath + imageName;
                                        break;
                                    case 5:
                                        csvRowData.Picture5 = serverPath + imageName;
                                        break;
                                    case 6:
                                        csvRowData.Picture6 = serverPath + imageName;
                                        break;
                                    case 7:
                                        csvRowData.Picture7 = serverPath + imageName;
                                        break;
                                    case 8:
                                        csvRowData.Picture8 = serverPath + imageName;
                                        break;
                                    case 9:
                                        csvRowData.Picture9 = serverPath + imageName;
                                        break;
                                    case 10:
                                        csvRowData.Picture10 = serverPath + imageName;
                                        break;
                                    case 11:
                                        csvRowData.Picture11 = serverPath + imageName;
                                        break;
                                    case 12:
                                        csvRowData.Picture12 = serverPath + imageName;
                                        break;
                                }
                                i++;

                            }
                        }
                        csvRowData.IsOverridePic = true.ToString().ToUpper();

                        csvRows.Add(csvRowData);

                        //if (itemIndex < itemsPerFile &&  adDatas.Count != itemIndex)
                        if (itemIndex < itemsPerFile && (fileNumber - 1) * itemsPerFile + itemIndex < adDatas.Count)
                            itemIndex++;
                        else
                        {
                            _csvContext.Write<NopcommerceCSVBM>(csvRows, "NopcommerceItemFile\\NopcommerceItem_" + fileDate + "_" + fileNumber.ToString() + ".csv", _csvFileDescription);
                            fileNumber++;
                            itemIndex = 1;
                        }
                    }
                    catch (Exception ex)
                    {
                        reDownloadImageSKUs.Add(adData.SKU);
                        LogManager.Instance.Error(ex.ToString());
                    }
                }

                if(reDownloadImageSKUs.Count>0)
                {
                    //ReDownLoadImages(reDownloadImageSKUs.ToArray());
                }
                
                


                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally
            {

            }
        }
       



        public bool GetCategories()
        {
            var sessionID = _magentoService.login("NewAim", "abc.123");
            try
            {
                var categoryTree = _magentoService.catalogCategoryTree(sessionID, "1", "1");

                var category=AutoMapper.Mapper.Map<catalogCategoryTree, catalogCategoryEntity>(categoryTree);

                InsertOrUpdateDropshipZoneCategory(category);

                LoopCategories(category);

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
            finally 
            {
                _magentoService.endSession(sessionID);
            }
        }

        public bool ConvertHtmlToPlainTextForGumtree()
        {
            try
            {
                //var saveList = new List<AutoPostAdPostData>();
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                foreach (var data in datas)
                {
                    var html = data.Description.StripHTML();
                    var updateItem = _autoPostAdPostDataService.GetAutoPostAdPostDataByID(data.ID);
                    updateItem.Description = html;
                    //data.Description = html;
                    //saveList.Add(data);
                    _autoPostAdPostDataService.UpdateAutoPostAdPostData(updateItem);
                }
                //_csvContext.Write<AutoPostAdPostData>(datas, "E:\\DescriptionText.csv");
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public void RenderNewAddItemDescription()
        {
            try
            {
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                _csvContext.Write<AutoPostAdPostData>(datas,"E:\\DescriptionText.csv");
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
            }
        }

        public bool FixQuickSaleImagePath()
        {
            try
            {
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                foreach (var data in datas)
                {
                    var imagesPath = GetQuickSaleImagesPath(data.SKU);
                    var updateItem = _autoPostAdPostDataService.GetAutoPostAdPostDataByID(data.ID);
                    updateItem.ImagesPath = imagesPath;
                    _autoPostAdPostDataService.UpdateAutoPostAdPostData(updateItem);
                }
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public bool SortingForLogoingImages()
        {
            try
            {
                //var datas = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(ChannelType.DropshipZone);
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                var dirLogoingImages="ForLogoingImages\\";
                if (!Directory.Exists(dirLogoingImages))
                {
                    Directory.CreateDirectory(dirLogoingImages);
                }
                foreach (var data in datas)
                {
                    if (!string.IsNullOrEmpty(data.ImagesPath) && data.ImagesPath.Split(';').Count() > 0)
                    {
                        var firstImageFile = data.ImagesPath.Split(';').FirstOrDefault();
                        firstImageFile = firstImageFile.Substring(firstImageFile.IndexOf("\\" + data.SKU)+1, firstImageFile.Length - firstImageFile.IndexOf("\\" + data.SKU)-1);
                        firstImageFile = firstImageFile.Replace("_logo", "-00");
                        Image img = Image.FromFile(AutoPostAdConfig.Instance.ImageFilesPath + firstImageFile);
                        //Image img = Image.FromFile(AutoPostAdConfig.Instance.ImageFilesPath + data.SKU + "\\" + firstImageFile);
                        //if (img.Width==500)
                        //{
                        //    if (!Directory.Exists(Dir500))
                        //    {
                        //        Directory.CreateDirectory(Dir500);
                        //    }

                        //}
                        //else if (img.Width == 1000)
                        //{ 
                        
                        //}
                        //else if (img.Width == 1600)
                        //{

                        //}
                        //else
                        //{ 
                            
                        //}
                        if (img.Width > 500)
                        {
                            img=img.ResizeImage(new Size(500, 500));
                        }
                        img.Save(dirLogoingImages + data.SKU + "_logo.jpg", ImageFormat.Jpeg);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public bool CopyLogoedImagesToImagesFilePath()
        { 
            try
            {
                var dirLogoedImages = "LogoedImages\\";
                if (!Directory.Exists(dirLogoedImages))
                {
                    return false;
                }
                var imageFiles = Directory.GetFiles(dirLogoedImages);
                var copyToDirRoot = @"C:\Users\gdutj\Documents\Work\GumtreePostAdData\NopCommerce3\";
                //var copyToDirRoot = AutoPostAdConfig.Instance.ImageFilesPath;
                foreach (var imageFile in imageFiles)
                {
                    var sku = GetOnlyFileNameByFullName(imageFile).Substring(0, GetOnlyFileNameByFullName(imageFile).IndexOf("_logo"));
                    if (Directory.Exists(AutoPostAdConfig.Instance.ImageFilesPath + sku))
                    {
                        var exactDirPathName = GetExactPathName(copyToDirRoot + sku);
                        var exactSKUName = GetOnlyFileNameByFullName(exactDirPathName);

                        File.Copy(imageFile, exactDirPathName+"\\"+exactSKUName + "_logo.jpg", true);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public bool CopyLogoedImagesToProductionFolder()
        {
            try
            {
                var fromFolder = AutoPostAdConfig.Instance.ImageFilesPath;
                var toFolder = AutoPostAdConfig.Instance.CopyToProductionFolder;
                if (!Directory.Exists(fromFolder))
                {
                    return false;
                }



                var fromImageFiles = Directory.GetFiles(fromFolder);
                var toDirectories = Directory.GetDirectories(toFolder);

                //foreach(var to in toDirectories)
                //{
                //    var tostring = to.Substring(to.LastIndexOf("\\"), to.Length - to.LastIndexOf("\\"));
                //}

                var fromSKU = fromImageFiles.Select(f => GetOnlyFileNameByFullName(f).Substring(0, GetOnlyFileNameByFullName(f).IndexOf("_logo")).ToUpper());
                var toSKU = toDirectories.Select(d => d.Substring(d.LastIndexOf("\\")+1,d.Length-d.LastIndexOf("\\")-1).ToUpper());
                var fromHasToHasnot = fromSKU.Where(f => !toSKU.Contains(f));
                var toHasFromHasnot = toSKU.Where(t => !fromSKU.Contains(t));
                //var fromImageFiles = Directory.GetFiles(fromFolder);
                //var copyToDirRoot = @"G:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData\NopCommerce3\";
                //var copyToDirRoot = AutoPostAdConfig.Instance.ImageFilesPath;
                foreach (var imageFile in fromImageFiles)
                {
                    var sku = GetOnlyFileNameByFullName(imageFile).Substring(0, GetOnlyFileNameByFullName(imageFile).IndexOf("_logo"));
                    if (Directory.Exists(toFolder + sku))
                    {
                        var exactDirPathName = GetExactPathName(toFolder + sku);
                        var exactSKUName = GetOnlyFileNameByFullName(exactDirPathName);

                        File.Copy(imageFile, exactDirPathName + "\\" + exactSKUName + "_logo.jpg", true);
                    }
                }
                foreach(var notexistSKU in toHasFromHasnot)
                {
                    LogManager.Instance.Info(notexistSKU);
                }
                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }

        }

        public void RenameImages()
        {
            //var allImageFiles = Directory.GetFiles(@"C:\Users\gdutj\Documents\DropshipImages\Temp", "*", SearchOption.AllDirectories);
            //foreach(var image in allImageFiles)
            //{
            //    im
            //}

            var allDir = Directory.GetDirectories(@"C:\Users\gdutj\Documents\DropshipImages\Temp");
            foreach(var dir in allDir)
            {
                var imageFiles = Directory.GetFiles(dir);
                var dirInfo = new DirectoryInfo(dir);
                var SKU = dirInfo.Name;
                Console.WriteLine(SKU);
                
                int i = 0;
                foreach (var image in imageFiles)
                {
                    var imgInfo = new FileInfo(image);
                    File.Move(imgInfo.FullName, Path.Combine(dir, SKU + "-" + i.ToString().PadLeft(2, '0') + ".jpg"));
                    i++;
                }
                Console.WriteLine();
            }
            Console.ReadLine();
        }

        public void ResizeImages(string imagesDir)
        {
            try
            {
                if (!Directory.Exists(imagesDir))
                {
                    return;
                }
                var imageFiles = Directory.GetFiles(imagesDir,"*",SearchOption.AllDirectories);
                //var copyToDirRoot = @"G:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData\NopCommerce2\";
                //var copyToDirRoot = AutoPostAdConfig.Instance.ImageFilesPath;
                var imageFilesGroup = from f in imageFiles
                                      group f by new { DirName = Path.GetDirectoryName(f) } into grp
                                      select grp;

                foreach (var imgFiles in imageFilesGroup)
                {
                    var di = new DirectoryInfo(imgFiles.Key.DirName);
                    int i = 101;
                    foreach (var imgFile in imgFiles)
                    {
                        Image img = Image.FromFile(imgFile);
                        if (img.Width > 1000 || img.Height > 1000)
                        {
                            img = img.ResizeImage(new Size(1000, 1000));
                        }
                        else
                        {
                            img = img.ResizeImage(new Size(img.Width, img.Height));
                        }
                        img.Save(di.FullName + "\\" + i + ".jpg", ImageFormat.Jpeg);
                        i++;
                    }

                }

                //Resize Dropship Images
                //var tmpDir = Directory.CreateDirectory(imagesDir+"\\Temp");
                //foreach (var imgFiles in imageFilesGroup)
                //{
                //    var di = new DirectoryInfo(imgFiles.Key.DirName);
                //    var newDir = Directory.CreateDirectory(tmpDir.FullName+"\\"+di.Name);
                //    //int i = 0;
                //    foreach (var imgFile in imgFiles)
                //    {
                //        var fi = new FileInfo(imgFile);
                //        if (fi.Name.IndexOf("logo") == -1)
                //        {
                //            var imgNum = Regex.Matches(fi.Name, @"\d{2}").OfType<Match>().LastOrDefault().Value;
                //            if (!string.IsNullOrEmpty(imgNum))
                //            {
                //                Image img = Image.FromFile(imgFile);
                //                if (img.Width > 1000 || img.Height > 1000)
                //                {
                //                    img = img.ResizeImage(new Size(1000, 1000));
                //                }
                //                else
                //                {
                //                    img = img.ResizeImage(new Size(img.Width, img.Height));
                //                }
                //                //fi.Delete();
                //                img.Save(newDir.FullName + "\\" + di.Name + "-" + imgNum.ToString().PadLeft(2, '0') + ".jpg", ImageFormat.Jpeg);
                //            }
                //        }
                //        else
                //        {
                //            fi.CopyTo(newDir.FullName + "\\" + fi.Name);
                //        }
                //    }

                //}
                return;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return;
            }
        }


        public bool UpdateActiveListing(bool isUpdateSelectedSKU=false)
        {
            try
            {
                //freeshipping not bulky
                var strFreePostage = "Postage is calculated as per item. We offer free shipping service to Australian wide for this item excluding the following postcode: 5701, 6740, 6743 and 7151.";
                //freeshipping and bulky
                var strBulkyFreePostage = "Postage is calculated as per item. We offer free shipping service to Australian wide for this item excluding the following areas: NT 0800-0999, NSW 2641, QLD 4450-4499, 4680, 4700-4805, 9920-9959, 4806-4899, 4900-4999, 9960-9999, SA 5701, TAS 7151, WA 6215-6699, 6700-6799 due to no shipping contract, sorry about all inconvenience occured.";
                //freight and bulky
                var strBulkyItemFreight = "Postage is calculated as per item. We cannot ship to NT 0800-0999, NSW 2641, QLD 4450-4499, 4680, 4700-4805, 9920-9959, 4806-4899, 4900-4999, 9960-9999, SA 5701, TAS 7151, WA 6215-6699, 6700-6799 for this bulky item because we have no shipping contract for these areas, sorry about all inconvenience occured.";
                //freight and not bulky
                var strNotBulkyFreight = "Postage is calculated as per item. We offer freight shipping service to Australian wide for this item excluding the following postcode: 5701, 6740, 6743 and 7151.";


                var lstUpdateModel = new List<eBayUpdateModel>();
                lstUpdateModel.Add(new eBayUpdateModel() { SKU = "PV-AS-400-BLACK", Description = "", Price = Convert.ToDecimal(62.95), Qty = -1, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                lstUpdateModel.Add(new eBayUpdateModel() { SKU = "PV-AS-400-SILVER", Description = "", Price = Convert.ToDecimal(62.95), Qty = -1, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                lstUpdateModel.Add(new eBayUpdateModel() { SKU = "CAR-WINCH-3000-SR", Description = "", Price = Convert.ToDecimal(198.95), Qty = -1, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                lstUpdateModel.Add(new eBayUpdateModel() { SKU = "CAR-WINCH-4000-SR", Description = "", Price = Convert.ToDecimal(240.95), Qty = -1, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                //wait for change image from free shipping to freight
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "AQ-LED-120", Description = "", Price = Convert.ToDecimal(131.95), Qty = 0, ShippingPolicy = ECMShippingPolicy.Freight });
                lstUpdateModel.Add(new eBayUpdateModel() { SKU = "BFRAME-C-BS-BK", Description = "", Price = Convert.ToDecimal(111.95), Qty = 10, ShippingPolicy = ECMShippingPolicy.Freight });
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "CMAT-TW-H-135", Description = "", Price = Convert.ToDecimal(47.95), Qty = 0, ShippingPolicy = ECMShippingPolicy.Freight });
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "CAR-WINCH-13000-SET", Description = "", Price = Convert.ToDecimal(398.95), Qty = 0, ShippingPolicy = ECMShippingPolicy.Freight });
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "CD-SHELF-WH-AB", Description = "", Price = Convert.ToDecimal(151.95), Qty = 0, ShippingPolicy = ECMShippingPolicy.Freight });
                //dsz no stock actually have stock
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "TOPPER-PT-Q", Description = "", Price = Convert.ToDecimal(79.95), Qty = 5, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                //lstUpdateModel.Add(new eBayUpdateModel() { SKU = "POT-BIN-15L-SET", Description = "", Price = Convert.ToDecimal(71.95), Qty = 5, ShippingPolicy = ECMShippingPolicy.FreeShipping });
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                if (lstUpdateModel.Count > 0 && isUpdateSelectedSKU)
                {
                    datas = datas.Where(d => lstUpdateModel.Select(m => m.SKU.ToUpper()).Contains(d.SKU.ToUpper())).ToList();
                }
                foreach (var data in datas)
                {
                    try
                    {
                        var item = _getItemCall.GetItem(data.CustomID);
                        var updateItem = new ItemType();
                        updateItem.ItemID = item.ItemID;
                        updateItem.StartPrice = new AmountType() { currencyID = CurrencyCodeType.AUD };
                        var updateInfo = lstUpdateModel.Where(m => m.SKU.ToUpper().Equals(data.SKU.ToUpper())).FirstOrDefault();
                        var descHtmlDoc = new HtmlDocument();
                        if (!string.IsNullOrEmpty(item.Description))
                        {
                            descHtmlDoc.LoadHtml(item.Description);
                        }
                        if (updateInfo != null)
                        {
                            //update price
                            updateItem.StartPrice.Value = Convert.ToDouble(updateInfo.Price);
                            var elementPrice = descHtmlDoc.GetElementbyId("price");
                            WriteText(elementPrice, "$" + updateItem.StartPrice.Value.ToString());

                            if (!string.IsNullOrEmpty(updateInfo.Description))
                            {
                                var newDesc = HtmlNode.CreateNode(updateInfo.Description);
                                descHtmlDoc.DocumentNode.ParentNode.ReplaceChild(newDesc,descHtmlDoc.DocumentNode);
                            }
                            

                            //updateItem.Description = descHtmlDoc.DocumentNode.OuterHtml;

                            if (updateInfo.Qty != -1)
                            {
                                updateItem.Quantity = updateInfo.Qty;
                            }
                            else//when update qty =-1 then follow dsz qty rule
                            {
                                if (data.InventoryQty >= 50)
                                    updateItem.Quantity = 10;
                                else if (data.InventoryQty >= 5 && data.InventoryQty < 50)
                                    updateItem.Quantity = 5;
                                else
                                    updateItem.Quantity = 0;
                            }

                            //update shipping policy
                            //UpdatePostagePolicy(updateItem, updateInfo.ShippingPolicy);
                            
                            
                        }
                        else
                        {
                            updateItem.StartPrice.Value = Convert.ToDouble(data.Price.ToeBayCrazyMallPrice());
                            var elementPrice = descHtmlDoc.GetElementbyId("price");
                            WriteText(elementPrice, "$" + updateItem.StartPrice.Value.ToString());

                            //update shipping & delivery
                            var elementPostageDesc = descHtmlDoc.DocumentNode.SelectSingleNode("//*[@id='delivery']/p[3]");
                            var elementFreeFastIcon = descHtmlDoc.DocumentNode.SelectSingleNode("//*[@id='delivery']/img");
                            //Remove Free and Fast Icon

                            if(elementPostageDesc!=null)
                            {
                                if (data.Notes.Equals(string.Empty) && data.CategoryID == 1)//Bulky Item
                                {
                                    WriteText(elementPostageDesc, strBulkyItemFreight);
                                }
                                else if (data.Notes.Equals(string.Empty) && data.CategoryID == 0)
                                {
                                    WriteText(elementPostageDesc, strNotBulkyFreight);
                                }
                                else if (!data.Notes.Equals(string.Empty) && data.CategoryID == 0)
                                {
                                    WriteText(elementPostageDesc, strFreePostage);
                                }
                                else
                                {
                                    WriteText(elementPostageDesc, strBulkyFreePostage);
                                }
                            }

                            if (elementFreeFastIcon != null)
                            {
                                if (data.Notes.Equals(string.Empty))
                                {
                                    elementFreeFastIcon.Remove();
                                }
                            }

                            //updateItem.Description = descHtmlDoc.DocumentNode.OuterHtml;

                            //update shipping policy
                            if (data.Notes.Equals(string.Empty))
                            {
                                //UpdatePostagePolicy(updateItem, ECMShippingPolicy.Freight);
                            }


                            //update available qty
                            if (data.InventoryQty >= 50)
                                updateItem.Quantity = 10;
                            else if (data.InventoryQty >= 5 && data.InventoryQty < 50)
                                updateItem.Quantity = 5;
                            else
                                updateItem.Quantity = 0;


                            
                        }

                        StringCollection deletedFields = new StringCollection();
                        _reviseFixedPriceItemCall.ReviseFixedPriceItem(updateItem, deletedFields);
                        if (_reviseFixedPriceItemCall.ApiResponse.Ack != AckCodeType.Success)
                        { 
                            if(_reviseFixedPriceItemCall.ApiResponse.Errors!=null&&_reviseFixedPriceItemCall.ApiResponse.Errors.Count>0)
                                throw new Exception("SKU: "+data.SKU+" Error Message: "+ _reviseFixedPriceItemCall.ApiResponse.Errors[0].LongMessage);
                            else
                                throw new Exception("SKU: " + data.SKU + " Update Failed");
                        }
                            
                        
                    }
                    catch (Exception ex)
                    {
                        LogManager.Instance.Error(ex.ToString());
                    }

                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }


        public bool UpdateActiveListingInventory()
        {

            try
            {
                var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
                foreach (var data in datas)
                {
                    try
                    { 
                        var updateItem = new ItemType();
                        updateItem.ItemID = data.CustomID;
                        updateItem.Quantity = 0;// data.InventoryQty;
                        //var newDesc = data.Description.Replace("dealsplash", "ozcrazymall");
                        //updateItem.Description = newDesc;

                        StringCollection deletedFields = new StringCollection();
                        _reviseFixedPriceItemCall.ReviseFixedPriceItem(updateItem, deletedFields);
                        if (_reviseFixedPriceItemCall.ApiResponse.Ack != AckCodeType.Success)
                        {
                            if (_reviseFixedPriceItemCall.ApiResponse.Errors != null && _reviseFixedPriceItemCall.ApiResponse.Errors.Count > 0)
                                throw new Exception("SKU: " + data.SKU + " Error Message: " + _reviseFixedPriceItemCall.ApiResponse.Errors[0].LongMessage);
                            else
                                throw new Exception("SKU: " + data.SKU + " Update Failed");
                        }
                    }
                    catch (Exception ex)
                    {
                        LogManager.Instance.Error("ItemID:" + data.CustomID+ " " + ex.ToString());
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public class eBayUpdateModel
        {
            public string SKU { get; set; }
            public string Description { get; set; }
            public decimal Price { get; set; }
            public int Qty { get; set; }
            public string ShippingPolicy { get; set; }
        }

        public bool ListeBayItem(string sku="")
        {
            try 
            {
                var addFixedPriceItemCall = new AddFixedPriceItemCall(AutoPostAdConfig.Instance.eBayAPIContext);
                var item = new ItemType();


                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }


        public bool TestGetSellerList()
        {
            try
            {
                PaginationType pageInfo = new PaginationType();
                pageInfo.PageNumber = 1;
                pageInfo.EntriesPerPage = 50;
                _getSellerListCall.Pagination = pageInfo;
                
                //_getSellerListCall.SKUArrayList.Add("ATV-RAMPS-SR609-SINGLE");
                //_getSellerListCall.SKUArrayList.Add("OCHAIR-9174-WH");
                //_getSellerListCall.SKUArrayList.Add("AQ-SPH-6400");
                var datas = _autoPostAdPostDataService.GetAutoPostAdPostDataByAdTypeID(ChannelType.DropshipZone);
                
                var entriesPerPage=5000;
                var pageCount = Convert.ToInt32(Math.Ceiling(Convert.ToDecimal( datas.Count)/Convert.ToDecimal( entriesPerPage)));
                var pageNum = 1;
                var lstReturnListings = new List<ItemType>();
                do
                {
                    var pagedDatas = datas.Skip((pageNum - 1) * entriesPerPage).Take(entriesPerPage).ToList();
                    _getSellerListCall.SKUArrayList = new StringCollection();
                    foreach (var data in pagedDatas)
                    {
                        _getSellerListCall.SKUArrayList.Add(data.SKU.ToUpper());
                    }

                    //_getSellerListCall.StartTimeFrom = DateTime.Now.AddDays(-120).ToUniversalTime();
                    //_getSellerListCall.StartTimeTo = DateTime.Now.ToUniversalTime();

                    _getSellerListCall.EndTimeFrom =DateTime.Now.ToUniversalTime();
                    _getSellerListCall.EndTimeTo = DateTime.Now.AddDays(90).ToUniversalTime();

                    var items=_getSellerListCall.GetSellerList().ToArray();//only active listing will return
                    //foreach (var item in items)
                    //{
                    //    lstReturnListings.Add(item);
                    //}
                    //var validListing = items.Where(l=>!string.IsNullOrEmpty( l.SKU));
                    //foreach (var item in validListing)
                    //{
                    //    lstReturnListings.Add(item);
                    //}

                    var invalidListing = items.Where(l => l.ItemID == "261994331066" 
                        || l.ItemID == "262000775578"
                        || l.ItemID == "262044386505"
                        || l.ItemID == "261889669066"
                        || l.ItemID == "261889671863"
                        || l.ItemID == "261853470622"
                        || l.ItemID == "261969242285"
                        || l.ItemID == "261969434722"
                        || l.ItemID == "261969434723");
                    foreach (var item in invalidListing)
                    {
                        lstReturnListings.Add(item);
                    }
                    pageNum++;
                } while (pageNum <= pageCount);



                return true;
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
                return false;
            }
        }

        public void TestBatteryExpertService()
        {
            var sessionID = _batteryexpertService.login("jim0519", "abc.123");
            try
            {
                var paraFilters = new filters();
                var lstFilters = new List<associativeEntity>();

                lstFilters.Add(new associativeEntity() { key = "sku", value = "SCALE-BFAT-WH" });
                paraFilters.filter = lstFilters.ToArray();
            }

            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.ToString());
            }
            finally
            {
                _batteryexpertService.endSession(sessionID);
            }

        }

        #endregion

        #region Private Method

        private string GetExactPathName(string pathName)
        {
            if (!(File.Exists(pathName) || Directory.Exists(pathName)))
                return pathName;

            var di = new DirectoryInfo(pathName);

            if (di.Parent != null)
            {
                return Path.Combine(
                    GetExactPathName(di.Parent.FullName),
                    di.Parent.GetFileSystemInfos(di.Name)[0].Name);
            }
            else
            {
                return di.Name.ToUpper();
            }
        }

        private string GetOnlyFileNameByFullName(string fileFullName)
        {
            return fileFullName.Substring(fileFullName.LastIndexOf("\\") + 1, fileFullName.Length - (fileFullName.LastIndexOf("\\") + 1));
        }

        private void LoopCategories(catalogCategoryEntity category)
        {
            foreach (var childCateogory in category.children)
            {
                if (childCateogory.children.Count() > 0)
                {
                    LoopCategories(childCateogory);
                }

                InsertOrUpdateDropshipZoneCategory(childCateogory);
            }

        }

        private void InsertOrUpdateDropshipZoneCategory(catalogCategoryEntity category)
        {
            var productCategory = _autoPostAdPostDataService.GetProductCategory(category.category_id.ToString(), Common.CategoryType.DropshipZone);
            if (productCategory == null)
                productCategory = new ProductCategory();

            productCategory.CategoryID = category.category_id.ToString();
            productCategory.CategoryName = category.name;
            productCategory.ParentCategoryID = category.parent_id == 0 ? category.category_id.ToString() : category.parent_id.ToString();
            productCategory.Status = (category.is_active == 1 ? Status.Active : Status.Deleted);

            productCategory.CategoryTypeID = Common.CategoryType.DropshipZone;
            productCategory.TemplateID = 1;

            if (productCategory.ID == 0)
                _autoPostAdPostDataService.InsertProductCategory(productCategory);
            else
                _autoPostAdPostDataService.UpdateProductCategory(productCategory);
        }

        private string GetQuickSaleImagesPath(string sku)
        {
            var imageURLConstString = "http://www.dropshipzone.com.au/media/catalog/product/{0}/{1}/{2}.jpg";
            var firstArg = sku.Substring(0, 1);
            var secondArg = sku.Substring(1, 1);
            var lstImagesPath = new List<string>();

            bool hasCompleteDownLoad = false;
            int i = 0;

            using (var wc = new HeadOnlyWebClient())
            {
                while (!hasCompleteDownLoad)
                {
                    //while (has1000Size)
                    //{
                    bool has500Size = true;
                    bool has1000Size = true;
                    bool hasDefaultSize = true;

                    var imageFileName = sku + "-" + i.ToString().PadLeft(2, '0') + "{0}";
                    //var saveImageFileFullName = di.FullName + string.Format(imageFileName, ".jpg");
                    var addListImageFileName = sku + "\\" + string.Format(imageFileName, ".jpg");

                    var DownloadPath1000SizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "_1").ToLowerInvariant());
                    var DownloadPath500SizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "_5").ToLowerInvariant());
                    var DownloadPathDefaultSizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "").ToLowerInvariant());

                    var DownloadPath1000SizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "_1").ToUpperInvariant());
                    var DownloadPath500SizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "_5").ToUpperInvariant());
                    var DownloadPathDefaultSizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "").ToUpperInvariant());
                    //if (!File.Exists(saveImageFileFullName))
                    //{
                        try
                        {
                            wc.DownloadData(DownloadPath1000SizeLower);
                            lstImagesPath.Add(DownloadPath1000SizeLower);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has1000Size = false;
                        }

                        try
                        {
                            wc.DownloadData(DownloadPath1000SizeUpper);
                            lstImagesPath.Add(DownloadPath1000SizeUpper);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has1000Size = false;
                        }




                        try
                        {
                            wc.DownloadData(DownloadPath500SizeLower);
                            lstImagesPath.Add(DownloadPath500SizeLower);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has500Size = false;
                        }

                        try
                        {
                            wc.DownloadData(DownloadPath500SizeUpper);
                            lstImagesPath.Add(DownloadPath500SizeUpper);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has500Size = false;
                        }





                        try
                        {
                            wc.DownloadData(DownloadPathDefaultSizeLower);
                            lstImagesPath.Add(DownloadPathDefaultSizeLower);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            hasDefaultSize = false;
                        }

                        try
                        {
                            wc.DownloadData(DownloadPathDefaultSizeUpper);
                            lstImagesPath.Add(DownloadPathDefaultSizeUpper);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            hasDefaultSize = false;
                        }

                        if (!has1000Size && !has500Size && !hasDefaultSize)
                            hasCompleteDownLoad = true;
                    //}
                    //else
                    //{
                    //    lstImagesPath.Add(addListImageFileName);
                    //}
                    i++;

                }
            }

            var imagesPath = (lstImagesPath.Count > 0 ? lstImagesPath.Aggregate((current, next) => current + ";" + next) : string.Empty);
            return imagesPath;
        }

        private string GetImagesPath(string sku)
        {
            //var imageWithSizeURLConstString = "http://www.dropshipzone.com.au/media/catalog/product/{0}/{1}/{2}_{3}.jpg";
            var imageURLConstString = "http://www.dropshipzone.com.au/media/catalog/product/{0}/{1}/{2}.jpg";
            var firstArg = sku.Substring(0, 1);
            var secondArg = sku.Substring(1, 1);
            var lstImagesPath = new List<string>();
            
            DirectoryInfo di = new DirectoryInfo(AutoPostAdConfig.Instance.ImageFilesPath+sku+"\\");
            if (!di.Exists)
            {
                di.Create();
            }
            
            //see if there is 1000x1000 pixels 
            
            bool hasCompleteDownLoad = false;
            int i = 0;
            using (var wc = new WebClient())
            {
                while (!hasCompleteDownLoad)
                {
                    //while (has1000Size)
                    //{
                    bool has500Size = true;
                    bool has1000Size = true;
                    bool hasDefaultSize = true;

                    var imageFileName = sku + "-" + i.ToString().PadLeft(2, '0') + "{0}";
                    var saveImageFileFullName = di.FullName + string.Format(imageFileName, ".jpg");
                    var addListImageFileName = sku + "\\" + string.Format(imageFileName, ".jpg");

                    var DownloadPath1000SizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "_1").ToLowerInvariant());
                    var DownloadPath500SizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "_5").ToLowerInvariant());
                    var DownloadPathDefaultSizeLower = string.Format(imageURLConstString, firstArg.ToLowerInvariant(), secondArg.ToLowerInvariant(), string.Format(imageFileName, "").ToLowerInvariant());

                    var DownloadPath1000SizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "_1").ToUpperInvariant());
                    var DownloadPath500SizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "_5").ToUpperInvariant());
                    var DownloadPathDefaultSizeUpper = string.Format(imageURLConstString, firstArg.ToUpperInvariant(), secondArg.ToUpperInvariant(), string.Format(imageFileName, "").ToUpperInvariant());
                    if (!File.Exists(saveImageFileFullName))
                    {
                        try
                        {
                            wc.DownloadFile(DownloadPath1000SizeLower, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has1000Size = false;
                        }

                        try
                        {
                            wc.DownloadFile(DownloadPath1000SizeUpper, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has1000Size = false;
                        }




                        try
                        {
                            wc.DownloadFile(DownloadPath500SizeLower, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has500Size = false;
                        }

                        try
                        {
                            wc.DownloadFile(DownloadPath500SizeUpper, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            has500Size = false;
                        }





                        try
                        {
                            wc.DownloadFile(DownloadPathDefaultSizeLower, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            hasDefaultSize = false;
                        }

                        try
                        {
                            wc.DownloadFile(DownloadPathDefaultSizeUpper, saveImageFileFullName);
                            lstImagesPath.Add(addListImageFileName);
                            i++;
                            continue;
                        }
                        catch (WebException wex)
                        {
                            hasDefaultSize = false;
                        }

                        if (!has1000Size && !has500Size && !hasDefaultSize)
                            hasCompleteDownLoad = true;
                    }
                    else
                    {
                        lstImagesPath.Add(addListImageFileName);
                    }
                    i++;

                }
            }

            ////see if there is 500x500 pixels 
            //bool has500Size = true;
            //i = 0;
            //if (!hasCompleteDownLoad)
            //{
            //    while (has500Size)
            //    {
            //        try
            //        {
            //            var imageFileName = sku + "-" + i.ToString().PadLeft(2, '0') + "{0}";
            //            var saveImageFileFullName = di.FullName + string.Format(imageFileName, ".jpg");
            //            if (!File.Exists(saveImageFileFullName))
            //            {
            //                wc.DownloadFile(string.Format(imageURLConstString, firstArg, secondArg, string.Format(imageFileName, "_5")), saveImageFileFullName);
            //            }
            //            lstImagesPath.Add(sku + "\\" + string.Format(imageFileName, ".jpg"));
            //            hasCompleteDownLoad = true;
            //        }
            //        catch (WebException wex)
            //        {
            //            if (((HttpWebResponse)wex.Response).StatusCode == HttpStatusCode.NotFound)
            //            {
            //                has500Size = false;
            //            }
            //        }
            //        i++;
            //    }
            //}

            ////see if there is default size
            //bool hasDefaultSize = true;
            //i = 0;
            //if (!hasCompleteDownLoad)
            //{
            //    while (hasDefaultSize)
            //    {
            //        try
            //        {
            //            var imageFileName = sku + "-" + i.ToString().PadLeft(2, '0') + "{0}";
            //            var saveImageFileFullName = di.FullName + string.Format(imageFileName, ".jpg");
            //            if (!File.Exists(saveImageFileFullName))
            //            {
            //                wc.DownloadFile(string.Format(imageURLConstString, firstArg, secondArg,imageFileName), saveImageFileFullName);
            //            }
            //            lstImagesPath.Add(sku + "\\" + string.Format(imageFileName, ".jpg"));
            //            hasCompleteDownLoad = true;
            //        }
            //        catch (WebException wex)
            //        {
            //            if (((HttpWebResponse)wex.Response).StatusCode == HttpStatusCode.NotFound)
            //            {
            //                hasDefaultSize = false;
            //            }
            //        }
            //        i++;
            //    }
            //}

            var imagesPath =(lstImagesPath.Count>0? lstImagesPath.Aggregate((current, next) => current + ";" + next):string.Empty);
            return imagesPath;

        }


        private string ApplyDataToTemplate(AutoPostAdPostData ad)
        {
            if (string.IsNullOrEmpty(ad.Description))
                return string.Empty;
            var htmlDoc = new HtmlDocument();
            htmlDoc.LoadHtml(ad.Description);
            var allNodes = htmlDoc.DocumentNode.DescendantsAndSelf();
            var firstP = allNodes.Where(n => n.Name.Equals("p")).FirstOrDefault();
            //foreach (var node in allNodes)
            //{ 

            //}
            var descNodes = new List<HtmlNode>();
            var featureNodes = new List<HtmlNode>();
            var pkgContentNodes = new List<HtmlNode>();

            var descContent = "";
            var featureContent = "";
            var pkgContentContent = "";

            if (firstP == null)
                return string.Empty;

            descNodes.Add(firstP);
            descContent += firstP.OuterHtml;
            var anchorNode = firstP;
            var i = 1;
            while (anchorNode.NextSibling != null)
            {
                var nextSibling = anchorNode.NextSibling;
                var nextSiblingDescendants = nextSibling.DescendantsAndSelf();

                if ((nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("features")&&n.ParentNode!=null&&n.ParentNode.Name.Equals("strong")).FirstOrDefault() != null )||
                    (nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("content") && n.ParentNode != null && n.ParentNode.Name.Equals("strong")).FirstOrDefault() != null))
                {
                    i++;
                }

                if (i == 1)
                {
                    descNodes.Add(nextSibling);
                    descContent += nextSibling.OuterHtml;
                }
                else if (i == 2)
                {
                    if (nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("features") && n.Name.Equals("#text") && n.ParentNode != null && n.ParentNode.Name.Equals("strong")).FirstOrDefault() != null)
                    {
                        var removeNode = nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("features") && n.Name.Equals("#text") && n.ParentNode != null && n.ParentNode.Name.Equals("strong")).FirstOrDefault();
                        removeNode.Remove();
                        
                    }
                    featureNodes.Add(nextSibling);
                    featureContent += nextSibling.OuterHtml;
                    
                }
                else if (i == 3)
                {
                    if (nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("content") && n.Name.Equals("#text") && n.ParentNode != null && n.ParentNode.Name.Equals("strong")).FirstOrDefault() != null)
                    {
                        var removeNode = nextSiblingDescendants.Where(n => n.InnerHtml.ToLowerInvariant().Contains("content") && n.Name.Equals("#text") && n.ParentNode != null && n.ParentNode.Name.Equals("strong")).FirstOrDefault();
                        removeNode.Remove();
                    }

                    pkgContentNodes.Add(nextSibling);
                    pkgContentContent += nextSibling.OuterHtml;
                    
                    
                }
                anchorNode = nextSibling;
            }

            //var templateHtml = File.ReadAllText(@"F:\Jim\Own\LearningDoc\eBayTemplate\nautica-05\indexWithoutRelatedItems.htm");
            //htmlDoc.Load(@"F:\Jim\Own\LearningDoc\eBayTemplate\nautica-05\indexWithoutRelatedItems.html");
            if (!ad.Notes.Equals(string.Empty) && ad.CategoryID == 0)
            {
                htmlDoc.Load(@"C:\Users\Administrator\Desktop\ToRay\index.html");
            }
            else if (!ad.Notes.Equals(string.Empty) && ad.CategoryID == 1)
            {
                htmlDoc.Load(@"C:\Users\Administrator\Desktop\ToRay\indexBulkyItemFreeShipping.html");
            }
            else if (ad.Notes.Equals(string.Empty) && ad.CategoryID == 0)
            {
                htmlDoc.Load(@"C:\Users\Administrator\Desktop\ToRay\indexFreightNotBulkyItem.html");
            }
            else
            {
                htmlDoc.Load(@"C:\Users\Administrator\Desktop\ToRay\indexBulkyItem.html");
            }
            
            allNodes = htmlDoc.DocumentNode.DescendantsAndSelf();
            var titleNode = allNodes.Where(n => n.Id.Equals("title")).FirstOrDefault();
            var priceNode = allNodes.Where(n => n.Id.Equals("price")).FirstOrDefault();
            var descriptionNode = allNodes.Where(n => n.Id.Equals("description")).FirstOrDefault();
            var featureNode = allNodes.Where(n => n.Id.Equals("feature")).FirstOrDefault();
            var pkgContentNode = allNodes.Where(n => n.Id.Equals("pkgContent")).FirstOrDefault();
            var skuHiddenNode = allNodes.Where(n => n.Id.Equals("SKU")).FirstOrDefault();

            titleNode.InnerHtml = ad.Title;
            skuHiddenNode.InnerHtml = ad.SKU.ToUpper();
            priceNode.InnerHtml ="$"+ ad.Price.ToString();
            descriptionNode.InnerHtml = descContent;
            featureNode.InnerHtml = featureContent;
            pkgContentNode.InnerHtml = pkgContentContent;
            

            //var imgPathList = new List<string>();
            //var imgPathPrefix = @"file:///F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\NewAdImages\";
            var imgPathPrefix = @"http://www.dealsplash.com.au/eBayMaterial/images/ProductImage/";
            var imgPathSurfixList = ad.ImagesPath.Split(';');
            var imgPathList = imgPathSurfixList.Select(s => imgPathPrefix + s.Replace('\\','/'));

            var bigImgNode = allNodes.Where(n => n.Id.Equals("imgBigImage")).FirstOrDefault();
            var imgListNode = allNodes.Where(n => n.Id.Equals("imgList")).FirstOrDefault();
            var imgListItem = "<a><img class=\"border\" onmouseover=\"DisplayInBigImage(this)\" src=\"{0}\" /></a>";
            var imgListHtml = "";
            foreach (var imgPath in imgPathList)
            {
                imgListHtml += string.Format(imgListItem, imgPath);
            }

            imgListNode.InnerHtml = imgListHtml;
            //bigImgNode.Attributes["src"] = "<img id=\"imgBigImage\" src=\"" + imgPathList.FirstOrDefault() + "\" style=\"width:400px;height:400px; border:solid 1px #c9c9c9; display:block;\" />";
            bigImgNode.Attributes["src"].Value =  imgPathList.FirstOrDefault() ;

            return htmlDoc.DocumentNode.OuterHtml;


            //var descAfterApplyingTemplate = "";
            //return descAfterApplyingTemplate;
        }



        private void DirectoryCopy(string sourceDir, string destDir, bool copySubDirs)
        {
            DirectoryInfo dir = new DirectoryInfo(sourceDir);
            DirectoryInfo[] dirs = dir.GetDirectories();

            // If the source directory does not exist, throw an exception.
            if (!dir.Exists)
            {
                throw new DirectoryNotFoundException(
                    "Source directory does not exist or could not be found: "
                    + sourceDir);
            }

            // If the destination directory does not exist, create it.
            if (!Directory.Exists(destDir))
            {
                Directory.CreateDirectory(destDir);
            }


            // Get the file contents of the directory to copy.
            FileInfo[] files = dir.GetFiles();

            foreach (FileInfo file in files)
            {
                // Create the path to the new copy of the file.
                string temppath = Path.Combine(destDir, file.Name);

                // Copy the file.
                file.CopyTo(temppath, false);
            }

            // If copySubDirs is true, copy the subdirectories.
            if (copySubDirs)
            {

                foreach (DirectoryInfo subdir in dirs)
                {
                    // Create the subdirectory.
                    string temppath = Path.Combine(destDir, subdir.Name);

                    // Copy the subdirectories.
                    DirectoryCopy(subdir.FullName, temppath, copySubDirs);
                }
            }
        }

        private void WriteText(HtmlNode node, string text)
        {
            if (node.ChildNodes.Count > 0)
            {
                node.ReplaceChild(node.OwnerDocument.CreateTextNode(text), node.ChildNodes.First());
            }
            else
            {
                node.AppendChild(node.OwnerDocument.CreateTextNode(text));
            }
        }



        private void UpdatePostagePolicy(ItemType updateItem, string strECMShippingPolicy)
        {
            if (strECMShippingPolicy == ECMShippingPolicy.Freight)
            {
                updateItem.ShippingDetails = new ShippingDetailsType();
                updateItem.ShippingDetails.ShippingServiceOptions = new ShippingServiceOptionsTypeCollection();

                var shippingServiceOption = new ShippingServiceOptionsType();
                shippingServiceOption.FreeShipping = false;
                shippingServiceOption.FreeShippingSpecified = true;
                shippingServiceOption.ShippingService = "AU_Freight";

                updateItem.ShippingDetails.ShippingServiceOptions.Add(shippingServiceOption);

                updateItem.ShippingDetails.GlobalShipping = false;
                updateItem.ShippingDetails.ShippingType = ShippingTypeCodeType.Freight;
                //updateItem.ShippingDetails.ExcludeShipToLocation = new StringCollection(new string[] { "Northern Territory", "QLD Regional", "QLD Far North", "WA Regional", "WA Remote" });
                updateItem.ShippingDetails.ExcludeShipToLocation = new StringCollection(new string[] { "NONE" });
            }
        }


       

        #endregion


        public void TestNCalc()
        {

            var LastSuccessTime = Convert.ToDateTime("2016-07-04 05:01:25.257");
            var nowTime = Convert.ToDateTime("2016-07-04 08:01:25.257");
            var elaspDays = (nowTime.Date-LastSuccessTime.Date).TotalDays;
            if (elaspDays % 2 == 0)
            {
                var nowTimeTime = nowTime.TimeOfDay;
            }


            //var nowTime = DateTime.Now.TimeOfDay;
            //var ts1 = TimeSpan.FromDays(0);
            ////var nowTimePlusDay = nowTime.Add(ts1);
            //var timeRangeFrom = Convert.ToDateTime("2016-02-05 17:00:00.000").TimeOfDay;
            //var timeRangeFromPlusDay = timeRangeFrom.Add(ts1);
            //if (timeRangeFromPlusDay > nowTime)
            //{ 
                
            //}

            var datas = _autoPostAdPostDataService.GetCustomAutoPostAdPostData();
            
            foreach (var data in datas)
            {
                //var formula = "Abs(Ceiling((" + data.nameof(x => x.Price) + "+Abs(0.3))/Abs(0.774)))-Abs(0.05)";
                var formula = "10";
                var list = new List<KeyValuePair<string, object>>();
                var paramKeyValue = new KeyValuePair<string, object>(data.nameof(x => x.Price),data.Price);
                list.Add(paramKeyValue);
                var eBayPrice = CommonFunction.EvaluateFormula(list, formula);
                var deceBayPrice = Convert.ToDecimal( eBayPrice);
                
            }


        }

        public void ConvertBatteryExpertData()
        {
            var origData = _autoPostAdPostDataService.GetBatteryExpertGumtreeData();
            foreach (var data in origData)
            {
                var ad = new AutoPostAdPostData();
                ad.SKU = data.MPN.Trim();
                ad.Title =(data.title.Length>65? data.title.Substring(0,65):data.title);
                ad.Price = Convert.ToDecimal(data.sale_price);
                ad.CategoryID = 293;
                ad.InventoryQty = 0;
                ad.AddressID = 2;
                ad.AccountID = 1;
                ad.CustomFieldGroupID = 1;
                ad.BusinessLogoPath = string.Empty;
                ad.CustomID = data.id.ToString();
                ad.Status = "D";
                ad.Postage = 0;
                ad.Notes = string.Empty;
                ad.AdTypeID = 12;
                ad.ScheduleRuleID = 1;
                //TODO
                ad.Description = data.description.StripHTML();

                DirectoryInfo di = new DirectoryInfo(AutoPostAdConfig.Instance.ImageFilesPath + ad.SKU + "\\");
                if (!di.Exists)
                {
                    di.Create();
                }
                using (var wc = new WebClient())
                {
                    try
                    {
                        var imageFileName = "1.jpg";
                        var saveImageFileFullName = Path.Combine(di.FullName, imageFileName);

                        wc.DownloadFile(data.image_link, saveImageFileFullName);
                        ad.ImagesPath = "\\" + ad.SKU + "\\" + imageFileName;
                    }
                    catch (Exception ex)
                    {
                        LogManager.Instance.Error(data.image_link + " download failed. " + ex.Message);
                        ad.ImagesPath = string.Empty;
                    }
                }

                _autoPostAdPostDataService.InsertAutoPostAdPostData(ad);

            }
        }

        public void TestNetwork()
        {
            LogManager.Instance.Error("Test email sending");

            var networkManager = new NetworkManagement();
            var nicNames = networkManager.GetNICNames();
            networkManager.setIP("192.168.1.220", "255.255.255.0");
            networkManager.setGateway("192.168.1.1");
            foreach(var nicName in nicNames)
            {
                
            }
            //networkManager.setDNS()
            while (!networkManager.IsNetworkAvailable())
            {
                Thread.Sleep(5000);
            }

        }

        public void TestInheritance()
        {
            var cb = new ClassB();
            cb.MethodX();
            Console.ReadLine();
        }
    }


    public class NetworkManagement
    {
        /// <summary>
        /// Set's a new IP Address and it's Submask of the local machine
        /// </summary>
        /// <param name="ip_address">The IP Address</param>
        /// <param name="subnet_mask">The Submask IP Address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setIP(string ip_address, string subnet_mask)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    try
                    {
                        ManagementBaseObject setIP;
                        ManagementBaseObject newIP =
                            objMO.GetMethodParameters("EnableStatic");

                        newIP["IPAddress"] = new string[] { ip_address };
                        newIP["SubnetMask"] = new string[] { subnet_mask };

                        setIP = objMO.InvokeMethod("EnableStatic", newIP, null);
                    }
                    catch (Exception)
                    {
                        throw;
                    }


                }
            }
        }
        /// <summary>
        /// Set's a new Gateway address of the local machine
        /// </summary>
        /// <param name="gateway">The Gateway IP Address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setGateway(string gateway)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    try
                    {
                        ManagementBaseObject setGateway;
                        ManagementBaseObject newGateway =
                            objMO.GetMethodParameters("SetGateways");

                        newGateway["DefaultIPGateway"] = new string[] { gateway };
                        newGateway["GatewayCostMetric"] = new int[] { 1 };

                        setGateway = objMO.InvokeMethod("SetGateways", newGateway, null);
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                }
            }
        }
        /// <summary>
        /// Set's the DNS Server of the local machine
        /// </summary>
        /// <param name="NIC">NIC address</param>
        /// <param name="DNS">DNS server address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setDNS(string NIC, string DNS)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    // if you are using the System.Net.NetworkInformation.NetworkInterface you'll need to change this line to if (objMO["Caption"].ToString().Contains(NIC)) and pass in the Description property instead of the name 
                    if (objMO["Caption"].Equals(NIC))
                    {
                        try
                        {
                            ManagementBaseObject newDNS =
                                objMO.GetMethodParameters("SetDNSServerSearchOrder");
                            newDNS["DNSServerSearchOrder"] = DNS.Split(',');
                            ManagementBaseObject setDNS =
                                objMO.InvokeMethod("SetDNSServerSearchOrder", newDNS, null);
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Set's WINS of the local machine
        /// </summary>
        /// <param name="NIC">NIC Address</param>
        /// <param name="priWINS">Primary WINS server address</param>
        /// <param name="secWINS">Secondary WINS server address</param>
        /// <remarks>Requires a reference to the System.Management namespace</remarks>
        public void setWINS(string NIC, string priWINS, string secWINS)
        {
            ManagementClass objMC = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection objMOC = objMC.GetInstances();

            foreach (ManagementObject objMO in objMOC)
            {
                if ((bool)objMO["IPEnabled"])
                {
                    if (objMO["Caption"].Equals(NIC))
                    {
                        try
                        {
                            ManagementBaseObject setWINS;
                            ManagementBaseObject wins =
                            objMO.GetMethodParameters("SetWINSServer");
                            wins.SetPropertyValue("WINSPrimaryServer", priWINS);
                            wins.SetPropertyValue("WINSSecondaryServer", secWINS);

                            setWINS = objMO.InvokeMethod("SetWINSServer", wins, null);
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        public bool IsNetworkAvailable()
        {
            //return System.Net.NetworkInformation.NetworkInterface.GetIsNetworkAvailable();
            try
            {
                Ping myPing = new Ping();
                String host = "www.google.com.au";
                byte[] buffer = new byte[32];
                int timeout = 1000;
                PingOptions pingOptions = new PingOptions();
                PingReply reply = myPing.Send(host, timeout, buffer, pingOptions);
                if (reply.Status == IPStatus.Success)
                {
                    return true;
                }
                return false;
            }
            catch (PingException pex)
            {
                return false;
            }

            
        }

        public List<object> GetNICNames()
        {
            var nicNames = new List<object>();

            ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection moc = mc.GetInstances();

            foreach (ManagementObject mo in moc)
            {
                if ((bool)mo["ipEnabled"])
                {
                    nicNames.Add(mo["Caption"]);
                }
            }

            return nicNames;
        }

        

        
    }

    public class ClassA
    {
        public virtual void MethodX()
        {
            MethodY(); 
        }

        protected virtual void MethodY()
        {
            Console.WriteLine("Protect Method Parent Y"); 
        }
    }

    public class ClassB : ClassA
    {
        public override void MethodX()
        {
            base.MethodX();

            MethodY();
        }

        protected new void MethodY()
        {
            Console.WriteLine("Protect Method Child Y");
        }
    }
}
