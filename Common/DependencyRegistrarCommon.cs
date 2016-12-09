using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using Common.Infrastructure;

namespace Common
{
    public class DependencyRegistrarCommon : IDependencyRegistrar
    {
        #region IDependencyRegistrar Members

        public void Register(ContainerBuilder builder, ITypeFinder typeFinder)
        {
            //PerHttpRequest

            //Sigleton
            builder.RegisterType<CacheManager>().As<ICacheManager>().SingleInstance();
        }

        public int Order
        {
            get { return 0; }
        }

        #endregion
    }
}
