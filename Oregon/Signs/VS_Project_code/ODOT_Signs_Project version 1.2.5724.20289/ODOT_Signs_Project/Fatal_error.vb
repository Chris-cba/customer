Imports System.Windows.Forms

Public Class dialog_abort_program
    Public g_s_issue As String
    Public g_s_title As String = "Fatal Error"
    Public g_s_error As String

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub dialog_abort_program_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = g_s_title
        TB_issue.Text = g_s_issue
        TB_Error.Text = g_s_error
    End Sub
End Class
