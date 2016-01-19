Namespace My

    ' The following events are available for MyApplication:
    ' 
    ' Startup: Raised when the application starts, before the startup form is created.
    ' Shutdown: Raised after all application forms are closed.  This event is not raised if the application terminates abnormally.
    ' UnhandledException: Raised if the application encounters an unhandled exception.
    ' StartupNextInstance: Raised when launching a single-instance application and the application is already active. 
    ' NetworkAvailabilityChanged: Raised when the network connection is connected or disconnected.

    Partial Friend Class MyApplication



        '''''''''''''''''''''''''''''''''''
        'Used For: writing normally disruptive errors to the error log in TI instead of prompting the user.
        '''''''''''''''''''''''''''''''''''
        Private Sub MyApplication_UnhandledException( _
            ByVal sender As Object, _
            ByVal e As Microsoft.VisualBasic.ApplicationServices.UnhandledExceptionEventArgs _
        ) Handles Me.UnhandledException

#If DEBUG Then
            MsgBox(e.Exception.Message.ToString, MsgBoxStyle.Information, "Debug Build Message")
#End If
            e.ExitApplication = False
            If e.Exception.Message.ToString.Contains("-03113") _
                Or e.Exception.Message.ToString.Contains("-03114") _
                Or e.Exception.Message.ToString.Contains("-03135") _
                Or e.Exception.Message.ToString.Contains("TI_CONN") _
                Then

                'MsgBox(My.Resources.strings.ERROR_ORA_03113, MsgBoxStyle.Critical, "Connection Lost Unable to Continue")

                dialog_abort_program.g_s_issue = "Connection Lost Unable to Continue"
                dialog_abort_program.g_s_title = "Connection Lost Unable to Continue"
                dialog_abort_program.g_s_error = My.Resources.strings.ERROR_ORA_03113

                dialog_abort_program.ShowDialog()


                e.ExitApplication = True
            ElseIf main_form.TI_Conn.State = ConnectionState.Open Then
                Dim ti As New TI_Tools
                Dim mes As String = e.Exception.Message & vbCrLf & e.Exception.StackTrace
                Dim i As Int16

                If mes.Length < 1998 Then
                    i = mes.Length
                Else
                    i = 1997
                End If

                ti.write_xodot_signs_logging_exception("UNHANDLED", "VB.NET", "VB.NET", 0, e.Exception.HResult, mes.Substring(0, i))

                If e.Exception.HResult = -2147467259 Then
                    If e.Exception.Message.ToString.Contains("ORA-04068") _
                        Or e.Exception.Message.ToString.Contains("OCI-22303") _
                        Then

                        dialog_abort_program.g_s_issue = "Unable to Continue"
                        dialog_abort_program.g_s_title = "Unable to Continue"
                        dialog_abort_program.g_s_error = My.Resources.strings.ERROR_ORA_04068

                        dialog_abort_program.ShowDialog()
                        'MsgBox(My.Resources.strings.ERROR_ORA_04068, MsgBoxStyle.Critical, "Unable to Continue")
                        e.ExitApplication = True

                    End If
                End If


            Else

                Dim bp As New Broker_Processing
                bp.Log_issue(Broker_Processing.Log_source.SFA, "N/A", e.Exception.Message, e.Exception.StackTrace, , , "Unhandled Exception Logged, please alert a systems administrator")
            End If


            My.Application.Log.WriteException(e.Exception, TraceEventType.Critical, "Unhandled Exception.")

        End Sub
    End Class


End Namespace

