

Public Class Broker_Processing
    Private TI_conn As Oracle.DataAccess.Client.OracleConnection = main_form.TI_Conn
    Private sBreakChar As Char = "·"

    Public Enum edit_tables
        '''''''''''''''''''''''''''''''''''
        'Used For: Selecting which edit table we are processing in SFA
        '''''''''''''''''''''''''''''''''''
        CUSTOM
        LOG
        INSTALLATION
        'LEGEND
        STANDARD
        SUPPORTS
    End Enum

    Public Sub process_sfa_new_installs(Optional Inst_Skip_list As ArrayList = Nothing)
        '''''''''''''''''''''''''''''''''''
        'Used For: Processing New installs form the SFA table.  
        ' Once a NE_ID is returned if a "child" item exists the inst_id is put into the corresponding SFA edit tables for processing by the edit routine.
        '''''''''''''''''''''''''''''''''''

        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim new_inst_list As ArrayList

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"



        sfa.init()

        new_inst_list = sfa._get_new_install_list

        If new_inst_list.Count <> 0 Then

            main_form.TSStatusLabel1.Text = "Inserting New Installs into TI"
            main_form.TSProgressBar1.Minimum = 0
            main_form.TSProgressBar1.Maximum = new_inst_list.Count
            main_form.TSProgressBar1.Value = 0

            If IsNothing(Inst_Skip_list) Then
                Dim al As New ArrayList
                Inst_Skip_list = al
                Inst_Skip_list.Add("SKIP")
            End If

            For i = 0 To new_inst_list.Count - 1 Step 1

                ' we need to skip items that errored the frist time around to not doulbe the error messages
                If Inst_Skip_list.Contains(new_inst_list.Item(i)) = False Then



                    'Chk to see if install date is null or blank

                    'Now lets insert it into TI
                    Dim row As DataRow
                    Dim n_inst_id As String = new_inst_list.Item(i)

                    main_form.TSProgressBar1.Increment(1)
                    Application.DoEvents()

#If DEBUG Then
                main_form.TSStatusLabel1.Text = "NewInst: " & i & " of " & new_inst_list.Count & ", " & "Doing  Inst ID: " & n_inst_id
                Application.DoEvents()
#End If

                    row = sfa._get_install_row(n_inst_id)
                    If IsDate(main_form.g_d_run_date) = True Then
                        Dim t_results As XODOT_SIGNS_ASSET_OP
                        Dim ss_LRM As String = row.Item("fldStateHwy").ToString.PadRight(5, "0") & row.Item("RDWY_ID").ToString & row.Item("fldMPPrefix").ToString


                        Dim s_xsect As String = ""
                        Dim s_note As String = "Orginally Added with Signs Broker"




                        s_xsect = _get_XSP_from_sfa_data(ss_LRM, row.Item("RDWY_ID").ToString, row.Item("fldDirection").ToString, row.Item("fldSide").ToString)

                        If s_xsect.Length = 4 Then
                            ' currently shoudl return ZZZZ

                            If s_xsect = "ZZZZ" Then s_xsect = "-1" ' -1 means not suppiled to my oracle call
                            If s_xsect = "CCCC" Then s_xsect = "C"
                            If s_xsect = "OOOO" Then s_xsect = "O"

                            ' send the item to TI
                            row = _sanitize_dr(row)
                            t_results = ti.add_SNIN("I", , main_form.g_d_run_date, , s_xsect, , s_note, row.Item("fldLocation").ToString, _Get_Cty_country_from_sfa_desc(cty_county.City, row.Item("fldAddtNotes").ToString), _Get_Cty_country_from_sfa_desc(cty_county.County, row.Item("fldAddtNotes").ToString), row.Item("fldAddtNotes").ToString, row.Item("fldDistanceEOP"), row.Item("fldLatitude"), row.Item("fldLongitude"), ss_LRM, row.Item("fldMP"), row.Item("fldSide"), row.Item("fldDirection"), n_inst_id)

                            ' put neid back into access db
                            If t_results.NE_ID = -999 Then
                                If t_results.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                    Dim ex As New Exception
                                    main_form._sub_something_wrong_abort("BAD_USER", ex)
                                Else
                                    ' we have a problem that shoudl be logged
                                    Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                    loc = loc.Replace("<H>", row.Item("fldStateHwy").ToString)
                                    loc = loc.Replace("<M>", row.Item("fldMP"))

                                    Log_issue(Log_source.TI, "INSERT_SNIN", t_results.ERR_NUM, t_results.ERR_MSG, "SFA_Inst_Id: " & n_inst_id.ToString, loc)

                                    ' we need to add it to the edit table so it can be attepted to be updated later
                                    add_sync_count(count_list.SFA_EXP)
                                End If
                            ElseIf t_results.NE_ID = -888 Then
                                ' THis shoudl only happen is somehtign is wrong with the TI API componets
                                Log_issue(Log_source.TI, "INSERT_SNIN", t_results.ERR_NUM, t_results.ERR_MSG, "Fatal Error Processing New Installs, Contact A systems Administrator to check the TransInfo error logs.")
                                Exit Sub
                            Else
                                sfa._update_ne_id(n_inst_id, t_results.NE_ID)

                                ' lets put the items into the Edit Tables to have the "edited" routines add this to TI, but only if something nexts in the SFA for those items

                                Dim mychild As New SFA_Tools.edit_items

                                mychild = SFA_Tools.edit_items.STANDARD
                                If sfa._child_item_exists_for_Install(n_inst_id, mychild) <> 0 Then sfa._insert_edit_item(n_inst_id, mychild)

                                mychild = SFA_Tools.edit_items.CUSTOM
                                If sfa._child_item_exists_for_Install(n_inst_id, mychild) <> 0 Then sfa._insert_edit_item(n_inst_id, mychild)

                                mychild = SFA_Tools.edit_items.SUPPORTS
                                If sfa._child_item_exists_for_Install(n_inst_id, mychild) <> 0 Then sfa._insert_edit_item(n_inst_id, mychild)

                                mychild = SFA_Tools.edit_items.HISTORY
                                If sfa._child_item_exists_for_Install(n_inst_id, mychild) <> 0 Then sfa._insert_edit_item(n_inst_id, mychild)

                                'Now lets remove this Inst ID from the edit tables incase edits were made after the fact
                                sfa._remove_from_edit_tables(SFA_Tools.edit_items.NEW_INSTALL, n_inst_id)
                                sfa._remove_from_edit_tables(SFA_Tools.edit_items.INSTALLATION, n_inst_id)
                            End If
                        Else ' need to log the xsp error

                            row = _sanitize_dr(row, "N/A")
                            Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                            loc = loc.Replace("<H>", row.Item("fldStateHwy").ToString)
                            loc = loc.Replace("<M>", row.Item("fldMP"))

                            If s_xsect.Contains("R_DIR_MISS:") Then
                                Log_issue(Log_source.TI, "Road Direction Issue, FIND XSP, Issue with data in SFA direction NS, EW Mismatch", -0, "Get XSP Error", n_inst_id.ToString, ss_LRM & " SFA Dir: " & ToString(), "SFA DIR: " & row.Item("fldDirection").ToString & " TI DIR:" & s_xsect.Last.ToString)
                                ti.write_xodot_signs_logging_exception("N/A", n_inst_id.ToString, row.Item("fldStateHwy"), row.Item("fldMP"), 0, "Road Direction Issue, FIND XSP, Issue with data in SFA direction NS, EW Mismatch " & "SFA DIR: " & row.Item("fldDirection").ToString & " TI DIR:" & s_xsect.Last.ToString)
                                add_sync_count(count_list.SFA_EXP)
                            ElseIf s_xsect = "NOT_FOUND" Then
                                Log_issue(Log_source.TI, "LRM Not Found in TI", -0, "Get XSP Error", n_inst_id.ToString, ss_LRM & " SFA LRM: " & ss_LRM)
                                ti.write_xodot_signs_logging_exception("N/A", n_inst_id.ToString, row.Item("fldStateHwy"), row.Item("fldMP"), 0, "LRM Not Found in TI: " & ss_LRM)
                                add_sync_count(count_list.SFA_EXP)
                            Else
                                ' we have a problem that shoudl be logged
                                Log_issue(Log_source.TI, "FIND XSP Issue with data in SFA", -0, "Get XSP Error", n_inst_id.ToString, loc)
                                ti.write_xodot_signs_logging_exception("N/A", n_inst_id.ToString, row.Item("fldStateHwy"), row.Item("fldMP"), 0, "FIND XSP Issue with data in SFA: " & ss_LRM)

                                ' we need to add it to the edit table so it can be attepted to be updated later
                                add_sync_count(count_list.SFA_EXP)
                            End If
                        End If

                    Else  'log the missing date as an error
                        Log_issue(Log_source.SFA, "Creation Date Is Invaild", -0, "Date Issue", n_inst_id.ToString, "For Route : " & row.Item("fldStateHwy") & " MP: " & row.Item("fldMP"), "Please Insert a Date")
                        ti.write_xodot_signs_logging_exception("N/A", n_inst_id.ToString, row.Item("fldStateHwy"), row.Item("fldMP"), 0, "Creation Date Is Invaild, please insert an Creation Date")
                    End If

                End If
            Next
        End If

        sfa.Dispose()
    End Sub


    Public Sub process_sfa_edited_installs(e_table As edit_tables)
        '''''''''''''''''''''''''''''''''''
        'Used For: Looping trhough the SFA edit tables and deleting all the childern from TI and replacing them  with what is in SFA
        '''''''''''''''''''''''''''''''''''
        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools

        Dim s_xsect As String = ""
        Dim s_note As String = "Orginally Added with Signs Broker"

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Select Case e_table

            Case edit_tables.CUSTOM
                Dim edit_list As ArrayList
                Dim edit_list_leg As ArrayList

                edit_list = sfa._get_edited_list(SFA_Tools.edit_items.CUSTOM)
                edit_list_leg = sfa._get_edited_list(SFA_Tools.edit_items.LEGEND)

                If edit_list_leg.Count <> 0 Then ' lets find out the inst_id ans add it to edit_list
                    For i = 0 To edit_list_leg.Count - 1 Step 1
                        Dim i_inst As Integer = sfa._get_install_ID_From_Legend_Id(edit_list_leg(i))

                        If i_inst <> -1 Then
                            If edit_list.Contains(i_inst) = False Then
                                edit_list.Add(i_inst)
                            End If
                        End If
                    Next
                End If

                If edit_list.Count <> 0 Then

                    main_form.TSStatusLabel1.Text = "Inserting Custom Signs into TI"
                    main_form.TSProgressBar1.Minimum = 0
                    main_form.TSProgressBar1.Maximum = edit_list.Count
                    main_form.TSProgressBar1.Value = 0

                    For i = 0 To edit_list.Count - 1 Step 1

                        If IsNumeric(edit_list.Item(i)) Then

                            Dim n_inst_id As String = edit_list.Item(i)
                            ' Now the custom signs
                            Dim sign_data As DataTable
                            sign_data = sfa._get_custom_signs(n_inst_id)

                            Dim instrow As DataRow

                            instrow = sfa._get_install_row(n_inst_id)
                            If instrow.Table.Rows.Count <> 0 Then


                                ' Delete Existing ones in TI first
                                Dim t_results_sign_delete As XODOT_SIGNS_ASSET_OP



                                Dim s_ne_id As String = instrow("SNIN_NE_ID").ToString

                                If IsNumeric(s_ne_id) = True Then
                                    t_results_sign_delete = ti.add_SNSN("D", s_ne_id, , , , , , "C")


                                    If t_results_sign_delete.NE_ID <> -999 Then

                                        Dim s_row As DataRow
                                        Dim boolerror As Boolean = False

                                        If sign_data.Rows.Count <> 0 Then
                                            For Each s_row In sign_data.Rows
                                                Dim t_results_signs As XODOT_SIGNS_ASSET_OP
                                                Dim s_signtype As String = "C"

                                                Dim s_legends As String = ""

                                                s_legends = sfa._getCustomSignLegend(s_row("fldCustLegendId"), sBreakChar)



                                                t_results_signs = ti.add_SNSN("I", s_ne_id, main_form.g_d_run_date.ToString, , s_xsect, , s_note, s_signtype, _
                                                                , _access_true_false_to_YN(s_row("fldCustFail")), s_row("fldFacingId").ToString, s_row("fldSubstrate").ToString, s_row("fldSheeting").ToString.ToUpper _
                                                                , _access_yes_no(s_row("fldSOI")), s_legends, s_row("fldCustPicture").ToString, s_row("fldCustEstReplaceDate").ToString, s_row("RefInspDt").ToString, main_form.g_d_run_date.ToString _
                                                                , s_row("fldCustWidth"), s_row("fldCustHeight"), s_row("fldSignRecycleCount"), n_inst_id.ToString
                                                )

                                                If t_results_signs.NE_ID = -999 Then
                                                    ' we have a problem that shoudl be logged
                                                    If main_form.CB_Debug.Checked Then MsgBox(t_results_signs.ERR_MSG, MsgBoxStyle.Critical, t_results_signs.ERR_NUM)
                                                    boolerror = True

                                                    Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                                    loc = loc.Replace("<H>", instrow.Item("fldStateHwy").ToString)
                                                    loc = loc.Replace("<M>", instrow.Item("fldMP"))

                                                    If t_results_signs.ERR_MSG.Contains("Record not found: nm_inv_items") Then

                                                        ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, instrow("fldStateHwy").ToString, instrow("fldMP").ToString, t_results_signs.ERR_NUM, " Parent Record Not Found, most likely cause is that the install date of the Sign is < the Install date of the Installation .")
                                                        Log_issue(Log_source.SFA, "SNSN", t_results_signs.ERR_NUM, " Parent Record Not Found, most likely cause is that the install date of the SIGN is < the Install date of the Installation .", n_inst_id, loc, "Error Inserting into Transinfo, most likely cause is that the install date of the SIGN is less than the Install date of the Installation")

                                                    ElseIf t_results_signs.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                                        Dim ex As New Exception
                                                        main_form._sub_something_wrong_abort("BAD_USER", ex)

                                                    Else

                                                        Log_issue(Log_source.TI, SFA_Tools.edit_items.CUSTOM.ToString, t_results_signs.ERR_NUM, t_results_signs.ERR_MSG, n_inst_id, loc)
                                                    End If


                                                    main_form.g_row_sync_count.Item("SFA_EXP") = main_form.g_row_sync_count.Item("SFA_EXP") + 1
                                                Else
                                                    sfa._remove_from_edit_tables(SFA_Tools.edit_items.LEGEND, s_row("fldCustLegendId"))
                                                    main_form.g_row_sync_count.Item("SFA_CNT") = main_form.g_row_sync_count.Item("SFA_CNT") + 1
                                                End If
                                            Next
                                            If Not boolerror Then
                                                sfa._remove_from_edit_tables(SFA_Tools.edit_items.CUSTOM, n_inst_id)
                                                add_sync_count(count_list.SFA_CNT)
                                            Else
                                                add_sync_count(count_list.SFA_EXP)
                                            End If

                                        Else
                                            ' No sign data, it might be correct
                                            'add_sync_count(count_list.SFA_EXP)
                                        End If
                                    End If
                            Else
                                ' No custom sign found so it might have been deleted.
                            End If

                        Else
                            Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                            Dim sh As String
                            Dim mp As String

                            If IsDBNull(instrow.Item("fldStateHwy")) Then
                                sh = "[Highway not found]"
                            Else
                                sh = instrow.Item("fldStateHwy")
                            End If

                            If IsDBNull(instrow.Item("fldMP")) Then
                                mp = "[Milepoint not found]"
                            Else
                                mp = instrow.Item("fldMP")
                            End If

                            loc = loc.Replace("<H>", sh)
                            loc = loc.Replace("<M>", mp)

                                Log_issue(Log_source.TI, SFA_Tools.edit_items.CUSTOM.ToString, Convert.ToString(-20000), "Expected an SNIN_NE_ID to be in SFA database for Installation ID: " & n_inst_id.ToString)
                                ti.write_xodot_signs_logging_exception("N/A", n_inst_id.ToString, sh, mp, 0, "Expected an SNIN_NE_ID to be in SFA database for Installation ID: " & n_inst_id.ToString)
                            add_sync_count(count_list.SFA_EXP)
                            main_form.TSProgressBar1.Increment(1)
                        End If

                                main_form.TSProgressBar1.Increment(1)
                                Application.DoEvents()
                            End If
                    Next
                End If

            Case edit_tables.LOG
                Dim edit_list As ArrayList


                edit_list = sfa._get_edited_list(SFA_Tools.edit_items.HISTORY)


                If edit_list.Count <> 0 Then

                    main_form.TSStatusLabel1.Text = "Inserting History into TI"
                    main_form.TSProgressBar1.Minimum = 0
                    main_form.TSProgressBar1.Maximum = edit_list.Count
                    main_form.TSProgressBar1.Value = 0

                    For i = 0 To edit_list.Count - 1 Step 1
                        Dim n_inst_id As String = edit_list.Item(i)
                        ' Now the custom signs
                        Dim sign_data As DataTable
                        sign_data = sfa._get_Maintenance_Log(n_inst_id)

                        If sign_data.Rows.Count <> 0 Then
                            ' Delete Existing ones in TI first
                            Dim t_results_sign_delete As XODOT_SIGNS_ASSET_OP

                            Dim instrow As DataRow

                            instrow = sfa._get_install_row(n_inst_id)

                            Dim s_ne_id As String = instrow("SNIN_NE_ID").ToString
                            If IsNumeric(s_ne_id) = True Then
                                t_results_sign_delete = ti.delete_snml(s_ne_id)


                                If t_results_sign_delete.NE_ID <> -999 Then

                                    Dim s_row As DataRow
                                    Dim boolerror As Boolean = False

                                    For Each s_row In sign_data.Rows
                                        Application.DoEvents()
                                        Dim t_results_log As XODOT_SIGNS_ASSET_OP

                                        s_row = _sanitize_dr(s_row)

                                        t_results_log = ti.add_SNML("I", s_ne_id, main_form.g_d_run_date.ToString, , s_xsect, , s_note _
                                                                        , s_row("fldHistAction").ToString, s_row("fldHistCause").ToString, s_row("fldHistSignNumber").ToString _
                                                                        , s_row("fldHistRespPerson").ToString, s_row("fldHistSignSize").ToString, s_row("fldHistSignFacing").ToString _
                                                                        , s_row("fldHistSignLegend").ToString, s_row("fldHistComments").ToString, s_row("fldHistMaterials").ToString _
                                                                        , s_row("fldHistPost").ToString, s_row("fldHistDate").ToString, s_row("fldHistAccomplishments").ToString _
                                                                        , s_row("fldHistCrewHours"), s_row("fldHistEquipHours"), n_inst_id.ToString
                                                                     )

                                        If t_results_log.NE_ID = -999 Then
                                            ' we have a problem that should be logged
                                            If main_form.CB_Debug.Checked Then MsgBox(t_results_log.ERR_MSG, MsgBoxStyle.Critical, t_results_log.ERR_NUM)
                                            add_sync_count(count_list.SFA_EXP)
                                            boolerror = True

                                            Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                            loc = loc.Replace("<H>", instrow.Item("fldStateHwy").ToString)
                                            loc = loc.Replace("<M>", instrow.Item("fldMP"))

                                            If t_results_log.ERR_MSG.Contains("Record not found: nm_inv_items") Then

                                                ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, instrow("fldStateHwy").ToString, instrow("fldMP").ToString, t_results_log.ERR_NUM, " Parent Record Not Found, mostlikely cause is that the History date of the History is < the Install date of the Installation .")
                                                Log_issue(Log_source.SFA, "SNML", t_results_log.ERR_NUM, " Parent Record Not Found, most likely cause is that the History date of the SIGN is < the Install date of the Installation .", n_inst_id, loc, "Error Inserting into Transinfo, most likely cause is that the History date of the History is less than the History date of the Installation")

                                            ElseIf t_results_log.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                                Dim ex As New Exception
                                                main_form._sub_something_wrong_abort("BAD_USER", ex)
                                            Else

                                                Log_issue(Log_source.TI, SFA_Tools.edit_items.HISTORY.ToString, t_results_log.ERR_NUM, t_results_log.ERR_MSG, n_inst_id, loc)
                                            End If
                                        Else
                                            add_sync_count(count_list.SFA_CNT)

                                        End If
                                    Next
                                    If Not boolerror Then sfa._remove_from_edit_tables(SFA_Tools.edit_items.HISTORY, n_inst_id)

                                End If
                            End If
                        End If
                        main_form.TSProgressBar1.Increment(1)
                        Application.DoEvents()
                    Next
                End If
            Case edit_tables.INSTALLATION


                'Lets handle items that are marked as deleted in SFA
                Dim del_list As ArrayList
                del_list = sfa._get_edited_list(SFA_Tools.edit_items.DELETED)

                If del_list.Count <> 0 Then
                    'lets see if there was an ne_id for the item
                    For i = 0 To del_list.Count - 1 Step 1
                        Dim n_ne_id As Int32 = sfa._get_neid_from_edit(del_list(i))

                        'if it had an ne_id then delete from TI
                        If n_ne_id <> -1 Then
                            ' this should end date the item in TI and cascade to the childern
                            ti.add_SNIN("E", n_ne_id)
                        End If

                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.NEW_INSTALL, del_list(i))
                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.STANDARD, del_list(i))
                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.CUSTOM, del_list(i))
                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.HISTORY, del_list(i))
                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.LEGEND, del_list(i))
                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.SUPPORTS, del_list(i))

                        sfa._remove_from_edit_tables(SFA_Tools.edit_items.INSTALLATION, del_list(i))
                    Next
                End If

                ' This is the only one that can be updated and not completely replaced



                Dim edit_list As New ArrayList
                edit_list = sfa._get_edited_list(SFA_Tools.edit_items.INSTALLATION)

                If edit_list.Count <> 0 Then

                    For i = 0 To edit_list.Count Step 1
                        'Now lets insert it into TI
                        Dim row As DataRow
                        Dim n_inst_id As String = edit_list.Item(0)

                        row = sfa._get_install_row(n_inst_id)
                        If row.Item("fldinstallationid") = -99 Then
                            ti.write_xodot_signs_logging_exception("N/A", n_inst_id, "N/A", -1, "-22222", "Sign  Broker is trying to add a new install but it cannot be located in tblInstallations")
                        Else
                            Dim t_results As XODOT_SIGNS_ASSET_OP

                            main_form.TSStatusLabel1.Text = "Updating edited Installations into TI"
                            main_form.TSProgressBar1.Minimum = 0
                            main_form.TSProgressBar1.Maximum = edit_list.Count
                            main_form.TSProgressBar1.Value = 0


                            Dim boolerror As Boolean = False

                            If IsDBNull(row("SNIN_NE_ID")) = False Then
                                Dim s_ne_id As String = row("SNIN_NE_ID").ToString

                                Dim ss_LRM As String = row.Item("fldStateHwy").ToString.PadRight(5, "0") & row.Item("RDWY_ID").ToString & row.Item("fldMPPrefix").ToString

                                s_xsect = _get_XSP_from_sfa_data(ss_LRM, row.Item("RDWY_ID").ToString, row.Item("fldDirection").ToString, row.Item("fldSide").ToString)

                                s_xsect = "-1" ' shodul net be processed by TI

                                ' send the item to TI
                                t_results = ti.add_SNIN("U", Convert.ToDecimal(s_ne_id), , , s_xsect, , s_note, row.Item("fldLocation").ToString, _
                                                        _Get_Cty_country_from_sfa_desc(cty_county.City, row.Item("fldAddtNotes").ToString), _Get_Cty_country_from_sfa_desc(cty_county.County, row.Item("fldAddtNotes").ToString), _
                                                        row.Item("fldAddtNotes").ToString, row.Item("fldDistanceEOP"), row.Item("fldLatitude"), row.Item("fldLongitude"), ss_LRM, row.Item("fldMP"), row.Item("fldSide"), row.Item("fldDirection"), n_inst_id.ToString)

                                If t_results.NE_ID = -999 Then
                                    ' we have a problem that shoudl be logged
                                    If main_form.CB_Debug.Checked Then MsgBox(t_results.ERR_MSG, MsgBoxStyle.Critical, t_results.ERR_NUM)
                                    boolerror = True
                                    add_sync_count(count_list.SFA_EXP)

                                    Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                    loc = loc.Replace("<H>", row.Item("fldStateHwy").ToString)
                                    loc = loc.Replace("<M>", row.Item("fldMP"))

                                    Log_issue(Log_source.TI, SFA_Tools.edit_items.INSTALLATION.ToString, t_results.ERR_NUM, t_results.ERR_MSG, n_inst_id, loc)

                                ElseIf t_results.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                    Dim ex As New Exception
                                    main_form._sub_something_wrong_abort("BAD_USER", ex)
                                Else
                                    ' Update the NEID since it changed
                                    sfa._update_ne_id(n_inst_id, t_results.NE_ID)
                                    sfa._remove_from_edit_tables(SFA_Tools.edit_items.INSTALLATION, n_inst_id)
                                    add_sync_count(count_list.SFA_CNT)
                                End If

                            Else
                                'need to treat this as a new install, so lets add it to the new install table and rerun new installs before doign the rest of the update tables
                                sfa._insert_new_install_item(n_inst_id)
                            End If
                        End If
                        main_form.TSProgressBar1.Increment(1)
                        Application.DoEvents()

                    Next
                End If


                '---------------------
                'case edit_tables.LEGEND  ' This is included in custom
                '---------------------
            Case edit_tables.STANDARD
                Dim edit_list As ArrayList


                edit_list = sfa._get_edited_list(SFA_Tools.edit_items.STANDARD)




                If edit_list.Count <> 0 Then

                    main_form.TSStatusLabel1.Text = "Inserting Standard Signs into TI "
                    main_form.TSProgressBar1.Minimum = 0
                    main_form.TSProgressBar1.Maximum = edit_list.Count
                    main_form.TSProgressBar1.Value = 0

                    For i = 0 To edit_list.Count - 1 Step 1
                        If edit_list.Item(i) <> "" Then
                            Dim n_inst_id As String = edit_list.Item(i)
                            ' Now the custom signs
                            Dim sign_data As DataTable
                            sign_data = sfa._get_Standard_signs(n_inst_id)

                            If sign_data.Rows.Count <> 0 Then
                                ' Delete Existing ones in TI first
                                Dim t_results_sign_delete As XODOT_SIGNS_ASSET_OP

                                Dim instrow As DataRow

                                instrow = sfa._get_install_row(n_inst_id)

                                Dim s_ne_id As String = instrow("SNIN_NE_ID").ToString
                                If IsNumeric(s_ne_id) Then
                                    t_results_sign_delete = ti.add_SNSN("D", s_ne_id, , , , , , "S")


                                    If t_results_sign_delete.NE_ID <> -999 Then
                                        Dim boolerror As Boolean = False
                                        Dim s_row As DataRow
                                        For Each s_row In sign_data.Rows
                                            Dim t_results_signs As XODOT_SIGNS_ASSET_OP
                                            Dim s_signtype As String = "S"

                                            Application.DoEvents()

                                            _replace_row_null_except_dates(s_row)  'used to kill DB nulls before sendign to TI

                                            t_results_signs = ti.add_SNSN("I", s_ne_id, main_form.g_d_run_date.ToString, , s_xsect, , s_note, s_signtype, s_row("fldStandSignNumber").ToString _
                                                            , _access_true_false_to_YN(s_row("fldStandFail").ToString), s_row("fldFacingId"), s_row("fldSubstrate").ToString, s_row("fldSheeting").ToString.ToUpper _
                                                            , _access_yes_no(s_row("fldSOI")), , , s_row("fldStandEstReplaceDate").ToString, s_row("RefInspDt").ToString, s_row("fldInstallDate").ToString, , _
                                                            , s_row("fldSignRecycleCount"), n_inst_id.ToString
                                            )

                                            If t_results_signs.NE_ID = -999 Then
                                                ' we have a problem that shoudl be logged

                                                If main_form.CB_Debug.Checked Then MsgBox(t_results_signs.ERR_MSG, MsgBoxStyle.Critical, t_results_signs.ERR_NUM)

                                                'already gets logged vomr the TI package called
                                                'ti.write_xodot_signs_logging_exception(t_results_signs.NE_ID, n_inst_id, "UNKNOWN", 0, "SNSN: " & t_results_signs.ERR_NUM, t_results_signs.ERR_MSG)

                                                boolerror = True

                                                Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                                loc = loc.Replace("<H>", instrow.Item("fldStateHwy").ToString)
                                                loc = loc.Replace("<M>", instrow.Item("fldMP"))

                                                If t_results_signs.ERR_MSG.Contains("Record not found: nm_inv_items") Then
                                      
                                                    ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, "N/A", -1, t_results_signs.ERR_NUM, " Parent Record Not Found, most likely cause is that the install date of the SIGN is < the Install date of the Installation .")
                                                    Log_issue(Log_source.SFA, "SNSN", t_results_signs.ERR_NUM, " Parent Record Not Found, most likely cause is that the install date of the SIGN is < the Install date of the Installation .", n_inst_id, loc, "Error Inserting into Transinfo, mostlikely cause is that the install date of the SIGN is less than the Install date of the Installation")

                                                ElseIf t_results_signs.ERR_MSG.Contains("ORA-20751: SNSN - STD_SIGN_ID") Then
                                                    Dim msg As String = ""
                                                    Dim extra As String = "" 'not used with custom


                                                    msg = "<ST> is not a valid Standard Sign number/type, please correct the Sign data located on <LOC>"
                                                    msg = msg.Replace("<ST>", s_row("fldStandSignNumber").ToString)
                                                    msg = msg.Replace("<LOC>", loc)


                                                    Log_issue(Log_source.CUSTOM, SFA_Tools.edit_items.STANDARD.ToString, t_results_signs.ERR_NUM, msg, n_inst_id, loc, extra)

                                                ElseIf t_results_signs.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                                    Dim ex As New Exception
                                                    main_form._sub_something_wrong_abort("BAD_USER", ex)
                                                Else

                                                    Log_issue(Log_source.TI, SFA_Tools.edit_items.STANDARD.ToString, t_results_signs.ERR_NUM, t_results_signs.ERR_MSG, n_inst_id, loc)
                                                End If

                                                add_sync_count(count_list.SFA_EXP)

                                            Else
                                                'sfa._remove_from_edit_tables(SFA_Tools.edit_items.STANDARD, n_inst_id)
                                                add_sync_count(count_list.SFA_CNT)
                                            End If
                                        Next
                                        If Not boolerror Then sfa._remove_from_edit_tables(SFA_Tools.edit_items.STANDARD, n_inst_id)
                                    End If
                                Else ' no NE_ID for parent error
                                    ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, instrow("fldStateHwy").ToString, instrow("fldMP"), "ERR_NO_NE_ID", " The installation does not have an NE_ID assigned in SFA.")
                                End If

                            End If
                        End If
                        main_form.TSProgressBar1.Increment(1)
                        Application.DoEvents()
                    Next
                End If

                main_form.TSStatusLabel1.Text = ""
                main_form.TSProgressBar1.Value = 0

                ' ----------------------------------Supports


            Case edit_tables.SUPPORTS
                Dim edit_list As ArrayList


                edit_list = sfa._get_edited_list(SFA_Tools.edit_items.SUPPORTS)




                If edit_list.Count <> 0 Then


                    main_form.TSStatusLabel1.Text = "Inserting Supports into TI"
                    main_form.TSProgressBar1.Minimum = 0
                    main_form.TSProgressBar1.Maximum = edit_list.Count
                    main_form.TSProgressBar1.Value = 0

                    For i = 0 To edit_list.Count - 1 Step 1
                        Dim n_inst_id As String = edit_list.Item(i)
                        ' Now the custom signs
                        Dim sign_data As DataTable
                        sign_data = sfa._get_supports(n_inst_id)

                        If sign_data.Rows.Count <> 0 Then
                            ' Delete Existing ones in TI first
                            Dim t_results_sign_delete As XODOT_SIGNS_ASSET_OP

                            Dim instrow As DataRow

                            instrow = sfa._get_install_row(n_inst_id)

                            Dim s_ne_id As String = instrow("SNIN_NE_ID").ToString

                            If IsNumeric(s_ne_id) = True Then
                                t_results_sign_delete = ti.delete_snsu(s_ne_id)

                                Dim boolerror As Boolean = False

                                If sign_data.Rows.Count <> 0 Then
                                    Dim s_row As DataRow
                                    For Each s_row In sign_data.Rows
                                        Application.DoEvents()
                                        Dim t_results_supp As XODOT_SIGNS_ASSET_OP


                                        If IsDate(s_row("fldInstallDate")) = False Then
                                            s_row("fldInstallDate") = main_form.g_d_run_date
                                        End If

                                        t_results_supp = ti.add_SNSU("I", s_ne_id, main_form.g_d_run_date.ToString, , s_xsect, , s_note _
                                                                        , s_row("fldPostType_Size").ToString, s_row("fldInstallDate").ToString, s_row("fldNumberOfPosts"), n_inst_id.ToString
                                                                     )

                                        If t_results_supp.NE_ID = -999 Then
                                            ' we have a problem that should be logged

                                            Dim loc As String = My.Resources.strings.ERROR_SFA_LOCATION
                                            loc = loc.Replace("<H>", instrow.Item("fldStateHwy").ToString)
                                            loc = loc.Replace("<M>", instrow.Item("fldMP"))

                                            If main_form.CB_Debug.Checked Then MsgBox(t_results_supp.ERR_MSG, MsgBoxStyle.Critical, t_results_supp.ERR_NUM)
                                            boolerror = True
                                            add_sync_count(count_list.SFA_EXP)
                                            If t_results_supp.ERR_MSG.Contains("Record not found: nm_inv_items") Then
                                                

                                                ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, "N/A", -1, t_results_supp.ERR_NUM, " The Support Installation is Null and Required by Transinfo, please fix the date and sync again. ")
                                                Log_issue(Log_source.SFA, "SNSU", t_results_supp.ERR_NUM, " Parent Record Not Found, mostlikely cause is that the install date of the SUPPORT is < the Install date of the Installation .", n_inst_id, loc, "Error Inserting into Transinfo, most likely cause is that the install date of the SUPPORT is less than the Install date of the Installation")

                                            ElseIf t_results_supp.ERR_MSG.Contains("ORA-20750: SNSU - INSTALL_DT - cannot be null") Then
                                                
                                                ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, "N/A", -1, t_results_supp.ERR_NUM, " The Support Installation is Null and Required by Transinfo, please fix the date and sync again.")
                                                Log_issue(Log_source.SFA, "SNSU", t_results_supp.ERR_NUM, " Installed Date is Null", n_inst_id, loc, "The Support Installation is Null and Required by Transinfo, please fix the date and sync again.")

                                            ElseIf t_results_supp.ERR_MSG.Contains("ORA-20000: HIG-0182: User not instantiated correctly") Then
                                                Dim ex As New Exception
                                                main_form._sub_something_wrong_abort("BAD_USER", ex)



                                            ElseIf t_results_supp.ERR_MSG.Contains("ORA-20751: SNSU - SUPP_TYP") Then
                                                Dim msg As String = ""
                                                Dim extra As String = "" 'not used with custom


                                                msg = "<ST> is not a valid support type, please correct the support data located on hwy <hywy> and milepoint <mp>"
                                                msg = msg.Replace("<ST>", s_row("fldPostType_Size").ToString)
                                                msg = msg.Replace("<hywy>", instrow("fldStateHwy").ToString)
                                                msg = msg.Replace("<mp>", instrow("fldMP").ToString)

                                                Log_issue(Log_source.CUSTOM, SFA_Tools.edit_items.SUPPORTS.ToString, t_results_supp.ERR_NUM, msg, n_inst_id, loc, extra)
                                            Else
                                               
                                                'ti.write_xodot_signs_logging_exception(s_ne_id, n_inst_id, "N/A", -1, t_results_supp.ERR_NUM, t_results_supp.ERR_MSG)
                                                Log_issue(Log_source.TI, SFA_Tools.edit_items.SUPPORTS.ToString, t_results_supp.ERR_NUM, t_results_supp.ERR_MSG, n_inst_id, loc, )
                                            End If
                                        Else
                                            add_sync_count(count_list.SFA_CNT)
                                        End If
                                    Next
                                    If Not boolerror Then sfa._remove_from_edit_tables(SFA_Tools.edit_items.SUPPORTS, n_inst_id)
                                End If
                            End If
                        Else
                            ' No Supports found, it is mostlikely correct and doesnt need to log an error
                            'add_sync_count(count_list.SFA_EXP)
                        End If

                        main_form.TSProgressBar1.Increment(1)
                        Application.DoEvents()

                    Next
                End If
                main_form.TSStatusLabel1.Text = ""
                main_form.TSProgressBar1.Value = 0
        End Select
        sfa.Dispose()
    End Sub

    Public Function process_TI_edited_Installs() As ArrayList
        '''''''''''''''''''''''''''''''''''
        'Used For: Gettign Edits that were made in TI, This includes items edited by another Field book.  And inserting/editing them into the current SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As New ArrayList
        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        Dim bWasError As Boolean = False

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim dt_ti_inst As DataTable
        Dim s_last_date As String

        s_last_date = ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNIN, True)

        Dim s_crew As String = main_form.g_s_crew

        main_form.TSStatusLabel1.Text = "Retrieving Changed Installs  from Transinfo"

        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Marquee

        dt_ti_inst = ti.get_changed_sign_asset(s_crew, s_last_date, "SNIN")

        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Continuous




        If dt_ti_inst.Rows.Count <> 0 Then

            main_form.TSStatusLabel1.Text = "Inserting Changed Installs into SFA"
            main_form.TSProgressBar1.Minimum = 0
            main_form.TSProgressBar1.Maximum = dt_ti_inst.Rows.Count
            main_form.TSProgressBar1.Value = 0

            Dim row As DataRow
            For Each row In dt_ti_inst.Rows
                'this is an nm_inv_items_all row
                Dim s_inst_id As String
                Dim n_ne_id As Decimal

#If DEBUG Then
                main_form.TSStatusLabel1.Text = "count: " & dt_ti_inst.Rows.Count & ", " & "Doing  SNIN: " & row.Item("iit_ne_id")
                Application.DoEvents()
#End If

                n_ne_id = row.Item("IIT_NE_ID")

                s_inst_id = sfa._get_inst_id_from_NE_ID(n_ne_id)

                'going to use the s_inst_id for end date as well

                If IsDBNull(row.Item("iit_end_date")) = False Then
                    s_inst_id = "END_DATE"
                End If


                Select Case s_inst_id
                    Case "MULTI"
                        ' need to log that there are too many
                        If main_form.CB_Debug.Checked Then MsgBox("ne_id exists more than once in SFA DB" & vbCrLf & n_ne_id, MsgBoxStyle.Critical, "Too Many NE ID")
                        Log_issue(Log_source.SFA, "Get sfa.inst_id from ti.ne_id", "SFA_Issue", -1, "ne_id exists more than once in SFA DB" & vbCrLf & n_ne_id)
                        ret_val.Add("NO")
                        add_sync_count(count_list.TI_EXP)
                        bWasError = True  ' There was an error so lets not set the syncdate
                    Case "NOT_FOUND"
                        'Treat as new insert
                        Dim instrow As DataRow

                        instrow = sfa._get_new_install_row

                        'Dim i_last_inst_id As Integer = sfa._get_max_fldInstallationId

                        'If i_last_inst_id = -1 Then
                        '    MsgBox("log admin error, too many ret on get_max fld_id")

                        '    i_last_inst_id = 0
                        'End If

                        Dim loc_table As DataTable

                        loc_table = ti.get_mem_location_from_ne_id(n_ne_id)

                        If loc_table.Rows.Count = 0 Then
                            If main_form.CB_Debug.Checked Then MsgBox("no loc rows for inst")
                            ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", "N/A", 0, "ti.location", "The SNIN Attribute is not Located in TI and can not be processed into an SFA Database")
                            add_sync_count(count_list.TI_EXP)
                            bWasError = True  ' There was an error so lets not set the syncdate
                        ElseIf loc_table.Rows.Count > 1 Then
                            If main_form.CB_Debug.Checked Then MsgBox("multi locations for inst")
                            ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", "N/A", 0, "ti.location", "The SNIN Attribute has too many Locations in TI (should be a point asset) and can not be processed into an SFA Database")
                            add_sync_count(count_list.TI_EXP)
                            bWasError = True  ' There was an error so lets not set the syncdate
                        Else
                            Dim loc_row As DataRow = loc_table.Rows(0)




                            'SNIN	IIT_CHR_ATTRIB26	INV_DIR
                            'SNIN	IIT_CHR_ATTRIB27	LOC_NOTE
                            'SNIN	IIT_CHR_ATTRIB28	CITY_RD_FLG
                            'SNIN	IIT_CHR_ATTRIB29	CNTY_RD_FLG
                            'SNIN	IIT_CHR_ATTRIB66	OFF_NETWRK_NOTE
                            'SNIN	IIT_DISTANCE	    DSTNC_FROM_PVMT
                            'SNIN	IIT_NUM_ATTRIB100	LAT
                            'SNIN	IIT_NUM_ATTRIB101	LONGTD

                            'SNIN	IIT_CHR_ATTRIB26	LOC_NOTE	    Location Notes
                            'SNIN	IIT_CHR_ATTRIB27	CITY_RD_FLG	    City Road Flag
                            'SNIN	IIT_CHR_ATTRIB28	CNTY_RD_FLG	    County Road Flag
                            'SNIN	IIT_CHR_ATTRIB66	OFF_NETWRK_NOTE	Off Network Notes
                            'SNIN	IIT_NUM_ATTRIB102	    DSTNC_FROM_PVMT	Distance from End of Pavement
                            'SNIN	IIT_NUM_ATTRIB100	LAT	            Latitude
                            'SNIN	IIT_NUM_ATTRIB101	LONGTD	        Longitude



#If DEBUG Then
                            ' MsgBox(n_ne_id, , "Debug Info, adding NE_ID Inst into SFA")
#End If

                            'Dim dict_dir As Dictionary(Of String, String)
                            'dict_dir = _decode_Side_facing_from_XSP(row.Item("IIT_X_SECT"), loc_row.Item("ne_unique").ToString)

                            Dim dict_rte As Dictionary(Of String, String)

#If DEBUG Then

                            ' MsgBox("NE_ID, loc_row.Item(LINK_ID).ToString, loc_row.Item(HWY_NUM).ToString, loc_row.Item(ROADWAY_ID).ToString, loc_row.Item(NM_SLK).ToString" & vbCrLf & n_ne_id & loc_row.Item("LINK_ID") & vbCrLf & loc_row.Item("HWY_NUM") & vbCrLf & loc_row.Item("ROADWAY_ID") & vbCrLf & loc_row.Item("NM_SLK"))

#End If



                            dict_rte = _get_rt_dist_from_TBL_HWY_LKUP(loc_row.Item("LINK_ID").ToString, loc_row.Item("HWY_NUM").ToString, loc_row.Item("ROADWAY_ID").ToString, loc_row.Item("NM_SLK").ToString)


                            'regexp_replace( substr(lrm_key,1,5), '00$', null )

                            'instrow.Item("fldInstallationId") = i_last_inst_id + 1
                            instrow.Item("fldDistrict") = main_form.g_s_district
                            instrow.Item("fldStateHwy") = System.Text.RegularExpressions.Regex.Replace(loc_row.Item("HWY_NUM").ToString & loc_row.Item("LINK_ID").ToString, "00$", "")
                            instrow.Item("fldMPPrefix") = loc_row.Item("MT").ToString & loc_row.Item("OVERLAP_CODE").ToString
                            instrow.Item("fldMP") = loc_row.Item("MP")
                            instrow.Item("fldLocation") = row.Item("IIT_CHR_ATTRIB26")
                            'instrow.Item("fldDirection") = dict_dir.Item("DIRECTION")
                            'instrow.Item("fldSide") = dict_dir.Item("SIDE")
                            instrow.Item("fldDirection") = row.Item("IIT_CHR_ATTRIB30")
                            instrow.Item("fldSide") = row.Item("IIT_CHR_ATTRIB29")
                            instrow.Item("fldDistanceEOP") = row.Item("IIT_NUM_ATTRIB102")
                            instrow.Item("fldCreationDate") = row.Item("IIT_DATE_CREATED")
                            instrow.Item("RDWY_ID") = loc_row.Item("ROADWAY_ID").ToString
                            If dict_rte.Item("I_RTE") <> "" Then instrow.Item("intrstt_rts") = dict_rte.Item("I_RTE")
                            If dict_rte.Item("US_RTE") <> "" Then instrow.Item("us_rts") = dict_rte.Item("US_RTE")
                            If dict_rte.Item("OR_RTE") <> "" Then instrow.Item("stt_rts") = dict_rte.Item("OR_RTE")
                            instrow.Item("fldLatitude") = row.Item("IIT_NUM_ATTRIB100")
                            instrow.Item("fldLongitude") = row.Item("IIT_NUM_ATTRIB101")
                            If dict_rte.Item("DIST") <> "" Then instrow.Item("fldSecondDist") = dict_rte.Item("DIST")
                            instrow.Item("fldAddtNotes") = row.Item("IIT_CHR_ATTRIB66")
                            instrow.Item("SNIN_NE_ID") = n_ne_id


                            Dim rchk As Integer
                            rchk = sfa._insert_inst_row(instrow)

                            If rchk <> 1 Then
                                If main_form.CB_Debug.Checked Then MsgBox("instrow not inserted")
                                Log_issue(Log_source.SFA, "Issue inserting new Installation  row into SFA", "SFA_Issue", -1, "Issue inserting SNIN: " & n_ne_id, loc_row.Item("HWY_NUM").ToString, "milepoint:" & loc_row.Item("MP"))
                                ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", loc_row.Item("HWY_NUM").ToString, loc_row.Item("MP"), "SFA_Issue", "Issue inserting new Installation  row into SFA")
                                add_sync_count(count_list.TI_EXP)
                                bWasError = True  ' There was an error so lets not set the syncdate
                            Else
                                add_sync_count(count_list.TI_CNT)
                                'now lets do the childern
                                'get the inst ID
                                Dim new_inst_id As String
                                new_inst_id = sfa._get_inst_id_from_NE_ID(n_ne_id)

                                If new_inst_id = "MULTI" Or new_inst_id = "NOT_FOUND" Then
                                    'we have an issue to log
                                    If main_form.CB_Debug.Checked Then MsgBox("Inst ID not found when trying to place child" & vbCrLf & n_ne_id)
                                    Log_issue(Log_source.SFA, "Issue getting Inst_ID from Ne_ID for", "SFA_Issue", -1, "Issue trying to getting Inst_ID from NE_ID for: " & n_ne_id, My.Resources.strings.CONTACT_ADMIN)
                                Else
                                    _add_children_to_sfa_SNSN(n_ne_id.ToString, new_inst_id)
                                    _add_children_to_sfa_SNSU(n_ne_id.ToString, new_inst_id)
                                    _add_children_to_sfa_SNML(n_ne_id.ToString, new_inst_id)
                                End If
                                ret_val.Add(n_ne_id) ' add to a skip list so that updated children are not done twice
                            End If


                        End If
                    Case "END_DATE"
                        'need to delete from SFA and all the childern
                        s_inst_id = sfa._get_inst_id_from_NE_ID(n_ne_id)
                        If IsNumeric(s_inst_id) = True Then
                            'removing from the edit tables in case some lingering items exist in them
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.CUSTOM, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.DELETED, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.HISTORY, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.INSTALLATION, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.LEGEND, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.NEW_INSTALL, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.STANDARD, s_inst_id)
                            sfa._remove_from_edit_tables(SFA_Tools.edit_items.SUPPORTS, s_inst_id)


                            'Removing form sfa
                            sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSN, s_inst_id)
                            sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSU, s_inst_id)
                            sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNML, s_inst_id)
                            sfa._remove_Installation(s_inst_id)
                            add_sync_count(count_list.TI_CNT)

                            ret_val.Add(n_ne_id) ' add to a skip list so that updated children are not done twice
                        Else
                            add_sync_count(count_list.TI_EXP)
                            bWasError = True  ' There was an error so lets not set the syncdate
                        End If
                    Case Else
                        'Treat as update, only update the inst item in this case

                        Dim instrow As DataRow

                        instrow = sfa._get_new_install_row


                        Dim loc_table As DataTable

                        loc_table = ti.get_mem_location_from_ne_id(n_ne_id)


                        If loc_table.Rows.Count = 0 Then
                            If main_form.CB_Debug.Checked Then MsgBox("no loc rows for inst")
                            ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", "N/A", 0, "ti.location", "The SNIN Attribute is not Located in TI and can not be processed into an SFA Database")
                            add_sync_count(count_list.TI_EXP)
                            bWasError = True  ' There was an error so lets not set the syncdate
                        ElseIf loc_table.Rows.Count > 1 Then
                            If main_form.CB_Debug.Checked Then MsgBox("multi locations for inst")
                            ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", "N/A", 0, "ti.location", "The SNIN Attribute has too many Locations in TI (should be a point asset) and can not be processed into an SFA Database")
                            add_sync_count(count_list.TI_EXP)
                            bWasError = True  ' There was an error so lets not set the syncdate
                        Else


                            Dim loc_row As DataRow = loc_table.Rows(0)



                            'SNIN	IIT_CHR_ATTRIB26	LOC_NOTE	    Location Notes
                            'SNIN	IIT_CHR_ATTRIB27	CITY_RD_FLG	    City Road Flag
                            'SNIN	IIT_CHR_ATTRIB28	CNTY_RD_FLG	    County Road Flag
                            'SNIN	IIT_CHR_ATTRIB66	OFF_NETWRK_NOTE	Off Network Notes
                            'SNIN	IIT_NUM_ATTRIB102	    DSTNC_FROM_PVMT	Distance from End of Pavement
                            'SNIN	IIT_NUM_ATTRIB100	LAT	            Latitude
                            'SNIN	IIT_NUM_ATTRIB101	LONGTD	        Longitude

                            'instrow.Item("fldInstallationId") = i_last_inst_id + 1


                            'Dim dict_dir As Dictionary(Of String, String)
                            'dict_dir = _decode_Side_facing_from_XSP(row.Item("IIT_X_SECT"), loc_row.Item("ne_unique").ToString)

                            Dim dict_rte As Dictionary(Of String, String)
                            dict_rte = _get_rt_dist_from_TBL_HWY_LKUP(loc_row.Item("LINK_ID").ToString, loc_row.Item("HWY_NUM").ToString, loc_row.Item("ROADWAY_ID").ToString, loc_row.Item("NM_SLK").ToString)




                            instrow.Item("fldDistrict") = main_form.g_s_district '_sanitize_District(dict_rte.Item("DIST"))
                            instrow.Item("fldStateHwy") = System.Text.RegularExpressions.Regex.Replace(loc_row.Item("HWY_NUM").ToString & loc_row.Item("LINK_ID").ToString, "00$", "")
                            instrow.Item("fldMPPrefix") = loc_row.Item("MT").ToString & loc_row.Item("OVERLAP_CODE").ToString
                            instrow.Item("fldMP") = loc_row.Item("MP")
                            instrow.Item("fldLocation") = row.Item("IIT_CHR_ATTRIB26")
                            'instrow.Item("fldDirection") = dict_dir.Item("DIRECTION")
                            'instrow.Item("fldSide") = dict_dir.Item("SIDE")
                            instrow.Item("fldDirection") = row.Item("IIT_CHR_ATTRIB30")
                            instrow.Item("fldSide") = row.Item("IIT_CHR_ATTRIB29")
                            instrow.Item("fldDistanceEOP") = row.Item("IIT_NUM_ATTRIB102")
                            instrow.Item("fldCreationDate") = row.Item("IIT_DATE_CREATED")
                            instrow.Item("RDWY_ID") = loc_row.Item("ROADWAY_ID").ToString
                            If dict_rte.Item("I_RTE") <> "" Then instrow.Item("intrstt_rts") = dict_rte.Item("I_RTE")
                            If dict_rte.Item("US_RTE") <> "" Then instrow.Item("us_rts") = dict_rte.Item("US_RTE")
                            If dict_rte.Item("OR_RTE") <> "" Then instrow.Item("stt_rts") = dict_rte.Item("OR_RTE")
                            instrow.Item("fldLatitude") = row.Item("IIT_NUM_ATTRIB100")
                            instrow.Item("fldLongitude") = row.Item("IIT_NUM_ATTRIB101")
                            If dict_rte.Item("DIST") <> "" Then instrow.Item("fldSecondDist") = dict_rte.Item("DIST")
                            instrow.Item("fldAddtNotes") = row.Item("IIT_CHR_ATTRIB66")
                            instrow.Item("SNIN_NE_ID") = n_ne_id

                            Dim rv As Integer
                            Try
                                rv = sfa._update_inst_row(instrow)
                            Catch ex As Exception  ' added incase soemthing strange happens with the input.
                                ti.write_xodot_signs_logging_exception(n_ne_id, "N/A", instrow.Item("fldStateHwy"), loc_row.Item("MP"), "TItoSFA", "Error Attempting to UPDATE SFA with TI Data. See other logged error for details.")
                                rv = -1
                                Throw
                            End Try

                            If rv < 1 Then
                                bWasError = True  ' There was an error or nothing updated so lets not set the syncdate
                            End If

                            add_sync_count(count_list.TI_CNT)
                        End If

                End Select
                main_form.TSProgressBar1.Increment(1)
                Application.DoEvents()
            Next
        End If
        sfa.Dispose()

        If bWasError = False Then ft.write_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNIN, main_form.g_d_run_date)
        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0

        Return ret_val

    End Function

    Public Function process_TI_edited_supports(ByVal skip_list As ArrayList) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Gettign Edits that were made in TI, This includes items edited by another Field book.  And inserting/editing them into the current SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0
        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools
        Dim bWasError = False

        Dim loc_skip_list As ArrayList = skip_list.Clone

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim dt_ti_items As DataTable
        Dim s_last_date As String

        s_last_date = ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNSU, True)

        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Marquee
        main_form.TSStatusLabel1.Text = "Retrieving Changed Supports from Transinfo"

        dt_ti_items = ti.get_changed_sign_asset(main_form.g_s_crew, s_last_date, "SNSU") ' returns nm_inv_items_all
        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Continuous

#If DEBUG Then
        'Dim msg As String = "CrewSent: " & main_form.g_s_crew.ToString & vbCrLf & "date sent: " & s_last_date.ToString & vbCrLf & "returned Count: " & dt_ti_items.Rows.Count

        'MsgBox(msg, MsgBoxStyle.Information, "Debug Message")

        'MsgBox("The skiplist has: " & loc_skip_list.Count & vbCrLf & "When entering SNSU.  Some may get locally added during this run.", MsgBoxStyle.Information, "Debug Message")

#End If

        If dt_ti_items.Rows.Count > 0 Then
            Dim row As DataRow

            main_form.TSStatusLabel1.Text = "Inserting Changed Supports into SFA"
            main_form.TSProgressBar1.Minimum = 0
            main_form.TSProgressBar1.Maximum = dt_ti_items.Rows.Count
            main_form.TSProgressBar1.Value = 0



            For Each row In dt_ti_items.Rows
                Dim s_in_neid As String = row.Item("iit_foreign_key")
                If loc_skip_list.Contains(s_in_neid) = True Then  ' chk to see if it was processed with the edited installs, end date check added 
#If DEBUG Then
                    main_form.TSStatusLabel1.Text = "count: " & dt_ti_items.Rows.Count & ", " & "Doing SNSU for SNIN: " & row.Item("iit_foreign_key") & ", SNSU NEID: " & row.Item("iit_ne_id")
                    Application.DoEvents()
#End If
                ElseIf loc_skip_list.Contains(s_in_neid) = False And IsDBNull(row.Item("iit_end_date")) Then  ' end date check added 
                    Dim s_inst As String
                    s_inst = sfa._get_inst_id_from_NE_ID(s_in_neid)

                    If sfa._is_sfa_inst_in_edit_table(s_inst, SFA_Tools.edit_items.SUPPORTS) = False Then
                        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSU, s_in_neid)

                        If IsDBNull(row.Item("iit_end_date")) Then
                            ' only add if it wasn't enddated, althought it shouldn't happen normally, but coudl if done in TI
                            Dim s_sfa_id As String

                            s_sfa_id = sfa._get_inst_id_from_NE_ID(s_in_neid)
                            Dim rv As Integer
                            rv = _add_children_to_sfa_SNSU(s_in_neid, s_sfa_id)

                            If rv < 1 Then
                                bWasError = True  ' There was an error so lets not set the syncdate
                            End If

                            'since _add_children_to_sfa_SNXX(s_in_neid, s_sfa_id) does all the childern lets skip this the next time this parent ne_id comes up
                            loc_skip_list.Add(s_in_neid)

                        End If
                    Else
                        bWasError = True
                        ti.write_xodot_signs_logging_exception(s_in_neid, s_inst, "N/A", 0, "SNSU", My.Resources.strings.ERROR_TI_TO_SFA_WITH_EDIT_ITEM_IN_SFA)
                        add_sync_count(count_list.TI_EXP)
                    End If
                End If
                main_form.TSProgressBar1.Increment(1)
                Application.DoEvents()

            Next


        End If

        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0

        sfa.Dispose()
        If bWasError = False Then ft.write_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNSU, main_form.g_d_run_date)

        Return ret_val
    End Function

    Public Function process_TI_edited_signs(ByVal skip_list As ArrayList) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Gettign Edits that were made in TI, This includes items edited by another Field book.  And inserting/editing them into the current SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0
        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools
        Dim bWasError = False

        Dim loc_skip_list As ArrayList = skip_list.Clone

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim dt_ti_items As DataTable
        Dim s_last_date As String

        s_last_date = ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNSN, True)
        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Marquee
        main_form.TSStatusLabel1.Text = "Retrieving Changed Signs  from Transinfo"

        dt_ti_items = ti.get_changed_sign_asset(main_form.g_s_crew, s_last_date, "SNSN") ' returns nm_inv_items_all
        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Continuous

        If dt_ti_items.Rows.Count > 0 Then
            Dim row As DataRow

            main_form.TSStatusLabel1.Text = "Inserting Changed Signs into SFA"
            main_form.TSProgressBar1.Minimum = 0
            main_form.TSProgressBar1.Maximum = dt_ti_items.Rows.Count
            main_form.TSProgressBar1.Value = 0

            For Each row In dt_ti_items.Rows
#If DEBUG Then
                main_form.TSStatusLabel1.Text = "count: " & dt_ti_items.Rows.Count & ", " & "Doing SNSN for SNIN: " & row.Item("iit_foreign_key") & ", SNSN NEID: " & row.Item("iit_ne_id")
                Application.DoEvents()
#End If

                Dim s_in_neid As String = row.Item("iit_foreign_key")
                If loc_skip_list.Contains(s_in_neid) = False And IsDBNull(row.Item("iit_end_date")) Then  ' chk to see if it was processed with the edited installs, DB null check added to remove an end date issue.
                    Dim s_inst As String
                    s_inst = sfa._get_inst_id_from_NE_ID(s_in_neid)

                    If sfa._is_sfa_inst_in_edit_table(s_inst, SFA_Tools.edit_items.CUSTOM) = False And sfa._is_sfa_inst_in_edit_table(s_inst, SFA_Tools.edit_items.STANDARD) = False Then
                        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSN, s_in_neid)

                        If IsDBNull(row.Item("iit_end_date")) Then
                            ' only add if it wasn't enddated, althought it shouldn't happen normally, but coudl if done in TI
                            Dim s_sfa_id As String

                            s_sfa_id = sfa._get_inst_id_from_NE_ID(s_in_neid)

                            If s_sfa_id <> "NOT_FOUND" Then

                                Dim rv As Integer
                                rv = _add_children_to_sfa_SNSN(s_in_neid, s_sfa_id)
                                If rv < 1 Then bWasError = True ' There was an error so lets not set the syncdate


                                'since _add_children_to_sfa_SNXX(s_in_neid, s_sfa_id) does all the childern lets skip this the next time this parent ne_id comes up
                                loc_skip_list.Add(s_in_neid)
                            Else

                            End If

                        End If
                    Else
                        bWasError = True
                        ti.write_xodot_signs_logging_exception(s_in_neid, s_inst, "N/A", 0, "SNSN", My.Resources.strings.ERROR_TI_TO_SFA_WITH_EDIT_ITEM_IN_SFA)
                        add_sync_count(count_list.TI_EXP)
                    End If


                End If
                main_form.TSProgressBar1.Increment(1)
                Application.DoEvents()
            Next


        End If

        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0

        sfa.Dispose()
        If bWasError = False Then ft.write_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNSN, main_form.g_d_run_date)

        Return ret_val
    End Function

    Public Function process_TI_edited_Maint_Log(ByVal skip_list As ArrayList) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Gettign Edits that were made in TI, This includes items edited by another Field book.  And inserting/editing them into the current SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0
        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        Dim bWasError = False

        Dim loc_skip_list As ArrayList = skip_list.Clone

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim dt_ti_items As DataTable
        Dim s_last_date As String

        s_last_date = ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNML, True)

        main_form.TSStatusLabel1.Text = "Retrieving Changed History into SFA"
        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Marquee

        dt_ti_items = ti.get_changed_sign_asset(main_form.g_s_crew, s_last_date, "SNML") ' returns nm_inv_items_all
        main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Continuous

        If dt_ti_items.Rows.Count > 0 Then
            Dim row As DataRow

            main_form.TSStatusLabel1.Text = "Inserting Changed History  from Transinfo"
            main_form.TSProgressBar1.Minimum = 0
            main_form.TSProgressBar1.Maximum = dt_ti_items.Rows.Count
            main_form.TSProgressBar1.Value = 0

            For Each row In dt_ti_items.Rows
#If DEBUG Then
                main_form.TSStatusLabel1.Text = "count: " & dt_ti_items.Rows.Count & ", " & "Doing SNML for SNIN: " & row.Item("iit_foreign_key") & ", SNML NEID: " & row.Item("iit_ne_id")
                Application.DoEvents()
#End If

                Dim s_in_neid As String = row.Item("iit_foreign_key")
                If loc_skip_list.Contains(s_in_neid) = False And IsDBNull(row.Item("iit_end_date")) Then  ' chk to see if it was processed with the edited installs, end date check added 
                    Dim s_inst As String
                    s_inst = sfa._get_inst_id_from_NE_ID(s_in_neid)

                    If sfa._is_sfa_inst_in_edit_table(s_inst, SFA_Tools.edit_items.HISTORY) = False Then
                        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNML, s_in_neid)

                        If IsDBNull(row.Item("iit_end_date")) Then
                            ' only add if it wasn't enddated, althought it shouldn't happen normally, but coudl if done in TI
                            Dim s_sfa_id As String

                            s_sfa_id = sfa._get_inst_id_from_NE_ID(s_in_neid)

                            Dim rv As Integer

                            rv = _add_children_to_sfa_SNML(s_in_neid, s_sfa_id)

                            If rv < 1 Then bWasError = True ' There was an error so lets not set the syncdate

                            'since _add_children_to_sfa_SNXX(s_in_neid, s_sfa_id) does all the childern lets skip this the next time this parent ne_id comes up
                            loc_skip_list.Add(s_in_neid)

                        End If
                    Else
                        bWasError = True
                        ti.write_xodot_signs_logging_exception(s_in_neid, s_inst, "N/A", 0, "SNML", My.Resources.strings.ERROR_TI_TO_SFA_WITH_EDIT_ITEM_IN_SFA)
                        add_sync_count(count_list.TI_EXP)
                    End If
                End If
                main_form.TSProgressBar1.Increment(1)
                Application.DoEvents()
            Next


        End If

        sfa.Dispose()

        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0

        If bWasError = False Then ft.write_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNML, main_form.g_d_run_date)

        Return ret_val
    End Function



    Private Function _add_children_to_sfa_SNSN(s_parent_ne_id As String, s_sfa_inst_id As String) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: Given the TI ID and SFA ID of a parent get all the SNSN childeren and add them to SFA
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = -1

        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        Dim bWasError = False

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()
        Dim DT As DataTable

        DT = ti.get_child_from_parent_ne_id(s_parent_ne_id, "SNSN")

        'remove existing childern from sfa

        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSN, s_sfa_inst_id)


        If DT.Rows.Count > 0 Then
            Dim c_row As DataRow

            For Each c_row In DT.Rows
                '	SNSN	IIT_CHR_ATTRIB26	SIGN_TYP
                '	SNSN	IIT_CHR_ATTRIB27	STD_SIGN_ID
                '	SNSN	IIT_CHR_ATTRIB28	FAIL_FLG
                '	SNSN	IIT_CHR_ATTRIB29	FACING_DIR
                '	SNSN	IIT_CHR_ATTRIB30	SBSTR
                '	SNSN	IIT_CHR_ATTRIB31	SHEETING
                '	SNSN	IIT_CHR_ATTRIB32	SOI_FLG
                '	SNSN	IIT_CHR_ATTRIB66	CUSTOM_LGND
                '	SNSN	IIT_CHR_ATTRIB67	CUSTOM_PIC_PATH
                '	SNSN	IIT_DATE_ATTRIB86	EST_RPLCMNT_DT
                '	SNSN	IIT_DATE_ATTRIB88	INSP_DT
                '	SNSN	IIT_FOREIGN_KEY		IT_FK
                '	SNSN	IIT_DATE_ATTRIB87	INSTALL_DT
                '   SNSN	IIT_NUM_ATTRIB16	CUSTOM_WD	Custom Width
                '   SNSN	IIT_NUM_ATTRIB17	CUSTOM_HT	Custom Height
                '   SNSN	IIT_NUM_ATTRIB18	RECYC_CNT	Recycle Count

                Dim inst_row As DataRow

                If c_row.Item("IIT_CHR_ATTRIB26") = "S" Then
                    'standard sign
                    inst_row = sfa._get_new_std_panel_row

                    inst_row.Item("fldInstalledId") = Convert.ToDecimal(s_sfa_inst_id)
                    inst_row.Item("fldStandSignNumber") = c_row.Item("IIT_CHR_ATTRIB27").ToString
                    inst_row.Item("fldStandEstReplaceDate") = c_row.Item("IIT_DATE_ATTRIB86")
                    inst_row.Item("fldStandFail") = _get_access_bool(c_row.Item("IIT_CHR_ATTRIB28").ToString)
                    inst_row.Item("fldFacingId") = sfa._get_FacingID(c_row.Item("IIT_CHR_ATTRIB29").ToString)
                    inst_row.Item("fldInstallDate") = c_row.Item("IIT_DATE_ATTRIB87")
                    inst_row.Item("RefInspDt") = c_row.Item("IIT_DATE_ATTRIB88")
                    inst_row.Item("fldSheeting") = c_row.Item("IIT_CHR_ATTRIB31").ToString
                    inst_row.Item("fldSubstrate") = c_row.Item("IIT_CHR_ATTRIB30").ToString
                    inst_row.Item("fldSignRecycleCount") = c_row.Item("IIT_NUM_ATTRIB18")
                    inst_row.Item("fldSOI") = _get_access_bool(c_row.Item("IIT_CHR_ATTRIB32").ToString)

                    Dim r_chk As Integer

                    r_chk = sfa._insert_general_row(inst_row, "tblInstalledStandardSigns")
                    If r_chk <> 1 Then
                        If main_form.CB_Debug.Checked Then MsgBox("error inserting child with inst id" & vbCrLf & Convert.ToDecimal(s_sfa_inst_id))
                        Log_issue(Log_source.SFA, "tblInstalledStandardSigns Insert", "SFA_Issue", -1, "error inserting child with inst id" & Convert.ToDecimal(s_sfa_inst_id), , My.Resources.strings.CONTACT_ADMIN)
                        add_sync_count(count_list.TI_EXP)
                        bWasError = True  ' There was an error so lets not set the syncdate
                    Else
                        add_sync_count(count_list.TI_CNT)
                        ret_val = r_chk
                    End If
                Else
                    'custom sign
                    inst_row = sfa._get_new_cust_panel_row

                    Dim i_next_legend_id As Integer

                    i_next_legend_id = sfa._get_max_fldLegendId + 1

                    inst_row.Item("fldInstalledId") = Convert.ToDecimal(s_sfa_inst_id)
                    inst_row.Item("fldCustWidth") = c_row.Item("IIT_NUM_ATTRIB16")
                    inst_row.Item("fldCustHeight") = c_row.Item("IIT_NUM_ATTRIB17")
                    inst_row.Item("fldCustEstReplaceDate") = c_row.Item("IIT_DATE_ATTRIB86")
                    inst_row.Item("fldCustLegendId") = i_next_legend_id
                    inst_row.Item("fldCustFail") = _get_access_bool(c_row.Item("IIT_CHR_ATTRIB28").ToString)
                    inst_row.Item("fldCustPicture") = c_row.Item("IIT_CHR_ATTRIB67").ToString
                    inst_row.Item("fldFacingId") = sfa._get_FacingID(c_row.Item("IIT_CHR_ATTRIB29").ToString)
                    inst_row.Item("fldSubstrate") = c_row.Item("IIT_CHR_ATTRIB30").ToString
                    inst_row.Item("fldSheeting") = c_row.Item("IIT_CHR_ATTRIB31").ToString
                    inst_row.Item("fldInstallDate") = c_row.Item("IIT_DATE_ATTRIB87")
                    inst_row.Item("RefInspDt") = c_row.Item("IIT_DATE_ATTRIB88")
                    inst_row.Item("fldSignRecycleCount") = c_row.Item("IIT_NUM_ATTRIB18")
                    inst_row.Item("fldSOI") = _get_access_bool(c_row.Item("IIT_CHR_ATTRIB32").ToString)

                    Dim r_chk As Integer
                    r_chk = sfa._insert_general_row(inst_row, "tblInstalledCustomSigns")
                    If r_chk <> 1 Then
                        ' MsgBox("error inserting child with inst id" & vbCrLf & Convert.ToDecimal(s_sfa_inst_id))
                        Log_issue(Log_source.SFA, "tblInstalledCustomSigns Insert", "SFA_Issue", -1, "error inserting child with inst id " & Convert.ToDecimal(s_sfa_inst_id), , My.Resources.strings.CONTACT_ADMIN)
                        add_sync_count(count_list.TI_EXP)
                        bWasError = True  ' There was an error so lets not set the syncdate
                    Else
                        'lets add the legends
                        '	SNSN	IIT_CHR_ATTRIB66	CUSTOM_LGND
                        Dim s_array As String()

                        s_array = Split(c_row.Item("IIT_CHR_ATTRIB66").ToString, sBreakChar)

                        ret_val = r_chk

                        For i = LBound(s_array) To UBound(s_array)
                            Dim cl_row As DataRow
                            cl_row = sfa._get_new_legend_row

                            cl_row.Item("fldLegendID") = i_next_legend_id
                            cl_row.Item("fldLegend") = s_array(i)
                            cl_row.Item("fldLineNo") = i + 1

                            If IsDBNull(s_array(i)) Or s_array(i) = "" Then
                                ' Something went wrong with the line break Char and we should log it
                                bWasError = True
                                add_sync_count(count_list.TI_EXP)
                                ti.write_xodot_signs_logging_exception(s_sfa_inst_id, "N/A", "N/A", 0, "SignLegends", "This Item has a Custom Sign Legends line break or missing a value that would result in a empty string being created in SFA.")
                            Else

                                ret_val = sfa._insert_general_row(cl_row, "tblCustomSignLegends")

                                If ret_val < 1 Then bWasError = True ' There was an error so lets not set the syncdate
                            End If
                        Next i

                        add_sync_count(count_list.TI_CNT)


                    End If

                End If

            Next

        End If

        If bWasError = True Then ret_val = -1 ' There was an error so lets return -1

        sfa.Dispose()
        Return ret_val
    End Function

    Private Function _add_children_to_sfa_SNSU(s_parent_ne_id As String, s_sfa_inst_id As String) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Given the TI ID and SFA ID of a parent get all the SNSU children and add them to SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = -1

        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()
        Dim DT As DataTable

        DT = ti.get_child_from_parent_ne_id(s_parent_ne_id, "SNSU")

        'remove existing childern from sfa

        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNSU, s_sfa_inst_id)

        '#If DEBUG Then
        '        Dim msg As String = "SNSU Doing Parent NE_ID: " & s_parent_ne_id & vbCrLf & "sfa_inst_id: " & vbCrLf & "Children returned form TI: " & vbCrLf & DT.Rows.Count
        '        MsgBox(msg, MsgBoxStyle.Information, "Debug Message")
        '#End If


        If DT.Rows.Count > 0 Then
            Dim c_row As DataRow
            For Each c_row In DT.Rows

                'SNSU	IIT_CHR_ATTRIB26	SUPP_TYP
                'SNSU	IIT_CHR_ATTRIB27	SUPP_DESC
                'SNSU	IIT_FOREIGN_KEY	    IT_FK
                'SNSU	IIT_DATE_ATTRIB86    INSTALL_DT
                'SNSU	IIT_NO_OF_UNITS 	NO_SUPPS


                '#If DEBUG Then
                '                Dim msg2 As String = "NEID: " & s_parent_ne_id & vbCrLf & "SFA_ID: " & s_sfa_inst_id & vbCrLf & "IIT_NO_OF_UNITS: " & c_row.Item("IIT_NO_OF_UNITS") & vbCrLf & "IIT_CHR_ATTRIB26: " & c_row.Item("IIT_CHR_ATTRIB26") & vbCrLf & "IIT_DATE_ATTRIB86: " & c_row.Item("IIT_DATE_ATTRIB86")
                '                MsgBox(msg2, MsgBoxStyle.Information, "Debug Message")
                '#End If



                Dim w_row As DataRow

                w_row = sfa._get_new_support_row

                w_row("fldInstalledId") = s_sfa_inst_id
                w_row("fldNumberOfPosts") = c_row.Item("IIT_NO_OF_UNITS")
                'w_row("fldPostType_Size") = c_row.Item("IIT_CHR_ATTRIB26")
                w_row("fldPostType_Size") = c_row.Item("SUPP_DESC")
                w_row("fldInstallDate") = c_row.Item("IIT_DATE_ATTRIB86")

                Dim r_chk As Integer
                r_chk = sfa._insert_general_row(w_row, "tblInstalledSupports")
                If r_chk <> 1 Then
                    If main_form.CB_Debug.Checked Then MsgBox("error inserting child with inst id" & vbCrLf & Convert.ToDecimal(s_sfa_inst_id))
                    Log_issue(Log_source.SFA, "tblInstalledSupports Insert", "SFA_Issue", -1, "error inserting child with inst id " & Convert.ToDecimal(s_sfa_inst_id), , My.Resources.strings.CONTACT_ADMIN)
                    add_sync_count(count_list.TI_EXP)
                Else
                    ret_val = r_chk
                    add_sync_count(count_list.TI_CNT)
                End If
            Next
        End If
        sfa.Dispose()
        Return ret_val
    End Function

    Private Function _add_children_to_sfa_SNML(s_parent_ne_id As String, s_sfa_inst_id As String) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Given the TI ID and SFA ID of a parent get all the SNML children and add them to SFA
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = -1

        Dim sfa As New SFA_Tools
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()
        Dim DT As DataTable

        DT = ti.get_child_from_parent_ne_id(s_parent_ne_id, "SNML")

        'remove existing childern from sfa

        sfa._remove_child_item_for_inst_ID(SFA_Tools.ti_child_assets.SNML, s_sfa_inst_id)



        If DT.Rows.Count > 0 Then
            Dim c_row As DataRow
            For Each c_row In DT.Rows

                'SNML	IIT_CHR_ATTRIB26	ACTN
                'SNML	IIT_CHR_ATTRIB27	CAUSE
                'SNML	IIT_CHR_ATTRIB28	SIGN_DTL
                'SNML	IIT_CHR_ATTRIB29	RESP_PER
                'SNML	IIT_CHR_ATTRIB30	SIGN_SZ
                'SNML	IIT_CHR_ATTRIB31	SIGN_FACING
                'SNML	IIT_CHR_ATTRIB56	SIGN_LGND
                'SNML	IIT_CHR_ATTRIB66	COMNT
                'SNML	IIT_CHR_ATTRIB67	MATL
                'SNML	IIT_CHR_ATTRIB70	SUPP_DESC
                'SNML	IIT_DATE_ATTRIB86	MAINT_HIST_DT
                'SNML	IIT_FOREIGN_KEY 	IT_FK
                'SNML	IIT_NO_OF_UNITS 	ACCOMP
                'SNML	IIT_NUM_ATTRIB16	CREW_HR
                'SNML	IIT_NUM_ATTRIB17	EQUIP_HR
                Dim w_row As DataRow
                w_row = sfa._get_new_history_row

                w_row("fldInstalledId") = s_sfa_inst_id
                w_row("fldHistDate") = c_row.Item("IIT_DATE_ATTRIB86")
                w_row("fldHistAction") = c_row.Item("IIT_CHR_ATTRIB26")
                w_row("fldHistCause") = c_row.Item("IIT_CHR_ATTRIB27")
                w_row("fldHistCrewHours") = c_row.Item("IIT_NUM_ATTRIB16")
                w_row("fldHistEquipHours") = c_row.Item("IIT_NUM_ATTRIB17")
                w_row("fldHistSignNumber") = c_row.Item("IIT_CHR_ATTRIB28")
                w_row("fldHistRespPerson") = c_row.Item("IIT_CHR_ATTRIB29")
                w_row("fldHistComments") = c_row.Item("IIT_CHR_ATTRIB66")
                w_row("fldHistAccomplishments") = c_row.Item("IIT_CHR_ATTRIB57")
                w_row("fldHistMaterials") = c_row.Item("IIT_CHR_ATTRIB67")
                w_row("fldHistSignLegend") = c_row.Item("IIT_CHR_ATTRIB56")
                w_row("fldHistSignSize") = c_row.Item("IIT_CHR_ATTRIB30")
                w_row("fldHistSignFacing") = c_row.Item("IIT_CHR_ATTRIB31")
                w_row("fldHistPost") = c_row.Item("IIT_CHR_ATTRIB70")
                w_row("fldHistAct") = ""

                Dim r_chk As Integer
                r_chk = sfa._insert_general_row(w_row, "tblInstallationHistory")

                If r_chk <> 1 Then
                    If main_form.CB_Debug.Checked Then MsgBox(" tblInstallationHistor error inserting child with inst id" & vbCrLf & Convert.ToDecimal(s_sfa_inst_id))
                    Log_issue(Log_source.SFA, "tblInstallationHistory Insert", "SFA_Issue", -1, "error inserting child with inst id" & Convert.ToDecimal(s_sfa_inst_id), , My.Resources.strings.CONTACT_ADMIN)
                    add_sync_count(count_list.TI_EXP)
                Else
                    ret_val = r_chk
                    add_sync_count(count_list.TI_CNT)
                End If
            Next
        End If
        sfa.Dispose()
        Return ret_val
    End Function
    Private Function _access_yes_no(i As Integer) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: converting an access int to Y or N
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = "N"

        If i <> 0 Then ret_val = "Y"

        Return ret_val
    End Function

    Private Function _access_true_false_to_YN(i As Boolean) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: converting a bool to Y or N
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = "N"

        If i <> False Then ret_val = "Y"

        Return ret_val
    End Function

    Private Function _get_access_bool(s_input) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: converting a  Y or N to access int (bool)
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0

        Select Case s_input
            Case "Y"
                ret_val = -1
            Case Else
                ret_val = 0
        End Select

        Return ret_val
    End Function

    Private Function _YN_to_boolean(item As String) As Boolean
        Dim ret_val As Boolean = False

        If item.ToUpper = "Y" Then ret_val = True

        Return ret_val
    End Function

    Private Sub _replace_row_null_except_dates(ByRef r_row As DataRow)
        '''''''''''''''''''''''''''''''''''
        'Used For: this removes the dbnull from everything in a row except dates, and turns it into -1  so the TI tools routines doesnt process them
        '''''''''''''''''''''''''''''''''''
        ' 

        Dim c_col As DataColumn

        For Each c_col In r_row.Table.Columns
            If IsDBNull(r_row(c_col)) Then
                Select Case c_col.DataType
                    Case System.Type.GetType("System.String")
                        r_row(c_col) = "-1"
                    Case System.Type.GetType("System.DateTime")
                        ' nothing
                    Case Else
                        r_row(c_col) = -1
                End Select
            End If
        Next
    End Sub

    Public Enum Log_source
        '''''''''''''''''''''''''''''''''''
        'Used For: The Log_issue routine
        '''''''''''''''''''''''''''''''''''
        TI
        SFA
        CUSTOM
    End Enum

    Public Sub Log_issue(source As Log_source, source_function As String, err_code As String, err_message As String, Optional s_id As String = "", Optional s_loc As String = "", Optional extra_info As String = "")
        '''''''''''''''''''''''''''''''''''
        'Used For: Logging an issue to the Broker_data.mdb  for use with the error log.
        '''''''''''''''''''''''''''''''''''

        Dim ft As New File_Config_Tools
        Dim ti As New TI_Tools

        If extra_info = "" Then extra_info = My.Resources.strings.ERROR_UNEXPECTED

        Dim msg As String = My.Resources.strings.ERROR_SFA_LOG_UNHANDLED

        If s_loc = "" Then
            msg = "Issue when processing the item: " & source_function & " for " & s_loc & " with an ID of " & s_id & ". Additional information: " & extra_info
        Else
            msg = msg.Replace("<LOC>", s_loc)
        End If

        Select Case source
            Case Log_source.TI

                ' msg = "Issue when processing the item: " & source_function & " for " & s_loc & " with an ID of " & s_id & ". Additional information: " & extra_info

                ft.Write_mdb_sync_log(err_code & ": " & err_message, msg)
                'ti.write_xodot_signs_logging_exception("N/A", s_id, "See MSG", -1, err_message, msg)
            Case Log_source.SFA
                'msg = "Issue when  processing the item: " & source_function & " for " & s_loc & " with an ID of " & s_id & ". Additional information: " & extra_info
                ft.Write_mdb_sync_log(err_code & ": " & err_message, msg)
                'ti.write_xodot_signs_logging_exception("N/A", s_id, "See MSG", -1, err_message, msg)
            Case Log_source.CUSTOM

                msg = err_message
                ft.Write_mdb_sync_log(err_code & ": " & err_message, msg)

        End Select


    End Sub

    Public Sub Get_LOV_DOMAINS()
        '''''''''''''''''''''''''''''''''''
        'Used For: Filling LOVs that are based on TI Domains
        '''''''''''''''''''''''''''''''''''
        Dim enum_items As Array
        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        enum_items = System.Enum.GetNames((GetType(TI_Tools.TI_LOV_DOMAINS)))

        Dim ti As New TI_Tools
        Dim item As String

        For Each item In enum_items
            Dim dt As New DataTable
            dt = ti.get_domain_lov(item)

            If dt.Rows.Count > 0 Then
                Dim row As DataRow

                main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                main_form.TSProgressBar1.Minimum = 0
                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                main_form.TSProgressBar1.Value = 0

                Dim sfa_table As New SFA_Tools.LOV

                Select Case item
                    Case TI_Tools.TI_LOV_DOMAINS.SIGN_SBSTR.ToString
                        sfa_table = SFA_Tools.LOV.TBLSUBSTRATE
                    Case TI_Tools.TI_LOV_DOMAINS.SIGN_SHEETING.ToString
                        sfa_table = SFA_Tools.LOV.TBLSHEETING
                    Case TI_Tools.TI_LOV_DOMAINS.GEN_DIR.ToString
                        sfa_table = SFA_Tools.LOV.TBLDIRECTIONS
                End Select

                sfa._remove_LOV_items(sfa_table)


                For Each row In dt.Rows
                    Dim newrow As DataRow

                    newrow = sfa._get_new_lov_row(sfa_table)

                    newrow.Item(0) = row.Item(0)
                    newrow.Item(1) = row.Item(1)

                    sfa._insert_general_row(newrow, sfa_table.ToString.ToUpper)

                    main_form.TSProgressBar1.Increment(1)
                    Application.DoEvents()

                Next
                add_sync_count(count_list.LOV_CNT)
            End If


        Next

        sfa.Dispose()
    End Sub

    Public Sub Get_LOV_ASSETS()
        '''''''''''''''''''''''''''''''''''
        'Used For: Filling LOVs that are based on TI Assets
        '''''''''''''''''''''''''''''''''''
        Dim enum_items As Array
        Dim ft As New File_Config_Tools
        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        enum_items = System.Enum.GetNames((GetType(TI_Tools.TI_LOV_ASSETS)))

        Dim ti As New TI_Tools
        Dim item As String


        For Each item In enum_items
            Dim dt As New DataTable
            Dim last_date As Date
            Try
                Dim asset_enum As New File_Config_Tools.sync_date_val

                asset_enum = DirectCast([Enum].Parse(GetType(File_Config_Tools.sync_date_val), "UPDATE_LOV_" & item), File_Config_Tools.sync_date_val)

                last_date = ft.get_sync_date(asset_enum)

                dt = ti.get_asset_lov(item, last_date.ToString)

                If dt.Rows.Count > 0 Then
                    If dt.Rows(0).Item(0) <> "NO_CHANGE" Then


                        main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                        main_form.TSProgressBar1.Minimum = 0
                        main_form.TSProgressBar1.Maximum = dt.Rows.Count
                        main_form.TSProgressBar1.Value = 0

                        Dim sfa_table As New SFA_Tools.LOV

                        Select Case item
                            Case TI_Tools.TI_LOV_ASSETS.SIGN.ToString
                                sfa_table = SFA_Tools.LOV.TBLSTANDARDSIGNS

                                'okay we have new values, lets replace them all for now
                                sfa._remove_LOV_items(sfa_table)

                                Dim row As DataRow

                                For Each row In dt.Rows
                                    If IsDBNull(row.Item("iit_end_date")) = True Then
                                        Dim newrow As DataRow
                                        newrow = sfa._get_new_lov_row(sfa_table)

                                        newrow.Item("fldStandSignNumber") = row.Item("IIT_CHR_ATTRIB26")
                                        newrow.Item("fldStandStoreroomNumber") = row.Item("IIT_CHR_ATTRIB27")
                                        newrow.Item("fldStandSize") = row.Item("IIT_CHR_ATTRIB28")
                                        newrow.Item("fldStandWidth") = row.Item("IIT_NUM_ATTRIB16")
                                        newrow.Item("fldStandHeight") = row.Item("IIT_NUM_ATTRIB17")
                                        newrow.Item("fldStandColor") = row.Item("IIT_CHR_ATTRIB29")
                                        newrow.Item("fldStandSignType") = row.Item("IIT_CHR_ATTRIB30")
                                        newrow.Item("fldStandDescription") = row.Item("IIT_CHR_ATTRIB56")
                                        'newrow.Item("fldGraphicId") = row.Item("IIT_CHR_ATTRIB31")  ' changed to reflect data model change from orginal
                                        newrow.Item("fldGraphicId") = row.Item("GRAPH_ID")
                                        newrow.Item("fldShow") = _YN_to_boolean(row.Item("IIT_CHR_ATTRIB32"))
                                        newrow.Item("fldMMS") = row.Item("IIT_CHR_ATTRIB33")

                                        Dim ret As Integer

                                        ret = sfa._insert_general_row(newrow, sfa_table.ToString)

                                        If ret = 1000000000 Then
                                            ti.write_xodot_signs_logging_exception("N/A", "N/A", "N/A", 0, "SIGN", "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                            add_sync_count(count_list.LOV_EXP)


                                        End If


                                    End If
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next

                                add_sync_count(count_list.LOV_CNT)
                                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_SIGN, main_form.g_d_run_date)

                            Case TI_Tools.TI_LOV_ASSETS.SNAC.ToString
                                sfa_table = SFA_Tools.LOV.TBLACTIONS

                                'okay we have new values, lets replace them all for now
                                sfa._remove_LOV_items(sfa_table)

                                Dim row As DataRow

                                main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                                main_form.TSProgressBar1.Minimum = 0
                                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                                main_form.TSProgressBar1.Value = 0

                                For Each row In dt.Rows
                                    If IsDBNull(row.Item("iit_end_date")) <> False Then
                                        Dim newrow As DataRow
                                        newrow = sfa._get_new_lov_row(sfa_table)

                                        newrow.Item("fldAction") = row.Item("IIT_CHR_ATTRIB26")
                                        Dim ret As Integer
                                        ret = sfa._insert_general_row(newrow, sfa_table.ToString)

                                        If ret = 1000000000 Then
                                            'Log_issue(Log_source.SFA, "SNAC", ret, "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                            ti.write_xodot_signs_logging_exception("N/A", "N/A", "N/A", 0, "SNAC", "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                            add_sync_count(count_list.LOV_EXP)
                                        End If
                                    End If
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next

                                add_sync_count(count_list.LOV_CNT)
                                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_SNAC, main_form.g_d_run_date)

                            Case TI_Tools.TI_LOV_ASSETS.SNCS.ToString
                                sfa_table = SFA_Tools.LOV.TBLCAUSES

                                'okay we have new values, lets replace them all for now
                                sfa._remove_LOV_items(sfa_table)

                                Dim row As DataRow
                                main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                                main_form.TSProgressBar1.Minimum = 0
                                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                                main_form.TSProgressBar1.Value = 0

                                For Each row In dt.Rows
                                    If IsDBNull(row.Item("iit_end_date")) <> False Then
                                        Dim newrow As DataRow
                                        newrow = sfa._get_new_lov_row(sfa_table)

                                        newrow.Item("fldCause") = row.Item("IIT_CHR_ATTRIB26")
                                        Dim ret As Integer
                                        ret = sfa._insert_general_row(newrow, sfa_table.ToString)
                                        If ret = 1000000000 Then
                                            'Log_issue(Log_source.SFA, "SNCS", ret, "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                            ti.write_xodot_signs_logging_exception("N/A", "N/A", "N/A", 0, "SNCS", "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                            add_sync_count(count_list.LOV_EXP)
                                        End If

                                    End If

                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next

                                add_sync_count(count_list.LOV_CNT)
                                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_SNCS, main_form.g_d_run_date)


                            Case TI_Tools.TI_LOV_ASSETS.SNGR.ToString
                                sfa_table = SFA_Tools.LOV.TBLSTANDARDSIGNGRAPHICS

                                'okay we have new values, lets replace them all for now
                                sfa._remove_LOV_items(sfa_table)

                                Dim row As DataRow
                                main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                                main_form.TSProgressBar1.Minimum = 0
                                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                                main_form.TSProgressBar1.Value = 0

                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(sfa_table)

                                    Dim iShow As Integer = 0

                                    If IsDBNull(row.Item("iit_end_date")) = True Then
                                        iShow = -1
                                    End If


                                    newrow.Item("fldGraphicId") = row.Item("IIT_NUM_ATTRIB16")
                                    newrow.Item("fldGraphicName") = row.Item("IIT_CHR_ATTRIB56")    ' in SFA it is filled wiht the path
                                    newrow.Item("fldDescription") = row.Item("IIT_CHR_ATTRIB57")
                                    newrow.Item("fldShow") = iShow
                                    Dim ret As Integer
                                    ret = sfa._insert_general_row(newrow, sfa_table.ToString)


                                    If ret = 1000000000 Then
                                        'Log_issue(Log_source.SFA, "SNGR", ret, "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                        ti.write_xodot_signs_logging_exception("N/A", "N/A", "N/A", 0, "SNGR", "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                        add_sync_count(count_list.LOV_EXP)
                                    End If
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next

                                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_SNGR, main_form.g_d_run_date)
                                add_sync_count(count_list.LOV_EXP)


                            Case TI_Tools.TI_LOV_ASSETS.SUPP.ToString
                                sfa_table = SFA_Tools.LOV.TBLSUPPORTS

                                'okay we have new values, lets replace them all for now
                                sfa._remove_LOV_items(sfa_table)

                                Dim row As DataRow

                                main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                                main_form.TSProgressBar1.Minimum = 0
                                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                                main_form.TSProgressBar1.Value = 0

                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(sfa_table)

                                    Dim iShow As Integer = -1

                                    If IsDBNull(row.Item("iit_end_date")) = False Then
                                        iShow = 0
                                    End If


                                    newrow.Item("fldSupportStoreRoomNum") = row.Item("IIT_CHR_ATTRIB56")
                                    'newrow.Item("fldSupportSize") = row.Item("IIT_CHR_ATTRIB56")
                                    newrow.Item("fldSupportType") = row.Item("IIT_CHR_ATTRIB26")
                                    'newrow.Item("fldSupportCost") = row.Item("IIT_CHR_ATTRIB57")
                                    'newrow.Item("fldSupportMMS") = row.Item("IIT_CHR_ATTRIB27")
                                    newrow.Item("fldShow") = iShow
                                    Dim ret As Integer
                                    ret = sfa._insert_general_row(newrow, sfa_table.ToString)
                                    If ret = 1000000000 Then

                                        ti.write_xodot_signs_logging_exception("N/A", "N/A", "N/A", 0, "SUPP", "Possible Duplicate Item: " & row.Item("IIT_CHR_ATTRIB26"))
                                        add_sync_count(count_list.LOV_EXP)
                                    End If
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next



                                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_SUPP, main_form.g_d_run_date)
                                add_sync_count(count_list.LOV_CNT)
                            Case Else
                                ' do nothing
                        End Select



                    End If
                End If
            Catch ex As Exception  ' If I cant find the date in the MDB's last sync, skip updating
                Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
                Dim i As Int16

                If mes.Length < 1998 Then
                    i = mes.Length
                Else
                    i = 1997
                End If
                add_sync_count(count_list.LOV_EXP)
                ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            End Try

        Next

        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0

        sfa.Dispose()
    End Sub



    Public Sub get_LOV_REPORTS_SCHEMA()
        '''''''''''''''''''''''''''''''''''
        'Used For: Filling LOVs that are based on TI report schema
        '''''''''''''''''''''''''''''''''''
        Dim enum_items As Array
        Dim ft As New File_Config_Tools
        Dim sfa As New SFA_Tools
        Dim rundate As Date = main_form.g_d_run_date
        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        enum_items = System.Enum.GetNames((GetType(SFA_Tools.LOV_SIMPLE_REPORT)))

        Dim ti As New TI_Tools
        Dim item As String


        For Each item In enum_items
            Dim dt As New DataTable
            Dim last_date As Date

            Try
                Dim asset_enum As New File_Config_Tools.sync_date_val

                asset_enum = DirectCast([Enum].Parse(GetType(File_Config_Tools.sync_date_val), "UPDATE_LOV_" & item), File_Config_Tools.sync_date_val)

                last_date = ft.get_sync_date(asset_enum)

                main_form.TSStatusLabel1.Text = "Retriving Data from TI for: " & item.ToString
                main_form.TSProgressBar1.Value = 0

                Dim s_district As String = _sanitize_District(main_form.g_s_district)

                dt = ti.get_simple_report_lov(item.ToUpper, main_form.g_s_crew, s_district, main_form.g_b_crew_only, last_date.ToString)

                If dt.Rows.Count <> 0 Then
                    If dt.Rows(0).Item(0) <> "NO_DATA" Then

                        main_form.TSStatusLabel1.Text = "Updating: " & item.ToString
                        main_form.TSProgressBar1.Minimum = 0
                        main_form.TSProgressBar1.Maximum = dt.Rows.Count
                        main_form.TSProgressBar1.Value = 0

                        Select Case item
                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLHIGHWAYEA.ToString

                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLHIGHWAYEA)
                                Dim row As DataRow
                                For Each row In dt.Rows


                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLHIGHWAYEA)

                                    newrow.Item("fldHwy_EA") = row.Item("EA_NO")
                                    newrow.Item("fldHwy_NO") = System.Text.RegularExpressions.Regex.Replace(row.Item("LRM_KEY").ToString.Substring(0, 5), "00$", "")
                                    newrow.Item("fldMileageType") = row.Item("LRM_KEY").ToString.Substring(6, 2)
                                    newrow.Item("fldBeginMP") = Convert.ToDouble(row.Item("BEG_MP_NO").ToString)  ' work around for strange VB number converting issue
                                    newrow.Item("fldEndMP") = Convert.ToDouble(row.Item("END_MP_NO").ToString)
                                    newrow.Item("DESCRIPTION_updated: 12/13/2011") = row.Item("SECT_DESC")
                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLHIGHWAYEA.ToString)

                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "HIGHWAYEA", newrow.Item("fldHwy_NO"), newrow.Item("fldBeginMP"), e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)

                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()

                                Next
                                ft.write_sync_date(asset_enum, rundate)


                                ' This LOV is managed only in SFA now
                                'Case SFA_Tools.LOV_SIMPLE_REPORT.TBLDISTRICTS.ToString
                                '    sfa._remove_LOV_items(SFA_Tools.LOV.TBLDISTRICTS)
                                '    Dim row As DataRow
                                '    For Each row In dt.Rows
                                '        Dim newrow As DataRow
                                '        newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLDISTRICTS)

                                '        newrow.Item("fldDistrict") = _sanitize_District(row.Item("dist"))
                                '        newrow.Item("fldRegion") = row.Item("reg")

                                '        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLDISTRICTS.ToString)

                                '        main_form.TSProgressBar1.Increment(1)
                                '        Application.DoEvents()
                                '    Next
                                '    ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLHIGHWAYS.ToString


                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLHIGHWAYS)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLHIGHWAYS)

                                    newrow.Item("fldHighway") = row.Item("HWY")
                                    newrow.Item("fldHighwayName") = row.Item("HWY_NM")
                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLHIGHWAYS.ToString)


                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "HIGHWAYS", newrow.Item("fldHighway"), 0, e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)

                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLROUTESINTERSTATE.ToString


                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLROUTESINTERSTATE)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLROUTESINTERSTATE)

                                    newrow.Item("intrstt_rts") = row.Item("IS_RTE")

                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLROUTESINTERSTATE.ToString)
                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "intrstt_rts", newrow.Item("intrstt_rts"), 0, e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLROUTESUS.ToString()


                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLROUTESUS)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLROUTESUS)

                                    newrow.Item("us_rts") = row.Item("US_RTE_1")
                                    Try

                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLROUTESUS.ToString)

                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "ROUTESUS", newrow.Item("us_rts"), 0, e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)

                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLROUTESSTATE.ToString()


                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLROUTESSTATE)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLROUTESSTATE)

                                    newrow.Item("stt_rts") = row.Item("OR_RTE_1")

                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLROUTESSTATE.ToString)
                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "RTESTATE", newrow.Item("stt_rts"), 0, e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)

                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLMILEPOSTPREFIXES.ToString()

                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLMILEPOSTPREFIXES)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLMILEPOSTPREFIXES)

                                    newrow.Item("fldMPPrefix") = row.Item("MP_PREFIX")
                                    newrow.Item("fldDescription") = row.Item("MEANING")
                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLMILEPOSTPREFIXES.ToString)
                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "fldMPPrefix", newrow.Item("fldMPPrefix"), 0, e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                            Case SFA_Tools.LOV_SIMPLE_REPORT.TBLHWYLKUP.ToString()
                                sfa._remove_LOV_items(SFA_Tools.LOV.TBLHWYLKUP)
                                Dim row As DataRow
                                For Each row In dt.Rows
                                    Dim newrow As DataRow
                                    newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLHWYLKUP)

                                    newrow.Table.Columns.Remove("ID")

                                    Dim LRM As String = row.Item("LRM_KEY")

                                    newrow.Item("MileageType") = _Parse_LRM(LRM, LRM_Items.Mile_type)
                                    newrow.Item("RD_ID") = row.Item("hwy_no")
                                    newrow.Item("RDWY_ID") = _Parse_LRM(LRM, LRM_Items.Road_Dir_Increase)
                                    newrow.Item("BeginMP") = Convert.ToDouble(row.Item("beg_mp_no").ToString)
                                    newrow.Item("EndMP") = Convert.ToDouble(row.Item("end_mp_no").ToString)
                                    newrow.Item("District") = _sanitize_District(row.Item("DIST"), True)
                                    newrow.Item("Interstate_RTE") = row.Item("IS_RTE")
                                    newrow.Item("US_RTE") = row.Item("US_RTE_1")
                                    newrow.Item("OR_RTE") = row.Item("OR_RTE_1")
                                    Try
                                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLHWYLKUP.ToString)
                                    Catch e As Exception

                                        Dim mes As String = e.Message & vbCrLf & e.StackTrace
                                        Dim i As Int16

                                        If mes.Length < 1998 Then
                                            i = mes.Length
                                        Else
                                            i = 1997
                                        End If
                                        ti.write_xodot_signs_logging_exception("LOV_ERROR", "HIGHWAYEA", row.Item("LRM_KEY"), newrow.Item("BeginMP"), e.HResult, mes.Substring(0, i))

                                        add_sync_count(count_list.LOV_EXP)
                                    End Try

                                    add_sync_count(count_list.LOV_CNT)
                                    main_form.TSProgressBar1.Increment(1)
                                    Application.DoEvents()
                                Next
                                ft.write_sync_date(asset_enum, rundate)

                        End Select
                    End If
                End If

            Catch ex As Exception
                Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
                Dim i As Int16

                If mes.Length < 1998 Then
                    i = mes.Length
                Else
                    i = 1997
                End If

                'ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
                Throw  ' lets send this to the application events handler
            End Try
        Next
        main_form.TSStatusLabel1.Text = ""
        main_form.TSProgressBar1.Value = 0
        sfa.Dispose()
    End Sub

    Public Sub get_LOV_HUND(Optional dmydate As Date = #12:00:00 AM#)

        '''''''''''''''''''''''''''''''''''
        'Used For: Filling 100's LOV that are based on TI reports, only does changed roads
        '''''''''''''''''''''''''''''''''''

        Dim ft As New File_Config_Tools
        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        Dim icount As Integer = 0
        sfa.init()

        Dim dt As New DataTable
        Dim last_date As Date
        Dim ti As New TI_Tools

        Dim s_district As String = _sanitize_District(main_form.g_s_district)

        Try
            If dmydate = #12:00:00 AM# Then

                last_date = ft.get_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_TBLHWYGPSDATA)
            Else
                last_date = dmydate

            End If

            main_form.TSStatusLabel1.Text = "Retrieving GPS Milepoint Data (This Could Take Some Time): "
            main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Marquee

            dt = ti.get_simple_report_lov("TBLHWYGPSDATA", main_form.g_s_crew, s_district, main_form.g_b_crew_only, last_date)

            main_form.TSProgressBar1.ProgressBar.Style = ProgressBarStyle.Continuous

            If dt.Rows(0).Item(0) = "NO_DATA" Then
                'do nothing
            Else
                'need to get distint LRM so we can just replace the changed routes
                main_form.TSStatusLabel1.Text = "Updating GPS Milepoint Data: " & dt.Rows.Count & " Rows"

                main_form.TSProgressBar1.Minimum = 0
                main_form.TSProgressBar1.Maximum = dt.Rows.Count
                main_form.TSProgressBar1.Value = 0

                Dim dv As New DataView(dt)

                Dim lrm_dt As DataTable = dv.ToTable(True, "lrm_key")

                Dim lrm_row As DataRow

                For Each lrm_row In lrm_dt.Rows



                    Dim dt_rows As DataRow() = dt.Select("lrm_key='" & lrm_row.Item(0).ToString & "'")

                    sfa._remove_LOV_items(SFA_Tools.LOV.TBLHWYGPSDATA, dt_rows(0))

                    For Each row As DataRow In dt_rows

                        Dim newrow As DataRow
                        newrow = sfa._get_new_lov_row(SFA_Tools.LOV.TBLHWYGPSDATA)

                        newrow.Item("HWYNUMB") = row.Item("hwy_no")
                        newrow.Item("RDWY_ID") = row.Item("rdwy_id")
                        newrow.Item("MLGE_TYP") = row.Item("Mlge_typ")
                        newrow.Item("OVLP_CD") = row.Item("ovlp_cd")
                        newrow.Item("MP") = Convert.ToDouble(row.Item("MP").ToString)
                        newrow.Item("RDWY_TYP") = row.Item("rdwy_typ")
                        newrow.Item("LAT") = row.Item("lat")
                        newrow.Item("LONGTD") = row.Item("longtd")
                        newrow.Item("GIS_PRC_DT") = row.Item("extrct_prc_dt")
                        sfa._insert_general_row(newrow, SFA_Tools.LOV.TBLHWYGPSDATA.ToString)

                        add_sync_count(count_list.NUM100_CNT)

                        icount = icount + 1

                        main_form.TSProgressBar1.Value = icount
                        'main_form.Refresh()
                    Next
                Next

                ' Lets mass update the M, C,F from Ti to what SFA Expects
                sfa._update_GPS_RDWY_TYP()


                Dim rundate As Date = main_form.g_d_run_date

                ft.write_sync_date(File_Config_Tools.sync_date_val.UPDATE_LOV_TBLHWYGPSDATA, rundate)

                main_form.TSStatusLabel1.Text = ""
                main_form.TSProgressBar1.Value = 0



            End If

        Catch ex As Exception
            Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16

            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If
            add_sync_count(count_list.NUM100_EXP)
            'ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            Throw  ' lets send this to the application events handler
        End Try

        sfa.Dispose()

    End Sub

    Public Enum count_list
        '''''''''''''''''''''''''''''''''''
        'Used For: adding to the count list in ti.reports
        '''''''''''''''''''''''''''''''''''
        SFA_CNT
        SFA_EXP
        TI_CNT
        TI_EXP
        LOV_CNT
        LOV_EXP
        NUM100_CNT
        NUM100_EXP
    End Enum


    Public Sub add_sync_count(item As count_list)
        '''''''''''''''''''''''''''''''''''
        'Used For: adding to the count list in ti.reports
        '''''''''''''''''''''''''''''''''''

        Dim s As String = item.ToString.Replace("NUM", "")

        Try
            If IsDBNull(main_form.g_row_sync_count.Item(s)) Then main_form.g_row_sync_count.Item(s) = 0

            main_form.g_row_sync_count.Item(s) = main_form.g_row_sync_count.Item(s) + 1
        Catch ex As Exception
            If ex.HResult = -2147467261 Then
                'the main form was probally closeed and we shoudl abort
                Application.Exit()
            End If
        End Try


    End Sub

    Private Function _sanitize_dr(input As DataRow, Optional s_string_val As String = "-1") As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: removes nulls from a datarow
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As DataRow

        For i = 0 To input.Table.Columns.Count - 1 Step 1

            If IsDBNull(input.Item(i)) = True Then
                Select Case input.Table.Columns(i).DataType
                    Case System.Type.GetType("System.String")
                        input.Item(i) = s_string_val

                    Case System.Type.GetType("System.DateTime")
                    Case Else
                        input.Item(i) = -1
                End Select
            End If


        Next

        ret_val = input

        Return ret_val
    End Function



    Private Function _get_XSP_from_sfa_data(LRM As String, route_direction As String, facing_Direction As String, Side As String) As String
        '''''''''''''''''''''''''''''''''''
        'Used For:   Converting side of road to XSP, currently not in use
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = ""
        Dim ti As New TI_Tools
        Dim iGD As Integer = 0
        Dim iFD As Integer = 0

        Dim s_Gen_direction As String = ""

        ret_val = "ZZZZ"

        ' Not curently usign XSP in TI, so the following code is commented out

        'Select Case Side
        '    Case "C"
        '        ret_val = "CCCC"

        '    Case "O"
        '        ret_val = "OOOO"
        '    Case Else

        '        s_Gen_direction = ti.get_gen_dir_from_LRM(LRM)

        '        If s_Gen_direction = "-" Then
        '            ret_val = "NOT_FOUND"
        '        Else
        '            Select Case s_Gen_direction
        '                Case "N", "S"
        '                    iGD = 1
        '                Case Else
        '                    iGD = 2
        '            End Select

        '            Select Case facing_Direction
        '                Case "N", "S"
        '                    iFD = 1
        '                Case Else
        '                    iFD = 2
        '            End Select

        '            If iGD <> iFD Then
        '                ret_val = "R_DIR_MISS:" & s_Gen_direction
        '            Else

        '                Select Case route_direction
        '                    Case "I"
        '                        Select Case s_Gen_direction = facing_Direction
        '                            Case True
        '                                If Side = "R" Then ret_val = "ITRR"
        '                                If Side = "L" Then ret_val = "ITRL"
        '                            Case False
        '                                If Side = "R" Then ret_val = "ITRL"
        '                                If Side = "L" Then ret_val = "ITRR"
        '                        End Select

        '                    Case "D"
        '                        Select Case s_Gen_direction = facing_Direction
        '                            Case True
        '                                If Side = "R" Then ret_val = "DTRR"
        '                                If Side = "L" Then ret_val = "DTRL"
        '                            Case False
        '                                If Side = "R" Then ret_val = "DTRL"
        '                                If Side = "L" Then ret_val = "DTRR"
        '                        End Select
        '                    Case Else
        '                        ret_val = "R_DIR_MISS:" & s_Gen_direction
        '                End Select


        '            End If

        '        End If
        'End Select






        Return ret_val
    End Function

    Private Function _decode_Side_facing_from_XSP(s_xsp As String, s_lrm As String) As Dictionary(Of String, String)

        '''''''''''''''''''''''''''''''''''
        'Used For: 'Used to translate the side and  directiogn from TI for SFA use
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As New Dictionary(Of String, String)

        Dim ti As New TI_Tools

        Dim s_Gen_direction As String = ti.get_gen_dir_from_LRM(s_lrm)


        Select Case s_xsp
            Case "C", "O"
                ret_val.Add("DIRECTION", s_Gen_direction)
                ret_val.Add("SIDE", s_xsp)
            Case "ITRR"
                ret_val.Add("DIRECTION", s_Gen_direction)
                ret_val.Add("SIDE", "R")
            Case "ITRL"
                ret_val.Add("DIRECTION", s_Gen_direction)
                ret_val.Add("SIDE", "L")
            Case "DTRR"
                ret_val.Add("DIRECTION", s_Gen_direction)
                ret_val.Add("SIDE", "R")
            Case "DTRL"
                ret_val.Add("DIRECTION", s_Gen_direction)
                ret_val.Add("SIDE", "L")

        End Select


        Return ret_val
    End Function

    Private Function _get_rt_dist_from_TBL_HWY_LKUP(MileageType As String, RD_ID As String, RDWY_ID As String, mp As String) As Dictionary(Of String, String)

        '''''''''''''''''''''''''''''''''''
        'Used For: Getting the route and district from TBL_HWY_LKUP fro use when inserting an installation into SFA
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As New Dictionary(Of String, String)
        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"
        sfa.init()
        Dim r_row As DataRow

        r_row = sfa._get_rt_dist_from_TBL_HWY_LKUP(MileageType, RD_ID, RDWY_ID, mp)

        If IsDBNull(r_row.Item("RD_ID")) Then  ' it means the item wasn't found in tblHWYLKup
            ret_val.Add("DIST", "")
            ret_val.Add("I_RTE", "")
            ret_val.Add("US_RTE", "")
            ret_val.Add("OR_RTE", "")

        Else
            Dim temp As String
            If IsDBNull(r_row.Item("District")) Then temp = "" Else temp = r_row.Item("District")
            ret_val.Add("DIST", temp)
            If IsDBNull(r_row.Item("Interstate_RTE")) Then temp = "" Else temp = r_row.Item("Interstate_RTE")
            ret_val.Add("I_RTE", temp)
            If IsDBNull(r_row.Item("US_RTE")) Then temp = "" Else temp = r_row.Item("US_RTE")
            ret_val.Add("US_RTE", temp)
            If IsDBNull(r_row.Item("OR_RTE")) Then temp = "" Else temp = r_row.Item("OR_RTE")
            ret_val.Add("OR_RTE", temp)
        End If

        sfa.Dispose()
        Return ret_val
    End Function



    Private Enum cty_county
        '''''''''''''''''''''''''''''''''''
        'Used For: checking if a city or country comment is in the SFA descripition
        '''''''''''''''''''''''''''''''''''
        City
        County
    End Enum


    Private Function _Get_Cty_country_from_sfa_desc(check As cty_county, item As String) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: checking if a city or country comment is in the SFA descripition
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = "N"

        Select Case check
            Case cty_county.City
                If item.ToUpper.Contains("CITY LOCATION -") Then ret_val = "Y"
            Case cty_county.County
                If item.ToUpper.Contains("COUNTY LOCATION -") Then ret_val = "Y"
        End Select

        Return ret_val
    End Function

    Private Function _get_cty_country_from_ti(s_comments As String, s_city As String, s_county As String) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: Adding a city/ county description item when writting to SFA if the flags are set in TI
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As String = s_comments

        Select Case "Y"
            Case s_city
                If s_comments.ToUpper.Contains("CITY LOCATION -") Then
                    ret_val = s_comments
                Else
                    ret_val = "CITY LOCATION -" & s_comments
                End If
            Case s_county
                If s_comments.ToUpper.Contains("COUNTY LOCATION -") Then
                    ret_val = s_comments
                Else
                    ret_val = "COUNTY LOCATION -" & s_comments
                End If
            Case Else ' both are no, lets make sure the comments are clean

                ret_val = s_comments.Remove("City Location -")
                ret_val = ret_val.Remove("County Location -")
        End Select

        Return ret_val
    End Function

    Private Function _numChkDefault(input As Object) As Single
        '''''''''''''''''''''''''''''''''''
        'Used For: checking if a value is numeric, if not returning a -1 so it is not processed by the TI routines
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Single = -1

        If IsNumeric(input) Then
            ret_val = Convert.ToSingle(input)
        End If


        Return ret_val

    End Function

    Private Enum LRM_Items
        Mile_type
        Road_Dir_Increase
    End Enum


    Private Function _Parse_LRM(s_lrm As String, s_item As LRM_Items) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: Breaking an LRM into sub componets
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As String = ""
        Select Case s_item
            Case LRM_Items.Mile_type
                ret_val = s_lrm.Substring(6, 2)
            Case LRM_Items.Road_Dir_Increase
                ret_val = s_lrm.Substring(5, 1)
        End Select


        Return ret_val
    End Function

    Private Function _sanitize_District(s_district As String, Optional b_keepLetter As Boolean = False) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: removing letters and making sure there is a leading zero on single digit districts
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As String = s_district


        ret_val = System.Text.RegularExpressions.Regex.Replace(s_district, "[^0-9]", "").ToString.PadLeft(2, "0")

        If b_keepLetter = True Then
            ret_val = ret_val & System.Text.RegularExpressions.Regex.Replace(s_district, "[0-9]", "")
        End If


        Return ret_val
    End Function

End Class
