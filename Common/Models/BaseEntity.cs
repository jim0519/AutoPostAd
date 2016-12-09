using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;

namespace Common.Models
{
    public abstract class BaseEntity
    {
        /// <summary>
        /// Gets or sets the entity identifier
        /// </summary>
        public int ID { get; set; }

        public override bool Equals(object obj)
        {
            return Equals(obj as BaseEntity);
        }

        private static bool IsTransient(BaseEntity obj)
        {
            return obj != null && Equals(obj.ID, default(int));
        }

        private Type GetUnproxiedType()
        {
            return GetType();
        }

        public virtual bool Equals(BaseEntity other)
        {
            if (other == null)
                return false;

            if (ReferenceEquals(this, other))
                return true;

            if (!IsTransient(this) &&
                !IsTransient(other) &&
                Equals(ID, other.ID))
            {
                var otherType = other.GetUnproxiedType();
                var thisType = GetUnproxiedType();
                return thisType.IsAssignableFrom(otherType) ||
                        otherType.IsAssignableFrom(thisType);
            }

            return false;
        }

        public override int GetHashCode()
        {
            if (Equals(ID, default(int)))
                return base.GetHashCode();
            return ID.GetHashCode();
        }

        public static bool operator ==(BaseEntity x, BaseEntity y)
        {
            return Equals(x, y);
        }

        public static bool operator !=(BaseEntity x, BaseEntity y)
        {
            return !(x == y);
        }

        #region Rules

        private IEnumerable<ValidateError> _validateErrors;
        private IEnumerable<ValidateError> Validate(object instance)
        {
            _validateErrors = from propertyInfo in instance.GetType().GetProperties()
                         from attribute in propertyInfo.GetCustomAttributes(typeof(ValidationAttribute), true).OfType<ValidationAttribute>()
                         where attribute.IsValid(propertyInfo.GetValue(instance, null)) == false
                         select new ValidateError { ErrorMessage = attribute.FormatErrorMessage(propertyInfo.Name), PropertyName = propertyInfo.Name };
            return _validateErrors;
        }

        protected class ValidateError
        {
            public string ErrorMessage { get; set; }
            public string PropertyName { get; set; }
        }

        public virtual bool IsValid
        {
            get
            {
                return this.Validate(this).Count() == 0;
            }
        }

        public string GetErrorMessage()
        {
            StringBuilder sb=new StringBuilder();
            if (_validateErrors == null)
                this.Validate(this);
            _validateErrors.ToList().ForEach(x=>sb.AppendLine(x.ErrorMessage));
            return sb.ToString();
        }

        #endregion
    }
}
