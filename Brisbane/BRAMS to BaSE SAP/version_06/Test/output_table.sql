create table  z_brams_base_output_delete
(
	  run_id 			number
	, run_timestamp 	date
	, i_start_date 		date
	, i_end_date 		date
	, i_brams_id 		number(12)
	, o_indicator		varchar2(200)
	, o_brams_id		varchar2(200)
	, o_object			varchar2(200)
	, o_name			varchar2(200)
	, o_START			varchar2(200)
	, o_END				varchar2(200)	
);