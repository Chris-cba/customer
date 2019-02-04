create or replace view XCTDOT_PW_PROJ_FT as
select 
--
projecttypeid	projecttypeid,
CAST ("o_projectname" as varchar2(63)) PROJ_NAME,
CAST ("o_projectdesc" as varchar2(127)) PROJ_DESCRIPTION,
--
CAST (substr("PROJECT_Project_Description",1,200)		 as VARCHAR2 (200))					PROJ_DESC_TITLE ,
CAST (substr("PROJECT_ASSETS__Bridge_Nos_in_",1,500)		 as VARCHAR2 (500))				ASSETS_BRIDGE_NOS_IN,
CAST ("PROJECT_ASSETS__Pavement_Treat"		 as VARCHAR2 (75))								ASSETS_PAVEMENT_TREAT,
CAST ("PROJECT_ASSETS__Retaining_Wall"		 as VARCHAR2 (500))								ASSETS_RETAINING_WALL,
CAST ("PROJECT_ASSETS__Sign_Structure"		 as VARCHAR2 (500))								ASSETS_SIGN_STRUCTURE,
CAST (substr("PROJECT_ASSETS__Signal_System_",1,500)		 as VARCHAR2 (500))				ASSETS_SIGNAL_SYSTEM,
CAST ("PROJECT_Cons_Project_Inspector"		 as VARCHAR2 (500))								CONS_INSPECTOR,
CAST (substr("PROJECT_Cons_Project_Manager",1,200)		 as VARCHAR2 (200))					CONS_MANAGER,
CAST (substr("PROJECT_Construction__As_Built",1,200)		 as VARCHAR2 (200))				CONS_AS_BUILT,
CAST (substr("PROJECT_Contractor",1,200)		 as VARCHAR2 (200))							CONTRACTOR,
CAST ("PROJECT_COST__PE_Expenditures"		 as NUMBER (38))								COST_PE_EXPENDITURES,
CAST ("PROJECT_COST__ROW_EstBudget"		 as NUMBER (38))									COST_ROW_ESTBUDGET,
CAST (substr("PROJECT_Design__Consultant_Eng",1,200)		 as VARCHAR2 (200))				DES_CONSULTANT_ENG,
CAST (substr("PROJECT_Consultant_Designed_",1,200)		 as VARCHAR2 (200))					CONS_DES_PRIMARY,
CAST (substr("PROJECT_CTDOT_Project_Manager",1,200)		 as VARCHAR2 (200))					DES_PROJ_MAN,
CAST ("PROJECT_DESIGN__Project_Manage"		 as VARCHAR2 (50))								DES_PROJ_MAN_EMAIL,
CAST (substr("PROJECT_FHWA_Oversight",1,200)		 as VARCHAR2 (200))						FHWA_OVERSIGHT,
CAST ("PROJECT_General__Program_Numbe"		 as VARCHAR2 (25))								GEN_PROGRAM_NUMBE,
CAST ("PROJECT_GENERAL__Contract_Numb"		 as VARCHAR2 (25))								GEN_CONTR_NUM,
CAST ("PROJECT_General_Description"		 as VARCHAR2 (500))									GEN_DESCRIPTION,
CAST ("PROJECT_Project_Current_Phase"		 as VARCHAR2 (35))								PROJ_CURRENT_PHASE,
--CAST ("PROJECT_Project_Number"		 as VARCHAR2 (25))										PROJ_NUMBER,
CAST (to_char("PROJECT_SCHEDULE__FDP__Design_",  'DD-MON-YYYY')		 as varchar2(11))	SCHED_FDP_DES,
CAST (to_char("PROJECT_SCHEDULE__FDP__RPM"		,  'DD-MON-YYYY')		 as varchar2(11))										SCHED_FDP_RPM,
CAST (to_char("PROJECT_SCHEDULE__Notice_to_Pr"		 ,  'DD-MON-YYYY')		 as varchar2(11))										SCHED_NOTICE_TO_PR,
CAST (to_char("PROJECT_SCHEDULE__Project_Init"		 ,  'DD-MON-YYYY')		 as varchar2(11))										SCHED_INIT,
CAST (to_char("PROJECT_SCHEDULE__RPM_Date"		 ,  'DD-MON-YYYY')		 as varchar2(11))											SCHED_RPM_DATE,
CAST (substr("PROJECT_Remarks",1,200)		 				as VARCHAR2 (200))				PROJ_REMARKS,
--
--
CAST (substr("PROJECT_GENERAL__Project_Inher",1,40)		 as VARCHAR2 (40))					GEN_PROJ_INHERITED ,
CAST (substr("PROJECT_GENERAL__Phase_Types_I",1,20)		 as VARCHAR2 (20))					GEN_PHASE_TYPES_INCL ,
CAST (substr("PROJECT_GENERAL__STIP_Status",1,20)		 as VARCHAR2 (20))					GEN_STIP_STATUS ,
CAST (to_char("PROJECT_Schedule__ROW_Initiati",'MM/DD/RRRR')		 as VARCHAR2 (200))					SCHED_ROW_INIT ,
--
CAST ("PROJECT_COST__ROW_Expenditures"		 as number(36,2))						COST_ROW_EXPENDITURES,
CAST ("PROJECT_COST__Construction_Exp"		 as number(36,2))					COST_CONST_EXP ,
CAST (to_char("PROJECT_Project_End_Date")		as varchar2(12))					PROJ_END_DATE ,
CAST (substr("PROJECT_PROJECT_End_Date_Reaso",1,25)		 as VARCHAR2 (25))					PROJ_END_DATE_REASON ,
--
--
CAST ("PROJECT_Assets__Towns"		 as VARCHAR2 (500))				LOC_TOWNS,
--CAST ("PROJECT_Bridge_Number"		 as VARCHAR2 (15))			Bridge_Number	/* Not in FT */,
CAST (to_char("PROJECT_CON_CCD"		 ,  'DD-MON-YYYY')		 as varchar2(11))				SCHED_CURRENT_EST_CCD,
CAST (to_char("PROJECT_Constr_ADV"		 ,  'DD-MON-YYYY')		 as varchar2(11))				SCHED_ADV_CURRENT,
CAST ("PROJECT_Constr_Completed"		 as DATE)				SCHED_CONS_COMPLETION,
CAST ("PROJECT_Constr_DCD"		 as DATE)				SCHED_CURRENT_DCD,
CAST ("PROJECT_Constr_FDP"		 			as DATE)				SCHED_CURRENT_FDP,
CAST ("PROJECT_CONSTRUCTION__Consulta"		as VARCHAR2 (75))				CONS_CONSULTANT_INSPECT_FIRM,
CAST ("PROJECT_CONSTRUCTION__Primary_"		as VARCHAR2 (75))				CONS_PRIMARY_INSPECTOR,
CAST ("PROJECT_CONSTRUCTION__Supervis"		as VARCHAR2 (75))				CONS_SUPERVISING_ENGINEER,
CAST ("PROJECT_Construction_Percent_C"		as NUMBER (10))				CONS_PERCENT_COMPLETE,
CAST ("PROJECT_CONSTRUCTION_Supervisi"		as VARCHAR2 (500))			CONS_SUPERVISING_ENG_EMAIL,
CAST ("PROJECT_Financial__Original_Co"		as NUMBER (38))				COST_CONS_ORIG_CONTRACT_VAL,
CAST ("PROJECT_Financial__Revised_Con"		as NUMBER (38))				COST_REVISED_ORIG_CONTRACT_VAL,
CAST ("PROJECT_COST_ConstrTotalEstima"		as NUMBER (38))				COST_CONS_TOT_EST_AT_DCD,
CAST ("PROJECT_SCHEDULE__Constructio1"		as DATE)				SCHED_CONST_INIT,
--CAST ("PROJECT_COST__Construction_To2"		as NUMBER (38))				COST_CONS_TOT_EST_AT_DES_APPR,
CAST ("PROJECT_COST__Construction_Tot"		as NUMBER (38))				COST_CONS_TOT_EST_AT_RPM,
CAST ("PROJECT_COST__PE_Est__Design_A"		as NUMBER (38))				COST_PE_EST_AT_DES_APPR,
CAST ("PROJECT_COSTS__Total_Project_C"		as NUMBER (38))				COST_TOT_PROJ_EST,
CAST ("PROJECT_COST_Current_Constr_To"		as NUMBER (38))				COST_CURRENT_CONS_TOT_EST,
CAST ("PROJECT_COST__Construction_To1"		as NUMBER (38))				COST_CONS_TOT_EST_AT_DES_APPR,
CAST ("PROJECT_CTDOT_Project_Engineer"		as VARCHAR2 (50))			DES_PROJECT_ENGINEER,
CAST (substr("PROJECT_DISTRICT",1,200)		as VARCHAR2 (200))			PROJECT_DISTRICT,
CAST ("PROJECT_GENERAL__Project_Scope"		as VARCHAR2 (25))			GEN_PROJECT_SCOPE_CODE,
CAST ("PROJECT_LOCATION__Milepoint_En"		as NUMBER (38))				LOC_END_MILEPOINT,
CAST ("PROJECT_LOCATION__Milepoint_St"		as NUMBER (38))				LOC_BEGIN_MILEPOINT,
CAST ("PROJECT_Percent_Design_Complet"		as NUMBER (10))				DES_PERCENT_COMPLETE,
CAST ("PROJECT_Routes"		 				as VARCHAR2 (500))			LOC_ROUTES,
CAST ("PROJECT_SCHEDULE__Contract_Awa"		as varchar2(50))			SCHED_AWARD,
CAST ("PROJECT_SCHEDULE__Design_Appro"		as DATE)				SCHED_DATE_OF_DES_APPR,
CAST ("PROJECT_SCHEDULE__Estimated_CC"		as DATE)				SCHED_EST_CCD_AT_AWARD,
--CAST ("PROJECT_SIGNAL_SYSTEM_NO"		 	as VARCHAR2 (500))		SIGNAL_SYSTEM_NO,		/*Confirm that we should not use this instead of PROJECT_ASSETS__Signal_System_ */
CAST ("PROJECT_Project_Type"				as VARCHAR2 (25))				PROJ_TYPE,
CAST ("o_projguid"							as VARCHAR2 (36))				PROJ_GUID
--
from
XCTDOT_PW_PROJ_MV
;