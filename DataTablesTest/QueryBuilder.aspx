<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueryBuilder.aspx.cs" Inherits="DataTablesTest.QueryBuilder" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
   
    <link href="Content/bootstrap.css" rel="stylesheet" />
     <link href="Content/QueryBuilder/query-builder.default.css" rel="stylesheet" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>

    <script src="scripts/jquery-2.2.1.js"></script>
    <script src="scripts/QueryBuilder/jQuery.extendext.js"></script>
    <script src="scripts/QueryBuilder/doT.js"></script>
    <script src="scripts/QueryBuilder/query-builder.js"></script>   
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="scripts/bootstrap.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
                  

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
                },  {
                    id: 'State',
                    label: 'State',
                    type: 'string',
                    input: 'select',
                    values: {
                        1:'Does Not Exist',2:'No Access',3: 'Not wired'
                    }
                }, {
                    id: 'Panel',
                    label: 'Panel',
                    type: 'string',
                    input: 'select',
                    values: {
                        'PB563_MCC1370': 'PB563_MCC1370',
                        'PB56205_2.08_8.10m': 'PB56205_2.08_8.10m',
                        'PB562_MCC1360': 'PB562_MCC1360',
                        'PB56304_0.13_-2.00m': 'PB56304_0.13_-2.00m',
                        'PB56502_0.12_-2.00m': 'PB56502_0.12_-2.00m',
                        'PB562_MCC1350': 'PB562_MCC1350',
                        'PV56306_2.08_8.10m': 'PV56306_2.08_8.10m',
                        'PB56501_0.12_-2.00m': 'PB56501_0.12_-2.00m',
                        'PV56302_0.12_-2.00m': 'PV56302_0.12_-2.00m',
                        'PV56307_5.05_25.70m': 'PV56307_5.05_25.70m',
                        'PV56309_5.19_25.70m': 'PV56309_5.19_25.70m',
                        'PV56204_1.04_3.20m': 'PV56204_1.04_3.20m',
                        'PV56301_0.12_-2.00m': 'PV56301_0.12_-2.00m',
                        'PV56201_0.12_-2.00m': 'PV56201_0.12_-2.00m',
                        'PV56401_0.12_-2.00m': 'PV56401_0.12_-2.00m',
                        'PV56403_4.04_19.35m': 'PV56403_4.04_19.35m',
                        'PB56306_3.06_13.20m': 'PB56306_3.06_13.20m',
                        'PV56305_2.08_8.10m': 'PV56305_2.08_8.10m',
                        'PB56206_3.06_13.20m': 'PB56206_3.06_13.20m',
                        'PB56202_012_-2.00m': 'PB56202_012_-2.00m',
                        'PB56208_5.19_25.70m': 'PB56208_5.19_25.70m',
                        'PV56402_2.04_8.10m': 'PV56402_2.04_8.10m',
                        'PB56307_5.05_25.70m': 'PB56307_5.05_25.70m',
                        'PV56205_2.08_8.10m': 'PV56205_2.08_8.10m',
                        'PB56403_4.04_19.35m': 'PB56403_4.04_19.35m',
                        'PB56302_0.12_-2.00m': 'PB56302_0.12_-2.00m',
                        'PV56501_0.12_-2.00m': 'PV56501_0.12_-2.00m',
                        'PB563_MCC1390': 'PB563_MCC1390',
                        'PB564_MCC1400': 'PB564_MCC1400',
                        'PV56207_5.05_25.70m': 'PV56207_5.05_25.70m',
                        'PV56209_5.19_25.70m': 'PV56209_5.19_25.70m',
                        'PB56308_5.19_25.70m': 'PB56308_5.19_25.70m',
                        'PV56303_0.13_-2.00m': 'PV56303_0.13_-2.00m',
                        'PB56401_0.12_-2.00m': 'PB56401_0.12_-2.00m',
                        'PV56207_3.06_13.20m': 'PV56207_3.06_13.20m',
                        'PB56204_0.13-2.00m': 'PB56204_0.13-2.00m',
                        'PB56505_4.04_19.35m': 'PB56505_4.04_19.35m',
                        'PB56303_0.13_-2.00m': 'PB56303_0.13_-2.00m',
                        'PV56502_0.12_-2.00m': 'PV56502_0.12_-2.00m',
                        'PV56308_5.05_25.70m': 'PV56308_5.05_25.70m',
                        'PB565_MCC1450': 'PB565_MCC1450',
                        'PB56504_4.04_19.35m': 'PB56504_4.04_19.35m',
                        'PB56203_0.13_-2.00m': 'PB56203_0.13_-2.00m',
                        'PB56503_2.04_8.10m': 'PB56503_2.04_8.10m',
                        'PV56203_0.13_-2.00m': 'PV56203_0.13_-2.00m',
                        'PB563_MCC1380': 'PB563_MCC1380',
                        'PB56207_5.05_25.70m': 'PB56207_5.05_25.70m',
                        'PV56304_1.04_3.20m': 'PV56304_1.04_3.20m',
                        'PB562_MCC1340': 'PB562_MCC1340',
                        'PV56208_5.05_25.70m': 'PV56208_5.05_25.70m',
                        'PV56307_3.06_13.20m': 'PV56307_3.06_13.20m',
                        'PV56202_0.12_-2.00m': 'PV56202_0.12_-2.00m',
                        'PV56206_2.08_8.10m': 'PV56206_2.08_8.10m',
                        'PV56503_2.04_8.10m': 'PV56503_2.04_8.10m',
                        'PB56305_2.08_8.10m': 'PB56305_2.08_8.10m',
                        'PB56402_2.04_8.10m': 'PB56402_2.04_8.10m',
                        'PV56504_4.04_19.35m': 'PV56504_4.04_19.35m',
                        'PB56201_0.12_-2.00m': 'PB56201_0.12_-2.00m',
                        'PB56301_0.12_-2.00m': 'PB56301_0.12_-2.00m'
                    }
                }
                


                ],

                rules: ''
            });


            $('#btn-reset').on('click', function () {
                $('#builder').queryBuilder('reset');
            });          

            $('#btn-get-sql').on('click', function () {
                var result = $('#builder').queryBuilder('getSQL', false,false);

                if (result.sql.length) {
                    alert(result.sql +  JSON.stringify(result.params, null, 2));
                    console.log(JSON.stringify(result, null, 2));
                }
            });


    
        });
    </script>
    <form id="form1" runat="server" action="log">
        
        

            <div id="builder"></div>
            <div class="btn-group">
                <button type="button" class="btn btn-warning" id="btn-reset">Reset</button>
                <button type="button" class="btn btn-primary" id="btn-get-sql">Get SQL</button>
            </div>

    </form>
</body>
</html>
