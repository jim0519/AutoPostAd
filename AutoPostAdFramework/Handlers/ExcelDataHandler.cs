using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace AutoPostAdFramework.Handlers
{
    public class ExcelDataHandler:IPostDataHandler
    {
        string _filePath;
        public ExcelDataHandler(string filePath="")
        {
            _filePath = filePath;
        }

        #region IPostDataHandler Members

        public bool SaveData()
        {
            throw new NotImplementedException();
        }

        public System.Data.DataSet ProvideData()
        {
            throw new NotImplementedException();
        }

        protected void ValidateData()
        { 
            
        }

        #endregion
    }
}
