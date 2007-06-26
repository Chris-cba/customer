CREATE OR REPLACE TRIGGER xmrwa_prevent_future_inv
   BEFORE INSERT
    ON    nm_inv_items_all
    FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_prevent_future_inv.trg	1.1 03/15/05
--       Module Name      : xmrwa_prevent_future_inv.trg
--       Date into SCCS   : 05/03/15 00:45:58
--       Date fetched Out : 07/06/06 14:38:25
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA site specific trigger to prevent assets being created with a
--    future IIT_START_DATE
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
   c_sysdate   CONSTANT DATE         := TRUNC(SYSDATE);
   c_date_mask CONSTANT VARCHAR2(80) := nm3user.get_user_date_mask;
--
BEGIN
   IF :NEW.IIT_START_DATE > c_sysdate
    THEN
      hig.raise_ner (pi_appl               => 'XMRWA'
                    ,pi_id                 => 2
                    ,pi_supplementary_info => TO_CHAR(:NEW.IIT_START_DATE,c_date_mask)||' > '||TO_CHAR(c_sysdate,c_date_mask)
                    );
   END IF;
END xmrwa_prevent_future_inv;
/
