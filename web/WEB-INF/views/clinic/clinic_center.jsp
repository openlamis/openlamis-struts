<%-- 
    Document   : Patient
    Created on : Feb 8, 2012, 1:15:46 PM
    Author     : AALOZIE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>LAMIS 3.0</title>
        <link type="image/png" rel="icon" href="images/favicon.png" />
        <jsp:include page="/WEB-INF/views/template/css.jsp" />

        <jsp:include page="/WEB-INF/views/template/javascript.jsp" />
        <script type="text/javascript" src="js/json.min.js"></script>
        <script type="text/javascript" src="assets/highchart/highcharts.js"></script>     
        <script type="text/javascript" src="assets/highchart/highcharts-3d.js"></script>
        <script type="text/javascript" src="assets/highchart/modules/exporting.js"></script>  
        <script type="text/javascript" src="assets/chart-asset/moment.min.js"></script>
        <script type="text/javascript" src="assets/chart-asset/daterangepicker.js"></script>
        <script type="text/javascript" src="js/lamis/chart-common.js"></script>  
        <script type="text/JavaScript">
          function pmtct(data){
              if (data == 'Female'){ 
                  $('#tab2').removeAttr("style"); 
                  $('#label2').removeAttr("style");
                  $('#content2').removeAttr("style");
                  $('#profile').html('<i class="fa fa-female" style="font-size:24px;"></i> Profile');
              } else {
                  $('#profile').html('<i class="fa fa-male" style="font-size:24px;"></i> Profile');
              }
          }
             
          $(document).ready(function (){
              var queryString = decodeURIComponent(window.location.search);
              var hospitalNo = queryString.substring(5);
               
            
              $(".search").on("keyup", function() {
                  var value = $(this).val().toLowerCase(); 
                  $("#grid tr").filter(function() {
                      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                  });
              });
               
                
          $.ajax({
                  url: "Patient_retrieve.action",
                  dataType: "json",
                  success: function(patientList) {
                      console.log(patientList); 
                      $('#hospitalNo').html(patientList[0].hospitalNum); $('#hospitalNum').val(patientList[0].hospitalNum);
                      $('#pname').html(patientList[0].name);  $('#name').val(patientList[0].name);
                      $('#gender').html(patientList[0].gender); $("#dateCurrentStatus").val(patientList[0].dateCurrentStatus);
                      $('#phone').html(patientList[0].phone); $("#currentStatus").val(patientList[0].currentStatus);
                      $('#occupation').html(patientList[0].occupation); $("#dateVisit").val(patientList[0].dateStarted);
                      $('#mstatus').html(patientList[0].maritalStatus); $('#regdate').html(patientList[0].dateRegistration);
                      $('#age').html(patientList[0].age);
                      $('#state').html(patientList[0].state);
                      $('#address').html(patientList[0].address);
                      $('#lga').html(patientList[0].lga);
                      $('#lastVisit').html(patientList[0].dateLastClinic);
                      $('#patientId').val(patientList[0].patientId);
                      clinicVisit(patientList[0].patientId);
                      artCommencement(patientList[0].patientId);
                      unSuppressed(patientList[0].patientId);
                      careSupport(patientList[0].patientId); 
                      childFollowup(patientList[0].patientId);
                      ancRegistration(patientList[0].patientId);
                      labourDelivery(patientList[0].patientId);
                      laboratory(patientList[0].patientId);
                      pharmacy(patientList[0].patientId);
                      pmtct(patientList[0].gender);
                        
                      getClinicalTrendChart();
                  }                    
          });  

      $("#searchClinic").on("keyup", function() {
          var value = $(this).val().toLowerCase();
          $("#clinic tr").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
          });
          });
            
           
      $("#searchDispense").on("keyup", function() {
          var value = $(this).val().toLowerCase();
          $("#dispense tr").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
          });
      });
        
          function clinicVisit(patientId){
          $("#grid").jqGrid({
          url: "Clinic_grid.action?q=1&patientId=" + patientId,
          datatype: "json",
          mtype: "GET",
          colNames: ["Date of Visit", "Clinic Stage", "Functional Status", "TB Status", "Next Clinic Visit", "Action", "", ""],
          colModel: [
          {name: "dateVisit", index: "date1", width: "160", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "clinicStage", index: "clinicStage", width: "160"},
          {name: "funcStatus", index: "funcStatus", width: "180"},
          {name: "tbStatus", index: "tbStatus", width: "300"},
          {name: "nextAppointment", index: "nextAppointment", width: "150", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},                        
          {name: "clinicId", index: "clinicId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="editClinicVisit('+ cellValue+')">Edit</a><a class="dropdown-item" href="#" onclick="deleteClinicVisit(' + cellValue +');">Delete</a></div></div>';
          }},
          {name: "dateVisit", index: "dateVisit", width: "100", hidden: true},
          {name: "commence", index: "commence", width: "1", hidden: true},
          ],
          rowNum: -1,
          sortname: "clinicId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,                    
          height: 150, 
          pager: "#cpager",
          jsonReader: {
          root: "clinicList",
          page: "currpage",
          total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "clinicId"
          }
          }); //end of detail jqGrid  
          }
            
           //ART Commencement
          function artCommencement(patientId){
              $("#commencegrid").jqGrid({
                  url: 'Commence_grid.action?q=1&patientId=' + patientId,
                  datatype: "json",
                  mtype: "GET",
                  colNames: ["Date of ART Start", "Original Regimen Line", "Original Regimen", "Clinic Stage", "TB Status", "Next Appointment", "Action", "", ""],
                  colModel: [
                  {name: "dateVisit", index: "date1", width: "160", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
                  {name: "regimentype", index: "regimentype", width: "200"},
                  {name: "regimen", index: "regimen", width: "350"},
                  {name: "clinicStage", index: "clinicStage", width: "160"},
                   {name: "tbStatus", index: "tbStatus", width: "200"},
                  {name: "nextAppointment", index: "nextAppointment", width: "150", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},                        
                  {name: "clinicId", index: "clinicId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
                    return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="editCommence('+ cellValue+')">Edit</a><a class="dropdown-item" href="#" onclick="deleteCommence(' + cellValue +');">Delete</a></div></div>';
                  }},
                  {name: "dateVisit", index: "dateVisit", width: "100", hidden: true},
                  {name: "commence", index: "commence", width: "1", hidden: true},
                  ],
                  rowNum: -1,
                  sortname: "clinicId",
                  sortorder: "desc",
                  viewrecords: true,
                  imgpath: "themes/basic/images",
                  resizable: false,                    
                  height: 150, 
                  jsonReader: {
                  root: "clinicList",
                  page: "currpage",
                  total: "totalpages",
                  records: "totalrecords",
                  repeatitems: false,
                  id: "clinicId"
                  }
                  }); //end of detail jqGrid  
          }
    
        
         //Pharmacy
          $("#dispense").jqGrid({
          url: 'Pharmacy_grid.action?q=1&patientId=46712',
          mtype: "GET",
          datatype: "json",
          colModel: [
          { label: 'Date of Refill', name: 'dateVisit', key: true, width: 160,
          formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"} },
          { label: 'Drug Dispensed', name: 'description', width: 400 },
          { label: 'Refill Period', name: 'duration', width: 160 },
          { label: 'Next Refill', name: 'nextAppointment', width: 160,
          formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}}
          ],
          viewrecords: true,
          //width: 780,
          height: 250,
          rowNum: 20,
          pager: "#dpager",
          jsonReader: {
          root: "pharmacyList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "dispenseId"	 
          }
          });
          $("#care").jqGrid({
          url: 'Pharmacy_grid.action?q=1&patientId=46712',
          mtype: "GET",
          datatype: "json",
          colModel: [
          { label: 'Date of Devolved', name: 'dateDevolved', key: true, width: 150,
          formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"} },
          { label: 'Viral Load', name: 'lastViralLoad', width: 120 },
          { label: 'CD4 Count', name: 'lastCd4', width: 120 },
          { label: 'Clinic Stage', name: 'lastClinicStage', width: 120},
          { label: 'Regimen Dispensed', name: 'regimen', width: 220 },
          { label: 'Date of Next Visit', name: 'dateNextClinic', width: 150 },
          ],
          viewrecords: true,
          //width: 780,
          height: 250,
          rowNum: 20,
          pager: "#carepager",
          jsonReader: {
          root: "pharmacyList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "careId"	 
          }
          });

          function careSupport(patientId){
          $("#support").jqGrid({
          url: 'Chroniccare_grid.action?q=1&patientId=' + patientId,
          mtype: "GET",
          datatype: "json",
          colNames: ["Date of Visit", "ART Status", "Clinical Stage",  "Last CD4 Result", "Last Viral Load Result","Action", ""],
          colModel: [
          {name: "dateVisit", index: "date1", width: "170", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "currentStatus", index: "currentStatus", width: "170"},
          {name: "clinicStage", index: "clinicStage", width: "170"},
          {name: "lastCd4", index: "lastCd4", width: "200"},
          {name: "lastViralLoad", index: "lastViralLoad", width: "250"},
          {name: "chroniccareId", index: "chroniccareId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="editSupport(' + cellValue +');">Edit</a><a class="dropdown-item" href="#" onclick="deleteSupport(' + cellValue +');">Delete</a></div></div>';
          }},
          {name: "dateVisit", index: "dateVisit", width: "100", hidden: true},
          ],
          rowNum: -1,
          sortname: "chroniccareId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,                    
          height: 150,                    
          jsonReader: {
          root: "chroniccareList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "chroniccareId"
          }
          }); //end of detail jqGrid   
          }              


          //Unsuppressed
          function unSuppressed(patientId){
          $("#unsuppressed").jqGrid({
          url: 'Eac_grid.action?q=1&patientId=' + patientId,
          mtype: "GET",
          datatype: "json",
          colNames: ["Date of 1st EAC", "Date of 2nd EAC", "Date of 3rd EAC", "Date Repeat VL Sample collected", "Action", ""],
          colModel: [
          {name: "dateEac1", index: "dateEac1", width: "200", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "dateEac2", index: "dateEac2", width: "200", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},                        
          {name: "dateEac3", index: "dateEac3", width: "200", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},                        
          {name: "dateSampleCollected", index: "dateSampleCollected", width: "290", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},  
          {name: "eacId", index: "eacId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="editUnsuppressed(' + cellValue +');">Edit</a><a class="dropdown-item" href="#" onclick="deleteUnsuppressed(' + cellValue +');">Delete</a></div></div>';
          }},
          {name: "dateVisit", index: "dateVisit", width: "100", hidden: true}
          ],
          rowNum: -1,
          sortname: "eacId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,
          height: 150,                    
          jsonReader: {
          root: "eacList",
          page: "currpage",
          total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "eacId"
          },
          onSelectRow: function(id) {
          if(id != null) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          $("#dateVisit").val(data.dateVisit);
          }
          $("#eacId").val(id);
          $("#new_button").html("View");
          }
          },
          ondblClickRow: function(id) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          $("#dateVisit").val(data.dateVisit);
          }
          $("#eacId").val(id);
          $("#lamisform").attr("action", "Eac_find");
          $("#lamisform").submit();
          }
          });
          }
          });


          function newCommence(){
              $("#lamisform").attr("action", "Commence_new");
              return true;
          }
            
            
          function editCommence(id){
              var data = $("#commencegrid").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#clinicId").val(id);
              $("#lamisform").attr("action", "Commence_find");
              $("#lamisform").submit();
          }
            
          function deleteCommence(id){
               var data = $("#commencegrid").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#clinicId").val(id);
                
                
              $.confirm({
                  title: 'Confirm!',
                  content: 'Are you sure you want to delete?',
                  buttons: {
                      confirm: function () {
                      if($("#userGroup").html() == "Data Analyst") {
                          $("#lamisform").attr("action", "Error_message");
                      }
                      else {
                          $.ajax({
                                                                          url: encodeURI('Clinic_delete?clinicId=' + $('#clinicId').val() +
                                                                                  '&hospitalNum=' + $('#hospitalNum').val() + '&patientId=' + $('#patientId').val()),
                                                                          dataType: 'json',
                                                                          header: {
                                                                                  'Content-Type': 'application/json'
                                                                          },
                                                                          success: function (e) {
                                                                                  window.location.reload();
                                                                          }
                                                                  });
                                                                  window.location.reload();
                      }
                      return true;
                      },
                      cancel: function () {
                          console.log("cancel");
                      }
                  }
              });
          }


          function newSupport(){
              $("#lamisform").attr("action", "Chroniccare_new.action");
              return true;
          }
            
          function viewSupport(){
              var data = $("#support").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#chroniccareId").val(id);
              $("#lamisform").attr("action", "Chroniccare_find");
              $("#lamisform").submit();
          }
            
          function editSupport(id){
              var data = $("#support").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#chroniccareId").val(id);
              $("#lamisform").attr("action", "Chroniccare_find");
              $("#lamisform").submit();
          }
            
          function deleteSupport(id){
               var data = $("#support").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#chroniccareId").val(id);
                
              $.confirm({
                  title: 'Confirm!',
                  content: 'Are you sure you want to delete?',
                  buttons: {
                      confirm: function () {
                      if($("#userGroup").html() == "Data Analyst") {
                          $("#lamisform").attr("action", "Error_message");
                      }
                      else {
                           $.ajax({
                                    url: encodeURI('Chroniccare_delete?chroniccareId=' + id + '&patientId='+$('#patientId').val()),
                                    dataType: 'json',
                                    header: {
                                        'Content-Type': 'application/json'
                                    },
                                    success: function (e) {

                                        window.location.reload();
                                    }
                                });
                                window.location.reload();
                      }
                      return true;
                      },
                      cancel: function () {
                          console.log("cancel");
                      }
                  }
              });
          }
            
          function viewChroniccare(data){
          $("#patientId").val(data);
          $("#lamisform").attr("action", "Chroniccare_find");
          $("#lamisform").submit();
          return true;  	
          }
            
          function newChroniccare(data){
          $("#patientId").val(data);
          $("#lamisform").attr("action", "Chroniccare_new");
          return true;
          }
            
          function newUnsuppressed(){
            sessionStorage.setItem("key", "1");
               $("#lamisform").attr("action", "Eac_new");
             
               return true;
          }
            
          function viewUnsuppressed(id){
              $("#eacId").val(id);
              var data = $("#unsuppressed").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#lamisform").attr("action", "Eac_find");
              $("#lamisform").submit();
          }
            
          function editUnsuppressed(id){
              $("#eacId").val(id);
              var data = $("#unsuppressed").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#lamisform").attr("action", "Eac_find");
              $("#lamisform").submit();
          }
            
          function deleteUnsuppressed(id){
              $("#eacId").val(id);
              var data = $("#unsuppressed").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $.confirm({
                  title: 'Confirm!',
                  content: 'Are you sure you want to delete?',
                  buttons: {
                      confirm: function () {
                          if($("#userGroup").html() == "Data Analyst") {
                              $("#lamisform").attr("action", "Error_message");
                          }
                          else {
                               $.ajax({
                                    url: encodeURI('Eac_delete?eacId=' + id + '&patientId='+$('#patientId').val()),
                                    dataType: 'json',
                                    header: {
                                        'Content-Type': 'application/json'
                                    },
                                    success: function (e) {

                                        window.location.reload();
                                    }
                                });
                                window.location.reload();
                          }
                          return true;
                      },
                      cancel: function () {
                          console.log("cancel");
                      }
                  }
              });
          }
            
          function viewClinicVisit(id){
              $("#clinicId").val(id);
              var data = $("#grid").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#lamisform").attr("action", "Clinic_find");
              $("#lamisform").submit();
          }
            
          function editClinicVisit(id){
              $("#clinicId").val(id);
              var data = $("#grid").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $("#lamisform").attr("action", "Clinic_find");
              $("#lamisform").submit();	
          }
            
          function deleteClinicVisit(id){
               $("#clinicId").val(id);
              var data = $("#grid").getRowData(id);
              $("#dateVisit").val(data.dateVisit);
              $.confirm({
                      title: 'Confirm!',
                      content: 'Are you sure you want to delete?',
                      buttons: {
                          confirm: function () {
                          if($("#userGroup").html() == "Data Analyst") {
                      $("#lamisform").attr("action", "Error_message");
                  }
                  else {
                      $("#lamisform").attr("action", "Clinic_delete");
                       $("#lamisform").submit();
                  }
                          return true;
                         },
                          cancel: function () {
                              console.log("cancel");
                          }
                      }
                  });
          }
            
          function newClinicVisit(){
              $("#lamisform").attr("action", "Clinic_new");
              return true;
          }
            
          function newStatusUpdate(){
              // $("#patientId").val(data);
              $("#lamisform").attr("action", "Status_new");
              return true;
          }
            
          function childFollowup(patientId){
          $("#childfollowup").jqGrid({
          ul: "Childfollowup_grid.action?q=1&childId=" + patientId,
          datatype: "json",
          mtype: "GET",
          colNames: ["Date of Visit", "Feeding at Present", "Outcome", "Rapid Test Result", "On Cotrim", "Actions"],
          colModel: [
          {name: "dateVisit", index: "dateVisit", width: "170", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "feeding", index: "feeding", width: "200"},
          {name: "childOutcome", index: "childOutcome", width: "160"},
          {name: "rapidTestResult", index: "rapidTestResult", width: "170"},
          {name: "cotrim", index: "cotrim", width: "130"},
            
          {name: "patientId", index: "patientId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#">Edit</a><a class="dropdown-item" href="#" onclick="deleteButton(' + cellValue +');">Delete</a></div></div>';
          }},
          ],
          rowNum: -1,
          sortname: "childfollowupId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,                    
          height: 150,                    
          jsonReader: {
          root: "childfollowupList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "childfollowupId"
          }, 
          afterInsertRow: function(id) {
          var content = $("#detail").getCell(id, "feeding");
          $("#detail").setCell(id, "feeding", content.substring(content.indexOf("-") + 2), '', '');

          content = $("#detail").getCell(id, "childOutcome");
          $("#detail").setCell(id, "childOutcome", content.substring(content.indexOf("-") + 2), '', '');  
          },
          onSelectRow: function(id) {
          if(id != null) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          var date = data.dateVisit;
          $("#dateVisit").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#childfollowupId").val(id);
          $("#new_button").html("View");
          }
          },							
          ondblClickRow: function(id) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          var date = data.dateVisit;
          $("#dateVisit").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#childfollowupId").val(id);
          $("#lamisform").attr("action", "Childfollowup_find");
          $("#lamisform").submit();
          }
          }); //end of detail jqGrid       
          }

          function labourDelivery(patientId){
          $("#delivery").jqGrid({
          url: "Delivery_grid.action?q=1&patientId="+patientId,
          datatype: "json",
          mtype: "GET",
          colNames: ["Date of Delivery", "Mode of Delivery", "Maternal Outcome","Actions"],
          colModel: [
          {name: "dateDelivery", index: "dateDelivery", width: "205", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "modeDelivery", index: "modeDelivery", width: "330"},
          {name: "maternalOutcome", index: "maternalOutcome", width: "300"},
            
          {name: "patientId", index: "patientId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="viewButton(' + cellValue +');">View</a><a class="dropdown-item" href="#">Edit</a><a class="dropdown-item" href="#" onclick="deleteButton(' + cellValue +');">Delete</a></div></div>';
          }},
          ],
          rowNum: -1,
          sortname: "deliveryId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,                    
          height: 150,                    
          jsonReader: {
          root: "deliveryList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "deliveryId"},
          onSelectRow: function(id) {
          if(id != null) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          var date = data.dateDelivery;
          $("#dateDelivery").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#deliveryId").val(id);
          // $("#new_button").html("View");
          }
          },                   
          ondblClickRow: function(id) {
          var selectedRow = $("#delivery").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#delivery").getRowData(selectedRow);
          var date = data.dateDelivery;
          $("#dateDelivery").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#deliveryId").val(id);
          $("#lamisform").attr("action", "Delivery_find");
          $("#lamisform").submit();
          }
          }); //end of detail jqGrid   
          }

          function ancRegistration(patientId){
          $("#anc").jqGrid({
          url: "Anc_grid.action?q=1&patientId=" + patientId,
          datatype: "json",
          mtype: "GET",
          colNames: ["Date of Visit", "Source of Referral", "LMP", "EDD","Actions"],
          colModel: [
          {name: "dateVisit", index: "dateVisit", width: "160", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "sourceReferral", index: "sourceReferral", width: "300"},
          {name: "lmp", index: "lmp", width: "193", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
          {name: "edd", index: "edd", width: "193", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
            
          {name: "patientId", index: "patientId", width: "100",  classes: "table_dropdown", formatter:function (cellValue, options, rowObject){
            return '<div id="table-btn" class="dropdown" style="postion: absolute; color: #000;"><button  class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Action</button><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="#" onclick="viewButton(' + cellValue +');">View</a><a class="dropdown-item" href="#">Edit</a><a class="dropdown-item" href="#" onclick="deleteButton(' + cellValue +');">Delete</a></div></div>';
          }},
          ],
          rowNum: -1,
          sortname: "ancId",
          sortorder: "desc",
          viewrecords: true,
          imgpath: "themes/basic/images",
          resizable: false,                    
          height: 150,                    
          jsonReader: {
          root: "ancList",
          page: "currpage",
          //total: "totalpages",
          records: "totalrecords",
          repeatitems: false,
          id: "ancId"
          },
          onSelectRow: function(id) {
          if(id != null) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          var date = data.dateVisit;
          $("#dateVisit").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#ancId").val(id);
          $("#new_button").html("View");
          }
          },                   
          ondblClickRow: function(id) {
          var selectedRow = $("#detail").getGridParam('selrow');
          if(selectedRow != null) {
          var data = $("#detail").getRowData(selectedRow);
          var date = data.dateVisit;
          $("#dateVisit").val(date.slice(3,5)+"/"+date.slice(0,2)+"/"+date.slice(6));
          }
          $("#ancId").val(id);
          $("#lamisform").attr("action", "Anc_find");
          $("#lamisform").submit();
          }
          }); //end of detail jqGrid      
          }
            
          function laboratory(patientId){
              $(".laboratory").jqGrid({
                  url: "Laboratory_grid.action?q=1&patientId="+patientId,
                  datatype: "json",
                  mtype: "GET",
                  colNames: ["Sample Collected", "Result Reported", "Lab No", "Description", "Absolute", "Relative",""],
                  colModel: [
                  {name: "dateCollected", index: "dateCollected", width: "170", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
                  {name: "dateReported", index: "date1", width: "170", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
                  {name: "labno", index: "labno", width: "140"},
                  {name: "description", index: "description", width: "200"},
                  {name: "resultab", index: "resultab", width: "110"},
                  {name: "resultpc", index: "resultpc", width: "110"},
                  {name: "dateReported", index: "dateReported", width: "100", hidden: true}
                  ],
                  rowNum: -1,
                  sortname: "laboratoryId",
                  sortorder: "desc",
                  viewrecords: true,
                  imgpath: "themes/basic/images",
                  resizable: false,                    
                  height: 150,                    
                  jsonReader: {
                      root: "laboratoryList",
                      page: "currpage",
                      //total: "totalpages",
                      records: "totalrecords",
                      repeatitems: false,
                      id: "laboratoryId"
                  }

              }); //end of detail jqGrid        
          }
          function pharmacy(patientId){
          $(".pharmac").jqGrid({
              url: "Pharmacy_grid.action?q=1&patientId=" + patientId,   
              datatype: "json",
              mtype: "GET",
              colNames: ["Date of Refill", "Drug Dispensed", "Refill Period", "Next Refill", ""],
              colModel: [
              {name: "dateVisit", index: "date1", width: "200", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
              {name: "description", index: "description", width: "400"},
              {name: "duration", index: "duration", width: "170"},
              {name: "nextAppointment", index: "nextAppointment", width: "170", formatter: "date", formatoptions: {srcformat: "m/d/Y", newformat: "d/m/Y"}},
              {name: "dateVisit", index: "dateVisit", width: "100", hidden: true},
              ],
              rowNum: -1,
              sortname: "pharmacyId",
              sortorder: "desc",
              viewrecords: true,
              imgpath: "themes/basic/images",
              resizable: false,                   
              height: 150,                    
              jsonReader: {
                  root: "pharmacyList",
                  page: "currpage",
                  //total: "totalpages",
                  records: "totalrecords",
                  repeatitems: false,
                  id: "pharmacyId"	 
                  
              }
           }); //end of detail jqGrid  
          }    
        </script>

        <style class="cp-pen-styles">
            *,
            *::before,
            *::after {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            p:not(:last-child) {
                margin: 0 0 20px;
            }

            section {
                display: none;
                padding: 20px 0 0;
                border-top: 1px solid #abc;
            }

            input {
                display: none;
            }

            label {
                display: inline-block;
                margin: 0 0 -1px;
                padding: 15px 25px;
                font-weight: 600;
                text-align: center;
                color: #abc;
                border: 1px solid transparent;
            }

            label:before {
                font-family: fontawesome;
                font-weight: normal;
                margin-right: 10px;
            }

            label:hover {
                color: #789;
                cursor: pointer;
            }

            input:checked+label {
                color: #0af;
                border: 1px solid #abc;
                border-top: 2px solid #0af;
                border-bottom: 1px solid #fff;
            }

            #tab1:checked~#content1,
            #tab2:checked~#content2,
            #tab3:checked~#content3,
            #tab4:checked~#content4 {
                display: block;
            }

            #taba:checked~#contenta,
            #tabb:checked~#contentb,
            #tabc:checked~#contentc {
                display: block;
            }

            @media screen and (max-width: 800px) {
                label {
                    font-size: 0;
                }

                label:before {
                    margin: 0;
                    font-size: 18px;
                }
            }

            @media screen and (max-width: 500px) {
                label {
                    padding: 15px;
                }
            }
            #container {
                min-width: 310px;
                max-width: 800px;
                height: 400px;
                margin: 0 auto
            }
        </style>
    </head>
    <body>
        <span id="style"></span>
        <!-- Navbar -->
        <jsp:include page="/WEB-INF/views/template/header.jsp" />
        <jsp:include page="/WEB-INF/views/template/nav_clinic.jsp" />
        <div class="mt-5"></div>
        <div class="content col-12 mr-auto ml-auto">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Home_page">Home</a></li>
                <li class="breadcrumb-item"><a href="Clinic_page">Clinic</a></li>
                <li class="breadcrumb-item active">Patient Details</li>
            </ol>

            <!-- Summary Section -->
            <s:form id="lamisform" theme="css_xhtml">
                <input type="hidden" name="patientId" id="patientId" class="form-control" />
                <input type="hidden" name="clinicId" id="clinicId" class="form-control" />
                <input name="hospitalNum" type="hidden" id="hospitalNum" class="form-control" />
                <input name="dateVisit" type="hidden" id="dateVisit" class="form-control" />
                <input name="commence" type="hidden" value="1" id="commence" class="form-control" />
                <input name="currentStatus" type="hidden" id="currentStatus" class="form-control" />
                <input name="dateCurrentStatus" type="hidden" id="dateCurrentStatus" class="form-control" />
                <div class="row">
                    <div class="col-12">
                        <div class="card card-user">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <table class="table table-striped">
                                            <tr>
                                                <th>Hospital Number</th>
                                                <td id="hospitalNo"></td>
                                                <th>Name</th>
                                                <td id="pname"></td>
                                            </tr>
                                            <tr>
                                                <th>Gender</th>
                                                <td id="gender"></td>
                                                <th>Marital Status</th>
                                                <td id="mstatus"></td>
                                            </tr>
                                            <tr>
                                                <th>Age at Registration</th>
                                                <td id="age"></td>
                                                <th>Date of Registration</th>
                                                <td id="regdate"></td>
                                            </tr>
                                            <tr>
                                                <th>Telephone</th>
                                                <td id="phone"></td>
                                                <th>Address</th>
                                                <td id="address"></td>
                                            </tr>
                                            <tr>
                                                <th>LGA</th>
                                                <td id="lga"></td>
                                                <th>State</th>
                                                <td id="state"></td>
                                            </tr>
                                            <tr>
                                                <th>Occupation</th>
                                                <td id="occupation"></td>
                                                <th>Last Clinic Visit</th>
                                                <td id="lastVisit"></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card card-user">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <div id="container">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <input id="tab1" type="radio" name="tabs" checked>
                                        <label for="tab1">ART Clinic</label>
                                        <input id="tab2" type="radio" name="tabs" style="display:none;">
                                        <label for="tab2" id="label2" style="display:none;">PMTCT</label>

                                        <input id="tab3" type="radio" name="tabs">
                                        <label for="tab3">Laboratory History</label>

                                        <input id="tab4" type="radio" name="tabs">
                                        <label for="tab4">Pharmacy History</label>

                                        <section id="content1">
                                            <!-- ART Clinic -->
                                            <div class="row">
                                                <div id="accordion" role="tablist" aria-multiselectable="true"
                                                     class="card-collapse col-12">
                                                    <div class="card card-plain">
                                                        <div class="card-header" role="tab" id="careheading">
                                                            <a data-toggle="collapse" data-parent="#accordion" href="#clinictab"
                                                               aria-expanded="false" aria-controls="clinictab" class="collapsed">
                                                                Clinic Visit <i class="now-ui-icons arrows-1_minimal-down"></i>
                                                            </a>
                                                        </div>

                                                        <div id="clinictab" class="collapse" role="tabpanel"
                                                             aria-labelledby="clinicheading">
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <button onclick="newClinicVisit()"
                                                                                class="btn btn-info">New</button>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <div class="input-group no-border col-6 pull-right">
                                                                            <input id="searchCare" hidden="true" type="text" class="form-control"
                                                                                   placeholder="Search...">
                                                                            <!--                                                                <div class="input-group-append">
                                                                                                                                                <div class="input-group-text">
                                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                                                                </div>
                                                                                                                                            </div>-->
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12 mr-auto ml-auto">
                                                                        <div class="table-responsive">
                                                                            <table id="grid"
                                                                                   class="table table-bordered table-striped table-hover">
                                                                            </table>
                                                                            <div id="cpager" style="text-align:center;"></div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="card card-plain">
                                                        <div class="card-header" role="tab" id="commenceheading">
                                                            <a data-toggle="collapse" data-parent="#accordion" href="#commencetab"
                                                               aria-expanded="false" aria-controls="commencetab" class="collapsed">
                                                                ART Commencement <i
                                                                    class="now-ui-icons arrows-1_minimal-down"></i>
                                                            </a>
                                                        </div>

                                                        <div id="commencetab" class="collapse" role="tabpanel"
                                                             aria-labelledby="commenceheading">
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <button onclick="newCommence()"
                                                                                class="btn btn-info">New</button>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <!--                                                            <div class="input-group no-border col-6 pull-right">
                                                                                                                                        <input id="searchCommence"  hidden="true"type="text"
                                                                                                                                            class="form-control" placeholder="Search...">
                                                                                                                                        <div class="input-group-append">
                                                                                                                                            <div class="input-group-text">
                                                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                                                            </div>
                                                                                                                                        </div>
                                                                                                                                    </div>-->
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12 mr-auto ml-auto">
                                                                        <div class="table-responsive">
                                                                            <table id="commencegrid"></table>
                                                                            <div id="commencepager" style="text-align:center;"></div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="card card-plain">
                                                        <div class="card-header" role="tab" id="supportheading">
                                                            <a data-toggle="collapse" data-parent="#accordion" href="#supporttab"
                                                               aria-expanded="false" aria-controls="supporttab" class="collapsed">
                                                                Care and Support Assessment <i
                                                                    class="now-ui-icons arrows-1_minimal-down"></i>
                                                            </a>
                                                        </div>

                                                        <div id="supporttab" class="collapse" role="tabpanel"
                                                             aria-labelledby="supportheading">
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <button onclick="newSupport()"
                                                                                class="btn btn-info">New</button>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <!--                                                            <div class="input-group no-border col-6 pull-right">
                                                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                                                            class="form-control" placeholder="Search...">
                                                                                                                                        <div class="input-group-append">
                                                                                                                                            <div class="input-group-text">
                                                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                                                            </div>
                                                                                                                                        </div>
                                                                                                                                    </div>-->
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12 mr-auto ml-auto">
                                                                        <div class="table-responsive">
                                                                            <table id="support"></table>
                                                                            <div id="supportpager" style="text-align:center;"></div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="card card-plain">
                                                        <div class="card-header" role="tab" id="unsuppressedheading">
                                                            <a data-toggle="collapse" data-parent="#accordion"
                                                               href="#unsuppressedtab" aria-expanded="false"
                                                               aria-controls="unsuppressedtab" class="collapsed">
                                                                Unsuppressed Client Monitoring/ Enhanced Adherence Counseling <i
                                                                    class="now-ui-icons arrows-1_minimal-down"></i>
                                                            </a>
                                                        </div>

                                                        <div id="unsuppressedtab" class="collapse" role="tabpanel"
                                                             aria-labelledby="unsuppressedheading">
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <button onclick="newUnsuppressed()" class="btn btn-info">New</button>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <!--                                                            <div class="input-group no-border col-6 pull-right">
                                                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                                                            class="form-control" placeholder="Search...">
                                                                                                                                        <div class="input-group-append">
                                                                                                                                            <div class="input-group-text">
                                                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                                                            </div>
                                                                                                                                        </div>
                                                                                                                                    </div>-->
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12 mr-auto ml-auto">
                                                                        <div class="table-responsive">
                                                                            <table id="unsuppressed"></table>
                                                                            <div id="unsuppressedpager" style="text-align:center;">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </section>

                                        <!--                            <section id="content2" style="display:none;">
                                                                        <div class="row">
                                                                            <div id="accordion" role="tablist" aria-multiselectable="true"
                                                                                class="card-collapse col-12">
                                                                                <div class="card card-plain">
                                                                                    <div class="card-header" role="tab" id="ancheading">
                                                                                        <a data-toggle="collapse" data-parent="#accordion" href="#anctab"
                                                                                            aria-expanded="false" aria-controls="anctab" class="collapsed">
                                                                                            ANC Registration <i class="now-ui-icons arrows-1_minimal-down"></i>
                                                                                        </a>
                                                                                    </div>
                                        
                                                                                    <div id="anctab" class="collapse" role="tabpanel"
                                                                                        aria-labelledby="careheading">
                                                                                        <div class="card-body">
                                                                                            <div class="row">
                                                                                                <div class="col-6">
                                                                                                    <button onclick="ancRegistration()"
                                                                                                        class="btn btn-info">New</button>
                                                                                                </div>
                                                                                                <div class="col-6">
                                                                                                    <div class="input-group no-border col-6 pull-right">
                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                            class="form-control" placeholder="Search...">
                                                                                                        <div class="input-group-append">
                                                                                                            <div class="input-group-text">
                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row">
                                                                                                <div class="col-12 mr-auto ml-auto">
                                        
                                                                                                    <div class="table-responsive">
                                                                                                        <table id="anc"></table>
                                                                                                        <div id="ancpager" style="text-align:center;"></div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="card card-plain">
                                                                                    <div class="card-header" role="tab" id="labourheading">
                                                                                        <a data-toggle="collapse" data-parent="#accordion" href="#labourtab"
                                                                                            aria-expanded="false" aria-controls="labourtab" class="collapsed">
                                                                                            Labour and Delivery <i
                                                                                                class="now-ui-icons arrows-1_minimal-down"></i>
                                                                                        </a>
                                                                                    </div>
                                        
                                                                                    <div id="labourtab" class="collapse" role="tabpanel"
                                                                                        aria-labelledby="labourheading">
                                                                                        <div class="card-body">
                                                                                            <div class="row">
                                                                                                <div class="col-6">
                                                                                                    <button onclick="newDelivery();"
                                                                                                        class="btn btn-info">New</button>
                                                                                                </div>
                                                                                                <div class="col-6">
                                                                                                    <div class="input-group no-border col-6 pull-right">
                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                            class="form-control" placeholder="Search...">
                                                                                                        <div class="input-group-append">
                                                                                                            <div class="input-group-text">
                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row">
                                                                                                <div class="col-12 mr-auto ml-auto">
                                        
                                                                                                    <div class="table-responsive">
                                                                                                        <table id="delivery"></table>
                                                                                                        <div id="deliverypager" style="text-align:center;">
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="card card-plain">
                                                                                    <div class="card-header" role="tab" id="cupdateheading">
                                                                                        <a data-toggle="collapse" data-parent="#accordion" href="#cupdatetab"
                                                                                            aria-expanded="false" aria-controls="cupdatetab" class="collapsed">
                                                                                            ANC/PNC Visit<i class="now-ui-icons arrows-1_minimal-down"></i>
                                                                                        </a>
                                                                                    </div>
                                        
                                                                                    <div id="cupdatetab" class="collapse" role="tabpanel"
                                                                                        aria-labelledby="cupdateheading">
                                                                                        <div class="card-body">
                                                                                            <div class="row">
                                                                                                <div class="col-6">
                                                                                                    <button onclick="newUnsuppressed"
                                                                                                        class="btn btn-info">New</button>
                                                                                                </div>
                                                                                                <div class="col-6">
                                                                                                    <div class="input-group no-border col-6 pull-right">
                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                            class="form-control" placeholder="Search...">
                                                                                                        <div class="input-group-append">
                                                                                                            <div class="input-group-text">
                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row">
                                                                                                <div class="col-12 mr-auto ml-auto">
                                                                                                    <div class="table-responsive">
                                                                                                        <table id="cupdate"></table>
                                                                                                        <div id="cupdatepager" style="text-align:center;"></div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="card card-plain">
                                                                                    <div class="card-header" role="tab" id="followupheading">
                                                                                        <a class="collapsed" data-toggle="collapse" data-parent="#accordion"
                                                                                            href="#followuptab" aria-expanded="false"
                                                                                            aria-controls="followuptab">
                                                                                            Child Follow-up <i class="now-ui-icons arrows-1_minimal-down"></i>
                                                                                        </a>
                                                                                    </div>
                                                                                    <div id="followuptab" class="collapse" role="tabpanel"
                                                                                        aria-labelledby="followupheading">
                                                                                        <div class="card-body">
                                                                                            <div class="row">
                                                                                                <div class="col-6">
                                                                                                    <button onclick="newChildFollowup();"
                                                                                                        class="btn btn-info">New</button>
                                                                                                </div>
                                                                                                <div class="col-6">
                                                                                                    <div class="input-group no-border col-6 pull-right">
                                                                                                        <input id="searchUnsuppressed" type="text"
                                                                                                            class="form-control" placeholder="Search...">
                                                                                                        <div class="input-group-append">
                                                                                                            <div class="input-group-text">
                                                                                                                <i class="now-ui-icons ui-1_zoom-bold"></i>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row">
                                                                                                <div class="col-12 mr-auto ml-auto">
                                                                                                    <div class="table-responsive">
                                                                                                        <table id="childfollowup"></table>
                                                                                                        <div id="cfpager" style="text-align:center;"></div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </section>-->

                                        <section id="content3">
                                            <div class="row">
                                                <div class="col-12">
                                                    <div class="table-responsive">
                                                        <table class="laboratory" class="table table-striped"></table>
                                                    </div>
                                                </div>
                                            </div>
                                        </section>

                                        <section id="content4">
                                            <div class="row">
                                                <div class="col-md-12 mr-auto ml-auto">
                                                    <div class="table-responsive">
                                                        <table class="pharmac"
                                                               class="table table-bordered table-striped table-hover"></table>
                                                    </div>
                                                </div>
                                            </div>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </s:form>
        </div>
        <div id="user_group1" style="display: none">
            <s:property value="#session.userGroup" />
        </div>
        <jsp:include page="/WEB-INF/views/template/footer.jsp" />
    </body>

</html>