INSERT INTO NM_INV_TYPE_ROLES values
('JOET', 'INV_ALL', 'NORMAL');
INSERT INTO NM_INV_TYPE_ROLES values
('JOET', 'INV_READONLY', 'READONLY');


Insert into EXOR.NM_INV_NW_ALL
   (NIN_NW_TYPE, NIN_NIT_INV_CODE, NIN_LOC_MANDATORY, NIN_START_DATE)
 Values
   ('BD', 'JOET', 'N', trunc(sysdate));
COMMIT;

exec nm3inv.create_view ('JOET', false);
exec nm3inv.create_view ('JOET', true);