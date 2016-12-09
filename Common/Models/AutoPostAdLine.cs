using System;
using System.Collections.Generic;

namespace Common.Models
{
    public partial class AutoPostAdLine : BaseEntity
    {

        public int HeaderID { get; set; }
        public string ExternalID { get; set; }
        public string Status { get; set; }
        public System.DateTime PostDate { get; set; }
        public virtual AutoPostAdHeader AutoPostAdHeader { get; set; }
    }
}
