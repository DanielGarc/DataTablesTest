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
using System.Xml.Serialization;
using System.IO;
using System.Text;

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
        public string InsertNewRecord(List<string> selectedDevicesList,int selectedStatenKey, string comment)
        {
            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

           
        
            //use to inform the client if the insert was succesful
            bool success = true;

            //if we have an error
            List<string> error = new List<string>();

            //List to be populate with the successfull inserts, sql will inform of this
            List<string> insertedDevices = new List<string>();
            

            //Convert List of Devices into XML 
            XmlSerializer xs = new XmlSerializer(typeof(List<string>));
            MemoryStream ms = new MemoryStream();
            xs.Serialize(ms, selectedDevicesList);

            string resultXML = UTF8Encoding.UTF8.GetString(ms.ToArray());

            try
            {

                using (SqlConnection con = new SqlConnection(cs))
                {
                    //Create Command
                    SqlCommand cmd = new SqlCommand("InsertNewLogItem", con);
                    //Store procedure
                    cmd.CommandType = CommandType.StoredProcedure;
                    //Add the parameters
                    cmd.Parameters.Add("@XMLDevices", SqlDbType.NVarChar).Value = resultXML;
                    cmd.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = "test";
                    cmd.Parameters.Add("@State_nKey", SqlDbType.Int).Value = selectedStatenKey;
                    cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = comment;
                    //open the conection
                    con.Open();
                    //Reader
                    SqlDataReader reader = cmd.ExecuteReader();
                    //Read the succesfull inserts from the DB
                    while (reader.Read())
                    {
                        insertedDevices.Add(reader["Devices"].ToString());
                    }

                    con.Close();


                }

            }
            catch (Exception e)
            {
                error.Add(e.ToString());
                success = false;
            }


            var result = new
            {
                insertedDevices = success ? insertedDevices : error,
                success = success
            };

            JavaScriptSerializer js = new JavaScriptSerializer();

            string tresult = js.Serialize(result);
         

            return js.Serialize(result);

            //return string.Format("Name: {0}{2}Age: {1}", name, age, Environment.NewLine);
        }

        [WebMethod]        
        public string GetStates()
        {
            //Create an object to store the states returns
            List<States> states = new List<States>();

            //Get the panel names
            List<string> panels = new List<string>();

            string cs = ConfigurationManager.ConnectionStrings["SSM6911CS"].ConnectionString;

            using(SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("GetStates", con);

                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                //SqlDataReader reader = cmd.ExecuteReader();

                //while (reader.Read())
                //{
                //    States state = new States();
                //    state.state_nKey = Int32.Parse(reader[0].ToString());
                //    state.state_Name = reader[1].ToString();
                //    state.state_Description = reader[2].ToString();

                //    states.Add(state);
                //}

                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    States state = new States();
                    state.state_nKey = Int32.Parse(item[0].ToString());
                    state.state_Name = item[1].ToString();
                    state.state_Description = item[1].ToString();

                    states.Add(state);
                }

                foreach (DataRow item in ds.Tables[1].Rows)
                {
                    panels.Add(item[0].ToString());                    
                }

                con.Close();

              

         
            }

            var result = new
            {
                states = states,
                panels = panels
            };

            JavaScriptSerializer js = new JavaScriptSerializer();

            return js.Serialize(result);

        }


    }

   

}

