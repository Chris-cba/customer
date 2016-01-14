/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/im4_framework_4500/im4_framework_4500/js/im4_wo_wt.js-arc   1.0   Jan 14 2016 21:38:32   Sarah.Williams  $
 --       Module Name      : $Workfile:   im4_wo_wt.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 21:38:32  $
 --       Date fetched Out : $Modtime:   Mar 08 2012 20:01:16  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 --	Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */

var instructItem = null;
var holdRejectItem = null;
var forwardItem = null;
var authoriseItem = null;

//$(document).ready(function(){
//      $('.dhtmlMenuLG').parent('td').parent('tr').append('<td><input type="button" class="t13Button" value="Instruct" onclick="javascript:instructSelected();"></td>');
//	});

function instructSelected(pWorkOrderID){
	var rtrn = true;
	var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=instructWO',0);
	get.add('WOID',pWorkOrderID);
	get.add('WOINSDATE',$('#P'+ $v('pFlowStepId')+'_INSTRUCT_DATE').val());
	var gReturn = get.get();
	if (gReturn.substr(0,3) === 'Err'){		
		rtrn = false;
	}
	$("#errorbox").empty().append(gReturn).dialog('open');
	return rtrn;
}

function authoriseSelected(pWorkOrderID){
	var rtrn = true;
	var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=authoriseWO',0);
	get.add('WOID',pWorkOrderID);
	var gReturn = get.get();
	if (gReturn.substr(0,3) === 'Err'){		
		rtrn = false;
	}
	$("#errorbox").empty().append(gReturn).dialog('open');
	return rtrn;
}


$(document).ready(function(){
		$("#boqcontainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Bill of Quantities (BOQ)',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:750,
			//height:500,
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Cancel': function(){
					$(this).dialog('close');
				}
			}
		});
	});

$(document).ready(function(){
	var cbox = getChecked();
	cbox.attr('checked',false);
	cbox.bind("click", function(){
		//cbox.attr('checked', false);
		$(this).attr('checked', true);
	});	
	
	
});

$(document).ready(function(){	
		$("#errorbox").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Message',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:500,
			//height:170,			
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'OK': function(){				
				    $(instructItem).attr('checked',false);		  
					$(this).dialog('close');
				}
			}
		});
	});

$(document).ready(function(){	
		$("#confirmbox").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Confirm',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			zIndex:100,
			//width:200,
			//height:170,			
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Cancel': function(){
					$(instructItem).attr('checked',false);
					$(this).dialog('close');
				},
				'OK': function(){		
				    if (instructSelected(instructItem.val())) {
						$(instructItem).parent("td").parent("tr").remove();
						/* var words = new Array();
						words = $('.fielddata').text().split(' ');
						
					      //console.log('i is ' + 3 + ' : '+ words[3] + ' new : '+ words[3] - 1);
						  var x = words[3] -1;
						  var y = words[5] -1;
						  //	console.log('i is ' + i + ' : ' + words[i] + ' new : %d ',x );
						  
						  var xofy = '';
						  xofy = words[0] +' '+ words[1] + ' '+ words[2]+ ' '+x+' ' + words[4]+' '+ y +' '+ words[6];
						  console.log(xofy);
						  $('.fielddata').text(xofy);
*/						  
					}
					$(this).dialog('close');
				}
			}
		});
	});

$(document).ready(function(){
		$("#holdrejectcontainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Reason for Hold/Rejection',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:550,
			height:230,
			zIndex:500,
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Cancel': function(){
					$(holdRejectItem).attr('checked',false);
					$(this).dialog('close');
				},
				'OK': function(){					
					$(holdRejectItem).parent("td").parent("tr").remove();
					$(this).dialog('close');
				}
			}
		});
	});

$(document).ready(function(){
		$("#forwardtocontainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Forward To',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:320,
			open: function(event, ui){getFwdUserList(getChecked().val());},
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Cancel': function(){
					$(forwardItem).attr('checked',false);
					$(this).dialog('close');
				},
				'OK': function(){					
					if (forwardWO()){				
						$(forwardItem).parent("td").parent("tr").remove();
					}
					$(forwardItem).attr('checked',false);
					$(this).dialog('close');
				}
			}
		});
	});
$(document).ready(function(){
		$("#authorisedcontainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'Authorise',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:320,
			open: function(event, ui){getFwdUserList(getChecked().val());},
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Cancel': function(){
					$(authoriseItem).attr('checked',false);
					$(this).dialog('close');
				},
				'OK': function(){					
					if(!authoriseSelected(authoriseItem.val())){
					   $(authoriseItem).attr('checked',false);
					}
					else{
						$(authoriseItem).attr('disabled',true);
						}
					$(this).dialog('close');
				}
			}
		});
	});

function openBOQ(pWONumber,pWOLNumber){
	var get = new htmldb_Get(null, $x('pFlowId').value, null, 11);
	get.add('P11_WO_NUMBER', pWONumber);
	get.add('P11_WOL_NUMBER', pWOLNumber);
	
    var gReturn = get.get(null, '<ajax:BOX_BODY>', '</ajax:BOX_BODY>');
    get = null;
    $x('boqcontainer').innerHTML = gReturn;
	$("#boqcontainer").dialog( "option", "title",  'Bill of Quantities (BOQ) for WO '+pWONumber );
	$("#boqcontainer").dialog('open');
	return;
}

function openBOQWO(pWONumber){
	var get = new htmldb_Get(null, $x('pFlowId').value, null, 14);
	get.add('P14_WO_NUMBER', pWONumber);
	
    var gReturn = get.get(null, '<ajax:BOX_BODY>', '</ajax:BOX_BODY>');
    get = null;
    $x('boqcontainer').innerHTML = gReturn;
	$("#boqcontainer").dialog( "option", "title",  'Bill of Quantities (BOQ) for WO '+pWONumber );
	$("#boqcontainer").dialog('open');
	return;
}

function getChecked(){
   return $('input:checkbox:checked:not(.authchk).selectme');
}

function openConfirmBox(pText){	
	instructItem = getChecked();
//	$("#confirmbox").empty().append('<h5>'+pText+'</h5><h5>'+instructItem.val()+'</h5>'
//	    +'<input type="text" id="P10_INSTRUCT_DATE" value="" maxlength="2000" size="30" name="p_t05" class="hasDatepicker">'
//        +'<img class="ui-datepicker-trigger" src="/i/asfdcldr.gif" alt="..." title="...">'
//	 ).dialog('open');
     $("#ui-datepicker-div").addClass("promoteZ"); 
	 $("#wolid").empty().append(instructItem.val());
     
     $('#P'+ $v('pFlowStepId')+'_INSTRUCT_DATE').val(new Date().toLocaleDateString().replace(/ /gi,'-'));
	 $("#confirmbox").dialog('open');
	return;
}	
function openHoldRejectDialog(){
	holdRejectItem = getChecked();
	
	$("#holdrejectcontainer").dialog('open');
	return;
}	
function openForwardToDialog(){
	forwardItem = getChecked();

	$("#forwardtocontainer").dialog('open');
	//repromoteZturn;
}	

function openAuthoriseDialog(){
	authoriseItem = $('input:checkbox:checked.authchk:enabled');
    $("#wolida").empty().append(authoriseItem.val());
	$("#authorisedcontainer").dialog('open');
	return;
}

$(document).ready(function(){
	$wollinesinfo = $('#wolineinfo');
	$('#wolmsg').empty();
	$wollinesinfo.mouseenter(function() {
	    
        $wollinesinfo.show();
		
		});
	$wollinesinfo.mouseleave(function() {
		$('#wolmsg').empty();
        $wollinesinfo.hide();		
		});
})

function showWOLDetails(pThis){

	wollinesinfo = $('#wolineinfo');
	$wollinesinfo.hide();
/*		var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=getWOLDetails',0);
		get.add('WOID',$(pThis).attr('id'));
		var gReturn = get.get();
		$('#wolmsg').empty().append(gReturn);
	*/	
	var get = new htmldb_Get(null, $x('pFlowId').value, null, 12);
	get.add('P12_WO_NUMBER', $(pThis).attr('id'));
	
    var gReturn = get.get(null, '<ajax:BOX_BODY>', '</ajax:BOX_BODY>');
    get = null;
    $('#wolmsg').empty().append(gReturn);
//$('html, body').animate({scrollTop: $(pThis).offset().top}, 2000);
	//get the position of the placeholder element
	var pos = $(pThis).offset();  
	var width = $(pThis).width();
	var height = $(pThis).height();
	//show the menu directly over the placeholder
	//$wollinesinfo.css( { "left": (pos.left + width) + "px", "top":pos.top + "px" } );
	$wollinesinfo.css( { "left": (pos.left+100) + "px", "top":(pos.top + height )+ "px" } );
			
	$wollinesinfo.show();
	//$wollinesinfo.show().animate({opacity: 1.0}, 10000).fadeOut();
}
	
function resetLocation(){
   $('#P'+ $v('pFlowStepId')+'_NE_UNIQUE').val('');
   $('#P'+ $v('pFlowStepId')+'_NE_ID').val('');
   $('#P'+ $v('pFlowStepId')+'_LOCATION_TEXT').val('');
   $('#wolmsg').empty();
   $('#wolineinfo').hide(); 
   doSubmit('SUBMIT');
   
}	
	
function reLoad(){
   $('#wolmsg').empty()
   $('#wolineinfo').hide(); 
   $('#P'+ $v('pFlowStepId')+'_LOCATION_TEXT').val($('#P'+ $v('pFlowStepId')+'_NET_LOCATION').val());
   doSubmit('SUBMIT');
}	
	
$(document).ready( function() {
	var page = $v('pFlowStepId');   
    if ( page != 10){
		return;
	}  
	$('#wolmsg').empty();	
	$('#wolineinfo').hide();
	$('.close_message').bind("click",function(){
	    $('#wolmsg').empty();
		$('#wolineinfo').hide();
	});
	
	var $lab = $("label[for='P'+ $v('pFlowStepId')+'_NET_LOCATION']").parent('td').html();
	$("label[for='P'+ $v('pFlowStepId')+'_NET_LOCATION']").remove();
	
	var $netloc = $('#P'+ $v('pFlowStepId')+'_NET_LOCATION').parent('td').html();
	$('#P'+ $v('pFlowStepId')+'_NET_LOCATION').remove();
	
	$('.dhtmlMenuLG').parent('td').parent('tr').append('<td>'+$lab+'</td>');
	$('.dhtmlMenuLG').parent('td').parent('tr').append('<td>'+$netloc+'</td>');
	$('.dhtmlMenuLG').parent('td').parent('tr').append('<td><input type="button" onclick="reLoad();" value="Set Location"/></td>');
	$('.dhtmlMenuLG').parent('td').parent('tr').append('<td><input type="button" onclick="resetLocation();" value="Reset"/></td>');
	
	$("#P'+ $v('pFlowStepId')+'_NET_LOCATION").autocomplete('APEX', {
			apexProcess: 'AUTO_NETWORK',
			width: 400,
			multiple: false,
			matchContains: true,
			cacheLength: 1,
			max: 100,
			delay: 150,
			minChars: 3,
			matchSubset: false
		});
	 $("#P'+ $v('pFlowStepId')+'_NET_LOCATION").result(function(event, data, formatted) {
		 if (data){
			$("#P'+ $v('pFlowStepId')+'_NE_ID").val(data[1]);
			$("#P'+ $v('pFlowStepId')+'_NE_UNIQUE").val(data[2]);			
		   }
		});
	if ($('#P'+ $v('pFlowStepId')+'_LOCATION_TEXT').val()){	
     $('#apexir_TOOLBAR').append('<p>Location set to '+$('#P'+ $v('pFlowStepId')+'_LOCATION_TEXT').val()+'</p>');
	 }
});			


$(document).ready( function() {
var page = $v('pFlowStepId');   
    if ( page == 201){
		$("#P201_USER").autocomplete('APEX', {
				apexProcess: 'AUTO_USERNAME',
				width: 400,
				multiple: false,
				matchContains: true,
				cacheLength: 1,
				max: 100,
				delay: 150,
				minChars: 1,
				matchSubset: false
			});
		 $("#P201_USER").result(function(event, data, formatted) {
			 if (data){
				$("#P201_MWU_USER_ID").val(data[1]);
			   }
			});
	}  
    if ( page == 202){
	

		var $P202_GROUP_TYPE = $("#P202_GROUP_TYPE").val('');
		
		$P202_GROUP_TYPE.bind("keypress", function(e) {
		if (e.keyCode == 13) {return false;}
		});
		
		$P202_GROUP_TYPE.autocomplete('APEX', {
				apexProcess: 'AUTO_GROUP_TYPE',
				width: 400,
				multiple: false,
				matchContains: true,
				cacheLength: 1,
				max: 100,
				delay: 150,
				minChars: 1,
				matchSubset: false
			});
		 $P202_GROUP_TYPE.result(function(event, data, formatted) {
			 if (data){
				var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=get_groups_shuttle',0);
				get.add('GROUP_TYPE',data[1]);
				var gReturn = eval(get.get());
				get = null;
				
				var left = $x("P202_ROAD_GROUPS_LEFT");
				left.length=0;
				  if (gReturn)
					for ( var i=0; i<gReturn.length; i++ )
					  left.options[i] = new Option(gReturn[i].data, gReturn[i].id);
			   }
			});
	}
	 
});			

	
	
function getFwdUserList(pWOId){
	var l_Return = null;
	var l_Select = html_GetElement('P'+ $v('pFlowStepId')+'_FORWARD_TO');
	var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
			  'APPLICATION_PROCESS=getForwardWOtoUsers',0);              
	get.add('WOID',pWOId);
	gReturn = get.get();
	$('#P'+ $v('pFlowStepId')+'_FORWARD_TO').empty().append(gReturn);

	get = null;
} 	

function forwardWO(){
	var rtrn = true;
	var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
			  'APPLICATION_PROCESS=forwardWO',0);              
	get.add('WOID',getChecked().val());
	get.add('USERID',$('#P'+ $v('pFlowStepId')+'_FORWARD_TO').val());
	gReturn = get.get();
		if (gReturn.substr(0,3) === 'Err'){		
		rtrn = false;
	}
	$("#errorbox").empty().append(gReturn).dialog('open');
	return rtrn;
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
			width:750,
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
										
				},
				'Refresh' : function() {
					showMap();},
				'Legend' : function() {
					showMapLegend();},
                'Print' : function() {
					showPrintMap();}
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
			height:500,
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

$(document).ready(function(){
		$("#printMapContainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: false,
			title: 'Print Map',
			autoOpen: false,
			position: 'right',
			hide: 'blind',
			show: 'blind',
			width:490,
			height:280,
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
    
$(document).ready(function() {
	var page = $v('pFlowStepId');   
    if ( page != 101){
		return;
	}  
	
    var $P0_PROD_LIC = $('#P0_PROD_LIC');
    var $nolicimg = $('#nolicimg').hide();
    
    if ($P0_PROD_LIC.val() === 'NO'){
     $nolicimg.show();
     $('#P101_USERNAME, #P101_PASSWORD, #P101_DATABASE').addClass("disabledField");
     $('.t13Button').attr("disabled","disabled");
          
    }
         
});    

function showWorkOrder(pWOID, pWOLID){
    removeTemplated();
       
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + 'IM_WORK_ORDER_LINES');
    xthemebasedfoi.setQueryParameters(pWOLID, pWOLID, pWOID );
    
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}

function showPopUpMap(pWOID, pWOLID){
  
	$("#mapholder").dialog('open');
	showMapNoDisplay();
	
	showWorkOrder(pWOID, pWOLID);
	
	mapview.display();
	setMapListener();
}

function showMapLegend(){ 	
	$("#mapLegendContainer").dialog('open');
}

function showPrintMap(){ 		  
    $("#printMapContainer").dialog('open');  
}

function openForms(pWOID){
    var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=getFormsURL',0);
	get.add('WOID',pWOID);
	
	var gReturn = get.get();
    var win =window.open(gReturn,'WorkOrders','menubar=0,width=10,height=10,toolbar=0,scrollbars=0,resizable=0,status=0');
	win.focus();         
}


$(document).ready(function() {
    $('.workcode').each(function (){
	   // console.log($(this).val());
		var l_Return = null;	
		var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
				  'APPLICATION_PROCESS=getWorkCodes',0);              
		get.add('WOID',$(this).val());
		gReturn = get.get();
		$(this).empty().append(gReturn);

		get = null;	   
	});
	
    $('.shuttleSelect1').prepend('<th>Available Groups</th>');	
	$('.shuttleSelect2').prepend('<th>Selected Groups</th>');	

	var l_Return = null;	
	var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
			  'APPLICATION_PROCESS=getRoadGroups',0);              
	get.add('WOID',$('#P202_MWU_USER_ID').val());
	gReturn = get.get();
	$('#P202_ROAD_GROUPS_RIGHT').empty().append(gReturn);

	get = null;	   

   
})

function saveUserRoadGroups(pUserID){
   var list = "";
   $('#P202_ROAD_GROUPS_RIGHT option').each(function(){
		list = list + $(this).val() + ':';
		});
	var l_Return = null;	
	var get = new htmldb_Get(null,html_GetElement('pFlowId').value,'APPLICATION_PROCESS=saveRoadGroups',0);              
	get.add('WOID',pUserID);
	get.add('AI_VALS',list);
	gReturn = get.get();
	get = null;	
	
}
function showDrillDown(appID, sessionID, page, item1,val1, item2,val2, item3,val3, item4,val4, item5,val5 ){
var params = '';

   if (item1 != null)
   {  
       params = item1+':'+val1;
   }
   if (item2 != null)
   {
       params = item1+','+item2+':'+val1+','+val2;
   }
   if (item3 != null)
   {
       params = item1+','+item2+','+item3+':'+val1+','+val2+','+val3;
   }   
   if (item4 != null)
   {
       params = item1+','+item2+','+item3+','+item4+':'+val1+','+val2+','+val3+','+val4;
   }
   if (item5 != null)
   {
       params = item1+','+item2+','+item3+','+item4+','+item5+':'+val1+','+val2+','+val3+','+val4+','+val5;
   }      
    
   //var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
   //           'APPLICATION_PROCESS=getCurrentSessionID',0);

   //var lsessionID = get.get();
   
   //get = null;
   var lsessionID = $v('pInstance');  
      
   var url = 'f?p=' + appID + ':'+page+':' + lsessionID+ '::::' + params;
   
  
   if (page != '51'){     
   
    var win =window.open(url,'Drilldown','menubar=no,width=1000,height=700,toolbar=no,scrollbars=yes,resizable=yes,status=no');
	win.focus();         
	//$("#onLineHelp").dialog('close');
	//$("#jqmContent").attr("src",url);  
	//$("#onLineHelp").dialog('option', 'title' , '');  
	//$("#onLineHelp").dialog('open');
	//$("#myTabs").tabs("add",url,"new tab");
		
	
	//var id =$("#myTabs").tabs('length') ;
	//$("#myTabs").tabs('add', url, 'New Tab ' +page );
	
	//if (!$("#drillDownContainer").dialog( 'isOpen' )){		
	//	$("#drillDownContainer").dialog('open');	
    //}
   }
   else{
    	$("#griContent").attr("src",url);  
        $("#gri").dialog('option', 'title' , '');    
        $("#gri").dialog('option','height',$(document).height()-50);
        $("#gri").dialog('option','width',$(document).width()-100);
    	$("#gri").dialog('open');       
   }
 }
