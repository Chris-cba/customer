--

-- Version 3 - Richard Ellis May 2011


--
-- Descr   : drops views XODOT_BARR_V, XODOT_IATN_V 
--           
--
-- ******************************************************************************

spool Roadside_barrier_uninstall.log

drop snapshot XODOT_BARR_V;

drop view XODOT_BARR_V;

drop snapshot XODOT_IATN_V;
drop view XODOT_IATN_V;
spool off;

