using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class ScheduleRuleLine : BaseEntity
    {
        public int ScheduleRuleID { get; set; }
        public DateTime TimeRangeFrom { get; set; }
        public DateTime TimeRangeTo { get; set; }
        public DateTime CreateTime { get; set; }
        public string CreateBy { get; set; }
        public DateTime EditTime { get; set; }
        public string EditBy { get; set; }

        public virtual ScheduleRule ScheduleRuleObj { get; set; }
    }
}
