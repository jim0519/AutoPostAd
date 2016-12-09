using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;
using Autofac;

namespace Common.Infrastructure
{
    public class AutoPostAdContext
    {
        private static AutoPostAdContext _instance;
        private ContainerManager _containerManager;
        private readonly IDictionary<Type, object> _allSingletons = new Dictionary<Type, object>();

        private AutoPostAdContext()
        {

        }

        public static AutoPostAdContext Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new AutoPostAdContext();
                }
                return _instance;
            }
        }

        public void Initialize()
        { 
            
            //dependency injection
            _containerManager = new ContainerManager(new ContainerBuilder().Build());
            _containerManager.RegisterDependency();

            //Initialize Mapper
            //SingleInstance<MapperInfrastruture.MapperRule>().Initialize();

            //Run startup task
            RunStartupTasks();
            
        }

        private void RunStartupTasks()
        {
            var typeFinder = _containerManager.Resolve<ITypeFinder>();
            var startUpTaskTypes = typeFinder.FindClassesOfType<IStartupTask>();
            var startUpTasks = new List<IStartupTask>();
            foreach (var startUpTaskType in startUpTaskTypes)
                startUpTasks.Add((IStartupTask)Activator.CreateInstance(startUpTaskType));
            //sort
            startUpTasks = startUpTasks.AsQueryable().OrderBy(st => st.Order).ToList();
            foreach (var startUpTask in startUpTasks)
                startUpTask.Execute();
        }

        public AutoPostAdConfig Config
        {
            get
            {
                return AutoPostAdConfig.Instance;
            }
        }

        public ContainerManager ContainerManager { get { return _containerManager; } }

        public T SingleInstance<T>()
        {
            if (!_allSingletons.ContainsKey(typeof(T)))
            {
                _allSingletons[typeof(T)] = Activator.CreateInstance<T>();
            }
            return (T)_allSingletons[typeof(T)];
        }

        //public T Resolve<T>(string key = "") where T : class
        //{
        //    try
        //    {
        //        if (string.IsNullOrEmpty(key))
        //        {
        //            return _containerManager.Resolve<T>();
        //        }
        //        return _containerManager.Resolve<T>(key);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public T Resolve<T>(string key = "", ILifetimeScope scope = null) where T : class
        {
            if (scope == null)
            {
                //no scope specified
                scope = _containerManager.Scope();
            }
            if (string.IsNullOrEmpty(key))
            {
                return scope.Resolve<T>();
            }
            return scope.ResolveKeyed<T>(key);
        }

        public T[] ResolveAll<T>(string key = "")
        {
            if (string.IsNullOrEmpty(key))
            {
                return _containerManager.Resolve<IEnumerable<T>>().ToArray();
            }
            return _containerManager.Resolve<IEnumerable<T>>(key).ToArray();
        }

        


        public bool TryResolve(Type serviceType, ILifetimeScope scope, out object instance)
        {
            if (scope == null)
            {
                //no scope specified
                scope = _containerManager.Scope();
            }
            return scope.TryResolve(serviceType, out instance);
        }

        public T ResolveUnregistered<T>(ILifetimeScope scope = null) where T : class
        {
            return ResolveUnregistered(typeof(T), scope) as T;
        }

        public object ResolveUnregistered(Type type, ILifetimeScope scope = null)
        {
            if (scope == null)
            {
                //no scope specified
                scope = _containerManager.Scope();
            }
            var constructors = type.GetConstructors();
            foreach (var constructor in constructors)
            {
                try
                {
                    var parameters = constructor.GetParameters();
                    var parameterInstances = new List<object>();
                    foreach (var parameter in parameters)
                    {
                        var service = Resolve(parameter.ParameterType, scope);
                        if (service == null) throw new Exception("Unkown dependency");
                        parameterInstances.Add(service);
                    }
                    return Activator.CreateInstance(type, parameterInstances.ToArray());
                }
                catch (Exception)
                {

                }
            }
            throw new Exception("No contructor was found that had all the dependencies satisfied.");
        }

        public object Resolve(Type type, ILifetimeScope scope = null)
        {
            if (scope == null)
            {
                //no scope specified
                scope = _containerManager.Scope();
            }
            return scope.Resolve(type);
        }
    }
}
