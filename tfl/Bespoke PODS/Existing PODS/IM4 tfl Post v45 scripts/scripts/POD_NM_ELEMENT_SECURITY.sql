CREATE OR REPLACE FORCE VIEW HIGHWAYS.POD_NM_ELEMENT_SECURITY
(
   USER_ID,
   ELEMENT_ID,
   RD_RESTRICT
)
AS
   SELECT Q.USER_ID, Q.ELEMENT_ID, Q.RD_RESTRICT
     FROM (    SELECT DISTINCT x_get_im_user_id USER_ID,
                               NM_NE_ID_OF ELEMENT_ID,
                               (SELECT MWU_RESTRICT_BY_ROAD_GROUP
                                  FROM MAI_WO_USERS
                                 WHERE x_get_im_user_id = MWU_USER_ID)
                                  RD_RESTRICT
                 FROM NM_MEMBERS
                WHERE NM_TYPE = 'G'
           CONNECT BY PRIOR NM_NE_ID_OF = NM_NE_ID_IN
           START WITH NM_NE_ID_IN IN
                         (SELECT MWUR_ROAD_GROUP_ID
                            FROM MAI_WO_USER_ROAD_GROUPS
                           WHERE MWUR_USER_ID = x_get_im_user_id)) Q
    WHERE RD_RESTRICT = 'Y';