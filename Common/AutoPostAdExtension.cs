using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using System.IO;
using HtmlAgilityPack;


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

        private static IEnumerable<HtmlNode> GetNodesByPredicate(this HtmlNode node, Func<HtmlNode, bool> predicate)
        {
            var allNodes = node.DescendantsAndSelf();
            var returnNodes = allNodes.Where(predicate);
            //if (returnNodes.Count() > 0)
            //    return returnNodes;
            //else
            //    return null;

            return returnNodes ?? null;
        }

        private static string GetInfoByPredicate(this HtmlNode node, Func<HtmlNode, bool> predicate)
        {
            if (node != null)
            {
                var targetNode = node.GetNodesByPredicate(predicate).FirstOrDefault();
                if (targetNode != null)
                {
                    return targetNode.InnerText;
                }
                else
                {
                    return string.Empty;
                }
            }
            else
            {
                return string.Empty;
            }
        }

        public static int GetTotalPage(this HtmlNode node)
        {
            var pageNumberNodes= node.GetNodesByPredicate(n =>
                n.Attributes.Contains("class") && n.Attributes["class"].Value.Contains("paginator__page-num"));

            if (pageNumberNodes != null && pageNumberNodes.Count() > 0)
            {
                return pageNumberNodes.Select(n => int.Parse(n.InnerText)).Max();
            }
            else
            {
                return 1;
            }
            
        }

        public static IEnumerable<HtmlNode> GetAdNodes(this HtmlNode node)
        {
            return node.GetNodesByPredicate(n =>
                n.Name.ToLower().Equals("a")
                && n.Attributes.Contains("class")
                && n.Attributes["class"].Value.Contains("rs-ad-title")
                && n.Attributes.Contains("href"));

        }

        public static IEnumerable<string> GetImagesByDay(this string imagesPath)
        {
            var arrImages = imagesPath.Split(';');
            var imageCount = 10;
            if (arrImages.Count() <= imageCount)
            {
                return arrImages;
            }
            else
            {
                //var day = ((int)Enum.Parse(typeof(DayOfWeek), DateTime.Now.DayOfWeek.ToString()));
                var mods = Math.Ceiling(Convert.ToDouble(arrImages.Count()) / Convert.ToDouble(imageCount));
                var totalDays = (DateTime.Today - DateTime.MinValue).TotalDays;
                var multiplyDigit = totalDays % mods;

                var takeImages = arrImages.Skip(Convert.ToInt32(multiplyDigit * imageCount)).Take(imageCount);
                if (takeImages.Count() < imageCount)
                {
                    takeImages = takeImages.Concat(arrImages.Take(imageCount - takeImages.Count()));
                }

                return takeImages;
            }
        }
    }
}
