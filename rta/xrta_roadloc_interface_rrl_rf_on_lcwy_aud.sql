CREATE OR REPLACE TRIGGER rrl_rf_on_lcwy_mem_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_members_all FOR EACH ROW
  WHEN (new.nm_obj_type = 'REFF' OR old.nm_obj_type = 'REFF')
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_rf_on_lcwy_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_rf_on_lcwy_aud.sql
--       Date into SCCS   : 05/03/15 23:05:35
--       Date fetched Out : 07/06/06 14:39:35
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  CURSOR inv_cursor(inv_id IN NUMBER, elem_id IN NUMBER) IS
    SELECT nm_inv_items_all.*, nm_elements_all.ne_number ne_number
    FROM nm_inv_items_all, nm_elements_all
    WHERE iit_ne_id = inv_id
      AND nm_elements_all.ne_id = elem_id;
  inv_row inv_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    OPEN inv_cursor(:new.nm_ne_id_in, :new.nm_ne_id_of);
    FETCH inv_cursor INTO inv_row;
    CLOSE inv_cursor;
    --
    IF INSERTING THEN
      -- A inventory location is being added
      action := 'add';
    ELSE  -- UPDATING
      IF :old.nm_end_date IS NULL AND :new.nm_end_date IS NOT NULL THEN
        -- Existing inventory location is having an end date set.
        -- This means delete.
        action := 'delete';
      ELSIF :old.nm_end_date IS NOT NULL AND :new.nm_end_date IS NULL THEN
        -- Existing inventory location is having an end date unset.
        -- This means undo.
        action := 'undo';
      ELSE
        -- Some other (non-delete) update in the inventory location
        -- is taking place
        action := 'update';
      END IF;
    END IF;
    INSERT INTO rrl_rf_on_lcwy_aud VALUES(
      audit_id_seq.nextval,
      action,
      inv_row.ne_number,
      :new.nm_ne_id_of,
      inv_row.iit_primary_key,
      inv_row.iit_chr_attrib26,
      inv_row.iit_chr_attrib56,
      :new.nm_begin_mp,
      inv_row.iit_chr_attrib27,
      :new.nm_start_date
    );
--
--
-- Relocating an inventory item consists of end-dating the
-- old location, then a precautionary _delete_ of the new
-- location by primary key and end date, and finally
-- inserting the new location.  Therefore we don't want to
-- audit on row deletes in nm_members_all.
--
--  ELSIF DELETING THEN
--    -- This shouldn't really happen (records get end-dated
--    -- instead of being deleted).  However if a record
--    -- does somehow get deleted, it will be handled here.
--    OPEN inv_cursor(:old.nm_ne_id_in, :old.nm_ne_id_of);
--    FETCH inv_cursor INTO inv_row;
--    CLOSE inv_cursor;
--    INSERT INTO rrl_rf_on_lcwy_aud VALUES(
--      audit_id_seq.nextval,
--      'delete',
--      inv_row.ne_number,
--      :old.nm_ne_id_of,
--      inv_row.iit_primary_key,
--      inv_row.iit_chr_attrib26,
--      inv_row.iit_chr_attrib56,
--      :old.nm_begin_mp,
--      inv_row.iit_chr_attrib27,
--      :old.nm_start_date
--    );
  END IF;
END;
.
/


CREATE OR REPLACE TRIGGER rrl_rf_on_lcwy_inv_trig
AFTER UPDATE ON nm_inv_items_all FOR EACH ROW
  WHEN (new.iit_inv_type = 'REFF' OR old.iit_inv_type = 'REFF')
DECLARE
  CURSOR member_cursor(id IN NUMBER) IS
    SELECT nm_members_all.*, nm_elements_all.ne_number
    FROM nm_members_all, nm_elements_all
    WHERE nm_ne_id_in = id AND nm_members_all.nm_end_date IS NULL
      AND nm_elements_all.ne_id = nm_members_all.nm_ne_id_of;
  action VARCHAR2(10);
BEGIN
  -- If an existing inventory item is having an end date set, it is being
  -- deleted.  Don't write an audit record in this case, as the member
  -- record(s) will be end-dated anyway and leave an audit trail.
  --
  -- So, only write an update audit trail if the update does not involve
  -- the inventory item being end-dated.  So the inventory item could
  -- have its end-date removed (undo operation), or it could be some other
  -- type of update.
  --
  IF :old.iit_end_date IS NOT NULL AND :new.iit_end_date IS NULL THEN
    -- The end date is being unset;  that is an undo operation.
    action := 'undo';
  ELSIF (:old.iit_end_date IS NULL AND :new.iit_end_date IS NOT NULL) THEN
    action := 'delete';
  ELSIF (:old.iit_end_date IS NOT NULL AND :new.iit_end_date IS NOT NULL) THEN
    -- if the inventory record was and still is end-dated, then an update is
    -- taking place on something thats already been deleted.  ignore it.
    action := 'dead';
  ELSE
    action := 'update';
  END IF;
  --
  IF action = 'update' OR action = 'undo' THEN
    FOR member_row IN member_cursor(:new.iit_ne_id)
    LOOP
      -- Write an audit record for every member record associated with the
      -- inventory item.
      INSERT INTO rrl_rf_on_lcwy_aud VALUES(
        audit_id_seq.nextval,
        action,
        member_row.ne_number,
        member_row.nm_ne_id_of,
        :new.iit_primary_key,
        :new.iit_chr_attrib26,
        :new.iit_chr_attrib56,
        member_row.nm_begin_mp,
        :new.iit_chr_attrib27,
        member_row.nm_start_date
      );
    END LOOP;
  END IF;
END;
.
/
