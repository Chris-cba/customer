/*

-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/javascript/wagtpcmap_130_new.js-arc   3.0   Jun 15 2010 14:52:14   iturnbull  $
--       Module Name      : $Workfile:   wagtpcmap_130_new.js  $
--       Date into PVCS   : $Date:   Jun 15 2010 14:52:14  $
--       Date fetched Out : $Modtime:   Jun 15 2010 14:37:38  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
*/
var mapview;
var themebasedfoi;
var SRID         = null; //262148;
var overviewContainer;
var overviewMap;
var legendContainer;
var mapZoom      = null; //3; 
var featureZoom  = 5;
var zoomType     = 'C';
var tagHtml;

var baseURL  = null; //"http://"+document.location.host+"/mapviewer";
var imageURL = "http://gbexor8cd/i/";
var baseMapString = null; //"wagtpc.wag_basemap_tp2";
var WMSMapString = null; //"wagtpc.wag_wms13";
var baseMap = null;
var WMSMap = null;

var streetWorksFOI = "wagtpc.ENQUIRIES BY STATUS";
var dataSource = "-1" ; //"wagtpc";

var enquiriesTheme = "enquiries_templated";

var copyright = null;
var copyImage = null;
  
function getMapVariables(){
    var paramArray = new Array(100);
    for (var k = 0; k < 100; k++) {
        paramArray[k] = new Array(2);
    }
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getMapVariables', 0);
    gReturn = get.get('XML');
    
    if (gReturn) {
        var l_Count = gReturn.getElementsByTagName("PARAM_NAME").length;
        
        for (var j = 0; j < l_Count; j++) {
            var l_param_name = gReturn.getElementsByTagName("PARAM_NAME")[j];
            var l_param_value = gReturn.getElementsByTagName("PARAM_VALUE")[j];
            
            paramArray[j][0] = l_param_name.getAttribute('value');
            paramArray[j][1] = l_param_value.getAttribute('value');
        }
        if (dataSource == "-1") {
            for (var i = 0; i < l_Count; i++) {
			console.log(paramArray[i][0]);
                if (paramArray[i][0] == "TPCDATASRC") {
                    dataSource = paramArray[i][1];
					
                }
                if (paramArray[i][0] == "IMAGEURL") {
                    imageURL = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCBASEURL") {
                    baseURL = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCBASEMAP") {
                    baseMapString = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCWMSMAP") {
                    WMSMapString = paramArray[i][1];
                }
                if (paramArray[i][0] == "ROADSFOI") {
                    roadsFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "ENQTHEFOI") {
                    EnqTheFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCCPYRGHT") {
                    copyright = paramArray[i][1];
                }
                if (paramArray[i][0] == "STREETSTHE") {
                    streetsTheme = paramArray[i][1];
                }
                if (paramArray[i][0] == "TMATHEFOI") {
                    TmaTheFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCCOPYIMG") {
                    copyImage = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCMAPSRID") {
                    SRID = paramArray[i][1];
                }
                if (paramArray[i][0] == "TPCINIZOOM") {
                    mapZoom = paramArray[i][1];
                }
            }
        }
    }
    get = null;     
}

function initMap(){
    var mapCenterLon = null;
    var mapCenterLat = null;
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getmapcenterxy', 0);
    var gReturn = get.get('XML');
    get = null;
    
    if (gReturn) {
        var l_Count = gReturn.getElementsByTagName("X").length;
        for (var i = 0; i < l_Count; i++) {
            var l_x = gReturn.getElementsByTagName("X")[i];
            mapCenterLon = parseFloat(l_x.getAttribute('value'));
            var l_y = gReturn.getElementsByTagName("Y")[i];
            mapCenterLat = parseFloat(l_y.getAttribute('value'));
        }
    }
    
    getMapVariables();
    
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=GET_USER_TEMP_VALUE', 0);
    get.add('TEMP_TYPE', 'CURRENTZOOM');
    var currentZoom = get.get();
    
    var initialZoom = mapZoom;
    if (currentZoom) {
        mapZoom = currentZoom;
    }
    
    var mpoint = MVSdoGeometry.createPoint(mapCenterLon, mapCenterLat, SRID);
    mapview = new MVMapView(document.getElementById("map"), baseURL);
    
    //   mapview.enableCodingHints(false);
    //MVMapView.enableCodingHints(false);
    if (baseMapString !== null) {
        baseMap = new MVBaseMap(dataSource + '.' + baseMapString);
        mapview.addBaseMapLayer(baseMap);
    }
    
    if (WMSMapString !== null) {
        WMSMap = new MVBaseMap(dataSource + '.' + WMSMapString);
        mapview.addBaseMapLayer(WMSMap);
    }
    //bear_with_jar_on_head.jpg
    //Transport_For_London.png
    //im4_framework/linux_penguin_small.gif
    if (copyImage !== null) {
        var watermark = new MVMapDecoration('<img class="mapCopyImage" src="' + copyImage + '" id="watermark"></img>', 0, 0, 0, 0, 0, 0);
        watermark.setPrintable(true);
        watermark.enableEventPropagation(true);
        mapview.addMapDecoration(watermark);
    }
    
    mapview.setCenter(mpoint);
    mapview.setZoomLevel(mapZoom);
   
    mapview.addCopyRightNote(copyright);
    mapview.setHomeMap(mpoint, initialZoom);
    //mapview.setHomeMap(mpoint, 1);
    mapview.addScaleBar();
    mapview.enableLoadingIcon(true);
    
    addInlineOverview();
    //addLegend();
    
    mapview.addNavigationPanel("EAST");
    
    //mapview.attachEventListener(MVEvent.ZOOM_LEVEL_CHANGE, getCurrentMapState);
    //mapview.attachEventListener(MVEvent.RECENTER, getCurrentMapState);
    
	//addThemeBasedFOI();
}
function getCurrentMapState(bZoom, aZoom){
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=INS_USER_TEMP_VALUES', 0);
    get.add('TEMPVALUE', mapview.getZoomLevel());
    get.add('TEMP_TYPE', 'CURRENTZOOM');
    var gReturn = get.get();
    
    var xyObj = mapview.getCenter();
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=INS_USER_TEMP_VALUES', 0);
    get.add('TEMPVALUE', xyObj.getPointX());
    get.add('TEMP_TYPE', 'POINTX');
    var gReturn = get.get();
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=INS_USER_TEMP_VALUES', 0);
    get.add('TEMPVALUE', xyObj.getPointY());
    get.add('TEMP_TYPE', 'POINTY');
    var gReturn = get.get();
  
}

function showMap(incidentID)
{
   initMap();

   mapview.addNavigationPanel("EAST");  
   zoomToPEM(incidentID);
   mapview.setZoomLevel(mapZoom);
   mapview.display();
}


function addInlineOverview()
{
   overviewContainer = new MVMapDecoration("<font face='Tahoma' size='4'>Overview Map</font>",null,null,200,150) ;
   overviewContainer.setCollapsible(true);
   overviewMap = new MVOverviewMap(overviewContainer.getContainerDiv(),3);
   mapview.addOverviewMap(overviewMap);
   mapview.addMapDecoration(overviewContainer);
}

function zoomToPEM(doc_id)
{
   removeTemplated();

   var xthemebasedfoi = new MVThemeBasedFOI('locator',dataSource+'.'+enquiriesTheme);
   xthemebasedfoi.setQueryParameters(doc_id);
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
   xthemebasedfoi.setBoundingTheme(true);
   mapview.addThemeBasedFOI(xthemebasedfoi);
}

function mapPrint()
{
   var a=document.getElementById("map");
   mapview.print(a);
}

function removeTemplated()
{
   var xthemebasedfoi = mapview.getThemeBasedFOI('locator');
   mapview.removeThemeBasedFOI(xthemebasedfoi);
}

function toggleMarqueeZoom(checked)
{
   if (checked)
      startMarqueeZoom();
   else
      stopMarqueeZoom();
}

function startMarqueeZoom()
{
   mapview.startMarqueeZoom("continuous");
}

function stopMarqueeZoom()
{
   mapview.stopMarqueeZoom();
}

function testjava()
{
   alert("Your call worked");
}

function testjava(myvar)
{
   alert("Your call worked - myvar is");
   alert(myvar);
}

function disable_p0_fields()
{
   document.getElementById('p0_doc_location').readOnly = true;
   document.getElementById('p0_doc_location').style.Color = "lightgray";
//document.getElementById('Aspirin').style.backgroundColor = "gray";
   document.getElementById('p0_doc_road_name').readOnly = true;
//   document.getElementById('p0_doc_location').disabled = true;
//   document.getElementById('p0_doc_road_name').disabled = true;
}