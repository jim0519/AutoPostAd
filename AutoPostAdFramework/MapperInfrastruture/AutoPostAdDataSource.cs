using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Common.Models;

namespace AutoPostAdBusiness.MapperInfrastruture
{
    public class AutoPostAdDataSource<TOriginal, TBusiness> : List<TBusiness>
        where TOriginal : BaseEntity
        where TBusiness : BaseEntity
    {
        private IList<TOriginal> _originalDataSource;
        public AutoPostAdDataSource(IList<TOriginal> orginalDataSource)
            : base(orginalDataSource.Select(x => (TBusiness)Activator.CreateInstance(typeof(TBusiness), new object[] { x })))
        {
            _originalDataSource = orginalDataSource;
        }

        public IList<TOriginal> OrginalDataSource
        {
            get { return _originalDataSource; }
        }

        public void SynchronizeData(int id = 0)
        {
            if (id == 0)
                _originalDataSource.AsParallel().ForAll(o =>
                {
                    var pdbm = this.FirstOrDefault(b => b.ID == o.ID);
                    if (pdbm != null)
                        Mapper.Map<TBusiness, TOriginal>(pdbm, o);
                });
            else
            {
                var pdbm = this.FirstOrDefault(b => b.ID == id);
                var pd = _originalDataSource.FirstOrDefault(o => o.ID == id);
                if (pd != null && pdbm != null)
                {
                    Mapper.Map<TBusiness, TOriginal>(pdbm, pd);
                }
            }
        }

        public void RevertSynchronizeData(int id = 0)
        {
            if (id == 0)
                this.AsParallel().ForAll(o =>
                {
                    var pd = _originalDataSource.FirstOrDefault(b => b.ID == o.ID);
                    if (pd != null)
                        Mapper.Map<TOriginal,TBusiness>(pd, o);
                });
            else
            {
                var pdbm = this.FirstOrDefault(b => b.ID == id);
                var pd = _originalDataSource.FirstOrDefault(o => o.ID == id);
                if (pd != null && pdbm != null)
                {
                    Mapper.Map<TBusiness, TOriginal>(pdbm, pd);
                }
            }
        }

        //public IList<TBusiness> BusinessDataSource
        //{
        //    get { return _businessDataSource; }
        //}
    }
}
