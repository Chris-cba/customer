Insert into NM_MAIL_GROUPS
Select nmg_id_seq.nextval,'Works Order on Hold' from dual
Where not exists (select 1 from nm_mail_groups where nmg_name = 'Works Order on Hold');
