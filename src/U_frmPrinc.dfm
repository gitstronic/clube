object frmPrinc: TfrmPrinc
  Left = 0
  Top = 0
  Caption = 'frmPrinc'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnActivate = FormActivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GB: TGroupBox
    Left = 0
    Top = 0
    Width = 503
    Height = 321
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 3
      Top = 3
      Width = 497
      Height = 121
      Color = clBtnFace
      DataSource = DSaldos
      DrawingStyle = gdsGradient
      Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'ContaCorrente'
          Title.Caption = 'Conta Corrente'
          Width = 274
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Saldo'
          Width = 200
          Visible = True
        end>
    end
    object GroupBox2: TGroupBox
      Left = 3
      Top = 132
      Width = 497
      Height = 186
      Caption = 'Transa'#231#227'o entre contas:'
      TabOrder = 1
      object lblCDeb: TLabel
        Left = 16
        Top = 26
        Width = 67
        Height = 13
        Caption = 'Conta D'#233'bito:'
      end
      object lblCCred: TLabel
        Left = 189
        Top = 26
        Width = 71
        Height = 13
        Caption = 'Conta Cr'#233'dito:'
      end
      object Label1: TLabel
        Left = 167
        Top = 45
        Width = 16
        Height = 13
        Caption = '=>'
      end
      object Label2: TLabel
        Left = 365
        Top = 26
        Width = 81
        Height = 13
        Caption = 'Valor Transa'#231#227'o:'
      end
      object dblContaDebito: TDBLookupComboBox
        Left = 16
        Top = 42
        Width = 145
        Height = 21
        KeyField = 'id'
        ListField = 'descricao'
        ListSource = DContaDebito
        TabOrder = 0
      end
      object dblContaCredito: TDBLookupComboBox
        Left = 189
        Top = 42
        Width = 145
        Height = 21
        KeyField = 'id'
        ListField = 'descricao'
        ListSource = DContaCredito
        TabOrder = 1
      end
      object btnTransaction: TBitBtn
        Left = 336
        Top = 143
        Width = 150
        Height = 35
        Caption = 'Efetuar Transa'#231#227'o!'
        TabOrder = 2
        OnClick = btnTransactionClick
      end
      object edtValor: TEdit
        Left = 365
        Top = 42
        Width = 121
        Height = 21
        Alignment = taRightJustify
        MaxLength = 20
        TabOrder = 3
        Text = 'R$'
        OnEnter = edtValorEnter
        OnExit = edtValorExit
        OnKeyPress = edtValorKeyPress
      end
      object GroupBox3: TGroupBox
        Left = 80
        Top = 69
        Width = 337
        Height = 68
        Caption = 'Previs'#227'o de transa'#231#227'o:'
        Enabled = False
        TabOrder = 4
        object ledSaldoDebito: TLabeledEdit
          Left = 24
          Top = 32
          Width = 121
          Height = 21
          Alignment = taRightJustify
          Color = clBtnFace
          EditLabel.Width = 96
          EditLabel.Height = 13
          EditLabel.Caption = 'Saldo Conta D'#233'bito:'
          TabOrder = 0
        end
        object ledSaldoCredito: TLabeledEdit
          Left = 197
          Top = 32
          Width = 121
          Height = 21
          Alignment = taRightJustify
          Color = clBtnFace
          EditLabel.Width = 100
          EditLabel.Height = 13
          EditLabel.Caption = 'Saldo Conta Cr'#233'dito:'
          TabOrder = 1
        end
      end
    end
  end
  object DSaldos: TDataSource
    DataSet = DM.aqySaldos
    Left = 760
    Top = 8
  end
  object DContaDebito: TDataSource
    DataSet = DM.aqyContaDebito
    Left = 592
    Top = 24
  end
  object Refresh: TTimer
    Interval = 5000
    OnTimer = RefreshTimer
    Left = 712
    Top = 32
  end
  object DContaCredito: TDataSource
    DataSet = DM.aqyContaCredito
    Left = 624
    Top = 80
  end
end
