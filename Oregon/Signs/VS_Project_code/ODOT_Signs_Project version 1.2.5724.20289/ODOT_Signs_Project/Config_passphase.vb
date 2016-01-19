Imports System.Windows.Forms

Public Class dia_passphase

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        main_form.g_passphrase = TextBox1.Text

        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub dia_passphase_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Label1.Text = "Enter Pass Phrase.  Press Cancel to Resume Normal Operation"
        TextBox1.UseSystemPasswordChar = True
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.CheckState = CheckState.Checked Then
            TextBox1.UseSystemPasswordChar = False
        Else
            TextBox1.UseSystemPasswordChar = True
        End If
    End Sub
End Class
