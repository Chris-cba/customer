--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/Bike_Ped/Bike_Ped_Object/Version_X/Admin/Sql/bike_ped_mrg_metadata.sql-arc   1.0   Jan 15 2016 16:39:20   Sarah.Williams  $
--       Module Name      : $Workfile:   bike_ped_mrg_metadata.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 16:39:20  $
--       Date fetched Out : $Modtime:   Oct 21 2010 04:10:44  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- Script to create Bike ped reporting merge query metadata 
DECLARE

l_merge_id number;

BEGIN
    
	BEGIN
    select nmq_id into l_merge_id from NM_MRG_QUERY_ALL where NMQ_UNIQUE = 'BIKE_PED_MRG';
    
    delete from  NM_MRG_QUERY_ALL where NMQ_ID = l_merge_id;
    
    commit; 
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      null;	
    END;
	
    select NMQ_ID_SEQ.nextval into l_merge_id from dual;
    
    Insert into NM_MRG_QUERY_ALL
       (NMQ_ID, NMQ_UNIQUE, NMQ_DESCR, NMQ_INNER_OUTER_JOIN, NMQ_INV_TYPE_X_SECT_COUNT, NMQ_TRANSIENT_QUERY)
    select 
       l_merge_id
       , 'BIKE_PED_MRG'
       , 'Merge Query for Bike PED reporting'
       , 'O'
       , 6
       , 'N' from dual;

     commit;

       Insert into NM_MRG_QUERY_ROLES
           (NQRO_NMQ_ID, NQRO_ROLE, NQRO_MODE)
               select
            l_merge_id
           , 'HIG_USER'
           , 'NORMAL'
           from dual;
		   
		   Insert into NM_MRG_QUERY_ROLES
           (NQRO_NMQ_ID, NQRO_ROLE, NQRO_MODE)
               select
            l_merge_id
           , 'NET_USER'
           , 'NORMAL'
           from dual;

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
       ('BIKE'
	   ,'PARK'
	   ,'CURB'
	   ,'SHUP'
	   ,'SWLK'
	   ,'CITY'
	   ,'URBN'
	   ,'SCNS'
	   ,'SPZN'
        );
        commit;
		
        -- NM_MRG_QUERY_ATTRIBS asset attributes
       
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'BIKE'
            and ITA_VIEW_ATTRI in
            ('TYP_CD',
            'COND_CD',
            'NEED_IND',
            'WD_MEAS',
			'INSP_YR',
			'NOTE');
			
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'PARK'
            and ITA_VIEW_ATTRI in
            ('TYP_CD',
            'COND_CD',
            'WD_MEAS',
			'INSP_YR',
			'SRCE_TYP',
			'NOTE');    		


        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'CURB'
            and ITA_VIEW_ATTRI in
            ('TYP_CD',
            'HT_CD',
            'COND_CD',
			'INSP_YR',
			'SRCE_TYP',
			'NOTE'
			);  

        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SHUP'
            and ITA_VIEW_ATTRI in
            ('SURF_CD',
            'COND_CD',
            'WD_MEAS',
			'INSP_YR');	

        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SWLK'
            and ITA_VIEW_ATTRI in
            ('SURF_CD',
            'COND_CD',
            'WD_MEAS',
			'INSP_YR',
			'BUF_IND',
			'NEED_IND');	
             
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'CITY'
            and ITA_VIEW_ATTRI in
            ('NM');            
            
        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'URBN'
            and ITA_VIEW_ATTRI in
            ('URBAN_AREA'
			,'SMALL_URBAN');    

        INSERT INTO NM_MRG_QUERY_ATTRIBS (NQA_NMQ_ID, NQA_NQT_SEQ_NO, NQA_ATTRIB_NAME)    
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
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
        select     NQT_NMQ_ID 
            , NQT_SEQ_NO
            , ita_attrib_name
        from nm_inv_type_attribs,
        NM_MRG_QUERY_TYPES,
        NM_MRG_QUERY
        where ita_inv_type(+) = NQT_INV_TYPE
        and NQT_NMQ_ID = NMQ_ID
        and NQT_NMQ_ID = l_merge_id
        and ita_inv_type = 'SPZN'
            and ITA_VIEW_ATTRI in
            ('SPEED_DESIG'); 			
 			
              -- NM_MRG_QUERY_VALUES attribute values.
            
               -- None
			   
        
        commit;
        -- build the merge views so that the building of the derived asset works:
      NM3MRG_VIEW.build_view(l_merge_ID);
            
END;
/




		