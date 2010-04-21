var mapview;
var themebasedfoi;
var SRID         = 262148;
var overviewContainer;
var overviewMap;
var legendContainer;
var mapZoom      = 8; 
var featureZoom  = 5;
var zoomType     = 'C';
var tagHtml;

var baseURL  = "http://"+document.location.host+"/mapviewer";
var imageURL = "http://gbexor8cd/i/";
var baseMapString = "wag.wag_basemap_tp1";
var WMSMapString = "wag.wag_wms13";
var baseMap = null;
var WMSMap = null;

var streetWorksFOI = "wag.ENQUIRIES BY STATUS";
var dataSource = "wag";

//var enquiriesTheme = "wag.enquiries_templated";
var enquiriesTheme = "wag.ENQUIRIES BY STATUS";
  
function showMap(xpos, ypos)
{
   var mpoint = MVSdoGeometry.createPoint(parseFloat(xpos),parseFloat(ypos),SRID);
   mapview = new MVMapView(document.getElementById("map"), baseURL);

   baseMap = new MVBaseMap(baseMapString);
   WMSMap  = new MVBaseMap(WMSMapString);
   mapview.addBaseMapLayer(WMSMap);
 //  mapview.addBaseMapLayer(baseMap);

   mapview.setCenter(mpoint);   
   mapview.setZoomLevel(mapZoom);

   mapview.addCopyRightNote("Copyright ©2008 Exor Corporation Ltd");
   mapview.setHomeMap(mpoint, 1);
   mapview.addScaleBar();

   addInlineOverview();

   mapview.addNavigationPanel("EAST");  
   mapview.setZoomLevel(mapZoom);

   var centre_mark = MVFOI.createMarkerFOI("1",mpoint,"/i/centre_mark.gif");
   centre_mark.setWidth(50);
   centre_mark.setHeight(50);
   mapview.addFOI(centre_mark);
   PEMbyCAT('PLAN');
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

   var xthemebasedfoi = new MVThemeBasedFOI('locator',enquiriesTheme);
//   xthemebasedfoi.setQueryParameters(doc_id);
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
//   xthemebasedfoi.setBoundingTheme(true);
   mapview.addThemeBasedFOI(xthemebasedfoi);
}

function PEMbyCAT(doc_category)
{
   removeTemplated();

   var xthemebasedfoi = new MVThemeBasedFOI('locator','ENQUIRIES BY CAT TEMPLATED');
   xthemebasedfoi.setQueryParameters(doc_category);
   xthemebasedfoi.setBringToTopOnMouseOver(true);
   xthemebasedfoi.enableInfoTip(true);
   xthemebasedfoi.setVisible(true);
   xthemebasedfoi.setInfoWindowStyle("MVInfoWindowStyle1");
//   xthemebasedfoi.setBoundingTheme(true);
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

