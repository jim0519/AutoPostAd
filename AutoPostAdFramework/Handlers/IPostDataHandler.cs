using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace AutoPostAdFramework.Handlers
{
    public interface IPostDataHandler
    {
        //Save ad data from out source
        bool SaveData();

        //Provide Post Data for use
        DataSet ProvideData();

        //Validate Post Data
        //protected void ValidateData();
    }
}
