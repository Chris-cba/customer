create table XOX_FMS_TRIGGER_LOOKUP 
(
STATUS_CODE varchar2(4),
STATUS_NAME Varchar2(30),
STATUS Varchar2(30),
Description Varchar2(512)


);




Insert into XOX_FMS_TRIGGER_LOOKUP (STATUS_NAME,STATUS,DESCRIPTION,STATUS_CODE) values ('REFERRED','OPEN','This call has been referred to an Officer within the Highways Department of Oxfordshire County Council','RF');
Insert into XOX_FMS_TRIGGER_LOOKUP (STATUS_NAME,STATUS,DESCRIPTION,STATUS_CODE) values ('INSPECTED','OPEN','The issue reported in this call has been inspected by an Oxfordshire County Council Highways Inspector and appropriate action has been taken','WI');
Insert into XOX_FMS_TRIGGER_LOOKUP (STATUS_NAME,STATUS,DESCRIPTION,STATUS_CODE) values ('COMPLETED','CLOSED','The issue reported in this call has now been fixed','CO');

Commit;