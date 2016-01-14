/*-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Fix installs/im4_4500_tfl_fix1/admin/im4_framework/js/im4_gen_search.js-arc   1.0   Jan 14 2016 20:14:08   Sarah.Williams  $
--       Module Name      : $Workfile:   im4_gen_search.js  $
--       Date into PVCS   : $Date:   Jan 14 2016 20:14:08  $
--       Date fetched Out : $Modtime:   Sep 26 2011 22:44:52  $
--       PVCS Version     : $Revision:   1.0  $
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
*/	
var colid = '';			
var searchtext = '' ;
var operator = '';
var joins = '';
var tabid = '';



function getColumns(pi_id){
			var get = new
			htmldb_Get(null,html_GetElement('pFlowId').value,
			          'APPLICATION_PROCESS=getSearchColumnslist',0);
			get.add('AI_ITTS_SEQ',pi_id);
			var gReturn = get.get();
			
			$('#cols').empty().append(gReturn);
			$('#searchCols').empty();
			setDragDrop();

}

function setButtons(state){
	$('#gensearchbutton,#resetbutton,#showSQLbutton,#savebutton').attr("disabled", state);
}

function getValues(){
	   tabid = $('#gensearch').find('input:checked').val();
		colid = '';
		searchtext = '';
		operator = '';
		joins = '';
		$('#searchCols tr td input').each(function(){
        if ($(this).attr('NAME')){
			colid = colid + $(this).attr('NAME')+'~';
		}		
		else {
			searchtext = searchtext + $(this).val()+'~';
		}		
	});
	$('#searchCols tr td select').each(function(){
		if ( $(this).attr('ID')=== 'OPERATORS'){
			operator = operator + $(this).val() + '~';
		}	
		else {
			joins = joins + $(this).val() + '~';
		}		
	});	

	searchtext = searchtext.replace(',',' ');

}

function del_ius(pThis,pQueryName){
	var get = new
			htmldb_Get(null,html_GetElement('pFlowId').value,
			          'APPLICATION_PROCESS=del_ius',0);
		get.add('AI_LOV_NAME', pQueryName);
		var gReturn = get.get();				
		$(pThis).parent("td").parent("tr").remove();		
}

function dispSearchCols(){
		var get = new
			htmldb_Get(null,html_GetElement('pFlowId').value,
			          'APPLICATION_PROCESS=dispsavedsearch',0);
		get.add('AI_LOV_NAME', $('#saved').find('input:checked').val());
		var gReturn = get.get();
		$('#searchCols').empty().append(gReturn);
}

$(document).ready(function() {
	var page = $v('pFlowStepId');    
	
	if (page != 82) {
		return;
	}
	
	var cbox = $('input:checkbox');
	cbox.attr('checked',false);
	cbox.bind("click", function(){
		cbox.attr('checked', false);
		$(this).attr('checked', true);
		dispSearchCols();		
	});
	
	var f82_1 = $('#f82_1').attr('checked',true).val();
	getColumns(f82_1);
	
	dispSearchCols();
			
   $('#gensearchbutton2').bind("click",function(){
   		
      getValues();
   	tabid = $('#tabid').val();
//   	var url = 'f?p=' + $v('pFlowId') + ':' + 81 + ':' + $v('pInstance') + '::::' 
   	        //+ 'P81_QUERY_ID,P81_COLS,P81_OPS,P81_VALS,P81_SEARCH_TYPE,P81_JOINS:' 
//   	        +  tabid + ',' + colid + ',' +operator+ ',' +searchtext+',A,'+joins;
  	var url = 'f?p=' + $v('pFlowId') + ':' + 6 + ':' + $v('pInstance') + '::::' 
   	        + 'P6_MODULE,P6_PARAM1,P6_PARAM2,P6_PARAM3,P6_PARAM4,P6_PARAM5,P6_PARAM6:' 
   	        +  'QUERY,'+tabid + ',' + colid + ',' +operator+ ',' +searchtext+',A,'+joins; 
   	window.location = url;	
   });		
});

$(document).ready(function() {
	var page = $v('pFlowStepId');    

	if (page != 80) {
		return;
	}
	
	var f35_1 = $('#f35_1').attr('checked',true).val();
	getColumns(f35_1);
	
	setButtons(true);
	
	
	$('#showSQLbutton').bind("click", function(){
		getValues();
		var get = new htmldb_Get(null,html_GetElement('pFlowId').value,'APPLICATION_PROCESS=getSearchSQL',0);
		get.add('AI_QUERY_ID', tabid);					  
		get.add('AI_SEARCH_TYPE', 'A');
		get.add('AI_SEARCH_TEXT', 'RE');
		get.add('AI_COLS', colid);
		get.add('AI_OPS', operator);
		get.add('AI_VALS', searchtext); 
		get.add('AI_JOINS', joins);
		var gReturn = get.get();
		get = null;
		$('#P80_SQL_TEXT').val(gReturn);
		$("#sqlviewcontainer").dialog('open');
		//alert(gReturn);
	});
	
	$('#resetbutton').bind("click", function(){
		getColumns($('input:checked').val());
		setButtons(true);
	});
	
	$('#savebutton').bind("click", function(){
		getValues();
		 $('#P80_NAME')
            .addClass('exorgreyText')
            .val('Enter a Name for your search criteria.')
             .bind('focus', function() {                
                         	$('#P80_NAME').val('')
    						 	.removeClass('exorgreyText')
    						 	.addClass('exorBlackText');
						 });
		 $('#P80_ABSTRACT')
            .addClass('exorgreyText')
            .val('Enter a description for you criteria that describes its use.')
             .bind('focus', function() {                
                         	$('#P80_ABSTRACT').val('')
    						 	.removeClass('exorgreyText')
    						 	.addClass('exorBlackText');
						 });
		$("#savecriteriacontainer").dialog('open');
		
	});
	
	var cbox = $('input:checkbox');
	cbox.bind("click", function(){
		cbox.attr('checked', false);
		$(this).attr('checked', true);
		var tabid = $(this).val();
        getColumns(tabid);		
	});
	
	$('#gensearchbutton').bind("click",function(){
        getValues();
//		var url = 'f?p=' + $v('pFlowId') + ':' + 81 + ':' + $v('pInstance') + '::::' 
//		+ 'P81_QUERY_ID,P81_COLS,P81_OPS,P81_VALS,P81_SEARCH_TYPE,P81_JOINS:' 
//		+  tabid + ',' + colid + ',' +operator+ ',' +searchtext+',A,'+joins;
  	var url = 'f?p=' + $v('pFlowId') + ':' + 6 + ':' + $v('pInstance') + '::::' 
   	        + 'P6_MODULE,P6_PARAM1,P6_PARAM2,P6_PARAM3,P6_PARAM4,P6_PARAM5,P6_PARAM6:' 
   	        +  'QUERY,'+tabid + ',' + colid + ',' +operator+ ',' +searchtext+',A,'+joins; 
			window.location = url;	
	});		
	
	
	
});

function setDragDrop(){
	var $gallery = $('#col_list'), $trash = $('#trash');
 
    //$gallery.draggable('destroy');
	 //$trash.droppable('destroy');
	
	// let the gallery items be draggable
	$('li',$gallery).draggable({
		cancel: 'a.ui-icon',// clicking an icon won't initiate dragging
		revert: 'invalid', // when not dropped, the item will revert back to its initial position
		containment: $('#collistcontainer').length ? '#collistcontainer' : 'document', // stick to demo-frame if present
		helper: 'clone',
		cursor: 'move'
	});
	
	$('li',$gallery).bind('dblclick',function(){
		moveToTrash($(this));
	});
	
	// let the trash be droppable, accepting the gallery items
	$trash.droppable({
		accept: '#col_list > li',
		activeClass: 'ui-state-highlight',
		drop: function(event, ui) {
				moveToTrash(ui.draggable);
	          }
	});
}



function moveToTrash($item) {
	var $trash = $('#trash');
	setButtons(false);
	//$item.fadeOut(function() {
		//var $list = $('ul',$trash).length ? $('ul',$trash) : $('<ul class="col_list ui-helper-reset"/>').appendTo($trash);
        var $tab = $('#searchCols');
		
		var get = new
			htmldb_Get(null,html_GetElement('pFlowId').value,
			          'APPLICATION_PROCESS=getOperatorsLOV',0);
		get.add('AI_LOV_NAME', 'OPERATORS');
		var gReturn = get.get();
		
		var newRow = '<tr><td>';
		newRow = newRow + '<input title="'+$item.attr("TITLE")+'" name="'+$item.attr("ID")+'" type="text" id="P80_1_'+$item.attr("ID") +'" value="'+$item.attr("TITLE")  +'" maxlength="2000" size="30" name="p_t01" DISABLED></input>' +'</td>';
		newRow = newRow + '<td>'+gReturn+'</td>';
		newRow = newRow + '<td><input type="text" id="P81_'+$item.attr("ID") +'" value="" maxlength="2000" size="30" ></input></td>';
		var get = new
			htmldb_Get(null,html_GetElement('pFlowId').value,
			          'APPLICATION_PROCESS=getOperatorsLOV',0);
		get.add('AI_LOV_NAME', 'JOINS');
							  
		var gReturn = get.get();
		
		newRow = newRow + '<td>'+gReturn+'</td>';
		
		
		newRow = newRow + '<td>'+'<img style="cursor:pointer;" onclick="html_RowDown(this)"src="/i/arrow_down_gray_dark.gif" /><img style="cursor:pointer;" onclick="html_RowUp(this)"src="/i/arrow_up_gray_dark.gif" /></td>';
		
		newRow = newRow + '</tr>';
	   
		$tab.append(newRow).fadeIn();
		
		//$item.find('a.ui-icon-trash').remove();
		//$item.appendTo($list).fadeIn(function() {
		//	$item.animate({ width: '96px' }).find('img').animate({ height: '36px' });						
		//});
	//});
}


function html_HideBasedOnCheckBox(pThis,pThat){
    if(pThis.checked == true){
        html_HideCellColumn(pThat);
    }else{
        html_ShowCellColumn(pThat);        
    }
}

function html_HideCellColumn(pId){
 var l_Cell = html_GetElement(pId);
 var l_Table =  html_CascadeUpTill(l_Cell,'TABLE');
 var l_Rows = l_Table.rows;
 for (var i=0;i<l_Rows.length;i++){
     html_HideElement(l_Rows[i].cells[l_Cell.cellIndex]);
     }
 return;
}

function html_ShowCellColumn(pId){
 var l_Cell = html_GetElement(pId);
 var l_Table =  html_CascadeUpTill(l_Cell,'TABLE');
 var l_Rows = l_Table.rows;
 for (var i=0;i<l_Rows.length;i++){
     html_ShowElement(l_Rows[i].cells[l_Cell.cellIndex]);
     }
 return;
}

function html_ToogleCellColumn(pId){
 var l_Cell = html_GetElement(pId);
 var l_Table =  html_CascadeUpTill(l_Cell,'TABLE');
 var l_Rows = l_Table.rows;
 for (var i=0;i<l_Rows.length;i++){
     html_ToggleElement(l_Rows[i].cells[l_Cell.cellIndex]);
	 }
 return;
}




$(document).ready(function(){
		$("#sqlviewcontainer").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			title: 'SQL',
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
				}
			}
		});
	});
$(document).ready(function(){
		$("#savecriteriacontainer").dialog({
			bgiframe: true,
			resizable: true,
			modal: true,
			title: 'Save Query Deatils',
			autoOpen: false,
			hide: 'blind',
			show: 'blind',
			width:560,
			height:240,
			zindex: 400,
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				'Save': function(){		
				    var $p80_name = $('#P80_NAME');
					var $p80_abstract = $('#P80_ABSTRACT');
					var ok = true;
					
					ok = ok && ($p80_name.val().length > 0) && ($p80_abstract.val().length > 0) ;
					ok = ok && $p80_name.hasClass('exorBlackText') && $p80_abstract.hasClass('exorBlackText'); 
					
					if (ok) {
						doSaveCriteria();
						$(this).dialog('close');
					}
					else{
						$p80_name.addClass('exorgreyText')
			            .val('Enter a Name for your search criteria.')
			             .bind('focus', function() {                
			                         	$(this).val('')
			    						 	.removeClass('exorgreyText')
			    						 	.addClass('exorBlackText');
									 });
						 $p80_abstract
				            .addClass('exorgreyText')
				            .val('Enter a description for you criteria that describes its use.')
				             .bind('focus', function() {                
				                         	$(this).val('')
				    						 	.removeClass('exorgreyText')
				    						 	.addClass('exorBlackText');
										 });
					}
				},
				'Cancel': function(){
					$(this).dialog('close');
				}
			}
		});
	});

function doSaveCriteria(){
	getValues();
	var get = new htmldb_Get(null,html_GetElement('pFlowId').value,'APPLICATION_PROCESS=savesearchcriteria',0);
	get.add('AI_QUERY_ID', tabid);					  
	get.add('AI_COLS', colid);
	get.add('AI_OPS', operator);
	get.add('AI_VALS', searchtext); 
	get.add('AI_JOINS', joins);
	get.add('AI_QUERY_NAME',$('#P80_NAME').val());
	get.add('AI_ABSTRACT',$('#P80_ABSTRACT').val());
	var gReturn = get.get();
	get = null;
	return;
}
