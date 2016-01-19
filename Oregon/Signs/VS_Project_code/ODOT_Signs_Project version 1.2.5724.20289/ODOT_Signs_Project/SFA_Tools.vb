Imports System.Data

Public Class SFA_Tools : Implements IDisposable
    Private pg_init_error As Exception
    Private pg_s_sfa_SignClient_path As String = ""
    Private pg_s_sfa_SignData_path As String = ""
    Private pg_Conn_sfa_Client As New OleDb.OleDbConnection
    Private pg_Conn_sfa_Data As New OleDb.OleDbConnection

    Public Enum edit_items
        '''''''''''''''''''''''''''''''''''
        'Used For: looping through the edit tables by broker processing
        '''''''''''''''''''''''''''''''''''
        CUSTOM
        HISTORY
        INSTALLATION
        LEGEND
        STANDARD
        SUPPORTS
        NEW_INSTALL
        DELETED
    End Enum
    Public Enum ti_child_assets
        '''''''''''''''''''''''''''''''''''
        'Used For: List of child assets in TI
        '''''''''''''''''''''''''''''''''''
        SNSU
        SNSN
        SNML
    End Enum

    Public Enum LOV
        '''''''''''''''''''''''''''''''''''
        'Used For: looping through the LOV tables by broker processing
        '''''''''''''''''''''''''''''''''''
        TBLSHEETING
        TBLSUBSTRATE
        TBLSIDE
        TBLDIRECTIONS
        'TBLDISTRICTS
        TBLHIGHWAYEA
        TBLHIGHWAYS
        TBLHWYLKUP
        TBLROUTESINTERSTATE
        TBLROUTESUS
        TBLROUTESSTATE
        TBLMILEPOSTPREFIXES
        TBLHWYGPSDATA
        TBLSTANDARDSIGNS
        TBLACTIONS
        TBLCAUSES
        TBLSTANDARDSIGNGRAPHICS
        TBLSUPPORTS

    End Enum

    Public Enum LOV_SIMPLE_REPORT
        '''''''''''''''''''''''''''''''''''
        'Used For: looping through the LOV tables by broker processing for report type items in TI
        '''''''''''''''''''''''''''''''''''
        TBLHIGHWAYEA
        'TBLDISTRICTS
        TBLHIGHWAYS
        TBLROUTESINTERSTATE
        TBLROUTESUS
        TBLROUTESSTATE
        TBLMILEPOSTPREFIXES
        TBLHWYLKUP
    End Enum



    Public ReadOnly Property InitError As Exception
        Get
            Return pg_init_error
        End Get
    End Property
    Public Property sfa_SignClient_path As String
        Get
            Return pg_s_sfa_SignClient_path
        End Get
        Set(ByVal value As String)
            pg_s_sfa_SignClient_path = value
        End Set
    End Property

    Public Property sfa_SignData_path As String
        Get
            Return pg_s_sfa_SignData_path
        End Get
        Set(ByVal value As String)
            pg_s_sfa_SignData_path = value
        End Set
    End Property




    Public Function init() As Integer
        ' 1 init successful, 
        ' 0 init failed

        Try
            pg_Conn_sfa_Client.ConnectionString = main_form.g_s_jetConnString & pg_s_sfa_SignClient_path
            pg_Conn_sfa_Data.ConnectionString = main_form.g_s_jetConnString & pg_s_sfa_SignData_path


            pg_Conn_sfa_Client.Open()
            pg_Conn_sfa_Data.Open()

            Return 1

        Catch ex As OleDb.OleDbException
            pg_init_error = ex
            ' MsgBox(ex.Message)
            Return 0
        Catch ex As Exception
            pg_init_error = ex
            Return 0
        End Try






    End Function



    Public Function _get_new_install_list() As ArrayList
        '''''''''''''''''''''''''''''''''''
        'Used For: Geting the list of new install items
        '''''''''''''''''''''''''''''''''''
        Dim _ret_val As New ArrayList
        Dim _sql As String = "select fldinstalledID from tblExpNewInstall "
        Dim _where As String = " where fldinstalledID not in (select fldInstallationId from tblEditinstallation where ucase(fldLocation) = 'DELETE')"

        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        Dim mdbDT As New DataTable("NewInstalls")
        mdbAdaptor.Fill(mdbDT)

        Dim row As DataRow

        For Each row In mdbDT.Rows
            If IsDBNull(row.Item("fldinstalledID")) = False Then _ret_val.Add(row.Item("fldinstalledID"))
        Next

        Return _ret_val
    End Function

    Public Function _get_edited_list(e_item As edit_items) As ArrayList
        '''''''''''''''''''''''''''''''''''
        'Used For: Geting the list of edited install items
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As ArrayList
        Dim _sql As String = ""
        Dim _where As String = ""

        Select Case e_item
            Case edit_items.CUSTOM
                _sql = "select distinct fldInstalledId as fldID from tblEditCustom "
                _where = "where fldInstalledId is not null"
            Case edit_items.HISTORY
                _sql = "select distinct fldInstalledId as fldID from tblEditHistory "
                _where = "where fldInstalledId is not null"
            Case edit_items.INSTALLATION
                _sql = "select distinct fldInstallationId as fldID from tblEditInstallation "
                _where = "where fldInstallationId is not null and ucase(fldLocation) <> 'DELETE'"
            Case edit_items.LEGEND
                _sql = "select distinct fldLegendID  as fldID from tblEditLegend "
                _where = "where fldLegendID is not null"
            Case edit_items.STANDARD
                _sql = "select distinct fldInstalledId  as fldID from tblEditStandard "
                _where = "where fldInstalledId is not null"
            Case edit_items.SUPPORTS
                _sql = "select distinct fldInstallId as fldID from tblEditSupports "
                _where = "where fldInstallId is not null"
            Case edit_items.NEW_INSTALL
                ret_val = _get_new_install_list()
                Return ret_val
            Case edit_items.DELETED
                _sql = "select distinct fldInstallationId as fldID from tblEditInstallation "
                _where = "where fldInstallationId is not null and  ucase(fldLocation) = 'DELETE'"
        End Select

        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        Dim mdbDT As New DataTable("NewInstalls")
        mdbAdaptor.Fill(mdbDT)

        Dim row As DataRow

        ret_val = New ArrayList

        For Each row In mdbDT.Rows
            ret_val.Add(row.Item("fldID"))
        Next

        Return ret_val
    End Function

    Public Function _get_neid_from_edit(i_item As Int32) As Int32
        '''''''''''''''''''''''''''''''''''
        'Used For: Geting the ne_id from SFA, if it exists
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Int32 = -1

        Dim _sql As String = ""
        Dim _where As String = ""
        _sql = "select distinct snin_ne_id as ne_id from tblEditInstallation "
        _where = "where fldInstallationId = " & i_item

        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        Dim mdbDT As New DataTable("Edited_NE_ID")
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 And IsDBNull(mdbDT.Rows(0).Item(0)) = False Then
            ret_val = mdbDT.Rows(0).Item(0)
        End If


        Return ret_val
    End Function




    Public Function _is_sfa_inst_in_edit_table(i_item As Int64, sTable As edit_items) As Boolean
        '''''''''''''''''''''''''''''''''''
        'Used For: Geting the ne_id from SFA, if it exists
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Boolean = False


        Dim _sql As String = ""
        Dim _where As String = ""

        Select Case sTable
            Case edit_items.CUSTOM
                _sql = "select distinct fldInstalledId as fldID from tblEditCustom "
                _where = "where fldInstalledId = @1"
            Case edit_items.HISTORY
                _sql = "select distinct fldInstalledId as fldID from tblEditHistory "
                _where = "where fldInstalledId  = @1"
            Case edit_items.INSTALLATION
                _sql = "select distinct fldInstallationId as fldID from tblEditInstallation "
                _where = "where fldInstallationId  = @1"
            Case edit_items.STANDARD
                _sql = "select distinct fldInstalledId  as fldID from tblEditStandard "
                _where = "where fldInstalledId  = @1"
            Case edit_items.SUPPORTS
                _sql = "select distinct fldInstallId as fldID from tblEditSupports "
                _where = "where fldInstallId = @1"

        End Select

        If _sql <> "" Then



            Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
            Dim mdbDT As New DataTable("Edit")

            mdbAdaptor.SelectCommand.Parameters.AddWithValue("@1", i_item)

            mdbAdaptor.Fill(mdbDT)

            If mdbDT.Rows.Count > 0 Then
                ret_val = True
            End If
        End If

        Return ret_val
    End Function


    Public Function _get_total_sfa_sync_count() As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Geting a count of items that need to be synced
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0
        Dim sync_cnt As Integer = 0
        Dim _sql As String = ""
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        Dim ol As New OleDb.OleDbCommand
        Dim mdbDT As New DataTable("Installid")

        _sql = "select distinct fldInstalledId as fldID from tblEditCustom "



        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        ol.Connection = pg_Conn_sfa_Client

        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If


        _sql = "select distinct fldInstalledId as fldID from tblEditHistory where fldinstalledId"

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If

        _sql = "select distinct fldInstallationId as fldID from tblEditInstallation "

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If

        _sql = "select distinct fldLegendID  as fldID from tblEditLegend "

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If

        _sql = "select distinct fldInstalledId  as fldID from tblEditStandard "

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If

        _sql = "select distinct fldInstallId as fldID from tblEditSupports "

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If


        _sql = "select distinct * from  tblEXpNewInstall"

        ol.CommandText = "select count(*) as cnt from (" & _sql & ")"
        mdbAdaptor.SelectCommand = ol
        mdbDT.Reset()
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            ret_val = ret_val + mdbDT.Rows(0).Item(0)
        End If





        Return ret_val
    End Function

    Public Function _get_install_row(install_id As Int64) As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a single row from the install table
        '''''''''''''''''''''''''''''''''''

        Dim _ret_val As DataRow
        Dim _sql As String = "select * from tblInstallations where fldinstallationid = " & install_id

        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        Dim mdbDT As New DataTable("InstallsRow")
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count > 0 Then
            _ret_val = mdbDT.Rows(0)
        Else

            _ret_val = mdbDT.NewRow
            _ret_val.Item("fldinstallationid") = -99
        End If

        ' need to trap a possible null reference error
        Return _ret_val

    End Function

    Public Function _get_install_ID_From_Legend_Id(legend_id As Integer) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a inst_id from a legend ID
        '''''''''''''''''''''''''''''''''''
        Dim _ret_val As Integer
        Dim _sql As String = "select fldInstalledId from tblinstalledCustomSigns where fldCustLegendId = " & legend_id

        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        Dim mdbDT As New DataTable("Installid")
        mdbAdaptor.Fill(mdbDT)

        If mdbDT.Rows.Count <> 0 Then
            _ret_val = mdbDT.Rows(0).Item(0)
        Else
            _ret_val = -1
        End If
        ' need to trap a possible null reference error
        Return _ret_val

    End Function

    Public Sub _update_ne_id(n_inst_id, n_neid)
        '''''''''''''''''''''''''''''''''''
        'Used For: updating the ne_id in the instalation table 
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "update tblinstallations set snin_ne_id =" & n_neid & " where fldinstallationid = " & n_inst_id

        'Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)

        Dim mdbcommand As New OleDb.OleDbCommand(_sql, pg_Conn_sfa_Client)

        mdbcommand.ExecuteNonQuery()

    End Sub

    Public Function _get_new_install_row() As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''
        Dim _sql As String = "select fldDistrict,  fldStateHwy,  fldMPPrefix,  fldMP,  fldLocation,  fldDirection,  fldSide,  fldDistanceEOP,  fldCreationDate,  RDWY_ID,  intrstt_rts,  us_rts,  stt_rts,  fldLatitude,  fldLongitude,  fldSecondDist,  fldAddtNotes,  SNIN_NE_ID from tblInstallations where 1=2"
        Dim mdbdt As New DataTable("install_row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow

    End Function

    Public Function _get_new_std_panel_row() As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "SELECT fldInstalledId, fldStandSignNumber, fldStandEstReplaceDate, fldStandFail, fldFacingId, fldInstallDate, RefInspDt,fldSubstrate, fldSheeting, fldSignRecycleCount, fldSOI FROM tblInstalledStandardSigns where 1=2;"
        Dim mdbdt As New DataTable("panel_row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow

    End Function
    Public Function _get_new_cust_panel_row() As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "SELECT fldInstalledId, fldCustWidth, fldCustHeight, fldCustEstReplaceDate, fldCustLegendId, fldCustFail, fldCustPicture, fldFacingId, fldSubstrate, fldSheeting, fldInstallDate, RefInspDt, fldSignRecycleCount, fldSOI FROM tblInstalledCustomSigns where 1 =2;"
        Dim mdbdt As New DataTable("panel_row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow

    End Function

    Public Function _get_new_legend_row() As DataRow

        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "SELECT fldLegendID,fldLegend, fldLineNo FROM tblCustomSignLegends where 1 =2;"
        Dim mdbdt As New DataTable("panel_row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow

    End Function

    Public Function _get_new_support_row() As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "SELECT fldInstalledId,fldNumberOfPosts,fldPostType_Size,fldInstallDate from tblInstalledSupports where 1 =2;"
        Dim mdbdt As New DataTable("row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow

    End Function

    Public Function _get_new_history_row() As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a empty row
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "SELECT * from tblinstallationHistory where 1 =2;"
        Dim mdbdt As New DataTable("row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        'newrow.Table.Columns.Remove("fldInstalledId")

        Return newrow

    End Function

    Public Function _insert_inst_row(r_row As DataRow) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: building an insert sql statement
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = -1

        'Dim _sql As String = "insert into tblInstallations ("

        '_sql = _sql & insert_builder(r_row) & ")"

        'Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)

        Dim s_table_name As String = "tblInstallations"
        Dim mdbcommand As New OleDb.OleDbCommand '(_sql, pg_Conn_sfa_Client)
        mdbcommand.Connection = pg_Conn_sfa_Client

        mdbcommand = _insert_builder_test(r_row, mdbcommand, s_table_name)

        ret_val = mdbcommand.ExecuteNonQuery()

        Return ret_val




    End Function

    Public Function _update_inst_row(r_row As DataRow) As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: building an update sql statement
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = -1
        Dim _sql As String = "update tblInstallations set "
        Dim _where As String

        '_sql = _sql & update_builder(r_row) & " "

        '_where = " where SNIN_NE_ID = " & r_row.Item("SNIN_NE_ID")
        _where = " where SNIN_NE_ID = @00"
        'Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)

        Dim mdbcommand As New OleDb.OleDbCommand  '(_sql & _where, pg_Conn_sfa_Client)

        mdbcommand.Connection = pg_Conn_sfa_Client

        mdbcommand = update_builder(r_row, mdbcommand, "tblInstallations", _where)
        mdbcommand.Parameters.AddWithValue("@00", r_row.Item("SNIN_NE_ID"))

        ret_val = mdbcommand.ExecuteNonQuery()

        Return ret_val

    End Function

    Public Function _update_GPS_RDWY_TYP() As Integer
        Dim ret_val As Integer = 0

        Dim _sql As String = "update tblhwyGPSdata set rdwy_typ = @1 "
        Dim _where As String = " where  rdwy_typ = @2"

        Dim mdbcommand As New OleDb.OleDbCommand

        mdbcommand.Connection = pg_Conn_sfa_Client

        mdbcommand.CommandText = _sql & _where

        mdbcommand.Parameters.Add("@1", OleDb.OleDbType.VarChar)
        mdbcommand.Parameters.Add("@2", OleDb.OleDbType.VarChar)

        ' Update the TI Valuses to the Expected SFA ones
        mdbcommand.Parameters("@1").Value = "reg"
        mdbcommand.Parameters("@2").Value = "M"
        ret_val = mdbcommand.ExecuteNonQuery()

        mdbcommand.Parameters("@1").Value = "con"
        mdbcommand.Parameters("@2").Value = "C"
        ret_val = mdbcommand.ExecuteNonQuery()

        mdbcommand.Parameters("@1").Value = "frt"
        mdbcommand.Parameters("@2").Value = "F"
        ret_val = mdbcommand.ExecuteNonQuery()


        Return ret_val

    End Function


    Public Function _insert_general_row_old(r_row As DataRow, s_table_name As String) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: building an insert sql statement
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer
        Dim _sql As String = "insert into " & s_table_name & " ("

        _sql = _sql & insert_builder(r_row) & ")"

        'Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)

        Dim mdbcommand As New OleDb.OleDbCommand(_sql, pg_Conn_sfa_Client)

        ret_val = mdbcommand.ExecuteNonQuery()

        Return ret_val

    End Function

    Public Function _insert_general_row(r_row As DataRow, s_table_name As String) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: building an insert sql statement with parameters
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = -1
        ' Dim _sql As String = "insert into " & s_table_name & " ("

        '_sql = _sql & insert_builder(r_row) & ")"

        Dim mdbcommand As New OleDb.OleDbCommand '(_sql, pg_Conn_sfa_Client)
        mdbcommand.Connection = pg_Conn_sfa_Client



        _insert_builder_test(r_row, mdbcommand, s_table_name)

        'Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)

        'Dim mdbcommand As New OleDb.OleDbCommand(_sql, pg_Conn_sfa_Client)
        Try
            ret_val = mdbcommand.ExecuteNonQuery()

            mdbcommand.Dispose()
        Catch ex As OleDb.OleDbException
            Select Case ex.ErrorCode
                Case -2147467259
                    ret_val = -2147467259


                    If ex.Message.Contains("duplicate") = False Then  ' the duplicate error shoudl only happen when TI has a meta data issue on the LOVS

                        Dim mes As String = "SFA.ROW.INSERT(" & s_table_name & "): " & ex.Message & vbCrLf & ex.StackTrace
                        Dim i As Int16
                        Dim ti As New TI_Tools
                        If mes.Length < 1998 Then
                            i = mes.Length
                        Else
                            i = 1997
                        End If

                        'ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
                        Throw  ' lets send this to the application events handler
                    Else
                        ret_val = 1000000000  ' so I can just send a duplicate error message from the calling function
                    End If

                Case Else
                    Dim mes As String = "SFA.ROW.INSERT(" & s_table_name & "): " & ex.Message & vbCrLf & ex.StackTrace
                    Dim i As Int16
                    Dim ti As New TI_Tools
                    If mes.Length < 1998 Then
                        i = mes.Length
                    Else
                        i = 1997
                    End If


                    'ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
                    Throw  ' lets send this to the application events handler
            End Select
        Catch ex As Exception

            Dim mes As String = "SFA.ROW.INSERT(" & s_table_name & "): " & ex.Message & vbCrLf & ex.StackTrace
            Dim i As Int16
            Dim ti As New TI_Tools
            If mes.Length < 1998 Then
                i = mes.Length
            Else
                i = 1997
            End If

            ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
        End Try

        Application.DoEvents()

        Return ret_val

    End Function


    Public Sub _insert_new_install_item(i_instID As Integer)
        '''''''''''''''''''''''''''''''''''
        'Used For: building an inserting into the new install table
        '''''''''''''''''''''''''''''''''''

        Dim _sql As String = "insert into tblExpNewInstall (fldInstalledId) values (" & i_instID & ")"

        Dim mdbcommand As New OleDb.OleDbCommand(_sql, pg_Conn_sfa_Client)

        mdbcommand.ExecuteNonQuery()
        Application.DoEvents()
    End Sub

    Public Sub _insert_edit_item(i_install_id As Integer, e_item As edit_items)

        '''''''''''''''''''''''''''''''''''
        'Used For: building an inserting into various edited tables 
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As Boolean = False
        Dim _sql As String = "insert into #TABLE# values ("
        Dim _where As String = " ( #values )"

        Select Case e_item
            Case edit_items.CUSTOM
                _sql = _sql.Replace("#TABLE#", "tblEditCustom ")
                _where = _quoted_string(i_install_id) & ")"
            Case edit_items.HISTORY
                _sql = _sql.Replace("#TABLE#", "tblEditHistory ")
                _where = i_install_id & ")"
            Case edit_items.INSTALLATION
                _sql = _sql.Replace("#TABLE#", "tblEditInstallation ")
                _where = i_install_id & ")"
            Case edit_items.LEGEND
                _sql = _sql.Replace("#TABLE#", "tblEditLegend ")
                _where = i_install_id & ")"
            Case edit_items.STANDARD
                _sql = _sql.Replace("#TABLE#", "tblEditStandard ")
                _where = _quoted_string(i_install_id) & ")"
            Case edit_items.SUPPORTS
                _sql = _sql.Replace("#TABLE#", "tblEditSupports ")
                _where = i_install_id & ")"
            Case edit_items.NEW_INSTALL
                _sql = _sql.Replace("#TABLE#", " tblExpNewInstall ")
                _where = i_install_id & ")"
        End Select

        If _sql <> "N/A" Then
            Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)

            mdbcommand.ExecuteNonQuery()
            ret_val = True

        End If


    End Sub
    Public Function _child_item_exists_for_Install(i_install_id As Integer, e_item As edit_items) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: Checks to see if a given istallation has items in a "child" table 
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = 0
        Dim _sql As String = "select count(*) from  #TABLE#   "
        Dim _where As String = " ( #values )"

        Select Case e_item
            Case edit_items.CUSTOM
                _sql = _sql.Replace("#TABLE#", "tblInstalledCustomSigns ")
                _where = " where fldInstalledId =" & i_install_id
            Case edit_items.HISTORY
                _sql = _sql.Replace("#TABLE#", "tblInstallationHistory ")
                _where = " where fldInstalledId =" & i_install_id
            Case edit_items.INSTALLATION
                _sql = _sql.Replace("#TABLE#", "tblInstallations ")
                _where = " where fldInstallationId =" & i_install_id
            Case edit_items.LEGEND
                _sql = _sql.Replace("#TABLE#", "tblCustomSignLegends ")
                _where = " where fldLegendId =" & i_install_id
            Case edit_items.STANDARD
                _sql = _sql.Replace("#TABLE#", "tblInstalledStandardSigns ")
                _where = " where fldInstalledId =" & i_install_id
            Case edit_items.SUPPORTS
                _sql = _sql.Replace("#TABLE#", "tblInstalledSupports ")
                _where = " where fldInstalledId =" & i_install_id
            Case edit_items.NEW_INSTALL
                _sql = _sql.Replace("#TABLE#", " tblInstallations ")
                _where = " where fldInstalledId =" & i_install_id
        End Select

        If _sql <> "N/A" Then
            Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)

            ret_val = mdbcommand.ExecuteScalar


        End If
        Return ret_val

    End Function


    Public Function _get_Standard_signs(i_installID As Integer) As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the stanadard signs of an instalation
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As DataTable

        Dim _sql As String = "SELECT  fldInstalledId,  fldStandSignNumber,  fldStandEstReplaceDate,  fldStandFail,  fldInstallDate,(SELECT DISTINCT fldFacingText FROM tblSignFacing where tblsignfacing.fldFacingId = tblInstalledStandardSigns.fldFacingId ) as fldFacingId,  RefInspDt,  fldSubstrate,  fldSheeting,  fldSignRecycleCount,  fldSOI FROM tblInstalledStandardSigns "
        Dim _where As String = " where fldInstalledId = " & i_installID
        Dim mdbdt As New DataTable("StandardSigns")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        ret_val = mdbdt

        Return ret_val
    End Function
    Public Function _get_custom_signs(i_installID As Int64) As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the custom signs of an instalation
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As DataTable

        'Dim _sql As String = "SELECT fldInstalledId, fldCustWidth, fldCustHeight, fldCustEstReplaceDate, fldCustLegendId, fldCustFail, fldCustPicture, fldFacingId, fldSubstrate, fldSheeting,fldInstallDate, RefInspDt, fldSignRecycleCount, fldSOI FROM tblInstalledCustomSigns "
        Dim _sql As String = "SELECT fldInstalledId, fldCustWidth, fldCustHeight, fldCustEstReplaceDate, fldCustLegendId, fldCustFail, fldCustPicture, (SELECT DISTINCT fldFacingText FROM tblSignFacing where tblsignfacing.fldFacingId = tblInstalledCustomSigns.fldFacingId ) as fldFacingId, fldSubstrate, fldSheeting,fldInstallDate, RefInspDt, fldSignRecycleCount, fldSOI FROM tblInstalledCustomSigns "
        Dim _where As String = " where fldInstalledId = " & i_installID
        Dim mdbdt As New DataTable("CustomSigns")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        ret_val = mdbdt

        Return ret_val
    End Function

    Public Function _get_supports(i_installID As Integer) As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the supports of an instalation
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As DataTable

        'Dim _sql As String = "SELECT fldInstalledId, fldNumberOfPosts, fldPostTYpe_size, fldInstallDate from tblInstalledSupports "
        Dim _sql As String = "SELECT fldInstalledId, fldNumberOfPosts,  iif(isnull((select fldsupporttype from tblsupports where fldSupportStoreRoomNum = a.fldPostTYpe_size)), a.fldPostTYpe_size,(select fldsupporttype from tblsupports where fldSupportStoreRoomNum = a.fldPostTYpe_size)) as fldPostTYpe_size, fldInstallDate from tblInstalledSupports a "
        Dim _where As String = " where fldInstalledId = " & i_installID
        Dim mdbdt As New DataTable("supports")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        ret_val = mdbdt

        Return ret_val
    End Function

    Public Function _get_Maintenance_Log(i_installID As Integer) As DataTable
        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the history of an instalation
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As DataTable

        Dim _sql As String = "SELECT fldInstalledId, fldHistDate, fldHistAction, fldHistCause, fldHistCrewHours, fldHistEquipHours, fldHistSignNumber, fldHistRespPerson, fldHistComments, fldHistAccomplishments, fldHistMaterials, fldHistSignLegend, fldHistSignSize, fldHistSignFacing, fldHistPost, fldHistAct FROM tblInstallationHistory "
        Dim _where As String = " where fldInstalledId = " & i_installID
        Dim mdbdt As New DataTable("log")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        ret_val = mdbdt

        Return ret_val
    End Function

    Public Function _getCustomSignLegend(s_legendid As String, sBreakChar As Char) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the signs legends of an instalation
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As String = "NOT_FOUND"

        Dim _sql As String = "SELECT fldLegend from tblCustomSignLegends "
        Dim _where As String = " where fldLegendId = " & s_legendid & " order by fldLineNo"
        Dim mdbdt As New DataTable("SignsLeg")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count <> 0 Then
            Dim row As DataRow
            ret_val = ""
            For Each row In mdbdt.Rows
                ret_val = ret_val & row("fldLegend").ToString & sBreakChar
            Next
            ret_val = ret_val.TrimEnd(sBreakChar)
        End If

        Return ret_val
    End Function

    Public Function _remove_from_edit_tables(e_Item As edit_items, i_install_id As Integer) As Boolean

        '''''''''''''''''''''''''''''''''''
        'Used For: removes all items from one of data tables for an installation ID
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Boolean = False
        Dim _sql As String = "N/A"
        Dim _where As String = "N/A"


        Select Case e_Item
            Case edit_items.CUSTOM
                _sql = "delete from tblEditCustom "
                _where = " where fldInstalledId = @1"
            Case edit_items.HISTORY
                _sql = "delete from tblEditHistory "
                _where = " where fldInstalledId = @1"
            Case edit_items.INSTALLATION
                _sql = "delete from tblEditInstallation "
                _where = " where fldInstallationId =  @1"
            Case edit_items.LEGEND
                _sql = "delete from tblEditLegend "
                _where = " where fldLegendId =  @1"
            Case edit_items.STANDARD
                _sql = "delete from tblEditStandard "
                _where = " where fldInstalledId =  @1"
            Case edit_items.SUPPORTS
                _sql = "delete from tblEditSupports "
                _where = " where fldInstallId =  @1"
            Case edit_items.NEW_INSTALL
                _sql = "delete from tblExpNewInstall "
                _where = " where fldInstalledId =  @1"
        End Select




        If _sql <> "N/A" Then
            Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)

            mdbcommand.Parameters.AddWithValue("@1", i_install_id)

            mdbcommand.ExecuteNonQuery()
            ret_val = True

        End If

        Return ret_val
    End Function

    Public Function _get_inst_id_from_NE_ID_old(s_ne_id As String) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: gets an installation ID form a TI NE ID
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As String = "NOT_FOUND"

        Dim _sql As String = "SELECT fldInstallationId from tblInstallations "
        Dim _where As String = " where SNIN_NE_ID = " & s_ne_id
        Dim mdbdt As New DataTable("SignInst")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)

        Try
            mdbAdaptor.Fill(mdbdt)

            If mdbdt.Rows.Count = 1 Then
                ret_val = mdbdt.Rows(0).Item(0).ToString
            ElseIf mdbdt.Rows.Count > 1 Then
                ret_val = "MULTI"
            End If
        Catch ex As Exception
            ' Adding a Trap here to help troubleshoot an error tha tthe general handler was not giving enough information for.
            Dim ti As New TI_Tools
            ti.write_xodot_signs_logging_exception(s_ne_id, "N/A", "N/A", 0, "SFA_Tools", "Error trying to retrieve the fldInstallationId from tblInstallations where SNIN_NE_ID = " & s_ne_id)

            Throw
        End Try


        Return ret_val


    End Function

    Public Function _get_inst_id_from_NE_ID(s_ne_id As String) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: gets an installation ID form a TI NE ID
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As String = "NOT_FOUND"

        Dim _sql As String = "SELECT fldInstallationId from tblInstallations "
        Dim _where As String = " where SNIN_NE_ID = @1"
        Dim mdbdt As New DataTable("SignInst")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)

        mdbAdaptor.SelectCommand.Parameters.AddWithValue("@1", s_ne_id)

        Try
            mdbAdaptor.Fill(mdbdt)

            If mdbdt.Rows.Count = 1 Then
                ret_val = mdbdt.Rows(0).Item(0).ToString
            ElseIf mdbdt.Rows.Count > 1 Then
                ret_val = "MULTI"
            End If
        Catch ex As Exception
            ' Adding a Trap here to help troubleshoot an error tha tthe general handler was not giving enough information for.
            Dim ti As New TI_Tools
            ti.write_xodot_signs_logging_exception(s_ne_id, "N/A", "N/A", 0, "SFA_Tools", "Error trying to retrieve the fldInstallationId from tblInstallations where SNIN_NE_ID = " & s_ne_id)

            Throw
        End Try


        Return ret_val


    End Function

    Public Function _get_crew_number() As String
        '''''''''''''''''''''''''''''''''''
        'Used For: gets the crew number using the broker
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = 0

        Dim _sql As String = "SELECT fldCrew from tblDistrictLkup  "
        Dim _where As String = " where fldDistrict = (select max(fldDfltDist) from tblDfltDist)"
        Dim mdbdt As New DataTable("dist")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)

        Try
            mdbAdaptor.Fill(mdbdt)

        Catch ex As OleDb.OleDbException

            If ex.ErrorCode <> -2147467259 Then
                Dim mes As String = ex.Message & vbCrLf & ex.StackTrace
                Dim i As Int16
                Dim ti As New TI_Tools
                If mes.Length < 1998 Then
                    i = mes.Length
                Else
                    i = 1997
                End If

                ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, ex.HResult, mes.Substring(0, i))
            End If

            ret_val = ex.ErrorCode
        End Try

        If mdbdt.Rows.Count = 1 Then
            ret_val = mdbdt.Rows(0).Item(0)
        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = -1  ' should never happen
        End If

        Return ret_val
    End Function
    Public Function _get_crew_district() As String
        '''''''''''''''''''''''''''''''''''
        'Used For: gets all the district of the current crew
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As String = "0"

        Dim _sql As String = "SELECT fldDistrict from tblDistrictLkup  "
        Dim _where As String = " where fldDistrict = (select max(fldDfltDist) from tblDfltDist)"
        Dim mdbdt As New DataTable("dist")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count = 1 Then
            ret_val = mdbdt.Rows(0).Item(0)
        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = "-1"  ' should never happen
        End If

        Return ret_val
    End Function
    Public Function _get_crew_only() As Integer
        '''''''''''''''''''''''''''''''''''
        'Used For: gets if the crew only flag is set
        '''''''''''''''''''''''''''''''''''


        Dim ret_val As Integer = 0

        Dim _sql As String = "SELECT fldCrewOnlyFlag from tblDistrictLkup  "
        Dim _where As String = " where fldDistrict = (select max(fldDfltDist) from tblDfltDist)"
        Dim mdbdt As New DataTable("dist")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count = 1 Then
            ret_val = mdbdt.Rows(0).Item(0)
        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = -1  ' should never happen
        End If

        Return ret_val
    End Function
    Public Function _get_max_fldInstallationId() As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: gets the current max installation ID
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = 0

        Dim _sql As String = "SELECT max(fldInstallationId) as id_max from tblInstallations "
        Dim _where As String = ""
        Dim mdbdt As New DataTable("SignInst")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count = 1 Then
            ret_val = mdbdt.Rows(0).Item(0)
        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = -1  ' should never happen
        End If

        Return ret_val
    End Function


    Public Function _get_max_fldLegendId() As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: gets the current max Legend ID
        '''''''''''''''''''''''''''''''''''
        Dim ret_val As Integer = 0

        Dim _sql As String = "SELECT max(fldCustLegendId) as id_max from tblinstalledCustomSigns"
        Dim _where As String = ""
        Dim mdbdt As New DataTable("SignInfo")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count = 1 Then
            If IsDBNull(mdbdt.Rows(0).Item(0)) Then
                ret_val = 0
            Else
                ret_val = mdbdt.Rows(0).Item(0)
            End If
        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = 0  ' could happen on empty table
        End If

        Return ret_val
    End Function

    Public Function _remove_child_item_for_inst_ID(s_ti_asset_item As ti_child_assets, s_install_id As String) As Boolean
        '''''''''''''''''''''''''''''''''''
        'Used For: Deleting child items related to an instalation ID
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Boolean = False
        Dim _sql As String = "N/A"
        Dim _where As String = "N/A"

        Dim _sql_2 As String = "N/A"
        Dim _where_2 As String = "N/A"

        Select Case s_ti_asset_item
            Case ti_child_assets.SNSU
                Dim tblname As String = "tblInstalledSupports"
                Dim whereitem As String = "fldInstalledId"

                _sql = "delete from " & tblname & " "
                _where = "where " & whereitem & " = " & s_install_id

            Case ti_child_assets.SNML
                Dim tblname As String = "tblInstallationHistory"
                Dim whereitem As String = "fldInstalledId"

                _sql = "delete from " & tblname & " "
                _where = "where " & whereitem & " = " & s_install_id

            Case ti_child_assets.SNSN
                'in this casee we need to clear both custom and standard
                Dim tblname As String = "tblInstalledStandardSigns"
                Dim whereitem As String = "fldInstalledId"

                _sql = "delete from " & tblname & " "
                _where = "where " & whereitem & " = " & s_install_id

                Dim tblname2 As String = "tblInstalledCustomSigns"
                Dim whereitem2 As String = "fldInstalledId"

                _sql_2 = "delete from " & tblname2 & " "
                _where_2 = "where " & whereitem2 & " = " & s_install_id

                _remove_legend_items_from_inst_id(s_install_id)

        End Select


        'If pg_Conn_sfa_Client.State = ConnectionState.Closed Then pg_Conn_sfa_Client.Open()

        Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)



        Dim i_return As Integer
        i_return = mdbcommand.ExecuteNonQuery()

        If s_ti_asset_item = ti_child_assets.SNSN Then
            mdbcommand.CommandText = _sql_2 & _where_2
            Dim i_return2 As Integer
            i_return2 = mdbcommand.ExecuteNonQuery()
        End If


        Return ret_val

    End Function

    Public Function _remove_Installation(s_install_id As String) As Boolean

        '''''''''''''''''''''''''''''''''''
        'Used For: Deleting child items related to an instalation 
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Boolean = False
        Dim _sql As String = "N/A"
        Dim _where As String = "N/A"


        Dim tblname As String = "tblInstallations"
        Dim whereitem As String = "fldInstallationId"

        _sql = "delete from " & tblname & " "
        _where = "where " & whereitem & " = " & s_install_id


        Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)



        Dim i_return As Integer
        i_return = mdbcommand.ExecuteNonQuery()

        If i_return <> 0 Then ret_val = True
        Return ret_val

    End Function

    Public Function _remove_LOV_items(item As LOV, Optional row As DataRow = Nothing) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: Deleting LOV Items from SFA
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = 0

        Dim _sql As String = ""
        Dim _where As String = ""

        Select Case item
            Case Else
                _sql = "delete from " & item.ToString & " "
        End Select

        Select Case item
            Case LOV.TBLHWYGPSDATA
                '_where = " where hwynumb = @1 and rdwy_id = @2 and mlge_type = @3 and ovlp_cd = @4"
                _where = " where hwynumb = @1 and rdwy_id = @2  and mlge_typ = @3  and ovlp_cd = @4"
        End Select

        Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where, pg_Conn_sfa_Client)

        If IsNothing(row) = False Then
            Select Case item
                Case LOV.TBLHWYGPSDATA
                    mdbcommand.Parameters.AddWithValue("@1", row.Item("hwy_no"))
                    mdbcommand.Parameters.AddWithValue("@2", row.Item("rdwy_id"))
                    mdbcommand.Parameters.AddWithValue("@3", row.Item("mlge_typ"))
                    mdbcommand.Parameters.AddWithValue("@4", row.Item("ovlp_cd"))
            End Select
        End If

        ret_val = mdbcommand.ExecuteNonQuery()

        Return ret_val
    End Function

    Public Function _get_new_lov_row(item As LOV) As DataRow
        '''''''''''''''''''''''''''''''''''
        'Used For: Getting a new LOV row
        '''''''''''''''''''''''''''''''''''


        Dim _sql As String = "SELECT * from " & item.ToString & " where 1 =2;"
        Dim mdbdt As New DataTable("row")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        Dim newrow As DataRow = mdbdt.NewRow

        Return newrow
    End Function

    Public Function _get_rt_dist_from_TBL_HWY_LKUP(MileageType As String, RD_ID As String, RDWY_ID As String, mp As String) As DataRow

        '''''''''''''''''''''''''''''''''''
        'Used For: getting a single row form a lookup table: TBL_HWY_LKUP
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As DataRow

        Dim _sql As String = "select * from tblHWYLkup "
        Dim _where As String = " where rd_id = @1 and  mileagetype= @2 and rdwy_id = @3 and beginMP<= @4 and endmp >= @4 "


        Dim mdbcommand As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)


        mdbcommand.SelectCommand.Parameters.AddWithValue("@1", RD_ID)
        mdbcommand.SelectCommand.Parameters.AddWithValue("@2", MileageType)
        mdbcommand.SelectCommand.Parameters.AddWithValue("@3", RDWY_ID)
        mdbcommand.SelectCommand.Parameters.AddWithValue("@4", mp)

        Dim tb As New DataTable("hwylookup")

        mdbcommand.Fill(tb)

        If tb.Rows.Count = 1 Or tb.Rows.Count = 2 Then
            ret_val = tb.Rows(0)
        Else
            ret_val = tb.NewRow
        End If

        Return ret_val
    End Function

    Public Function _get_FacingID(TI_facing As String) As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: gets the facing ID from a String given by TI
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = 0

        Dim _sql As String = "select fldFacingId from tblSignFacing "
        Dim _where As String = " where fldFacingText = @1 "


        Dim mdbcommand As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)


        mdbcommand.SelectCommand.Parameters.AddWithValue("@1", TI_facing
                                                         )


        Dim tb As New DataTable("hwylookup")

        mdbcommand.Fill(tb)

        If tb.Rows.Count = 1 Then
            ret_val = tb.Rows(0).Item(0)
        Else
            ret_val = 1
        End If

        Return ret_val
    End Function


    Public Function _remove_legend_items_from_inst_id(s_inst_id As String) As Boolean

        '''''''''''''''''''''''''''''''''''
        'Used For: Deletes Items from the legend table for a given Install ID
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Boolean = False

        Dim dt As DataTable

        sfa_SignClient_path = main_form.g_s_sfa_path & "SignClient.mdb"
        sfa_SignData_path = main_form.g_s_sfa_path & "Signdata.mdb"

        ' init()  ' init needed since I am using somethign from in this class

        dt = _get_custom_signs(Convert.ToInt32(s_inst_id))

        If dt.Rows.Count > 0 Then
            Dim _sql As String = "delete from tblCustomSignLegends "
            Dim _where As String = "where fldLegendId in ("
            Dim _in_str As String = ""
            Dim row As DataRow

            For Each row In dt.Rows
                _in_str = _in_str & row.Item("fldCustLegendId") & ","
            Next

            _in_str = _in_str.TrimEnd(",")
            _in_str = _in_str & ")"

#If DEBUG Then
            'MsgBox(_sql & _where & _in_str)
#End If



            Dim mdbcommand As New OleDb.OleDbCommand(_sql & _where & _in_str, pg_Conn_sfa_Client)

            mdbcommand.ExecuteNonQuery()
            ret_val = True
        End If






        Return ret_val
    End Function

    Public Function _get_max_broker_version() As Integer

        '''''''''''''''''''''''''''''''''''
        'Used For: gets max major broker version form the version control table
        '''''''''''''''''''''''''''''''''''

        Dim ret_val As Integer = -998

        Dim _sql As String = "SELECT max(BrokerVersion) as id_max from tblVersionControl"
        Dim _where As String = ""
        Dim mdbdt As New DataTable("SignInfo")
        Dim mdbAdaptor As New OleDb.OleDbDataAdapter(_sql & _where, pg_Conn_sfa_Client)
        mdbAdaptor.Fill(mdbdt)

        If mdbdt.Rows.Count = 1 Then
            If IsNumeric(mdbdt.Rows(0).Item(0)) Then
                ret_val = Convert.ToInt16(mdbdt.Rows(0).Item(0))
            Else
                ret_val = -999 ' A numeric value could not be found
            End If

        ElseIf mdbdt.Rows.Count > 1 Then
            ret_val = -998  ' could happen on empty table
        End If


        Return ret_val
    End Function

    Public Function _insert_builder_test(r_row As DataRow, cmd As OleDb.OleDbCommand, s_table As String) As OleDb.OleDbCommand

        '''''''''''''''''''''''''''''''''''
        'Used For: bulding an insert statment using parameters
        '''''''''''''''''''''''''''''''''''

        Dim s_out As String = ""
        Dim s_names As String = ""
        Dim s_val As String = ""
        Dim s_tmp As String = ""

        Dim c_col As DataColumn

        Dim i As Integer = 1

        For Each c_col In r_row.Table.Columns
            Select Case c_col.DataType
                Case System.Type.GetType("System.String")

                    If IsDBNull(r_row(c_col)) Then
                        s_tmp = ""
                    Else
                        s_tmp = r_row(c_col)
                    End If

                    's_tmp = _quoted_string(s_tmp)
                Case System.Type.GetType("System.DateTime")
                    's_tmp = "#" & r_row(c_col) & "#"
                Case Else
                    's_tmp = r_row(c_col)
            End Select

            If IsDBNull(r_row(c_col)) = False Then
                s_names = s_names & _access_column_brackets(c_col.ColumnName) & ","
                s_val = s_val & "@" & i & ","

                cmd.Parameters.AddWithValue("@" & i, r_row(c_col))

                i = i + 1

            End If
        Next

        s_names = s_names.TrimEnd(",")
        s_val = s_val.TrimEnd(",")

        cmd.CommandText = "Insert into " & s_table & " (" & s_names & ") values (" & s_val & ");"

        ' MsgBox(cmd.CommandText)

        Return cmd
    End Function

    Private Function insert_builder(r_row As DataRow) As String
        '''''''''''''''''''''''''''''''''''
        'Used For: bulding an insert statment without parameters (still in use)
        '''''''''''''''''''''''''''''''''''
        Dim s_out As String = ""
        Dim s_names As String = ""
        Dim s_val As String = ""
        Dim s_tmp As String = ""

        Dim c_col As DataColumn


        For Each c_col In r_row.Table.Columns
            If IsDBNull(r_row(c_col)) = False Then
                Select Case c_col.DataType
                    Case System.Type.GetType("System.String")

                        If IsDBNull(r_row(c_col)) Then
                            s_tmp = ""
                        Else
                            s_tmp = r_row(c_col)
                        End If

                        s_tmp = _quoted_string(s_tmp)
                    Case System.Type.GetType("System.DateTime")
                        s_tmp = "#" & r_row(c_col) & "#"
                    Case Else
                        s_tmp = r_row(c_col)
                End Select


                s_names = s_names & c_col.ColumnName & ","
                s_val = s_val & s_tmp & ","
            End If

        Next




        s_names = s_names.TrimEnd(",")
        s_val = s_val.TrimEnd(",")

        s_out = s_names & ") values (" & s_val

        Return s_out
    End Function

    Private Function update_builder(r_row As DataRow, cmd As OleDb.OleDbCommand, s_table As String, s_where As String) As OleDb.OleDbCommand


        '''''''''''''''''''''''''''''''''''
        'Used For: bulding an update statment using parameters
        '''''''''''''''''''''''''''''''''''


        Dim _sql As String = "update " & s_table & " set "
        Dim s_out As String = ""
        Dim s_names As String = ""
        Dim s_val As String = ""

        Dim s_tmp As String = ""

        Dim c_col As DataColumn

        Dim i As Integer = 1

        For Each c_col In r_row.Table.Columns
            Select Case c_col.DataType
                Case System.Type.GetType("System.String")

                    If IsDBNull(r_row(c_col)) Then
                        s_tmp = ""
                    Else
                        s_tmp = r_row(c_col)
                    End If

                    's_tmp = _quoted_string(s_tmp)
                Case System.Type.GetType("System.DateTime")
                    's_tmp = "#" & r_row(c_col) & "#"
                Case Else
                    's_tmp = r_row(c_col)
            End Select

            If IsDBNull(r_row(c_col)) = False Then
                If r_row(c_col).ToString.Trim <> "" Then
                    s_names = s_names & _access_column_brackets(c_col.ColumnName) & "= @" & i & ","
                    's_val = s_val & "@" & i & ","

                    cmd.Parameters.AddWithValue("@" & i, r_row(c_col))

                    i = i + 1
                End If
            End If
        Next

        s_names = s_names.TrimEnd(",")
        's_val = s_val.TrimEnd(",")

        cmd.CommandText = "update " & s_table & " set " & s_names & " " & s_where & ";"

        ' MsgBox(cmd.CommandText)
#If DEBUG Then
        Dim s As String = ""

        Dim params As OleDb.OleDbParameter

        For Each params In cmd.Parameters
            s = s & params.ParameterName & vbTab & "~" & params.Value & "~" & vbCrLf

        Next
        'MsgBox(s, , "Debug Message")
#End If

        Return cmd

    End Function

    'Private Function update_builder_old(r_row As DataRow) As String


    '    '''''''''''''''''''''''''''''''''''
    '    'Used For: bulding an insert statment without parameters
    '    '''''''''''''''''''''''''''''''''''

    '    Dim s_out As String = ""
    '    Dim s_names As String = ""
    '    Dim s_val As String = ""

    '    Dim c_col As DataColumn

    '    For Each c_col In r_row.Table.Columns
    '        If IsDBNull(r_row(c_col)) = False Then
    '            Select Case c_col.DataType
    '                Case System.Type.GetType("System.String")

    '                    If IsDBNull(r_row(c_col)) Then
    '                        s_val = ""
    '                    Else
    '                        s_val = r_row(c_col)
    '                    End If

    '                    s_val = _quoted_string(s_val)
    '                Case System.Type.GetType("System.DateTime")
    '                    s_val = "#" & r_row(c_col) & "#"
    '                Case Else
    '                    s_val = r_row(c_col)
    '            End Select


    '            s_names = s_names & c_col.ColumnName & "=" & s_val & ","
    '        End If
    '    Next

    '    s_names = s_names.TrimEnd(",")

    '    s_out = s_names

    '    Return s_out
    'End Function

    Private Function _quoted_string(s As String) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: doulbe quoting strings for using in Access SQL
        '''''''''''''''''''''''''''''''''''

        Dim out As String = Chr(34) & s & Chr(34)

        Return out
    End Function

    Private Function _access_column_brackets(s) As String

        '''''''''''''''''''''''''''''''''''
        'Used For: bracketing for using in Access SQL
        '''''''''''''''''''''''''''''''''''
        Dim out As String = "[" & s & "]"

        Return out
    End Function

    Public Sub Dispose() Implements IDisposable.Dispose

        '''''''''''''''''''''''''''''''''''
        'Used For: Clean-up since every instance of sfa tools opens a connection
        '''''''''''''''''''''''''''''''''''

        ' Dispose of unmanaged resources.

        pg_Conn_sfa_Client.Close()
        pg_Conn_sfa_Data.Close()


        ' Suppress finalization.
        GC.SuppressFinalize(Me)
    End Sub
End Class
