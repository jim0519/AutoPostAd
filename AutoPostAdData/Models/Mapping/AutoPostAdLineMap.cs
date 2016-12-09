using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AutoPostAdLineMap : EntityTypeConfiguration<AutoPostAdLine>
    {
        public AutoPostAdLineMap()
        {
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.ExternalID)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.Status)
                .IsRequired()
                .HasMaxLength(10);

            // Table & Column Mappings
            //this.ToTable("AutoPostAdLine");
            //this.Property(t => t.ID).HasColumnName("ID");
            //this.Property(t => t.HeaderID).HasColumnName("HeaderID");
            //this.Property(t => t.ExternalID).HasColumnName("ExternalID");
            //this.Property(t => t.Status).HasColumnName("Status");
            //this.Property(t => t.PostDate).HasColumnName("PostDate");

            // Relationships
            this.HasRequired(t => t.AutoPostAdHeader)
                .WithMany(t => t.AutoPostAdLines)
                .HasForeignKey(d => d.HeaderID);

        }
    }
}
