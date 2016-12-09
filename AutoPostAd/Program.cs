using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoPostAdBusiness;
using Common.Infrastructure;

namespace AutoPostAd
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            //Initialize context
            AutoPostAdContext.Instance.Initialize();

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());

            //var qsController = AutoPostAdContext.Instance.Resolve<AutoPostAdBusiness.Handlers.QuickSaleAutoPostAdController>();
            //qsController.PostAd();
        }
    }
}
