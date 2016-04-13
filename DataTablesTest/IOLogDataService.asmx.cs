using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace DataTablesTest
{
    /// <summary>
    /// Summary description for IOLogDataService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class IOLogDataService : System.Web.Services.WebService
    {
        [WebMethod]
        public string InsertNewRecord(List<string> selectedDevices)
        {
            return "";
            //return string.Format("Name: {0}{2}Age: {1}", name, age, Environment.NewLine);
        }

    

    }
}

