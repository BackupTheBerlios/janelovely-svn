object SavePointDialog: TSavePointDialog
  Left = 422
  Top = 278
  Width = 553
  Height = 134
  Caption = #22266#23450#12475#12540#12502#12509#12452#12531#12488#12398#32232#38598
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClick = ebChange
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object Label1: TLabel
    Left = 52
    Top = 45
    Width = 30
    Height = 15
    Caption = #22580#25152
  end
  object Label2: TLabel
    Left = 10
    Top = 10
    Width = 73
    Height = 15
    Caption = #12461#12515#12503#12471#12519#12531
  end
  object ebCaption: TEdit
    Left = 92
    Top = 10
    Width = 173
    Height = 20
    TabOrder = 0
    OnChange = ebChange
  end
  object ebLocation: TEdit
    Left = 92
    Top = 40
    Width = 445
    Height = 20
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = ebChange
  end
  object btnSelectLocation: TButton
    Left = 500
    Top = 10
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = btnSelectLocationClick
  end
  object btnOK: TButton
    Left = 340
    Top = 70
    Width = 94
    Height = 27
    Caption = #12424#12429#12375
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 440
    Top = 70
    Width = 94
    Height = 27
    Caption = #12420#12417#12427
    ModalResult = 2
    TabOrder = 4
  end
end
