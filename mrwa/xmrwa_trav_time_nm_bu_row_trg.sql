CREATE OR REPLACE TRIGGER xmrwa_trav_time_nm_bu_row_trg
   BEFORE INSERT OR UPDATE
    ON    nm_members_all
   FOR    EACH ROW
   WHEN (  (NEW.nm_type = 'G' AND NEW.nm_obj_type = 'TRAV')
        OR (NEW.nm_type = 'I' AND NEW.nm_obj_type = 'TRTI')
        )
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_trav_time_nm_bu_row_trg.sql	1.1 03/15/05
--       Module Name      : xmrwa_trav_time_nm_bu_row_trg.sql
--       Date into SCCS   : 05/03/15 00:46:32
--       Date fetched Out : 07/06/06 14:38:34
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
   xmrwa_travel_time.g_rec_nm_old.nm_ne_id_in                    := :OLD.nm_ne_id_in;
   xmrwa_travel_time.g_rec_nm_old.nm_ne_id_of                    := :OLD.nm_ne_id_of;
   xmrwa_travel_time.g_rec_nm_old.nm_type                        := :OLD.nm_type;
   xmrwa_travel_time.g_rec_nm_old.nm_obj_type                    := :OLD.nm_obj_type;
   xmrwa_travel_time.g_rec_nm_old.nm_begin_mp                    := :OLD.nm_begin_mp;
   xmrwa_travel_time.g_rec_nm_old.nm_start_date                  := :OLD.nm_start_date;
   xmrwa_travel_time.g_rec_nm_old.nm_end_date                    := :OLD.nm_end_date;
   xmrwa_travel_time.g_rec_nm_old.nm_end_mp                      := :OLD.nm_end_mp;
   xmrwa_travel_time.g_rec_nm_old.nm_slk                         := :OLD.nm_slk;
   xmrwa_travel_time.g_rec_nm_old.nm_cardinality                 := :OLD.nm_cardinality;
   xmrwa_travel_time.g_rec_nm_old.nm_admin_unit                  := :OLD.nm_admin_unit;
   xmrwa_travel_time.g_rec_nm_old.nm_date_created                := :OLD.nm_date_created;
   xmrwa_travel_time.g_rec_nm_old.nm_date_modified               := :OLD.nm_date_modified;
   xmrwa_travel_time.g_rec_nm_old.nm_modified_by                 := :OLD.nm_modified_by;
   xmrwa_travel_time.g_rec_nm_old.nm_created_by                  := :OLD.nm_created_by;
   xmrwa_travel_time.g_rec_nm_old.nm_seq_no                      := :OLD.nm_seq_no;
   xmrwa_travel_time.g_rec_nm_old.nm_seg_no                      := :OLD.nm_seg_no;
   xmrwa_travel_time.g_rec_nm_old.nm_true                        := :OLD.nm_true;
   xmrwa_travel_time.g_rec_nm_old.nm_end_slk                     := :OLD.nm_end_slk;
   xmrwa_travel_time.g_rec_nm_old.nm_end_true                    := :OLD.nm_end_true;
--
   xmrwa_travel_time.g_rec_nm_new.nm_ne_id_in                    := :NEW.nm_ne_id_in;
   xmrwa_travel_time.g_rec_nm_new.nm_ne_id_of                    := :NEW.nm_ne_id_of;
   xmrwa_travel_time.g_rec_nm_new.nm_type                        := :NEW.nm_type;
   xmrwa_travel_time.g_rec_nm_new.nm_obj_type                    := :NEW.nm_obj_type;
   xmrwa_travel_time.g_rec_nm_new.nm_begin_mp                    := :NEW.nm_begin_mp;
   xmrwa_travel_time.g_rec_nm_new.nm_start_date                  := :NEW.nm_start_date;
   xmrwa_travel_time.g_rec_nm_new.nm_end_date                    := :NEW.nm_end_date;
   xmrwa_travel_time.g_rec_nm_new.nm_end_mp                      := :NEW.nm_end_mp;
   xmrwa_travel_time.g_rec_nm_new.nm_slk                         := :NEW.nm_slk;
   xmrwa_travel_time.g_rec_nm_new.nm_cardinality                 := :NEW.nm_cardinality;
   xmrwa_travel_time.g_rec_nm_new.nm_admin_unit                  := :NEW.nm_admin_unit;
   xmrwa_travel_time.g_rec_nm_new.nm_date_created                := :NEW.nm_date_created;
   xmrwa_travel_time.g_rec_nm_new.nm_date_modified               := :NEW.nm_date_modified;
   xmrwa_travel_time.g_rec_nm_new.nm_modified_by                 := :NEW.nm_modified_by;
   xmrwa_travel_time.g_rec_nm_new.nm_created_by                  := :NEW.nm_created_by;
   xmrwa_travel_time.g_rec_nm_new.nm_seq_no                      := :NEW.nm_seq_no;
   xmrwa_travel_time.g_rec_nm_new.nm_seg_no                      := :NEW.nm_seg_no;
   xmrwa_travel_time.g_rec_nm_new.nm_true                        := :NEW.nm_true;
   xmrwa_travel_time.g_rec_nm_new.nm_end_slk                     := :NEW.nm_end_slk;
   xmrwa_travel_time.g_rec_nm_new.nm_end_true                    := :NEW.nm_end_true;
--
   xmrwa_travel_time.fire_mem_change_email (l_prefix);
--
END xmrwa_trav_time_nm_bu_row_trg;
/

