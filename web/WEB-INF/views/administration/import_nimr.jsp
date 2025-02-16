<%-- 
    Document   : Data Export
    Created on : Aug 15, 2012, 6:53:46 PM
    Author     : AALOZIE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>LAMIS 3.0</title>
    <jsp:include page="/WEB-INF/views/template/css.jsp" />
    <jsp:include page="/WEB-INF/views/template/javascript.jsp" />
    <script type="text/javascript" src="js/jquery.timer.js"></script>
    <script type="text/javascript" src="js/zebra.js"></script> 
    <link type="text/css" rel="stylesheet" href="css/zebra.css" />
    <script type="text/javascript" src="js/lamis/maintenance-common.js"></script>
    <script type="text/JavaScript">
            var timer = {};
            $(document).ready(function(){
                initialize(); 
                
                timer = $.timer(function() {
                    $.ajax({
                        url: "Processing_status.action",
                        dataType: "json",
                        success: function(status) {
                            if(status == "terminated") {
                                timer.stop();
                                $("#loader").html('');
                                $("#messageBar").html("Error occured while importing data, please retry").slideDown('fast');                                 
                            }
                            else {
                                if(status == "completed") {
                                    timer.stop();
                                    $("#loader").html('');
                                    $("#messageBar").html("Import Completed").slideDown('fast');
                                }
                                else {
                                    processingStatusNotifier("Importing " + status + " table, please wait...");
                               }
                            }
                        }                    
                    }); 
                });
                timer.set({time : 60000, autostart : false});
                
                $("#import_button").bind("click", function(event){
                    $("#messageBar").hide();
                    importData();
                    return false;                        
                }); 
                               
                $("#close_button").bind("click", function(event){
                    $("#lamisform").attr("action", "Maintenance_page");
                    return true;
                });                
            });
   
   
            function importData() {  
                timer.play();
                $("#messageBar").hide();
                $("#import_button").attr("disabled", true);
                $.ajax({
                    url: "Import_nimr_data.action",
                    dataType: "json",
                    success: function(status) {
                        timer.stop();
                        $("#loader").html('');
                        $("#messageBar").html(status).slideDown('slow');     
                        $("#import_button").attr("disabled", false);
                    }                    
                }); 
            }                
        </script>
</head>

<body>
    <jsp:include page="/WEB-INF/views/template/header.jsp" />
    <jsp:include page="/WEB-INF/views/template/nav_maintenance.jsp" />

    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="Home_page">Home</a></li>
        <li class="breadcrumb-item"><a href="Export_page">Data Maintenance</a></li>
        <li class="breadcrumb-item active">Import NIMR Data</li>
    </ol>
    <!-- MAIN CONTENT -->
    <s:form id="lamisform" method="post" autocomplete="off">
        <div class="row">
            <div class="col-md-10 ml-auto mr-auto">
                <div class="card">
                    <div class="card-body">
                        <div id="messageBar" class="alert alert-warning alert-dismissible fade show" role="alert">
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div id="messageBar"></div>
                        <div id="userGroup" style="display: none">
                            <s:property value="#session.userGroup" />
                        </div>
                        <div id="fileUploaded" style="display: none">
                            <s:property value="#session.fileUploaded" />
                        </div>
                        <div class="col-md-6 pull-right">
                            <button id="import_button" class="btn btn-info">Import</button>
                            <button id="close_button" class="btn btn-default">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </s:form>
    <div id="userGroup" style="display: none">
        <s:property value="#session.userGroup" />
    </div>
    <jsp:include page="/WEB-INF/views/template/footer.jsp" />
</body>

</html>