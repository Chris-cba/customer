/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/im4_framework_4500/im4_framework_4500/js/im4_user_pods.js-arc   1.0   Jan 14 2016 21:38:26   Sarah.Williams  $
 --       Module Name      : $Workfile:   im4_user_pods.js  $
 --       Date into PVCS   : $Date:   Jan 14 2016 21:38:26  $
 --       Date fetched Out : $Modtime:   Nov 15 2011 17:54:06  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 --	Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
function setDragDrop(){var b=$("#podtree"),a=$("#podcontainer");$(".podlist li",b).draggable({cancel:"a.ui-icon",revert:"invalid",containment:$("#collistcontainer").length?"#collistcontainer":"document",helper:function(){return $('<li style="background-color:#b0c4de; list-style-type: none;  border-style:solid; margin: 1px 1px 1px 0; padding: 1px; float: left; width: 75px; height: 100px; font-size: 9px; text-align: center; " >'+$(this).html()+"</li>")},cursor:"move"});$(".podlist li",b).bind("dblclick",function(){moveToTrash($(this))});a.droppable({accept:"#batree > li > ul >li",activeClass:"ui-state-highlight",drop:function(c,d){moveToTrash(d.draggable)}})}function moveToTrash(b){var a=$("#podpositions");var c=$("#podpos");b.clone().addClass("dropped").prepend('<a href="#" title="Remove" class="ui-icon ui-icon-trash">Remove</a><br>').appendTo(c).fadeIn(function(){});$(".ui-icon-trash").bind("click",function(){$(this).parent("li").remove().fadeOut()})}function populateTab(){var c=$(".exor_Current").attr("id").substring(4);var a=new htmldb_Get(null,html_GetElement("pFlowId").value,"APPLICATION_PROCESS=getUserTabPods",0);a.add("AI_TAB",c);var b=a.get();$("#podpos").append(b);$(".ui-icon-trash").bind("click",function(){$(this).parent("li").remove().fadeOut()})}function changeTab(a){$(".ui-icon-trash").parent("li").remove().fadeOut();$(".exor_Current").removeClass("exor_Current");$("#tab_"+a).addClass("exor_Current");populateTab()}function savePage(){var d=$(".exor_Current").attr("id").substring(4);var c="";$(".dropped").each(function(e){c=c+$(this).attr("value")+":"});var a=new htmldb_Get(null,html_GetElement("pFlowId").value,"APPLICATION_PROCESS=savepodtabs",0);a.add("AI_TAB",d);a.add("AI_PODS",c);var b=a.get()}function changeConfigTab(a){if(a==="podc"){$("#podc").addClass("cmode_Current");$("#podtabcontainer").show();$("#tabc").removeClass("cmode_Current");$("#tabconfigcontainer").hide()}else{$("#podc").removeClass("cmode_Current");$("#podtabcontainer").hide();$("#tabc").addClass("cmode_Current");$("#tabconfigcontainer").show()}}$(document).ready(function(){var a=$v("pFlowStepId");if(a!=800){return}$("#tabconfigcontainer").toggle();setDragDrop();$("#clearall").button().bind("click",function(){$(".ui-icon-trash").parent("li").remove().fadeOut()});$("#reset").button().bind("click",function(){$(".ui-icon-trash").parent("li").remove().fadeOut();populateTab()});$("#save").button().bind("click",function(){savePage()});populateTab()});