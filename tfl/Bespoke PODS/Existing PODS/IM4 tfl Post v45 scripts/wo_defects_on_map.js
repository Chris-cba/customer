/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/wo_defects_on_map.js-arc   1.0   Jan 14 2016 19:44:42   Sarah.Williams  $
 --       Module Name      : $Workfile:   wo_defects_on_map.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 19:44:42  $
 --       Date fetched Out : $Modtime:   Jun 27 2012 10:15:04  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
function addTheme(pLayerName, pFeatureID){
   var xthemebasedfoi = new MVThemeBasedFOI(pLayerName, dataSource + '.' + pLayerName);
   if (pLayerName == 'IM_WORK_ORDER_LINES'){
    xthemebasedfoi.setQueryParameters( '~', '~', pFeatureID );
   } else {
    xthemebasedfoi.setQueryParameters(pFeatureID);
   } 
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
   xthemebasedfoi.setEventListener("mouse_click", foiClick);
   xthemebasedfoi.setBoundingTheme(true);
   mapview.addThemeBasedFOI(xthemebasedfoi);
}

function showWODefOnMap(pWOID,pWOLID ){
  
   $("#mapholder").dialog('open');
   
   showMapNoDisplay();

   removeTemplated();
       
   addTheme('IM_WORK_ORDER_LINES',pWOID);
   addTheme('IM_WO_DEFECTS',pWOID);

   mapview.display();
   
}