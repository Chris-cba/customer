Imports System.Xml

Public Class File_Config_Tools
    Private gs_xml_path As String = ""


    Public Enum sync_date_val
        SFA_NEW_INSTALL
        SFA_EDIT_INSTALL
        SFA_EDIT_HISTORY
        SFA_EDIT_SUPPORTS
        SFA_EDIT_CUSTOM
        SFA_EDIT_STANDARD
        TI_EDIT_SNIN
        TI_EDIT_SNSN
        TI_EDIT_SNSU
        TI_EDIT_SNML
        UPDATE_LOV_SNCS
        UPDATE_LOV_SIGN
        UPDATE_LOV_SUPP
        UPDATE_LOV_SNAC
        UPDATE_LOV_SNGR
        UPDATE_LOV_TBLHIGHWAYEA
        UPDATE_LOV_TBLHIGHWAYS
        'UPDATE_LOV_TBLDISTRICTS
        UPDATE_LOV_TBLROUTESINTERSTATE
        UPDATE_LOV_TBLROUTESUS
        UPDATE_LOV_TBLROUTESSTATE
        UPDATE_LOV_TBLHWYGPSDATA
        UPDATE_LOV_TBLMILEPOSTPREFIXES
        UPDATE_LOV_TBLHWYLKUP


    End Enum

   



    Public Function init_xml_config(ByVal s_path_to_xml) As Integer
        If IO.File.Exists(s_path_to_xml) Then
            gs_xml_path = s_path_to_xml
            Return 0
        Else
            Return 1 ' file does not exist
        End If
    End Function

    Public Function xml_Get_Config_Item(ByVal s_item As String, Optional encrypted As Boolean = False) As String
        Dim s As String = "NOT_FOUND"
        Try

            Dim _xml_config_reader As XmlReader = New XmlTextReader(gs_xml_path)

            While (_xml_config_reader.Read())
                Dim _type = _xml_config_reader.NodeType
                If _type = XmlNodeType.Element Then
                    If _xml_config_reader.Name.ToUpper = s_item.ToUpper Then
                        s = _xml_config_reader.ReadInnerXml.ToString
                        Exit While
                    End If
                End If
            End While

            _xml_config_reader.Close()

            If encrypted = True Then
                Dim crypto As New Simple3Des(main_form.g_des_key)

                s = crypto.DecryptData(s)

            End If

            Return s



        Catch ex As IO.IOException
            MsgBox(ex.Message)
            Return s

        Catch ex As Exception
            main_form._sub_something_wrong_abort("CONFIG_LOAD", ex)

            Return s
        End Try
    End Function

    Public Sub make_new_sync_dates()
        Dim db As New OleDb.OleDbConnection
        Try
            db.ConnectionString = main_form.g_s_jetConnString & main_form.g_s_broker_data_mdb
            db.Open()

            Dim _sql As String = "select item from sync_dates"

            Dim mdbSupportAdaptor As New OleDb.OleDbDataAdapter(_sql, db)
            Dim mdbSupportDT As New DataTable("dates")
            mdbSupportAdaptor.Fill(mdbSupportDT)
            Dim col(0) As DataColumn
            col(0) = mdbSupportDT.Columns(0)

            mdbSupportDT.PrimaryKey = col


            Dim enum_items As Array
            enum_items = System.Enum.GetNames(GetType(sync_date_val))

            Dim item As String
            For Each item In enum_items
                'MsgBox(mdbSupportDT.Select("item='" & item & "'").Count())

                If mdbSupportDT.Select("item='" & item & "'").Count() = 0 Then
                    Dim _insert As String

                    _insert = "insert into sync_dates (item, last_sync_date) values (" & _quoted_string(item) & ", " & _quoted_string("01-JAN-1901") & ")"
                    Dim cmd As New OleDb.OleDbCommand(_insert, db)
                    cmd.ExecuteNonQuery()

                End If
            Next



        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Information)

        End Try

        db.Dispose()

    End Sub

    Public Function get_sync_date(sync_date_item As sync_date_val, Optional b_full_date As Boolean = False) As String
        Dim ret_val As String = "N/A"
        Dim db As New OleDb.OleDbConnection
        Try
            db.ConnectionString = main_form.g_s_jetConnString & main_form.g_s_broker_data_mdb
            db.Open()

            Dim _sql As String = "select item, last_sync_date from sync_dates "
            Dim _where As String = " where item = " & _quoted_string(sync_date_item.ToString)

            Dim mdbSupportAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, db)
            Dim mdbSupportDT As New DataTable("dates")
            mdbSupportAdaptor.Fill(mdbSupportDT)

            Dim d_date As Date = mdbSupportDT.Rows(0).Item("last_sync_date")

            If b_full_date = True Then
                ret_val = d_date.ToString
            Else
                ret_val = d_date.ToString("dd-MMM-yyyy")
            End If
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Information)

        End Try

        db.Dispose()


        Return ret_val
    End Function

    Public Function write_sync_date(sync_date_item As sync_date_val, s_date As Date) As Boolean
        Dim ret_val As Boolean = False
        Dim db As New OleDb.OleDbConnection
        Try
            db.ConnectionString = main_form.g_s_jetConnString & main_form.g_s_broker_data_mdb
            db.Open()

            Dim _sql As String
            Dim _where As String
            Dim iret As Integer
            _sql = "update sync_dates set last_sync_date = " & "#" & main_form.g_d_run_date & "# "
            _where = " where item = " & _quoted_string(sync_date_item.ToString)
            Dim cmd As New OleDb.OleDbCommand(_sql & _where, db)

            iret = cmd.ExecuteNonQuery()

        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Information)

        End Try

        db.Dispose()
        Return ret_val
    End Function

    Public Function Write_mdb_sync_log(s_internal_message As String, s_external_message As String) As Boolean
        Dim ret_val As Boolean = False
        Dim db As New OleDb.OleDbConnection
        Try
            db.ConnectionString = main_form.g_s_jetConnString & main_form.g_s_broker_data_mdb
            db.Open()
            Dim _sql As String
            Dim _where As String = ""
            Dim iret As Integer



            _sql = "Insert into sync_log (runtimestamp,internal_message,external_message) values ( " & "#" & main_form.g_d_run_date & "# "
            _sql = _sql & " ," & "@1" '_quoted_string(s_internal_message)
            _sql = _sql & " ," & "@2" '_quoted_string(s_external_message)
            _sql = _sql & ") "


            Dim cmd As New OleDb.OleDbCommand(_sql & _where, db)

            cmd.Parameters.AddWithValue("1", s_internal_message)
            cmd.Parameters.AddWithValue("2", s_external_message)

            'cmd.Parameters(0).Value = s_internal_message
            'cmd.Parameters(1).Value = s_external_message

            iret = cmd.ExecuteNonQuery()
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Information)

        End Try

        db.Dispose()
        Return ret_val
    End Function

    Public Function get_current_sync_log() As DataTable
        Dim ret_val As DataTable

        Dim db As New OleDb.OleDbConnection
        Try
            db.ConnectionString = main_form.g_s_jetConnString & main_form.g_s_broker_data_mdb
            db.Open()

            Dim _sql As String = "select runtimestamp, internal_message, external_message from sync_log "
            Dim _where As String = " where runtimestamp = " & "#" & main_form.g_d_run_date & "# "

            Dim mdbSupportAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, db)
            Dim mdbSupportDT As New DataTable("log")
            mdbSupportAdaptor.Fill(mdbSupportDT)



            ret_val = mdbSupportDT
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Information)
            ret_val = New DataTable
        End Try






        Return ret_val

    End Function

    Public Function Write_sync_log(s_directory As String) As Boolean
        Dim ret_val As Boolean = False

        Dim s_logfile As String = main_form.g_s_Data_Save_location & main_form.g_log_file_name

        Dim dt As DataTable

        If IO.File.Exists(s_logfile) Then
            IO.File.Delete(s_logfile)
        End If

        dt = get_current_sync_log()
        Dim writer As New IO.StreamWriter(s_logfile)

        writer.WriteLine("*********************** SYNC PROCESS BEGIN LOG **********************") '
        writer.WriteLine("Process started: " & vbTab & main_form.g_d_run_date)
        If dt.Rows.Count > 0 Then
            Dim row As DataRow


            For Each row In dt.Rows
                Dim sline As String
                sline = row.Item("runtimestamp") & vbTab & row.Item("external_message")
                writer.WriteLine(sline)
            Next


            ret_val = True
        End If

        writer.WriteLine("Process Completed: " & vbTab & Now)
        writer.WriteLine("*********************** SYNC PROCESS END **********************")

        writer.Close()
        writer.Dispose()
        Return ret_val
    End Function

    Public Function Write_sync_log_Running(s_directory As String) As Boolean
        Dim ret_val As Boolean = False

        Dim s_logfile As String = main_form.g_s_Data_Save_location & main_form.g_log_file_name



        If IO.File.Exists(s_logfile) Then
            IO.File.Delete(s_logfile)
        End If

        Dim writer As New IO.StreamWriter(s_logfile)

        writer.WriteLine("*********************** SYNC PROCESS IN PROGRESS **********************") '
        writer.WriteLine("Process started: " & vbTab & main_form.g_d_run_date)
        writer.WriteLine("*********************** SYNC PROCESS IN PROGRESS **********************") '
        writer.WriteLine("") '
        writer.WriteLine("If you are seeing this message Sign Broker did not successfully complete the syncing process.")
        writer.WriteLine("If no errors occurred try rerunning the Sign Broker.  If the problem continues please contact a systems Administrator.") '

        writer.Close()
        writer.Dispose()
        Return ret_val
    End Function

    Private Function _quoted_string(s As String) As String
        Dim out As String = Chr(34) & s & Chr(34)

        Return out
    End Function

End Class
