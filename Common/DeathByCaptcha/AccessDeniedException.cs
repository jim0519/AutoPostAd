/**
 */

namespace Common.DeathByCaptcha
{
    /**
     * <summary>Exception indicating that access to the API was denied due to invalid credentials, insufficied balance, or because the DBC account was banned.</summary>
     */
    public class AccessDeniedException : DeathByCaptchaException
    {
        public AccessDeniedException() : base()
        {}

        public AccessDeniedException(string message) : base(message)
        {}
    }
}
