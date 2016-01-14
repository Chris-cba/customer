Insert into NM_INV_TYPES
   (NIT_INV_TYPE, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG, NIT_ELEC_DRAIN_CARR, NIT_CONTIGUOUS, 
    NIT_REPLACEABLE, NIT_EXCLUSIVE, NIT_CATEGORY, NIT_DESCR, NIT_LINEAR, 
    NIT_USE_XY, NIT_MULTIPLE_ALLOWED, NIT_END_LOC_ONLY, NIT_VIEW_NAME, NIT_START_DATE, 
    NIT_SHORT_DESCR, NIT_FLEX_ITEM_FLAG, NIT_ADMIN_TYPE, NIT_TOP, NIT_UPDATE_ALLOWED, 
    NIT_DATE_CREATED, NIT_MODIFIED_BY, NIT_CREATED_BY)
 Values
   ('OPBD', 'C', 'N', 'C', 'Y','Y', 'Y', 'D', 'Derived Type Operation', 'N', 
    'N', 'Y', 'N', 'V_NM_OPBD', to_date(sysdate), 'Derived Type Operation', 'N', 'INV', 'N', 'Y', 
    to_date(sysdate), 'EXOR', 'EXOR');

Insert into NM_INV_TYPE_ATTRIBS
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DATE_CREATED, ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('OPBD', 'IIT_CHR_ATTRIB26', 'Y', 1, 'N', 
    'VARCHAR2', 1, 'Type of Operation', 'Y', 'TYPE_OP', 
    'TYPE_OP', to_date(sysdate), 'Y', 'N', 'N', 
    to_date(sysdate), to_date(sysdate), 'EXOR', 'EXOR', 'Y', 
    1, 'Y', 'UPPER');
      
INSERT INTO NM_INV_TYPE_ROLES values
('OPBD', 'INV_ALL', 'NORMAL');
INSERT INTO NM_INV_TYPE_ROLES values
('OPBD', 'INV_READONLY', 'READONLY');

exec nm3inv.create_view ('OPBD', false);
--exec nm3inv.create_view ('OPBD', true);

declare


l_merge_id number;


begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY where NMQ_UNIQUE = 'TYPEOP_BD';
    
    delete from  NM_MRG_QUERY where NMQ_ID = l_merge_id;
    
    exception
    when others then null;
    
    end;
    
    commit;  

    select NMQ_ID_SEQ.nextval into l_merge_id from dual;
    
    Insert into NM_MRG_QUERY
       (NMQ_ID, NMQ_UNIQUE, NMQ_DESCR, NMQ_INNER_OUTER_JOIN, NMQ_INV_TYPE_X_SECT_COUNT, NMQ_TRANSIENT_QUERY)
    select 
       l_merge_id
       , 'TYPEOP_BD'
       , 'TYPEOP_BD'
       , 'O'
       , 0
       , 'Y' from dual;

     commit;

       Insert into NM_MRG_QUERY_ROLES
           (NQRO_NMQ_ID, NQRO_ROLE, NQRO_MODE)
               select
            l_merge_id
           , 'HIG_ADMIN'
           , 'NORMAL'
           from dual;

        commit;

        -- NM_MRG_QUERY_TYPES - asset types 
        
        

        Insert into NM_MRG_QUERY_TYPES
           (NQT_NMQ_ID, NQT_SEQ_NO, NQT_INV_TYPE, NQT_DEFAULT)
           select 
               l_merge_id
           , NQT_SEQ_NO_SEQ.nextval
           , nit_inv_type
           , 'N'
        from
        nm_inv_types where nit_inv_type = 'BD' 
              ;
           
        -- NM_MRG_QUERY_ATTRIBS asset attributes

        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME) 
        select NQT_NMQ_ID 
             , NQT_SEQ_NO
             , nvl(ita_attrib_name,'TYPE_OF_OPERATION')
      -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        -- and NQT_NMQ_ID = 39
        and NQT_NMQ_ID = l_merge_id
        AND ITA_ATTRIB_NAME = 'TYPE_OF_OPERATION'
       ;
      
     
     
        -- build the merge views so that the building of the derived asset works:
        commit;
     
      NM3MRG_VIEW.build_view(l_merge_ID);
END;
/

Insert into NM_MRG_NIT_DERIVATION
   (NMND_NIT_INV_TYPE, NMND_NMQ_ID, NMND_LAST_REFRESH_DATE, NMND_REFRESH_INTERVAL_DAYS, NMND_LAST_REBUILD_DATE, 
    NMND_REBUILD_INTERVAL_DAYS, NMND_MAINTAIN_HISTORY, NMND_NMU_ID_ADMIN, NMND_WHERE_CLAUSE, NMND_DATE_CREATED, 
    NMND_DATE_MODIFIED, NMND_MODIFIED_BY, NMND_CREATED_BY, nmnd_nt_type, NMND_NGT_GROUP_TYPE)
 Values
   ('OPBD', 
   (select nmq_id from nm_mrg_query
   where nmq_unique = 'TYPEOP_BD'),
   SYSDATE, 7, to_date(SYSDATE), 
    1, 'N', 2058, null, to_date(SYSDATE), 
    to_date(SYSDATE), 'EXOR', 'EXOR', 'RT', 'RT');

insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OPBD', 'IIT_CHR_ATTRIB26', 1, 'MRG.BD_TYPE_OF_OPERATION');

INSERT INTO NM_MRG_NIT_DERIVATION_NW (
NMNDN_NMND_NIT_INV_TYPE, NMNDN_NT_TYPE, NMNDN_DATE_CREATED, NMNDN_DATE_MODIFIED, NMNDN_MODIFIED_BY, NMNDN_CREATED_BY)
VALUES
  ('OPBD', 'RT', TO_DATE(sysdate), TO_DATE(sysdate), 'EXOR', 'EXOR');

COMMIT;





