using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace Common.Models
{
    public partial class AutoPostAdResult : BaseEntity
    {
        public AutoPostAdResult()
        {

        }

        public int AutoPostAdDataID { get; set; }
        public DateTime PostDate { get; set; }
        public string AdID { get; set; }

        //public virtual AutoPostAdPostData AutoPostAdPostDataObj { get; set; }
    }
}
