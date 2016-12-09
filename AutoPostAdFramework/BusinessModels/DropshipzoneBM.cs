using LINQtoCSV;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoPostAdBusiness.BusinessModels
{
    public class DropshipzoneGroupPrice
    {
        public int ID { get; set; }
        public string Sku { get; set; }
        public string Standard { get; set; }
        public string Professional { get; set; }
        public string Enterprise { get; set; }
        public string Wholesale { get; set; }
        public string WholesaleBig { get; set; }
    }

    public class DropshipzonePostage
    {
        public int ID { get; set; }
        [CsvColumn(Name = "Product Code")]
        public string Sku { get; set; }
        [CsvColumn(Name = "Freight (VIC)")]
        public string VIC { get; set; }
        [CsvColumn(Name = "Freight (NSW)")]
        public string NSW { get; set; }
        [CsvColumn(Name = "Freight (SA)")]
        public string SA { get; set; }
        [CsvColumn(Name = "Freight (QLD)")]
        public string QLD { get; set; }
        [CsvColumn(Name = "Freight (TAS)")]
        public string TAS { get; set; }
        [CsvColumn(Name = "Freight (WA)")]
        public string WA { get; set; }
        [CsvColumn(Name = "Freight (NT)")]
        public string NT { get; set; }
        public string Group { get; set; }
    }

    public class DropshipzoneSKU
    {
        public string SKU { get; set; }
        public string Title { get; set; }
        public string price { get; set; }
        public string VIC { get; set; }
        public string NSW { get; set; }
        public string SA { get; set; }
        public string QLD { get; set; }
        public string TAS { get; set; }
        public string WA { get; set; }
        public string NT { get; set; }
        [CsvColumn(Name = "bulky item")]
        public string IsBulkyItem { get; set; }
        [CsvColumn(Name = "EAN Code")]
        public string EAN { get; set; }
        public string Brand { get; set; }
        public string MPN { get; set; }
        [CsvColumn(Name = "Weight (kg)")]
        public string Weight { get; set; }

    }
}
