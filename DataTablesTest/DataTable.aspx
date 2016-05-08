<%@ Page MasterPageFile="~/Main.Master" Language="C#" AutoEventWireup="true" CodeBehind="DataTable.aspx.cs" Inherits="DataTablesTest.DataTable" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="main_area"  runat="server">

    <style type="text/css">
        td.details-control {
            background: url('../Content/DataTables/images/details_open.png') no-repeat center center;
            cursor: pointer;
        }

        tr.shown td.details-control {
            background: url('../Content/DataTables/images/details_close.png') no-repeat center center;
        }

        .delete-item:hover {
            cursor: pointer;
            color: red;
        }

        .space10bot {
            margin-bottom: 10px;
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

    <link href="Content/bootstrap.css" rel="stylesheet" />
    <script src="scripts/jquery-2.2.1.js"></script>

    <%--Query Builder Scripts/css--%>
    <script src="scripts/QueryBuilder/jQuery.extendext.js"></script>
    <script src="scripts/QueryBuilder/doT.js"></script>
    <script src="scripts/QueryBuilder/query-builder.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="scripts/bootstrap.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="Content/QueryBuilder/query-builder.default.css" rel="stylesheet" />


    <%--Datatable Scripts/css--%>
    <script src="scripts/DataTables/jquery.dataTables.js"></script>
    <script src="scripts/bootstrap.js"></script>
    <link href="Content/DataTables/css/select.dataTables.min.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="Content/DataTables/css/jquery.dataTables.min.css" />

    <script type="text/javascript">

        /* Formatting function for row details - modify as you need */
        function format(rowinfo, id) {

            return '<div class="panel container">' +
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

        function CreateQueryBuilder(statesArray, panelArray) {

            //Query Builder
            $('#builder').queryBuilder({
                plugins: ['bt-tooltip-errors'],

                filters: [{
                    id: 'ProL_Name',
                    label: 'Proleit Name',
                    type: 'string'
                }, {
                    id: 'Description',
                    label: 'Description',
                    type: 'string',

                }, {
                    id: 'Address',
                    label: 'Address',
                    type: 'string'
                }, {
                    id: 'Units',
                    label: 'Units',
                    type: 'string',
                    input: 'select',
                    values: {
                        'um': 'um',
                        'mBarG': 'mBarG',
                        'kg/h': 'kg/h',
                        'kg/hr': 'kg/hr',
                        'T/F': 'T/F',
                        'bar': 'bar',
                        'RPM': 'RPM',
                        'A-C': 'A-C',
                        'kg/(m^3)': 'kg/(m^3)',
                        'uS/cm': 'uS/cm',
                        'cm': 'cm',
                        'FTU': 'FTU',
                        'Off/On': 'Off/On',
                        'NULL': 'NULL',
                        'mBar': 'mBar',
                        '%': '%',
                        'mm/s': 'mm/s',
                        'mBarA': 'mBarA',
                        '(m^3)/h': '(m^3)/h',
                        'C': 'C',
                        'A-O': 'A-O',
                        'BarA': 'BarA',
                        'm': 'm',
                        'A-A': 'A-A'
                    }

                }, {
                    id: 'Scale_4ma',
                    label: 'Scale 4ma',
                    type: 'integer'
                }, {
                    id: 'Scale_20ma',
                    label: 'Scale 20ma',
                    type: 'integer'
                }, {
                    id: 'TotalizerIncrement',
                    label: 'Totalizer Increment',
                    type: 'integer'
                }, {
                    id: 'State',
                    label: 'State',
                    type: 'string',
                    input: 'select',
                    values: statesArray
                }, {
                    id: 'Panel',
                    label: 'Panel',
                    type: 'string',
                    input: 'select',
                    values: panelArray
                }



                ],

                rules: ''
            });
        }

        $(document).ready(function () {

            //Store the states loaded from the d
            //

            //Get States and populate  select state options
            $.ajax({
                type: 'POST',
                url: 'IOLogDataService.asmx/GetStates',
                contentType: "application/json; charset=utf-8",
                dataType: "json", // dataType is json format
                success: function (data) {
                    //convert the returned data to json
                    result = jQuery.parseJSON(data.d);

                    //create the array and save the state name when looping throu the json object
                    var statesArray = new Array();

                    $.each(result.states, function (index, element) {

                        var state_Name = element.state_Name;
                        var state_Description = element.state_Description;
                        var state_nkey = element.state_nKey;

                        //populate the states array to build the querybuilder
                        statesArray.push(state_Name);

                        //create the option
                        var newOption = '<option data-toggle="tooltip" title="' + state_Description + '" value="' + state_nkey + '">' + state_Name + '</option>';
                        //append the new option to the select box
                        $('#slctStates').append(newOption);

                    });



                    var panelArray = $.map(result.panels, function (el) { return el; }); //convert the panels to javascript array
                    CreateQueryBuilder(statesArray, panelArray); //Create the Query Builder      

                }
            });

            $('#btn-reset').on('click', function () {
                $('#builder').queryBuilder('reset');
            });

            $('#btn-get-sql').on('click', function () {
                var result = $('#builder').queryBuilder('getSQL', false, false);

                if (result.sql.length) {
                    alert(result.sql + JSON.stringify(result.params, null, 2));
                    console.log(JSON.stringify(result, null, 2));
                }
            });


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
                      'width': "5px"
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
                        selected: true,
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
                    '<li>' +
                        '<a class="list-group-item">' +
                            data.Proleit_Name +
                            '<span class="glyphicon glyphicon-remove-circle pull-right"></span>' +
                        '</a>' +
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



                var index = 0;

                //var selectedDevices = new Array(); //use whats selected in the table
                var selectedDevicesList = new Array(); //use whats selected in the list

                var selectedStatenKey = $('#slctStates option:selected').val();

                var comment = $('#comment').val();
                ////loop through the table to figure out whats selected
                //table.rows('.selected').every(function (rowIdx, tableLoop, rowLoop) {
                //    selectedDevices[index] = this.data().Proleit_Name;
                //    index++;
                //});

                index = 0;
                //better performance. just looping through the li's
                $('#list li').each(function (li) {
                    selectedDevicesList[index] = $(this).text();
                    index++;
                });

                var postData =
                    {
                        selectedDevicesList: selectedDevicesList,
                        selectedStatenKey: selectedStatenKey,
                        comment: comment
                    };

                $.ajax({
                    url: 'IOLogDataService.asmx/InsertNewRecord',
                    type: 'Post',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify(postData),
                    dataType: 'json',
                    success: function (data) {
                        //put all this crap into a proper function

                        //convert response into json
                        result = jQuery.parseJSON(data.d);
                        //reload the table
                        table.ajax.reload(null, false);

                        //loop through the result
                        $.each(result.insertedDevices, function (index, element) {
                            alert(element);
                        });



                    },
                    traditional: true

                });

            });






        });

    </script>

        <div class="panel-group">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#collapse1">Advance Search</a>
                    </h4>
                </div>
                <div id="collapse1" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div id="builder"></div>
                    </div>
                    <div class="panel-footer">
                        <div class="btn-group">
                            <button type="button" class="btn btn-warning" id="btn-reset">Reset</button>
                            <button type="button" class="btn btn-primary" id="btn-get-sql">Filter Seach</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="well well-lg">

            <table id="Datatable" class="display nowrap">
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
                                                <button id="btnInsertDevices" type="button" class="btn btn-primary btn-sm">Insert New Records</button>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
       






</asp:Content>