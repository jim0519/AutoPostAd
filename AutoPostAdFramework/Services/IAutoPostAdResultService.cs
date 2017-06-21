using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Models;
using AutoPostAdData.Models;

namespace AutoPostAdBusiness.Services
{
    public interface IAutoPostAdResultService
    {
        void InsertAutoPostAdResult(AutoPostAdResult result);

        void UpdateAutoPostAdResult(AutoPostAdResult result);

        void DeleteAutoPostAdResult(AutoPostAdResult result);

        //void DeleteAutoPostAdResult(int resultID);
    }
}
