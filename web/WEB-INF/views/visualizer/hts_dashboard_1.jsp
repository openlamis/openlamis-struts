<%-- 
    Document   : Patient
    Created on : Feb 8, 2012, 1:15:46 PM
    Author     : AALOZIE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>LAMIS 2.6</title>
        <!--<link type="image/png" rel="icon" href="images/favicon.png" />-->

        <jsp:include page="/WEB-INF/views/template/css.jsp" />        
        <!--<link type="text/css" rel="stylesheet" href="assets/highchart/css/highcharts.css" />-->
        
        <link type="text/css" rel="stylesheet" href="assets/chart-asset/daterangepicker.css" />
		<link type="text/css" rel="stylesheet" href="css/lamis.css" />
				
        <jsp:include page="/WEB-INF/views/template/javascript.jsp" /> 
        <script type="text/javascript" src="js/json.min.js"></script>
        <script type="text/javascript" src="js/highchart/highcharts.js"></script> 
		<script src="http://code.highcharts.com/maps/modules/map.js"></script>
        <script type="text/javascript" src="js/highchart/highcharts-3d.js"></script>
        <script type="text/javascript" src="js/highchart/modules/exporting.js"></script>  
        <script type="text/javascript" src="js/highchart/moment.min.js"></script>
        <script type="text/javascript" src="js/highchart/daterangepicker.js"></script>
		<script src="https://code.highcharts.com/maps/highmaps.js"></script>
		<script src="https://code.highcharts.com/mapdata/countries/ng/ng-all.js"></script>
        <script type="text/javascript" src="js/lamis/hts-chart.js"></script> 
		

        <style>
           .highcharts-container {
                width: 100%;
                height: 100%;
            } 
            i.fa{
                font-size: 36px;
                color: #FFFFFF;
            }
            .card-title{
                font-size: 15px;
                color: #fffff;
                font-weight: bold;
            }
            .ninety{
                background-color: #FF6600;
                color: #FFFFFF;
            }
            .bgInfo{
                background-color: rgb(42, 87, 136);
            }
            .bgGrey{
                background-color: #001aa3\9;
            }
            .bg-flat-color-1 {
                background: #5c6bc0;
            }

            .bg-flat-color-2 {
                background: #FF6600;
            }
            .form-control{
                font-size: 16px;
            }
			
			.container8 {
				height: 500px; 
				min-width: 310px; 
				max-width: 800px; 
				margin: 0 auto; 
			}
			.loading {
				margin-top: 10em;
				text-align: center;
				color: gray;
			}

        </style>
    </head>

    <body>
        <div class="wrapper">
            <jsp:include page="/WEB-INF/views/template/menu_dashboard.jsp" />  
            <div class="main-panel">

                <div class="mt-5"></div>
                <div class="content col-10 mr-auto ml-auto">
                   <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="Dashboard_page">Visualizer</a></li>
                        <li class="breadcrumb-item active">AKS Control Room Dashboard</li>
                    </ol>
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <s:form id="lamisform" theme="css_xhtml">
                                        <div class="row">
                                            <div class="col-md-3 form-group">
                                                <label>IP</label>
                                                <select name="ipId" id="ipId" class="form-control select2" style="width: 100%;">
                                                    <option value="0">FHI360</option>
                                                    
                                                </select>
                                            </div>
                                            <div class="col-md-3 form-group">
                                                <label>State</label>
                                                <select name="stateId" id="stateId" class="form-control select2" style="width: 100%;">
                                                    <option value="0">Select</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3 form-group">
                                                <label>LGA</label>
                                                <select name="lgaId" id="lgaId" class="form-control select2" style="width: 100%;">
                                                    <option value="0">Select</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3 form-group">
                                                <label>Facility</label>
                                                <select name="facilityId" id="facilityId" class="form-control select2" style="width: 100%;">
                                                    <option value="0">Select</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-3 form-group">
                                                <label>Date From</label>
                                               <div class="input-group">
                                                        <div class="input-group-prepend">
                                                            <div class="input-group-text">
                                                                <i class="fa fa-calendar" style="font-size:16px; color: #ccc;"></i>
                                                            </div>
                                                        </div>
                                                     <input type="text" name="reportingLabel" id="reportingLabel" class="form-control datepicker">
                                                </div>
                                            </div>
                                            <div class="col-md-3 form-group">
                                                <label>Date To</label>
                                               <div class="input-group">
                                            <div class="input-group-prepend">
                                                <div class="input-group-text">
                                                    <i class="fa fa-calendar" style="font-size:16px; color: #ccc;"></i>
                                                </div>
                                            </div>
                                                    <input type="text" name="reportingLabel2" id="reportingLabel2" class="form-control datepicker">
                                                </div>
                                            </div>
                                            <div class="col-md-4 form-group">
                                                <br/>
                                                <button id="ok_button" type="button" class="btn btn-sm btn-info">Generate</button>
                                               <input type="hidden" name="reportingDateBegin" id="reportingDateBegin" class="form-control datepicker">
                                                <input type="hidden" name="reportingDateEnd" id="reportingDateEnd" class="form-control">
                                            </div>
                                        </div>
                                    </s:form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <span id="loader"></span>
                        </div>
                    </div>
                    <!-- Summary Section -->
                    <div class="row">
                        <div class="col-md-10 mr-auto ml-auto">
                            <h3 id="reportLabel" style="text-align:center;"></h3>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-4 col-md-4 mb-2">
                            <div class="card border-left border-5 border-secondary bg-info">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-white mb-1">Total Tested</div>
                                            <div id="totalTested" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fa fa-users fa-2x text-gray-light"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Total Positive -->
                        <div class="col-xl-4 col-md-4 mb-2">
                            <div class="card border-left border-5 border-secondary bg-flat-color-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-white mb-1">Total Positive</div>
                                            <div class="row no-gutters align-items-center">
                                                <div class="col-auto">
                                                    <div id="totalPositive" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">0</div>
                                                </div>
                                                <div class="col" id="positive">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fa fa-user-plus fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Total Enrolled on ART -->
                        <div class="col-xl-4 col-md-4 mb-2">
                            <div class="card border-left border-5 border-secondary bg-success">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-white mb-1">Total Initiated on ART</div>
                                            <div class="row no-gutters align-items-center">
                                                <div class="col-auto">
                                                    <div id="totalInitiated" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">0</div>
                                                </div>
                                                <div class="col" id="initiated">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fa fa-user-circle-o fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <div class="card card-chart">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container1"></div>
                                    </div>
                                </div>
				</div>
				</div>
				<div class="col-md-6 mb-2">
				<div class="card card-chart">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container2"></div>
                                    </div>
                                </div>
                            </div>
			</div>
			</div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <div class="card card-chart">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container4"></div>
                                    </div>
                                     </div>
					</div>
					</div>
				<div class="col-md-6 mb-2">
                            <div class="card card-chart">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container3"></div>
                                    </div>
                                </div>
                            </div>
			</div>
			</div>
			<div class="row">
                        <div class="col-md-6">
                            <div class="card card-chart">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container5"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-chart shadow">
                                <div class="card-body">
                                    <div class="chart-area">
                                        <div id="container6"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="footer">
                
            </div>
        </div>
        <script type="text/JavaScript">

            for(i = new Date().getFullYear(); i > 1900; i--) {
            $("#reportingYearBegin").append($("<option/>").val(i).html(i));
            $("#reportingYearEnd").append($("<option/>").val(i).html(i));
            }


            $(document).ready(function(){          
                $('.datepicker').datepicker({
                    format: 'mm/dd/yyyy',
                    maxDate: new Date()
                });
             
            $.ajax({
            url: "StateId_retrieve.action",
            dataType: "json",
            success: function(stateMap) {
            var options = "<option value = '0'>" + 'Select' + "</option>";
            $.each(stateMap, function(key, value) {
            options += "<option value = '" + key + "'>" + value + "</option>";
            }); //end each
            $("#stateId").html(options);                        
            }                     
            }); //end of ajax call
            $("#stateId").change(function(event){
            $.ajax({
            url: "LgaId_retrieve.action",
            dataType: "json",
            data: {stateId: $("#stateId").val()},
            success: function(lgaMap) {
            var options = "<option value = '0'>" + 'Select' + "</option>";
            $.each(lgaMap, function(key, value) {
            options += "<option value = '" + key + "'>" + value + "</option>";
            }); //end each
            $("#lgaId").html(options);                        
            }                    
            }); //end of ajax call
            }); 

            $("#lgaId").change(function(event){
            $.ajax({
            url: "Facility_retrieve.action",
            dataType: "json",
            data: {stateId: $("#stateId").val(), lgaId: $("#lgaId").val()},

            success: function(facilityMap) {
            var options = "<option value = '0'>" + '' + "</option>";
            $.each(facilityMap, function(key, value) {
            options += "<option value = '" + key + "'>" + value + "</option>";
            }) //end each
            $("#facilityId").html(options);                        
            }                    
            }); //end of ajax call
            }); 
			
			//jsonmap();
			
            var start = moment().subtract(6, 'months');
            var end = moment();

            function cb(start, end) {
                $('#reportingDateBegin').val(start.format('YYYY-M-D')); $('#reportingDateEnd').val(end.format('YYYY-M-D'));
                $('#reportingLabel').val(start.format('MM/DD/YYYY')); 
                $('#reportingLabel2').val(end.format('MM/DD/YYYY'));
            }
            
            cb(start, end);
            $("#reportLabel").html("Reporting Period: " + $('#reportingLabel').val() + " to " + $('#reportingLabel2').val());
            generate();
            
            $("#ok_button").bind("click", function() {
                event.preventDefault();
                startDate = formatDate($('#reportingLabel').val());
                endDate = formatDate($('#reportingLabel2').val());

                $('#reportingDateBegin').val(startDate); $('#reportingDateEnd').val(endDate);

                generate();    

                dateFrom = new Date($('#reportingLabel').val());
                dateTo = new Date( $('#reportingLabel2').val());
                monthsBetween = monthDiff(dateFrom,  dateTo);

                console.log("Month between: ", monthsBetween);

                if (monthsBetween > 0 ){
                    $("#reportLabel").html("Reporting Period: " + moment(dateFrom).format('MMMM YYYY') + " to " + moment(dateTo).format('MMMM YYYY'));
                } else{
                     $("#reportLabel").html("Reporting Period: " + $('#reportingLabel').val() + " to " + $('#reportingLabel2').val());
                }

                return false;
            });

            function formatDate(dateInput, format){
                var date_convert = new Date(dateInput);
                var dy = date_convert.getDate();
                var mth = date_convert.getMonth() + 1;
                var yr = date_convert.getFullYear();
                str_date = yr + '-'  + mth + '-' + dy;
                return str_date;
            }
            function monthDiff(dateFrom, dateTo) {
                
                return (dateTo.getMonth() - dateFrom.getMonth()) + 
                  (12 * (dateTo.getFullYear() - dateFrom.getFullYear()))
             }
            });


        </script> 

    </body>
</html>

