create or replace view X_WO_TFL_WT_IM511003_ALL as
--
--
Select DISTINCT *
     FROM 
          X_WO_TFL_WT_IM511003_FULL
    WHERE     1=1
           and  nvl(WOR_CHAR_ATTRIB118 , 'BLANK') not in ('PROD', 'DRAFT')
          ;
