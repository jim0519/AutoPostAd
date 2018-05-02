using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using AutoPostAdData.Models;

namespace AutoPostAdBusiness.Services
{
    public interface IAutoPostAdPostDataService
    {
        #region AutoPostAdPostData

        AutoPostAdPostData GetAutoPostAdPostDataByID(int ID);

        IList<AutoPostAdPostData> GetAllAutoPostAdPostData();

        IList<AutoPostAdPostData> GetAllQuickSaleAutoPostAdPostData();

        void InsertAutoPostAdPostData(AutoPostAdPostData postData);

        void UpdateAutoPostAdPostData(AutoPostAdPostData postData);

        void DeleteAutoPostAdPostData(AutoPostAdPostData postData);

        void DeleteAutoPostResult(AutoPostAdResult result);

        AutoPostAdPostData GetAutoPostAdPostDataByCustomIDAdTypeID(string customID,int adTypeID);

        AutoPostAdPostData GetAutoPostAdPostDataByCustomIDSKU(string customID, string sku);

        AutoPostAdPostData GetAutoPostAdPostDataBySKUAdTypeID(string sku, int categoryTypeID);

        IList<AutoPostAdPostData> GetAutoPostAdPostDataByAdTypeID(int adTypeID,string status="");

        IList<AutoPostAdPostData> GetCustomAutoPostAdPostData();

        IList<AutoPostAdBusiness.Handlers.DropshipController.ImagesData> GetImagesData();

        IList<AutoPostAdPostData> GetAutoPostAdPostDataByScheduleRuleID(int scheduleRuleID);

        #endregion

        #region ProductCategory

        void InsertProductCategory(ProductCategory categoryData);

        void UpdateProductCategory(ProductCategory categoryData);

        ProductCategory GetProductCategory(string categoryID, int categoryTypeID);

        bool IsLeafCategory(string categoryID, int categoryTypeID);

        #endregion

        IList<NopcommerceCategory> GetNopcommerceCategories();

        IList<NopcommerceCategory> GetMatchedNopcommerceCategories(string dropshizoneCategories);

        string[] GetRedownloadImageSKUList();
    }
}
