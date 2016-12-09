using LINQtoCSV;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoPostAdBusiness.BusinessModels
{
    public class DropshipzoneSKUModel
    {
        public string SKU { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        //public string ListingTitle { get; set; }
        //public string ListingTitle { get; set; }
        [CsvColumn(Name = "price")]
        public decimal Price { get; set; }
        [CsvColumn(Name = "Stock Qty")]
        public int InventoryQty { get; set; }
        public string Status { get; set; }
        public string VIC { get; set; }
        public string NSW { get; set; }
        public string SA { get; set; }
        public string QLD { get; set; }
        public string TAS { get; set; }
        public string WA { get; set; }
        public string NT { get; set; }
        [CsvColumn(Name = "bulky item")]
        public string IsBulkyItem { get; set; }
        [CsvColumn(Name = "Weight (kg)")]
        public string Weight { get; set; }
        [CsvColumn(Name = "Carton Length (cm)")]
        public string Length { get; set; }
        [CsvColumn(Name = "Carton Width (cm)")]
        public string Width { get; set; }
        [CsvColumn(Name = "Carton Height (cm)")]
        public string Height { get; set; }
        [CsvColumn(Name = "images")]
        public string Images { get; set; }
    }
}
