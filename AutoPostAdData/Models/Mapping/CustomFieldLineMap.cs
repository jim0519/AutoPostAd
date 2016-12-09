using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class CustomFieldLineMap : EntityTypeConfiguration<CustomFieldLine>
    {

        public CustomFieldLineMap()
        {
            this.ToTable("CustomFieldLine");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.CustomFieldGroupID)
                .IsRequired();

            this.Property(t => t.FieldName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.FieldValue)
               .IsRequired()
               .HasMaxLength(4000);

        }
    }
}
