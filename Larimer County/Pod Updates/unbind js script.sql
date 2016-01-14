// Run the following once the document is ready
$(document).ready(function(){  
  // -- Handle Go Button --
  // Unbind all events. Important for order of execution
  $('input[type="button"][value="Go"]').attr('onclick',''); //unbind click event
  // Rebind events
  //$('input[type="button"][value="Go"]').click(function(){fLogSearch()});
   
  // -- Handle "Enter" in input field --
  $('#apexir_SEARCH').attr('onkeyup',''); //unbind onkeyup event
  // Rebind Events
  $('#apexir_SEARCH').keyup(function(event){($f_Enter(event))null;null;});
  
  javascript:gReport.controls.filter();
 });