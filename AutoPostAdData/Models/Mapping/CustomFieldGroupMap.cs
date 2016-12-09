using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class CustomFieldGroupMap : EntityTypeConfiguration<CustomFieldGroup>
    {
        public CustomFieldGroupMap()
        {
            this.ToTable("CustomFieldGroup");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.Name)
                .IsRequired()
                .HasMaxLength(100);

            //Relationship

            this.HasMany(t => t.CustomFieldLines).WithRequired().HasForeignKey(t => t.CustomFieldGroupID).WillCascadeOnDelete(true);
        }
    }
}
