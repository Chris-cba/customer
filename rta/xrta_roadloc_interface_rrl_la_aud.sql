
CREATE OR REPLACE TRIGGER rrl_la_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_inv_attri_lookup_all FOR EACH ROW
  WHEN (new.ial_domain IN ('LGA_(INV)', 'SED_(INV)', 'MA_(INV)')
        OR old.ial_domain IN ('LGA_(INV)', 'SED_(INV)', 'MA_(INV)'))
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_la_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_la_aud.sql
--       Date into SCCS   : 05/03/15 23:05:30
--       Date fetched Out : 07/06/06 14:39:32
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    IF INSERTING THEN
      -- New domain value is being created.
      action := 'add';
    ELSE  -- UPDATING
      IF :old.ial_end_date IS NULL AND :new.ial_end_date IS NOT NULL THEN
        -- Existing domain value is having an end date changed.
        -- This is equivalent to delete.
        action := 'delete';
      ELSIF :old.ial_end_date IS NOT NULL AND :new.ial_end_date IS NULL THEN
        -- Existing domain value is having an end date unset.
        -- This is equivalent to undo.
        action := 'undo';
      ELSE
        -- Existing domain value is being updated.
        action := 'update';
      END IF;
    END IF;
    INSERT INTO rrl_la_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.ial_domain,
      :new.ial_value,
      :new.ial_meaning,
      :new.ial_start_date
    );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    INSERT INTO rrl_la_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.ial_domain,
      :old.ial_value,
      :old.ial_meaning,
      :old.ial_start_date
    );
  END IF;
END;
.
/
