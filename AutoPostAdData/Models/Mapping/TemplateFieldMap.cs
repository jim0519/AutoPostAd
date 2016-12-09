using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class TemplateFieldMap : EntityTypeConfiguration<TemplateField>
    {
        public TemplateFieldMap()
        {
            this.ToTable("TemplateField");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.TemplateID)
                .IsRequired();

            this.Property(t => t.DataFieldID)
                .IsRequired();

            this.Property(t => t.Order)
                .IsRequired();

            this.Property(t => t.TemplateFieldName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.DefaultValue)
               .IsRequired()
               .HasMaxLength(50);

            this.Property(t => t.TemplateFieldType)
                .IsRequired();

            this.Property(t => t.IsRequireInput)
                .IsRequired();

           //Relationship
            this.HasRequired(t => t.DataFieldObj).WithMany().HasForeignKey(t => t.DataFieldID).WillCascadeOnDelete(true);

        }
    }
}
