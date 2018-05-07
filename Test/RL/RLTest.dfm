object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Test - [Reinforrcenent Learning]'
  ClientHeight = 372
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 355
    Top = 241
    Width = 185
    Height = 128
    Caption = 'Learning:'
    TabOrder = 0
    object Label8: TLabel
      Left = 8
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Ciclo:'
    end
    object btnStart: TBitBtn
      Left = 3
      Top = 55
      Width = 75
      Height = 25
      Caption = 'Start'
      Enabled = False
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TBitBtn
      Left = 107
      Top = 55
      Width = 75
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnShowSol: TBitBtn
      Left = 10
      Top = 100
      Width = 166
      Height = 25
      Caption = 'Mostra Soluzione'
      Enabled = False
      TabOrder = 2
      OnClick = btnShowSolClick
    end
    object stCiclo: TStaticText
      Left = 40
      Top = 24
      Width = 89
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 355
    Top = 8
    Width = 185
    Height = 227
    Caption = 'Setting'
    TabOrder = 1
    object Bevel1: TBevel
      Left = 8
      Top = 126
      Width = 169
      Height = 17
      Shape = bsTopLine
    end
    object Label1: TLabel
      Left = 8
      Top = 19
      Width = 79
      Height = 13
      Caption = 'Algoritmo Appr.:'
    end
    object Label2: TLabel
      Left = 8
      Top = 46
      Width = 83
      Height = 13
      Caption = 'Fattori di Esplor.:'
    end
    object Label3: TLabel
      Left = 8
      Top = 73
      Width = 81
      Height = 13
      Caption = 'Fattore di Appr.:'
    end
    object Label4: TLabel
      Left = 8
      Top = 100
      Width = 63
      Height = 13
      Caption = 'Cicli di Appr.:'
    end
    object Label7: TLabel
      Left = 8
      Top = 145
      Width = 71
      Height = 13
      Caption = 'Ricomp. Move:'
    end
    object Label6: TLabel
      Left = 8
      Top = 172
      Width = 69
      Height = 13
      Caption = 'Ricomp. Muro:'
    end
    object Label5: TLabel
      Left = 8
      Top = 199
      Width = 89
      Height = 13
      Caption = 'Ricomp. Obiettivo:'
    end
    object edtRMove: TEdit
      Left = 97
      Top = 142
      Width = 80
      Height = 21
      TabOrder = 0
    end
    object cbAlgo: TComboBox
      Left = 96
      Top = 16
      Width = 81
      Height = 21
      ItemIndex = 0
      TabOrder = 1
      Text = 'Q-Learning'
      Items.Strings = (
        'Q-Learning'
        'Sarsa')
    end
    object edtEsplor: TEdit
      Left = 97
      Top = 43
      Width = 80
      Height = 21
      TabOrder = 2
    end
    object edtAppren: TEdit
      Left = 95
      Top = 70
      Width = 81
      Height = 21
      TabOrder = 3
    end
    object edtCicli: TEdit
      Left = 96
      Top = 97
      Width = 81
      Height = 21
      TabOrder = 4
    end
    object edtRMuro: TEdit
      Left = 96
      Top = 169
      Width = 81
      Height = 21
      TabOrder = 5
    end
    object edtRObiet: TEdit
      Left = 96
      Top = 196
      Width = 81
      Height = 21
      TabOrder = 6
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 361
    Caption = 'Mappa'
    TabOrder = 2
    object Label9: TLabel
      Left = 140
      Top = 331
      Width = 86
      Height = 13
      Caption = 'Dimensioni Griglia:'
    end
    object stDim: TStaticText
      Left = 244
      Top = 331
      Width = 72
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      TabOrder = 0
    end
    object btnLoad: TBitBtn
      Left = 16
      Top = 326
      Width = 75
      Height = 25
      Caption = 'Load'
      TabOrder = 1
      OnClick = btnLoadClick
    end
  end
  object sgCellWord: TAdvStringGrid
    Left = 20
    Top = 24
    Width = 304
    Height = 304
    Cursor = crDefault
    ColCount = 1
    DefaultColWidth = 30
    DefaultRowHeight = 30
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    ScrollBars = ssBoth
    TabOrder = 3
    HoverRowCells = [hcNormal, hcSelected]
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ControlLook.FixedGradientHoverFrom = clGray
    ControlLook.FixedGradientHoverTo = clWhite
    ControlLook.FixedGradientDownFrom = clGray
    ControlLook.FixedGradientDownTo = clSilver
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -11
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Visible = True
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -11
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Visible = True
    ControlLook.DropDownFooter.Buttons = <>
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDown.TextChecked = 'Checked'
    FilterDropDown.TextUnChecked = 'Unchecked'
    FilterDropDownClear = '(All)'
    FilterEdit.TypeNames.Strings = (
      'Starts with'
      'Ends with'
      'Contains'
      'Not contains'
      'Equal'
      'Not equal'
      'Clear')
    FixedColWidth = 30
    FixedRowHeight = 30
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    HoverButtons.Buttons = <>
    HoverButtons.Position = hbLeftFromColumnLeft
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'Tahoma'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    SearchFooter.FindNextCaption = 'Find &next'
    SearchFooter.FindPrevCaption = 'Find &previous'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    SearchFooter.HighLightCaption = 'Highlight'
    SearchFooter.HintClose = 'Close'
    SearchFooter.HintFindNext = 'Find next occurence'
    SearchFooter.HintFindPrev = 'Find previous occurence'
    SearchFooter.HintHighlight = 'Highlight occurences'
    SearchFooter.MatchCaseCaption = 'Match case'
    ShowSelection = False
    ShowDesignHelper = False
    SortSettings.DefaultFormat = ssAutomatic
    Version = '7.4.6.4'
  end
  object dlgOpen: TOpenDialog
    Left = 504
    Top = 248
  end
end
