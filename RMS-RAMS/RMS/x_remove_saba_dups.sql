Create or replace procedure x_remove_saba_dups as


    loopnum NUMBER;
BEGIN
    
    select to_number(max(cnt)) into loopnum
        from (select max(iit_ne_id), count(*) cnt  from v_nm_saba_nw
        where 
        iit_inv_type = 'SABA'
        and trunc(iit_date_created) in ('23/DEC/2009', '24/DEC/2009')
        group by IIT_DESCR, IIT_NOTE, IIT_PEO_INVENT_BY_ID, NAU_UNIT_CODE, IIT_END_DATE, BARRIER_TYPE, START_TERMINAL, END_TERMINAL, PURPOSE, SIDE, COMMENTS, NE_ID_OF, MEMBER_UNIQUE, NM_BEGIN_MP, NM_END_MP, NM_SEQ_NO, NM_START_DATE, NM_END_DATE, NM_SLK, NM_SEG_NO, NM_CARDINALITY, NM_ADMIN_UNIT
        having count(*) > 1
        )
        ;
        
        if loopnum > 1 then 
            
            for i in 1 .. loopnum LOOP
            
                delete from nm_members_all where nm_ne_id_in in (
                        select max(iit_ne_id) from v_nm_saba_nw
                        where 
                        iit_inv_type = 'SABA'
                        and trunc(iit_date_created) in ('23/DEC/2009', '24/DEC/2009')
                        group by IIT_DESCR, IIT_NOTE, IIT_PEO_INVENT_BY_ID, NAU_UNIT_CODE, IIT_END_DATE, BARRIER_TYPE, START_TERMINAL, END_TERMINAL, PURPOSE, SIDE, COMMENTS, NE_ID_OF, MEMBER_UNIQUE, NM_BEGIN_MP, NM_END_MP, NM_SEQ_NO, NM_START_DATE, NM_END_DATE, NM_SLK, NM_SEG_NO, NM_CARDINALITY, NM_ADMIN_UNIT
                        having count(*) > 1
                                                               );
            END LOOP; 
                                                        
            for i in 1 .. loopnum LOOP
			
                delete from nm_inv_items_all where iit_ne_id in (
                        select max(iit_ne_id) from v_nm_saba_nw
                        where 
                        iit_inv_type = 'SABA'
                        and trunc(iit_date_created) in ('23/DEC/2009', '24/DEC/2009')
                        group by IIT_DESCR, IIT_NOTE, IIT_PEO_INVENT_BY_ID, NAU_UNIT_CODE, IIT_END_DATE, BARRIER_TYPE, START_TERMINAL, END_TERMINAL, PURPOSE, SIDE, COMMENTS, NE_ID_OF, MEMBER_UNIQUE, NM_BEGIN_MP, NM_END_MP, NM_SEQ_NO, NM_START_DATE, NM_END_DATE, NM_SLK, NM_SEG_NO, NM_CARDINALITY, NM_ADMIN_UNIT
                        having count(*) > 1
                                                                );
                                                                

            END LOOP;
        END IF;
END;
\