using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class ScheduleRuleMap:EntityTypeConfiguration<ScheduleRule>
    {
        public ScheduleRuleMap()
        {
            this.ToTable("ScheduleRule");
            this.HasKey(t => t.ID);
            this.Property(t => t.Name).IsRequired().HasMaxLength(4000);
            this.Property(t => t.Description).IsRequired();
            this.Property(t => t.Status).IsRequired().HasMaxLength(4000);

            this.Property(t => t.CreateBy)
                .IsRequired()
                .HasMaxLength(4000);

            this.Property(t => t.EditBy)
                .IsRequired()
                .HasMaxLength(4000);
        }
    }
}
