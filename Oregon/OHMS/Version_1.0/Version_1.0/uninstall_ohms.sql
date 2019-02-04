/*<TOAD_FILE_CHUNK>*/

delete from HIG_STANDARD_FAVOURITES where HSTF_PARENT = 'OHMS';

delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD = 'OHMS';

delete from GRI_MODULES where GRM_MODULE = 'OHMS_RUN';


delete from HIG_MODULES where 
 HMO_APPLICATION = 'OHMS';

declare

l_merge_id NM_MRG_QUERY_ALL.nmq_id%type;

begin


    select nmq_id into l_merge_id from NM_MRG_QUERY_ALL where NMQ_UNIQUE = 'OHMS_EXTRACT';
    
    delete from  NM_MRG_QUERY_ALL where NMQ_ID = l_merge_id;
    
    exception
    when others then null;
    
end;
/
/*<TOAD_FILE_CHUNK>*/

DROP TABLE V_NM_OHMS_NW CASCADE CONSTRAINTS;
DROP TABLE OHMS_SUBMIT_SAMPLES;

DROP MATERIALIZED VIEW V_NM_CURB137_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_NBI104_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM107_COUNT_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM109_COUNT_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM110_COUNT_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM111_COUNT_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM137_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM138_SUM_MV_NW;
DROP MATERIALIZED VIEW V_NM_RDGM139_SUM_MV_NW;

DROP MATERIALIZED VIEW V_NM_ROAD131_COUNT_MV_NW;

DROP MATERIALIZED VIEW V_NM_ROAD133_COUNT_MV_NW;

DROP MATERIALIZED VIEW V_NM_SHLD137_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_SPZN114_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_TUNL104_OUTER_MV_NW;
DROP MATERIALIZED VIEW V_NM_URBN114_OUTER_MV_NT;

drop package XODOT_POPULATE_OHMS_SECTIONS;

drop package xodot_OHMS;
