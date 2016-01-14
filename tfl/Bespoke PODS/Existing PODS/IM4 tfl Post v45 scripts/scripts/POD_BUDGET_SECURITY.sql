CREATE OR REPLACE FORCE VIEW HIGHWAYS.POD_BUDGET_SECURITY
(
   USER_ID,
   BUDGET_CODE,
   BUD_RESTRICT
)
AS
   SELECT DISTINCT
          x_get_im_user_id user_id,
             MWUW_ICB_ITEM_CODE
          || MWUW_ICB_SUB_ITEM_CODE
          || MWUW_ICB_SUB_SUB_ITEM_CODE
             budget_code,
          MWU_RESTRICT_BY_WORKCODE bud_restrict
     FROM MAI_WO_USER_WORK_CODES, MAI_WO_USERS
    WHERE     x_get_im_user_id = MWUW_USER_ID
          AND x_get_im_user_id = MWU_USER_ID
          AND MWU_RESTRICT_BY_WORKCODE = 'Y';
          