object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Test [Rete Neurale - BackPropagation Learning]'
  ClientHeight = 325
  ClientWidth = 778
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
  object Chart1: TChart
    Left = 263
    Top = 8
    Width = 313
    Height = 313
    Legend.Visible = False
    Title.Text.Strings = (
      'Errori')
    BottomAxis.LogarithmicBase = 2.718281828459050000
    RightAxis.Visible = False
    TopAxis.Visible = False
    View3D = False
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 17
    object Grafico: TLineSeries
      Brush.BackColor = clDefault
      Pointer.Brush.Gradient.EndColor = 16711842
      Pointer.Gradient.EndColor = 16711842
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        0019000000000000000000044000000000000024400000000000804B40000000
        0000404F400000000000C0424000000000002062400000000000906A40000000
        0000987240000000000078794000000000009872400000000000E06F40000000
        0000B06340000000000000444000000000002052400000000000C05740000000
        0000C04C400000000000805B400000000000106D400000000000A07440000000
        0000506E400000000000B8754000000000005074400000000000D87840000000
        000018804000000000002C8040}
    end
  end
  object grp1: TGroupBox
    Left = 582
    Top = 8
    Width = 187
    Height = 313
    Caption = 'Rete Neurale:'
    TabOrder = 1
    object bvl1: TBevel
      Left = 7
      Top = 254
      Width = 169
      Height = 9
      Shape = bsTopLine
      Style = bsRaised
    end
    object lbl1: TLabel
      Left = 8
      Top = 227
      Width = 30
      Height = 13
      Caption = 'Errore'
    end
    object lbl2: TLabel
      Left = 8
      Top = 193
      Width = 26
      Height = 13
      Caption = 'Ciclo:'
    end
    object bvl2: TBevel
      Left = 8
      Top = 178
      Width = 169
      Height = 9
      Shape = bsTopLine
      Style = bsRaised
    end
    object lbl3: TLabel
      Left = 8
      Top = 154
      Width = 63
      Height = 13
      Caption = 'Cicli di Appr.:'
    end
    object lbl4: TLabel
      Left = 8
      Top = 127
      Width = 64
      Height = 13
      Caption = 'Errore Limite:'
    end
    object lbl5: TLabel
      Left = 8
      Top = 100
      Width = 81
      Height = 13
      Caption = 'Val. Alpha Sigm.:'
    end
    object lbl6: TLabel
      Left = 8
      Top = 73
      Width = 48
      Height = 13
      Caption = 'Momento:'
    end
    object lbl7: TLabel
      Left = 8
      Top = 46
      Width = 81
      Height = 13
      Caption = 'Fattore di Appr.:'
    end
    object lbl8: TLabel
      Left = 8
      Top = 19
      Width = 73
      Height = 13
      Caption = 'Tipo Sigmoide.:'
    end
    object btnStart: TBitBtn
      Left = 8
      Top = 269
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object stErrore: TStaticText
      Left = 56
      Top = 225
      Width = 121
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      TabOrder = 1
    end
    object stCiclo: TStaticText
      Left = 56
      Top = 193
      Width = 121
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSingle
      TabOrder = 2
    end
    object edtCicli: TEdit
      Left = 96
      Top = 151
      Width = 81
      Height = 21
      TabOrder = 3
    end
    object edtErrLim: TEdit
      Left = 95
      Top = 124
      Width = 81
      Height = 21
      TabOrder = 4
    end
    object edtAlpha: TEdit
      Left = 95
      Top = 97
      Width = 81
      Height = 21
      TabOrder = 5
    end
    object edtMomento: TEdit
      Left = 97
      Top = 70
      Width = 80
      Height = 21
      TabOrder = 6
    end
    object edtAppren: TEdit
      Left = 95
      Top = 43
      Width = 81
      Height = 21
      TabOrder = 7
    end
    object cbTipoSig: TComboBox
      Left = 96
      Top = 16
      Width = 81
      Height = 21
      ItemIndex = 0
      TabOrder = 8
      Text = 'Unipolare'
      Items.Strings = (
        'Unipolare'
        'Bipolare')
    end
    object btnStop: TBitBtn
      Left = 104
      Top = 269
      Width = 75
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 9
      OnClick = btnStopClick
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 313
    Caption = 'Errori:'
    TabOrder = 2
    object mErrori: TMemo
      Left = 3
      Top = 16
      Width = 232
      Height = 289
      Lines.Strings = (
        'mErrori')
      TabOrder = 0
    end
  end
end
