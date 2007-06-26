CREATE OR REPLACE PACKAGE BODY xval_audit AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_audit.pkb	1.1 03/14/05
--       Module Name      : xval_audit.pkb
--       Date into SCCS   : 05/03/14 23:11:06
--       Date fetched Out : 07/06/06 14:33:54
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   valuations audit package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xval_audit.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30) := 'xval_audit';
--
   c_inv_table_name  CONSTANT  VARCHAR2(16) := 'NM_INV_ITEMS_ALL';
   c_date_format     CONSTANT  VARCHAR2(22) := nm3type.c_full_date_time_format;
--
   c_old             CONSTANT  nm_audit_temp.nat_old_or_new%TYPE := 'OLD';
   c_new             CONSTANT  nm_audit_temp.nat_old_or_new%TYPE := 'NEW';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nat_pair_for_val (p_rec_iit_old IN nm_inv_items%ROWTYPE
                                  ,p_rec_iit_new IN nm_inv_items%ROWTYPE
                                  ,p_audit_type  IN VARCHAR2
                                  ) IS
--
   l_aud_seq    nm_audit_temp.nat_audit_id%TYPE;
   l_user       nm_audit_temp.nat_performed_by%TYPE;
   l_session_id nm_audit_temp.nat_session_id%TYPE;
   l_old_or_new nm_audit_temp.nat_old_or_new%TYPE;
--
   do_not_audit  EXCEPTION;
--
   CURSOR cs_nextval IS
   SELECT nm_audit_temp_seq.NEXTVAL
         ,USERENV('SESSIONID')
         ,user
    FROM  dual;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_nat_pair_for_val');
--
   IF NVL(p_rec_iit_old.iit_inv_type,p_rec_iit_new.iit_inv_type) != xval_find_inv.get_val_inv_type
    THEN
      RAISE do_not_audit;
   END IF;
--
   OPEN  cs_nextval;
   FETCH cs_nextval INTO l_aud_seq, l_session_id, l_user;
   CLOSE cs_nextval;
--
   DELETE FROM nm_audit_temp
   WHERE  nat_audit_id IN (SELECT nat_audit_id
                            FROM  nm_audit_temp
                           WHERE  nat_audit_table  = c_inv_table_name
                            AND  (nat_key_info_1   = p_rec_iit_new.iit_ne_id
                                 OR nat_key_info_1 = p_rec_iit_old.iit_ne_id
                                 )
                            AND   nat_session_id   = l_session_id
                          );
--
   l_old_or_new := c_old;
-- INSERT THE "OLD" record
   INSERT INTO nm_audit_temp
          (nat_audit_id
          ,nat_old_or_new
          ,nat_audit_type
          ,nat_audit_table
          ,nat_performed_by
          ,nat_session_id
          ,nat_key_info_1 -- IIT_NE_ID
          ,nat_key_info_2 -- IIT_PRIMARY_KEY
          ,nat_key_info_3 -- IIT_FOREIGN_KEY
          ,nat_key_info_4 -- IIT_INV_TYPE
          ,nat_column_1 -- IIT_NE_ID
          ,nat_column_2 -- IIT_INV_TYPE
          ,nat_column_3 -- IIT_PRIMARY_KEY
          ,nat_column_4 -- IIT_START_DATE
          ,nat_column_9 -- IIT_ADMIN_UNIT
          ,nat_column_10 -- IIT_DESCR
          ,nat_column_11 -- IIT_END_DATE
          ,nat_column_12 -- IIT_FOREIGN_KEY
          ,nat_column_13 -- IIT_LOCATED_BY
          ,nat_column_14 -- IIT_POSITION
          ,nat_column_15 -- IIT_X_COORD
          ,nat_column_16 -- IIT_Y_COORD
          ,nat_column_17 -- IIT_NUM_ATTRIB16
          ,nat_column_18 -- IIT_NUM_ATTRIB17
          ,nat_column_19 -- IIT_NUM_ATTRIB18
          ,nat_column_20 -- IIT_NUM_ATTRIB19
          ,nat_column_21 -- IIT_NUM_ATTRIB20
          ,nat_column_22 -- IIT_NUM_ATTRIB21
          ,nat_column_23 -- IIT_NUM_ATTRIB22
          ,nat_column_24 -- IIT_NUM_ATTRIB23
          ,nat_column_25 -- IIT_NUM_ATTRIB24
          ,nat_column_26 -- IIT_NUM_ATTRIB25
          ,nat_column_27 -- IIT_CHR_ATTRIB26
          ,nat_column_28 -- IIT_CHR_ATTRIB27
          ,nat_column_29 -- IIT_CHR_ATTRIB28
          ,nat_column_30 -- IIT_CHR_ATTRIB29
          ,nat_column_31 -- IIT_CHR_ATTRIB30
          ,nat_column_32 -- IIT_CHR_ATTRIB31
          ,nat_column_33 -- IIT_CHR_ATTRIB32
          ,nat_column_34 -- IIT_CHR_ATTRIB33
          ,nat_column_35 -- IIT_CHR_ATTRIB34
          ,nat_column_36 -- IIT_CHR_ATTRIB35
          ,nat_column_37 -- IIT_CHR_ATTRIB36
          ,nat_column_38 -- IIT_CHR_ATTRIB37
          ,nat_column_39 -- IIT_CHR_ATTRIB38
          ,nat_column_40 -- IIT_CHR_ATTRIB39
          ,nat_column_41 -- IIT_CHR_ATTRIB40
          ,nat_column_42 -- IIT_CHR_ATTRIB41
          ,nat_column_43 -- IIT_CHR_ATTRIB42
          ,nat_column_44 -- IIT_CHR_ATTRIB43
          ,nat_column_45 -- IIT_CHR_ATTRIB44
          ,nat_column_46 -- IIT_CHR_ATTRIB45
          ,nat_column_47 -- IIT_CHR_ATTRIB46
          ,nat_column_48 -- IIT_CHR_ATTRIB47
          ,nat_column_49 -- IIT_CHR_ATTRIB48
          ,nat_column_50 -- IIT_CHR_ATTRIB49
          ,nat_column_51 -- IIT_CHR_ATTRIB50
          ,nat_column_52 -- IIT_CHR_ATTRIB51
          ,nat_column_53 -- IIT_CHR_ATTRIB52
          ,nat_column_54 -- IIT_CHR_ATTRIB53
          ,nat_column_55 -- IIT_CHR_ATTRIB54
          ,nat_column_56 -- IIT_CHR_ATTRIB55
          ,nat_column_57 -- IIT_CHR_ATTRIB56
          ,nat_column_58 -- IIT_CHR_ATTRIB57
          ,nat_column_59 -- IIT_CHR_ATTRIB58
          ,nat_column_60 -- IIT_CHR_ATTRIB59
          ,nat_column_61 -- IIT_CHR_ATTRIB60
          ,nat_column_62 -- IIT_CHR_ATTRIB61
          ,nat_column_63 -- IIT_CHR_ATTRIB62
          ,nat_column_64 -- IIT_CHR_ATTRIB63
          ,nat_column_65 -- IIT_CHR_ATTRIB64
          ,nat_column_66 -- IIT_CHR_ATTRIB65
          ,nat_column_67 -- IIT_CHR_ATTRIB66
          ,nat_column_68 -- IIT_CHR_ATTRIB67
          ,nat_column_69 -- IIT_CHR_ATTRIB68
          ,nat_column_70 -- IIT_CHR_ATTRIB69
          ,nat_column_71 -- IIT_CHR_ATTRIB70
          ,nat_column_72 -- IIT_CHR_ATTRIB71
          ,nat_column_73 -- IIT_CHR_ATTRIB72
          ,nat_column_74 -- IIT_CHR_ATTRIB73
          ,nat_column_75 -- IIT_CHR_ATTRIB74
          ,nat_column_76 -- IIT_CHR_ATTRIB75
          ,nat_column_77 -- IIT_NUM_ATTRIB76
          ,nat_column_78 -- IIT_NUM_ATTRIB77
          ,nat_column_79 -- IIT_NUM_ATTRIB78
          ,nat_column_80 -- IIT_NUM_ATTRIB79
          ,nat_column_81 -- IIT_NUM_ATTRIB80
          ,nat_column_82 -- IIT_NUM_ATTRIB81
          ,nat_column_83 -- IIT_NUM_ATTRIB82
          ,nat_column_84 -- IIT_NUM_ATTRIB83
          ,nat_column_85 -- IIT_NUM_ATTRIB84
          ,nat_column_86 -- IIT_NUM_ATTRIB85
          ,nat_column_87 -- IIT_DATE_ATTRIB86
          ,nat_column_88 -- IIT_DATE_ATTRIB87
          ,nat_column_89 -- IIT_DATE_ATTRIB88
          ,nat_column_90 -- IIT_DATE_ATTRIB89
          ,nat_column_91 -- IIT_DATE_ATTRIB90
          ,nat_column_92 -- IIT_DATE_ATTRIB91
          ,nat_column_93 -- IIT_DATE_ATTRIB92
          ,nat_column_94 -- IIT_DATE_ATTRIB93
          ,nat_column_95 -- IIT_DATE_ATTRIB94
          ,nat_column_96 -- IIT_DATE_ATTRIB95
          ,nat_column_97 -- IIT_ANGLE
          ,nat_column_98 -- IIT_ANGLE_TXT
          ,nat_column_99 -- IIT_CLASS
          ,nat_column_100 -- IIT_CLASS_TXT
          ,nat_column_101 -- IIT_COLOUR
          ,nat_column_102 -- IIT_COLOUR_TXT
          ,nat_column_103 -- IIT_COORD_FLAG
          ,nat_column_104 -- IIT_DESCRIPTION
          ,nat_column_105 -- IIT_DIAGRAM
          ,nat_column_106 -- IIT_DISTANCE
          ,nat_column_107 -- IIT_END_CHAIN
          ,nat_column_108 -- IIT_GAP
          ,nat_column_109 -- IIT_HEIGHT
          ,nat_column_110 -- IIT_HEIGHT_2
          ,nat_column_111 -- IIT_ID_CODE
          ,nat_column_112 -- IIT_INSTAL_DATE
          ,nat_column_113 -- IIT_INVENT_DATE
          ,nat_column_114 -- IIT_INV_OWNERSHIP
          ,nat_column_115 -- IIT_ITEMCODE
          ,nat_column_116 -- IIT_LCO_LAMP_CONFIG_ID
          ,nat_column_117 -- IIT_LENGTH
          ,nat_column_118 -- IIT_MATERIAL
          ,nat_column_119 -- IIT_MATERIAL_TXT
          ,nat_column_120 -- IIT_METHOD
          ,nat_column_121 -- IIT_METHOD_TXT
          ,nat_column_122 -- IIT_NOTE
          ,nat_column_123 -- IIT_NO_OF_UNITS
          ,nat_column_124 -- IIT_OPTIONS
          ,nat_column_125 -- IIT_OPTIONS_TXT
          ,nat_column_126 -- IIT_OUN_ORG_ID_ELEC_BOARD
          ,nat_column_127 -- IIT_OWNER
          ,nat_column_128 -- IIT_OWNER_TXT
          ,nat_column_129 -- IIT_PEO_INVENT_BY_ID
          ,nat_column_130 -- IIT_PHOTO
          ,nat_column_131 -- IIT_POWER
          ,nat_column_132 -- IIT_PROV_FLAG
          ,nat_column_133 -- IIT_REV_BY
          ,nat_column_134 -- IIT_REV_DATE
          ,nat_column_135 -- IIT_TYPE
          ,nat_column_136 -- IIT_TYPE_TXT
          ,nat_column_137 -- IIT_WIDTH
          ,nat_column_138 -- IIT_XTRA_CHAR_1
          ,nat_column_139 -- IIT_XTRA_DATE_1
          ,nat_column_140 -- IIT_XTRA_DOMAIN_1
          ,nat_column_141 -- IIT_XTRA_DOMAIN_TXT_1
          ,nat_column_142 -- IIT_XTRA_NUMBER_1
          ,nat_column_143 -- IIT_X_SECT
          ,nat_column_144 -- IIT_DET_XSP
          ,nat_column_145 -- IIT_OFFSET
          ,nat_column_146 -- IIT_X
          ,nat_column_147 -- IIT_Y
          ,nat_column_148 -- IIT_Z
          ,nat_column_149 -- IIT_NUM_ATTRIB96
          ,nat_column_150 -- IIT_NUM_ATTRIB97
          ,nat_column_151 -- IIT_NUM_ATTRIB98
          ,nat_column_152 -- IIT_NUM_ATTRIB99
          ,nat_column_153 -- IIT_NUM_ATTRIB100
          ,nat_column_154 -- IIT_NUM_ATTRIB101
          ,nat_column_155 -- IIT_NUM_ATTRIB102
          ,nat_column_156 -- IIT_NUM_ATTRIB103
          ,nat_column_157 -- IIT_NUM_ATTRIB104
          ,nat_column_158 -- IIT_NUM_ATTRIB105
          ,nat_column_159 -- IIT_NUM_ATTRIB106
          ,nat_column_160 -- IIT_NUM_ATTRIB107
          ,nat_column_161 -- IIT_NUM_ATTRIB108
          ,nat_column_162 -- IIT_NUM_ATTRIB109
          ,nat_column_163 -- IIT_NUM_ATTRIB110
          ,nat_column_164 -- IIT_NUM_ATTRIB111
          ,nat_column_165 -- IIT_NUM_ATTRIB112
          ,nat_column_166 -- IIT_NUM_ATTRIB113
          ,nat_column_167 -- IIT_NUM_ATTRIB114
          ,nat_column_168 -- IIT_NUM_ATTRIB115
          )
   VALUES (l_aud_seq -- nat_audit_id
          ,l_old_or_new -- nat_old_or_new
          ,p_audit_type -- nat_audit_type
          ,c_inv_table_name -- nat_audit_table
          ,l_user -- nat_performed_by
          ,l_session_id -- nat_session_id
          ,TO_CHAR(p_rec_iit_old.IIT_NE_ID) -- nat_key_info_1
          ,p_rec_iit_old.IIT_PRIMARY_KEY -- nat_key_info_2
          ,p_rec_iit_old.IIT_FOREIGN_KEY -- nat_key_info_3
          ,p_rec_iit_old.IIT_INV_TYPE -- nat_key_info_4
          ,TO_CHAR(p_rec_iit_old.IIT_NE_ID) -- nat_column_1
          ,p_rec_iit_old.IIT_INV_TYPE -- nat_column_2
          ,p_rec_iit_old.IIT_PRIMARY_KEY -- nat_column_3
          ,TO_CHAR(p_rec_iit_old.IIT_START_DATE,c_date_format) -- nat_column_4
          ,TO_CHAR(p_rec_iit_old.IIT_ADMIN_UNIT) -- nat_column_9
          ,p_rec_iit_old.IIT_DESCR -- nat_column_10
          ,TO_CHAR(p_rec_iit_old.IIT_END_DATE,c_date_format) -- nat_column_11
          ,p_rec_iit_old.IIT_FOREIGN_KEY -- nat_column_12
          ,TO_CHAR(p_rec_iit_old.IIT_LOCATED_BY) -- nat_column_13
          ,TO_CHAR(p_rec_iit_old.IIT_POSITION) -- nat_column_14
          ,TO_CHAR(p_rec_iit_old.IIT_X_COORD) -- nat_column_15
          ,TO_CHAR(p_rec_iit_old.IIT_Y_COORD) -- nat_column_16
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB16) -- nat_column_17
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB17) -- nat_column_18
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB18) -- nat_column_19
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB19) -- nat_column_20
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB20) -- nat_column_21
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB21) -- nat_column_22
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB22) -- nat_column_23
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB23) -- nat_column_24
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB24) -- nat_column_25
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB25) -- nat_column_26
          ,p_rec_iit_old.IIT_CHR_ATTRIB26 -- nat_column_27
          ,p_rec_iit_old.IIT_CHR_ATTRIB27 -- nat_column_28
          ,p_rec_iit_old.IIT_CHR_ATTRIB28 -- nat_column_29
          ,p_rec_iit_old.IIT_CHR_ATTRIB29 -- nat_column_30
          ,p_rec_iit_old.IIT_CHR_ATTRIB30 -- nat_column_31
          ,p_rec_iit_old.IIT_CHR_ATTRIB31 -- nat_column_32
          ,p_rec_iit_old.IIT_CHR_ATTRIB32 -- nat_column_33
          ,p_rec_iit_old.IIT_CHR_ATTRIB33 -- nat_column_34
          ,p_rec_iit_old.IIT_CHR_ATTRIB34 -- nat_column_35
          ,p_rec_iit_old.IIT_CHR_ATTRIB35 -- nat_column_36
          ,p_rec_iit_old.IIT_CHR_ATTRIB36 -- nat_column_37
          ,p_rec_iit_old.IIT_CHR_ATTRIB37 -- nat_column_38
          ,p_rec_iit_old.IIT_CHR_ATTRIB38 -- nat_column_39
          ,p_rec_iit_old.IIT_CHR_ATTRIB39 -- nat_column_40
          ,p_rec_iit_old.IIT_CHR_ATTRIB40 -- nat_column_41
          ,p_rec_iit_old.IIT_CHR_ATTRIB41 -- nat_column_42
          ,p_rec_iit_old.IIT_CHR_ATTRIB42 -- nat_column_43
          ,p_rec_iit_old.IIT_CHR_ATTRIB43 -- nat_column_44
          ,p_rec_iit_old.IIT_CHR_ATTRIB44 -- nat_column_45
          ,p_rec_iit_old.IIT_CHR_ATTRIB45 -- nat_column_46
          ,p_rec_iit_old.IIT_CHR_ATTRIB46 -- nat_column_47
          ,p_rec_iit_old.IIT_CHR_ATTRIB47 -- nat_column_48
          ,p_rec_iit_old.IIT_CHR_ATTRIB48 -- nat_column_49
          ,p_rec_iit_old.IIT_CHR_ATTRIB49 -- nat_column_50
          ,p_rec_iit_old.IIT_CHR_ATTRIB50 -- nat_column_51
          ,p_rec_iit_old.IIT_CHR_ATTRIB51 -- nat_column_52
          ,p_rec_iit_old.IIT_CHR_ATTRIB52 -- nat_column_53
          ,p_rec_iit_old.IIT_CHR_ATTRIB53 -- nat_column_54
          ,p_rec_iit_old.IIT_CHR_ATTRIB54 -- nat_column_55
          ,p_rec_iit_old.IIT_CHR_ATTRIB55 -- nat_column_56
          ,p_rec_iit_old.IIT_CHR_ATTRIB56 -- nat_column_57
          ,p_rec_iit_old.IIT_CHR_ATTRIB57 -- nat_column_58
          ,p_rec_iit_old.IIT_CHR_ATTRIB58 -- nat_column_59
          ,p_rec_iit_old.IIT_CHR_ATTRIB59 -- nat_column_60
          ,p_rec_iit_old.IIT_CHR_ATTRIB60 -- nat_column_61
          ,p_rec_iit_old.IIT_CHR_ATTRIB61 -- nat_column_62
          ,p_rec_iit_old.IIT_CHR_ATTRIB62 -- nat_column_63
          ,p_rec_iit_old.IIT_CHR_ATTRIB63 -- nat_column_64
          ,p_rec_iit_old.IIT_CHR_ATTRIB64 -- nat_column_65
          ,p_rec_iit_old.IIT_CHR_ATTRIB65 -- nat_column_66
          ,p_rec_iit_old.IIT_CHR_ATTRIB66 -- nat_column_67
          ,p_rec_iit_old.IIT_CHR_ATTRIB67 -- nat_column_68
          ,p_rec_iit_old.IIT_CHR_ATTRIB68 -- nat_column_69
          ,p_rec_iit_old.IIT_CHR_ATTRIB69 -- nat_column_70
          ,p_rec_iit_old.IIT_CHR_ATTRIB70 -- nat_column_71
          ,p_rec_iit_old.IIT_CHR_ATTRIB71 -- nat_column_72
          ,p_rec_iit_old.IIT_CHR_ATTRIB72 -- nat_column_73
          ,p_rec_iit_old.IIT_CHR_ATTRIB73 -- nat_column_74
          ,p_rec_iit_old.IIT_CHR_ATTRIB74 -- nat_column_75
          ,p_rec_iit_old.IIT_CHR_ATTRIB75 -- nat_column_76
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB76) -- nat_column_77
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB77) -- nat_column_78
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB78) -- nat_column_79
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB79) -- nat_column_80
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB80) -- nat_column_81
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB81) -- nat_column_82
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB82) -- nat_column_83
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB83) -- nat_column_84
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB84) -- nat_column_85
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB85) -- nat_column_86
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB86,c_date_format) -- nat_column_87
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB87,c_date_format) -- nat_column_88
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB88,c_date_format) -- nat_column_89
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB89,c_date_format) -- nat_column_90
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB90,c_date_format) -- nat_column_91
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB91,c_date_format) -- nat_column_92
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB92,c_date_format) -- nat_column_93
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB93,c_date_format) -- nat_column_94
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB94,c_date_format) -- nat_column_95
          ,TO_CHAR(p_rec_iit_old.IIT_DATE_ATTRIB95,c_date_format) -- nat_column_96
          ,TO_CHAR(p_rec_iit_old.IIT_ANGLE) -- nat_column_97
          ,p_rec_iit_old.IIT_ANGLE_TXT -- nat_column_98
          ,p_rec_iit_old.IIT_CLASS -- nat_column_99
          ,p_rec_iit_old.IIT_CLASS_TXT -- nat_column_100
          ,p_rec_iit_old.IIT_COLOUR -- nat_column_101
          ,p_rec_iit_old.IIT_COLOUR_TXT -- nat_column_102
          ,p_rec_iit_old.IIT_COORD_FLAG -- nat_column_103
          ,p_rec_iit_old.IIT_DESCRIPTION -- nat_column_104
          ,p_rec_iit_old.IIT_DIAGRAM -- nat_column_105
          ,TO_CHAR(p_rec_iit_old.IIT_DISTANCE) -- nat_column_106
          ,TO_CHAR(p_rec_iit_old.IIT_END_CHAIN) -- nat_column_107
          ,TO_CHAR(p_rec_iit_old.IIT_GAP) -- nat_column_108
          ,TO_CHAR(p_rec_iit_old.IIT_HEIGHT) -- nat_column_109
          ,TO_CHAR(p_rec_iit_old.IIT_HEIGHT_2) -- nat_column_110
          ,p_rec_iit_old.IIT_ID_CODE -- nat_column_111
          ,TO_CHAR(p_rec_iit_old.IIT_INSTAL_DATE,c_date_format) -- nat_column_112
          ,TO_CHAR(p_rec_iit_old.IIT_INVENT_DATE,c_date_format) -- nat_column_113
          ,p_rec_iit_old.IIT_INV_OWNERSHIP -- nat_column_114
          ,p_rec_iit_old.IIT_ITEMCODE -- nat_column_115
          ,TO_CHAR(p_rec_iit_old.IIT_LCO_LAMP_CONFIG_ID) -- nat_column_116
          ,TO_CHAR(p_rec_iit_old.IIT_LENGTH) -- nat_column_117
          ,p_rec_iit_old.IIT_MATERIAL -- nat_column_118
          ,p_rec_iit_old.IIT_MATERIAL_TXT -- nat_column_119
          ,p_rec_iit_old.IIT_METHOD -- nat_column_120
          ,p_rec_iit_old.IIT_METHOD_TXT -- nat_column_121
          ,p_rec_iit_old.IIT_NOTE -- nat_column_122
          ,TO_CHAR(p_rec_iit_old.IIT_NO_OF_UNITS) -- nat_column_123
          ,p_rec_iit_old.IIT_OPTIONS -- nat_column_124
          ,p_rec_iit_old.IIT_OPTIONS_TXT -- nat_column_125
          ,TO_CHAR(p_rec_iit_old.IIT_OUN_ORG_ID_ELEC_BOARD) -- nat_column_126
          ,p_rec_iit_old.IIT_OWNER -- nat_column_127
          ,p_rec_iit_old.IIT_OWNER_TXT -- nat_column_128
          ,TO_CHAR(p_rec_iit_old.IIT_PEO_INVENT_BY_ID) -- nat_column_129
          ,p_rec_iit_old.IIT_PHOTO -- nat_column_130
          ,TO_CHAR(p_rec_iit_old.IIT_POWER) -- nat_column_131
          ,p_rec_iit_old.IIT_PROV_FLAG -- nat_column_132
          ,p_rec_iit_old.IIT_REV_BY -- nat_column_133
          ,TO_CHAR(p_rec_iit_old.IIT_REV_DATE,c_date_format) -- nat_column_134
          ,p_rec_iit_old.IIT_TYPE -- nat_column_135
          ,p_rec_iit_old.IIT_TYPE_TXT -- nat_column_136
          ,TO_CHAR(p_rec_iit_old.IIT_WIDTH) -- nat_column_137
          ,p_rec_iit_old.IIT_XTRA_CHAR_1 -- nat_column_138
          ,TO_CHAR(p_rec_iit_old.IIT_XTRA_DATE_1,c_date_format) -- nat_column_139
          ,p_rec_iit_old.IIT_XTRA_DOMAIN_1 -- nat_column_140
          ,p_rec_iit_old.IIT_XTRA_DOMAIN_TXT_1 -- nat_column_141
          ,TO_CHAR(p_rec_iit_old.IIT_XTRA_NUMBER_1) -- nat_column_142
          ,p_rec_iit_old.IIT_X_SECT -- nat_column_143
          ,p_rec_iit_old.IIT_DET_XSP -- nat_column_144
          ,TO_CHAR(p_rec_iit_old.IIT_OFFSET) -- nat_column_145
          ,TO_CHAR(p_rec_iit_old.IIT_X) -- nat_column_146
          ,TO_CHAR(p_rec_iit_old.IIT_Y) -- nat_column_147
          ,TO_CHAR(p_rec_iit_old.IIT_Z) -- nat_column_148
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB96) -- nat_column_149
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB97) -- nat_column_150
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB98) -- nat_column_151
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB99) -- nat_column_152
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB100) -- nat_column_153
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB101) -- nat_column_154
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB102) -- nat_column_155
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB103) -- nat_column_156
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB104) -- nat_column_157
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB105) -- nat_column_158
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB106) -- nat_column_159
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB107) -- nat_column_160
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB108) -- nat_column_161
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB109) -- nat_column_162
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB110) -- nat_column_163
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB111) -- nat_column_164
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB112) -- nat_column_165
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB113) -- nat_column_166
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB114) -- nat_column_167
          ,TO_CHAR(p_rec_iit_old.IIT_NUM_ATTRIB115) -- nat_column_168
          );
--
   l_old_or_new := c_new;
-- INSERT THE "NEW" record
   INSERT INTO nm_audit_temp
          (nat_audit_id
          ,nat_old_or_new
          ,nat_audit_type
          ,nat_audit_table
          ,nat_performed_by
          ,nat_session_id
          ,nat_key_info_1 -- IIT_NE_ID
          ,nat_key_info_2 -- IIT_PRIMARY_KEY
          ,nat_key_info_3 -- IIT_FOREIGN_KEY
          ,nat_key_info_4 -- IIT_INV_TYPE
          ,nat_column_1 -- IIT_NE_ID
          ,nat_column_2 -- IIT_INV_TYPE
          ,nat_column_3 -- IIT_PRIMARY_KEY
          ,nat_column_4 -- IIT_START_DATE
          ,nat_column_9 -- IIT_ADMIN_UNIT
          ,nat_column_10 -- IIT_DESCR
          ,nat_column_11 -- IIT_END_DATE
          ,nat_column_12 -- IIT_FOREIGN_KEY
          ,nat_column_13 -- IIT_LOCATED_BY
          ,nat_column_14 -- IIT_POSITION
          ,nat_column_15 -- IIT_X_COORD
          ,nat_column_16 -- IIT_Y_COORD
          ,nat_column_17 -- IIT_NUM_ATTRIB16
          ,nat_column_18 -- IIT_NUM_ATTRIB17
          ,nat_column_19 -- IIT_NUM_ATTRIB18
          ,nat_column_20 -- IIT_NUM_ATTRIB19
          ,nat_column_21 -- IIT_NUM_ATTRIB20
          ,nat_column_22 -- IIT_NUM_ATTRIB21
          ,nat_column_23 -- IIT_NUM_ATTRIB22
          ,nat_column_24 -- IIT_NUM_ATTRIB23
          ,nat_column_25 -- IIT_NUM_ATTRIB24
          ,nat_column_26 -- IIT_NUM_ATTRIB25
          ,nat_column_27 -- IIT_CHR_ATTRIB26
          ,nat_column_28 -- IIT_CHR_ATTRIB27
          ,nat_column_29 -- IIT_CHR_ATTRIB28
          ,nat_column_30 -- IIT_CHR_ATTRIB29
          ,nat_column_31 -- IIT_CHR_ATTRIB30
          ,nat_column_32 -- IIT_CHR_ATTRIB31
          ,nat_column_33 -- IIT_CHR_ATTRIB32
          ,nat_column_34 -- IIT_CHR_ATTRIB33
          ,nat_column_35 -- IIT_CHR_ATTRIB34
          ,nat_column_36 -- IIT_CHR_ATTRIB35
          ,nat_column_37 -- IIT_CHR_ATTRIB36
          ,nat_column_38 -- IIT_CHR_ATTRIB37
          ,nat_column_39 -- IIT_CHR_ATTRIB38
          ,nat_column_40 -- IIT_CHR_ATTRIB39
          ,nat_column_41 -- IIT_CHR_ATTRIB40
          ,nat_column_42 -- IIT_CHR_ATTRIB41
          ,nat_column_43 -- IIT_CHR_ATTRIB42
          ,nat_column_44 -- IIT_CHR_ATTRIB43
          ,nat_column_45 -- IIT_CHR_ATTRIB44
          ,nat_column_46 -- IIT_CHR_ATTRIB45
          ,nat_column_47 -- IIT_CHR_ATTRIB46
          ,nat_column_48 -- IIT_CHR_ATTRIB47
          ,nat_column_49 -- IIT_CHR_ATTRIB48
          ,nat_column_50 -- IIT_CHR_ATTRIB49
          ,nat_column_51 -- IIT_CHR_ATTRIB50
          ,nat_column_52 -- IIT_CHR_ATTRIB51
          ,nat_column_53 -- IIT_CHR_ATTRIB52
          ,nat_column_54 -- IIT_CHR_ATTRIB53
          ,nat_column_55 -- IIT_CHR_ATTRIB54
          ,nat_column_56 -- IIT_CHR_ATTRIB55
          ,nat_column_57 -- IIT_CHR_ATTRIB56
          ,nat_column_58 -- IIT_CHR_ATTRIB57
          ,nat_column_59 -- IIT_CHR_ATTRIB58
          ,nat_column_60 -- IIT_CHR_ATTRIB59
          ,nat_column_61 -- IIT_CHR_ATTRIB60
          ,nat_column_62 -- IIT_CHR_ATTRIB61
          ,nat_column_63 -- IIT_CHR_ATTRIB62
          ,nat_column_64 -- IIT_CHR_ATTRIB63
          ,nat_column_65 -- IIT_CHR_ATTRIB64
          ,nat_column_66 -- IIT_CHR_ATTRIB65
          ,nat_column_67 -- IIT_CHR_ATTRIB66
          ,nat_column_68 -- IIT_CHR_ATTRIB67
          ,nat_column_69 -- IIT_CHR_ATTRIB68
          ,nat_column_70 -- IIT_CHR_ATTRIB69
          ,nat_column_71 -- IIT_CHR_ATTRIB70
          ,nat_column_72 -- IIT_CHR_ATTRIB71
          ,nat_column_73 -- IIT_CHR_ATTRIB72
          ,nat_column_74 -- IIT_CHR_ATTRIB73
          ,nat_column_75 -- IIT_CHR_ATTRIB74
          ,nat_column_76 -- IIT_CHR_ATTRIB75
          ,nat_column_77 -- IIT_NUM_ATTRIB76
          ,nat_column_78 -- IIT_NUM_ATTRIB77
          ,nat_column_79 -- IIT_NUM_ATTRIB78
          ,nat_column_80 -- IIT_NUM_ATTRIB79
          ,nat_column_81 -- IIT_NUM_ATTRIB80
          ,nat_column_82 -- IIT_NUM_ATTRIB81
          ,nat_column_83 -- IIT_NUM_ATTRIB82
          ,nat_column_84 -- IIT_NUM_ATTRIB83
          ,nat_column_85 -- IIT_NUM_ATTRIB84
          ,nat_column_86 -- IIT_NUM_ATTRIB85
          ,nat_column_87 -- IIT_DATE_ATTRIB86
          ,nat_column_88 -- IIT_DATE_ATTRIB87
          ,nat_column_89 -- IIT_DATE_ATTRIB88
          ,nat_column_90 -- IIT_DATE_ATTRIB89
          ,nat_column_91 -- IIT_DATE_ATTRIB90
          ,nat_column_92 -- IIT_DATE_ATTRIB91
          ,nat_column_93 -- IIT_DATE_ATTRIB92
          ,nat_column_94 -- IIT_DATE_ATTRIB93
          ,nat_column_95 -- IIT_DATE_ATTRIB94
          ,nat_column_96 -- IIT_DATE_ATTRIB95
          ,nat_column_97 -- IIT_ANGLE
          ,nat_column_98 -- IIT_ANGLE_TXT
          ,nat_column_99 -- IIT_CLASS
          ,nat_column_100 -- IIT_CLASS_TXT
          ,nat_column_101 -- IIT_COLOUR
          ,nat_column_102 -- IIT_COLOUR_TXT
          ,nat_column_103 -- IIT_COORD_FLAG
          ,nat_column_104 -- IIT_DESCRIPTION
          ,nat_column_105 -- IIT_DIAGRAM
          ,nat_column_106 -- IIT_DISTANCE
          ,nat_column_107 -- IIT_END_CHAIN
          ,nat_column_108 -- IIT_GAP
          ,nat_column_109 -- IIT_HEIGHT
          ,nat_column_110 -- IIT_HEIGHT_2
          ,nat_column_111 -- IIT_ID_CODE
          ,nat_column_112 -- IIT_INSTAL_DATE
          ,nat_column_113 -- IIT_INVENT_DATE
          ,nat_column_114 -- IIT_INV_OWNERSHIP
          ,nat_column_115 -- IIT_ITEMCODE
          ,nat_column_116 -- IIT_LCO_LAMP_CONFIG_ID
          ,nat_column_117 -- IIT_LENGTH
          ,nat_column_118 -- IIT_MATERIAL
          ,nat_column_119 -- IIT_MATERIAL_TXT
          ,nat_column_120 -- IIT_METHOD
          ,nat_column_121 -- IIT_METHOD_TXT
          ,nat_column_122 -- IIT_NOTE
          ,nat_column_123 -- IIT_NO_OF_UNITS
          ,nat_column_124 -- IIT_OPTIONS
          ,nat_column_125 -- IIT_OPTIONS_TXT
          ,nat_column_126 -- IIT_OUN_ORG_ID_ELEC_BOARD
          ,nat_column_127 -- IIT_OWNER
          ,nat_column_128 -- IIT_OWNER_TXT
          ,nat_column_129 -- IIT_PEO_INVENT_BY_ID
          ,nat_column_130 -- IIT_PHOTO
          ,nat_column_131 -- IIT_POWER
          ,nat_column_132 -- IIT_PROV_FLAG
          ,nat_column_133 -- IIT_REV_BY
          ,nat_column_134 -- IIT_REV_DATE
          ,nat_column_135 -- IIT_TYPE
          ,nat_column_136 -- IIT_TYPE_TXT
          ,nat_column_137 -- IIT_WIDTH
          ,nat_column_138 -- IIT_XTRA_CHAR_1
          ,nat_column_139 -- IIT_XTRA_DATE_1
          ,nat_column_140 -- IIT_XTRA_DOMAIN_1
          ,nat_column_141 -- IIT_XTRA_DOMAIN_TXT_1
          ,nat_column_142 -- IIT_XTRA_NUMBER_1
          ,nat_column_143 -- IIT_X_SECT
          ,nat_column_144 -- IIT_DET_XSP
          ,nat_column_145 -- IIT_OFFSET
          ,nat_column_146 -- IIT_X
          ,nat_column_147 -- IIT_Y
          ,nat_column_148 -- IIT_Z
          ,nat_column_149 -- IIT_NUM_ATTRIB96
          ,nat_column_150 -- IIT_NUM_ATTRIB97
          ,nat_column_151 -- IIT_NUM_ATTRIB98
          ,nat_column_152 -- IIT_NUM_ATTRIB99
          ,nat_column_153 -- IIT_NUM_ATTRIB100
          ,nat_column_154 -- IIT_NUM_ATTRIB101
          ,nat_column_155 -- IIT_NUM_ATTRIB102
          ,nat_column_156 -- IIT_NUM_ATTRIB103
          ,nat_column_157 -- IIT_NUM_ATTRIB104
          ,nat_column_158 -- IIT_NUM_ATTRIB105
          ,nat_column_159 -- IIT_NUM_ATTRIB106
          ,nat_column_160 -- IIT_NUM_ATTRIB107
          ,nat_column_161 -- IIT_NUM_ATTRIB108
          ,nat_column_162 -- IIT_NUM_ATTRIB109
          ,nat_column_163 -- IIT_NUM_ATTRIB110
          ,nat_column_164 -- IIT_NUM_ATTRIB111
          ,nat_column_165 -- IIT_NUM_ATTRIB112
          ,nat_column_166 -- IIT_NUM_ATTRIB113
          ,nat_column_167 -- IIT_NUM_ATTRIB114
          ,nat_column_168 -- IIT_NUM_ATTRIB115
          )
   VALUES (l_aud_seq -- nat_audit_id
          ,l_old_or_new -- nat_old_or_new
          ,p_audit_type -- nat_audit_type
          ,c_inv_table_name -- nat_audit_table
          ,l_user -- nat_performed_by
          ,l_session_id -- nat_session_id
          ,TO_CHAR(p_rec_iit_new.IIT_NE_ID) -- nat_key_info_1
          ,p_rec_iit_new.IIT_PRIMARY_KEY -- nat_key_info_2
          ,p_rec_iit_new.IIT_FOREIGN_KEY -- nat_key_info_3
          ,p_rec_iit_new.IIT_INV_TYPE -- nat_key_info_4
          ,TO_CHAR(p_rec_iit_new.IIT_NE_ID) -- nat_column_1
          ,p_rec_iit_new.IIT_INV_TYPE -- nat_column_2
          ,p_rec_iit_new.IIT_PRIMARY_KEY -- nat_column_3
          ,TO_CHAR(p_rec_iit_new.IIT_START_DATE,c_date_format) -- nat_column_4
          ,TO_CHAR(p_rec_iit_new.IIT_ADMIN_UNIT) -- nat_column_9
          ,p_rec_iit_new.IIT_DESCR -- nat_column_10
          ,TO_CHAR(p_rec_iit_new.IIT_END_DATE,c_date_format) -- nat_column_11
          ,p_rec_iit_new.IIT_FOREIGN_KEY -- nat_column_12
          ,TO_CHAR(p_rec_iit_new.IIT_LOCATED_BY) -- nat_column_13
          ,TO_CHAR(p_rec_iit_new.IIT_POSITION) -- nat_column_14
          ,TO_CHAR(p_rec_iit_new.IIT_X_COORD) -- nat_column_15
          ,TO_CHAR(p_rec_iit_new.IIT_Y_COORD) -- nat_column_16
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB16) -- nat_column_17
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB17) -- nat_column_18
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB18) -- nat_column_19
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB19) -- nat_column_20
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB20) -- nat_column_21
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB21) -- nat_column_22
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB22) -- nat_column_23
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB23) -- nat_column_24
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB24) -- nat_column_25
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB25) -- nat_column_26
          ,p_rec_iit_new.IIT_CHR_ATTRIB26 -- nat_column_27
          ,p_rec_iit_new.IIT_CHR_ATTRIB27 -- nat_column_28
          ,p_rec_iit_new.IIT_CHR_ATTRIB28 -- nat_column_29
          ,p_rec_iit_new.IIT_CHR_ATTRIB29 -- nat_column_30
          ,p_rec_iit_new.IIT_CHR_ATTRIB30 -- nat_column_31
          ,p_rec_iit_new.IIT_CHR_ATTRIB31 -- nat_column_32
          ,p_rec_iit_new.IIT_CHR_ATTRIB32 -- nat_column_33
          ,p_rec_iit_new.IIT_CHR_ATTRIB33 -- nat_column_34
          ,p_rec_iit_new.IIT_CHR_ATTRIB34 -- nat_column_35
          ,p_rec_iit_new.IIT_CHR_ATTRIB35 -- nat_column_36
          ,p_rec_iit_new.IIT_CHR_ATTRIB36 -- nat_column_37
          ,p_rec_iit_new.IIT_CHR_ATTRIB37 -- nat_column_38
          ,p_rec_iit_new.IIT_CHR_ATTRIB38 -- nat_column_39
          ,p_rec_iit_new.IIT_CHR_ATTRIB39 -- nat_column_40
          ,p_rec_iit_new.IIT_CHR_ATTRIB40 -- nat_column_41
          ,p_rec_iit_new.IIT_CHR_ATTRIB41 -- nat_column_42
          ,p_rec_iit_new.IIT_CHR_ATTRIB42 -- nat_column_43
          ,p_rec_iit_new.IIT_CHR_ATTRIB43 -- nat_column_44
          ,p_rec_iit_new.IIT_CHR_ATTRIB44 -- nat_column_45
          ,p_rec_iit_new.IIT_CHR_ATTRIB45 -- nat_column_46
          ,p_rec_iit_new.IIT_CHR_ATTRIB46 -- nat_column_47
          ,p_rec_iit_new.IIT_CHR_ATTRIB47 -- nat_column_48
          ,p_rec_iit_new.IIT_CHR_ATTRIB48 -- nat_column_49
          ,p_rec_iit_new.IIT_CHR_ATTRIB49 -- nat_column_50
          ,p_rec_iit_new.IIT_CHR_ATTRIB50 -- nat_column_51
          ,p_rec_iit_new.IIT_CHR_ATTRIB51 -- nat_column_52
          ,p_rec_iit_new.IIT_CHR_ATTRIB52 -- nat_column_53
          ,p_rec_iit_new.IIT_CHR_ATTRIB53 -- nat_column_54
          ,p_rec_iit_new.IIT_CHR_ATTRIB54 -- nat_column_55
          ,p_rec_iit_new.IIT_CHR_ATTRIB55 -- nat_column_56
          ,p_rec_iit_new.IIT_CHR_ATTRIB56 -- nat_column_57
          ,p_rec_iit_new.IIT_CHR_ATTRIB57 -- nat_column_58
          ,p_rec_iit_new.IIT_CHR_ATTRIB58 -- nat_column_59
          ,p_rec_iit_new.IIT_CHR_ATTRIB59 -- nat_column_60
          ,p_rec_iit_new.IIT_CHR_ATTRIB60 -- nat_column_61
          ,p_rec_iit_new.IIT_CHR_ATTRIB61 -- nat_column_62
          ,p_rec_iit_new.IIT_CHR_ATTRIB62 -- nat_column_63
          ,p_rec_iit_new.IIT_CHR_ATTRIB63 -- nat_column_64
          ,p_rec_iit_new.IIT_CHR_ATTRIB64 -- nat_column_65
          ,p_rec_iit_new.IIT_CHR_ATTRIB65 -- nat_column_66
          ,p_rec_iit_new.IIT_CHR_ATTRIB66 -- nat_column_67
          ,p_rec_iit_new.IIT_CHR_ATTRIB67 -- nat_column_68
          ,p_rec_iit_new.IIT_CHR_ATTRIB68 -- nat_column_69
          ,p_rec_iit_new.IIT_CHR_ATTRIB69 -- nat_column_70
          ,p_rec_iit_new.IIT_CHR_ATTRIB70 -- nat_column_71
          ,p_rec_iit_new.IIT_CHR_ATTRIB71 -- nat_column_72
          ,p_rec_iit_new.IIT_CHR_ATTRIB72 -- nat_column_73
          ,p_rec_iit_new.IIT_CHR_ATTRIB73 -- nat_column_74
          ,p_rec_iit_new.IIT_CHR_ATTRIB74 -- nat_column_75
          ,p_rec_iit_new.IIT_CHR_ATTRIB75 -- nat_column_76
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB76) -- nat_column_77
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB77) -- nat_column_78
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB78) -- nat_column_79
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB79) -- nat_column_80
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB80) -- nat_column_81
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB81) -- nat_column_82
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB82) -- nat_column_83
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB83) -- nat_column_84
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB84) -- nat_column_85
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB85) -- nat_column_86
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB86,c_date_format) -- nat_column_87
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB87,c_date_format) -- nat_column_88
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB88,c_date_format) -- nat_column_89
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB89,c_date_format) -- nat_column_90
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB90,c_date_format) -- nat_column_91
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB91,c_date_format) -- nat_column_92
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB92,c_date_format) -- nat_column_93
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB93,c_date_format) -- nat_column_94
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB94,c_date_format) -- nat_column_95
          ,TO_CHAR(p_rec_iit_new.IIT_DATE_ATTRIB95,c_date_format) -- nat_column_96
          ,TO_CHAR(p_rec_iit_new.IIT_ANGLE) -- nat_column_97
          ,p_rec_iit_new.IIT_ANGLE_TXT -- nat_column_98
          ,p_rec_iit_new.IIT_CLASS -- nat_column_99
          ,p_rec_iit_new.IIT_CLASS_TXT -- nat_column_100
          ,p_rec_iit_new.IIT_COLOUR -- nat_column_101
          ,p_rec_iit_new.IIT_COLOUR_TXT -- nat_column_102
          ,p_rec_iit_new.IIT_COORD_FLAG -- nat_column_103
          ,p_rec_iit_new.IIT_DESCRIPTION -- nat_column_104
          ,p_rec_iit_new.IIT_DIAGRAM -- nat_column_105
          ,TO_CHAR(p_rec_iit_new.IIT_DISTANCE) -- nat_column_106
          ,TO_CHAR(p_rec_iit_new.IIT_END_CHAIN) -- nat_column_107
          ,TO_CHAR(p_rec_iit_new.IIT_GAP) -- nat_column_108
          ,TO_CHAR(p_rec_iit_new.IIT_HEIGHT) -- nat_column_109
          ,TO_CHAR(p_rec_iit_new.IIT_HEIGHT_2) -- nat_column_110
          ,p_rec_iit_new.IIT_ID_CODE -- nat_column_111
          ,TO_CHAR(p_rec_iit_new.IIT_INSTAL_DATE,c_date_format) -- nat_column_112
          ,TO_CHAR(p_rec_iit_new.IIT_INVENT_DATE,c_date_format) -- nat_column_113
          ,p_rec_iit_new.IIT_INV_OWNERSHIP -- nat_column_114
          ,p_rec_iit_new.IIT_ITEMCODE -- nat_column_115
          ,TO_CHAR(p_rec_iit_new.IIT_LCO_LAMP_CONFIG_ID) -- nat_column_116
          ,TO_CHAR(p_rec_iit_new.IIT_LENGTH) -- nat_column_117
          ,p_rec_iit_new.IIT_MATERIAL -- nat_column_118
          ,p_rec_iit_new.IIT_MATERIAL_TXT -- nat_column_119
          ,p_rec_iit_new.IIT_METHOD -- nat_column_120
          ,p_rec_iit_new.IIT_METHOD_TXT -- nat_column_121
          ,p_rec_iit_new.IIT_NOTE -- nat_column_122
          ,TO_CHAR(p_rec_iit_new.IIT_NO_OF_UNITS) -- nat_column_123
          ,p_rec_iit_new.IIT_OPTIONS -- nat_column_124
          ,p_rec_iit_new.IIT_OPTIONS_TXT -- nat_column_125
          ,TO_CHAR(p_rec_iit_new.IIT_OUN_ORG_ID_ELEC_BOARD) -- nat_column_126
          ,p_rec_iit_new.IIT_OWNER -- nat_column_127
          ,p_rec_iit_new.IIT_OWNER_TXT -- nat_column_128
          ,TO_CHAR(p_rec_iit_new.IIT_PEO_INVENT_BY_ID) -- nat_column_129
          ,p_rec_iit_new.IIT_PHOTO -- nat_column_130
          ,TO_CHAR(p_rec_iit_new.IIT_POWER) -- nat_column_131
          ,p_rec_iit_new.IIT_PROV_FLAG -- nat_column_132
          ,p_rec_iit_new.IIT_REV_BY -- nat_column_133
          ,TO_CHAR(p_rec_iit_new.IIT_REV_DATE,c_date_format) -- nat_column_134
          ,p_rec_iit_new.IIT_TYPE -- nat_column_135
          ,p_rec_iit_new.IIT_TYPE_TXT -- nat_column_136
          ,TO_CHAR(p_rec_iit_new.IIT_WIDTH) -- nat_column_137
          ,p_rec_iit_new.IIT_XTRA_CHAR_1 -- nat_column_138
          ,TO_CHAR(p_rec_iit_new.IIT_XTRA_DATE_1,c_date_format) -- nat_column_139
          ,p_rec_iit_new.IIT_XTRA_DOMAIN_1 -- nat_column_140
          ,p_rec_iit_new.IIT_XTRA_DOMAIN_TXT_1 -- nat_column_141
          ,TO_CHAR(p_rec_iit_new.IIT_XTRA_NUMBER_1) -- nat_column_142
          ,p_rec_iit_new.IIT_X_SECT -- nat_column_143
          ,p_rec_iit_new.IIT_DET_XSP -- nat_column_144
          ,TO_CHAR(p_rec_iit_new.IIT_OFFSET) -- nat_column_145
          ,TO_CHAR(p_rec_iit_new.IIT_X) -- nat_column_146
          ,TO_CHAR(p_rec_iit_new.IIT_Y) -- nat_column_147
          ,TO_CHAR(p_rec_iit_new.IIT_Z) -- nat_column_148
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB96) -- nat_column_149
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB97) -- nat_column_150
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB98) -- nat_column_151
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB99) -- nat_column_152
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB100) -- nat_column_153
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB101) -- nat_column_154
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB102) -- nat_column_155
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB103) -- nat_column_156
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB104) -- nat_column_157
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB105) -- nat_column_158
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB106) -- nat_column_159
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB107) -- nat_column_160
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB108) -- nat_column_161
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB109) -- nat_column_162
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB110) -- nat_column_163
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB111) -- nat_column_164
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB112) -- nat_column_165
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB113) -- nat_column_166
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB114) -- nat_column_167
          ,TO_CHAR(p_rec_iit_new.IIT_NUM_ATTRIB115) -- nat_column_168
          );
--
--   Output a debug message to say leaving procedure
   nm_debug.proc_end(g_package_name,'create_nat_pair_for_val');
--
EXCEPTION
   WHEN do_not_audit
    THEN
      Null;
END create_nat_pair_for_val;
--
-----------------------------------------------------------------------------
--
END xval_audit;
/
