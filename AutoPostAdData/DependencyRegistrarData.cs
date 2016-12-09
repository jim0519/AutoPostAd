using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using AutoPostAdData.Models;
using Common;

namespace AutoPostAdData
{
    public class DependencyRegistrarData : IDependencyRegistrar
    {
        #region IDependencyRegistrar Members

        public void Register(ContainerBuilder builder, ITypeFinder typeFinder)
        {
            //PerLifetimeScope
            builder.RegisterType<AutoPostAdDBContext>().As<IDbContext>().InstancePerLifetimeScope();
            builder.RegisterGeneric(typeof(AutoPostAdRepository<>)).As(typeof(IRepository<>)).InstancePerLifetimeScope();
        }

        public int Order
        {
            get { return 0; }
        }

        #endregion
    }
}
