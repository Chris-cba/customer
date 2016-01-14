create table x_tab_surf_lookup (
Pave_Type varchar2(6),
CODE number(3),
Description varchar2(80),
surf_lookup number(3)
)
;

commit;

SET DEFINE OFF;
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION)
 Values
   ('SURF', 40, 'Soil, Gravel, or Stone');
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION)
 Values
   ('SURF', 52, 'Asphalt Pavement');
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION)
 Values
   ('SURF', 70, 'Concrete Pavement');
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION)
 Values
   ('SURF', 80, 'Brick, Block, or Other');
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 0, 'N/A - Description not used', 40);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 20, 'N/A - Description not used', 40);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 40, 'N/A - Description not used', 40);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 52, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 53, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 61, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 62, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 70, 'N/A - Description not used', 70);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 72, 'N/A - Description not used', 70);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('BD', 80, 'N/A - Description not used', 80);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 1, 'N/A - Description not used', 70);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 2, 'N/A - Description not used', 70);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 3, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 4, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 5, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 6, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 7, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 8, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 9, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 10, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 11, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 12, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 13, 'N/A - Description not used', 52);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 20, 'N/A - Description not used', 40);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 21, 'N/A - Description not used', 70);
Insert into EXOR.X_TAB_SURF_LOOKUP
   (PAVE_TYPE, CODE, DESCRIPTION, SURF_LOOKUP)
 Values
   ('PM', 22, 'N/A - Description not used', 52);
COMMIT;


commit;
