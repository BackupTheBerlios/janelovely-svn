object GetBoardListForm: TGetBoardListForm
  Left = 352
  Top = 279
  Width = 313
  Height = 171
  Caption = #12508#12540#12489#19968#35239#12398#21462#24471
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object MessageLabel1: TLabel
    Left = 16
    Top = 16
    Width = 4
    Height = 12
  end
  object MessageLabel2: TLabel
    Left = 16
    Top = 80
    Width = 174
    Height = 12
    Caption = #12414#12391#12508#12540#12489#19968#35239#21462#12426#12395#34892#12367#12435#12420#12424#65374
  end
  object ComboBoxURL: TComboBox
    Left = 8
    Top = 48
    Width = 289
    Height = 20
    ItemHeight = 12
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 72
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object ButtonCancel: TButton
    Left = 168
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
