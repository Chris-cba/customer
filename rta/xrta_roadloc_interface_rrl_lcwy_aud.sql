CREATE OR REPLACE TRIGGER rrl_lcwy_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_elements_all FOR EACH ROW
  WHEN ((new.ne_type = 'S' OR old.ne_type = 'S')
  )  --AND (new.ne_number IS NOT NULL OR old.ne_number IS NOT NULL))
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_lcwy_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_lcwy_aud.sql
--       Date into SCCS   : 05/03/15 23:05:32
--       Date fetched Out : 07/06/06 14:39:33
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  CURSOR admin_unit_cursor(admin_unit IN NUMBER) IS
    SELECT nau_unit_code FROM nm_admin_units_all
    WHERE  nau_admin_unit = admin_unit;
  admin_unit_row admin_unit_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    IF INSERTING THEN
      -- A new element is being added
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
    OPEN admin_unit_cursor(:new.ne_admin_unit);
    FETCH admin_unit_cursor INTO admin_unit_row;
    CLOSE admin_unit_cursor;
    INSERT INTO rrl_lcwy_aud VALUES(
        audit_id_seq.nextval,
        action,
        :new.ne_id,
        :new.ne_group,
        :new.ne_sub_type,
        :new.ne_owner,
        :new.ne_prefix,
        :new.ne_version_no,
        :new.ne_length,
        :new.ne_descr,
        admin_unit_row.nau_unit_code,
        :new.ne_number,
        :new.ne_start_date
      );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    OPEN admin_unit_cursor(:old.ne_admin_unit);
    FETCH admin_unit_cursor INTO admin_unit_row;
    CLOSE admin_unit_cursor;
    INSERT INTO rrl_lcwy_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.ne_id,
      :old.ne_group,
      :old.ne_sub_type,
      :old.ne_owner,
      :old.ne_prefix,
      :old.ne_version_no,
      :old.ne_length,
      :old.ne_descr,
      admin_unit_row.nau_unit_code,
      :old.ne_number,
      :old.ne_start_date
    );
  END IF;
END;
.
/
