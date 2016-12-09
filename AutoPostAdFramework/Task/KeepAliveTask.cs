using AutoPostAdBusiness.Task;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace AutoPostAdBusiness.Task
{
    public partial class KeepAliveTask : ITask
    {
        //private readonly IeBayAPIContextProvider _eBayAPIContextProvider;
        public KeepAliveTask()
        {
            //_eBayAPIContextProvider = OMSCommon.Infrastructure.OMSWebContext.Instance.Resolve<IeBayAPIContextProvider>();
        }

        /// <summary>
        /// Executes a task
        /// </summary>
        public void Execute()
        {

            if (!string.IsNullOrEmpty( Common.AutoPostAdConfig.Instance.LocalHost ))
            {
                string url = Common.AutoPostAdConfig.Instance.LocalHost + "/Home/Index";
                using (var wc = new WebClient())
                {
                    wc.DownloadString(url);
                }
            }
            else
                return;
        }
    }
}
