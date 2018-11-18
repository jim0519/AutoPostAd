using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdBusiness.Handlers;
using Common.Infrastructure;
using Common;
using AutoPostAdBusiness.Task;

namespace Dropship
{
    class Program
    {
        static void Main(string[] args)
        {
            AutoPostAdContext.Instance.Initialize();
            //RuneBayServiceMethod();
            CallScheduleTask();
        }

        private static void CallScheduleTask()
        {
            var scope = AutoPostAdContext.Instance.ContainerManager.Scope();
            ITask task = null;
            
            var type2 = System.Type.GetType("AutoPostAdBusiness.Task.AutoPostAdIPSwitchTask, AutoPostAdBusiness");
            if (type2 != null)
            {
                object instance;
                if (!AutoPostAdContext.Instance.TryResolve(type2, scope, out instance))
                {
                    //not resolved
                    instance = AutoPostAdContext.Instance.ResolveUnregistered(type2, scope);
                }
                task = instance as ITask;
            }

            task.Execute();
        }

        private static void RuneBayServiceMethod()
        {
            var ebayService = AutoPostAdContext.Instance.Resolve<DropshipController>();
            //ebayService.GetActiveListing();
            //ebayService.GetUnsoldList();
            //ebayService.GetDropshipzoneInfo(true);
            //ebayService.GetCategories();
            //ebayService.GetDropshipzoneProductImagesPath();
            //ebayService.UpdateDropshipzoneInfoForNopcommerce();
            //ebayService.GenerateCSVFile("BA-TW-8031-FAB-GY");
            //ebayService.ConvertHtmlToPlainTextForGumtree();
            //ebayService.FixQuickSaleImagePath();
            //ebayService.RenderNewAddItemDescription();
            //ebayService.GetRealSmartInfo(true);
            //ebayService.GenerateNopcommerceImportCSVFile();
            //ebayService.SortingForLogoingImages();
            //ebayService.CopyLogoedImagesToImagesFilePath();
            ebayService.ResizeImages(@"C:\Users\gdutj\Documents\Work\GumtreePostAdData\SydneyFurniture2\Temp");
            //ebayService.UpdateActiveListing();
            //ebayService.UpdateActiveListingInventory();
            //ebayService.UpdateLocalDropshipzoneInfo();
            //ebayService.TestNCalc();
            //ebayService.TestGetSellerList();
            //ebayService.TestNetwork();
            //ebayService.TestInheritance();
            //var skus = ebayService.GetRedownloadImageSKUList();
            //var skus = new string[] { "FPIT-UFO-7676" };
            //ebayService.ReDownLoadImages(skus);
            //ebayService.FixDropshipzoneCategoryCustomID();
            //ebayService.CopyLogoedImagesToProductionFolder();
            //ebayService.ConvertBatteryExpertData();
            //ebayService.RenameImages();


            //var html=System.IO.File.ReadAllText(@"F:\tt.txt");
            //var strPlainText = html.StripHTML();
            //Console.WriteLine(strPlainText);
        }
    }
}
