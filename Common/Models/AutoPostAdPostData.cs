using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace Common.Models
{
    public partial class AutoPostAdPostData : BaseEntity
    {
        public AutoPostAdPostData()
        {
            //AutoPostAdResults = new List<AutoPostAdResult>();
        }
        
        public string SKU { get; set; }
        public decimal Price { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ImagesPath { get; set; }
        public int CategoryID { get; set; }
        public int InventoryQty { get; set; }
        public int AddressID { get; set; }
        public int AccountID { get; set; }
        public int CustomFieldGroupID { get; set; }
        public string BusinessLogoPath { get; set; }
        public string CustomID { get; set; }
        public string Status { get; set; }
        public decimal Postage { get; set; }
        public string Notes { get; set; }
        public int AdTypeID { get; set; }
        public int ScheduleRuleID { get; set; }

        public virtual ProductCategory ProductCategoryObj { get; set; }
        public virtual CustomFieldGroup CustomFieldGroupObj { get; set; }
        public virtual Address AddressObj { get; set; }
        public virtual Account AccountObj { get; set; }
        public virtual ScheduleRule ScheduleRuleObj { get; set; }
        public virtual ICollection<AutoPostAdResult> AutoPostAdResults { get; set; }
        public virtual ICollection<AccountAdvertise> AccountAdvertises { get; set; }

        //[CustomValidation(typeof(AutoPostAdPostData), "ValidateImages")]
        //public ICollection<ImageDetail> Images { get; set; }

        //public class ImageDetail:BaseEntity
        //{
        //    public string FilePath { get; set; }

        //    [CustomValidation(typeof(ImageDetail),"ValidateImageSize")]
        //    public int Size { get; set; }

        //    public static ValidationResult ValidateImageSize(int size)
        //    {
        //        //if (size > 4000)
        //        //    return new ValidationResult("");
        //        //else
        //        //    return ValidationResult.Success;
        //        return ValidationResult.Success;
        //    }
        //}

        //public static ValidationResult ValidateImages(ICollection<ImageDetail> images)
        //{
        //    bool isValid =images.Count>0? images.Any(x=>!x.IsValid ):true;
        //    if (!isValid)
        //        return new ValidationResult("Image Size must be less than 4MB");
        //    return ValidationResult.Success;
        //}




    }
}
