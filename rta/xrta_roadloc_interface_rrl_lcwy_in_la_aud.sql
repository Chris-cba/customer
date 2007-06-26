CREATE OR REPLACE TRIGGER rrl_lcwy_in_la_mem_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_members_all FOR EACH ROW
  WHEN (new.nm_obj_type IN ('LGA', 'SED')
        OR old.nm_obj_type IN ('LGA', 'SED'))
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_rrl_lcwy_in_la_aud.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_rrl_lcwy_in_la_aud.sql
--       Date into SCCS   : 05/03/15 23:05:33
--       Date fetched Out : 07/06/06 14:39:34
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
  CURSOR inv_cursor(id IN NUMBER) IS
    SELECT iit_chr_attrib26, iit_chr_attrib27 FROM nm_inv_items_all
    WHERE iit_ne_id = id;
  inv_row inv_cursor%ROWTYPE;
  CURSOR datum_cursor(id IN NUMBER) IS
    SELECT ne_number FROM nm_elements_all
    where nm_elements_all.ne_id = id;
  datum_row datum_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    OPEN inv_cursor(:new.nm_ne_id_in);
    FETCH inv_cursor INTO inv_row;
    CLOSE inv_cursor;
    OPEN datum_cursor(:new.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    --
    IF INSERTING THEN
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
    INSERT INTO rrl_lcwy_in_la_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.nm_ne_id_of,
      :new.nm_begin_mp,
      :new.nm_end_mp,
      :new.nm_obj_type,
      inv_row.iit_chr_attrib26,
      inv_row.iit_chr_attrib27,
      datum_row.ne_number,
      :new.nm_start_date
      );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    OPEN inv_cursor(:old.nm_ne_id_in);
    FETCH inv_cursor INTO inv_row;
    CLOSE inv_cursor;
    OPEN datum_cursor(:old.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    INSERT INTO rrl_lcwy_in_la_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.nm_ne_id_of,
      :old.nm_begin_mp,
      :old.nm_end_mp,
      :old.nm_obj_type,
      inv_row.iit_chr_attrib26,
      inv_row.iit_chr_attrib27,
      datum_row.ne_number,
      :old.nm_start_date
    );
  END IF;
END;
.
/


CREATE OR REPLACE TRIGGER rrl_lcwy_in_la_mem_mnum_trig
AFTER INSERT OR UPDATE OR DELETE ON nm_members_all FOR EACH ROW
  WHEN (new.nm_obj_type IN ('MNUM')
        OR old.nm_obj_type IN ('MNUM'))
DECLARE
  CURSOR inv_cursor(id IN NUMBER) IS
    SELECT iit_chr_attrib26, iit_chr_attrib27 FROM nm_inv_items_all
    WHERE iit_ne_id = id;
  inv_row inv_cursor%ROWTYPE;
  CURSOR datum_cursor(id IN NUMBER) IS
    SELECT ne_number FROM nm_elements_all
    where nm_elements_all.ne_id = id;
  datum_row datum_cursor%ROWTYPE;
  action VARCHAR2(10);
BEGIN
  IF INSERTING OR UPDATING THEN
    OPEN inv_cursor(:new.nm_ne_id_in);
    FETCH inv_cursor INTO inv_row;
    CLOSE inv_cursor;
    OPEN datum_cursor(:new.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    --
    IF INSERTING THEN
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
    INSERT INTO rrl_lcwy_in_la_aud VALUES(
      audit_id_seq.nextval,
      action,
      :new.nm_ne_id_of,
      :new.nm_begin_mp,
      :new.nm_end_mp,
      :new.nm_obj_type,
      inv_row.iit_chr_attrib27,
      NULL,
      datum_row.ne_number,
      :new.nm_start_date
      );
  ELSIF DELETING THEN
    -- This shouldn't really happen (records get end-dated
    -- instead of being deleted).  However if a record
    -- does somehow get deleted, it will be handled here.
    OPEN inv_cursor(:old.nm_ne_id_in);
    FETCH inv_cursor INTO inv_row;
    CLOSE inv_cursor;
    OPEN datum_cursor(:old.nm_ne_id_of);
    FETCH datum_cursor INTO datum_row;
    CLOSE datum_cursor;
    INSERT INTO rrl_lcwy_in_la_aud VALUES(
      audit_id_seq.nextval,
      'delete',
      :old.nm_ne_id_of,
      :old.nm_begin_mp,
      :old.nm_end_mp,
      :old.nm_obj_type,
      inv_row.iit_chr_attrib27,
      NULL,
      datum_row.ne_number,
      :old.nm_start_date
    );
  END IF;
END;
.
/


CREATE OR REPLACE TRIGGER rrl_lcwy_in_la_inv_trig
AFTER UPDATE ON nm_inv_items_all FOR EACH ROW
  WHEN (new.iit_inv_type = 'LGA' OR new.iit_inv_type = 'SED')
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
      INSERT INTO rrl_lcwy_in_la_aud VALUES(
        audit_id_seq.nextval,
        action,
        member_row.nm_ne_id_of,
        member_row.nm_begin_mp,
        member_row.nm_end_mp,
        member_row.nm_obj_type,
        :new.iit_chr_attrib26,
        :new.iit_chr_attrib27,
        member_row.ne_number,
        member_row.nm_start_date
      );
    END LOOP;
  END IF;
END;
.
/


CREATE OR REPLACE TRIGGER rrl_lcwy_in_la_inv_mnum_trig
AFTER UPDATE ON nm_inv_items_all FOR EACH ROW
  WHEN (new.iit_inv_type = 'MNUM')
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
      INSERT INTO rrl_lcwy_in_la_aud VALUES(
        audit_id_seq.nextval,
        action,
        member_row.nm_ne_id_of,
        member_row.nm_begin_mp,
        member_row.nm_end_mp,
        member_row.nm_obj_type,
        :new.iit_chr_attrib27,
        NULL,
        member_row.ne_number,
        member_row.nm_start_date
      );
    END LOOP;
  END IF;
END;
.
/
