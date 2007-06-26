CREATE OR REPLACE TRIGGER rrl_lcwy_lc_class_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_members_all FOR EACH ROW
  WHEN (new.nm_obj_type = 'ADMN' OR old.nm_obj_type = 'ADMN')
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_lcwy_lc_class_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_lcwy_lc_class_aud.sql
--       Date into SCCS   : 05/03/15 23:05:34
--       Date fetched Out : 07/06/06 14:39:34
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  CURSOR lc_class_cursor(id IN NUMBER) IS
    SELECT ne_unique FROM nm_elements_all
    WHERE nm_elements_all.ne_id = id;
  lc_class_row lc_class_cursor%ROWTYPE;
  CURSOR datum_cursor(id IN NUMBER) IS
    SELECT ne_number FROM nm_elements_all
    where nm_elements_all.ne_id = id;
  datum_row datum_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    IF INSERTING THEN
      -- A new element is being added to the group
      action := 'add';
    ELSE   -- UPDATING
      IF :old.nm_end_date IS NULL AND :new.nm_end_date IS NOT NULL THEN
        -- Existing group membership is having an end date set.
        -- This means delete.
        action := 'delete';
      ELSIF :old.nm_end_date IS NOT NULL AND :new.nm_end_date IS NULL THEN
        -- Existing group membership is having an end date unset.
        -- This means undo.
        action := 'undo';
      ELSE
        -- Some other (non-delete) update in the membership is taking place
        action := 'update';
      END IF;
    END IF;
    --
    OPEN lc_class_cursor(:new.nm_ne_id_in);
    FETCH lc_class_cursor INTO lc_class_row;
    CLOSE lc_class_cursor;
    OPEN datum_cursor(:new.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    INSERT INTO rrl_lcwy_lc_class_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.nm_ne_id_of,
      lc_class_row.ne_unique,
      datum_row.ne_number,
      :new.nm_start_date
    );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    OPEN lc_class_cursor(:old.nm_ne_id_in);
    FETCH lc_class_cursor INTO lc_class_row;
    CLOSE lc_class_cursor;
    OPEN datum_cursor(:old.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    INSERT INTO rrl_lcwy_lc_class_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.nm_ne_id_of,
      lc_class_row.ne_unique,
      datum_row.ne_number,
      :old.nm_start_date
    );
  END IF;
END;
.
/
