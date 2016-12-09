using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class ScheduleRule : BaseEntity
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public int IntervalDay { get; set; }
        public DateTime LastSuccessTime { get; set; }
        public string Status { get; set; }
        public DateTime CreateTime { get; set; }
        public string CreateBy { get; set; }
        public DateTime EditTime { get; set; }
        public string EditBy { get; set; }


        public virtual ICollection<ScheduleRuleLine> ScheduleRuleLines { get; set; }
    }
}
