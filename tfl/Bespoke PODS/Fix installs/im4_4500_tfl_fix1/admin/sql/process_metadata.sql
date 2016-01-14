SET DEFINE OFF;
Insert into HIG_PROCESS_TYPES
   (HPT_PROCESS_TYPE_ID, HPT_NAME, HPT_DESCR, HPT_WHAT_TO_CALL, HPT_RESTARTABLE, HPT_SEE_IN_HIG2510, HPT_POLLING_ENABLED)
 Values
   (HPT_PROCESS_TYPE_ID_SEQ.nextval, 'Generate Work Order Work Tray Data1', 'Process to generate the data required for the Work Order Work ttay Pods in IM4', 'x_tfl_woot.IM511001_POPULATE_CHART_DATA;', 
    'Y', 'Y', 'N');
Insert into HIG_PROCESS_TYPES
   (HPT_PROCESS_TYPE_ID, HPT_NAME, HPT_DESCR, HPT_WHAT_TO_CALL, HPT_RESTARTABLE, HPT_SEE_IN_HIG2510, HPT_POLLING_ENABLED)
 Values
   (HPT_PROCESS_TYPE_ID_SEQ.nextval, 'Generate Work Order Work Tray Data2', 'Process required to generate the work order work tray data for IM4', 'x_tfl_woot.IM511002_POPULATE_CHART_DATA;', 
    'Y', 'Y', 'N');
Insert into HIG_PROCESS_TYPES
   (HPT_PROCESS_TYPE_ID, HPT_NAME, HPT_DESCR, HPT_WHAT_TO_CALL, HPT_RESTARTABLE, HPT_SEE_IN_HIG2510, HPT_POLLING_ENABLED)
 Values
   (HPT_PROCESS_TYPE_ID_SEQ.nextval,'Generate Work Order Work Tray Data3', 'Process required to generate work order work tray data for IM4', 'x_tfl_woot.IM511003_POPULATE_CHART_DATA;', 
    'Y', 'Y', 'N');
COMMIT;

insert into hig_process_type_frequencies
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data1'), -3,null from dual;


insert into hig_process_type_frequencies
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data2'), -3,null from dual;

insert into hig_process_type_frequencies
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data3'), -3,null from dual;
commit;

insert into hig_process_type_roles
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data1'), 'HIG_USER' from dual

insert into hig_process_type_roles
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data2'), 'HIG_USER' from dual

insert into hig_process_type_roles
select  (select HPT_PROCESS_TYPE_ID from HIG_PROCESS_TYPES where HPT_NAME = 'Generate Work Order Work Tray Data3'), 'HIG_USER' from dual