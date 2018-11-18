using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class AccountAdvertise : BaseEntity
    {
        public AccountAdvertise()
        {

        }

        public int AccountID { get; set; }
        public int AdvertiseID { get; set; }
        public string OnlineAdvertiseID { get; set; }
        public DateTime? OnlineAdvertiseDate { get; set; }
        public string Ref { get; set; }

        public virtual Account AccountObj { get; set; }
        public virtual AutoPostAdPostData AdvertiseObj { get; set; }
    }
}
