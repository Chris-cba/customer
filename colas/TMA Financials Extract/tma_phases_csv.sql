CREATE OR REPLACE procedure HIGHWAYS.tma_phases_csv
as
    l_rows  number;

begin
    l_rows := dump_csv( 'select tphs_phase_status , tphs_act_start_date, tphs_act_end_date , tphs_duration_value , tphs_works_id, tphs_est_end_date, tphs_proposed_start_date, TPHS_ACTIVE_FLAG from tma_phases',chr(9),'D:\bentley_dir\colaprd\extracts\financials','tma_phases.csv' );
end;
/

