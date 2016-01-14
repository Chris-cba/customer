--
-- im_user_tabs
--
delete im_user_tabs;

SET DEFINE OFF;
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ)
 Values
   ('HIGHWAYS', 1, -1);
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 2, 0, 'Map', 'Map Page');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 3, 1, 'Business Areas', 'Business Areas');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 4, 2, 'Query', 'Generic Search');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 5, 3, 'Admin', 'Admin Page');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 6, 4, 'Help', 'Help Page');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 7, 5, 'User1', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 16, 6, 'LoHAC_WIP', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('HIGHWAYS', 8, 7, 'LoHac_Exist_WIP', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACNW1', 8, 7, 'LoHac_Exist_WIP', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ)
 Values
   ('LOHACNE1', 1, -1);
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACNE1', 8, 0, 'LoHac_Exist_WIP', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACNE1', 5, 1, 'Admin', 'Admin Page');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACNE1', 2, 2, 'Map', 'Map Page');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ)
 Values
   ('LOHACC1', 1, -1);
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ)
 Values
   ('LOHACS1', 1, -1);
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ)
 Values
   ('LOHACNW1', 1, -1);
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACS1', 8, 0, 'LoHac_Exist_WIP', 'UserTab');
Insert into IM_USER_TABS
   (IUT_HUS_USERNAME, IUT_IT_ID, IUT_SEQ, IUT_DISP_NAME, IUT_DESCR)
 Values
   ('LOHACC1', 8, 0, 'LoHac_Exist_WIP', 'UserTab');
COMMIT;
