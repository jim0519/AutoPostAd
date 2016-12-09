using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;
using AutoPostAdBusiness.Services;
using AutoPostAdData.Models;
using AutoPostAdBusiness.BusinessModels;
using AutoMapper;
using Common.Models;
using System.Text.RegularExpressions;
using AutoPostAdBusiness.MapperInfrastruture;


namespace AutoPostAdBusiness.Handlers
{
    public class AutoPostAdController
    {
        #region Dependent object

        private readonly IAutoPostAdHeaderService _autoPostAdHeaderService;
        private readonly IListAdAutoPostAdPostDataBMWebsite _website;
        private readonly IAutoPostAdPostDataService _autoPostAdPostDataService;
        private readonly IAutoPostAdResultService _autoPostAdResultService;
        private AutoPostAdDataSource<AutoPostAdPostData,AutoPostAdPostDataBM> _dataSource;
        //private string _guid = Guid.NewGuid().ToString();
        //public string GUID 
        //{ 
        //    get { return _guid; } 
        //}
        #endregion

        public AutoPostAdController(IAutoPostAdHeaderService autoPostAdHeaderService,
            IListAdAutoPostAdPostDataBMWebsite website, IAutoPostAdPostDataService autoPostAdPostDataService,
            IAutoPostAdResultService autoPostAdResultService)
        {
            _autoPostAdHeaderService = autoPostAdHeaderService;
            _website = website;
            _autoPostAdPostDataService = autoPostAdPostDataService;
            _autoPostAdResultService = autoPostAdResultService;

            _website.PostComplete +=_website_PostComplete;
            _website.DeleteAdComplete +=_website_DeleteAdComplete;
            //var postData = GetPostData();
            //var validData = from data in postData
            //                where data.IsValid == true
            //                select data;
            //var lstData=validData.ToList();
            
        }

        


        public AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM> DataSource
        {
            get
            {
                try
                {
                    if (_dataSource == null)
                    {
                        _dataSource = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(_autoPostAdPostDataService.GetAllAutoPostAdPostData().ToList());
                        //var lstDataSource = _autoPostAdPostDataService.GetAllAutoPostAdPostData().Select(x =>Mapper.Map<AutoPostAdPostData, AutoPostAdPostDataBM>(x)).ToList();
                        //_dataSource.ForEach(x => x.Selected = true);
                        //_dataSource = lstDataSource;
                    }
                    return _dataSource;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public void SaveAutoPostAdPostData()
        {
            ProgressInfoService.BeginProgressProcess();
            int i = 1;
            int percentage = i;
            DataSource.SynchronizeData();
            foreach (AutoPostAdPostData pd in DataSource.OrginalDataSource )
            {
                //get object and modify value
                //var pd = DataSource.OrginalDataSource.FirstOrDefault(o => o.ID == pdbm.ID);
                //var pd= _autoPostAdPostDataService.GetAutoPostAdPostDataByID(pdbm.ID);
                //pd = Mapper.Map<AutoPostAdPostDataBM, AutoPostAdPostData>(pdbm, pd);
                //if (pd!=null)
                _autoPostAdPostDataService.UpdateAutoPostAdPostData(pd);
                //report progress
                percentage = i * 100 / DataSource.Count;
                var message=new Dictionary<string, object>();
                message.Add("ProgressMessage", "Processing prgress " + percentage + " percent.");
                ProgressInfoService.ReportProgess(percentage, message);
                i++;
            }
            ProgressInfoService.EndProgressProcess();
            //_autoPostAdPostDataService.UpdateGumtreePostData
        }

        public void PostAd()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.PostAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public event EventHandler<NotifyContinueWebsiteProcessEventArgs> NotifyContinueWebsiteProcess;

        public void OnNotifyContinueWebsiteProcess(NotifyContinueWebsiteProcessEventArgs e)
        {
            if (NotifyContinueWebsiteProcess != null)
            {
                NotifyContinueWebsiteProcess(this, e);
            }
        }


        public void ContinuePostProcess(string verificationCode)
        {
            NotifyContinueWebsiteProcessEventArgs e = new NotifyContinueWebsiteProcessEventArgs(verificationCode);
            OnNotifyContinueWebsiteProcess(e);
        }

        void _website_PostComplete(object sender,BusinessObjectEventArgs<AutoPostAdPostDataBM> e)
        {
            var returnData = e.ReturnObject as AutoPostAdPostDataBM;
            if (!string.IsNullOrEmpty(returnData.ReturnAdID) && returnData.Result == ResultType.Success)
            {
                returnData.AutoPostAdResults.Add(new AutoPostAdResult() { 
                    AutoPostAdDataID = returnData.ID, 
                    PostDate = DateTime.Now, 
                    AdID = returnData.ReturnAdID });
                DataSource.SynchronizeData(returnData.ID);
                _autoPostAdPostDataService.UpdateAutoPostAdPostData(DataSource.OrginalDataSource.FirstOrDefault(o=>o.ID==returnData.ID));
                //insert the result in ad result
                
            }
            //_dataSource = returnDatas;
            //_autoPostAdPostDataService.UpdateAutoPostAdPostData(pd);
        }

        public void DeleteAd()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected).Where(x => !string.IsNullOrEmpty(x.LastReturnAdID));
                _website.DeleteAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void _website_DeleteAdComplete(object sender, BusinessObjectEventArgs<AutoPostAdPostDataBM> e)
        {
            var returnData = e.ReturnObject as AutoPostAdPostDataBM;
            if (returnData.Result == ResultType.Success)
            {
                _autoPostAdPostDataService.DeleteAutoPostResult(returnData.LastReturnAdResult);
                if (returnData.LastReturnAdResult != null)
                {
                    returnData.AutoPostAdResults.Clear();
                }
                //returnData.AutoPostAdResults.Remove(returnData.AutoPostAdResults.FirstOrDefault());
                //DataSource.SynchronizeData(returnData.ID);
                //_autoPostAdPostDataService.UpdateAutoPostAdPostData(DataSource.OrginalDataSource.FirstOrDefault(o => o.ID == returnData.ID));
            }
        }

        public void DeletePost()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.DeleteAd(selectedRecord.ToList());
                //_website.PostAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void GetCookies()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.GetCookies(selectedRecord.ToList());
                //_website.PostAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    public class NotifyContinueWebsiteProcessEventArgs:EventArgs
    {
        public NotifyContinueWebsiteProcessEventArgs(object returnObject)
        {
            ReturnObject = returnObject;
        }

        public object ReturnObject { get; set; }
    }

    
}
