using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AddressMap : EntityTypeConfiguration<Address>
    {
        public AddressMap()
        {
            this.ToTable("Address");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.AddressName)
               .IsRequired()
               .HasMaxLength(100);

            this.Property(t => t.PostCode)
               .IsRequired()
               .HasMaxLength(100);

            this.Property(t => t.GeoLatitude)
               .IsRequired()
               .HasMaxLength(100);

            this.Property(t => t.GeoLongitude)
               .IsRequired()
               .HasMaxLength(100);

            //this.HasRequired(r => r.AutoPostAdPostDataObj).WithMany(d => d.AutoPostAdResults).HasForeignKey(d=>d.SKU).WillCascadeOnDelete(true);
        }
    }
}
