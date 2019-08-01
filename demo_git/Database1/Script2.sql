using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unity;
using System.Web;
using NNA.Services.Common;

namespace NNA.Services.Identity.Common
{
    public static class Globals
    {
        public const string Domain = "Identity";
        public const string ErrorCodeLabel = "nna-error-code";
        public const string MessageIdLabel = "nna-message-id";

        public static IUnityContainer Container { get; set; }

        public static Guid? GetAuthenticateUserGuid()
        {
            if (HttpContext.Current?.User == null)
                return null;

            //var oauthAccountId = (actionContext.RequestContext.Principal ?? HttpContext.Current.User)?.GetUserId();
            //var oauthAccountId = (request.GetRequestContext()?.Principal ?? HttpContext.Current.User)?.GetUserId();
            return HttpContext.Current.User?.GetUserId();
        }
    }
}
