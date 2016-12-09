using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace AutoPostAdData.Models
{
    public partial class AutoPostAdPostData : BaseEntity
    {
        public AutoPostAdPostData()
        {
            Images = new List<ImageDetail>();
        }

        public string SKU { get; set; }
        public decimal Price { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ImagesPath { get; set; }
        public string CategoryID { get; set; }

        [CustomValidation(typeof(AutoPostAdPostData), "ValidateImages")]
        public ICollection<ImageDetail> Images { get; set; }

        public class ImageDetail:BaseEntity
        {
            public string FilePath { get; set; }
            
            [CustomValidation(typeof(ImageDetail),"ValidateImageSize")]
            public int Size { get; set; }

            public static ValidationResult ValidateImageSize(int size)
            {
                if (size > 4000)
                    return new ValidationResult("");
                else
                    return ValidationResult.Success;
            }
        }

        public static ValidationResult ValidateImages(ICollection<ImageDetail> images)
        {
            bool isValid = images.Any(x=>!x.IsValid );
            if (!isValid)
                return new ValidationResult("Image Size must be less than 4MB");
            return ValidationResult.Success;
        }

        public bool Selected { get; set; }
        

    }
}
