CREATE OR REPLACE TRIGGER xmrwa_nmg_ial_maint_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON nm_mail_groups
   FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_nmg_ial_maint_trg.trg	1.1 03/15/05
--       Module Name      : xmrwa_nmg_ial_maint_trg.trg
--       Date into SCCS   : 05/03/15 00:45:57
--       Date fetched Out : 07/06/06 14:38:24
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   c_domain_name CONSTANT nm_inv_domains.id_domain%TYPE := 'NM_MAIL_GROUPS';
BEGIN
   IF INSERTING
    THEN
      INSERT INTO nm_inv_attri_lookup
             (ial_domain
             ,ial_value
             ,ial_meaning
             ,ial_start_date
             ,ial_seq
             )
      VALUES (c_domain_name
             ,:NEW.nmg_id
             ,:NEW.nmg_name
             ,TRUNC(SYSDATE)
             ,LEAST(:NEW.nmg_id,9999)
             );
   ELSIF UPDATING
    THEN
      UPDATE nm_inv_attri_lookup_all
       SET   ial_meaning  = :NEW.nmg_name
      WHERE  ial_domain   = c_domain_name
       AND   ial_value    = :NEW.nmg_id;
   ELSIF DELETING
    THEN
      UPDATE nm_inv_attri_lookup_all
       SET   ial_end_date = TRUNC(SYSDATE)
      WHERE  ial_domain   = c_domain_name
       AND   ial_value    = :OLD.nmg_id;
   END IF;
END;
/
