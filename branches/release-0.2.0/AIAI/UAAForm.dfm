object AAForm: TAAForm
  Left = 547
  Top = 88
  Width = 305
  Height = 368
  Caption = #31777#26131'AA'#12456#12487#12451#12479
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      297
      20)
    object ComboBox: TComboBox
      Left = 0
      Top = 0
      Width = 297
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 16
      ItemHeight = 12
      TabOrder = 0
      OnSelect = ComboBoxSelect
    end
  end
  object Edit: TMemo
    Left = 0
    Top = 20
    Width = 297
    Height = 321
    Align = alClient
    PopupMenu = PopupMenu
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object PopupMenu: TPopupMenu
    Left = 160
    Top = 104
    object MenuSave: TMenuItem
      Caption = #20445#23384'(&S)'
      ShortCut = 16467
      OnClick = MenuSaveClick
    end
  end
end
