using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;

namespace AutoPostAdData.Models.Mapping
{
    public class DataFieldMap : EntityTypeConfiguration<DataField>
    {
        public DataFieldMap()
        {
            this.ToTable("DataField");
            // Primary Key
            this.HasKey(t => t.ID);

            // Properties
            this.Property(t => t.DataFieldName)
                .IsRequired()
                .HasMaxLength(50);

            

        }
    }
}
