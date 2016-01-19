Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Types
Imports System
Imports System.Net
Imports System.Net.NetworkInformation
Imports System.Threading



Public Class main_form
    Public g_s_Config_Save_location As String
    Public g_s_Data_Save_location As String
    Public g_s_config_xml As String
    Public g_s_broker_data_mdb As String
    Public g_s_jetConnString As String = "Provider=Microsoft.Jet.OleDb.4.0;Data Source=" ' Basic JET connection string to use
    Public g_s_sfa_path As String
    Public g_s_crew As String
    Public g_s_district As String
    Public g_s_district_s As String 'In the format to use in TI
    Public g_b_crew_only As Boolean
    Public g_d_run_date As Date = Now
    Public g_log_file_name As String = "current_sync_logfile.txt"
    Public g_passphrase As String = ""
    Public g_row_sync_count As DataRow
    Public g_des_key As String
    Public g_b_quiet_mode As Boolean = False


    Public Enum task_states
        UNPROCESSED
        PROCESSING
        COMPLETED
    End Enum

    Private Sub main_form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AddHandler NetworkChange.NetworkAddressChanged, AddressOf NetworkChangedCallback


        Me.Text = "Signs to Transinfo Sync Broker Build: " & Application.ProductVersion



#If DEBUG Then
        Me.Text = Me.Text & " Debug Build "
#End If

        lbl_crew.Text = ""
        LV_Tasks.Columns(0).Text = ""


        ''''''''''''''''''''''''''''
        'Seting Quiet Mode

        Dim arguments As String() = Environment.GetCommandLineArgs()

        g_b_quiet_mode = arguments.Contains("/s")

        If g_b_quiet_mode = True Then Me.Text = Me.Text & " - Auto Sync Enabled"
        ''''''''''''''''''''''''''''




        'Me.TopMost = True
        'Me.Focus()

        ''''''''''''''''''''''''''''
        'Set Global varibales
        g_des_key = My.Computer.Name & g_s_jetConnString

        g_s_Config_Save_location = My.Application.Info.DirectoryPath & "\config\"
        g_s_Data_Save_location = My.Application.Info.DirectoryPath & "\config\"

        g_s_config_xml = g_s_Config_Save_location & "ora_connect.xml"
        g_s_broker_data_mdb = g_s_Data_Save_location & "broker_data.mdb"

        If My.Computer.Keyboard.ShiftKeyDown = True Then
            dia_passphase.ShowDialog(Me)

            If g_passphrase = "TI<>Broker1" Then
                Configuration.ShowDialog(Me)
            End If
        End If

        ''''''''''''''''''''''''''''''
        Dim ft As New File_Config_Tools

        'Write a blank process to the log file
        ft.Write_sync_log_Running(g_s_Data_Save_location)

        ''''''''''''''''''''''''''''''

        Dim fct As New File_Config_Tools
        If fct.init_xml_config(g_s_config_xml) <> 0 Then
            Dim ex As New Exception

            _sub_something_wrong_abort("ORA_CONNECT", ex)

            Application.ExitThread()
            'Me.Close()
            'Me.Dispose()
            Exit Sub

        End If
        g_s_sfa_path = fct.xml_Get_Config_Item("ACCESSPATH")

        '''''''''''''''''''''''

        ' If My.Computer.Keyboard.CtrlKeyDown And My.Computer.Keyboard.AltKeyDown Then
        'CB_Debug.Visible = True
        ' End If


#If DEBUG Then
        If My.User.Name.ToUpper.Contains("BENTLEY") Then GB_TEST.Visible = True
        If My.Computer.Keyboard.CtrlKeyDown And My.Computer.Keyboard.AltKeyDown Then GB_TEST.Visible = True
#End If


        '''''''''''''''''''''''''''''''''''
        'Disable Sync button until the task list is built
        but_sync.Enabled = False
        '''''''''''''''''''''''''''''''''''


        'Me.TopMost = False
        'Me.TopLevel = True
        '''''''''''''''''''''''''''''''''''
        'Connecting to TI
        Init_TI_Connection()
        '''''''''''''''''''''''''''''''''''
        'Me.TopMost = True
        'Me.TopMost = False
        'Me.TopLevel = True

        'Me.BringToFront()
        'Me.Refresh()

        '''''''''''''''''''''''''''''''''''
        'Connect that broker dates exist

        ft.make_new_sync_dates()

        '''''''''''''''''''''''''''''''''''

        '''''''''''''''''''''''''''''''''''
        'get the crew number

        Dim xml_config As New File_Config_Tools
        Dim sfa_class As New SFA_Tools
        If xml_config.init_xml_config(g_s_config_xml) <> 0 Then
            Dim ex As New Exception
            _sub_something_wrong_abort("SFA_FIND", ex)


            Exit Sub
        End If





        sfa_class.sfa_SignClient_path = xml_config.xml_Get_Config_Item("ACCESSPATH") & "SignClient.mdb"
        sfa_class.sfa_SignData_path = xml_config.xml_Get_Config_Item("ACCESSPATH") & "Signdata.mdb"

        ' Lets check for lock files and try to delete them incase Brokered exited unexpectedly when the SFA database was open
        Try
            FileIO.FileSystem.DeleteFile(xml_config.xml_Get_Config_Item("ACCESSPATH") & "SignClient.ldb")
            FileIO.FileSystem.DeleteFile(xml_config.xml_Get_Config_Item("ACCESSPATH") & "Signdata.ldb")
        Catch ex As Exception
            ' IF we cant delete it assume it is legitmaly open.
        End Try


        If sfa_class.init() <> 1 Then
            Dim ex As New Exception
            _sub_something_wrong_abort("SFA_FIND", ex)
            Exit Sub
        End If

        'lets check the major version number and make sure they match

        Dim sfa_broker_version As Integer = sfa_class._get_max_broker_version

        Select Case sfa_broker_version
            Case -998
                Dim ex As New Exception
                _sub_something_wrong_abort("SFA_VERSION_NOT_FOUND", ex)
            Case -999
                Dim ex As New Exception
                _sub_something_wrong_abort("SFA_VERSION_NOT_FOUND", ex)
            Case Else
                If (My.Application.Info.Version.Major) <> sfa_broker_version Then
                    Dim ex As New Exception
                    _sub_something_wrong_abort("SFA_VERSION_MISMATCH", ex)
                End If
        End Select




        g_s_crew = sfa_class._get_crew_number

        If g_s_crew = -2147467259 Then
            _sub_something_wrong_abort("SFA_INTERNAL_PATH")
        End If
        g_s_district = sfa_class._get_crew_district


        g_b_crew_only = _get_access_bool(sfa_class._get_crew_only)

        lbl_crew.Text = "District: " & g_s_district & ", Crew: " & g_s_crew

#If DEBUG Then

        Dim i As Integer

        i = g_s_sfa_path.Length

        If i > 75 Then i = 75



        lbl_crew.Text = lbl_crew.Text & " SFAPATH: ..." & g_s_sfa_path.Substring(g_s_sfa_path.Length - i, i)
#End If

        '''''''''''''''''''''''''''''''''''

        '''''''''''''''''''''''''''''''''''
        'Init the data row for sync_status
        Dim dt As New DataTable

        dt.Columns.Add("SFA_CNT", System.Type.GetType("System.Int32"))
        dt.Columns.Add("SFA_EXP", System.Type.GetType("System.Int32"))
        dt.Columns.Add("TI_CNT", System.Type.GetType("System.Int32"))
        dt.Columns.Add("TI_EXP", System.Type.GetType("System.Int32"))
        dt.Columns.Add("LOV_CNT", System.Type.GetType("System.Int32"))
        dt.Columns.Add("LOV_EXP", System.Type.GetType("System.Int32"))
        dt.Columns.Add("100_CNT", System.Type.GetType("System.Int32"))
        dt.Columns.Add("100_EXP", System.Type.GetType("System.Int32"))

        dt.Rows.Add()

        g_row_sync_count = dt.Rows(0)

        For i = 0 To g_row_sync_count.Table.Columns.Count - 1
            g_row_sync_count(i) = 0
        Next



        '''''''''''''''''''''''''''''''''''
        '''''''''''''''''''''''''''''''''''

        Me.TopMost = False
        Me.TopLevel = True
        Me.Focus()

        'get the tasks
        Init_Task_LV()
        '''''''''''''''''''''''''''''''''''
        '''''''''''''''''''''''''''''''''''
        'Init Test Button
        cb_test_populate_list()
        '''''''''''''''''''''''''''''''''''
        '''''''''''''''''''''''''''''''''''


        '****************************************
        '   Reenable the sync button
        '****************************************

        but_sync.Enabled = True

        Me.BringToFront()


        If g_b_quiet_mode = True Then but_sync_Click(Me, e)

    End Sub



    Private Sub Init_Task_LV()
        '''''''''''''''''''''''''''''''''''
        'Used For: Setting the item count of the tasks that are going to be preformed
        '''''''''''''''''''''''''''''''''''
        Dim pb1 As New ProgressBar
        Dim Images As New ImageList

        LV_Tasks.Columns.Clear()
        LV_Tasks.Items.Clear()

        LV_Tasks.Columns.Add("")
        LV_Tasks.Columns.Add("Item")
        LV_Tasks.Columns.Add("Changes")
        LV_Tasks.Columns.Add("Sync Status")



        Dim iwidth As Integer

        iwidth = LV_Tasks.Width


        LV_Tasks.Columns(0).Width = iwidth * 0.05
        LV_Tasks.Columns(1).Width = iwidth * 0.4
        LV_Tasks.Columns(2).Width = iwidth * 0.25
        LV_Tasks.Columns(3).Width = iwidth * 0.3

        Images.Images.Add("OFF", My.Resources.LightOff)
        Images.Images.Add("ON", My.Resources.PlaceLight)
        Images.Images.Add("DELETE", My.Resources.DeleteLightSetup)

        LV_Tasks.SmallImageList = Images

        '****************************************
        '   Lets Get the Tasks
        '****************************************

        sub_add_LV_Item(My.Resources.strings.TASK_POPULATING_TASKS, "---", task_states.UNPROCESSED)
        sub_change_LV_Item(My.Resources.strings.TASK_POPULATING_TASKS.ToString, task_states.PROCESSING)

        Dim ft As New File_Config_Tools

        _get_sfa_sync_tasks()
        Me.Refresh()

        Dim my_args As New ArgumentGetTask

        ' Getting TI Tasks might take awhile so threading it out
        my_args.TI_Connection = TI_Conn
        my_args.g_tasktype = ArgumentGetTask.taskType.TI_ASSET_TASKS
        my_args.g_date_string = ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNIN, True)
        my_args.g_crew = g_s_crew

        TSStatusLabel1.Text = "Getting Tasks From TransInfo, Please Wait."
        TSProgressBar1.Style = ProgressBarStyle.Marquee

        BW_TASKS.RunWorkerAsync(my_args)

        Me.Refresh()
        Me.Focus()
        Do While BW_TASKS.IsBusy

            Windows.Forms.Application.DoEvents()

        Loop
        Try
            TSStatusLabel1.Text = ""
            TSProgressBar1.Style = ProgressBarStyle.Continuous

            Me.Refresh()



            '_get_ti_asset_tasks(ft.get_sync_date(File_Config_Tools.sync_date_val.TI_EDIT_SNIN))


            sub_add_LV_Item(My.Resources.strings.TASK_LOV, "All", task_states.UNPROCESSED)

            'sub_change_LV_Item(My.Resources.strings.TASK_LOV, task_states.PROCESSING)


            sub_change_LV_Item(My.Resources.strings.TASK_POPULATING_TASKS.ToString, task_states.COMPLETED)
        Catch ex As Exception
            If ex.HResult = -2147467261 Then
            Else
                MsgBox(ex.Message)
            End If

        End Try
    End Sub

    Private Sub sub_add_LV_Item(ByVal s_item As String, ByVal S_Changes As String, ByVal s_status As task_states)
        '''''''''''''''''''''''''''''''''''
        'Used For: Adding tasks to the task lsit
        '''''''''''''''''''''''''''''''''''
        Dim s_items(2) As String
        s_items(0) = s_item
        s_items(1) = S_Changes
        s_items(2) = s_status.ToString

        LV_Tasks.Items.Add("").SubItems.AddRange(s_items)
        LV_Tasks.Items.Item(LV_Tasks.Items.Count - 1).ImageKey = "OFF"
    End Sub

    Private Sub sub_change_LV_Item(ByVal s_item As String, state As task_states)
        '''''''''''''''''''''''''''''''''''
        'Used For: Changing the status of a task in the task list
        '''''''''''''''''''''''''''''''''''

        Dim i_val As Integer = 0
        Dim i_image As Integer = 0

        'Dim myitem As ListViewItem
        Try
            i_val = LV_Tasks.FindItemWithText(s_item, True, 0).Index
            LV_Tasks.Items.Item(i_val).SubItems(3).Text = state.ToString
            Select Case state
                Case task_states.UNPROCESSED
                    i_image = 0
                Case task_states.PROCESSING
                    i_image = 2
                Case task_states.COMPLETED
                    i_image = 1
            End Select

            LV_Tasks.Items(i_val).ImageIndex = i_image
        Catch

        End Try


    End Sub



    Private Sub LV_Tasks_ItemSelectionChanged(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ListViewItemSelectionChangedEventArgs) Handles LV_Tasks.ItemSelectionChanged
        ''''''''''''''''''''''''''''''''''''
        'Used For: De selecting object in the task list box incase somehtign gets highlighted.
        '''''''''''''''''''''''''''''''''''
        If e.IsSelected Then e.Item.Selected = False
    End Sub




    Private Sub Init_TI_Connection()
        '''''''''''''''''''''''''''''''''''
        'Used For: Connecting to TI
        '''''''''''''''''''''''''''''''''''

        Dim file_class As New File_Config_Tools
        Dim s_ds As String = ""
        Dim s_username As String
        Dim s_password As String
        Dim s_datasource As String


        Try
            file_class.init_xml_config(g_s_config_xml)

            s_username = file_class.xml_Get_Config_Item("USERNAME", True)
            s_password = file_class.xml_Get_Config_Item("PASSWORD", True)
            s_datasource = file_class.xml_Get_Config_Item("DATASOURCE")

            s_ds = s_ds & "User ID = " & s_username & ";"
            s_ds = s_ds & "Password = " & s_password & ";"
            s_ds = s_ds & "Data Source = " & s_datasource & ";"

            TI_Conn.ConnectionString = s_ds

            'dialog_connecting.ShowDialog()

            'BW_ORA_CONNECT.RunWorkerAsync()

            Application.DoEvents()

            Application.DoEvents()
            Me.Refresh()

            Application.DoEvents()
            dialog_connecting.Refresh()


            Dim open_thread = New Thread(Sub() Threaded_TI_open(TI_Conn))

            open_thread.Start()
            dialog_connecting.StartPosition = FormStartPosition.CenterScreen
            dialog_connecting.Show(Me)
            Do While open_thread.ThreadState = ThreadState.Running
                Application.DoEvents()
            Loop
            dialog_connecting.Close()

            Dim ti As New TI_Tools

            If ti.get_version <> "PASSED" Then
                Dim ex As New Exception
                _sub_something_wrong_abort("TI_API", ex)

            End If



        Catch ex As Oracle.DataAccess.Client.OracleException
            BW_ORA_CONNECT.CancelAsync()

            _sub_something_wrong_abort("TI", ex)

            Application.Exit()

        Catch ex As Exception
            BW_ORA_CONNECT.CancelAsync()

            _sub_something_wrong_abort("TI", ex)
            Application.Exit()
        End Try

        BW_ORA_CONNECT.CancelAsync()




    End Sub
    Private Sub Threaded_TI_open(ByRef TI As Oracle.DataAccess.Client.OracleConnection)
        '''''''''''''''''''''''''''''''''''
        'Used For: Long running gets in TI so that the message pump can process and the broker doesnt look to be locked up.
        '''''''''''''''''''''''''''''''''''
        TI.Open()
    End Sub


    Private Sub cb_test_populate_list()
        '''''''''''''''''''''''''''''''''''
        'Used For: Testing purposes
        '''''''''''''''''''''''''''''''''''

        cb_test.Items.Add("INST_NEW")
        cb_test.Items.Add("INST_EDIT")
        cb_test.Items.Add("INST_FROM_TI")
        cb_test.Items.Add("ASSET_TASKS_FROM_TI")
        cb_test.Items.Add("ASSE_TASK_UPDATE")
        cb_test.Items.Add("Get_LOV_DOMAINS()")
        cb_test.Items.Add("Get_LOV_ASSETS()")
        cb_test.Items.Add("get_report_lovs()")
        cb_test.Items.Add("get_current_sync_log()")
        cb_test.Items.Add("get_mem_location_from_ne_id")
        cb_test.Items.Add("process_TI_edited_Installs()")
        cb_test.Items.Add("GET_CHANGED_SIGN_ASSET()")
        cb_test.Items.Add("unhandled")
        cb_test.Items.Add("GPS_RDWY_TYP_UPDATE")
        cb_test.Items.Add("_get_inst_id_from_NE_ID()")
        cb_test.Items.Add("get_report_HUND()")
        cb_test.SelectedIndex = cb_test.Items.Count - 1
    End Sub

    Private Sub But_test_Click(sender As Object, e As EventArgs) Handles But_test.Click
        '''''''''''''''''''''''''''''''''''
        'Used For: Testing Purposes (button) not exposed to enduser,  Unless on a debug build and  on the bentley domain
        '''''''''''''''''''''''''''''''''''

        Select Case cb_test.Text
            Case "INST_NEW"
                Dim bp As New Broker_Processing

                bp.process_sfa_new_installs()
                MsgBox("done")
            Case "INST_EDIT"
                Dim bp As New Broker_Processing

                bp.process_sfa_edited_installs(Broker_Processing.edit_tables.SUPPORTS)
                bp.process_sfa_edited_installs(Broker_Processing.edit_tables.STANDARD)
                bp.process_sfa_edited_installs(Broker_Processing.edit_tables.CUSTOM)
                bp.process_sfa_edited_installs(Broker_Processing.edit_tables.LOG)
                MsgBox("done")
            Case "INST_FROM_TI"
                Dim ti As New TI_Tools
                Dim dt As DataTable
                dt = ti.get_changed_sign_asset("1040", "01/JAN/2014", "SNIN")

                MsgBox(dt.Rows.Count)
            Case "ASSET_TASKS_FROM_TI"
                _get_ti_asset_tasks("01-JAN-2014", g_s_crew, TI_Conn)
            Case "ASSE_TASK_UPDATE"
                sub_change_LV_Item("SNIN", task_states.PROCESSING)
            Case "Get_LOV_DOMAINS()"
                Dim bp As New Broker_Processing
                bp.Get_LOV_DOMAINS()
            Case "Get_LOV_ASSETS()"
                Dim bp As New Broker_Processing
                bp.Get_LOV_ASSETS()
            Case "get_report_lovs()"
                Dim bp As New Broker_Processing
                bp.get_LOV_REPORTS_SCHEMA()
                bp.get_LOV_HUND()
                MsgBox("Completed")
            Case "get_current_sync_log()"
                Dim fc As New File_Config_Tools
                fc.get_current_sync_log()
            Case "get_mem_location_from_ne_id"
                Dim loc_table As DataTable
                Dim ti As New TI_Tools

                loc_table = ti.get_mem_location_from_ne_id(7850201)

                MsgBox(loc_table.Rows(0).Item(0))
            Case "process_TI_edited_Installs()"
                Dim bp As New Broker_Processing
                Dim al As ArrayList
                al = bp.process_TI_edited_Installs()
            Case "GET_CHANGED_SIGN_ASSET()"
                Dim ti As New TI_Tools

                ti.get_changed_sign_asset("1040", "01-JAN-1901", "SNIN")
                ti.get_changed_sign_asset("1040", "01-JAN-1901", "SNSN")
                ti.get_changed_sign_asset("1040", "01-JAN-1901", "SNSU")
                ti.get_changed_sign_asset("1040", "01-JAN-1901", "SNML")

            Case "unhandled"
                Dim s_test As String
                Dim r As DataRow
                'r.Table.NewRow()

                s_test = r.Item(0)
            Case "GPS_RDWY_TYP_UPDATE"
                Dim sfa As New SFA_Tools

                sfa.sfa_SignClient_path = g_s_sfa_path & "SignClient.mdb"
                sfa.sfa_SignData_path = g_s_sfa_path & "Signdata.mdb"
                sfa.init()
                sfa._update_GPS_RDWY_TYP()
                sfa.Dispose()

            Case "_get_inst_id_from_NE_ID()"
                Dim sfa As New SFA_Tools
                sfa.sfa_SignClient_path = g_s_sfa_path & "SignClient.mdb"
                sfa.sfa_SignData_path = g_s_sfa_path & "Signdata.mdb"
                sfa.init()
                MsgBox(sfa._get_inst_id_from_NE_ID(InputBox("NEID", "8909343")))
                sfa.Dispose()
            Case "get_report_HUND()"
                Dim bp As New Broker_Processing
                bp.get_LOV_HUND(Convert.ToDateTime("01-JAN-1990"))
                MsgBox("Completed")
        End Select
    End Sub



    Private Sub BW_ORA_CONNECT_DoWork(sender As Object, e As System.ComponentModel.DoWorkEventArgs) Handles BW_ORA_CONNECT.DoWork

        '''''''''''''''''''''''''''''''''''
        'Used For: putting up a connection dialog while connecting to TI
        '''''''''''''''''''''''''''''''''''

        dialog_connecting.Show()


        While BW_ORA_CONNECT.CancellationPending = False
            Application.DoEvents()
            dialog_connecting.Update()
            dialog_connecting.BringToFront()
        End While

        dialog_connecting.Close()

    End Sub


    Private Sub but_sync_Click(sender As Object, e As EventArgs) Handles but_sync.Click

        '''''''''''''''''''''''''''''''''''
        'Used For: Running through the routines related to syncing the data
        '''''''''''''''''''''''''''''''''''

        Dim bp As New Broker_Processing
        Dim ti As New TI_Tools
        Dim ft As New File_Config_Tools

        but_sync.Enabled = False

        'SFA to TI
        sub_change_LV_Item(My.Resources.strings.TASK_SFA_ITEMS, task_states.PROCESSING)

        bp.process_sfa_new_installs()

        ' we need a list of items that still remain in the new table so that when the bp.process_sfa_new_installs()
        ' is ran again the error messages do not get duplicated up

        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim int_still_new As ArrayList = sfa._get_new_install_list

        sfa.Dispose()

        'continue with the sync

        bp.process_sfa_edited_installs(Broker_Processing.edit_tables.INSTALLATION)
        ' rerun new incase the edit process wrote to the newinstall table
        '
        bp.process_sfa_new_installs(int_still_new)


        bp.process_sfa_edited_installs(Broker_Processing.edit_tables.STANDARD)
        bp.process_sfa_edited_installs(Broker_Processing.edit_tables.CUSTOM)
        bp.process_sfa_edited_installs(Broker_Processing.edit_tables.SUPPORTS)
        bp.process_sfa_edited_installs(Broker_Processing.edit_tables.LOG)

        'Lets change the sync dates even though the program doesnt really use them

        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_NEW_INSTALL, g_d_run_date)
        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_EDIT_HISTORY, g_d_run_date)
        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_EDIT_INSTALL, g_d_run_date)
        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_EDIT_STANDARD, g_d_run_date)
        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_EDIT_CUSTOM, g_d_run_date)
        ft.write_sync_date(File_Config_Tools.sync_date_val.SFA_EDIT_SUPPORTS, g_d_run_date)


        ' continuing on

        sub_change_LV_Item(My.Resources.strings.TASK_SFA_ITEMS, task_states.COMPLETED)

        'TI to SFA

        sub_change_LV_Item(My.Resources.strings.TASK_TI_ITEMS, task_states.PROCESSING)

        Me.Refresh()

        Dim skip_array As ArrayList
        skip_array = bp.process_TI_edited_Installs()

#If DEBUG Then
        'MsgBox("clearing the skip array for testing", MsgBoxStyle.Information, "Debug Message")
        'skip_array.Clear()
#End If

        bp.process_TI_edited_signs(skip_array)

        bp.process_TI_edited_supports(skip_array)
        bp.process_TI_edited_Maint_Log(skip_array)

        sub_change_LV_Item(My.Resources.strings.TASK_TI_ITEMS, task_states.COMPLETED)


        'UPDATE LISTS
        sub_change_LV_Item(My.Resources.strings.TASK_LOV, task_states.PROCESSING)

        bp.Get_LOV_DOMAINS()
        bp.Get_LOV_ASSETS()
        bp.get_LOV_REPORTS_SCHEMA()
        bp.get_LOV_HUND()

        sub_change_LV_Item(My.Resources.strings.TASK_LOV , task_states.COMPLETED )

        ti.write_xodot_signs_logging_status(g_row_sync_count.Item("SFA_CNT"), g_row_sync_count.Item("SFA_EXP"), g_row_sync_count.Item("TI_CNT"), g_row_sync_count.Item("TI_EXP"), g_row_sync_count.Item("LOV_CNT"), g_row_sync_count.Item("LOV_EXP"), g_row_sync_count.Item("100_CNT"), g_row_sync_count.Item("100_EXP"))



        ft.Write_sync_log(My.Application.Info.DirectoryPath)

        but_sync.Enabled = False
        but_sync.Text = "Sync Completed"
        TSStatusLabel1.Text = "Sync Completed"

        If g_b_quiet_mode = False Then MsgBox(My.Resources.strings.INFO_SYNC_COMPLETED, MsgBoxStyle.Information)

        

        Me.Dispose()
        Me.Close()

    End Sub

    Private Function _get_ti_asset_tasks(s_date As String, s_crew As String, TI_C As Oracle.DataAccess.Client.OracleConnection) As XODOT_SIGNS_TASK_LIST
        '''''''''''''''''''''''''''''''''''
        'Used For: getting the number of objects to sync from TI, not LOV's
        '''''''''''''''''''''''''''''''''''

        Dim ti As New TI_Tools
        Dim tasklist As XODOT_SIGNS_TASK_LIST
        'Dim taskrow As XODOT_SIGNS_TASK_LIST_ROW

        tasklist = ti.get_task_list_assets(s_date, s_crew, TI_C)
        Return tasklist

    End Function

    Private Sub _get_sfa_sync_tasks()
        '''''''''''''''''''''''''''''''''''
        'Used For: getting the number of objects to sync from SFA, not LOV's
        '''''''''''''''''''''''''''''''''''
        Dim sfa As New SFA_Tools
        sfa.sfa_SignClient_path = g_s_sfa_path & "SignClient.mdb"
        sfa.sfa_SignData_path = g_s_sfa_path & "Signdata.mdb"

        sfa.init()

        Dim int As Integer

        int = sfa._get_total_sfa_sync_count

        'If int <> 0 Then
        sub_add_LV_Item(My.Resources.strings.TASK_SFA_ITEMS, int, task_states.UNPROCESSED)
        'End If

    End Sub

    Public Sub _sub_something_wrong_abort(s_item As String, Optional ex As Exception = Nothing)

        '''''''''''''''''''''''''''''''''''
        'Used For: Displaying known fatal errors to the user and exiting the program
        '''''''''''''''''''''''''''''''''''

        Dim s_mes As String
        Dim s_err As String = ""

        If BW_ORA_CONNECT.IsBusy = True Then
            BW_ORA_CONNECT.CancelAsync()

            Do While BW_ORA_CONNECT.IsBusy = True
                Application.DoEvents()
            Loop

        End If


        Select Case s_item
            Case "TI"
                s_mes = My.Resources.strings.TI_CONNECT_ERROR & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = ex.Message.ToString
            Case "TI_API"
                s_mes = My.Resources.strings.ERROR_TI_API & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_TI_API_EX
            Case "ORA_CONNECT"
                s_mes = My.Resources.strings.ERROR_ORA_CONFIG & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_ORA_CONFIG_EX
            Case "SFA_FIND"
                s_mes = My.Resources.strings.ERROR_SFA_NOT_FOUND & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_SFA_NOT_FOUND_EX
            Case "SFA_INTERNAL_PATH"
                s_mes = My.Resources.strings.ERROR_SFA_NOT_INI & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_SFA_NOT_INI_EX
            Case "SFA_VERSION_NOT_FOUND"
                s_mes = My.Resources.strings.ERROR_SFA_VERSION_NOT_FOUND & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_SFA_VERSION_NOT_FOUND_EX
            Case "SFA_VERSION_MISMATCH"
                s_mes = My.Resources.strings.ERROR_SFA_VERSION_NOT_FOUND & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = My.Resources.strings.ERROR_SFA_VERSION_NOT_FOUND_EX
            Case "BAD_USER"
                s_mes = My.Resources.strings.TI_BAD_USER & My.Resources.strings.CONTACT_ADMIN & vbCrLf & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = "ORA-20000: HIG-0182: User not instantiated correctly."
            Case "CONFIG_LOAD"
                s_mes = My.Resources.strings.ERROR_MAIN_CONFIG_DATA_LOAD
                s_err = "Technical information: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace
            Case Else
                s_mes = My.Resources.strings.UNHANDLED & My.Resources.strings.CONTACT_ADMIN & vbCrLf & My.Resources.strings.ERROR_DETAILS
                s_err = "Technical information: " & ex.Message.ToString & vbCrLf & vbCrLf & ex.StackTrace
        End Select

        dialog_abort_program.g_s_issue = s_mes
        dialog_abort_program.g_s_error = s_err

        dialog_abort_program.ShowDialog()
        Environment.Exit(exitCode:=0)
        Application.Exit()

    End Sub



    Private Sub BW_TASKS_RunWorkerCompleted(sender As Object, e As System.ComponentModel.RunWorkerCompletedEventArgs) Handles BW_TASKS.RunWorkerCompleted

        '''''''''''''''''''''''''''''''''''
        'Used For: Background threading finished when retriving the tasks (used b/c a large number of tasks form TI could take awhile)
        '''''''''''''''''''''''''''''''''''
        Try
            Dim tasklist As XODOT_SIGNS_TASK_LIST = e.Result
            Dim taskrow As XODOT_SIGNS_TASK_LIST_ROW

            'tasklist = ti.get_task_list_assets(s_date, TI_C)

            Dim int As Integer = 0

            If tasklist.Value.Count > 0 Then
                For Each taskrow In tasklist.Value
                    If taskrow.ASSET.ToString <> "-ERR" Then
                        int = int + taskrow.CNT
                    End If


                Next

                sub_add_LV_Item(My.Resources.strings.TASK_TI_ITEMS, int.ToString, task_states.UNPROCESSED)
            End If
        Catch ex As OracleException
            ' Assuming that if I get an exception here there is an issue and I should not continue
            ' going to catch it in the genral appevents area
            Throw
        Catch ex As Exception
            Throw
        End Try

    End Sub

    Private Sub BW_TASKS_DoWork(sender As Object, e As System.ComponentModel.DoWorkEventArgs) Handles BW_TASKS.DoWork
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting the tasks from TI
        '''''''''''''''''''''''''''''''''''
        Dim my_args As ArgumentGetTask = e.Argument

        Select Case my_args.g_tasktype
            Case ArgumentGetTask.taskType.TI_ASSET_TASKS
                my_args.tasklist_results = _get_ti_asset_tasks(my_args.g_date_string, my_args.g_crew, my_args.TI_Connection)

                e.Result = my_args.tasklist_results
        End Select



    End Sub

    Private Function _get_access_bool(input As Integer) As Boolean
        '''''''''''''''''''''''''''''''''''
        'Used For:  COnverting a value in access to a VB boolean
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Boolean = False

        Select Case input
            Case -1
                ret_val = True
            Case Else
                ret_val = False
        End Select

        Return ret_val
    End Function


    Private Sub main_form_FormClosing(sender As Object, e As FormClosingEventArgs) Handles MyBase.FormClosing
        Application.Exit()
        Environment.Exit(1)
    End Sub

    Private Shared Sub NetworkChangedCallback(ByVal sender As Object, ByVal e As EventArgs)


        Select Case main_form.TI_Conn.State
            Case ConnectionState.Closed, ConnectionState.Broken
                dialog_abort_program.g_s_issue = "Connection Lost Unable to Continue"
                dialog_abort_program.g_s_title = "Connection Lost Unable to Continue"
                dialog_abort_program.g_s_error = My.Resources.strings.ERROR_ORA_03113

                dialog_abort_program.ShowDialog()

                Application.Exit()
                Environment.Exit(3113)

        End Select



    End Sub
End Class




Public Class ArgumentGetTask
    '''''''''''''''''''''''''''''''''''
    'Used For: the task retrieval back ground worker, the aurgument list
    '''''''''''''''''''''''''''''''''''
    Public Enum taskType
        TI_ASSET_TASKS

    End Enum

    Public g_tasktype As taskType
    Public g_date_string As String
    Public g_crew As String
    Public TI_Connection As Oracle.DataAccess.Client.OracleConnection
    Public tasklist_results As XODOT_SIGNS_TASK_LIST

End Class

