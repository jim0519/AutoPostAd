using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class ProductCategoryMap : EntityTypeConfiguration<ProductCategory>
    {
        public ProductCategoryMap()
        {
            this.ToTable("ProductCategory");
            // Primary Key
            this.HasKey(t => t.ID);
            //this.HasKey(t=>t.CategoryID);

            // Properties
            this.Property(t => t.CategoryID)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.CategoryName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.ParentCategoryID)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.TemplateID)
                .IsRequired();

            this.Property(t => t.CategoryTypeID)
                .IsRequired();

            this.Property(t => t.Status)
                .IsRequired()
                .HasMaxLength(50);

            
            //Relationship
            this.HasRequired(t => t.TemplateObj).WithMany().HasForeignKey(t => t.TemplateID).WillCascadeOnDelete(false);


        }
    }
}
