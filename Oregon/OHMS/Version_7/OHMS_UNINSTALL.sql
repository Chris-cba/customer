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
DROP TABLE OHMS_ACTIVITY_LOG;


@zDrop_OHMS_TV.sql


drop Procedure XODOT_POPULATE_OHMS_SECTIONS;  
drop Procedure OHMS_SIGNAL_CNT;
drop package xodot_OHMS;

