using AutoPostAdBusiness.Services;
using AutoPostAdBusiness.Task;
using AutoPostAdData.Models;
using Common.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Common;
using AutoPostAdBusiness.MapperInfrastruture;
using AutoPostAdBusiness.BusinessModels;
using AutoPostAdBusiness.Handlers;

namespace AutoPostAdBusiness.Task
{
    public partial class AutoPostAdIPSwitchTask : AutoPostAdTask
    {
        private readonly IEnumerable<IBumpupable> _bumpupHandlers;

        public AutoPostAdIPSwitchTask(IAutoPostAdWebPostService autoPostAdWebPostService,
            IAutoPostAdPostDataService autoPostAdPostDataService,
            IRepository<ScheduleRule> scheduleRule,
            IEnumerable<IBumpupable> bumpupHandlers)
            : base(autoPostAdWebPostService, autoPostAdPostDataService, scheduleRule)
        {
            _bumpupHandlers = bumpupHandlers;
        }

        /// <summary>
        /// Executes a task
        /// </summary>
        public override void Execute()
        {
            try
            {

                //var datas = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(AutoPostAdPostDataService.GetAllAutoPostAdPostData().ToList());
                
                //foreach(var handler in _bumpupHandlers)
                //{
                //    var handlerChannelName = handler.GetType().Name;
                //    var bumpupAds = datas.Where(ad=>ad.AccountObj.ChannelObj.Name.ToLower().Equals(handlerChannelName.ToLower())).ToList();
                //    handler.Bumpup(bumpupAds);
                //}
                //return;

                //LogManager.Instance.Error("Test email error");
                var scheduleRule = ScheduleRule.Table.Where(r => r.Status == Status.Active).ToList();
                var nowTime = DateTime.Now;
                //Loop Rules
                foreach (var rule in scheduleRule)
                {
                    var availableRuleLine = GetAvailableRuleLine(rule, nowTime);
                    
                    //Get Available Rule Line To Post, If Null Then No Need To Post.
                    if (availableRuleLine != null)
                    {
                        try
                        {
                            var scheduleAds = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(AutoPostAdPostDataService.GetAutoPostAdPostDataByScheduleRuleID(rule.ID));

                            #region bumpup ads with corresponding channel
                            foreach (var handler in _bumpupHandlers)
                            {
                                var handlerChannelName = handler.GetType().Name;
                                var bumpupAds = scheduleAds.Where(ad => ad.AccountObj.ChannelObj.Name.ToLower().Equals(handlerChannelName.ToLower())).ToList();
                                handler.Bumpup(bumpupAds);
                            }
                            #endregion


                            #region Change IP Implementation
                            var currentPublicIP = "";
                            try
                            {
                                currentPublicIP = CommonFunction.GetPublicIPAddress();
                                LogManager.Instance.Info("Public IP Address before change " + currentPublicIP);
                                if (string.IsNullOrEmpty(currentPublicIP))
                                    throw new Exception("Public IP is not available.");
                            }
                            catch (Exception ex)
                            {
                                LogManager.Instance.Error(ex.Message);
                                return;
                            }
                            var gumtreeAds = scheduleAds.Where(ad => ad.AccountObj.ChannelID == 1);
                            var postAdDataIPGrp = gumtreeAds.GroupBy(pd => new{ IPAddress=pd.AccountObj.IPAddress,Netmask=pd.AccountObj.Netmask,Gateway=pd.AccountObj.Gateway}).OrderBy(pdg => pdg.Key.IPAddress.Equals(currentPublicIP)).ThenBy(pdg => pdg.Key.IPAddress);
                            //var deletePostSuccess = true;
                            foreach (var pdg in postAdDataIPGrp)
                            {
                                
                                if (pdg.Key.IPAddress != currentPublicIP)
                                {
                                    if (CommonFunction.ChangeIPAddress(pdg.Key.IPAddress, pdg.Key.Netmask, pdg.Key.Gateway))
                                    {
                                        var realCurrentIP = CommonFunction.GetPublicIPAddress();
                                        if (pdg.Key.IPAddress != realCurrentIP)
                                            throw new Exception("Change IP Address from " + currentPublicIP + " to " + pdg.Key.IPAddress + " failed.");
                                        currentPublicIP = realCurrentIP;
                                        LogManager.Instance.Info("Public IP Address after change " + currentPublicIP);
                                    }
                                    else
                                        throw new Exception("Change IP Address from " + currentPublicIP + " to " + pdg.Key.IPAddress+" failed.");
                                }

                                LogManager.Instance.Info("Posting ads using IP "+currentPublicIP);

                                var grpScheduleAdsDelete = pdg.Select(pd => pd);
                                var grpScheduleAdsPost = grpScheduleAdsDelete.Where(pd=>!pd.Notes.ToUpper().Equals("DELONLY"));
                                var grpScheduleAdsToBeUpdateDelete = grpScheduleAdsDelete.Where(pd => pd.Notes.ToUpper().Equals("DELONLY"));
                                var grpScheduleAdsToBeClearNotes = grpScheduleAdsDelete.Where(pd => pd.Notes.ToUpper().Equals("UPDATE"));
                                if (AutoPostAdWebPostService.DeleteAd(grpScheduleAdsDelete))
                                {
                                    foreach(var d in grpScheduleAdsToBeUpdateDelete)
                                    {
                                        var originAd = AutoPostAdPostDataService.GetAutoPostAdPostDataByID(d.ID);
                                        originAd.Status = Status.Deleted;
                                        AutoPostAdPostDataService.UpdateAutoPostAdPostData(originAd);
                                    }
                                    foreach (var d in grpScheduleAdsToBeClearNotes)
                                    {
                                        var originAd = AutoPostAdPostDataService.GetAutoPostAdPostDataByID(d.ID);
                                        originAd.Notes = "";
                                        AutoPostAdPostDataService.UpdateAutoPostAdPostData(originAd);
                                    }
                                    if (!AutoPostAdWebPostService.PostAd(grpScheduleAdsPost))
                                    {
                                        throw new Exception("Delete post faild for schedule rule " + rule.ID);
                                    }
                                }
                                else
                                    throw new Exception("Delete post faild for schedule rule " + rule.ID);

                                //if (!deletePostSuccess)
                                    
                            }

                            rule.LastSuccessTime = nowTime;
                            ScheduleRule.Update(rule);

                            #endregion
                        }
                        catch (Exception ex)
                        {
                            LogManager.Instance.Error(ex.Message);
                            rule.Status =Status.Deleted;
                            ScheduleRule.Update(rule);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
                
            }
            
        }

    }
}
