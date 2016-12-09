/**
 */

namespace Common.DeathByCaptcha
{
    /**
     * <summary>Exception indicating that CAPTCHA was rejected due to service being overloaded.</summary>
     */
    public class ServiceOverloadException : DeathByCaptchaException
    {
        public ServiceOverloadException() : base()
        {}

        public ServiceOverloadException(string message) : base(message)
        {}
    }
}
