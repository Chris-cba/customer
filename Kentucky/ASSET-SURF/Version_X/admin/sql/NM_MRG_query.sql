

declare


l_merge_id number;


begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY where NMQ_UNIQUE = 'MQ_SURF';
    
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
       , 'MQ_SURF'
       , 'MQ_SURF'
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
        nm_inv_types where nit_inv_type = 'PM' 	;
			 
		 
		 Insert into NM_MRG_QUERY_TYPES
           (NQT_NMQ_ID, NQT_SEQ_NO, NQT_INV_TYPE, NQT_DEFAULT)
           select 
               l_merge_id
           , NQT_SEQ_NO_SEQ.nextval
           , nit_inv_type
           , 'N'
        from
        nm_inv_types where nit_inv_type = 'BD' 	;	 

		commit;
		
           		   
        -- NM_MRG_QUERY_ATTRIBS asset attributes

		
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME) 
        select l_merge_id 
             , (select NQT_SEQ_NO from  NM_MRG_QUERY_TYPES where 1=1 and NQT_INV_TYPE= 'PM' and  NQT_NMQ_ID = l_merge_id)
             , 'IIT_ADMIN_UNIT' from dual;
      
             INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME) 
        select NQT_NMQ_ID 
             , NQT_SEQ_NO
             , ita_attrib_name
      -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        -- and NQT_NMQ_ID = 39
        and NQT_NMQ_ID = l_merge_id
        AND ITA_scrn_text = 'PM Pavement Type'
		and NQT_INV_TYPE= 'PM'
       ;
     
	         INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME) 
        select NQT_NMQ_ID 
             , NQT_SEQ_NO
             , ita_attrib_name
      -- , nvl(ITA_VIEW_ATTRI,'IIT_PRIMARY_KEY')
            from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        -- and NQT_NMQ_ID = 39
        and NQT_NMQ_ID = l_merge_id
        AND ITA_scrn_text = 'Admin Unit'
		and NQT_INV_TYPE = 'BD'
       ;
        -- build the merge views so that the building of the derived asset works:
        commit;
     
      NM3MRG_VIEW.build_view(l_merge_ID);
END;
/