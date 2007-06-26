CREATE OR REPLACE TRIGGER rrl_la_rel_aud_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_members_all FOR EACH ROW
  WHEN (new.nm_obj_type = 'RLG' OR old.nm_obj_type = 'RLG')
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_la_rel_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_la_rel_aud.sql
--       Date into SCCS   : 05/03/15 23:05:31
--       Date fetched Out : 07/06/06 14:39:33
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  CURSOR lga_cursor(lga_ne_id IN NUMBER) IS
    SELECT hig_codes.hco_meaning FROM nm_elements_all, hig_codes
    WHERE nm_elements_all.ne_id = lga_ne_id
      AND hig_codes.hco_code = nm_elements_all.ne_group
      AND hig_codes.hco_domain = 'LGA_(NET)';
  lga_row lga_cursor%ROWTYPE;
  CURSOR unit_code_cursor(rlg_ne_id IN NUMBER) IS
    SELECT nau_unit_code FROM nm_elements_all, nm_admin_units_all
     WHERE nm_elements_all.ne_id = rlg_ne_id
       AND nm_admin_units_all.nau_admin_unit = nm_elements_all.ne_admin_unit;
  unit_code_row unit_code_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    IF INSERTING THEN
      -- A new relationship is being added
      action := 'add';
    ELSE  -- UPDATING
      IF :old.nm_end_date IS NULL AND :new.nm_end_date IS NOT NULL THEN
        -- Existing relationship is having an end date set.
        -- This means delete.
        action := 'delete';
      ELSIF :old.nm_end_date IS NOT NULL AND :new.nm_end_date IS NULL THEN
        -- Existing relationship is having an end date unset.
        -- This means undo.
        action := 'undo';
      ELSE
        -- Some other (non-delete) update in the relationship is taking place
        action := 'update';
      END IF;
    END IF;
    --
    OPEN unit_code_cursor(:new.nm_ne_id_in);
    FETCH unit_code_cursor INTO unit_code_row;
    CLOSE unit_code_cursor;
    OPEN lga_cursor(:new.nm_ne_id_of);
    FETCH lga_cursor INTO lga_row;
    CLOSE lga_cursor;
    INSERT INTO rrl_la_rel_aud VALUES(
      audit_id_seq.nextval,
      action,
      unit_code_row.nau_unit_code,
      lga_row.hco_meaning,
      :new.nm_start_date
    );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    OPEN unit_code_cursor(:old.nm_ne_id_in);
    FETCH unit_code_cursor INTO unit_code_row;
    CLOSE unit_code_cursor;
    OPEN lga_cursor(:old.nm_ne_id_of);
    FETCH lga_cursor INTO lga_row;
    CLOSE lga_cursor;
    INSERT INTO rrl_la_rel_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      unit_code_row.nau_unit_code,
      lga_row.hco_meaning,
      :new.nm_start_date
    );
  END IF;
END;
/

