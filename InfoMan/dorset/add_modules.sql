--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/InfoMan/dorset/add_modules.sql-arc   3.0   Jan 11 2010 09:00:14   iturnbull  $
--       Module Name      : $Workfile:   add_modules.sql  $
--       Date into PVCS   : $Date:   Jan 11 2010 09:00:14  $
--       Date fetched Out : $Modtime:   Jan 11 2010 08:44:02  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--


REM INSERTING into im_item_help
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (20210,'IM20210','This pod displays the total number of FPN offences per utility company for the dates entered.  Click on the utility company to view the type of offences incurred.','IM20210');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (20211,'IM20211','The type of FPN offence is displayed as a percentage against the number of works carried out by the utilities company for the given period.','IM20211');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (40212,'IM40212','This pod presents the number of defects that are incomplete by category.  Click on the area of the pie chart to view in more detail the status of the defects.','IM40212');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (40213,'IM40213','This pod displays the number of defects that are ''Within Target'', ''Near Completion'' or ''Late''.  Click on the section of the bar graph to view the defects in more detail.','IM40213');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (40214,'IM40214','Details of the defects are displayed in this table.','IM40214');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (40215,'IM40215','This pod displays the response to Cat 1 and Cat 2.1 defects.  ''Completed on Time'' = repair + administration time (7 days) </= ''System date'' (Cat 1 = 32 hours + 7 days, Cat 2.1 = 28 days + 7 days), ''Late'' = repair + administration time > ''System date.''  Cat 1 defects take into account both Temporary and Permanent repairs.','IM40215');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (40216,'IM40216','This table displays the information for each defect.','IM40216');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (100211,'IM100211','This pod displays the number of PEM enquiries by type for the dates set.  PEMs at RE status are shown by a negative value to highlight that no action has been taken.','IM100211');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (100212,'IM100212','This table displays the individual records of each PEM.','IM100212');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (100213,'IM100213','This pod displays the number of Email, Letter or Fax enquiries that are nearing or exceeding the target time (14 calendar days) for a Positive Response Letter (PRL), Delayed Action Letter (DAL) and a No Response Necessary (NRN).  Those exceeding 10.5 days are shown as nearing target time; those over 14 days are shown as exceeding target time.','IM100213');
Insert into "im_item_help" (IMIH_ID,IMIH_ITEM_NAME,IMIH_HELP_TEXT,IMIH_ITEM_LABEL) values (100214,'IM100214','This table displays the individual records of each PEM.','IM100214');


REM INSERTING into hmo_modules
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM100211','Enquiries Type over time','100000:IM100211','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM100212','Enquiries Type over time Report','IM100212','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM100213','Enquiries','100000:IM100213','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM100214','Enquiries Report','IM100214','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM20210','FPN Offences by Works Promoter','20000:IM20210','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM20211','FPN Offences by Type and by Works Promoter','IM20211','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM40212','Defects passed or nearing completion','40000:IM40212','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM40213','Total number of available and instructed defects','40000:IM40213','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM40214','Incomplete Defects Report','40000:IM40214','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM40215','Defect Repair Times','40000:IM40215','WEB',null,'Y','N','IM',null);
Insert into "hmo_modules" (HMO_MODULE,HMO_TITLE,HMO_FILENAME,HMO_MODULE_TYPE,HMO_FASTPATH_OPTS,HMO_FASTPATH_INVALID,HMO_USE_GRI,HMO_APPLICATION,HMO_MENU) values ('IM40216','Details of Defect Repair Times','40000:IM40216','WEB',null,'Y','N','IM',null);


REM INSERTING into hig_module_roles
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM100211','ENQ_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM100212','ENQ_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM100213','ENQ_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM100214','ENQ_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM20210','TMA_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM20211','TMA_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM40212','MAI_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM40213','MAI_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM40214','MAI_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM40215','MAI_USER','NORMAL');
Insert into "hig_module_roles" (HMR_MODULE,HMR_ROLE,HMR_MODE) values ('IM40216','MAI_USER','NORMAL');
