drop trigger XKYTC_INV_TYPES_METC_TRG_CMP;
drop trigger XKYTC_INV_TYPES_METP_TRG_CMP;


drop package xKYTC_META_Insert;

drop function xKYTC_METP_fk;

drop table xnm_inv_items_all;

---- remove CSV LOADERS
DECLARE
--
-- ###############################################################
--
--  File           : 329.METC_CSV.sql
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
   l_rec_nlf.nlf_unique           := 'METC_CSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
				  
   l_rec_nlf.nlf_unique           := 'METP_CSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
END;

/