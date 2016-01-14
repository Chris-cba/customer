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
	
	P_REC_OLD V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE;
	
	s_module varchar2(30) := upper('xcsvload_inv_vip');
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);

PROCEDURE LOAD_ON_ELEMENT (P_REC X_V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE) IS
	
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
   

	
	if instr(p_rec.ROUTE_DIR, '+') = 0 then   -- process items with /, nothing or is null
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => FALSE
								);
	elsif instr(p_rec.ROUTE_DIR, '+') <>0 then
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => FALSE
								);
		
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),-1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => FALSE
								);
	end if;
	
   NM_DEBUG.PROC_END(G_PACKAGE_NAME,'load_on_element');

END LOAD_ON_ELEMENT;



PROCEDURE VALIDATE_ON_ELEMENT (P_REC X_V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE) IS
BEGIN

   NM_DEBUG.PROC_START(G_PACKAGE_NAME,'validate_on_element');

	if instr(p_rec.ROUTE_DIR, '+') = 0 then   -- process items with /, nothing or is null
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' || substr(trim(p_rec.route_dir),1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => TRUE
								);
	elsif instr(p_rec.ROUTE_DIR, '+') <>0 then
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' ||  substr(trim(p_rec.route_dir),1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => TRUE
								);
		
		p_rec_old.NE_UNIQUE			:= trim(p_rec.road_unique) || trim(p_rec.route_suffix) || '-' || substr(trim(p_rec.route_dir),-1,1);
		p_rec_old.NE_NT_TYPE		:= p_rec.NE_NT_TYPE;
		p_rec_old.BEGIN_MP			:= p_rec.BEGIN_MP;
		p_rec_old.END_MP			:= p_rec.END_MP;
		p_rec_old.IIT_NE_ID			:= p_rec.IIT_NE_ID;
		p_rec_old.IIT_INV_TYPE		:= p_rec.IIT_INV_TYPE;
		p_rec_old.NM_START_DATE		:= p_rec.NM_START_DATE;
		
		LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old
								,P_VALIDATE_ONLY => TRUE
								);
	end if;

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








END xcsvload_inv_vip;