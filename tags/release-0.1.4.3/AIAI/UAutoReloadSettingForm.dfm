object AutoReloadSettingForm: TAutoReloadSettingForm
  Left = 417
  Top = 257
  Width = 247
  Height = 107
  Caption = #12458#12540#12488#12522#12525#12540#12489#38291#38548#12398#35373#23450
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 11
    Top = 13
    Width = 116
    Height = 12
    Caption = #21336#20301#12399#31186#12290'1'#31186#65374'120'#31186
    Layout = tlCenter
  end
  object OKButton: TButton
    Left = 40
    Top = 46
    Width = 49
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object IntervalSpinEdit: TJLXPSpinEdit
    Left = 138
    Top = 11
    Width = 41
    Height = 21
    MaxValue = 120
    MinValue = 1
    TabOrder = 1
    Value = 5
  end
  object CancelButton: TButton
    Left = 136
    Top = 47
    Width = 57
    Height = 25
    Caption = 'Cancel'
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
  end
  object DefaultButton: TButton
    Left = 184
    Top = 10
    Width = 49
    Height = 20
    Caption = #21462#28040
    TabOrder = 3
    OnClick = DefaultButtonClick
  end
end
