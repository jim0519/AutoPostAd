using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AccountAdvertiseMap : EntityTypeConfiguration<AccountAdvertise>
    {
        public AccountAdvertiseMap()
        {
            this.ToTable("AccountAdvertise");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.OnlineAdvertiseID)
               .IsRequired()
               .HasMaxLength(500);

            this.Property(t => t.Ref)
               .IsRequired()
               .HasColumnType("nvarchar(max)");

            // Relationships
            this.HasRequired(a => a.AdvertiseObj)
                .WithMany(d => d.AccountAdvertises)
                .HasForeignKey(a => a.AdvertiseID);
            this.HasRequired(t => t.AccountObj)
                .WithMany()
                .HasForeignKey(d => d.AccountID);

            //this.HasRequired(r => r.AutoPostAdPostDataObj).WithMany(d => d.AutoPostAdResults).HasForeignKey(d=>d.SKU).WillCascadeOnDelete(true);
        }
    }
}
