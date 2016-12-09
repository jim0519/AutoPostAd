using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;
using Common.Models;

namespace AutoPostAdBusiness.Services
{
    public class AutoPostAdResultService:IAutoPostAdResultService
    {
        private readonly IRepository<AutoPostAdResult> _autoPostAdResultRepository;

         #region Ctor

        public AutoPostAdResultService(IRepository<AutoPostAdResult> autoPostAdResultRepository)
        {
            this._autoPostAdResultRepository = autoPostAdResultRepository;
        }

        #endregion

        #region IAutoPostAdResultService Members

        public void InsertAutoPostAdResult(Common.Models.AutoPostAdResult result)
        {
            if (result == null)
                throw new ArgumentNullException("AutoPostAdResult");

            _autoPostAdResultRepository.Insert(result);
        }

        public void UpdateAutoPostAdResult(Common.Models.AutoPostAdResult result)
        {
            if (result == null)
                throw new ArgumentNullException("AutoPostAdResult");

            _autoPostAdResultRepository.Update(result);
        }

        public void DeleteAutoPostAdResult(Common.Models.AutoPostAdResult result)
        {
            if (result == null)
                throw new ArgumentNullException("AutoPostAdResult");

            _autoPostAdResultRepository.Delete(result);
        }

        #endregion
    }
}
