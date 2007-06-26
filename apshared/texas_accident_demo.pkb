CREATE OR REPLACE PACKAGE BODY texas_accident_demo IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)texas_accident_demo.pkb	1.1 03/15/05
--       Module Name      : texas_accident_demo.pkb
--       Date into SCCS   : 05/03/15 22:46:46
--       Date fetched Out : 07/06/06 14:36:35
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)texas_accident_demo.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT VARCHAR2(30) := 'texas_accident_demo';
   c_date_mask CONSTANT VARCHAR2(10)    := 'MM/DD/YYYY';
   c_acc       CONSTANT VARCHAR2(4)     := 'ACC';
   c_cas       CONSTANT VARCHAR2(4)     := 'CAS';
   c_veh       CONSTANT VARCHAR2(4)     := 'VEH';
   c_menu_module    CONSTANT VARCHAR2(30)    := 'CRIS0001';
   c_view_module    CONSTANT VARCHAR2(30)    := 'CRIS0002';
   c_new_module     CONSTANT VARCHAR2(30)    := 'CRIS0003';
   c_find_module    CONSTANT VARCHAR2(30)    := 'CRIS0004';
--
-----------------------------------------------------------------------------------
--
FUNCTION get_acc (pi_acc_id NUMBER) RETURN acc_items_all%ROWTYPE;
--
-----------------------------------------------------------------------------------
--
FUNCTION get_veh (pi_acc_id NUMBER, pi_seq NUMBER DEFAULT 1) RETURN acc_items_all%ROWTYPE;
--
-----------------------------------------------------------------------------------
--
FUNCTION get_resultsetoddeven (pi_number NUMBER) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_domain_as_options (p_aad_id VARCHAR2, p_value VARCHAR2 DEFAULT NULL);
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_image_map;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_pending_Accs;
--
-----------------------------------------------------------------------------------
--
PROCEDURE image_submit_button (p_form_name    VARCHAR2
                              ,p_image_name   VARCHAR2
                              ,p_image_width  NUMBER
                              ,p_image_height NUMBER
                              );
--
-----------------------------------------------------------------------------------
--
PROCEDURE maximise_browser;
--
-----------------------------------------------------------------------------------
--
FUNCTION display_val_if_acc_id (p_acc_id NUMBER, p_value VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------------
--
FUNCTION display_title_if_acc_id (p_acc_id NUMBER) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_tab_bar (pi_acc_id NUMBER,p_page NUMBER);
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------------
--
PROCEDURE home IS
   CURSOR cs_recent_accs (p_tolerance NUMBER DEFAULT 7) IS
   SELECT *
    FROM  acc_items_all
   WHERE  acc_ait_id     = 'ACC'
    AND   acc_id        != 0
    AND   acc_start_date >= TRUNC(SYSDATE)-p_tolerance
    AND   rownum         <= 10
   ORDER BY acc_start_date DESC;
   l_rec_hus hig_users%ROWTYPE;
--   CURSOR cs_tum (c_user_id NUMBER) IS
--   SELECT *
--    FROM  texas_user_messages
--   WHERE  tum_hus_user_id = c_user_id;
BEGIN
--
   nm_debug.proc_start(g_package_name,'home');
--
   nm3web.user_can_run_module_web (c_menu_module);
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=225;');
   htp.p('		formPicture.style.height=150;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=75;');
   htp.p('		formPicture.style.height=300;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=420;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=225;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map"></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   l_rec_hus := nm3user.get_hus(pi_hus_username=>USER);
   htp.p('    <td class="HomePageTitle">Welcome, John Davidson</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td><table width="175" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Menu Favorites</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('          <td><table width="780" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Message Queue</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('          <td width="175" valign="top" class="BodyTableHomePage">');
   htp.p('            <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 100px">');
   htp.p('              <table width="100%" border="0" cellpadding="4" cellspacing="0" class="Favorites">');
   htp.p('<tr>');
   htp.p('                  <td>'||CHR(38)||'nbsp;<img src="'||nm3web.get_download_url('BulletStar.gif')||'" width="7" height="7" align="absmiddle">'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;<a href="'||g_package_name||'.data_entry" class="Favorites">Enter ');
   htp.p('                    New Crash Record</a></td>');
   htp.p('                </tr>');
   htp.p('                <tr>');
   htp.p('                  <td>'||CHR(38)||'nbsp;<img src="'||nm3web.get_download_url('BulletStar.gif')||'" width="7" height="7" align="absmiddle">'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;<a href="'||g_package_name||'.find_accident" class="Favorites">Retrieve ');
   htp.p('                    Crash Record</a></td>');
   htp.p('                </tr>');
   htp.p('                <tr>');
   htp.p('                  <td>'||CHR(38)||'nbsp;<img src="'||nm3web.get_download_url('BulletStar.gif')||'" width="7" height="7" align="absmiddle">'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;Map ');
   htp.p('                    Services</td>');
   htp.p('                </tr>');
   htp.p('                <tr>');
   htp.p('                  <td>'||CHR(38)||'nbsp;<img src="'||nm3web.get_download_url('BulletStar.gif')||'" width="7" height="7" align="absmiddle">'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;Accident ');
   htp.p('                    Diagramming Tool</td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="20" height="10"></td>');
   htp.p('          <td width="780" class="BodyTableHomePage">');
   htp.p('              <table width="780" border="0" cellpadding="0" cellspacing="0">');
   htp.p('              <tr> ');
   htp.p('                <td width="94" class="ResultSetSorted">Date Received</td>');
   htp.p('                <td width="399" class="ResultSetUnsorted">Subject</td>');
   htp.p('                <td width="157" class="ResultSetUnsorted">Sent By</td>');
   htp.p('                <td width="90" class="ResultSetUnsorted">Priority</td>');
   htp.p('                <td width="20" class="ResultSetUnsorted"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('                <td width="20" class="ResultSetRightColumn"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('              </tr>');
   htp.p('            </table>');
   htp.p('              <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 100px"> ');
   htp.p('                ');
   htp.p('              <table width="760" border="0" cellpadding="0" cellspacing="0" class="ResultSetResults">');
--   FOR cs_rec IN cs_tum (l_rec_hus.hus_user_id)
--    LOOP
--      htp.p('                <tr class="'||get_resultsetoddeven(cs_tum%ROWCOUNT)||'"> ');
--      htp.p('                  <td width="102">'||CHR(38)||'nbsp;'||to_char(cs_rec.tum_start_date,c_date_mask)||'</td>');
--      htp.p('                  <td width="383">'||cs_rec.tum_message||'</td>');
--      htp.p('                  <td width="157">'||nm3user.get_hus(pi_hus_user_id=>cs_rec.tum_sender_hus_user_id).hus_name||'</td>');
--      htp.p('                  <td width="98">'||cs_rec.tum_priority||'</td>');
--      htp.p('                  <td width="20"><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17"></td>');
--      htp.p('                </tr>');
--   END LOOP;
   htp.p('                <tr class="ResultSetOdd"> ');
   htp.p('                  <td width="102">'||CHR(38)||'nbsp;03/23/2003</td>');
   htp.p('                  <td width="383">Need to update your time card.</td>');
   htp.p('                  <td width="157">Officer Thompson</td>');
   htp.p('                  <td width="98">Normal</td>');
   htp.p('                  <td width="20"><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17"></td>');
   htp.p('                </tr>');
   htp.p('                <tr class="ResultSetEven"> ');
   htp.p('                  <td>'||CHR(38)||'nbsp;03/23/2003</td>');
   htp.p('                  <td>Officers meeting on the 23rd cancelled.</td>');
   htp.p('                  <td>Chief Johnson</td>');
   htp.p('                  <td>High</td>');
   htp.p('                  <td><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17"></td>');
   htp.p('                </tr>');
   htp.p('                <tr class="ResultSetOdd"> ');
   htp.p('                  <td>'||CHR(38)||'nbsp;03/23/2003</td>');
   htp.p('                  <td>Please see detailed information on submitting a report.</td>');
   htp.p('                  <td>Chief Johnson</td>');
   htp.p('                  <td>High</td>');
   htp.p('                  <td><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Pending Reports</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   do_pending_accs;
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Recent Accidents</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('          <td colspan="3" class="BodyTableHomePage"> <table width="975" border="0" cellspacing="0" cellpadding="0">');
   htp.p('              <tr> ');
   htp.p('                <td width="95" class="ResultSetSorted">Date Filed</td>');
   htp.p('                <td width="403" class="ResultSetUnsorted">Description</td>');
   htp.p('                <td width="171" class="ResultSetUnsorted">Filed By</td>');
   htp.p('                <td width="95" class="ResultSetUnsorted">Court Date</td>');
   htp.p('                <td width="167" class="ResultSetUnsorted">County</td>');
   htp.p('                <td width="23" class="ResultSetUnsorted"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('                <td width="20" class="ResultSetRightColumn"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('              </tr>');
   htp.p('            </table>');
   htp.p('            <DIV id="pendingReports" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 75px"> ');
   htp.p('              <table width="955" border="0" cellpadding="0" cellspacing="0" class="ResultSetResults">');
   FOR cs_rec IN cs_recent_accs (150)
    LOOP
      htp.p('                <tr class="'||get_resultsetoddeven(cs_recent_accs%ROWCOUNT)||'"> ');
      htp.p('                  <td width="103">'||nm3web.c_nbsp||to_char(cs_rec.acc_start_date,c_date_mask)||'</td>');
      htp.p('                  <td width="389">'||accdisc.get_attr_value(cs_rec.acc_id,'ADES',c_acc)||'</td>');
      htp.p('                  <td width="172">Officer Briggs</td>');
      htp.p('                  <td width="96">05/15/2003</td>');
      htp.p('                  <td width="169">Travis</td>');
      htp.p('                  <td width="26"><a href="'||g_package_name||'.accident1?pi_acc_id='||cs_rec.acc_id||'"><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17" border="0"></a></td>');
      htp.p('                </tr>');
   END LOOP;
   htp.p('              </table>');
   htp.p('            </div>');
   htp.p('            </td>');
   htp.p('          <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="5" class="FormButtons"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('</table>');
   do_image_map;
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'home');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END home;
--
-----------------------------------------------------------------------------------
--
PROCEDURE accident1 (pi_acc_id NUMBER DEFAULT NULL) IS
--
   l_rec_acc acc_items_all%ROWTYPE;
   l_rec_veh acc_items_all%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'accident1');
--
   nm3web.user_can_run_module_web (c_view_module);
   l_rec_acc := get_acc (pi_acc_id => pi_acc_id);
   l_rec_veh := get_veh (pi_acc_id => pi_acc_id);
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.height=140;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=65;');
   htp.p('		formPicture.style.height=280;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inliAne'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=390;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map"></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   htp.p('    <td class="HomePageTitle">'||display_title_if_acc_id(pi_acc_id)||'</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   do_tab_bar (pi_acc_id,1);
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 390px"> ');
   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="8"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="8" class="tableHeaders">Where Accident Occured</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="81" height="29" class="formlabels">County:</td>');
   htp.p('                  <td height="29" colspan="3"><input name="textfield2" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Travis')||'" size="20"></td>');
   htp.p('                  <td width="125" height="29" class="formlabels">City or Town:</td>');
   htp.p('                  <td width="230" height="29"><input name="textfield22" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="20"></td>');
   htp.p('                  <td width="89" height="29" class="formlabels">Location #:</td>');
   htp.p('                  <td width="106"><input name="textfield2322222" type="text" disabled value="'||display_val_if_acc_id(pi_acc_id,'12')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="8" class="tableHeaders">If Accident was Outside ');
   htp.p('                    City Limits, Indicate Distance From Nearest Town</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Miles:</td>');
   htp.p('                  <td width="61" height="29"><input name="textfield23" type="text" size="1"></td>');
   htp.p('                  <td width="123" height="29" class="formlabels">Direction:</td>');
   htp.p('                  <td width="160" height="29"><select name="select">');
   htp.p('                      <option>N</option>');
   htp.p('                      <option>E</option>');
   htp.p('                      <option>S</option>');
   htp.p('                      <option>W</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" class="formlabels">Of City or Town:</td>');
   htp.p('                  <td height="29"><input name="textfield222" type="text" size="20"></td>');
   htp.p('                  <td height="29" colspan="2">'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="10" class="tableHeaders">Road on Which Accident ');
   htp.p('                    Occured</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="80" height="29" class="formlabels">Block #:</td>');
   htp.p('                  <td width="62" height="29"><input name="textfield2322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'200')||'" size="2"></td>');
   htp.p('                  <td width="123" height="29" class="formlabels">Street or Road ');
   htp.p('                    Name:</td>');
   htp.p('                  <td width="159" height="29"><input name="textfield2232" type="text" value="'||display_val_if_acc_id(pi_acc_id,l_rec_acc.acc_local_ref)||'" size="20"></td>');
   htp.p('                  <td width="126" height="29" class="formlabels">Route # or St. ');
   htp.p('                    Code:</td>');
   htp.p('                  <td width="76" height="29"><input name="textfield23222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'213')||'" size="5"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="78" height="29" class="formlabels">Const Zone:</td>');
   htp.p('                  <td width="76" height="29"> <select name="select4">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option selected>No</option>');
   htp.p('                    </select> </td>');
   htp.p('                  <td width="88" height="29" class="formlabels">Speed Limit:</td>');
   htp.p('                  <td width="107" height="29"><input name="textfield232222" type="text" value="'||display_val_if_acc_id(pi_acc_id,''||accdisc.get_attr_value(pi_acc_id,'ASL1',c_acc))||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="10" class="tableHeaders">Intersecting Street</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Block #:</td>');
   htp.p('                  <td height="29"><input name="textfield2322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'400')||'" size="2"></td>');
   htp.p('                  <td height="29" class="formlabels">Street or Road Name:</td>');
   htp.p('                  <td height="29"><input name="textfield2232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'')||'" size="20"></td>');
   htp.p('                  <td height="29" class="formlabels">Route # or St. Code:</td>');
   htp.p('                  <td height="29"><input name="textfield23222" type="text" size="5"> ');
   htp.p('                  </td>');
   htp.p('                  <td height="29" class="formlabels">Const Zone:</td>');
   htp.p('                  <td height="29"> <select name="select4">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select> </td>');
   htp.p('                  <td height="29" class="formlabels">Speed Limit:</td>');
   htp.p('                  <td height="29"><input name="textfield232222" type="text" size="2" value="'||display_val_if_acc_id(pi_acc_id,''||accdisc.get_attr_value(pi_acc_id,'ASL2',c_acc))||'"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="10" class="tableHeaders">Not at Intersection</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Feet/Miles:</td>');
   htp.p('                  <td height="29"><select name="select2">');
   htp.p('                      <option>Ft</option>');
   htp.p('                      <option>Mi</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" class="formlabels">Direction:</td>');
   htp.p('                  <td height="29"><select name="select3">');
   htp.p('                      <option>N</option>');
   htp.p('                      <option>E</option>');
   htp.p('                      <option>S</option>');
   htp.p('                      <option>W</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" class="formlabels">Of City or Town:</td>');
   htp.p('                  <td height="29" colspan="5"><input name="textfield2222" type="text" size="20"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="1"></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td colspan="2"></td>');
   htp.p('                  <td colspan="3"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="10" class="tableHeaders">Date of Accident</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="80" height="29" class="formlabels">Date:</td>');
   htp.p('                  <td width="79" height="29"><input name="textfield23223" type="text" value="'||display_val_if_acc_id(pi_acc_id,''||to_char(l_rec_acc.acc_start_date,c_date_mask))||'" size="5"></td>');
   htp.p('                  <td width="123" height="29" class="formlabels">Day of Week:</td>');
   htp.p('                  <td width="159" height="29"><select name="select7">');
   DECLARE
      l_day VARCHAR2(254) := accdisc.get_attr_value(pi_acc_id,'ADAY',c_acc);
      l_text VARCHAR2(10);
      l_selected VARCHAR2(10);
   BEGIN
      FOR i IN 0..6
       LOOP
         l_text := TO_CHAR(TO_DATE('04/05/2003','DD/MM/YYYY')+i,'Day');
         --###########################################################
         -- Cheating - Should be using ADAY attribute
         --###########################################################
         l_selected := nm3flx.i_t_e(TO_CHAR(l_rec_acc.acc_start_date,'Day')=l_text,' selected',Null);
         htp.p('                      <option'||l_selected||'>'||RTRIM(l_text)||'</option>');
      END LOOP;
   END;
   htp.p('                    </select></td>');
   htp.p('                  <td width="125" height="29" class="formlabels">Time:</td>');
   DECLARE
      l_atim VARCHAR2(254) := accdisc.get_attr_value(pi_acc_id,'ATIM',c_acc);
      l_selected_am       VARCHAR2(9);
      l_selected_pm       VARCHAR2(9);
      l_selected_noon     VARCHAR2(9);
      l_selected_not_noon VARCHAR2(9);
   BEGIN
      IF l_atim < 1200
       THEN
         l_selected_am       := ' selected';
         l_selected_not_noon := l_selected_am;
      ELSIF l_atim = 1200
       THEN
         l_selected_pm   := ' selected';
         l_selected_noon := l_selected_pm;
      ELSE
         l_selected_pm       := ' selected';
         l_selected_not_noon := l_selected_pm;
      END IF;
      --l_atim := TO_CHAR(TRUNC(SYSDATE)+(l_atim/1440),'HH:MI');
      l_atim := to_char(sysdate,c_date_mask)||to_char(TO_NUMBER(l_atim),'0000');
      l_atim := to_char(to_date(l_atim,c_date_mask||'HH24MI'),'HH:MI');
      htp.p('                  <td width="142" height="29"><input name="textfield232223" type="text" value="'||display_val_if_acc_id(pi_acc_id,''||l_atim)||'" size="5"> ');
      htp.p('                    <select name="select6">');
      htp.p('                      <option'||l_selected_am||'>AM</option>');
      htp.p('                      <option'||l_selected_pm||'>PM</option>');
      htp.p('                    </select> </td>');
      htp.p('                  <td width="89" height="29" class="formlabels">Exactly Noon:</td>');
      htp.p('                  <td height="29" colspan="3"> <select name="select5">');
      htp.p('                      <option'||l_selected_noon||'>Yes</option>');
      htp.p('                      <option'||l_selected_not_noon||'>No</option>');
   END;
   htp.p('                    </select> </td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="1"></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td></td>');
   htp.p('                  <td colspan="2"></td>');
   htp.p('                  <td width="195" colspan="3"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Unit #1 Motor Vehicle ');
   htp.p('                    Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Vehicle ID Number:</td>');
   htp.p('                  <td height="29" colspan="2"><input name="textfield22322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'JNF345KLOL5564IOOI')||'" size="20"></td>');
   htp.p('                  <td height="29" colspan="2" class="formlabels">If Van or Bus, ');
   htp.p('                    Capacity:</td>');
   htp.p('                  <td height="29" colspan="4"><input name="textfield2322323" type="text" size="1"></td>');
   htp.p('                  <td width="46" height="29" class="formlabels"><div align="left">Year</div></td>');
   htp.p('                  <td width="48" height="29" class="formlabels"><div align="left">State</div></td>');
   htp.p('                  <td width="58" height="29" class="formlabels"><div align="left">Number</div></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="103" height="29" class="formlabels">Year Model:</td>');
   htp.p('                  <td width="70" height="29"><input name="textfield232232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'1992')||'" size="3"></td>');
   htp.p('                  <td width="87" class="formlabels">Color '||CHR(38)||'amp; Make:</td>');
   htp.p('                  <td width="92" height="29"> <input name="textfield2322322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Silver Dodge')||'" size="10"></td>');
   htp.p('                  <td width="85" height="29" class="formlabels">Model Name:</td>');
   htp.p('                  <td width="103" height="29"><input name="textfield23223222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Viper')||'" size="10"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="80" height="29" class="formlabels">Body Style:</td>');
   htp.p('                  <td width="105" height="29"><input name="textfield232232222" type="text" value="'||display_val_if_acc_id(pi_acc_id,''||accdisc.get_attr_value(l_rec_veh.acc_id,'VTYP',c_veh))||'" size="10"></td>');
   htp.p('                  <td width="98" class="formlabels">License Plate:</td>');
   htp.p('                  <td height="29"> <input name="textfield23223232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'2002')||'" size="2"> ');
   htp.p('                  </td>');
   htp.p('                  <td height="29"><input name="textfield23223233" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td height="29"><input name="textfield23223234" type="text" value="'||display_val_if_acc_id(pi_acc_id,'BGR-601')||'" size="4"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              ');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureTab" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">ST-3 Image</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('iplusN.gif')||'" width="17" height="17" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage'||CHR(39)||','||CHR(39)||'max'||CHR(39)||')"><img src="'||nm3web.get_download_url('iMinusN.gif')||'" width="17" height="17" hspace="4" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage.form200'||CHR(39)||','||CHR(39)||'min'||CHR(39)||')"></td>');
   htp.p('                <td><A href="javascript:resizePictureAndForm()"><img src="'||nm3web.get_download_url('ExpandButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureSpacer" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formPicture" style="DISPLAY:NONE; PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 150px"> ');
   htp.p('              <div align="center"><img src="'||nm3web.get_download_url('formPage1.gif')||'" name="formimage" width="950" height="1229" id="formimageid"> ');
   htp.p('              </div>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3" class="FormButtons"><a href="'||g_package_name||'.accident2?pi_acc_id='||pi_acc_id||'"><img src="'||nm3web.get_download_url('button_next.gif')||'" width="77" height="32" border="0"></a></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('</table>');
   do_image_map;
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'accident1');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END accident1;

PROCEDURE accident2 (pi_acc_id NUMBER DEFAULT NULL) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'accident2');
--
   nm3web.user_can_run_module_web (c_view_module);
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.height=140;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=65;');
   htp.p('		formPicture.style.height=280;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=390;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map"></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   htp.p('    <td class="HomePageTitle">'||display_title_if_acc_id(pi_acc_id)||' - Page 2</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   do_tab_bar (pi_acc_id,2);
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 390px"> ');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="14"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="14" class="tableHeaders">Driver'||CHR(39)||'s Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="86" height="29" class="formlabels">Last Name:</td>');
   htp.p('                  <td width="79" height="29"> ');
   htp.p('                    <input name="textfield2322324" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Freed')||'" size="10"></td>');
   htp.p('                  <td width="69" class="formlabels">First Name:</td>');
   htp.p('                  <td width="84" height="29"> ');
   htp.p('                    <input name="textfield23223223" type="text" value="'||display_val_if_acc_id(pi_acc_id,'William')||'" size="10"></td>');
   htp.p('                  <td width="74" height="29" class="formlabels">Middle Name:</td>');
   htp.p('                  <td width="58" height="29"> ');
   htp.p('                    <input name="textfield232232223" type="text" size="3"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="73" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td width="152" height="29"> ');
   htp.p('                    <input name="textfield2322322222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'334 Blackmon Street')||'" size="20"></td>');
   htp.p('                  <td width="47" class="formlabels">City:</td>');
   htp.p('                  <td width="60" height="29"> ');
   htp.p('                    <input name="textfield232232322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="7"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="45" height="29" class="formlabels">State:</td>');
   htp.p('                  <td width="34" height="29">');
   htp.p('                    <input name="textfield232232342" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td width="38" class="formlabels">Zip:</td>');
   htp.p('                  <td width="68"><input name="textfield2322323222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'75013')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="28" class="formlabels"> License State:</td>');
   htp.p('                  <td height="28"><input name="textfield232232332" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td class="formlabels">Lic. Number:</td>');
   htp.p('                  <td height="28"><input name="textfield23223242" type="text" value="'||display_val_if_acc_id(pi_acc_id,'13488098')||'" size="6"></td>');
   htp.p('                  <td height="28" class="formlabels">Class/Type:</td>');
   htp.p('                  <td height="28"><select name="select8">');
   htp.p('                      <option selected>A</option>');
   htp.p('                      <option>B</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="28" class="formlabels">Occupation:</td>');
   htp.p('                  <td height="28"><input name="textfield23223222222" type="text" size="15"></td>');
   htp.p('                  <td class="formlabels">DOB:</td>');
   htp.p('                  <td height="28"><input name="textfield2322332" type="text" value="'||display_val_if_acc_id(pi_acc_id,'12/23/1967')||'" size="5"></td>');
   htp.p('                  <td height="28" class="formlabels">Race:</td>');
   htp.p('                  <td height="28"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                  <td class="formlabels">Sex:</td>');
   htp.p('                  <td><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('<tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Other Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" colspan="3" class="formlabels">Specimen Taken ');
   htp.p('                    (Alcohol/Drug Analysis):</td>');
   htp.p('                  <td width="9%" height="29"> ');
   htp.p('                    <select name="select2">');
   htp.p('                      <option>Breath</option>');
   htp.p('                      <option>Blood</option>');
   htp.p('                      <option>Other</option>');
   htp.p('                      <option>None</option>');
   htp.p('                      <option>Refused</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="14%" class="formlabels">Alcohol Analysis Result:</td>');
   htp.p('                  <td width="13%" height="29"> ');
   htp.p('                    <input name="textfield232232232" type="text" size="20"></td>');
   htp.p('                  <td height="29" colspan="5" class="formlabels">Peace Officer, ');
   htp.p('                    EMS Driver, Fire Fighter on Emergency?</td>');
   htp.p('                  <td width="10%" height="29"> ');
   htp.p('                    <select name="select3">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select> </td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="100" height="29" class="formlabels">Owner:</td>');
   htp.p('                  <td width="88"> ');
   htp.p('                    <select name="select">');
   htp.p('                      <option>Lessee</option>');
   htp.p('                      <option>Owner</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="56" class="formlabels">Name:</td>');
   htp.p('                  <td width="206" height="29"> ');
   htp.p('                    <input name="textfield2322322322" type="text" size="25"></td>');
   htp.p('                  <td width="73" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td width="151" height="29"> <input name="textfield23223222224" type="text" value="'||display_val_if_acc_id(pi_acc_id,'334 Blackmon Street')||'" size="20"></td>');
   htp.p('                  <td width="48" height="29" class="formlabels">City:</td>');
   htp.p('                  <td width="61" height="29"> <input name="textfield23223232232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="7"></td>');
   htp.p('                  <td width="43" height="29" class="formlabels">State:</td>');
   htp.p('                  <td width="37" height="29"> <input name="textfield2322323423" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td width="37" class="formlabels">Zip:</td>');
   htp.p('                  <td width="67"> <input name="textfield23223232223" type="text" value="'||display_val_if_acc_id(pi_acc_id,'75013')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="99" height="29" class="formlabels">Liability Insurance:</td>');
   htp.p('                  <td width="89"> ');
   htp.p('                    <select name="select4">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="56" class="formlabels">Insurance Name:</td>');
   htp.p('                  <td width="190" height="29"> ');
   htp.p('                    <input name="textfield23223223222" type="text" size="25"></td>');
   htp.p('                  <td width="89" height="29" class="formlabels">Policy Number:</td>');
   htp.p('                  <td width="150" height="29"> ');
   htp.p('                    <input name="textfield232232222242" type="text" size="10"></td>');
   htp.p('                  <td width="153" height="29" class="formlabels">Vehicle Damage ');
   htp.p('                    Rating :</td>');
   htp.p('                  <td width="141" height="29"> <input name="textfield2322322222422" type="text" size="10"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Unit #2 Motor Vehicle ');
   htp.p('                    Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Vehicle Type:</td>');
   htp.p('                  <td height="29" colspan="2"><select name="select5">');
   htp.p('                      <option>Motor Vehicle</option>');
   htp.p('                      <option>Train</option>');
   htp.p('                      <option>PedalCyclist</option>');
   htp.p('                      <option>Towed</option>');
   htp.p('                      <option>Pedestrian</option>');
   htp.p('                      <option>Other</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" colspan="2" class="formlabels">Vehicle ID Number: ');
   htp.p('                  </td>');
   htp.p('                  <td height="29"> ');
   htp.p('                    <input name="textfield22322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'JNF345KLOL5564IOOI')||'" size="20"></td>');
   htp.p('                  <td height="29" class="formlabels">If Van or Bus, Capacity:</td>');
   htp.p('                  <td height="29"><input name="textfield2322323" type="text" size="1"></td>');
   htp.p('                  <td height="29"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                  <td width="43" height="29" class="formlabels">');
   htp.p('                    <div align="left">Year</div></td>');
   htp.p('                  <td width="45" height="29" class="formlabels">');
   htp.p('                    <div align="left">State</div></td>');
   htp.p('                  <td width="60" height="29" class="formlabels">');
   htp.p('                    <div align="left">Number</div></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="100" height="29" class="formlabels">Year Model:</td>');
   htp.p('                  <td width="46" height="29"> ');
   htp.p('                    <input name="textfield232232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'1992')||'" size="3"></td>');
   htp.p('                  <td width="84" class="formlabels">Color '||CHR(38)||'amp; Make:</td>');
   htp.p('                  <td width="81" height="29"> ');
   htp.p('                    <input name="textfield2322322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Silver Dodge')||'" size="10"></td>');
   htp.p('                  <td width="81" height="29" class="formlabels">Model Name:</td>');
   htp.p('                  <td width="146" height="29"> ');
   htp.p('                    <input name="textfield23223222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Viper')||'" size="10"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="85" height="29" class="formlabels">Body Style:</td>');
   htp.p('                  <td width="94" height="29"> ');
   htp.p('                    <input name="textfield232232222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'R/T')||'" size="10"></td>');
   htp.p('                  <td width="102" class="formlabels">License Plate:</td>');
   htp.p('                  <td height="29"> <input name="textfield23223232" type="text" value="'||display_val_if_acc_id(pi_acc_id,'2002')||'" size="2"> ');
   htp.p('                  </td>');
   htp.p('                  <td height="29"><input name="textfield23223233" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td height="29"><input name="textfield23223234" type="text" value="'||display_val_if_acc_id(pi_acc_id,'BGR-601')||'" size="4"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="14"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="14" class="tableHeaders">Driver'||CHR(39)||'s Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="86" height="29" class="formlabels">Last Name:</td>');
   htp.p('                  <td width="79" height="29"> <input name="textfield23223243" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Freed')||'" size="10"></td>');
   htp.p('                  <td width="69" class="formlabels">First Name:</td>');
   htp.p('                  <td width="84" height="29"> <input name="textfield232232233" type="text" value="'||display_val_if_acc_id(pi_acc_id,'William')||'" size="10"></td>');
   htp.p('                  <td width="74" height="29" class="formlabels">Middle Name:</td>');
   htp.p('                  <td width="58" height="29"> <input name="textfield2322322232" type="text" size="3"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="73" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td width="152" height="29"> <input name="textfield23223222223" type="text" value="'||display_val_if_acc_id(pi_acc_id,'334 Blackmon Street')||'" size="20"></td>');
   htp.p('                  <td width="47" class="formlabels">City:</td>');
   htp.p('                  <td width="60" height="29"> <input name="textfield2322323223" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="7"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="45" height="29" class="formlabels">State:</td>');
   htp.p('                  <td width="34" height="29"> <input name="textfield2322323422" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td width="38" class="formlabels">Zip:</td>');
   htp.p('                  <td width="68"><input name="textfield23223232222" type="text" value="'||display_val_if_acc_id(pi_acc_id,'75013')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="28" class="formlabels"> License State:</td>');
   htp.p('                  <td height="28"><input name="textfield2322323322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td class="formlabels">Lic. Number:</td>');
   htp.p('                  <td height="28"><input name="textfield232232422" type="text" value="'||display_val_if_acc_id(pi_acc_id,'13488098')||'" size="6"></td>');
   htp.p('                  <td height="28" class="formlabels">Class/Type:</td>');
   htp.p('                  <td height="28"><select name="select6">');
   htp.p('                      <option selected>A</option>');
   htp.p('                      <option>B</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="28" class="formlabels">Occupation:</td>');
   htp.p('                  <td height="28"><input name="textfield232232222222" type="text" size="15"></td>');
   htp.p('                  <td class="formlabels">DOB:</td>');
   htp.p('                  <td height="28"><input name="textfield23223322" type="text" value="'||display_val_if_acc_id(pi_acc_id,'12/23/1967')||'" size="5"></td>');
   htp.p('                  <td height="28" class="formlabels">Race:</td>');
   htp.p('                  <td height="28"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                  <td class="formlabels">Sex:</td>');
   htp.p('                  <td><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              ');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureTab" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Accident Report Image</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('iplusN.gif')||'" width="17" height="17" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage'||CHR(39)||','||CHR(39)||'max'||CHR(39)||')"><img src="'||nm3web.get_download_url('iMinusN.gif')||'" width="17" height="17" hspace="4" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage.form200'||CHR(39)||','||CHR(39)||'min'||CHR(39)||')"></td>');
   htp.p('                <td><A href="javascript:resizePictureAndForm()"><img src="'||nm3web.get_download_url('ExpandButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureSpacer" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formPicture" style="DISPLAY:NONE; PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 150px"> ');
   htp.p('              <div align="center"><img src="'||nm3web.get_download_url('formPage1.gif')||'" name="formimage" width="950" height="1229" id="formimageid"> ');
   htp.p('              </div>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3" class="FormButtons"><a href="'||g_package_name||'.accident1?pi_acc_id='||pi_acc_id||'"><img src="'||nm3web.get_download_url('button_previous.gif')||'" width="77" height="32" border="0"></a>'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;<a href="'||g_package_name||'.accident3?pi_acc_id='||pi_acc_id||'"><img src="'||nm3web.get_download_url('button_next.gif')||'" width="77" height="32" border="0"></a></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('</table>');
   do_image_map;
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'accident2');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END accident2;




PROCEDURE accident3 (pi_acc_id NUMBER DEFAULT NULL) IS
   l_rec_acc acc_items_all%ROWTYPE;
   c_form_name CONSTANT VARCHAR2(30) := 'upd_acc';
BEGIN
--
   nm_debug.proc_start(g_package_name,'accident3');
--
   nm3web.user_can_run_module_web (c_view_module);
--
   l_rec_acc := get_acc (pi_acc_id);
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.height=140;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=65;');
   htp.p('		formPicture.style.height=280;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=390;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map"></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   htp.p('    <td class="HomePageTitle">'||display_title_if_acc_id(pi_acc_id)||' - Page 3</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   do_tab_bar (pi_acc_id,3);
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 390px"> ');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr>');
   htp.p('                  <td colspan="12"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Other Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.formOpen(curl => g_package_name||'.update_pending_reason',cattributes=>'NAME="'||c_form_name||'"');
   htp.formhidden(cname=>'pi_acc_id',cvalue=>pi_acc_id);
   htp.p('                  <td height="29" colspan="3" class="formlabels">'||nm3web.c_nbsp||'Pending Reason:</td>');
   htp.p('                  <td width="9%" height="29"> <select name="pi_pending_reason">');
   FOR cs_rec IN (SELECT hco_code
                        ,hco_meaning
                        ,DECODE(hco_code,l_rec_acc.acc_status,' selected',Null) selected
                   FROM  hig_codes
                  WHERE  hco_domain = 'PENDING_REASON'
                 )
    LOOP
      htp.p('                      <option VALUE="'||cs_rec.hco_code||'"'||cs_rec.selected||'>'||cs_rec.hco_meaning||'</option>');
   END LOOP;
   htp.p('                    </select></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" colspan="3" class="formlabels">Specimen Taken ');
   htp.p('                    (Alcohol/Drug Analysis):</td>');
   htp.p('                  <td width="9%" height="29"> <select name="">');
   htp.p('                      <option>Breath</option>');
   htp.p('                      <option>Blood</option>');
   htp.p('                      <option>Other</option>');
   htp.p('                      <option>None</option>');
   htp.p('                      <option>Refused</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="14%" class="formlabels">Alcohol Analysis Result:</td>');
   htp.p('                  <td width="13%" height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td height="29" colspan="5" class="formlabels">Peace Officer, ');
   htp.p('                    EMS Driver, Fire Fighter on Emergency?</td>');
   htp.p('                  <td width="10%" height="29"> <select name="">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select> </td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="100" height="29" class="formlabels">Owner:</td>');
   htp.p('                  <td width="88"> <select name="">');
   htp.p('                      <option>Lessee</option>');
   htp.p('                      <option>Owner</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="60" class="formlabels">Name:</td>');
   htp.p('                  <td width="202" height="29"> ');
   htp.p('                    <input name="" type="text" size="25"></td>');
   htp.p('                  <td width="73" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td width="151" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'334 Blackmon Street')||'" size="20"></td>');
   htp.p('                  <td width="48" height="29" class="formlabels">City:</td>');
   htp.p('                  <td width="61" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="7"></td>');
   htp.p('                  <td width="43" height="29" class="formlabels">State:</td>');
   htp.p('                  <td width="37" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td width="37" class="formlabels">Zip:</td>');
   htp.p('                  <td width="67"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'75013')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="99" height="29" class="formlabels">Liability Insurance:</td>');
   htp.p('                  <td width="89"> <select name="">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td width="56" class="formlabels">Insurance Name:</td>');
   htp.p('                  <td width="190" height="29"> <input name="" type="text" size="25"></td>');
   htp.p('                  <td width="89" height="29" class="formlabels">Policy Number:</td>');
   htp.p('                  <td width="150" height="29"> <input name="" type="text" size="10"></td>');
   htp.p('                  <td width="153" height="29" class="formlabels">Vehicle Damage ');
   htp.p('                    Rating :</td>');
   htp.p('                  <td width="141" height="29"> <input name="" type="text" size="10"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Damage to Other Property</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="36" height="1"></td>');
   htp.p('                  <td width="1"></td>');
   htp.p('                  <td width="23"></td>');
   htp.p('                  <td width="162"></td>');
   htp.p('                  <td width="55"></td>');
   htp.p('                  <td width="121"></td>');
   htp.p('                  <td width="176"></td>');
   htp.p('                  <td width="60"></td>');
   htp.p('                  <td width="52"></td>');
   htp.p('                  <td width="96"></td>');
   htp.p('                  <td width="110"></td>');
   htp.p('                  <td width="75"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="100" height="29" class="formlabels">Object:</td>');
   htp.p('                  <td width="88"> <input name="" type="text" size="10"></td>');
   htp.p('                  <td width="56" class="formlabels">Name:</td>');
   htp.p('                  <td width="206" height="29"> <input name="" type="text" size="25"></td>');
   htp.p('                  <td width="73" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td width="151" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'334 Blackmon Street')||'" size="20"></td>');
   htp.p('                  <td width="48" height="29" class="formlabels">City:</td>');
   htp.p('                  <td width="61" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'Austin')||'" size="7"></td>');
   htp.p('                  <td width="43" height="29" class="formlabels">State:</td>');
   htp.p('                  <td width="37" height="29"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'TX')||'" size="1"></td>');
   htp.p('                  <td width="37" class="formlabels">Zip:</td>');
   htp.p('                  <td width="67"> <input name="" type="text" value="'||display_val_if_acc_id(pi_acc_id,'75013')||'" size="2"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td width="98" height="29" class="formlabels">Light Condition:</td>');
   htp.p('                  <td width="161"> <select name="">');
   do_domain_as_options ('ACLI',accdisc.get_attr_value(pi_acc_id,'ACLI',c_acc));
   htp.p('                    </select></td>');
   htp.p('                  <td width="72" class="formlabels">Weather:</td>');
   htp.p('                  <td width="137" height="29"> <select name="">');
   do_domain_as_options ('ACBW',accdisc.get_attr_value(pi_acc_id,'ACBW',c_acc));
   htp.p('                    </select></td>');
   htp.p('                  <td width="121" height="29" class="formlabels">Surface Condition:</td>');
   htp.p('                  <td width="144" height="29"> <select name="">');
   do_domain_as_options ('ACCO',accdisc.get_attr_value(pi_acc_id,'ACCO',c_acc));
   htp.p('                    </select></td>');
   htp.p('                  <td width="93" height="29" class="formlabels"> Road Surface:</td>');
   htp.p('                  <td width="141" height="29"> <select name="">');
   do_domain_as_options ('ACRS',accdisc.get_attr_value(pi_acc_id,'ACRS',c_acc));
   htp.p('                    </select></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" colspan="3" valign="top" class="formlabels">Describe ');
   htp.p('                    Road Conditions: </td>');
   htp.p('                  <td colspan="4"><textarea name="" cols="45" rows="3"></textarea></td>');
   htp.p('                  <td height="29"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" colspan="5" class="formlabels">In your opinon, ');
   htp.p('                    did this accident result in at least $1000.00 damage to any ');
   htp.p('                    one person'||CHR(39)||'s property?</td>');
   htp.p('                  <td height="29">');
   htp.p('                    <select name="">');
   htp.p('                      <option>Yes</option>');
   htp.p('                      <option>No</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" class="formlabels"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                  <td height="29"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="10" class="tableHeaders">Charges Filed</td>');
   htp.p('                </tr>');
   htp.p('                <tr>');
   htp.p('                  <td height="29" class="formlabels">Name:</td>');
   htp.p('                  <td height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td class="formlabels">Charge:</td>');
   htp.p('                  <td height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td height="29" class="formlabels">Citation Number:</td>');
   htp.p('                  <td height="29"> <input name="" type="text" size="10"> ');
   htp.p('                  </td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="10%" height="29" class="formlabels">Name:</td>');
   htp.p('                  <td width="18%" height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td width="6%" class="formlabels">Charge:</td>');
   htp.p('                  <td width="17%" height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td width="10%" height="29" class="formlabels">Citation Number:</td>');
   htp.p('                  <td width="39%" height="29"> <input name="" type="text" size="10"> ');
   htp.p('                  </td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureTab" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Accident Report Image</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('iplusN.gif')||'" width="17" height="17" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage'||CHR(39)||','||CHR(39)||'max'||CHR(39)||')"><img src="'||nm3web.get_download_url('iMinusN.gif')||'" width="17" height="17" hspace="4" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage.form200'||CHR(39)||','||CHR(39)||'min'||CHR(39)||')"></td>');
   htp.p('                <td><A href="javascript:resizePictureAndForm()"><img src="'||nm3web.get_download_url('ExpandButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureSpacer" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formPicture" style="DISPLAY:NONE; PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 150px"> ');
   htp.p('              <div align="center"><img src="'||nm3web.get_download_url('formPage1.gif')||'" name="formimage" width="950" height="1229" id="formimageid"> ');
   htp.p('              </div>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3" class="FormButtons"><a href="'||g_package_name||'.accident2?pi_acc_id='||pi_acc_id||'"><img src="'||nm3web.get_download_url('button_previous.gif')||'" width="77" height="32" border="0"></a>'||CHR(38)||'nbsp;'||CHR(38)||'nbsp;');
   image_submit_button (p_form_name    => c_form_name
                       ,p_image_name   => 'button_submit.gif'
                       ,p_image_width  => 77
                       ,p_image_height => 32
                       );
   htp.formclose;
   htp.p('</TD>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('</table>');
   do_image_map;
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'accident3');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END accident3;
--
-----------------------------------------------------------------------------------
--
PROCEDURE data_entry IS
BEGIN
--
   nm_debug.proc_end(g_package_name,'data_entry');
--
   nm3web.user_can_run_module_web (c_new_module);
--
   accident1;
--   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
--   htp.p('<html>');
--   htp.p('<head>');
--   htp.p('<title>CRIS Prototype</title>');
--   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
--   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
--   htp.p('<script language="javascript">');
--   htp.p('');
--   htp.p('reSizePer = 100;	// resize percentage of the image');
--   htp.p('');
--   htp.p('');
--   htp.p('function imageResize(img, reSize){');
--   htp.p('');
--   htp.p('	//imgObj = eval("document."+img+".formimageid");');
--   htp.p('	imgObj = window.document.formimageid;');
--   htp.p('	imgOHeight = (imgObj.height/4);');
--   htp.p('	imgOWidth = (imgObj.width/4);');
--   htp.p('	//alert(imgObj);');
--   htp.p('	//alert(eval(imgObj));');
--   htp.p('	//alert(imgObj.width);');
--   htp.p('	');
--   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
--   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
--   htp.p('	');
--   htp.p('');
--   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
--   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
--   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
--   htp.p('		//alert(increaseWidth);');
--   htp.p('		//alert(imgObj.width);');
--   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
--   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
--   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
--   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
--   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
--   htp.p('	}');
--   htp.p('');
--   htp.p('}');
--   htp.p('');
--   htp.p('</script>');
--   htp.p('<SCRIPT language=JavaScript>');
--   htp.p('var showForm = true;');
--   htp.p('var showPicture = false;');
--   htp.p('var resizeValue = false;');
--   htp.p('');
--   htp.p('function resizePictureAndForm(){');
--   htp.p('	if(resizeValue){');
--   htp.p('		formInfo.style.height=205;');
--   htp.p('		formPicture.style.height=140;');
--   htp.p('		resizeValue = false;');
--   htp.p('	} else {');
--   htp.p('		formInfo.style.height=65;');
--   htp.p('		formPicture.style.height=280;');
--   htp.p('		resizeValue = true;');
--   htp.p('	}');
--   htp.p('}');
--   htp.p('');
--   htp.p('function showHideForm(){');
--   htp.p('	if(showForm){');
--   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
--   htp.p('		showForm = false;');
--   htp.p('	} else {');
--   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
--   htp.p('		showForm = true;');
--   htp.p('	}');
--   htp.p('}');
--   htp.p('function showHidePicture(){');
--   htp.p('	if(showPicture){');
--   htp.p('		formInfo.style.height=390;');
--   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
--   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
--   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
--   htp.p('		showPicture = false;');
--   htp.p('	} else {');
--   htp.p('		formInfo.style.height=205;');
--   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
--   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
--   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
--   htp.p('		showPicture = true;');
--   htp.p('	}');
--   htp.p('}');
--   htp.p('</SCRIPT>');
--   htp.p('</head>');
--   htp.p('');
--   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
--   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
--   htp.p('  <tr> ');
--   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map"></td>');
--   htp.p('  </tr>');
--   htp.p('  <tr> ');
--   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
--   htp.p('  </tr>');
--   htp.p('  <tr>');
--   htp.p('    <td class="HomePageTitle">Enter a New Crash Record');
--   do_image_map;
--   htp.p('    </td>');
--   htp.p('  </tr>');
--   htp.p('  <tr> ');
--   htp.p('    <td> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
--   htp.p('        <tr> ');
--   htp.p('          <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
--   htp.p('          <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('          <td nowrap class="Tab"><a href="'||g_package_name||'.accident1" class="TabLink">ST-3 ');
--   htp.p('            Details Page 1</a></td>');
--   htp.p('          <td nowrap class="Tab"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('          <td nowrap class="Tab"><a href="'||g_package_name||'.accident2" class="TabLink">ST-3 ');
--   htp.p('            Details Page 2</a></td>');
--   htp.p('          <td><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('          <td nowrap class="Tab"><a href="'||g_package_name||'.accident3" class="TabLink">ST-3 ');
--   htp.p('            Details Page 3</a></td>');
--   htp.p('          <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
--   htp.p('          <td><a href="javascript:showHidePicture()"><img src="'||nm3web.get_download_url('PictureButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
--   htp.p('          <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
--   htp.p('        </tr>');
--   htp.p('      </table></td>');
--   htp.p('  </tr>');
--   htp.p('  <tr> ');
--   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
--   htp.p('        <tr> ');
--   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr> ');
--   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
--   htp.p('          <td class="BodyTable"> <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 390px"> ');
--   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
--   htp.p('                <!--DWLayoutTable-->');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="8"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="8" class="tableHeaders">Where Accident Occured</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="81" height="29" class="formlabels">County:</td>');
--   htp.p('                  <td height="29" colspan="3"><input name="textfield2" type="text" size="20"></td>');
--   htp.p('                  <td width="125" height="29" class="formlabels">City or Town:</td>');
--   htp.p('                  <td width="230" height="29"><input name="textfield22" type="text" size="20"></td>');
--   htp.p('                  <td width="89" height="29" class="formlabels">Location #:</td>');
--   htp.p('                  <td width="106"><input name="textfield2322222" type="text" size="2" disabled></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="8" class="tableHeaders">If Accident was Outside ');
--   htp.p('                    City Limits, Indicate Distance From Nearest Town</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="29" class="formlabels">Miles:</td>');
--   htp.p('                  <td width="61" height="29"><input name="textfield23" type="text" size="1"></td>');
--   htp.p('                  <td width="123" height="29" class="formlabels">Direction:</td>');
--   htp.p('                  <td width="160" height="29"><select name="select">');
--   htp.p('                      <option>N</option>');
--   htp.p('                      <option>E</option>');
--   htp.p('                      <option>S</option>');
--   htp.p('                      <option>W</option>');
--   htp.p('                    </select></td>');
--   htp.p('                  <td height="29" class="formlabels">Of City or Town:</td>');
--   htp.p('                  <td height="29"><input name="textfield222" type="text" size="20"></td>');
--   htp.p('                  <td height="29" colspan="2">'||CHR(38)||'nbsp;</td>');
--   htp.p('                </tr>');
--   htp.p('              </table>');
--   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
--   htp.p('                <!--DWLayoutTable-->');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="10" class="tableHeaders">Road on Which Accident ');
--   htp.p('                    Occured</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="80" height="29" class="formlabels">Block #:</td>');
--   htp.p('                  <td width="62" height="29"><input name="textfield2322" type="text" size="2"></td>');
--   htp.p('                  <td width="123" height="29" class="formlabels">Street or Road ');
--   htp.p('                    Name:</td>');
--   htp.p('                  <td width="159" height="29"><input name="textfield2232" type="text" size="20"></td>');
--   htp.p('                  <td width="126" height="29" class="formlabels">Route # or St. ');
--   htp.p('                    Code:</td>');
--   htp.p('                  <td width="76" height="29"><input name="textfield23222" type="text" size="5"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td width="78" height="29" class="formlabels">Const Zone:</td>');
--   htp.p('                  <td width="76" height="29"> <select name="select4">');
--   htp.p('                      <option>Yes</option>');
--   htp.p('                      <option>No</option>');
--   htp.p('                    </select> </td>');
--   htp.p('                  <td width="88" height="29" class="formlabels">Speed Limit:</td>');
--   htp.p('                  <td width="107" height="29"><input name="textfield232222" type="text" size="2"></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="10" class="tableHeaders">Intersecting Street</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="29" class="formlabels">Block #:</td>');
--   htp.p('                  <td height="29"><input name="textfield2322" type="text" size="2"></td>');
--   htp.p('                  <td height="29" class="formlabels">Street or Road Name:</td>');
--   htp.p('                  <td height="29"><input name="textfield2232" type="text" size="20"></td>');
--   htp.p('                  <td height="29" class="formlabels">Route # or St. Code:</td>');
--   htp.p('                  <td height="29"><input name="textfield23222" type="text" size="5"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td height="29" class="formlabels">Const Zone:</td>');
--   htp.p('                  <td height="29"> <select name="select4">');
--   htp.p('                      <option>Yes</option>');
--   htp.p('                      <option>No</option>');
--   htp.p('                    </select> </td>');
--   htp.p('                  <td height="29" class="formlabels">Speed Limit:</td>');
--   htp.p('                  <td height="29"><input name="textfield232222" type="text" size="2"></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="10" class="tableHeaders">Not at Intersection</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="29" class="formlabels">Feet/Miles:</td>');
--   htp.p('                  <td height="29"><select name="select2">');
--   htp.p('                      <option>Ft</option>');
--   htp.p('                      <option>Mi</option>');
--   htp.p('                    </select></td>');
--   htp.p('                  <td height="29" class="formlabels">Direction:</td>');
--   htp.p('                  <td height="29"><select name="select3">');
--   htp.p('                      <option>N</option>');
--   htp.p('                      <option>E</option>');
--   htp.p('                      <option>S</option>');
--   htp.p('                      <option>W</option>');
--   htp.p('                    </select></td>');
--   htp.p('                  <td height="29" class="formlabels">Of City or Town:</td>');
--   htp.p('                  <td height="29" colspan="5"><input name="textfield2222" type="text" size="20"></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="1"></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td colspan="2"></td>');
--   htp.p('                  <td colspan="3"></td>');
--   htp.p('                </tr>');
--   htp.p('              </table>');
--   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
--   htp.p('                <!--DWLayoutTable-->');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="10" class="tableHeaders">Date of Accident</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="80" height="29" class="formlabels">Date:</td>');
--   htp.p('                  <td width="62" height="29"><input name="textfield23223" type="text" size="5"></td>');
--   htp.p('                  <td width="123" height="29" class="formlabels">Day of Week:</td>');
--   htp.p('                  <td width="159" height="29"><select name="select7">');
--   htp.p('                      <option>Sunday</option>');
--   htp.p('                      <option>Monday</option>');
--   htp.p('                      <option>Tuesday</option>');
--   htp.p('                      <option>Wednesday</option>');
--   htp.p('                      <option>Thursday</option>');
--   htp.p('                      <option>Friday</option>');
--   htp.p('                      <option>Saturday</option>');
--   htp.p('                    </select></td>');
--   htp.p('                  <td width="125" height="29" class="formlabels">Time:</td>');
--   htp.p('                  <td width="142" height="29"><input name="textfield232223" type="text" size="5"> ');
--   htp.p('                    <select name="select6">');
--   htp.p('                      <option>AM</option>');
--   htp.p('                      <option>PM</option>');
--   htp.p('                    </select> </td>');
--   htp.p('                  <td width="89" height="29" class="formlabels">Exactly Noon:</td>');
--   htp.p('                  <td height="29" colspan="3"> <select name="select5">');
--   htp.p('                      <option>Yes</option>');
--   htp.p('                      <option>No</option>');
--   htp.p('                    </select> </td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="1"></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td></td>');
--   htp.p('                  <td colspan="2"></td>');
--   htp.p('                  <td width="195" colspan="3"></td>');
--   htp.p('                </tr>');
--   htp.p('              </table>');
--   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
--   htp.p('                <!--DWLayoutTable-->');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="12" class="tableHeaders">Unit #1 Motor Vehicle ');
--   htp.p('                    Information</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="29" class="formlabels">Vehicle ID Number:</td>');
--   htp.p('                  <td height="29" colspan="2"><input name="textfield22322" type="text" size="20"></td>');
--   htp.p('                  <td height="29" colspan="2" class="formlabels">If Van or Bus, ');
--   htp.p('                    Capacity:</td>');
--   htp.p('                  <td height="29" colspan="4"><input name="textfield2322323" type="text" size="1"></td>');
--   htp.p('                  <td width="46" height="29" class="formlabels"><div align="left">Year</div></td>');
--   htp.p('                  <td width="48" height="29" class="formlabels"><div align="left">State</div></td>');
--   htp.p('                  <td width="58" height="29" class="formlabels"><div align="left">Number</div></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="103" height="29" class="formlabels">Year Model:</td>');
--   htp.p('                  <td width="70" height="29"><input name="textfield232232" type="text" size="3"></td>');
--   htp.p('                  <td width="87" class="formlabels">Color '||CHR(38)||'amp; Make:</td>');
--   htp.p('                  <td width="92" height="29"> <input name="textfield2322322" type="text" size="10"></td>');
--   htp.p('                  <td width="85" height="29" class="formlabels">Model Name:</td>');
--   htp.p('                  <td width="103" height="29"><input name="textfield23223222" type="text" size="10"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td width="80" height="29" class="formlabels">Body Style:</td>');
--   htp.p('                  <td width="105" height="29"><input name="textfield232232222" type="text" size="10"></td>');
--   htp.p('                  <td width="98" class="formlabels">License Plate:</td>');
--   htp.p('                  <td height="29"> <input name="textfield23223232" type="text" size="2"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td height="29"><input name="textfield23223233" type="text" size="1"></td>');
--   htp.p('                  <td height="29"><input name="textfield23223234" type="text" size="4"></td>');
--   htp.p('                </tr>');
--   htp.p('              </table>');
--   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
--   htp.p('                <!--DWLayoutTable-->');
--   htp.p('                <tr> ');
--   htp.p('                  <td colspan="14" class="tableHeaders">Driver'||CHR(39)||'s Information</td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="88" height="29" class="formlabels">Last Name:</td>');
--   htp.p('                  <td width="74" height="29"><input name="textfield2322324" type="text" size="10"></td>');
--   htp.p('                  <td width="72" class="formlabels">First Name:</td>');
--   htp.p('                  <td width="67" height="29"> <input name="textfield23223223" type="text" size="10"></td>');
--   htp.p('                  <td width="81" height="29" class="formlabels">Middle Name:</td>');
--   htp.p('                  <td width="49" height="29"><input name="textfield232232223" type="text" size="3"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td width="72" height="29" class="formlabels">Address:</td>');
--   htp.p('                  <td width="166" height="29"><input name="textfield2322322222" type="text" size="25"></td>');
--   htp.p('                  <td width="48" class="formlabels">City:</td>');
--   htp.p('                  <td width="59" height="29"> <input name="textfield232232322" type="text" size="7"> ');
--   htp.p('                  </td>');
--   htp.p('                  <td width="50" height="29" class="formlabels">State:</td>');
--   htp.p('                  <td width="50" height="29"><input name="textfield232232342" type="text" size="1"></td>');
--   htp.p('                  <td width="39" class="formlabels">Zip:</td>');
--   htp.p('                  <td width="60"><input name="textfield2322323222" type="text" size="2"></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td height="28" class="formlabels"> License State:</td>');
--   htp.p('                  <td height="28"><input name="textfield232232332" type="text" size="1"></td>');
--   htp.p('                  <td class="formlabels">Lic. Number:</td>');
--   htp.p('                  <td height="28"><input name="textfield23223242" type="text" size="6"></td>');
--   htp.p('                  <td height="28" class="formlabels">Class/Type:</td>');
--   htp.p('                  <td height="28"><select name="select8">');
--   htp.p('                      <option>A</option>');
--   htp.p('                      <option>B</option>');
--   htp.p('                    </select></td>');
--   htp.p('                  <td height="28" class="formlabels">Occupation:</td>');
--   htp.p('                  <td height="28"><input name="textfield23223222222" type="text" size="15"></td>');
--   htp.p('                  <td class="formlabels">DOB:</td>');
--   htp.p('                  <td height="28"><input name="textfield2322332" type="text" size="5"></td>');
--   htp.p('                  <td height="28" class="formlabels">Race:</td>');
--   htp.p('                  <td height="28"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
--   htp.p('                  <td class="formlabels">Sex:</td>');
--   htp.p('                  <td><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
--   htp.p('                </tr>');
--   htp.p('              </table>');
--   htp.p('            </div></td>');
--   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr> ');
--   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr id="pictureTab" style="DISPLAY:NONE;"> ');
--   htp.p('          <td colspan="3"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
--   htp.p('              <tr> ');
--   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
--   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('                <td nowrap class="Tab">Accident Report Image</td>');
--   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('iplusN.gif')||'" width="17" height="17" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage'||CHR(39)||','||CHR(39)||'max'||CHR(39)||')"><img src="'||nm3web.get_download_url('iMinusN.gif')||'" width="17" height="17" hspace="4" align="absmiddle" onClick="imageResize('||CHR(39)||'formimage.form200'||CHR(39)||','||CHR(39)||'min'||CHR(39)||')"></td>');
--   htp.p('                <td><A href="javascript:resizePictureAndForm()"><img src="'||nm3web.get_download_url('ExpandButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
--   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
--   htp.p('              </tr>');
--   htp.p('            </table></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr id="pictureSpacer" style="DISPLAY:NONE;"> ');
--   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr> ');
--   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
--   htp.p('          <td class="BodyTable"> <DIV id="formPicture" style="DISPLAY:NONE; PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 150px"> ');
--   htp.p('              <div align="center"><img src="'||nm3web.get_download_url('formPage1.gif')||'" name="formimage" width="950" height="1229" id="formimageid"> ');
--   htp.p('              </div>');
--   htp.p('            </div></td>');
--   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
--   htp.p('        </tr>');
--   htp.p('        <tr> ');
--   htp.p('          <td colspan="3" class="FormButtons"><a href="'||g_package_name||'.home"><img src="'||nm3web.get_download_url('button_submit.gif')||'" width="75" height="31" border="0"></a></td>');
--   htp.p('        </tr>');
--   htp.p('      </table></td>');
--   htp.p('  </tr>');
--   htp.p('</table>');
--   htp.p('</body>');
--   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'data_entry');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END data_entry;
--
-----------------------------------------------------------------------------------
--
PROCEDURE find_accident IS
   c_form_name CONSTANT VARCHAR2(30) := 'cris_search';
BEGIN
--
   nm_debug.proc_end(g_package_name,'find_accident');
--
   nm3web.user_can_run_module_web (c_find_module);
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.height=140;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=65;');
   htp.p('		formPicture.style.height=280;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=390;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=205;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('<script type="text/javascript">');
   htp.p('function setfocus()');
   htp.p('{');
   htp.p('document.forms[0].pi_acc_name.focus()');
   htp.p('}');
   htp.p('</script>');
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ONLOAD=setfocus()>');
   htp.p('<table width="995" border="0" cellpadding="0" cellspacing="0" class="MainTable">');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('header.gif')||'" width="995" height="83" border="0" usemap="#Map">');
--   htp.p('      <map name="Map">');
--   htp.p('        <area shape="rect" coords="86,38,208,56" href="form.html">');
--   htp.p('        <area shape="rect" coords="576,38,614,58" href="search.html">');
--   htp.p('      </map></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   htp.p('    <td class="HomePageTitle">Search for a Crash Record</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('        <tr> ');
   htp.p('          <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('          <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('          <td nowrap class="Tab"><a href="accident1.html" class="TabLink">Search ');
--   htp.p('            Criteria </a></td>');
   htp.p('          <td nowrap class="Tab">Search Criteria</td>');
   htp.p('          <td nowrap class="Tab"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('          <td width="100%" nowrap>'||CHR(38)||'nbsp;</td>');
   htp.p('          <td>'||CHR(38)||'nbsp;</td>');
   htp.p('          <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td><table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('          <td class="BodyTable"> <DIV id="formInfo" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px;"> ');
   htp.p('              <table width="100%" border="0" cellspacing="0" cellpadding="0">');
   htp.p('                <!--DWLayoutTable-->');

      htp.formOpen(curl => g_package_name||'.get_acc_by_accname',cattributes=>'NAME="'||c_form_name||'"');
--      htp.formhidden(cname      => 'pi_acc_id'
--                    ,cvalue     => cs_rec.acc_id
--                    );
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Accident Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="132" height="29" class="formlabels">Accident Name:</td>');
   htp.p('                  <td height="29" colspan="3"> <input name="pi_acc_name" type="text" size="30"></td>');
--   htp.p('                </tr>');
--   htp.p('                <tr> ');
--   htp.p('                  <td width="132" height="29" class="formlabels">Accident Date:</td>');
--   htp.p('                  <td height="29" colspan="2"> <input name="acc_date" type="text" size="20"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Accident Location</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="132" height="29" class="formlabels">County:</td>');
--   htp.p('                  <td height="29" colspan="3"> <input name="textfield2" type="text" size="20"></td>');
   htp.p('                  <td height="29" colspan="3"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td width="129" height="29" class="formlabels">City or Town:</td>');
--   htp.p('                  <td width="204" height="29"> <input name="textfield22" type="text" size="20"></td>');
   htp.p('                  <td width="204" height="29"> <input name="" type="text" size="20"></td>');
   htp.p('                  <td width="122" height="29" class="formlabels">Location #:</td>');
   htp.p('                  <td width="187"> <input name="" type="text" size="2" disabled></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Block #:</td>');
   htp.p('                  <td height="29" colspan="3"><input name="" type="text" size="2"></td>');
   htp.p('                  <td height="29" class="formlabels">Street or Road Name:</td>');
   htp.p('                  <td height="29"><input name="" type="text" size="20"></td>');
   htp.p('                  <td height="29" class="formlabels">Route # or St. Code:</td>');
   htp.p('                  <td><input name="" type="text" size="5"></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Date:</td>');
   htp.p('                  <td height="29" colspan="3"><input name="" type="text" size="5"></td>');
   htp.p('                  <td height="29" class="formlabels">Day of Week:</td>');
   htp.p('                  <td height="29"><select name="">');
   htp.p('                      <option>Sunday</option>');
   htp.p('                      <option>Monday</option>');
   htp.p('                      <option>Tuesday</option>');
   htp.p('                      <option>Wednesday</option>');
   htp.p('                      <option>Thursday</option>');
   htp.p('                      <option>Friday</option>');
   htp.p('                      <option>Saturday</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="29" class="formlabels">Time:</td>');
   htp.p('                  <td><input name="" type="text" size="5"> <select name="">');
   htp.p('                      <option>AM</option>');
   htp.p('                      <option>PM</option>');
   htp.p('                    </select></td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="29" class="formlabels">Vehicle ID Number:</td>');
   htp.p('                  <td height="29" colspan="3"><input name="" type="text" size="20"></td>');
   htp.p('                  <td height="29" class="formlabels">License Plate:</td>');
   htp.p('                  <td height="29"> S ');
   htp.p('                    <input name="" type="text" size="1">');
   htp.p('                    Y ');
   htp.p('                    <input name="" type="text" size="2">');
   htp.p('                    # ');
   htp.p('                    <input name="" type="text" size="4"> </td>');
   htp.p('                  <td height="29" class="formlabels">Speed Limit:</td>');
   htp.p('                  <td><input name="" type="text" size="2"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('              <table width="100%" border="0" cellpadding="0" cellspacing="0">');
   htp.p('                <!--DWLayoutTable-->');
   htp.p('                <tr> ');
   htp.p('                  <td colspan="12" class="tableHeaders">Driver'||CHR(39)||'s Information</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td width="139" height="29" class="formlabels">Last Name:</td>');
   htp.p('                  <td width="99" height="29"> <input name="" type="text" size="10"></td>');
   htp.p('                  <td width="87" class="formlabels">First Name:</td>');
   htp.p('                  <td width="111" height="29"> <input name="" type="text" size="10"></td>');
   htp.p('                  <td width="81" height="29" class="formlabels">Middle Name:</td>');
   htp.p('                  <td width="78" height="29"> <input name="" type="text" size="3"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="89" height="29" class="formlabels">Address:</td>');
   htp.p('                  <td height="29" colspan="3"> <input name="" type="text" size="25"> ');
   htp.p('                  </td>');
   htp.p('                  <td width="35" height="29" class="formlabels"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                  <td width="56" height="29"><!--DWLayoutEmptyCell-->'||CHR(38)||'nbsp;</td>');
   htp.p('                </tr>');
   htp.p('                <tr> ');
   htp.p('                  <td height="28" class="formlabels"> License State:</td>');
   htp.p('                  <td height="28"><input name="" type="text" size="1"></td>');
   htp.p('                  <td class="formlabels">Lic. Number:</td>');
   htp.p('                  <td height="28"><input name="" type="text" size="6"></td>');
   htp.p('                  <td height="28" class="formlabels">Class/Type:</td>');
   htp.p('                  <td height="28"><select name="">');
   htp.p('                      <option>A</option>');
   htp.p('                      <option>B</option>');
   htp.p('                    </select></td>');
   htp.p('                  <td height="28" class="formlabels">City:</td>');
   htp.p('                  <td width="93" height="28"> <input name="" type="text" size="7"></td>');
   htp.p('                  <td width="54" class="formlabels">State:</td>');
   htp.p('                  <td width="45" height="28"><input name="" type="text" size="1"></td>');
   htp.p('                  <td height="28" class="formlabels">Zip:</td>');
   htp.p('                  <td height="28"><input name="" type="text" size="2"></td>');
   htp.p('                </tr>');
   htp.p('              </table>');
   htp.p('            </div></td>');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3" class="FormButtons">');

--      htp.formOpen(curl => g_package_name||'.accident1',cattributes=>'NAME="P'||cs_rec.acc_id||'"');
--      htp.formhidden(cname      => 'pi_acc_id'
--                    ,cvalue     => cs_rec.acc_id
--                    );
      image_submit_button (p_form_name    => c_form_name
                          ,p_image_name   => 'button_submit.gif'
                          ,p_image_width  => 77
                          ,p_image_height => 32
                          );
      htp.formclose;
   htp.p('</td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureTab" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('              <tr> ');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   htp.p('                <td nowrap class="Tab">Search Results</td>');
   htp.p('                <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('                <td>'||CHR(38)||'nbsp;</td>');
   htp.p('                <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('              </tr>');
   htp.p('            </table></td>');
   htp.p('        </tr>');
   htp.p('        <tr id="pictureSpacer" style="DISPLAY:NONE;"> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   do_pending_Accs;
   htp.p('          <td width="10"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="10" height="1"></td>');
   htp.p('        </tr>');
   htp.p('        <tr> ');
   htp.p('          <td colspan="3"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="50" height="10"></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
   htp.p('  </tr>');
   htp.p('</table>');
   do_image_map;
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'find_accident');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END find_accident;
--
-----------------------------------------------------------------------------------
--
FUNCTION get_veh (pi_acc_id NUMBER, pi_seq NUMBER DEFAULT 1) RETURN acc_items_all%ROWTYPE IS
   CURSOR cs_acc (c_acc_id NUMBER) IS
   SELECT *
    FROM  acc_items_all
   WHERE  acc_top_id = c_acc_id
    AND   acc_ait_id = 'VEH'
   ORDER BY acc_seq;
   l_rec_acc acc_items_all%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_veh');
--
   FOR cs_rec IN cs_acc (pi_acc_id)
    LOOP
      IF cs_acc%ROWCOUNT = pi_seq
       THEN
         l_rec_acc := cs_rec;
         EXIT;
      END IF;
   END LOOP;
----
--   IF l_rec_acc.acc_id IS NULL
--    THEN
--      hig.raise_ner (pi_appl               => nm3type.c_hig
--                    ,pi_id                 => 67
--                    ,pi_supplementary_info => 'acc_items_all.acc_top_id='||pi_acc_id||' seq = '||pi_seq
--                    );
--   END IF;
--
   nm_debug.proc_end(g_package_name,'get_veh');
   RETURN l_rec_acc;
--
END get_veh;
--
-----------------------------------------------------------------------------------
--
FUNCTION get_acc (pi_acc_id NUMBER) RETURN acc_items_all%ROWTYPE IS
   CURSOR cs_acc (c_acc_id NUMBER) IS
   SELECT *
    FROM  acc_items_all
   WHERE  acc_id = c_acc_id;
   l_rec_acc acc_items_all%ROWTYPE;
   l_found   BOOLEAN;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_acc');
--
   IF pi_acc_id IS NOT NULL
    THEN
      OPEN  cs_acc (pi_acc_id);
      FETCH cs_acc INTO l_rec_Acc;
      l_found := cs_acc%FOUND;
      CLOSE cs_acc;
   --
      IF NOT l_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'acc_items_all.acc_id='||pi_acc_id
                       );
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_acc');
   RETURN l_rec_acc;
--
END get_acc;
--
-----------------------------------------------------------------------------------
--
FUNCTION get_resultsetoddeven (pi_number NUMBER) RETURN VARCHAR2 IS
BEGIN
   RETURN 'ResultSet'||nm3flx.i_t_e(MOD(pi_number,2)=0,'Even','Odd');
END get_resultsetoddeven;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_domain_as_options (p_aad_id VARCHAR2, p_value VARCHAR2 DEFAULT NULL) IS
   CURSOR cs_aal (c_aal_aad_id VARCHAR2) IS
   SELECT aal_value,aal_meaning
     FROM acc_attr_lookup
   WHERE  aal_aad_id = c_aal_aad_id
   ORDER BY aal_seq;
--
   l_tab_aal_value   nm3type.tab_varchar2000;
   l_tab_aal_meaning nm3type.tab_varchar2000;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'do_domain_as_options');
--
   OPEN  cs_aal (p_aad_id);
   FETCH cs_aal
    BULK COLLECT
    INTO l_tab_aal_value
        ,l_tab_aal_meaning;
   CLOSE cs_aal;
--
   IF l_tab_aal_value.COUNT = 0
    THEN
      l_tab_aal_value(1)   := Null;
      l_tab_aal_meaning(1) := 'No domain values for '||p_aad_id;
   END IF;
--
   FOR i IN 1..l_tab_aal_value.COUNT
    LOOP
      htp.p('                      <option'||nm3flx.i_t_e(p_value=l_tab_aal_value(i),' selected',Null)||'>'
                                   ||l_tab_aal_meaning(i)||
                                   '</option>');
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'do_domain_as_options');
--
END do_domain_as_options;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_image_map IS
BEGIN
   htp.p('<map name="Map">');
   htp.p('  <area shape="rect" coords="8,4,82,82" href="'||g_package_name||'.home">');
   htp.p('  <area shape="rect" coords="86,38,208,56" href="'||g_package_name||'.data_entry">');
   htp.p('  <area shape="rect" coords="214,38,336,56" href="'||g_package_name||'.find_accident">');
   htp.p('  <area shape="rect" coords="966,20,988,44" href="'||g_package_name||'.logoff">');
   htp.p('</map>');
END do_image_map;
--
-----------------------------------------------------------------------------------
--
PROCEDURE logoff IS
BEGIN
   login;
END logoff;
--
-----------------------------------------------------------------------------------
--
PROCEDURE get_acc_by_accname (pi_acc_name VARCHAR2) IS
   CURSOR cs_acc IS
   SELECT acc_id
    FROM  acc_items_all
   WHERE  acc_name = pi_acc_name
    AND   acc_ait_id = 'ACC';
   l_acc_id NUMBER;
   l_found  BOOLEAN;
BEGIN
   IF pi_acc_name IS NOT NULL
    THEN
      OPEN  cs_acc;
      FETCH cs_acc INTO l_acc_id;
      l_found := cs_acc%FOUND;
      CLOSE cs_acc;
      IF NOT l_found
       THEN
         hig.raise_ner (pi_appl => nm3type.c_hig
                       ,pi_id   => 67
                       );
      END IF;
      accident1 (l_acc_id);
   ELSE
      htp.p('<SCRIPT LANGUAGE="JavaScript">history.back()</SCRIPT>');
   END IF;
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      Null;
   WHEN OTHERS
    THEN
      nm3web.failure(SQLERRM);
END get_acc_by_accname;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_pending_Accs IS
   CURSOR cs_pending_accs IS
   SELECT /*+ INDEX (acc acc_texas_demo_ind) */
          acc_id
         ,acc_start_date
         ,acc_status
    FROM  acc_items_all
   WHERE  acc_ait_id  = 'ACC'
    AND   acc_id     != 0
--    and   acc_id      = 1
    AND   acc_status IN (1,2,3,4);
   l_tab_acc_id nm3type.tab_number;
BEGIN
--
   htp.p('          <td colspan="3" class="BodyTableHomePage"><table width="975" border="0" cellspacing="0" cellpadding="0">');
   htp.p('              <tr> ');
   htp.p('                <td width="79" class="ResultSetSorted">Date Filed</td>');
   htp.p('                <td width="285" class="ResultSetUnsorted">Description</td>');
   htp.p('                <td width="161" class="ResultSetUnsorted">Filed By</td>');
   htp.p('                <td width="165" class="ResultSetUnsorted">Pending Reason</td>');
   htp.p('                <td width="89" class="ResultSetUnsorted">Court Date</td>');
   htp.p('                <td width="149" class="ResultSetUnsorted">County</td>');
   htp.p('                <td width="26" class="ResultSetUnsorted"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('                <td width="20" class="ResultSetRightColumn"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="1" height="1"></td>');
   htp.p('              </tr>');
   htp.p('            </table>');
   htp.p('            <DIV id="pendingReports" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; OVERFLOW: auto; WIDTH: 100%; PADDING-TOP: 0px; HEIGHT: 100px"> ');
   htp.p('              <table width="955" border="0" cellpadding="0" cellspacing="0" class="ResultSetResults">');
   --
   FOR cs_rec IN cs_pending_accs
    LOOP
      l_tab_acc_id(cs_pending_accs%ROWCOUNT) := cs_rec.acc_id;
      htp.p('                <tr class="'||get_resultsetoddeven(cs_pending_accs%ROWCOUNT)||'"> ');
      htp.p('                  <td width="87">'||nm3web.c_nbsp||to_char(cs_rec.acc_start_date,c_date_mask)||'</td>');
      htp.p('                  <td width="277">'||NVL(accdisc.get_attr_value(cs_rec.acc_id,'ADES',c_acc),nm3web.c_nbsp)||'</td>');
      htp.p('                  <td width="157">Officer Briggs</td>');
      htp.p('                  <td width="165">'||nm3get.get_hco (pi_hco_domain      => 'PENDING_REASON'
                                                                 ,pi_hco_code        => cs_rec.acc_status
                                                                 ,pi_raise_not_found => FALSE
                                                                 ).hco_meaning
                                                ||'</td>');
      htp.p('                  <td width="91">04/15/2003</td>');
      htp.p('                  <td width="151">Travis</td>');
      htp.p('                  <td width="27"><a href="'||g_package_name||'.accident1?pi_acc_id='||cs_rec.acc_id||'"><img src="'||nm3web.get_download_url('iPreview.gif')||'" width="17" height="17" border="0"></a></td>');
      htp.p('                </tr>');
   END LOOP;
   --
   htp.p('              </table>');
   htp.p('</div></td>');
--
END do_pending_Accs;
--
-----------------------------------------------------------------------------------
--
PROCEDURE image_submit_button (p_form_name    VARCHAR2
                              ,p_image_name   VARCHAR2
                              ,p_image_width  NUMBER
                              ,p_image_height NUMBER
                              ) IS
   l_width  VARCHAR2(20);
   l_height VARCHAR2(20);
BEGIN
   l_width  := nm3flx.i_t_e (p_image_width  IS NULL,NULL,' WIDTH="'||p_image_width||'"');
   l_height := nm3flx.i_t_e (p_image_height IS NULL,NULL,' WIDTH="'||p_image_height||'"');
   htp.p('<a href="javascript:void(document.'||p_form_name||'.submit())"><img border="0" src="'||nm3web.get_download_url(p_image_name)||'"'||l_width||l_height||' border="0"></a>');
END image_submit_button;
--
-----------------------------------------------------------------------------------
--
PROCEDURE login IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'login');
--
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<script language="javascript">');
   htp.p('');
   htp.p('reSizePer = 100;	// resize percentage of the image');
   htp.p('');
   htp.p('');
   htp.p('function imageResize(img, reSize){');
   htp.p('');
   htp.p('	//imgObj = eval("document."+img+".formimageid");');
   htp.p('	imgObj = window.document.formimageid;');
   htp.p('	imgOHeight = (imgObj.height/4);');
   htp.p('	imgOWidth = (imgObj.width/4);');
   htp.p('	//alert(imgObj);');
   htp.p('	//alert(eval(imgObj));');
   htp.p('	//alert(imgObj.width);');
   htp.p('	');
   htp.p('	increaseWidth = imgOWidth*(reSizePer/100);');
   htp.p('	increaseHeight = imgOHeight*(reSizePer/100);');
   htp.p('	');
   htp.p('');
   htp.p('	if(reSize == '||CHR(39)||'max'||CHR(39)||'){');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti+2;');
   htp.p('		imgObj.width = imgObj.width+increaseWidth;');
   htp.p('		//alert(increaseWidth);');
   htp.p('		//alert(imgObj.width);');
   htp.p('		imgObj.height = imgObj.height+increaseHeight;');
   htp.p('	} else if(reSize == '||CHR(39)||'min'||CHR(39)||' '||CHR(38)||''||CHR(38)||' imgObj.width > imgOWidth) {');
   htp.p('		//parent.imageFrame.scrollMulti = parent.imageFrame.scrollMulti-2;');
   htp.p('		imgObj.width = imgObj.width-increaseWidth;');
   htp.p('		imgObj.height = imgObj.height-increaseHeight;');
   htp.p('	}');
   htp.p('');
   htp.p('}');
   htp.p('');
   htp.p('</script>');
   htp.p('<SCRIPT language=JavaScript>');
   htp.p('var showForm = true;');
   htp.p('var showPicture = false;');
   htp.p('var resizeValue = false;');
   htp.p('');
   htp.p('function resizePictureAndForm(){');
   htp.p('	if(resizeValue){');
   htp.p('		formInfo.style.height=225;');
   htp.p('		formPicture.style.height=150;');
   htp.p('		resizeValue = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=75;');
   htp.p('		formPicture.style.height=300;');
   htp.p('		resizeValue = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('');
   htp.p('function showHideForm(){');
   htp.p('	if(showForm){');
   htp.p('		formInfo.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showForm = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showForm = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('function showHidePicture(){');
   htp.p('	if(showPicture){');
   htp.p('		formInfo.style.height=420;');
   htp.p('		formPicture.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'none'||CHR(39)||';');
   htp.p('		showPicture = false;');
   htp.p('	} else {');
   htp.p('		formInfo.style.height=225;');
   htp.p('		formPicture.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureTab.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		pictureSpacer.style.display='||CHR(39)||'inline'||CHR(39)||';');
   htp.p('		showPicture = true;');
   htp.p('	}');
   htp.p('}');
   htp.p('</SCRIPT>');
   htp.p('<script type="text/javascript">');
   htp.p('function setfocus()');
   htp.p('{');
   htp.p('document.forms[0].pi_password.focus()');
   htp.p('}');
   htp.p('</script>');

--   maximise_browser;
   htp.p('</head>');
   htp.p('');
   htp.p('<body bgcolor="#003366" background="'||nm3web.get_download_url('LoginBackground.jpg')||'" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ONLOAD=setfocus()>');
   htp.p('<table width="995" border="0" cellspacing="0" cellpadding="0">');
   htp.p('  <tr> ');
   htp.p('    <td height="377" colspan="3">'||CHR(38)||'nbsp;</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.formopen (curl=>g_package_name||'.home',cattributes=>'NAME="logon"');
   htp.p('    <td width="608" height="66" class="LoginLabel">Username:</td>');
   htp.p('    <td width="379"> <input name="pi_username" type="text" class="LoginFields" value="DAVIS0123"></td>');
   htp.p('    <td width="8">'||CHR(38)||'nbsp;</td>');
   htp.p('  </tr>');
   htp.p('  <tr> ');
   htp.p('    <td height="30" class="LoginLabel">Password:</td>');
   htp.p('    <td><input name="pi_password" type="password" class="LoginFields" value=""></td>');
   htp.p('    <td>'||CHR(38)||'nbsp;</td>');
   htp.p('  </tr>');
   htp.p('  <tr>');
   htp.p('    <td height="129" class="LoginLabel">'||CHR(38)||'nbsp;</td>');
   htp.p('    <td valign="bottom"><img src="'||nm3web.get_download_url('spacer.gif')||'" width="326" height="104" border="0" usemap="#Map"></td>');
   htp.p('    <td>'||CHR(38)||'nbsp;</td>');
   htp.p('  </tr>');
   htp.p('</table>');
   htp.formclose;
   htp.p('<map name="Map">');
   htp.p('  <area shape="rect" coords="183,1,325,103" href="'||g_package_name||'.home">');
   htp.p('</map>');
   htp.p('</body>');
   htp.p('</html>');
--
   nm_debug.proc_end(g_package_name,'login');
--
END login;
--
-----------------------------------------------------------------------------------
--
PROCEDURE launch IS
   l_attribute_list VARCHAR2(400);
   c_width  CONSTANT NUMBER := 995;
   c_height CONSTANT NUMBER := 625;
BEGIN
   l_attribute_list := 'toolbar=no,address=no,status=NO,menubar=no,copyhistory=no,width="+win_width+",height="+win_height+",left="+winl+",top="+wint+",resizable=yes,scrollbars=no';
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('<link href="'||nm3web.get_download_url('styles.css')||'" rel="stylesheet" type="text/css">');
   htp.p('<SCRIPT language="JavaScript">');
   htp.p('   var win_width = '||c_width||';');
   htp.p('   var win_height = '||c_height||';');
   htp.p('   var winl = (screen.width - win_width) / 2;');
   htp.p('   var wint = (screen.height - win_height) / 2;');
--   htp.p('   top.window.outerHeight = 10');
--   htp.p('   top.window.outerWidth = 10');
   htp.p('   self.resizeTo(200,200)');
   htp.p('   window.open("'||g_package_name||'.frameset","CRIS_WINDOW","'||l_attribute_list||'")');
--   htp.p('   alert("hello")');
   htp.p('</SCRIPT>');
   htp.p('</HEAD>');
--
   htp.p('<BODY>');
   htp.p('<A HREF="'||g_package_name||'.frameset">CRIS Login</A>');
   htp.p('</BODY>');
   htp.p('</HTML>');
END launch;
--
-----------------------------------------------------------------------------------
--
PROCEDURE frameset IS
BEGIN
   htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>CRIS Prototype</title>');
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
   htp.p('</head>');
   htp.p('<FRAMESET ROWS="*" COLS="*">');
   htp.p('   <FRAME SRC="'||g_package_name||'.login" SCROLLING=NO NORESIZE>');
   htp.p('</FRAMESET>');
   htp.p('</html>');
END frameset;
--
-----------------------------------------------------------------------------------
--
PROCEDURE maximise_browser IS
BEGIN
   htp.p('<script language="JavaScript1.2">');
   htp.p('<!--');
   htp.p('top.window.moveTo(0,0);');
--   htp.p('alert(self.name)');
--   htp.p('if (self.name=="CRIS_WINDOW")');
--   htp.p('else');
--   htp.p('{');
   htp.p('if (document.all) {');
   htp.p('top.window.resizeTo(screen.availWidth,screen.availHeight);');
   htp.p('}');
   htp.p('else if (document.layers||document.getElementById) {');
   htp.p('if (top.window.outerHeight < screen.availHeight||top.window.outerWidth < screen.availWidth){');
   htp.p('top.window.outerHeight = screen.availHeight;');
   htp.p('top.window.outerWidth = screen.availWidth;');
--   htp.p('}');
   htp.p('}');
   htp.p('}');
   htp.p('//-->');
   htp.p('</script>');
END maximise_browser;
--
-----------------------------------------------------------------------------------
--
FUNCTION display_val_if_acc_id (p_acc_id NUMBER, p_value VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3flx.i_t_e (p_acc_id IS NULL,Null,p_value);
END display_val_if_acc_id;
--
-----------------------------------------------------------------------------------
--
FUNCTION display_title_if_acc_id (p_acc_id NUMBER) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3flx.i_t_e (p_acc_id IS NULL
                       ,nm3get.get_hmo(pi_hmo_module=>c_new_module).hmo_title
                       ,nm3get.get_hmo(pi_hmo_module=>c_view_module).hmo_title
                       );
END display_title_if_acc_id;
--
-----------------------------------------------------------------------------------
--
PROCEDURE do_tab_bar (pi_acc_id NUMBER,p_page NUMBER) IS
BEGIN
   htp.p('    <td> <table width="975" border="0" cellpadding="0" cellspacing="0" class="TabBar">');
   htp.p('        <tr> ');
   htp.p('          <td><img src="'||nm3web.get_download_url('BarLeft.gif')||'" width="10" height="27"></td>');
   htp.p('          <td><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
   FOR i IN 1..3
    LOOP
      htp.p('          <td nowrap class="Tab">');
      IF i != p_page
       THEN
         htp.p('<a href="'||g_package_name||'.accident'||i||'?pi_acc_id='||pi_acc_id||'" class="TabLink">');
      END IF;
      htp.p('ST-3 Details Page '||i);
      IF i != p_page
       THEN
         htp.p('</a>');
      END IF;
      htp.p('</td>');
      IF i <3
       THEN
         htp.p('          <td nowrap class="Tab"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
      END IF;
   END LOOP;
--   htp.p('          <td nowrap class="Tab"><a href="'||g_package_name||'.accident2?pi_acc_id='||pi_acc_id||'" class="TabLink">ST-3 ');
--   htp.p('            Details Page 2</a></td>');
--   htp.p('          <td><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"><img src="'||nm3web.get_download_url('TabLeft.gif')||'" width="21" height="27"></td>');
--   htp.p('          <td nowrap class="Tab"><a href="'||g_package_name||'.accident3?pi_acc_id='||pi_acc_id||'" class="TabLink">ST-3 ');
--   htp.p('            Details Page 3</a></td>');
   htp.p('          <td width="100%"><img src="'||nm3web.get_download_url('TabRight.gif')||'" width="20" height="27"></td>');
   htp.p('          <td><a href="javascript:showHidePicture()"><img src="'||nm3web.get_download_url('PictureButton.gif')||'" width="32" height="27" border="0" align="absmiddle"></a></td>');
   htp.p('          <td><img src="'||nm3web.get_download_url('BarRight.gif')||'" width="8" height="27"></td>');
   htp.p('        </tr>');
   htp.p('      </table></td>');
END do_tab_bar;
--
-----------------------------------------------------------------------------------
--
PROCEDURE update_pending_reason (pi_acc_id NUMBER, pi_pending_reason acc_items_all.acc_status%TYPE) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF pi_acc_id IS NOT NULL
    THEN
      UPDATE acc_items_all_all
       SET   acc_status = pi_pending_reason
      WHERE  acc_id     = pi_acc_id;
   END IF;
   home;
   COMMIT;
END update_pending_reason;
--
-----------------------------------------------------------------------------------
--
END texas_accident_demo;
/
