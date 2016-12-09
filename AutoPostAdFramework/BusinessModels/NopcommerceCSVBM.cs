using LINQtoCSV;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoPostAdBusiness.BusinessModels
{
    public class NopcommerceCSVBM
    {
        [CsvColumn(FieldIndex = 1)]
        public int ProductTypeId { get; set; }

        [CsvColumn(FieldIndex = 2)]
        public int ParentGroupedProductId { get; set; }

        [CsvColumn(FieldIndex = 3)]
        public string VisibleIndividually { get; set; }

        [CsvColumn(FieldIndex = 4)]
        public string Name { get; set; }

        [CsvColumn(FieldIndex = 5)]
        public string ShortDescription { get; set; }

        [CsvColumn(FieldIndex = 6)]
        public string FullDescription { get; set; }

        [CsvColumn(FieldIndex = 7)]
        public int VendorId { get; set; }

        [CsvColumn(FieldIndex = 8)]
        public int ProductTemplateId { get; set; }

        [CsvColumn(FieldIndex = 9)]
        public string ShowOnHomePage { get; set; }

        [CsvColumn(FieldIndex = 10)]
        public string MetaKeywords { get; set; }

        [CsvColumn(FieldIndex = 11)]
        public string MetaDescription { get; set; }

        [CsvColumn(FieldIndex = 12)]
        public string MetaTitle { get; set; }

        [CsvColumn(FieldIndex = 13)]
        public string SeName { get; set; }

        [CsvColumn(FieldIndex = 14)]
        public string AllowCustomerReviews { get; set; }

        [CsvColumn(FieldIndex = 15)]
        public string Published { get; set; }

        [CsvColumn(FieldIndex = 16)]
        public string SKU { get; set; }

        [CsvColumn(FieldIndex = 17)]
        public string ManufacturerPartNumber { get; set; }

        [CsvColumn(FieldIndex = 18)]
        public string Gtin { get; set; }

        [CsvColumn(FieldIndex = 19)]
        public string IsGiftCard { get; set; }

        [CsvColumn(FieldIndex = 20)]
        public int GiftCardTypeId { get; set; }

        [CsvColumn(FieldIndex = 21)]
        public string RequireOtherProducts { get; set; }

        [CsvColumn(FieldIndex = 22)]
        public string RequiredProductIds { get; set; }

        [CsvColumn(FieldIndex = 23)]
        public string AutomaticallyAddRequiredProducts { get; set; }

        [CsvColumn(FieldIndex = 24)]
        public string IsDownload { get; set; }

        [CsvColumn(FieldIndex = 25)]
        public int DownloadId { get; set; }

        [CsvColumn(FieldIndex = 26)]
        public string UnlimitedDownloads { get; set; }

        [CsvColumn(FieldIndex = 27)]
        public int MaxNumberOfDownloads { get; set; }

        [CsvColumn(FieldIndex = 28)]
        public int DownloadActivationTypeId { get; set; }

        [CsvColumn(FieldIndex = 29)]
        public string HasSampleDownload { get; set; }

        [CsvColumn(FieldIndex = 30)]
        public int SampleDownloadId { get; set; }

        [CsvColumn(FieldIndex = 31)]
        public string HasUserAgreement { get; set; }

        [CsvColumn(FieldIndex = 32)]
        public string UserAgreementText { get; set; }

        [CsvColumn(FieldIndex = 33)]
        public string IsRecurring { get; set; }

        [CsvColumn(FieldIndex = 34)]
        public int RecurringCycleLength { get; set; }

        [CsvColumn(FieldIndex = 35)]
        public int RecurringCyclePeriodId { get; set; }

        [CsvColumn(FieldIndex = 36)]
        public int RecurringTotalCycles { get; set; }

        [CsvColumn(FieldIndex = 37)]
        public string IsRental { get; set; }

        [CsvColumn(FieldIndex = 38)]
        public int RentalPriceLength { get; set; }

        [CsvColumn(FieldIndex = 39)]
        public int RentalPricePeriodId { get; set; }

        [CsvColumn(FieldIndex = 40)]
        public string IsShipEnabled { get; set; }

        [CsvColumn(FieldIndex = 41)]
        public string IsFreeShipping { get; set; }

        [CsvColumn(FieldIndex = 42)]
        public string ShipSeparately { get; set; }

        [CsvColumn(FieldIndex = 43)]
        public decimal  AdditionalShippingCharge { get; set; }

        [CsvColumn(FieldIndex = 44)]
        public int DeliveryDateId { get; set; }

        [CsvColumn(FieldIndex = 45)]
        public string IsTaxExempt { get; set; }

        [CsvColumn(FieldIndex = 46)]
        public int TaxCategoryId { get; set; }

        [CsvColumn(FieldIndex = 47)]
        public string IsTelecommunicationsOrBroadcastingOrElectronicServices { get; set; }

        [CsvColumn(FieldIndex = 48)]
        public int ManageInventoryMethodId { get; set; }

        [CsvColumn(FieldIndex = 49)]
        public string UseMultipleWarehouses { get; set; }

        [CsvColumn(FieldIndex = 50)]
        public int WarehouseId { get; set; }

        [CsvColumn(FieldIndex = 51)]
        public int StockQuantity { get; set; }

        [CsvColumn(FieldIndex = 52)]
        public string DisplayStockAvailability { get; set; }

        [CsvColumn(FieldIndex = 53)]
        public string DisplayStockQuantity { get; set; }

        [CsvColumn(FieldIndex = 54)]
        public int MinStockQuantity { get; set; }

        [CsvColumn(FieldIndex = 55)]
        public int LowStockActivityId { get; set; }

        [CsvColumn(FieldIndex = 56)]
        public int NotifyAdminForQuantityBelow { get; set; }

        [CsvColumn(FieldIndex = 57)]
        public int BackorderModeId { get; set; }

        [CsvColumn(FieldIndex = 58)]
        public string AllowBackInStockSubscriptions { get; set; }

        [CsvColumn(FieldIndex = 59)]
        public int OrderMinimumQuantity { get; set; }

        [CsvColumn(FieldIndex = 60)]
        public int OrderMaximumQuantity { get; set; }

        [CsvColumn(FieldIndex = 61)]
        public string AllowedQuantities { get; set; }

        [CsvColumn(FieldIndex = 62)]
        public string AllowAddingOnlyExistingAttributeCombinations { get; set; }

        [CsvColumn(FieldIndex = 63)]
        public string DisableBuyButton { get; set; }

        [CsvColumn(FieldIndex = 64)]
        public string DisableWishlistButton { get; set; }

        [CsvColumn(FieldIndex = 65)]
        public string AvailableForPreOrder { get; set; }

        [CsvColumn(FieldIndex =66)]
        public string PreOrderAvailabilityStartDateTimeUtc { get; set; }

        [CsvColumn(FieldIndex = 67)]
        public string CallForPrice { get; set; }

        [CsvColumn(FieldIndex = 68)]
        public decimal Price { get; set; }

        [CsvColumn(FieldIndex = 69)]
        public decimal OldPrice { get; set; }

        [CsvColumn(FieldIndex = 70)]
        public decimal ProductCost { get; set; }

        [CsvColumn(FieldIndex = 71)]
        public string SpecialPrice { get; set; }

        [CsvColumn(FieldIndex = 72)]
        public string SpecialPriceStartDateTimeUtc { get; set; }

        [CsvColumn(FieldIndex = 73)]
        public string SpecialPriceEndDateTimeUtc { get; set; }

        [CsvColumn(FieldIndex = 74)]
        public string CustomerEntersPrice { get; set; }

        [CsvColumn(FieldIndex = 75)]
        public decimal MinimumCustomerEnteredPrice { get; set; }

        [CsvColumn(FieldIndex = 76)]
        public decimal MaximumCustomerEnteredPrice { get; set; }

        [CsvColumn(FieldIndex = 77)]
        public decimal Weight { get; set; }

        [CsvColumn(FieldIndex = 78)]
        public decimal Length { get; set; }

        [CsvColumn(FieldIndex = 79)]
        public decimal Width { get; set; }

        [CsvColumn(FieldIndex = 80)]
        public decimal Height { get; set; }

        [CsvColumn(FieldIndex = 81)]
        public double CreatedOnUtc { get; set; }

        [CsvColumn(FieldIndex = 82)]
        public string CategoryIds { get; set; }

        [CsvColumn(FieldIndex = 83)]
        public string ManufacturerIds { get; set; }

        [CsvColumn(FieldIndex = 84)]
        public string Picture1 { get; set; }

        [CsvColumn(FieldIndex = 85)]
        public string Picture2 { get; set; }

        [CsvColumn(FieldIndex = 86)]
        public string Picture3 { get; set; }

        [CsvColumn(FieldIndex = 87)]
        public string Picture4 { get; set; }

        [CsvColumn(FieldIndex = 88)]
        public string Picture5 { get; set; }

        [CsvColumn(FieldIndex = 89)]
        public string Picture6 { get; set; }

        [CsvColumn(FieldIndex = 90)]
        public string Picture7 { get; set; }

        [CsvColumn(FieldIndex = 91)]
        public string Picture8 { get; set; }

    }
}
