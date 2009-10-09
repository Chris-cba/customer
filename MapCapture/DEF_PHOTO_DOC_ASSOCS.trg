CREATE OR REPLACE TRIGGER DEF_PHOTO_DOC_ASSOCS
BEFORE INSERT
ON DEFECTS REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/MapCapture/DEF_PHOTO_DOC_ASSOCS.trg-arc   3.0   Oct 09 2009 14:43:00   Ian Turnbull  $
--       Module Name      : $Workfile:   DEF_PHOTO_DOC_ASSOCS.trg  $
--       Date into PVCS   : $Date:   Oct 09 2009 14:43:00  $
--       Date fetched Out : $Modtime:   Oct 09 2009 14:25:34  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
/******************************************************************************
   NAME:       DEF_PHOTO_DOC_ASSOCS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/10/2006  P Stanton        Automatically create a doc assoc for a defects that have photos
   1.1        27/03/2007  P Stanton 	 Updated to deal with both before and after defect photos 
   1.2        08/10/2009  P Stanton        Updated doc locations for enfield and East sussex. Tidied up before and after since it
                                           was creating both when it didn't have both a before and after photo
   1.3        09/10/2009  P Stanton        For East Sussex made change to a before insert trigger so that the special instruction 
                                           field could have the special characters removed after the photo associations have been made
                                           this is because the CHR(1) was coming out in the CIM file and couldn't be loaded                                                 
   NOTES:
   Trigger to create document associations between defect photos and defects.
   In mapcapture when defect photo are attached, the names of the photos are stored in the def_special_instr field.
   This trigger fires before insert and checks the def_special_instr field for photo id’s and if they exist creates doc_assocs records for   
   the photos. 
   Document manager metadata must exist that has a doc_type of PHOTO and a doc_location named DEFECT PHOTOS.
   The def_special_instr is then stripped of the special characters ( CHR(1) ) so that if the customer is using CIM this does not cause 
   Problems when extracted.


******************************************************************************/
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

  l_doc_id         number;
  l_before_photo   docs.doc_file%type;
  l_after_photo    docs.doc_file%type;
  l_initials       VARCHAR2(3);
  l_dlc_dmd_id     NUMBER;
  l_dlc_id         NUMBER;
  
  CURSOR get_initials IS
  SELECT hus_initials FROM hig_users
  WHERE hus_username = user;

  --CURSOR get_location( p_initials VARCHAR2) IS
  --SELECT dlc_dmd_id, dlc_id FROM doc_locations
  --WHERE dlc_name = p_initials||'_DEFECT_PHOTOS';
  
  CURSOR get_location IS
  SELECT dlc_dmd_id, dlc_id FROM doc_locations
  WHERE dlc_name = 'DEFECT PHOTOS';
  
BEGIN

IF :new.def_special_instr IS NOT NULL THEN

    --l_before_photo := substr(:new.def_special_instr,instr(:new.def_special_instr,chr(1),1)+1,instr(:new.def_special_instr,chr(1),2)-2); 
    
    l_before_photo := substr(:new.def_special_instr,(instr(:new.def_special_instr,chr(1),1,1)+1),(instr(:new.def_special_instr,chr(1),1,2))-6); 

    --l_after_photo  := substr(:new.def_special_instr,instr(:new.def_special_instr,chr(1),3)+1); 
    
    l_after_photo  := substr(:new.def_special_instr,instr(:new.def_special_instr,chr(1),1,2)+1);
                      

   IF l_before_photo IS NOT NULL THEN

      l_doc_id := doc.get_next_doc_id;
   
      --OPEN get_initials;
      --FETCH get_initials INTO l_initials;
      --CLOSE get_initials;
   
      OPEN get_location;
      FETCH get_location INTO l_dlc_dmd_id, l_dlc_id;
      CLOSE get_location;
   
      INSERT INTO docs 
      ( doc_id,
        doc_title, 
        doc_dtp_code, 
        doc_date_issued, 
        doc_file, 
        doc_dlc_dmd_id, 
        doc_dlc_id, 
        doc_reference_code, 
        doc_descr
      )
      VALUES
      ( 
        l_doc_id,
        Substr('Defect Photograph '||doc.get_table_descr('DEFECTS')||' - '||:new.def_defect_id, 1, 60),
        'PHOTO',
        sysdate,
        l_before_photo,
        l_dlc_dmd_id,
        l_dlc_id,
        l_before_photo,
        'Before Defect Photo automatically associated with Defect'
      );
      
      INSERT INTO doc_assocs 
      (
       das_table_name,
       das_rec_id,
       das_doc_id
       )
       VALUES
       (
       'DEFECTS',
       :new.def_defect_id,
       l_doc_id 
       );
   
   END IF;
   
  IF l_after_photo IS NOT NULL THEN

      l_doc_id := doc.get_next_doc_id;
   
      --OPEN get_initials;
      --FETCH get_initials INTO l_initials;
      --CLOSE get_initials;
   
      OPEN get_location;
      FETCH get_location INTO l_dlc_dmd_id, l_dlc_id;
      CLOSE get_location;
   
      INSERT INTO docs 
      ( doc_id,
        doc_title, 
        doc_dtp_code, 
        doc_date_issued, 
        doc_file, 
        doc_dlc_dmd_id, 
        doc_dlc_id, 
        doc_reference_code, 
        doc_descr
      )
      VALUES
      ( 
        l_doc_id,
        Substr('Defect Photograph '||doc.get_table_descr('DEFECTS')||' - '||:new.def_defect_id, 1, 60),
       'PHOTO',
        sysdate,
        l_after_photo,
        l_dlc_dmd_id,
        l_dlc_id,
        l_after_photo,
        'After Defect Photo automatically associated with Defect'
      );
      
      INSERT INTO doc_assocs 
      (
       das_table_name,
       das_rec_id,
       das_doc_id
       )
       VALUES
       (
       'DEFECTS',
       :new.def_defect_id,
       l_doc_id 
       );
   
   END IF;
   
   :new.def_special_instr := replace(:new.def_special_instr,chr(1),' - ');
END IF;

   
END DEF_PHOTO_DOC_ASSOCS;
/
