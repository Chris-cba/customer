drop trigger XKYTC_INV_TYPES_hath_trg;
drop trigger XKYTC_INV_TYPES_hath_trg_bi;
drop trigger XKYTC_INV_TYPES_hath_trg_ai;

drop trigger XKYTC_INV_TYPES_hatt_trg;
drop trigger XKYTC_INV_TYPES_hatt_trg_bi;
drop trigger XKYTC_INV_TYPES_hatt_trg_ai;

drop package xKYTC_META_Insert;

drop function xKYTC_hath_fk;

---- remove CSV LOADERS
DECLARE
--
-- ###############################################################
--
--  File           : 329.HATT_CSV.sql
--  Extracted from : EXOR@ktky.BRSCOMODB03
--  Extracted by   : EXOR
--  At             : 11-JUN-2013 15:52:27
--
-- ###############################################################
--
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
--
--
BEGIN
--
   l_rec_nlf.nlf_unique           := 'HATT_CSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
				  
   l_rec_nlf.nlf_unique           := 'HATH_CSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
END;

/