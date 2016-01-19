Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Types
Imports System.Data
Imports System.Threading

Public Class TI_Tools
    Private pg_init_error As Exception
    Private TI_conn As Oracle.DataAccess.Client.OracleConnection = main_form.TI_Conn
    Private Fill_thread As Thread

    Public Function add_SNIN(s_Operation As String, Optional p_iit_ne_id As Decimal = -1, Optional p_effective_date_string As String = "-1", Optional p_admin_unit As Integer = -1, Optional p_x_sect As String = "-1", Optional p_descr As String = "-1", Optional p_note As String = "-1", Optional pf_loc_note As String = "-1", Optional pf_city_rd_flg As String = "-1", Optional pf_cnty_rd_flg As String = "-1", Optional pf_off_netwrk_note As String = "-1", Optional pf_dstnc_from_pvmt As Single = -1, Optional pf_lat As Double = -1, Optional pf_longtd As Double = -1, Optional s_LRM As String = "-1", Optional n_MP As Single = -1, Optional pf_sign_inv_side_of_rd As String = "-1", Optional pf_sign_inv_trvl_dir As String = "-1", Optional s_sfa_id As String = "N/A") As XODOT_SIGNS_ASSET_OP
        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNIN_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As XODOT_SIGNS_ASSET_OP = Nothing
        Dim my_error As Boolean = False

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snin_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_Operation"
            os_Operation.Value = s_Operation
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)



            Dim op_iit_ne_id As New OracleParameter
            Dim op_effective_date As New OracleParameter
            Dim op_admin_unit As New OracleParameter
            Dim op_x_sect As New OracleParameter
            Dim op_descr As New OracleParameter
            Dim op_note As New OracleParameter

            Dim opf_loc_note As New OracleParameter
            Dim opf_city_rd_flg As New OracleParameter
            Dim opf_cnty_rd_flg As New OracleParameter
            Dim opf_off_netwrk_note As New OracleParameter
            Dim opf_dstnc_from_pvmt As New OracleParameter
            Dim opf_lat As New OracleParameter
            Dim opf_longtd As New OracleParameter

            Dim os_LRM As New OracleParameter
            Dim on_MP As New OracleParameter

            If p_iit_ne_id <> -1 Then
                op_iit_ne_id.OracleDbType = OracleDbType.Decimal
                op_iit_ne_id.Direction = ParameterDirection.Input
                op_iit_ne_id.ParameterName = "p_iit_ne_id"
                op_iit_ne_id.Value = p_iit_ne_id
                o_cmd.Parameters.Add(op_iit_ne_id)
            End If

            If _chk_dt_string(p_effective_date_string) <> "-1" Then
                op_effective_date.OracleDbType = OracleDbType.Date
                op_effective_date.Direction = ParameterDirection.Input
                op_effective_date.ParameterName = "p_effective_date"
                op_effective_date.Value = _sanitize_date_string(p_effective_date_string)
                o_cmd.Parameters.Add(op_effective_date)

            End If

            If p_admin_unit <> -1 Then
                op_admin_unit.OracleDbType = OracleDbType.Int16
                op_admin_unit.Direction = ParameterDirection.Input
                op_admin_unit.ParameterName = "p_admin_unit"
                op_admin_unit.Value = p_admin_unit
                o_cmd.Parameters.Add(op_admin_unit)
            End If

            ''**Currently setting X_SECT TO a set vaule pending if ODOT is goign to keep it or remove it **
            p_x_sect = "-1"

            If p_x_sect <> "-1" Then
                op_x_sect.OracleDbType = OracleDbType.Varchar2
                op_x_sect.Direction = ParameterDirection.Input
                op_x_sect.ParameterName = "p_x_sect"
                op_x_sect.Value = p_x_sect
                o_cmd.Parameters.Add(op_x_sect)
            End If

            If p_descr <> "-1" Then
                op_descr.OracleDbType = OracleDbType.Varchar2
                op_descr.Direction = ParameterDirection.Input
                op_descr.ParameterName = "p_descr"
                op_descr.Value = p_descr
                o_cmd.Parameters.Add(op_descr)
            End If

            If p_note <> "-1" Then
                op_note.OracleDbType = OracleDbType.Varchar2
                op_note.Direction = ParameterDirection.Input
                op_note.ParameterName = "p_note"
                op_note.Value = p_note
                o_cmd.Parameters.Add(op_note)
            End If

            If pf_loc_note <> "-1" Then
                opf_loc_note.OracleDbType = OracleDbType.Varchar2
                opf_loc_note.Direction = ParameterDirection.Input
                opf_loc_note.ParameterName = "pf_loc_note"
                opf_loc_note.Value = pf_loc_note
                o_cmd.Parameters.Add(opf_loc_note)
            End If

            If pf_city_rd_flg <> "-1" Then
                opf_city_rd_flg.OracleDbType = OracleDbType.Varchar2
                opf_city_rd_flg.Direction = ParameterDirection.Input
                opf_city_rd_flg.ParameterName = "pf_city_rd_flg"
                opf_city_rd_flg.Value = pf_city_rd_flg
                o_cmd.Parameters.Add(opf_city_rd_flg)
            End If

            If pf_cnty_rd_flg <> "-1" Then
                opf_cnty_rd_flg.OracleDbType = OracleDbType.Varchar2
                opf_cnty_rd_flg.Direction = ParameterDirection.Input
                opf_cnty_rd_flg.ParameterName = "pf_cnty_rd_flg"
                opf_cnty_rd_flg.Value = pf_cnty_rd_flg
                o_cmd.Parameters.Add(opf_cnty_rd_flg)
            End If

            If pf_off_netwrk_note <> "-1" Then
                opf_off_netwrk_note.OracleDbType = OracleDbType.Varchar2
                opf_off_netwrk_note.Direction = ParameterDirection.Input
                opf_off_netwrk_note.ParameterName = "pf_off_netwrk_note"
                opf_off_netwrk_note.Value = pf_off_netwrk_note
                o_cmd.Parameters.Add(opf_off_netwrk_note)
            End If

            If pf_dstnc_from_pvmt <> "-1" Then
                opf_dstnc_from_pvmt.OracleDbType = OracleDbType.Single
                opf_dstnc_from_pvmt.Direction = ParameterDirection.Input
                opf_dstnc_from_pvmt.ParameterName = "pf_dstnc_from_pvmt"
                opf_dstnc_from_pvmt.Value = pf_dstnc_from_pvmt
                o_cmd.Parameters.Add(opf_dstnc_from_pvmt)
            End If

            If pf_lat <> "-1" Then
                opf_lat.OracleDbType = OracleDbType.Single
                opf_lat.Direction = ParameterDirection.Input
                opf_lat.ParameterName = "pf_lat"
                opf_lat.Value = pf_lat
                o_cmd.Parameters.Add(opf_lat)
            End If

            If pf_longtd <> "-1" Then
                opf_longtd.OracleDbType = OracleDbType.Single
                opf_longtd.Direction = ParameterDirection.Input
                opf_longtd.ParameterName = "pf_longtd"
                opf_longtd.Value = pf_longtd
                o_cmd.Parameters.Add(opf_longtd)
            End If

            If s_LRM <> "-1" Then
                os_LRM.OracleDbType = OracleDbType.Varchar2
                os_LRM.Direction = ParameterDirection.Input
                os_LRM.ParameterName = "s_LRM"
                os_LRM.Value = s_LRM
                o_cmd.Parameters.Add(os_LRM)
            End If

            If n_MP <> "-1" Then
                on_MP.OracleDbType = OracleDbType.Single
                on_MP.Direction = ParameterDirection.Input
                on_MP.ParameterName = "n_MP"
                on_MP.Value = n_MP
                o_cmd.Parameters.Add(on_MP)
            End If

            Dim opf_sign_inv_side_of_rd As New OracleParameter
            If pf_sign_inv_side_of_rd <> "-1" Then
                opf_sign_inv_side_of_rd.OracleDbType = OracleDbType.Varchar2
                opf_sign_inv_side_of_rd.Direction = ParameterDirection.Input
                opf_sign_inv_side_of_rd.ParameterName = "pf_sign_inv_side_of_rd"
                opf_sign_inv_side_of_rd.Value = pf_sign_inv_side_of_rd
                o_cmd.Parameters.Add(opf_sign_inv_side_of_rd)
            End If


            Dim opf_sign_inv_trvl_dir As New OracleParameter
            If pf_sign_inv_trvl_dir <> "-1" Then
                opf_sign_inv_trvl_dir.OracleDbType = OracleDbType.Varchar2
                opf_sign_inv_trvl_dir.Direction = ParameterDirection.Input
                opf_sign_inv_trvl_dir.ParameterName = "pf_sign_inv_trvl_dir"
                opf_sign_inv_trvl_dir.Value = pf_sign_inv_trvl_dir
                o_cmd.Parameters.Add(opf_sign_inv_trvl_dir)
            End If

            Dim os_sfa_id As New OracleParameter
            If s_sfa_id <> "-1" Then
                os_sfa_id.OracleDbType = OracleDbType.Varchar2
                os_sfa_id.Direction = ParameterDirection.Input
                os_sfa_id.ParameterName = "s_sfa_id"
                os_sfa_id.Value = s_sfa_id
                o_cmd.Parameters.Add(os_sfa_id)
            End If





            o_cmd.ExecuteNonQuery()

            Dim t_output As New XODOT_SIGNS_TASK_LIST

            ret_val = ot_result.Value()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw

        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If IsNothing(ret_val) Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If

        Return ret_val

    End Function


    Public Function add_SNSN(s_Operation As String, p_iit_ne_id As String, Optional p_effective_date As String = "-1", Optional p_admin_unit As Integer = -1, Optional p_x_sect As String = "-1", Optional p_descr As String = "-1", Optional p_note As String = "-1" _
            , Optional pf_sign_typ As String = "-1", Optional pf_std_sign_id As String = "-1", Optional pf_fail_flg As String = "-1" _
            , Optional pf_facing_dir As String = "-1", Optional pf_sbstr As String = "-1", Optional pf_sheeting As String = "-1" _
            , Optional pf_soi_flg As String = "-1", Optional pf_custom_lgnd As String = "-1", Optional pf_custom_pic_path As String = "-1" _
            , Optional pf_est_rplcmnt_dt As String = "-1", Optional pf_insp_dt As String = "-1", Optional pf_install_dt As String = "-1" _
            , Optional pf_custom_wd As Single = -1, Optional pf_custom_ht As Single = -1, Optional pf_recyc_cnt As Single = -1 _
            , Optional s_sfa_id As String = "N/A"
            ) As XODOT_SIGNS_ASSET_OP

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNSN_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As New XODOT_SIGNS_ASSET_OP

        '(t_result 						out		xodot_signs_asset_op
        ',s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
        ',p_iit_ne_id					in 		number 	-- THis is the Parent NE_ID			
        '---AssetInformation
        ',p_effective_date				IN		nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date								
        ',p_x_sect						IN		nm_inv_items_all.iit_x_sect%TYPE DEFAULT NULL 
        ',p_descr						IN		nm_inv_items_all.iit_descr%TYPE DEFAULT NULL 
        ',p_note							IN		nm_inv_items_all.iit_note%TYPE DEFAULT NULL 
        '--<FLEXIBLEATTRIBUTES>		
        ',pf_sign_typ					IN		nm_inv_items_all.iit_chr_attrib26%TYPE DEFAULT NULL 								
        ',pf_std_sign_id					IN		nm_inv_items_all.iit_chr_attrib27%TYPE DEFAULT NULL 
        ',pf_fail_flg					IN		nm_inv_items_all.iit_chr_attrib28%TYPE DEFAULT NULL 
        ',pf_facing_dir					IN		nm_inv_items_all.iit_chr_attrib29%TYPE DEFAULT NULL 
        ',pf_sbstr						IN		nm_inv_items_all.iit_chr_attrib30%TYPE DEFAULT NULL 
        ',pf_sheeting					IN		nm_inv_items_all.iit_chr_attrib31%TYPE DEFAULT NULL 
        ',pf_soi_flg						IN		nm_inv_items_all.iit_chr_attrib32%TYPE DEFAULT NULL 
        ',pf_custom_lgnd					IN		nm_inv_items_all.iit_chr_attrib66%TYPE DEFAULT NULL 
        ',pf_custom_pic_path				IN		nm_inv_items_all.iit_chr_attrib67%TYPE DEFAULT NULL 
        ',pf_est_rplcmnt_dt				IN		nm_inv_items_all.iit_date_attrib86%TYPE DEFAULT NULL 
        ',pf_insp_dt						IN		nm_inv_items_all.iit_date_attrib87%TYPE DEFAULT NULL 
        ',pf_install_dt					IN		nm_inv_items_all.iit_instal_date%TYPE DEFAULT NULL 
        ',pf_custom_wd					IN		nm_inv_items_all.iit_num_attrib101%TYPE DEFAULT NULL 
        ',pf_custom_ht					IN		nm_inv_items_all.iit_num_attrib102%TYPE DEFAULT NULL 
        ',pf_recyc_cnt					IN		nm_inv_items_all.iit_num_attrib103%TYPE DEFAULT NULL 
        ') is

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snsn_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_Operation"
            os_Operation.Value = s_Operation
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)



            Dim op_iit_ne_id As New OracleParameter

            If p_iit_ne_id <> "-1" Then
                op_iit_ne_id.OracleDbType = OracleDbType.Int64
                op_iit_ne_id.Direction = ParameterDirection.Input
                op_iit_ne_id.ParameterName = "p_iit_ne_id"
                op_iit_ne_id.Value = Convert.ToInt64(p_iit_ne_id.ToString)
                o_cmd.Parameters.Add(op_iit_ne_id)
            End If



            Dim op_effective_date As New OracleParameter
            Dim op_x_sect As New OracleParameter
            Dim op_descr As New OracleParameter
            Dim op_note As New OracleParameter
            Dim opf_sign_typ As New OracleParameter
            Dim opf_std_sign_id As New OracleParameter
            Dim opf_fail_flg As New OracleParameter
            Dim opf_facing_dir As New OracleParameter
            Dim opf_sbstr As New OracleParameter
            Dim opf_sheeting As New OracleParameter
            Dim opf_soi_flg As New OracleParameter
            Dim opf_custom_lgnd As New OracleParameter
            Dim opf_custom_pic_path As New OracleParameter
            Dim opf_est_rplcmnt_dt As New OracleParameter
            Dim opf_insp_dt As New OracleParameter
            Dim opf_install_dt As New OracleParameter
            Dim opf_custom_wd As New OracleParameter
            Dim opf_custom_ht As New OracleParameter
            Dim opf_recyc_cnt As New OracleParameter

            If _chk_dt_string(p_effective_date) <> "-1" Then
                op_effective_date.OracleDbType = OracleDbType.Varchar2
                op_effective_date.Direction = ParameterDirection.Input
                op_effective_date.ParameterName = "p_effective_date"
                op_effective_date.Value = _sanitize_date_string(p_effective_date)
                o_cmd.Parameters.Add(op_effective_date)
            End If

            If p_x_sect <> "-1" Then
                op_x_sect.OracleDbType = OracleDbType.Varchar2
                op_x_sect.Direction = ParameterDirection.Input
                op_x_sect.ParameterName = "p_x_sect"
                op_x_sect.Value = p_x_sect
                o_cmd.Parameters.Add(op_x_sect)
            End If

            If p_descr <> "-1" Then
                op_descr.OracleDbType = OracleDbType.Varchar2
                op_descr.Direction = ParameterDirection.Input
                op_descr.ParameterName = "p_descr"
                op_descr.Value = p_descr
                o_cmd.Parameters.Add(op_descr)
            End If

            If p_note <> "-1" Then
                op_note.OracleDbType = OracleDbType.Varchar2
                op_note.Direction = ParameterDirection.Input
                op_note.ParameterName = "p_note"
                op_note.Value = p_note
                o_cmd.Parameters.Add(op_note)
            End If

            If pf_sign_typ <> "-1" Then
                opf_sign_typ.OracleDbType = OracleDbType.Varchar2
                opf_sign_typ.Direction = ParameterDirection.Input
                opf_sign_typ.ParameterName = "pf_sign_typ"
                opf_sign_typ.Value = pf_sign_typ
                o_cmd.Parameters.Add(opf_sign_typ)
            End If

            If pf_std_sign_id <> "-1" Then
                opf_std_sign_id.OracleDbType = OracleDbType.Varchar2
                opf_std_sign_id.Direction = ParameterDirection.Input
                opf_std_sign_id.ParameterName = "pf_std_sign_id"
                opf_std_sign_id.Value = pf_std_sign_id
                o_cmd.Parameters.Add(opf_std_sign_id)
            End If

            If pf_fail_flg <> "-1" Then
                opf_fail_flg.OracleDbType = OracleDbType.Varchar2
                opf_fail_flg.Direction = ParameterDirection.Input
                opf_fail_flg.ParameterName = "pf_fail_flg"
                opf_fail_flg.Value = pf_fail_flg
                o_cmd.Parameters.Add(opf_fail_flg)
            End If

            If pf_facing_dir <> "-1" Then
                opf_facing_dir.OracleDbType = OracleDbType.Varchar2
                opf_facing_dir.Direction = ParameterDirection.Input
                opf_facing_dir.ParameterName = "pf_facing_dir"
                opf_facing_dir.Value = pf_facing_dir
                o_cmd.Parameters.Add(opf_facing_dir)
            End If

            If pf_sheeting <> "-1" Then
                opf_sheeting.OracleDbType = OracleDbType.Varchar2
                opf_sheeting.Direction = ParameterDirection.Input
                opf_sheeting.ParameterName = "pf_sheeting"
                opf_sheeting.Value = pf_sheeting
                o_cmd.Parameters.Add(opf_sheeting)
            End If

            If pf_soi_flg <> "-1" Then
                opf_soi_flg.OracleDbType = OracleDbType.Varchar2
                opf_soi_flg.Direction = ParameterDirection.Input
                opf_soi_flg.ParameterName = "pf_soi_flg"
                opf_soi_flg.Value = pf_soi_flg
                o_cmd.Parameters.Add(opf_soi_flg)
            End If

            If pf_custom_lgnd <> "-1" Then
                opf_custom_lgnd.OracleDbType = OracleDbType.Varchar2
                opf_custom_lgnd.Direction = ParameterDirection.Input
                opf_custom_lgnd.ParameterName = "pf_custom_lgnd"
                opf_custom_lgnd.Value = pf_custom_lgnd
                o_cmd.Parameters.Add(opf_custom_lgnd)
            End If

            If pf_custom_pic_path <> "-1" Then
                opf_custom_pic_path.OracleDbType = OracleDbType.Varchar2
                opf_custom_pic_path.Direction = ParameterDirection.Input
                opf_custom_pic_path.ParameterName = "pf_custom_pic_path"
                opf_custom_pic_path.Value = pf_custom_pic_path
                o_cmd.Parameters.Add(opf_custom_pic_path)
            End If

            If _chk_dt_string(pf_est_rplcmnt_dt) <> "-1" Then
                opf_est_rplcmnt_dt.OracleDbType = OracleDbType.Date
                opf_est_rplcmnt_dt.Direction = ParameterDirection.Input
                opf_est_rplcmnt_dt.ParameterName = "pf_est_rplcmnt_dt"
                opf_est_rplcmnt_dt.Value = _sanitize_date_string(pf_est_rplcmnt_dt)
                o_cmd.Parameters.Add(opf_est_rplcmnt_dt)
            End If

            If _chk_dt_string(pf_insp_dt) <> "-1" Then
                opf_insp_dt.OracleDbType = OracleDbType.Date
                opf_insp_dt.Direction = ParameterDirection.Input
                opf_insp_dt.ParameterName = "pf_insp_dt"
                opf_insp_dt.Value = _sanitize_date_string(pf_insp_dt)
                o_cmd.Parameters.Add(opf_insp_dt)
            End If

            If _chk_dt_string(pf_install_dt) <> "-1" Then
                opf_install_dt.OracleDbType = OracleDbType.Date
                opf_install_dt.Direction = ParameterDirection.Input
                opf_install_dt.ParameterName = "pf_install_dt"
                opf_install_dt.Value = _sanitize_date_string(pf_install_dt)
                o_cmd.Parameters.Add(opf_install_dt)
            End If

            If pf_custom_wd <> "-1" Then
                opf_custom_wd.OracleDbType = OracleDbType.Single
                opf_custom_wd.Direction = ParameterDirection.Input
                opf_custom_wd.ParameterName = "pf_custom_wd"
                opf_custom_wd.Value = pf_custom_wd
                o_cmd.Parameters.Add(opf_custom_wd)
            End If

            If pf_custom_ht <> "-1" Then
                opf_custom_ht.OracleDbType = OracleDbType.Single
                opf_custom_ht.Direction = ParameterDirection.Input
                opf_custom_ht.ParameterName = "pf_custom_ht"
                opf_custom_ht.Value = pf_custom_ht
                o_cmd.Parameters.Add(opf_custom_ht)
            End If

            If pf_recyc_cnt <> "-1" Then
                opf_recyc_cnt.OracleDbType = OracleDbType.Single
                opf_recyc_cnt.Direction = ParameterDirection.Input
                opf_recyc_cnt.ParameterName = "pf_recyc_cnt"
                opf_recyc_cnt.Value = pf_recyc_cnt
                o_cmd.Parameters.Add(opf_recyc_cnt)
            End If


            If pf_sbstr <> "-1" Then
                opf_sbstr.OracleDbType = OracleDbType.Varchar2
                opf_sbstr.Direction = ParameterDirection.Input
                opf_sbstr.ParameterName = "pf_sbstr"
                opf_sbstr.Value = pf_sbstr
                o_cmd.Parameters.Add(opf_sbstr)
            End If


            Dim os_sfa_id As New OracleParameter
            If s_sfa_id <> "-1" Then
                os_sfa_id.OracleDbType = OracleDbType.Varchar2
                os_sfa_id.Direction = ParameterDirection.Input
                os_sfa_id.ParameterName = "s_sfa_id"
                os_sfa_id.Value = s_sfa_id
                o_cmd.Parameters.Add(os_sfa_id)
            End If




            o_cmd.ExecuteNonQuery()



            ret_val = ot_result.Value()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If IsNothing(ret_val) Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If

        Return ret_val

    End Function

    Public Function get_version() As String
        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker, curently used just so ensure the signs_api package is okay
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As String = "ERROR"



        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.CommandText = "xodot_signs_api.get_version"

            Dim oresult As New OracleParameter

            oresult.OracleDbType = OracleDbType.Varchar2
            oresult.Size = 12
            oresult.Direction = ParameterDirection.ReturnValue
            oresult.ParameterName = "result"
            o_cmd.Parameters.Add(oresult)





            o_cmd.ExecuteNonQuery()


            ret_val = "PASSED"


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        Return ret_val

    End Function


    Public Function delete_snsu(p_iit_ne_id As String) As XODOT_SIGNS_ASSET_OP
        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNSU_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As XODOT_SIGNS_ASSET_OP = Nothing

        Dim my_error As Boolean = False

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snsu_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_Operation"
            os_Operation.Value = "D"
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)



            Dim op_iit_ne_id As New OracleParameter


            op_iit_ne_id.OracleDbType = OracleDbType.Single
            op_iit_ne_id.Direction = ParameterDirection.Input
            op_iit_ne_id.ParameterName = "p_iit_ne_id"
            op_iit_ne_id.Value = p_iit_ne_id
            o_cmd.Parameters.Add(op_iit_ne_id)

            o_cmd.ExecuteNonQuery()

            Dim t_output As New XODOT_SIGNS_TASK_LIST

            ret_val = ot_result.Value()


        Catch ex As OracleException
            my_error = True
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw

        Catch ex As Exception
            my_error = True
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If my_error = True Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If


        Return ret_val

    End Function
    Public Function add_SNSU(s_Operation As String, p_iit_ne_id As String, Optional p_effective_date As String = "-1", Optional p_admin_unit As Integer = -1, Optional p_x_sect As String = "-1", Optional p_descr As String = "-1", Optional p_note As String = "-1" _
     , Optional pf_supp_typ As String = "-1", Optional pf_install_dt As String = "-1", Optional pf_no_supps As Single = -1, Optional s_sfa_id As String = "N/A"
         ) As XODOT_SIGNS_ASSET_OP

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNSU_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As New XODOT_SIGNS_ASSET_OP

        '   snsu_opps 			(t_result 						out		xodot_signs_asset_op
        '							,s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
        '							,p_iit_ne_id					in 		number 	-- This is the Parent NE_ID			
        '							---AssetInformation
        '							,p_effective_date               IN     nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
        '							,p_admin_unit                   IN     nm_inv_items_all.iit_admin_unit%TYPE default null
        '							,p_x_sect                       IN     nm_inv_items_all.iit_x_sect%TYPE default null
        '							,p_descr                        IN     nm_inv_items_all.iit_descr%TYPE DEFAULT NULL
        '							,p_note                         IN     nm_inv_items_all.iit_note%TYPE DEFAULT NULL
        '							-- <FLEXIBLE ATTRIBUTES>
        '							,pf_supp_typ                    IN     nm_inv_items_all.iit_chr_attrib26%TYPE  DEFAULT NULL
        '							,pf_install_dt                  IN     nm_inv_items_all.iit_instal_date%TYPE  DEFAULT NULL
        '							,pf_no_supps                    IN     nm_inv_items_all.iit_no_of_units%TYPE  DEFAULT NULL								
        '							) is

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snsu_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_Operation"
            os_Operation.Value = s_Operation
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)


            Dim op_iit_ne_id As New OracleParameter

            If p_iit_ne_id <> "-1" Then
                op_iit_ne_id.OracleDbType = OracleDbType.Decimal
                op_iit_ne_id.Direction = ParameterDirection.Input
                op_iit_ne_id.ParameterName = "p_iit_ne_id"
                op_iit_ne_id.Value = p_iit_ne_id
                o_cmd.Parameters.Add(op_iit_ne_id)
            End If

            Dim op_effective_date As New OracleParameter
            Dim op_x_sect As New OracleParameter
            Dim op_descr As New OracleParameter
            Dim op_note As New OracleParameter


            If _chk_dt_string(p_effective_date) <> "-1" Then
                op_effective_date.OracleDbType = OracleDbType.Varchar2
                op_effective_date.Direction = ParameterDirection.Input
                op_effective_date.ParameterName = "p_effective_date"
                op_effective_date.Value = _sanitize_date_string(p_effective_date)
                o_cmd.Parameters.Add(op_effective_date)
            End If

            If p_x_sect <> "-1" Then
                op_x_sect.OracleDbType = OracleDbType.Varchar2
                op_x_sect.Direction = ParameterDirection.Input
                op_x_sect.ParameterName = "p_x_sect"
                op_x_sect.Value = p_x_sect
                o_cmd.Parameters.Add(op_x_sect)
            End If

            If p_descr <> "-1" Then
                op_descr.OracleDbType = OracleDbType.Varchar2
                op_descr.Direction = ParameterDirection.Input
                op_descr.ParameterName = "p_descr"
                op_descr.Value = p_descr
                o_cmd.Parameters.Add(op_descr)
            End If

            If p_note <> "-1" Then
                op_note.OracleDbType = OracleDbType.Varchar2
                op_note.Direction = ParameterDirection.Input
                op_note.ParameterName = "p_note"
                op_note.Value = p_note
                o_cmd.Parameters.Add(op_note)
            End If

            Dim opf_install_dt As New OracleParameter
            Dim opf_supp_typ As New OracleParameter
            Dim opf_no_supps As New OracleParameter

            If _chk_dt_string(pf_install_dt) <> "-1" Then
                opf_install_dt.OracleDbType = OracleDbType.Varchar2
                opf_install_dt.Direction = ParameterDirection.Input
                opf_install_dt.ParameterName = "pf_install_dt"
                opf_install_dt.Value = _sanitize_date_string(pf_install_dt)
                o_cmd.Parameters.Add(opf_install_dt)
            End If

            If pf_supp_typ <> "-1" Then
                opf_supp_typ.OracleDbType = OracleDbType.Varchar2
                opf_supp_typ.Direction = ParameterDirection.Input
                opf_supp_typ.ParameterName = "pf_supp_typ"
                opf_supp_typ.Value = pf_supp_typ.ToUpper
                o_cmd.Parameters.Add(opf_supp_typ)
            End If

            If pf_no_supps <> "-1" Then
                opf_no_supps.OracleDbType = OracleDbType.Varchar2
                opf_no_supps.Direction = ParameterDirection.Input
                opf_no_supps.ParameterName = "pf_no_supps"
                opf_no_supps.Value = pf_no_supps
                o_cmd.Parameters.Add(opf_no_supps)
            End If

            Dim os_sfa_id As New OracleParameter
            If s_sfa_id <> "-1" Then
                os_sfa_id.OracleDbType = OracleDbType.Varchar2
                os_sfa_id.Direction = ParameterDirection.Input
                os_sfa_id.ParameterName = "s_sfa_id"
                os_sfa_id.Value = s_sfa_id
                o_cmd.Parameters.Add(os_sfa_id)
            End If



            o_cmd.ExecuteNonQuery()



            ret_val = ot_result.Value()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If IsNothing(ret_val) Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If

        Return ret_val

    End Function

    Public Function delete_snml(p_iit_ne_id As String) As XODOT_SIGNS_ASSET_OP

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNML_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As XODOT_SIGNS_ASSET_OP = Nothing

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snml_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_Operation"
            os_Operation.Value = "D"
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)



            Dim op_iit_ne_id As New OracleParameter


            op_iit_ne_id.OracleDbType = OracleDbType.Single
            op_iit_ne_id.Direction = ParameterDirection.Input
            op_iit_ne_id.ParameterName = "p_iit_ne_id"
            op_iit_ne_id.Value = p_iit_ne_id
            o_cmd.Parameters.Add(op_iit_ne_id)

            o_cmd.ExecuteNonQuery()

            Dim t_output As New XODOT_SIGNS_TASK_LIST

            ret_val = ot_result.Value()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If IsNothing(ret_val) Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If


        Return ret_val

    End Function

    Public Function add_SNML(s_Operation As String, p_iit_ne_id As String, Optional p_effective_date As String = "-1", Optional p_admin_unit As Integer = -1, Optional p_x_sect As String = "-1", Optional p_descr As String = "-1", Optional p_note As String = "-1" _
        , Optional pf_actn As String = "-1", Optional pf_cause As String = "-1", Optional pf_sign_dtl As String = "-1", Optional pf_resp_per As String = "-1" _
        , Optional pf_sign_sz As String = "-1", Optional pf_sign_facing As String = "-1", Optional pf_sign_lgnd As String = "-1", Optional pf_comnt As String = "-1" _
        , Optional pf_matl As String = "-1", Optional pf_supp_desc As String = "-1", Optional pf_maint_hist_dt As String = "-1", Optional pf_accomp As String = "-1" _
        , Optional pf_crew_hr As Single = -1, Optional pf_equip_hr As Single = -1, Optional s_sfa_id As String = "N/A"
     ) As XODOT_SIGNS_ASSET_OP

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNML_OPPS
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As New XODOT_SIGNS_ASSET_OP

        'snml_opps 			(t_result 						out		xodot_signs_asset_op
        '								,s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
        '								,p_iit_ne_id					in 		number 	-- This is the Parent NE_ID			
        '								---AssetInformation
        '								,p_effective_date               IN     nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
        '								,p_admin_unit                   IN     nm_inv_items_all.iit_admin_unit%TYPE DEFAULT NULL
        '								,p_x_sect                       IN     nm_inv_items_all.iit_x_sect%TYPE DEFAULT NULL
        '								,p_descr                        IN     nm_inv_items_all.iit_descr%TYPE DEFAULT NULL
        '								,p_note                         IN     nm_inv_items_all.iit_note%TYPE DEFAULT NULL
        '								-- <FLEXIBLE ATTRIBUTES>
        '								,pf_actn                        IN     nm_inv_items_all.iit_chr_attrib26%TYPE DEFAULT NULL
        '								,pf_cause                       IN     nm_inv_items_all.iit_chr_attrib27%TYPE DEFAULT NULL
        '								,pf_sign_dtl                    IN     nm_inv_items_all.iit_chr_attrib28%TYPE DEFAULT NULL
        '								,pf_resp_per                    IN     nm_inv_items_all.iit_chr_attrib29%TYPE DEFAULT NULL
        '								,pf_sign_sz                     IN     nm_inv_items_all.iit_chr_attrib30%TYPE DEFAULT NULL
        '								,pf_sign_facing                 IN     nm_inv_items_all.iit_chr_attrib31%TYPE DEFAULT NULL
        '								,pf_sign_lgnd                   IN     nm_inv_items_all.iit_chr_attrib56%TYPE DEFAULT NULL
        '								,pf_comnt                       IN     nm_inv_items_all.iit_chr_attrib66%TYPE DEFAULT NULL
        '								,pf_matl                        IN     nm_inv_items_all.iit_chr_attrib67%TYPE DEFAULT NULL
        '								,pf_supp_desc                   IN     nm_inv_items_all.iit_chr_attrib70%TYPE DEFAULT NULL
        '								,pf_maint_hist_dt               IN     nm_inv_items_all.iit_date_attrib86%TYPE DEFAULT NULL
        '								,pf_accomp                      IN     nm_inv_items_all.iit_no_of_units%TYPE DEFAULT NULL
        '								,pf_crew_hr                     IN     nm_inv_items_all.iit_num_attrib100%TYPE DEFAULT NULL
        '								,pf_equip_hr                    IN     nm_inv_items_all.iit_num_attrib101%TYPE DEFAULT NULL

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.snml_opps"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);


            Dim os_Operation As New OracleParameter
            os_Operation.OracleDbType = OracleDbType.Varchar2
            os_Operation.Direction = ParameterDirection.Input
            os_Operation.ParameterName = "s_operation"
            os_Operation.Value = s_Operation
            o_cmd.Parameters.Add(os_Operation)


            Dim ot_result As New OracleParameter

            ot_result.OracleDbType = OracleDbType.Object
            ot_result.Direction = ParameterDirection.Output
            ot_result.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            ot_result.ParameterName = "t_result"

            o_cmd.Parameters.Add(ot_result)


            Dim op_iit_ne_id As New OracleParameter

            If p_iit_ne_id <> "-1" Then
                op_iit_ne_id.OracleDbType = OracleDbType.Int64
                op_iit_ne_id.Direction = ParameterDirection.Input
                op_iit_ne_id.ParameterName = "p_iit_ne_id"
                op_iit_ne_id.Value = p_iit_ne_id
                o_cmd.Parameters.Add(op_iit_ne_id)
            End If

            Dim op_effective_date As New OracleParameter
            Dim op_x_sect As New OracleParameter
            Dim op_descr As New OracleParameter
            Dim op_note As New OracleParameter



            If _chk_dt_string(p_effective_date) <> "-1" Then
                op_effective_date.OracleDbType = OracleDbType.Varchar2
                op_effective_date.Direction = ParameterDirection.Input
                op_effective_date.ParameterName = "p_effective_date"
                op_effective_date.Value = _sanitize_date_string(p_effective_date)
                o_cmd.Parameters.Add(op_effective_date)
            End If

            If p_x_sect <> "-1" Then
                op_x_sect.OracleDbType = OracleDbType.Varchar2
                op_x_sect.Direction = ParameterDirection.Input
                op_x_sect.ParameterName = "p_x_sect"
                op_x_sect.Value = p_x_sect
                o_cmd.Parameters.Add(op_x_sect)
            End If

            If p_descr <> "-1" Then
                op_descr.OracleDbType = OracleDbType.Varchar2
                op_descr.Direction = ParameterDirection.Input
                op_descr.ParameterName = "p_descr"
                op_descr.Value = p_descr
                o_cmd.Parameters.Add(op_descr)
            End If

            If p_note <> "-1" Then
                op_note.OracleDbType = OracleDbType.Varchar2
                op_note.Direction = ParameterDirection.Input
                op_note.ParameterName = "p_note"
                op_note.Value = p_note
                o_cmd.Parameters.Add(op_note)
            End If




            Dim opf_actn As New OracleParameter
            Dim opf_cause As New OracleParameter
            Dim opf_sign_dtl As New OracleParameter
            Dim opf_resp_per As New OracleParameter
            Dim opf_sign_sz As New OracleParameter
            Dim opf_sign_facing As New OracleParameter
            Dim opf_sign_lgnd As New OracleParameter
            Dim opf_comnt As New OracleParameter
            Dim opf_matl As New OracleParameter
            Dim opf_supp_desc As New OracleParameter
            Dim opf_maint_hist_dt As New OracleParameter
            Dim opf_accomp As New OracleParameter
            Dim opf_crew_hr As New OracleParameter
            Dim opf_equip_hr As New OracleParameter


            If pf_actn <> "-1" Then
                opf_actn.OracleDbType = OracleDbType.Varchar2
                opf_actn.Direction = ParameterDirection.Input
                opf_actn.ParameterName = "pf_actn"
                opf_actn.Value = pf_actn.ToUpper
                o_cmd.Parameters.Add(opf_actn)
            End If


            'pf_cause 
            If pf_cause <> "-1" Then
                opf_cause.OracleDbType = OracleDbType.Varchar2
                opf_cause.Direction = ParameterDirection.Input
                opf_cause.ParameterName = "pf_cause"
                opf_cause.Value = pf_cause.ToUpper
                o_cmd.Parameters.Add(opf_cause)
            End If



            If pf_sign_dtl <> "-1" Then
                opf_sign_dtl.OracleDbType = OracleDbType.Varchar2
                opf_sign_dtl.Direction = ParameterDirection.Input
                opf_sign_dtl.ParameterName = "pf_sign_dtl"
                opf_sign_dtl.Value = pf_sign_dtl
                o_cmd.Parameters.Add(opf_sign_dtl)
            End If

            If pf_resp_per <> "-1" Then
                opf_resp_per.OracleDbType = OracleDbType.Varchar2
                opf_resp_per.Direction = ParameterDirection.Input
                opf_resp_per.ParameterName = "pf_resp_per"
                opf_resp_per.Value = pf_resp_per
                o_cmd.Parameters.Add(opf_resp_per)
            End If



            If pf_sign_sz <> "-1" Then
                opf_sign_sz.OracleDbType = OracleDbType.Varchar2
                opf_sign_sz.Direction = ParameterDirection.Input
                opf_sign_sz.ParameterName = "pf_sign_sz"
                opf_sign_sz.Value = pf_sign_sz
                o_cmd.Parameters.Add(opf_sign_sz)
            End If

            If pf_sign_facing <> "-1" Then
                opf_sign_facing.OracleDbType = OracleDbType.Varchar2
                opf_sign_facing.Direction = ParameterDirection.Input
                opf_sign_facing.ParameterName = "pf_sign_facing"
                opf_sign_facing.Value = pf_sign_facing
                o_cmd.Parameters.Add(opf_sign_facing)
            End If

            If pf_sign_lgnd <> "-1" Then
                opf_sign_lgnd.OracleDbType = OracleDbType.Varchar2
                opf_sign_lgnd.Direction = ParameterDirection.Input
                opf_sign_lgnd.ParameterName = "pf_sign_lgnd"
                opf_sign_lgnd.Value = pf_sign_lgnd
                o_cmd.Parameters.Add(opf_sign_lgnd)
            End If



            If pf_comnt <> "-1" Then
                opf_comnt.OracleDbType = OracleDbType.Varchar2
                opf_comnt.Direction = ParameterDirection.Input
                opf_comnt.ParameterName = "pf_comnt"
                opf_comnt.Value = pf_comnt
                o_cmd.Parameters.Add(opf_comnt)
            End If

            If pf_matl <> "-1" Then
                opf_matl.OracleDbType = OracleDbType.Varchar2
                opf_matl.Direction = ParameterDirection.Input
                opf_matl.ParameterName = "pf_matl"
                opf_matl.Value = pf_matl
                o_cmd.Parameters.Add(opf_matl)
            End If

            If pf_supp_desc <> "-1" Then
                opf_supp_desc.OracleDbType = OracleDbType.Varchar2
                opf_supp_desc.Direction = ParameterDirection.Input
                opf_supp_desc.ParameterName = "pf_supp_desc"
                opf_supp_desc.Value = pf_supp_desc
                o_cmd.Parameters.Add(opf_supp_desc)
            End If

            If _chk_dt_string(pf_maint_hist_dt) <> "-1" Then
                opf_maint_hist_dt.OracleDbType = OracleDbType.Date
                opf_maint_hist_dt.Direction = ParameterDirection.Input
                opf_maint_hist_dt.ParameterName = "pf_maint_hist_dt"
                opf_maint_hist_dt.Value = _sanitize_date_string(pf_maint_hist_dt)
                o_cmd.Parameters.Add(opf_maint_hist_dt)
            End If

            If pf_accomp <> "-1" Then
                opf_accomp.OracleDbType = OracleDbType.Varchar2
                opf_accomp.Direction = ParameterDirection.Input
                opf_accomp.ParameterName = "pf_accomp"
                opf_accomp.Value = pf_accomp
                o_cmd.Parameters.Add(opf_accomp)
            End If

            If pf_crew_hr <> "-1" Then
                opf_crew_hr.OracleDbType = OracleDbType.Single
                opf_crew_hr.Direction = ParameterDirection.Input
                opf_crew_hr.ParameterName = "pf_crew_hr"
                opf_crew_hr.Value = pf_crew_hr
                o_cmd.Parameters.Add(opf_crew_hr)
            End If

            If pf_equip_hr <> "-1" Then
                opf_equip_hr.OracleDbType = OracleDbType.Single
                opf_equip_hr.Direction = ParameterDirection.Input
                opf_equip_hr.ParameterName = "pf_equip_hr"
                opf_equip_hr.Value = pf_equip_hr
                o_cmd.Parameters.Add(opf_equip_hr)
            End If

            Dim os_sfa_id As New OracleParameter
            If s_sfa_id <> "-1" Then
                os_sfa_id.OracleDbType = OracleDbType.Varchar2
                os_sfa_id.Direction = ParameterDirection.Input
                os_sfa_id.ParameterName = "s_sfa_id"
                os_sfa_id.Value = s_sfa_id
                o_cmd.Parameters.Add(os_sfa_id)
            End If



            o_cmd.ExecuteNonQuery()




            ret_val = ot_result.Value()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            Select Case ex.HResult
                Case -2147467259
                    ret_val = New XODOT_SIGNS_ASSET_OP
                    ret_val.ERR_NUM = -888
                    ret_val.ERR_MSG = "Error With TI_API Component"
                Case Else
                    ret_val = New XODOT_SIGNS_ASSET_OP
                    ret_val.ERR_NUM = -999
                    ret_val.ERR_MSG = "Error returning data"
            End Select
            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try

        If IsNothing(ret_val) Then
            ret_val = New XODOT_SIGNS_ASSET_OP
            ret_val.ERR_NUM = -999
            ret_val.ERR_MSG = "Error returning data"

        End If

        Return ret_val
    End Function

    Public Function get_changed_sign_asset(s_crew_number As String, s_sync_date As String, s_asset_type As String) As DataTable
        Dim ret_val As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker, retriving changed assets
        '''''''''''''''''''''''''''''''''''

        'get_sign_assets(s_crew_number varchar2, s_asset_type in varchar2, d_date_last_synced in date, ref_cur out sys_refcursor)
        ' returns nm_inv_items_all

        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_sign_assets"

            Dim os_crew_number As New OracleParameter

            If s_crew_number <> "-1" Then
                os_crew_number.OracleDbType = OracleDbType.Varchar2
                os_crew_number.Direction = ParameterDirection.Input
                os_crew_number.ParameterName = "s_crew_number"
                os_crew_number.Value = s_crew_number
                o_cmd.Parameters.Add(os_crew_number)
            End If


            Dim os_sync_date As New OracleParameter
            If s_sync_date <> "-1" Then
                os_sync_date.OracleDbType = OracleDbType.Date
                os_sync_date.Direction = ParameterDirection.Input
                os_sync_date.ParameterName = "d_date_last_synced"
                os_sync_date.Value = Convert.ToDateTime(s_sync_date)
                o_cmd.Parameters.Add(os_sync_date)
            End If



            Dim os_asset_type As New OracleParameter

            If s_asset_type <> "-1" Then
                os_asset_type.OracleDbType = OracleDbType.Varchar2
                os_asset_type.Direction = ParameterDirection.Input
                os_asset_type.ParameterName = "s_asset_type"
                os_asset_type.Value = s_asset_type
                o_cmd.Parameters.Add(os_asset_type)
            End If

            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)

#If DEBUG Then
            ' MsgBox("Asking TI for Changed Asset: " & s_asset_type)
#End If

            ' data_adaptor.Fill(ds)

            'Threading out the fill so the app doesnt look locked

            Fill_thread = New Thread(Sub() Threaded_data_adaptor_fill(data_adaptor, ds))

            Fill_thread.Start()

            Do While Fill_thread.ThreadState = ThreadState.Running
                Application.DoEvents()
            Loop

#If DEBUG Then
            ' MsgBox("TI Returned count: " & ds.Tables(0).Rows.Count, , s_asset_type)
#End If
        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val

    End Function
    Public Function get_mem_location_from_ne_id(n_ne_id As Decimal) As DataTable
        Dim ret_val As DataTable

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker SNIN_OPPS
        'get_mem_location_from_ne_id(n_ne_id in number, ref_cur out sys_refcursor);
        'Returns select ne_loc.ne_unique, ne_owner hwy_num, ne_name_1 MT , ne_name_2 overlap_code,ne_prefix roadway_ID ,ne_number gen_direct ,ne_sub_type link_id , nm_members.* 
        '''''''''''''''''''''''''''''''''''

        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_mem_location_from_ne_id"

            Dim on_ne_id As New OracleParameter

            If n_ne_id <> "-1" Then
                on_ne_id.OracleDbType = OracleDbType.Decimal
                'on_ne_id.OracleDbType = OracleDbType.Varchar2
                on_ne_id.Direction = ParameterDirection.Input
                on_ne_id.ParameterName = "n_ne_id"
                on_ne_id.Value = Convert.ToInt64(n_ne_id)
                'on_ne_id.Value = Convert.ToString(n_ne_id)
                o_cmd.Parameters.Add(on_ne_id)
            End If


            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)



            data_adaptor.Fill(ds)


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw

        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val

    End Function


    Public Function get_child_from_parent_ne_id(n_ne_id As Decimal, s_asset_type As String) As DataTable
        Dim ret_val As DataTable

        '''''''''''''''''''''''''''''''''''
        'Used For: interfacing with TI API made for the broker
        'get_child_from_parent_ne_id(n_ne_id in number, s_child_type varchar2, ref_cur out sys_refcursor)
        'Returns nm_inv_items for the child assests listed
        '''''''''''''''''''''''''''''''''''


        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_child_from_parent_ne_id"

            Dim on_ne_id As New OracleParameter

            If n_ne_id <> "-1" Then
                on_ne_id.OracleDbType = OracleDbType.Decimal
                on_ne_id.Direction = ParameterDirection.Input
                on_ne_id.ParameterName = "n_ne_id"
                on_ne_id.Value = n_ne_id
                o_cmd.Parameters.Add(on_ne_id)
            End If

            Dim os_asset_type As New OracleParameter

            If s_asset_type <> "-1" Then
                os_asset_type.OracleDbType = OracleDbType.Varchar2
                os_asset_type.Direction = ParameterDirection.Input
                os_asset_type.ParameterName = "s_child_type"
                os_asset_type.Value = s_asset_type
                o_cmd.Parameters.Add(os_asset_type)
            End If





            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)



            data_adaptor.Fill(ds)

        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val
    End Function
    Public Enum TI_LOV_DOMAINS
        '''''''''''''''''''''''''''''''''''
        'Used For: a list of values handled by TI Domains
        '''''''''''''''''''''''''''''''''''
        SIGN_SBSTR
        SIGN_SHEETING
        GEN_DIR
    End Enum

    Public Enum TI_LOV_ASSETS
        '''''''''''''''''''''''''''''''''''
        'Used For: a list of values handled by TI assets
        '''''''''''''''''''''''''''''''''''
        SNAC ' Actions
        SNCS 'Causes
        SIGN ' Standard Signs
        SNGR ' Standard Sign Graphics
        SUPP ' Sign Supports
    End Enum


    Public Function get_task_list_assets(s_sync_date As String, Optional s_crew As String = Nothing, Optional ti_c As Oracle.DataAccess.Client.OracleConnection = Nothing) As XODOT_SIGNS_TASK_LIST

        '''''''''''''''''''''''''''''''''''
        'Used For: a list of values handled by TI assets
        '''''''''''''''''''''''''''''''''''

        Dim t_output As New XODOT_SIGNS_TASK_LIST
        Dim my_crew As String

        Try
            Dim o_cmd As New OracleCommand

            If IsNothing(ti_c) Then
                o_cmd.Connection = TI_conn
            Else
                o_cmd.Connection = ti_c
            End If

            If IsNothing(s_crew) Then
                my_crew = main_form.g_s_crew
            Else
                my_crew = s_crew
            End If


            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.CommandText = "xodot_signs_api.get_task_list_sign_assets"

            'get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out t_task_list);
            Dim s_crew_number As New OracleParameter
            s_crew_number.OracleDbType = OracleDbType.Varchar2
            s_crew_number.Direction = ParameterDirection.Input
            s_crew_number.Value = my_crew
            o_cmd.Parameters.Add(s_crew_number)


            Dim d_last_sync_date As New OracleParameter
            d_last_sync_date.OracleDbType = OracleDbType.Date
            d_last_sync_date.Direction = ParameterDirection.Input
            d_last_sync_date.Value = Convert.ToDateTime(s_sync_date)
            'd_last_sync_date.Value = Convert.ToDateTime("21/MAR/2015 8:28:00 PM")
            o_cmd.Parameters.Add(d_last_sync_date)

            Dim output_list As New OracleParameter
            output_list.OracleDbType = OracleDbType.Object
            output_list.Direction = ParameterDirection.Output
            output_list.UdtTypeName = "XODOT_SIGNS_TASK_LIST"
            o_cmd.Parameters.Add(output_list)

            o_cmd.ExecuteNonQuery()



            t_output = output_list.Value()



            Return t_output


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw

        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            Throw
            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
        End Try

        Return t_output
    End Function

    Public Function get_domain_lov(s_domain As String, Optional s_sync_date As String = "") As DataTable

        Dim ret_val As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For:  'get_domain_lov(s_domain in varchar2, info out xodot_signs_asset_op, ref_cur out sys_refcursor ) 
        'select ial_value, ial_meaning from NM_INV_ATTRI_LOOKUP
        '''''''''''''''''''''''''''''''''''


        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_domain_lov"

            Dim os_domain As New OracleParameter
            If s_domain <> "-1" Then
                os_domain.OracleDbType = OracleDbType.Varchar2
                os_domain.Direction = ParameterDirection.Input
                os_domain.ParameterName = "s_domain"
                os_domain.Value = s_domain.ToString.ToUpper
                o_cmd.Parameters.Add(os_domain)
            End If





            Dim oinfo As New OracleParameter

            oinfo.OracleDbType = OracleDbType.Object
            oinfo.Direction = ParameterDirection.Output
            oinfo.ParameterName = "info"
            oinfo.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            o_cmd.Parameters.Add(oinfo)








            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)



            data_adaptor.Fill(ds)

            'Dim tmp As XODOT_SIGNS_ASSET_OP = oinfo.Value



        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val
    End Function

    Public Function get_asset_lov(s_asset As String, Optional s_date_last_synced As String = "") As DataTable

        Dim ret_val As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For:         'procedure get_asset_lov(s_asset varchar2, d_date_last_synced date, info out xodot_signs_asset_op, ref_cur out sys_refcursor);

        'returns:
        'iit_inv_type
        ',IIT_CHR_ATTRIB26
        ',IIT_CHR_ATTRIB27
        ',IIT_CHR_ATTRIB28
        ',IIT_CHR_ATTRIB29
        ',IIT_CHR_ATTRIB30
        ',IIT_CHR_ATTRIB31
        ',IIT_CHR_ATTRIB32
        ',IIT_CHR_ATTRIB56
        ',IIT_CHR_ATTRIB57
        ',IIT_NUM_ATTRIB100
        ',IIT_NUM_ATTRIB101
        ',IIT_NUM_ATTRIB102
        ',IIT_NUM_ATTRIB103
        '''''''''''''''''''''''''''''''''''


        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_asset_lov"

            Dim os_asset As New OracleParameter
            If s_asset <> "-1" Then
                os_asset.OracleDbType = OracleDbType.Varchar2
                os_asset.Direction = ParameterDirection.Input
                os_asset.ParameterName = "s_asset"
                os_asset.Value = s_asset
                o_cmd.Parameters.Add(os_asset)
            End If



            Dim od_date_last_synced As New OracleParameter
            If s_date_last_synced <> "-1" Then
                od_date_last_synced.OracleDbType = OracleDbType.Varchar2
                od_date_last_synced.Direction = ParameterDirection.Input
                od_date_last_synced.ParameterName = "d_date_last_synced"
                od_date_last_synced.Value = _sanitize_date_string(s_date_last_synced)
                o_cmd.Parameters.Add(od_date_last_synced)
            End If





            Dim oinfo As New OracleParameter

            oinfo.OracleDbType = OracleDbType.Object
            oinfo.Direction = ParameterDirection.Output
            oinfo.ParameterName = "info"
            oinfo.UdtTypeName = "XODOT_SIGNS_ASSET_OP"
            o_cmd.Parameters.Add(oinfo)








            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)



            data_adaptor.Fill(ds)

            'Dim tmp As XODOT_SIGNS_ASSET_OP = oinfo.Value



        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val
    End Function

    Public Function get_simple_report_lov(s_report As String, s_crew As String, s_district As String, Optional b_crew_only As Boolean = False, Optional s_last_sync_date As String = "-1") As DataTable

        Dim ret_val As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For:         'get_simple_report_lookup(s_report in varchar2,s_crew varchar2, s_district varchar2, b_crew_only  boolean, ref_cur out sys_refcursor)
        'returns various
        '''''''''''''''''''''''''''''''''''


        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_simple_report_lookup"


            Dim os_report As New OracleParameter
            If s_report <> "-1" Then
                os_report.OracleDbType = OracleDbType.Varchar2
                os_report.Direction = ParameterDirection.Input
                os_report.ParameterName = "s_report"
                os_report.Value = s_report
                o_cmd.Parameters.Add(os_report)
            End If

            Dim os_crew As New OracleParameter
            If s_crew <> "-1" Then
                os_crew.OracleDbType = OracleDbType.Varchar2
                os_crew.Direction = ParameterDirection.Input
                os_crew.ParameterName = "s_crew "
                os_crew.Value = s_crew
                o_cmd.Parameters.Add(os_crew)
            End If

            Dim os_district As New OracleParameter
            If s_district <> "-1" Then
                os_district.OracleDbType = OracleDbType.Varchar2
                os_district.Direction = ParameterDirection.Input
                os_district.ParameterName = "s_district"
                os_district.Value = s_district
                o_cmd.Parameters.Add(os_district)
            End If



            Dim ob_crew_only As New OracleParameter

            ob_crew_only.OracleDbType = OracleDbType.Varchar2
            ob_crew_only.Direction = ParameterDirection.Input
            ob_crew_only.ParameterName = "b_crew_only"
            ob_crew_only.Value = b_crew_only.ToString
            o_cmd.Parameters.Add(ob_crew_only)


            Dim od_date_last_synced As New OracleParameter
            If s_last_sync_date <> "-1" Then
                od_date_last_synced.OracleDbType = OracleDbType.Varchar2
                od_date_last_synced.Direction = ParameterDirection.Input
                od_date_last_synced.ParameterName = "d_last_sync_date"
                od_date_last_synced.Value = _sanitize_date_string(s_last_sync_date)
                o_cmd.Parameters.Add(od_date_last_synced)
            End If


            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)




            'data_adaptor.Fill(ds)

            'Threading out the fill so the app doesnt look locked

            Fill_thread = New Thread(Sub() Threaded_data_adaptor_fill(data_adaptor, ds))

            Fill_thread.Start()

            Do While Fill_thread.ThreadState = ThreadState.Running
                Application.DoEvents()
            Loop


            'Dim tmp As XODOT_SIGNS_ASSET_OP = oinfo.Value



        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


        ret_val = ds.Tables(0)

        Return ret_val
    End Function

    Public Sub write_xodot_signs_logging_exception(s_ne_id As String, s_install_id As String, s_statehwy As String, n_mp As Single, s_error_type As String, s_sync_error As String)

        '''''''''''''''''''''''''''''''''''
        'Used For: logging to the reports.signs_except table in TI
        '''''''''''''''''''''''''''''''''''


        Dim o_cmd As New OracleCommand

        o_cmd.Connection = TI_conn
        o_cmd.CommandType = CommandType.StoredProcedure
        o_cmd.BindByName = True
        o_cmd.CommandText = "xodot_signs_logging.log_exception"

        Dim os_ne_id As New OracleParameter

        os_ne_id.OracleDbType = OracleDbType.Varchar2
        os_ne_id.Direction = ParameterDirection.Input
        os_ne_id.ParameterName = "s_ne_id"
        os_ne_id.Value = s_ne_id
        o_cmd.Parameters.Add(os_ne_id)


        Dim os_install_id As New OracleParameter

        os_install_id.OracleDbType = OracleDbType.Varchar2
        os_install_id.Direction = ParameterDirection.Input
        os_install_id.ParameterName = "s_install_id"
        os_install_id.Value = s_install_id
        o_cmd.Parameters.Add(os_install_id)


        Dim os_statehwy As New OracleParameter

        os_statehwy.OracleDbType = OracleDbType.Varchar2
        os_statehwy.Direction = ParameterDirection.Input
        os_statehwy.ParameterName = "s_statehwy"
        os_statehwy.Value = s_statehwy
        o_cmd.Parameters.Add(os_statehwy)


        Dim on_mp As New OracleParameter

        on_mp.OracleDbType = OracleDbType.Single
        on_mp.Direction = ParameterDirection.Input
        on_mp.ParameterName = "n_mp"
        on_mp.Value = n_mp
        o_cmd.Parameters.Add(on_mp)



        Dim os_error_type As New OracleParameter

        os_error_type.OracleDbType = OracleDbType.Varchar2
        os_error_type.Direction = ParameterDirection.Input
        os_error_type.ParameterName = "s_error_type"
        os_error_type.Value = s_error_type
        o_cmd.Parameters.Add(os_error_type)



        If IsNothing(s_error_type) Then s_error_type = "No Oracle Error Thrown"

        Dim os_sync_error As New OracleParameter

        os_sync_error.OracleDbType = OracleDbType.Varchar2
        os_sync_error.Direction = ParameterDirection.Input
        os_sync_error.ParameterName = "s_sync_error"
        os_sync_error.Value = s_sync_error
        o_cmd.Parameters.Add(os_sync_error)






        o_cmd.ExecuteNonQuery()


        'Catch ex As OracleException


        'Catch ex As Exception
        '
        'End Try


    End Sub

    Public Sub write_xodot_signs_logging_status(n_SFA_CNT As Integer, n_SFA_EXP As Integer, n_TI_CNT As Integer, n_TI_EXCP As Integer, n_LOV_CNT As Integer, n_LOV_EXP As Integer, n_MP100_CNT As Integer, n_MP100_EXP As Integer)

        '''''''''''''''''''''''''''''''''''
        'Used For: recording to the sync summary table in TI
        '''''''''''''''''''''''''''''''''''

        Try


            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_logging.log_status"

            Dim on_SFA_CNT As New OracleParameter
            If n_SFA_CNT <> "-1" Then
                on_SFA_CNT.OracleDbType = OracleDbType.Int64
                on_SFA_CNT.Direction = ParameterDirection.Input
                on_SFA_CNT.ParameterName = "n_SFA_CNT"
                on_SFA_CNT.Value = n_SFA_CNT
                o_cmd.Parameters.Add(on_SFA_CNT)
            End If

            Dim on_SFA_EXP As New OracleParameter
            If n_SFA_EXP <> "-1" Then
                on_SFA_EXP.OracleDbType = OracleDbType.Int64
                on_SFA_EXP.Direction = ParameterDirection.Input
                on_SFA_EXP.ParameterName = "n_SFA_EXP"
                on_SFA_EXP.Value = n_SFA_EXP
                o_cmd.Parameters.Add(on_SFA_EXP)
            End If

            Dim on_TI_CNT As New OracleParameter
            If n_TI_CNT <> "-1" Then
                on_TI_CNT.OracleDbType = OracleDbType.Int64
                on_TI_CNT.Direction = ParameterDirection.Input
                on_TI_CNT.ParameterName = "n_TI_CNT"
                on_TI_CNT.Value = n_TI_CNT
                o_cmd.Parameters.Add(on_TI_CNT)
            End If


            Dim on_TI_EXCP As New OracleParameter
            If n_TI_EXCP <> "-1" Then
                on_TI_EXCP.OracleDbType = OracleDbType.Int64
                on_TI_EXCP.Direction = ParameterDirection.Input
                on_TI_EXCP.ParameterName = "n_TI_EXCP"
                on_TI_EXCP.Value = n_TI_EXCP
                o_cmd.Parameters.Add(on_TI_EXCP)
            End If

            Dim on_LOV_CNT As New OracleParameter
            If n_LOV_CNT <> "-1" Then
                on_LOV_CNT.OracleDbType = OracleDbType.Int64
                on_LOV_CNT.Direction = ParameterDirection.Input
                on_LOV_CNT.ParameterName = "n_LOV_CNT"
                on_LOV_CNT.Value = n_LOV_CNT
                o_cmd.Parameters.Add(on_LOV_CNT)
            End If

            Dim on_LOV_EXP As New OracleParameter
            If n_LOV_EXP <> "-1" Then
                on_LOV_EXP.OracleDbType = OracleDbType.Int64
                on_LOV_EXP.Direction = ParameterDirection.Input
                on_LOV_EXP.ParameterName = "n_LOV_EXP"
                on_LOV_EXP.Value = n_LOV_EXP
                o_cmd.Parameters.Add(on_LOV_EXP)
            End If

            Dim on_MP100_CNT As New OracleParameter
            If n_MP100_CNT <> "-1" Then
                on_MP100_CNT.OracleDbType = OracleDbType.Int64
                on_MP100_CNT.Direction = ParameterDirection.Input
                on_MP100_CNT.ParameterName = "n_MP100_CNT"
                on_MP100_CNT.Value = n_MP100_CNT
                o_cmd.Parameters.Add(on_MP100_CNT)
            End If

            Dim on_MP100_EXP As New OracleParameter
            If n_MP100_EXP <> "-1" Then
                on_MP100_EXP.OracleDbType = OracleDbType.Int64
                on_MP100_EXP.Direction = ParameterDirection.Input
                on_MP100_EXP.ParameterName = "n_MP100_EXP"
                on_MP100_EXP.Value = n_MP100_EXP
                o_cmd.Parameters.Add(on_MP100_EXP)
            End If



            o_cmd.ExecuteNonQuery()


        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            '            write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try


    End Sub


    Private Function _chk_dt_string(sinput As String) As String
        '''''''''''''''''''''''''''''''''''
        'Used For:  Makign sure the date isnt blank
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As String = -1

        Select Case sinput
            Case "-1", ""
                ret_val = "-1"
            Case Else
                ret_val = "1"

        End Select


        Return ret_val
    End Function

    Private Function _sanitize_date_string(s_date As String) As String
        '''''''''''''''''''''''''''''''''''
        'Used For:  Making sure the date is in a format that oracle likes
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String
        Dim d_date As Date

        d_date = Convert.ToDateTime(s_date)

        ret_val = d_date.ToString("dd-MMM-yyyy").ToUpper

        Return ret_val
    End Function

    Public Function get_gen_dir_from_LRM(s_LRM As String) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: getting the genral direction of a HWY in TI
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = "-"


        Dim ds As New DataSet
        Try
            Dim o_cmd As New OracleCommand

            o_cmd.Connection = TI_conn
            o_cmd.CommandType = CommandType.StoredProcedure
            o_cmd.BindByName = True
            o_cmd.CommandText = "xodot_signs_api.get_gen_dir_from_LRM"


            Dim os_LRM As New OracleParameter
            If s_LRM <> "-1" Then
                os_LRM.OracleDbType = OracleDbType.Varchar2
                os_LRM.Direction = ParameterDirection.Input
                os_LRM.ParameterName = "LRM"
                os_LRM.Value = s_LRM
                o_cmd.Parameters.Add(os_LRM)
            End If





            Dim o_ref_cur As New OracleParameter


            o_ref_cur.OracleDbType = OracleDbType.RefCursor
            o_ref_cur.Direction = ParameterDirection.Output
            o_ref_cur.ParameterName = "ref_cur"
            o_cmd.Parameters.Add(o_ref_cur)


            Dim data_adaptor As OracleDataAdapter = New OracleDataAdapter(o_cmd)




            data_adaptor.Fill(ds)

            ret_val = ds.Tables(0).Rows(0).Item(0)



        Catch ex As OracleException

            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ' write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            'write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw
        End Try




        Return ret_val
    End Function


    Private Sub Threaded_data_adaptor_fill(data_adaptor As OracleDataAdapter, ByRef ds As DataSet)
        '''''''''''''''''''''''''''''''''''
        'Used For: Long running gets in TI so that the message pump can process and the broker doesnt look to be locked up.
        '''''''''''''''''''''''''''''''''''
        data_adaptor.Fill(ds)
    End Sub

End Class