object AdvAboneRegist: TAdvAboneRegist
  Left = 194
  Top = 201
  BorderStyle = bsToolWindow
  Caption = #25313#24373'NG'
  ClientHeight = 232
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 72
    Width = 49
    Height = 12
    Caption = 'NG Name'
  end
  object Label2: TLabel
    Left = 96
    Top = 48
    Width = 30
    Height = 12
    Caption = #12479#12452#12503
  end
  object Label3: TLabel
    Left = 344
    Top = 48
    Width = 55
    Height = 12
    Caption = #12461#12540#12527#12540#12489
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 44
    Height = 12
    Caption = 'NG Addr'
  end
  object Label5: TLabel
    Left = 8
    Top = 136
    Width = 31
    Height = 12
    Caption = 'NG ID'
  end
  object Label6: TLabel
    Left = 8
    Top = 168
    Width = 45
    Height = 12
    Caption = 'NG Word'
  end
  object Label7: TLabel
    Left = 240
    Top = 210
    Width = 44
    Height = 12
    Caption = #26399#38480'('#26085')'
  end
  object EditNGName: TEdit
    Left = 184
    Top = 72
    Width = 353
    Height = 20
    TabOrder = 0
    OnChange = EditNGChange
  end
  object ComboBoxNGNameType: TComboBox
    Left = 64
    Top = 72
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 1
    OnChange = ComboBoxNGChange
    Items.Strings = (
      #28961#35222
      #21547#12416
      #21547#12414#12394#12356
      #19968#33268
      #19981#19968#33268
      #27491#35215'('#21547#12416')'
      #27491#35215'('#21547#12414#12394#12356')')
  end
  object EditNGMail: TEdit
    Left = 184
    Top = 104
    Width = 353
    Height = 20
    TabOrder = 2
    OnChange = EditNGChange
  end
  object ComboBoxNGMailType: TComboBox
    Left = 64
    Top = 104
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 3
    OnChange = ComboBoxNGChange
    Items.Strings = (
      #28961#35222
      #21547#12416
      #21547#12414#12394#12356
      #19968#33268
      #19981#19968#33268
      #27491#35215'('#21547#12416')'
      #27491#35215'('#21547#12414#12394#12356')')
  end
  object EditNGId: TEdit
    Left = 184
    Top = 136
    Width = 353
    Height = 20
    TabOrder = 4
    OnChange = EditNGChange
  end
  object ComboBoxNGIdType: TComboBox
    Left = 64
    Top = 136
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 5
    OnChange = ComboBoxNGChange
    Items.Strings = (
      #28961#35222
      #21547#12416
      #21547#12414#12394#12356
      #19968#33268
      #19981#19968#33268
      #27491#35215'('#21547#12416')'
      #27491#35215'('#21547#12414#12394#12356')')
  end
  object ComboBoxNGWordType: TComboBox
    Left = 64
    Top = 168
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 6
    OnChange = ComboBoxNGChange
    Items.Strings = (
      #28961#35222
      #21547#12416
      #21547#12414#12394#12356
      #19968#33268
      #19981#19968#33268
      #27491#35215'('#21547#12416')'
      #27491#35215'('#21547#12414#12394#12356')')
  end
  object ButtonOK: TButton
    Left = 368
    Top = 200
    Width = 75
    Height = 25
    Caption = #12424#12429#12375
    ModalResult = 1
    TabOrder = 7
  end
  object ButtonCancel: TButton
    Left = 456
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12420#12417#12427
    ModalResult = 2
    TabOrder = 8
  end
  object ComboBoxAboneType: TComboBox
    Left = 120
    Top = 206
    Width = 105
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 9
    OnChange = MiscOnChange
    Items.Strings = (
      #27161#28310#12354#12412#65374#12435
      #36879#26126#12354#12412#65374#12435
      #37325#35201#12461#12540#12527#12540#12489)
  end
  object SpinEditLifeSpan: TJLXPSpinEdit
    Left = 296
    Top = 206
    Width = 49
    Height = 21
    MaxValue = 999
    MinValue = -1
    TabOrder = 10
    Value = -1
    OnChange = MiscOnChange
  end
  object EditName: TEdit
    Left = 8
    Top = 8
    Width = 441
    Height = 20
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 11
    OnExit = EditNameExit
  end
  object EditNGWord: TEdit
    Left = 184
    Top = 168
    Width = 353
    Height = 20
    TabOrder = 12
    OnChange = EditNGChange
  end
  object ButtonRename: TButton
    Left = 456
    Top = 8
    Width = 81
    Height = 20
    Caption = #30331#37682#21517#22793#26356
    TabOrder = 13
    OnClick = ButtonRenameClick
  end
end
