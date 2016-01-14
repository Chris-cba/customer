CREATE OR REPLACE PACKAGE BODY x_tfl_woot
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Fix installs/im4_4500_tfl_fix1/admin/pck/x_tfl_woot.pkb-arc   1.0   Jan 14 2016 21:04:48   Sarah.Williams  $
--       Module Name      : $Workfile:   x_tfl_woot.pkb  $
--       Date into PVCS   : $Date:   Jan 14 2016 21:04:48  $
--       Date fetched Out : $Modtime:   Oct 11 2012 21:30:04  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : PStanton
--
--   x_tfl_woot body
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

  g_package_name CONSTANT varchar2(30) := '%YourObjectName%';
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
-----------------------------------------------------------------------------
--
PROCEDURE IM511001_POPULATE_CHART_DATA IS

CURSOR non_defect IS
select days2 days,nvl("Non Defective",0) col_value from
(select days,sum(priority) "Non Defective" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority is null
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;


CURSOR get_1a IS
select days2 days,nvl("1A",0) col_value from
(select days,sum(priority) "1A" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '1A'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR get_2H IS
select days2 days,nvl("2H",0) col_value from
(select days,sum(priority) "2H" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2H'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

Cursor get_2m IS
select days2 days,nvl("2M",0) col_value  from
(select days,sum(priority) "2M" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2M'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR get_2L is
select days2 days,nvl("2L",0) col_value from
(select days,sum(priority) "2L" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2L'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR work_order_numbers IS
select distinct(works_order_number), case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end days,  nvl(defect_priority,'NON') def_pri
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority is null
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD')
union
select distinct(works_order_number), case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end days,  nvl(defect_priority,'NON') def_pri
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority in ('1A','2H','2M','2L')
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and nvl(haud_old_value,'Empty') not in ('REJ','HLD');


n_run_id number;

BEGIN

    select X_im511001_seq.nextval into n_run_id from dual;

   insert into x_IM511001
   (run_id)
   values
   (n_run_id);

   FOR i in non_defect LOOP

      IF i.days = '0-1' THEN

         update  x_IM511001
         set non_col1 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511001
         set non_col2 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511001
         set non_col3 = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;


 FOR i in get_1a LOOP

      IF i.days = '0-1' THEN

         update  x_IM511001
         set col1_1A  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511001
         set col2_1A  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511001
         set col3_1A  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2h LOOP

      IF i.days = '0-1' THEN

         update  x_IM511001
         set col1_2h  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511001
         set col2_2h  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511001
         set col3_2h  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2m LOOP

      IF i.days = '0-1' THEN

         update  x_IM511001
         set col1_2m  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511001
         set col2_2m  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511001
         set col3_2m  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2L LOOP

      IF i.days = '0-1' THEN

         update  x_IM511001
         set col1_2L  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511001
         set col2_2L  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511001
         set col3_2L  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

delete from x_IM511001
where run_id = 1;
commit;

insert into x_IM511001
select 1,NON_COL1,  NON_COL2,  NON_COL3,  COL1_1A,  COL2_1A,  COL3_1A,  COL1_2H,  COL2_2H,  COL3_2H,  COL1_2M,  COL2_2M,  COL3_2M,  COL1_2L,  COL2_2L,  COL3_2L from  x_IM511001 where run_id = n_run_id;
commit;



FOR i in work_order_numbers LOOP

   insert into  x_im511001_wo
   values
   (n_run_id,
   i.works_order_number,
   i.days,
   i.def_pri);

END LOOP;

delete from x_im511001_wo
where run_id = 1;
commit;

insert into x_im511001_wo
select 1,work_order_number,days, def_pri from  x_IM511001_wo where run_id = n_run_id;
commit;

delete from x_im511001_wo
where run_id = n_run_id;
commit;

delete from X_IM511001
where run_id = n_run_id;
commit;


END IM511001_POPULATE_CHART_DATA;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE IM511002_POPULATE_CHART_DATA IS

CURSOR non_defect IS
select days2 days,nvl("Non Defective",0) col_value from
(select days,sum(priority) "Non Defective" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority is null
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;


CURSOR get_1a IS
select days2 days,nvl("1A",0) col_value from
(select days,sum(priority) "1A" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '1A'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR get_2H IS
select days2 days,nvl("2H",0) col_value from
(select days,sum(priority) "2H" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2H'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

Cursor get_2m IS
select days2 days,nvl("2M",0) col_value  from
(select days,sum(priority) "2M" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2M'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR get_2L is
select days2 days,nvl("2L",0) col_value from
(select days,sum(priority) "2L" from
(select distinct (case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end) days
,1 priority, works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority = '2L'
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
)
group by days
order by days),
(select days2 from
(select '0-1' as days2 from dual) union (select '2-7' as days2 from dual)
union (select '>7' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR work_order_numbers IS
select distinct(works_order_number), case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end days,  nvl(defect_priority,'NON') def_pri
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority is null
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD')
union
select distinct(works_order_number), case when trunc(sysdate-haud_timestamp) <= 1 then '0-1'
when trunc(sysdate-haud_timestamp) > 1 and trunc(sysdate-haud_timestamp) <= 7 then '2-7'
when trunc(sysdate-haud_timestamp) > 7 then '>7' end days,  nvl(defect_priority,'NON') def_pri
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and works_order_status = 'DRAFT'
and defect_priority in ('1A','2H','2M','2L')
and WOR_CHAR_ATTRIB100 = 'RDY'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'RDY')
and haud_old_value in ('REJ','HLD');



n_run_id number;

BEGIN

    select X_im511002_seq.nextval into n_run_id from dual;

   insert into x_IM511002
   (run_id)
   values
   (n_run_id);

   FOR i in non_defect LOOP

      IF i.days = '0-1' THEN

         update  x_IM511002
         set non_col1 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511002
         set non_col2 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511002
         set non_col3 = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;


 FOR i in get_1a LOOP

      IF i.days = '0-1' THEN

         update  x_IM511002
         set col1_1A  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511002
         set col2_1A  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511002
         set col3_1A  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2h LOOP

      IF i.days = '0-1' THEN

         update  x_IM511002
         set col1_2h  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511002
         set col2_2h  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511002
         set col3_2h  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2m LOOP

      IF i.days = '0-1' THEN

         update  x_IM511002
         set col1_2m  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511002
         set col2_2m  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511002
         set col3_2m  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

FOR i in get_2L LOOP

      IF i.days = '0-1' THEN

         update  x_IM511002
         set col1_2L  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '2-7' THEN

         update  x_IM511002
         set col2_2L  = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '>7' THEN

         update  x_IM511002
         set col3_2L  = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

delete from x_IM511002
where run_id = 1;
commit;

insert into x_IM511002
select 1,NON_COL1,  NON_COL2,  NON_COL3,  COL1_1A,  COL2_1A,  COL3_1A,  COL1_2H,  COL2_2H,  COL3_2H,  COL1_2M,  COL2_2M,  COL3_2M,  COL1_2L,  COL2_2L,  COL3_2L from  x_IM511002 where run_id = n_run_id;
commit;

FOR i in work_order_numbers LOOP


insert into  x_im511002_wo
   values
   (n_run_id,
   i.works_order_number,
   i.days,
   i.def_pri);


END LOOP;

delete from x_im511002_wo
where run_id = 1;
commit;


insert into x_im511002_wo
select 1,work_order_number,days, def_pri  from  x_IM511002_wo where run_id = n_run_id;
commit;

delete from x_im511002_wo
where run_id = n_run_id;
commit;

END IM511002_POPULATE_CHART_DATA;
--
---------------------------------------------------------------------------------------------------------------------
--
PROCEDURE IM511003_POPULATE_CHART_DATA IS

CURSOR non_lump_sum IS
select days2 days,nvl("Non LS",0) col_value from
(select days,sum(contract) "Non LS" from
(select (case when trunc(sysdate-wor_date_raised) <=21 then '0-2'
when trunc(sysdate-wor_date_raised) > 2 and trunc(sysdate-wor_date_raised) <= 5 then '3-5'
when trunc(sysdate-wor_date_raised) > 5 and trunc(sysdate-wor_date_raised) <= 30 then '6-30'
when trunc(sysdate-wor_date_raised) > 30 then '>30' end) days
,1 contract
from work_orders wor
where (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)  = 'DRAFT'
and nvl(wor_descr,'Empty') not like '%**Cancelled**%'
and nvl(WOR_CHAR_ATTRIB100,'Empty') not in ('RDY','HLD','REJ')
and  wor_works_order_no not like '%LS%'
)
group by days
order by days),
(select days2 from
(select '0-2' as days2 from dual) union (select '3-5' as days2 from dual)
union (select '6-30' as days2 from dual) union (select '>30' as days2 from dual))
where days(+)=days2
order by days2;

CURSOR lump_sum IS
select days2 days,nvl("LS",0) col_value from
(select days,sum(contract) "LS" from
(select (case when trunc(sysdate-wor_date_raised) <=21 then '0-2'
when trunc(sysdate-wor_date_raised) > 2 and trunc(sysdate-wor_date_raised) <= 5 then '3-5'
when trunc(sysdate-wor_date_raised) > 5 and trunc(sysdate-wor_date_raised) <= 30 then '6-30'
when trunc(sysdate-wor_date_raised) > 30 then '>30' end) days
,1 contract
from work_orders wor
where (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)  = 'DRAFT'
and nvl(wor_descr,'Empty') not like '%**Cancelled**%'
and nvl(WOR_CHAR_ATTRIB100,'Empty') not in ('RDY','HLD','REJ')
and wor_works_order_no like '%LS%'
)
group by days
order by days),
(select days2 from
(select '0-2' as days2 from dual) union (select '3-5' as days2 from dual)
union (select '6-30' as days2 from dual) union (select '>30' as days2 from dual))
where days(+)=days2
order by days2;


CURSOR work_order_numbers IS
select distinct(wor_works_order_no), case when trunc(sysdate-wor_date_raised) <=21 then '0-2'
when trunc(sysdate-wor_date_raised) > 2 and trunc(sysdate-wor_date_raised) <= 5 then '3-5'
when trunc(sysdate-wor_date_raised) > 5 and trunc(sysdate-wor_date_raised) <= 30 then '6-30'
when trunc(sysdate-wor_date_raised) > 30 then '>30' end days
from work_orders wor
where (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)  = 'DRAFT'
and nvl(wor_descr,'Empty') not like '%**Cancelled**%'
and nvl(WOR_CHAR_ATTRIB100,'Empty') not in ('RDY','HLD','REJ')
and wor_works_order_no like '%LS%'
union
select distinct(wor_works_order_no), case when trunc(sysdate-wor_date_raised) <=21 then '0-2'
when trunc(sysdate-wor_date_raised) > 2 and trunc(sysdate-wor_date_raised) <= 5 then '3-5'
when trunc(sysdate-wor_date_raised) > 5 and trunc(sysdate-wor_date_raised) <= 30 then '6-30'
when trunc(sysdate-wor_date_raised) > 30 then '>30' end days
from work_orders wor
where (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)  = 'DRAFT'
and nvl(wor_descr,'Empty') not like '%**Cancelled**%'
and nvl(WOR_CHAR_ATTRIB100,'Empty') not in ('RDY','HLD','REJ')
and wor_works_order_no not like '%LS%';


n_run_id number;

BEGIN

    select X_im511003_seq.nextval into n_run_id from dual;

   insert into x_IM511003
   (run_id)
   values
   (n_run_id);

   FOR i in non_lump_sum LOOP

      IF i.days = '0-2' THEN

         update  x_IM511003
         set non_col1 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '3-5' THEN

         update  x_IM511003
         set non_col2 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '6-30' THEN

         update  x_IM511003
         set non_col3 = i.col_value
         where run_id = n_run_id;

       ELSIF i.days = '>30' THEN

         update  x_IM511003
         set non_col4 = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;

  FOR i in lump_sum LOOP

      IF i.days = '0-2' THEN

         update  x_IM511003
         set ls_col1 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '3-5' THEN

         update  x_IM511003
         set ls_col2 = i.col_value
         where run_id = n_run_id;

      ELSIF i.days = '6-30' THEN

         update  x_IM511003
         set ls_col3 = i.col_value
         where run_id = n_run_id;

       ELSIF i.days = '>30' THEN

         update  x_IM511003
         set ls_col4 = i.col_value
         where run_id = n_run_id;

      END IF;

END LOOP;


delete from x_IM511003
where run_id = 1;
commit;

insert into x_IM511003
select 1,non_col1, non_col2, non_col3, non_col4, ls_col1, ls_col2, ls_col3, ls_col4 from  x_IM511003 where run_id = n_run_id;
commit;

FOR i in work_order_numbers LOOP

   insert into  x_im511003_wo
   values
   (n_run_id,
   i.wor_works_order_no,
   i.days);

END LOOP;

delete from x_im511003_wo
where run_id = 1;
commit;

insert into x_im511003_wo
select 1,work_order_number, days from  x_IM511003_wo where run_id = n_run_id;
commit;

delete from x_im511003_wo
where run_id = n_run_id;
commit;

END IM511003_POPULATE_CHART_DATA;
--

--------------------------------------------------------------------------------------
--
Procedure populate_all_data is

BEGIN

x_tfl_woot.IM511001_POPULATE_CHART_DATA;
commit;

x_tfl_woot.IM511002_POPULATE_CHART_DATA;
commit;

x_tfl_woot.IM511003_POPULATE_CHART_DATA;
commit;

END;

END x_tfl_woot;
/
