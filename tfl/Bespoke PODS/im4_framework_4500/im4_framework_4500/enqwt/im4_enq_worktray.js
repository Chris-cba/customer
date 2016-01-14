//
// This javascript file is for the ENQ work Tray
//
/* -----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/im4_framework_4500/im4_framework_4500/enqwt/im4_enq_worktray.js-arc   1.0   Jan 14 2016 21:15:42   Sarah.Williams  $
--       Module Name      : $Workfile:   im4_enq_worktray.js  $
--       Date into PVCS   : $Date:   Jan 14 2016 21:15:42  $
--       Date fetched Out : $Modtime:   Nov 14 2011 21:55:00  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
*/

function get_select_list(pThis, pSelect){
    html_Submit_Progress();
    var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=popAdminNameLOV', 0);
    get.add('PADMINORUSER', pThis);
    gReturn = get.get('XML');
    //alert(pThis);
    if (gReturn && l_Select) {
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for (var i = 0; i < l_Count; i++) {
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect2(l_Select, l_Opt_Xml.getAttribute('value'), l_Opt_Xml.firstChild.nodeValue);
        }
    }
    get = null;
	
	$x_Hide('AjaxLoading');
}

function appendToSelect2(pSelect, pValue, pContent, pSelected){
    var l_Opt = document.createElement("option");
    l_Opt.value = pValue;
	l_Opt.selected = pSelected;
    if (document.all) {
        pSelect.options.add(l_Opt);
        l_Opt.innerText = pContent;
    }
    else {
        l_Opt.appendChild(document.createTextNode(pContent));
        pSelect.appendChild(l_Opt);
    }
    
}

function html_Submit_Progress(){
    $x_Show('AjaxLoading');
    window.setTimeout('$s("AjaxLoading",$x("AjaxLoading").innerHTML)', 100);
    
}  



function AjaxReportRefresh(piButton){
	html_Submit_Progress();
	$s('P0_RADIO_IP', $v('P1_RADIO_IP'));
	$s('P0_LOV', $v('P1_LOV'));
	

	var get = new htmldb_Get(null, $x('pFlowId').value, null, 19);
	get.add('P19_RADIO_IP', $v('P1_RADIO_IP'));
	get.add('P19_LOV', $v('P1_LOV'));
    var gReturn = get.get(null, '<ajax:BOX_BODY>', '</ajax:BOX_BODY>');
    get = null;
    $x('AjaxReport').innerHTML = gReturn;
	

	var get = new htmldb_Get(null, $x('pFlowId').value, null, 18);
	get.add('P18_RADIO_IP', $v('P0_RADIO_IP'));
	get.add('P18_LOV', $v('P0_LOV'));
    var gReturn = get.get(null, '<ajax:BOX_BODY>', '</ajax:BOX_BODY>');
    get = null;
    $x('AjaxReportENQRec').innerHTML = gReturn;


    $x_Hide('AjaxLoading');
	
    return;
}

function ENQSumaryRefresh(pPriority, pDay, pPriorityText){
    html_Submit_Progress();
    $s('P0_DAY', pDay);
    $s('P0_PRIORITY', pPriority);
    $s('P0_PRIORITY_TEXT', pPriorityText);
    
    doSubmit('Enquiries');
    $x_Hide('AjaxLoading');

    return;
}

function enqListFromReceived( pDay, pPriorityText){
    html_Submit_Progress();
    $s('P0_RE_DAYS', pDay);
    $s('P0_RE_TEXT', pPriorityText);
    
    doSubmit('T_ENQUIRIES');
    $x_Hide('AjaxLoading');
    return;
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

$(document).ready(function(){
		$("#raisedefect").dialog({
			bgiframe: true,
			resizable: true,
			modal: true,
			title: 'Raise Defect',
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
				'Cancel': function(){
					$(this).dialog('close');
				},
				'Create' : function() {	               				   
					createDefectNow();						
				}
			}
		});
	});

$(document).ready(function(){
		$("#infobox").dialog({
			bgiframe: true,
			resizable: true,
			modal: true,
			title: '',
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
				'Close': function(){
					$(this).dialog('close');
				}
			}
		});
	});

function setMaxDocID(){
  var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                          'APPLICATION_PROCESS=getMaxDocId',0); 	 
    var gReturn = get.get();
    $('#P0_MAX_DOC_ID').val(gReturn);
    get = null;
}

function displayNewDocCheck(){
    var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                          'APPLICATION_PROCESS=checkNewDocs',0); 	
    get.add('DOC_ID',$v('P0_MAX_DOC_ID'));                                  
    var gReturn = get.get();
    get = null;   
    if (gReturn === 'YES'){
        setMaxDocID();
        $('#NEWENQ').show().addClass('NEWENQ');    
        clearInterval ($('#P0_TIMER_ID').val());
    }    
}

$(document).ready(function() {
    $('#P0_DOC_REASON, #P0_OUTCOME_REASON').addClass('disabledField');
    
    $('#P10_LOCATION, #P10_DESCRIPTION, #P10_ACTIONS, #P10_NEW_ACTION').resizable({
    	maxHeight: 500,
    	maxWidth:  1015,
    	minHeight: 50,
    	minWidth:  1015,
    	handles: 's, se'
    });
    $('#P12_DOC_REASON_LATER_ARR').resizable({
    maxHeight: 500,
    maxWidth:  735,
    minHeight: 50,
    minWidth:  735,
    handles: 'se'
    });       
    
    $('#P0_DOC_STATUS_CODE').bind('change',function(){
			var $P0_DOC_REASON =  $('#P0_DOC_REASON');
            $P0_DOC_REASON.removeClass('disabledField')
                          .val($('#P0_DOC_STATUS_CODE :selected').text())
						  .removeAttr('disabled');            
		});
    $('#P0_DOC_OUTCOME').bind('change',function(){
			var $P0_OUTCOME_REASON =  $('#P0_OUTCOME_REASON');
            $P0_OUTCOME_REASON.removeClass('disabledField')
                          .val($('#P0_DOC_OUTCOME :selected').text())
						  .removeAttr('disabled');            
		});
    setMaxDocID();
    $('#P0_TIMER_ID').val(setInterval ( "displayNewDocCheck()", 50000 ));
    
});


function createEnqTemplatedFOI(pEnqId)
{
   removeTemplated();
   var docID = pEnqId;
   var respOf = '';
   var postcode = '';
   var surname = '';
   var xthemebasedfoi = new MVThemeBasedFOI('locator',dataSource+'.'+EnqTheFOI);
   xthemebasedfoi.setQueryParameters(docID,respOf,postcode,postcode,surname,surname);
   
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
   xthemebasedfoi.setEventListener("mouse_click", foiClick);
   xthemebasedfoi.setBoundingTheme(true);   
   mapview.addThemeBasedFOI(xthemebasedfoi);
}

function showPopUpMap(pDocID){
    $s('P0_ENQ_ID',pDocID); 	
	$("#mapholder").dialog('open');
	showMapNoDisplay();
	
	//createEnqTemplatedFOI(pDocID);
    setEnqsTemplatedReport('P0_ENQ_ID');
	mapview.display();
	setMapListener();
}

function showMapLegend(){ 	
	$("#mapLegendContainer").dialog('open');
}

function showPrintMap(){ 		  
    $("#printMapContainer").dialog('open');  
}

function showInfoBox(pText){
    $("#infotext").val(pText); 	
	$("#infotext").dialog('open');
}

function showRaiseDefect(){    
	var url = 'f?p=' + $v('pFlowId') + ':30:' + $v('pInstance') ;
	$("#rdContent").attr("src",url);    
	$("#raisedefect").dialog('open');
	
}

function update_enquiry(){
            
         var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                                  'APPLICATION_PROCESS=update_enquiry',0); 	 
         get.add('DOC_ID',$v('P0_ENQ_ID'));         
         get.add('DOC_STATUS_CODE',$v('P0_DOC_STATUS_CODE'));
         get.add('DOC_REASON',$v('P0_DOC_REASON'));
         get.add('DOC_COMPL_COMPLETE',$v('P0_DOC_COMPL_COMPLETE'));
         get.add('DOC_LOCATION',$v('P0_DOC_LOCATION'));
         get.add('DOC_DESCRIPTION',$v('P0_DOC_DESCRIPTION'));
         get.add('DOC_ACTIONS',$v('P0_ACTIONS'));         
         get.add('DOC_COMPL_CPR_ID',$v('P0_DOC_COMPL_CPR_ID'));
         get.add('EMAIL',$v('P0_EMAIL'));
         get.add('HOME_PHONE',$v('P0_HOME_PHONE'));
         get.add('WORK_PHONE',$v('P0_WORK_PHONE'));
         get.add('MOBILE_PHONE',$v('P0_MOBILE_PHONE'));
         get.add('NE_ID',$v('P0_NE_ID'));
         get.add('REASON_LATE',$v('P0_DOC_REASON_LATER_ARR'));
         get.add('DOC_OUTCOME',$v('P0_DOC_OUTCOME'));
         get.add('OUTCOME_REASON',$v('P0_OUTCOME_REASON'));
         get.add('DOC_COMPL_INCIDENT_DATE',$v('P0_DOC_COMPL_INCIDENT_DATE'));
         get.add('DOC_DATE_TIME_ARRIVED',$v('P0_DOC_DATE_ARRIVED')+' '+$v('P0_DOC_TIME_ARRIVED'));                  
		 
		 get.add('G_DTP_CODE', $('#P0_CATEGORY').val());
		 get.add('G_DCL_CODE', $('#P0_CLASS').val());
		 get.add('G_DEC_CODE', $('#P0_TYPE').val());
                                            
         gReturn = get.get();
         get = null;
         
         if (gReturn != "OK" ){
            alert(gReturn);    
         }
         else {
           
			var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                                  'APPLICATION_PROCESS=get_doc_action_text',0); 	 
			get.add('DOC_ID',$v('P0_ENQ_ID'));  
			gReturn = get.get();
            get = null;
			$('#P10_ACTIONS').val(gReturn);			
			$('#P10_NEW_ACTION').val('');
			alert('Enquiry has been updated.');
         }
		
}          


$(document).ready(function(){
    var page = $v('pFlowStepId');
	if (page != 11){
        return;
    }
	
    var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                          'APPLICATION_PROCESS=checkenqcontact',0); 	 
    get.add('FIELD_VALUE',$v('P0_ENQ_ID'));
    gReturn = get.get();
    get = null;
    
    if (gReturn != 'Y'){
        $('#P11_HOME_PHONE,#P11_WORK_PHONE,#P11_MOBILE_PHONE,#P11_EMAIL').addClass('disabledField');
    }    
});


$(document).ready(function() {
	var page = $v('pFlowStepId');
	
	if ( page <= 10 && page >=15){
		return;
	}
    
	var lchangebutton  = $('#changebutton'); 
	var lchangebutton2  = $('#changebutton2');
    var lchangeimage  = $('#changeimage');
    var lmapbutton  = $('#mapbutton'); 
	var lmapbutton2  = $('#mapbutton2');
	var lmapimage   = $('#mapimage');
	var ldocbutton  = $('#docbutton');
	var ldocbutton2  = $('#docbutton2');
	var ldocimage   = $('#docimage');
	var ldefbutton  = $('#defbutton');
	var ldefbutton2  = $('#defbutton2');
	var ldefimage   = $('#defimage');	
	var lsavebutton = $('#savebutton');
    var lsavebutton2 = $('#savebutton2');
	var lsaveimage  = $('#saveimage');
	var lcancelbutton = $('#cancelbutton');
	var lcancelbutton2 = $('#cancelbutton2');
	var lcancelimage  = $('#cancelimage');

	
	var lwidth     = "24";
	var lheight    = "24";
	
	var lImageBase = "/im4_framework/";
    
    // set all updateable values to null
    // that are not eneterd on page 0
    $('#P0_LOCATION,#P0_DESCRIPTION,#P0_ACTIONS,#P0_HOME_PHONE,#P0_WORK_PHONE,#P0_MOBILE_PHONE,#P0_EMAIL,#P0_DOC_REASON_LATER_ARR').val('');
    
    var lP0_DOC_ID = $('#P0_DOC_ID');
    var lP0_RETURN_TO_PAGE = $('#P0_RETURN_TO_PAGE');
    
    lP0_RETURN_TO_PAGE.val($('#P0_RTRN_TO_PAGE_TMP').val());
    
    lchangeimage.attr("src", lImageBase+"enqwt/refresh.gif").attr("title", "Click to allow select a different ID");
    lchangebutton2.bind("click", function(){
			
            lP0_DOC_ID.toggleClass("disabledField");
			
            
            if (lP0_DOC_ID.hasClass("disabledField")){
                $('#P0_RETURN_TO_PAGE').val($('#P0_RTRN_TO_PAGE_TMP').val());
				lP0_DOC_ID.attr('disabled','disabled');				   
            }
            else{
                $('#P0_RETURN_TO_PAGE').val('10');
				lP0_DOC_ID.removeAttr('disabled'); 
            }            
		})
    
    
	if ($v('P10_OBJECTID') > 0) {
		lmapbutton.attr("href", "javascript:showPopUpMap($v('P0_DOC_ID'));");
		lmapbutton2.bind("click", function(){
			showPopUpMap($v('P0_DOC_ID'));
		})
		           .attr("disabled",false);
		
		lmapimage.attr("src", lImageBase+"images/globe_64.gif").attr("title", "Show on map");				         
	}
	else {			
		lmapimage.attr("src", lImageBase+"images/grey_globe.png").attr("title", "No Location for enquiry");
		lmapbutton2.attr("disabled",true);
	}
	lmapimage.attr("width",  lwidth)
	         .attr("height", lheight);


    if ($v('P0_HAS_DOC') > 0){
		ldocbutton.attr("href", "javascript:showDocAssocsWT($v('P0_DOC_ID'),$v('pFlowId'),$v('pInstance'),'DOCS2VIEW');");
		ldocbutton2.bind("click", function(){
			showDocAssocsWT($v('P0_DOC_ID'),$v('pFlowId'),$v('pInstance'),'DOCS2VIEW');
		})
		           .attr("disabled",false)
		
		ldocimage.attr("src", lImageBase+"images/mfopen.gif").attr("title", "Show Documents");
	}
	else {
	    ldocimage.attr("src", lImageBase+"images/mfclosed.gif").attr("title", "No Documents");	
		ldocbutton2.attr("disabled",true);
	}
	ldocimage.attr("width",  lwidth)
	         .attr("height", lheight);

	
	lsavebutton2.bind("click", function(){
         update_enquiry();
	});		
	lsaveimage.attr("src", lImageBase+"enqwt/disk_32.gif").attr("title", "Save Changes")
	          .attr("width",  lwidth)
	          .attr("height", lheight);
	
	lcancelbutton.attr("href", "javascript:doSubmit('CANCEL');");		
	lcancelbutton2.bind("click", function(){
        $('#P0_RETURN_TO_PAGE').val($('#P0_RTRN_TO_PAGE_TMP').val()); 
		doSubmit('CANCEL');
	});
	lcancelimage.attr("src", lImageBase+"images/red_square.png").attr("title", "Cancel")
	            .attr("width",  lwidth)
	            .attr("height", lheight);

    var get = new
    htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=allowRaiseDefects',0);
   
    gReturn = get.get();
    get = null;
    	
	if (gReturn === 'Y') {
		ldefbutton.attr("href", "");
		ldefbutton2.bind("click", function(){
			showRaiseDefect();
		}).attr("disabled", false);
	}
	else {
		ldefbutton2.attr("disabled", true);
	}

	ldefimage.attr("src", lImageBase+"enqwt/24builda.gif").attr("title", "Raise Defect")
	            .attr("width",  lwidth)
	            .attr("height", lheight);

});


/*
function populateRseUnique(pRseUnique)
{
    
   
   if (pRseUnique.value.length < 2)
   {
      return;
   }
   
   var l_Return     = null;
   var networkArray = new Array(20);
   for (var i=0; i<20; i++)
      networkArray[i] = new Array(2);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateRseUnique',0);
   get.add('G_RSE_UNIQUE',pRseUnique.value.toUpperCase());
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("UNIQUE").length;

      for (var i=0; i<l_Count; i++)
      {
         var l_unique       = gReturn.getElementsByTagName("UNIQUE")[i];
		 var l_descr        = gReturn.getElementsByTagName("DESCR")[i];
         var l_ne_id        = gReturn.getElementsByTagName("NEID")[i];

         networkArray[i][0] = l_unique.getAttribute('value');
         networkArray[i][1] = l_descr.getAttribute('value');
         networkArray[i][2] = l_ne_id.getAttribute('value');         		
      }
   }
   get = null;

   var networkLOVdata     = new YAHOO.widget.DS_JSArray(networkArray);

   var networkInputX     = YAHOO.util.Dom.getX('P10_ROAD');
   var networkInputY     = YAHOO.util.Dom.getY('P10_ROAD');
   networkInputY         = networkInputY + 22;
   var networkLOVlocation = new Array(2);
   networkLOVlocation[0]  = networkInputX;
   networkLOVlocation[1]  = networkInputY;

     YAHOO.util.Dom.setXY('rseuniquecontainer', networkLOVlocation);

   var networkLOV =
      new YAHOO.widget.AutoComplete('P10_ROAD','rseuniquecontainer', networkLOVdata);
   networkLOV.prehighlightClassName = "yui-ac-prehighlight";
   networkLOV.typeAhead = false;
   networkLOV.useShadow = true;
   networkLOV.minQueryLength = 2;
   networkLOV.autoHighlight = false;
   networkLOV.useIFrame = true;
   networkLOV.allowBrowserAutocomplete = false;
   networkLOV.maxResultsDisplayed = 20;
   networkLOV.animHoriz=true;
   networkLOV.animSpeed=0.2;

   networkLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_unique = aResultItem[0]; 
	  var l_descr  = aResultItem[1];
                     
      var aMarkup = ["<div id='rseuniquecontainerLOV'>",
        "<span class=networkLOVunique>",
        l_unique,
        "</span>",
        "<span class=networkLOVdescr>",
        l_descr,
        "</span>",
        "</div>"];
		
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P10_ROAD").value = args[2][0];
      YAHOO.util.Dom.get("P10_ROAD_DESCR").value = args[2][1];
      YAHOO.util.Dom.get("P0_ROAD").value = args[2][0];
      YAHOO.util.Dom.get("P0_ROAD_DESCR").value = args[2][1];
      YAHOO.util.Dom.get("P0_NE_ID").value = args[2][2];      
   }
   networkLOV.itemSelectEvent.subscribe(fnCallback);

   networkLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P10_ROAD').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}
*/
/* function populateRoadDescr(pRoadDescr)
{
   if (pRoadDescr.value.length < 2)
   {
      return;
   }
   var l_Return     = null;
   var networkArray = new Array(20);
   for (var i=0; i<20; i++)
      networkArray[i] = new Array(2);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateRoadDescr',0);
   get.add('G_RSE_UNIQUE',pRoadDescr.value.toUpperCase());
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("DESCR").length;

      for (var i=0; i<l_Count; i++)
      {
         var l_descr        = gReturn.getElementsByTagName("DESCR")[i];
		 var l_unique       = gReturn.getElementsByTagName("UNIQUE")[i];
         var l_ne_id        = gReturn.getElementsByTagName("NEID")[i];
         
         networkArray[i][0] = l_descr.getAttribute('value');
         networkArray[i][1] = l_unique.getAttribute('value');
         networkArray[i][2] = l_ne_id.getAttribute('value');
		
      }
   }
   get = null;

   var networkLOVdata     = new YAHOO.widget.DS_JSArray(networkArray);

   var networkInputX     = YAHOO.util.Dom.getX('P10_ROAD_DESCR');
   var networkInputY     = YAHOO.util.Dom.getY('P10_ROAD_DESCR');
   networkInputY         = networkInputY + 22;
   var networkLOVlocation = new Array(2);
   networkLOVlocation[0]  = networkInputX;
   networkLOVlocation[1]  = networkInputY;

     YAHOO.util.Dom.setXY('rsedescrcontainer', networkLOVlocation);

   var networkLOV =
      new YAHOO.widget.AutoComplete('P10_ROAD_DESCR','rsedescrcontainer', networkLOVdata);
   networkLOV.prehighlightClassName = "yui-ac-prehighlight";
   networkLOV.typeAhead = false;
   networkLOV.useShadow = true;
   networkLOV.minQueryLength = 2;
   networkLOV.autoHighlight = false;
   networkLOV.useIFrame = true;
   networkLOV.allowBrowserAutocomplete = false;
   networkLOV.maxResultsDisplayed = 20;
   networkLOV.animHoriz=true;
   networkLOV.animSpeed=0.2;

   networkLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_descr  = aResultItem[0];
	  var l_unique = aResultItem[1]; 
	  
                     
      var aMarkup = ["<div id='rseuniquecontainerLOV' >",
	    "<span class=networkLOVdescr>",
        l_descr,
        "</span>",
        "<span class=networkLOVunique>",
        l_unique,
        "</span>",        
        "</div>"];
		
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P10_ROAD_DESCR").value = args[2][0];
      YAHOO.util.Dom.get("P10_ROAD").value = args[2][1];
      YAHOO.util.Dom.get("P0_ROAD_DESCR").value = args[2][0];
      YAHOO.util.Dom.get("P0_ROAD").value = args[2][1];
      YAHOO.util.Dom.get("P0_NE_ID").value = args[2][2];      
   }
   networkLOV.itemSelectEvent.subscribe(fnCallback);

   networkLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P10_ROAD_DESCR').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}
*/

   function is_valid_numeric_char(pThis,pErrMsg){
      var rtrn = false;
	 
      var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                                  'APPLICATION_PROCESS=is_valid_numeric_char',0); 	  	 
	  get.add('FIELD_VALUE',pThis.val());
	  gReturn = get.get();
      get = null;
	 
	  if (gReturn === 'Y'){
	  	rtrn = true;}
      else {
          pErrMsg.addClass('ui-state-highlight')
           .text('Only numeric characters allowed')
           .show();
           pThis.addClass('ui-state-highlight');
      }  
	  return rtrn;
   }

   function createDefectNow()
   {
    var errMsg =  $('#rdContent').contents().find('#Errormsg');    
    var defPriority = $('#rdContent').contents().find('.f35_checkbox:checked');
	var defTreatment   = $('#rdContent').contents().find('.f45_checkbox:checked');
   	var sChain =  $('#rdContent').contents().find('#P30_START_CHAINAGE'); 
    var eChain =  $('#rdContent').contents().find('#P30_END_CHAINAGE');
    var inspBy =  $('#rdContent').contents().find('#P30_INSPECTED_BY');
    var inspDate =  $('#rdContent').contents().find('#P30_INSP_DATE');
    var inspTime =  $('#rdContent').contents().find('#P30_INSP_TIME');
    var chainage =  $('#rdContent').contents().find('#P30_CHAINAGE');
    var xsect    =  $('#rdContent').contents().find('#P30_X_SECT_POSITION');    
	
    var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
	                     'APPLICATION_PROCESS=create_defect',0); 	  	 
    get.add('DEFPRIORITY',defPriority.val());
    get.add('SCHAIN',sChain.val());
    get.add('ECHAIN',eChain.val());
    get.add('INSPBY',inspBy.val());
    get.add('INSPDATE',inspDate.val());
    get.add('INSPTIME',inspTime.val());
    get.add('CHAINAGE',chainage.val());
    get.add('XSECT',xsect.val());
    if (defTreatment) {
    get.add('DEFTREATMENT',defTreatment.val());
   }
	var gReturn = get.get();
    get = null;
    
    alert('Defect ' + gReturn+ ' created.');
    $("#raisedefect").dialog('close')	;	
   }

$(document).ready(function() {
	var page = $v('pFlowStepId');
    
	
	if ( page != 30){
		return;
	}
    
    var errMsg =  $('#rdContent').contents().find('#Errormsg');  
    
	$("#P30_INSP_TIME").timeEntry({
		show24Hours: true,
		//spinnerImage: '/im4_framework/jquery/css/ui-lightness/images/spinnerUpDown.png'
		spinnerImage: '/im4_framework/jquery/css/ui-lightness/images/spinnerDefault.png'
	});
	
	var cbox = $('.f35_checkbox');
	cbox.bind("click", function(){
		cbox.attr('checked',false);
		$(this).attr('checked',true);
	});

	var xbox = $('.f45_checkbox');
	xbox.bind("click", function(){
		xbox.attr('checked',false);
		$(this).attr('checked',true);
	});
  
    
    $('#Errormsg').hide();
	return;	
});	  

$(document).ready(function() {
	var page = $v('pFlowStepId');    
	
	if ( page != 1){
		return;
	} 
//    var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
//                                  'APPLICATION_PROCESS=getHusUserId',0); 	  	 
//    gReturn = get.get();
//    get = null;
    //$s('P1_LOV',gReturn);
	
    var $P0_RADIO_IP = $('#P0_RADIO_IP');
    var $P1_RADIO_IP = $('#P1_RADIO_IP');
	
    if ($P0_RADIO_IP.val() === 'USER'){
        $('#P1_RADIO_IP_1').attr('checked',true);
    }
    else {
        $('#P1_RADIO_IP_0').attr('checked',true);
    }        
    $P1_RADIO_IP.val($('#P0_RADIO_IP').val());
    
    get_select_list($('#P0_RADIO_IP').val(), 'P1_LOV');
    
    $('#P1_LOV').val($('#P0_LOV').val());   
    
    $P1_GO_EDIT = $('#P1_GO_EDIT');
    
    $('#P1_ENQUIRY_ID')
            .addClass('exorgreyText')
            .val('Enter a valid Enquiry ID')
             .bind('focus', function() {                
                         	$('#P1_ENQUIRY_ID').val('')
    						 	.removeClass('exorgreyText')
    						 	.addClass('exorBlackText');
						 });
    $P1_GO_EDIT.bind("click", function(){
		var $p1_enquiry_id = $('#P1_ENQUIRY_ID');
        if ($p1_enquiry_id.val() !== ''){
         var get = new  htmldb_Get(null,html_GetElement('pFlowId').value,
                                  'APPLICATION_PROCESS=checkDocID',0); 
         get.add('FIELD_VALUE',$p1_enquiry_id.val());  	 
         var gReturn = get.get();
         get = null;
         if (gReturn === 'OK'){                         
             $('#P0_DOC_ID').val('');
             window.location='f?p=' + $v('pFlowId') + ':'+'10'+':' + $v('pInstance')+ '::::' + 'P10_DOC_ID:'+$p1_enquiry_id.val() ;
         }    
         else {
             $('#P1_ENQUIRY_ID').val('Enter a valid Enquiry ID')
    						 	.addClass('exorgreyText')
    						 	.removeClass('exorBlackText');
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

$(document).ready(function() {
	var page = $v('pFlowStepId');   
    if ( page != 12){
		return;
	}  

	$("#P12_DOC_TIME_ARRIVED").timeEntry({
		show24Hours: true,
		//spinnerImage: '/im4_framework/jquery/css/ui-lightness/images/spinnerUpDown.png'
		spinnerImage: '/im4_framework/jquery/css/ui-lightness/images/spinnerDefault.png'
	});
});    


$(document).ready(function() {
   $('.disabledField').attr('disabled', 'disabled');         
}); 

$(document).ready( function() {
    var page = $v('pFlowStepId');   
    if ( page != 10){
        return;
    }  
        $("#P10_ROAD").autocomplete('APEX', {
                apexProcess: 'populateRseUnique',
                width: 400,
                multiple: false,
                matchContains: true,
                cacheLength: 1,
                max: 100,
                delay: 150,
                minChars: 3,
                matchSubset: false
            });
         $("#P10_ROAD").result(function(event, data, formatted) {
        if (data){
		// $("#P10_ROAD").val(data[0]);
            $("#P10_ROAD_DESCR").val(data[1]);
			$("#P0_NE_ID").val(data[2]); 
           }
        });
        $("#P10_ROAD_DESCR").autocomplete('APEX', {
                apexProcess: 'populateRoadDescr',
                width: 400,
                multiple: false,
                matchContains: true,
                cacheLength: 1,
                max: 100,
                delay: 150,
                minChars: 3,
                matchSubset: false
            });
         $("#P10_ROAD_DESCR").result(function(event, data, formatted) {
        if (data){		
		// $("#P10_ROAD").val(data[0]);
            $("#P10_ROAD").val(data[1]);
			$("#P0_NE_ID").val(data[2]); 
           }
        });		
});     

function setCatClassType(){
	$('#P0_CATEGORY').val($('#P10_CATEGORY option:selected').val());
	$('#P0_CLASS').val($('#P10_CLASS option:selected').val());
	$('#P0_TYPE').val($('#P10_TYPE option:selected').val());
}		 

function populate_doc_class_lov(){
	var l_Return = null;
	var l_Select = html_GetElement('P10_CLASS');
	var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=POP_DOC_CLASS_LOV', 0);
	get.add('G_DTP_CODE', $('#P0_CATEGORY').val());
	get.add('G_DCL_CODE', $('#P0_CLASS').val());
	gReturn = get.get('XML');
	//alert(pThis);
	if (gReturn ) {		
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for (var i = 0; i < l_Count; i++) {
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect2(l_Select, l_Opt_Xml.getAttribute('value'), l_Opt_Xml.firstChild.nodeValue,l_Opt_Xml.getAttribute('selected'));
        }
	}
}

function populate_doc_type_lov(){
	var l_Return = null;
	var l_Select = html_GetElement('P10_TYPE');
	var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=POP_DOC_TYPE_LOV', 0);
	get.add('G_DTP_CODE', $('#P0_CATEGORY').val());
	get.add('G_DCL_CODE', $('#P0_CLASS').val());
	get.add('G_DET_CODE', $('#P0_TYPE').val());
	gReturn = get.get('XML');
	if (gReturn ) {		
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for (var i = 0; i < l_Count; i++) {
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];						
            appendToSelect2(l_Select, l_Opt_Xml.getAttribute('value'), l_Opt_Xml.firstChild.nodeValue,l_Opt_Xml.getAttribute('selected'));
        }
	}
}


$(document).ready( function() {
	$('#P10_CATEGORY').change(function(){
		setCatClassType();
		populate_doc_class_lov();
		setCatClassType();
		populate_doc_type_lov();		
	});

	$('#P10_CLASS').change(function(){
		setCatClassType();
		populate_doc_type_lov();		
	});
	
	$('#P10_TYPE').change(function(){
	   setCatClassType();
	});

	populate_doc_class_lov();
	populate_doc_type_lov();
});     
