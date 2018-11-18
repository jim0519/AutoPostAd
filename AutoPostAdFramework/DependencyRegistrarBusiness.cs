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
using AutoPostAdBusiness.Task;

namespace AutoPostAdBusiness
{
    public class DependencyRegistrarBusiness : IDependencyRegistrar
    {
        #region IDependencyRegistrar Members

        public void Register(ContainerBuilder builder, ITypeFinder typeFinder)
        {
            var assemblies = typeFinder.GetAssemblies().ToArray();
            //PerLifetimeScope
            builder.RegisterType<AutoPostAdHeaderService>().As<IAutoPostAdHeaderService>().InstancePerLifetimeScope();
            builder.RegisterType<AutoPostAdPostDataService>().As<IAutoPostAdPostDataService>().InstancePerLifetimeScope();
            builder.RegisterType<AutoPostAdResultService>().As<IAutoPostAdResultService>().InstancePerLifetimeScope();
            builder.RegisterType<GumtreeWebsite>().As<IListAdAutoPostAdPostDataBMWebsite>().InstancePerLifetimeScope().OnActivated(e => e.Instance.Manager = e.Context.Resolve<AutoPostAdController>());
            builder.RegisterType<AutoPostAdController>().InstancePerLifetimeScope();
            builder.RegisterType<DelayController>().As<IDelayable>().InstancePerLifetimeScope();

            builder.RegisterType<QuickSaleAPIClient>().As<IQuickSaleAPIClient>().InstancePerLifetimeScope();
            builder.RegisterType<QuickSaleAutoPostAdController>().InstancePerLifetimeScope();
            builder.RegisterType<QuickSaleWebsite>().As<IListAdQuickSalePostAdPostDataBMWebsite>().InstancePerLifetimeScope();

            builder.RegisterType<DropshipController>().InstancePerLifetimeScope();

            builder.RegisterType<SocketClient>().As<Client>().InstancePerLifetimeScope()
                .WithParameter("username", AutoPostAdConfig.Instance.DeathByCaptchaUserName).WithParameter("password", AutoPostAdConfig.Instance.DeathByCaptchaPassword);

            builder.RegisterType<AutoPostAdWebPostService>().As<IAutoPostAdWebPostService>().InstancePerLifetimeScope();

            builder.RegisterType<ScheduleTaskService>().As<IScheduleTaskService>().InstancePerLifetimeScope();

            builder.RegisterAssemblyTypes(assemblies).Where(t => typeof(IBumpupable).IsAssignableFrom(t)).InstancePerLifetimeScope().AsImplementedInterfaces();
        }

        public int Order
        {
            get { return 0; }
        }

        #endregion
    }
}
