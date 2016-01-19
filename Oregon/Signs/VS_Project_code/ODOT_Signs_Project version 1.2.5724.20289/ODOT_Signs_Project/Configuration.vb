Imports System
Imports System.Xml
Public Class Configuration
    Private pbool_access_good As Boolean = False
    Private pbool_oracle_good As Boolean = False


    Public Class ArgumentConType
        Public connString As String
    End Class

    Private Sub Configuration_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        '''''''''''''''''''''''''''''''''''
        'Used For:Setting up text and retriving config information
        '''''''''''''''''''''''''''''''''''

        GroupBox2.Text = "Signs Access Databases Directory"
        GroupBox1.Text = "Transinfo Connection Information"


        lbl1.Text = "User Name"
        lbl2.Text = "Password"
        lbl3.Text = "DataSource"

        but_FO.Text = "..."
        but_cancel.Text = "Cancel"
        but_save.Text = "Save"
        but_test.Text = "Test"

        StatusStrip1.Items(0).Text = ""

        tb1.TabIndex = 1
        tb2.TabIndex = 2
        TB3.TabIndex = 3
        but_test.TabIndex = 4
        but_save.TabIndex = 5
        but_cancel.TabIndex = 6

        but_save.Enabled = False

        tb1.Enabled = True
        tb2.Enabled = True
        TB3.Enabled = True
        but_test.Enabled = True

        tb2.UseSystemPasswordChar = True

        '--------------------
        ' tb1.Text = "transinfo"
        'tb2.Text = "transinfo"
        'TB3.Text = "transinf"
        '----------testing


        sub_read_connection_info()

        'Lets see if the path for the Access DB's are correct

        Dim s_msg As String = fun_accessDB_found(tb_Apath.Text)
        If s_msg <> "YES" Then
            tb_Apath.Text = ""
        Else
            tb_Apath.Enabled = False
            pbool_access_good = True
            sub_enable_save()
        End If

        Me.TopMost = True
        Me.TopMost = False

    End Sub

    Private Sub but_cancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles but_cancel.Click
        Me.Close()

    End Sub

    Private Sub Configuration_FormClosed(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles MyBase.FormClosed
        Me.Dispose()
    End Sub

    Private Sub but_test_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles but_test.Click

        '''''''''''''''''''''''''''''''''''
        'Used For: Validating the database configrations
        '''''''''''''''''''''''''''''''''''

        Dim s_mbox As String = "The following Issues need to be resolved" & vbCrLf

        If tb1.Text = "" Then s_mbox = s_mbox & "Please Provide a Username " & vbCrLf
        If tb2.Text = "" Then s_mbox = s_mbox & "Please Provide a Password" & vbCrLf
        If TB3.Text = "" Then s_mbox = s_mbox & "Please Provide a Datasource" & vbCrLf

        If s_mbox <> "The following Issues need to be resolved" & vbCrLf Then
            MsgBox(s_mbox, MsgBoxStyle.Exclamation, "Connection Information is Missing")
            Exit Sub
        End If

        ' lets try to connect to the DB
        Try
            Dim _args As New ArgumentConType



            Dim s_DS As String = ""
            s_DS = s_DS & "User ID = " & tb1.Text & ";"
            s_DS = s_DS & "Password = " & tb2.Text & ";"
            s_DS = s_DS & "Data Source = " & TB3.Text & ";"

            _args.connString = s_DS

            BackgroundWorker1.WorkerSupportsCancellation = True
            BackgroundWorker1.RunWorkerAsync(_args)
            but_test.Enabled = False
            but_cancel.Enabled = False

            StatusStrip1.Items(0).Text = "Attemping to Connect. Please Wait. Double Click Here to Cancel"

        Catch ex As Oracle.DataAccess.Client.OracleException
            MsgBox(ex.Message, MsgBoxStyle.Exclamation)


        Catch ex As Exception
            MsgBox(ex.Message)

        End Try


    End Sub



    Private Sub but_save_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles but_save.Click
        sub_save_connection_info()

    End Sub

    Private Sub sub_save_connection_info()
        '''''''''''''''''''''''''''''''''''
        'Used For:  Saving the configration infromation
        '''''''''''''''''''''''''''''''''''

        Try
            If IO.File.Exists(main_form.g_s_config_xml) = True Then
                ' Since we are savign lets just delete this one and overwrite it
                IO.File.Delete(main_form.g_s_config_xml)
            End If

            Dim xmlsettings As New XmlWriterSettings
            xmlsettings.Indent = True

            Dim xmlConfigWriter As XmlWriter = XmlWriter.Create(main_form.g_s_config_xml, xmlsettings)
            Dim des As New Simple3Des(main_form.g_des_key)


            xmlConfigWriter.WriteStartDocument()
            xmlConfigWriter.WriteComment("Configuration Settings to Connect to Transinfo")

            xmlConfigWriter.WriteStartElement("Connection_Info")

            xmlConfigWriter.WriteStartElement("USERNAME")
            xmlConfigWriter.WriteString(des.EncryptData(tb1.Text))
            xmlConfigWriter.WriteEndElement()

            xmlConfigWriter.WriteStartElement("PASSWORD")
            xmlConfigWriter.WriteString(des.EncryptData(tb2.Text))
            xmlConfigWriter.WriteEndElement()

            xmlConfigWriter.WriteStartElement("DATASOURCE")
            xmlConfigWriter.WriteString(TB3.Text)
            xmlConfigWriter.WriteEndElement()

            xmlConfigWriter.WriteStartElement("ACCESSPATH")
            xmlConfigWriter.WriteString(tb_Apath.Text)
            xmlConfigWriter.WriteEndElement()

            xmlConfigWriter.WriteEndElement()
            xmlConfigWriter.WriteEndDocument()
            xmlConfigWriter.Close()

            Me.Close()

        Catch ex As IO.IOException
            MsgBox(ex.Message)


        Catch ex As Exception
            MsgBox(ex.Message)
        End Try


    End Sub

    Private Sub sub_read_connection_info()
        '''''''''''''''''''''''''''''''''''
        'Used For: Readign the config information
        '''''''''''''''''''''''''''''''''''
        Dim _xml_config_reader As XmlReader = Nothing

        Try
            If IO.File.Exists(main_form.g_s_config_xml) = False Then
                'Do nothing
                Exit Sub
            End If

            _xml_config_reader = New XmlTextReader(main_form.g_s_config_xml)
            Dim des As New Simple3Des(main_form.g_des_key)
            While (_xml_config_reader.Read())
                Dim _type = _xml_config_reader.NodeType

                If _type = XmlNodeType.Element Then


                    If _xml_config_reader.Name = "ACCESSPATH" Then
                        tb_Apath.Text = _xml_config_reader.ReadInnerXml.ToString
                    End If

                    If _xml_config_reader.Name = "DATASOURCE" Then
                        TB3.Text = _xml_config_reader.ReadInnerXml.ToString
                    End If

#If DEBUG Then          ' Odot asked for it to be removed from the dialog, but if Im on a debug build I would like to see it.
                    If My.User.Name.ToUpper.Contains("BENTLEY") Then



                        If _xml_config_reader.Name = "USERNAME" Then
                            tb1.Text = des.DecryptData(_xml_config_reader.ReadInnerXml.ToString)
                        End If

                        If _xml_config_reader.Name = "PASSWORD" Then
                            tb2.Text = des.DecryptData(_xml_config_reader.ReadInnerXml.ToString)
                        End If
                    End If
#End If


                    End If


            End While

            _xml_config_reader.Close()




        Catch ex As IO.IOException
            _xml_config_reader.Close()
            MsgBox(ex.Message)


        Catch ex As Exception
            _xml_config_reader.Close()
            MsgBox(My.Resources.strings.ERROR_CONFIG_SCREEN_DATA_LOAD, MsgBoxStyle.Critical, My.Resources.strings.ERROR_CONFIG_SCREEN_DATA_LOAD_TITLE)
        End Try
    End Sub

    Private Sub BackgroundWorker1_DoWork(ByVal sender As System.Object, ByVal e As System.ComponentModel.DoWorkEventArgs) Handles BackgroundWorker1.DoWork
        '''''''''''''''''''''''''''''''''''
        'Used For: connectiong to TI to not let the broker looked locked up
        '''''''''''''''''''''''''''''''''''

        Try
            Dim _a As ArgumentConType = e.Argument

            ' Allow us to skip the check and just write the config file
            If My.Computer.Keyboard.CtrlKeyDown = False And My.Computer.Keyboard.AltKeyDown = False Then



                TransInfo1.ConnectionString = _a.connString

                TransInfo1.Open()
                TransInfo1.Close()

                If BackgroundWorker1.CancellationPending = False Then
                    e.Result = 1
                Else
                    e.Cancel = True
                End If
            Else
                e.Result = 1
            End If
        Catch ex As IO.IOException
            If BackgroundWorker1.CancellationPending = False Then
                MsgBox(ex.Message)
                e.Result = 0
            Else
                e.Cancel = True
            End If
        Catch ex As Exception
            If BackgroundWorker1.CancellationPending = False Then
                MsgBox(ex.Message)
                e.Result = 0
            Else
                e.Cancel = True
            End If
        End Try


    End Sub

    Private Sub BackgroundWorker1_RunWorkerCompleted(ByVal sender As System.Object, ByVal e As System.ComponentModel.RunWorkerCompletedEventArgs) Handles BackgroundWorker1.RunWorkerCompleted

        '''''''''''''''''''''''''''''''''''
        'Used For: connectiong to TI to not let the broker looked locked up
        '''''''''''''''''''''''''''''''''''

        If e.Cancelled = False Then
            If e.Result = 1 Then


                StatusStrip1.Items(0).Text = "Connection Test Successful. Please save your selection."

                MsgBox("Connection Test Successful." & vbCrLf & " Please save your selection.", MsgBoxStyle.Information, "Success")

                'but_save.Enabled = True

                tb1.Enabled = False
                tb2.Enabled = False
                TB3.Enabled = False


                pbool_oracle_good = True

                Dim s_msg As String = fun_accessDB_found(tb_Apath.Text)
                If s_msg <> "YES" Then
                    tb_Apath.Text = ""
                Else
                    tb_Apath.Enabled = False
                    pbool_access_good = True
                    sub_enable_save()
                End If


            End If

            If e.Result = 0 Then

                StatusStrip1.Items(0).Text = "Connection Test Failed."
                but_test.Enabled = True
            End If
        End If

    End Sub

    Private Sub StatusStrip1_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StatusStrip1.DoubleClick
        BackgroundWorker1.CancelAsync()
        StatusStrip1.Items(0).Text = "Connection Test Canceled"
        but_test.Enabled = True
        but_cancel.Enabled = True

    End Sub

    Private Sub but_FO_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles but_FO.Click
        of_Access.CheckPathExists = True
        of_Access.CheckFileExists = False
        of_Access.Filter = "Signs Access DB(SignClient.mdb)|SignClient.mdb"
        of_Access.FileName = "SignClient.mdb"
        of_Access.ShowDialog()

        If of_Access.FileName = "SignClient.mdb" Then
            ' do nothing, because cancel probally clicked, I woudl expect a full path
        Else
            Dim s_msg As String = fun_accessDB_found(IO.Path.GetDirectoryName(of_Access.FileName) & "\")
            If s_msg <> "YES" Then
                MsgBox(s_msg, MsgBoxStyle.Exclamation, "Cannot find the file")
            Else
                tb_Apath.Text = IO.Path.GetDirectoryName(of_Access.FileName) & "\"
                tb_Apath.Enabled = False
                pbool_access_good = True
                sub_enable_save()
            End If

        End If




    End Sub

    Public Function fun_accessDB_found(ByVal s_path As String) As String
        fun_accessDB_found = ""

        Dim s_file_names(1) As String

        s_file_names(0) = "SignClient.mdb"
        s_file_names(1) = "signdata.mdb"

        For ii = 0 To s_file_names.GetUpperBound(0)
            If IO.File.Exists(s_path & s_file_names(ii)) = False Then
                fun_accessDB_found = "Unable to find the file:  " & s_path & s_file_names(ii)
                Exit Function
            End If
        Next ii

        fun_accessDB_found = "YES"

    End Function

    Sub sub_enable_save()

        If pbool_access_good And pbool_oracle_good Then

            tb_Apath.Enabled = False
            tb1.Enabled = False
            tb2.Enabled = False
            TB3.Enabled = False
            but_FO.Enabled = False
            but_test.Enabled = False
            but_cancel.Enabled = True
            but_test.Enabled = False
            but_save.Enabled = True

        End If
    End Sub


End Class