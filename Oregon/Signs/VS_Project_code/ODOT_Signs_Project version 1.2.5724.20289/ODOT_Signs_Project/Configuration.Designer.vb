<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Configuration
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Configuration))
        Me.lbl1 = New System.Windows.Forms.Label()
        Me.lbl2 = New System.Windows.Forms.Label()
        Me.lbl3 = New System.Windows.Forms.Label()
        Me.tb1 = New System.Windows.Forms.TextBox()
        Me.tb2 = New System.Windows.Forms.TextBox()
        Me.TB3 = New System.Windows.Forms.TextBox()
        Me.but_cancel = New System.Windows.Forms.Button()
        Me.but_test = New System.Windows.Forms.Button()
        Me.but_save = New System.Windows.Forms.Button()
        Me.TransInfo1 = New Oracle.DataAccess.Client.OracleConnection()
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.BackgroundWorker1 = New System.ComponentModel.BackgroundWorker()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.but_FO = New System.Windows.Forms.Button()
        Me.tb_Apath = New System.Windows.Forms.TextBox()
        Me.of_Access = New System.Windows.Forms.OpenFileDialog()
        Me.StatusStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'lbl1
        '
        Me.lbl1.AutoSize = True
        Me.lbl1.Location = New System.Drawing.Point(3, 53)
        Me.lbl1.Name = "lbl1"
        Me.lbl1.Size = New System.Drawing.Size(39, 13)
        Me.lbl1.TabIndex = 0
        Me.lbl1.Text = "Label1"
        '
        'lbl2
        '
        Me.lbl2.AutoSize = True
        Me.lbl2.Location = New System.Drawing.Point(265, 52)
        Me.lbl2.Name = "lbl2"
        Me.lbl2.Size = New System.Drawing.Size(39, 13)
        Me.lbl2.TabIndex = 1
        Me.lbl2.Text = "Label1"
        '
        'lbl3
        '
        Me.lbl3.AutoSize = True
        Me.lbl3.Location = New System.Drawing.Point(3, 115)
        Me.lbl3.Name = "lbl3"
        Me.lbl3.Size = New System.Drawing.Size(39, 13)
        Me.lbl3.TabIndex = 2
        Me.lbl3.Text = "Label1"
        '
        'tb1
        '
        Me.tb1.Location = New System.Drawing.Point(99, 49)
        Me.tb1.Name = "tb1"
        Me.tb1.Size = New System.Drawing.Size(134, 20)
        Me.tb1.TabIndex = 3
        '
        'tb2
        '
        Me.tb2.Location = New System.Drawing.Point(380, 48)
        Me.tb2.Name = "tb2"
        Me.tb2.Size = New System.Drawing.Size(134, 20)
        Me.tb2.TabIndex = 4
        '
        'TB3
        '
        Me.TB3.Location = New System.Drawing.Point(99, 112)
        Me.TB3.Multiline = True
        Me.TB3.Name = "TB3"
        Me.TB3.Size = New System.Drawing.Size(415, 68)
        Me.TB3.TabIndex = 5
        '
        'but_cancel
        '
        Me.but_cancel.Location = New System.Drawing.Point(6, 192)
        Me.but_cancel.Name = "but_cancel"
        Me.but_cancel.Size = New System.Drawing.Size(149, 36)
        Me.but_cancel.TabIndex = 6
        Me.but_cancel.Text = "can"
        Me.but_cancel.UseVisualStyleBackColor = True
        '
        'but_test
        '
        Me.but_test.Location = New System.Drawing.Point(185, 192)
        Me.but_test.Name = "but_test"
        Me.but_test.Size = New System.Drawing.Size(149, 36)
        Me.but_test.TabIndex = 7
        Me.but_test.Text = "test"
        Me.but_test.UseVisualStyleBackColor = True
        '
        'but_save
        '
        Me.but_save.Location = New System.Drawing.Point(365, 192)
        Me.but_save.Name = "but_save"
        Me.but_save.Size = New System.Drawing.Size(149, 36)
        Me.but_save.TabIndex = 8
        Me.but_save.Text = "save"
        Me.but_save.UseVisualStyleBackColor = True
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 385)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(556, 22)
        Me.StatusStrip1.TabIndex = 9
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(121, 17)
        Me.ToolStripStatusLabel1.Text = "ToolStripStatusLabel1"
        '
        'BackgroundWorker1
        '
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.but_cancel)
        Me.GroupBox1.Controls.Add(Me.lbl1)
        Me.GroupBox1.Controls.Add(Me.but_save)
        Me.GroupBox1.Controls.Add(Me.lbl2)
        Me.GroupBox1.Controls.Add(Me.but_test)
        Me.GroupBox1.Controls.Add(Me.lbl3)
        Me.GroupBox1.Controls.Add(Me.tb1)
        Me.GroupBox1.Controls.Add(Me.TB3)
        Me.GroupBox1.Controls.Add(Me.tb2)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 141)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(531, 239)
        Me.GroupBox1.TabIndex = 10
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "GroupBox1"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.but_FO)
        Me.GroupBox2.Controls.Add(Me.tb_Apath)
        Me.GroupBox2.Location = New System.Drawing.Point(12, 12)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(531, 123)
        Me.GroupBox2.TabIndex = 9
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "GroupBox2"
        '
        'but_FO
        '
        Me.but_FO.Location = New System.Drawing.Point(487, 21)
        Me.but_FO.Name = "but_FO"
        Me.but_FO.Size = New System.Drawing.Size(26, 20)
        Me.but_FO.TabIndex = 1
        Me.but_FO.Text = "..."
        Me.but_FO.UseVisualStyleBackColor = True
        '
        'tb_Apath
        '
        Me.tb_Apath.Location = New System.Drawing.Point(17, 22)
        Me.tb_Apath.Name = "tb_Apath"
        Me.tb_Apath.Size = New System.Drawing.Size(465, 20)
        Me.tb_Apath.TabIndex = 0
        '
        'of_Access
        '
        Me.of_Access.AddExtension = False
        Me.of_Access.FileName = "OpenFileDialog1"
        '
        'Configuration
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(556, 407)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "Configuration"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Configuration"
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lbl1 As System.Windows.Forms.Label
    Friend WithEvents lbl2 As System.Windows.Forms.Label
    Friend WithEvents lbl3 As System.Windows.Forms.Label
    Friend WithEvents tb1 As System.Windows.Forms.TextBox
    Friend WithEvents tb2 As System.Windows.Forms.TextBox
    Friend WithEvents TB3 As System.Windows.Forms.TextBox
    Friend WithEvents but_cancel As System.Windows.Forms.Button
    Friend WithEvents but_test As System.Windows.Forms.Button
    Friend WithEvents but_save As System.Windows.Forms.Button
    Friend WithEvents TransInfo1 As Oracle.DataAccess.Client.OracleConnection
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents BackgroundWorker1 As System.ComponentModel.BackgroundWorker
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents but_FO As System.Windows.Forms.Button
    Friend WithEvents tb_Apath As System.Windows.Forms.TextBox
    Friend WithEvents of_Access As System.Windows.Forms.OpenFileDialog
End Class
