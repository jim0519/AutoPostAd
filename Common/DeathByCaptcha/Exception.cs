/**
 */

namespace Common.DeathByCaptcha
{
    /**
     * <summary>Base DBC API exception.</summary>
     */
    public class DeathByCaptchaException : System.Exception
    {
        public DeathByCaptchaException() : base()
        {}

        public DeathByCaptchaException(string message) : base(message)
        {}
    }
}
