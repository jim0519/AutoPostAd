using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class CustomFieldLine : BaseEntity
    {
        public int CustomFieldGroupID { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
    }
}
