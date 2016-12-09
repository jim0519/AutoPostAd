using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using AutoPostAdBusiness.Handlers;
using AutoPostAdBusiness.Services;
using Common;
using Common.DeathByCaptcha;

namespace AutoPostAdBusiness
{
    public class DependencyRegistrarBusiness : IDependencyRegistrar
    {
        #region IDependencyRegistrar Members

        public void Register(ContainerBuilder builder, ITypeFinder typeFinder)
        {
            //PerLifetimeScope
            
        }

        public int Order
        {
            get { return 0; }
        }

        #endregion
    }
}
