object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmLogin'
  ClientHeight = 194
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LOGIN: TLabeledEdit
    Left = 48
    Top = 40
    Width = 156
    Height = 21
    CharCase = ecLowerCase
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Usu'#225'rio:'
    TabOrder = 0
  end
  object PASS: TLabeledEdit
    Left = 48
    Top = 88
    Width = 156
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = 'Senha:'
    PasswordChar = '*'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 136
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 129
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 3
  end
  object STATUS: TStatusBar
    Left = 0
    Top = 175
    Width = 259
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
end
