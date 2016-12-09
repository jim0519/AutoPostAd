using System;
using System.Collections.Generic;

namespace Common.Models
{
    public partial class AutoPostAdHeader : BaseEntity
    {
        public AutoPostAdHeader()
        {
            this.AutoPostAdLines = new List<AutoPostAdLine>();
        }

        public string FileName { get; set; }
        public System.DateTime PostDate { get; set; }
        public virtual ICollection<AutoPostAdLine> AutoPostAdLines { get; set; }
    }
}
