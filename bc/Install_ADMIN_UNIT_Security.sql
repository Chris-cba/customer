-- Admin Unit Security install
-- Note this also removes existing triggers and packages.

-- load the new objects

@ admin\pck\xbc_create_securing_inv.pkh
@ admin\pck\xbc_create_securing_inv.pkb
@ admin\trg\xbc_ne_b_i_stm_trg.trg
@ admin\trg\xbc_ne_b_i_row_trg.trg
@ admin\trg\xbc_ne_a_i_stm_trg.trg
@ admin\trg\XBC_TRIG_ELEMENT_UPDATE_ROW.trg
@ admin\trg\XBC_TRIG_ELEMENT_UPDATE.trg

-- set CA and PINV to be non Exclusive

update nm_inv_types_all t set T.NIT_EXCLUSIVE = 'N' where T.NIT_INV_TYPE in ('CA', 'PINV');
commit;


-- drop the old ones 

set serveroutput on;
prompt Dropping Existing "XKYTC" Objects
drop table xkytc_securing_inventory;
drop trigger xkytc_ne_a_i_stm_trg;
drop trigger xkytc_ne_b_i_row_trg;
drop trigger xkytc_ne_b_i_stm_trg;
drop package xkytc_create_securing_inv;

--@ replace_ADMIN_UNIT_Security.sql
