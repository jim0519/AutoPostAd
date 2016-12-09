using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class CustomFieldGroup : BaseEntity
    {
        public string Name { get; set; }

        public virtual ICollection<CustomFieldLine> CustomFieldLines { get; set; }
    }
}
