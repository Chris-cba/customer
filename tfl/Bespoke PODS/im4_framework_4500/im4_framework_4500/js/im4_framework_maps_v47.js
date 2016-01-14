/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/im4_framework_4500/im4_framework_4500/js/im4_framework_maps_v47.js-arc   1.0   Jan 14 2016 21:38:06   Sarah.Williams  $
 --       Module Name      : $Workfile:   im4_framework_maps_v47.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 21:38:06  $
 --       Date fetched Out : $Modtime:   Nov 29 2011 19:00:40  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 --	Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
var mapview;
var themebasedfoi;
var SRID = null; //81989;
var overviewContainer;
var overviewMap;
var legendContainer;
var mapZoom = null; //2;
var featureZoom = 5;
var zoomType = 'C';
var tagHtml;

var mapUrl;

var browserName = navigator.appName;

// these values come from product options
var dataSource = "-1"; //"mvdev1024";
var baseURL = null; //"http://192.168.40.159:8888/mapviewer";
var imageURL = null; //"http://exdl9:7777.exorcorp.local/i/";
var baseMapString = null; //"mvdev1024.im4dev_map";
var WMSMapString = null; //"mvdev1024.dorset_wms10";
var copyright = null; //"Copyright (C)2009 Exor Corporation Ltd"
var baseMap = null;
var WMSMap = null;
var copyImage = null;

// these are the themes with a where clause, Templated Themes
// these values come from product options
var TmaTheFOI = null; //"mvdev1024.streetworks_sites_current";
var roadsFOI = null; //"mvdev1024.STREET_TEST";
var EnqTheFOI = null; //"mvdev1024.im_enquiries";
var streetsTheme = null; //"mvdev1024.street_test_templ";
/*
 //These are themes to be dispalyed as backgroud
 var countiesTheme = "mvdev1024.counties_test_templ";
 var townsTheme    = "mvdev1024.towns_test_templ";
 var streetsTheme  = "mvdev1024.street_test_templ";
 var enqsTheme     = null; //"mvdev1024.enquiries";
 var defectsTheme  = null; //"mvdev1024.defects";
 */
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
                if (paramArray[i][0] == "DATASOURCE") {
                    dataSource = paramArray[i][1];
                }
                if (paramArray[i][0] == "IMAGEURL") {
                    imageURL = paramArray[i][1];
                }
                if (paramArray[i][0] == "BASEURL") {
                    baseURL = paramArray[i][1];
                }
                if (paramArray[i][0] == "BASEMAPSTR") {
                    baseMapString = paramArray[i][1];
                }
                if (paramArray[i][0] == "WMSMAPSTR") {
                    WMSMapString = paramArray[i][1];
                }
                if (paramArray[i][0] == "ROADSFOI") {
                    roadsFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "ENQTHEFOI") {
                    EnqTheFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "COPYRIGHT") {
                    copyright = paramArray[i][1];
                }
                if (paramArray[i][0] == "STREETSTHE") {
                    streetsTheme = paramArray[i][1];
                }
                if (paramArray[i][0] == "TMATHEFOI") {
                    TmaTheFOI = paramArray[i][1];
                }
                if (paramArray[i][0] == "COPYIMG") {
                    copyImage = paramArray[i][1];
                }
                if (paramArray[i][0] == "MAPSRID") {
                    SRID = paramArray[i][1];
                }
                if (paramArray[i][0] == "INITZOOM") {
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
    MVMapView.enableCodingHints(false);
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
    addLegend();
    
    mapview.addNavigationPanel("EAST");
    
    mapview.attachEventListener(MVEvent.ZOOM_LEVEL_CHANGE, getCurrentMapState);
    mapview.attachEventListener(MVEvent.RECENTER, getCurrentMapState);
    mapview.attachEventListener(MVEvent.INITIALIZE , getCurrentMapState);
    removeTemplated();    
	addThemeBasedFOI();

}

function showMap(){

    initMap();

    mapview.display();

    //mapview.getMapImageURL(getMapUrl);	
}

function showMapNoDisplay(){
    initMap();
    setMapListener();
}


function setMapQueryType(pType){
    document.getElementById('P0_MAP_QUERY_TYPE').value = pType;
    setSessionValue('P0_MAP_QUERY_TYPE', pType);
}

function executeLatestQuery(){

    var mapQueryType = document.getElementById('P0_MAP_QUERY_TYPE').value;
	
    switch (mapQueryType) {
        case "FINDROADWORKS":
            showMapNoDisplay();
            setStreetTemplated();
            mapview.display();
			//mapview.getMapImageURL(getMapUrl);
            setMapListener();
            break;
        case "FINDENQS":
            showMapNoDisplay();
            
            setEnqsTemplated('P0_ENQ_ID_INPUT');
            mapview.display();
			//mapview.getMapImageURL(getMapUrl);
            setMapListener();
            break;
        case "FINDENQSREP":
            showMapNoDisplay();
            
            setEnqsTemplatedReport('P0_ENQ_ID');
            mapview.display();
			//mapview.getMapImageURL(getMapUrl);
            setMapListener();
            break;
        case "FINDTMA":
            showMapNoDisplay();
            setRoadworksTemplated('P0_TMA_ID');
            mapview.display();
			//mapview.getMapImageURL(getMapUrl);
            setMapListener();
            break;
        case "FINDNETWORK":
            showMapNoDisplay();
            setNetworkTemplated('P4_NE_UNIQUE');			
            mapview.display();			
            setMapListener();
            break;
        default:
		
            showMap();
		
            mapview.display(); 
		
			setMapListener();
    }
	setMapQueryType('');
}

function findEnqsFromReport(doc_id, appID, sessionID){
    /*setMapQueryType("FINDENQSREP");
     //document.getElementById('P0_ENQ_ID').value = doc_id;
     //setSessionValue('P0_ENQ_ID',doc_id);
     //var url = 'f?p=' + appID + ':9:' + sessionID;
     
     
     var params = 'P0_ENQ_ID';
     var values = doc_id;
     var url = 'f?p=' + appID + ':9:' + sessionID + '::::' + params+':'+values;
     
     var win =window.open(url,'map','menubar=no,width=1024,height=768,toolbar=no,scrollbars=yes,resizable=yes,status=no');
     win.focus();
     */
    var params = 'P0_MAP_QUERY_TYPE' + ',' + 'P0_ENQ_ID';
    var values = 'FINDENQSREP,' + doc_id;
    var url = 'f?p=' + appID + ':' + '9' + ':' + sessionID + '::::' + params + ':' + values;
    var win = window.open(url, 'map', 'menubar=no,width=1024,height=768,toolbar=no,scrollbars=yes,resizable=yes,status=no');
    win.focus();
}

function findTMA(pTMAId, appID, sessionID, pPage){
    setMapQueryType("FINDTMA");
    document.getElementById('P0_TMA_ID').value = pTMAId;
    setSessionValue('P0_TMA_ID', pTMAId);
    
    var url = 'f?p=' + appID + ':' + pPage + ':' + sessionID;
    var win = window.open(url, 'map', 'menubar=no,width=1024,height=768,toolbar=no,scrollbars=yes,resizable=yes,status=no');
    win.focus();
}

function addThemeBasedFOI(){
    var l_foi_theme = null;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getFOIThemes', 0);
    gReturn = get.get('XML');
    
    if (gReturn) {
        var l_Count = gReturn.getElementsByTagName("THEME_NAME").length;
        
        for (var i = 0; i < l_Count; i++) {
            var l_theme_name = gReturn.getElementsByTagName("THEME_NAME")[i];
            var l_onoff = gReturn.getElementsByTagName("ONOFF")[i].getAttribute('value');
            var l_min = gReturn.getElementsByTagName("MINVISIBLEZOOMLEVEL")[i].getAttribute('value');
            var l_max = gReturn.getElementsByTagName("MAXVISIBLEZOOMLEVEL")[i].getAttribute('value');
            
            var l_foi_theme = l_theme_name.getAttribute('value');
            
            themebasedfoi = new MVThemeBasedFOI(l_foi_theme, dataSource + '.' + l_foi_theme);
            themebasedfoi.setMinVisibleZoomLevel(l_min);
            themebasedfoi.setMaxVisibleZoomLevel(l_max);
			
            themebasedfoi.setBringToTopOnMouseOver(true);
            themebasedfoi.enableInfoTip(true);
            if (l_onoff === 'ON') {
                themebasedfoi.setVisible(true);
            }
            else {
                themebasedfoi.setVisible(false);
            }
            
            if (l_foi_theme.substr(0, 3) == 'TMA') {
				themebasedfoi.setEventListener("mouse_click", foiTMAClick);
			}
			else {
				themebasedfoi.setEventListener("mouse_click", foiClick);
			}				   
            themebasedfoi.setInfoWindowStyle("MVInfoWindowStyle2");
            mapview.addThemeBasedFOI(themebasedfoi);
        }
    }
    get = null;
	
   // mapview.getMapImageURL(getMapUrl);
	
}


function setVisibleFOI(pThemeName){
    var layer = mapview.getThemeBasedFOI(pThemeName.value);
    
    if (layer.isVisible()) {
        layer.setVisible(false);
    }
    else {
        layer.setVisible(true);
    }
   // mapview.pan(10, 10);
}


function addInlineOverview(){
    var width = $('#map').width();
    var height = $('#map').height() ;
    
    var w = width * 0.1;
    var h = height * 0.2;
    
    var x = (width * 0.11) * -1;
    var y = (height * 0.23) * -1;

    overviewContainer = new MVMapDecoration("<font face='Tahoma' size='4'>Overview Map</font>", null, null, w, h, x, y);
    overviewContainer.setCollapsible(true);
    overviewMap = new MVOverviewMap(overviewContainer.getContainerDiv(), 2);
    overviewContainer.setDraggable(true);
    mapview.addOverviewMap(overviewMap);
    mapview.addMapDecoration(overviewContainer);
}

function addLegend(){
    var legendHTML = buildLegend(baseURL);
    
    var legendContainer = document.getElementById("mapLegendContainer");
    legendContainer.innerHTML = legendHTML;
    
    /* Following code used if legend is inline on map */
    /*
    
     var legendContainer = new MVMapDecoration(legendHTML, 0, 0, 195, 185);
    
     legendContainer.setCollapsible(true);
    
     legendContainer.setVisible(true);
    
     legendContainer.setDraggable(true);
    
     mapview.addMapDecoration(legendContainer); */
    
}

function buildLegend(baseURL){
    var legendHTML = null;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getMapLegend', 0);
    legendHTML = get.get();
    get = null;
    
    return legendHTML;
}

function foiClick(point, foi){
    var aFOI = mapview.getAllFOIs();
    var x = 250;
    var y = 250;
	
	tagHtml = getMediaString(foi);
    mapview.displayInfoWindow(point, tagHtml, x, y, "MVInfoWindowStyle2");
}

function foiTMAClick(point, foi){
	var aFOI = mapview.getAllFOIs();
    var x = 450;
    var y = 300;
    tagHtml = getMediaStringTMA(foi);
    mapview.displayInfoWindow(point, tagHtml, x, y, "MVInfoWindowStyle2");
}

function openDocWindow(url){
    window.open(url);
}

function getMediaString(foi){
    var refID = foi.attrs[0];
	var pThemeName = foi.attrnames[0];
		
    var html;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getMapCallOut', 0);
    get.add('DOC_ID', refID);
	get.add('THEME_NAME',pThemeName);
    html = get.get();
    get = null;
    return html;
}

function getMediaStringNetwork(foi){
    var refID = foi.attrs[0];
    
    var html;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getMapItemNetDetails', 0);
    get.add('DOC_ID', document.getElementById('P0_RSE_UNIQUE').value);
    html = get.get();
    get = null;
    
    return html;
}

function getMediaStringTMA(foi){
    var refID = foi.attrs[0];
    
    var html;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=displayRoadworkDetails', 0);
    get.add('ROAD_REF', refID);
    html = get.get();
    get = null;
    
    return html;
}

function getMediaStringINT(foi){
    var refID = foi.attrs[0];
    
    var html;
    
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=getINTDetails', 0);
    get.add('IIT_NE_ID', refID);
    html = get.get();
    get = null;
    
    return html;
}


function setMapListener(){
    //mapview.setEventListener("mouse_right_click", addNewTag);
}



function mapPrint(){
    var a = document.getElementById("map");
    mapview.print(a);
}

function setStreetTemplated(){
    removeTemplated();
    
    var upperWORRef = null;
    var upperTown = document.getElementById('P0_TOWN').value.toUpperCase();
    var upperStreet = document.getElementById('P0_STREET').value.toUpperCase();
    var upperNSG = document.getElementById('P0_NSG').value.toUpperCase();
    var SEVERE = document.getElementById('P0_IMPACT_SEVERE_VALUE').value.toUpperCase();
    var MODERATE = document.getElementById('P0_IMPACT_MODERATE_VALUE').value.toUpperCase();
    var SLIGHT = document.getElementById('P0_IMPACT_SLIGHT_VALUE').value.toUpperCase();
    var MINIMAL = document.getElementById('P0_IMPACT_MINIMAL_VALUE').value.toUpperCase();
    var fromDate = document.getElementById('P0_FROM_DATE_VALUE').value.toUpperCase();
    var toDate = document.getElementById('P0_TO_DATE_VALUE').value.toUpperCase();
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + streetsTheme);
    
    
    xthemebasedfoi.setQueryParameters(upperWORRef, upperTown, upperStreet, upperNSG, SEVERE, MODERATE, SLIGHT, MINIMAL, fromDate, toDate);
    
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}

function setEnqsTemplated(pEnqId){
    removeTemplated();
    var docID = document.getElementById(pEnqId).value;
    var respOf = document.getElementById('P0_RESP_OF').value;
    var postcode = document.getElementById('P0_POSTCODE').value;
    var surname = document.getElementById('P0_SURNAME').value;
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + EnqTheFOI);
    xthemebasedfoi.setQueryParameters(docID, respOf, postcode, postcode, surname, surname);
    
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}

function setEnqsTemplatedReport(pEnqId){
    removeTemplated();
    var docID = document.getElementById(pEnqId).value;
    var respOf = '';
    var postcode = '';
    var surname = '';
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + EnqTheFOI);
    xthemebasedfoi.setQueryParameters(docID, respOf, postcode, postcode, surname, surname);
    
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}

function setRoadworksTemplated(pTMAId){
    var TMAID = '~';
    var upperTown = '~';
    var upperStreet = '~';
    var upperNSG = '~';
    var SEVERE = '~';
    var MODERATE = '~';
    var SLIGHT = '~';
    var MINIMAL = '~';
    var fromDate = '~';
    var toDate = '~';
    
    removeTemplated();
    
    TMAID = $('#'+pTMAId).val();
    
    
    
    if (!TMAID) {
        TMAID = '~';
    }
    else {
        SEVERE = 'true';
        MODERATE = 'true';
        SLIGHT = 'true';
        MINIMAL = 'true';
    }
 /*   if (TMAID == '~') {
        upperTown = $('#P4_PARAM4').val().toUpperCase();
        if (!upperTown) {
            upperTown = '~';
        }
        
        upperStreet = $('#P4_PARAM5').val().toUpperCase();
        if (!upperStreet) {
            upperStreet = '~';
        }
        upperNSG = $('#P4_PARAM6').val().toUpperCase();
        if (!upperNSG) {
            upperNSG = '~';
        }
        SEVERE = $('#P4_PARAM7').val();
        if (!SEVERE) {
            SEVERE = '~';
        }
        else 
        {SEVERE = 'true'}
        
        MODERATE = $('#P4_PARAM8').val();
        if (!MODERATE) {
            MODERATE = '~';
        }
        else{
           MODERATE = 'true';
        }
        
        SLIGHT = $('#P4_PARAM9').val();
        if (!SLIGHT) {
            SLIGHT = '~';
        }
        else {
           SLIGHT = 'true';
        }
        
        MINIMAL = $('#P4_PARAM10').val();
        if (!MINIMAL) {
            MINIMAL = '~';
        }
        else {
           MINIMAL = 'true';
        }
        fromDate = $('#P4_PARAM2').val().toUpperCase();
        if (!fromDate) {
            fromDate = '~';
        }
        toDate = $('#P4_PARAM3').val().toUpperCase();
        if (!toDate) {
            toDate = '~';
        }
    } */
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + TmaTheFOI);
    
    //alert(dataSource+'.'+TmaTheFOI);
    //alert(TMAID+':'+upperTown+':'+upperStreet+':'+SEVERE+':'+MODERATE+':'+SLIGHT+':'+MINIMAL+':'+fromDate+':'+toDate+':'+upperNSG);
    
    
    xthemebasedfoi.setQueryParameters(TMAID, TMAID, upperTown, upperTown, upperStreet, upperStreet, SEVERE, MODERATE, SLIGHT, MINIMAL, fromDate, fromDate, toDate, toDate, upperNSG, upperNSG);
    
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiTMAClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}





function setNetworkTemplated(pNeUnique){
    removeTemplated();
    
    var layer;
    var neUnique = document.getElementById(pNeUnique).value;
    var get = new htmldb_Get(null, html_GetElement('pFlowId').value, 'APPLICATION_PROCESS=net_or_nsg', 0);
    get.add('NETWORK_NAME', neUnique);
    var gReturn = get.get('XML');
    get = null;
    
    if (gReturn) {
        var l_Count = gReturn.getElementsByTagName("DATA").length;
        for (var i = 0; i < l_Count; i++) {
            var l_layer = gReturn.getElementsByTagName("DATA")[i];
            layer = l_layer.getAttribute('value');
        }
    }
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + layer);
    xthemebasedfoi.setQueryParameters(neUnique,neUnique);
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}

function setTMASiteTemplated(pTMAId){
    removeTemplated();
    var TMAId = document.getElementById(pTMAId).value;
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', tmaSitesThemeFOI);
    xthemebasedfoi.setQueryParameters(TMAId);
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}


function removeTemplated(){
    var xthemebasedfoi = mapview.getThemeBasedFOI('locator');
    mapview.removeThemeBasedFOI(xthemebasedfoi);
}

function togglebaseMap(pChecked){
    if (pChecked.checked) {
        showbaseMap();
    }
    else {
        hidebaseMap();
    }
}

function showbaseMap(){
    baseMap.setVisible(true);
}

function hidebaseMap(){
    baseMap.setVisible(false);
}

function toggleWMS(pChecked){
    if (pChecked.checked) {
        showWMS();
    }
    else {
        hideWMS();
    }
}

function showWMS(){
    WMSMap.setVisible(true);
}

function hideWMS(){
    WMSMap.setVisible(false);
}

function testjava(){
    alert("Your call worked");
}

function testjava(myvar){
    alert("Your call worked - myvar is");
    alert(myvar);
}

function getMapUrl(url){
    mapUrl = url;
}

function callPrintMap(appID, sessionID){
    var pTitle = $('#P0_MAP_TITLE_INPUT').val();
    var pText = $('#P0_MAP_TEXT_INPUT').val();
    
    
    //mapview.getMapImageURL(getMapUrl);
    
    document.getElementById('P0_MAP_URL').value = mapUrl;
    setSessionValue('P0_MAP_URL', mapUrl);
    document.getElementById('P0_MAP_TITLE').value = pTitle;
    setSessionValue('P0_MAP_TITLE', pTitle);
    document.getElementById('P0_MAP_TEXT').value = pText;
    setSessionValue('P0_MAP_TEXT', pText);
    
   
    var url = 'f?p=' + appID + ':0:' + sessionID + ':PRINT_REPORT=Print_Map';
    
    var win = window.open(url, 'PrintMap', 'menubar=no,width=10,height=10,toolbar=no,scrollbars=no,resizable=no,status=no');
    win.focus();
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
    
	//mapview.getMapImageURL(getMapUrl);
}

function showTemplatedTheme(pLayerName, pValue){
    removeTemplated();
    
    
    var xthemebasedfoi = new MVThemeBasedFOI('locator', dataSource + '.' + pLayerName);
    xthemebasedfoi.setQueryParameters(pValue);
    xthemebasedfoi.setBringToTopOnMouseOver(true);
    xthemebasedfoi.enableInfoTip(true);
    xthemebasedfoi.setVisible(true);
    xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
    xthemebasedfoi.setEventListener("mouse_click", foiClick);
    xthemebasedfoi.setBoundingTheme(true);
    mapview.addThemeBasedFOI(xthemebasedfoi);
}



