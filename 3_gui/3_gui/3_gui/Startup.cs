using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(_3_gui.Startup))]
namespace _3_gui
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
