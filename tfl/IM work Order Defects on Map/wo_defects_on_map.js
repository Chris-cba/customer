/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/IM work Order Defects on Map/wo_defects_on_map.js-arc   1.1   Jun 25 2012 09:40:28   Ian.Turnbull  $
 --       Module Name      : $Workfile:   wo_defects_on_map.js  $
 --       Date into PVCS   : $Date:   Jun 25 2012 09:40:28  $
 --       Date fetched Out : $Modtime:   Jun 25 2012 09:40:04  $
 --       PVCS Version     : $Revision:   1.1  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
function addTheme(pLayerName, pFeatureID){
   var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + pLayerName);
   xthemebasedfoi.setQueryParameters(pFeatureID);
    
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