-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/XSPOFFSET metadata.sql-arc   3.0   Dec 21 2010 15:55:46   Ade.Edwards  $
--       Module Name      : $Workfile:   XSPOFFSET metadata.sql  $
--       Date into PVCS   : $Date:   Dec 21 2010 15:55:46  $
--       Date fetched Out : $Modtime:   Dec 21 2010 15:18:40  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks      
                            ,hol_datatype     
                            ,hol_domain
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'XSPOFFSET'
     , 'NET'
     , 'XSP Offset functionality'
     , 'If set to Y to enable the XSP OFFSET functionality. This will allow you to create XSP Offset data in the GIS Layer Tool.'
     , 'VARCHAR2'
     , 'Y_OR_N'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'XSPOFFSET')
/

INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'XSPOFFSET'
     , 'N'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'XSPOFFSET')
/