using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class TemplateMap : EntityTypeConfiguration<Template>
    {
        public TemplateMap()
        {
            this.ToTable("Template");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.TemplateName)
                .IsRequired()
                .HasMaxLength(50);

            //Relationship

            this.HasMany(t => t.TemplateFileds).WithRequired().HasForeignKey(t => t.TemplateID).WillCascadeOnDelete(true);
        }
    }
}
