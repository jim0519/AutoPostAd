using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoPostAdData.Models;

namespace AutoPostAdService
{
    public interface IAutoPostAdHeaderService
    {
        /// <summary>
        /// Gets an auto post ad header
        /// </summary>
        /// <param name="ID">auto post ad header identifier</param>
        /// <returns>Auto Post Ad Header</returns>
        AutoPostAdHeader GetAutoPostAdHeaderByID(int ID);

        /// <summary>
        /// Inserts an auto post ad header
        /// </summary>
        /// <param name="AutoPostAdHeader">Auto Post Ad Header</param>
        void InsertAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader);

        /// <summary>
        /// Updates the auto post ad header
        /// </summary>
        /// <param name="AutoPostAdHeader">Auto Post Ad Header</param>
        void UpdateAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader);

        /// <summary>
        /// Deletes an auto post ad header
        /// </summary>
        /// <param name="AutoPostAdHeader">Auto Post Ad Header</param>
        void DeleteAutoPostAdHeader(AutoPostAdHeader autoPostAdHeader);

        /// <summary>
        /// Gets all auto post ad headers
        /// </summary>
        
    }
}
