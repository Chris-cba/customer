/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/IM work Order Defects on Map/wo_defects_on_map.js-arc   1.2   Jun 26 2012 10:59:14   Ian.Turnbull  $
 --       Module Name      : $Workfile:   wo_defects_on_map.js  $
 --       Date into PVCS   : $Date:   Jun 26 2012 10:59:14  $
 --       Date fetched Out : $Modtime:   Jun 26 2012 10:58:46  $
 --       PVCS Version     : $Revision:   1.2  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
function addTheme(pLayerName, pFeatureID){
   var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + pLayerName);
   if (pLayerName == 'IM_WORK_ORDER_LINES'){
    xthemebasedfoi.setQueryParameters( pFeatureID, pFeatureID, pFeatureID );
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