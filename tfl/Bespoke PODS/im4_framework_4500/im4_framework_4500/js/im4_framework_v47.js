/*-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/im4_framework_4500/im4_framework_4500/js/im4_framework_v47.js-arc   1.0   Jan 14 2016 21:38:16   Sarah.Williams  $
--       Module Name      : $Workfile:   im4_framework_v47.js  $
--       Date into PVCS   : $Date:   Jan 14 2016 21:38:16  $
--       Date fetched Out : $Modtime:   Nov 16 2011 20:58:34  $
--       PVCS Version     : $Revision:   1.0  $
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
*/
var EXOR = {};
EXOR.mX;
EXOR.mY;
EXOR.setXY = function(pX, pY){
            mX = pX;
            mY = pY;
        };
EXOR.getX = function() {
            return mX;
        };
EXOR.getY = function() {
            return mY;
        };
        


function callNetworkLOV(pNetwork)
{
   if (pNetwork.value.length < 3)
   {
      return;
   }


   var l_Return     = null;
   var networkArray = new Array[20];
   for (var i=0; i<20; i++)
      networkArray[i] = new Array(3);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateNetworkLOVdata',0);
   get.add('NETWORK_NAME',pNetwork.value);
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("DESCR").length;

      for (var i=0; i<l_Count; i++)
      {
         var l_descr        = gReturn.getElementsByTagName("DESCR")[i];
         var l_unique       = gReturn.getElementsByTagName("UNIQUE")[i];
         var l_group        = gReturn.getElementsByTagName("GROUP")[i];

         networkArray[i][0] = l_descr.getAttribute('value');
         networkArray[i][1] = l_unique.getAttribute('value');
         networkArray[i][2] = l_group.getAttribute('value');
      }
   }
   get = null;

   var networkLOVdata     = new YAHOO.widget.DS_JSArray(networkArray);

   var networkInputX     = YAHOO.util.Dom.getX('P0_NETWORK_INPUT');
   var networkInputY     = YAHOO.util.Dom.getY('P0_NETWORK_INPUT');
   networkInputY         = networkInputY + 22;
   var networkLOVlocation = new Array(2);
   networkLOVlocation[0]  = networkInputX;
   networkLOVlocation[1]  = networkInputY;

   YAHOO.util.Dom.setXY('networkLOVcontainer', networkLOVlocation);

   var networkLOV =
      new YAHOO.widget.AutoComplete('P0_NETWORK_INPUT','networkLOVcontainer', networkLOVdata);
   networkLOV.prehighlightClassName = "yui-ac-prehighlight";
   networkLOV.typeAhead = false;
   networkLOV.useShadow = true;
   networkLOV.minQueryLength = 3;
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
      var l_group  = aResultItem[2];
//          alert(l_descr);
      var aMarkup = ["<div id='networkLOVresult'>",
        "<span class=networkLOVdescr>",
        l_descr,
        "</span>",
        "<span class=networkLOVunique>",
        l_unique,
        "</span>",
        "<span class=networkLOVgroup>",
        l_group,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P0_RSE_DESCR").value = args[2][0];
      YAHOO.util.Dom.get("P0_RSE_UNIQUE").value = args[2][1];
      setSessionValue('P0_RSE_DESCR',args[2][0]);
      setSessionValue('P0_RSE_UNIQUE',args[2][1]);

      YAHOO.util.Dom.get("P0_LOCATION").value = args[2][1];
      setSessionValue('P0_LOCATION',args[2][1]);
   }
   networkLOV.itemSelectEvent.subscribe(fnCallback);

   networkLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_NETWORK_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}

function callTownLOV(pTown)
{
   if (pTown.value.length < 1)
   {
      return;
   }

   var l_Return = null;
   var townArray    = new Array(100);
   for (var i=0; i<100; i++)
      townArray[i] = new Array(2);

   var get      = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateTownLOVdata',0);
   get.add('TOWN_NAME',pTown.value);
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("TOWN").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_town   = gReturn.getElementsByTagName("TOWN")[i];
         var l_county = gReturn.getElementsByTagName("COUNTY")[i];

         townArray[i][0] = l_town.getAttribute('value');
         townArray[i][1] = l_county.getAttribute('value');
      }
   }

   get = null;

   var townLOVdata = new YAHOO.widget.DS_JSArray(townArray);

   var townInputX = YAHOO.util.Dom.getX('P0_TOWN_INPUT');
   var townInputY = YAHOO.util.Dom.getY('P0_TOWN_INPUT');
   townInputY = townInputY + 22;
   var townLOVlocation = new Array(2);
   townLOVlocation[0] = townInputX;
   townLOVlocation[1] = townInputY

   YAHOO.util.Dom.setXY('townLOVcontainer', townLOVlocation);

   var townLOV =
      new YAHOO.widget.AutoComplete('P0_TOWN_INPUT','townLOVcontainer', townLOVdata);

   townLOV.prehighlightClassName = "yui-ac-prehighlight";
   townLOV.typeAhead = false;
   townLOV.useShadow = true;
   townLOV.minQueryLength = 1;
   townLOV.autoHighlight = false;
   townLOV.useIFrame = true;
   townLOV.allowBrowserAutocomplete = false;
   townLOV.maxResultsDisplayed = 20;
   townLOV.animHoriz=true;
   townLOV.animSpeed=0.2;

   townLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_town   = aResultItem[0];
      var l_county = aResultItem[1];

      var aMarkup = ["<div id='townLOVresult'>",
        "<span class=townLOVtown>",
        l_town,
        "</span>",
        "<span class=townLOVcounty>",
        l_county,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P0_TOWN").value = args[2][0];
      YAHOO.util.Dom.get("P0_COUNTY").value = args[2][1];
      setSessionValue('P0_TOWN',args[2][0]);
      setSessionValue('P0_COUNTY',args[2][1]);
      clearStreet();
   }
   townLOV.itemSelectEvent.subscribe(fnCallback);

   townLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_TOWN_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}

function callStreetLOV(pStreet)
{
   if (pStreet.value.length < 1)
   {
      return;
   }

   var l_Return = null;
   var streetArray    = new Array(100);
   for (var i=0; i<100; i++)
      streetArray[i] = new Array(4);

   var get      = new
   htmldb_Get(null, html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateStreetLOVdata', 0);
   get.add('STREET_NAME',pStreet.value);
   var l_current_town = document.getElementById('P0_TOWN_INPUT').value;
   get.add('STREET_TOWN_NAME',l_current_town);

   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("STREET").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_street = gReturn.getElementsByTagName("STREET")[i];
         var l_nsg    = gReturn.getElementsByTagName("NSG")[i];
         var l_town   = gReturn.getElementsByTagName("TOWN")[i];
         var l_county = gReturn.getElementsByTagName("COUNTY")[i];

         streetArray[i][0] = l_street.getAttribute('value');
         streetArray[i][1] = l_nsg.getAttribute('value');
         streetArray[i][2] = l_town.getAttribute('value');
         streetArray[i][3] = l_county.getAttribute('value');
      }
   }
   else
      return;

   get = null;

   var streetLOVdata = new YAHOO.widget.DS_JSArray(streetArray);

   var streetInputX = YAHOO.util.Dom.getX('P0_STREET_INPUT');
   var streetInputY = YAHOO.util.Dom.getY('P0_STREET_INPUT');
   streetInputY = streetInputY + 22;
   var streetLOVlocation = new Array(2);
   streetLOVlocation[0] = streetInputX;
   streetLOVlocation[1] = streetInputY;

   YAHOO.util.Dom.setXY('streetLOVcontainer', streetLOVlocation);

   //document.getElementById("streetLOVcontainer").innerHTML = document.getElementById("emptyDIV").innerHTML;

   streetLOV =   new YAHOO.widget.AutoComplete('P0_STREET_INPUT','streetLOVcontainer', streetLOVdata);

   streetLOV.prehighlightClassName = "yui-ac-prehighlight";
   streetLOV.typeAhead = false;
   streetLOV.useShadow = true;
   streetLOV.minQueryLength = 1;
   streetLOV.autoHighlight = false;
   streetLOV.useIFrame = true;
   streetLOV.allowBrowserAutocomplete = false;
   streetLOV.maxResultsDisplayed = 20;
   streetLOV.animHoriz=true;
   streetLOV.animSpeed=0.2;

   streetLOV.formatResult = function(aResultItem, sQuery) {
      var l_street = aResultItem[0];
      var l_nsg    = aResultItem[1];
      var l_town   = aResultItem[2];
      var l_county = aResultItem[3];
      var aMarkup  = ["<div id='streetLOVresult'>",
        "<span class=streetLOVstreet>",
        l_street,
        "</span>",
        "<span class=streetLOVnsg>",
        l_nsg,
        "</span>",
        "<span class=streetLOVtown>",
        l_town,
        "</span>",
        "<span class=streetLOVcounty>",
        l_county,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P0_STREET").value = args[2][0];
      YAHOO.util.Dom.get("P0_NSG").value = args[2][1];
      setSessionValue('P0_STREET',args[2][0]);
      setSessionValue('P0_NSG',args[2][1]);
   }
   streetLOV.itemSelectEvent.subscribe(fnCallback);

   streetLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_STREET_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}

function callEnqIDLOV(pEnqId)
{
   if (pEnqId.value.length < 3)
   {
      return;
   }

   var l_Return   = null;
   var enqIdArray = new Array(100);
   for (var i=0; i<100; i++)
      enqIdArray[i] = new Array(5);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateEnqIdLOVdata',0);
   get.add('ENQ_ID_NAME',pEnqId.value);
   gReturn = get.get('XML');

   if (gReturn)
   {

      var l_Count = gReturn.getElementsByTagName("ENQUIRY_ID").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_enq_id        = gReturn.getElementsByTagName("ENQUIRY_ID")[i];
         var l_cat           = gReturn.getElementsByTagName("CATEGORY")[i];
         var l_class         = gReturn.getElementsByTagName("CLASS")[i];
         var l_type          = gReturn.getElementsByTagName("TYPE")[i];
         var l_status        = gReturn.getElementsByTagName("STATUS")[i];

         enqIdArray[i][0] = l_enq_id.getAttribute('value');
         enqIdArray[i][1] = l_cat.getAttribute('value');
         enqIdArray[i][2] = l_class.getAttribute('value');
         enqIdArray[i][3] = l_type.getAttribute('value');
         enqIdArray[i][4] = l_status.getAttribute('value');
      }
   }


   get = null;

   var enqIdLOVdata     = new YAHOO.widget.DS_JSArray(enqIdArray);

   var enqidInputX     = YAHOO.util.Dom.getX('P0_ENQ_ID_INPUT');
   var enqidInputY     = YAHOO.util.Dom.getY('P0_ENQ_ID_INPUT');
   enqidInputY         = enqidInputY + 22;
   var enqidLOVlocation = new Array(2);
   enqidLOVlocation[0]  = enqidInputX;
   enqidLOVlocation[1]  = enqidInputY;

   YAHOO.util.Dom.setXY('enqidLOVcontainer', enqidLOVlocation);

   //document.getElementById("enqidLOVcontainer").innerHTML = document.getElementById("emptyDIV").innerHTML;

   var enqidLOV =      new YAHOO.widget.AutoComplete('P0_ENQ_ID_INPUT','enqidLOVcontainer', enqIdLOVdata);

   enqidLOV.prehighlightClassName = "yui-ac-prehighlight";
   enqidLOV.typeAhead = false;
   enqidLOV.useShadow = true;
   enqidLOV.minQueryLength = 3;
   enqidLOV.autoHighlight = false;
   enqidLOV.useIFrame = true;
   enqidLOV.allowBrowserAutocomplete = false;
   enqidLOV.maxResultsDisplayed = 20;
   enqidLOV.animHoriz=true;
   enqidLOV.animSpeed=0.2;

   enqidLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_enqid   = aResultItem[0];
      var l_cat     = aResultItem[1];
      var l_class   = aResultItem[2];
      var l_type    = aResultItem[3];
      var l_status  = aResultItem[4];

      var aMarkup = ["<div id='enqidLOVresult'>",
        "<span class=enquiryLOVenqid>",
        l_enqid,
        "</span>",
        "<span class=enquiryLOVcategory>",
        l_cat,
        "</span>",
        "<span class=enquiryLOVclass>",
        l_class,
        "</span>",
        "<span class=enquiryLOVtype>",
        l_type,
        "</span>",
        "<span class=enquiryLOVstatus>",
        l_status,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P0_ENQ_ID").value = args[1][0];
      setSessionValue('P0_ENQ_ID',args[1][0]);
   }
   enqidLOV.itemSelectEvent.subscribe(fnCallback);

  enqidLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_ENQ_ID_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}


function callSurnameLOV(pSurnameId)
{
   if (pSurnameId.value.length < 2)
   {
      return;
   }

   var l_Return   = null;
   var SurnameArray = new Array(100);
   for (var i=0; i<100; i++)
      SurnameArray[i] = new Array(3);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateSurnameLOVdata',0);
   get.add('SURNAME_NAME',pSurnameId.value);
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("SURNAME").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_surname       = gReturn.getElementsByTagName("SURNAME")[i];
         var l_firstname     = gReturn.getElementsByTagName("FIRSTNAME")[i];
         var l_title         = gReturn.getElementsByTagName("TITLE")[i];

         SurnameArray[i][0] = l_surname.getAttribute('value');
         SurnameArray[i][1] = l_firstname.getAttribute('value');
         SurnameArray[i][2] = l_title.getAttribute('value');
      }
   }


   get = null;

   var surnameLOVdata     = new YAHOO.widget.DS_JSArray(SurnameArray);

   var InputX     = YAHOO.util.Dom.getX('P0_SURNAME_INPUT');
   var InputY     = YAHOO.util.Dom.getY('P0_SURNAME_INPUT');
   InputY         = InputY + 22;
   var LOVlocation = new Array(2);
   LOVlocation[0]  = InputX;
   LOVlocation[1]  = InputY;

   YAHOO.util.Dom.setXY('surnameLOVcontainer', LOVlocation);

   //document.getElementById("surnameLOVcontainer").innerHTML = document.getElementById("emptyDIV").innerHTML;

   var aLOV =      new YAHOO.widget.AutoComplete('P0_SURNAME_INPUT','surnameLOVcontainer', surnameLOVdata);

   aLOV.prehighlightClassName = "yui-ac-prehighlight";
   aLOV.typeAhead = false;
   aLOV.useShadow = true;
   aLOV.minQueryLength = 2;
   aLOV.autoHighlight = false;
   aLOV.useIFrame = true;
   aLOV.allowBrowserAutocomplete = false;
   aLOV.maxResultsDisplayed = 20;
   aLOV.animHoriz=true;
   aLOV.animSpeed=0.2;

   aLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_surname   = aResultItem[0];
      var l_firstname = aResultItem[1];
      var l_title     = aResultItem[2];

      var aMarkup = ["<div id='surnameLOVresult'>",
        "<span class=surnameLOVsurname>",
        l_surname,
        "</span>",
        "<span class=firstnameLOVfirstname>",
        l_firstname,
        "</span>",
        "<span class=titleLOVtitle>",
        l_title,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      //YAHOO.util.Dom.get("P0_SURNAME").value = args[1][0];
      //setSessionValue('P0_SURNAME',args[1][0]);
      YAHOO.util.Dom.get("P0_SURNAME").value = YAHOO.util.Dom.get('P0_SURNAME_INPUT').value;
      setSessionValue('P0_SURNAME',YAHOO.util.Dom.get('P0_SURNAME_INPUT').value);
      
   }
   aLOV.itemSelectEvent.subscribe(fnCallback);

   aLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_SURNAME_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}


function callpostcodeLOV(pItem)
{
   if (pItem.value.length < 1)
   {
      return;
   }

   var l_Return   = null;
   var itemArray = new Array(100);
   for (var i=0; i<100; i++)
      itemArray[i] = new Array(1);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populatePostcodeLOVdata',0);
   get.add('POSTCODE_NAME',pItem.value);
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("POSTCODE").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_item1       = gReturn.getElementsByTagName("POSTCODE")[i];

         itemArray[i][0] = l_item1.getAttribute('value');
      }
   }

   get = null;

   var LOVdata     = new YAHOO.widget.DS_JSArray(itemArray);

   var InputX     = YAHOO.util.Dom.getX('P0_POSTCODE_INPUT');
   var InputY     = YAHOO.util.Dom.getY('P0_POSTCODE_INPUT');
   InputY         = InputY + 22;
   var LOVlocation = new Array(2);
   LOVlocation[0]  = InputX;
   LOVlocation[1]  = InputY;

   YAHOO.util.Dom.setXY('postcodeLOVcontainer', LOVlocation);

   //document.getElementById("surnameLOVcontainer").innerHTML = document.getElementById("emptyDIV").innerHTML;

   var aLOV =      new YAHOO.widget.AutoComplete('P0_POSTCODE_INPUT','postcodeLOVcontainer', LOVdata);

   aLOV.prehighlightClassName = "yui-ac-prehighlight";
   aLOV.typeAhead = false;
   aLOV.useShadow = true;
   aLOV.minQueryLength = 1;
   aLOV.autoHighlight = false;
   aLOV.useIFrame = true;
   aLOV.allowBrowserAutocomplete = false;
   aLOV.maxResultsDisplayed = 20;
   aLOV.animHoriz=true;
   aLOV.animSpeed=0.2;

   aLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_item1   = aResultItem[0];

      var aMarkup = ["<div id='postcodeLOVresult'>",
        "<span class=postcodeLOVpostcode>",
        l_item1,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("PO_POSTCODE").value = YAHOO.util.Dom.get('PO_POSTCODE_INPUT').value;
      setSessionValue('PO_POSTCODE',YAHOO.util.Dom.get('PO_POSTCODE_INPUT').value);
   }
   aLOV.itemSelectEvent.subscribe(fnCallback);

   aLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('PO_POSTCODE_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}

function callRespOfLOV(pItem)
{
   if (pItem.value.length < 1)
   {
      return;
   }

   var l_Return   = null;
   var itemArray = new Array(100);
   for (var i=0; i<100; i++)
      itemArray[i] = new Array(2);

   var get = new
   htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=populateRespOfLOVdata',0);
   get.add('RESP_OF_NAME',pItem.value);
   gReturn = get.get('XML');

   if (gReturn)
   {
      var l_Count = gReturn.getElementsByTagName("RESPOF").length;
      for (var i=0; i<l_Count; i++)
      {
         var l_item1       = gReturn.getElementsByTagName("RESPOF")[i];
         var l_item2       = gReturn.getElementsByTagName("USERID")[i];

         itemArray[i][0] = l_item1.getAttribute('value');
         itemArray[i][1] = l_item2.getAttribute('value');
      }
   }

   get = null;

   var LOVdata     = new YAHOO.widget.DS_JSArray(itemArray);

   var InputX     = YAHOO.util.Dom.getX('P0_RESP_OF_INPUT');
   var InputY     = YAHOO.util.Dom.getY('P0_RESP_OF_INPUT');
   InputY         = InputY + 22;
   var LOVlocation = new Array(2);
   LOVlocation[0]  = InputX;
   LOVlocation[1]  = InputY;

   YAHOO.util.Dom.setXY('resp_ofLOVcontainer', LOVlocation);

   //document.getElementById("surnameLOVcontainer").innerHTML = document.getElementById("emptyDIV").innerHTML;

   var aLOV =      new YAHOO.widget.AutoComplete('P0_RESP_OF_INPUT','resp_ofLOVcontainer', LOVdata);

   aLOV.prehighlightClassName = "yui-ac-prehighlight";
   aLOV.typeAhead = false;
   aLOV.useShadow = true;
   aLOV.minQueryLength = 1;
   aLOV.autoHighlight = false;
   aLOV.useIFrame = true;
   aLOV.allowBrowserAutocomplete = false;
   aLOV.maxResultsDisplayed = 20;
   aLOV.animHoriz=true;
   aLOV.animSpeed=0.2;

   aLOV.formatResult = function(aResultItem, sQuery)
   {
      var l_item1   = aResultItem[0];

      var aMarkup = ["<div id='resp_ofLOVresult'>",
        "<span class=resp_ofLOVresp_of>",
        l_item1,
        "</span>",
        "</div>"];
      return (aMarkup.join(""));
   };

   function fnCallback(e, args)
   {
      YAHOO.util.Dom.get("P0_RESP_OF").value = args[2][0];
      setSessionValue('P0_RESP_OF',args[2][0]);
      YAHOO.util.Dom.get("P0_USERID").value = args[2][1];
      setSessionValue('P0_USERID',args[2][1]);

   }
   aLOV.itemSelectEvent.subscribe(fnCallback);

   aLOV.textboxFocusEvent.subscribe(function()
   {
      var sInputValue = YAHOO.util.Dom.get('P0_RESP_OF_INPUT').value;
      if(sInputValue.length === 0)
      {
         var oSelf = this;
         setTimeout(function(){oSelf.sendQuery(sInputValue);},0);
      }
   });
}


function setSessionValue(pItem, pValue)
{         
   var get = new htmldb_Get(null,html_GetElement('pFlowId').value,null,0);
   get.add(pItem, pValue);
   get.get();
   get = null;  
}

function syncRoad()
{
   YAHOO.util.Dom.get("P0_NETWORK_INPUT").value = YAHOO.util.Dom.get("P0_RSE_DESCR").value;
}

function syncTown()
{
   YAHOO.util.Dom.get("P0_TOWN_INPUT").value = YAHOO.util.Dom.get("P0_TOWN").value;
}

function syncStreet()
{
   YAHOO.util.Dom.get("P0_STREET_INPUT").value = YAHOO.util.Dom.get("P0_STREET").value;
}

function clearTown()
{
   YAHOO.util.Dom.get("P0_TOWN_INPUT").value =  '';
   setSessionValue('P0_TOWN_INPUT','');
   YAHOO.util.Dom.get("P0_TOWN").value =  '';
   setSessionValue('P0_TOWN','');
   YAHOO.util.Dom.get("P0_COUNTY").value =  '';
   setSessionValue('P0_COUNTY','');
}

function clearStreet()
{
   YAHOO.util.Dom.get("P0_STREET_INPUT").value =  '';
   setSessionValue('P0_STREET_INPUT','');
   YAHOO.util.Dom.get("P0_NSG").value =  '';
   setSessionValue('P0_NSG','');
   YAHOO.util.Dom.get("P0_STREET").value =  '';
   setSessionValue('P0_STREET','');    
   
   
   YAHOO.util.Dom.get("P0_WORK_REF").value =  '';
   setSessionValue('P0_WORK_REF','');    
}

function clearDates()
{
   YAHOO.util.Dom.get("P0_FROM_DATE").value =  '';
   setSessionValue('P0_FROM_DATE','');
   YAHOO.util.Dom.get("P0_TO_DATE").value =  '';
   setSessionValue('P0_TO_DATE','');
   YAHOO.util.Dom.get("P0_TO_DATE").value =  '';
   setSessionValue('P0_TO_DATE','');
}

function clearRoad()
{
   YAHOO.util.Dom.get("P0_NETWORK_INPUT").value = '';
   YAHOO.util.Dom.get("P0_RSE_DESCR").value = '';
   YAHOO.util.Dom.get("P0_RSE_UNIQUE").value = '';
   YAHOO.util.Dom.get("P0_LOCATION").value = '';
   setSessionValue('P0_RSE_DESCR',null);
   setSessionValue('P0_RSE_UNIQUE',null);
   setSessionValue('P0_LOCATION',null);   
}

function clearDisruption()
{
   YAHOO.util.Dom.get("P0_IMPACT_MINIMAL_VALUE").value = 'true';
   YAHOO.util.Dom.get("P0_IMPACT_MINIMAL_0").checked = true;
   
   YAHOO.util.Dom.get("P0_IMPACT_SLIGHT_VALUE").value = 'true';
   YAHOO.util.Dom.get("P0_IMPACT_SLIGHT_0").checked = true;
   
   YAHOO.util.Dom.get("P0_IMPACT_MODERATE_VALUE").value = 'true';
   YAHOO.util.Dom.get("P0_IMPACT_MODERATE_0").checked = true;
   

   YAHOO.util.Dom.get("P0_IMPACT_SEVERE_VALUE").value = 'true';
   YAHOO.util.Dom.get("P0_IMPACT_SEVERE_0").checked = true;
}


function clearEnq()
{
   YAHOO.util.Dom.get("P0_ENQ_ID").value = '';
   YAHOO.util.Dom.get("P0_ENQ_ID_INPUT").value = '';
   YAHOO.util.Dom.get("P0_SURNAME").value = '';
   YAHOO.util.Dom.get("P0_SURNAME_INPUT").value = '';
   YAHOO.util.Dom.get("P0_POSTCODE").value = '';
   YAHOO.util.Dom.get("P0_POSTCODE_INPUT").value = '';
   YAHOO.util.Dom.get("P0_RESP_OF").value = '';
   YAHOO.util.Dom.get("P0_RESP_OF_INPUT").value = '';
   YAHOO.util.Dom.get("P0_USERID").value = '';
   YAHOO.util.Dom.get("P0_DOC_DESCR").value = '';
   
}

function clearEnqID()
{
   YAHOO.util.Dom.get("P0_ENQ_ID").value = '';
   YAHOO.util.Dom.get("P0_ENQ_ID_INPUT").value = '';
   setSessionValue('P0_ENQ_ID',null);
   setSessionValue('P0_ENQ_ID_INPUT',null);
}

function clearEnqText()
{
   YAHOO.util.Dom.get("P0_SURNAME").value = '';
   YAHOO.util.Dom.get("P0_SURNAME_INPUT").value = '';
   YAHOO.util.Dom.get("P0_POSTCODE").value = '';
   YAHOO.util.Dom.get("P0_POSTCODE_INPUT").value = '';
   YAHOO.util.Dom.get("P0_RESP_OF").value = '';
   YAHOO.util.Dom.get("P0_RESP_OF_INPUT").value = '';
   YAHOO.util.Dom.get("P0_USERID").value = '';
   YAHOO.util.Dom.get("P0_DOC_DESCR").value = '';
   setSessionValue('P0_SURNAME',null);
   setSessionValue('P0_SURNAME_INPUT',null);
   setSessionValue('P0_POSTCODE',null);
   setSessionValue('P0_POSTCODE_INPUT',null);
   setSessionValue('P0_RESP_OF',null);
   setSessionValue('P0_RESP_OF_INPUT',null);
   setSessionValue('P0_USERID',null);
   setSessionValue('P0_DOC_DESCR',null);
}

function showEnqDetails(docID,appID,sessionID)
{
 //  document.getElementById('P0_ENQ_ID').value = docID;
 //  document.getElementById('P0_ENQ_ID_INPUT').value = docID;
   
   setSessionValue('P0_ENQ_ID',docID);
   setSessionValue('P0_ENQ_ID_INPUT',docID);

var get = new htmldb_Get(null,$x('pFlowId').value,null,20);
get.add('P20_ENQ_ID',docID);
gReturn = get.get();
get = null; 
   
   var url = 'f?p=' + appID + ':20:' + sessionID;
   var win =window.open(url,'enqDetails','menubar=no,width=1024,height=768,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   win.focus();
}

function showDocAssocs(docID,appID,sessionID)
{
   document.getElementById('P0_ENQ_ID').value = docID;
   setSessionValue('P0_ENQ_ID',docID);
   var url = 'f?p=' + appID + ':7:' + sessionID;
   var win =window.open(url,'docAssocs','menubar=no,width=1024,height=550,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   win.focus();
}

function showDocAssocsWT(docID,appID,sessionID,dasTableName)
{
   //document.getElementById('P7_ENQ_ID').value = docID;
   setSessionValue('P7_ENQ_ID',docID);
   setSessionValue('P7_DAS_TABLE_NAME',dasTableName);
   var url = 'f?p=' + appID + ':7:' + sessionID;
   
//   var win =window.open(url,'docAssocs','menubar=no,width=1024,height=550,toolbar=no,scrollbars=yes,resizable=yes,status=no');
//   win.focus();
   
    $("#daContent").attr("src",url);  
    $("#docAss").dialog('option', 'title' , 'Associated documents for : '+docID);    
    $("#docAss").dialog('open');

   
}

function setCheckbox(pThis,pThat){
    
   if ( pThis.value != 'false')
   { 
      pThis.value = 'false';
      document.getElementById(pThat).value = 'false';
      document.getElementById(pThat).checked = 'false';
   }
   else
   {
      pThis.value = 'true';
      document.getElementById(pThat).value = 'true';
      document.getElementById(pThat).checked = 'true';
   }       
 
}

function showRoadworks(appID,sessionID,pageID)
{
var   workRef  = document.getElementById('P0_WORK_REF').value.toUpperCase();
var   fromDate = document.getElementById('P0_FROM_DATE').value;
var   toDate   = document.getElementById('P0_TO_DATE').value;
var   town     = document.getElementById('P0_TOWN').value;
var   street   = document.getElementById('P0_STREET').value;
var   usrn     = document.getElementById('P0_NSG').value;
var   impactMin  = document.getElementById('P0_IMPACT_MINIMAL_VALUE').value;
var   impactSlight = document.getElementById('P0_IMPACT_SLIGHT_VALUE').value;
var   impactModerate = document.getElementById('P0_IMPACT_MODERATE_VALUE').value;
var   impactSevere = document.getElementById('P0_IMPACT_SEVERE_VALUE').value;


var values = workRef +','+fromDate + ','+toDate+','+town+','+street+','+usrn+','+impactMin+','+impactSlight+','+impactModerate+','+impactSevere;
var params = 'P10_WORK_REF,P10_FROM_DATE,P10_TO_DATE,P10_TOWN,P10_STREET,P10_USRN,P10_IMPACT_MINIMAL,P10_IMPACT_SLIGHT,P10_IMPACT_MODERATE,P10_IMPACT_SEVERE';
var url = 'f?p=' + appID + ':'+pageID+':' + sessionID + '::::' + params+':'+values;

popUp2(url, 1000, 750);
}

function showNetworkDetails(roadClass,appID,sessionID)
{
   //document.getElementById('P7_ENQ_ID').value = docID;
   setSessionValue('P60_ROAD_CAT',roadClass);

   var url = 'f?p=' + appID + ':60:' + sessionID;
   var win =window.open(url,'networkdetails','menubar=no,width=1024,height=550,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   win.focus();
}

function showStreetDetails(streetType,appID,sessionID)
{

   setSessionValue('P65_STREET_TYPE',streetType);

   var url = 'f?p=' + appID + ':65:' + sessionID;
   var win =window.open(url,'streetdetails','menubar=no,width=1024,height=550,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   win.focus();
}


function showEnqWorkTray(sessionID)
{
    var url = 'f?p=' + '501' + ':1:' + sessionID;
    var win =window.open(url,'focus_area','menubar=no,width=1100,height=900,toolbar=no,scrollbars=yes,resizable=yes,status=no');
    win.focus();
}

function addmodules(ibaId,appID,sessionID)
{
   //document.getElementById('P7_ENQ_ID').value = docID;
   setSessionValue('P912_IBA_ID',ibaId);

   var url = 'f?p=' + appID + ':912:' + sessionID;
   var win =window.open(url,'AddBusinessAreaModules','menubar=no,width=1024,height=550,toolbar=no,scrollbars=yes,resizable=no,status=no');
   win.focus();
}

function updateValue (pThis, pThat){
var enter_val = pThis;
var return_val = pThat;
  {
  gReturn = document.getElementById(enter_val).value;
    {html_GetElement(return_val).value = gReturn.toUpperCase()}
  }
}

function disFormItems(item1){
             disItem = document.getElementById(item1);
            // disItem.style.background = '#eeeeee';
             disItem.disabled = true;
    }
function enableFormItems(item1){
             enableItem = document.getElementById(item1);
             //disItem.style.background = '#FFFFFF';
             enableItem.disabled = false;
    }

function disableEnqSearch(pEnqId)
{
   if (pEnqId.value.length >= 1)
   {
     disFormItems("P0_SURNAME_INPUT");
     disFormItems("P0_POSTCODE_INPUT");
     disFormItems("P0_RESP_OF_INPUT");
     clearEnqText();
   }
   else
   {
     enableFormItems("P0_SURNAME_INPUT");
     enableFormItems("P0_POSTCODE_INPUT");
     enableFormItems("P0_RESP_OF_INPUT");
   }

   return;
}

function get_select_list_xml1(pThis,pSelect){
//alert('stuxml1');
    var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=docClassLov',0);
    get.add('DOC_TYPE_ITEM',pThis.value);
    gReturn = get.get('XML');
    if(gReturn && l_Select){
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for(var i=0;i<l_Count;i++){
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect(l_Select, l_Opt_Xml.getAttribute('value'),
                                     l_Opt_Xml.firstChild.nodeValue)
        }
    }
    get = null;
 }

  function initialise_lovs()
  {
//     var params = document.getElementsByClassName('gri_params');
     var params = getElementsByClassName('gri_params');
//alert('initialise_lov');     
//alert('initialise_lov2');     
//alert(params.length);
     for (var i=0; i<params.length; i++)
     {    
//alert('initialise_lov3 - '+params[i].value);
     if (params[i].onchange != null) {
     params[i].onchange();
     //bob[i].height = "20px";
     }
     }     
  }
 
 function get_select_list_xml2(pThis,pSelect){
//alert('stuxml2');                  
 var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=enquiryTypeLov',0);
    get.add('DOC_CLASS_ITEM',pThis.value);
//alert('stuxml2:2');                  
    gReturn = get.get('XML');
    //alert(gReturn);
    if(gReturn && l_Select){
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for(var i=0;i<l_Count;i++){
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect(l_Select, l_Opt_Xml.getAttribute('value'),
                                     l_Opt_Xml.firstChild.nodeValue)
        }
    }
    get = null;
 }

  function get_select_list_xml3(pThis,pSelect,pLov,pItem,pNo){
//alert('stuxml3');              
  var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS='+pLov,0);
//alert('stuxml3:2'+ 'APPLICATION_PROCESS='+pLov);              
    get.add(pItem+pNo,pThis.value);
    get.add(pItem,pThis.value);
    get.add('PARAM_DEP'+pNo,pSelect);
    
//alert('stuxml3:3 '+ pItem+pNo+' - '+pThis.value);                  
    gReturn = get.get('XML');
    //alert(gReturn);
    if(gReturn && l_Select){
//        alert('hello');
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for(var i=0;i<l_Count;i++){
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect(l_Select, l_Opt_Xml.getAttribute('value'),
                                     l_Opt_Xml.firstChild.nodeValue)
        }
    }
    get = null;
 }

   function addValue(pThis,pSelect,pItem,pNo){
//alert('stuxml - addValue');              
//alert('stuxml - addValue '+'PARAM_DEP'+pNo,pSelect);              
//alert('stuxml3:2'+ 'APPLICATION_PROCESS='+pLov);              
    get.add(pItem+pNo,pThis.value);
    get.add('PARAM_DEP'+pNo,pSelect);
//alert('stuxml3:3'+ pItem+pNo+' - '+pThis.value);                  
    //get = null;
 }
 
   function griClearItem(pItem,pNo)
{
//alert('stuxml - clearItem');              
//alert('stuxml - addValue '+'PARAM_DEP'+pNo,pSelect);              
//alert('stuxml3:2'+ 'APPLICATION_PROCESS='+pLov);              

   setSessionValue('PARAM_DEP'+pNo,null);
   setSessionValue('GRIRESULTITEM'+pNo,null);

//alert('stuxml3:3'+ pItem+pNo+' - '+pThis.value);                  
    //get = null;
 } 

   function helloWorld(pItem)
{
alert('Hello World - '+pItem.value);              
}   

   function helloWorld2()
{
alert('Hello World');              
} 
 
   function clearAllItems()
{
//alert('stuxml - clearAllItems');              
//alert('stuxml - addValue '+'PARAM_DEP'+pNo,pSelect);              
//alert('stuxml3:2'+ 'APPLICATION_PROCESS='+pLov);   
   setSessionValue('PARAM_DEP1',null);
   setSessionValue('PARAM_DEP2',null);
   setSessionValue('PARAM_DEP3',null);
   setSessionValue('PARAM_DEP4',null);
   setSessionValue('PARAM_DEP5',null);
   setSessionValue('PARAM_DEP6',null);
   setSessionValue('PARAM_DEP7',null);
   setSessionValue('PARAM_INDEP',null);
   setSessionValue('GRIRESULTITEM',null);
   setSessionValue('GRIRESULTITEM1',null);
   setSessionValue('GRIRESULTITEM2',null);
   setSessionValue('GRIRESULTITEM3',null);
   setSessionValue('GRIRESULTITEM4',null);
   setSessionValue('GRIRESULTITEM5',null);
   setSessionValue('GRIRESULTITEM6',null);
           
//alert('stuxml3:3'+ pItem+pNo+' - '+pThis.value);                  
    //get = null;
 }  
 
  function get_select_list_xml_dep(pThis,pSelect,pLov,pItem,pNo,pParam1){
//alert(getElementById('DOC_TYPE').value);;   
griClearItem(pSelect,pNo);
  var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS='+pLov,0);              
              //'APPLICATION_PROCESS=GRI0200LOV',0);
//alert('stuxml4:2 '+ 'APPLICATION_PROCESS='+pLov);              
//alert('stuxml4:3 '+ 'GRI0200RESULT ='+pThis.value);              
//alert('stuxml4:4 '+ 'PARAM_DEP'+pNo+' ='+pSelect);              
//alert('stuxml4:5 '+ 'PARAM_INDEP ='+pParam1);              
    get.add(pItem+pNo,pThis.value);
    //get.add('PARAM_DEP1',pSelect);
    get.add('PARAM_DEP'+pNo,pSelect);
    get.add('PARAM_INDEP',pParam1);
    get.add(pItem,pThis.value);
//alert('stuxml4:6'+ pItem+pNo+' - '+pThis.value);                  
    gReturn = get.get('XML');
//    alert(gReturn);
    if(gReturn && l_Select){
        var l_Count = gReturn.getElementsByTagName("option").length;        
  //      alert(l_Select.length);
        l_Select.length = 0;
        for(var i=0;i<l_Count;i++){
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect(l_Select, l_Opt_Xml.getAttribute('value'),
                                     l_Opt_Xml.firstChild.nodeValue)
        }
    }
    get = null;
 } 
 
function ValidateGRIText( pModule,pParam,pThis ){
  var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS=ValidateGRIText',0);
  get.add('GRITESTRESULTITEM',pThis.value);
  get.add('GRIPARAM',pParam);
  get.add('GRIMODULE',pModule);

  id = get.get();
  get = null; 
  if (id != "YES")
  {
    displayError('IM','12',pParam);
  }  
}

  function get_select_list_xml_dep2(pThis,pSelect,pThis2,pSelect2,pLov,pItem,pNo,pParam1){
//alert('studep2');              
  var l_Return = null;
    var l_Select = html_GetElement(pSelect);
    var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
              'APPLICATION_PROCESS='+pLov,0);              
              //'APPLICATION_PROCESS=GRI0200LOV',0);
//alert('studep2:2 '+ 'APPLICATION_PROCESS='+pLov);              
//alert('studep2:3 '+ 'GRIRESULTITEM1 ='+pThis.value);              
//alert('studep2:4 '+ 'GRIRESULTITEM2 ='+pThis2.value);              
//alert('studep2:4 '+ 'PARAM_DEP1 ='+pSelect);              
//alert('studep2:4 '+ 'PARAM_DEP2 ='+pSelect2);              
//alert('studep2:5 '+ 'PARAM_INDEP ='+pParam1);              
    get.add('GRIRESULTITEM1',pThis.value);
    get.add('GRIRESULTITEM2',pThis2.value);
    get.add('PARAM_DEP1',pSelect);
    get.add('PARAM_DEP2',pSelect2);
    get.add('PARAM_INDEP',pParam1);
    get.add(pItem,pThis.value);
//alert('studep2:6'+ pItem+pNo+' - '+pThis.value);                  
    gReturn = get.get('XML');
    alert(gReturn);
    if(gReturn && l_Select){
        var l_Count = gReturn.getElementsByTagName("option").length;
        l_Select.length = 0;
        for(var i=0;i<l_Count;i++){
            var l_Opt_Xml = gReturn.getElementsByTagName("option")[i];
            appendToSelect(l_Select, l_Opt_Xml.getAttribute('value'),
                                     l_Opt_Xml.firstChild.nodeValue)
        }
    }
    get = null;
 } 
 
 function appendToSelect(pSelect, pValue, pContent) {
    var l_Opt = document.createElement("option");
    l_Opt.value = pValue;
    if(document.all){
        pSelect.options.add(l_Opt);
        l_Opt.innerText = pContent;
     }else{
        l_Opt.appendChild(document.createTextNode(pContent));
        pSelect.appendChild(l_Opt);
    }

}


function callReportUrl(url,appID,sessionID)
{
   //document.getElementById('P7_ENQ_ID').value = docID;
   //setSessionValue('P911_IBM_IBA_ID',ibaId);

   //var url = 'f?p=' + appID + ':911:' + sessionID;
   var win =window.open(url,'Reports','menubar=no,width=550,height=550,toolbar=no,scrollbars=no,resizable=no,status=yes');
   win.focus();
}


function hideDiv(divName) {
    document.getElementById(divName).style.visibility = "hidden";
}


function displayGRI(moduleID)
{
   var html;
   var griWin = document.getElementById("griWin");
   
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=displayGRI',0);
   get.add('MODULE_ID',moduleID);                  
   html = get.get();
   get = null;
   //alert('stuxml - displayGRI');   
   clearAllItems();
   griWin.innerHTML = html;
   griWin.style.visibility = "visible";  
   
   document.getElementById('P50_MODULE').value = moduleID;
   setSessionValue('P50_MODULE', moduleID);

}

function displayRoadworkDetails(ref)
{
   var html;
   var roadworksWin = document.getElementById("roadworksWin");
   
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=displayRoadworkDetails',0);
   get.add('ROAD_REF',ref);                
   html = get.get();
   get = null;

   $('#drillh').append('<div id="dispRW"></div>')

   $("#dispRW").append(html).dialog({
         bgiframe: true,
         resizable: false,
         modal: true,
         title: 'Details for : '+ ref,
         autoOpen: true,
         position: 'center',
         hide: 'blind',
         show: 'blind',
         width:400,
         //height:400,
         zIndex:4999,
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
}



function showHelp(moduleID)
{
   var url;
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=displayWebHelp',0);
   get.add('MODULE_ID',moduleID);                  
   url = get.get();
   get = null;
   
   //url = 'http://exdl9:7777/im4dev';
   panel1 = new YAHOO.widget.Panel("helpPanel", { width:"600px", height:"400px", visible:true, draggable:true, close:true} );

   panel1.setHeader("Help "+url);
   panel1.setBody("<iframe src="+url+" width=580px height=375px></iframe>");
   panel1.setFooter("");
   panel1.render("showHelp");
}



function exorpopupFieldHelp(pFieldName)
{

   var text;
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=getItemHelpText',0);
   get.add('ERROR_ID',pFieldName);                 
   text = get.get();
   get = null;
   
   panel1 = new YAHOO.widget.Panel("popUpHelpPanel", { visible:true, draggable:true, close:true,constraintoviewport:true, underlay:"none"} );

   panel1.setHeader("Hints & Tips");
   panel1.setBody(text); 
   
   panel1.setFooter('<a href="javascript:showOnlineHelp();">Online Help</a>');
   panel1.render("showHelpPanel");
}


function podInfo(pThis)
{
   var pFieldName = pThis.attr('value');
   var pVersionTag;
   var text;
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=getItemHelpText',0);
   get.add('ERROR_ID',pFieldName);                 
   text = get.get();
   get = null;
  
   

   $("#dispInfo").dialog( "option", "title", 'POD Info : '+ pFieldName ).empty().append(text).dialog('open'); 
   
   
}

function AjaxReportRefresh(pThis){
var l_Val = pThis;
var get = new htmldb_Get(null,$x('pFlowId').value,null,911);
get.add('P911_IBM_IBA_ID',l_Val);
gReturn = get.get(null,'<ajax:BOX_BODY>','</ajax:BOX_BODY>');
get = null;
//$x('AjaxReport').innerHTML = gReturn;

panel1 = new YAHOO.widget.Panel("reportModules", { width:"400px", visible:true, draggable:false, close:true, fixedcenter:true} );

    panel1.setHeader("Modules");
    panel1.setBody(gReturn);
    panel1.setFooter("");
    panel1.render("AjaxReport");

return;
}

function setNetLocation(pDescr, pUnique)
{

if (opener.document.forms["wwv_flow"].p_t01.length > 1){
    var l_field = opener.document.forms["wwv_flow"].p_t01[13];
    l_field.value = pDescr;
    opener.document.forms["wwv_flow"].p_t01[13].focus();

    var l_field2= opener.document.forms["wwv_flow"].p_t02[13];
    l_field2.value = pDescr;
    //opener.document.forms["wwv_flow"].p_t01[13].focus();
    var l_field3= opener.document.forms["wwv_flow"].p_t03[13];
    l_field3.value = pUnique;
   opener.document.getElementById("P0_LOCATION_INPUT").value = pDescr;

}else{
    var l_field = opener.document.forms["wwv_flow"].p_t01;
    l_field.value = pDescr;
    opener.document.forms["wwv_flow"].p_t01.focus();
    var l_field2= opener.document.forms["wwv_flow"].p_t02;
    l_field2.value = pDescr;
    //opener.document.forms["wwv_flow"].p_t01[13].focus();
    var l_field3= opener.document.forms["wwv_flow"].p_t03;
    l_field3.value = pUnique;
    opener.document.getElementById("P0_LOCATION").value = pDescr;
    
}
    if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
    window.close();
if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}   

function passbackSurname(pSurname,pHctId)
{
   if (opener.document.forms["wwv_flow"].p_t05.length > 1){
      var l_field = opener.document.forms["wwv_flow"].p_t05[13];
      l_field.value = pSurname;
      opener.document.forms["wwv_flow"].p_t06[13].focus();
      var l_field2 = opener.document.forms["wwv_flow"].p_t06[13];
      l_field2.value = pHctId;
   }else{
      var l_field = opener.document.forms["wwv_flow"].p_t05;
      l_field.value = pSurname;
      opener.document.forms["wwv_flow"].p_t05.focus();  
      var l_field2 = opener.document.forms["wwv_flow"].p_t06;
      l_field2.value = pHctId;
   }
      if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
      window.close();
   if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}   
function passbackPostcode(pPostcode)
{
   if (opener.document.forms["wwv_flow"].p_t07.length > 1){
      var l_field = opener.document.forms["wwv_flow"].p_t07[13];
      l_field.value = pPostcode;
      opener.document.forms["wwv_flow"].p_t07[13].focus();
      var l_field2 = opener.document.forms["wwv_flow"].p_t08[13];
      l_field2.value = pPostcode;
   }else{
      var l_field = opener.document.forms["wwv_flow"].p_t07;
      l_field.value = pPostcode;
      opener.document.forms["wwv_flow"].p_t07.focus();  
      l_field2 = opener.document.forms["wwv_flow"].p_t08;
      l_field2.value = pPostcode;
   }
      if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
      window.close();
   if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}   
function passbackRespOf(pRespOf,pUserid)
{
   if (opener.document.forms["wwv_flow"].p_t09.length > 1){
      var l_field = opener.document.forms["wwv_flow"].p_t09[13];
      l_field.value = pRespOf;
      opener.document.forms["wwv_flow"].p_t09[13].focus();
      var l_field2 = opener.document.forms["wwv_flow"].p_t10[13];
      l_field2.value = pUserid;
   }else{
      var l_field = opener.document.forms["wwv_flow"].p_t09;
      l_field.value = pRespOf;
      opener.document.forms["wwv_flow"].p_t09.focus();  
      l_field2 = opener.document.forms["wwv_flow"].p_t10;
      l_field2.value = pUserid;
   }
      if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
      window.close();
   if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}   
function passbackTown(pTown, pCounty)
{
   if (opener.document.forms["wwv_flow"].p_t16.length > 1){
      var l_field = opener.document.forms["wwv_flow"].p_t16[13];
      l_field.value = pTown;
      opener.document.forms["wwv_flow"].p_t16[13].focus();
      var l_field2 = opener.document.forms["wwv_flow"].p_t17[13];
      l_field2.value = pCounty;
      var l_field3 = opener.document.forms["wwv_flow"].p_t19[13];
      l_field3.value = pTown;
   }else{
      var l_field = opener.document.forms["wwv_flow"].p_t16;
      l_field.value = pTown;
      opener.document.forms["wwv_flow"].p_t17.focus();  
      l_field2 = opener.document.forms["wwv_flow"].p_t17;
      l_field2.value = pCounty;
      l_field3 = opener.document.forms["wwv_flow"].p_t19;
      l_field3.value = pTown;
   }
      if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
      window.close();
   if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}   
function passbackStreet(pStreet, pUsrn, pTown, pCounty)
{
   if (opener.document.forms["wwv_flow"].p_t18.length > 1){
      var l_field = opener.document.forms["wwv_flow"].p_t18[13];
      l_field.value = pStreet;
      opener.document.forms["wwv_flow"].p_t18[13].focus();
      
      var l_field2 = opener.document.forms["wwv_flow"].p_t16[13];
      l_field2.value = pTown;
       var l_field3 = opener.document.forms["wwv_flow"].p_t15[13];
      l_field3.value = pCounty;
       var l_field4 = opener.document.forms["wwv_flow"].p_t19[13];
      l_field4.value = pTown;
       var l_field5 = opener.document.forms["wwv_flow"].p_t20[13];
      l_field5.value = pStreet;
       var l_field6 = opener.document.forms["wwv_flow"].p_t21[13];
      l_field6.value = pUsrn;
     
   }else{
      var l_field = opener.document.forms["wwv_flow"].p_t18;
      l_field.value = pStreet;
      opener.document.forms["wwv_flow"].p_t18.focus();  
      
      var l_field2 = opener.document.forms["wwv_flow"].p_t16;
      l_field2.value = pTown;
       var l_field3 = opener.document.forms["wwv_flow"].p_t17;
      l_field3.value = pCounty;
       var l_field4 = opener.document.forms["wwv_flow"].p_t19;
      l_field4.value = pTown;
       var l_field5 = opener.document.forms["wwv_flow"].p_t20;
      l_field5.value = pStreet;
       var l_field6 = opener.document.forms["wwv_flow"].p_t21;
      l_field6.value = pUsrn;
      
   }
   
      if(l_field.getAttribute('onchange') || l_field.onchange){l_field.onchange()}
      window.close();
   if(!(l_field.disabled || l_field.type == 'HIDDEN')){l_field.focus();}
}
function displayNetSearch(appID, sessionID, fromItem, toItem, pageId,x,y){
var l_Val = document.getElementById(fromItem).value;
var get = new htmldb_Get(null,$x('pFlowId').value,null,pageId);
get.add(toItem,l_Val);
gReturn = get.get();
get = null;
 var url = 'f?p=' + appID + ':'+pageId+':' + sessionID;

   // var win =window.open(url,'Reports','menubar=no,width=800,height=630,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   //win.focus();
   popUp2(url, x, y);
return;
}
function displayNetSearch2(appID, sessionID, fromItem, toItem,  fromItem2, toItem2,pageId,x,y){
var l_Val = document.getElementById(fromItem).value;
var l_Val2 = document.getElementById(fromItem2).value;
var get = new htmldb_Get(null,$x('pFlowId').value,null,pageId);
get.add(toItem,l_Val);
get.add(toItem2,l_Val2);
gReturn = get.get();
get = null;
 var url = 'f?p=' + appID + ':'+pageId+':' + sessionID;

   // var win =window.open(url,'Reports','menubar=no,width=800,height=630,toolbar=no,scrollbars=yes,resizable=yes,status=no');
   //win.focus();
   popUp2(url, x, y);
return;
}

function displayENQList(appID, sessionID, pageID){
id = document.getElementById('P0_ENQ_ID_INPUT').value;
sname = document.getElementById('P0_SURNAME').value;
pcode = document.getElementById('P0_POSTCODE').value;
respof = document.getElementById('P0_RESP_OF').value;
values = id + ','+sname+','+pcode+','+respof;

var url = 'f?p=' + appID + ':'+pageID+':' + sessionID + '::::' + 'P20_ENQ_ID,P20_SURNAME,P20_POSTCODE,P20_RESP_OF:'+values;
//alert(url);
popUp2(url, 1000, 700);
return;
}


function showDrillDown(appID, sessionID, page, item1,val1, item2,val2, item3,val3, item4,val4, item5,val5 ){
  
  if(page != 51){
     var module =  parseInt(appID) + parseInt(page);
    
     doDrillDown('IM'+module,val1,val2,val3,val4,val5);    
  }
  else {
      
    
   
var params = '';

   if (item1 != null)
   {  
       params = item1+':'+val1;
   }
   if (item2 != null)
   {
       params = item1+','+item2+':'+val1+','+val2;
   }
   if (item3 != null)
   {
       params = item1+','+item2+','+item3+':'+val1+','+val2+','+val3;
   }   
   if (item4 != null)
   {
       params = item1+','+item2+','+item3+','+item4+':'+val1+','+val2+','+val3+','+val4;
   }
   if (item5 != null)
   {
       params = item1+','+item2+','+item3+','+item4+','+item5+':'+val1+','+val2+','+val3+','+val4+','+val5;
   }      
    
   //var get = new htmldb_Get(null,html_GetElement('pFlowId').value,
   //           'APPLICATION_PROCESS=getCurrentSessionID',0);

   //var lsessionID = get.get();
   
   //get = null;
   var lsessionID = $v('pInstance');  
      
   var url = 'f?p=' + appID + ':'+page+':' + lsessionID+ '::::' + params;
   
  
    var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=displayGRI',0);
   get.add('MODULE_ID',val1);                  
   var gReturn = get.get();
   get = null; 
        $("#grixxx").empty().append(gReturn);  
    //    $("#gri").dialog('option', 'title' , '');    
    //    $("#gri").dialog('option','height',$(document).height()-50);
    //    $("#gri").dialog('option','width',$(document).width()-100);
   //   $("#gri").dialog('open');       
   }
   
   
 }
function popUpReport (pURL){
     var win =window.open(pURL,'Drilldown','menubar=no,width=1000,height=700,toolbar=yes,scrollbars=yes,resizable=yes,status=ye');
        win.focus(); 
}
function validLocation()
{
  var id;
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=IsValidLocation',0);
   get.add('NETWORK_NAME',document.getElementById('P0_NETWORK_INPUT').value.toUpperCase());                
   id = get.get();
   get = null; 
   return id;
}
function validEnquiry()
{
  var id;
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=IsValidEnquiry',0);
   get.add('DOC_ID',document.getElementById('P0_ENQ_ID_INPUT').value);                 
   get.add('ENQ_ID_NAME',document.getElementById('P0_SURNAME').value);                 
   get.add('POSTCODE_NAME',document.getElementById('P0_POSTCODE_INPUT').value);                
   get.add('RESP_OF_NAME',document.getElementById('P0_RESP_OF_INPUT').value);       
   id = get.get();
   get = null; 
   return id;
}
function validEnquiryLocation()
{
  var id;
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=checkEnqLocation',0);
   get.add('DOC_ID',document.getElementById('P0_ENQ_ID_INPUT').value);                 
   get.add('ENQ_ID_NAME',document.getElementById('P0_SURNAME').value);                 
   get.add('POSTCODE_NAME',document.getElementById('P0_POSTCODE_INPUT').value);                
   get.add('RESP_OF_NAME',document.getElementById('P0_RESP_OF_INPUT').value);       
   id = get.get();
   get = null;    
   return id;
}

function validRoadworks()
{
  var id;
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=isValidRoadworkData',0);
   get.add('P_FROM_DATE',$('#PX_FROM').val());              
   get.add('P_TO_DATE',$('#PX_TO').val());               
   get.add('P_TOWN',$('#PX_TOWN').val());             
   get.add('P_STREET',$('#PX_STREET').val());       
   id = get.get();
   get = null; 
   return id;
}
function validRoadworksLocation()
{
  var id;
    
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=checkRoadWorkAtLocation',0);
   get.add('P_FROM_DATE',$('#PX_FROM').val());                 
   get.add('P_TO_DATE',$('#PX_TO').val());                 
   get.add('P_TOWN',$('#PX_TOWN').val());                  
   get.add('P_STREET',$('#PX_STREET').val());       
   id = get.get();
   get = null; 
   return id;
}
function displayError(pProduct, pMsgId, pElement)
{
   var get = new
         htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=raisener',0);
   get.add('PRODUCT',pProduct);                
   get.add('ERROR_ID',pMsgId);  
   if (pElement != 'NONE'){
   get.add('SUPP_INFO',document.getElementById(pElement).value);
   }
   else{
   get.add('SUPP_INFO','');
   }
   id = get.get();
   get = null;   
   alert(id);
   
}
function validateMapCall(pMapRequest, pPage)
{
   var id = validLocation();
    
   if (id == "NO\n")
   {
      displayError('IM',1,'P0_NETWORK_INPUT');
   }
   else
   { 
      if (pPage == 1)
      {
         setMapQueryType(pMapRequest);
         doSubmit('T_MAP')
      }
      else
      {
         setMapQueryType(pMapRequest);
         executeLatestQuery();
      }
   } 
   
}
function validateENQButton(pMapRequest, pPage, pAppId, pSessionID)
{
   var id = validEnquiry();
    
   if (id != "YES")
   {
      
      switch(id)
        {
        case '2':
          displayError('IM',id,'P0_ENQ_ID_INPUT');
          break;    
        case '3':
          displayError('IM',id,'P0_SURNAME_INPUT');
          break;
        case '4':
          displayError('IM',id,'P0_POSTCODE_INPUT');
          break;
        case '5':
          displayError('IM',id,'P0_RESP_OF_INPUT');
          break;
        default:
          displayError('IM',id,'NONE');       
        }
   }
   else
   { if (pMapRequest != "")
     {
      var id = validEnquiryLocation();
      if (id == 'NO')
      {
         displayError('IM',11,'NONE');  
      }
      else
      {
         if (pPage == 1)
         {
            setMapQueryType(pMapRequest);
            doSubmit('T_MAP');
         }
         else
         {
            setMapQueryType(pMapRequest);
            executeLatestQuery();
         }
      }
     }
     else
     {
       displayENQList(pAppId, pSessionID, 20);
     }
   }
}

function validateRoadworkButton(pMapRequest, pPage, pAppId, pSessionID)
{
   var id = validRoadworks();
    
   if (id != "YES")
   {     
      switch(id)
        {
        case '7':
          displayError('IM',id,'P0_FROM_DATE');
          break;    
        case '8':
          displayError('IM',id,'P0_TOWN_INPUT');
          break;
        case '9':
          displayError('IM',id,'P0_STREET_INPUT');
          break;
        default:
          displayError('IM',id,'NONE');       
        }
   }
   else
   { if (pMapRequest != "")
     {
      var id = validRoadworksLocation();
      if (id == 'NO')
      {
         displayError('IM',10,'NONE');  
      }
      else
      {
         if (pPage == 1)
         {
            setMapQueryType(pMapRequest);
          
            //doSubmit('T_MAP');
            //window.location = 'f?p='+$v('pFlowId')+':4:'+$v('pInstance');
            goMapPage($('#PX_REF').val() ,$('#PX_FROM').val() ,$('#PX_TO').val() ,$('#PX_TOWN').val() ,$('#PX_STREET').val() 
                     ,$('#PX_NSG').val() ,$('#PX_IMPACT_SEVERE').val() ,$('#PX_IMPACT_MODERATE').val()
                     ,$('#PX_IMPACT_SLIGHT').val() ,$('#PX_IMPACT_MINIMAL').val());
            
         }
         else
         {
            setMapQueryType(pMapRequest);
            executeLatestQuery();
         }
      }
     }
     else
     {
       showRoadworks(pAppId, pSessionID, 10);       
     }
   }
}

function checkLocationSet()
{
    if (document.getElementById('P0_NETWORK_INPUT').value != '')
    {
        toggleLocationLabel('SHOW');
    }
}

function toggleLocationLabel(pAction)
{
   var l_label = document.getElementById('P0_LOCATION_LABEL');
   var l_value = document.getElementById('P0_LOCATION');
   
   document.getElementById('P0_LOCATION').innerHTML = document.getElementById('P0_NETWORK_INPUT').value;
 
   if(pAction == 'SHOW' && document.getElementById('P0_SET_LOCATION').value == 'Y')
   {
       YAHOO.util.Dom.removeClass(l_label, "locationSetTo");
       YAHOO.util.Dom.addClass(l_label, "locationSetToShow");   
       YAHOO.util.Dom.removeClass(l_value, "locationSetTo");
       YAHOO.util.Dom.addClass(l_value, "locationSetToShow");   
   }
   else
   {
       YAHOO.util.Dom.removeClass(l_label, "locationSetToShow");
       YAHOO.util.Dom.addClass(l_label, "locationSetTo");
       YAHOO.util.Dom.removeClass(l_value, "locationSetToShow");
       YAHOO.util.Dom.addClass(l_value, "locationSetTo");
    
   }
}

function validateLocationSet(pPage)
{
   var id = validLocation();
    
   if (id == "NO\n") {
    displayError('IM', 1, 'P0_NETWORK_INPUT');
   }
   else {
    if (pPage == 1) {
        toggleLocationLabel('SHOW');
        document.getElementById('P0_SET_LOCATION').value = 'Y';
        YAHOO.util.Dom.get("P0_SET_LOCATION").value = 'Y'
        doSubmit('T_HOME');
    }
   }

}
function doLocationClear(pPage)
{
   toggleLocationLabel('CLEAR');
    YAHOO.util.Dom.get("P0_SET_LOCATION").value  = 'N';
   clearRoad();
   if (pPage == 1)
   {
      doSubmit('T_HOME');
   }   
   clearMapThemes(pPage);
}

/*
    Developed by Robert Nyman, http://www.robertnyman.com
    Code/licensing: http://code.google.com/p/getelementsbyclassname/
*/  
var getElementsByClassName = function (className, tag, elm){
    if (document.getElementsByClassName) {
        getElementsByClassName = function (className, tag, elm) {
            elm = elm || document;
            var elements = elm.getElementsByClassName(className),
                nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,
                returnElements = [],
                current;
            for(var i=0, il=elements.length; i<il; i+=1){
                current = elements[i];
                if(!nodeName || nodeName.test(current.nodeName)) {
                    returnElements.push(current);
                }
            }
            return returnElements;
        };
    }
    else if (document.evaluate) {
        getElementsByClassName = function (className, tag, elm) {
            tag = tag || "*";
            elm = elm || document;
            var classes = className.split(" "),
                classesToCheck = "",
                xhtmlNamespace = "http://www.w3.org/1999/xhtml",
                namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,
                returnElements = [],
                elements,
                node;
            for(var j=0, jl=classes.length; j<jl; j+=1){
                classesToCheck += "[contains(concat(' ', @class, ' '), ' " + classes[j] + " ')]";
            }
            try {
                elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);
            }
            catch (e) {
                elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);
            }
            while ((node = elements.iterateNext())) {
                returnElements.push(node);
            }
            return returnElements;
        };
    }
    else {
        getElementsByClassName = function (className, tag, elm) {
            tag = tag || "*";
            elm = elm || document;
            var classes = className.split(" "),
                classesToCheck = [],
                elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),
                current,
                returnElements = [],
                match;
            for(var k=0, kl=classes.length; k<kl; k+=1){
                classesToCheck.push(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));
            }
            for(var l=0, ll=elements.length; l<ll; l+=1){
                current = elements[l];
                match = false;
                for(var m=0, ml=classesToCheck.length; m<ml; m+=1){
                    match = classesToCheck[m].test(current.className);
                    if (!match) {
                        break;
                    }
                }
                if (match) {
                    returnElements.push(current);
                }
            }
            return returnElements;
        };
    }
    return getElementsByClassName(className, tag, elm);
};

$(document).ready(function() {
        var mouseX;
        var mouseY;

       /*  var $tooltip = $('<div id="tooltip"></div>').appendTo('body');
        var positionTooltip = function(event) {
        var tPosX = event.pageX;
        var tPosY = event.pageY + 20;
        $tooltip.css({top: tPosY, left: tPosX});
        };
        var showTooltip = function(event) {
        var authorName = $(this).attr("alt");
        $tooltip
        .text('Highlight all articles by ' + authorName)
        .show();
        positionTooltip(event);
        };
        var hideTooltip = function() {
        $tooltip.hide();
        };
        $('img').hover(showTooltop, hideTooltip)
                .mousemove(positionTooltop);
        */
 /*    $('.podIconsi').click(function(e){
                     mouseX = e.pageX - 510;
                     mouseY = e.pageY - 50;
                            
                     EXOR.setXY(mouseX, mouseY);
               });  */
    // add id to img elements and add tooltips for images
    /*  for ( var i = 0; i < $('img').length; i++ ) {
            if ($('img:eq(' + i + ')').attr('id') == '') {
                $('img:eq(' + i + ')').attr('id', 'link-' + i);
                var imgItem = $('#link-' + i);
                var alt_text = imgItem.attr("alt");
                imgItem.attr("alt", "").click(function(e){
                            mouseX = e.pageX - 510;
                            mouseY = e.pageY - 50;
                            
                        EXOR.setXY(mouseX, mouseY);
                    });
                
                if (alt_text != '') {
                    
                    new YAHOO.widget.Tooltip("myTip", {
                        context: 'link-' + i,
                        text: alt_text,
                        effect: {
                            effect: YAHOO.widget.ContainerEffect.FADE,
                            duration: 0.30
                        },
                        showdelay: 0
                    });
                }
            }   
        }*/
    
    });

jQuery.url = function()
{
    var segments = {};
    
    var parsed = {};
    
    /**
    * Options object. Only the URI and strictMode values can be changed via the setters below.
    */
    var options = {
    
        url : window.location, // default URI is the page in which the script is running
        
        strictMode: false, // 'loose' parsing by default
    
        key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"], // keys available to query 
        
        q: {
            name: "queryKey",
            parser: /(?:^|&)([^&=]*)=?([^&]*)/g
        },
        
        parser: {
            strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,  //less intuitive, more accurate to the specs
            loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/ // more intuitive, fails on relative paths and deviates from specs
        }
        
    };
    
    /**
     * Deals with the parsing of the URI according to the regex above.
     * Written by Steven Levithan - see credits at top.
     */     
    var parseUri = function()
    {
        str = decodeURI( options.url );
        
        var m = options.parser[ options.strictMode ? "strict" : "loose" ].exec( str );
        var uri = {};
        var i = 14;

        while ( i-- ) {
            uri[ options.key[i] ] = m[i] || "";
        }

        uri[ options.q.name ] = {};
        uri[ options.key[12] ].replace( options.q.parser, function ( $0, $1, $2 ) {
            if ($1) {
                uri[options.q.name][$1] = $2;
            }
        });

        return uri;
    };

    /**
     * Returns the value of the passed in key from the parsed URI.
     * 
     * @param string key The key whose value is required
     */     
    var key = function( key )
    {
        if ( ! parsed.length )
        {
            setUp(); // if the URI has not been parsed yet then do this first...    
        } 
        if ( key == "base" )
        {
            if ( parsed.port !== null && parsed.port !== "" )
            {
                return parsed.protocol+"://"+parsed.host+":"+parsed.port+"/";   
            }
            else
            {
                return parsed.protocol+"://"+parsed.host+"/";
            }
        }
    
        return ( parsed[key] === "" ) ? null : parsed[key];
    };
    
    /**
     * Returns the value of the required query string parameter.
     * 
     * @param string item The parameter whose value is required
     */     
    var param = function( item )
    {
        if ( ! parsed.length )
        {
            setUp(); // if the URI has not been parsed yet then do this first...    
        }
        return ( parsed.queryKey[item] === null ) ? null : parsed.queryKey[item];
    };

    /**
     * 'Constructor' (not really!) function.
     *  Called whenever the URI changes to kick off re-parsing of the URI and splitting it up into segments. 
     */ 
    var setUp = function()
    {
        parsed = parseUri();
        
        getSegments();  
    };
    
    /**
     * Splits up the body of the URI into segments (i.e. sections delimited by '/')
     */
    var getSegments = function()
    {
        var p = parsed.path;
        segments = []; // clear out segments array
        segments = parsed.path.length == 1 ? {} : ( p.charAt( p.length - 1 ) == "/" ? p.substring( 1, p.length - 1 ) : path = p.substring( 1 ) ).split("/");
    };
    
    return {
        
        /**
         * Sets the parsing mode - either strict or loose. Set to loose by default.
         *
         * @param string mode The mode to set the parser to. Anything apart from a value of 'strict' will set it to loose!
         */
        setMode : function( mode )
        {
            strictMode = mode == "strict" ? true : false;
            return this;
        },
        
        /**
         * Sets URI to parse if you don't want to to parse the current page's URI.
         * Calling the function with no value for newUri resets it to the current page's URI.
         *
         * @param string newUri The URI to parse.
         */     
        setUrl : function( newUri )
        {
            options.url = newUri === undefined ? window.location : newUri;
            setUp();
            return this;
        },      
        
        /**
         * Returns the value of the specified URI segment. Segments are numbered from 1 to the number of segments.
         * For example the URI http://test.com/about/company/ segment(1) would return 'about'.
         *
         * If no integer is passed into the function it returns the number of segments in the URI.
         *
         * @param int pos The position of the segment to return. Can be empty.
         */ 
        segment : function( pos )
        {
            if ( ! parsed.length )
            {
                setUp(); // if the URI has not been parsed yet then do this first...    
            } 
            if ( pos === undefined )
            {
                return segments.length;
            }
            return ( segments[pos] === "" || segments[pos] === undefined ) ? null : segments[pos];
        },
        
        attr : key, // provides public access to private 'key' function - see above
        
        param : param // provides public access to private 'param' function - see above
        
    };
    
}();    





 $(document).ready(function(){
        $("#onLineHelp").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,
            title: 'Online Help',
            autoOpen: false,
            hide: 'blind',
            //show: 'slide',
            width:750,
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
        $("#docAss").dialog({
            bgiframe: true,
            resizable: true,
            modal: true,
            title: 'Associated documents',
            autoOpen: false,
//          hide: 'blind',
            //show: 'slide',
            width:750,
            height:500,
            zIndex:4999,
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
        $("#gri").dialog({
            bgiframe: true,
            resizable: true,
            modal: true,
            title: 'Associated documents',
            autoOpen: false,
//          hide: 'blind',
            //show: 'slide',
            width:750,
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



function showOnlineHelp(){
    var lHost = jQuery.url.attr("host");
    $("#onLineHelp").dialog('option', 'title' , 'Online Help');
    $("#jqmContent").attr("src","http://"+lHost+"/im4_framework/WebHelp/Information_Manager.htm");  
    $("#onLineHelp").dialog('open');
}

 $(document).ready(function(){

    var helpTab = $('a:contains(Help) && !a:contains(show_ir_help)');
    helpTab.removeAttr("href");
    helpTab.bind('click', function() {                       
                         showOnlineHelp();                       
                         })
           .addClass('help-hover');
 });

function clearMapThemes(pPageID)    {
    if(pPageID == 4){
        removeTemplated();
    }
}


 $(document).ready(function (){
   $("td.datepicker")
                    .next("td")
                    .remove()
                    .end()
                    .children("input[type!=hidden]")
                    .datepicker(
                            { dateFormat : 'dd-M-yy'
                            , closeText : 'X'
                            , clearText : ''
                            , showAnim : 'scale'
                            , showOptions : { origin: ['top', 'left'] }
                            , showOn : 'button'
                            , buttonImage : '/i/asfdcldr.gif'
                            , buttonImageOnly : true
							, changeYear : true
							, changeMonth : true
                    });
    });
    
    
$(document).ready(function(){
       
        $("#themeColumnsContainer").dialog({
            bgiframe: true,
            resizable: true,
            modal: true,
            title: 'Theme Columns',
            autoOpen: false,
            position: 'middle',
            hide: 'blind',
            show: 'blind',
            width:700,
            height:600,
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
       
        $("#searchColumnsContainer").dialog({
            bgiframe: true,
            resizable: true,
            modal: true,
            title: 'Search Columns',
            autoOpen: false,
            position: 'middle',
            hide: 'blind',
            show: 'blind',
            width:700,
            height:600,
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

    
function showThemeColumns(pThemeID){
    var url = 'f?p=' + $v('pFlowId') + ':935:' + $v('pInstance') + '::::'+'P935_THEME_ID:' + pThemeID;
    $("#themeColumnsContent").attr("src", url);
    $("#themeColumnsContainer").dialog('open');
}

function showAdminSearchCols(pSearchID){
    var url = 'f?p=' + $v('pFlowId') + ':981:' + $v('pInstance') + '::::'+'P981_ITTS_SEQ:' + pSearchID;
    $("#searchColumnsContent").attr("src", url);
    $("#searchColumnsContainer").dialog('open');
}




$(document).ready(function(){
       
        $("#MapMoreDetailsContent").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,
            title: 'Theme Columns',
            autoOpen: false,
            position: ['left','top'],
            hide: 'blind',
            show: 'blind',
            width:700,
            height:400,
            zIndex:4999,
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
    

function showMapMoreDetailsContent(piItemId, piThemeID ){
    
    var get = new
        htmldb_Get(null,html_GetElement('pFlowId').value,
                   'APPLICATION_PROCESS=moremapdetails',0);
    get.add('ITEM_ID',piItemId);                   
    get.add('THEME_ID',piThemeID);

    var id = get.get();
    get = null;   
    $("#MapMoreDetailsContent").empty().append('<b>'+id+'</b>').dialog('open'); 
}   

/*
$(document).ready(function(){
    //create the tabs
    $("#myTabs").tabs();
});


 $(document).ready(function(){
    var page = $v('pFlowStepId');   
    if ( page != 1){
        return;
    }  
        $("#drillDownContainer").dialog({
            bgiframe: true,
            resizable: true,
            modal: false,           
            autoOpen: false,
            title: 'Drilldown',
            hide: 'blind',
            show: 'blind',
            width:900,
            height:550,
            overlay: {
                backgroundColor: '#000',
                opacity: 0.5
            },
            buttons: {
                'Close' : function() {                  
                    var $tabs = $('#myTabs').tabs('length');
                    for (var i = $tabs - 1; i >= 0; i--) {
                        $tabs.tabs('remove', i);                    
                    } 
                    $(this).dialog('close');                                    
                }
            }
        });
    });*/
$(document).ready(function(){   
    $("#showmaplegend, #showmapprint, #searchmapButton, #refreshButton").button();
}); 

$(document).ready( function() {
    var page = $v('pFlowStepId');   
    if ( page != 4){
        return;
    }  
        $("#searchmap").autocomplete('APEX', {
                apexProcess: 'AUTO_NETWORK',
                width: 400,
                multiple: false,
                matchContains: true,
                cacheLength: 1,
                max: 100,
                delay: 150,
                minChars: 3,
                matchSubset: false
            });
         $("#searchmap").result(function(event, data, formatted) {
        if (data){
            $("#P4_NE_ID").val(data[1]);
            $("#P4_NE_UNIQUE").val(data[2]);            
           }
        });

});         