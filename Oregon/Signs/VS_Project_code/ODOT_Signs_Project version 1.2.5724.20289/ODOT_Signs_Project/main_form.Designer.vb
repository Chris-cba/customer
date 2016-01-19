<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class main_form
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
        Dim ListViewItem1 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("")
        Dim ListViewItem2 As System.Windows.Forms.ListViewItem = New System.Windows.Forms.ListViewItem("")
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(main_form))
        Me.but_sync = New System.Windows.Forms.Button()
        Me.LV_Tasks = New System.Windows.Forms.ListView()
        Me.ColumnHeader2 = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.TI_Conn = New Oracle.DataAccess.Client.OracleConnection()
        Me.OracleConnection1 = New Oracle.DataAccess.Client.OracleConnection()
        Me.GB_TEST = New System.Windows.Forms.GroupBox()
        Me.But_test = New System.Windows.Forms.Button()
        Me.cb_test = New System.Windows.Forms.ComboBox()
        Me.BW_ORA_CONNECT = New System.ComponentModel.BackgroundWorker()
        Me.lbl_crew = New System.Windows.Forms.Label()
        Me.BW_TASKS = New System.ComponentModel.BackgroundWorker()
        Me.CB_Debug = New System.Windows.Forms.CheckBox()
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip()
        Me.TSProgressBar1 = New System.Windows.Forms.ToolStripProgressBar()
        Me.TSStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel()
        Me.BW_TI_Tasks = New System.ComponentModel.BackgroundWorker()
        Me.GB_TEST.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'but_sync
        '
        Me.but_sync.Location = New System.Drawing.Point(237, 280)
        Me.but_sync.Name = "but_sync"
        Me.but_sync.Size = New System.Drawing.Size(149, 36)
        Me.but_sync.TabIndex = 0
        Me.but_sync.Text = "Process Sync Tasks"
        Me.but_sync.UseVisualStyleBackColor = True
        '
        'LV_Tasks
        '
        Me.LV_Tasks.BackColor = System.Drawing.SystemColors.Control
        Me.LV_Tasks.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader2})
        Me.LV_Tasks.Items.AddRange(New System.Windows.Forms.ListViewItem() {ListViewItem1, ListViewItem2})
        Me.LV_Tasks.Location = New System.Drawing.Point(26, 45)
        Me.LV_Tasks.MultiSelect = False
        Me.LV_Tasks.Name = "LV_Tasks"
        Me.LV_Tasks.Scrollable = False
        Me.LV_Tasks.Size = New System.Drawing.Size(567, 180)
        Me.LV_Tasks.TabIndex = 4
        Me.LV_Tasks.UseCompatibleStateImageBehavior = False
        Me.LV_Tasks.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Width = 92
        '
        'GB_TEST
        '
        Me.GB_TEST.Controls.Add(Me.But_test)
        Me.GB_TEST.Controls.Add(Me.cb_test)
        Me.GB_TEST.Location = New System.Drawing.Point(387, 266)
        Me.GB_TEST.Name = "GB_TEST"
        Me.GB_TEST.Size = New System.Drawing.Size(205, 62)
        Me.GB_TEST.TabIndex = 7
        Me.GB_TEST.TabStop = False
        Me.GB_TEST.Text = "testing"
        Me.GB_TEST.Visible = False
        '
        'But_test
        '
        Me.But_test.Location = New System.Drawing.Point(155, 22)
        Me.But_test.Name = "But_test"
        Me.But_test.Size = New System.Drawing.Size(38, 19)
        Me.But_test.TabIndex = 1
        Me.But_test.Text = "Button1"
        Me.But_test.UseVisualStyleBackColor = True
        '
        'cb_test
        '
        Me.cb_test.FormattingEnabled = True
        Me.cb_test.Location = New System.Drawing.Point(10, 21)
        Me.cb_test.Name = "cb_test"
        Me.cb_test.Size = New System.Drawing.Size(133, 21)
        Me.cb_test.TabIndex = 0
        '
        'BW_ORA_CONNECT
        '
        Me.BW_ORA_CONNECT.WorkerReportsProgress = True
        Me.BW_ORA_CONNECT.WorkerSupportsCancellation = True
        '
        'lbl_crew
        '
        Me.lbl_crew.AutoSize = True
        Me.lbl_crew.Location = New System.Drawing.Point(23, 15)
        Me.lbl_crew.Name = "lbl_crew"
        Me.lbl_crew.Padding = New System.Windows.Forms.Padding(0, 0, 3, 0)
        Me.lbl_crew.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lbl_crew.Size = New System.Drawing.Size(42, 13)
        Me.lbl_crew.TabIndex = 8
        Me.lbl_crew.Text = "Label1"
        Me.lbl_crew.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'BW_TASKS
        '
        Me.BW_TASKS.WorkerReportsProgress = True
        Me.BW_TASKS.WorkerSupportsCancellation = True
        '
        'CB_Debug
        '
        Me.CB_Debug.AutoSize = True
        Me.CB_Debug.Location = New System.Drawing.Point(12, 315)
        Me.CB_Debug.Name = "CB_Debug"
        Me.CB_Debug.Size = New System.Drawing.Size(131, 17)
        Me.CB_Debug.TabIndex = 9
        Me.CB_Debug.Text = "Show Message Boxes"
        Me.CB_Debug.UseVisualStyleBackColor = True
        Me.CB_Debug.Visible = False
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TSProgressBar1, Me.TSStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 337)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.StatusStrip1.Size = New System.Drawing.Size(623, 22)
        Me.StatusStrip1.SizingGrip = False
        Me.StatusStrip1.Stretch = False
        Me.StatusStrip1.TabIndex = 10
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'TSProgressBar1
        '
        Me.TSProgressBar1.Name = "TSProgressBar1"
        Me.TSProgressBar1.Size = New System.Drawing.Size(100, 16)
        Me.TSProgressBar1.Style = System.Windows.Forms.ProgressBarStyle.Continuous
        '
        'TSStatusLabel1
        '
        Me.TSStatusLabel1.Name = "TSStatusLabel1"
        Me.TSStatusLabel1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.TSStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'BW_TI_Tasks
        '
        Me.BW_TI_Tasks.WorkerReportsProgress = True
        Me.BW_TI_Tasks.WorkerSupportsCancellation = True
        '
        'main_form
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(623, 359)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.CB_Debug)
        Me.Controls.Add(Me.lbl_crew)
        Me.Controls.Add(Me.GB_TEST)
        Me.Controls.Add(Me.LV_Tasks)
        Me.Controls.Add(Me.but_sync)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "main_form"
        Me.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.GB_TEST.ResumeLayout(False)
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents but_sync As System.Windows.Forms.Button
    Friend WithEvents LV_Tasks As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents TI_Conn As Oracle.DataAccess.Client.OracleConnection
    Friend WithEvents OracleConnection1 As Oracle.DataAccess.Client.OracleConnection
    Friend WithEvents GB_TEST As System.Windows.Forms.GroupBox
    Friend WithEvents But_test As System.Windows.Forms.Button
    Friend WithEvents cb_test As System.Windows.Forms.ComboBox
    Friend WithEvents BW_ORA_CONNECT As System.ComponentModel.BackgroundWorker
    Friend WithEvents lbl_crew As System.Windows.Forms.Label
    Public WithEvents BW_TASKS As System.ComponentModel.BackgroundWorker
    Friend WithEvents CB_Debug As System.Windows.Forms.CheckBox
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents TSStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Public WithEvents TSProgressBar1 As System.Windows.Forms.ToolStripProgressBar
    Public WithEvents BW_TI_Tasks As System.ComponentModel.BackgroundWorker

End Class
