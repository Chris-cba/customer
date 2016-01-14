CREATE OR REPLACE PACKAGE BODY xcsvload_inv_ploc_bridge IS
--
-----------------------------------------------------------------------------
 /*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file:   xcsvload_inv_vip
	Author: JMM
	UPDATE01:	Original - Modified to allow dual asset from single row, 2014.06.11, JMM
*/
	G_PACKAGE_NAME    				CONSTANT  VARCHAR2(30)   	:= 'xcsvload_inv_vip';
	g_create_temp_ne_on_validate 	BOOLEAN 					:= FALSE;
	g_last_nte_job_id            	NUMBER 						:= -1;
	
	
	b_has_rows boolean;
	P_REC_OLD V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE;
	

	
	cursor c_brdg(s_brdge_id varchar2) is 
		select iit_type, iit_ne_id,IIT_CHR_ATTRIB26, IIT_CHR_ATTRIB27  from nm_inv_items
		where iit_inv_type = 'BRDG'
		and trim(IIT_CHR_ATTRIB26 || nvl(iit_chr_attrib27,'')) = trim(s_brdge_id)		
		;
		
	cursor c_brdg_list(s_bridge_list varchar2) is
		select cast(myrow as varchar2(50)) myrow from   (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_bridge_list col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        );

	cursor c_get_ne_id_slk(n_iit_id number) is
		with g as  
						(SELECT EXTRACT(column_value,'/e/text()') myrow from (select 'BRDG' col1 from dual) x,
						TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
						)
					, c as  
						(SELECT EXTRACT(column_value,'/e/text()') myrow from (select  'RTE,LOCL' col1 from dual) x,
						TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
						)
					,base1 as( -- needed to hint it b/c QO was doing unnecessary TFS
						SELECT /*+ materialize */ 
							mem.nm_ne_id_in         mem_nm_ne_id_in,
							aloc.nm_ne_id_in            aloc_nm_ne_id_in
							,aloc. nm_date_modified aloc_nm_date_modified  
							,aloc.nm_date_created    aloc_nm_date_created 
							, aloc.nm_start_date        aloc_nm_start_date
							, aloc.nm_end_date        aloc_nm_end_date
							, aloc.nm_obj_type          aloc_nm_obj_type
							,iit_x_sect							
							,IIT_CHR_ATTRIB26, IIT_CHR_ATTRIB27
							,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
							,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk
						FROM 
							nm_inv_items i
							,(select * from nm_members where nm_obj_type in (select trim( cast(myrow as varchar2(25))) from g)  ) aloc		
							,(select * from nm_members where  nm_obj_type in (select trim( cast(myrow as varchar2(25))) from c))  mem              
						WHERE 1=1
							and I.IIT_NE_ID = n_iit_id
							and aloc.nm_ne_id_in like  n_iit_id
							AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from c) 		
							AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from g)                     
							AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
							and aloc.nm_ne_id_in = i.iit_ne_id
							and mem.nm_ne_id_in in (select min(nm_ne_id_in) from nm_members where nm_ne_id_of = mem.nm_ne_id_of and nm_obj_type in (select trim( cast(myrow as varchar2(25))) from c))
						)
					,base2 as  
						(select 
							mem_nm_ne_id_in	,aloc_nm_obj_type ,slk	,end_slk
						from base1 
						order by slk
						)
					,base3 as (
						select 
							mem_nm_ne_id_in	,aloc_nm_obj_type	,slk,end_slk
						from base2
						)
					select
						mem_nm_ne_id_in,
						min(slk) slk,
						max(end_slk) end_slk				
					from (
						select a.*
						, Case when (lag (end_slk) over (partition by   mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by  mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
						from (
							select
							mem_nm_ne_id_in,
							slk,
							end_slk
							, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in order by slk)) <> slk then 'Y' else 'N' end DB
							, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in order by slk)) <> slk then slk  else null end DBTSMP							
							from (	select * from base3 )
							) a
						)
					group by mem_nm_ne_id_in , DBSMP
					order by mem_nm_ne_id_in, slk
					;
		
PROCEDURE LOAD_ON_ELEMENT (P_REC x_v_load_ploc_brdg_mem_on_ele%ROWTYPE) IS
	
BEGIN

/*
		NE_UNIQUE		VARCHAR2 (30 Byte)	
		NE_NT_TYPE		VARCHAR2 (4 Byte)	
		BEGIN_MP		NUMBER				
		END_MP			NUMBER				
		IIT_NE_ID		NUMBER				
		IIT_INV_TYPE	VARCHAR2 (4 Byte)	
		NM_START_DATE	DATE				
*/
   NM_DEBUG.PROC_START(G_PACKAGE_NAME,'load_on_element');
	
	for y_row in c_brdg_list(p_rec.BRIDGE_ID) loop
		b_has_rows := false;
		for r_row in c_brdg(y_row.myrow) loop
			b_has_rows := true;
				for t_row in c_get_ne_id_slk(r_row.iit_ne_id) loop
					p_rec_old.NE_UNIQUE			:= nm3net.get_ne_unique(t_row.mem_nm_ne_id_in);
					p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
					p_rec_old.BEGIN_MP			:= t_row.slk;
					p_rec_old.END_MP			:= t_row.end_slk;
					p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
					p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
					p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
			
					LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
											,P_VALIDATE_ONLY => FALSE
											);
				end loop;
		end loop;
	end loop;
	
	if b_has_rows = false then raise_application_error(-20001, 'No BRDG items returned, probable bad bridge number' ); end if;
	
   NM_DEBUG.PROC_END(G_PACKAGE_NAME,'load_on_element');

END LOAD_ON_ELEMENT;



PROCEDURE VALIDATE_ON_ELEMENT (P_REC x_v_load_ploc_brdg_mem_on_ele%ROWTYPE) IS
BEGIN

   NM_DEBUG.PROC_START(G_PACKAGE_NAME,'validate_on_element');

   
	b_has_rows := false;
	for y_row in c_brdg_list(p_rec.BRIDGE_ID) loop
		b_has_rows := false;
		for r_row in c_brdg(y_row.myrow) loop
			b_has_rows := true;
				for t_row in c_get_ne_id_slk(r_row.iit_ne_id) loop
					p_rec_old.NE_UNIQUE			:= nm3net.get_ne_unique(t_row.mem_nm_ne_id_in);
					p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
					p_rec_old.BEGIN_MP			:= t_row.slk;
					p_rec_old.END_MP			:= t_row.end_slk;
					p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
					p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
					p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
			
					LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
											,P_VALIDATE_ONLY => true
											);
				end loop;
		end loop;
	end loop;
	
	if b_has_rows = false then raise_application_error(-20001, 'No BRDG items returned, probable bad bridge number'); end if;
	
   

   NM_DEBUG.PROC_END(G_PACKAGE_NAME,'validate_on_element');

END VALIDATE_ON_ELEMENT;



PROCEDURE LOAD_OR_VAL_ON_ELEMENT (P_REC           V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE
                                 ,P_VALIDATE_ONLY BOOLEAN
                                 ) IS

   C_INIT_EFFECTIVE_DATE CONSTANT DATE := TO_DATE(SYS_CONTEXT('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   
   L_REC_NE       NM_ELEMENTS%ROWTYPE;

   NOTHING_TO_DO  EXCEPTION;

   L_BEGIN_MP     NUMBER;
   L_END_MP       NUMBER;
   L_NTE_JOB_ID   NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE;

   C_END_MP CONSTANT NUMBER := NVL(P_REC.END_MP,P_REC.BEGIN_MP);

BEGIN

   SAVEPOINT TOP_OF_LOAD;

   IF  P_REC.NE_UNIQUE IS NULL
    THEN
      RAISE NOTHING_TO_DO;
   END IF;

   NM3HOMO.HISTORIC_LOCATE_INIT(PI_EFFECTIVE_DATE => P_REC.NM_START_DATE);

   L_REC_NE := NM3GET.GET_NE (PI_NE_ID  => NM3NET.GET_NE_ID (P_REC.NE_UNIQUE,P_REC.NE_NT_TYPE));

   IF   NVL(P_REC.BEGIN_MP,0)            = 0
    AND NVL(C_END_MP,L_REC_NE.NE_LENGTH) = L_REC_NE.NE_LENGTH
    THEN
      L_BEGIN_MP := NULL;
      L_END_MP   := NULL;
   ELSE
      L_BEGIN_MP := P_REC.BEGIN_MP;
      L_END_MP   := C_END_MP;
   END IF;

   NM3EXTENT.CREATE_TEMP_NE (PI_SOURCE_ID => L_REC_NE.NE_ID
                            ,PI_SOURCE    => NM3EXTENT.C_ROUTE
                            ,PI_BEGIN_MP  => L_BEGIN_MP
                            ,PI_END_MP    => L_END_MP
                            ,PO_JOB_ID    => L_NTE_JOB_ID
                            );

   NM3EXTENT.REMOVE_DB_FROM_TEMP_NE (L_NTE_JOB_ID);

   NM3HOMO.CHECK_TEMP_NE_FOR_PNT_OR_CONT (PI_NTE_JOB_ID  => L_NTE_JOB_ID
                                         ,PI_PNT_OR_CONT => NM3GET.GET_NIT (PI_NIT_INV_TYPE=>P_REC.IIT_INV_TYPE).NIT_PNT_OR_CONT
                                         );

   NM3HOMO.HISTORIC_LOCATE_VALIDATION(PI_NTE_JOB_ID   => L_NTE_JOB_ID
                                     ,PI_USER_NE_ID   => L_REC_NE.NE_ID
                                     ,PI_USER_NE_TYPE => L_REC_NE.NE_TYPE);
   
   IF P_VALIDATE_ONLY
    THEN
      IF NOT G_CREATE_TEMP_NE_ON_VALIDATE
       THEN
         ROLLBACK TO TOP_OF_LOAD;
         G_LAST_NTE_JOB_ID := -1;
      END IF;
   ELSE
      NM3HOMO.HOMO_UPDATE (P_TEMP_NE_ID_IN  => L_NTE_JOB_ID
                          ,P_IIT_NE_ID      => P_REC.IIT_NE_ID
                          ,P_EFFECTIVE_DATE => P_REC.NM_START_DATE
                          );
   END IF;

   G_LAST_NTE_JOB_ID := L_NTE_JOB_ID;
   
   NM3HOMO.HISTORIC_LOCATE_POST(PI_INIT_EFFECTIVE_DATE => C_INIT_EFFECTIVE_DATE);

EXCEPTION

   WHEN NOTHING_TO_DO
    THEN
      NULL;

   WHEN OTHERS
    THEN
      ROLLBACK TO TOP_OF_LOAD;
      NM3HOMO.HISTORIC_LOCATE_POST(PI_INIT_EFFECTIVE_DATE => C_INIT_EFFECTIVE_DATE);
      RAISE;

END LOAD_OR_VAL_ON_ELEMENT;








END xcsvload_inv_ploc_bridge;