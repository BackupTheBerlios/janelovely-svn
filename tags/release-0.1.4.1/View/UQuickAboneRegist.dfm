object QuickAboneRegist: TQuickAboneRegist
  Left = 285
  Top = 220
  Width = 500
  Height = 302
  BorderIcons = [biSystemMenu, biMaximize]
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 500
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 242
    Width = 492
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      492
      33)
    object Label1: TLabel
      Left = 184
      Top = 10
      Width = 44
      Height = 12
      Caption = #26399#38480'('#26085')'
    end
    object btnRegister: TButton
      Left = 356
      Top = 4
      Width = 54
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #30331#37682
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 420
      Top = 4
      Width = 62
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      TabOrder = 1
    end
    object btnSelectAll: TButton
      Left = 0
      Top = 4
      Width = 65
      Height = 25
      Caption = #20840#36984#25246
      TabOrder = 2
      OnClick = btnSelectAllClick
    end
    object cmbAboneType: TComboBox
      Left = 72
      Top = 6
      Width = 105
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 3
      Items.Strings = (
        #27161#28310#12354#12412#65374#12435
        #36879#26126#12354#12412#65374#12435
        #37325#35201#12461#12540#12527#12540#12489)
    end
    object seLifeSpan: TJLXPSpinEdit
      Left = 240
      Top = 6
      Width = 49
      Height = 21
      MaxValue = 999
      MinValue = -1
      TabOrder = 4
      Value = -1
    end
    object btnQuickAbone: TButton
      Left = 304
      Top = 4
      Width = 43
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #31777#26131
      ModalResult = 6
      TabOrder = 5
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 416
    Top = 168
    object PopupCopy: TMenuItem
      Caption = #12467#12500#12540'(&C)'
      OnClick = PopupCopyClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PopupSelectAll: TMenuItem
      Caption = #12377#12409#12390#36984#25246'(&A)'
      OnClick = PopupSelectAllClick
    end
  end
end
