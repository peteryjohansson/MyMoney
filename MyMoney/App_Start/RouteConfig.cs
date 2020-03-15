using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace MyMoney
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
             settings.AutoRedirectMode = RedirectMode.Permanent;
           // settings.AutoRedirectMode = RedirectMode.Off;
            //routes.IgnoreRoute("{page}.aspx/{*webmethod}");
            routes.EnableFriendlyUrls(settings);
        }
    }
}
