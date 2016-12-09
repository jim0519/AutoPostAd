using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class ScheduleRuleLineMap : EntityTypeConfiguration<ScheduleRuleLine>
    {
        public ScheduleRuleLineMap()
        {
            this.ToTable("ScheduleRuleLine");
            this.HasKey(t => t.ID);

            this.Property(t => t.CreateBy)
                .IsRequired()
                .HasMaxLength(4000);

            this.Property(t => t.EditBy)
                .IsRequired()
                .HasMaxLength(4000);

            // Relationships
            this.HasRequired(t => t.ScheduleRuleObj)
                .WithMany(t => t.ScheduleRuleLines)
                .HasForeignKey(d => d.ScheduleRuleID);
        }
    }
}
