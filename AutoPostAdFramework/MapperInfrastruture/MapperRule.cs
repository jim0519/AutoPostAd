using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using AutoPostAdBusiness.BusinessModels;
using AutoMapper;
using Common.Infrastructure;
using AutoPostAdBusiness.DropshipSOAP;
using Common;


namespace AutoPostAdBusiness.MapperInfrastruture
{
    public class MapperRule : IStartupTask
    {
        public void Execute()
        {
            Mapper.Initialize(cfg => {

                //AutoPostAdPostData,AutoPostAdPostDataBM
                cfg.CreateMap<AutoPostAdPostData, AutoPostAdPostDataBM>().ForMember(dest => dest.Result, mce => mce.Ignore())
                .ForMember(dest => dest.ResultMessage, mce => mce.Ignore())
                .ForMember(dest => dest.Selected, mce => mce.Ignore());

                cfg.CreateMap<AutoPostAdPostDataBM, AutoPostAdPostData>().ForMember(dest => dest.ID , mce => mce.Ignore());

                //
                cfg.CreateMap<AutoPostAdPostData, QuickSalePostAdPostDataBM>().ForMember(dest => dest.Result, mce => mce.Ignore())
                .ForMember(dest => dest.ResultMessage, mce => mce.Ignore())
                .ForMember(dest => dest.Selected, mce => mce.Ignore());
                cfg.CreateMap<QuickSalePostAdPostDataBM, AutoPostAdPostData>().ForMember(dest => dest.ID, mce => mce.Ignore());

                cfg.CreateMap<catalogCategoryTree, catalogCategoryEntity>().ForMember(dest=>dest.is_active,mce=>mce.UseValue<int>(1));

                //Mapper.CreateMap<catalogCategoryTree, catalogCategoryEntity>().AfterMap((o, d) => d.is_active = (d.is_active.Equals(0) ? 1 : d.is_active));

            });
        }


        #region IStartupTask Members


        public int Order
        {
            get { return 0; }
        }

        #endregion
    }

}
