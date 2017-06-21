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
using System.Threading;

namespace AutoPostAdBusiness.Task
{
    public partial class AutoPostAdTask : ITask
    {
        private readonly IAutoPostAdWebPostService _autoPostAdWebPostService;
        private readonly IAutoPostAdPostDataService _autoPostAdPostDataService;
        private readonly IRepository<ScheduleRule> _scheduleRule;

        public AutoPostAdTask(IAutoPostAdWebPostService autoPostAdWebPostService,
            IAutoPostAdPostDataService autoPostAdPostDataService,
            IRepository<ScheduleRule> scheduleRule)
        {
            _autoPostAdWebPostService = autoPostAdWebPostService;
            _autoPostAdPostDataService = autoPostAdPostDataService;
            _scheduleRule = scheduleRule;
            //_eBayAPIContextProvider = OMSCommon.Infrastructure.OMSWebContext.Instance.Resolve<IeBayAPIContextProvider>();
        }

        /// <summary>
        /// Executes a task
        /// </summary>
        public virtual void Execute()
        {
            //Thread.Sleep(900000);
            try
            {
                var scheduleRule = _scheduleRule.Table.Where(r=>r.Status==Status.Active).ToList();
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
                            var scheduleAds = new AutoPostAdDataSource<AutoPostAdPostData, AutoPostAdPostDataBM>(_autoPostAdPostDataService.GetAutoPostAdPostDataByScheduleRuleID(rule.ID));
                            //Get Ads Belongs to Rule Line To Post
                            if (_autoPostAdWebPostService.DeleteAd(scheduleAds))
                            {
                                if (_autoPostAdWebPostService.PostAd(scheduleAds))
                                {
                                    rule.LastSuccessTime = nowTime;
                                    _scheduleRule.Update(rule);
                                }
                            }

                            
                        }
                        catch (Exception ex)
                        {
                            LogManager.Instance.Error(ex.Message);
                            rule.Status =Status.Deleted;
                            _scheduleRule.Update(rule);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                LogManager.Instance.Error(ex.Message);
                
            }
            
        }

        protected ScheduleRuleLine GetAvailableRuleLine(ScheduleRule rule,DateTime nowTime)
        {
            ScheduleRuleLine returnRuleLine = null; 
            var elaspDays=(nowTime.Date-rule.LastSuccessTime.Date).TotalDays;
            //see if nowTime is meet the interval day+LastSuccessTime
            if ((elaspDays % rule.IntervalDay == 0)&&((elaspDays>0&&rule.IntervalDay>=1)||elaspDays==0&&rule.IntervalDay==1))
            {
                var nowTimeTime = nowTime.TimeOfDay;
                //get the rule line whose time range the nowTime can sit in
                returnRuleLine = rule.ScheduleRuleLines.FirstOrDefault(l => nowTimeTime >= l.TimeRangeFrom.TimeOfDay
                    && nowTimeTime < l.TimeRangeTo.TimeOfDay
                    && l.ScheduleRuleObj.LastSuccessTime.TimeOfDay < l.TimeRangeFrom.TimeOfDay.Add(TimeSpan.FromDays(elaspDays)));
            }

            return returnRuleLine;
        }

        protected IAutoPostAdWebPostService AutoPostAdWebPostService { get { return _autoPostAdWebPostService; } }

        protected IAutoPostAdPostDataService AutoPostAdPostDataService { get { return _autoPostAdPostDataService; } }

        protected IRepository<ScheduleRule> ScheduleRule { get { return _scheduleRule; } }
    }
}
