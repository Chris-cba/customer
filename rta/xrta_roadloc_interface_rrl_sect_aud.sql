CREATE OR REPLACE TRIGGER rrl_sect_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_elements_all FOR EACH ROW
  WHEN (new.ne_nt_type = 'FOCL' OR old.ne_nt_type = 'FOCL')
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_sect_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_sect_aud.sql
--       Date into SCCS   : 05/03/15 23:05:57
--       Date fetched Out : 07/06/06 14:39:36
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
      -- A new relationship is being added
      action := 'add';
    ELSE  -- UPDATING
      IF :old.ne_end_date IS NULL AND :new.ne_end_date IS NOT NULL THEN
        -- Existing element is having an end date set.
        -- This means delete.
        action := 'delete';
      ELSIF :old.ne_end_date IS NOT NULL AND :new.ne_end_date IS NULL THEN
        -- Existing element is having an end date unset.
        -- This means undo.
        action := 'undo';
      ELSE
        -- Some other (non-delete) update in the element is taking place
        action := 'update';
      END IF;
    END IF;
    --
    INSERT INTO rrl_sect_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.ne_group,
      :new.ne_sub_type,
      :new.ne_name_1,
      :new.ne_number,
      :new.ne_name_2,
      :new.ne_nsg_ref,
      :new.ne_start_date
    );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    INSERT INTO rrl_sect_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.ne_group,
      :old.ne_sub_type,
      :old.ne_name_1,
      :old.ne_number,
      :old.ne_name_2,
      :old.ne_nsg_ref,
      :old.ne_start_date
    );
  END IF;
END;
.
/
