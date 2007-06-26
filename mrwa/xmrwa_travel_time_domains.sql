--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
INSERT INTO hig_domains
      (HDO_DOMAIN
      ,HDO_PRODUCT
      ,HDO_TITLE
      ,HDO_CODE_LENGTH
      )
VALUES ('TRAVEL_VERSION'
       ,'MRWA'
       ,'Travel Version'
       ,2
       )
/


INSERT INTO hig_codes
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       )
SELECT 'TRAVEL_VERSION'
      ,ne_id
      ,ne_id
      ,'N'
      ,ne_id
 FROM  nm_elements_all
WHERE  NE_ID <= 10
/


INSERT INTO hig_domains
      (HDO_DOMAIN
      ,HDO_PRODUCT
      ,HDO_TITLE
      ,HDO_CODE_LENGTH
      )
VALUES ('TRAVEL_DIRECTION'
       ,'MRWA'
       ,'Travel Direction'
       ,2
       )
/


INSERT INTO hig_codes
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       )
SELECT 'TRAVEL_DIRECTION'
      ,DECODE(ne_id,1,'NB',2,'SB',3,'EB',4,'WB',5,'NM')
      ,DECODE(ne_id,1,'NB',2,'SB',3,'EB',4,'WB',5,'NM')
      ,'N'
      ,ne_id
 FROM  nm_elements_all
WHERE  NE_ID <= 5
/

INSERT INTO hig_domains
      (HDO_DOMAIN
      ,HDO_PRODUCT
      ,HDO_TITLE
      ,HDO_CODE_LENGTH
      )
VALUES ('TRAVEL_LOCATION'
       ,'MRWA'
       ,'Travel Location'
       ,2
       )
/

INSERT INTO hig_codes
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       )
SELECT 'TRAVEL_LOCATION'
      ,DECODE(ne_id,1,'M',2,'NM')
      ,DECODE(ne_id,1,'M',2,'NM')
      ,'N'
      ,ne_id
 FROM  nm_elements_all
WHERE  NE_ID <= 2
/