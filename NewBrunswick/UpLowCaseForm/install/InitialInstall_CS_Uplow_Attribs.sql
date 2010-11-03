----------------------------------------------------------

--   PVCS Identifiers :-

--

--       pvcsid           : $Header:   //vm_latest/archives/customer/NewBrunswick/UpLowCaseForm/install/InitialInstall_CS_Uplow_Attribs.sql-arc   3.0   Nov 03 2010 08:08:56   Ian.Turnbull  $

--       Module Name      : $Workfile:   InitialInstall_CS_Uplow_Attribs.sql  $

--       Date into PVCS   : $Date:   Nov 03 2010 08:08:56  $

--       Date fetched Out : $Modtime:   Nov 02 2010 13:49:52  $

--       PVCS Version     : $Revision:   3.0  $

----------------------------------------------------------

SET SERVEROUTPUT ON
Spool cs_uplow_install.log

DROP TABLE XNB_CS_UPLOW_ATTRIBS;

delete from hig_module_roles WHERE hmr_module = 'CS_UPLOW';

delete from hig_standard_favourites where hstf_child = 'CS_UPLOW';

delete from hig_modules where hmo_module = 'CS_UPLOW';

COMMIT;

insert into HIG_MODULES (hmo_module,hmo_title,hmo_module_type,hmo_filename,hmo_fastpath_invalid,hmo_application,hmo_use_gri)
  values ('CS_UPLOW','Control Section Attributes','FMX','XNB_CS_ATTRIBS','N','HIG','N');

insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
  values ( 'FAVOURITES','CS_UPLOW','Control Section Attributes','M',20);

insert into hig_module_roles (hmr_module,hmr_role,hmr_mode) values ('CS_UPLOW','NET_USER','NORMAL');
insert into hig_module_roles (hmr_module,hmr_role,hmr_mode) values ('CS_UPLOW','HIG_USER','NORMAL');

COMMIT;

CREATE TABLE XNB_CS_UPLOW_ATTRIBS
(
  XCUA_CS_NE_ID       NUMBER(9),
  XCUA_ENGLISH_START  VARCHAR2(200 BYTE),
  XCUA_ENGLISH_END    VARCHAR2(200 BYTE),
  XCUA_FRENCH_START   VARCHAR2(200 BYTE),
  XCUA_FRENCH_END     VARCHAR2(200 BYTE)
)
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;

INSERT INTO XNB_CS_UPLOW_ATTRIBS (
XCUA_CS_NE_ID
,XCUA_ENGLISH_START
,XCUA_ENGLISH_END
,XCUA_FRENCH_START
,XCUA_FRENCH_END)
(SELECT nad_ne_id xcua_cs_ne_id
    , iit_chr_attrib66 xcua_english_start
    , iit_chr_attrib67 xcua_english_end
    , iit_chr_attrib68 xcua_french_start
    , iit_chr_attrib69 xcua_french_end 
FROM nm_elements a
    , nm_nw_ad_link_all b
    , nm_inv_items c
WHERE a.ne_id = b.nad_ne_id
    AND b.nad_iit_ne_id = c.iit_ne_id
    AND a.ne_nt_type = 'NBCS'
    AND nad_end_date IS NULL
    AND nad_inv_type = 'CSP'
    );


ALTER TABLE XNB_CS_UPLOW_ATTRIBS ADD (
  CONSTRAINT XCUA_PK
 PRIMARY KEY
 (XCUA_CS_NE_ID));

Spool off
SET SERVEROUTPUT OFF