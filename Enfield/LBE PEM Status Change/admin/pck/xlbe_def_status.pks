CREATE OR REPLACE package xlbe_def_status as
--<PACKAGE>
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:$
--       Module Name      : $Workfile:$
--       Date into PVCS   : $Date:$
--       Date fetched Out : $Modtime:$
--       PVCS Version     : $Revision:$
--       Based on SCCS version :

--
--
--   Author : Garry Bleakley
--
--    xlbe_def_status
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  g_sccsid CONSTANT VARCHAR2(2000):='"$Revision:$"';

--</GLOBVAR>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_VERSION">
-- This function returns the current SCCS version
FUNCTION get_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_BODY_VERSION">
-- This function returns the current SCCS version of the package body
FUNCTION get_body_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PRAGMA>
  PRAGMA RESTRICT_REFERENCES(get_version, RNDS, WNPS, WNDS);
  PRAGMA RESTRICT_REFERENCES(get_body_version, RNDS, WNPS, WNDS);
--</PRAGMA>
--
-----------------------------------------------------------------------------

--
type defects is table of number
index by binary_integer;

tab_defects defects;

procedure clear_defects;

procedure process_defects;

procedure update_def_status (p_def_id number);

type wols is table of number
index by binary_integer;

tab_wols wols;

procedure clear_wols;

procedure process_wols;

procedure update_wol_status (p_wol_def_id number);

end xlbe_def_status;
/

