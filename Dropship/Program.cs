using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdBusiness.Handlers;
using Common.Infrastructure;
using Common;


namespace Dropship
{
    class Program
    {
        static void Main(string[] args)
        {
            AutoPostAdContext.Instance.Initialize();
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
            //ebayService.ResizeImages(@"G:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData\TotalDirect\New\TDirect2\Material\Newfolder");
            //ebayService.UpdateActiveListing();
            //ebayService.UpdateActiveListingInventory();
            //ebayService.UpdateLocalDropshipzoneInfo();
            //ebayService.TestNCalc();
            //ebayService.TestGetSellerList();
            //ebayService.TestNetwork();
            //ebayService.TestInheritance();
            //var skus = ebayService.GetRedownloadImageSKUList();
            //ebayService.ReDownLoadImages(skus);
            //ebayService.FixDropshipzoneCategoryCustomID();
            //ebayService.CopyLogoedImagesToProductionFolder();


            //var html=System.IO.File.ReadAllText(@"F:\tt.txt");
            //var strPlainText = html.StripHTML();
            //Console.WriteLine(strPlainText);
        }
    }
}
