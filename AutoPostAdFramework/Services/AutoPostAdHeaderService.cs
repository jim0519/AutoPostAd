using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;
using Common.Models;

namespace AutoPostAdBusiness.Services
{
    public class AutoPostAdHeaderService:IAutoPostAdHeaderService
    {
        #region Fields

        private readonly IRepository<AutoPostAdHeader> _autoPostAdHeaderRepository;
        private readonly IRepository<AutoPostAdLine> _autoPostAdLineRepository;

        #endregion

        #region Ctor

        public AutoPostAdHeaderService(IRepository<AutoPostAdHeader> autoPostAdHeaderRepository,
            IRepository<AutoPostAdLine> autoPostAdLineRepository)
        {
            this._autoPostAdHeaderRepository = autoPostAdHeaderRepository;
            this._autoPostAdLineRepository = autoPostAdLineRepository;
        }

        #endregion

        public virtual void InsertAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        {
            if (autoPostAdHeader == null)
                throw new ArgumentNullException("autoPostAdHeader");

            _autoPostAdHeaderRepository.Insert(autoPostAdHeader);

        }

        public virtual void UpdateAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        {
            if (autoPostAdHeader == null)
                throw new ArgumentNullException("autoPostAdHeader");

            _autoPostAdHeaderRepository.Update(autoPostAdHeader);

        }

        public virtual void DeleteAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader)
        {
            if (autoPostAdHeader == null)
                throw new ArgumentNullException("autoPostAdHeader");

            _autoPostAdHeaderRepository.Delete(autoPostAdHeader);

        }

        public virtual AutoPostAdHeader GetAutoPostAdHeaderByID(int ID)
        {
            if (ID == 0)
                return null;

            return _autoPostAdHeaderRepository.GetById(ID);
        }
    }
}
