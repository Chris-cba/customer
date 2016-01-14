CREATE OR REPLACE PACKAGE BODY HIGHWAYS.IM_FRAMEWORK
AS























  
  
  
  
  G_BODY_SCCSID  CONSTANT VARCHAR2(2000) :='"$Revision:   1.0  $"';

  G_PACKAGE_NAME CONSTANT VARCHAR2(30) := 'imf_framework';




FUNCTION GET_VERSION RETURN VARCHAR2 IS
BEGIN
   RETURN G_SCCSID;
END GET_VERSION;



FUNCTION GET_BODY_VERSION RETURN VARCHAR2 IS
BEGIN
   RETURN G_BODY_SCCSID;
END GET_BODY_VERSION;



FUNCTION ALLOW_FOR_PRODUCT(PI_PRODUCT HIG_PRODUCTS.HPR_PRODUCT%TYPE)
RETURN BOOLEAN
IS
   RTRN BOOLEAN;
   L_PRODUCT  HIG_PRODUCTS.HPR_PRODUCT%TYPE;
BEGIN
   RTRN := FALSE;
   L_PRODUCT := PI_PRODUCT;
   FOR VREC IN (SELECT 1
                FROM HIG_PRODUCTS
                WHERE
                     HPR_PRODUCT = L_PRODUCT
                 AND HPR_KEY IS NOT NULL)
   LOOP
      RTRN := TRUE;
   END LOOP;
   RETURN RTRN;
END ALLOW_FOR_PRODUCT;



FUNCTION ALLOW_POD(PI_MODULE HIG_MODULES.HMO_MODULE%TYPE)
RETURN BOOLEAN
IS
   RTRN BOOLEAN;
   L_MODULE HIG_MODULES.HMO_MODULE%TYPE;
BEGIN
   RTRN := FALSE;












   RETURN RTRN ;
END ALLOW_POD;



PROCEDURE POP_UP_WINDOW( PI_APP_ID VARCHAR2
                        ,PI_SESSION VARCHAR2
                        ,PI_PAGE VARCHAR2
                        ,PI_ITEM VARCHAR2 DEFAULT NULL
                        ,PI_VALUE VARCHAR2 DEFAULT NULL
                     )
IS
BEGIN
   HTP.P ('<script>');
   HTP.P
      (   'window.open(''f?p='||PI_APP_ID||':'''
       || PI_PAGE
       || ':'|| PI_SESSION||'::NO:::'',
          ''mywindow'',
          ''width=600,height=600,resizable=yes,'
       || 'scrollbars=yes,toolbar=yes,menubar=yes'')'
      );
   HTP.P ('</script>');

END POP_UP_WINDOW;




PROCEDURE INSERT_BUSINESS_MODULES( PI_BA_ID IM_BUSINESS_AREAS.IBA_ID%TYPE
                                  ,PI_MODULES VARCHAR2
                                 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   L_VC_ARR2    APEX_APPLICATION_GLOBAL.VC_ARR2;

BEGIN
   L_VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(PI_MODULES);

   FOR I IN 1..L_VC_ARR2.COUNT
    LOOP
       INSERT INTO IM_BUSINESS_MODULES
       (SELECT IBM_ID_SEQ.NEXTVAL
             , L_VC_ARR2(I)
             ,PI_BA_ID
             , HMO_TITLE
       FROM HIG_MODULES
       WHERE HMO_MODULE = L_VC_ARR2(I)
         AND NOT EXISTS ( SELECT 1
                          FROM IM_BUSINESS_MODULES
                          WHERE IBM_IBA_ID = PI_BA_ID
                          AND IBM_MODULE = L_VC_ARR2(I))
                          );
   END LOOP;
 COMMIT;

  
   
 END INSERT_BUSINESS_MODULES;
PROCEDURE DELETE_BUSINESS_MODULES( PI_BA_ID IM_BUSINESS_AREAS.IBA_ID%TYPE
                                  ,PI_MODULES VARCHAR2
                                 )
IS
 
   L_VC_ARR2    APEX_APPLICATION_GLOBAL.VC_ARR2;

BEGIN
   L_VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(PI_MODULES);

   FOR I IN 1..L_VC_ARR2.COUNT
    LOOP
       DELETE IM_BUSINESS_MODULES
       WHERE IBM_IBA_ID = PI_BA_ID
         AND IBM_MODULE = L_VC_ARR2(I);
   END LOOP;

  



END DELETE_BUSINESS_MODULES;



FUNCTION HAS_DOC(PI_DOC_ID DOC_ASSOCS.DAS_REC_ID%TYPE, PI_TABLE_NAME VARCHAR2 DEFAULT 'DOCS2VIEW')
RETURN NUMBER
IS
   CURSOR C1
   IS
   SELECT 1
   FROM DOC_ASSOCS
   WHERE DAS_REC_ID = PI_DOC_ID
   AND DAS_TABLE_NAME = PI_TABLE_NAME;

   RTRN NUMBER;
BEGIN
  OPEN C1;
  FETCH C1 INTO RTRN;
  IF C1%FOUND THEN RTRN := 1;
  ELSE
     RTRN := 0;
  END IF;
  CLOSE C1;
  RETURN RTRN;
END HAS_DOC;



FUNCTION GET_IM4_QUERY(PI_MODULE IM4_QUERIES.IQ_MODULE%TYPE)
RETURN IM4_QUERIES%ROWTYPE
IS
   RTRN IM4_QUERIES%ROWTYPE;
BEGIN
   FOR VREC IN (SELECT * FROM IM4_QUERIES WHERE IQ_MODULE =   PI_MODULE)
    LOOP
      RTRN := VREC;
   END LOOP;
   RETURN RTRN;
END GET_IM4_QUERY;



FUNCTION GET_QUERY(PI_MODULE VARCHAR2
                  ,PI_LOCATION VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2
IS
   IQ_REC IM4_QUERIES%ROWTYPE;
   L_SQL VARCHAR2(2000);
BEGIN
   IQ_REC := GET_IM4_QUERY(PI_MODULE => PI_MODULE);

   L_SQL := IQ_REC.IQ_SQL;

    IF PI_LOCATION IS NOT NULL
     AND
       IQ_REC.IQ_USE_LOCATION = 'Y'
     THEN
        L_SQL := L_SQL ||'and ' ||IQ_REC.IQ_NE_COLUMN ||' in (SELECT ' ||
        '      nm_ne_id_of data ' ||
        '      FROM ' ||
        '      nm_members ' ||
        '     WHERE ' ||
        '      nm3net.get_ne_gty( nm_ne_id_of ) IS  ' ||
        '      NULL CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in ' ||
        '     AND ' ||
        '      nm3net.get_ne_gty( nm_ne_id_of ) IS NULL  ' ||
        '     START ' ||
        '     WITH nm_ne_id_in                     = nm3net.get_ne_id(nvl('''||TRIM(PI_LOCATION)||''',''ALL_SECTIONS_GROUP'')) ' ||
        '   ) ' ;
   END IF;

  IF IQ_REC.IQ_GROUP_BY IS NOT NULL
   THEN
     L_SQL := L_SQL || ' group by ' || IQ_REC.IQ_GROUP_BY;
  END IF;

  RETURN L_SQL;
END GET_QUERY;



PROCEDURE GET_PARAMS ( PI_MODULE GRI_PARAM_DEPENDENCIES.GPD_MODULE%TYPE
                     ) IS

BEGIN
  SELECT GMP_SEQ, GMP_MODULE, GMP_PARAM, GPD_DEP_PARAM, GPD_INDEP_PARAM, GMP_WHERE, ''
  BULK COLLECT INTO IM_FRAMEWORK_TYPES.G_PARAMS
   FROM GRI_MODULE_PARAMS, GRI_PARAM_DEPENDENCIES
   WHERE GMP_MODULE = PI_MODULE
     AND GMP_MODULE = GPD_MODULE (+)
     AND GMP_PARAM = GPD_DEP_PARAM (+)
     ORDER BY GMP_SEQ;
END GET_PARAMS;



FUNCTION GET_PARAM_RESULT ( PI_MODULE      IN GRI_PARAM_DEPENDENCIES.GPD_MODULE%TYPE
                          , PI_DEP_PARAM   IN GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                          , PI_INDEP_PARAM IN GRI_PARAM_DEPENDENCIES.GPD_INDEP_PARAM%TYPE DEFAULT NULL
                          ) RETURN VARCHAR2 IS

L_RESULT VARCHAR2(2);
BEGIN
  FOR I IN 1..IM_FRAMEWORK_TYPES.G_PARAMS.COUNT LOOP
    IF IM_FRAMEWORK_TYPES.G_PARAMS(I).GMP_MODULE = PI_MODULE
    AND IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM
    AND IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_INDEP_PARAM = PI_INDEP_PARAM
    THEN
      L_RESULT := IM_FRAMEWORK_TYPES.G_PARAMS(I).RESULT;
    END IF;
  END LOOP;
  RETURN L_RESULT;
END GET_PARAM_RESULT;



PROCEDURE ADD_PARAM_RESULT ( PI_MODULE      IN GRI_PARAM_DEPENDENCIES.GPD_MODULE%TYPE
                           , PI_DEP_PARAM   IN GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                           , PI_INDEP_PARAM IN GRI_PARAM_DEPENDENCIES.GPD_INDEP_PARAM%TYPE DEFAULT NULL
                           , PI_RESULT      IN VARCHAR2
                           ) IS

BEGIN
  FOR I IN 1..IM_FRAMEWORK_TYPES.G_PARAMS.COUNT LOOP
    IF IM_FRAMEWORK_TYPES.G_PARAMS(I).GMP_MODULE = PI_MODULE
    AND IM_FRAMEWORK_TYPES.G_PARAMS(I).GMP_PARAM = PI_DEP_PARAM
    AND NVL(IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_DEP_PARAM,PI_DEP_PARAM) = PI_DEP_PARAM
    AND NVL(IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_INDEP_PARAM,NVL(PI_INDEP_PARAM,'@')) = NVL(PI_INDEP_PARAM,'@')
    THEN
      IM_FRAMEWORK_TYPES.G_PARAMS(I).RESULT := PI_RESULT;

        NM_DEBUG.DEBUG(GET_PARAM_RESULT( IM_FRAMEWORK_TYPES.G_PARAMS(I).GMP_MODULE
                                       , IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_DEP_PARAM
                                       , IM_FRAMEWORK_TYPES.G_PARAMS(I).GPD_INDEP_PARAM)
                                       );

    END IF;
  END LOOP;

END ADD_PARAM_RESULT;



FUNCTION IS_PARAM_DEPENDENT ( PI_MODULE      IN GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                            , PI_PARAM       IN GRI_MODULE_PARAMS.GMP_PARAM%TYPE DEFAULT NULL
                            ) RETURN NUMBER IS
  L_COUNT NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO L_COUNT
   FROM GRI_MODULE_PARAMS, GRI_PARAM_DEPENDENCIES
   WHERE GMP_MODULE = PI_MODULE
     AND GMP_PARAM = PI_PARAM
     AND GMP_MODULE = GPD_MODULE
     AND GMP_PARAM = GPD_DEP_PARAM
     ORDER BY GMP_SEQ;
  RETURN L_COUNT;
END IS_PARAM_DEPENDENT;



FUNCTION IS_PARAM_INDEPENDENT ( PI_MODULE      IN GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                              , PI_PARAM       IN GRI_MODULE_PARAMS.GMP_PARAM%TYPE DEFAULT NULL
                              ) RETURN NUMBER IS
  L_COUNT NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO L_COUNT
   FROM GRI_MODULE_PARAMS, GRI_PARAM_DEPENDENCIES
   WHERE GMP_MODULE = PI_MODULE
     AND GMP_PARAM = PI_PARAM
     AND GMP_MODULE = GPD_MODULE
     AND GMP_PARAM = GPD_INDEP_PARAM
     ORDER BY GMP_SEQ;
  RETURN L_COUNT;
END IS_PARAM_INDEPENDENT;



PROCEDURE GET_PARAM_DEPENDENCIES ( PI_MODULE      IN GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                                , PI_PARAM       IN GRI_MODULE_PARAMS.GMP_PARAM%TYPE DEFAULT NULL
                                ) IS
BEGIN
  SELECT GMP_SEQ, GMP_MODULE, GMP_PARAM, GPD_DEP_PARAM, GPD_INDEP_PARAM, GMP_WHERE, ''
  BULK COLLECT INTO G_DEP_PARAMS
   FROM GRI_MODULE_PARAMS, GRI_PARAM_DEPENDENCIES
   WHERE GMP_MODULE = PI_MODULE
     AND GMP_PARAM = PI_PARAM
     AND GMP_MODULE = GPD_MODULE
     AND GMP_PARAM = GPD_DEP_PARAM
     ORDER BY GMP_SEQ;
END GET_PARAM_DEPENDENCIES;



PROCEDURE GET_PARAM_INDEPENDENCIES ( PI_MODULE      IN GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                                  , PI_PARAM       IN GRI_MODULE_PARAMS.GMP_PARAM%TYPE DEFAULT NULL
                                  ) IS
BEGIN
  SELECT GMP_SEQ, GMP_MODULE, GMP_PARAM, GPD_DEP_PARAM, GPD_INDEP_PARAM, GMP_WHERE, ''
  BULK COLLECT INTO G_INDEP_PARAMS
   FROM GRI_MODULE_PARAMS, GRI_PARAM_DEPENDENCIES
   WHERE GMP_MODULE = PI_MODULE
     AND GMP_PARAM = PI_PARAM
     AND GMP_MODULE = GPD_MODULE
     AND GMP_PARAM = GPD_INDEP_PARAM
     ORDER BY GMP_SEQ;
END GET_PARAM_INDEPENDENCIES;



FUNCTION COUNT_PARAMS_IN_WHERE ( PI_WHERE GRI_MODULE_PARAMS.GMP_WHERE%TYPE
                               ) RETURN NUMBER IS

 L_COUNT NUMBER := 0;
 L_CHAR VARCHAR2(1) := ':';
BEGIN
 FOR I IN 1..LENGTH(PI_WHERE) LOOP
   IF SUBSTR(PI_WHERE,I,LENGTH(L_CHAR)) = L_CHAR THEN
     L_COUNT := L_COUNT + 1;
   END IF;
 END LOOP;
 RETURN L_COUNT;
END COUNT_PARAMS_IN_WHERE;                               



PROCEDURE GET_PARAMS_IN_STRING ( PI_MODULE IN GRI_MODULE_PARAMS.GMP_WHERE%TYPE
                               , PI_WHERE IN GRI_MODULE_PARAMS.GMP_WHERE%TYPE
                               , PO_PARAM OUT GRI_MODULE_PARAMS.GMP_PARAM%TYPE
                               , PO_SEQ OUT GRI_MODULE_PARAMS.GMP_PARAM%TYPE
                               ) IS

 CURSOR C1 IS 
 SELECT *
 FROM GRI_MODULE_PARAMS
 WHERE GMP_MODULE = PI_MODULE;
 L_COUNT NUMBER := 0;
 L_PARAM_FOUND VARCHAR2(20);
BEGIN
 FOR C1REC IN C1 LOOP
   FOR I IN 1..LENGTH(PI_WHERE) LOOP
     IF SUBSTR(PI_WHERE,I,LENGTH(C1REC.GMP_PARAM)+1) = ':'||C1REC.GMP_PARAM THEN
       L_COUNT := L_COUNT + 1;
       PO_PARAM := C1REC.GMP_PARAM;
       PO_SEQ := C1REC.GMP_SEQ;
     END IF; 
   END LOOP;
 END LOOP;
END GET_PARAMS_IN_STRING;



PROCEDURE REPLACE_PARAM_WITH_RESULT ( PI_PARAM IN GRI_MODULE_PARAMS.GMP_PARAM%TYPE
                                    , PI_RESULT IN VARCHAR2
                                    , PI_SELECT IN OUT GRI_MODULE_PARAMS.GMP_WHERE%TYPE
                                    ) IS
BEGIN
  PI_SELECT := REPLACE(PI_SELECT, ':'||PI_PARAM, ''''||PI_RESULT||'''');
END REPLACE_PARAM_WITH_RESULT;



FUNCTION GET_DEFAULT_LOV_VALUE ( PI_SELECT VARCHAR2 ) RETURN VARCHAR2 IS
  L_RESULT VARCHAR2(500);
  L_DESCR VARCHAR2(500);
  L_CODE VARCHAR2(500);
  TYPE C_REF_TYPE IS REF CURSOR;
  C_REF C_REF_TYPE;
BEGIN
  OPEN C_REF FOR (PI_SELECT);
    LOOP        
      FETCH C_REF INTO L_DESCR, L_CODE;
      EXIT WHEN 1 = 1 OR C_REF%NOTFOUND;
    END LOOP;
  CLOSE C_REF;
  L_RESULT := L_DESCR;
  RETURN L_RESULT;  
END GET_DEFAULT_LOV_VALUE;



PROCEDURE BUILD_LOV_1 ( PI_MODULE GRI_PARAM_DEPENDENCIES.GPD_MODULE%TYPE
                      , PI_DEP_PARAM1 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM2 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM3 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM4 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM5 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM6 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_DEP_PARAM7 GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE DEFAULT NULL
                      , PI_INDEP_PARAM GRI_PARAM_DEPENDENCIES.GPD_INDEP_PARAM%TYPE DEFAULT NULL
                      , PI_RESULT VARCHAR2 DEFAULT NULL
                      , PI_RESULT1 VARCHAR2 DEFAULT NULL
                      , PI_RESULT2 VARCHAR2 DEFAULT NULL
                      , PI_RESULT3 VARCHAR2 DEFAULT NULL
                      , PI_RESULT4 VARCHAR2 DEFAULT NULL
                      , PI_RESULT5 VARCHAR2 DEFAULT NULL
                      , PI_RESULT6 VARCHAR2 DEFAULT NULL
                      ) IS

  CURSOR C_SELECT_PARAMS ( C_MODULE GRI_PARAM_DEPENDENCIES.GPD_MODULE%TYPE
                           , C_PARAM GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE
                           ) IS
  SELECT 'select '||GP_SHOWN_COLUMN||'||'' ''||'||GP_DESCR_COLUMN||' descr, '||GP_COLUMN||' code from '||GP_TABLE||DECODE(GMP_WHERE,'','',' where '||GMP_WHERE)
    FROM GRI_MODULE_PARAMS, GRI_PARAMS
   WHERE GMP_PARAM = GP_PARAM
       AND GMP_MODULE = C_MODULE
    AND GMP_PARAM = C_PARAM;

  L_PI_RESULT1 VARCHAR2(4000) := PI_RESULT1;
  L_PI_RESULT2 VARCHAR2(4000) := PI_RESULT2;
  L_PI_RESULT3 VARCHAR2(4000) := PI_RESULT3;
  L_PI_RESULT4 VARCHAR2(4000) := PI_RESULT4;
  L_PI_RESULT5 VARCHAR2(4000) := PI_RESULT5;
  L_PI_RESULT6 VARCHAR2(4000) := PI_RESULT6;

  L_SELECT VARCHAR2(4000);
  L_LOV VARCHAR2(4000);
  L_CODE VARCHAR2(100);
  L_DESCR VARCHAR2(100);
  L_PARAM GRI_MODULE_PARAMS.GMP_PARAM%TYPE;
  L_SEQ GRI_MODULE_PARAMS.GMP_SEQ%TYPE;
  TYPE C_REF_TYPE IS REF CURSOR;
  C_REF C_REF_TYPE;
  L_DEP_PARAM GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE;
BEGIN
  
  IF IM_FRAMEWORK.IS_PARAM_INDEPENDENT(PI_MODULE => PI_MODULE
                                      ,PI_PARAM => PI_INDEP_PARAM) > 0 THEN
    
    IM_FRAMEWORK.GET_PARAM_INDEPENDENCIES ( PI_MODULE => PI_MODULE
                                          , PI_PARAM => PI_INDEP_PARAM
                                          );
    
    FOR I IN 1..G_INDEP_PARAMS.COUNT LOOP
      IF G_INDEP_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM1 THEN
        L_PI_RESULT1 := NULL;
      END IF;               



      IF G_INDEP_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM3 THEN
        L_PI_RESULT3 := NULL;
      END IF;               
      IF G_INDEP_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM4 THEN
        L_PI_RESULT4 := NULL;
      END IF;
      IF G_INDEP_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM5 THEN
        L_PI_RESULT5 := NULL;
      END IF;               
      IF G_INDEP_PARAMS(I).GPD_DEP_PARAM = PI_DEP_PARAM6 THEN
        L_PI_RESULT6 := NULL;
      END IF;
    END LOOP;
  END IF;
 
  IF PI_DEP_PARAM6 IS NOT NULL AND L_PI_RESULT6 IS NOT NULL THEN
    L_DEP_PARAM := PI_DEP_PARAM6;
  ELSIF PI_DEP_PARAM5 IS NOT NULL AND L_PI_RESULT5 IS NOT NULL THEN
    L_DEP_PARAM := PI_DEP_PARAM5;
  ELSIF PI_DEP_PARAM4 IS NOT NULL AND L_PI_RESULT4 IS NOT NULL THEN
    L_DEP_PARAM := PI_DEP_PARAM4;
  ELSIF PI_DEP_PARAM3 IS NOT NULL AND L_PI_RESULT3 IS NOT NULL THEN
    L_DEP_PARAM := PI_DEP_PARAM3;
  ELSIF PI_DEP_PARAM2 IS NOT NULL AND L_PI_RESULT2 IS NOT NULL THEN
    L_DEP_PARAM := PI_DEP_PARAM2;
  ELSIF PI_DEP_PARAM1 IS NOT NULL AND L_PI_RESULT1 IS NOT NULL THEN
     L_DEP_PARAM := PI_DEP_PARAM1;
  END IF;


    OPEN C_SELECT_PARAMS( PI_MODULE
                        , L_DEP_PARAM
                        );
  FETCH C_SELECT_PARAMS INTO L_SELECT;
  CLOSE C_SELECT_PARAMS;

  IF PI_INDEP_PARAM IS NOT NULL THEN
  
  IF PI_INDEP_PARAM IS NOT NULL AND PI_RESULT IS NOT NULL THEN
    L_SELECT := REPLACE(L_SELECT, ':'||PI_INDEP_PARAM, ''''||PI_RESULT||'''');
  END IF;

  IF PI_DEP_PARAM1 IS NOT NULL AND L_PI_RESULT1 IS NOT NULL THEN
    L_SELECT := REPLACE(L_SELECT, ':'||PI_DEP_PARAM1, ''''||L_PI_RESULT1||'''');
  END IF;

  IF PI_DEP_PARAM2 IS NOT NULL AND L_PI_RESULT2 IS NOT NULL THEN
      L_SELECT := REPLACE(L_SELECT, ':'||PI_INDEP_PARAM, ''''||L_PI_RESULT2||'''');
  END IF;

  IF PI_DEP_PARAM3 IS NOT NULL AND L_PI_RESULT3 IS NOT NULL THEN
      L_SELECT := REPLACE(L_SELECT, ':'||PI_INDEP_PARAM, ''''||L_PI_RESULT3||'''');
  END IF;

  IF PI_DEP_PARAM4 IS NOT NULL AND L_PI_RESULT4 IS NOT NULL THEN
    L_SELECT := REPLACE(L_SELECT, ':'||PI_DEP_PARAM4, ''''||L_PI_RESULT4||'''');
  END IF;

  IF PI_DEP_PARAM5 IS NOT NULL AND L_PI_RESULT5 IS NOT NULL THEN
    L_SELECT := REPLACE(L_SELECT, ':'||PI_DEP_PARAM5, ''''||L_PI_RESULT5||'''');
  END IF;

  IF PI_DEP_PARAM6 IS NOT NULL AND L_PI_RESULT6 IS NOT NULL THEN
    L_SELECT := REPLACE(L_SELECT, ':'||PI_DEP_PARAM6, ''''||L_PI_RESULT6||'''');
  END IF;
  END IF;

 
  IF IM_FRAMEWORK.COUNT_PARAMS_IN_WHERE(L_SELECT) > 0 THEN
    GET_PARAMS_IN_STRING ( PI_MODULE
                         , L_SELECT
                         , L_PARAM
                         , L_SEQ
                         );
    CASE L_SEQ
      WHEN 1 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT1
                                  , L_SELECT
                                  );
      WHEN 2 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT2
                                  , L_SELECT
                                  );
      WHEN 3 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT3
                                  , L_SELECT
                                  );
      WHEN 4 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT4
                                  , L_SELECT
                                  );
      WHEN 5 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT5
                                  , L_SELECT
                                  );
      WHEN 6 THEN
        REPLACE_PARAM_WITH_RESULT ( L_PARAM
                                  , L_PI_RESULT6
                                  , L_SELECT
                                  );                                                                                                                                        
    END CASE;
  END IF;
      OWA_UTIL.MIME_HEADER ('text/xml', FALSE);
      HTP.P ('Cache-Control: no-cache');
      HTP.P ('Pragma: no-cache');
      OWA_UTIL.HTTP_HEADER_CLOSE;
      HTP.PRN ('<select>');
        OPEN C_REF FOR (L_SELECT);
        LOOP
          FETCH C_REF INTO L_DESCR, L_CODE;
          EXIT WHEN C_REF%NOTFOUND;
          HTP.PRN ('<option value="' || L_CODE || '">' || L_DESCR || '</option>');
        END LOOP;
        CLOSE C_REF;
      HTP.PRN ('</select>');

END BUILD_LOV_1;



PROCEDURE GRI0200( PI_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE )
IS
   CURSOR C_PARAMS ( C_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE )
   IS
   SELECT *
   FROM GRI_MODULE_PARAMS
       ,GRI_PARAMS
   WHERE GMP_MODULE = C_MODULE
     AND GP_PARAM = GMP_PARAM
   ORDER BY GMP_SEQ ;

   L_QUERY VARCHAR2(4000);
   L_ATTRIBUTES VARCHAR2(4000);
   L_DEP_PARAM_COUNT NUMBER;
   L_INDEP_PARAM_COUNT NUMBER;
   L_PARAM_COUNT NUMBER;

   VID NUMBER;
   
   L_ITEM_DEP IM_FRAMEWORK_TYPES.ITEM_TAB_TYPE;
   L_DEP_PARAMS IM_FRAMEWORK_TYPES.ITEM_TAB_TYPE;
   L_MULTIPLE_DEP_PARAMS NUMBER := 0;
   L_SHOW_NULL VARCHAR2(3);
   L_DEFAULT_DATE DATE := SYSDATE;   

BEGIN
    IM_FRAMEWORK.GET_PARAMS(PI_MODULE);
NM_DEBUG.DEBUG_ON;










    

    
    HTP.P('<table border=0');
    HTP.TABLEROWOPEN;
    HTP.P('<td width=350px align=left><H1>Parameters for ' ||PI_MODULE ||'</H1></td>');
    
    
    HTP.P('<td ><a id="runreport" href="javascript:runReport('''||PI_MODULE||''','''||  0 || ''')">Run</a></td>');
    HTP.P('<td ><a id="reporthelp" href="javascript:showHelp('''||PI_MODULE||''');">Help</a></td>');
HTP.P('<script language="Javascript" > $("#runreport, #reporthelp").button();</script>');
    
    HTP.TABLEROWCLOSE;
    HTP.TABLECLOSE;
    HTP.TABLEOPEN;
    VID := 0;
    FOR PREC IN C_PARAMS(PI_MODULE)
     LOOP
       VID := VID + 1;
       HTP.TABLEROWOPEN;
       IF PREC.GMP_MANDATORY != 'Y' THEN 
         L_SHOW_NULL := 'YES';
         HTP.TABLEDATA(CVALUE => PREC.GMP_PARAM_DESCR
                      ,CALIGN => 'right');
       ELSE
         L_SHOW_NULL := 'NO';
         HTP.TABLEDATA(CVALUE => PREC.GMP_PARAM_DESCR||'*'
                      ,CALIGN => 'right');
       END IF;

       HTP.TABLEDATA(CVALUE =>  CHR(38)||'nbsp');
       IF PREC.GP_PARAM_TYPE != 'DATE' THEN
       
       L_DEP_PARAM_COUNT := IM_FRAMEWORK.IS_PARAM_DEPENDENT(PI_MODULE,PREC.GMP_PARAM);
       IF L_DEP_PARAM_COUNT>0 THEN
         L_MULTIPLE_DEP_PARAMS := 0;
         
         IM_FRAMEWORK.GET_PARAM_DEPENDENCIES(PI_MODULE,PREC.GMP_PARAM);
         









       END IF;

       L_INDEP_PARAM_COUNT := IM_FRAMEWORK.IS_PARAM_INDEPENDENT(PI_MODULE,PREC.GMP_PARAM);
       IF L_INDEP_PARAM_COUNT>0 THEN
         
         IM_FRAMEWORK.GET_PARAM_INDEPENDENCIES(PI_MODULE,PREC.GMP_PARAM);
         FOR I IN 1..G_INDEP_PARAMS.COUNT LOOP
           







           FOR J IN 1..G_INDEP_PARAMS.COUNT LOOP
             SELECT COUNT(1)
             INTO L_MULTIPLE_DEP_PARAMS
             FROM GRI_PARAM_DEPENDENCIES
             WHERE GPD_MODULE = PI_MODULE
             AND ((GPD_INDEP_PARAM = G_INDEP_PARAMS(I).GPD_DEP_PARAM
                   AND GPD_DEP_PARAM = G_INDEP_PARAMS(J).GPD_DEP_PARAM)
                   OR
                  (GPD_INDEP_PARAM = G_INDEP_PARAMS(J).GPD_DEP_PARAM
                   AND GPD_DEP_PARAM = G_INDEP_PARAMS(I).GPD_DEP_PARAM));

             IF L_MULTIPLE_DEP_PARAMS > 0 THEN
               EXIT;
             END IF;

           END LOOP;
         END LOOP;
       END IF;

       L_ATTRIBUTES := ' class=gri_params  ';
       IF L_DEP_PARAM_COUNT = 0 AND L_MULTIPLE_DEP_PARAMS > 0 THEN 

         L_ATTRIBUTES := L_ATTRIBUTES || 'onchange="';
         FOR I IN 1..G_INDEP_PARAMS.COUNT LOOP
             L_ATTRIBUTES := L_ATTRIBUTES || 'get_select_list_xml_dep(this,'''||G_INDEP_PARAMS(I).GPD_DEP_PARAM||''',''GRI0200LOV'',''GRIRESULTITEM'','''||G_INDEP_PARAMS(I).GMP_SEQ||''','''||G_INDEP_PARAMS(I).GPD_INDEP_PARAM||''');';
         END LOOP;
        L_ATTRIBUTES := L_ATTRIBUTES || '"';

       ELSIF L_DEP_PARAM_COUNT = 0 AND L_INDEP_PARAM_COUNT > 0 AND L_MULTIPLE_DEP_PARAMS = 0 THEN  
         L_ATTRIBUTES := L_ATTRIBUTES || 'onchange="';
         FOR I IN 1..G_INDEP_PARAMS.COUNT LOOP

           IF G_INDEP_PARAMS(I).GPD_DEP_PARAM NOT IN ('ROAD_ID','ENQUIRY_REF') THEN
             L_ATTRIBUTES := L_ATTRIBUTES || 'get_select_list_xml_dep(this,'''||G_INDEP_PARAMS(I).GPD_DEP_PARAM||''',''GRI0200LOV'',''GRIRESULTITEM'','''||PREC.GMP_SEQ||''','''||G_INDEP_PARAMS(I).GPD_INDEP_PARAM||''');';       
           END IF;  
         END LOOP;  

         IF LENGTH(SUBSTR(L_ATTRIBUTES,INSTR(L_ATTRIBUTES,'onchange='),LENGTH(L_ATTRIBUTES))) < 11 THEN
           L_ATTRIBUTES := SUBSTR(L_ATTRIBUTES,1,INSTR(L_ATTRIBUTES,'onchange=')-1);
         ELSE          
           L_ATTRIBUTES := L_ATTRIBUTES || '"';
         END IF;

       ELSIF L_DEP_PARAM_COUNT = 1 AND L_INDEP_PARAM_COUNT = 1 AND L_MULTIPLE_DEP_PARAMS < 1 THEN 

         L_ATTRIBUTES := L_ATTRIBUTES || 'onchange="';
         FOR I IN 1..G_INDEP_PARAMS.COUNT LOOP
           L_ATTRIBUTES := L_ATTRIBUTES || 'get_select_list_xml_dep(this,'''||G_INDEP_PARAMS(I).GPD_DEP_PARAM||''',''GRI0200LOV'',''GRIRESULTITEM'','''||PREC.GMP_SEQ||''','''||G_INDEP_PARAMS(I).GPD_INDEP_PARAM||'''); ';
         END LOOP;
         L_ATTRIBUTES := L_ATTRIBUTES || '"';
       ELSIF L_DEP_PARAM_COUNT = 1 AND L_INDEP_PARAM_COUNT = 0 AND L_MULTIPLE_DEP_PARAMS < 1 THEN 
         NULL;
       END IF;
       END IF;

       IF PREC.GP_PARAM_TYPE = 'DATE'
        THEN
           
           IF INSTR(PREC.GMP_PARAM,'FROM') > 0
            THEN
             L_DEFAULT_DATE := '01-JAN-1900';
            ELSE
             L_DEFAULT_DATE := SYSDATE;
           END IF;
           
           L_ATTRIBUTES := ' class=gri_fields  ';
           HTP.TABLEDATA(HTMLDB_ITEM.DATE_POPUP( P_IDX         => VID
                                                ,P_ROW         => NULL
                                                ,P_VALUE       => L_DEFAULT_DATE
                                                ,P_DATE_FORMAT => 'DD-MON-YYYY'
                                                ,P_SIZE        => NULL
                                                ,P_MAXLENGTH   => 2000
                                                ,P_ATTRIBUTES  => L_ATTRIBUTES
                                                ,P_ITEM_ID     => PREC.GMP_PARAM
                                                ,P_ITEM_LABEL  => PREC.GMP_PARAM
                                                ,P_DISPLAY_AS  => NULL));
       ELSIF PREC.GMP_PARAM IN ('WORKS_ORDER_NO','DOC_ID','ENQUIRY_REF')
        THEN
          IF L_SHOW_NULL = 'YES' THEN
            L_ATTRIBUTES := ' class=gri_fields  ';
          ELSIF L_SHOW_NULL = 'NO' THEN
            L_ATTRIBUTES := ' class=griRequied  ';
          END IF;
          L_ATTRIBUTES := L_ATTRIBUTES||' onblur="ValidateGRIText( '''||PREC.GMP_MODULE||''','''||PREC.GMP_PARAM||''',this);"';
          NM_DEBUG.DEBUG_ON;
          NM_DEBUG.DEBUG('stu1) l_attributes - '||L_ATTRIBUTES);
          NM_DEBUG.DEBUG_OFF;
          HTP.TABLEDATA(HTMLDB_ITEM.TEXT(  P_IDX        => VID
                                         , P_VALUE     => NULL
                                         , P_SIZE      => NULL
                                         , P_MAXLENGTH  =>  4000
                                         , P_ATTRIBUTES => L_ATTRIBUTES
                                         , P_ITEM_ID    => PREC.GMP_PARAM
                                         , P_ITEM_LABEL => NULL));                                                
       ELSIF PREC.GMP_LOV = 'Y'
        THEN
          IF L_DEP_PARAM_COUNT > 0 THEN
           















              
              HTP.TABLEDATA(HTMLDB_ITEM.SELECT_LIST( P_IDX => VID,
                            P_VALUE       => NULL,
                            P_LIST_VALUES => NULL,
                            P_ATTRIBUTES  => L_ATTRIBUTES,
                            P_SHOW_NULL   => L_SHOW_NULL,
                            P_NULL_VALUE  => '%null%',
                            P_NULL_TEXT   => '%',
                            P_ITEM_ID     => PREC.GMP_PARAM,
                            P_ITEM_LABEL  => PREC.GMP_PARAM,
                            P_SHOW_EXTRA  => 'YES'));



          ELSE
             L_QUERY := 'select ' || PREC.GP_SHOWN_COLUMN || '||'' ''||' ||
                                             PREC.GP_DESCR_COLUMN ||
                                             ','||PREC.GP_COLUMN ||
                                             ' from ' || PREC.GP_TABLE;
               L_QUERY := L_QUERY || ' where rownum < 100' ;
             IF PREC.GMP_WHERE IS NOT NULL
              THEN
           
                 L_QUERY := L_QUERY || ' and ' ||PREC.GMP_WHERE;
             END IF;

   
             
               
               
             

               
  

             
             
                               










    
             HTP.TABLEDATA(HTMLDB_ITEM.SELECT_LIST_FROM_QUERY_XL( P_IDX         => VID,
                            P_VALUE       => IM_FRAMEWORK.GET_DEFAULT_LOV_VALUE(PI_SELECT => L_QUERY),
                            P_QUERY       => L_QUERY,
                            P_ATTRIBUTES  => L_ATTRIBUTES,
                            P_SHOW_NULL   => L_SHOW_NULL,
                            P_NULL_VALUE  => '%null%',
                            P_NULL_TEXT   => '%',
                            P_ITEM_ID     => PREC.GMP_PARAM,
                            P_ITEM_LABEL  => PREC.GMP_PARAM,
                            P_SHOW_EXTRA  => 'NO'));



          END IF;
       ELSE
          IF L_SHOW_NULL = 'YES' THEN
            L_ATTRIBUTES := ' class=gri_fields  ';
          ELSIF L_SHOW_NULL = 'NO' THEN
            L_ATTRIBUTES := ' class=griRequired  ';
          END IF;
          L_ATTRIBUTES := L_ATTRIBUTES||' onblur="ValidateGRIText( '''||PREC.GMP_MODULE||''','''||PREC.GMP_PARAM||''',this);"';
          NM_DEBUG.DEBUG_ON;
          NM_DEBUG.DEBUG('stu2) l_attributes - '||L_ATTRIBUTES);
          NM_DEBUG.DEBUG_OFF;
          HTP.TABLEDATA(HTMLDB_ITEM.TEXT(  P_IDX        => VID
                                         , P_VALUE     => NULL
                                         , P_SIZE      => NULL
                                         , P_MAXLENGTH  =>  4000
                                         , P_ATTRIBUTES => L_ATTRIBUTES
                                         , P_ITEM_ID    => PREC.GMP_PARAM
                                         , P_ITEM_LABEL => NULL));


       END IF;

       HTP.TABLEROWCLOSE;
    END LOOP;

   
   
END GRI0200;



PROCEDURE VALIDATEGRITEXT ( PI_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                          , PI_PARAM GRI_MODULE_PARAMS.GMP_PARAM%TYPE
                          , PI_VALUE VARCHAR2
                          ) IS

  TYPE C_REF_TYPE IS REF CURSOR;
  C_REF C_REF_TYPE;
  L_DEP_PARAM GRI_PARAM_DEPENDENCIES.GPD_DEP_PARAM%TYPE;
  
  CURSOR GET_TABLE_DETAILS ( P_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                           , P_PARAM GRI_MODULE_PARAMS.GMP_PARAM%TYPE
                           ) IS
  SELECT *
  FROM GRI_MODULE_PARAMS, GRI_PARAMS
  WHERE GMP_MODULE = P_MODULE
    AND GMP_PARAM = GP_PARAM
    AND GMP_PARAM = P_PARAM;

  L_SELECT VARCHAR2(4000);
  L_FOUND NUMBER := 0;
  
BEGIN                                 
NM_DEBUG.DEBUG_ON;
NM_DEBUG.DEBUG(L_FOUND||') '||PI_MODULE||'/'||PI_PARAM||' = '||PI_VALUE);
  FOR C1REC IN GET_TABLE_DETAILS(PI_MODULE, PI_PARAM) LOOP
    L_SELECT := 'select 1 from '||C1REC.GP_TABLE||' where '||C1REC.GP_COLUMN||' = '''||PI_VALUE||''''; 
  END LOOP;
NM_DEBUG.DEBUG(L_FOUND||') '||L_SELECT);  
  OPEN C_REF FOR (L_SELECT);
  LOOP
    FETCH C_REF INTO L_FOUND;  
    EXIT WHEN C_REF%NOTFOUND;
  END LOOP;

NM_DEBUG.DEBUG(L_FOUND||') '||L_SELECT);
NM_DEBUG.DEBUG_OFF;  
  IF L_FOUND > 0 THEN
    HTP.PRN('YES');
  ELSE
    HTP.PRN('NO');
  END IF;
END;      



PROCEDURE SAVE_GRI_PARAMS(PI_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE
                          ,PI_JOB_ID IN OUT NUMBER
                          ,PI_VALS VARCHAR2)
IS
 PRAGMA AUTONOMOUS_TRANSACTION;

 CURSOR C_PARAMS (C_MODULE GRI_MODULE_PARAMS.GMP_MODULE%TYPE)
   IS
   SELECT *
   FROM GRI_MODULE_PARAMS
       ,GRI_PARAMS
   WHERE GMP_MODULE = C_MODULE
     AND GP_PARAM = GMP_PARAM
   ORDER BY GMP_SEQ;

   L_VALS APEX_APPLICATION_GLOBAL.VC_ARR2 := APEX_UTIL.STRING_TO_TABLE(PI_VALS);
   L_VALUE VARCHAR2(1000);

BEGIN
   SELECT RTG_JOB_ID_SEQ.NEXTVAL
   INTO PI_JOB_ID
   FROM DUAL;
   
   INSERT INTO GRI_REPORT_RUNS
              (GRR_JOB_ID
              ,GRR_MODULE
              ,GRR_USERNAME
              ,GRR_SUBMIT_DATE
              )
   VALUES     (
               PI_JOB_ID
              ,PI_MODULE
              ,USER
              ,TRUNC(SYSDATE)
              );
      
   

   FOR CREC IN C_PARAMS(PI_MODULE)
    LOOP
        L_VALUE := L_VALS(CREC.GMP_SEQ);
        INSERT INTO GRI_RUN_PARAMETERS
                       (GRP_JOB_ID
                       ,GRP_SEQ
                       ,GRP_PARAM
                       ,GRP_VALUE
                       ,GRP_VISIBLE
                       ,GRP_DESCR
                       ,GRP_SHOWN)
            VALUES     (PI_JOB_ID
                       ,CREC.GMP_SEQ
                       ,CREC.GMP_PARAM
                       ,DECODE(L_VALUE,'%null%', '%',L_VALUE)
                       ,'Y'
                       ,CREC.GMP_PARAM_DESCR
                       ,CREC.GMP_VISIBLE
                       );
           COMMIT;            
   END LOOP;
   COMMIT;

END SAVE_GRI_PARAMS;



FUNCTION GET_COOKIE_VALUE(PI_NAME VARCHAR2)
RETURN VARCHAR2
IS
  L_COOKIE OWA_COOKIE.COOKIE;
  







BEGIN
  L_COOKIE := OWA_COOKIE.GET( NAME=>PI_NAME);
   RETURN L_COOKIE.VALS(1);
END GET_COOKIE_VALUE;



FUNCTION GET_REPORT_URL
            ( P_JOB_ID    IN NUMBER
            , P_FILENAME  IN VARCHAR2
            , P_PARAMFLAG IN BOOLEAN := FALSE
            , P_USERNAME  IN VARCHAR2
            , P_PASSWORD  IN VARCHAR2
            , P_DATABASE  IN VARCHAR2
            )
RETURN VARCHAR2
IS

  L_UN  VARCHAR2(30) := P_USERNAME ; 
  L_PW  VARCHAR2(30) := P_PASSWORD ; 
  L_CS  VARCHAR2(30) := P_DATABASE ; 


  L_URL VARCHAR2(2000) ;

  L_REPSERVER VARCHAR2(2000) ;

  RTRN VARCHAR2(4000);

  FUNCTION ENCODE64 ( P IN VARCHAR2 ) RETURN VARCHAR2
  IS
  L_O VARCHAR2(200);
  L_A VARCHAR2(10);
  L_B VARCHAR2(10);
  BEGIN

              FOR I IN 1..LENGTH(P) LOOP
                L_A := LTRIM(TO_CHAR(TRUNC(ASCII(SUBSTR(P,I,1))/16)));
                IF L_A = '10' THEN L_A := 'A';
                ELSIF L_A = '11' THEN L_A := 'B';
                ELSIF L_A = '12' THEN L_A := 'C';
                ELSIF L_A = '13' THEN L_A := 'D';
                ELSIF L_A = '14' THEN L_A := 'E';
                ELSIF L_A = '15' THEN L_A := 'F';
                END IF;
                L_B := LTRIM(TO_CHAR(MOD(ASCII(SUBSTR(P,I,1)),16)));
                IF L_B = '10' THEN L_B := 'A';
                ELSIF L_B = '11' THEN L_B := 'B';
                ELSIF L_B = '12' THEN L_B := 'C';
                ELSIF L_B = '13' THEN L_B := 'D';
                ELSIF L_B = '14' THEN L_B := 'E';
                ELSIF L_B = '15' THEN L_B := 'F';
                END IF;
                L_O := L_O||'%'||L_A||L_B;
              END LOOP;
             

     RETURN P;
  END ENCODE64 ;
BEGIN
    L_REPSERVER := HIG.GET_SYSOPT('REPURL');
    IF L_REPSERVER IS NOT NULL
    THEN
        L_URL :=
        ENCODE64('report=' || NM3GET.GET_HMO (PI_HMO_MODULE =>P_FILENAME).HMO_FILENAME) ||
         CHR(38) ||
        ENCODE64('job_id=' ||P_JOB_ID) ||
         CHR(38) || ENCODE64( 'userid=' || L_UN || '/' || L_PW || '@' || L_CS ) ||
         CHR(38) || ENCODE64( 'destype=cache' ) ||  CHR(38) || ENCODE64( 'desformat=pdf' )
        ;
        
        IF P_PARAMFLAG
        THEN
           L_URL := L_URL ||  CHR(38) || ENCODE64( 'paramform=Y' ) ;
        END IF ;
        
        RTRN := L_REPSERVER|| CHR(38)||L_URL;
    END IF ;
    RETURN RTRN;
END ;



PROCEDURE GETFOITHEMES
IS
BEGIN
   OWA_UTIL.MIME_HEADER ('text/xml', FALSE);
   HTP.P ('Cache-Control: no-cache');
   HTP.P ('Pragma: no-cache');
   OWA_UTIL.HTTP_HEADER_CLOSE;
   HTP.PRN ('<RECORDS>');

   FOR C IN ( SELECT IFT_NTH_THEME_NAME PARAM_NAME
                    ,IFT_DEFAULT_STATE ONOFF
                    ,IFT_MINVISIBLEZOOMLEVEL
                    ,IFT_MAXVISIBLEZOOMLEVEL                    
              FROM IM_FOI_THEMES
              ORDER BY IFT_SEQ
            )
   LOOP
      HTP.PRN ('<THEME_NAME value="' || C.PARAM_NAME   || '"></THEME_NAME>');
      HTP.PRN ('<ONOFF value="' || C.ONOFF   || '"></ONOFF>');
      HTP.PRN ('<MINVISIBLEZOOMLEVEL value="' || C.IFT_MINVISIBLEZOOMLEVEL   || '"></MINVISIBLEZOOMLEVEL>');
      HTP.PRN ('<MAXVISIBLEZOOMLEVEL value="' || C.IFT_MAXVISIBLEZOOMLEVEL   || '"></MAXVISIBLEZOOMLEVEL>');
   END LOOP;

   HTP.PRN ('</RECORDS>');
END;



PROCEDURE GET_MAP_LAYER_TOOL(PLEGENDTYPE VARCHAR2 DEFAULT NULL)
IS
   L_IMAGE_URL VARCHAR2(100);
   L_BASE_URL  VARCHAR2(100);
   L_DATA_SOURCE VARCHAR2(20);

   L_HTML VARCHAR2(4000);
   L_THEME_DETAILS NM3LAYER_TOOL.TAB_MSV_THEME_DETAILS;

   L_W NUMBER := 50;
   L_H NUMBER := 30;
   
   L_ONOFF VARCHAR2(100);


BEGIN

   L_DATA_SOURCE := HIG.GET_USER_OR_SYS_OPT('DATASOURCE');
   L_BASE_URL    := HIG.GET_USER_OR_SYS_OPT('BASEURL');
   L_IMAGE_URL   := HIG.GET_USER_OR_SYS_OPT('IMAGEURL');

   L_HTML := NULL;

   HTP.PRN( '<table bgcolor=white border=0px)>');

   IF PLEGENDTYPE IS NULL
    THEN
    HTP.PRN( '<table bgcolor=white border=1px)>');
    HTP.PRN( '<tr><td class="mapLegendHeader">Map Symbol</td><td class="mapLegendHeader">Map Data</td><td class="mapLegendHeader">Show</td></tr>'     );
   END IF;
   FOR C IN ( SELECT IFT_NTH_THEME_NAME THEME_NAME
                     ,IFT_DEFAULT_STATE ONOFF
              FROM IM_FOI_THEMES
              ORDER BY IFT_SEQ
            )
   LOOP
      NM3LAYER_TOOL.GET_MSV_USTD
              ( PI_THEME_NAME  => C.THEME_NAME
              , PO_RESULTS     => L_THEME_DETAILS );

      IF SUBSTR(L_THEME_DETAILS(0).C_FEATURE_STYLE,1,1) = 'V'
       THEN
         L_H := 200;
      ELSE
          L_H  := 30;
      END IF;
      IF C.ONOFF = 'ON'
       THEN 
         L_ONOFF := ' checked="yes" ';
      ELSE
         L_ONOFF := '  ';
      END IF;
     IF PLEGENDTYPE = 'G14'
      THEN
      
       IF INSTR(C.THEME_NAME,'DISRUPTION') > 0
        THEN
         L_H:=40;
         HTP.PRN( '<td align=center><img src='||L_BASE_URL||'/omserver?sty='||NM3WEB.STRING_TO_URL(L_THEME_DETAILS(0).C_FEATURE_STYLE)||
                               CHR(38)||'w=' ||L_W||CHR(38)||'h='||L_H||CHR(38)||'ds='||
                               L_DATA_SOURCE||'></td><td align=left>'||REPLACE(INITCAP(C.THEME_NAME),'_',' ')||'</td>'||
                               '<td align=center><input type="checkbox" name="'||C.THEME_NAME ||'" value="'||
                               C.THEME_NAME|| L_ONOFF ||'" onclick="setVisibleFOI(this)" id="'||C.THEME_NAME ||'" /></td>'
                              );
        END IF;

     ELSE
       HTP.PRN( '<tr><td align=center><img src='||L_BASE_URL||'/omserver?sty='||NM3WEB.STRING_TO_URL(L_THEME_DETAILS(0).C_FEATURE_STYLE)||
                            CHR(38)||'w=' ||L_W||CHR(38)||'h='||L_H||CHR(38)||'ds='||
                             L_DATA_SOURCE||'></td><td align=left>'||REPLACE(INITCAP(C.THEME_NAME),'_',' ')||'</td>'||
                             '<td align=center><input type="checkbox"  value="'|| C.THEME_NAME||
                             '"'||L_ONOFF ||' onclick="setVisibleFOI(this)" id="'||REPLACE(C.THEME_NAME,CHR(32),'') ||'" /></td>'||
                             '</tr>');
     END IF ;
   END LOOP;

   HTP.PRN( '</table>');

END GET_MAP_LAYER_TOOL;



PROCEDURE GET_MAP_LEGEND
IS
   L_IMAGE_URL VARCHAR2(100);
   L_BASE_URL  VARCHAR2(100);
   L_DATA_SOURCE VARCHAR2(20);

   L_HTML VARCHAR2(4000);
   L_THEME_DETAILS NM3LAYER_TOOL.TAB_MSV_THEME_DETAILS;

   L_W NUMBER := 50;
   L_H NUMBER := 30;


BEGIN

   L_DATA_SOURCE := HIG.GET_USER_OR_SYS_OPT('DATASOURCE');
   L_BASE_URL    := HIG.GET_USER_OR_SYS_OPT('BASEURL');
   L_IMAGE_URL   := HIG.GET_USER_OR_SYS_OPT('IMAGEURL');

   L_HTML := NULL;

   HTP.PRN( '<table bgcolor=white border=1px)>');

   HTP.PRN( '<tr><td class="mapLegendHeader">Map Symbol</td><td class="mapLegendHeader">Map Data</td></tr>'     );

   FOR C IN ( SELECT IFT_NTH_THEME_NAME THEME_NAME
              FROM IM_FOI_THEMES
            )
   LOOP
      NM3LAYER_TOOL.GET_MSV_USTD
              ( PI_THEME_NAME  => C.THEME_NAME
              , PO_RESULTS     => L_THEME_DETAILS );

      IF SUBSTR(L_THEME_DETAILS(0).C_FEATURE_STYLE,1,1) = 'V'
       THEN
         L_H := 200;
      ELSE
          L_H  := 30;
      END IF;
   HTP.PRN( '<tr><td align=center><img src='||L_BASE_URL||'/omserver?sty='||NM3WEB.STRING_TO_URL(L_THEME_DETAILS(0).C_FEATURE_STYLE)||
                        CHR(38)||'w=' ||L_W||CHR(38)||'h='||L_H||CHR(38)||'ds='||
                         L_DATA_SOURCE||'></td><td align=left>'||REPLACE(INITCAP(C.THEME_NAME),'_',' ')||'</td>'||
                         '</tr>');
  END LOOP;

   HTP.PRN( '</table>');

END GET_MAP_LEGEND;



PROCEDURE GET_SHOW_HIDE_REGION_IDS(P_APP_NO NUMBER)
IS

BEGIN
   OWA_UTIL.MIME_HEADER ('text/xml', FALSE);
   HTP.P ('Cache-Control: no-cache');
   HTP.P ('Pragma: no-cache');
   OWA_UTIL.HTTP_HEADER_CLOSE;
   HTP.PRN ('<RECORDS>');

   FOR C IN ( SELECT REGION_ID
              FROM APEX_APPLICATION_PAGE_REGIONS
              WHERE  PAGE_ID = 0
                AND APPLICATION_ID = P_APP_NO
                AND TEMPLATE = 'Hide and Show Region'
            )
   LOOP
      HTP.PRN ('<REGION_ID value="' || C.REGION_ID   || '"></REGION_ID>');

   END LOOP;

   HTP.PRN ('</RECORDS>');
END GET_SHOW_HIDE_REGION_IDS;




PROCEDURE GET_MAP_VARIABLES
IS
BEGIN
   OWA_UTIL.MIME_HEADER ('text/xml', FALSE);
   HTP.P ('Cache-Control: no-cache');
   HTP.P ('Pragma: no-cache');
   OWA_UTIL.HTTP_HEADER_CLOSE;
   HTP.PRN ('<RECORDS>');

   FOR C IN ( SELECT HOV_ID PARAM_NAME
                   , HOV_VALUE PARAM_VALUE
                FROM HIG_OPTION_VALUES
                    ,HIG_OPTION_LIST
               WHERE HOL_PRODUCT = 'IM'
                 AND HOL_ID = HOV_ID
            )
   LOOP
      HTP.PRN ('<PARAM_NAME value="' || C.PARAM_NAME   || '"></PARAM_NAME>');
      HTP.PRN ('<PARAM_VALUE value="' || DBMS_XMLGEN.CONVERT(C.PARAM_VALUE) || '"></PARAM_VALUE>');
   END LOOP;

   HTP.PRN ('</RECORDS>');
END GET_MAP_VARIABLES;



PROCEDURE GETMAPCALLOUT( PI_ID NUMBER DEFAULT NULL
                        ,PI_THEME_NAME VARCHAR2 DEFAULT NULL
                        ,PI_APP_ID NUMBER DEFAULT NULL
                        ,PI_SESSION NUMBER DEFAULT NULL)
IS
   L_SQL VARCHAR2(4000);
   L_DETAIL_SQL VARCHAR2(4000);
   L_VALUES VARCHAR2(1000);
   L_NTH_REC NM_THEMES_ALL%ROWTYPE;
   L_VAL_ARR WWV_FLOW_GLOBAL.VC_ARR2;
   L_CNT NUMBER ;
   L_IMAGE_URL VARCHAR2(100);
   L_BASE_URL  VARCHAR2(100);
   L_DATA_SOURCE VARCHAR2(20);

   L_HTML VARCHAR2(4000);
   L_THEME_DETAILS NM3LAYER_TOOL.TAB_MSV_THEME_DETAILS;

   E_NULL_PARAMS EXCEPTION;   
   
   L_IFT_REC IM_FOI_THEMES%ROWTYPE;

BEGIN 
   IF PI_ID IS NULL OR PI_THEME_NAME IS NULL
    THEN 
      RAISE E_NULL_PARAMS;
   END IF;
   FOR VREC IN ( SELECT * FROM NM_THEMES_ALL WHERE NTH_THEME_NAME = PI_THEME_NAME)
    LOOP
       L_NTH_REC := VREC;
   END LOOP;
   
   FOR VREC IN ( SELECT * FROM IM_FOI_THEMES WHERE IFT_NTH_THEME_NAME = PI_THEME_NAME)
    LOOP
       L_IFT_REC := VREC;
   END LOOP;
   
   
   L_SQL := 'select ';
   FOR VREC IN (SELECT IFTC_COLUMN_NAME FROM IM_FOI_THEME_COLS WHERE IFTC_NTH_THEME_ID = L_NTH_REC.NTH_THEME_ID ORDER BY IFTC_SEQ)
    LOOP
      L_SQL := L_SQL || VREC.IFTC_COLUMN_NAME || '||'':''||';
   END LOOP;
   L_SQL := SUBSTR(L_SQL,1,LENGTH(L_SQL)-7);
   
   L_SQL := L_SQL || ' from ' || L_NTH_REC.NTH_TABLE_NAME || ' ' ;
   L_SQL := L_SQL || ' where ' || L_NTH_REC.NTH_PK_COLUMN ||  ' = ' || PI_ID;
   
   L_DETAIL_SQL := 'select * from ' || L_NTH_REC.NTH_TABLE_NAME || ' '|| ' where ' || L_NTH_REC.NTH_PK_COLUMN ||  ' = ' || PI_ID;
   
   EXECUTE IMMEDIATE L_SQL INTO L_VALUES;
   L_VAL_ARR := APEX_UTIL.STRING_TO_TABLE(L_VALUES);
 
   L_CNT := 1;
   L_DATA_SOURCE := HIG.GET_USER_OR_SYS_OPT('DATASOURCE');
   L_BASE_URL    := HIG.GET_USER_OR_SYS_OPT('BASEURL');
   L_IMAGE_URL   := HIG.GET_USER_OR_SYS_OPT('IMAGEURL');

    HTP.PRN( '<table bgcolor=white border=0>');
    
      NM3LAYER_TOOL.GET_MSV_USTD
              ( PI_THEME_NAME  => L_NTH_REC.NTH_THEME_NAME
              , PO_RESULTS     => L_THEME_DETAILS );
      HTP.PRN('<tr><td valign=middle align=center><img src='||L_BASE_URL||'/omserver?sty='||NM3WEB.STRING_TO_URL(L_THEME_DETAILS(0).C_FEATURE_STYLE)||CHR(38)||'w=20'||CHR(38)||'h=20'||CHR(38)||'ds='||
                         L_DATA_SOURCE||'></td><td class="headerCell_map"  align=left>'||REPLACE(INITCAP(L_NTH_REC.NTH_THEME_NAME),'_',' ')||'</td>'||
                         '</tr>');
    HTP.PRN('</table>');
    
    HTP.PRN('<div class="listwrapper">');
    HTP.PRN( '<table bgcolor=white border=0 >');
   
   FOR C_REC IN ( SELECT IFTC_SCREEN_TEXT FROM IM_FOI_THEME_COLS WHERE IFTC_NTH_THEME_ID = L_NTH_REC.NTH_THEME_ID ORDER BY IFTC_SEQ)
    LOOP
       DBMS_OUTPUT.PUT_LINE(C_REC.IFTC_SCREEN_TEXT || ' : ' || L_VAL_ARR(L_CNT));
       HTP.PRN( '<tr>'||
                          '<td valign=top width=40% class="mapText" >' ||C_REC.IFTC_SCREEN_TEXT ||' : </td>'||
                          '<td align=left valign=top width=60% class="mapText">'||L_VAL_ARR(L_CNT)||'</td>'||
                         '</tr>'); 
       L_CNT := L_CNT+1;
   END LOOP;
   HTP.PRN( '</table>');
   HTP.PRN('</div>');

   
   HTP.PRN( '<table bgcolor=white border=0px style="empty-cells: show")>');

            HTP.PRN( '<tr>'||
                          '<td ></td>'||
                          '<td ></td>'||
                         '</tr>');

   HTP.PRN( '<tr>'||'<td ><a class="mapDetailLinks" href="javascript:showMapMoreDetailsContent('|| PI_ID||','||L_NTH_REC.NTH_THEME_ID||')">More Details</a></td>');

   IF HAS_DOC(PI_ID) = 1
    THEN
      HTP.PRN('<td ><a class="mapDetailLinks" href="javascript:showDocAssocsWT('||PI_ID||','||PI_APP_ID||','||PI_SESSION||','''||L_IFT_REC.IFT_DAS_TABLE_NAME||''')" >Documents</a></td>');
   ELSE
      HTP.PRN( '<td>Documents</td>');
      NULL;
   END IF;
   HTP.PRN( '</tr>');

   HTP.PRN( '</table>');   
   
   
   EXCEPTION
      WHEN OTHERS THEN 
      HTP.PRN('Theme details not entered in mapbuilder<br>');
      HTP.PRN(' Theme, Advanced Parameters<br>');
      HTP.PRN('Requires PK col as value<br>');
      HTP.PRN('and theme name<br>'||L_SQL);
   
END GETMAPCALLOUT;



PROCEDURE MOREMAPDETAILS(PI_ID VARCHAR2, PI_THEME_ID VARCHAR2)
IS
   L_ATTRIB_NAME NM3TYPE.TAB_VARCHAR80;
   L_SCRN_TEXT   NM3TYPE.TAB_VARCHAR80;
   L_DATA        VARCHAR(2000);
   L_SQL VARCHAR2(4000);
   L_NTH_REC NM_THEMES_ALL%ROWTYPE;
   V_CUR NM3TYPE.REF_CURSOR;
   L_CNT NUMBER;
   L_NIT_REC NM_INV_TYPES%ROWTYPE;
   L_REC_CNT NUMBER;
BEGIN 
   SELECT *
   INTO L_NTH_REC
   FROM NM_THEMES_ALL
   WHERE NTH_THEME_ID = PI_THEME_ID;
   
   select count(*) into L_REC_CNT FROM  NM_INV_THEMES WHERE NITH_NTH_THEME_ID = PI_THEME_ID and rownum <5;

  if l_rec_cnt > 0
  then

   SELECT * 
   INTO L_NIT_REC
   FROM NM_INV_TYPES
   WHERE NIT_INV_TYPE = ( SELECT NITH_NIT_ID FROM NM_INV_THEMES WHERE NITH_NTH_THEME_ID = PI_THEME_ID);
  
   IF L_NIT_REC.NIT_TABLE_NAME IS NULL
    THEN 
      SELECT ITA_VIEW_COL_NAME
           , REPLACE(UPPER(TRIM(ITA_SCRN_TEXT)),CHR(32),'_')
      BULK COLLECT INTO   L_ATTRIB_NAME, L_SCRN_TEXT   
      FROM NM_INV_TYPE_ATTRIBS
      WHERE ITA_INV_TYPE = ( SELECT NITH_NIT_ID FROM NM_INV_THEMES WHERE NITH_NTH_THEME_ID = PI_THEME_ID)
      AND ITA_END_DATE IS NULL
      ORDER BY ITA_DISP_SEQ_NO;
   ELSE
      SELECT ITA_ATTRIB_NAME
           , REPLACE(UPPER(TRIM(ITA_SCRN_TEXT)),CHR(32),'_')
      BULK COLLECT INTO   L_ATTRIB_NAME, L_SCRN_TEXT   
      FROM NM_INV_TYPE_ATTRIBS
      WHERE ITA_INV_TYPE = ( SELECT NITH_NIT_ID FROM NM_INV_THEMES WHERE NITH_NTH_THEME_ID = PI_THEME_ID)
      AND ITA_END_DATE IS NULL
      ORDER BY ITA_DISP_SEQ_NO;

   END IF;
   
   L_SQL := 'SELECT ';
   FOR I IN 1..L_ATTRIB_NAME.COUNT
    LOOP
      L_SQL := L_SQL || L_ATTRIB_NAME(I)||' "'|| L_SCRN_TEXT(I) || '",';
   END LOOP;
  
   L_SQL := SUBSTR(L_SQL,1,LENGTH(L_SQL)-1);
   IF L_NIT_REC.NIT_TABLE_NAME IS NULL
    THEN 
      L_SQL := L_SQL || ' from ' || L_NIT_REC.NIT_VIEW_NAME || ' ' ;
      L_SQL := L_SQL || ' where ' || L_NTH_REC.NTH_PK_COLUMN ||  ' = ' || PI_ID;
   ELSE
      L_SQL := L_SQL || ' from ' || L_NIT_REC.NIT_TABLE_NAME || ' ' ;
      L_SQL := L_SQL || ' where ' || L_NIT_REC.NIT_FOREIGN_PK_COLUMN ||  ' = ' || PI_ID;
   END IF;
   
   
 end if;
 
 l_rec_cnt := 0;
  
  select count(*) into L_REC_CNT FROM  NM_NW_THEMES WHERE NNTH_NTH_THEME_ID = PI_THEME_ID;-- and rownum <5

 if l_rec_cnt > 0
 then


        L_SQL := ' select  * from nm_elements where ne_id ='  || PI_ID;


  end if;
  
   
   HTP.PRN(DM3QUERY.EXECUTE_QUERY_SQL(L_SQL));
   
   EXCEPTION WHEN OTHERS THEN 
      
      HTP.PRN('<B> Error trying to get more details<b><br>Sql statement is :<br>');
      HTP.PRN(L_SQL);
 
END MOREMAPDETAILS;




PROCEDURE GETMAPITEMDETAILS(PI_ID NUMBER DEFAULT NULL
                           ,PI_APP_ID NUMBER DEFAULT NULL
                           ,PI_SESSION NUMBER DEFAULT NULL)
IS
   CURSOR C_GET_ENQ(C_DOC_ID DOCS.DOC_ID%TYPE)
   IS
   SELECT *
   FROM DOCS
   WHERE DOC_ID = C_DOC_ID;

   L_DOC_REC DOCS%ROWTYPE;

   L_IMAGE_URL VARCHAR2(100);
   L_BASE_URL  VARCHAR2(100);
   L_DATA_SOURCE VARCHAR2(20);

   L_HTML VARCHAR2(4000);
   L_THEME_DETAILS NM3LAYER_TOOL.TAB_MSV_THEME_DETAILS;

   L_TYPE  VARCHAR2(60);

BEGIN
   L_TYPE := NULL;

   OPEN C_GET_ENQ(PI_ID);
   FETCH C_GET_ENQ INTO L_DOC_REC;
   IF C_GET_ENQ%FOUND
    THEN
      CLOSE C_GET_ENQ;
      L_TYPE := 'ENQUIRIES';
   ELSE
      CLOSE C_GET_ENQ;
   END IF;

   IF L_TYPE IS NOT NULL
    THEN
   L_DATA_SOURCE := HIG.GET_USER_OR_SYS_OPT('DATASOURCE');
   L_BASE_URL    := HIG.GET_USER_OR_SYS_OPT('BASEURL');
   L_IMAGE_URL   := HIG.GET_USER_OR_SYS_OPT('IMAGEURL');

   L_HTML := NULL;

    L_HTML := L_HTML || '<table bgcolor=white border=0>';

    FOR C IN ( SELECT IFT_NTH_THEME_NAME THEME_NAME
              FROM IM_FOI_THEMES
              WHERE IFT_NTH_THEME_NAME = L_TYPE
            )
    LOOP
      NM3LAYER_TOOL.GET_MSV_USTD
              ( PI_THEME_NAME  => C.THEME_NAME
              , PO_RESULTS     => L_THEME_DETAILS );
      L_HTML := L_HTML || '<tr><td valign=middle align=center><img src='||L_BASE_URL||'/omserver?sty='||NM3WEB.STRING_TO_URL(L_THEME_DETAILS(0).C_FEATURE_STYLE)||CHR(38)||'w=20'||CHR(38)||'h=20'||CHR(38)||'ds='||
                         L_DATA_SOURCE||'></td><td class="headerCell_map"  align=left>'||REPLACE(INITCAP(C.THEME_NAME),'_',' ')||'</td>'||
                         '</tr>';
    END LOOP;
    L_HTML := L_HTML || '</table>';
    L_HTML := L_HTML || '<table bgcolor=white border=0)>';
    L_HTML := L_HTML || '<tr>'||
                          '<td valign=top >Reference: </td>'||
                          '<td align=left>'||L_DOC_REC.DOC_ID||'</td>'||
                         '</tr>';

     L_HTML := L_HTML || '<tr>'||
                          '<td valign=top >Description:</td>'||
                          '<td align=left width=150px class="mapText" >'||TRIM(L_DOC_REC.DOC_DESCR)||'</td>'||
                          
                         '</tr>';

     L_HTML := L_HTML || '<tr>'||
                          '<td valign=top >Location:</td>'||
                          '<td align=left width=150px class="mapText">'||TRIM(L_DOC_REC.DOC_COMPL_LOCATION)||'</td>'||
                          
                         '</tr>';

   L_HTML := L_HTML || '</table>';
   L_HTML := L_HTML || '<table bgcolor=white border=0px style="empty-cells: show")>';

            L_HTML := L_HTML || '<tr>'||
                          '<td ></td>'||
                          '<td ></td>'||
                         '</tr>';
        L_HTML := L_HTML || '<tr>'||
                          '<td ><a class="mapDetailLinks" href="javascript:showEnqDetails('||L_DOC_REC.DOC_ID||','||PI_APP_ID||','||PI_SESSION||')">More Details</a></td>';

   IF HAS_DOC(L_DOC_REC.DOC_ID) = 1
    THEN
      L_HTML := L_HTML || '<td ><a class="mapDetailLinks" href="javascript:showDocAssocsWT('||L_DOC_REC.DOC_ID||','||PI_APP_ID||','||PI_SESSION||',''DOCS2VIEW'')" >Documents</a></td>';
   ELSE
      
      NULL;
   END IF;
   L_HTML := L_HTML || '</tr>';



   L_HTML := L_HTML || '</table>';

   END IF;

   HTP.PRN (L_HTML);

END GETMAPITEMDETAILS ;




PROCEDURE GET_HELP_URL(PI_MODULE VARCHAR2)
IS
BEGIN
   HTP.P(HIG_WEB_CONTEXT_HELP.GET_HTML(PI_MODULE,PI_MODULE));
END GET_HELP_URL;



PROCEDURE NET_OR_NSG(PI_NE_UNIQUE NM_ELEMENTS_ALL.NE_UNIQUE%TYPE)
IS
   CURSOR C1 (C_UNIQUE NM_ELEMENTS.NE_UNIQUE%TYPE)
   IS
   SELECT *
   FROM NM_ELEMENTS
   WHERE NE_UNIQUE = (C_UNIQUE);

   L_NE_REC NM_ELEMENTS%ROWTYPE;
   L_RTRN VARCHAR(100);
BEGIN
   L_RTRN := 'IM_NETWORK';
   OPEN C1(PI_NE_UNIQUE);
   FETCH C1 INTO L_NE_REC;
   IF C1%NOTFOUND
    THEN
      L_RTRN := 'IM_TYPE_1_AND_2_STREETS';
   END IF;
   CLOSE C1;
   OWA_UTIL.MIME_HEADER('text/xml',FALSE);
  HTP.P('Cache-Control: no-cache');
  HTP.P('Pragma: no-cache');
  OWA_UTIL.HTTP_HEADER_CLOSE;
  HTP.PRN('<RECORDS>');
   HTP.P('<DATA value="'||L_RTRN||'"></DATA>');
    HTP.PRN('</RECORDS>');

END NET_OR_NSG;



PROCEDURE GETMAPITEMNETDETAILS(PI_ID VARCHAR2 DEFAULT NULL
                           ,PI_APP_ID NUMBER DEFAULT NULL
                           ,PI_SESSION NUMBER DEFAULT NULL)
IS
   CURSOR C_GET_NE(C_NE_ID NM_ELEMENTS.NE_UNIQUE%TYPE)
   IS
   SELECT *
   FROM IM_FRAME_NET_SELECT
   WHERE NE_UNIQUE = C_NE_ID;

   L_NE_REC IM_FRAME_NET_SELECT%ROWTYPE;


   L_HTML VARCHAR2(4000);

BEGIN

   OPEN C_GET_NE(PI_ID);
   FETCH C_GET_NE INTO L_NE_REC;
   CLOSE C_GET_NE;

   L_HTML := NULL;

   L_HTML := L_HTML || '<table bgcolor=white border=0 style="empty-cells: show")>';
   L_HTML := L_HTML || '<tr>'||
                       '<td colspan="2" class="headerCell_map" >Location Details</td>'||
                       '</tr>';

            L_HTML := L_HTML || '<tr>'||
                          '<td ></td>'||
                          '<td ></td>'||
                         '</tr>';
  IF L_NE_REC.NET_TYPE = 'NSGN'
   THEN
   L_HTML := L_HTML || '<tr>'||
                       '<td valign=top >USRN: </td>'||
                       '<td align=left>'||L_NE_REC.NE_UNIQUE||'</td>'||
                       '</tr>';
  ELSE
   L_HTML := L_HTML || '<tr>'||
                       '<td valign=top >Unique: </td>'||
                       '<td align=left>'||L_NE_REC.NE_UNIQUE||'</td>'||
                       '</tr>';
  END IF;

    L_HTML := L_HTML || '<tr>'||
                        '<td valign=top >Street: </td>'||
                        '<td align=left>'||L_NE_REC.NE_DESCR||'</td>'||
                        '</tr>';

    L_HTML := L_HTML || '<tr>'||
                        '<td valign=top >Group: </td>'||
                        '<td align=left>'||L_NE_REC.GROUP_DESCR||'</td>'||
                        '</tr>';


   L_HTML := L_HTML || '</table>';

   HTP.PRN (L_HTML);

END GETMAPITEMNETDETAILS ;



PROCEDURE SHOW_ROADWORK_LEGEND
IS
   L_HTML VARCHAR2(2000);
BEGIN
   L_HTML := NULL;
   L_HTML := L_HTML || '<table  border=0 style="empty-cells: show") class="roadworkLegend">';
   L_HTML := L_HTML || '<tr>'||
                       '<td>'||
                       '<img src="/im4_framework/RWSignLow.gif" border=0 alt="Roadwork" align="absbottom"></img>Minimal impact - delays possible'||
                       '</td>'||
                       '<td>'||
                       '<img src="/im4_framework/RWSignMed.gif" border=0 alt="Roadwork" align="absbottom"></img><span>Slight impact - delays possible    </span>'||
                       '</td>'||
                       '<td>'||
                       '<img src="/im4_framework/RWSignHigh.gif" border=0 alt="Roadwork" align="absbottom"></img><span>    Moderate impact - delays possible    </span>'||
                       '</td>'||
                       '<td>'||
                       '<img src="/im4_framework/RWSignSev.gif" border=0 alt="Roadwork" align="absbottom"></img><span> Severe impact - delays possible    </span>'||
                       '</td>'||

                       '</tr>';

   HTP.P(L_HTML);
END SHOW_ROADWORK_LEGEND;



PROCEDURE ISVALIDLOCATION(PI_UNIQUE VARCHAR2)
IS
   CURSOR C1
   IS
   SELECT 'YES' YES
FROM IMF_NET_NETWORK
WHERE
  UPPER(NETWORK_ELEMENT_DESCRIPTION) = UPPER(PI_UNIQUE)
  ;
  L_RESPONCE VARCHAR2(3);
BEGIN
   OPEN C1;
   FETCH C1 INTO L_RESPONCE;
   IF (C1%FOUND)
    THEN
      L_RESPONCE := 'YES';
   ELSE
      L_RESPONCE := 'NO';
   END IF;
   CLOSE C1;
   HTP.P(L_RESPONCE);
END ISVALIDLOCATION;



  PROCEDURE RAISE_NER(  PI_APPL               IN NM_ERRORS.NER_APPL%TYPE
                      , PI_ID                 IN NM_ERRORS.NER_ID%TYPE
                      , PI_SQLCODE            IN PLS_INTEGER DEFAULT -20000
                      , PI_SUPPLEMENTARY_INFO IN VARCHAR2    DEFAULT NULL
                      ) IS

     L_REC_NER NM_ERRORS%ROWTYPE;

     L_SQLCODE PLS_INTEGER := ABS(PI_SQLCODE) * (-1);
     L_SQLERRM VARCHAR2(32767);

     L_ID_CHAR VARCHAR2(5);

  BEGIN
     

     DECLARE
        L_NER_NOT_FOUND EXCEPTION;

     BEGIN

        NM_DEBUG.DEBUG('calling get_ner to get the error record');
        L_REC_NER := HIG.GET_NER(PI_APPL,PI_ID);

        IF L_REC_NER.NER_ID =  -1 THEN

           RAISE L_NER_NOT_FOUND;

        END IF;

     EXCEPTION
        WHEN L_NER_NOT_FOUND
         THEN

           L_SQLCODE := NULL;
           L_REC_NER.NER_DESCR := 'Error not found in NM_ERRORS - ';

     END;
     

     L_ID_CHAR := LTRIM(TO_CHAR(PI_ID,'0000'),' ');
     
     IF  ABS(L_SQLCODE) NOT BETWEEN 20000 AND 20999
      OR L_SQLCODE IS NULL
      THEN
        L_SQLCODE := -20000;
     END IF;
     
     L_SQLERRM := L_REC_NER.NER_DESCR;
     
     IF PI_SUPPLEMENTARY_INFO IS NOT NULL
      THEN
        L_SQLERRM := L_SQLERRM||': '||PI_SUPPLEMENTARY_INFO;
     END IF;
     
     IF L_REC_NER.NER_CAUSE IS NOT NULL
     THEN
       L_SQLERRM := L_SQLERRM||CHR(10)||': '||L_REC_NER.NER_CAUSE;
     END IF;
     

     HTP.PRN(L_SQLERRM ||CHR(10)||CHR(10)||'Error ID. '||PI_APPL||':'||PI_ID);

     
  END RAISE_NER;



FUNCTION GET_HUS_NAME (PI_HUS_USER_ID HIG_USERS.HUS_USER_ID%TYPE) RETURN HIG_USERS.HUS_NAME%TYPE
IS
BEGIN
   RETURN NM3USER.GET_HUS(PI_HUS_USER_ID).HUS_NAME;
END GET_HUS_NAME;




PROCEDURE GETITEMHELPTEXT(PI_ITEM VARCHAR2)
IS
   CURSOR C1 (C_IMIH_ITEM_NAME IM_ITEM_HELP.IMIH_ITEM_NAME%TYPE)
   IS
   SELECT DBMS_XMLGEN.CONVERT(NVL(IP_DESCR, 'No description found for POD, go to POD maintenance to add a description for: '||PI_ITEM))
   FROM IM_PODS
   WHERE IP_HMO_MODULE  = C_IMIH_ITEM_NAME;
   L_HELP_TEXT IM_ITEM_HELP.IMIH_HELP_TEXT%TYPE;
   L_ID IM_ITEM_HELP.IMIH_ID%TYPE;
BEGIN
   L_HELP_TEXT := 'No Help text found for : '||PI_ITEM;
   OPEN C1(PI_ITEM);
   FETCH C1 INTO L_HELP_TEXT ;
   CLOSE C1;
   HTP.PRN(L_HELP_TEXT );
END GETITEMHELPTEXT;



PROCEDURE GETREPORTAREAS(P_APP_ID VARCHAR2
                        ,P_SESSION_ID VARCHAR2)
IS
  CURSOR C1 IS
  SELECT
        '<li><a href="javascript:showDrillDown('||P_APP_ID||','||P_SESSION_ID||',50'||',''P50_PROD'','||IBA_ID||');">'||IBA_DESCR||'</a></li>' URL
  FROM IM_BUSINESS_AREAS
  WHERE IBA_PARENT_ID != 0
  ORDER BY IBA_ID;
  TXT VARCHAR2(1000) := NULL;
BEGIN
  HTP.PRN(TXT);
  HTP.PRN('<ul type="square">');
  FOR C1REC IN C1
   LOOP
     HTP.PRN(TXT || C1REC.URL);
  END LOOP;
  HTP.PRN(TXT || '</ul>');
  HTP.PRN(TXT);
END GETREPORTAREAS;




FUNCTION GET_THEME_ID(PI_THEME_NAME NM_THEMES_ALL.NTH_THEME_NAME%TYPE)
RETURN NUMBER
IS
   RETVAL VARCHAR2(100);
BEGIN
   SELECT NTH_THEME_ID
   INTO RETVAL
   FROM NM_THEMES_ALL
   WHERE NTH_THEME_NAME = PI_THEME_NAME;
   RETURN RETVAL;
END GET_THEME_ID;



PROCEDURE GET_URL(PI_ID NUMBER)
IS
   CURSOR C_URL (C_IUL_ID IM_URL_LINKS.IUL_ID%TYPE)
   IS
   SELECT *
   FROM IM_URL_LINKS
   WHERE IUL_ID = C_IUL_ID;

BEGIN
   FOR URL_REC IN C_URL (PI_ID)
    LOOP

      HTP.PRN('<table>');
      HTP.PRN('<tr>');
      HTP.PRN('<td>');
      HTP.PRN('<a href="'||URL_REC.IUL_URL||'" target="_blank">'||URL_REC.IUL_URL||'</a>');
      HTP.PRN('</td>');
      HTP.PRN('</tr>');
      HTP.PRN('<tr>');
      HTP.PRN('<td>');
      HTP.PRN('<iframe src="'||URL_REC.IUL_URL||'" height="350" width="400"></iframe>');
      HTP.PRN('</td>');
      HTP.PRN('</tr>');
      HTP.PRN('</table>');
  END LOOP;
END GET_URL;



FUNCTION USER_CAN_RUN_MODULE(  P_USER   HIG_USERS.HUS_USERNAME%TYPE
                             , P_MODULE  HIG_MODULE_ROLES.HMR_MODULE%TYPE) RETURN BOOLEAN IS

   CURSOR C1 (C_MODULE  HIG_MODULES.HMO_MODULE%TYPE
              ,C_USER    HIG_USER_ROLES.HUR_USERNAME%TYPE
              ,C_SYSDATE HIG_USER_ROLES.HUR_START_DATE%TYPE
              ) IS
      SELECT 1
      FROM   HIG_MODULE_ROLES
            ,HIG_USER_ROLES
            ,HIG_MODULES
            ,HIG_PRODUCTS
      WHERE  HMO_MODULE      = C_MODULE
       AND   HPR_PRODUCT     = HMO_APPLICATION
       AND   HPR_KEY IS NOT NULL
       AND   HMR_MODULE      = HMO_MODULE
       AND   HMR_ROLE        = HUR_ROLE
       AND   HUR_USERNAME    = C_USER
       AND   HUR_START_DATE <= C_SYSDATE;

    L_DUMMY  PLS_INTEGER;
    L_RETVAL BOOLEAN;

  BEGIN


    OPEN  C1 (C_MODULE  => UPPER(P_MODULE)
             ,C_USER    => P_USER
             ,C_SYSDATE => TRUNC(SYSDATE)
             );
    FETCH C1 INTO L_DUMMY;
    L_RETVAL := C1%FOUND;
    CLOSE C1;
  
    RETURN L_RETVAL;

  END USER_CAN_RUN_MODULE;



PROCEDURE SHOW_CONTEXT (PI_NAMESPACE IN VARCHAR2 DEFAULT  NULL) IS

   L_CURRENT_NAMESPACE    VARCHAR2(30) := '??BADGER??';
   L_CONTEXT_VALUES_FOUND BOOLEAN := FALSE;

   C_USERENV_NAMESPACE CONSTANT VARCHAR2(30) := 'USERENV';
   C_NULL_STRING       CONSTANT VARCHAR2(10) := '#Null#';

   X VARCHAR2(100) := 'NM3_'||SUBSTR(USER,1,26);
BEGIN


      FOR CS_REC IN (SELECT *
                      FROM  SESSION_CONTEXT
                     WHERE  NAMESPACE = NVL(X,NAMESPACE)
                     ORDER BY NAMESPACE
                             ,ATTRIBUTE
                    )
       LOOP
         IF L_CURRENT_NAMESPACE <> CS_REC.NAMESPACE
          THEN
            L_CURRENT_NAMESPACE := CS_REC.NAMESPACE;
            HTP.P(L_CURRENT_NAMESPACE);
            HTP.P(RPAD('-',LENGTH(L_CURRENT_NAMESPACE),'-'));
         END IF;
         HTP.P(RPAD(CS_REC.ATTRIBUTE,31)
                              ||': '
                              ||NVL(CS_REC.VALUE,C_NULL_STRING)
                             );
         L_CONTEXT_VALUES_FOUND := TRUE;
      END LOOP;





















   IF NOT L_CONTEXT_VALUES_FOUND
    THEN
     HTP.P('No context values found');
   END IF;

END SHOW_CONTEXT;



PROCEDURE LOGON_LOGO
IS
 L_IMAGE_URL  VARCHAR2(100) := HIG.GET_USER_OR_SYS_OPT('LOGONLOGO');
 L_URL  VARCHAR2(100) := HIG.GET_USER_OR_SYS_OPT('LOGONURL');
BEGIN
     
     
     
     HTP.PRN('<a href="'||L_URL||'" target="_blank"><img src="'||L_IMAGE_URL ||'" class="logonLogoImage"></img></a>');
   
    
    
    
END LOGON_LOGO;



PROCEDURE LOGO_INFO
IS
   L_INFO  VARCHAR2(4000) := HIG.GET_USER_OR_SYS_OPT('LOGONINFO');
BEGIN
  HTP.PRN(L_INFO);
END LOGO_INFO;



PROCEDURE GETMAPCENTERXY
IS

 L_X NUMBER;
 L_Y NUMBER;
BEGIN
  L_X := GET_COOKIE(PI_NAME => 'POINTX');
  L_Y := GET_COOKIE(PI_NAME => 'POINTY');
  IF L_X IS NULL 
     OR 
     L_Y IS NULL
   THEN
     MAPVIEWER.SET_CENT_SIZE_THEME;
     SELECT GETX X, GETY Y
     INTO L_X, L_Y
     FROM DUAL;
  END IF;
  
  OWA_UTIL.MIME_HEADER('text/xml',FALSE);
  HTP.P('Cache-Control: no-cache');
  HTP.P('Pragma: no-cache');
  OWA_UTIL.HTTP_HEADER_CLOSE;
  HTP.PRN('<RECORDS>');
  
    HTP.PRN(
             '<X value="' ||
             L_X ||
             '">' ||
             '</X>'||
             '<Y value="' ||
             L_Y ||
             '">' ||
             '</Y>'
    );
  HTP.PRN('</RECORDS>');
END GETMAPCENTERXY;



  PROCEDURE SAVE_COOKIE(PI_NAME VARCHAR2
                     ,PI_VALUE       VARCHAR2)
IS
BEGIN
   OWA_UTIL.MIME_HEADER('text/html', FALSE);
   OWA_COOKIE.SEND(
                   NAME=> PI_NAME
                  ,VALUE=>PI_VALUE
                  ,EXPIRES => SYSDATE + 365); 

EXCEPTION
   WHEN OTHERS THEN
      NULL;
END SAVE_COOKIE;



FUNCTION GET_COOKIE(PI_NAME VARCHAR2)
RETURN VARCHAR2
IS
   C OWA_COOKIE.COOKIE;
BEGIN 
   C := OWA_COOKIE.GET(PI_NAME);
   RETURN C.VALS(1);
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END GET_COOKIE;



FUNCTION GET_MAX_ZOOM
RETURN VARCHAR2
IS
  RTRN NUMBER := 0;
BEGIN 
   FOR VREC IN 
   (SELECT SUBSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/cache_instance/zoom_levels'),
          INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/cache_instance/zoom_levels') ,'"')+1,
          INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/cache_instance/zoom_levels') ,'"',1,2) - INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/cache_instance/zoom_levels') ,'"')-1) ZOOMLEVEL
   FROM USER_SDO_CACHED_MAPS
   WHERE NAME = UPPER(NVL(HIG.GET_USER_OR_SYS_OPT('BASEMAPSTR'), HIG.GET_USER_OR_SYS_OPT('WMSMAPSTR'))))
   LOOP 
      RTRN := VREC.ZOOMLEVEL;
   END LOOP;

   IF RTRN IS NULL
     THEN 
       FOR VREC IN 
       (SELECT SUBSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels'),
              INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"')+1,
              INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"',1,2) - INSTR(EXTRACT(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"')-1) ZOOMLEVEL
       FROM USER_SDO_CACHED_MAPS
       WHERE NAME = UPPER(NVL(HIG.GET_USER_OR_SYS_OPT('BASEMAPSTR'), HIG.GET_USER_OR_SYS_OPT('WMSMAPSTR'))))
       LOOP 
          RTRN := VREC.ZOOMLEVEL;
       END LOOP;
   END IF;

   RETURN (RTRN-1);
END GET_MAX_ZOOM;



PROCEDURE GET_MAX_ZOOM
IS
BEGIN 
   HTP.PRN(GET_MAX_ZOOM);
END GET_MAX_ZOOM;



FUNCTION GET_POD_SQL( PI_PAGE_ID NUMBER
                     ,PI_USERNAME VARCHAR2
                     ,PI_POSITION NUMBER
                     ,PI_SQL_SEQ NUMBER DEFAULT 1)
RETURN VARCHAR
IS 
  RTRN VARCHAR2(4000);
CURSOR C1
IS
SELECT IPS_SOURCE_CODE
FROM IM_POD_SQL A
    ,IM_USER_PODS B
WHERE 
  A.IPS_IP_ID = B.IUP_IP_ID
AND
  B.IUP_IT_ID = (SELECT IT_ID FROM IM_TABS WHERE IT_PAGE_ID = PI_PAGE_ID)
AND 
  B.IUP_HUS_USERNAME = PI_USERNAME
AND
  B.IUP_POD_POSITION = PI_POSITION
AND
  A.IPS_SEQ = PI_SQL_SEQ;
BEGIN

  OPEN C1;
  FETCH C1 INTO RTRN;
  IF C1%NOTFOUND
   THEN 
     RTRN := 'select null link, null d, null v from dual';
  END IF;
  CLOSE C1;
  
  RETURN RTRN;
END GET_POD_SQL;



PROCEDURE GETUSERTABPODS(PI_TAB NUMBER, PI_USERNAME VARCHAR2)
IS
BEGIN
   FOR CREC IN (SELECT '<li value="'||IP_ID||'" class="ui-draggable dropped">'||
                       '<a class="ui-icon ui-icon-trash" title="Remove" href="#">Remove</a><br><b>'||IP_TYPE||
                       '</b><br>'||IP_TITLE||'</li>' LI
                FROM IM_USER_PODS
                    ,IM_PODS
                WHERE IUP_IP_ID = IP_ID
                  AND IUP_IT_ID = PI_TAB 
                  AND IUP_HUS_USERNAME = PI_USERNAME )
   LOOP
      HTP.PRN(CREC.LI);
   END LOOP;
END GETUSERTABPODS;



PROCEDURE SAVEPODTABS ( PI_TAB NUMBER
                       ,PI_PODS VARCHAR2
                       ,PI_USERNAME VARCHAR2)
AS
   L_PODS APEX_APPLICATION_GLOBAL.VC_ARR2;
   L_POD_REC IM_PODS%ROWTYPE;
   
   L_POD_POSITION IM_USER_PODS.IUP_POD_POSITION%TYPE := 0;
   
   
   L_CHART NUMBER := 0;
   L_MAP NUMBER := 99;
   L_TABLE NUMBER :=199;
   L_CAL NUMBER := 299;
   L_PLSQL NUMBER := 399;
   L_TWITTER NUMBER := 499;
   L_TAG NUMBER := 599;
   
   
   
   CURSOR C_POD(POD_ID IM_PODS.IP_ID%TYPE)
   IS
   SELECT * 
   FROM IM_PODS 
   WHERE IP_ID = POD_ID;
   
   CURSOR C_NEXT_POS( PAGE_ID IM_TABS.IT_PAGE_ID%TYPE
                     ,POD_TYPE IM_PODS.IP_TYPE%TYPE
                     ,POD_USERNAME IM_USER_PODS.IUP_HUS_USERNAME%TYPE
                     ,C_MIN NUMBER)
   IS                  
   SELECT NVL(MAX(IUP_POD_POSITION),C_MIN) + 1
   FROM IM_PODS
       ,IM_USER_PODS
   WHERE IUP_IP_ID = IP_ID
     AND
        IUP_IT_ID = (SELECT IT_ID FROM IM_TABS WHERE IT_PAGE_ID = PAGE_ID)
     AND IP_TYPE = POD_TYPE
     AND IUP_HUS_USERNAME = POD_USERNAME;

   
BEGIN


  L_PODS := APEX_UTIL.STRING_TO_TABLE(SUBSTR(PI_PODS,1,LENGTH(PI_PODS)-1));
  DELETE IM_USER_PODS 
  WHERE IUP_IT_ID = PI_TAB
    AND IUP_HUS_USERNAME = PI_USERNAME;
  
  
  FOR I IN 1..L_PODS.COUNT 
   LOOP
    OPEN C_POD(L_PODS(I));
    FETCH C_POD INTO L_POD_REC;
    CLOSE C_POD;

    CASE TRIM(L_POD_REC.IP_TYPE)
     WHEN 'Static' THEN 
         IF L_POD_REC.IP_HMO_MODULE = 'IM_TMA' THEN L_MAP := 101; 
         ELSIF L_POD_REC.IP_HMO_MODULE = 'IM_ENQ' THEN L_MAP := 102; 
         END IF;
         L_POD_POSITION := L_MAP;
     WHEN 'Map' THEN 
         L_MAP := 100;         
         L_POD_POSITION := L_MAP;         
     WHEN 'Table' THEN L_TABLE := L_TABLE + 1; L_POD_POSITION := L_TABLE;
     WHEN 'Calendar' THEN L_CAL := L_CAL + 1 ; L_POD_POSITION := L_CAL;
     WHEN 'PLSQL' THEN L_PLSQL := L_PLSQL + 1; L_POD_POSITION := L_PLSQL;
     WHEN 'Twitter' THEN L_TWITTER := L_TWITTER + 1; L_POD_POSITION := L_TWITTER;
     WHEN 'Tag Cloud' THEN L_TAG := L_TAG + 1; L_POD_POSITION := L_TAG;
     ELSE  L_CHART := L_CHART + 1;     L_POD_POSITION := L_CHART;
    END CASE; 
    
    
   



    
    INSERT
        INTO IM_USER_PODS
          (
            IUP_IP_ID
          , IUP_HUS_USERNAME
          , IUP_IT_ID
          , IUP_POD_POSITION
          , IUP_SOURCE_SEQ
          )
          VALUES
          (
            L_PODS(I)
          , PI_USERNAME
          , PI_TAB
          , L_POD_POSITION
          , NULL
          );
    
  END LOOP;
END SAVEPODTABS;



FUNCTION DISPLAY_USER_POD(PI_USERNAME HIG_USERS.HUS_USERNAME%TYPE
                         ,PI_PAGE IM_TABS.IT_PAGE_ID%TYPE
                         ,PI_POD_POSITION IM_USER_PODS.IUP_POD_POSITION%TYPE
                         )
RETURN BOOLEAN                       
IS
  RTRN BOOLEAN := FALSE;
  L_REC IM_USER_PODS%ROWTYPE;
  CURSOR C_ALLOW (C_USERNAME HIG_USERS.HUS_USERNAME%TYPE
                 ,C_PAGE IM_TABS.IT_PAGE_ID%TYPE                 
                 ,C_POD_POSITION IM_USER_PODS.IUP_POD_POSITION%TYPE
                 ) 
  IS
  SELECT *
  FROM IM_USER_PODS
  WHERE     
     IUP_IT_ID = (SELECT IT_ID FROM IM_TABS WHERE IT_PAGE_ID = C_PAGE)
    AND
     IUP_HUS_USERNAME = C_USERNAME
    AND 
     IUP_POD_POSITION = C_POD_POSITION;
BEGIN 
  OPEN C_ALLOW(PI_USERNAME 
              ,PI_PAGE 
              ,PI_POD_POSITION );
  FETCH C_ALLOW INTO L_REC;
  IF C_ALLOW%FOUND
   THEN 
    RTRN := TRUE;
  END IF;
  CLOSE C_ALLOW;
  RETURN RTRN;
END DISPLAY_USER_POD;



PROCEDURE GETPODTITLES(PI_PAGE_ID NUMBER
                      ,PI_MODULE VARCHAR2
                      ,PI_APP_ID NUMBER
                      ,PI_USERNAME VARCHAR2)
IS
  L_FRAMEWORK_DIR VARCHAR2(100);
BEGIN 
  SELECT SUBSTITUTION_VALUE 
  INTO L_FRAMEWORK_DIR
  FROM APEX_APPLICATION_SUBSTITUTIONS
  WHERE APPLICATION_ID  = PI_APP_ID
  AND SUBSTITUTION_STRING = 'FRAMEWORK_DIR';
  OWA_UTIL.MIME_HEADER ('text/xml', FALSE);
  HTP.P ('Cache-Control: no-cache');
  HTP.P ('Pragma: no-cache');
  OWA_UTIL.HTTP_HEADER_CLOSE;
  HTP.PRN ('<TITLES>');
  
  IF PI_PAGE_ID = 6
   THEN 
    FOR CREC IN (SELECT '<TITLE value="'|| DBMS_XMLGEN.CONVERT(IP_TITLE ||
              '<a href="#"><img value="'||PI_MODULE||'" class="podIconsi" src="/'||L_FRAMEWORK_DIR||'/images/info_icon.jpg" alt="Pod Info" title="Pod Info"></img></a>'
               )
               ||DBMS_XMLGEN.CONVERT(
               ( CASE IP_DRILL_DOWN
                   WHEN 'Y' THEN '<img class="podIconsd" src="/'||L_FRAMEWORK_DIR||'/images/green_down_arrow.png" alt="Drill down for more detail." title="Drill down for more detail."></img>'
                   ELSE '<img title="No further drill down available." alt="No further drill down available." src="/'||L_FRAMEWORK_DIR||'/images/no_drilldown.png" class="podIconsd" >'
                  END ))
              ||'"/>'||'<PAGE value="'||
              'drill'||'"/>' 
                || '<HEADER value="' || DBMS_XMLGEN.CONVERT(IP_HEADER) || '"/>'
                || '<FOOTER value="' || DBMS_XMLGEN.CONVERT(IP_FOOTER) || '"/>' POD_POSITION
                    FROM IM_PODS
                    WHERE IP_HMO_MODULE = PI_MODULE)
     LOOP
      HTP.PRN(CREC.POD_POSITION);
    END LOOP;
  ELSE 
  
  FOR CREC IN (SELECT DISTINCT '<TITLE value="'|| DBMS_XMLGEN.CONVERT(IP_TITLE ||
              '<a href="#"><img value="'||IP_HMO_MODULE||'" class="podIconsi" src="/'||L_FRAMEWORK_DIR||'/images/info_icon.jpg" alt="Pod Info" title="Pod Info"></img></a>'
              
               )
             
               ||DBMS_XMLGEN.CONVERT(
               ( CASE IP_DRILL_DOWN
                   WHEN 'Y' THEN '<img class="podIconsd" src="/'||L_FRAMEWORK_DIR||'/images/green_down_arrow.png" alt="Drill down for more detail." title="Drill down for more detail."></img>'
                   ELSE '<img title="No further drill down available." alt="No further drill down available." src="/'||L_FRAMEWORK_DIR||'/images/no_drilldown.png" class="podIconsd" >'
                  END ))
               || DBMS_XMLGEN.CONVERT(CASE IP_HMO_MODULE 
                   WHEN 'IM_MAP' THEN 
                     '<img class="podIconslayer" src="/'||L_FRAMEWORK_DIR||'/images/list.gif" alt="Layers." title="Layers."></img>'
             
               
                   
                    
                   END   )
              ||'"/>'
              ||'<PAGE value="'|| 'home'||IUP_POD_POSITION
               











 ||'"/>' 
                || '<HEADER value="' || DBMS_XMLGEN.CONVERT(IP_HEADER) || '"/>'
                || '<FOOTER value="' || DBMS_XMLGEN.CONVERT(IP_FOOTER) || '"/>' POD_POSITION
                    FROM IM_PODS
                        ,IM_USER_PODS
                        ,IM_TABS
                    WHERE IP_ID = IUP_IP_ID
                      AND IUP_IT_ID = IT_ID  
                      AND IT_PAGE_ID = PI_PAGE_ID
                      AND IUP_HUS_USERNAME = PI_USERNAME)
   LOOP
      HTP.PRN(CREC.POD_POSITION);
   END LOOP;
   END IF;
   HTP.PRN ('</TITLES>');
END GETPODTITLES;



PROCEDURE POPULATE_IM_LOCATION(PI_NE_ID NM_ELEMENTS.NE_ID%TYPE
                              ,PI_USERNAME HIG_USERS.HUS_USERNAME%TYPE)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
   INSERT INTO IM_LOCATION (IL_NE_ID_IN,IL_NE_ID,IL_USERNAME)
   SELECT    NM_NE_ID_IN, NM_NE_ID_OF,PI_USERNAME DATA  
              FROM  
              NM_MEMBERS  
             WHERE  
              NM3NET.GET_NE_GTY( NM_NE_ID_OF ) IS   
              NULL CONNECT BY PRIOR NM_NE_ID_OF = NM_NE_ID_IN  
             AND  
              NM3NET.GET_NE_GTY( NM_NE_ID_OF ) IS NULL   
             START  
             WITH NM_NE_ID_IN   = PI_NE_ID;
   
   UPDATE_USER_LOCATION_SET(PI_USERNAME => PI_USERNAME, PI_SET => 'Y');
   COMMIT;
END POPULATE_IM_LOCATION;



PROCEDURE CLEAR_IM_LOCATION(PI_USERNAME HIG_USERS.HUS_USERNAME%TYPE)
IS
BEGIN 
   EXECUTE IMMEDIATE ('truncate table im_location');
   UPDATE_USER_LOCATION_SET(PI_USERNAME => PI_USERNAME, PI_SET => 'N');   
END CLEAR_IM_LOCATION;



FUNCTION IS_LOCATION_SET(PI_USERNAME HIG_USERS.HUS_USERNAME%TYPE)
RETURN VARCHAR2
IS
  RTRN VARCHAR(1000) DEFAULT NULL;
BEGIN 
   SELECT IULS_SET
   INTO RTRN
   FROM IM_USER_LOCATION_SET
   WHERE IULS_USERNAME = PI_USERNAME; 

   RETURN NVL(RTRN,'N') ;
END IS_LOCATION_SET;



PROCEDURE UPDATE_USER_LOCATION_SET(PI_USERNAME HIG_USERS.HUS_USERNAME%TYPE
                                  ,PI_SET VARCHAR2)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
MERGE INTO IM_USER_LOCATION_SET A
USING  DUAL
ON  (A.IULS_USERNAME =PI_USERNAME)
WHEN NOT MATCHED THEN
   INSERT  (IULS_USERNAME, IULS_SET)
   VALUES (PI_USERNAME, 'Y')
WHEN MATCHED THEN 
   UPDATE  SET IULS_SET = PI_SET
;
COMMIT;
END UPDATE_USER_LOCATION_SET;



FUNCTION IMF_TRANSLATE(L_IN_STRING VARCHAR2)
RETURN VARCHAR IS
L_OUT_STRING VARCHAR2(2000);
BEGIN
  L_OUT_STRING:=TRANSLATE(L_IN_STRING,',&:''','   '); 
RETURN L_OUT_STRING;
END IMF_TRANSLATE; 



END IM_FRAMEWORK;
/
