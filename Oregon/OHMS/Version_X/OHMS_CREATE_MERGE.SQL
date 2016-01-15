declare


l_merge_id number;






begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY_ALL where NMQ_UNIQUE = 'OHMS_EXTRACT';
    
    delete from  NM_MRG_QUERY_ALL where NMQ_ID = l_merge_id;
    
    exception
    when others then null;
    
    end;
    
    commit;  

    select NMQ_ID_SEQ.nextval into l_merge_id from dual;
    
    Insert into NM_MRG_QUERY_ALL
       (NMQ_ID, NMQ_UNIQUE, NMQ_DESCR, NMQ_INNER_OUTER_JOIN, NMQ_INV_TYPE_X_SECT_COUNT, NMQ_TRANSIENT_QUERY)
    select 
       l_merge_id
       , 'OHMS_EXTRACT'
       , 'OHMS Extract'
       , 'O'
       , 0
       , 'N' from dual;

     commit;

       Insert into NM_MRG_QUERY_ROLES
           (NQRO_NMQ_ID, NQRO_ROLE, NQRO_MODE)
               select
            l_merge_id
           , 'TI_APPROLE_OHMS_USER'
           , 'NORMAL'
           from dual;

        commit;

        -- NM_MRG_QUERY_TYPES_ALL - asset types 

        Insert into NM_MRG_QUERY_TYPES_ALL
           (NQT_NMQ_ID, NQT_SEQ_NO, NQT_INV_TYPE, NQT_DEFAULT)
           select 
               l_merge_id
           , NQT_SEQ_NO_SEQ.nextval
           , nit_inv_type
           , 'N'
        from
        nm_inv_types where nit_inv_type in 
       (
        'FFC',
        'URBN',
        'FACL',
        'RDGM',
        'TRAF',
        'HPPV',
        'CNTY',
        'SPZN',
        'TERR',
        'SCS',
        'OFRG',
        'SCNS'
        );
    commit;

        -- NM_MRG_QUERY_ATTRIBS asset attributes

         
      -- CNTY 
       
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'CNTY'
        and ITA_VIEW_ATTRI in
            ('COUNTY_ID' );
            
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'URBN'
        and ITA_VIEW_ATTRI in
            ('URBAN_AREA' );
     
     
     INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
       select   NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'FFC'
        and ITA_VIEW_ATTRI in
            ('FC_CD' );
            
            
       INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
          select   NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'FACL'   
        and ITA_VIEW_ATTRI in
            ('TYP_CD' );
            
       INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
       select   NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'TRAF'  
        and ITA_VIEW_ATTRI in
            ('AADT_CNT',
            'AADT_YR'
             );
             
      --  dbms_output.put_line ('RDGM');
        
            
                 
     -- RDGM 
       
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
       
      select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
      -- and NQT_NMQ_ID = 
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'RDGM'
            and ITA_VIEW_ATTRI in
            ('WD_MEAS',
            'LAYER'
               );
             
           --  dbms_output.put_line ('SPZN');
               
                INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
              select   NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SPZN'  
        and ITA_VIEW_ATTRI in
            ('SPEED_DESIG'  );
            
 --dbms_output.put_line ('TERR');
            
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
          select   NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'TERR' 
        and ITA_VIEW_ATTRI in
            ('TYP_CD'  );

            
         INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
             select
           NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SCS' 
        and ITA_VIEW_ATTRI in
            ('CLASSFN_NO');
            
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select --ITA_VIEW_ATTRI,
              NQT_NMQ_ID 
            , NQT_SEQ_NO
         --   , ita_attrib_name
            , 'IIT_PRIMARY_KEY'
        from -- nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where  --ita_inv_tye(+) = NQT_INV_TYPE and
         NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and NQT_INV_TYPE = 'OFRG' ;
     
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select
           NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
      --  , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SCNS' 
        and ITA_VIEW_ATTRI in
            ('HWY_EA_NO');
            
            
            INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
            select
           NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
       -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
       and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'HPPV' 
        and ITA_VIEW_ATTRI in
            ('SECT_ID', 'DATA_YR');

            
            update NM_MRG_QUERY_ATTRIBS 
            set nqa_condition = '='
            where NQA_NMQ_ID = l_merge_id
            and nqa_nqt_seq_no = (            
                         select NQT_SEQ_NO from NM_MRG_QUERY_TYPES
                         where NQT_NMQ_ID = l_merge_id
                          and NQT_INV_TYPE = 'RDGM')
            and nqa_attrib_name = 'IIT_NO_OF_UNITS';
            
            update NM_MRG_QUERY_ATTRIBS 
            set nqa_condition = '='
            where NQA_NMQ_ID = l_merge_id
            and nqa_nqt_seq_no = (            
                         select NQT_SEQ_NO from NM_MRG_QUERY_TYPES
                         where NQT_NMQ_ID = l_merge_id
                          and NQT_INV_TYPE = 'TRAF')
            and nqa_attrib_name = 'IIT_POWER';
            
              update NM_MRG_QUERY_ATTRIBS 
            set nqa_condition = '='
            where NQA_NMQ_ID = l_merge_id
            and nqa_nqt_seq_no = (            
                         select NQT_SEQ_NO from NM_MRG_QUERY_TYPES
                         where NQT_NMQ_ID = l_merge_id
                          and NQT_INV_TYPE = 'HPPV')
            and nqa_attrib_name = 'IIT_POWER';
         
              -- NM_MRG_QUERY_VALUES attribute values.
            
            insert into nm_mrg_query_values 
                (NQV_NMQ_ID, NQV_NQT_SEQ_NO, NQV_ATTRIB_NAME, NQV_SEQUENCE, NQV_VALUE   )
         select l_merge_id
                , NQA_NQT_SEQ_NO
                , NQA_ATTRIB_NAME
                , 1
                , 1   
             from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
            where NQT_INV_TYPE = 'RDGM'
            and NQT_NMQ_ID =  l_merge_id
            and NQT_SEQ_NO = NQA_NQT_SEQ_NO
            and NQA_CONDITION is not null;
            
            insert into nm_mrg_query_values 
                (NQV_NMQ_ID, NQV_NQT_SEQ_NO, NQV_ATTRIB_NAME, NQV_SEQUENCE, NQV_VALUE   )
        
         select   l_merge_id , 
                  NQA_NQT_SEQ_NO
                , NQA_ATTRIB_NAME
                , 1
                , (select max(AADT_YR) from v_nm_traf)
             from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
            where NQT_INV_TYPE = 'TRAF'
            and NQT_NMQ_ID =  l_merge_id
            and NQT_SEQ_NO = NQA_NQT_SEQ_NO
            and NQA_CONDITION is not null;
            
            
             insert into nm_mrg_query_values 
                (NQV_NMQ_ID, NQV_NQT_SEQ_NO, NQV_ATTRIB_NAME, NQV_SEQUENCE, NQV_VALUE   )
         select   l_merge_id , 
                  NQA_NQT_SEQ_NO
                , NQA_ATTRIB_NAME
                , 1
                , (select max(DATA_YR) from v_nm_HPPV)
             from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
            where NQT_INV_TYPE = 'HPPV'
            and NQT_NMQ_ID =  l_merge_id
            and NQT_SEQ_NO = NQA_NQT_SEQ_NO
            and NQA_CONDITION is not null;

        -- build the merge views so that the building of the derived asset works:
        commit;
        
      NM3MRG_VIEW.build_view(l_merge_ID);
            
end;
/



