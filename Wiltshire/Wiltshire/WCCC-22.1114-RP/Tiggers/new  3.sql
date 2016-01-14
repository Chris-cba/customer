PACKAGE BODY mai_cim_automation
AS
















  
  
  
  
  G_BODY_SCCSID  CONSTANT VARCHAR2(2000) := '$Revision:   1.0  $';

  G_PACKAGE_NAME CONSTANT VARCHAR2(30) := 'mai_cim_automation';
  L_FAILED       VARCHAR2(1) ;
  L_FOUND        VARCHAR2(1);



FUNCTION GET_VERSION RETURN VARCHAR2 IS
BEGIN
   RETURN G_SCCSID;
END GET_VERSION;



FUNCTION GET_BODY_VERSION RETURN VARCHAR2 IS
BEGIN
   RETURN G_BODY_SCCSID;
END GET_BODY_VERSION;


PROCEDURE RUN_BATCH(PI_BATCH_TYPE VARCHAR2)
IS

   L_FILE_NAME  VARCHAR2(100);
   L_CONTINUE_REC    HIG_FTP_CONNECTIONS%ROWTYPE;
   L_CONN       UTL_TCP.CONNECTION;
   L_ARC_CONN   UTL_TCP.CONNECTION;
   L_CNT        NUMBER;
   L_FILE_TAB   NM3FTP.T_STRING_TABLE ;
   L_FLIST      NM3FILE.FILE_LIST;
   L_TMP        VARCHAR2(100);
   L_PATH       VARCHAR2(100) ; 
   L_ERROR      VARCHAR2(32767);
   L_ER_ERROR   INTERFACE_ERRONEOUS_RECORDS.IER_ERROR%TYPE;
   L_IH_ID      INTERFACE_HEADERS.IH_ID%TYPE;   
   L_ERR_NO     INTEGER;
   L_PROCESS_ID NUMBER := HIG_PROCESS_API.GET_CURRENT_PROCESS_ID;   
   L_MSG        VARCHAR2(500) ;
   L_IH_REC     INTERFACE_HEADERS%ROWTYPE ;
   L_WOR_COUNT  NUMBER ;
   L_CONTINUE   BOOLEAN ;
   L_HPAL_REC   HIG_PROCESS_ALERT_LOG%ROWTYPE;
   L_HP_REC     HIG_PROCESSES%ROWTYPE;   
   CURSOR C_GET_DIR_PATH
   IS
   SELECT HDIR_PATH 
   FROM   HIG_DIRECTORIES
   WHERE  HDIR_NAME = 'CIM_DIR';  
   CURSOR C_CON_DETAILS(QP_CONTRACTOR_ID VARCHAR2)
   IS
   SELECT OUN_ORG_ID
         ,OUN_NAME
         ,CON_CODE
         ,CON_NAME
         ,OUN_CONTRACTOR_ID
         ,NAU_UNIT_CODE
         ,NAU_ADMIN_UNIT
         ,CON_ID
   FROM  ORG_UNITS 
        ,CONTRACTS
        ,NM_ADMIN_UNITS 
   WHERE OUN_CONTRACTOR_ID = QP_CONTRACTOR_ID
   AND   OUN_ORG_ID        = CON_CONTR_ORG_ID 
   AND   CON_ADMIN_ORG_ID = NAU_ADMIN_UNIT;
   L_CON_DETAILS_REC C_CON_DETAILS%ROWTYPE;   
   CURSOR C_GET_IH (QP_IH_ID INTERFACE_HEADERS.IH_ID%TYPE)
   IS
   SELECT * 
   FROM   INTERFACE_HEADERS
   WHERE  IH_ID = QP_IH_ID ;
   PROCEDURE RUN_COMP_FILE(PI_CONTRACTOR_ID VARCHAR2
                          ,PI_FILE_NAME     VARCHAR2)
   IS   
   
      L_IH_ID     INTERFACE_HEADERS.IH_ID%TYPE;
      L_ERROR     VARCHAR2(32767);
      L_ER_ERROR  INTERFACE_ERRONEOUS_RECORDS.IER_ERROR%TYPE;
   
   BEGIN
   
      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                            ,PI_MESSAGE    => 'Loading File '||PI_FILE_NAME);
      OPEN  C_CON_DETAILS(PI_CONTRACTOR_ID) ;
      FETCH C_CON_DETAILS INTO L_CON_DETAILS_REC;
      CLOSE C_CON_DETAILS ;
      INTERFACES.COMPLETION_FILE_PH1(PI_CONTRACTOR_ID
                                    ,NULL
                                    ,NULL
                                    ,PI_FILE_NAME
                                    ,L_ERROR); 
      IF SYS_CONTEXT('NM3SQL','CIM_IH_ID') IS NOT NULL
      THEN
          L_IH_ID := SYS_CONTEXT('NM3SQL','CIM_IH_ID') ;
          INTERFACES.AUTO_LOAD_FILE(L_IH_ID
                                   ,NULL
                                   ,L_ER_ERROR);
          HIG_PROCESS_API.SET_PROCESS_INTERNAL_REFERENCE(PI_INTERNAL_REFERENCE => L_IH_ID);
          OPEN  C_GET_IH(L_IH_ID);
          FETCH C_GET_IH INTO L_IH_REC ;
          CLOSE C_GET_IH ;
          SELECT COUNT(0) INTO L_WOR_COUNT
          FROM INTERFACE_COMPLETIONS_ALL WHERE IC_IH_ID = L_IH_ID ;
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                ,PI_MESSAGE      => 'Total Work Orders Processed : '||L_WOR_COUNT
                                ,PI_SUMMARY_FLAG => 'Y' );
          SELECT COUNT(0) INTO L_WOR_COUNT
          FROM INTERFACE_COMPLETIONS WHERE IC_IH_ID = L_IH_ID ;
          IF NVL(L_WOR_COUNT,0) > 0
          THEN 
              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                    ,PI_MESSAGE      => 'Total Work Orders Rejected :'||L_WOR_COUNT
                                    ,PI_MESSAGE_TYPE => 'E'
                                    ,PI_SUMMARY_FLAG => 'Y' );
          END IF ;
          FOR I IN (SELECT * FROM INTERFACE_COMPLETIONS WHERE IC_IH_ID = L_IH_ID )
          LOOP
              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                    ,PI_MESSAGE      => I.IC_WORKS_ORDER_NO||' : '||I.IC_ERROR
                                    ,PI_MESSAGE_TYPE => 'E'
                                    ,PI_SUMMARY_FLAG => 'N' );
          END LOOP;
          IF  L_IH_REC.IH_STATUS IS NULL
          THEN
              L_MSG := 'Loading file '||PI_FILE_NAME||' : Completed Successfully';
          ELSE
              L_MSG := 'Loading file '||PI_FILE_NAME||' failed '|| L_IH_REC.IH_ERROR;
              L_FAILED := 'Y' ;
          END IF ;
      ELSE    
          L_MSG :=     'Error while loading file '||PI_FILE_NAME;
          L_FAILED := 'Y' ;
      END IF ;      
      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                            ,PI_MESSAGE      => L_MSG
                            ,PI_SUMMARY_FLAG => 'Y' );
      NM3FILE.MOVE_FILE(PI_FILE_NAME,'CIM_DIR',PI_FILE_NAME,'CIM_ARC',NULL,TRUE,L_ERR_NO,L_ERROR);
      IF L_ERROR IS NOT NULL
      THEN
          L_FAILED    := 'Y' ;
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                ,PI_MESSAGE      => 'Following error occurred while archiving the WC file '||PI_FILE_NAME||' '||L_ERROR
                                ,PI_MESSAGE_TYPE => 'E'
                                ,PI_SUMMARY_FLAG => 'Y' );                                     
      ELSE
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                ,PI_MESSAGE    => 'WC file '||PI_FILE_NAME||' archived on the Database server');
      END IF ;

   
   END RUN_COMP_FILE;
   
   PROCEDURE RUN_CLAIM_FILE(PI_CONTRACTOR_ID VARCHAR2
                           ,PI_FILE_NAME     VARCHAR2)
   IS
   
      CURSOR C_COL_CLAIM_VAL (P_WOL_ID INTERFACE_CLAIMS_WOL_ALL.ICWOL_WOL_ID%TYPE,
                              P_IH_ID INTERFACE_CLAIMS_WOR_ALL.ICWOR_IH_ID%TYPE) 
      IS
      SELECT ICWOL_CLAIM_VALUE  
      FROM   INTERFACE_CLAIMS_WOL_ALL
      WHERE  ICWOL_WOL_ID = P_WOL_ID
        AND  ICWOL_IH_ID = P_IH_ID;
        
      LV_WOL_ACT             WORK_ORDER_LINES.WOL_ACT_COST%TYPE;
      LV_ICWOL_CLAIM_VALUE   INTERFACE_CLAIMS_WOR_ALL.ICWOR_WORKS_ORDER_NO%TYPE;
      L_ERROR                VARCHAR2(32767);
      L_FD_FILE              VARCHAR2(200) ;   
   
   BEGIN
   

      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                            ,PI_MESSAGE    => 'Loading File '||PI_FILE_NAME); 
      INTERFACES.CLAIM_FILE_PH1(PI_CONTRACTOR_ID
                               ,NULL
                               ,NULL
                               ,PI_FILE_NAME
                               ,L_ERROR);
      OPEN  C_CON_DETAILS(PI_CONTRACTOR_ID) ;
      FETCH C_CON_DETAILS INTO L_CON_DETAILS_REC;
      CLOSE C_CON_DETAILS ;      
      IF SYS_CONTEXT('NM3SQL','CIM_WI_IH_ID') IS NOT NULL
      THEN
      
          L_IH_ID := SYS_CONTEXT('NM3SQL','CIM_WI_IH_ID') ;
      
          INTERFACES.CLAIM_FILE_PH2(L_IH_ID , L_FD_FILE, L_ERROR);

          HIG_PROCESS_API.SET_PROCESS_INTERNAL_REFERENCE(PI_INTERNAL_REFERENCE => L_IH_ID);
          OPEN  C_GET_IH(L_IH_ID);
          FETCH C_GET_IH INTO L_IH_REC ;
          CLOSE C_GET_IH ;
          SELECT COUNT(0) INTO L_WOR_COUNT
          FROM INTERFACE_CLAIMS_WOR_ALL WHERE ICWOR_IH_ID = L_IH_ID ;
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                ,PI_MESSAGE      => 'Total Work Orders Processed : '||L_WOR_COUNT
                                ,PI_SUMMARY_FLAG => 'Y' );
          SELECT COUNT(0) INTO L_WOR_COUNT
          FROM INTERFACE_CLAIMS_WOR WHERE ICWOR_IH_ID = L_IH_ID ;
          IF NVL(L_WOR_COUNT,0) > 0
          THEN 
              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                    ,PI_MESSAGE      => 'Total Work Orders Rejected :'||L_WOR_COUNT
                                    ,PI_MESSAGE_TYPE => 'E'
                                    ,PI_SUMMARY_FLAG => 'Y' );
          END IF ;
          FOR I IN (SELECT * FROM INTERFACE_CLAIMS_WOR WHERE ICWOR_IH_ID = L_IH_ID )
          LOOP
              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                    ,PI_MESSAGE      => I.ICWOR_WORKS_ORDER_NO||' : '||I.ICWOR_ERROR
                                    ,PI_MESSAGE_TYPE => 'E'
                                    ,PI_SUMMARY_FLAG => 'N' );
          END LOOP;
          IF  L_IH_REC.IH_STATUS IS NULL
          THEN
              L_MSG := 'Loading file '||PI_FILE_NAME||' : Completed Successfully';
          ELSE
              L_MSG := 'Loading file '||PI_FILE_NAME||' failed '|| L_IH_REC.IH_ERROR;
              L_FAILED := 'Y' ;
          END IF ;
      ELSE    
          L_MSG :=     'Error while loading file '||PI_FILE_NAME;
          L_FAILED := 'Y' ;
      END IF ;
      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                            ,PI_MESSAGE      => L_MSG
                            ,PI_SUMMARY_FLAG => 'Y' ); 
      NM3FILE.MOVE_FILE(PI_FILE_NAME,'CIM_DIR',PI_FILE_NAME,'CIM_ARC',NULL,TRUE,L_ERR_NO,L_ERROR);
      IF L_ERROR IS NOT NULL
      THEN
          L_FAILED    := 'Y' ;
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                ,PI_MESSAGE      => 'Following error occurred while archiving the WI file '||PI_FILE_NAME||' '||L_ERROR
                                ,PI_MESSAGE_TYPE => 'E'
                                ,PI_SUMMARY_FLAG => 'Y' );                                     
      ELSE
          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                ,PI_MESSAGE    => 'WI file '||PI_FILE_NAME||' archived on the Database server');
      END IF ;
   
   END RUN_CLAIM_FILE ;

BEGIN

   
   OPEN  C_GET_DIR_PATH;
   FETCH C_GET_DIR_PATH INTO L_PATH;
   CLOSE C_GET_DIR_PATH;
   

   L_HP_REC := HIG_PROCESS_FRAMEWORK.GET_PROCESS(L_PROCESS_ID);
   FOR OUN IN (SELECT *
               FROM   ORG_UNITS
               WHERE  OUN_ELECTRONIC_ORDERS_FLAG = 'Y'
               AND    OUN_ORG_ID                 = NVL(L_HP_REC.HP_AREA_ID,OUN_ORG_ID)
               AND    OUN_CONTRACTOR_ID IS NOT NULL)
   LOOP       
       IF PI_BATCH_TYPE ='WO'
       THEN            
           BEGIN
           
              SELECT COUNT(0)
              INTO   L_CNT
              FROM   INTERFACE_WOR
                    ,CONTRACTS
                    ,ORG_UNITS
              WHERE  IWOR_CON_CODE     = CON_CODE
              AND    IWOR_WO_RUN_NUMBER IS NULL
              AND    CON_CONTR_ORG_ID  = OUN_ORG_ID
              AND    OUN_CONTRACTOR_ID = OUN.OUN_CONTRACTOR_ID ;              
              IF L_CNT > 0
              THEN
                  
                  L_FOUND := 'Y' ;
                  OPEN  C_CON_DETAILS(OUN.OUN_CONTRACTOR_ID) ;
                  FETCH C_CON_DETAILS INTO L_CON_DETAILS_REC;
                  CLOSE C_CON_DETAILS ;
                  BEGIN
                     
                     L_FILE_NAME := INTERFACES.WRITE_WOR_FILE(OUN.OUN_CONTRACTOR_ID,NULL,NULL);
                     IF L_FILE_NAME IS NULL
                     THEN 
                         L_CONTINUE := FALSE;
                         L_FAILED := 'Y' ;
                         HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                               ,PI_MESSAGE      => SYS_CONTEXT('NM3SQL','CIM_ERROR_TEXT')
                                               ,PI_MESSAGE_TYPE => 'E');
                     ELSE                         
                         L_CONTINUE  := TRUE ;
                         HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                               ,PI_MESSAGE    => 'Work Order Extract file '||L_FILE_NAME||' created  for Contractor '||OUN.OUN_CONTRACTOR_ID);
                     END IF ; 
                  
                  EXCEPTION 
                      WHEN OTHERS THEN
                          L_CONTINUE  := FALSE ;
                          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                ,PI_MESSAGE      => 'Error while generating WO file for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                ,PI_MESSAGE_TYPE => 'E'
                                                ,PI_SUMMARY_FLAG => 'Y' );    
                  END ;
                  
                  FOR FTP IN (SELECT FTP.* 
                              FROM   HIG_PROCESS_CONNS_BY_AREA ,HIG_FTP_CONNECTIONS FTP
                              WHERE  HPTC_PROCESS_TYPE_ID = L_HP_REC.HP_PROCESS_TYPE_ID 
                              AND    HPTC_AREA_ID_VALUE   = NVL(L_HP_REC.HP_AREA_ID,OUN.OUN_ORG_ID)
                              AND    HFC_ID               = HPTC_FTP_CONNECTION_ID)
                  LOOP    
                      
                  
                  
                      IF L_CONTINUE
                      THEN
                         BEGIN
                         
                            NM3CTX.SET_CONTEXT('NM3FTPPASSWORD','Y');
                            BEGIN
                               
                               L_CONN := NM3FTP.LOGIN(FTP.HFC_FTP_HOST,FTP.HFC_FTP_PORT,FTP.HFC_FTP_USERNAME,NM3FTP.GET_PASSWORD(FTP.HFC_FTP_PASSWORD));
                               L_CONTINUE  := TRUE ;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    L_CONTINUE  := FALSE ;
                                    L_FAILED    := 'Y' ; 
                                    HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                          ,PI_MESSAGE      => 'Error while connecting to the FTP server for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                          ,PI_MESSAGE_TYPE => 'E'
                                                          ,PI_SUMMARY_FLAG => 'Y' );
                            END ;
                            IF L_CONTINUE 
                            THEN
                                BEGIN
                                   
                                   NM3FTP.PUT(L_CONN,'CIM_DIR',L_FILE_NAME,FTP.HFC_FTP_OUT_DIR||L_FILE_NAME);
                                   HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                             ,PI_MESSAGE    => 'Work Order Extract file '||L_FILE_NAME||' copied to FTP location');
                                   L_CONTINUE  := TRUE ;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        L_CONTINUE  := FALSE ; 
                                        L_FAILED    := 'Y' ;
                                        HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                              ,PI_MESSAGE      => 'Following error occurred while copying the WO file to the FTP location for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                              ,PI_MESSAGE_TYPE => 'E'
                                                              ,PI_SUMMARY_FLAG => 'Y' ); 
                                END  ;            
                                IF L_CONTINUE 
                                THEN
                                    BEGIN
                                       
                                       NM3FILE.MOVE_FILE(L_FILE_NAME,'CIM_DIR',L_FILE_NAME,'CIM_ARC',NULL,TRUE,L_ERR_NO,L_ERROR);
                                       IF L_ERROR IS NOT NULL
                                       THEN
                                            L_FAILED    := 'Y' ;
                                            HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                  ,PI_MESSAGE      => 'Following error occurred while archiving the WO file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||L_ERROR
                                                                  ,PI_MESSAGE_TYPE => 'E'
                                                                  ,PI_SUMMARY_FLAG => 'Y' );                                     
                                       ELSE
                                           HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                 ,PI_MESSAGE    => 'Work Order Extract file '||L_FILE_NAME||' archived');
                                       END IF ;
                                       NM3FTP.LOGOUT(L_CONN);
                                       
                                     EXCEPTION
                                        WHEN OTHERS THEN
                                            L_FAILED := 'Y' ;
                                            NM3FTP.LOGOUT(L_CONN);
                                            HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                  ,PI_MESSAGE      => 'Following error occurred while archiving the WO file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                  ,PI_MESSAGE_TYPE => 'E'
                                                                  ,PI_SUMMARY_FLAG => 'Y' ); 
                                    END ;
                                END IF ;
                            END IF ;
                         
                         EXCEPTION
                         WHEN OTHERS
                         THEN
                             NM3FTP.LOGOUT(L_CONN);                             
                             RAISE_APPLICATION_ERROR(-20001,'Error '||SQLERRM);
                         END ;
                      END IF ;
                  END LOOP; 
              END IF ; 
           EXCEPTION
               WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20001,'Error '||SQLERRM);
           END ; 
       ELSIF PI_BATCH_TYPE ='WC'
       THEN
           L_FILE_NAME := NULL ;
           L_TMP       := NULL ;
           IF NVL(L_HP_REC.HP_POLLING_FLAG,'N')= 'Y'
           THEN
               FOR FTP IN (SELECT FTP.* 
                           FROM   HIG_PROCESS_CONNS_BY_AREA ,HIG_FTP_CONNECTIONS FTP
                           WHERE  HPTC_PROCESS_TYPE_ID = L_HP_REC.HP_PROCESS_TYPE_ID 
                           AND    HPTC_AREA_ID_VALUE   = NVL(L_HP_REC.HP_AREA_ID,OUN.OUN_ORG_ID)
                           AND    HFC_ID               = HPTC_FTP_CONNECTION_ID)
               LOOP
                   
                   
                   
                   BEGIN
                   
                      NM3CTX.SET_CONTEXT('NM3FTPPASSWORD','Y');
                      BEGIN
                         
                         L_CONN := NM3FTP.LOGIN(FTP.HFC_FTP_HOST,FTP.HFC_FTP_PORT,FTP.HFC_FTP_USERNAME,NM3FTP.GET_PASSWORD(FTP.HFC_FTP_PASSWORD));
                         L_CONTINUE := TRUE;
                         
                      EXCEPTION
                          WHEN OTHERS THEN
                              L_FOUND := 'Y' ; 
                              L_CONTINUE := FALSE;
                              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                    ,PI_MESSAGE    => 'Error while connecting to the FTP server for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                    ,PI_SUMMARY_FLAG => 'Y' ); 
                      END ;
                      IF L_CONTINUE 
                      THEN
                          NM3FTP.LIST(L_CONN,FTP.HFC_FTP_IN_DIR, L_FILE_TAB);
                          FOR I IN 1..L_FILE_TAB.COUNT
                          LOOP
                              L_TMP := NULL ; 
                              L_FILE_NAME := NULL ; 
                              IF L_FILE_TAB(I) IS NOT NULL
                              THEN
                                  L_TMP := UPPER(L_FILE_TAB(I)) ;
                                  IF L_TMP LIKE UPPER('%WC%.'||OUN.OUN_CONTRACTOR_ID)
                                  THEN
                                      L_FILE_NAME := SUBSTR(L_TMP,1,INSTR(L_TMP,'.'||UPPER(OUN.OUN_CONTRACTOR_ID),1,1)-1);
                                      L_FILE_NAME := SUBSTR(L_FILE_NAME,INSTR(L_FILE_NAME,' ',-1,1))||'.'||UPPER(OUN.OUN_CONTRACTOR_ID);
                                  END IF ;
                              END IF;
                              IF L_FILE_NAME IS NOT NULL                          
                              THEN
                                  L_FILE_NAME := TRIM(L_FILE_NAME);
                                  L_FOUND := 'Y' ;
                                  BEGIN
                                     
                                     NM3FTP.GET(L_CONN,FTP.HFC_FTP_IN_DIR||L_FILE_NAME,'CIM_DIR',L_FILE_NAME);
                                     NM3FTP.DELETE(L_CONN,FTP.HFC_FTP_IN_DIR||L_FILE_NAME);
                                     L_CONTINUE := TRUE;
                                     
                                  EXCEPTION
                                      WHEN OTHERS THEN
                                          L_CONTINUE := FALSE;
                                          HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                ,PI_MESSAGE    => 'Error while getting file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                ,PI_SUMMARY_FLAG => 'Y' ); 
                                  END ;
                                  IF L_CONTINUE 
                                  THEN                         
                                      BEGIN
                                         
                                          RUN_COMP_FILE(OUN.OUN_CONTRACTOR_ID,L_FILE_NAME);
                                          L_CONTINUE := TRUE;
                                          
                                      EXCEPTION
                                          WHEN OTHERS THEN
                                              L_CONTINUE := FALSE;
                                              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                    ,PI_MESSAGE    => 'Error while loading file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                    ,PI_SUMMARY_FLAG => 'Y' ); 
                                      END ;
                                  END IF ;
                                  IF L_CONTINUE
                                  THEN
                                      
                                      IF  FTP.HFC_FTP_ARC_PASSWORD IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_HOST IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_PORT IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_USERNAME IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_IN_DIR   IS NOT NULL
                                      THEN
                                      
                                          IF FTP.HFC_FTP_ARC_HOST      = FTP.HFC_FTP_HOST
                                          AND FTP.HFC_FTP_PORT         = FTP.HFC_FTP_ARC_PORT
                                          AND FTP.HFC_FTP_ARC_USERNAME = FTP.HFC_FTP_USERNAME
                                          THEN
                                              BEGIN
                                              
                                                 IF L_CONTINUE
                                                 THEN   
                                                     NM3FTP.PUT(L_CONN,'CIM_ARC',L_FILE_NAME,FTP.HFC_FTP_ARC_IN_DIR||L_FILE_NAME);
                                                     L_CONTINUE := TRUE;
                                                     HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                           ,PI_MESSAGE    => 'WC file '||L_FILE_NAME||' archived on the FTP server');
                                                 END IF ;
                                              
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                      L_CONTINUE := FALSE;
                                                      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                            ,PI_MESSAGE    => 'Error while archiving file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                            ,PI_SUMMARY_FLAG => 'Y' ); 
                                              END ;
                                          ELSE
                                              BEGIN 
                                              
                                                 NM3CTX.SET_CONTEXT('NM3FTPPASSWORD','Y');
                                                 BEGIN
                                                 
                                                    L_ARC_CONN := NM3FTP.LOGIN(FTP.HFC_FTP_ARC_HOST,FTP.HFC_FTP_ARC_PORT,FTP.HFC_FTP_ARC_USERNAME,NM3FTP.GET_PASSWORD(FTP.HFC_FTP_ARC_PASSWORD));
                                                    L_CONTINUE  := TRUE ;
                                                    IF L_CONTINUE
                                                    THEN   
                                                        NM3FTP.PUT(L_ARC_CONN,'CIM_ARC',L_FILE_NAME,FTP.HFC_FTP_ARC_IN_DIR||L_FILE_NAME);
                                                        L_CONTINUE := TRUE;
                                                        HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                              ,PI_MESSAGE    => 'WC file '||L_FILE_NAME||' archived on the FTP server');
                                                    END IF ;
                                                    
                                                 EXCEPTION
                                                     WHEN OTHERS THEN
                                                         L_CONTINUE := FALSE;
                                                         HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                               ,PI_MESSAGE    => 'Error while archiving file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                               ,PI_SUMMARY_FLAG => 'Y' ); 
                                                 END ;    
                                                 NM3FTP.LOGOUT(L_ARC_CONN);
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                  L_CONTINUE  := FALSE ;
                                                  L_FAILED    := 'Y' ; 
                                                  HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                        ,PI_MESSAGE      => 'Error while connecting to the archiving FTP server for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                        ,PI_MESSAGE_TYPE => 'E'
                                                                        ,PI_SUMMARY_FLAG => 'Y' );
                                              END ;
                                          END IF ; 
                                      END IF ;                              
                                  END IF ;
                              END IF ; 
                          END LOOP; 
                          NM3FTP.LOGOUT(L_CONN);                 
                      END IF ; 
                   
                   EXCEPTION
                   WHEN OTHERS
                   THEN
                       NM3FTP.LOGOUT(L_CONN);
                       RAISE_APPLICATION_ERROR(-20001,'Error '||SQLERRM);
                   END ;    
               END LOOP;
           ELSE
               BEGIN
               
                  L_FLIST := NM3FILE.GET_WILDCARD_FILES_IN_DIR (L_PATH,'WC*.'||UPPER(OUN.OUN_CONTRACTOR_ID));
                  L_CONTINUE := TRUE;
               
               EXCEPTION
                   WHEN OTHERS THEN
                       L_CONTINUE := FALSE;
                       HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                             ,PI_MESSAGE    => 'Error while searhing WC file for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                             ,PI_SUMMARY_FLAG => 'Y' ); 
               END ;
               IF L_CONTINUE 
               THEN
                   FOR I IN 1..L_FLIST.COUNT
                   LOOP
                       IF TRIM(L_FLIST(I)) IS NOT NULL
                       THEN
                          L_FOUND := 'Y' ;                        
                           BEGIN
                           
                              RUN_COMP_FILE(OUN.OUN_CONTRACTOR_ID,TRIM(L_FLIST(I)));
                           
                           EXCEPTION
                               WHEN OTHERS THEN
                               HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                     ,PI_MESSAGE    => 'Error while loading file '||TRIM(L_FLIST(I))||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                     ,PI_SUMMARY_FLAG => 'Y' ); 
                           END ;                            
                       END IF ;
                   END LOOP;
               END IF ;
           END IF; 
       ELSIF PI_BATCH_TYPE = 'WI'
       THEN
           L_FILE_NAME := NULL ;
           L_TMP       := NULL ;
           IF NVL(L_HP_REC.HP_POLLING_FLAG,'N')= 'Y'
           THEN
               FOR FTP IN (SELECT FTP.* 
                           FROM   HIG_PROCESS_CONNS_BY_AREA ,HIG_FTP_CONNECTIONS FTP
                           WHERE  HPTC_PROCESS_TYPE_ID = L_HP_REC.HP_PROCESS_TYPE_ID 
                           AND    HPTC_AREA_ID_VALUE   = NVL(L_HP_REC.HP_AREA_ID,OUN.OUN_ORG_ID)
                           AND    HFC_ID               = HPTC_FTP_CONNECTION_ID)
               LOOP
               
               
               
                   BEGIN
                   
                      NM3CTX.SET_CONTEXT('NM3FTPPASSWORD','Y');
                      BEGIN
                         
                         L_CONN := NM3FTP.LOGIN(FTP.HFC_FTP_HOST,FTP.HFC_FTP_PORT,FTP.HFC_FTP_USERNAME,NM3FTP.GET_PASSWORD(FTP.HFC_FTP_PASSWORD));
                         L_CONTINUE := TRUE;
                         
                      EXCEPTION
                          WHEN OTHERS THEN
                              L_FOUND := 'Y' ;
                              L_CONTINUE := FALSE;
                              HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                    ,PI_MESSAGE    => 'Error while connecting to the FTP server for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                    ,PI_SUMMARY_FLAG => 'Y' );
                      END ;
                      IF L_CONTINUE 
                      THEN
                          NM3FTP.LIST(L_CONN,FTP.HFC_FTP_IN_DIR, L_FILE_TAB);
                          FOR I IN 1..L_FILE_TAB.COUNT
                          LOOP
                              L_TMP := NULL ; 
                              L_FILE_NAME := NULL ;
                              IF L_FILE_TAB(I) IS NOT NULL
                              THEN
                                  L_TMP := UPPER(L_FILE_TAB(I)) ;
                                  IF L_TMP LIKE UPPER('%WI%.'||OUN.OUN_CONTRACTOR_ID)
                                  THEN
                                      L_FILE_NAME := SUBSTR(L_TMP,1,INSTR(L_TMP,'.'||UPPER(OUN.OUN_CONTRACTOR_ID),1,1)-1);
                                      L_FILE_NAME := SUBSTR(L_FILE_NAME,INSTR(L_FILE_NAME,' ',-1,1))||'.'||UPPER(OUN.OUN_CONTRACTOR_ID);
                                  END IF ;
                              END IF;
                              IF L_FILE_NAME IS NOT NULL
                              THEN
                                  L_FILE_NAME := TRIM(L_FILE_NAME); 
                                  L_FOUND := 'Y' ;
                                  BEGIN
                                  
                                     NM3FTP.GET(L_CONN,FTP.HFC_FTP_IN_DIR||L_FILE_NAME,'CIM_DIR',L_FILE_NAME);      
                                     NM3FTP.DELETE(L_CONN,FTP.HFC_FTP_IN_DIR||L_FILE_NAME);                    
                                     L_CONTINUE := TRUE;
                                  
                                  EXCEPTION
                                     WHEN OTHERS THEN
                                         L_CONTINUE := FALSE;
                                         HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                               ,PI_MESSAGE    => 'Error while getting file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                               ,PI_SUMMARY_FLAG => 'Y' );
                                  
                                  END ;
                                  IF L_CONTINUE
                                  THEN
                                      BEGIN
                                      
                                         RUN_CLAIM_FILE(OUN.OUN_CONTRACTOR_ID,L_FILE_NAME);    
                                         L_CONTINUE := TRUE;
                                      
                                      EXCEPTION
                                         WHEN OTHERS THEN
                                             L_CONTINUE := FALSE;
                                             HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                   ,PI_MESSAGE    => 'Error while loading file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                   ,PI_SUMMARY_FLAG => 'Y' );
                                      
                                      END ;
                                  END IF ;
                                  IF L_CONTINUE
                                  THEN
                                      
                                      IF  FTP.HFC_FTP_ARC_PASSWORD IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_HOST IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_PORT IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_USERNAME IS NOT NULL
                                      AND FTP.HFC_FTP_ARC_IN_DIR   IS NOT NULL
                                      THEN
                                      
                                          IF FTP.HFC_FTP_ARC_HOST      = FTP.HFC_FTP_HOST
                                          AND FTP.HFC_FTP_PORT         = FTP.HFC_FTP_ARC_PORT
                                          AND FTP.HFC_FTP_ARC_USERNAME = FTP.HFC_FTP_USERNAME
                                          THEN
                                          
                                              BEGIN
                                              
                                                 IF L_CONTINUE
                                                 THEN   
                                                     NM3FTP.PUT(L_CONN,'CIM_ARC',L_FILE_NAME,FTP.HFC_FTP_ARC_IN_DIR||L_FILE_NAME);
                                                     L_CONTINUE := TRUE;
                                                     HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                           ,PI_MESSAGE    => 'WI file '||L_FILE_NAME||' archived on the FTP server');
                                                 END IF ;
                                                 
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                      L_CONTINUE := FALSE;
                                                      HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                            ,PI_MESSAGE    => 'Error while archiving file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                            ,PI_SUMMARY_FLAG => 'Y' );
                                              END ;
                                          ELSE                                     
                                              BEGIN 
                                              
                                                 NM3CTX.SET_CONTEXT('NM3FTPPASSWORD','Y');
                                                 BEGIN
                                                 
                                                    L_ARC_CONN := NM3FTP.LOGIN(FTP.HFC_FTP_ARC_HOST,FTP.HFC_FTP_ARC_PORT,FTP.HFC_FTP_ARC_USERNAME,NM3FTP.GET_PASSWORD(FTP.HFC_FTP_ARC_PASSWORD));
                                                    L_CONTINUE  := TRUE ;
                                                    IF L_CONTINUE
                                                    THEN   
                                                        NM3FTP.PUT(L_ARC_CONN,'CIM_ARC',L_FILE_NAME,FTP.HFC_FTP_ARC_IN_DIR||L_FILE_NAME);
                                                        L_CONTINUE := TRUE;
                                                        HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                              ,PI_MESSAGE    => 'WI file '||L_FILE_NAME||' archived on the FTP server');
                                                    END IF ;
                                                    
                                                 EXCEPTION
                                                     WHEN OTHERS THEN
                                                         L_CONTINUE := FALSE;
                                                         HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                                               ,PI_MESSAGE    => 'Error while archiving file '||L_FILE_NAME||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                               ,PI_SUMMARY_FLAG => 'Y' ); 
                                                 END ;   
                                                 NM3FTP.LOGOUT(L_ARC_CONN); 
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                  L_CONTINUE  := FALSE ;
                                                  L_FAILED    := 'Y' ; 
                                                  HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                        ,PI_MESSAGE      => 'Error while connecting to the archiving FTP server for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                                        ,PI_MESSAGE_TYPE => 'E'
                                                                        ,PI_SUMMARY_FLAG => 'Y' );
                                              END ;
                                          END IF ;
                                      END IF ;
                                  END IF ;
                              END IF;
                          END LOOP; 
                          NM3FTP.LOGOUT(L_CONN);                 
                      END IF ;  
                   
                   EXCEPTION
                   WHEN OTHERS
                   THEN
                       NM3FTP.LOGOUT(L_CONN);
                       RAISE_APPLICATION_ERROR(-20001,'Error '||SQLERRM);
                   END ;    
               END LOOP;
           ELSE
               BEGIN
               
                  L_FLIST := NM3FILE.GET_WILDCARD_FILES_IN_DIR (L_PATH,'WI*.'||UPPER(OUN.OUN_CONTRACTOR_ID));
                  L_CONTINUE := TRUE;
               
               EXCEPTION
                   WHEN OTHERS THEN
                       L_CONTINUE := FALSE;
                       HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                             ,PI_MESSAGE    => 'Error while searhing WI file for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                             ,PI_SUMMARY_FLAG => 'Y' ); 
               END ;
               IF L_CONTINUE 
               THEN
                   FOR I IN 1..L_FLIST.COUNT
                   LOOP
                       IF TRIM(L_FLIST(I)) IS NOT NULL
                       THEN
                           L_FOUND := 'Y' ;
                           BEGIN
                           
                              RUN_CLAIM_FILE(OUN.OUN_CONTRACTOR_ID,TRIM(L_FLIST(I)));
                           
                           EXCEPTION
                               WHEN OTHERS THEN
                               HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID => L_PROCESS_ID
                                                     ,PI_MESSAGE    => 'Error while loading file '||TRIM(L_FLIST(I))||' for Contractor '||OUN.OUN_CONTRACTOR_ID||' '||SQLERRM 
                                                     ,PI_SUMMARY_FLAG => 'Y' ); 
                           END ; 
                       END IF ;
                   END LOOP;
               END IF; 
           END IF ;
       END IF ; 
   END LOOP;
   IF   NVL(L_FOUND,'N') = 'N'
   THEN
       HIG_PROCESS_API.DROP_EXECUTION;
   END IF ;
   IF   NVL(L_FAILED,'N') ='Y'
   AND  L_PROCESS_ID IS NOT NULL
   THEN
       HIG_PROCESS_API.PROCESS_EXECUTION_END('N'); 
   END IF ;

END RUN_BATCH;



























END MAI_CIM_AUTOMATION;