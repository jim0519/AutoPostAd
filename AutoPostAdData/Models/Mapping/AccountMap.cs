using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class AccountMap : EntityTypeConfiguration<Account>
    {
        public AccountMap()
        {
            this.ToTable("Account");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.UserName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.Password)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.FirstName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.LastName)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.Cookie)
                .IsRequired()
                .HasMaxLength(4000);

            this.Property(t => t.PhoneNumber)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.Status)
                .IsRequired()
                .HasMaxLength(1);

            this.Property(t => t.IPAddress)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.Netmask)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.Gateway)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.UserAgent)
                .IsRequired()
                .HasMaxLength(500);

            this.Property(t => t.RefBinary).IsMaxLength();

            //Relationship
            this.HasRequired(a => a.ChannelObj).WithMany().HasForeignKey(d => d.ChannelID);
        }
    }
}
