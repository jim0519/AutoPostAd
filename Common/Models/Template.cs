using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class Template : BaseEntity
    {
        public string TemplateName { get; set; }

        public virtual ICollection<TemplateField> TemplateFileds { get; set; }
    }
}
