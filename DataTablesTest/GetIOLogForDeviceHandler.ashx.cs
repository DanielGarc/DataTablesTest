using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace DataTablesTest
{
    /// <summary>
    /// Summary description for GetIOLogForDeviceHandler
    /// </summary>
    public class GetIOLogForDeviceHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            //Info from the Datatable API
            string selectedRowDevice = context.Request["selectedValue"];

            int displayLength = int.Parse(context.Request["iDisplayLength"]);
            //in case paging is disabled
            if (displayLength == -1)
            {
                displayLength = GetDevicesCount(selectedRowDevice);
            }

           
            int displayStart = int.Parse(context.Request["iDisplayStart"]);
            int sortCol_0 = int.Parse(context.Request["iSortCol_0"]);
            int sortCol_1 = -1;
            string sortDir_0 = context.Request["sSortDir_0"];
            string sortDir_1 = context.Request["sSortDir_1"];
            string search = context.Request["sSearch"];

            int res = -1;
            if (int.TryParse(context.Request["iSortCol_1"], out res))
            {
                sortCol_1 = res;
            }

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

            //Here is where we are storing the data

            List<DeviceLog> log = new List<DeviceLog>();

            //how many items do we have in total after the filtering is done
            int filteredCount = 0;

            using (SqlConnection con = new SqlConnection(cs))
            {
                //Create a commmand to call the sql store procedure which return the formatted data
                SqlCommand cmd = new SqlCommand("GetLogTable", con);
                cmd.CommandType = CommandType.StoredProcedure;

                //Add the parameters
                cmd.Parameters.Add("@selectedRow", SqlDbType.NVarChar, 255).Value = selectedRowDevice;
                cmd.Parameters.Add("@orderbyColumn_0", SqlDbType.Int).Value = sortCol_0;
                cmd.Parameters.Add("@sortDirection_0", SqlDbType.NVarChar, 50).Value = sortDir_0;
                cmd.Parameters.Add("@orderbyColumn_1", SqlDbType.Int).Value = sortCol_1;
                cmd.Parameters.Add("@sortDirection_1", SqlDbType.NVarChar, 50).Value = sortDir_1;
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
                    DeviceLog devicelog = new DeviceLog();
                    devicelog.UserName = reader["UserName"].ToString();
                    devicelog.State = reader["State"].ToString();
                    devicelog.Description = reader["Description"].ToString();
                    devicelog.Notes = reader["Notes"].ToString();
                    devicelog.TimeStamp = reader["TimeStamp"].ToString();


                    //add them to the list
                    log.Add(devicelog);
                }

                var result = new
                {
                    iTotalRecords = GetDevicesCount(selectedRowDevice),
                    iTotalDisplayRecords = filteredCount,
                    aaData = log
                };
                JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.Write(js.Serialize(result));

                con.Close();

            }

        }

        private int GetDevicesCount(string ProL_Name)
        {
            int totalCount;

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

            string logcount = "SELECT COUNT(*) FROM IOCheckOutView WHERE PROL_NAME='" + ProL_Name + "'";

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(logcount, con);
                con.Open();
                totalCount = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();
            }

            return totalCount;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}