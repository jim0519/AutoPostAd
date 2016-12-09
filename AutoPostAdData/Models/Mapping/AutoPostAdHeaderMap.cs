using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AutoPostAdHeaderMap : EntityTypeConfiguration<AutoPostAdHeader>
    {
        public AutoPostAdHeaderMap()
        {
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.FileName)
                .IsRequired()
                .HasMaxLength(100);

            // Table & Column Mappings
            //this.ToTable("AutoPostAdHeader");
            //this.Property(t => t.ID).HasColumnName("ID");
            //this.Property(t => t.FileName).HasColumnName("FileName");
            //this.Property(t => t.PostDate).HasColumnName("PostDate");
        }
    }
}
