/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: MV_XBCC_EQUIP_ATTR_VIEWS_ESUR.sql
	Author: JMM
	UPDATE01:	Original, 2014.04.28, JMM
*/

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XBCC_EQUIP_ATTR_VIEWS_ESUR';
   --name_array(2) := 'xBBB_EAV_Input';
     --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'TABLE';
		if i_count = 1 then
			execute immediate 'drop table ' || name_array(i);
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'VIEW';
		if i_count = 1 then
			execute immediate 'drop view ' || name_array(i);	
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'MATERIALIZED VIEW';
		if i_count = 1 then
			execute immediate 'drop MATERIALIZED VIEW ' || name_array(i);	
		end if;
   END LOOP;
END;
/

CREATE MATERIALIZED VIEW BRAMS_OWNER.XBCC_EQUIP_ATTR_VIEWS_ESUR 
TABLESPACE BRAMS_DATA
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 25/04/2014 12:08:39 AM (QP5 v5.163.1008.3004) */
SELECT mem_nm_ne_id_in esur_mem_nm_ne_id_in,
       mem_nm_obj_type esur_mem_nm_obj_type,
       begin_mp_no esur_SLK,
       end_mp_no esur_END_SLK,
       aloc_nm_ne_id_in "SURVEY_ID",
       IIT_DATE_ATTRIB86 Survey_Date,
       IIT_CHR_ATTRIB26 Survey_Type
  FROM (  SELECT mem_nm_ne_id_in,
                 aloc_nm_ne_id_in,
                 mem_nm_obj_type,
                 MIN (begin_mp_no) begin_mp_no,
                 MAX (end_mp_no) end_mp_no,
                 DBSMP
            FROM (SELECT mem_nm_ne_id_in,
                         aloc_nm_ne_id_in,
                         mem_nm_obj_type,
                         begin_mp_no,
                         end_mp_no,
                         db,
                         DBTSMP,
                         CASE
                            WHEN (LAG (
                                     end_mp_no)
                                  OVER (
                                     PARTITION BY aloc_nm_ne_id_in,
                                                  mem_nm_ne_id_in
                                     ORDER BY begin_mp_no)) <> begin_mp_no
                            THEN
                               begin_mp_no
                            ELSE
                               (LAST_VALUE (
                                   DBTSMP IGNORE NULLS)
                                OVER (
                                   PARTITION BY aloc_nm_ne_id_in,
                                                mem_nm_ne_id_in
                                   ORDER BY begin_mp_no
                                   ROWS BETWEEN UNBOUNDED PRECEDING
                                        AND     1 PRECEDING))
                         END
                            DBSMP,
                         tt
                    FROM (SELECT mem_nm_ne_id_in,
                                 aloc_nm_ne_id_in,
                                 mem_nm_obj_type,
                                 begin_mp_no,
                                 end_mp_no,
                                 CASE
                                    WHEN (LAG (
                                             end_mp_no)
                                          OVER (
                                             PARTITION BY aloc_nm_ne_id_in,
                                                          mem_nm_ne_id_in
                                             ORDER BY begin_mp_no)) <>
                                            begin_mp_no
                                    THEN
                                       'Y'
                                    ELSE
                                       'N'
                                 END
                                    DB,
                                 CASE
                                    WHEN (LAG (
                                             end_mp_no)
                                          OVER (
                                             PARTITION BY aloc_nm_ne_id_in,
                                                          mem_nm_ne_id_in
                                             ORDER BY begin_mp_no) <>
                                             begin_mp_no)
                                    THEN
                                       begin_mp_no
                                    ELSE
                                       NULL
                                 END
                                    DBTSMP,
                                 LAG (
                                    end_mp_no)
                                 OVER (
                                    PARTITION BY aloc_nm_ne_id_in,
                                                 mem_nm_ne_id_in
                                    ORDER BY begin_mp_no)
                                    tt
                            --
                            FROM (SELECT mem.nm_ne_id_in mem_nm_ne_id_in,
                                         mem.nm_obj_type mem_nm_obj_type,
                                         aloc.nm_ne_id_in aloc_nm_ne_id_in,
                                         DECODE (
                                            MEM.NM_CARDINALITY,
                                            1, mem.nm_slk + aloc.nm_begin_mp,
                                            -1, mem.nm_end_slk
                                                - aloc.nm_begin_mp)
                                            begin_MP_NO,
                                         DECODE (
                                            MEM.NM_CARDINALITY,
                                            1, mem.nm_slk + aloc.nm_end_mp,
                                            -1, mem.nm_end_slk
                                                - aloc.nm_begin_mp)
                                            END_MP_NO
                                    FROM nm_members aloc, nm_members mem
                                   WHERE 1 = 1
                                         AND mem.nm_obj_type IN
                                                ('RDCO', 'VECO', 'KCOR')
                                         AND aloc.nm_type = 'I'
                                         AND aloc.nm_obj_type = 'ESUR'
                                         AND mem.nm_ne_id_of = aloc.nm_ne_id_of) base1)) base2
        GROUP BY mem_nm_ne_id_in,
                 mem_nm_obj_type,
                 aloc_nm_ne_id_in,
                 DBSMP) a,
       (SELECT * FROM nm_inv_items) b,
       (SELECT ne_id, ne_unique FROM nm_elements) c
 WHERE b.iit_ne_id = a.aloc_nm_ne_id_in AND a.mem_nm_ne_id_in = c.ne_id;

COMMENT ON MATERIALIZED VIEW BRAMS_OWNER.XBCC_EQUIP_ATTR_VIEWS_ESUR IS 'snapshot table for snapshot BRAMS_OWNER.XBCC_EQUIP_ATTR_VIEWS_ESUR';

create index XBCC_EQUIP_ATTR_VIEWS_ESUR_IDX on XBCC_EQUIP_ATTR_VIEWS_ESUR(esur_mem_nm_ne_id_in);
