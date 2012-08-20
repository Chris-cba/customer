set serveroutput on
set echo on
spool install.log
@X_LBTH_XML_SPECIAL_CHARS.fnc
@X_LBTH_START_DATIM.fnc
@X_LBTH_END_DATIM.fnc
@V_X_LBTH_TMA_EXTRACT.vw
@x_lbth_export_tma_as_xml.prc
spool off
