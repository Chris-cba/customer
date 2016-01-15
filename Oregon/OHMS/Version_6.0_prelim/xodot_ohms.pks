create or replace package xodot_ohms
is

procedure  create_submit_samples;



PROCEDURE run_merge_all(p_job_id OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE,
                        p_mrg_id NM_MRG_QUERY.NMQ_ID%TYPE
                       ) ;
                       
PROCEDURE ohms_report;
                       
procedure create_extract;

procedure Update_SampleID;

end xodot_ohms;
/
