using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using DataTablesTest.Classes;

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

        [WebMethod]        
        public List<States> GetStates()
        {
            //Create an object to store the states returns
            List<States> states = new List<States>();

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

            using(SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("GetStates", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    States state = new States();
                    state.state_nKey = Int32.Parse(reader[0].ToString());
                    state.state_Name = reader[1].ToString();
                    state.state_Description = reader[2].ToString();
                    states.Add(state);
                }

                con.Close();      
                
            }

            return states;

        }


    }

   

}

