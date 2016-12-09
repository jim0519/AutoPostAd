using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class TemplateField : BaseEntity
    {
        public int TemplateID { get; set; }
        public int DataFieldID { get; set; }
        public int Order { get; set; }
        public string DefaultValue { get; set; }
        public string TemplateFieldName { get; set; }
        public int TemplateFieldType { get; set; }
        public bool IsRequireInput { get; set; }

        public virtual DataField DataFieldObj { get; set; }
    }
}
