using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;
using Common.Models;
using Common;
using System.Data.SqlClient;
using System.Data;

namespace AutoPostAdBusiness.Services
{
    public class AutoPostAdPostDataService : IAutoPostAdPostDataService 
    {

        #region Fields

        private readonly IRepository<AutoPostAdPostData> _autoPostAdPostDataRepository;
        private readonly IRepository<AutoPostAdResult> _autoPostAdResultRepository;
        private readonly IRepository<ProductCategory> _productCategoryRepository;
        private readonly IRepository<ScheduleRule> _scheduleRuleRepository;
        private readonly IDbContext _dbContext;

        #endregion

        #region Ctor

        public AutoPostAdPostDataService(IRepository<AutoPostAdPostData> autoPostAdPostDataRepository,
            IRepository<AutoPostAdResult> autoPostAdResultRepository,
            IRepository<ProductCategory> productCategoryRepository,
            IRepository<ScheduleRule> scheduleRuleRepository,
            IDbContext dbContext)
        {
            this._autoPostAdPostDataRepository = autoPostAdPostDataRepository;
            this._autoPostAdResultRepository = autoPostAdResultRepository;
            _scheduleRuleRepository = scheduleRuleRepository;
            _productCategoryRepository = productCategoryRepository;
            _dbContext = dbContext;
        }

        #endregion

        #region IGumtreePostDataService Members

        public AutoPostAdPostData GetAutoPostAdPostDataByID(int ID)
        {
            if (ID == 0)
                return null;

            return _autoPostAdPostDataRepository.GetById(ID);
        }

        public IList<AutoPostAdPostData> GetAllAutoPostAdPostData()
        {
            var adTypeID = ChannelType.Gumtree;
            if (AutoPostAdConfig.Instance.ChannelType == ChannelType.GumtreeSydney.ToString() || AutoPostAdConfig.Instance.ChannelType == ChannelType.QuickSalesSydney.ToString())
                adTypeID = ChannelType.GumtreeSydney;
            else if (AutoPostAdConfig.Instance.ChannelType == ChannelType.GumtreeNopcommerce.ToString())
                adTypeID = ChannelType.GumtreeNopcommerce;
            var data = _autoPostAdPostDataRepository.Table.Where(x => x.AdTypeID == adTypeID && x.Status.Equals(Status.Active));
            return data.ToList();
        }

        public IList<AutoPostAdPostData> GetAllQuickSaleAutoPostAdPostData()
        {
            var adTypeID = ChannelType.QuickSales;
            if (AutoPostAdConfig.Instance.ChannelType == ChannelType.GumtreeSydney.ToString() || AutoPostAdConfig.Instance.ChannelType == ChannelType.QuickSalesSydney.ToString())
                adTypeID = ChannelType.QuickSalesSydney;
            var data = _autoPostAdPostDataRepository.Table.Where(x => x.AdTypeID == adTypeID && x.Status.Equals(Status.Active) && x.CategoryID != 0);
            return data.ToList();
        }

        public void InsertAutoPostAdPostData(AutoPostAdPostData gumtreePostData)
        {
            if (gumtreePostData == null)
                throw new ArgumentNullException("gumtreePostData");

            _autoPostAdPostDataRepository.Insert(gumtreePostData);
        }

        public void UpdateAutoPostAdPostData(AutoPostAdPostData gumtreePostData)
        {
            if (gumtreePostData == null)
                throw new ArgumentNullException("gumtreePostData");

            _autoPostAdPostDataRepository.Update(gumtreePostData);
        }

        public void DeleteAutoPostAdPostData(AutoPostAdPostData gumtreePostData)
        {
            if (gumtreePostData == null)
                throw new ArgumentNullException("gumtreePostData");

            _autoPostAdPostDataRepository.Delete(gumtreePostData);
        }

        public void DeleteAutoPostResult(AutoPostAdResult result)
        {
            if (result == null)
                throw new ArgumentNullException("result");

            _autoPostAdResultRepository.Delete(result);
        }



        #endregion

        #region IAutoPostAdPostDataService Members


        public ProductCategory GetProductCategory(string categoryID, int categoryTypeID)
        {
            var query = _productCategoryRepository.Table.FirstOrDefault(c => c.CategoryID == categoryID && c.CategoryTypeID == categoryTypeID);
            return query;
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public AutoPostAdPostData GetAutoPostAdPostDataByCustomIDAdTypeID(string customID,int adTypeID)
        {
            var query = _autoPostAdPostDataRepository.Table.FirstOrDefault(a => a.CustomID == customID&&a.AdTypeID==adTypeID);
            //var query=from data in _autoPostAdPostDataRepository.Table
            //          join category in _productCategoryRepository.Table on data.CategoryID equals category.ID
            //          where data.SKU==sku && category.CategoryTypeID==CategoryType.eBay

            return query;
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public AutoPostAdPostData GetAutoPostAdPostDataBySKUAdTypeID(string sku, int adTypeID)
        {
            //var query = from data in _autoPostAdPostDataRepository.Table
            //            join cat in _productCategoryRepository.Table on data.CategoryID equals cat.ID
            //            where data.SKU == sku && cat.CategoryTypeID == categoryTypeID
            //            select data;

            var query = _autoPostAdPostDataRepository.Table.Where(d=>d.SKU==sku && d.AdTypeID==adTypeID);

            return query.FirstOrDefault();
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public AutoPostAdPostData GetAutoPostAdPostDataByCustomIDSKU(string customID, string sku)
        {
            var query = _autoPostAdPostDataRepository.Table.FirstOrDefault(a => a.CustomID == customID&&a.SKU==sku);
            return query;
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public IList<AutoPostAdPostData> GetAutoPostAdPostDataByAdTypeID(int adTypeID, string status="")
        {
            //var p = new SqlParameter();
            //p.ParameterName = "AdTypeID";
            //p.Direction = ParameterDirection.Input;
            ////p.Size = 100;
            //p.DbType = DbType.Int32;
            //p.Value = adTypeID;
            
            //var sql = @"EXECUTE [dbo].[GetAutoPostAdPostDataByAdTypeID] @AdTypeID";
            //var query = _dbContext.SqlQuery<AutoPostAdPostData>(sql, p);

            var query = _autoPostAdPostDataRepository.Table.Where(d => d.AdTypeID == adTypeID);
            if(!string.IsNullOrEmpty(status))
                query = query.Where(d=>d.Status==status);
            return query.ToList();
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public void InsertProductCategory(ProductCategory categoryData)
        {
            if (categoryData == null)
                throw new ArgumentNullException("Null Cateogory Data.");

            _productCategoryRepository.Insert(categoryData);
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public void UpdateProductCategory(ProductCategory categoryData)
        {
            if (categoryData == null)
                throw new ArgumentNullException("Null Cateogory Data.");

            _productCategoryRepository.Update(categoryData);
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public IList<AutoPostAdPostData> GetCustomAutoPostAdPostData()
        {
            var sql = "select * from [dbo].[V_CustomAutoPostAdPostData]";
            var query = _dbContext.SqlQuery<AutoPostAdPostData>(sql);

            return query.ToList();
        }

        public IList<AutoPostAdBusiness.Handlers.DropshipController.ImagesData> GetImagesData()
        {
            var sql = "select * from [dbo].[V_GetImagesData]";
            var query = _dbContext.SqlQuery<AutoPostAdBusiness.Handlers.DropshipController.ImagesData>(sql);

            return query.ToList();
        }

        #endregion

        #region IAutoPostAdPostDataService Members


        public bool IsLeafCategory(string categoryID, int categoryTypeID)
        {
            var query = _productCategoryRepository.Table.Where(c => c.ParentCategoryID == categoryID && c.CategoryTypeID == categoryTypeID&&c.Status==Status.Active).FirstOrDefault();
            return query == null;
        }

        #endregion


        public IList<NopcommerceCategory> GetNopcommerceCategories()
        {
            var categories = _dbContext.SqlQuery<NopcommerceCategory>("select * from ozcrazym_Nopcommerce.dbo.Category");
            return categories.ToList();
        }


        public IList<NopcommerceCategory> GetMatchedNopcommerceCategories(string dropshizoneCategories)
        {
            var nopCats = _dbContext.SqlQuery<NopcommerceCategory>("select * from ozcrazym_Nopcommerce.dbo.Category where MetaKeywords in (" + dropshizoneCategories.Split(',').Aggregate((current, next) => "'" + current + "','" + next + "'") + ")");
            return nopCats.ToList();
        }


        public IList<AutoPostAdPostData> GetAutoPostAdPostDataByScheduleRuleID(int scheduleRuleID)
        {
            var takeCount=5;
            var query = _autoPostAdPostDataRepository.Table.Where(d => d.ScheduleRuleID == scheduleRuleID && d.Status == Status.Active).ToList();
            var scheduleRule = _scheduleRuleRepository.Table.FirstOrDefault(s => s.ID.Equals(scheduleRuleID));
            if (scheduleRule.Name.Contains("RollOver"))
            {
                var everyTimePostAds = query.Where(d => d.Notes.ToUpper().Equals("ALWAYS")).ToList();
                var updatePostAds = query.Where(d => d.Notes.ToUpper().Equals("UPDATE")).ToList();
                var delOnlyAds = query.Where(d => d.Notes.ToUpper().Equals("DELONLY")).ToList();
                var remainingAds = ((everyTimePostAds==null)?query.ToList():query.Where(d => !everyTimePostAds.Contains(d)).ToList());
                remainingAds = ((updatePostAds == null) ? remainingAds : remainingAds.Where(d => !updatePostAds.Contains(d)).ToList());
                remainingAds = ((delOnlyAds == null) ? remainingAds : remainingAds.Where(d => !delOnlyAds.Contains(d)).ToList());
                var remainingAdsCount = takeCount - ((everyTimePostAds == null) ? 0 : everyTimePostAds.Count()) - ((updatePostAds == null) ? 0 : updatePostAds.Count());
                if (remainingAdsCount <= 0)
                {
                    if (updatePostAds!=null&&updatePostAds.Count>0)
                        everyTimePostAds.InsertRange(0,updatePostAds); 
                    return everyTimePostAds;
                }

                var hasResultAds = remainingAds.Where(ad => ad.AutoPostAdResults.FirstOrDefault() != null);
                if (hasResultAds != null && hasResultAds.Count() > 0)
                {
                    //find latest posted ad
                    var latestAd = remainingAds.Where(ad => ad.AutoPostAdResults.FirstOrDefault() != null).OrderByDescending(ad => ad.AutoPostAdResults.FirstOrDefault().PostDate).FirstOrDefault();
                    remainingAds = remainingAds.TakeSkipWhileRollOver(ad => ad.ID <= latestAd.ID, remainingAdsCount).ToList();
                }
                else
                {
                    remainingAds = remainingAds.Take(remainingAdsCount).ToList(); 
                }
                if (delOnlyAds != null)
                    remainingAds.InsertRange(0, delOnlyAds);
                if (everyTimePostAds!=null)
                    remainingAds.InsertRange(0,everyTimePostAds);
                if (updatePostAds != null)
                    remainingAds.InsertRange(0, updatePostAds);
                return remainingAds;
            }
            return query;
        }
    }
}
