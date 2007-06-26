CREATE OR REPLACE TRIGGER rrl_road_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON hig_codes FOR EACH ROW
  WHEN (new.hco_domain = 'ROAD_NUMBER' OR old.hco_domain = 'ROAD_NUMBER')
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_road_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_road_aud.sql
--       Date into SCCS   : 05/03/15 23:05:56
--       Date fetched Out : 07/06/06 14:39:36
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  action VARCHAR2(10);
  hig_code_row hig_codes%ROWTYPE;
BEGIN
  IF INSERTING OR UPDATING THEN
    IF INSERTING THEN
      -- New domain value is being created.
      action := 'add';
    ELSE  -- UPDATING
      IF :old.hco_end_date IS NULL AND :new.hco_end_date IS NOT NULL THEN
        -- Existing domain value is having an end date set.
        -- This is equivalent to delete.
        action := 'delete';
      ELSIF :old.hco_end_date IS NOT NULL AND :new.hco_end_date IS NULL THEN
        -- Existing domain value is having an end date unset.
        -- This is equivalent to undo.
        action := 'undo';
      ELSE
      -- Existing domain value is being updated.
        action := 'update';
      END IF;
    END IF;
    INSERT INTO rrl_road_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.hco_code,
      :new.hco_meaning,
      :new.hco_start_date
    );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    INSERT INTO rrl_road_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.hco_code,
      :old.hco_meaning,
      :old.hco_start_date
    );
  END IF;
END;
.
/
