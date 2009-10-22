CREATE OR REPLACE TRIGGER xwcc_def_sdo_trg
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Warwickshire/Defects SDO/xwcc_def_sdo_trg.trg-arc   3.0   Oct 22 2009 08:42:34   aedwards  $
--       Module Name      : $Workfile:   xwcc_def_sdo_trg.trg  $
--       Date into PVCS   : $Date:   Oct 22 2009 08:42:34  $
--       Date fetched Out : $Modtime:   Oct 22 2009 08:41:44  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
--
--Trigger is based on a generated theme trigger but modified by Rob Coupe
--
--Date 23 April 2009
--
--------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2005
--------------------------------------------------------------------------
--

BEFORE
DELETE OR INSERT OR UPDATE of def_easting,def_northing,def_st_chain
ON DEFECTS FOR EACH ROW
DECLARE

 l_geom mdsys.sdo_geometry;
 l_lref nm_lref;

--
--------------------------------------------------------------------------
--
 PROCEDURE del IS
 BEGIN

    -- Delete from feature table mai_defects_lr_sdo
    DELETE FROM mai_defects_lr_sdo
          WHERE def_defect_id = :OLD.def_defect_id;

 EXCEPTION -- when others to cater for attempted delete where no geom values supplied e.g. no x/y
     WHEN others THEN
       Null;
 END del;
--
--------------------------------------------------------------------------
--
 PROCEDURE ins ( l_lref in nm_lref ) IS
-- l_lref nm_lref;
 BEGIN

--   l_lref := NM3LRS.GET_DISTINCT_OFFSET( nm_lref( :NEW.def_rse_he_id, :NEW.def_st_chain ));

   -- Insert into feature table mai_defects_lr_sdo
    INSERT INTO mai_defects_lr_sdo
    ( def_defect_id
    , geoloc
    , objectid
    )
    VALUES
    ( :NEW.def_defect_id
      ,nm3sdo.get_pt_shape_from_ne ( l_lref.lr_ne_id, l_lref.lr_offset ) -- geometry derived from start chainage reference
    , nth_173_seq.NEXTVAL
    );

 EXCEPTION -- when others to cater for attempted insert where no geom values supplied e.g. no x/y
    WHEN others THEN
       Null;
 END ins;
--
--------------------------------------------------------------------------
--
 PROCEDURE upd ( l_lref in nm_lref ) IS
-- l_lref nm_lref;
 BEGIN

--   l_lref := NM3LRS.GET_DISTINCT_OFFSET( nm_lref( :NEW.def_rse_he_id, :NEW.def_st_chain ));

    -- Update feature table mai_defects_lr_sdo
    UPDATE mai_defects_lr_sdo
       SET def_defect_id = :NEW.def_defect_id
              ,GEOLOC=nm3sdo.get_pt_shape_from_ne(l_lref.lr_ne_id, l_lref.lr_offset)
     WHERE def_defect_id = :OLD.DEF_DEFECT_ID;

    IF SQL%ROWCOUNT=0 THEN
       ins (l_lref );
    END IF;


 EXCEPTION -- when others to cater for attempted update where no geom values supplied e.g. no x/y
     WHEN others THEN
       Null;
 END upd;
--
--------------------------------------------------------------------------
--
BEGIN

   IF DELETING THEN
        del;
   ELSE
     
     DECLARE

       notrans exception;
       pragma exception_init( notrans,  -20001 );
       
       l_length number;

     BEGIN
     
       l_lref := NM3LRS.GET_DISTINCT_OFFSET( nm_lref( :NEW.def_rse_he_id, :NEW.def_st_chain ));
       
     exception
       when notrans then
       
         l_length := nm3net.get_ne_length( :NEW.def_rse_he_id );
         
         if l_length is not null and :NEW.def_st_chain > trunc(l_length) then
           
           :NEW.def_st_chain := trunc( l_length ); -- caters for def_st_chain being a whole number;
           
           l_lref := nm_lref( :NEW.def_rse_he_id, :NEW.def_st_chain);
           
         else

           raise_application_error( -20001, 'Defect measure does not exist, check the Section and measures');
           
         end if;

     END;
   
     IF INSERTING THEN
        ins( l_lref );
     ELSIF UPDATING THEN
        upd( l_lref );
     END IF;
     
   END IF;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
     NULL; -- no data in spatial table to update or delete
   WHEN OTHERS THEN
     RAISE;
END xwcc_def_sdo_trg;
--
--------------------------------------------------------------------------
--
/
