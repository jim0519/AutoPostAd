using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using System.IO;


namespace Common
{
    public static class AutoPostAdExtension
    {
        //public static FileInfo[] GetImages(this AutoPostAdPostData obj)
        //{
        //    string[] units = new string[] { "byte", "kb", "mb", "gb", "tb" };
        //    string[] imageExtensions = new string[] { ".JPG", ".JPE", ".BMP", ".GIF", ".PNG" };
        //    string unit = "mb";
        //    int size = 4;

        //    Int64 convertedSize = size * new Func<int, int>(x =>
        //    {
        //        int i = 0;
        //        int returnMultuply = 1;
        //        while (i < x)
        //        {
        //            returnMultuply *= 1024;
        //            i++;
        //        }
        //        return returnMultuply;
        //    }).Invoke(units.Select((s, i) =>
        //    {
        //        if (s.ToLowerInvariant() == unit.ToLowerInvariant())
        //            return i;
        //        else
        //            return -1;
        //    }).FirstOrDefault(x => x != -1));

        //    FileInfo[] returnFileInfos =string.IsNullOrEmpty(obj.ImagesPath)?null : obj.ImagesPath.Split(';').Select(s => 
        //    {
        //        bool invalid = false;
        //        FileInfo fi = new FileInfo(s);
        //        if (fi.Exists)
        //        {
        //            if (!imageExtensions.Contains(fi.Extension.ToUpperInvariant()))
        //                invalid = true;

        //            if (fi.Length >= convertedSize)
        //                invalid = true;
        //        }
        //        else
        //        {
        //            invalid = true;
        //        }
        //        if (!invalid)
        //            return fi;
        //        else
        //            return null;
        //    }).ToArray();

        //    return returnFileInfos;
        //}

        public static string ToIntString(this bool Value)
        {
            return Convert.ToInt32(Value).ToString();
        }
    }
}
