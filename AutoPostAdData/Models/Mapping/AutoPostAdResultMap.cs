using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AutoPostAdResultMap : EntityTypeConfiguration<AutoPostAdResult>
    {
        public AutoPostAdResultMap()
        {
            this.ToTable("AutoPostAdResult");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.AutoPostAdDataID)
                .IsRequired();

            this.Property(t => t.PostDate)
                .IsRequired();

            this.Property(t => t.AdID)
                .IsRequired()
                .HasMaxLength(50);

            //this.HasRequired(r => r.AutoPostAdPostDataObj).WithMany(d => d.AutoPostAdResults).HasForeignKey(d=>d.SKU).WillCascadeOnDelete(true);
        }
    }
}
