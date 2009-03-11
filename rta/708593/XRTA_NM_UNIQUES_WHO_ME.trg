CREATE OR REPLACE TRIGGER XRTA_NM_UNIQUES_WHO_ME
 BEFORE insert OR update
 ON XRTA_NM_UNIQUES
 FOR each row
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/rta/XRTA_NM_UNIQUES_WHO_ME.trg-arc   1.0   Mar 11 2009 11:58:40   cstrettle  $
--       Module Name      : $Workfile:   XRTA_NM_UNIQUES_WHO_ME.trg  $
--       Date into PVCS   : $Date:   Mar 11 2009 11:58:40  $
--       Date fetched Out : $Modtime:   Mar 11 2009 11:20:48  $
--       Version          : $Revision:   1.0  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
   SELECT sysdate
         ,user
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
   IF inserting
    THEN
      :new.XRTA_DT_CREATED  := l_sysdate;
      :new.XRTA_CREATED     := l_user;
   END IF;
--
   :new.XRTA_DT_MODIFIED    := l_sysdate;
   :new.XRTA_MODIFIED       := l_user;
--
END XRTA_NM_UNIQUES_WHO_ME;