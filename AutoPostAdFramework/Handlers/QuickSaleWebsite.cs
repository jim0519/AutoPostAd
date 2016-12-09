using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models.XML;
using AutoPostAdBusiness.BusinessModels;
using Common;

namespace AutoPostAdBusiness.Handlers
{
    public class QuickSaleWebsite : IListAdQuickSalePostAdPostDataBMWebsite
    {
        private readonly IQuickSaleAPIClient _qsClient;


        public QuickSaleWebsite(IQuickSaleAPIClient qsClient)
        {
            _qsClient = qsClient;
        }





        #region IWebsite<IEnumerable<APIPostAdPostDataBM>> Members

        public bool PostAd(IEnumerable<QuickSalePostAdPostDataBM> postAdData)
        {
            try
            {
                foreach (var data in postAdData)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(data.LastReturnAdID))
                            throw new Exception("Please delete the previous ad for this item.");
                        var listRequest = data.FillObjectIntoCreateItemRequest();
                        var response = _qsClient.GetAPIRequest<CreateItemRequest, CreateItemResponse>(listRequest);
                        if (response != null)
                        {
                            if (!string.IsNullOrEmpty(response.ListingID))
                            {
                                data.ReturnAdID = response.ListingID;
                                data.Result = ResultType.Success;
                            }
                            else
                            {
                                data.Result = ResultType.Error;
                                
                            }
                            data.ResultMessage = response.Message;
                        }
                        else
                        {
                            data.Result = ResultType.Error;
                        }
                        
                    }
                    catch(Exception ex)
                    {
                        data.Result = ResultType.Error;
                        data.ResultMessage = ex.Message;
                    }
                    var e = new BusinessObjectEventArgs<QuickSalePostAdPostDataBM>(data);
                    OnPostComplete(e);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool DeleteAd(IEnumerable<QuickSalePostAdPostDataBM> postAdData)
        {
            try
            {
                foreach (var data in postAdData)
                {
                    try
                    {
                        if (string.IsNullOrEmpty(data.LastReturnAdID))
                            continue;
                        var deleteRequest = data.DeleteReviseItemRequest();
                        var response = _qsClient.GetAPIRequest<ReviseItemRequest, ReviseItemResponse>(deleteRequest);
                        if (response != null)
                        {
                            if (!string.IsNullOrEmpty(response.ListingID))
                            {
                                data.ReturnAdID = response.ListingID;
                                data.Result = ResultType.Success;
                            }
                            else
                            {
                                data.Result = ResultType.Error;

                            }
                            data.ResultMessage = response.Message;
                        }
                        else
                        {
                            data.Result = ResultType.Error;
                        }

                    }
                    catch (Exception ex)
                    {
                        data.Result = ResultType.Error;
                        data.ResultMessage = ex.Message;
                    }
                    var e = new BusinessObjectEventArgs<QuickSalePostAdPostDataBM>(data);
                    OnDeleteAdComplete(e);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool RelistAd(IEnumerable<QuickSalePostAdPostDataBM> reviseData)
        {
            try
            {
                foreach (var data in reviseData)
                {
                    try
                    {
                        if (string.IsNullOrEmpty(data.LastReturnAdID))
                            continue;
                        var relistRequest = data.RelistReviseItemRequest();
                        var response = _qsClient.GetAPIRequest<ReviseItemRequest, ReviseItemResponse>(relistRequest);
                        if (response != null)
                        {
                            if (!string.IsNullOrEmpty(response.ListingID))
                            {
                                data.Result = ResultType.Success;
                            }
                            else
                            {
                                data.Result = ResultType.Error;
                            }
                            data.ResultMessage = response.Message;
                        }
                        else
                        {
                            data.Result = ResultType.Error;
                        }

                    }
                    catch (Exception ex)
                    {
                        data.Result = ResultType.Error;
                        data.ResultMessage = ex.Message;
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool ReviseInfo(IEnumerable<QuickSalePostAdPostDataBM> reviseData)
        {
            try
            {
                foreach (var data in reviseData)
                {
                    try
                    {
                        if (string.IsNullOrEmpty(data.LastReturnAdID))
                            continue;
                        var setAutoRelistRequest = data.ReviseInfoReviseItemRequest();
                        var response = _qsClient.GetAPIRequest<ReviseItemRequest, ReviseItemResponse>(setAutoRelistRequest);
                        if (response != null)
                        {
                            if (!string.IsNullOrEmpty(response.ListingID))
                            {
                                data.Result = ResultType.Success;
                            }
                            else
                            {
                                data.Result = ResultType.Error;
                            }
                            data.ResultMessage = response.Message;
                        }
                        else
                        {
                            data.Result = ResultType.Error;
                        }

                    }
                    catch (Exception ex)
                    {
                        data.Result = ResultType.Error;
                        data.ResultMessage = ex.Message;
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region INotifyPost<APIPostAdPostDataBM> Members

        public event EventHandler<BusinessObjectEventArgs<QuickSalePostAdPostDataBM>> PostComplete;
        public void OnPostComplete(BusinessObjectEventArgs<QuickSalePostAdPostDataBM> e)
        {
            if (PostComplete != null)
            {
                PostComplete(this, e);
            }
        }

        public event EventHandler<BusinessObjectEventArgs<QuickSalePostAdPostDataBM>> DeleteAdComplete;
        public void OnDeleteAdComplete(BusinessObjectEventArgs<QuickSalePostAdPostDataBM> e)
        {
            if (DeleteAdComplete != null)
            {
                DeleteAdComplete(this, e);
            }
        }
        #endregion
    }
}
