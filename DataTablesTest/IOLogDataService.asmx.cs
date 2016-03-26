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
        public string TestMethod(object age, object name)
        {
            return string.Format("Name: {0}{2}Age: {1}", name, age, Environment.NewLine);
        }

        [WebMethod]
        public void GetIOLogForDevice(int iDisplayLength, int iDisplayStart, int iSortCol_0, string sSortDir_0, string sSearch)//, string sSortDir_1, string sSearch)
        {


            //Info from the Datatable API
            int displayLength = Convert.ToInt32(iDisplayLength);
            //in case paging is disabled
            if (displayLength == -1)
            {
                displayLength = GetDevicesCount();
            }

            int displayStart = Convert.ToInt32(iDisplayStart);
            int sortCol_0 = Convert.ToInt32(iSortCol_0);
            int sortCol_1 = -1;
            string sortDir_0 = sSortDir_0.ToString();
            //string sortDir_1 = sSortDir_1;
            //string search = sSearch;

            int res = -1;
            //if (int.TryParse(iSortCol_1.ToString(),out res))
            //{
            //    sortCol_1 = res;
            //}

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

            //Here is where we are storing the data

            List<IODevices> devices = new List<IODevices>();

            //how many items do we have in total after the filtering is done
            int filteredCount = 0;

            using (SqlConnection con = new SqlConnection(cs))
            {
                //Create a commmand to call the sql store procedure which return the formatted data
                SqlCommand cmd = new SqlCommand("GetDevicesTable", con);
                cmd.CommandType = CommandType.StoredProcedure;

                //Add the parameters
                //cmd.Parameters.Add("@searchBox", SqlDbType.NVarChar, 255).Value = search;
                cmd.Parameters.Add("@orderbyColumn_0", SqlDbType.Int).Value = sortCol_0;
                cmd.Parameters.Add("@sortDirection_0", SqlDbType.NVarChar, 50).Value = sortDir_0;
                cmd.Parameters.Add("@orderbyColumn_1", SqlDbType.Int).Value = sortCol_1;
                //cmd.Parameters.Add("@sortDirection_1", SqlDbType.NVarChar, 50).Value = sortDir_1;
                cmd.Parameters.Add("@displayLength", SqlDbType.Int).Value = displayLength;
                cmd.Parameters.Add("@displayStart", SqlDbType.Int).Value = displayStart;

                //Open the connection
                con.Open();

                //Reader
                SqlDataReader reader = cmd.ExecuteReader();

                //loop through the returned data
                while (reader.Read())
                {
                    //Get the filtered count from the Database
                    filteredCount = Convert.ToInt32(reader["TotalCount"].ToString());

                    //Get all the columns
                    IODevices device = new IODevices();
                    device.Proleit_Name = reader["ProL_Name"].ToString();
                    device.Description = reader["Description"].ToString();
                    device.State = reader["State"].ToString();
                    device.Address = reader["Address"].ToString();
                    device.Units = reader["Units"].ToString();
                    device.Scale_4ma = reader["Scale_4ma"].ToString();
                    device.Scale_20ma = reader["Scale_20ma"].ToString();
                    device.TotalizerIncrement = reader["TotalizerIncrement"].ToString();
                    device.Panel = reader["Panel"].ToString();

                    //add them to the list
                    devices.Add(device);
                }

                var result = new
                {
                    iTotalRecords = GetDevicesCount(),
                    iTotalDisplayRecords = filteredCount,
                    aaData = devices
                };
                JavaScriptSerializer js = new JavaScriptSerializer();
                Context.Response.Write(js.Serialize(result));

                con.Close();

            }
        }
        private int GetDevicesCount()
        {
            int totalCount;

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;


            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("Select count(*) from [IOCheckOutView]", con);
                con.Open();
                totalCount = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();
            }

            return totalCount;
        }

    }
}

