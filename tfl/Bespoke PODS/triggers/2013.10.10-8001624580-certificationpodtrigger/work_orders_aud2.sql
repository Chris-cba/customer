CREATE OR REPLACE TRIGGER WORK_ORDERS_AUD2
AFTER Update
OF WOR_CHAR_ATTRIB100 ,WOR_CHAR_ATTRIB104 ,WOR_CHAR_ATTRIB106 ,WOR_NUM_ATTRIB50 ,WOR_CHAR_ATTRIB101 ,WOR_CHAR_ATTRIB110 ,WOR_CHAR_ATTRIB111 ,WOR_DATE_ATTRIB121 ,WOR_NUM_ATTRIB10 ,WOR_CHAR_ATTRIB102 ,WOR_CHAR_ATTRIB114 ,WOR_DATE_ATTRIB123 ,WOR_NUM_ATTRIB11 ,WOR_CHAR_ATTRIB103 ,WOR_DATE_ATTRIB122 ,WOR_CHAR_ATTRIB86 ,WOR_NUM_ATTRIB51 ,WOR_NUM_ATTRIB52 ,WOR_CHAR_ATTRIB113 ,WOR_CHAR_ATTRIB112 ,WOR_CHAR_ATTRIB107 ,WOR_CHAR_ATTRIB108 ,WOR_CHAR_ATTRIB109 ,WOR_NUM_ATTRIB53 ,WOR_WORKS_ORDER_NO ,WOR_PEO_PERSON_ID ,WOR_NUM_ATTRIB54 ,WOR_CHAR_ATTRIB105 ,WOR_CHAR_ATTRIB73 ,WOR_CHAR_ATTRIB74 ,WOR_CHAR_ATTRIB75 ,WOR_CHAR_ATTRIB115 ,WOR_CHAR_ATTRIB116 ,WOR_CHAR_ATTRIB117 ,WOR_CHAR_ATTRIB118 ,WOR_CHAR_ATTRIB119 ,WOR_CHAR_ATTRIB120 ,WOR_CHAR_ATTRIB61 ,WOR_CHAR_ATTRIB62 ,WOR_CHAR_ATTRIB63 ,WOR_CHAR_ATTRIB65 ,WOR_CHAR_ATTRIB66 ,WOR_CHAR_ATTRIB69 ,WOR_CHAR_ATTRIB70 ,WOR_CHAR_ATTRIB72 ,WOR_CHAR_ATTRIB76 ,WOR_CHAR_ATTRIB77 ,WOR_CHAR_ATTRIB79 ,WOR_CHAR_ATTRIB90 ,WOR_CHAR_ATTRIB91 ,WOR_DATE_ATTRIB124 ,WOR_DATE_ATTRIB125 ,WOR_DATE_ATTRIB126 ,WOR_DATE_ATTRIB127 ,WOR_DATE_ATTRIB128 ,WOR_DATE_ATTRIB130 ,WOR_NUM_ATTRIB01 ,WOR_NUM_ATTRIB02 ,WOR_DATE_ATTRIB129 ,WOR_CHAR_ATTRIB64 ,WOR_AGREED_BY ,WOR_DATE_AUTHORISED ,WOR_SCHEME_TYPE ,WOR_CHAR_ATTRIB95
ON WORK_ORDERS
For Each Row
DECLARE
--
-- Auditing Trigger for WORK_ORDERS
-- Generated 31-Mar-2013 05:21:21
-- automatically by hig_audit
-- hig_audit version information
-- Header : $Revision:   1.0  $
-- Body   : $Revision:   1.0  $
p_user_id number;
BEGIN
select x_get_im_user_id into p_user_id from dual;  -- added to account for IM4 users
IF Nvl(:OLD.WOR_CHAR_ATTRIB100,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB100,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB100',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB100,
:NEW.WOR_CHAR_ATTRIB100,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB104,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB104,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB104',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB104,
:NEW.WOR_CHAR_ATTRIB104,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB106,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB106,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB106',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB106,
:NEW.WOR_CHAR_ATTRIB106,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB50,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB50,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB50',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB50,
:NEW.WOR_NUM_ATTRIB50,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB101,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB101,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB101',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB101,
:NEW.WOR_CHAR_ATTRIB101,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB110,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB110,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB110',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB110,
:NEW.WOR_CHAR_ATTRIB110,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB111,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB111,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB111',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB111,
:NEW.WOR_CHAR_ATTRIB111,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB121,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB121,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB121',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB121),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB121),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB10,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB10,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB10',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB10,
:NEW.WOR_NUM_ATTRIB10,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB102,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB102,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB102',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB102,
:NEW.WOR_CHAR_ATTRIB102,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB114,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB114,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB114',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB114,
:NEW.WOR_CHAR_ATTRIB114,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB123,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB123,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB123',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB123),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB123),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB11,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB11,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB11',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB11,
:NEW.WOR_NUM_ATTRIB11,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB103,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB103,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB103',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB103,
:NEW.WOR_CHAR_ATTRIB103,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB122,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB122,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB122',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB122),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB122),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB86,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB86,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB86',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB86,
:NEW.WOR_CHAR_ATTRIB86,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB51,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB51,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB51',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB51,
:NEW.WOR_NUM_ATTRIB51,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB52,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB52,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB52',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB52,
:NEW.WOR_NUM_ATTRIB52,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB113,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB113,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB113',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB113,
:NEW.WOR_CHAR_ATTRIB113,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB112,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB112,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB112',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB112,
:NEW.WOR_CHAR_ATTRIB112,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB107,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB107,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB107',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB107,
:NEW.WOR_CHAR_ATTRIB107,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB108,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB108,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB108',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB108,
:NEW.WOR_CHAR_ATTRIB108,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB109,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB109,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB109',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB109,
:NEW.WOR_CHAR_ATTRIB109,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB53,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB53,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB53',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB53,
:NEW.WOR_NUM_ATTRIB53,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_WORKS_ORDER_NO,'$$$$$$$') !=  Nvl(:NEW.WOR_WORKS_ORDER_NO,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_WORKS_ORDER_NO',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_WORKS_ORDER_NO,
:NEW.WOR_WORKS_ORDER_NO,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_PEO_PERSON_ID,-9999999999) !=  Nvl(:NEW.WOR_PEO_PERSON_ID,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_PEO_PERSON_ID',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_PEO_PERSON_ID,
:NEW.WOR_PEO_PERSON_ID,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB54,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB54,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB54',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB54,
:NEW.WOR_NUM_ATTRIB54,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB105,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB105,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB105',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB105,
:NEW.WOR_CHAR_ATTRIB105,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB73,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB73,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB73',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB73,
:NEW.WOR_CHAR_ATTRIB73,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB74,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB74,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB74',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB74,
:NEW.WOR_CHAR_ATTRIB74,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB75,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB75,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB75',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB75,
:NEW.WOR_CHAR_ATTRIB75,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB115,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB115,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB115',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB115,
:NEW.WOR_CHAR_ATTRIB115,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB116,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB116,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB116',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB116,
:NEW.WOR_CHAR_ATTRIB116,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB117,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB117,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB117',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB117,
:NEW.WOR_CHAR_ATTRIB117,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB118,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB118,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB118',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB118,
:NEW.WOR_CHAR_ATTRIB118,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB119,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB119,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB119',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB119,
:NEW.WOR_CHAR_ATTRIB119,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB120,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB120,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB120',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB120,
:NEW.WOR_CHAR_ATTRIB120,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB61,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB61,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB61',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB61,
:NEW.WOR_CHAR_ATTRIB61,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB62,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB62,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB62',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB62,
:NEW.WOR_CHAR_ATTRIB62,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB63,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB63,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB63',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB63,
:NEW.WOR_CHAR_ATTRIB63,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB65,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB65,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB65',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB65,
:NEW.WOR_CHAR_ATTRIB65,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB66,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB66,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB66',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB66,
:NEW.WOR_CHAR_ATTRIB66,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB69,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB69,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB69',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB69,
:NEW.WOR_CHAR_ATTRIB69,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB70,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB70,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB70',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB70,
:NEW.WOR_CHAR_ATTRIB70,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB72,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB72,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB72',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB72,
:NEW.WOR_CHAR_ATTRIB72,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB76,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB76,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB76',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB76,
:NEW.WOR_CHAR_ATTRIB76,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB77,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB77,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB77',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB77,
:NEW.WOR_CHAR_ATTRIB77,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB79,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB79,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB79',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB79,
:NEW.WOR_CHAR_ATTRIB79,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB90,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB90,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB90',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB90,
:NEW.WOR_CHAR_ATTRIB90,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB91,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB91,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB91',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB91,
:NEW.WOR_CHAR_ATTRIB91,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB124,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB124,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB124',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB124),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB124),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB125,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB125,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB125',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB125),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB125),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB126,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB126,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB126',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB126),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB126),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB127,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB127,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB127',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB127),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB127),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB128,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB128,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB128',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB128),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB128),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB130,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB130,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB130',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB130),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB130),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB01,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB01,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB01',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB01,
:NEW.WOR_NUM_ATTRIB01,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_NUM_ATTRIB02,-9999999999) !=  Nvl(:NEW.WOR_NUM_ATTRIB02,-9999999999)
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_NUM_ATTRIB02',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_NUM_ATTRIB02,
:NEW.WOR_NUM_ATTRIB02,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_ATTRIB129,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_ATTRIB129,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_ATTRIB129',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_ATTRIB129),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_ATTRIB129),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB64,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB64,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB64',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB64,
:NEW.WOR_CHAR_ATTRIB64,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_AGREED_BY,'$$$$$$$') !=  Nvl(:NEW.WOR_AGREED_BY,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_AGREED_BY',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_AGREED_BY,
:NEW.WOR_AGREED_BY,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_DATE_AUTHORISED,Trunc(Sysdate+9999)) !=  Nvl(:NEW.WOR_DATE_AUTHORISED,Trunc(Sysdate+9999))
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_DATE_AUTHORISED',
:OLD.WOR_WORKS_ORDER_NO,
To_Char(Trunc(:OLD.WOR_DATE_AUTHORISED),'DD-MON-YYYY'),
To_Char(Trunc(:NEW.WOR_DATE_AUTHORISED),'DD-MON-YYYY'),
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_SCHEME_TYPE,'$$$$$$$') !=  Nvl(:NEW.WOR_SCHEME_TYPE,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_SCHEME_TYPE',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_SCHEME_TYPE,
:NEW.WOR_SCHEME_TYPE,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
IF Nvl(:OLD.WOR_CHAR_ATTRIB95,'$$$$$$$') !=  Nvl(:NEW.WOR_CHAR_ATTRIB95,'$$$$$$$')
THEN
INSERT INTO hig_audits (haud_id,haud_nit_inv_type,haud_table_name,haud_attribute_name,haud_pk_id,haud_old_value,haud_new_value,haud_timestamp,haud_operation,haud_hus_user_id,haud_terminal,haud_os_user,haud_description )
Values (
haud_id_seq.NEXTVAL,
'WFXA',
'WORK_ORDERS',
'WOR_CHAR_ATTRIB95',
:OLD.WOR_WORKS_ORDER_NO,
:OLD.WOR_CHAR_ATTRIB95,
:NEW.WOR_CHAR_ATTRIB95,
Sysdate,
'U',
p_user_id, --sys_context('NM3CORE','USER_ID'),
sys_context('USERENV','TERMINAL'),
sys_context('USERENV','OS_USER'),
'Works Order Flexible Attributes for new WFXA Update Update');
END IF;
END;
/