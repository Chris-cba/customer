CREATE OR REPLACE TRIGGER xmrwa_trav_time_ne_bu_row_trg
   BEFORE INSERT OR UPDATE
    ON    nm_elements_all
   FOR    EACH ROW
   WHEN (NEW.ne_gty_group_type = 'TRAV')
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_trav_time_ne_bu_row_trg.sql	1.1 03/15/05
--       Module Name      : xmrwa_trav_time_ne_bu_row_trg.sql
--       Date into SCCS   : 05/03/15 00:46:31
--       Date fetched Out : 07/06/06 14:38:32
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA trigger to send emails on update of a travel time route
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
   l_prefix VARCHAR2(10);
--
BEGIN
--
   IF INSERTING
    THEN
      l_prefix := 'New';
   ELSIF UPDATING
    THEN
      l_prefix := 'Updated';
   END IF;
--
   xmrwa_travel_time.g_rec_ne_old.ne_id                          := :OLD.ne_id;
   xmrwa_travel_time.g_rec_ne_old.ne_unique                      := :OLD.ne_unique;
   xmrwa_travel_time.g_rec_ne_old.ne_type                        := :OLD.ne_type;
   xmrwa_travel_time.g_rec_ne_old.ne_nt_type                     := :OLD.ne_nt_type;
   xmrwa_travel_time.g_rec_ne_old.ne_descr                       := :OLD.ne_descr;
   xmrwa_travel_time.g_rec_ne_old.ne_length                      := :OLD.ne_length;
   xmrwa_travel_time.g_rec_ne_old.ne_admin_unit                  := :OLD.ne_admin_unit;
   xmrwa_travel_time.g_rec_ne_old.ne_date_created                := :OLD.ne_date_created;
   xmrwa_travel_time.g_rec_ne_old.ne_date_modified               := :OLD.ne_date_modified;
   xmrwa_travel_time.g_rec_ne_old.ne_modified_by                 := :OLD.ne_modified_by;
   xmrwa_travel_time.g_rec_ne_old.ne_created_by                  := :OLD.ne_created_by;
   xmrwa_travel_time.g_rec_ne_old.ne_start_date                  := :OLD.ne_start_date;
   xmrwa_travel_time.g_rec_ne_old.ne_end_date                    := :OLD.ne_end_date;
   xmrwa_travel_time.g_rec_ne_old.ne_gty_group_type              := :OLD.ne_gty_group_type;
   xmrwa_travel_time.g_rec_ne_old.ne_owner                       := :OLD.ne_owner;
   xmrwa_travel_time.g_rec_ne_old.ne_name_1                      := :OLD.ne_name_1;
   xmrwa_travel_time.g_rec_ne_old.ne_name_2                      := :OLD.ne_name_2;
   xmrwa_travel_time.g_rec_ne_old.ne_prefix                      := :OLD.ne_prefix;
   xmrwa_travel_time.g_rec_ne_old.ne_number                      := :OLD.ne_number;
   xmrwa_travel_time.g_rec_ne_old.ne_sub_type                    := :OLD.ne_sub_type;
   xmrwa_travel_time.g_rec_ne_old.ne_group                       := :OLD.ne_group;
   xmrwa_travel_time.g_rec_ne_old.ne_no_start                    := :OLD.ne_no_start;
   xmrwa_travel_time.g_rec_ne_old.ne_no_end                      := :OLD.ne_no_end;
   xmrwa_travel_time.g_rec_ne_old.ne_sub_class                   := :OLD.ne_sub_class;
   xmrwa_travel_time.g_rec_ne_old.ne_nsg_ref                     := :OLD.ne_nsg_ref;
   xmrwa_travel_time.g_rec_ne_old.ne_version_no                  := :OLD.ne_version_no;
--
   xmrwa_travel_time.g_rec_ne_new.ne_id                          := :NEW.ne_id;
   xmrwa_travel_time.g_rec_ne_new.ne_unique                      := :NEW.ne_unique;
   xmrwa_travel_time.g_rec_ne_new.ne_type                        := :NEW.ne_type;
   xmrwa_travel_time.g_rec_ne_new.ne_nt_type                     := :NEW.ne_nt_type;
   xmrwa_travel_time.g_rec_ne_new.ne_descr                       := :NEW.ne_descr;
   xmrwa_travel_time.g_rec_ne_new.ne_length                      := :NEW.ne_length;
   xmrwa_travel_time.g_rec_ne_new.ne_admin_unit                  := :NEW.ne_admin_unit;
   xmrwa_travel_time.g_rec_ne_new.ne_date_created                := :NEW.ne_date_created;
   xmrwa_travel_time.g_rec_ne_new.ne_date_modified               := :NEW.ne_date_modified;
   xmrwa_travel_time.g_rec_ne_new.ne_modified_by                 := :NEW.ne_modified_by;
   xmrwa_travel_time.g_rec_ne_new.ne_created_by                  := :NEW.ne_created_by;
   xmrwa_travel_time.g_rec_ne_new.ne_start_date                  := :NEW.ne_start_date;
   xmrwa_travel_time.g_rec_ne_new.ne_end_date                    := :NEW.ne_end_date;
   xmrwa_travel_time.g_rec_ne_new.ne_gty_group_type              := :NEW.ne_gty_group_type;
   xmrwa_travel_time.g_rec_ne_new.ne_owner                       := :NEW.ne_owner;
   xmrwa_travel_time.g_rec_ne_new.ne_name_1                      := :NEW.ne_name_1;
   xmrwa_travel_time.g_rec_ne_new.ne_name_2                      := :NEW.ne_name_2;
   xmrwa_travel_time.g_rec_ne_new.ne_prefix                      := :NEW.ne_prefix;
   xmrwa_travel_time.g_rec_ne_new.ne_number                      := :NEW.ne_number;
   xmrwa_travel_time.g_rec_ne_new.ne_sub_type                    := :NEW.ne_sub_type;
   xmrwa_travel_time.g_rec_ne_new.ne_group                       := :NEW.ne_group;
   xmrwa_travel_time.g_rec_ne_new.ne_no_start                    := :NEW.ne_no_start;
   xmrwa_travel_time.g_rec_ne_new.ne_no_end                      := :NEW.ne_no_end;
   xmrwa_travel_time.g_rec_ne_new.ne_sub_class                   := :NEW.ne_sub_class;
   xmrwa_travel_time.g_rec_ne_new.ne_nsg_ref                     := :NEW.ne_nsg_ref;
   xmrwa_travel_time.g_rec_ne_new.ne_version_no                  := :NEW.ne_version_no;
--
   xmrwa_travel_time.fire_group_change_email (l_prefix);
--
END xmrwa_trav_time_ne_bu_row_trg;
/

