using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AdvertiseChannelMap : EntityTypeConfiguration<AdvertiseChannel>
    {
        public AdvertiseChannelMap()
        {
            this.ToTable("AdvertiseChannel");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.Name)
               .IsRequired()
               .HasMaxLength(50);

            this.Property(t => t.Description)
               .IsRequired()
               .HasMaxLength(2000);

        }
    }
}
