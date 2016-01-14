/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/Sent Old Fixes/im4_4500_tfl_fix1/admin/im4_framework/js/new_framework.js-arc   1.0   Jan 14 2016 23:35:12   Sarah.Williams  $
 --       Module Name      : $Workfile:   new_framework.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 23:35:12  $
 --       Date fetched Out : $Modtime:   Jul 10 2012 19:31:24  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
 
function setLocationText(ptext){
       $('#setloclink').text('Location Set to : ' +ptext).after('&nbsp; &nbsp; &nbsp; <a href="javascript:clearSetLocation();" id="clearloclink" >Clear</a>');
       return;
} 
 
$(document).ready(function(){
   var page = $v('pFlowStepId');   
if ( (page >1 && page < 200) || page > 245 ){
      $('#setloclink, #setLocationContainer').remove();
      return;
   }  
   
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=getSetLocation',0);
   var gReturn = get.get();
   get = null;
   
   if (gReturn != 'NO'){
       setLocationText(gReturn);   
   }
   
      $("#setLocationContainer").dialog({
         bgiframe: true,
         resizable: false,
         modal: true,
         title: 'Set Location',
         autoOpen: false,
         position: 'center',
         hide: 'blind',
         show: 'blind',
         width:490,        
         overlay: {
            backgroundColor: '#000',
            opacity: 0.5
         },
         buttons: {
            'Cancel' : function() {
                    $(this).dialog('close');             
            }
         }
      });   
     $('#setloclink').bind('click',function(){
        $("#setLocationContainer").dialog('open');
     }) ;
     setSessionValue('AI_LOCATION_GROUP_TYPE','~');
     $('#P0_SELECT_GROUP').bind('change',function(){
        setSessionValue('AI_LOCATION_GROUP_TYPE',$('#P0_SELECT_GROUP').val());
        $("#P0_LOCATION").val('');
     });
   $("#P0_LOCATION").autocomplete('APEX', {
               apexProcess: 'AUTO_LOCATION_SET',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 0,
               max: 200,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });   
       $("#P0_LOCATION").result(function(event, data, formatted) {
        if (data) {
           $("#P0_LOC_NE_ID").val(data[1]);
           $("#P0_LOC_NE_UNIQUE").val(data[2]);
           
           $( "#setLocationContainer" ).dialog( "option", "buttons", {
              "Set": function(){
                 doSetLocation($("#P0_SELECT_GROUP"), $("#P0_LOCATION"), $("#P0_LOC_NE_ID"),$("#P0_LOC_NE_UNIQUE"));
                 $(this).dialog("close");
              },
           //   "Clear": function(){
           //      clearSetLocation();
           //      $(this).dialog("close");
            //  },
              "Cancel": function(){
                 $(this).dialog("close");
              }
           } );
        }
        });             
});

function resetCharts(){
  window.location.reload();
}


function doSetLocation(p$SelectGroup,p$Location, p$NeId, p$NeUnique){
   
   
   setLocationText(p$Location.val()); 
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=populate_im_location',0);
         get.add('ITEM_ID',p$NeId.val() );                             
   var gReturn = get.get();
   get = null;

   resetCharts();
   
   return;
}

function clearSetLocation(){
   $("#P0_SELECT_GROUP").val('~');
   $("#P0_LOCATION").val('');
   $('#setloclink').text('Set Location');
   $('#clearloclink').remove();
   $( "#setLocationContainer" ).dialog( "option", "buttons", {
            "Cancel": function(){
                 $(this).dialog("close");
              }
           } );
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=clear_im_location',0);                                     
   var gReturn = get.get();
   get = null;
   resetCharts();
}
$(document).ready(function(){
        $("#mapholder").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,
            title: 'Map',
            autoOpen: false,
            hide: 'blind',
            show: 'blind',
            width:500,
            height:500,
            overlay: {
                backgroundColor: '#000',
                opacity: 0.5
            },
            buttons: {
                'Close' : function() {
                    $("#mapLegendContainer").dialog('close');
                    $("#printMapContainer").dialog('close');
                    $(this).dialog('close');
                $('#mappod').append($('#map'));
                },
                'Refresh' : function() {
                    showMap();},
                'Legend' : function() {
                    showMapLegend();}
					//,
                //'Print' : function() {
                 //   showPrintMap();}
            }
        });
    });
$(document).ready(function(){
        $("#mapLegendContainer").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,
            title: 'Map Legend',
            autoOpen: false,
            position: 'left',
            hide: 'blind',
            show: 'blind',
            width:250,
            //height:500,
            overlay: {
                backgroundColor: '#000',
                opacity: 0.5
            }
            ,
            buttons: {
                'Close' : function() {
                    $(this).dialog('close');                    
                }
            }
        });
      
       $("#printMapContainer").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,
            title: 'Print Map',
            autoOpen: false,
            position: 'center',
            hide: 'blind',
            show: 'blind',
            width:490,          
            overlay: {
                backgroundColor: '#000',
                opacity: 0.5
            },
            buttons: {
                'Close' : function() {
                    $(this).dialog('close');                    
                },
                'Print' : function() {                   
                    callPrintMap($v('pFlowId'),$v('pInstance'));
                                        
                }
            }
        }); 
});


function showMapLegend(){   
    $("#mapLegendContainer").dialog('open');
}

function showPrintMap(){          
    $("#printMapContainer").dialog('open');  
}

    
function initMap(pMapElement)
{ 
    if (!pMapElement){
       pMapElement = 'map';       
    }
   var mapCenterLon = null; //446629.34;
   var mapCenterLat = null; //128123.015; 
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=getmapcenterxy',0);                
   var gReturn = get.get('XML');
   get = null;
     
   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("X").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_x = gReturn.getElementsByTagName("X")[i];
         mapCenterLon = parseFloat(l_x.getAttribute('value'));
         var l_y = gReturn.getElementsByTagName("Y")[i];
         mapCenterLat = parseFloat(l_y.getAttribute('value'));
      }
   }

   getMapVariables();

   var mpoint = MVSdoGeometry.createPoint(mapCenterLon,mapCenterLat,SRID);
   mapview = new MVMapView(document.getElementById(pMapElement), baseURL);
   
//   mapview.enableCodingHints(false);
   MVMapView.enableCodingHints(false);  
   if (baseMapString !== null ){
      baseMap = new MVBaseMap(dataSource+'.'+baseMapString);
      mapview.addBaseMapLayer(baseMap); 
   }
   
   if (WMSMapString !== null ){
      WMSMap  = new MVBaseMap(dataSource+'.'+WMSMapString);
      mapview.addBaseMapLayer(WMSMap);
   }
//bear_with_jar_on_head.jpg
//Transport_For_London.png
//im4_framework/linux_penguin_small.gif
   if (copyImage !== null ){
      var watermark = new MVMapDecoration('<img class="mapCopyImage" src="'+copyImage+'" id="watermark"></img>',0,0,0,0,0,0);   
      watermark.setPrintable(true);
      watermark.enableEventPropagation(true);
      mapview.addMapDecoration(watermark);
   }
 
   mapview.setCenter(mpoint);
   mapview.setZoomLevel(mapZoom);

   addThemeBasedFOI();

   mapview.addCopyRightNote(copyright);
   //mapview.setHomeMap(mpoint, mapZoom);
   mapview.setHomeMap(mpoint, 1);
   mapview.addScaleBar();
   mapview.enableLoadingIcon(true);

   addInlineOverview();
   addLegend();

   mapview.addNavigationPanel("EAST");
   
  // mapview.enableCodingHints(false);

}

function displayReportResults(pURL, pTitle){
    $("#gri").dialog('option', 'title' , pTitle);    
    $("#gri").dialog('option','height',$(document).height()-50);
    $("#gri").dialog('option','width',$(document).width()-100);
    $("#griContent").attr('src',pURL);
    $("#gri").dialog('open'); 
}

function runReport(piModule, piJobID){
   var vallist = '';
   $('.gri_params, .gri_fields').each(function(index){
        vallist  += $(this).val() +':';
   });
  
   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=runReport',0);
   get.add('G_MODULE',piModule);
   get.add('G_JOB_ID',0);
   get.add('AI_VALS',vallist);
   gReturn = get.get();
   if (gReturn) {
    displayReportResults(gReturn,piModule); 
   }
}

var currentEditTab = -1;

$(document).ready(function() {
var page = $v('pFlowStepId');   
    if ( page != 800){
        return;
    }  
    $('#P800_DISPLAY_NAME').val("");
    $('#P800_DESCR').val("");
    
    $("#editdetails").dialog({
            bgiframe: true,
            resizable: false,
            modal: true,
            title: 'Change Tab Details',
            autoOpen: false,
            position: 'center',
            hide: 'blind',
            show: 'blind',
            width:700,
            //height:400,
            zIndex:4999,
            overlay: {
                backgroundColor: '#000',
                opacity: 0.5
            },
            buttons: {
                'Cancel' : function() {                 
                    $(this).dialog('close');                    
                },
                'Save' : function() {       
                   updateTabDetails();          
                    $(this).dialog('close');    
                                        
                }

            }
        }); 
   
}); 

function updateTabDetails(){
    //console.log('Current Edit tab is %d',currentEditTab);
    $('#disp_name'+currentEditTab).val($('#P800_DISPLAY_NAME').val());  
    $('#descr'+currentEditTab).val($('#P800_DESCR').val());
    
    $('#l801_'+currentEditTab).text($('#P800_DISPLAY_NAME').val());
    $('#P800_DISPLAY_NAME').val("");
    $('#P800_DESCR').val("");
    return; 
}

function editTabDetails(pId){
    currentEditTab = pId;
    $('#P800_DISPLAY_NAME').val($('#disp_name'+pId).val());
    $('#P800_DESCR').val($('#descr'+pId).val());
    $("#editdetails").dialog('open');
    
}   
    
function saveConfig(pUsername){
    var vals = "";
    var seq  = "";
    $('input:checked').each(function(index){        
        vals = vals + $(this).val()+':';
        seq = seq + index+':';
    });
    var dispNames = "";
    $("input:checked~.dispname ").each(function(index){
        dispNames = dispNames + $(this).val() + ':';
    });
    //console.log(dispNames);

    var descrs = "";
    $("input:checked~.descr").each(function(index){
        descrs = descrs + $(this).val() + ':';
    });

    
    var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=saveUserTabConfig',0);
   get.add('AI_ITTS_SEQ',seq);
   get.add('AI_VALS',vals);
   get.add('AI_USERNAME',pUsername);
   get.add('AI_DISPNAME',dispNames);
   get.add('AI_DESCRS',descrs);
   var gReturn = get.get();
  window.location.reload();
    return;
}   

$(document).ready(function() {
    if($('#mappod').length != 0) {
     executeLatestQuery();      
    } 
});


$(document).ready(function() {
   var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
                           'APPLICATION_PROCESS=getPODTitles',0);
   get.add('F_APP_PAGE_ID',$v('pFlowStepId'));   
   var gReturn = get.get('XML');
    
     if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("TITLE").length;

      for (var i=0; i<l_Count; i++)
      {
         var l_title         = gReturn.getElementsByTagName("TITLE")[i].getAttribute('value');
         var l_page          = gReturn.getElementsByTagName("PAGE")[i];
         var l_header        = gReturn.getElementsByTagName("HEADER")[i];
         var l_footer        = gReturn.getElementsByTagName("FOOTER")[i];

        if (l_title.search('&P6_PARAM1.') >0) {
           l_title = l_title.replace('&P6_PARAM1.',$('#P6_PARAM1').val());          
        } 
        if (l_title.search('&P6_PARAM2.') >0) {
           l_title = l_title.replace('&P6_PARAM2.',$('#P6_PARAM2').val());          
        } 
        if (l_title.search('&P6_PARAM3.') >0) {
           l_title = l_title.replace('&P6_PARAM3.',$('#P6_PARAM3').val());          
        } 
        if (l_title.search('&P6_PARAM4.') >0) {
           l_title = l_title.replace('&P6_PARAM4.',$('#P6_PARAM4').val());          
        } 
        if (l_title.search('&P6_PARAM5.') >0) {
           l_title = l_title.replace('&P6_PARAM5.',$('#P6_PARAM5').val());          
        } 
        
        var plsql_h;
        if (l_header.getAttribute('value').search('PLSQL:') > -1) {
           var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=exec_PLSQL_code', 0);
           get.add('PLSQL_CODE', l_header.getAttribute('value'));
           plsql_h = get.get();
           get = null;
        }
        if (!plsql_h ){
            plsql_h = l_header.getAttribute('value');
        }

        var plsql_f;
        if (l_footer.getAttribute('value').search('PLSQL:') > -1) {
           var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=exec_PLSQL_code', 0);
           get.add('PLSQL_CODE', l_footer.getAttribute('value'));
           plsql_f = get.get();
           get = null;
           
        }
        if (!plsql_f ){
            plsql_f = l_footer.getAttribute('value');
        }

         
        $('#'+l_page.getAttribute('value')).prepend(l_title);
        //$('#'+l_page.getAttribute('value')+'h').append(l_header.getAttribute('value'));        
        $('#'+l_page.getAttribute('value')+'h').prepend(plsql_h);
        $('#'+l_page.getAttribute('value')+'f').prepend(plsql_f);

        
        plsql_h = null;
        plsql_f = null;
      }
   }
   get = null;
    
});



$(document).ready(function() {
   
  $('.podIconslayer').bind("click", function(){
         showMapLegend();
      });
  $('.podIconsPrint').bind("click", function(){
         showPrintMap();
      });    
   $('.podIconsi').bind("click", function(){
                     podInfo($(this));
      });
      
      
   $("#dispInfo").dialog({
         bgiframe: true,
         resizable: false,
         modal: false,
         title: 'POD Info : ',
         autoOpen: false,
         position: 'center',
         hide: 'blind',
         show: 'blind',
         width:400,
         //height:400,
         zIndex:8999,
         overlay: {
            backgroundColor: '#000',
            opacity: 0.5
         },
         buttons: {
            'Close' : function() {             
               $(this).dialog('close');   
                        
            }
         }
      });     
      
});

function doDrillDown(piModule,Param1,Param2,Param3,Param4,Param5,Param6,Param7,Param8,Param9,Param10,Param11,Param12,Param13,Param14,Param15)
{
	

   var lAppID = $v('pFlowId');
   var lsessionID = $v('pInstance');  
   
   setSessionValue('MODULE_ID',piModule);
   
   var params = 'P6_MODULE,P6_PARAM1,P6_PARAM2,P6_PARAM3,P6_PARAM4,P6_PARAM5,P6_PARAM6,P6_PARAM7,P6_PARAM8,P6_PARAM9,P6_PARAM10,P6_PARAM11,P6_PARAM12,P6_PARAM13,P6_PARAM14,P6_PARAM15';
   var values = piModule+','+Param1+','+Param2+','+Param3+','+Param4+','+Param5+','+Param6+','+Param7+','+Param8+','+Param9+','+Param10+','+Param11+','+Param12+','+Param13+','+Param14+','+Param15;
      
   var url = 'f?p='+lAppID+':6:' + lsessionID+ '::::' + params + ':' + values;
   
   
   
   window.location = url;
   //var win =window.open(url,'Drilldown','menubar=no,width=1000,height=700,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   //win.focus();    
}   

function goMapPage(Param1,Param2,Param3,Param4,Param5
                    ,Param6,Param7,Param8,Param9,Param10
                    ,Param11,Param12,Param13,Param14,Param15){
   var lAppID = $v('pFlowId');
   var lsessionID = $v('pInstance');  
         
   var params = 'P4_PARAM1,P4_PARAM2,P4_PARAM3,P4_PARAM4,P4_PARAM5,P4_PARAM6,P4_PARAM7,P4_PARAM8,P4_PARAM9,P4_PARAM10,P4_PARAM11,P4_PARAM12,P4_PARAM13,P4_PARAM14,P4_PARAM15';
   var values = Param1+','+Param2+','+Param3+','+Param4+','+Param5+','+Param6+','+Param7+','+Param8+','+Param9+','+Param10+','+Param11+','+Param12+','+Param13+','+Param14+','+Param15;
      
   var url = 'f?p='+lAppID+':4:' + lsessionID+ '::::' + params + ':' + values;
   window.location = url;
   //var win =window.open(url,'Drilldown','menubar=no,width=1000,height=700,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   //win.focus();    
}

$(document).ready(function() {
var page = $v('pFlowStepId');   
    if ( (page >1 && page < 200) || page > 245 ){
      return;
   } 
       /* $("#"+page+"_PX_ENQ_ID").autocomplete('APEX', {
               apexProcess: 'AUTO_DOC_ID',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 1,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           }); */
      

       $("#"+page+"_PX_SURNAME").autocomplete('APEX', {
               apexProcess: 'AUTO_SURNAME',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 1,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });
        $("#"+page+"_PX_SURNAME").result(function(event, data, formatted) {
        if (data){
         $("#"+page+"_PX_CONTACT_ID").val(data[1]);           
           };
        });
           
       $("#"+page+"_PX_POSTCODE").autocomplete('APEX', {
               apexProcess: 'AUTO_POSTCODE',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 1,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });  
        $("#"+page+"_PX_POSTCODE").result(function(event, data, formatted) {
        if (data){
         $("#"+page+"_PX_POSTCODE_ID").val(data[1]);                 
           }
        }); 
        $("#"+page+"_PX_RESP_OF").autocomplete('APEX', {
               apexProcess: 'AUTO_RESP_OF',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 1,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });   
       $("#"+page+"_PX_RESP_OF").result(function(event, data, formatted) {
        if (data){
         $("#"+page+"_PX_RESP_OF_ID").val(data[1]);                 
           }
        }); 
   $("#clearEnqSearchButton, #mapEnqSearchButton, #searchEnqSearchButton, #clearTmaSearchButton, #mapTmaSearchButton, #searchTmaSearchButton").button();
   $("#"+page+"_PX_ENQ_ID, #"+page+"_PX_SURNAME, #"+page+"_PX_POSTCODE, #"+page+"_PX_RESP_OF").val('').addClass('inputFields');    
   $("#clearEnqSearchButton").bind('click',function(){
         $("#"+page+"_PX_ENQ_ID, #"+page+"_PX_SURNAME, #"+page+"_PX_POSTCODE, #"+page+"_PX_RESP_OF").val('');
   });
  
   $("#searchEnqSearchButton").bind('click',function(){         
          doDrillDown('IM1200',$('#'+page+'_PX_ENQ_ID').val(),$('#'+page+'_PX_CONTACT_ID').val(),$('#'+page+'_PX_POSTCODE_ID').val(),$('#'+page+'_PX_RESP_OF_ID').val());
   });

   $("#clearTmaSearchButton").bind('click',function(){
         $("#"+page+"_PX_TOWN, #"+page+"_PX_STREET, #"+page+"_PX_NSG, #"+page+"_PX_COUNTY, #"+page+"_PX_FROM, #"+page+"_PX_TO, #"+page+"_PX_REF").val('');
         setSessionValue('AI_TOWN',null);
   });

   $('#'+page+'_PX_COUNTY, #'+page+'_PX_NSG').addClass('findRoadworksFieldsDisabled').attr('disabled', 'disabled');
   
   $('#'+page+'_PX_IMPACT_SEVERE_0, #'+page+'_PX_IMPACT_MODERATE_0, #'+page+'_PX_IMPACT_SLIGHT_0, #'+page+'_PX_IMPACT_MINIMAL_0').attr('checked', true);
   
    $("#searchTmaSearchButton").bind('click',function(){         
          doDrillDown('IM1100',$('#'+page+'_PX_REF').val().toUpperCase(), $('#'+page+'_PX_TOWN').val(),$('#'+page+'_PX_NSG').val(),$('#'+page+'_PX_IMPACT_SEVERE_0:checked').val(),
                               $('#'+page+'_PX_IMPACT_MODERATE_0:checked').val(), $('#'+page+'_PX_IMPACT_SLIGHT_0:checked').val(), $('#'+page+'_PX_IMPACT_MINIMAL_0:checked').val(),
                               $('#'+page+'_PX_FROM').val(), $('#'+page+'_PX_TO').val(), $('#'+page+'_PX_NSG').val());
   });
   
   $("#mapTmaSearchButton").bind('click',function(){
       validateRoadworkButton('FINDTMA', page,$v('pFlowId'),$v('pInstance'));    
   });
   
    $("#"+page+"_PX_TOWN").autocomplete('APEX', {
               apexProcess: 'AUTO_TOWN',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 1,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });   
       $("#"+page+"_PX_TOWN").result(function(event, data, formatted) {
        if (data){
         $("#"+page+"_PX_COUNTY").val(data[1]);  
           setSessionValue('AI_TOWN',data[0]);
                    
           }
        }); 
    $("#"+page+"_PX_STREET").autocomplete('APEX', {
               apexProcess: 'AUTO_STREET',
               width: 400,
               multiple: false,
               matchContains: true,
               cacheLength: 0,
               max: 100,
               delay: 150,
               minChars: 0,
               matchSubset: false
           });   
       $("#"+page+"_PX_STREET").result(function(event, data, formatted) {
        if (data){
         $("#P"+page+"_X_STREET").val(data[1]);
         $("#"+page+"_PX_NSG").val(data[2]);                 
         $("#"+page+"_PX_TOWN").val(data[3]);
         $("#"+page+"_PX_COUNTY").val(data[4]);
           }
        });                   
});   


$(document).ready(function() {
var page = $v('pFlowStepId');   
    if ( page != 6 ){
      return;
   } 
   $("#P6_BackButton").button();
   $("#P6_BackButton").bind('click',function(){
         history.go(-1);
   });
     
   
        
});

function showPopUpMap(pType, pID){
  
   $("#mapholder").dialog('open');
   
   setMapQueryType(pType);
   
   $('#P0_ENQ_ID').val(pID);
   $('#P0_TMA_ID').val(pID);

   executeLatestQuery();
}

function getSetChartData(pThis){
    var html = $.ajax({
                    url: "http://gbexor8da/im4dev/im_chart_gen.simple_xml?pi_page_id=1&pi_user_id=HIGHWAYS&pi_position=2"
                    ,async: false
                }).responseText; 
    pThis.setData(html);
}


$(document).ready( function() {
    var page = $v('pFlowStepId');   
    if ( page != 6){
        return;
    }  
	
	 $(document).click(function(){  
        $('#apexir_rollover').hide(); //hide the button
     });
	
	$("div[id^='apexir_C0']").each(function(){	    
		$(this).removeAttr('Onclick').bind('click',function(e){
			
			
			
			var offset = $(this).offset();
			var width = $(window).width(); 
			
			if ( (offset.left + 200 ) > width ){
				offset.left  = offset.left - 200;
			}
			
			$("#apexir_rollover").attr('style','position: relative; left: '+ offset.left+'px; top: '+(offset.top+15)+'px;');
			
			$("#apexir_rollover").fadeIn();
			
            e.stopPropagation();
			                     
		});
	});
});         

var fixHelper = function(e, ui) {
    ui.children().each(function() {
        $(this).width($(this).width());
    });
    return ui;
};


$(document).ready( function() {


$('.rowdown,.rowup').attr("title","Click-hold and drag to a new position").removeAttr("style");
	$('.cmode_ReportData tr td').parent('tr').addClass("MoveableRow");
	$('.cmode_ReportData tbody').sortable({
		helper: fixHelper
		,items: '.MoveableRow'
		,placeholder: "ui-state-highlight"
		,forcePlaceholderSize: true
	}).disableSelection();
	

/*
	$('.cmode_ReportData tr td').parent('tr').addClass("MoveableRow");

	$('.rowdown').live('click', function () {
		var rowToMove = $(this).parents('tr.MoveableRow:first');
		var next = rowToMove.next('tr.MoveableRow')
		if (next.length == 1) { next.after(rowToMove); }
	});

	$('.rowup').live('click', function () {
		var rowToMove = $(this).parents('tr.MoveableRow:first');
		var prev = rowToMove.prev('tr.MoveableRow')
		if (prev.length == 1) { prev.before(rowToMove); }
	});
*/
});         

function openForms(pOBJECT,pID){
    var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=getFormsURL',0);
	get.add('OID',pID);
	get.add('NAVOBJECT',pOBJECT);
	var gReturn = get.get();
    var win =window.open(gReturn,'Navigator','menubar=0,width=10,height=10,toolbar=0,scrollbars=0,resizable=0,status=0');
	win.focus();         
}

function showFeatureOnMap(pFeatureID, pLayerName){
  
   $("#mapholder").dialog('open');
   
   showMapNoDisplay();
   
   removeTemplated();
    
   var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + pLayerName);
   xthemebasedfoi.setQueryParameters(pFeatureID);
    
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
   xthemebasedfoi.setEventListener("mouse_click", foiClick);
   xthemebasedfoi.setBoundingTheme(true);
   mapview.addThemeBasedFOI(xthemebasedfoi);
   
   mapview.display();
   
}
$(document).ready(function(){
//
// Display the pod tree if pod maintenance selected
// else display admin tree
//
   var page = $v('pFlowStepId');   
	if ( page == 995  || page == 996 ){
      $(".cmode_Accordion").accordion( "option", "active", 1 );
	} 
	else
	{
		$(".cmode_Accordion").accordion( "option", "active", 1 );
	}
    return;   
});   