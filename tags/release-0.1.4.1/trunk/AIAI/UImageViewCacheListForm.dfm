object ImageViewCacheListForm: TImageViewCacheListForm
  Left = 188
  Top = 114
  Width = 671
  Height = 403
  Caption = #12461#12515#12483#12471#12517#19968#35239
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 0
    Top = 121
    Width = 663
    Height = 4
    Cursor = crVSplit
    Align = alTop
  end
  object ListViewCache: TListView
    Left = 0
    Top = 125
    Width = 663
    Height = 232
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    Columns = <
      item
        Caption = 'URL'
        Width = 130
      end
      item
        Caption = 'LastAccess'
        Width = 80
      end
      item
        Caption = 'ContentType'
        Width = 80
      end
      item
        Caption = 'Status'
      end
      item
        Caption = 'Name'
        Width = 270
      end>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewCacheColumnClick
    OnDblClick = ListViewCacheDblClick
    OnMouseMove = ListViewCacheMouseMove
    OnSelectItem = ListViewCacheSelectItem
  end
  object PanelPreview: TPanel
    Left = 0
    Top = 0
    Width = 663
    Height = 121
    Align = alTop
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 116
      Top = 1
      Width = 4
      Height = 119
      Cursor = crHSplit
      Align = alRight
    end
    object Memo: TMemo
      Left = 120
      Top = 1
      Width = 542
      Height = 119
      Align = alRight
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object StatusBar: TJLXPStatusBar
    Left = 0
    Top = 357
    Width = 663
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object ProgressBar: TProgressBar
    Left = 432
    Top = 361
    Width = 198
    Height = 13
    Align = alCustom
    Min = 0
    Max = 100
    TabOrder = 3
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 320
    Top = 184
    object MenuItemRelease: TMenuItem
      Caption = #36984#25246#35299#38500'(&Z)'
      ShortCut = 27
      OnClick = MenuItemReleaseClick
    end
    object MenuItemSelectAll: TMenuItem
      Caption = #20840#12390#36984#25246'(&A)'
      OnClick = MenuItemSelectAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItemOpen: TMenuItem
      Caption = #38283#12367'(&O)'
      OnClick = MenuItemOpenClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuItemCopyURL: TMenuItem
      Caption = 'URL'#12434#12467#12500#12540'(&U)'
      OnClick = MenuItemCopyURLClick
    end
    object MenuItemCopyCacheName: TMenuItem
      Caption = #12461#12515#12483#12471#12517#12398#12501#12449#12452#12523#21517#12434#12467#12500#12540'(&C)'
      OnClick = MenuItemCopyCacheNameClick
    end
    object MenuItemDelCache: TMenuItem
      Caption = #12461#12515#12483#12471#12517#12434#21066#38500'(&D)'
      ShortCut = 46
      OnClick = MenuItemDelCacheClick
    end
    object MenuItemBrocra: TMenuItem
      Caption = #12502#12521#12463#12521'(&B)'
      OnClick = MenuItemBrocraClick
    end
  end
end
