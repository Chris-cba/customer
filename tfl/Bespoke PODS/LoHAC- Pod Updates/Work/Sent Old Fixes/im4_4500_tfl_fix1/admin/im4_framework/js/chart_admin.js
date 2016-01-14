/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/Sent Old Fixes/im4_4500_tfl_fix1/admin/im4_framework/js/chart_admin.js-arc   1.0   Jan 14 2016 23:34:40   Sarah.Williams  $
 --       Module Name      : $Workfile:   chart_admin.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 23:34:40  $
 --       Date fetched Out : $Modtime:   Nov 15 2011 16:49:08  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 --	Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
function setBgColors(a){var d=$("#P997_BGCOLOR1");var c=$("#P997_BGCOLOR2");var b=$("#P997_GRADIENT_ROTATION").attr("disabled",true);if(a=="T"){d.attr("disabled",true);c.attr("disabled",true)}if(a=="S"){d.removeAttr("disabled");c.attr("disabled",true)}if(a=="G"){d.removeAttr("disabled");c.removeAttr("disabled");b.removeAttr("disabled")}$("#P997_BGTYPE").val(a);$s("P997_BGTYPE",a)}function init_sliders(){$("#values_range_slider").slider({range:"max",min:0,max:360,step:90,value:$("#P997_VALUES_ROTATION").val(),slide:function(a,b){$("#P997_VALUES_ROTATION").val(b.value)}});$("#P997_VALUES_ROTATION").val($("#values_range_slider").slider("value")).bind("keyup",function(){$("#values_range_slider").slider("value",$(this).val())});$("#names_range_slider").slider({range:"max",min:0,max:360,step:90,value:$("#P997_NAMES_ROTATION").val(),slide:function(a,b){$("#P997_NAMES_ROTATION").val(b.value)}});$("#P997_NAMES_ROTATION").val($("#names_range_slider").slider("value")).bind("keyup",function(){$("#names_range_slider").slider("value",$(this).val())})}$(document).ready(function(){var b=$v("pFlowStepId");if(b!=997){return}init_sliders();$(".h_radio, .hh_radio").each(function(){$(this).next("label").next().remove()});$("#P997_CHART_TITLE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_CHART_TITLE_FONT_COLOUR").css("background-color",$("#P997_CHART_TITLE_FONT_COLOUR").val());$("#P997_Y_AXIS_TITLE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_Y_AXIS_TITLE_FONT_COLOUR").css("background-color",$("#P997_Y_AXIS_TITLE_FONT_COLOUR").val());$("#P997_Y_AXIS_VALUE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_Y_AXIS_VALUE_FONT_COLOUR").css("background-color",$("#P997_Y_AXIS_VALUE_FONT_COLOUR").val());$("#P997_X_AXIS_TITLE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_X_AXIS_TITLE_FONT_COLOUR").css("background-color",$("#P997_X_AXIS_TITLE_FONT_COLOUR").val());$("#P997_X_AXIS_NAMES_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_X_AXIS_NAMES_FONT_COLOUR").css("background-color",$("#P997_X_AXIS_NAMES_FONT_COLOUR").val());$("#P997_HINT_TITLE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_HINT_TITLE_FONT_COLOUR").css("background-color",$("#P997_HINT_TITLE_FONT_COLOUR").val());$("#P997_LEGEND_TITLE_FONT_COLOUR").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_LEGEND_TITLE_FONT_COLOUR").css("background-color",$("#P997_LEGEND_TITLE_FONT_COLOUR").val());setBgColors($("#P997_BGTYPE >:checked").val());$("#P997_BGCOLOR1").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_BGCOLOR2").addColorPicker({colorBg:"yes",cursor:"pointer"});$("#P997_BGCOLOR1").css("background-color",$("#P997_BGCOLOR1").val());$("#P997_BGCOLOR2").css("background-color",$("#P997_BGCOLOR2").val());$("#P997_BGTYPE > input").each(function(){$(this).bind("click",function(){setBgColors($(this).val())})});$(".h_radio").each(function(){$(this).bind("click",function(){var c="";$(".h_radio[type=checkbox]").each(function(){if($(this).attr("checked")){c=c+$(this).val()}c=c+":"});$(".h_radio[type=radio]:checked").each(function(){if($(this).attr("checked")){c=c+$(this).val()}c=c+":"});$("#P997_DISPLAY_ATTR").val(c)})});var a=new Array();a=$("#P997_DISPLAY_ATTR").val().split(":");for(i=0;i<12;i++){if(a[i]==="Y"){$("#P997_ATTRIBUTES_"+i).attr("checked","true")}}});function getChartColours(f,a,g){var c=new htmldb_Get(null,html_GetElement("pFlowId").value,"APPLICATION_PROCESS=GET_CHART_COLOURS",0);c.add("IPCC_IP_ID",f);c.add("IPCC_IPS_ID",a);c.add("IPCC_SEQ",g);var e=c.get();if(e){var b=new Array();b=e.split(":");for(var d=0;d<15;d++){$("#color"+d).val("").css("background-color","#FFFFFF")}for(var d=0;d<b.length;d++){$("#color"+d).val(b[d]).css("background-color",b[d])}}$("#colourdialog").dialog("open")}function saveChartColours(){var c="";$(".colourinput").each(function(){var d=$(this);if(d.val().length>0){c=c+d.val()+":"}});var a=new htmldb_Get(null,html_GetElement("pFlowId").value,"APPLICATION_PROCESS=Save_Chart_Colours",0);a.add("G_COLOUR_LIST",c);var b=a.get();if(b=="OK"){}}$(document).ready(function(){var a=$v("pFlowStepId");if(a!=996){return}var b=$("#P996_IP_ID").val();$(".colourinput").each(function(){$(this).addColorPicker({colorBg:"yes",cursor:"pointer"})});$("#colourdialog").dialog({autoOpen:false,resizable:false,title:"Colour Selector",draggable:false,modal:true,position:"center",hide:"slide",show:"slide",buttons:{Cancel:function(){$(this).dialog("close")},Save:function(){$(this).dialog("close");saveChartColours()}}})});