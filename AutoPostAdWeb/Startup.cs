using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(AutoPostAdWeb.Startup))]
namespace AutoPostAdWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
