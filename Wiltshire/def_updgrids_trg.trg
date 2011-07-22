CREATE OR REPLACE TRIGGER DEF_UPDGRIDS_TRG
 BEFORE INSERT OR UPDATE ON DEFECTS FOR EACH ROW
DECLARE
tmpVar NUMBER;
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Wiltshire/def_updgrids_trg.trg-arc   1.0   Jul 22 2011 09:30:52   Ian.Turnbull  $
--       Module Name      : $Workfile:   def_updgrids_trg.trg  $
--       Date into PVCS   : $Date:   Jul 22 2011 09:30:52  $
--       Date fetched Out : $Modtime:   Jul 22 2011 09:29:40  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
--    DEF_UPDUSRN_TRG
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
vstg VARCHAR2(100);
vstg2 VARCHAR2(100);
v_usrn nm_elements_all.ne_number%type;

cursor c1(p_id nm_elements_all.ne_id%type) is
select ne_number from nm_elements_all
where ne_id = p_id;
--
BEGIN
    IF INSERTING
	THEN BEGIN
  	       vstg:='<Grids>';
           vstg2:='<USRN>';
	       IF  :NEW.def_easting  IS NOT NULL
		   AND :NEW.def_northing IS NOT NULL
		   THEN vstg:=vstg||TO_CHAR(TRUNC(:NEW.def_easting))||':'||TO_CHAR(TRUNC(:NEW.def_northing));
                    tmpVar := nm3sdo.get_nearest_to_xy(nm3sdm.get_theme_from_feature_table('V_NM_NAT_NSGN_OFFN_SDO_DT'),:NEW.def_easting,:NEW.def_northing);
                    OPEN  c1(tmpVar);
                    FETCH c1
                    INTO v_usrn;
                    CLOSE c1;
                    vstg2:=vstg2||v_usrn;
		   END IF;
		   :NEW.def_special_instr:=:NEW.def_special_instr||vstg||vstg2;
	     END;
    END IF;
    IF UPDATING
	THEN IF :NEW.def_easting  <> :OLD.def_easting
	     OR :NEW.def_northing <> :OLD.def_northing
		 THEN BEGIN
		        :NEW.def_special_instr:=SUBSTR(:NEW.def_special_instr,1,(INSTR(:NEW.def_special_instr,'<Grids>')-1));
	 			vstg:='<Grids>';
                vstg2:='<USRN>';
	            IF  :NEW.def_easting  IS NOT NULL
		        AND :NEW.def_northing IS NOT NULL
		        THEN vstg:=vstg||TO_CHAR(TRUNC(:NEW.def_easting))||':'||TO_CHAR(TRUNC(:NEW.def_northing));
                         tmpVar := nm3sdo.get_nearest_to_xy(nm3sdm.get_theme_from_feature_table('V_NM_NAT_NSGN_OFFN_SDO_DT'),:NEW.def_easting,:NEW.def_northing);
                         OPEN  c1(tmpVar);
                         FETCH c1
                         INTO v_usrn;
                         CLOSE c1;
                         vstg2:=vstg2||v_usrn;
		        END IF;
		        :NEW.def_special_instr:=:NEW.def_special_instr||vstg||vstg2;
	          END;
		 END IF;
	END IF;
--
EXCEPTION
  WHEN OTHERS
  THEN NULL;
END DEF_UPDGRIDS_TRG;
/
