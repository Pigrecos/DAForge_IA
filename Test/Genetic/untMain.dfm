object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Traveling Salesman Problem using Genetic Algorithms'
  ClientHeight = 534
  ClientWidth = 709
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
    Left = 8
    Top = 8
    Width = 462
    Height = 513
    Caption = 'Map'
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 482
      Width = 49
      Height = 13
      Caption = 'N.'#176' Citt'#224' :'
    end
    object edtNumCitta: TEdit
      Left = 64
      Top = 481
      Width = 65
      Height = 21
      TabOrder = 0
      Text = 'edtNumCitta'
    end
    object btnGenMappa: TBitBtn
      Left = 160
      Top = 477
      Width = 105
      Height = 25
      Caption = 'Generate'
      TabOrder = 1
      OnClick = btnGenMappaClick
    end
    object Panel1: TPanel
      Left = 3
      Top = 16
      Width = 440
      Height = 440
      TabOrder = 2
      object PaintBox1: TPaintBox
        Left = 1
        Top = 1
        Width = 438
        Height = 438
        Align = alClient
        ExplicitLeft = 0
        ExplicitWidth = 348
        ExplicitHeight = 348
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 476
    Top = 8
    Width = 227
    Height = 226
    Caption = 'Setting'
    TabOrder = 1
    object Label2: TLabel
      Left = 6
      Top = 27
      Width = 89
      Height = 13
      Caption = 'Num. Popolazione:'
    end
    object Label3: TLabel
      Left = 6
      Top = 67
      Width = 99
      Height = 13
      Caption = 'Metodo di Selezione:'
    end
    object Label4: TLabel
      Left = 6
      Top = 187
      Width = 41
      Height = 13
      Caption = 'Cicli N.'#176':'
    end
    object Label5: TLabel
      Left = 168
      Top = 206
      Width = 43
      Height = 11
      Alignment = taCenter
      Caption = '(0-Infinito)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtNumPopolazione: TEdit
      Left = 159
      Top = 24
      Width = 65
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
    object cbMetodSelezione: TComboBox
      Left = 112
      Top = 64
      Width = 112
      Height = 21
      ItemIndex = 0
      TabOrder = 1
      Text = 'Elite'
      Items.Strings = (
        'Elite'
        'Rank'
        'Roulette')
    end
    object cbGreedyCroosover: TCheckBox
      Left = 6
      Top = 112
      Width = 150
      Height = 17
      Caption = 'Greedy Crossover'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object edtNumCicli: TEdit
      Left = 159
      Top = 184
      Width = 65
      Height = 21
      TabOrder = 3
      Text = 'Edit1'
    end
  end
  object GroupBox3: TGroupBox
    Left = 473
    Top = 240
    Width = 227
    Height = 105
    Caption = 'Ciclo Attuale'
    TabOrder = 2
    object Label6: TLabel
      Left = 17
      Top = 27
      Width = 26
      Height = 13
      Caption = 'Ciclo:'
    end
    object Label7: TLabel
      Left = 17
      Top = 67
      Width = 100
      Height = 13
      Caption = 'Lunghezza percorso:'
    end
    object edtCicloCur: TEdit
      Left = 159
      Top = 24
      Width = 65
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
      Text = 'Edit1'
    end
    object edtPathLen: TEdit
      Left = 135
      Top = 64
      Width = 89
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object btnStart: TBitBtn
    Left = 476
    Top = 351
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = btnStartClick
  end
  object btnStop: TBitBtn
    Left = 625
    Top = 351
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 4
  end
end
