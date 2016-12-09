using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;
using AutoPostAdBusiness.Services;
using AutoPostAdData.Models;
using AutoPostAdBusiness.BusinessModels;
using Common.Models;
using System.IO;
using System.Xml.Serialization;
using AutoPostAdBusiness.MapperInfrastruture;
using System.Net;
using Common.Infrastructure;


namespace AutoPostAdBusiness.Handlers
{
    public class QuickSaleAutoPostAdController
    {
        #region Dependent object

        private readonly IListAdQuickSalePostAdPostDataBMWebsite _website;
        private readonly IAutoPostAdPostDataService _autoPostAdPostDataService;
        private readonly IAutoPostAdResultService _autoPostAdResultService;
        private AutoPostAdDataSource<AutoPostAdPostData, QuickSalePostAdPostDataBM> _dataSource;
        #endregion

        public QuickSaleAutoPostAdController(
            IListAdQuickSalePostAdPostDataBMWebsite website, 
            IAutoPostAdHeaderService autoPostAdHeaderService, 
            IAutoPostAdPostDataService autoPostAdPostDataService,
            IAutoPostAdResultService autoPostAdResultService)
        {
            _website = website;
            _website = website;
            _autoPostAdPostDataService = autoPostAdPostDataService;
            _autoPostAdResultService = autoPostAdResultService;

            _website.PostComplete += _website_PostComplete;
            _website.DeleteAdComplete += _website_DeleteAdComplete;
        }

        private void _website_DeleteAdComplete(object sender, BusinessObjectEventArgs<QuickSalePostAdPostDataBM> e)
        {
            var returnData = e.ReturnObject;
            if (returnData.Result == ResultType.Success && returnData.LastReturnAdResult!=null)
            {
                //_autoPostAdPostDataService.DeleteAutoPostResult(returnData.LastReturnAdResult);
            }
        }

        private void _website_PostComplete(object sender, BusinessObjectEventArgs<QuickSalePostAdPostDataBM> e)
        {
            var returnData = e.ReturnObject;
            if (!string.IsNullOrEmpty(returnData.ReturnAdID) && returnData.Result == ResultType.Success)
            {
                returnData.AutoPostAdResults.Add(new AutoPostAdResult()
                {
                    AutoPostAdDataID = returnData.ID,
                    PostDate = DateTime.Now,
                    AdID = returnData.ReturnAdID
                });
                DataSource.SynchronizeData(returnData.ID);
                _autoPostAdPostDataService.UpdateAutoPostAdPostData(DataSource.OrginalDataSource.FirstOrDefault(o => o.ID == returnData.ID));
                //insert the result in ad result

            }
        }

        public AutoPostAdDataSource<AutoPostAdPostData, QuickSalePostAdPostDataBM> DataSource
        {
            get
            {
                try
                {
                    if (_dataSource == null)
                    {
                        _dataSource = new AutoPostAdDataSource<AutoPostAdPostData, QuickSalePostAdPostDataBM>(_autoPostAdPostDataService.GetAllQuickSaleAutoPostAdPostData().ToList());
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

        public void GetQuickSaleCategoryXML()
        {
            var qsClient = AutoPostAdContext.Instance.Resolve<IQuickSaleAPIClient>();
            var getCategoriesRequest = new GetCategoriesRequest();
            var getCategoryResponse =qsClient.GetAPIRequest<GetCategoriesRequest, GetCategoryResponse>(getCategoriesRequest);

            StringWriter sww = new StringWriter();
            System.Xml.XmlWriter xmlWriter = System.Xml.XmlWriter.Create("E:\\QuickSaleCategory.xml");
            XmlSerializer serializer = new XmlSerializer(typeof(GetCategoryResponse));
            serializer.Serialize(xmlWriter, getCategoryResponse);
            xmlWriter.Close();
        }

        public void ReviseInfo()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.ReviseInfo(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteAd()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.DeleteAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void RelistAd()
        {
            try
            {
                var selectedRecord = DataSource.Where(x => x.Selected);
                _website.RelistAd(selectedRecord.ToList());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void ConvertImageLink()
        {
            string strDirectory = @"F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\DownloadProductFromDropshipZone\";
            FileInfo fi = new FileInfo(strDirectory + "All_Images.txt");
            if (fi.Exists)
            {
                using (StreamReader sr = new StreamReader(fi.FullName))
                {
                    var strContent = sr.ReadToEnd();
                    var arrLink = strContent.Split(new string[1] { "\r\n" }, StringSplitOptions.None);
                    if (arrLink.Count() > 0)
                    {
                        var productImageList = new List<ProductImage>();
                        productImageList.AddRange(arrLink.GroupBy(x => x.Substring(x.LastIndexOf('/') + 1, x.Length - x.LastIndexOf('/') - 8))
                            .Select(x => new ProductImage()
                            {
                                SKU = x.Key,
                                ImagesPath = x.Aggregate((strImagesPath, link) => strImagesPath + ";" + link)
                            })
                            );

                        StringWriter sww = new StringWriter();
                        System.Xml.XmlWriter xmlWriter = System.Xml.XmlWriter.Create(strDirectory + "ProductImagesPath.xml");
                        XmlSerializer serializer = new XmlSerializer(typeof(List<ProductImage>));
                        serializer.Serialize(xmlWriter, productImageList);
                        xmlWriter.Close();

                    }
                }
            }
        }

        public void DownloadImages()
        {
            //var gumtreeAdDataSource = _autoPostAdPostDataService.GetAllAutoPostAdPostData();
            var imageLinkPath = @"F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\DownloadProductFromDropshipZone\ProductImagesPath.xml";
            var imagePath = @"F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\AdImages\";
            var webClient = new WebClient();


            StreamReader sr = new StreamReader(imageLinkPath);
            XmlSerializer serializer = new XmlSerializer(typeof(ArrayOfProductImage));
            var productImagesLink = (ArrayOfProductImage)serializer.Deserialize(sr);

            productImagesLink.ProductImage.ToList().ForEach(x => 
            {
                //var gumtreeAdData = gumtreeAdDataSource.Where(g=>g.SKU==x.SKU).FirstOrDefault();
                //if (gumtreeAdData.Count() > 0)
                //{
                var savedImagePathList = new List<string>();
                var di = new DirectoryInfo(imagePath + x.SKU);
                if (!di.Exists)
                {
                    di.Create();
                }
                var arrImagesLink = x.ImagesPath.Split(';');
                if (arrImagesLink.Count() > 0)
                {
                    int i=1;
                    arrImagesLink.ToList().ForEach(link =>
                    {
                        var savedImagePath = imagePath + x.SKU + "\\" + x.SKU + "_" + i.ToString().PadLeft(2, '0')+".jpg";
                        savedImagePathList.Add(savedImagePath);
                        var fi = new FileInfo(savedImagePath);
                        if (!fi.Exists)
                        {
                           //var imgData= webClient.DownloadData(link);
                           //File.WriteAllBytes(savedImagePath, imgData);
                            webClient.DownloadFile(link,savedImagePath);
                        }
                        i++;
                    });

                    //if (gumtreeAdData != null && savedImagePathList.Count>0)
                    //{
                    //    gumtreeAdData.ImagesPath = savedImagePathList.Aggregate((strImagesPath, savedImagePath) => strImagesPath + ";" + savedImagePath);
                    //    _autoPostAdPostDataService.UpdateAutoPostAdPostData(gumtreeAdData);
                    //}
                }
               
                //}
            });
        }

    }
}
