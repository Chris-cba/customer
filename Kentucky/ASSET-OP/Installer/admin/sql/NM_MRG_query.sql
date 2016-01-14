

declare


l_merge_id number;


begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY where NMQ_UNIQUE = 'TYPEOP';
    
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
       , 'TYPEOP'
       , 'TYPEOP'
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