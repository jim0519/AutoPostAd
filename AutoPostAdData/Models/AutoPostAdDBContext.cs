using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using AutoPostAdData.Models.Mapping;
using Common;
using Common.Models;

namespace AutoPostAdData.Models
{
    public partial class AutoPostAdDBContext : DbContext, IDbContext
    {
        static AutoPostAdDBContext()
        {
            Database.SetInitializer<AutoPostAdDBContext>(null);
        }

        public AutoPostAdDBContext()
            : base(AutoPostAdConfig.Instance.ConnectionString)
        {
        }

        //public DbSet<AutoPostAdHeader> AutoPostAdHeaders { get; set; }
        //public DbSet<AutoPostAdLine> AutoPostAdLines { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new AutoPostAdHeaderMap());
            modelBuilder.Configurations.Add(new AutoPostAdLineMap());
            modelBuilder.Configurations.Add(new AutoPostAdPostDataMap());
            modelBuilder.Configurations.Add(new ProductCategoryMap());
            modelBuilder.Configurations.Add(new AutoPostAdResultMap());
            modelBuilder.Configurations.Add(new TemplateMap());
            modelBuilder.Configurations.Add(new TemplateFieldMap());
            modelBuilder.Configurations.Add(new DataFieldMap());
            modelBuilder.Configurations.Add(new AddressMap());
            modelBuilder.Configurations.Add(new AccountMap());
            modelBuilder.Configurations.Add(new CustomFieldGroupMap());
            modelBuilder.Configurations.Add(new CustomFieldLineMap());
            modelBuilder.Configurations.Add(new ScheduleTaskMap());
            modelBuilder.Configurations.Add(new ScheduleRuleMap());
            modelBuilder.Configurations.Add(new ScheduleRuleLineMap());
            base.OnModelCreating(modelBuilder);
        }

        /// <summary>
        /// Get DbSet
        /// </summary>
        /// <typeparam name="TEntity">Entity type</typeparam>
        /// <returns>DbSet</returns>
        public new IDbSet<TEntity> Set<TEntity>() where TEntity : BaseEntity
        {
            return base.Set<TEntity>();
        }

        /// <summary>
        /// Creates a raw SQL query that will return elements of the given generic type.  The type can be any type that has properties that match the names of the columns returned from the query, or can be a simple primitive type. The type does not have to be an entity type. The results of this query are never tracked by the context even if the type of object returned is an entity type.
        /// </summary>
        /// <typeparam name="TElement">The type of object returned by the query.</typeparam>
        /// <param name="sql">The SQL query string.</param>
        /// <param name="parameters">The parameters to apply to the SQL query string.</param>
        /// <returns>Result</returns>
        public IEnumerable<TElement> SqlQuery<TElement>(string sql, params object[] parameters)
        {
            return this.Database.SqlQuery<TElement>(sql, parameters);
        }

        /// <summary>
        /// Executes the given DDL/DML command against the database.
        /// </summary>
        /// <param name="sql">The command string</param>
        /// <param name="timeout">Timeout value, in seconds. A null value indicates that the default value of the underlying provider will be used</param>
        /// <param name="parameters">The parameters to apply to the command string.</param>
        /// <returns>The result returned by the database after executing the command.</returns>
        public int ExecuteSqlCommand(string sql, int? timeout = null, params object[] parameters)
        {
            int? previousTimeout = null;
            if (timeout.HasValue)
            {
                //store previous timeout
                previousTimeout = ((IObjectContextAdapter)this).ObjectContext.CommandTimeout;
                ((IObjectContextAdapter)this).ObjectContext.CommandTimeout = timeout;
            }

            var result = this.Database.ExecuteSqlCommand(sql, parameters);

            if (timeout.HasValue)
            {
                //Set previous timeout back
                ((IObjectContextAdapter)this).ObjectContext.CommandTimeout = previousTimeout;
            }

            //return result
            return result;
        }
    }
}
