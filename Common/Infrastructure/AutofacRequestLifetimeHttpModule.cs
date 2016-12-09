using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;

namespace Common.Infrastructure
{
    public class AutofacRequestLifetimeHttpModule
    {

        public static readonly object LifetimeScopeTag = "AutofacLifetimeScope";

        /// <summary>
        /// Gets a nested lifetime scope that services can be resolved from.
        /// </summary>
        /// <param name="container">The parent container.</param>
        /// <param name="configurationAction">Action on a <see cref="ContainerBuilder"/>
        /// that adds component registations visible only in nested lifetime scopes.</param>
        /// <returns>A new or existing nested lifetime scope.</returns>
        public static ILifetimeScope GetLifetimeScope(ILifetimeScope container, Action<ContainerBuilder> configurationAction)
        {
            return InitializeLifetimeScope(configurationAction, container);
        }



       

        private static ILifetimeScope InitializeLifetimeScope(Action<ContainerBuilder> configurationAction, ILifetimeScope container)
        {
            return (configurationAction == null)
                ? container.BeginLifetimeScope(LifetimeScopeTag)
                : container.BeginLifetimeScope(LifetimeScopeTag, configurationAction);
        }
    }
}
