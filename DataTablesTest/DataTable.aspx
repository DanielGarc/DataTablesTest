<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataTable.aspx.cs" Inherits="DataTablesTest.DataTable" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">       
         td.details-control{
            background: url('../Content/DataTables/images/details_open.png') no-repeat center center;
            cursor: pointer;
        }
         tr.shown td.details-control{
             background: url('../Content/DataTables/images/details_close.png') no-repeat center center;
         }
    </style>
    <link rel="stylesheet" type="text/css" href="Content/DataTables/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="Content/bootstrap.css" />
    <script src="scripts/jquery-2.2.1.js"></script>
    <script src="scripts/DataTables/jquery.dataTables.js"></script>
    <script type="text/javascript">

        /* Formatting function for row details - modify as you need */
        function format(rowinfo,id) {
       
            return '<table id="subDatatable' + id + '" cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">' +
                '<thead>' +
                    '<tr>' +
                    '<th>User Name</th>' +
                    '<th>State</th>' +
                    '<th>Description</th>' +
                    '<th>Notes</th>' +
                    '<th>TimeStamp</th>' +
                    '</tr>' +
                '</thead>' +               
            '</table>'
            ;
        }

        $(document).ready(function () {

            //create main table
            $('#Datatable').DataTable({
                columns: [
                  {
                      'className': 'details-control',
                      'orderable': false,
                      'data': null,
                      'defaultContent': ''
                  },
                  { 'data': 'Proleit_Name' },
                  { 'data': 'Description' },
                  { 'data': 'State' },
                  { 'data': 'Address' },
                  { 'data': 'Units' },
                  { 'data': 'Scale_4ma' },
                  { 'data': 'Scale_20ma' },
                  { 'data': 'TotalizerIncrement' },
                  { 'data': 'Panel' }                 
                ],
                paging:true,
                stateSave: true,
                scrollY: "30vh",
                scrollX: true,              
                processing: true,                
                bServerSide: true,
                sAjaxSource: 'GetDevicesGHandler.ashx'              
            
                
            });

            var table = $('#Datatable').DataTable();

            $('#Datatable tbody').on('click', 'td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = table.row(tr);

                if (row.child.isShown()) {
                    //this row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                }
                else {
                    //open this row                    
                    row.child(format(row.data(), row.index())).show();
                    tr.addClass('shown');
                    //alert(row.data().Proleit_Name);

                  
                        //need to add custom table data from sql and everything else
                    $('#subDatatable' + row.index()).DataTable({                        
                        bServerSide: true,
                        sAjaxSource: 'IOLogDataService.asmx/GetIOLogForDevice',
                        sServerMethod: 'post'
                    });

                    //var obj = {};
                    //obj.name = row.data().Proleit_Name;
                    //obj.age = 10;
                    //$.ajax({
                    //    type: "POST",
                    //    url: "IOLogDataService.asmx/TestMethod",
                    //    data: JSON.stringify(obj),
                    //    contentType: "application/json; charset=utf-8",
                    //    dataType: "json",
                    //    success: function (r) {
                    //        alert(r.d);
                    //    }
                    //});
                   
                }

                   
            });

            //change color of selected row
            $('#Datatable tbody').on('click', 'tr', function () {

                //var id = table.row(this).index();
                //var data = table.row(this).data();
                //alert('Clicked row id ' + id + ' ' +data);
                //console.log(data);

                $(this).toggleClass('selected');
            
            });



            //$('#Datatable').click(function () {
            //    alert(table.rows('.selected').id() + ' row(s) selected');
            //});

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="bg-success">
     <table id="Datatable" class="display nowrap" style="width:100%" >
            <thead>
                <tr>       
                    <th></th>       
                    <th>Proleit Name</th>
                    <th>Description</th>
                    <th>State</th>
                    <th>Address</th>
                    <th>Units</th>
                    <th>4ma</th>
                    <th>20ma</th>
                    <th>TI</th>
                    <th>Panel</th>
                </tr>
            </thead>
         <tbody>

         </tbody>
         </table>
      
    </div>
    </form>
</body>
</html>
