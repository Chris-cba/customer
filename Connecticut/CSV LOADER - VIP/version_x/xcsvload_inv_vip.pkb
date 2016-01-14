CREATE OR REPLACE PACKAGE BODY xcsvload_inv_vip IS
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
	
	--type  typ_p_rec_old is table of V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE;  -- now in header
	
	
	p_rec_old_tbl typ_p_rec_old;
	p_rec_tbl typ_p_rec_old;
	
	s_module varchar2(30) := upper('xcsvload_inv_vip');
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);

PROCEDURE LOAD_ON_ELEMENT (P_REC X_V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE) IS
	
	function has_reverse(s_ne_number varchar2, n_slk number, n_end_slk number, s_obj_type varchar2) return boolean is
		b_return_val boolean := false;
		n_temp number := 0;
		begin
			select count(*) into n_temp from 
				nm_members ,nm_elements
				 where 1=1 
				 and ne_id = nm_ne_id_in
				 and nm_type = 'G' 	 and nm_obj_type = s_obj_type and ne_nt_type = s_obj_type and ne_name_1 = 'R'
				 and ne_number = substr( '000' || trim(s_ne_number),-3)
				 and  (nm_slk) >= n_slk
				 and nm_end_slk <= n_end_slk;
			
			if n_temp >0 then b_return_val := true; end if; 
				
			return b_return_val;
	end has_reverse;
	
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
   
	p_rec_old_tbl := typ_p_rec_old();
	
	p_rec_old_tbl.extend(1);
	
	if instr(p_rec.ROUTE_DIR, '+') = 0 then   -- process items with /, nothing or is null
		p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old_tbl
								,P_VALIDATE_ONLY => FALSE
								);
	elsif instr(p_rec.ROUTE_DIR, '+') <>0 then
		p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
		
		/*
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => FALSE
								);
		*/
								
		if has_reverse(trim(p_rec.road_unique),p_rec.BEGIN_MP,p_rec.END_MP,p_rec.NE_NT_TYPE)  = true then 
			p_rec_old_tbl.extend(1);
			
			p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),-1,1);
			p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
			p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
			
		end if;
		
					LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old_tbl
									,P_VALIDATE_ONLY => FALSE
									);
		
	end if;
	
   NM_DEBUG.PROC_END(G_PACKAGE_NAME,'load_on_element');

END LOAD_ON_ELEMENT;



PROCEDURE VALIDATE_ON_ELEMENT (P_REC X_V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE) IS

	function has_reverse(s_ne_number varchar2, n_slk number, n_end_slk number, s_obj_type varchar2) return boolean is
		b_return_val boolean := false;
		n_temp number := 0;
		begin
			select count(*) into n_temp from 
				nm_members ,nm_elements
				 where 1=1 
				 and ne_id = nm_ne_id_in
				 and nm_type = 'G' 	 and nm_obj_type = s_obj_type and ne_nt_type = s_obj_type and ne_name_1 = 'R'
				 and ne_number = substr( '000' || trim(s_ne_number),-3)
				 and  (nm_slk) >= n_slk
				 and nm_end_slk <= n_end_slk;
			
			if n_temp >0 then b_return_val := true; end if; 
				
			return b_return_val;
	end has_reverse;
BEGIN

   NM_DEBUG.PROC_START(G_PACKAGE_NAME,'validate_on_element');

	p_rec_old_tbl := typ_p_rec_old();
	
	p_rec_old_tbl.extend(1);
	
	if instr(nvl(p_rec.ROUTE_DIR,0), '+') = 0 then   -- process items with /, nothing or is null
		p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old_tbl
								,P_VALIDATE_ONLY => TRUE
								);
	elsif instr(p_rec.ROUTE_DIR, '+') <>0 then
		p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
		
		/*
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => FALSE
								);
		*/
								
		if has_reverse(trim(p_rec.road_unique),p_rec.BEGIN_MP,p_rec.END_MP,p_rec.NE_NT_TYPE)  = true then 
			p_rec_old_tbl.extend(1);
			
			p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),-1,1);
			p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP			:= p_rec.BEGIN_MP;
			p_rec_old_tbl(p_rec_old_tbl.count).END_MP			:= p_rec.END_MP;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_rec.IIT_NE_ID;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_rec.NM_START_DATE;
			

		end if;
		
					LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old_tbl
									,P_VALIDATE_ONLY => TRUE
									);
		
	end if;

   NM_DEBUG.PROC_END(G_PACKAGE_NAME,'validate_on_element');

END VALIDATE_ON_ELEMENT;



PROCEDURE LOAD_OR_VAL_ON_ELEMENT (P_REC           typ_p_rec_old
                                 ,P_VALIDATE_ONLY BOOLEAN
                                 ) IS

   C_INIT_EFFECTIVE_DATE CONSTANT DATE := TO_DATE(SYS_CONTEXT('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   
   L_REC_NE       NM_ELEMENTS%ROWTYPE;

   NOTHING_TO_DO  EXCEPTION;

   L_BEGIN_MP     NUMBER;
   L_END_MP       NUMBER;
   L_NTE_JOB_ID   NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE;
	L_NTE_JOB_ID_2   NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE;
   C_END_MP  NUMBER ;

BEGIN
/* 
	I am assuming 2 rows in the p_rec table, with only different extents
*/


   SAVEPOINT TOP_OF_LOAD;

   IF  P_REC(p_rec.first).NE_UNIQUE IS NULL
    THEN
      RAISE NOTHING_TO_DO;
   END IF;

	for xx in p_rec.first .. p_rec.last loop
	   
	   
			   
				C_END_MP   := NVL(P_REC(xx).END_MP,P_REC(xx).BEGIN_MP);
			   L_REC_NE := NM3GET.GET_NE (PI_NE_ID  => NM3NET.GET_NE_ID (P_REC(xx).NE_UNIQUE,p_rec(xx).NE_NT_TYPE));

			   
			   IF   NVL(P_REC(xx).BEGIN_MP,0)            = 0
				AND NVL(C_END_MP,L_REC_NE.NE_LENGTH) = L_REC_NE.NE_LENGTH
				THEN
				  L_BEGIN_MP := NULL;
				  L_END_MP   := NULL;
			   ELSE
				  L_BEGIN_MP := P_REC(xx).BEGIN_MP;
				  L_END_MP   := C_END_MP;
			   END IF;
				
				if xx = p_rec.first then 
				   NM3EXTENT.CREATE_TEMP_NE (PI_SOURCE_ID => L_REC_NE.NE_ID
							,PI_SOURCE    => NM3EXTENT.C_ROUTE
							,PI_BEGIN_MP  => L_BEGIN_MP
							,PI_END_MP    => L_END_MP
							,PO_JOB_ID    => L_NTE_JOB_ID
							);
					NM3EXTENT.REMOVE_DB_FROM_TEMP_NE (L_NTE_JOB_ID);
				else  -- lets add it to the first one
				   NM3EXTENT.CREATE_TEMP_NE (PI_SOURCE_ID => L_REC_NE.NE_ID
											,PI_SOURCE    => NM3EXTENT.C_ROUTE
											,PI_BEGIN_MP  => L_BEGIN_MP
											,PI_END_MP    => L_END_MP
											,PO_JOB_ID    => L_NTE_JOB_ID_2
											);
					NM3EXTENT.REMOVE_DB_FROM_TEMP_NE (L_NTE_JOB_ID_2);
					
					Nm3extent.combine_temp_nes(pi_job_id_1       => L_NTE_JOB_ID
					  ,pi_job_id_2       => L_NTE_JOB_ID_2
					  ,pi_check_overlaps => FALSE);  --homo will check for overlaps
				end if;
	end loop;
   
	NM3HOMO.HISTORIC_LOCATE_INIT(PI_EFFECTIVE_DATE => P_REC(p_rec.first).NM_START_DATE);
	
   NM3HOMO.CHECK_TEMP_NE_FOR_PNT_OR_CONT (PI_NTE_JOB_ID  => L_NTE_JOB_ID
                                         ,PI_PNT_OR_CONT => NM3GET.GET_NIT(PI_NIT_INV_TYPE=>P_REC(p_rec.first).IIT_INV_TYPE).NIT_PNT_OR_CONT
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
                          ,P_IIT_NE_ID      => P_REC(p_rec.first).IIT_NE_ID
                          ,P_EFFECTIVE_DATE => P_REC(p_rec.first).NM_START_DATE
                          );
	
	commit;
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








END xcsvload_inv_vip;