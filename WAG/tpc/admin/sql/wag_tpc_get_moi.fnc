CREATE OR REPLACE function wag_tpc_get_moi
(p_incident_id in wag_tpc_matterofissue_data.WAG_TPC_INCIDENT_ID%TYPE
,p_cat in wag_tpc_matterofissue_data.WAG_TPC_CATEGORY_ID%TYPE
,p_class in wag_tpc_matterofissue_data.WAG_TPC_CLASS_ID%TYPE
,p_type in wag_tpc_matterofissue_data.WAG_TPC_TYPE_ID%TYPE
,p_q_num in wag_tpc_matterofissue_data.WAG_TPC_QUESTION_NUM%TYPE)
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/sql/wag_tpc_get_moi.fnc-arc   3.0   Sep 21 2009 16:15:06   smarshall  $
--       Module Name      : $Workfile:   wag_tpc_get_moi.fnc  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:15:06  $
--       Date fetched Out : $Modtime:   Sep 21 2009 16:14:32  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
return varchar2 is
--
l_answer    wag_tpc_matterofissue_data.WAG_TPC_QUESTION_ANSWER%TYPE;
--
cursor cs_moi (p_incident_id number, p_cat varchar2, p_class varchar2, p_type varchar2, p_q_num number) is
select wag_tpc_question_answer
from wag_tpc_matterofissue_data
where wag_tpc_incident_id = p_incident_id
and wag_tpc_category_id = p_cat
and wag_tpc_class_id = p_class
and wag_tpc_type_id = p_type
and wag_tpc_question_num = p_q_num;
--
begin
    open cs_moi (p_incident_id, p_cat, p_class, p_type, p_q_num);
    fetch cs_moi into l_answer;
    close cs_moi;
--    
return l_answer;
--
end;
/