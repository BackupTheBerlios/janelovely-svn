object NewsSettingForm: TNewsSettingForm
  Left = 412
  Top = 292
  Width = 213
  Height = 136
  Caption = #12491#12517#12540#12473#20999#26367#38291#38548#12398#35373#23450
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
    Left = 12
    Top = 28
    Width = 110
    Height = 12
    Caption = '5'#31186#38291#38548#12289'10'#31186#65374'60'#31186
  end
  object ButtonOK: TButton
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object ButtonCancel: TButton
    Left = 112
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SpinEditNewsInterval: TJLXPSpinEdit
    Left = 136
    Top = 24
    Width = 49
    Height = 21
    Increment = 5
    MaxValue = 60
    MinValue = 10
    TabOrder = 2
    Value = 10
  end
end
