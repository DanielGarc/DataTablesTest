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

         .delete-item:hover{
             cursor:pointer;
             color:red;
         }
         .space10bot{
             margin-bottom:10px;
         }
        .navbar .divider-vertical {
            height: 40px;
            margin: 0 9px;
            border-left: 1px solid #f2f2f2;
            border-right: 1px solid #ffffff;
        }
        @media ( min-width: 768px ) {
            .grid-divider {
                position: relative;
                padding: 0;
            }

                .grid-divider > [class*='col-'] {
                    position: static;
                }

                    .grid-divider > [class*='col-']:nth-child(n+2):before {
                        content: "";
                        border-left: 1px solid #DDD;
                        position: absolute;
                        top: 0;
                        bottom: 0;
                    }

            .col-padding {
                padding: 0 15px;
            }
        }
    </style>
    <link rel="stylesheet" type="text/css" href="Content/DataTables/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="Content/bootstrap.css" />
    <script src="scripts/jquery-2.2.1.js"></script>
    <script src="scripts/DataTables/jquery.dataTables.js"></script>
    <script src="scripts/bootstrap.js"></script>
    <link href="Content/DataTables/css/select.dataTables.min.css" rel="stylesheet" />
    <script type="text/javascript">

        /* Formatting function for row details - modify as you need */
        function format(rowinfo,id) {
       
            return '<div class="panel container">'+
            '<table id="subDatatable' + id + '" class="display">' +
                '<thead>' +
                    '<tr>' +
                    '<th>User Name</th>' +
                    '<th>State</th>' +
                    '<th>Description</th>' +
                    '<th>Notes</th>' +
                    '<th>TimeStamp</th>' +
                    '</tr>' +
                '</thead>' +               
            '</table>' +
                '<div/>'
            ;
        }

        $(document).ready(function () {

            //create main table
            $('#Datatable').DataTable({
                columns: [
                  {
                      'orderable': false,
                      'className': 'select-checkbox',
                      'targets': 0,
                      'data': null,
                      'defaultContent': ''

                  },
                  {
                      'className': 'details-control',
                      'orderable': false,
                      'data': null,
                      'defaultContent': '',
                      'width':"5px"
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

                lengthMenu: [[10, 20, 50, -1], [10, 20, 50, "All"]],
                paging: true,
                stateSave: true,
                scrollY: "50vh",
                scrollX: true,
                processing: true,
                bServerSide: true,
                sAjaxSource: 'GetDevicesGHandler.ashx',
                select: {
                    style: 'os',
                    selector: 'td:first-child'
                },


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
                        columns: [
                          {
                              'data': 'UserName',
                              'orderable': false
                          },
                          {
                              'data': 'State',
                              'orderable': false

                          },
                          {
                              'data': 'Description',
                              'orderable': false

                          },
                          {
                              'data': 'Notes',
                              'orderable': false

                          },
                          {
                              'data': 'TimeStamp',
                              'orderable': false

                          },
                        ],
                        order: [[4, "desc"]],
                        bServerSide: true,
                        bFilter: false,
                        paging: false,
                        sAjaxSource: 'GetIOLogForDeviceHandler.ashx',
                        fnServerParams: function (aoData) {
                            aoData.push({ "name": "selectedValue", "value": row.data().Proleit_Name });
                        }



                    });

                   
                   
                }

                   
            });

         
            //change color of selected row, add remove elements to the list
            $('#Datatable tbody').on('click', 'tr', function () {

                var data = table.row(this).data();
                var itemFound = false;
          
                $(this).toggleClass('selected');
              
                $('#list li').each(function () {

                    if ($(this).text() === data.Proleit_Name) {
                        itemFound = true;
                        $(this).remove();
                    }

                });
                if (itemFound == false) {

                    var listitem = 
                    '<li>'+
                        '<a class="list-group-item">'   +
                            data.Proleit_Name   +
                            '<span class="glyphicon glyphicon-remove-circle pull-right"></span>'    +
                        '</a>'  +
                    '</li>';
                    $("#list").append(listitem);
                                  
                }             
            
            });

            $("#list").on("click", ".list-group-item", function (event) {
                removeClassFrom = $(this).text();             
        
                //Search the main datatable and remove the selected class
                table.rows().every(function (rowIdx, tableLoop, rowLoop) {
                    var data = this.data();
                   
                    if (data.Proleit_Name === removeClassFrom) {
                        $(this.row(rowIdx).node()).toggleClass('selected');
                    }
                });
             
                //Remove li object
                $(this).parent().remove();

               
            });

            $('#btnInsertDevices').click(function () {

             
                var table = $('#Datatable').DataTable();
                var index = 0;
                var selectedDevices = new Array();
                table.rows('.selected').every(function (rowIdx, tableLoop, rowLoop) {
                    selectedDevices[index] = this.data().Proleit_Name;
                    index++;
                });

                var postData = { selectedDevices: selectedDevices };

                $.ajax({
                    url: 'IOLogDataService.asmx/InsertNewRecord',
                    type: 'Post',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify(postData),
                    dataType: 'json',
                    success: function (data) {
                        alert(data);

                    },
                    traditional: true

                });
                
            });


            var jsonStates = {
                'PB563_MCC1370': 'PB563_MCC1370',
                'PB56205_2.08_8.10m': 'PB56205_2.08_8.10m',
                'PB562_MCC1360': 'PB562_MCC1360'
            };
                       
            $.each(jsonStates, function (i, value) {
                $('#slctStates').append($('<option>').text(value).attr('value', value));
            });

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">


            <div class="panel-group" id="accordion">
                <div class="panel panel-default">
                    <h4>
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">Advance Search
                        </a>
                    </h4>
                </div>
                <div id="collapse1" class="panel-collapse collapse in">
                    <div class="panel-body">
                        Some body here
                    </div>
                </div>

            </div>
        </div>

        <div class="well well-lg">

            <table id="Datatable" class="display nowrap" width="100%">
                <thead>
                    <tr>
                        <th></th>
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
   
        <div class="container">
            <div id="pnlInsertNewRecord" class="panel-group">
                <div class="panel panel-default">
                    <div class="panel-heading"> 
                     <button data-toggle="collapse" type="button" class="btn btn-primary btn-group-sm" data-target="#collapse">Insert New Records</button>
                    </div>
                    <div class="panel-body collapse" id="collapse">
                        <div class="form-group">
                            <div class="container">
                                <div class="row grid-divider">
                                    <div class="col-sm-3">
                                        <div class="col-padding">
                                            <ul id="list" class="list-group">                                              
                                            
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="col-padding">
                                            <select id="slctStates" class="form-control">
                                            </select>
                                            <label for="comment">Comment:</label>
                                            <textarea class="form-control space10bot" rows="5" id="comment"></textarea>

                                            <div class="btn-toolbar">
                                                <button id="btnInsertDevices" type="button" class="btn btn-primary btn-lg">Insert New Records</button>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div> 
        </div>

    </form>
</body>
</html>
