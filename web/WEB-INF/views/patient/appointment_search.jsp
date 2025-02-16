    <%-- 
        Document   : Appointment
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
            <title>LAMIS 3.0</title>
            <jsp:include page="/WEB-INF/views/template/css.jsp" /> 
            <jsp:include page="/WEB-INF/views/template/javascript.jsp" /> 
            <script type="text/JavaScript">
                var gridNum = 2;
                var enablePadding = true;
                   $(document).keypress(function(e){
                if(e.which == '13') {
                    e.preventDefault();
                }
            });
                $(document).ready(function(){
                    $.ajax({
                        url: "Padding_status.action",
                        dataType: "json",
                        success: function(statusMap) {
                           enablePadding = statusMap.paddingStatus;
                        }
                    });
                    resetPage();
                    initialize();
                    reports();

                     $(".search").on("keyup", function(){
                        var value = $(this).val().toLowerCase();
                         $("#grid tr").filter(function(){
                            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                        });
                     });

                    $("#grid").jqGrid({
                        url: "Patient_grid.action",
                        datatype: "json",
                        mtype: "GET",
                        colNames: ["Hospital No", "Name", "Gender", "ART Status", "Address", "Action"],
                        colModel: [
                            {name: "hospitalNum", index: "hospitalNum", width: "200"},
                            {name: "name", index: "name", width: "350"},
                            {name: "gender", index: "gender", width: "150"},
                            {name: "currentStatus", index: "currentStatus", width: "250"},
                            {name: "address", index: "address", width: "350"},
                            {name: "Action", index: "Action", width: "150", formatter: function(){
                            return "<button id='new_button' onclick='newAppointment();'  class='btn btn-sm btn-info'>New</button>";

                        } } ,  

                        ],
                        pager: $('#pager'),
                        rowNum: 100,
                        sortname: "patientId",
                        sortorder: "desc",
                        viewrecords: true,
                        imgpath: "themes/basic/images",
                        resizable: false,
                        height: 350,                    
                        jsonReader: {
                            root: "patientList",
                            page: "currpage",
                            total: "totalpages",
                            records: "totalrecords",
                            repeatitems: false,
                            id: "patientId"
                        },
                        onSelectRow: function(id) {
                            $("#patientId").val(id); 
                            var data = $("#grid").getRowData(id)
                            $("#hospitalNum").val(data.hospitalNum);
                            $("#name").val(data.name)
                            $("#new_button").removeAttr("disabled");
                        },               
                        ondblClickRow: function(id) {
                            $("#patientId").val(id);
                            var data = $("#grid").getRowData(id)
                            $("#hospitalNum").val(data.hospitalNum);
                            $("#name").val(data.name)
                            $("#lamisform").attr("action", "Appointment_new");
                            $("#lamisform").submit();
                        }
                    }); //end of jqGrid 


                    $("#close_button").bind("click", function(event){
                        $("#lamisform").attr("action", "Home_page");
                        return true;
                    });
                });

                function newAppointment(){
                    $("#lamisform").attr("action", "Appointment_new");
                        return true;
                }
            </script>
        </head>
        <body>
            <jsp:include page="/WEB-INF/views/template/header.jsp" />
            <jsp:include page="/WEB-INF/views/template/nav_casemanagement.jsp"/>
             <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="Home_page.action">Home</a></li>
                    <li class="breadcrumb-item"><a href="Casemanagement_page.action">Case Management</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Appointment Scheduling</li>
                        </ol>
                        </nav>        
                    <div class="row">
                    <div class="col-md-12 ml-auto mr-auto">
                    <div class="card">
<!--                    <div class="card-header bg-info">
                    <h5 class="card-title text-white"></h5>
                        </div> -->
                       <s:form id="lamisform" theme="css_xhtml">
                        <div class="card-body">
                            <div id="messageBar"></div> 
                            <div class="row">
                           <div class="col-12 ml-auto mr-auto">
                                <div class="input-group no-border col-md-3 pull-right">
                                    <input type="text" class="form-control search" placeholder="search...">
                                    <div class="input-group-append">
                                        <div class="input-group-text">
                                            <i class="now-ui-icons ui-1_zoom-bold"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </div> 
                              <div class="row">
                                <div class="col-12 ml-auto mr-auto">
                                    <div class="table-responsive">
                                    <table id="grid" class="table table-striped table-bordered center"></table>
                                    <div id="pager" style="text-align:center;"></div>
                                </div>
                            </div>
                        </div>
                       </div>
                       </div>
                    </s:form>
                     <div id="user_group" style="display: none">Patients</div>
                    </div>
                </div>
                    <jsp:include page="/WEB-INF/views/template/footer.jsp" />
                </div>
            </body>
        </html>
