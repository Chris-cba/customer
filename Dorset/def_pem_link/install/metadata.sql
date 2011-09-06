---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Dorset/def_pem_link/install/metadata.sql-arc   1.0   Sep 06 2011 16:23:20   Ian.Turnbull  $
--       Module Name      : $Workfile:   metadata.sql  $
--       Date into PVCS   : $Date:   Sep 06 2011 16:23:20  $
--       Date fetched Out : $Modtime:   Sep 06 2011 15:08:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
INSERT INTO x_def_pem_status
values ('AVAILABLE' , 'DR');

INSERT INTO x_def_pem_status
values ('CLOSED' , 'CBS');

INSERT INTO x_def_pem_status
values ('COMPLETED' , 'CO');

INSERT INTO x_def_pem_status
values ('INSTRUCTED' , 'WI');

INSERT INTO x_def_pem_status
values ('NOT DONE' , 'CO');

INSERT INTO x_def_pem_status
values ('SELECTED' , 'WA');

INSERT INTO x_def_pem_status
values ('STR MAINT' , 'CO');

INSERT INTO x_def_pem_status
values ('SUPERSEDED' , 'DR');

commit;

