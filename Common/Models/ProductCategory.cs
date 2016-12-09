using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class ProductCategory : BaseEntity
    {
        public string CategoryID { get; set; }
        public string CategoryName { get; set; }
        public string ParentCategoryID { get; set; }
        public int TemplateID { get; set; }
        public int CategoryTypeID { get; set; }
        public string Status { get; set; }

        public virtual Template TemplateObj { get; set; }
    }
}
