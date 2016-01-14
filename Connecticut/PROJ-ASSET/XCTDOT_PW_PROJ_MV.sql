drop MATERIALIZED VIEW ATLAS.XCTDOT_PW_PROJ_MV ;

CREATE MATERIALIZED VIEW ATLAS.XCTDOT_PW_PROJ_MV 
TABLESPACE ATLAS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('01-02-2014','dd-mm-yyyy')
NEXT TRUNC (SYSDATE + 1)   + 0 / 24 
WITH PRIMARY KEY
AS
SELECT 
"PROJECTTYPEID",
"PROJECT_Project_Number",
"PROJECT_Project_Description",
"PROJECT_Digitally_Signed",
"PROJECT_Town_Number",
"PROJECT_Routes",
"PROJECT_Bridge_Number",
"PROJECT_Project_Type",
"Project_Phase",
"PROJECT_Project_Current_Phase",
"PROJECT_Consultant_Designed_",
"PROJECT_FHWA_Oversight",
"PROJECT_Percent_Design_Complet",
"PROJECT_CTDOT_Project_Manager",
"PROJECT_CTDOT_Project_Engineer",
"PROJECT_Constr_FDP",
"PROJECT_Constr_DCD",
"PROJECT_Constr_ADV",
"PROJECT_CON_CCD",
"PROJECT_ROW_AUTH",
"PROJECT_Contractor",
"PROJECT_DISTRICT",
"PROJECT_Construction_Percent_C",
"PROJECT_Cons_Project_Manager",
"PROJECT_Cons_Project_Inspector",
"PROJECT_Constr_Completed",
"PROJECT_Remarks",
"PROJECT_Final_Cost",
"PROJECT_General_Description",
"PROJECT_SIGNAL_SYSTEM_NO",
"PROJECT_Design__Consultant_Eng",
"PROJECT_Financial__PE_Cost_Est",
"PROJECT_Finacial__Construction",
"PROJECT_Construction__As_Built",
"PROJECT_ASSETS__Bridge_Numbers",
"PROJECT_Assets__Towns",
"PROJECT_General__Program_Numbe",
"PROJECT_test",
"PROJECT_GENERAL__Project_Numbe",
"PROJECT_GENERAL__Project_Numb1",
"PROJECT_Financial__Initial_Con",
"PROJECT_Finacial__Revised_Cont",
"PROJECT_Financial__Revised_Con",
"PROJECT_Financial__Final_Cost_",
"PROJECT_Financial__Original_Co",
"test1",
"PROJECT_test_2",
"PROJECT_ASSETS_Test3",
"PROJECT_GENERAL__CADD_Standard",
"PROJECT_ASSETS__Signal_System_",
"PROJECT_ASSETS__Bridge_No",
"PROJECT_ASSETS__Bridge_Nos_in_",
"PROJECT_ASSETS__Sign_Structure",
"PROJECT_GENERAL__Project_Scope",
"PROJECT_LOCATION__Milepoint_St",
"PROJECT_LOCATION__Milepoint_En",
"PROJECT_ASSETS__Pavement_Treat",
"PROJECT_ASSETS__Retaining_Wall",
"PROJECT_SCHEDULE__RPM_Date",
"PROJECT_SCHEDULE__Project_Init",
"PROJECT_SCHEDULE__Design_Appro",
"PROJECT_SCHEDULE__FDP__RPM",
"PROJECT_SCHEDULE__FDP__Design_",
"PROJECT_SCHEDULE__Contract_Awa",
"PROJECT_SCHEDULE__Notice_to_Pr",
"PROJECT_SCHEDULE__Estimated_CC",
"PROJECT_SCHEDULE__Construction",
"PROJECT_COST__PE_Est__Design_A",
"PROJECT_COST__PE_Expenditures",
"PROJECT_COST__ROW_EstBudget",
"PROJECT_COST__Construction_Tot",
"PROJECT_COST__Construction_To1",
"PROJECT_COST__Construction_To2",
"PROJECT_COST_Current_Constr_To",
"PROJECT_COST__Constr_Original_",
"PROJECT_COST__Constr_Revised_C",
"PROJECT_COSTS__Total_Project_C",
"PROJECT_DESIGN__Project_Manage",
"PROJECT_CONSTRUCTION__Supervis",
"PROJECT_CONSTRUCTION__Primary_",
"PROJECT_CONSTRUCTION__Consulta",
"PROJECT_CONSTRUCTION_Supervisi",
"PROJECT_COST_ConstrTotalEstima",
"PROJECT_GENERAL__Phase_Types_I",
"PROJECT_GENERAL__STIP_Status",
"PROJECT_Schedule__ROW_Initiati",
"PROJECT_SCHEDULE__Constructio1",
"PROJECT_COST__PE_Expenditures1",
"PROJECT_COST__ROW_Expenditures",
"PROJECT_COST__Construction_Exp",
"PROJECT_Project_End_Date",
"PROJECT_PROJECT_End_Date_Reaso",
"PROJECT_GENERAL__Project_Inher",
"PROJECT_LOCATION__MilePoint_E1",
"PROJECT_LOCATION__MilePoint_S1",
"PROJECT_GENERAL__Contract_Numb",
"o_projguid",
"o_pprjguid",
"o_projectno",
"o_envno",
"o_parentno",
"o_projectcode",
"o_projectname",
"o_projectdesc",
"o_version",
"o_version_seq",
"o_mgrtype",
"o_projectmgr",
"o_defaultstor",
"o_creatorno",
"o_credatetime",
"o_subprojects",
"o_updaterno",
"o_updatetime",
"o_workflowno",
"o_stateno",
"o_type",
"o_archiveno",
"o_wspaceprofno",
"o_extra_attr",
"o_locationid",
"o_locationsource",
"o_classid",
"o_flags",
"o_instanceid",
"o_aclno" 
FROM 
dbo.i_ctdot_transportation_project@TO_CT_PW.BENTLEYHOSTING.COM a
,  dbo.dms_proj@TO_CT_PW.BENTLEYHOSTING.COM b
where 1 =1
and projecttypeid = "o_instanceid"
and "o_classid" = 1365
;