using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class Address:BaseEntity
    {
        public Address()
        {

        }

        public string AddressName { get; set; }
        public string PostCode { get; set; }
        public string GeoLatitude { get; set; }
        public string GeoLongitude { get; set; }
    }
}
