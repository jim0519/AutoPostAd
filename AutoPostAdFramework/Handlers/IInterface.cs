using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using AutoPostAdData.Models;
using AutoPostAdBusiness.BusinessModels;
using Common.Models.XML;
using Common;

namespace AutoPostAdBusiness.Handlers
{
    #region Website Interface
    public interface IWebsite<T>
    {
        bool PostAd(T postAdData);

        bool DeleteAd(T postAdData);
    }

    public interface INotifyPost<T>
    {
        event EventHandler<BusinessObjectEventArgs<T>> PostComplete;

        event EventHandler<BusinessObjectEventArgs<T>> DeleteAdComplete;
    }

    public interface IListAdAutoPostAdPostDataBMWebsite : IWebsite<IEnumerable<AutoPostAdPostDataBM>>, INotifyPost<AutoPostAdPostDataBM>
    {
        bool GetCookies(IEnumerable<AutoPostAdPostDataBM> adData);
    }

    public interface IListAdQuickSalePostAdPostDataBMWebsite : IWebsite<IEnumerable<QuickSalePostAdPostDataBM>>, INotifyPost<QuickSalePostAdPostDataBM>
    {
        bool RelistAd(IEnumerable<QuickSalePostAdPostDataBM> reviseData);
        bool ReviseInfo(IEnumerable<QuickSalePostAdPostDataBM> reviseData);
    }
    #endregion

    #region API Client Interface

    public interface IAPIClient
    {
        RP GetAPIRequest<RQ, RP>(RQ request);
    }

    public interface IQuickSaleAPIClient : IAPIClient
    { 
    
    }

    //public abstract class APIRequest
    //{
    
    //}

    //public abstract class APIResponse
    //{
    
    //}

    #endregion
}
