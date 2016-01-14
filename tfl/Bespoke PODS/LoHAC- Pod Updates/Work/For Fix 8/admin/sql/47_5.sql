

CREATE OR REPLACE package HIGHWAYS.xtfl_wol_state_pkg
  as
            type ridArray is table of rowid index by binary_integer;
  
            newRows ridArray;
            empty   ridArray;
   end;
/

CREATE OR REPLACE PUBLIC SYNONYM XTFL_WOL_STATE_PKG FOR HIGHWAYS.XTFL_WOL_STATE_PKG;

DROP TABLE HIGHWAYS.XTFL_WOL_STATUS_UPDATE CASCADE CONSTRAINTS;

CREATE TABLE HIGHWAYS.XTFL_WOL_STATUS_UPDATE
(
  WORK_ORDER_NO  VARCHAR2(16 BYTE)
)
TABLESPACE HIGHWAYS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wsu_wol_status
after insert ON HIGHWAYS.XTFL_WOL_STATUS_UPDATE 
begin
    for o in (select distinct * from xtfl_wol_status_update) loop
    update work_orders w set wor_char_attrib64  = (select wor_status from v_work_order_status where wor_works_order_no = o.work_order_no) where wor_works_order_no = o.work_order_no ;
    end loop;
    delete from xtfl_wol_status_update;
end;
/

--DROP TRIGGER HIGHWAYS.XTFL_WO_COMP_DATE_U_TRG;

CREATE OR REPLACE TRIGGER HIGHWAYS.XTFL_WO_COMP_DATE_U_TRG   
BEFORE UPDATE OF WOR_DATE_CLOSED ON HIGHWAYS.WORK_ORDERS 
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW 
declare 
l_cnt number; 
BEGIN 
if (:OLD.WOR_DATE_CLOSED is null and :NEW.WOR_DATE_CLOSED is not null) then   

    select count(*) into l_cnt from work_order_lines where wol_works_order_no = :NEW.WOR_WORKS_ORDER_NO and wol_status_code <> 'COMPLETED';

    if l_cnt = 0 then 
        :NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Awaiting Review' ); 
		-- date added for Invoice Status Effective Date
		:NEW.WOR_DATE_ATTRIB131 := trunc(sysdate);
		
		--:NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Approved' );
     else   
        :NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Approved but unreviewed' );
		-- date added for Invoice Status Effective Date
		:NEW.WOR_DATE_ATTRIB131 := trunc(sysdate);

    end if; 
    
     
end if;    
end; 
/

/*
CREATE OR REPLACE TRIGGER HIGHWAYS.XTFL_WO_COMP_DATE_U_TRG   
BEFORE UPDATE OF WOR_DATE_CLOSED ON HIGHWAYS.WORK_ORDERS 
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW
BEGIN 
if (:OLD.WOR_DATE_CLOSED is null and :NEW.WOR_DATE_CLOSED is not null) then 
    :NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Awaiting Review' ); 
end if;    
end;
/
*/

--DROP TRIGGER HIGHWAYS.XTFL_WO_INTERIM_U_TRG;

CREATE OR REPLACE TRIGGER HIGHWAYS.XTFL_WO_INTERIM_U_TRG   
BEFORE UPDATE OF WOR_ACT_COST ON HIGHWAYS.WORK_ORDERS 
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW
BEGIN 
if :NEW.WOR_DATE_CLOSED is null and (:NEW.wor_act_cost > NVL(:OLD.wor_act_cost,0)) then 
    if :NEW.wor_act_cost >= nvl(:new.wor_est_cost,0) * 1.1 
	then 
        :NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Awaiting Review'); 
		-- date added for Invoice Status Effective Date
		:NEW.WOR_DATE_ATTRIB131 := trunc(sysdate);
    else 
	    :NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Approved but unreviewed');
      --:NEW.WOR_CHAR_ATTRIB110 := XTFL_WO_TRG_PKG.get_inv_domain_value ('INVOICE_STATUS','Approved - Awaiting Commercial Review'); 
	  -- date added for Invoice Status Effective Date
		:NEW.WOR_DATE_ATTRIB131 := trunc(sysdate);
        end if; 
end if; 
end;
/

--DROP TRIGGER HIGHWAYS.XTFL_WO_ORD_INST_U_TRG;

/*
CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wo_ord_inst_u_trg
BEFORE UPDATE OF WOR_DATE_CONFIRMED ON HIGHWAYS.WORK_ORDERS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
--check if ordered maintenance
if (:OLD.WOR_DATE_CONFIRMED IS NULL AND :NEW.WOR_DATE_CONFIRMED IS NOT NULL and :NEW.WOR_SCHEME_TYPE in ('11','12')) then
    :NEW.WOR_CHAR_ATTRIB118 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('TO_STATUS', 'Quote Accepted');
end if;
end;
/
*/

-- revised for new alert has_link_desk_operator
CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wo_ord_inst_u_trg 
BEFORE UPDATE OF WOR_DATE_CONFIRMED ON HIGHWAYS.WORK_ORDERS REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW 
BEGIN 
--check if ordered maintenance 
if (:OLD.WOR_DATE_CONFIRMED IS NULL AND :NEW.WOR_DATE_CONFIRMED IS NOT NULL and :NEW.WOR_SCHEME_TYPE in ('11','12')) then  

    :NEW.WOR_CHAR_ATTRIB118 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('TO_STATUS', 'Quote Accepted'); 
end if; 
if (:OLD.WOR_DATE_CONFIRMED IS NULL AND :NEW.WOR_DATE_CONFIRMED IS NOT NULL and :NEW.WOR_SCHEME_TYPE in ('11','13','14') and xtfl_wo_trg_pkg.is_user_non_tfl()) then

    :NEW.WOR_CHAR_ATTRIB95 := 'YES'; 
    end if; 

end; 
/



--DROP TRIGGER HIGHWAYS.XTFL_WO_SEC_U_TRG;

-- moved to stand alone file


--DROP TRIGGER HIGHWAYS.XTFL_WO1_U_TRG;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wo1_u_trg
BEFORE UPDATE OF WOR_CHAR_ATTRIB100 ON HIGHWAYS.WORK_ORDERS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
if :NEW.WOR_CHAR_ATTRIB100 <> :OLD.WOR_CHAR_ATTRIB100 then
if :NEW.WOR_CHAR_ATTRIB100 in (XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT','Rejected'),XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT','Held')) and xtfl_wo_trg_pkg.is_user_non_tfl() then
    :NEW.WOR_CHAR_ATTRIB100 := :OLD.WOR_CHAR_ATTRIB100;
    end if;
end if;    
end;
/

--DROP TRIGGER HIGHWAYS.XTFL_WO2_U_TRG;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wo2_u_trg
Before UPDATE OF WOR_CHAR_ATTRIB118 ON HIGHWAYS.WORK_ORDERS FOR EACH ROW
BEGIN
 if :NEW.WOR_CHAR_ATTRIB118 = XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('TO_STATUS', 'Re-Quote Required') then
        :NEW.WOR_CHAR_ATTRIB100 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT','Rejected');
        :NEW.WOR_CHAR_ATTRIB104 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT_REASON', 'TO Re-Quote Required');
   elsif :new.WOR_CHAR_ATTRIB118 = XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('TO_STATUS', 'Quote Held') then
        :NEW.WOR_CHAR_ATTRIB100 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT','Held');
        :NEW.WOR_CHAR_ATTRIB104 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('WO_PRO_STAT_REASON','TO Held'); 
end if;
end;
/

-- WORK ORDER STATUS
--DROP TRIGGER HIGHWAYS.XTFL_WOL_STATUS_ADD;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wol_status_add
  after insert or update of wol_status_code ON HIGHWAYS.WORK_ORDER_LINES for each row
begin
            xtfl_wol_state_pkg.newRows(xtfl_wol_state_pkg.newRows.count+1 ) := :new.rowid;
    end;
/

--DROP TRIGGER HIGHWAYS.XTFL_WOL_STATUS_INIT;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wol_status_init
    before insert or update ON HIGHWAYS.WORK_ORDER_LINES 
begin
            xtfl_wol_state_pkg.newRows := xtfl_wol_state_pkg.empty;
    end;
/

--DROP TRIGGER HIGHWAYS.XTFL_WOL_STATUS_POST;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wol_status_post
    after insert or update of wol_status_code ON HIGHWAYS.WORK_ORDER_LINES 
begin
            for i in 1 .. xtfl_wol_state_pkg.newRows.count loop
                    insert into xtfl_wol_status_update
                    select wol_works_order_no
                      from work_order_lines where rowid = xtfl_wol_state_pkg.newRows(i);
            end loop;
    end;
/


