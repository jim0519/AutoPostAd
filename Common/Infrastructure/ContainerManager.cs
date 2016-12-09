using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Autofac;
using Common;
using Common.Models;
using Common.DeathByCaptcha;

namespace Common.Infrastructure
{
    public class ContainerManager
    {
        private readonly IContainer _container;

        public ContainerManager(IContainer container)
        {
            _container = container;
        }

        public IContainer Container
        {
            get { return _container; }
        }



        public void RegisterDependency()
        {
        //    var builder = new ContainerBuilder();

        //    //sigleton

        //    //PerLifetimeScope
        //    builder.RegisterType<AutoPostAdDBContext>().As<IDbContext>().InstancePerLifetimeScope();
        //    builder.RegisterGeneric(typeof(AutoPostAdRepository<>)).As(typeof(IRepository<>)).InstancePerLifetimeScope();
        //    builder.RegisterType<AutoPostAdHeaderService>().As<IAutoPostAdHeaderService>().InstancePerLifetimeScope();
        //    builder.RegisterType<AutoPostAdPostDataService>().As<IAutoPostAdPostDataService>().InstancePerLifetimeScope();
        //    builder.RegisterType<AutoPostAdResultService>().As<IAutoPostAdResultService>().InstancePerLifetimeScope();
        //    builder.RegisterType<GumtreeWebsite>().As<IListAdAutoPostAdPostDataBMWebsite>().InstancePerLifetimeScope().OnActivated(e => e.Instance.Manager = e.Context.Resolve<AutoPostAdController>());
        //    builder.RegisterType<AutoPostAdController>().InstancePerLifetimeScope();
        //    //builder.RegisterType<SocketClient>().As<Client>().InstancePerLifetimeScope()
        //    //    .WithParameters(new List<Autofac.Core.Parameter>() { new Autofac.Core.NamedPropertyParameter("username", AutoPostAdConfig.Instance.DeathByCaptchaUserName), new Autofac.Core.NamedPropertyParameter("password", AutoPostAdConfig.Instance.DeathByCaptchaPassword) });
        //    builder.RegisterType<SocketClient>().As<Client>().InstancePerLifetimeScope()
        //        .WithParameter("username", AutoPostAdConfig.Instance.DeathByCaptchaUserName).WithParameter("password", AutoPostAdConfig.Instance.DeathByCaptchaPassword);
        //    builder.RegisterType<DelayController>().As<IDelayable>().InstancePerLifetimeScope();

        //    builder.RegisterType<QuickSaleAPIClient>().As<IQuickSaleAPIClient>().InstancePerLifetimeScope();
        //    builder.RegisterType<QuickSaleAutoPostAdController>().InstancePerLifetimeScope();
        //    builder.RegisterType<QuickSaleWebsite>().As<IListAdQuickSalePostAdPostDataBMWebsite>().InstancePerLifetimeScope();

        //    builder.Update(_container);

            //type finder
            AddComponent<ITypeFinder, AppAllDLLTypeFinder>("typeFinder");

            //get type finders after registering
            var typeFinder = _container.Resolve<ITypeFinder>();

            //register dependencies provided by other assemblies
            UpdateContainer(b =>
            {
                var drTypes = typeFinder.FindClassesOfType<IDependencyRegistrar>();
                var drInstances = new List<IDependencyRegistrar>();
                foreach (var drType in drTypes)
                    drInstances.Add((IDependencyRegistrar)Activator.CreateInstance(drType));
                //sort
                drInstances = drInstances.AsQueryable().OrderBy(t => t.Order).ToList();
                foreach (var dependencyRegistrar in drInstances)
                    dependencyRegistrar.Register(b, typeFinder);
            });
        }


        public T Resolve<T>(string key = "")
            where T : class
        {
            if (string.IsNullOrEmpty(key))
            {
                if (Scope().IsRegistered(typeof(T)))
                {
                    return Scope().Resolve<T>();
                }
            }
            return Scope().ResolveKeyed<T>(key);
        }

        public ILifetimeScope Scope()
        {
            try
            {
                return AutofacRequestLifetimeHttpModule.GetLifetimeScope(Container, null);
            }
            catch
            {
                return Container;
            }
        }

        public object Resolve(Type type)
        {
            return Scope().Resolve(type);
        }

        public object ResolveOptional(Type serviceType)
        {
            return Scope().ResolveOptional(serviceType);
        }




        public void AddComponent<TService>(string key = "", ComponentLifeStyle lifeStyle = ComponentLifeStyle.Singleton)
        {
            AddComponent<TService, TService>(key, lifeStyle);
        }

        public void AddComponent(Type service, string key = "", ComponentLifeStyle lifeStyle = ComponentLifeStyle.Singleton)
        {
            AddComponent(service, service, key, lifeStyle);
        }

        public void AddComponent<TService, TImplementation>(string key = "", ComponentLifeStyle lifeStyle = ComponentLifeStyle.Singleton)
        {
            AddComponent(typeof(TService), typeof(TImplementation), key, lifeStyle);
        }

        public void AddComponent(Type service, Type implementation, string key = "", ComponentLifeStyle lifeStyle = ComponentLifeStyle.Singleton)
        {
            UpdateContainer(x =>
            {
                var serviceTypes = new List<Type> { service };

                if (service.IsGenericType)
                {
                    var temp = x.RegisterGeneric(implementation).As(
                        serviceTypes.ToArray()).PerLifeStyle(lifeStyle);
                    if (!string.IsNullOrEmpty(key))
                    {
                        temp.Keyed(key, service);
                    }
                }
                else
                {
                    var temp = x.RegisterType(implementation).As(
                        serviceTypes.ToArray()).PerLifeStyle(lifeStyle);
                    if (!string.IsNullOrEmpty(key))
                    {
                        temp.Keyed(key, service);
                    }
                }
            });
        }

        public void UpdateContainer(Action<ContainerBuilder> action)
        {
            var builder = new ContainerBuilder();
            action.Invoke(builder);
            builder.Update(_container);
        }


    }
}
