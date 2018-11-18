using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;


namespace AutoPostAdData.Models.Mapping
{
    public class AutoPostAdPostDataMap : EntityTypeConfiguration<AutoPostAdPostData>
    {
        public AutoPostAdPostDataMap()
        {
            this.ToTable("AutoPostAdPostData");
            // Primary Key
            this.HasKey(t => t.ID);
            //this.HasKey(t => t.SKU);

            // Properties
            this.Property(t => t.SKU)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.Price).HasPrecision(18, 2);
            this.Property(t => t.Title)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.Description)
                .IsRequired();

            this.Property(t => t.ImagesPath)
                .IsRequired();

            this.Property(t => t.CategoryID)
                .IsRequired();

            this.Property(t => t.InventoryQty)
                .IsRequired();

            this.Property(t => t.BusinessLogoPath)
                .IsRequired()
                .HasMaxLength(4000);

            this.Property(t => t.CustomID)
                 .IsRequired()
                 .HasMaxLength(500);

            this.Property(t => t.Status)
                 .IsRequired()
                 .HasMaxLength(50);

            this.Property(t => t.Postage).HasPrecision(18, 2);

            this.Property(t => t.Notes)
                .IsRequired();

            this.Property(t => t.AdTypeID)
                .IsRequired();

            // Relationships
            this.HasRequired(t => t.ProductCategoryObj)
                .WithMany()
                .HasForeignKey(d=>d.CategoryID)
                .WillCascadeOnDelete(false );

            this.HasRequired(t => t.CustomFieldGroupObj)
                .WithMany()
                .HasForeignKey(d => d.CustomFieldGroupID)
                .WillCascadeOnDelete(false);

            this.HasRequired(t => t.AddressObj)
                .WithMany()
                .HasForeignKey(d => d.AddressID)
                .WillCascadeOnDelete(false);

            this.HasRequired(t => t.AccountObj)
                .WithMany()
                .HasForeignKey(d => d.AccountID)
                .WillCascadeOnDelete(false);

            this.HasRequired(t => t.ScheduleRuleObj)
                .WithMany()
                .HasForeignKey(d => d.ScheduleRuleID)
                .WillCascadeOnDelete(false);

            this.HasMany(t => t.AutoPostAdResults).WithRequired().HasForeignKey(d => d.AutoPostAdDataID).WillCascadeOnDelete(true);


        }
    }
}
