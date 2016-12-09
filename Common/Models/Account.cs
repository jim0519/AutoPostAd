using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common.Models
{
    public partial class Account:BaseEntity
    {
        public Account()
        {

        }

        public string UserName { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Cookie { get; set; }
        public string PhoneNumber { get; set; }
        public string Status { get; set; }
        public string IPAddress { get; set; }
        public string Netmask { get; set; }
        public string Gateway { get; set; }
        public string UserAgent { get; set; }
    }
}
