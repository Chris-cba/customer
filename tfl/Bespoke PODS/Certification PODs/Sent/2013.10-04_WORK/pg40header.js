<link rel="stylesheet" href="/&FRAMEWORK_DIR./jquery/jquery-autocomplete/jquery.autocomplete.css" type="text/css" />
<script language="Javascript" src="/&FRAMEWORK_DIR./jquery/jquery-autocomplete/jquery.autocompleteApex1.1.js"></script>

<style>
label {
   width: 125px;
   display: inline-block;
   text-align: right;
}</style>

<script language="Javascript">

function getLOVs(pLOV,pLOVValue)
{
   var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=P40ApplicationReviewLOV',0);
   get.add('P40LOV',pLOV);
   get.add('P40LOVVALUE',pLOVValue);
   var gReturn = get.get();
   
   return gReturn;
}

function getAppReviewCols(pWorkOrderID)
{
   var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=getAppReviewCols',0);
   get.add('WOID',pWorkOrderID);
   var gReturn = get.get();

   
   return gReturn;
}

function openAttribEditBox(pWOID)
{
// woid 0
//Invoice_Status 1
//invoice_comment 2
//correct_quant 3
//quality_ok 4
//correct_boq 5
//certification_comment 6
//Before After Photos Present 7

   var tmp = getAppReviewCols(pWOID).split('~');

   $('#woid').val(tmp[0]);
   $('#Invoice_Status').empty().append(getLOVs('INVOICE_STATUS',tmp[1]));  
   $('#Invoice_Comment').val(tmp[2]);
   $('#Area_Quantity').empty().append(getLOVs('CORRECT_QUANT',tmp[3]));
   $('#Quality_of_Work').empty().append(getLOVs('QUALITY_OK',tmp[4]));
   $('#Correct_BOQ_Uplifts').empty().append(getLOVs('CORRECT_BOQ',tmp[5]));
   $('#CertificationComment').val(tmp[6]);
   $('#Before_After_Photos_Present').empty().append(getLOVs('PHOTO_PRESENT',tmp[7]));

   $("#attribeditbox").dialog('open');
}

function saveValues()
{
   var values = '';

   values = values + $('#woid').val() + '~';
   values = values + $('#Invoice_Status').val() + '~';
   values = values + $('#Invoice_Comment').val() + '~';
   values = values + $('#Area_Quantity').val() + '~';
   values = values + $('#Quality_of_Work').val() + '~';
   values = values + $('#Correct_BOQ_Uplifts').val() + '~';
   values = values + $('#CertificationComment').val() + '~';
   values = values + $('#Before_After_Photos_Present').val();

   var get = new htmldb_Get(null,$('#pFlowId').val(),'APPLICATION_PROCESS=P40Save',0);
   get.add('P40VALUES',values);
   var gReturn = get.get();

   $("#errorbox").empty().append(gReturn).dialog('open');


}

$(document).ready(function(){
	$("#attribeditbox").dialog({
		bgiframe: true,
		resizable: false,
		modal: true,
		title: 'Edit',
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
			},
			'Save': function(){
                                saveValues();
				$(this).dialog('close');
			}
		}
	});	
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
					$(this).dialog('close');
                                        location.reload();
				}
			}
		});
});
</script>