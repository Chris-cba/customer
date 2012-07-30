CREATE OR REPLACE TRIGGER XLBE_DEF_PHOTO_DOC_ASSOCS
AFTER INSERT
ON DEFECTS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/defect photo trigger/XLBE_DEF_PHOTO_DOC_ASSOCS.trg-arc   1.0   Jul 30 2012 15:05:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   XLBE_DEF_PHOTO_DOC_ASSOCS.trg  $
--       Date into PVCS   : $Date:   Jul 30 2012 15:05:18  $
--       Date fetched Out : $Modtime:   Jul 06 2012 14:56:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_def_photo_doc_assocs
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

  l_doc_id         number;
  l_photo          VARCHAR2(3);
  l_dlc_dmd_id     NUMBER;
  l_dlc_id         NUMBER;

BEGIN

  for locrec in (select dlc_dmd_id, dlc_id, dlc_name 
                 FROM doc_locations where dlc_name 
                 in ('COMPLETED_DEFECT_PHOTO_JPG','COMPLETED_DEFECT_PHOTO_BMP')) loop

  IF locrec.dlc_name = 'COMPLETED_DEFECT_PHOTO_BMP' THEN

    l_doc_id := doc.get_next_doc_id;
    l_dlc_dmd_id := locrec.dlc_dmd_id;
    l_dlc_id := locrec.dlc_id;
    
     
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
       'DONE',
       sysdate,
       'CPD-'||:new.def_defect_id||'.BMP',
       l_dlc_dmd_id,
       l_dlc_id,
       'CPD-'||:new.def_defect_id||'.BMP',
       'Defect Photo automatically associated with Defect'
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
               
      INSERT INTO doc_assocs
      (
    das_table_name,
    das_rec_id,
    das_doc_id
       )
       VALUES
       (
     'DEF_REP_TREAT',
     :new.def_defect_id,
     l_doc_id
       );       
       
   END IF;

  IF locrec.dlc_name = 'COMPLETED_DEFECT_PHOTO_JPG' THEN

    l_doc_id := doc.get_next_doc_id;
    l_dlc_dmd_id := locrec.dlc_dmd_id;
    l_dlc_id := locrec.dlc_id;
    
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
      'DONE',
      sysdate,
      'CPD-'||:new.def_defect_id||'.JPG',
      l_dlc_dmd_id,
      l_dlc_id,
      'CPD-'||:new.def_defect_id||'.JPG',
      'Defect Photo automatically associated with Defect'
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
               
      INSERT INTO doc_assocs
      (
    das_table_name,
    das_rec_id,
    das_doc_id
       )
       VALUES
       (
     'DEF_REP_TREAT',
     :new.def_defect_id,
     l_doc_id
       );       
       
   END IF;
END LOOP;


END XLBE_DEF_PHOTO_DOC_ASSOCS;
/
