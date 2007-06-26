CREATE OR REPLACE TRIGGER xtnz_lar_hct_ial_maint_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON hig_contacts
   FOR EACH ROW
   WHEN (NVL(NEW.hct_org_or_person_flag,OLD.hct_org_or_person_flag) = 'O'
        )
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_lar_hct_ial_maint_trg.trg	1.1 03/15/05
--       Module Name      : xtnz_lar_hct_ial_maint_trg.trg
--       Date into SCCS   : 05/03/15 03:46:05
--       Date fetched Out : 07/06/06 14:40:27
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   c_domain CONSTANT nm_inv_domains.id_domain%TYPE := 'HIG_CONTACTS';
   l_rec_ial     nm_inv_attri_lookup_all%ROWTYPE;
   l_rec_ial_new nm_inv_attri_lookup_all%ROWTYPE;
   l_rec_id      nm_inv_domains_all%ROWTYPE;
   l_rowid       ROWID;
   l_update_data BOOLEAN := FALSE;
BEGIN

   l_rec_id := nm3get.get_id_all (pi_id_domain => c_domain);
   l_rec_ial_new.ial_domain      := c_domain;
   l_rec_ial_new.ial_value       := :NEW.hct_organisation;
   l_rec_ial_new.ial_meaning     := :NEW.hct_organisation;
   l_rec_ial_new.ial_dtp_code    := :NEW.hct_id;
   l_rec_ial_new.ial_start_date  := NVL(:NEW.hct_start_date,l_rec_id.id_start_date);
   l_rec_ial_new.ial_end_date    := NVL(:NEW.hct_end_date,l_rec_id.id_end_date);
   l_rec_ial_new.ial_seq         := :NEW.hct_id;
   l_rec_ial_new.ial_nva_id      := Null;
   l_rowid   := nm3lock_gen.lock_ial
                                (pi_ial_domain      => c_domain
                                ,pi_ial_value       => :NEW.hct_id
                                ,pi_raise_not_found => FALSE
                                );
--
   IF INSERTING
    THEN
      l_rec_ial := nm3get.get_ial     (pi_ial_domain      => c_domain
                                      ,pi_ial_value       => l_rec_ial_new.ial_value
                                      ,pi_raise_not_found => FALSE
                                      );
      IF   l_rec_ial.ial_value    IS NOT NULL
       AND l_rec_ial.ial_end_date IS NOT NULL
       THEN -- The value is already in there
         l_rec_ial_new.ial_start_date  := LEAST (NVL(:NEW.hct_start_date,l_rec_ial.ial_start_date),l_rec_ial.ial_start_date);
         l_rec_ial_new.ial_end_date    := NVL(:NEW.hct_end_date,l_rec_id.id_end_date);
         l_update_data := TRUE;
      ELSE
         nm3ins.ins_ial_all (p_rec_ial_all => l_rec_ial_new);
      END IF;
   ELSIF UPDATING
    THEN
      l_update_data := TRUE;
   ELSIF DELETING
    THEN
      l_rowid   := nm3lock_gen.lock_ial
                                   (pi_ial_domain      => c_domain
                                   ,pi_ial_value       => :OLD.hct_organisation
                                   ,pi_raise_not_found => FALSE
                                   );
      UPDATE nm_inv_attri_lookup_all
       SET   ial_end_date = nm3user.get_effective_date
      WHERE  ROWID        = l_rowid;
   END IF;
--
   IF l_update_data
    THEN
      UPDATE nm_inv_attri_lookup_all
        SET  ial_value      = l_rec_ial_new.ial_value
            ,ial_dtp_code   = l_rec_ial_new.ial_dtp_code
            ,ial_meaning    = l_rec_ial_new.ial_meaning
            ,ial_start_date = l_rec_ial_new.ial_start_date
            ,ial_end_date   = l_rec_ial_new.ial_end_date
            ,ial_seq        = l_rec_ial_new.ial_seq
            ,ial_nva_id     = l_rec_ial_new.ial_nva_id
       WHERE ROWID          = l_rowid;
   END IF;
--
END xtnz_lar_hct_ial_maint_trg;
/

