object MainWnd: TMainWnd
  Left = 147
  Top = 82
  AutoScroll = False
  Caption = 'Jane2ch'
  ClientHeight = 552
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS UI Gothic'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel0: TPanel
    Left = 0
    Top = 0
    Width = 729
    Height = 533
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LogSplitter: TSplitter
      Left = 0
      Top = 511
      Width = 729
      Height = 2
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      MinSize = 1
      ResizeStyle = rsUpdate
    end
    object Panel1: TPanel
      Left = 4
      Top = 51
      Width = 725
      Height = 460
      Align = alClient
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnResize = Panel1Resize
      object BoardSplitter: TSplitter
        Left = 120
        Top = 0
        Width = 4
        Height = 460
        Cursor = crHSplit
        AutoSnap = False
        MinSize = 4
        Visible = False
      end
      object Panel2: TPanel
        Left = 124
        Top = 0
        Width = 601
        Height = 460
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object ThreadSplitter: TSplitter
          Left = 0
          Top = 145
          Width = 601
          Height = 4
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          MinSize = 1
        end
        object WebPanel: TPanel
          Left = 0
          Top = 149
          Width = 601
          Height = 311
          Align = alClient
          BevelOuter = bvNone
          Color = clWindow
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS UI Gothic'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnEnter = WebPanelEnter
          OnResize = WebPanelResize
          object WritePanelSplitter: TSplitter
            Left = 0
            Top = 109
            Width = 601
            Height = 2
            Cursor = crVSplit
            Align = alBottom
            AutoSnap = False
            MinSize = 25
          end
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 601
            Height = 1
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
          end
          object Panel3: TPanel
            Left = 0
            Top = 1
            Width = 601
            Height = 48
            Align = alTop
            Alignment = taLeftJustify
            AutoSize = True
            BevelOuter = bvLowered
            TabOrder = 1
            object TabBarPanel: TPanel
              Left = 1
              Top = 1
              Width = 599
              Height = 24
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object TabPanel: TPanel
                Left = 0
                Top = 0
                Width = 599
                Height = 24
                Align = alClient
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnDragDrop = TabPanelDragDrop
                OnDragOver = TabPanelDragOver
                OnMouseMove = TabPanelMouseMove
                object TabControl: TTabControl
                  Left = 1
                  Top = 1
                  Width = 597
                  Height = 22
                  Align = alClient
                  Images = ListImages
                  OwnerDraw = True
                  PopupMenu = ThreadPopupMenu
                  Style = tsFlatButtons
                  TabHeight = 20
                  TabOrder = 0
                  TabStop = False
                  OnChange = TabControlChange
                  OnDragDrop = TabControlDragDrop
                  OnDragOver = TabControlDragOver
                  OnDrawTab = TabControlDrawTab
                  OnGetImageIndex = TabControlGetImageIndex
                  OnMouseDown = TabControlMouseDown
                  OnMouseMove = TabControlMouseMove
                end
              end
            end
            object ThreadToolPanel: TPanel
              Left = 1
              Top = 25
              Width = 599
              Height = 22
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Font.Charset = SHIFTJIS_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'MS UI Gothic'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              DesignSize = (
                599
                22)
              object ThreadTitleLabel: TLabel
                Left = 8
                Top = 0
                Width = 756
                Height = 22
                Anchors = [akLeft, akTop, akRight, akBottom]
                AutoSize = False
                Color = clBtnFace
                Font.Charset = SHIFTJIS_CHARSET
                Font.Color = clWhite
                Font.Height = -12
                Font.Name = 'MS UI Gothic'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                ShowAccelChar = False
                Transparent = True
                Layout = tlCenter
                OnClick = ThreadTitleLabelClick
                OnDblClick = actReloadExecute
                OnMouseDown = ThreadTitleLabelMouseDown
                OnMouseMove = ThreadTitleLabelMouseMove
              end
              object ThreadToolBar: TJLXPToolBar
                Left = 308
                Top = 0
                Width = 291
                Height = 22
                Align = alRight
                AutoSize = True
                Caption = 'ThreadToolBar'
                EdgeBorders = []
                EdgeOuter = esNone
                Flat = True
                Font.Charset = SHIFTJIS_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
                Font.Style = []
                Images = ThreadToolImages
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                Transparent = True
                Wrapable = False
                OnMouseMove = ThreadToolBarMouseMove
                object AutoReScButton: TToolButton
                  Left = 0
                  Top = 0
                  Hint = #12458#12540#12488#12522#12525#12540#12489#12539#12458#12540#12488#12473#12463#12525#12540#12523
                  Action = actAutoReSc
                  Caption = #12458#12540#12488#12522#12525#12540#12489#12539#12458#12540#12488#12473#12463#12525#12540#12523
                  ImageIndex = 9
                end
                object DrawLinesButton: TToolButton
                  Left = 23
                  Top = 0
                  Hint = #34920#31034#12524#12473#25968'/'#12473#12524#12398#20877#25551#30011
                  Caption = #34920#31034#12524#12473#25968#12434#22793#26356'(&G)'
                  DropdownMenu = PopupDrawLines
                  Enabled = False
                  ImageIndex = 8
                  OnMouseDown = DrawLinesButtonMouseDown
                end
                object JumpBottun: TToolButton
                  Left = 46
                  Top = 0
                  Action = actScrollToNew
                  ImageIndex = 0
                end
                object ToolButton17: TToolButton
                  Left = 69
                  Top = 0
                  Width = 8
                  Caption = 'ToolButton17'
                  ImageIndex = 6
                  Style = tbsSeparator
                end
                object ThreCheckNewResButton: TToolButton
                  Left = 77
                  Top = 0
                  Hint = #12522#12525#12540#12489'/'#20840#12479#12502#12522#12525#12540#12489
                  Action = actCheckNewRes
                  DropdownMenu = PopupThreReload
                  ImageIndex = 1
                  Style = tbsDropDown
                  OnMouseDown = ThreCheckNewResButtonMouseDown
                end
                object ThreStopButton: TToolButton
                  Left = 111
                  Top = 0
                  Hint = #20013#27490
                  Action = actStop
                  Enabled = False
                  ImageIndex = 6
                end
                object ToolButton14: TToolButton
                  Left = 134
                  Top = 0
                  Width = 8
                  Caption = 'ToolButton14'
                  ImageIndex = 5
                  Style = tbsSeparator
                end
                object ResFindButton: TToolButton
                  Left = 142
                  Top = 0
                  Action = actKeywordExtraction
                  Enabled = False
                  ImageIndex = 7
                end
                object ToolButton19: TToolButton
                  Left = 165
                  Top = 0
                  Width = 8
                  Caption = 'ToolButton19'
                  ImageIndex = 6
                  Style = tbsSeparator
                end
                object ToolButton5: TToolButton
                  Left = 173
                  Top = 0
                  Action = actWriteRes
                  ImageIndex = 2
                end
                object ToolButton12: TToolButton
                  Left = 196
                  Top = 0
                  Action = actAddFavorite
                  DropdownMenu = PopupAddFavorite
                  ImageIndex = 3
                  Style = tbsDropDown
                end
                object ToolButton4: TToolButton
                  Left = 230
                  Top = 0
                  Width = 4
                  Caption = 'ToolButton2'
                  ImageIndex = 4
                  Style = tbsSeparator
                end
                object ToolButtonRemoveLog: TToolButton
                  Left = 234
                  Top = 0
                  Hint = #12525#12464#12434#21066#38500
                  Caption = #12371#12398#12525#12464#12434#21066#38500'(&D)'
                  DropdownMenu = PopupTrush
                  ImageIndex = 4
                end
                object ToolButton15: TToolButton
                  Left = 257
                  Top = 0
                  Action = actCloseTab
                  Caption = #12479#12502#12434#38281#12376#12427'(&W)'
                  DropdownMenu = PopupThreSys
                  ImageIndex = 5
                  Style = tbsDropDown
                end
              end
            end
          end
          object WritePanel: TPanel
            Left = 0
            Top = 111
            Width = 601
            Height = 200
            Align = alBottom
            Constraints.MinHeight = 25
            Constraints.MinWidth = 25
            TabOrder = 2
            Visible = False
            OnEnter = WritePanelEnter
            OnExit = WritePanelExit
            object WritePanelTitle: TPanel
              Left = 1
              Top = 1
              Width = 599
              Height = 17
              Align = alTop
              BevelOuter = bvNone
              Color = clActiveCaption
              TabOrder = 0
              object LabelWriteTitle: TLabel
                Left = 0
                Top = 0
                Width = 548
                Height = 17
                Align = alClient
                AutoSize = False
                Caption = '  '#26360#12365#36796#12415
                Font.Charset = SHIFTJIS_CHARSET
                Font.Color = clCaptionText
                Font.Height = -12
                Font.Name = 'MS UI Gothic'
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
                OnMouseDown = LabelWriteTitleMouseDown
                OnMouseMove = LabelWriteTitleMouseMove
                OnMouseUp = LabelWriteTitleMouseUp
              end
              object ToolBarWriteTitle: TJLXPToolBar
                Left = 548
                Top = 0
                Width = 51
                Height = 17
                Align = alRight
                AutoSize = True
                ButtonHeight = 16
                ButtonWidth = 17
                Caption = 'ToolBarWriteTitle'
                EdgeBorders = []
                Flat = True
                TabOrder = 0
                Transparent = True
                Wrapable = False
                object ToolButtonWriteTitle: TJLToolButton
                  Left = 0
                  Top = 0
                  Caption = 'ToolButtonWriteTitle'
                  DropdownMenu = PopupWritePanel
                  ImageIndex = 0
                  OnMouseDown = ToolButtonWriteTitleMouseDown
                end
                object ToolButtonWriteTitleAutoHide: TJLToolButton
                  Left = 17
                  Top = 0
                  Caption = 'ToolButtonWriteTitleAutoHide'
                  ImageIndex = 0
                  OnClick = ToolButtonWriteTitleAutoHideClick
                  OnMouseDown = ToolButtonWriteTitleMouseDown
                  PictureIndex = 1
                end
                object ToolButtonWriteTitleClose: TJLToolButton
                  Left = 34
                  Top = 0
                  Caption = 'ToolButtonWriteTitleClose'
                  ImageIndex = 3
                  Wrap = True
                  OnClick = ToolButtonWriteTitleCloseClick
                  OnMouseDown = ToolButtonWriteTitleMouseDown
                  PictureIndex = 3
                end
              end
            end
            object PageControlWrite: TPageControl
              Left = 1
              Top = 18
              Width = 599
              Height = 139
              ActivePage = TabSheetWriteMain
              Align = alClient
              TabIndex = 0
              TabOrder = 1
              TabStop = False
              OnChange = PageControlWriteChange
              object TabSheetWriteMain: TTabSheet
                Caption = #26360#12365#36796#12415
                object PanelWriteNameMail: TPanel
                  Left = 0
                  Top = 0
                  Width = 591
                  Height = 25
                  Align = alTop
                  BevelOuter = bvNone
                  TabOrder = 0
                  DesignSize = (
                    591
                    25)
                  object LabelWriteName: TLabel
                    Left = 6
                    Top = 5
                    Width = 31
                    Height = 12
                    Caption = 'Name:'
                  end
                  object LabelWriteMail: TLabel
                    Left = 431
                    Top = 6
                    Width = 23
                    Height = 12
                    Anchors = [akTop, akRight]
                    Caption = 'Mail:'
                  end
                  object ComboBoxWriteName: TComboBox
                    Left = 43
                    Top = 2
                    Width = 376
                    Height = 20
                    Hint = #21517#21069
                    AutoComplete = False
                    Anchors = [akLeft, akTop, akRight]
                    ItemHeight = 12
                    TabOrder = 0
                  end
                  object ComboBoxWriteMail: TComboBox
                    Left = 462
                    Top = 2
                    Width = 66
                    Height = 20
                    Hint = #12513#12540#12523
                    AutoComplete = False
                    Anchors = [akTop, akRight]
                    ItemHeight = 12
                    TabOrder = 1
                  end
                  object CheckBoxWriteSage: TCheckBox
                    Left = 534
                    Top = 4
                    Width = 46
                    Height = 17
                    Alignment = taLeftJustify
                    Anchors = [akTop, akRight]
                    Caption = 'Sage:'
                    TabOrder = 2
                    OnClick = CheckBoxWriteSageClick
                  end
                end
                object MemoWriteMain: TTntMemo
                  Left = 0
                  Top = 25
                  Width = 591
                  Height = 87
                  Align = alClient
                  ScrollBars = ssBoth
                  TabOrder = 1
                  WordWrap = False
                  OnChange = MemoWriteMainChange
                  OnEnter = MemoWriteMainEnter
                  OnExit = MemoWriteMainExit
                  OnKeyDown = MemoWriteMainKeyDown
                  OnKeyPress = MemoWriteMainKeyPress
                end
              end
              object TabSheetWritePreview: TTabSheet
                Caption = #12503#12524#12499#12517#12540
                ImageIndex = 1
              end
              object TabSheetWriteSettingTxt: TTabSheet
                Caption = 'SETTING.TXT'
                ImageIndex = 2
                object MemoWriteSettingTxt: TMemo
                  Left = 0
                  Top = 0
                  Width = 533
                  Height = 58
                  Align = alClient
                  ReadOnly = True
                  ScrollBars = ssBoth
                  TabOrder = 0
                  WordWrap = False
                end
              end
              object TabSheetWriteResult: TTabSheet
                Caption = #32080#26524
                ImageIndex = 3
                object MemoWriteResult: TMemo
                  Left = 0
                  Top = 0
                  Width = 533
                  Height = 58
                  Align = alClient
                  ReadOnly = True
                  ScrollBars = ssVertical
                  TabOrder = 0
                  WordWrap = False
                end
              end
            end
            object StatusBarWrite: TJLXPStatusBar
              Left = 1
              Top = 180
              Width = 599
              Height = 19
              Panels = <
                item
                  Width = 120
                end
                item
                  Width = 100
                end
                item
                  Width = 50
                end>
              SimplePanel = False
            end
            object PanelWriteTool: TPanel
              Left = 1
              Top = 157
              Width = 599
              Height = 23
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 3
              DesignSize = (
                599
                23)
              object ToolBarWriteTool: TJLXPToolBar
                Left = 0
                Top = 0
                Width = 215
                Height = 23
                Align = alLeft
                AutoSize = True
                ButtonHeight = 23
                EdgeBorders = []
                Flat = True
                Images = MemoImageList
                TabOrder = 0
                Wrapable = False
                object ToolButtonWriteAA: TToolButton
                  Left = 0
                  Top = 0
                  Hint = 'AA'
                  ImageIndex = 0
                  OnClick = ToolButtonWriteAAClick
                end
                object ToolButtonWriteSave: TToolButton
                  Left = 23
                  Top = 0
                  Hint = #12513#12514#27396#12398#20869#23481#12434#21517#21069#12392#12388#12369#12390#20445#23384
                  Caption = 'ToolButtonWriteSave'
                  ImageIndex = 1
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteLoad: TToolButton
                  Tag = 1
                  Left = 46
                  Top = 0
                  Hint = #12501#12449#12452#12523#12363#12425#12513#12514#27396#12395#35501#36796#12416
                  Caption = 'ToolButtonWriteLoad'
                  ImageIndex = 2
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteClear: TToolButton
                  Tag = 2
                  Left = 69
                  Top = 0
                  Hint = #12513#12514#27396#12398#20869#23481#12434#28040#21435
                  Caption = 'ToolButtonWriteClear'
                  ImageIndex = 3
                  OnClick = ToolButtonWriteClick
                end
                object ToolButton20: TToolButton
                  Left = 92
                  Top = 0
                  Width = 8
                  Caption = 'ToolButton20'
                  ImageIndex = 6
                  Style = tbsSeparator
                end
                object ToolButtonWriteRecordNameMail: TToolButton
                  Tag = 3
                  Left = 100
                  Top = 0
                  Hint = #12467#12486#12495#12531#35352#25014
                  Caption = 'ToolButtonWriteRecordNameMail'
                  ImageIndex = 4
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteTrim: TToolButton
                  Tag = 4
                  Left = 123
                  Top = 0
                  Hint = #26411#23614#25972#24418
                  Caption = 'ToolButtonWriteTrim'
                  ImageIndex = 5
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteUseWriteWait: TToolButton
                  Tag = 5
                  Left = 146
                  Top = 0
                  Hint = 'WriteWait'
                  Caption = 'ToolButtonWriteUseWriteWait'
                  ImageIndex = 6
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteNameMailWarning: TToolButton
                  Tag = 6
                  Left = 169
                  Top = 0
                  Hint = #12467#12486#12495#12531#35686#21578
                  Caption = 'ToolButtonWriteNameMailWarning'
                  ImageIndex = 7
                  OnClick = ToolButtonWriteClick
                end
                object ToolButtonWriteBelogin: TToolButton
                  Tag = 7
                  Left = 192
                  Top = 0
                  Hint = 'Be'#12525#12464#12452#12531
                  Caption = 'ToolButtonWriteBelogin'
                  ImageIndex = 8
                  OnClick = ToolButtonWriteClick
                end
              end
              object ButtonWriteWrite: TButton
                Left = 450
                Top = 0
                Width = 99
                Height = 23
                Anchors = [akTop, akRight]
                Caption = #26360#36796'(Shift+Enter)'
                TabOrder = 1
                OnClick = ButtonWriteWriteClick
              end
              object Button2: TButton
                Left = 554
                Top = 0
                Width = 43
                Height = 23
                Anchors = [akTop, akRight]
                Caption = #12420#12417#12427
                TabOrder = 2
                OnClick = ToolButtonWriteTitleCloseClick
              end
            end
          end
          object MDIClientPanel: TPanel
            Left = 0
            Top = 73
            Width = 601
            Height = 36
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 3
          end
          object ThreViewSearchToolBar: TJLXPToolBar
            Left = 0
            Top = 49
            Width = 601
            Height = 24
            ButtonWidth = 27
            Color = clBtnFace
            Flat = True
            Images = SearchImages
            ParentColor = False
            TabOrder = 4
            Visible = False
            Wrapable = False
            OnResize = ThreViewSearchToolBarResize
            object ThreViewSearchToolButton: TToolButton
              Left = 0
              Top = 0
              DropdownMenu = PopupSearch
              ImageIndex = 0
              Style = tbsDropDown
              OnClick = ThreViewSearchToolButtonClick
            end
            object ThreViewSearchEditBox: TComboBox
              Left = 38
              Top = 1
              Width = 145
              Height = 20
              AutoComplete = False
              ItemHeight = 12
              PopupMenu = PopupSearch
              TabOrder = 0
              OnKeyPress = SearchEditBoxKeyPress
            end
            object ThreViewSearchSep1: TToolButton
              Left = 183
              Top = 0
              Width = 8
              Caption = 'ThreViewSearchSep1'
              ImageIndex = 5
              Style = tbsSeparator
            end
            object ThreViewSearchUpDown: TUpDown
              Left = 191
              Top = 0
              Width = 17
              Height = 22
              Min = -32768
              Max = 32767
              Position = 0
              TabOrder = 1
              Wrap = True
              OnClick = ThreViewSearchUpDownClick
            end
            object ThreViewSearchSep2: TToolButton
              Left = 208
              Top = 0
              Width = 8
              Caption = 'ThreViewSearchSep2'
              ImageIndex = 5
              Style = tbsSeparator
            end
            object ThreViewSearchResFindButton: TToolButton
              Left = 216
              Top = 0
              Caption = 'ThreViewSearchResFindButton'
              ImageIndex = 4
            end
            object ThreViewSearchSep3: TToolButton
              Left = 243
              Top = 0
              Width = 8
              Caption = 'ThreViewSearchSep3'
              ImageIndex = 5
              Style = tbsSeparator
            end
            object ThreViewSearchCloseButton: TToolButton
              Left = 251
              Top = 0
              Caption = #26908#32034#12496#12540#12434#38560#12377
              ImageIndex = 5
              OnClick = ThreViewSearchCloseButtonClick
            end
          end
        end
        object ListViewPanel: TPanel
          Left = 0
          Top = 0
          Width = 601
          Height = 145
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          OnEnter = ListViewPanelEnter
          OnResize = ListViewPanelResize
          object ListView: THogeListView
            Left = 0
            Top = 47
            Width = 601
            Height = 98
            Align = alClient
            BevelInner = bvLowered
            BevelOuter = bvNone
            Columns = <
              item
                Caption = #65281
                MinWidth = -1
                Width = 25
              end
              item
                Alignment = taRightJustify
                Caption = #30058#21495
                Tag = 1
                Width = 40
              end
              item
                Caption = #12479#12452#12488#12523
                Tag = 2
                Width = 250
              end
              item
                Alignment = taRightJustify
                Caption = #12524#12473
                Tag = 3
                Width = 40
              end
              item
                Alignment = taRightJustify
                Caption = #21462#24471
                Tag = 4
                Width = 40
              end
              item
                Alignment = taRightJustify
                Caption = #26032#30528
                Tag = 5
                Width = 40
              end
              item
                Caption = #26368#32066#21462#24471
                Tag = 6
                Width = 20
              end
              item
                Caption = #26368#32066#26360#36796
                Tag = 7
                Width = 20
              end
              item
                Caption = 'since'
                Tag = 8
                Width = 20
              end
              item
                Caption = #26495
                Tag = 9
                Width = 20
              end
              item
                Alignment = taRightJustify
                Caption = #21218#12356
                Tag = 10
                Width = 20
              end
              item
                Alignment = taRightJustify
                Caption = #22679#12524#12473
                Tag = 11
                Width = 20
              end>
            HideSelection = False
            HotTrackStyles = [htHandPoint, htUnderlineHot]
            HoverTime = 2147483647
            ReadOnly = True
            RowSelect = True
            SmallImages = ListImages
            TabOrder = 0
            TabStop = False
            ViewStyle = vsReport
            Visible = False
            OnClick = ListViewClick
            OnColumnClick = ListViewColumnClick
            OnCustomDrawItem = ListViewCustomDrawItem
            OnData = ListViewData
            OnDataHint = MakeCheckNewThreadAfter
            OnDblClick = ListViewDblClick
            OnKeyDown = ListViewKeyDown
            OnMouseDown = ListViewMouseDown
            OnMouseMove = ListViewMouseMove
            OnSelectItem = ListViewSelectItem
            OnDropFiles = ListViewDropFiles
          end
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 601
            Height = 1
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
          end
          object ListTabPanel: TPanel
            Left = 0
            Top = 1
            Width = 601
            Height = 22
            Align = alTop
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 2
            OnDragDrop = ListTabPanelDragDrop
            OnDragOver = ListTabPanelDragOver
            OnMouseMove = ListTabPanelMouseMove
            object ListTabControl: TTabControl
              Left = 2
              Top = 2
              Width = 597
              Height = 18
              Align = alClient
              Images = ListImages
              PopupMenu = PopupTree
              Style = tsFlatButtons
              TabOrder = 0
              TabStop = False
              OnChange = ListTabControlChange
              OnChanging = ListTabControlChanging
              OnDragDrop = ListTabControlDragDrop
              OnDragOver = ListTabControlDragOver
              OnGetImageIndex = ListTabControlGetImageIndex
              OnMouseDown = ListTabControlMouseDown
              OnMouseMove = ListTabControlMouseMove
            end
          end
          object ListViewSearchToolBar: TJLXPToolBar
            Left = 0
            Top = 23
            Width = 601
            Height = 24
            ButtonWidth = 27
            Flat = True
            Images = SearchImages
            TabOrder = 3
            Visible = False
            Wrapable = False
            OnResize = ListViewSearchToolBarResize
            object ListViewSearchToolButton: TToolButton
              Left = 0
              Top = 0
              DropdownMenu = PopupSearch
              ImageIndex = 0
              Style = tbsDropDown
              OnClick = ListViewSearchToolButtonClick
            end
            object ListViewSearchEditBox: TComboBox
              Left = 38
              Top = 1
              Width = 145
              Height = 20
              AutoComplete = False
              ItemHeight = 12
              PopupMenu = PopupSearch
              TabOrder = 0
              OnKeyPress = SearchEditBoxKeyPress
            end
            object ListViewSearchSep: TToolButton
              Left = 183
              Top = 0
              Width = 8
              ImageIndex = 5
              Style = tbsSeparator
            end
            object ListViewSearchCloseButton: TToolButton
              Left = 191
              Top = 0
              Caption = #26908#32034#12496#12540#12434#38560#12377
              ImageIndex = 5
              OnClick = ListViewSearchCloseButtonClick
            end
          end
        end
      end
      object TreePanel: TPanel
        Left = 0
        Top = 0
        Width = 120
        Height = 460
        Align = alLeft
        BevelOuter = bvNone
        Constraints.MinHeight = 25
        Constraints.MinWidth = 25
        TabOrder = 0
        Visible = False
        OnEnter = TreePanelEnter
        OnExit = TreePanelExit
        OnResize = TreePanelResize
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 120
          Height = 1
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
        end
        object Panel9: TPanel
          Left = 0
          Top = 1
          Width = 120
          Height = 459
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object TreeView: TTreeView
            Left = 1
            Top = 63
            Width = 118
            Height = 395
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Ctl3D = False
            Font.Charset = SHIFTJIS_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
            Font.Style = []
            HideSelection = False
            HotTrack = True
            Images = ListImages
            Indent = 19
            ParentCtl3D = False
            ParentFont = False
            PopupMenu = PopupTree
            ReadOnly = True
            RightClickSelect = True
            RowSelect = True
            TabOrder = 0
            OnClick = TreeViewClick
            OnContextPopup = TreeViewContextPopup
            OnDblClick = TreeViewDblClick
            OnExpanding = TreeViewExpanding
            OnKeyDown = TreeViewKeyDown
            OnMouseMove = TreeViewMouseMove
          end
          object FavoriteView: TTreeView
            Left = 1
            Top = 63
            Width = 118
            Height = 395
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvRaised
            BorderStyle = bsNone
            Ctl3D = False
            DragMode = dmAutomatic
            HideSelection = False
            HotTrack = True
            Images = ListImages
            Indent = 19
            ParentCtl3D = False
            PopupMenu = PopupFavorites
            ReadOnly = True
            RightClickSelect = True
            RowSelect = True
            ShowRoot = False
            TabOrder = 1
            OnClick = FavoriteViewClick
            OnCollapsing = FavoriteViewCollapsing
            OnDblClick = FavoriteViewDblClick
            OnDragDrop = FavoriteViewDragDrop
            OnDragOver = FavoriteViewDragOver
            OnEdited = FavoriteViewEdited
            OnEditing = FavoriteViewEditing
            OnKeyDown = FavoriteViewKeyDown
            OnMouseMove = FavoriteViewMouseMove
          end
          object PanelTreeTitle: TPanel
            Left = 1
            Top = 1
            Width = 118
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            Color = clActiveCaption
            TabOrder = 2
            object LabelTreeTitle: TLabel
              Left = 0
              Top = 0
              Width = 65
              Height = 17
              Align = alClient
              AutoSize = False
              Caption = '  '#26495#19968#35239
              Font.Charset = SHIFTJIS_CHARSET
              Font.Color = clCaptionText
              Font.Height = -12
              Font.Name = 'MS UI Gothic'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
              OnMouseDown = LabelTreeTitleMouseDown
              OnMouseMove = LabelTreeTitleMouseMove
              OnMouseUp = LabelTreeTitleMouseUp
            end
            object ToolBarTreeTitle: TJLXPToolBar
              Left = 65
              Top = 0
              Width = 53
              Height = 17
              Align = alRight
              AutoSize = True
              ButtonHeight = 16
              ButtonWidth = 17
              EdgeBorders = [ebRight]
              Flat = True
              TabOrder = 0
              Transparent = True
              object ToolButtonTreeTitle: TJLToolButton
                Left = 0
                Top = 0
                ImageIndex = 0
                OnMouseDown = ToolButtonTreeTitleMouseDown
              end
              object ToolButtonTreeTitleCanMove: TJLToolButton
                Left = 17
                Top = 0
                ImageIndex = 1
                OnClick = PanelTitlePanelClick
                OnMouseDown = ToolButtonTreeTitleMouseDown
                PictureIndex = 1
              end
              object ToolButtonTreeTitleClose: TJLToolButton
                Left = 34
                Top = 0
                Caption = 'ToolButtonTreeTitleClose'
                ImageIndex = 3
                OnClick = PanelTitlePanelClick
                OnMouseDown = ToolButtonTreeTitleMouseDown
                PictureIndex = 3
              end
            end
          end
          object TreeViewSearchToolBar: TJLXPToolBar
            Left = 1
            Top = 39
            Width = 118
            Height = 24
            AutoSize = True
            ButtonWidth = 27
            Flat = True
            Images = SearchImages
            TabOrder = 3
            Wrapable = False
            OnResize = TreeViewSearchToolBarResize
            object TreeViewSearchToolButton: TToolButton
              Left = 0
              Top = 0
              DropdownMenu = PopupSearch
              ImageIndex = 0
              PopupMenu = PopupSearch
              Style = tbsDropDown
              OnClick = TreeViewSearchToolButtonClick
            end
            object TreeViewSearchEditBox: TComboBox
              Left = 38
              Top = 1
              Width = 80
              Height = 20
              AutoComplete = False
              ItemHeight = 12
              PopupMenu = PopupSearch
              TabOrder = 0
              OnKeyPress = SearchEditBoxKeyPress
            end
          end
          object TreeTabControl: TTabControl
            Left = 1
            Top = 18
            Width = 118
            Height = 21
            Align = alTop
            TabOrder = 4
            Tabs.Strings = (
              #26495#27396
              #12362#27671#12395#20837#12426)
            TabIndex = 0
            TabStop = False
            OnChange = TreeTabControlChange
          end
        end
      end
    end
    object LogPanel: TPanel
      Left = 0
      Top = 513
      Width = 729
      Height = 20
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Memo: TMemo
        Left = 0
        Top = 1
        Width = 729
        Height = 19
        TabStop = False
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = True
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnMouseMove = MemoMouseMove
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 729
        Height = 1
        Align = alTop
        TabOrder = 1
      end
    end
    object CoolBar: TCoolBar
      Left = 0
      Top = 0
      Width = 729
      Height = 51
      AutoSize = True
      BandMaximize = bmDblClick
      Bands = <
        item
          Control = ToolBarMain
          ImageIndex = -1
          MinHeight = 23
          Width = 331
        end
        item
          Break = False
          Control = LinkBar
          ImageIndex = -1
          MinHeight = 22
          Width = 392
        end
        item
          Control = ToolBarUrlEdit
          ImageIndex = -1
          MinHeight = 22
          Width = 725
        end>
      ParentShowHint = False
      ShowHint = True
      Visible = False
      object ToolBarMain: TJLXPToolBar
        Left = 9
        Top = 0
        Width = 318
        Height = 23
        AutoSize = True
        ButtonHeight = 23
        EdgeBorders = []
        Flat = True
        Images = MainToolImages
        PopupMenu = PopupBar
        TabOrder = 0
        Transparent = True
        Wrapable = False
        object OnlineButton: TToolButton
          Left = 0
          Top = 0
          Action = actOnLine
          ImageIndex = 12
          Style = tbsCheck
        end
        object ToolButton8: TToolButton
          Left = 23
          Top = 0
          Width = 8
          Caption = 'ToolButton8'
          ImageIndex = 5
          Style = tbsSeparator
        end
        object DivisionChangeButton: TToolButton
          Left = 31
          Top = 0
          Hint = #32294#8660#27178#20998#21106#20999#26367
          Action = actDivisionChange
          ImageIndex = 0
        end
        object PaneModeChangeButton: TToolButton
          Left = 54
          Top = 0
          Hint = '2'#8660'3'#12506#12452#12531#20999#26367
          Action = actPaneModeChange
          ImageIndex = 2
        end
        object ToggleTreeButton: TToolButton
          Left = 77
          Top = 0
          Hint = #26495#12484#12522#12540#34920#31034
          Action = actTreeToggleVisible
          ImageIndex = 3
          Style = tbsCheck
        end
        object ToggleRPaneButton: TToolButton
          Left = 100
          Top = 0
          Hint = #21491#20596#20999#26367
          Caption = #12298#21491#20596#20999#26367'(&X)'#12299
          ImageIndex = 4
          OnClick = MenuToggleRPaneClick
        end
        object ToolButton10: TToolButton
          Left = 123
          Top = 0
          Width = 8
          Caption = 'ToolButton7'
          ImageIndex = 5
          Style = tbsSeparator
        end
        object ThreBuildButton: TToolButton
          Left = 131
          Top = 0
          Action = actBuildThread
          Caption = #12473#12524#12483#12489#26032#35215#20316#25104'(&B)...'
          ImageIndex = 5
        end
        object ThreadRefreshButton: TToolButton
          Left = 154
          Top = 0
          Action = actGeneralUpdate
          Caption = #12522#12525#12540#12489'(&U)'
          ImageIndex = 6
          OnMouseDown = ThreadRefreshButtonMouseDown
        end
        object ToolButton1: TToolButton
          Left = 177
          Top = 0
          Hint = #12362#27671#12395#20837#12426#12398#26356#26032#12481#12455#12483#12463
          Caption = 'ToolButton1'
          ImageIndex = 7
          OnClick = MenuFavPatrolClick
        end
        object ToolButton11: TToolButton
          Left = 200
          Top = 0
          Width = 8
          Caption = 'ToolButton9'
          ImageIndex = 6
          Style = tbsSeparator
        end
        object FindThreadButton: TToolButton
          Left = 208
          Top = 0
          Hint = #12473#12524#32094#12426#36796#12415#26908#32034'/'#32094#12426#36796#12415#32080#26524#12398#12463#12522#12450
          Caption = #12473#12524#32094#12426#36796#12415#26908#32034'(&F)'
          ImageIndex = 8
          OnClick = MenuFindThreadClick
          OnMouseDown = FindThreadButtonMouseDown
        end
        object FindGrepButton: TToolButton
          Left = 231
          Top = 0
          Hint = #12525#12464#12363#12425#26908#32034
          Caption = #12525#12464#12363#12425#26908#32034'(&G)'
          ImageIndex = 9
          OnClick = FindGrepClick
        end
        object ToolButton9: TToolButton
          Left = 254
          Top = 0
          Width = 8
          Caption = 'ToolButton9'
          ImageIndex = 6
          Style = tbsSeparator
        end
        object ToolOptionsButton: TToolButton
          Left = 262
          Top = 0
          Hint = #35373#23450
          Caption = #35373#23450'(&O)...'
          ImageIndex = 10
          OnClick = MenuToolsOptionsClick
        end
        object HelpButton: TToolButton
          Left = 285
          Top = 0
          Hint = #12504#12523#12503
          Caption = #12504#12523#12503'(&H)'
          ImageIndex = 11
          OnClick = MenuHelpClick
        end
      end
      object ToolBarUrlEdit: TJLXPToolBar
        Left = 9
        Top = 25
        Width = 712
        Height = 22
        ButtonHeight = 20
        EdgeInner = esNone
        EdgeOuter = esNone
        TabOrder = 1
        Transparent = True
        OnResize = ToolBarUrlEditResize
        object UrlEdit: TEdit
          Left = 0
          Top = 2
          Width = 1024
          Height = 20
          AutoSize = False
          BevelInner = bvNone
          BevelOuter = bvNone
          ImeMode = imClose
          PopupMenu = PopupUrlEdit
          TabOrder = 0
          OnEnter = UrlEditEnter
          OnExit = UrlEditExit
          OnKeyDown = UrlEditKeyDown
        end
      end
      object LinkBar: TJLXPToolBar
        Left = 342
        Top = 0
        Width = 379
        Height = 22
        AutoSize = True
        ButtonWidth = 45
        Caption = #12522#12531#12463
        Ctl3D = False
        EdgeBorders = []
        Flat = True
        Images = ListImages
        List = True
        PopupMenu = PopupBar
        ShowCaptions = True
        TabOrder = 2
        Transparent = True
        Wrapable = False
        OnResize = LinkBarResize
      end
    end
    object SideBar: TJLSideBar
      Left = 0
      Top = 51
      Width = 4
      Height = 460
      Checked = True
      FocusColor = clSkyBlue
      Align = alLeft
      BevelOuter = bvNone
      OnClick = MenuViewTreeToggleVisibleClick
    end
  end
  object StatusBar: TJLXPStatusBar
    Left = 0
    Top = 533
    Width = 729
    Height = 19
    Panels = <
      item
        Width = 40
      end
      item
        Width = 70
      end
      item
        Width = 500
      end
      item
        Width = -1
      end>
    PopupMenu = PopupStatusBar
    SimplePanel = False
    OnClick = StatusBarClick
    OnResize = StatusBarResize
  end
  object MainMenu: TMainMenu
    Left = 88
    Top = 24
    object MenuBoard: TMenuItem
      Caption = #26495#35239'(&B)'
      object MenuBoardCanMove: TMenuItem
        Caption = #26495#12484#12522#12540#12434#31227#21205#21487#33021#12395#12377#12427
        OnClick = MenuBoardCanMoveClick
      end
      object MenuBoardGetList: TMenuItem
        Caption = #26495#19968#35239#12398#26356#26032'(&U)'
        OnClick = GetBoard2ch
      end
      object MenuBoardCheckLogFolder: TMenuItem
        Caption = #12525#12464#12501#12457#12523#12480#12398#12481#12455#12483#12463'(&C)'
        OnClick = MenuBoardCheckLogFolderClick
      end
      object N45: TMenuItem
        Caption = '-'
      end
      object MenuBoardLogListLimit: TMenuItem
        Caption = #12525#12464#19968#35239#21046#38480#22793#26356'(&L)'
        OnClick = MenuBoardLogListLimitClick
      end
      object MenuBoardList: TMenuItem
        Caption = #26495#19968#35239
        OnClick = MenuBoardListClick
        object MenuBoardSep: TMenuItem
          Caption = '-'
        end
        object TMenuItem
        end
      end
      object N87: TMenuItem
        Caption = '-'
      end
      object MenuBoardRestore: TMenuItem
        Caption = #26495#12484#12522#12540#12398#20301#32622#24489#24112
        OnClick = MenuBoardRestoreClick
      end
    end
    object MenuList: TMenuItem
      Caption = #65405#65434#35239'(&L)'
      OnClick = MenuListClick
      object MenuListClose: TMenuItem
        Caption = #29694#22312#12398#26495#12434#38281#12376#12427'(&C)'
        OnClick = MenuListCloseClick
      end
      object N34: TMenuItem
        Caption = '-'
      end
      object MenuListCloseBoards: TMenuItem
        Caption = #35079#25968#12398#12479#12502#12434#38281#12376#12427
        object MenuListCloseOtherTabs: TMenuItem
          Caption = #36984#25246#12373#12428#12390#12356#12394#12356#26495#12434#38281#12376#12427'(&W)'
          OnClick = MenuListCloseOtherTabsClick
        end
        object MenuListCloseAllTabs: TMenuItem
          Action = actListCloseAllTabs
        end
        object MenuListCloseLeftTabs: TMenuItem
          Caption = #12371#12428#12424#12426#24038#12434#38281#12376#12427
          OnClick = MenuListCloseLeftTabsClick
        end
        object MenuListCloseRightTabs: TMenuItem
          Caption = #12371#12428#12424#12426#21491#12434#38281#12376#12427
          OnClick = MenuListCloseRightTabsClick
        end
      end
      object MenuListTabMenuSep: TMenuItem
        Caption = '-'
      end
      object MenuListOpenAll: TMenuItem
        Caption = #9675#9675#12434#12377#12409#12390#38283#12367
        object MenuListOpenNewResThreads: TMenuItem
          Caption = #26356#26032#12398#12354#12427#12473#12524#12483#12489#12434#12377#12409#12390#38283#12367
          OnClick = MenuListOpenNewResThreadsClick
        end
        object MenuListOpenNewResFavorites: TMenuItem
          Caption = #12362#27671#12395#20837#12426#12391#26356#26032#12398#12354#12427#12473#12524#12483#12489#12434#12377#12409#12390#38283#12367
          OnClick = MenuListOpenNewResFavoritesClick
        end
        object MenuListOpenFavorites: TMenuItem
          Caption = #12362#27671#12395#20837#12426#12434#12377#12409#12390#38283#12367
          OnClick = MenuListOpenFavoritesClick
        end
      end
      object MenuListOpenNew: TMenuItem
        Action = actListOpenNew
      end
      object MenuListOpenCurrent: TMenuItem
        Action = actListOpenCurrent
      end
      object MenuListOpenHide: TMenuItem
        Action = actListOpenHide
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MenuListCloseThisThread: TMenuItem
        Action = actListCloseThisThread
      end
      object N94: TMenuItem
        Caption = '-'
      end
      object MenuListCanClose: TMenuItem
        Action = actListCanClose
      end
      object MenuListAlReady: TMenuItem
        Action = actListAlready
      end
      object MenuListToggleMarker: TMenuItem
        Action = actListToggleMarker
      end
      object MenuListAddFav: TMenuItem
        Action = actListAddFav
      end
      object MenuListDelFav: TMenuItem
        Action = actListDelFav
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object MenuListRefresh: TMenuItem
        Action = actListRefresh
        Caption = #12522#12525#12540#12489'(&U)'
        Hint = #12522#12525#12540#12489
      end
      object MenuListRefreshAll: TMenuItem
        Caption = #20840#12479#12502#12522#12525#12540#12489'(&A)'
        OnClick = MenuListRefreshAllClick
      end
      object MenuListHomeMovedBoard: TMenuItem
        Caption = #26495#31227#36578#12398#36861#23614'(&Q)'
        OnClick = MenuListHomeMovedBoardClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object MenuListThreBuild: TMenuItem
        Action = actBuildThread
        Caption = #12473#12524#12483#12489#26032#35215#20316#25104'(&B)...'
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object MenuListOpenByBrowser: TMenuItem
        Action = actListOpenByBrowser
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object MenuListCopyURL: TMenuItem
        Action = actListCopyURL
      end
      object E2: TMenuItem
        Action = actListCopyTITLE
      end
      object MenuListCopyTU: TMenuItem
        Action = actListCopyTU
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object MenuListCopys: TMenuItem
        Caption = #36984#25246#20013#12398#12525#12464#12434#12467#12500#12540
        object datD2: TMenuItem
          Action = actListCopyDat
          Enabled = False
        end
        object datidxI1: TMenuItem
          Action = actListCopyDI
          Enabled = False
        end
      end
      object N71: TMenuItem
        Caption = '-'
      end
      object MenuListLogDel: TMenuItem
        Action = actListDelLog
      end
      object N104: TMenuItem
        Caption = '-'
      end
      object N103: TMenuItem
        Action = actThreadAbone4
      end
      object N81: TMenuItem
        Action = actThreadAbone
      end
      object N100: TMenuItem
        Action = actThreadAbone3
      end
      object N105: TMenuItem
        Action = actThreadAbone2
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object MenuListSort: TMenuItem
        Caption = #12477#12540#12488'(&S)'
        OnClick = MenuListSortClick
        object SortMarker: TMenuItem
          Caption = '&1 !'
          OnClick = SortMenuClick
        end
        object SortNumber: TMenuItem
          Tag = 1
          Caption = '&2 '#30058#21495
          OnClick = SortMenuClick
        end
        object SortTitle: TMenuItem
          Tag = 2
          Caption = '&3 '#12479#12452#12488#12523
          OnClick = SortMenuClick
        end
        object SortItem: TMenuItem
          Tag = 3
          Caption = '&4 '#12524#12473
          OnClick = SortMenuClick
        end
        object SortLines: TMenuItem
          Tag = 4
          Caption = '&5 '#21462#24471
          OnClick = SortMenuClick
        end
        object SortNew: TMenuItem
          Tag = 5
          Caption = '&6 '#26032#30528
          OnClick = SortMenuClick
        end
        object SortGot: TMenuItem
          Tag = 6
          Caption = '&7 '#26368#32066#21462#24471
          OnClick = SortMenuClick
        end
        object SortWrote: TMenuItem
          Tag = 7
          Caption = '&8 '#26368#32066#26360#36796
          OnClick = SortMenuClick
        end
        object SortSince: TMenuItem
          Tag = 8
          Caption = '&9 Since'
          OnClick = SortMenuClick
        end
        object SortBoard: TMenuItem
          Tag = 9
          Caption = '&0 '#26495
          OnClick = SortMenuClick
        end
        object SortSpeed: TMenuItem
          Tag = 10
          Caption = '&a '#21218#12356
          OnClick = SortMenuClick
        end
        object SortGain: TMenuItem
          Tag = 11
          Caption = '&b '#22679#12524#12473
          OnClick = SortMenuClick
        end
        object N97: TMenuItem
          Caption = '-'
        end
        object N106: TMenuItem
          Action = actUpOpenThread
        end
        object N107: TMenuItem
          Action = actUpImportantThread
        end
      end
      object MenuListThreadAboneSetting: TMenuItem
        Caption = #12473#12524#12483#12489#12354#12412#65374#12435#12398#34920#31034#22793#26356
        object MenuListAboneTranseparency: TMenuItem
          Action = actThreadAboneTranseparency
          GroupIndex = 1
          RadioItem = True
        end
        object MenuListAboneNormal: TMenuItem
          Action = actThreadAboneNormal
          GroupIndex = 1
          RadioItem = True
        end
        object MenuListAboneIgnore: TMenuItem
          Action = actThreadAboneIgnore
          GroupIndex = 1
          RadioItem = True
        end
        object MenuListAboneOnly: TMenuItem
          Action = actThreadAboneOnly
          GroupIndex = 1
          RadioItem = True
        end
        object N77: TMenuItem
          Action = actThreadAboneImportantResOnly
          GroupIndex = 1
          RadioItem = True
        end
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object MenuListRefreshIdxList: TMenuItem
        Caption = #12508#12540#12489#12487#12540#12479#12398#20877#27083#25104
        OnClick = MenuListRefreshIdxListClick
      end
      object MenuListHideHistoricalLog: TMenuItem
        Caption = #36942#21435#12525#12464#38750#34920#31034
        OnClick = MenuListHideHistoricalLogClick
      end
    end
    object MenuThre: TMenuItem
      Caption = #65405#65434'(&T)'
      OnClick = MenuThreClick
      object MenuThreClose: TMenuItem
        Caption = #36984#25246#20013#12398#12479#12502#12434#38281#12376#12427'(&C)'
        ShortCut = 16471
        OnClick = MenuThreCloseClick
      end
      object MenuThreCloseWOSave: TMenuItem
        Caption = #26410#35501#12392#12375#12390#38281#12376#12427'(&Q)'
        OnClick = MenuThreCloseWOSaveClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N78: TMenuItem
        Caption = #35079#25968#12398#12479#12502#12434#38281#12376#12427
        object MenuThreCloseOtherTabs: TMenuItem
          Caption = #36984#25246#12373#12428#12390#12356#12394#12356#12479#12502#12434#38281#12376#12427'(&W)'
          OnClick = MenuThreCloseOtherTabsClick
        end
        object MenuThreCloseAllTabs: TMenuItem
          Action = actCloseAllTabs
        end
        object MenuThreCloseLeftTabs: TMenuItem
          Caption = #12371#12428#12424#12426#24038#12434#38281#12376#12427
          OnClick = MenuThreCloseLeftTabsClick
        end
        object MenuThreCloseRightTabs: TMenuItem
          Caption = #12371#12428#12424#12426#21491#12434#38281#12376#12427
          OnClick = MenuThreCloseRightTabsClick
        end
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object MenuThreToggleMarker: TMenuItem
        Action = actToggleMarker
      end
      object MenuThreAddFav: TMenuItem
        Action = actAddFavorite
      end
      object MenuThreDelFav: TMenuItem
        Action = actDeleteFavorite
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MenuThreBack: TMenuItem
        Action = actBack
        ShortCut = 32805
      end
      object MenuThreForword: TMenuItem
        Action = actForword
        ShortCut = 32807
      end
      object N54: TMenuItem
        Caption = '-'
      end
      object MenuThreScrollToPrev: TMenuItem
        Action = actScrollToPrev
      end
      object MenuThreScrollToNew: TMenuItem
        Action = actScrollToNew
      end
      object MenuThreCheckNew: TMenuItem
        Action = actCheckNewRes
        ShortCut = 16466
      end
      object MenuThreCheckNewAll: TMenuItem
        Action = actCheckNewResAll
      end
      object MenuThrePtrl: TMenuItem
        Action = actTabPtrl
      end
      object MenuThreStop: TMenuItem
        Caption = #20013#27490'(&S)'
        Enabled = False
        OnClick = MenuThreStopClick
      end
      object MenuReplay: TMenuItem
        Action = actWriteRes
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object MenuThreToggleAutoReload: TMenuItem
        Caption = #12458#12540#12488#12522#12525#12540#12489'(&R)'
        OnClick = ViewPopupToggleAutoReloadClick
      end
      object MenuThreToggleAutoScroll: TMenuItem
        Caption = #12458#12540#12488#12473#12463#12525#12540#12523'(&S)'
        OnClick = ViewPopupToggleAutoScrollClick
      end
      object MenuThreAutoReSc: TMenuItem
        Action = actAutoReSc
      end
      object N80: TMenuItem
        Caption = '-'
      end
      object MenuThreOpenByBrowser: TMenuItem
        Action = actOpenByBrowser
      end
      object N40: TMenuItem
        Caption = '-'
      end
      object MenuCopyURL: TMenuItem
        Action = actCopyURL
      end
      object MenuCopyTITLE: TMenuItem
        Action = actCopyTITLE
      end
      object MenuCopyTU: TMenuItem
        Action = actCopyTU
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object MenuOpenBoard: TMenuItem
        Action = actOpenBoard
        Caption = #12371#12398#26495#12434#38283#12367'(&B)'
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object MenuThreLogDel: TMenuItem
        Action = actRemvoeLog
      end
      object MenuThreReload: TMenuItem
        Action = actReload
      end
      object N73: TMenuItem
        Caption = #12371#12398#12525#12464#12434#20445#23384
        object datS1: TMenuItem
          Action = actSaveDat
        end
        object datD3: TMenuItem
          Action = actCopyDat
        end
        object datidxI2: TMenuItem
          Action = actCopyDI
        end
      end
      object N51: TMenuItem
        Caption = '-'
      end
      object MenuThreReadPos: TMenuItem
        Caption = #12371#12371#12414#12391#35501#12435#12384'(&K)'
        object MenuThreSetReadPos: TMenuItem
          Caption = #12371#12398#36794#12414#12391#35501#12435#12384'(&T)'
          OnClick = PopupViewSetReadPosClick
        end
        object MenuThreJumpToReadPos: TMenuItem
          Caption = #12300#12371#12371#12414#12391#35501#12435#12384#12301#12395#12472#12515#12531#12503'(&J)'
          OnClick = MenuThreJumpToReadPosClick
        end
        object MenuThreReadPosClear: TMenuItem
          Caption = #12300#12371#12371#12414#12391#35501#12435#12384#12301#12434#35299#38500'(&C)'
          OnClick = MenuThreReadPosClearClick
        end
      end
      object MenuThreCheckRes: TMenuItem
        Caption = #12524#12473#12398#12481#12455#12483#12463'(&I)'
        OnClick = MenuThreCheckResClick
        object MenuThreCheckResAllClear: TMenuItem
          Caption = #12524#12473#12398#12481#12455#12483#12463#12434#20840#12390#35299#38500'(&R)'
          OnClick = MenuThreCheckResAllClearClick
        end
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object MenuThreJumpRes: TMenuItem
        Caption = #25351#23450#12524#12473#30058#21495#12395#12472#12515#12531#12503'(&J)...'
        OnClick = MenuThreJumpResClick
      end
      object MenuThrePopupRes: TMenuItem
        Caption = #36984#25246#30058#21495#12398#12524#12473#12434#12509#12483#12503#12450#12483#12503
        Visible = False
        OnClick = MenuThrePopupResClick
      end
      object MenuThreChangeDrawLines: TMenuItem
        Caption = #34920#31034#12524#12473#25968#12434#22793#26356'(&G)'
        Enabled = False
        Hint = #34920#31034#12524#12473#25968
        object MenuDrawAll: TMenuItem
          Caption = #20840#12524#12473#34920#31034'(&0)'
          OnClick = MenuDrawAllClick
        end
        object MenuDraw50: TMenuItem
          Tag = 50
          Caption = #26368#26032' 50'#12524#12473'(&1)'
          OnClick = MenuDrawAllClick
        end
        object MenuDraw100: TMenuItem
          Tag = 100
          Caption = #26368#26032'100'#12524#12473'(&2)'
          OnClick = MenuDrawAllClick
        end
        object MenuDraw250: TMenuItem
          Tag = 250
          Caption = #26368#26032'250'#12524#12473'(&3)'
          OnClick = MenuDrawAllClick
        end
        object MenuDraw500: TMenuItem
          Tag = 500
          Caption = #26368#26032'500'#12524#12473'(&4)'
          OnClick = MenuDrawAllClick
        end
      end
    end
    object MenuBoardFavorites: TMenuItem
      Caption = #12362#27671#12395#20837#12426'(&F)'
      OnClick = FavMenuCreate
    end
    object MenuMemo: TMenuItem
      Caption = #12513#12514#27396'(&M)'
      OnClick = MenuMemoClick
      object MenuMemoCanMove: TMenuItem
        Caption = #12513#12514#27396#12434#31227#21205#21487#33021#12395#12377#12427
        OnClick = ToolButtonWriteTitleAutoHideClick
      end
      object MenuMemoPos: TMenuItem
        Caption = #12513#12514#27396#12434#12473#12524#12499#12517#12540#12398#19979#12395#37197#32622#12377#12427
        OnClick = MenuWritePanelPosClick
      end
      object MenuMemoDisableStatusBar: TMenuItem
        Caption = #12473#12486#12540#12479#12473#12496#12540#38750#34920#31034
        OnClick = MenuWritePanelDisableStatusBarClick
      end
      object MenuWriteMemoDisableTopBar: TMenuItem
        Caption = #12488#12483#12503#12496#12540#38750#34920#31034
        OnClick = MenuWritePanelDisableTopBarClick
      end
      object N86: TMenuItem
        Caption = '-'
      end
      object MenuMemoRestore: TMenuItem
        Caption = #12513#12514#27396#12398#20301#32622#24489#24112
        OnClick = MenuMemoRestoreClick
      end
    end
    object Find1: TMenuItem
      Caption = #26908#32034'(&S)'
      OnClick = Find1Click
      object MenuFind: TMenuItem
        Caption = #26908#32034'(&F)...'
        ShortCut = 16454
        OnClick = MenuFindClick
      end
      object FindNext: TMenuItem
        Caption = #8595#26908#32034'(&N)'
        ShortCut = 114
        OnClick = FindNextClick
      end
      object FindPrev: TMenuItem
        Caption = #8593#26908#32034'(&P)'
        ShortCut = 8306
        OnClick = FindPrevClick
      end
      object N59: TMenuItem
        Caption = '-'
      end
      object MenuExtractKeyword: TMenuItem
        Action = actKeywordExtraction
        Caption = #12524#12473#25277#20986'(&E)...'
      end
      object N60: TMenuItem
        Caption = '-'
      end
      object MenuShowResTree: TMenuItem
        Tag = -1
        Action = actShowResTree
      end
      object MenuShowOutLine: TMenuItem
        Tag = -1
        Action = actShowOutLine
      end
      object FindThreadSep: TMenuItem
        Caption = '-'
      end
      object MenuFindThreadNew: TMenuItem
        Caption = #26032#12383#12395#12473#12524#32094#12426#36796#12415'(&S)...'
        OnClick = MenuFindThreadClick
      end
      object MenuFindThread: TMenuItem
        Caption = #12473#12524#32094#12426#36796#12415'(&T)...'
        OnClick = MenuFindThreadClick
      end
      object MenuClearFindThreadResult: TMenuItem
        Caption = #12473#12524#32094#12426#36796#12415#32080#26524#12463#12522#12450'(&C)'
        OnClick = MenuClearFindThreadResultClick
      end
      object FindGrep: TMenuItem
        Caption = #12525#12464#12363#12425#26908#32034' pre-'#946'(&G)...'
        OnClick = FindGrepClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object FindNavigate: TMenuItem
        Caption = '2ch'#12398'URL'#12395#12472#12515#12531#12503'(&U)...'
        ShortCut = 16397
        OnClick = FindNavigateClick
      end
      object MenuFindeThreadTitle: TMenuItem
        Caption = #12473#12524#12483#12489#12479#12452#12488#12523#26908#32034
        OnClick = MenuFindeThreadTitleClick
      end
    end
    object MenuThreadRefresh: TMenuItem
      Action = actGeneralUpdate
      Caption = #12298#26356#26032'(&U)'#12299
    end
    object MenuView: TMenuItem
      Caption = #34920#31034'(&V)'
      OnClick = MenuViewClick
      object MenuViewToolBarToggleVisible: TMenuItem
        Caption = #12484#12540#12523#12496#12540'(&T)'
        Checked = True
        OnClick = MenuViewToolBarToggleVisibleClick
      end
      object MenuViewLinkBarToggleVisible: TMenuItem
        Caption = #12522#12531#12463#12496#12540'(&L)'
        Checked = True
        OnClick = MenuViewLinkBarToggleVisibleClick
      end
      object MenuViewAddressBarToggleVisible: TMenuItem
        Caption = #12450#12489#12524#12473#12496#12540'(&A)'
        Checked = True
        OnClick = MenuViewAddressBarToggleVisibleClick
      end
      object MenuViewTreeToggleVisible: TMenuItem
        Action = actTreeToggleVisible
      end
      object MenuViewMenuToggleVisible: TMenuItem
        Caption = #12513#12491#12517#12540'(&M)'
        Checked = True
        OnClick = MenuViewMenuToggleVisibleClick
      end
      object MenuViewWriteMemoToggleVisible: TMenuItem
        Caption = #12513#12514#27396'(&W)'
        Checked = True
        OnClick = StatusBarClick
      end
      object N47: TMenuItem
        Caption = '-'
      end
      object MenuToggleRPane: TMenuItem
        Caption = #21491#20596#20999#26367'(&X)'
        OnClick = MenuToggleRPaneClick
      end
      object MenuViewDivisionChange: TMenuItem
        Action = actDivisionChange
      end
      object MenuViewPaneModeChange: TMenuItem
        Action = actPaneModeChange
      end
    end
    object ool1: TMenuItem
      Caption = #12484#12540#12523'(&O)'
      object MenuOptOnline: TMenuItem
        Action = actOnLine
      end
      object MenuOptLogin: TMenuItem
        Action = actLogin
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MenuOptDumpShortcut: TMenuItem
        Caption = 'keyconf.ini'#26356#26032#65288'&K)'
        OnClick = MenuOptDumpShortcutClick
      end
      object MenuFavPatrol: TMenuItem
        Caption = #26356#26032#12481#12455#12483#12463'(&P)'
        OnClick = MenuFavPatrolClick
      end
      object N83: TMenuItem
        Caption = '-'
      end
      object LovelyBrowser1: TMenuItem
        Caption = 'LovelyBrowser'
        OnClick = LovelyBrowser1Click
      end
      object MenuCommand: TMenuItem
        Caption = #12467#12510#12531#12489'(&C)'
        OnClick = MenuCommandClick
      end
      object MenuAA: TMenuItem
        Caption = 'AA(&A)'
        object MenuAAEdit: TMenuItem
          Caption = #38283#12367
          OnClick = MenuAAEditClick
        end
      end
      object MenuOptNews: TMenuItem
        Caption = #12491#12517#12540#12473#27231#33021
        object MenuOptUseNews: TMenuItem
          Caption = #12491#12517#12540#12473#27231#33021#12434#26377#21177#12395#12377#12427
          OnClick = MenuOptUseNewsClick
        end
        object MenuOptSetNewsInterval: TMenuItem
          Caption = #12491#12517#12540#12473#20999#26367#38291#38548#12398#35373#23450
          OnClick = MenuOptSetNewsIntervalClick
        end
        object MenuOptSetNewsSize: TMenuItem
          Caption = #12491#12517#12540#12473#12496#12540#12398#24133#12398#35373#23450
          OnClick = MenuOptSetNewsSizeClick
        end
      end
      object MenuClearHistory: TMenuItem
        Caption = #23653#27508#28040#21435
        object MenuClearSearchHistory: TMenuItem
          Tag = 1
          Caption = #26908#32034#23653#27508#28040#21435
          OnClick = MenuClearHistroy
        end
        object MenuClearName: TMenuItem
          Tag = 2
          Caption = #21517#21069#23653#27508#28040#21435
          OnClick = MenuClearHistroy
        end
        object MenuClearMail: TMenuItem
          Tag = 3
          Caption = #12513#12540#12523#23653#27508#28040#21435
          OnClick = MenuClearHistroy
        end
      end
      object MenuImageView: TMenuItem
        Caption = #30011#20687'(&I)'
        object MenuOpenImageView: TMenuItem
          Caption = #12499#12517#12540#12450'(&V)'
          ShortCut = 16457
          OnClick = OpenImageView
        end
        object MenuOpenURLOnMouseOver: TMenuItem
          Caption = #12510#12454#12473#12458#12540#12496#12540#12391#30011#20687#12434#38283#12367'(&M)'
          OnClick = MenuOpenURLOnMouseOverClick
        end
        object MenuWatchClipboard: TMenuItem
          Caption = #12463#12522#12483#12503#12508#12540#12489#30435#35222'(&C)'
          OnClick = MenuWatchClipboardClick
        end
        object VN1: TMenuItem
          Caption = '-'
        end
        object MenuImageViewOpenCacheList: TMenuItem
          Caption = #12461#12515#12483#12471#12517#19968#35239'(&C)'
          OnClick = MenuImageViewOpenCacheListClick
        end
      end
      object N66: TMenuItem
        Caption = '-'
      end
      object MenuImageViewPreference: TMenuItem
        Caption = #12499#12517#12540#12450#35373#23450'(&V)'
        OnClick = OpenImageViewPreference
      end
      object MenuToolsOptions: TMenuItem
        Caption = #35373#23450'(&O)...'
        OnClick = MenuToolsOptionsClick
      end
    end
    object MenuWindow: TMenuItem
      Caption = #31379'(&W)'
      OnClick = MenuWindowClick
      object MenuWndClose: TMenuItem
        Caption = #29694#22312#12398#12506#12452#12531#12398#12479#12502#12434#38281#12376#12427'(&C)'
        OnClick = MenuWndCloseClick
      end
      object N43: TMenuItem
        Caption = '-'
      end
      object MenuWndCloseOtherTabs: TMenuItem
        Caption = #36984#25246#12373#12428#12390#12356#12394#12356#12479#12502#12434#38281#12376#12427'(&W)'
        OnClick = MenuWndCloseOtherTabsClick
      end
      object MenuWndCloseAllTabs: TMenuItem
        Caption = #20840#12390#12398#12479#12502#12434#38281#12376#12427
        OnClick = MenuWndCloseAllTabsClick
      end
      object MenuWndCloseLeftTabs: TMenuItem
        Caption = #12371#12428#12424#12426#24038#12434#38281#12376#12427
        OnClick = MenuWndCloseLeftTabsClick
      end
      object MenuWndCloseRightTabs: TMenuItem
        Caption = #12371#12428#12424#12426#21491#12434#38281#12376#12427
        OnClick = MenuWndCloseRightTabsClick
      end
      object MenuWndTabMenuSep: TMenuItem
        Caption = '-'
      end
      object MenuWndBoard: TMenuItem
        Caption = #26495'(&B)'
        OnClick = MenuWndBoardClick
      end
      object MenuWndFav: TMenuItem
        Tag = 1
        Caption = #12362#27671#12395#20837#12426'(&F)'
        OnClick = MenuWndBoardClick
      end
      object MenuWndThList: TMenuItem
        Caption = #12473#12524#19968#35239'(&L)'
        OnClick = MenuWndThListClick
      end
      object MenuWndThread: TMenuItem
        Caption = #12473#12524'(&T)'
        OnClick = MenuWndThreadClick
      end
      object N29: TMenuItem
        Caption = '-'
      end
      object MenuViewNextPane: TMenuItem
        Caption = #27425#12398#12506#12452#12531'(&V)'
        ShortCut = 115
        OnClick = MenuViewNextPaneClick
      end
      object MenuViewPrevPane: TMenuItem
        Caption = #21069#12398#12506#12452#12531'(&X)'
        ShortCut = 8307
        OnClick = MenuViewPrevPaneClick
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object MenuWndPrevTab: TMenuItem
        Caption = #21069#12398#12479#12502'(&P)'
        ShortCut = 16417
        OnClick = MenuWndPrevTabClick
      end
      object MenuWndNextTab: TMenuItem
        Caption = #27425#12398#12479#12502'(&N)'
        ShortCut = 16418
        OnClick = MenuWndNextTabClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object MenuWindowCascade: TMenuItem
        Caption = #37325#12397#12390#34920#31034'(&S)'
        ShortCut = 8308
        OnClick = MenuWindowCascadeClick
      end
      object MenuWindowTileVertically: TMenuItem
        Caption = #24038#21491#12395#20006#12409#12390#34920#31034'(&E)'
        ShortCut = 8309
        OnClick = MenuWindowTileVerticallyClick
      end
      object MenuWindowTileHorizontally: TMenuItem
        Caption = #19978#19979#12395#20006#12409#12390#34920#31034'(&H)'
        ShortCut = 117
        OnClick = MenuWindowTileHorizontallyClick
      end
      object MenuWindowRestoreAll: TMenuItem
        Caption = #12377#12409#12390#20803#12398#12469#12452#12474#12395#25147#12377
        ShortCut = 24690
        OnClick = MenuWindowRestoreAllClick
      end
      object MenuWindowMaximizeAll: TMenuItem
        Caption = #12377#12409#12390#26368#22823#21270
        ShortCut = 24692
        OnClick = MenuWindowMaximizeAllClick
      end
      object N55: TMenuItem
        Caption = '-'
      end
      object MenuWndHideInTaskTray: TMenuItem
        Caption = #12479#12473#12463#12488#12524#12452#12395#26684#32013'(&H)'
        OnClick = MenuWndHideInTaskTrayClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object ViewZoom: TMenuItem
        Caption = #25991#23383#12398#12469#12452#12474'(&S)'
        object ZoomG: TMenuItem
          Caption = #26368#22823'(&G)'
          OnClick = ZoomClick
        end
        object ZoomL: TMenuItem
          Caption = #22823'(&L)'
          OnClick = ZoomClick
        end
        object ZoomM: TMenuItem
          Caption = #20013'(&M)'
          OnClick = ZoomClick
        end
        object ZoomS: TMenuItem
          Caption = #23567'(&S)'
          OnClick = ZoomClick
        end
        object ZoomA: TMenuItem
          Caption = #26368#23567'(&A)'
          OnClick = ZoomClick
        end
      end
      object MenuWndRecently: TMenuItem
        Caption = #38281#12376#12383#12473#12524'(&R)'
      end
      object MenuWndLastClosed: TMenuItem
        Caption = #26368#24460#12395#38281#12376#12383#12473#12524
        Visible = False
        OnClick = MenuWndLastClosedClick
      end
      object VN2: TMenuItem
        Caption = '-'
      end
      object MenuChangeAboneLevel: TMenuItem
        Caption = #12525#12540#12459#12523#12354#12412#12540#12435#34920#31034#12398#22793#26356'(&L)'
        object MenuTransparencyAbone: TMenuItem
          Action = actTransparencyAbone
          GroupIndex = 1
          RadioItem = True
        end
        object MenuNormalAbone: TMenuItem
          Action = actNormalAbone
          GroupIndex = 1
          RadioItem = True
        end
        object MenuHalfAbone: TMenuItem
          Action = actHalfAbone
          GroupIndex = 1
          RadioItem = True
        end
        object MenuIgnoreAbone: TMenuItem
          Action = actIgnoreAbone
          GroupIndex = 1
          RadioItem = True
        end
        object MenuImportantResOnly: TMenuItem
          Action = actImportantResOnly
          GroupIndex = 1
          RadioItem = True
        end
        object MenuAboneOnly: TMenuItem
          Action = actAboneOnly
          GroupIndex = 1
        end
      end
      object MenuWindowSep: TMenuItem
        Caption = '-'
      end
    end
    object MenuHelps: TMenuItem
      Caption = #12504#12523#12503'(&H)'
      object MenuHelp: TMenuItem
        Caption = #12504#12523#12503'(&H)...'
        OnClick = MenuHelpClick
      end
      object N57: TMenuItem
        Caption = '-'
      end
      object MenuHelpAbout: TMenuItem
        Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)...'
        OnClick = MenuHelpAboutClick
      end
    end
    object DebugTmp: TMenuItem
      Caption = '&Debug'
      Enabled = False
      Visible = False
      OnClick = DebugTmpClick
    end
    object SystemKey: TMenuItem
      Caption = 'Key'
      Visible = False
      object ArrowUp: TMenuItem
        Tag = 38
        Caption = 'Up'
        OnClick = KeyEmulateClick
      end
      object ArrowDown: TMenuItem
        Tag = 40
        Caption = 'Down'
        OnClick = KeyEmulateClick
      end
      object ArrowRight: TMenuItem
        Tag = 39
        Caption = 'Right'
        OnClick = KeyEmulateClick
      end
      object ArrowLeft: TMenuItem
        Tag = 37
        Caption = 'Left'
        OnClick = KeyEmulateClick
      end
      object SysPgUp: TMenuItem
        Tag = 33
        Caption = 'PgUp'
        OnClick = KeyEmulateClick
      end
      object SysPgDn: TMenuItem
        Tag = 34
        Caption = 'PgDn'
        OnClick = KeyEmulateClick
      end
      object SysHome: TMenuItem
        Tag = 36
        Caption = 'Home'
        OnClick = KeyEmulateClick
      end
      object SysEnd: TMenuItem
        Tag = 35
        Caption = 'End'
        OnClick = KeyEmulateClick
      end
      object SysEnter: TMenuItem
        Tag = 13
        Caption = 'Enter'
        OnClick = KeyEmulateClick
      end
      object SysCtrlHome: TMenuItem
        Tag = 36
        Caption = 'CtrlHome'
        OnClick = KeyEmulateCtrlClick
      end
      object SysCtrlEnd: TMenuItem
        Tag = 35
        Caption = 'CtrlEnd'
        OnClick = KeyEmulateCtrlClick
      end
    end
  end
  object ListPopupMenu: TPopupMenu
    OnPopup = ListPopupMenuPopup
    Left = 176
    Top = 144
    object ListPopupHide: TMenuItem
      Action = actListOpenHide
    end
    object ListPopupNew: TMenuItem
      Action = actListOpenNew
    end
    object ListPopupOpen: TMenuItem
      Action = actListOpenCurrent
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object ListPopupCloseThisThread: TMenuItem
      Action = actListCloseThisThread
    end
    object N93: TMenuItem
      Caption = '-'
    end
    object PopupListCanClose: TMenuItem
      Action = actListCanClose
    end
    object ListPopupAlready: TMenuItem
      Action = actListAlready
    end
    object ListPopupSetFavorite: TMenuItem
      Action = actListToggleMarker
    end
    object ListPopupRegFavorite: TMenuItem
      Action = actListAddFav
    end
    object ListPopupDelFav: TMenuItem
      Action = actListDelFav
    end
    object N39: TMenuItem
      Caption = '-'
    end
    object ListPopupOpenByBrowser: TMenuItem
      Action = actListOpenByBrowser
    end
    object ListPopupChottoView: TMenuItem
      Caption = #12385#12423#12387#12392#35211#12427
      OnClick = ListPopupChottoViewClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ListPopupCopyURL: TMenuItem
      Action = actListCopyURL
    end
    object E1: TMenuItem
      Action = actListCopyTITLE
    end
    object ListPopupCopyTU: TMenuItem
      Action = actListCopyTU
    end
    object N69: TMenuItem
      Caption = '-'
    end
    object N101: TMenuItem
      Action = actThreadAbone4
    end
    object A1: TMenuItem
      Action = actThreadAbone
    end
    object N99: TMenuItem
      Action = actThreadAbone3
    end
    object N96: TMenuItem
      Action = actThreadAbone2
    end
    object N25: TMenuItem
      Caption = '-'
    end
    object N70: TMenuItem
      Caption = #36984#25246#20013#12398#12525#12464#12434#12467#12500#12540'(&C)'
      object datD1: TMenuItem
        Action = actListCopyDat
      end
      object datidx1: TMenuItem
        Action = actListCopyDI
      end
    end
    object N102: TMenuItem
      Caption = '-'
    end
    object ListPopupDel: TMenuItem
      Action = actListDelLog
    end
  end
  object HintTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = HintTimerTimer
    Left = 48
    Top = 344
  end
  object ThreadPopupMenu: TPopupMenu
    OnPopup = ThreadPopupMenuPopup
    Left = 136
    Top = 200
    object ViewPopupClose: TMenuItem
      Action = actCloseThisTab
    end
    object ViewPopupCloseWOSave: TMenuItem
      Action = actCloseThisTabWOSave
    end
    object N65: TMenuItem
      Caption = #35079#25968#12398#12479#12502#12434#38281#12376#12427
      object ViewPopupCloseOthers: TMenuItem
        Action = actCloseOtherTabs
      end
      object ViewPopupCloseAll: TMenuItem
        Action = actCloseAllTabs
      end
      object ViewPopupCloseLeft: TMenuItem
        Action = actCloseLeftTabs
      end
      object ViewPopupCloseRight: TMenuItem
        Action = actCloseRightTabs
      end
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object ViewPopupNotClose: TMenuItem
      Caption = #12371#12398#12479#12502#12399#38281#12376#12394#12356
      OnClick = ViewPopupNotCloseClick
    end
    object ViewPopupMark: TMenuItem
      Caption = #21360#12434#20184#12369#12427'(&M)'
      OnClick = ThreadToggleMarker
    end
    object ViewPopupFavorite: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152'(&A)'
      OnClick = ViewPopupFavoriteClick
    end
    object ViewPopupDelFav: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12434#21066#38500'(&V)'
      OnClick = ViewPopupDelFavClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object ViewPopupCheckNewAll: TMenuItem
      Action = actCheckNewResAll
    end
    object ViewPopupCheckNew: TMenuItem
      Caption = #12522#12525#12540#12489'(&N)'
      OnClick = ViewPopupCheckNewClick
    end
    object ViewPopupStop: TMenuItem
      Action = actStop
    end
    object ViewPopupRes: TMenuItem
      Caption = #12524#12473'(&R)...'
      Enabled = False
      Hint = #12524#12473
      OnClick = ViewPopupResClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object ViewPopupToggleAutoReload: TMenuItem
      Caption = #12458#12540#12488#12522#12525#12540#12489'(&R)'
      OnClick = ViewPopupToggleAutoReloadClick
    end
    object ViewPopupToggleAutoScroll: TMenuItem
      Caption = #12458#12540#12488#12473#12463#12525#12540#12523'(&S)'
      OnClick = ViewPopupToggleAutoScrollClick
    end
    object ViewPopupToggleAutoReSc: TMenuItem
      Action = actAutoReSc
    end
    object N74: TMenuItem
      Caption = '-'
    end
    object ViewPopupAutoScrollAtAnyTime: TMenuItem
      Caption = #24120#12395#12458#12540#12488#12473#12463#12525#12540#12523'(&A)'
      OnClick = ViewPopupAutoScrollAtAnyTimeClick
    end
    object ViewPopupAutoScrollSpeed: TMenuItem
      Caption = #12458#12540#12488#12473#12463#12525#12540#12523#12473#12500#12540#12489
      object Scroll8: TMenuItem
        Tag = 8
        Caption = #36895#12373#65304
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll7: TMenuItem
        Tag = 7
        Caption = #36895#12373#65303
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll6: TMenuItem
        Tag = 6
        Caption = #36895#12373#65302
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll5: TMenuItem
        Tag = 5
        Caption = #36895#12373#65301
        Checked = True
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll4: TMenuItem
        Tag = 4
        Caption = #36895#12373#65300
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll3: TMenuItem
        Tag = 3
        Caption = #36895#12373#65299
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll2: TMenuItem
        Tag = 2
        Caption = #36895#12373#65298
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object Scroll1: TMenuItem
        Tag = 1
        Caption = #36895#12373#65297
        RadioItem = True
        OnClick = ViewPopupScrollSpeedClick
      end
      object ViewPopupAutoScrollSetting: TMenuItem
        Caption = #12473#12463#12525#12540#12523#12473#12500#12540#12489#12398#35373#23450
        OnClick = ViewPopupAutoScrollSettingClick
      end
    end
    object ViewPopupOpenAutoReloadSettingForm: TMenuItem
      Caption = #12458#12540#12488#12522#12525#12540#12489#12398#35373#23450
      OnClick = ViewPopupOpenAutoReloadSettingFormClick
    end
    object N63: TMenuItem
      Caption = '-'
    end
    object ViewPopupOpenByBrowser: TMenuItem
      Caption = #12502#12521#12454#12470#12391#38283#12367'(&Z)'
      OnClick = ViewPopupOpenByBrowserClick
    end
    object N38: TMenuItem
      Caption = '-'
    end
    object ViewPopupURLCopy: TMenuItem
      Caption = 'URL'#12434#12467#12500#12540'(&L)'
      OnClick = ViewPopupURLCopyClick
    end
    object ViewPopupTITLECopy: TMenuItem
      Caption = #12479#12452#12488#12523#12434#12467#12500#12540'(&E)'
      OnClick = ViewPopupTITLECopyClick
    end
    object ViewPopupTUCopy: TMenuItem
      Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540'(&T)'
      OnClick = ViewPopupTUCopyClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object ViewPopupOpenBoard: TMenuItem
      Caption = #12371#12398#26495#12434#38283#12367'(&B)'
      OnClick = ViewPopupOpenBoardClick
    end
    object N58: TMenuItem
      Caption = '-'
    end
    object ViewPopupSetAlready: TMenuItem
      Caption = #26082#35501#12395#12377#12427
      OnClick = ViewPopupSetAlreadyClick
    end
    object ViewPopupReadPos: TMenuItem
      Caption = #12371#12371#12414#12391#35501#12435#12384'(&K)'
      OnClick = ViewPopupReadPosClick
      object ViewPopupSetReadPos: TMenuItem
        Action = actSetReadPos
      end
      object ViewPopupJumpToReadPos: TMenuItem
        Action = actJumpToReadPos
      end
      object ViewPopupReadPosClear: TMenuItem
        Action = actReadPosClear
        Caption = #12300#12371#12371#12414#12391#35501#12435#12384#12301#12434#35299#38500'(&C)'
      end
    end
    object ViewPopupCheckRes: TMenuItem
      Caption = #12524#12473#12398#12481#12455#12483#12463'(&I)'
      OnClick = ViewPopupCheckResClick
      object ViewPopupCheckResAllClear: TMenuItem
        Action = actCheckResAllClear
      end
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object ViewPopupDel: TMenuItem
      Caption = #12371#12398#12525#12464#12434#21066#38500'(&D)'
      OnClick = ViewPopupDelClick
    end
    object ViewPopupReload: TMenuItem
      Caption = #20877#35501#36796#12415#946'(&O)'
      OnClick = ViewPopupReloadClick
    end
    object N68: TMenuItem
      Caption = #12371#12398#12525#12464#12434#20445#23384
      object ViewPopupSaveDat: TMenuItem
        Caption = 'dat'#12434#21517#21069#12434#20184#12369#12390#20445#23384'(&S)'
        OnClick = ViewPopupSaveDatClick
      end
      object ViewPopupCopyDAT: TMenuItem
        Caption = 'dat'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&D)'
        OnClick = ViewPopupCopyDATClick
      end
      object ViewPopupCopyDI: TMenuItem
        Caption = 'dat'#12392'idx'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&I)'
        OnClick = ViewPopupCopyDIClick
      end
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 312
    object actThreadAboneTranseparency: TAction
      Tag = -1
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #36879#26126
      Checked = True
      GroupIndex = 2
      OnExecute = actThreadAboneShowExecute
    end
    object actWriteRes: TAction
      Caption = #12524#12473'(&R)...'
      Enabled = False
      Hint = #12524#12473
      OnExecute = ThreadWriteButtonClick
    end
    object actThreadAboneNormal: TAction
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12405#12388#12358
      GroupIndex = 2
      OnExecute = actThreadAboneShowExecute
    end
    object actThreadAboneIgnore: TAction
      Tag = 1
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12373#12412#12426
      GroupIndex = 2
      OnExecute = actThreadAboneShowExecute
    end
    object actThreadAboneImportantResOnly: TAction
      Tag = 2
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12424#12426#12372#12398#12415
      GroupIndex = 2
      OnExecute = actThreadAboneShowExecute
    end
    object actCheckNewRes: TAction
      Caption = #12522#12525#12540#12489'(&U)'
      Enabled = False
      Hint = #12522#12525#12540#12489
      OnExecute = ThreadChkNewResButtonClick
    end
    object actScrollToNew: TAction
      Caption = #26032#30528#12414#12391#12473#12463#12525#12540#12523'(&N)'
      Enabled = False
      Hint = #26032#30528#12414#12391#12473#12463#12525#12540#12523
      OnExecute = actScrollToNewExecute
    end
    object actCloseTab: TAction
      Caption = #12479#12502#12434#38281#12376#12427
      Hint = #12479#12502#12434#38281#12376#12427
      OnExecute = actCloseTabExecute
    end
    object actCloseThisTab: TAction
      Caption = #12371#12398#12479#12502#12434#38281#12376#12427'(&C)'
      Hint = #12371#12398#12479#12502#12434#38281#12376#12427
      OnExecute = actCloseThisTabExecute
    end
    object actCloseOtherTabs: TAction
      Caption = #12371#12398#12479#12502#20197#22806#12434#38281#12376#12427'(&W)'
      OnExecute = actCloseOtherTabsExecute
    end
    object actCloseAllTabs: TAction
      Caption = #20840#12390#12398#12479#12502#12434#38281#12376#12427
      OnExecute = actCloseAllTabsExecute
    end
    object actCloseRightTabs: TAction
      Caption = #12371#12428#12424#12426#21491#12434#38281#12376#12427
      OnExecute = actCloseRightTabsExecute
    end
    object actCloseLeftTabs: TAction
      Caption = #12371#12428#12424#12426#24038#12434#38281#12376#12427
      OnExecute = actCloseLeftTabsExecute
    end
    object actCloseThisTabWOSave: TAction
      Caption = #26410#35501#12392#12375#12390#38281#12376#12427'(&Q)'
      OnExecute = actCloseThisTabWOSaveExecute
    end
    object actToggleMarker: TAction
      Caption = #21360#12434#20184#12369#12427'(&M)'
      OnExecute = actToggleMarkerExecute
    end
    object actOpenBoard: TAction
      Caption = #26495#12434#38283#12367'(&B)'
      OnExecute = actOpenBoardExecute
    end
    object actCopyURL: TAction
      Caption = 'URL'#12434#12467#12500#12540'(&L)'
      OnExecute = actCopyURLExecute
    end
    object actCopyTITLE: TAction
      Caption = #12479#12452#12488#12523#12434#12467#12500#12540'(&E)'
      OnExecute = actCopyTITLEExecute
    end
    object actCopyTU: TAction
      Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540'(&T)'
      OnExecute = actCopyTUExecute
    end
    object actAddFavorite: TAction
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152'(&A)'
      Enabled = False
      Hint = #12362#27671#12395#20837#12426#12395#36861#21152
      OnExecute = actAddFavoriteExecute
    end
    object actDeleteFavorite: TAction
      Caption = #12362#27671#12395#20837#12426#12434#21066#38500'(&V)'
      Enabled = False
      OnExecute = actDeleteFavoriteExecute
    end
    object actScrollToPrev: TAction
      Caption = #38281#12376#12383#20184#36817#12395#25147#12427'(&P)'
      Enabled = False
      OnExecute = actScrollToPrevExecute
    end
    object actReload: TAction
      Caption = #20877#35501#36796#12415#946'(&O)'
      OnExecute = actReloadExecute
    end
    object actRemvoeLog: TAction
      Caption = #12371#12398#12525#12464#12434#21066#38500'(&D)'
      Hint = #12525#12464#12434#21066#38500
      OnExecute = actRemvoeLogExecute
    end
    object actStop: TAction
      Caption = #20013#27490'(&S)'
      OnExecute = actStopExecute
    end
    object actListRefresh: TAction
      Category = #12473#12524#27396
      Caption = #12473#12524#19968#35239#26356#26032'(&U)'
      OnExecute = actListRefreshExecute
    end
    object actListOpenNew: TAction
      Category = #12473#12524#27396
      Caption = #26032#12375#12356#12479#12502#12391#38283#12367'(&N)'
      Enabled = False
      OnExecute = actListOpenNewExecute
    end
    object actListOpenCurrent: TAction
      Category = #12473#12524#27396
      Caption = #20170#12398#12479#12502#12391#38283#12367'(&O)'
      Enabled = False
      OnExecute = actListOpenCurrentExecute
    end
    object actListOpenHide: TAction
      Category = #12473#12524#27396
      Caption = #12496#12483#12463#12464#12521#12454#12531#12489#12391#38283#12367'(&H)'
      Enabled = False
      OnExecute = actListOpenHideExecute
    end
    object actListToggleMarker: TAction
      Category = #12473#12524#27396
      Caption = #21360#12434#20184#12369#12427'(&M)'
      Enabled = False
      OnExecute = actListToggleMarkerExecute
    end
    object actListAddFav: TAction
      Category = #12473#12524#27396
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152'(&A)'
      Enabled = False
      OnExecute = actListAddFavExecute
    end
    object actListDelFav: TAction
      Category = #12473#12524#27396
      Caption = #12362#27671#12395#20837#12426#12434#21066#38500'(&V)'
      Enabled = False
      OnExecute = actListDelFavExecute
    end
    object actListDelLog: TAction
      Category = #12473#12524#27396
      Caption = #36984#25246#20013#12398#12525#12464#12434#21066#38500'(&D)'
      Enabled = False
      OnExecute = actListDelLogExecute
    end
    object actListCopyDat: TAction
      Category = #12473#12524#27396
      Caption = 'dat'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&D)'
      OnExecute = actListCopyDatExecute
    end
    object actListCopyDI: TAction
      Category = #12473#12524#27396
      Caption = 'dat'#12392'idx'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&I)'
      OnExecute = actListCopyDIExecute
    end
    object actListCopyURL: TAction
      Category = #12473#12524#27396
      Caption = 'URL'#12434#12467#12500#12540'(&L)'
      Enabled = False
      OnExecute = actListCopyURLExecute
    end
    object actListCopyTITLE: TAction
      Category = #12473#12524#27396
      Caption = #12479#12452#12488#12523#12434#12467#12500#12540'(&E)'
      Enabled = False
      OnExecute = actListCopyTITLEExecute
    end
    object actListCopyTU: TAction
      Category = #12473#12524#27396
      Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540'(&T)'
      Enabled = False
      OnExecute = actListCopyTUExecute
    end
    object actGeneralUpdate: TAction
      Caption = #26356#26032#12481#12455#12483#12463'(&U)'
      Hint = #12522#12525#12540#12489'/'#20840#12479#12502#12522#12525#12540#12489
      OnExecute = actGeneralUpdateExecute
    end
    object actListCloseThisTab: TAction
      Category = #12473#12524#27396
      Caption = #12371#12398#12479#12502#12434#38281#12376#12427'(&C)'
      OnExecute = actListCloseThisTabExecute
    end
    object actListCloseOtherTabs: TAction
      Category = #12473#12524#27396
      Caption = #12371#12398#12479#12502#20197#22806#12434#38281#12376#12427'(&W)'
      OnExecute = actListCloseOtherTabsExecute
    end
    object actListCloseAllTabs: TAction
      Category = #12473#12524#27396
      Caption = #20840#12390#12398#12479#12502#12434#38281#12376#12427
      OnExecute = actListCloseAllTabsExecute
    end
    object actListCloseLeftTabs: TAction
      Category = #12473#12524#27396
      Caption = #12371#12428#12424#12426#24038#12434#38281#12376#12427
      OnExecute = actListCloseLeftTabsExecute
    end
    object actListCloseRightTabs: TAction
      Category = #12473#12524#27396
      Caption = #12371#12428#12424#12426#21491#12434#38281#12376#12427
      OnExecute = actListCloseRightTabsExecute
    end
    object actListOpenByBrowser: TAction
      Category = #12473#12524#27396
      Caption = #12502#12521#12454#12470#12391#38283#12367'(&Z)'
      Enabled = False
      OnExecute = actListOpenByBrowserExecute
    end
    object actOpenByBrowser: TAction
      Caption = #12502#12521#12454#12470#12391#38283#12367'(&Z)'
      OnExecute = actOpenByBrowserExecute
    end
    object actTreeToggleVisible: TAction
      Caption = #26495#12484#12522#12540'(&B)'
      Checked = True
      OnExecute = MenuViewTreeToggleVisibleClick
    end
    object actDivisionChange: TAction
      Caption = #32294#8660#27178#20998#21106#20999#26367'(&D)'
      OnExecute = MenuViewDivisionChangeClick
    end
    object actPaneModeChange: TAction
      Caption = '2'#8660'3'#12506#12452#12531#20999#26367'(&P)'
      OnExecute = MenuViewPaneModeChangeClick
    end
    object actBuildThread: TAction
      Caption = #12473#12524#12483#12489#26032#35215#20316#25104'(&B)'
      Hint = #12473#12524#12483#12489#26032#35215#20316#25104
      OnExecute = actBuildThreadExecute
    end
    object actOnLine: TAction
      Caption = #12458#12531#12521#12452#12531'(&L)'
      Checked = True
      OnExecute = actOnLineExecute
    end
    object actLogin: TAction
      Caption = #12525#12464#12452#12531'(&I)'
      OnExecute = actLoginExecute
    end
    object actSetReadPos: TAction
      Caption = #12371#12398#36794#12414#12391#35501#12435#12384'(&T)'
      OnExecute = actSetReadPosExecute
    end
    object actReadPosClear: TAction
      Caption = #12371#12371#12414#12391#35501#12435#12384#12434#35299#38500'(&C)'
      OnExecute = actReadPosClearExecute
    end
    object actJumpToReadPos: TAction
      Caption = #12300#12371#12371#12414#12391#35501#12435#12384#12301#12395#12472#12515#12531#12503'(&J)'
      OnExecute = actJumpToReadPosExecute
    end
    object actCheckResPopup: TAction
      OnExecute = actCheckResPopupExecute
    end
    object actCheckResSubMenu: TAction
      OnExecute = actCheckResSubMenuExecute
    end
    object actCheckResAllClear: TAction
      Caption = #12524#12473#12398#12481#12455#12483#12463#12434#20840#12390#35299#38500'(&R)'
      OnExecute = actCheckResAllClearExecute
    end
    object actTransparencyAbone: TAction
      Tag = -1
      Category = 'View'
      Caption = #12392#12358#12417#12356
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actNormalAbone: TAction
      Category = 'View'
      Caption = #12405#12388#12358
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actHalfAbone: TAction
      Tag = 1
      Category = 'View'
      Caption = #12413#12387#12407#12354#12387#12407
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actIgnoreAbone: TAction
      Tag = 2
      Category = 'View'
      Caption = #12373#12412#12426
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actImportantResOnly: TAction
      Tag = 3
      Category = 'View'
      Caption = #12424#12426#12372#12398#12415
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actKeywordExtraction: TAction
      Caption = #12524#12473#25277#20986'(&E)'
      Hint = #12524#12473#25277#20986
      OnExecute = actKeywordExtractionExecute
    end
    object actBack: TAction
      Caption = #25147#12427'(&B)'
      OnExecute = actBackExecute
    end
    object actForword: TAction
      Caption = #36914#12416'(&F)'
      OnExecute = actForwordExecute
    end
    object actShowResTree: TAction
      Tag = -1
      Category = 'View'
      Caption = #12473#12524#12398#12484#12522#12540#24418#24335#34920#31034'(&R)'
      OnExecute = PopupViewShowResTreeClick
    end
    object actShowOutLine: TAction
      Tag = -1
      Category = 'View'
      Caption = #12473#12524#12398#12450#12454#12488#12521#12452#12531#34920#31034'(&O)'
      OnExecute = PopupViewShowResTreeClick
    end
    object actAboneOnly: TAction
      Tag = 4
      Category = 'View'
      Caption = #12399#12365#12384#12417
      GroupIndex = 1
      OnExecute = actAboneLevelExecute
    end
    object actSelectedKeywordExtraction: TAction
      Category = 'View'
      Caption = #36984#25246#21336#35486#12391#12524#12473#25277#20986
      OnExecute = actSelectedKeywordExtractionExecute
    end
    object actAutoReSc: TAction
      Caption = #12458#12540#12488#12522#12525#12540#12489#12539#12458#12540#12488#12473#12463#12525#12540#12523'(&A)'
      Enabled = False
      OnExecute = actAutoReScExecute
    end
    object actCheckNewResAll: TAction
      Caption = #12377#12409#12390#12398#12479#12502#12398#12522#12525#12540#12489
      Enabled = False
      Hint = #12377#12409#12390#12398#12479#12502#12398#12522#12525#12540#12489
      OnExecute = actCheckNewResAllExecute
    end
    object actTabPtrl: TAction
      Caption = #12377#12409#12390#12398#12479#12502#12398#26356#26032#12481#12455#12483#12463
      Enabled = False
      Hint = #12377#12409#12390#12398#12479#12502#12398#26356#26032#12481#12455#12483#12463
      ImageIndex = 2
      OnExecute = actTabPtrlExecute
    end
    object actListAlready: TAction
      Category = #12473#12524#27396
      Caption = #26082#35501#12395#12377#12427
      Enabled = False
      OnExecute = actListAlreadyExecute
    end
    object actSaveDat: TAction
      Caption = 'dat'#12434#21517#21069#12434#20184#12369#12390#20445#23384'(&S)'
      OnExecute = actSaveDatExecute
    end
    object actCopyDat: TAction
      Caption = 'dat'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&D)'
      Enabled = False
      OnExecute = actCopyDatExecute
    end
    object actCopyDI: TAction
      Caption = 'dat'#12392'idx'#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540'(&I)'
      Enabled = False
      OnExecute = actCopyDIExecute
    end
    object actRefreshIdxList: TAction
      Caption = #12508#12540#12489#12487#12540#12479#12398#20877#27083#25104
      OnExecute = actRefreshIdxListExecute
    end
    object actThreadAbone: TAction
      Tag = 1
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12473#12524#12483#12489#12354#12412#12540#12435
      Enabled = False
      OnExecute = actThreadAboneExecute
    end
    object actThreadAbone2: TAction
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12354#12412#65374#12435#12539#12481#12455#12483#12463#12434#35299#38500
      Enabled = False
      OnExecute = actThreadAbone2Execute
    end
    object actThreadAbone3: TAction
      Tag = 2
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #36879#26126#12473#12524#12483#12489#12354#12412#65374#12435
      Enabled = False
      OnExecute = actThreadAboneExecute
    end
    object actMaxView: TAction
      Caption = #20803#12398#12469#12452#12474#12395#25147#12377
      Hint = #20803#12398#12469#12452#12474#12395#25147#12377
      OnExecute = actMaxViewExecute
    end
    object actHideHistoricalLog: TAction
      Caption = #36942#21435#12525#12464#38750#34920#31034
      OnExecute = actHideHistoricalLogExecute
    end
    object actThreadAbone4: TAction
      Tag = 4
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12371#12398#12473#12524#12434#12481#12455#12483#12463
      Enabled = False
      OnExecute = actThreadAboneExecute
    end
    object actThreadAboneOnly: TAction
      Tag = 3
      Category = #12473#12524#12483#12489#12354#12412#65374#12435
      Caption = #12399#12365#12384#12417
      GroupIndex = 2
      OnExecute = actThreadAboneShowExecute
    end
    object actListCloseThisThread: TAction
      Category = #12473#12524#27396
      Caption = #36984#25246#20013#12398#12473#12524#12434#38281#12376#12427'(&Q)'
      OnExecute = actListCloseThisThreadExecute
    end
    object actListCanClose: TAction
      Category = #12473#12524#27396
      Caption = #36984#25246#20013#12398#12473#12524#12399#38281#12376#12394#12356'(&B)'
      Enabled = False
      OnExecute = actListCanCloseExecute
    end
    object actUpOpenThread: TAction
      Category = #12477#12540#12488
      Caption = #38283#12356#12390#12356#12427#12473#12524#12434#19978#12408#12477#12540#12488
      OnExecute = actUpOpenThreadExecute
    end
    object actUpImportantThread: TAction
      Category = #12477#12540#12488
      Caption = #37325#35201#12473#12524#12434#19978#12408#12477#12540#12488
      OnExecute = actUpImportantThreadExecute
    end
  end
  object PopupFavorites: TPopupMenu
    OnPopup = PopupFavoritesPopup
    Left = 80
    Top = 246
    object PopupFavOpenNew: TMenuItem
      Caption = #26032#12375#12356#12479#12502#12391#38283#12367'(&N)'
      OnClick = PopupFavOpenNewClick
    end
    object PopupFavOpenCurrent: TMenuItem
      Caption = #20170#12398#12479#12502#12391#38283#12367'(&O)'
      OnClick = PopupFavOpenCurrentClick
    end
    object N30: TMenuItem
      Caption = '-'
    end
    object PopupFavOpenFolderByBoard: TMenuItem
      Caption = #26495#12392#12375#12390#38283#12367'(&B)'
      OnClick = PopupFavOpenFolderByBoardClick
    end
    object PopupFavRenewCheck: TMenuItem
      Caption = #26356#26032#12481#12455#12483#12463'(&P)'
      OnClick = PopupFavRenewCheckClick
    end
    object N48: TMenuItem
      Caption = '-'
    end
    object PopupFavOpenByBrowser: TMenuItem
      Caption = #12502#12521#12454#12470#12391#38283#12367'(&Z)'
      OnClick = PopupFavOpenByBrowserClick
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object PopupFavCopyURL: TMenuItem
      Caption = 'URL'#12434#12467#12500#12540'(&L)'
      OnClick = PopupFavCopyURLClick
    end
    object PopupFavCopyTITLE: TMenuItem
      Caption = #12479#12452#12488#12523#12434#12467#12500#12540'(&E)'
      OnClick = PopupFavCopyTITLEClick
    end
    object PopupFavCopyTU: TMenuItem
      Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540'(&T)'
      OnClick = PopupFavCopyTUClick
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object PopupFavNew: TMenuItem
      Caption = #26032#35215#12501#12457#12523#12480'(&F)'
      OnClick = PopupFavNewClick
    end
    object PopupFavEdit: TMenuItem
      Caption = #21517#21069#12398#22793#26356'(&E)'
      OnClick = PopupFavEditClick
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object PopupFavDelete: TMenuItem
      Caption = #21066#38500'(&D)'
      OnClick = PopupFavDeleteClick
    end
  end
  object DblClkTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = DblClkTimerTimer
    Left = 80
    Top = 344
  end
  object PopupTree: TPopupMenu
    OnPopup = PopupTreePopup
    Left = 160
    Top = 40
    object PopupTreeClose: TMenuItem
      Action = actListCloseThisTab
    end
    object N36: TMenuItem
      Caption = '-'
    end
    object N76: TMenuItem
      Caption = #35079#25968#12398#12479#12502#12434#38281#12376#12427
      object PopupTreeCloseOthers: TMenuItem
        Action = actListCloseOtherTabs
      end
      object PopupTreeCloseAll: TMenuItem
        Action = actListCloseAllTabs
      end
      object PopupTreeCloseLeft: TMenuItem
        Action = actListCloseLeftTabs
      end
      object PopupTreeCloseRight: TMenuItem
        Action = actListCloseRightTabs
      end
    end
    object PopupTreeTabMenuSep: TMenuItem
      Caption = '-'
    end
    object PopupTreeOpenNewResThreads: TMenuItem
      Caption = #26356#26032#12398#12354#12427#12473#12524#12483#12489#12434#12377#12409#12390#38283#12367
      OnClick = PopupTreeOpenNewResThreadsClick
    end
    object PopupTreeOpenNewResFavorites: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12391#26356#26032#12398#12354#12427#12473#12524#12483#12489#12434#12377#12409#12390#38283#12367
      OnClick = PopupTreeOpenNewResFavoritesClick
    end
    object PopupOpenFavorites: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12434#12377#12409#12390#38283#12367
      OnClick = PopupOpenFavoritesClick
    end
    object N64: TMenuItem
      Caption = '-'
    end
    object PopupTreeOpenNew: TMenuItem
      Caption = #26032#12375#12356#12479#12502#12391#38283#12367'(&N)'
      Visible = False
      OnClick = PopupTreeOpenNewClick
    end
    object PopupTreeOpenCurrent: TMenuItem
      Caption = #20170#12398#12479#12502#12391#38283#12367'(&O)'
      Visible = False
      OnClick = PopupTreeOpenCurrentClick
    end
    object N44: TMenuItem
      Caption = '-'
    end
    object PopupTreeAddFav: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152'(&A)'
      OnClick = PopupTreeAddFavClick
    end
    object PopupTreeDelFav: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12434#21066#38500
      OnClick = PopupTreeDelFavClick
    end
    object PopupTreeSetHeader: TMenuItem
      Caption = #12385#12423#12387#12392#22793#12360#12383#12356'pre-'#945'(&C)'
      OnClick = PopupTreeSetHeaderClick
    end
    object PopupTreeSetCustomSkin: TMenuItem
      Caption = #12418#12387#12392#22793#12360#12383#12356#946'(&V)'
      object PopupTreeCustomSkinDefault: TMenuItem
        Caption = #12394#12375
        GroupIndex = 1
        RadioItem = True
        OnClick = PopupTreeCustomSkinClick
      end
    end
    object N23: TMenuItem
      Caption = '-'
    end
    object PopupTreeUMA: TMenuItem
      Caption = '('#65439#1076#65439')'#65395#65423#65392
      OnClick = PopupTreeUMAClick
    end
    object N27: TMenuItem
      Caption = '-'
    end
    object PopupTreeBuildThread: TMenuItem
      Caption = #12473#12524#12483#12489#26032#35215#20316#25104'(&B)'
      Hint = #12473#12524#12483#12489#26032#35215#20316#25104
      OnClick = PopupTreeBuildThreadClick
    end
    object N35: TMenuItem
      Caption = '-'
    end
    object PopupTreeOpenByBrowser: TMenuItem
      Caption = #12502#12521#12454#12470#12391#38283#12367'(&Z)'
      OnClick = PopupTreeOpenByBrowserClick
    end
    object N53: TMenuItem
      Caption = '-'
    end
    object PopupTreeCopyURL: TMenuItem
      Caption = 'URL'#12434#12467#12500#12540'(&L)'
      OnClick = PopupTreeCopyURLClick
    end
    object PopupTreeCopyTITLE: TMenuItem
      Caption = #12479#12452#12488#12523#12434#12467#12500#12540'(&E)'
      OnClick = PopupTreeCopyTITLEClick
    end
    object PopupTreeCopyTU: TMenuItem
      Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540'(&T)'
      OnClick = PopupTreeCopyTUClick
    end
    object N42: TMenuItem
      Caption = '-'
    end
    object PopupTreeDelBoard: TMenuItem
      Caption = #12371#12398#26495#12434#21066#38500'(&D)'
      OnClick = PopupTreeDelBoardClick
    end
    object N67: TMenuItem
      Caption = '-'
    end
    object PopupTreeRefreshIdxList: TMenuItem
      Action = actRefreshIdxList
    end
    object PopupTreeHideHistoricalLog: TMenuItem
      Action = actHideHistoricalLog
    end
  end
  object PopupViewMenu: TPopupMenu
    Left = 152
    Top = 280
    object PopupViewJump: TMenuItem
      Caption = #12371#12371#12395#12472#12515#12531#12503'(&J)'
      OnClick = PopupViewJumpClick
    end
    object N61: TMenuItem
      Caption = '-'
    end
    object PopupViewReply: TMenuItem
      Caption = #12371#12428#12395#12524#12473'(&R)'
      OnClick = PopupViewReplyClick
    end
    object PopupViewReplyOnWriteMemo: TMenuItem
      Caption = #12371#12428#12395#12513#12514#27396#12391#12524#12473
      OnClick = PopupViewReplyClick
    end
    object PopupViewReplyWithQuotation: TMenuItem
      Caption = #24341#29992#20184#12365#12524#12473'(&Q)'
      OnClick = PopupViewReplyWithQuotationClick
    end
    object PopupViewReplyWithQuotationOnWriteMemo: TMenuItem
      Caption = #12513#12514#27396#12391#24341#29992#12388#12365#12524#12473
      OnClick = PopupViewReplyWithQuotationOnWriteMemoClick
    end
    object NV001: TMenuItem
      Caption = '-'
    end
    object PopupViewShowResTree: TMenuItem
      Caption = #12371#12371#12363#12425#12484#12522#12540#21270'(&X)'
      OnClick = PopupViewShowResTreeClick
    end
    object PopupViewShowOutLine: TMenuItem
      Caption = #12371#12371#12363#12425#12450#12454#12488#12521#12452#12531#21270'(&Y)'
      OnClick = PopupViewShowResTreeClick
    end
    object N46: TMenuItem
      Caption = '-'
    end
    object c1: TMenuItem
      Caption = #12371#12398#12524#12473#12434#12467#12500#12540'(&c)'
      object PopupViewCopyURL: TMenuItem
        Caption = 'URL'#12434#12467#12500#12540'(&L)'
        OnClick = PopupViewCopyURLClick
      end
      object PopupViewCopyReference: TMenuItem
        Caption = #12479#12452#12488#12523#12392'URL'#12434#12467#12500#12540#65288'&U'#65289
        OnClick = PopupViewCopyReferenceClick
      end
      object PopupViewCopyData: TMenuItem
        Caption = #20869#23481#12434#12467#12500#12540'(&C)'
        OnClick = PopupViewCopyDataClick
      end
      object PopupViewCopyRD: TMenuItem
        Caption = #12479#12452#12488#12523#12392'URL'#12392#20869#23481#12434#12467#12500#12540'(&A)'
        OnClick = PopupViewCopyRDClick
      end
    end
    object N52: TMenuItem
      Caption = '-'
    end
    object PopupViewSetReadPos: TMenuItem
      Caption = #12371#12371#12414#12391#35501#12435#12384'(&B)'
      OnClick = PopupViewSetReadPosClick
    end
    object PopupViewSetCheckRes: TMenuItem
      Caption = #12371#12398#12524#12473#12434#12481#12455#12483#12463'(&K)'
      OnClick = PopupViewAboneClick
    end
    object JSN1: TMenuItem
      Caption = '-'
    end
    object PopupViewOpenImage: TMenuItem
      Caption = #12371#12398#12524#12473#12398'URL'#12434#20840#12390#38283#12367'(&O)'
      OnClick = PopupViewOpenImageClick
    end
    object VN55: TMenuItem
      Caption = '-'
    end
    object PopupViewAbone: TMenuItem
      Caption = #12354#12412#65374#12435'(&A)'
      OnClick = PopupViewAboneClick
    end
    object PopupViewTransParencyAbone: TMenuItem
      Caption = #36879#26126#12354#12412#65374#12435'(&T)'
      OnClick = PopupViewAboneClick
    end
    object N49: TMenuItem
      Caption = '-'
    end
    object PopupViewBlockAbone: TMenuItem
      Caption = #12371#12371#12363#12425#12354#12412#65374#12435'(&S)'
      OnClick = PopupViewBlockAboneClick
    end
    object PopupViewBlockAbone3: TMenuItem
      Caption = #12371#12371#12414#12391#36879#26126#12354#12412#65374#12435'(&P)'
      OnClick = PopupViewBlockAboneClick
    end
    object PopupViewBlockAbone2: TMenuItem
      Caption = #12371#12371#12414#12391#12354#12412#65374#12435#35299#38500'(&C)'
      Visible = False
      OnClick = PopupViewBlockAboneClick
    end
    object PopupViewAddNgName: TMenuItem
      Caption = 'NGName'#12395#36861#21152'(&N)'
      OnClick = PopupViewAddNgClick
    end
    object PopupViewAddNgAddr: TMenuItem
      Caption = 'NGAddr'#12395#36861#21152'(&M)'
      OnClick = PopupViewAddNgClick
    end
    object PopupViewAddNgWord: TMenuItem
      Caption = 'dat'#12363#12425'NGWord'#12395#36861#21152'(&W)'
      OnClick = PopupViewAddNgClick
    end
    object PopupViewAddNgId: TMenuItem
      Caption = 'NGId'#12395#36861#21152'(&I)'
      OnClick = PopupViewAddNgClick
    end
    object N79: TMenuItem
      Caption = '-'
    end
    object PopupViewAddAAlist: TMenuItem
      Caption = #12524#12473#12398#20869#23481#12434'AAList'#12395#30331#37682'(&L)'
      OnClick = PopupViewAddAAlistClick
    end
    object ViewPopupCmdSep: TMenuItem
      Caption = '-'
    end
  end
  object PopupTextMenu: TPopupMenu
    OnPopup = PopupTextMenuPopup
    Left = 184
    Top = 280
    object TextPopupCopy: TMenuItem
      Caption = #12467#12500#12540'(&C)'
      OnClick = TextPopupCopyClick
    end
    object TextPopupCopyLink: TMenuItem
      Caption = #12522#12531#12463#12434#12467#12500#12540'(&L)'
      OnClick = TextPopupCopyLinkClick
    end
    object TextPopupSelectAll: TMenuItem
      Caption = #12377#12409#12390#36984#25246'(&A)'
      OnClick = TextPopupSelectAllClick
    end
    object N62: TMenuItem
      Caption = '-'
    end
    object TextPopupExtractPopup: TMenuItem
      Caption = #25277#20986#12509#12483#12503#12450#12483#12503'(&P)'
      OnClick = ExtractPopupClick
    end
    object TextPopupTrensferToWriteForm: TMenuItem
      Caption = #12371#12398#25991#12395#12524#12473'(&R)'
      OnClick = TextPopupTrensferToWriteFormClick
    end
    object TextPopupTrensferToWriteMemo: TMenuItem
      Tag = 1
      Caption = #12371#12398#25991#12395#12513#12514#27396#12391#12524#12473'(&M)'
      OnClick = TextPopupTrensferToWriteFormClick
    end
    object TextPopupAddNGWord: TMenuItem
      Caption = 'NGWord'#12395#36861#21152'(&W)'
      OnClick = TextPopupNGWordClick
    end
    object TextPopupExtractRes: TMenuItem
      Action = actSelectedKeywordExtraction
    end
    object N95: TMenuItem
      Caption = '-'
    end
    object TextPopupAddAAList: TMenuItem
      Caption = #36984#25246#31684#22258#12434'AAList'#12395#30331#37682
      OnClick = TextPopupAddAAListClick
    end
    object N75: TMenuItem
      Caption = '-'
    end
    object TextPopupOpenByLovelyBrowser: TMenuItem
      Caption = #23550#35937#12434'LovelyBrowser'#12391#38283#12367
      OnClick = TextPopupOpenByLovelyBrowserClick
    end
    object TextPopupOpenByViewer: TMenuItem
      Caption = #23550#35937#12434#12499#12517#12540#12450#12391#38283#12367'(&V)'
      OnClick = TextPopupOpenByViewerClick
    end
    object TextPopupOpenByBrowser: TMenuItem
      Caption = #23550#35937#12434#12502#12521#12454#12470#12391#38283#12367'(&B)'
      OnClick = TextPopupOpenByBrowserClick
    end
    object TextPopupDownload: TMenuItem
      Caption = #23550#35937#12434#12501#12449#12452#12523#12395#20445#23384'(&S)'
      OnClick = TextPopupDownloadClick
    end
    object TextPopupRegisterBroCra: TMenuItem
      Caption = #23550#35937#12434#12502#12521#12463#12521#30331#37682'(&G)'
      OnClick = TextPopupRegisterBroCraClick
    end
    object TextPopupDeleteCache: TMenuItem
      Caption = #23550#35937#12398#12461#12515#12483#12471#12517#12434#21066#38500'(&D)'
      OnClick = TextPopupDeleteCacheClick
    end
    object TextPopupOpenSelectionURL: TMenuItem
      Caption = #36984#25246#31684#22258#12434'URL'#12392#12375#12390#38283#12367'(&O)'
      OnClick = TextPopupOpenSelectionURLClick
    end
    object TextPopUpOpenSelectionURLs: TMenuItem
      Caption = #36984#25246#31684#22258#12398'URL'#12434#20840#12390#38283#12367'(&U)'
      OnClick = TextPopupOpenSelectionURLsClick
    end
    object TextPopupChottoView: TMenuItem
      Caption = #12385#12423#12387#12392#35211#12427'(&Z)'
      OnClick = TextPopupChottoViewClick
    end
    object N50: TMenuItem
      Caption = '-'
    end
    object TextPopupExtractID: TMenuItem
      Caption = #12371#12398'ID'#12391#12524#12473#25277#20986'(&I)'
      OnClick = TextPopupExtractIDClick
    end
    object TextPopupCopyID: TMenuItem
      Caption = #12371#12398'ID'#12434#12467#12500#12540
      OnClick = TextPopupCopyLinkClick
    end
    object N72: TMenuItem
      Caption = '-'
    end
    object TextPopupAddNGID: TMenuItem
      Caption = 'NGID'#12395#36861#21152'(&N)'
      OnClick = TextPopupAddNGIDClick
    end
    object TextPopupIDAbone: TMenuItem
      Tag = 1
      Caption = #12371#12398'ID'#12434#12354#12412#12540#12435
      OnClick = TextPopupIDAboneClick
    end
    object TextPopupIDAbone2: TMenuItem
      Tag = 2
      Caption = #12371#12398'ID'#12434#36879#26126#12354#12412#12540#12435
      OnClick = TextPopupIDAboneClick
    end
    object TextPopupCmdSep: TMenuItem
      Caption = '-'
    end
  end
  object ListImages: TImageList
    Left = 144
    Top = 144
    Bitmap = {
      494C01010E001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFA5FF00FF63FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFA500FFFF630000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFA5FF00FF00FF00FF00FF00FF63FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFA500FFFF0000FFFF0000FFFF6300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFA5FF00FF00FF00FF00FF00FF00FF00FF00FF00FF63FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFA500FFFF0000FFFF0000FFFF0000FFFF0000FFFF63000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9CFF00FF00FF00FF00FF00FF00FF00FF00FF00FF63FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF9C00FFFF0000FFFF0000FFFF0000FFFF0000FFFF63000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9CFF00FF00FF00FF00FF00FF63FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF9C00FFFF0000FFFF0000FFFF6300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF9CFF00FF63FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF9C00FFFF630000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300F7CE9C00F7CE9400F7C69400F7C69400F7C68C00F7BD8400EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300F7C69400F7C69400F7C68C00F7C68C00F7C68C00F7BD8400EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF215200000000000000
      0000000000000000000000000000000000000000000000000000EFB57300F7CE
      A500F7CEA500F7D6A500F7D6A500F7CEA500F7CE9C00FF215200F7C68C00F7BD
      8400F7BD7B00EFB5730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFB57300F7CE
      9C00F7CE9C00F7CE9C00F7CE9C00F7CE9C00F7CE9C00F7C69400F7C68C00F7BD
      8400F7BD7B00EFB5730000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE004A0094003100BD0039000000
      00000000000000000000000000000000000000000000EFB57300F7D6AD00F7D6
      B500F7D6B500F7DEB500F7D6B500F7D6AD00DE004A0094003100BD003900F7CE
      9C00F7C68400F7BD7B00EFB57300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300F7CEA500F7D6
      AD00F7D6AD00F7D6AD00F7D6AD00F7D6AD00F7CEA500F7CE9C00F7CE9400F7C6
      8C00F7BD8400F7BD7B00EFB57300000000000000000000000000000000000000
      0000000000000000000000000000DE004A00BD003900BD003900BD003900FF4A
      73000000000000000000000000000000000000000000EFB57300F7D6B500F7DE
      B500F7DEBD00F7DEBD00F7DEBD00DE004A00BD003900BD003900BD003900FF4A
      7300F7C68C00F7BD8400EFB57300000000000000000000000000000000000000
      000000000000000000000000000029AD5A000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300F7D6B500F7DE
      B500F7DEBD00F7DEBD00F7DEBD0029AD5A00F7D6B500F7D6AD00F7CEA500F7CE
      9C00F7C68C00F7BD8400EFB57300000000000000000000000000000000000000
      00000000000000000000DE004A00DE004A00DE004A00DE004A00DE004A00DE00
      4A00BD003900000000000000000000000000F7BD7B00F7DEB500F7DEBD00F7DE
      C600FFE7C600FFE7C600DE004A00DE004A00DE004A00DE004A00DE004A00DE00
      4A00BD003900F7C68C00F7BD8400EFB573000000000000000000000000000000
      0000000000000000000029AD5A0029AD5A0029AD5A0000000000000000000000
      000000000000000000000000000000000000EFB57300F7DEB500F7DEBD00F7DE
      C600FFE7C600FFE7C60029AD5A0029AD5A0029AD5A00F7D6B500F7D6AD00F7CE
      A500F7CE9C00F7C68C00F7BD8400EFB573000000000000000000000000000000
      000000000000BD003900DE004A00DE004A00DE004A00DE004A00DE004A00DE00
      4A00BD003900000000000000000000000000EFB57300FFDEBD00FFE7C600FFE7
      CE00FFE7D600BD003900DE004A00DE004A00DE004A00DE004A00DE004A00DE00
      4A00BD003900F7C69400F7BD8400EFB573000000000000000000000000000000
      00000000000029AD5A0029AD5A0029BD520029BD520029AD5A00000000000000
      000000000000000000000000000000000000EFB57300FFDEBD00FFE7C600FFE7
      CE00FFE7D60029AD5A0029AD5A0029BD520029BD520029AD5A00F7DEB500F7D6
      AD00F7CE9C00F7C69400F7C68400EFB573000000000000000000000000000000
      0000000000000000000000000000BD003900FF005200FF005200FF0052000000
      000000000000000000000000000000000000EFB57300FFE7C600FFE7D600FFEF
      DE00FFF7EF00FFF7EF00FFF7EF00BD003900FF005200FF005200FF005200F7D6
      B500F7CEA500F7C69400F7C68C00EFB573000000000000000000000000000000
      000029AD5A0029AD5A00000000000000000029BD520029BD520029BD52000000
      000000000000000000000000000000000000EFB57300FFE7C600FFE7D600FFEF
      DE0029AD5A0029AD5A00FFEFDE00FFEFDE0029BD520029BD520029BD5200F7D6
      B500F7CEA500F7CE9C00F7C68C00EFB573000000000000000000000000000000
      000000000000000000000000000094003100FF215200FF215200BD0039000000
      000000000000000000000000000000000000EFB57300FFE7CE00FFEFDE00FFF7
      E700FFF7EF00FFF7EF00FFF7EF0094003100FF215200FF215200BD003900F7D6
      B500F7D6A500F7CE9400F7C68C00EFB573000000000000000000000000000000
      0000000000000000000000000000000000000000000029BD520029BD52000000
      000000000000000000000000000000000000EFB57300FFE7CE00FFEFDE00FFF7
      E700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFEFDE0029BD520029BD5200F7DE
      B500F7D6AD00F7CE9C00F7C68C00EFB573000000000000000000000000000000
      000000000000000000000000000094003100FF215200FF215200DE004A000000
      000000000000000000000000000000000000EFB57300FFE7D600FFEFDE00FFF7
      EF00FFFFF700FFFFF700FFFFF70094003100FF215200FF215200DE004A00F7D6
      B500F7D6A500F7CE9C00F7C68C00F7BD7B000000000000000000000000000000
      000000000000000000000000000000000000000000000000000029BD520029BD
      520000000000000000000000000000000000EFB57300FFE7D600FFEFDE00FFF7
      EF00FFFFF700FFFFF700FFFFF700FFF7EF00FFEFDE00FFE7D60029BD520029BD
      5200F7D6AD00F7CE9C00F7C69400EFB573000000000000000000000000000000
      0000000000000000000094003100FF4A7300FF4A7300DE004A00000000000000
      00000000000000000000000000000000000000000000EFB57300FFEFE700FFF7
      EF00FFFFFF00FFFFFF0094003100FF4A7300FF4A7300DE004A00FFDEC600F7D6
      B500F7D6A500F7CE9C00EFB57300000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000029BD
      52000000000000000000000000000000000000000000EFB57300FFEFE700FFF7
      EF00FFFFFF0000000000FFFFF700FFF7EF00FFEFE700FFEFD600FFE7C60029BD
      5200F7D6AD00F7CE9C00EFB57300000000000000000000000000000000000000
      0000000000000000000094003100FF4A7300DE004A0000000000000000000000
      00000000000000000000000000000000000000000000EFB57300FFEFD600FFEF
      E700FFF7EF00FFFFFF0094003100FF4A7300DE004A00FFE7CE00F7DEBD00F7D6
      B500F7CEA500F7C69400EFB57300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300FFEFDE00FFF7
      EF00FFFFF700FFFFFF00FFFFF700FFF7EF00FFEFDE00FFE7D600FFE7C600F7DE
      BD00F7D6AD00F7CE9C00EFB57300000000000000000000000000000000000000
      00009400310094003100BD003900DE004A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFB57300FFEF
      D6009400310094003100BD003900DE004A00FFE7CE00FFDEC600F7DEB500F7D6
      AD00F7CE9C00EFB5730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFB57300FFF7
      E700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFEFDE00FFE7CE00FFDEC600F7DE
      B500F7D6AD00EFB5730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300FFE7D600FFE7CE00FFE7CE00FFDEC600F7DEBD00F7D6B500EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300FFEFE700FFEFDE00FFEFDE00FFE7D600FFE7C600F7DEBD00EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300F7CE9C00F7CE9400F7C69400F7C69400F7C68C00F7BD8400EFB5
      7300EFB57300000000000000000000000000000000000000000000000000EFB5
      7300EFB57300F7C69400F7C69400F7C68C00F7C68C00F7C68C00F7BD8400EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000029C6520029BD52004294
      5200429452000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFB57300F7CE
      A500F7CEA500F7D6A500F7D6A500F7CEA50029C6520029BD5200429452004294
      5200F7BD7B00EFB5730000000000000000000000000000000000EFB57300F7CE
      9C00F7CE9C00F7CE9C00F7CE9C00F7CE9C00F7CE9C00F7C69400F7C68C00F7BD
      8400F7BD7B00EFB5730000000000000000000000000000000000000000000000
      00000000000000000000000000000000000029C6520052F78C00429452000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300F7D6AD00F7D6
      B500F7D6B500F7DEB500F7D6B50029C6520052F78C0042945200F7CE9C00F7C6
      9400F7C68400F7BD7B00EFB573000000000000000000EFB57300F7CEA500F7D6
      AD00F7D6AD00F7D6AD00F7D6AD00F7D6AD00F7CEA500F7CE9C00F7CE9400F7C6
      8C00F7BD8400F7BD7B00EFB57300000000000000000000000000000000000000
      000000000000000000000000000029C6520052F78C004AE77B00429452000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006363DE000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300F7DEB500FFDE
      BD00FFDEC600FFDEC60029C6520052F78C004AE77B0042945200F7D6A500F7CE
      9C00F7C68C00F7BD8400EFB573000000000000000000EFB57300F7D6B500F7DE
      B500F7DEBD00F7DEBD00F7DEBD006363DE00F7D6B500F7D6AD00F7CEA500F7CE
      9C00F7C68C00F7BD8400EFB57300000000000000000000000000000000000000
      0000000000000000000029C6520042DE730042DE730042945200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006363DE006363DE006363DE0000000000000000000000
      000000000000000000000000000000000000EFB57300F7DEBD00FFDEC600FFE7
      CE00FFE7CE0029C6520042DE730042DE730042945200F7DEBD00F7D6B500F7CE
      A500F7CE9400F7C68C00F7BD8400EFB57300EFB57300F7DEB500F7DEBD00F7DE
      C600FFE7C600FFE7C6006363DE006363DE006363DE00F7D6B500F7D6AD00F7CE
      A500F7CE9C00F7C68C00F7BD8400EFB573000000000000000000000000000000
      0000000000000000000029BD520039D6730039D6730042945200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006363DE006363DE007373FF007373FF006363DE00000000000000
      000000000000000000000000000000000000EFB57300FFDEC600FFE7CE00FFEF
      D600FFEFDE0029BD520039D6730039D6730042945200FFDEC600F7DEB500F7D6
      AD00F7CE9C00F7C69400F7BD8400EFB57300EFB57300FFDEBD00FFE7C600FFE7
      CE00FFE7D6006363DE006363DE007373FF007373FF006363DE00F7DEB500F7D6
      AD00F7CE9C00F7C69400F7C68400EFB573000000000000000000000000000000
      0000000000000000000029C6520031CE630031CE630029AD5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006363DE006363DE0000000000000000007373FF007373FF007373FF000000
      000000000000000000000000000000000000EFB57300FFE7CE00FFEFD600FFEF
      E700FFF7EF0029C6520031CE630031CE630029AD5A00FFE7CE00F7DEBD00F7D6
      B500F7CEA500F7C69400F7C68C00EFB57300EFB57300FFE7C600FFE7D600FFEF
      DE006363DE006363DE00FFEFDE00FFEFDE007373FF007373FF007373FF00F7D6
      B500F7CEA500F7CE9C00F7C68C00EFB573000000000000000000000000000000
      000029BD520029C6520029C6520029C6520029C6520029C6520029C6520029AD
      5A00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007373FF007373FF000000
      000000000000000000000000000000000000EFB57300FFE7CE00FFEFDE0029BD
      520029C6520029C6520029C6520029C6520029C6520029C6520029AD5A00F7D6
      B500F7D6A500F7CE9400F7C68C00EFB57300EFB57300FFE7CE00FFEFDE00FFF7
      E700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFEFDE007373FF007373FF00F7DE
      B500F7D6AD00F7CE9C00F7C68C00EFB573000000000000000000000000000000
      00007BB5B50018BD390018BD390018BD390018BD390018BD390031B55A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007373FF007373
      FF0000000000000000000000000000000000EFB57300FFE7D600FFEFDE007BB5
      B50018BD390018BD390018BD390018BD390018BD390031B55A00FFDEC600F7D6
      B500F7D6A500F7CE9C00F7C68C00F7BD7B00EFB57300FFE7D600FFEFDE00FFF7
      EF00FFFFF700FFFFF700FFFFF700FFF7EF00FFEFDE00FFE7D6007373FF007373
      FF00F7D6AD00F7CE9C00F7C69400EFB573000000000000000000000000000000
      00000000000052F78C0010AD290010AD290010AD290029BD5200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007373
      FF000000000000000000000000000000000000000000EFB57300FFEFDE00FFF7
      EF0052F78C0010AD290010AD290010AD290029BD5200FFE7CE00FFDEC600F7D6
      B500F7D6A500F7CE9C00EFB573000000000000000000EFB57300FFEFE700FFF7
      EF00FFFFFF0000000000FFFFF700FFF7EF00FFEFE700FFEFD600FFE7C6007373
      FF00F7D6AD00F7CE9C00EFB57300000000000000000000000000000000000000
      000000000000000000007BB5B50008A5180021BD4A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFB57300FFEFD600FFEF
      E700FFF7EF007BB5B50008A5180021BD4A00FFEFD600FFE7CE00F7DEBD00F7D6
      B500F7CEA500F7C69400EFB573000000000000000000EFB57300FFEFDE00FFF7
      EF00FFFFF700FFFFFF00FFFFF700FFF7EF00FFEFDE00FFE7D600FFE7C600F7DE
      BD00F7D6AD00F7CE9C00EFB57300000000000000000000000000000000000000
      000000000000000000000000000042C67B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFB57300FFEF
      D600FFEFDE00FFEFDE0042C67B00FFEFD600FFE7CE00FFDEC600F7DEB500F7D6
      AD00F7CE9C00EFB5730000000000000000000000000000000000EFB57300FFF7
      E700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFEFDE00FFE7CE00FFDEC600F7DE
      B500F7D6AD00EFB5730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFB5
      7300EFB57300FFE7D600FFE7CE00FFE7CE00FFDEC600F7DEBD00F7D6B500EFB5
      7300EFB57300000000000000000000000000000000000000000000000000EFB5
      7300EFB57300FFEFE700FFEFDE00FFEFDE00FFE7D600FFE7C600F7DEBD00EFB5
      7300EFB573000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFB57300EFB57300EFB57300EFB57300EFB57300EFB573000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000636363006363630063636300636363006363630063636300636363006363
      6300636363006363630063636300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AD7B
      6B00DEAD9C00D6A59C00D6A59400CEA59C00CE9C9400C69C9400C69C9400C694
      9400B5948C00BD8C8C0063636300000000000000000000000000000000000000
      00000000000000000000A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000187B9C00187B
      9C00187B9C00187B9C00187B9C00187B9C00187B9C00187B9C00187B9C00187B
      9C00187B9C00187B9C00187B9C000000000000000000000000004A5A6300635A
      63002121310018314A00214A730021315A0008185200FFD6BD00FFD6B500FFD6
      B500FFD6AD00EFBDA50063636300000000000000000000000000000000000000
      00000000000000000000D6D6D600EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00A5A5A500000000000000000000000000000000000000
      0000000000000000000084848400CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00000000000000000000000000188CB500188CB500188C
      B500188CB500188CB500188CB500188CB500188CB500188CB500188CB500188C
      B500188CB500188CB500188CB500187B9C000000000039393900BD737300FF9C
      9C0063313100180808004A4A9C006363CE000000AD0008184A00FFD6BD00FFD6
      B500FFD6B500EFBDAD0063636300000000000000000000000000000000000000
      00000000000000000000D6D6D600F7F7F700CECECE00CECECE00CECECE00CECE
      CE00CECECE00EFEFEF00A5A5A500000000000000000000000000000000000000
      00000000000000000000848484009CFFFF00FF000000FF000000FF000000FF00
      0000FF000000CECECE000000000000000000319CBD0063CEFF00188CB5009CFF
      FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6FF006BD6
      FF0039B5DE009CF7FF00188CB500187B9C000000000000000000FF9C9C00FF9C
      9C0063313100311818006363CE006363CE000000AD000000A50018314A00FFD6
      BD00FFD6B500F7C6AD006363630000000000A5A5A500A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500D6D6D600F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700EFEFEF00A5A5A500000000000000000000000000000000000000
      0000000000000000000084848400000000009CFFFF00000000009CFFFF000000
      00009CFFFF00CECECE000000000000000000319CBD0063CEFF00188CB5009CFF
      FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BE7FF007BDE
      FF0042B5DE009CFFFF00188CB500187B9C000000000000000000FF9C9C00FFCE
      CE008C5A5A00311818004A4A9C00B5B5E7002121BD000000A50021395A00FFDE
      BD00FFDEBD00F7C6AD006363630000000000D6D6D600EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00D6D6D60000000000D6D6D600D6D6D600D6D6D600D6D6
      D600D6D6D600EFEFEF00A5A5A5000000000084848400CECECE00CECECE00CECE
      CE00CECECE00CECECE00848484009CFFFF00FF000000FF000000FF000000FF00
      0000FF000000CECECE000000000000000000319CBD0063CEFF00188CB5009CFF
      FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084EF
      FF004AB5DE00A5F7FF00188CB500187B9C000000000000000000BDB5B500BD9C
      9C0039637300009CBD000073BD004A4A9C008C8CF7002121BD00395A7300FFDE
      C600FFDEBD00F7C6B5006363630000000000D6D6D60000000000B5B5B500B5B5
      B500B5B5B500B5B5B500D6D6D6000000000000000000F7F7F700F7F7F700F7F7
      F700F7F7F700EFEFEF00A5A5A5000000000084848400000000009C3100009C31
      00009C3100009C31000084848400000000009CFFFF00000000009CFFFF000000
      0000CECECE00CECECE000000000000000000319CBD0063CEFF00188CB5009CFF
      FF0094FFFF0094FFFF0094FFFF0094FFFF0094FFFF0094FFFF0094FFFF008CF7
      FF0052BDE7009CFFFF00188CB500187B9C000000000000000000000000003931
      310000CEFF0000CEFF00009CFF000073BD00313163004A637B00FFE7CE00FFDE
      C600FFDEC600F7CEB5006363630000000000D6D6D60000000000000000000000
      00000000000000000000D6D6D60000000000D6D6D600D6D6D600F7F7F700A5A5
      A500A5A5A500A5A5A500A5A5A50000000000848484009CFFFF00000000009CFF
      FF00000000009CFFFF008484840000000000FF633100FF633100000000000000
      000000000000000000000000000000000000319CBD006BD6FF00188CB5009CFF
      FF009CFFFF009CFFFF009CFFFF00A5F7FF009CFFFF009CFFFF009CFFFF009CFF
      FF0063CEFF009CFFFF00188CB500187B9C000000000000000000000000002121
      210000CEFF0000CEFF00009CFF00009CFF0063737B00FFE7D600FFE7CE00FFE7
      CE00FFDEC600F7CEB5006363630000000000D6D6D60000000000B5B5B500B5B5
      B500B5B5B500B5B5B500D6D6D60000000000000000000000000000000000D6D6
      D60000000000A5A5A500000000000000000084848400000000009C3100009C31
      00009C3100009C310000848484000000000000000000000000009CFFFF008484
      840000000000000000000000000000000000319CBD007BDEFF00188CB5000000
      0000F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF0000000000000000000000
      000084D6F700F7FFFF00188CB500187B9C000000000000000000000000002131
      390039E7FF0000FFFF0000E7FF00009CFF00395A7300FFE7D600FFE7D600FFE7
      CE00FFE7CE00F7CEBD006363630000000000D6D6D60000000000000000000000
      00000000000000000000D6D6D60000000000000000000000000000000000D6D6
      D600A5A5A500000000000000000000000000848484009CFFFF00000000009CFF
      FF00000000009CFFFF0084848400000000000000000000000000000000008484
      840000000000000000000000000000000000319CBD0084EFFF0084E7FF00188C
      B500188CB500188CB500188CB500188CB500188CB500188CB500188CB500188C
      B500188CB500188CB500188CB50000000000000000000000000000000000DEAD
      8400397B7B0000FFFF0000FFFF0000637B00FFEFDE00FFEFDE009C6B6B009C6B
      6B009C6B6B009C6B6B006363630000000000D6D6D60000000000B5B5B500B5B5
      B50000000000D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D6000000000000000000000000000000000084848400000000009C3100009C31
      0000000000000000000084848400848484008484840084848400848484008484
      840000000000000000000000000000000000319CBD009CF7FF008CF7FF008CF7
      FF008CF7FF008CF7FF008CF7FF00000000000000000000000000000000000000
      0000107BA500000000000000000000000000000000000000000000000000DEAD
      8400FFFFF700FFF7F700FFF7EF00FFF7EF00FFF7E700FFEFE700B5847300FFD6
      CE00F7B5AD00B58C7B006363630000000000D6D6D60000000000000000000000
      000000000000D6D6D60000000000A5A5A5000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      00009CFFFF008484840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319CBD00000000009CFFFF009CFF
      FF009CFFFF009CFFFF0000000000188CB500188CB500188CB500188CB500188C
      B500107BA500000000000000000000000000000000000000000000000000DEAD
      840000000000FFFFF700FFF7F700FFF7EF00FFF7EF00FFF7E700B5847300F7A5
      4200E7944200636363000000000000000000D6D6D60000000000000000000000
      000000000000D6D6D600A5A5A500000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000319CBD00000000000000
      000000000000F7FFFF00319CBD00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEAD
      84000000000000000000FFFFF700FFFFF700FFF7EF00FFF7EF00B5847300EFB5
      730063636300000000000000000000000000D6D6D600D6D6D600D6D6D600D6D6
      D600D6D6D600D6D6D60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000319CBD00319C
      BD00319CBD00319CBD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEAD
      8400DEAD8400DEAD8400DEAD8400DEAD8400DEAD8C00D6A58400B58473006363
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FE7FFE7F00000000
      FC3FFC3F00000000F81FF81F00000000F81FF81F00000000FC3FFC3F00000000
      FE7FFE7F00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFF81FFFFFF81FFFFFE007FFFFE007
      FFBFC003FFFFC003FF1F8001FFFF8001FE0F8001FEFF8001FC070000FC7F0000
      F8070000F83F0000FE1F0000F31F0000FE1F0000FF9F0000FE1F0000FFCF0000
      FC3F8001FFEF8401FC7F8001FFFF8001F0FFC003FFFFC003FFFFE007FFFFE007
      FFFFF81FFFFFF81FFFFFFFFFFFFFFFFFFFFFFFFFF81FF81FFFFFFFFFE007E007
      FF87FFFFC003C003FF1FFFFF80018001FE1FFEFF80018001FC3FFC7F00000000
      FC3FF83F00000000FC3FF31F00000000F00FFF9F00000000F01FFFCF00000000
      F83FFFEF80018401FC7FFFFF80018001FEFFFFFFC003C003FFFFFFFFE007E007
      FFFFFFFFF81FF81FFFFFFFFFFFFFFFFFFFFFF001FFFFFFFFFFFFE001FC01FC01
      C001C001FC01FC0180008001FC01FC0100008001000101510000800101010001
      00008001418141510000C0017D0129210000E00141EB41CB1070E0017DE729E7
      0001E001480F480F01F7E0017AFF72FF4207E80379FF79FFB9FFEC0703FF03FF
      C3FFE00FFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MainToolImages: TImageList
    Left = 51
    Top = 27
    Bitmap = {
      494C01010E001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000595C5E0046494A0046494A0046494A00595C5E000000
      0000000000000000000000000000000000000000000000000000000000000000
      000076769D00363675002B2B3D004C4C4C005656560035355700232367005959
      7400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000595C5E0046494A004649
      4A0046494A000277A9000272A3000272A3000376A8000270A200333536004649
      4A0046494A0046494A0046494A0046494A00000000006D6D6D00565656005656
      560040408B002828DE001E1EA90003375800094781002828E0002525BB004242
      5300565656005656560056565600565656000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002727270027272700272727002727
      27002727270016ADD9002CC1EB002BB8DF0029C0EA00067FAF00272727002727
      2700272727002727270027272700333536002727270027272700272727002727
      270027272700226AD9002D2EE100222AA800292BCB002930D5001F1E2F002727
      27002727270027272700272727003F3F3F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000099999900FFF1DF00FFF1DF00FFF1
      E000FFF1E00033ADD500BBE5EF00CDF7FF00AFE4F2001A8FBD00FFF1DF00FFF1
      DF00FFF1DF00FFF1DF002727270046494A0099999900FFF1DF00FFF1DF00FFF1
      E000FFF1E00033ACD5006170DD003433F3003534EE0016447D00FFF1DF00FFF1
      DF00FFF1DF00FFF1DF0027272700565656000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009999990099999900999999009999
      9900999999004EB6D800DAEBEF00FFFFFF00D4EEF5001690BE00999999009999
      9900999999009999990099999900B6BDC1009999990099999900999999009999
      9900999999004AAAD1006268DC005050FF00403EF50016307700747474009999
      9900999999009999990099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000026A7D20041B1D80049B0D2002C9FC60045A6C800A2A8AB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002757AD005556FD00556BD4005563F0004545F10040406800C9C9
      C900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C7CFD300BDC5C90082828200AAA19500151515002D2F3000949A9D00BAC2
      C500C4CCD0000000000000000000000000000000000000000000000000000000
      00009E9ED9005D5DFF005B5ABE0098908B00232347005E5EEB004E4EDC008484
      9700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C4CCD000BAC2
      C500A3A9AC0074797B00505050008E82810034303000191A1A00424546006C70
      7200979DA000B4BBBF00C1C9CD00000000000000000000000000000000000000
      0000C9C9C9008F8F8F00505050008E828100343030001D1D1D00515151008585
      8500BABABA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9C0C400979DA000676B
      6D006C6E6E008C8C8C00A5A5A500757070003F3C3C0049444400544C4C004342
      4300444648005A5D5F0084898C00ADB4B7000000000000000000BABABA007D7D
      7D00747474008D8D8D00A5A5A500757070003F3C3C0049444400574E4E004C4A
      4A00535353006E6E6E00A3A3A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDC5C9007074760083848400C9C9
      C900A3A3A30080808000828282007D7C7C004E4E4E00717171007D7D7D00746E
      6E00726464004E4A4B004144450061656600000000008585850088888800C9C9
      C900A3A3A30080808000828282007D7C7C004E4E4E00717171007D7D7D00746E
      6E00746565005550500050505000777777000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000093969700AEAEAE00989898008282
      8200A4A4A400B9B9B900D1D1D1008E8E8E00797979006C6C6C00818181006262
      620034343400B79898008674740054575900A3A3A300AEAEAE00989898008282
      8200A4A4A400B9B9B900D1D1D1008E8E8E00797979006C6C6C00818181006262
      620034343400B798980089767600686868000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000939596009C9C9C00B5B5B500C7C7
      C700E1E1E100E6E6E600D0D0D000D8D8D800D1D1D100C3C3C3009A9999007D78
      780046434300938181007F727200626668009E9E9E009C9C9C00B5B5B500C7C7
      C700E1E1E100E6E6E600D0D0D000D8D8D800D1D1D100C3C3C3009A9999007D78
      7800464343009381810083757500797979000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ADAFB000D3D3D300DEDEDE00C7C7
      C700E1E1E100DFDFDF00F2F2F200FCFCFC00ECECEC00DFDFDF00F7F7F700EEEA
      EA00DECCCC008F8A8A0083808100B5BDC000B8B8B800D3D3D300DEDEDE00C7C7
      C700E1E1E100DFDFDF00F2F2F200FCFCFC00ECECEC00DFDFDF00F7F7F700EEEA
      EA00DECCCC008F8A8A008C888800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BAC0C300C8CCCE00B1B3B3007979
      79006C6C6C00B8B8B800F2F2F200FCFCFC00ECECEC00DFDFDF00F7F7F700C5C5
      C600ABAEB000A7ACAF00C4CBCF000000000000000000DDDDDD00BABABA007979
      79006C6C6C00B8B8B800F2F2F200FCFCFC00ECECEC00DFDFDF00F7F7F700C9C9
      C900BEBEBE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BCC3
      C600B9BEC100B7BABB00D2D2D200E6E6E600C0C2C300B7BBBE00A9AFB200C6CE
      D200000000000000000000000000000000000000000000000000000000000000
      0000D6D6D600C6C6C600D5D5D500E6E6E600CBCBCB00D0D0D000CECECE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8B4B2007F726F00ABA8
      A700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D1D1D100D1D1D100D1D1D100D1D1D100D1D1D100D1D1D100D1D1D100D1D1
      D100D1D1D1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006A6A6A004E4E4E004B4B4B004B4B4B004B4B4B00505050007979
      79000000000000000000000000000000000000000000749AB5007890DB009C6F
      75009D9998000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009191
      9100717171007171710071717100717171007171710071717100717171007171
      71007171710095959500000000000000000000000000B85D1C0070422D005338
      2C00493E39004D4D4D0061616100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E3D0C700F3E1D700F4E3D900F4E3DA00F3E2D800F3E1D700C9BAB0005958
      57006D6D6D000000000000000000000000000000000096DCFF0040B4FF007185
      D3009D707400A6A2A20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BC897800BF8B
      7A00BC897900BA867700B7827600B3807400AF7C7200AA796F00A7746D00A370
      6B009E6C690071717100D1D1D1000000000000000000AA4B0900DEA07800E6B1
      8A00C37C50009A532C0062392400453B36004B4B4B0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F4E3
      D800F8FAFB00E4E2E200CFB1A200D4AB9600DDC6BB00ECF1F000F6F3F200F2E1
      D600877F7B006969690000000000000000000000000000000000A7E3FF003DBF
      FF006F89DB00966C7400BEBDBD00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C3C3C300C18E7B00DAB5
      AA00F0C3B800EEC1B700EDBFB300ECBDB200EABBAF00EAB9AD00E8B6AA00E7B5
      A800A06E6A0071717100D1D1D1000000000000000000AD4F0F00E5BB9C00FFF4
      D800FFE7C600FFDBB200F1B78900CA814E009F562A00513A2E00000000000000
      0000000000000000000000000000000000000000000000000000F5EAE200F4FF
      FF00CF9A8100B74D1600B9653D00D9AF9A00C0592400B9572500D5AF9F00F7FF
      FF00F4E2D90077716D00707070000000000000000000CECDCD00CDCED1006396
      B5002EB2FF006886CD0062595A00948B8D0087736F008A787400736563008F8F
      8F00BBBBBB00B4B2B200B9B9B90000000000000000007FA8D300877EA400D0B0
      B000FFEAD600FFE5CC00FFE3C700FFDFBF00FFDBB800FFD9B200FFD3A800FFD2
      A500A3716B0071717100D1D1D1000000000000000000B4561500E8C1A600FFEC
      D400FFE3C400F2DCBF00FFE1BD00FFD18600FBAD5E0076401F00000000000000
      00000000000000000000000000000000000000000000F2E1D700F8FFFF00C77E
      5900BB460D00C64F1400C2A49500FFFFFF00D9927000C14B1000B8460C00CE9A
      8100F8FFFF00F2E0D600555555009595950000000000B46F4300B6704800B46A
      42008CB9D1009AB6C700BD918500FFE8B800FFFFEC00FFFFFF00FFFFFA00A281
      7C0062332100D395710078482F000000000000000000000000004D95E0008B80
      A300DBB7B200FFE9D400FFE5CC00FFE2C600FFDFBF00FFDBB800FFD9B200FFD3
      A800A7746D0071717100D1D1D1000000000000000000B85D1C00EDCDB600FFF3
      DB00CCD7CC004FAECA00FADBB100FFC25C00F5B67A0067402800000000000000
      000000000000000000000000000000000000EFDDD400FAFAF900D8A89000BD49
      0E00CD632F00CD612A00CB6C3B00D88E6900CA5F2A00CC632E00C95E2A00B948
      1100E0C9BD00F6EDE800A49892006060600000000000F3D29D00E5FFFF00E4FD
      FF00E2F6F900CCBBB900EECBA400F5F7C400F0F3CD00EEF3DF00F4FBFF00FFFF
      F90084787600D7F5FD0092796A00000000000000000000000000A6C3D7005196
      DF008F81A200DFC2B400D6B2A300D2A89A00E1BBA500F4D1B400FFDBB800FFD9
      B200AB78700071717100D1D1D1000000000000000000B85D1C00F6D9C500D8E7
      DF004EB0CD004EB0CD00BABDA70091917600D49A6300824A1B0056514E007777
      770000000000000000000000000000000000F3E0D700F8FAFB00C5633300CA5D
      2700CE683400CB5C2400CA896A00FFFFFF00D06C3900CA5B2400CD663200C354
      1C00C7795100F8FCFD00E1CFC6004E4E4E0000000000E6BF8800CCEEFF00C5D7
      DD00BFD0D900D1B8A700E3D5A800DBCEA600DEE1C500DFE1D900E2E5E500F8FE
      EA00BEAD9400A2AEB6008F776800000000000000000000000000E2BCA000B0C9
      D600ABABB500CEA99400F6E5BB00FEFDD800EFE2CE00DDBAA500F4D1B300FFDA
      B500AF7C710071717100D1D1D1000000000000000000B85D1C00F8E5D7004EB0
      CD00BCD7D600A7D0D4004EB0CD00A89B8200EAB68100FAC99300C98747009466
      3A0073696000757575000000000000000000F3E1D800F2DED600C5571F00CE67
      3300CC663200CC5B2200C2866A00FFFFFF00E8AD9100C44B1000CC632E00CB60
      2900C35F2C00F3F2F100F2E0D6004D4D4D0000000000E6BD8700CFEEFF00C7D9
      DD00C1CCD400D8C3AD00DBCEA300D7C7A000D9DCB900DAE0C800DFE4CF00EFF6
      D300D0BE9D00A7ADB50092756400000000000000000000000000E2BCA000E7D9
      CE00DBB6A600F6E3B700FFF9CA00FFFFEC00FFFFFD00E7D7C300E1BBA500FFDF
      BE00B280730071717100D1D1D1000000000000000000B85D1C00F6EAE300F7F6
      EE00FFF6E400D7E2D9004EB0CD00FFEBCA00E2AA7700C7885000F3C69600F8C6
      9200BD966A00315AD100315AD10000000000F2E1D900F3D8CA00CD5C2300CF67
      3300CC653000CC612C00C4562000CFB5A800FFFFFF00E09C7B00C7541B00CD61
      2C00C65F2A00F5F1ED00F0DFD5005050500000000000E6BB8700D2EFFF00CADA
      DE00C9D7E100D1BDAB00E6E4BD00DECDAB00DFD5A800E0DFB900E3E1BC00FDFE
      CB00BB9B8100C5D3DB0093756200000000000000000000000000E2BCA000ECDF
      D400DBBBA500FEE5B300FFF5C500FFFFE700FFFFEC00FEFBD000CEA69600FFE1
      C400B783750071717100D1D1D1000000000000000000B85D1C00F9F2F000FFFD
      F700FFF6EB00FCF2E3004EB0CD00F6EEDD00EAB89100673A190000000000D7A6
      7800AC9E9B00315AD100315AD10000000000F1E0D700FBEDE600DB6B3300D369
      3400CA5F2900C9592200C9551A00C14C1100E2D0C600FFFFFF00D0714000CD5B
      2100CE6B3900FCFBFB00EFDED3006969690000000000E7BC8700D4F0FE00CDDA
      DC00CFE0E200C7C0BF00DBCAC200ECF2F600EDE0B900EDD5A100F4EDB700EBCC
      9D00A18D8E00F5FFFF0091715B00000000000000000000000000E2BCA000EFE2
      D800E1C6AF00F6E7C500FFEFC000FFFACB00FFFDD200F6E7B900D5B09F00FFE5
      CC00BA86770071717100D1D1D1000000000000000000B85D1C00FCFBFB000000
      0000FFF8F200FFF9EC00A8D3DC00CCE2E000F4BD9300583A2800000000000000
      0000000000000000000000000000F1F1F100F1DED400FFFFFF00F5986B00E267
      2B00C88B6E00FFFFFF00D77F5200BD310100D79C7F00FFFFFF00DA8C6600D154
      1500E29A7700FEFDFE00DBC9C000A7A7A70000000000E8BD8800D2ECFE00C7D6
      D800CBD9DB00C7D5DA00C0B7B900D3C3BA00E4D5AF00EFD8AB00E3C5A500B59B
      9700C4D7E000FFFFFF0092705700000000000000000000000000E2BCA000F3E6
      DB00E7D3CA00E9D8CC00F6E7D300FEE8B700F6E1B300D3AC9300EFD4C300FFDA
      C800BD89790071717100D1D1D1000000000000000000B85D1C00FAF8FA000000
      000000000000FFFFFE00D4EAEC00C3E5E800F0B68A00573D2700000000000000
      000000000000000000000000000000000000F2E1D900F6F1EF00FFEADB00FF8A
      4A00DE875D00EEFFFF00FFFFFF00E7B9A100FFFFFF00FFFFFF00E0733D00E671
      3600FFF3EE00F4E7E000A49B96000000000000000000EAC08E00D5F2FF00CBDA
      E300CDDDE500CFE1E800CFE3EC00C0C5CC00B0A8AE00BCB4BC00C2C5D000D5EB
      F600DDF1FC00FCFFFF0093735800000000000000000000000000E2BCA000F6E9
      DE00FFFFFF00DCC4BD00D6B9A300DAB89C00D8B09900E7CFC300F3D0C000F2A4
      9E00BF8B7A0080808000D8D8D8000000000000000000B85D1C00B85D1C00D194
      6900DCB39700E8CEC100F7E9E000FFFEFB00E9BA930059402900000000000000
      00000000000000000000000000000000000000000000F1DED400FFFFFF00FFE9
      CE00FFB27100ECAF8700FFFFFF00FFFFFF00FFFFFF00F6A47900FE8C4E00FFDE
      CA00FDFFFF00F0DDD200000000000000000000000000E8C59500D9FBFF00D3E8
      F200D4EAF200D4EAF300D4EAF500D7F1FA00DBF5FF00D9F4FF00DBF2FD00DCF1
      FA00DCF2F700FFFFFF0096775800000000000000000000000000E2BCA000FAED
      E200FFFFFF00FFFFFF00FFFFFF00FFFEFD00FFF9F300FFF6ED009B6B6A009B6B
      6A009B6B6A00AEAEAE0000000000000000000000000000000000B85D1C00B85D
      1C00B85D1C00BF520100C05E1100C87C4900CC793A005F463100000000000000
      0000000000000000000000000000000000000000000000000000F0DFD600FFFF
      FF00FFFFFB00FFF3C600FEDDA800FCCF9800FFC99100FFD4A900FFFEF800FCFF
      FF00F1DFD40000000000000000000000000000000000BC6E1900BD742600BF76
      2500BF742400BF762500BF762500BF742400BF742400BD732200C5803100C680
      2D00BC7E3600A7826A0085562000000000000000000000000000E2BCA000FFF2
      E500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFDFA00FFF9F2009B6B6A00DEA7
      7E00BAA69D000000000000000000000000000000000000000000000000000000
      000000000000B85D1C00B85D1C00D7741100D66C0500705E4C00000000000000
      000000000000000000000000000000000000000000000000000000000000F1DC
      D300F5E8E400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FCFBFD00F3E6E000F1DD
      D2000000000000000000000000000000000000000000D87E1700E5851B00E381
      1100E5811200E3800E00E5821300E2821100E47D0A00E17A0400E7831400EA86
      1200E3862000CB864A00AC8A6500000000000000000000000000F0C19700ECBD
      9600E6B99600E1B49500DAAF9400D4AB9400CEA69200CAA392009B6B6A00D7C4
      B900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F3E3DB00F1DCD100EFDBD000EFDBD100EFDCD100F1DBD000EADED7000000
      000000000000000000000000000000000000000000004D55FF004D55FF004D55
      FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF0000000000000000000000000000000000C3C2C200ACAA
      A800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAA
      A800ACAAA800ACAAA80000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008000FF008000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00AAAAFF009B9BFF009B9BFF009B9BFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000E8E7E400F3F1
      EE00F0EEEA00EDEBE800DDF2FC00D9E9F500D9E9F500D9E9F500D9E9F500D9E9
      F500D9E9F500ACAAA80000000000000000000000000000000000000000000000
      0000000000008000FF008000FF00000000008000FF008000FF008000FF008000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00AAAAFF00AAAAFF009B9BFF009B9BFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00EDEBE800F4F5F600F4F5F600EDEBE800DDF2FC00DDF2
      FC00F4F5F600ACAAA80000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF00000000008000FF008000FF008000FF008000
      FF008000FF000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000000000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00AAAAFF00AAAAFF009B9BFF009B9BFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00F3F1EE00807EA300C5D5FA00E8E7E400D5D9DA00D5D9DA00D9E9
      F500D9E9F500ACAAA80000000000000000000000000000000000000000008000
      FF008000FF00000000000000000000000000000000008000FF008000FF000000
      00008000FF008000FF000000000000000000000000000000000000000000FF00
      0000FF00000000000000000000000000000000000000FF000000FF0000000000
      0000FF000000FF0000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00AAAAFF00AAAAFF00AAAAFF009B9BFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00F3F1EE009ECDCF009ECDCF00C5D5FA00C5D5FA00D5D9DA00D5D9
      DA00D9E9F500ACAAA800000000000000000000000000000000008000FF008000
      FF000000000000000000000000000000000000000000000000008000FF000000
      0000000000008000FF008000FF00000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000FF000000FF00000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00B5B5FF00AAAAFF00AAAAFF00AAAAFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00F4F5F6009BE5F0009BE5F00080BEEE00D5D9DA00D5D9DA00D5D9
      DA00D5D9DA00ACAAA80000000000000000008000FF008000FF008000FF008000
      FF008000FF008000FF0000000000000000000000000000000000000000000000
      0000000000008000FF008000FF0000000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00B5B5FF00B5B5FF00AAAAFF00AAAAFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00F4F5F60088A9F40088A9F4008080FF009ECDCF00F4F5F600D9E9
      F500D9E9F500ACAAA8000000000000000000000000008000FF008000FF008000
      FF008000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00B5B5FF00B5B5FF00B5B5FF00AAAAFF009B9B
      FF009B9BFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB0088A9F4005353FD004654FF004654FF00E8E7E400DDF2
      FC00DDF2FC00ACAAA800000000000000000000000000000000008000FF008000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000008000FF008000FF00000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00CACAFF00B5B5FF00B5B5FF00AAAAFF00AAAA
      FF009B9BFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FBEFE2005353FD004654FF002424FF00C5D5FA00D9E9
      F500D9E9F500ACAAA80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF008000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00CACAFF00CACAFF00B5B5FF00AAAAFF00AAAA
      FF00AAAAFF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB005353FD004654FF002424FF001E05C900C5D5
      FA00D9E9F500ACAAA800000000000000000000000000000000008000FF008000
      FF00000000000000000000000000000000000000000000000000000000008000
      FF008000FF008000FF008000FF008000FF000000000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00CACAFF00CACAFF00B5B5FF00B5B5FF00AAAA
      FF00AAAAFF004D55FF0000000000000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB0088A9F4004654FF002424FF002424FF00C5D5
      FA00CFD1F700ACAAA800000000000000000000000000000000008000FF008000
      FF0000000000000000008000FF00000000000000000000000000000000000000
      0000000000008000FF008000FF00000000000000000000000000FF000000FF00
      00000000000000000000FF000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00CACAFF00CACAFF00CACAFF00B5B5FF00B5B5
      FF00B5B5FF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB005353FD002424FF002424FF001E05
      C900C0CEE100ACAAA80000000000000000000000000000000000000000008000
      FF008000FF00000000008000FF008000FF000000000000000000000000000000
      00008000FF008000FF000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF0000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00B5B5FF00CACAFF00CACAFF00B5B5FF00B5B5
      FF00B5B5FF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB0088A9F4002424FF002424FF001E05
      C900A8B3F900ACAAA80000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF008000FF008000FF00000000008000FF008000
      FF008000FF000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      0000FF000000000000000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D55FF00B5B5FF00B5B5FF00CACAFF00CACAFF00CACA
      FF00B5B5FF004D55FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB00F3F1EE005353FD002424FF002424
      FF00A8B3F900ACAAA80000000000000000000000000000000000000000000000
      0000000000008000FF008000FF008000FF008000FF00000000008000FF008000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000003200FF003200FF003200
      FF003200FF003200FF003200FF003200FF003200FF003200FF003200FF003200
      FF003200FF003200FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB00F4F5F60088A9F4005353FD0088A9
      F400ACAAA8000000000000000000000000000000000000000000000000000000
      000000000000000000008000FF008000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000000000006037FF006037FF006037
      FF006037FF006037FF006037FF006037FF006037FF006037FF006037FF006037
      FF006037FF006037FF0000000000000000000000000000000000E8E7E400F4F5
      F600F3F1EE00F3F1EE00F4F5F600EDEBE800D9E9F500C5D5FA00C5D5FA00ACAA
      A800000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D55FF004D55FF004D55
      FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF004D55FF004D55
      FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF004D55FF004D55
      FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF004D55FF004D55
      FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF009B9BFF009B9B
      FF009B9BFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF009B9BFF009B9B
      FF009B9BFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00AAAAFF009B9B
      FF009B9BFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00AAAAFF00AAAA
      FF009B9BFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00B5B5FF00AAAA
      FF00AAAAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00B5B5FF00B5B5
      FF00AAAAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00CACAFF00B5B5
      FF00AAAAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00CACAFF00B5B5
      FF00B5B5FF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00CACAFF00CACA
      FF00B5B5FF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00CACAFF00CACA
      FF00B5B5FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55FF004D55
      FF004D55FF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00CACAFF00CACA
      FF00CACAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00B5B5FF00CACA
      FF00CACAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00FFFFFF00FFFF
      FF00FFFFFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000004D55FF00B5B5FF00B5B5
      FF00CACAFF004D55FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D55FF000000000000000000000000003200FF003200FF003200
      FF003200FF003200FF003200FF003200FF003200FF003200FF003200FF003200
      FF003200FF003200FF000000000000000000000000003200FF003200FF003200
      FF003200FF003200FF003200FF003200FF003200FF003200FF003200FF003200
      FF003200FF003200FF000000000000000000000000003200FF003200FF003200
      FF003200FF003200FF003200FF003200FF003200FF003200FF003200FF003200
      FF003200FF003200FF000000000000000000000000003200FF003200FF003200
      FF003200FF003200FF003200FF003200FF003200FF003200FF003200FF003200
      FF003200FF003200FF000000000000000000000000006037FF006037FF006037
      FF006037FF006037FF006037FF006037FF006037FF006037FF006037FF006037
      FF006037FF006037FF000000000000000000000000006037FF006037FF006037
      FF006037FF006037FF006037FF006037FF006037FF006037FF006037FF006037
      FF006037FF006037FF000000000000000000000000006037FF006037FF006037
      FF006037FF006037FF006037FF006037FF006037FF006037FF006037FF006037
      FF006037FF006037FF000000000000000000000000006037FF006037FF006037
      FF006037FF006037FF006037FF006037FF006037FF006037FF006037FF006037
      FF006037FF006037FF000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FC1FF00F000000008000800000000000
      000000000000000000000000000000000000000100000000F81FF80F00000000
      F007F00F00000000C001F007000000008000C001000000000000800000000000
      0000000000000000000000000000000000000001000000000001800700000000
      E00FF01F00000000FFFFFFFF000000008FFFF007FFFFF80F87FFE00381FFF007
      83FFC001807FE003C1FF8001803FC00180018001803F80008001C001803F0000
      8001C001800F00008001C001800300008001C001800100008001C00180210000
      8001C001903E00008001C001983F00018001C001803F80038001C003C03FC007
      8001C007F83FE00F8001C00FFFFFF01F8003C003FF9FFF9F8003C003F90FF90F
      8003C003F107F1078003C003E793E7938003C003CFD9CFD98003C00303F903F9
      8003C00387FF87FF8003C003CFF9CFF98003C003FFF0FFF08003C003CFE0CFE0
      8003C003CDF9CDF98003C003E4F3E4F38003C003F047F0478003C003F84FF84F
      8003C007FCFFFCFF8003C00FFDFFFDFF80038003800380038003800380038003
      8003800380038003800380038003800380038003800380038003800380038003
      8003800380038003800380038003800380038003800380038003800380038003
      8003800380038003800380038003800380038003800380038003800380038003
      8003800380038003800380038003800300000000000000000000000000000000
      000000000000}
  end
  object ThreadToolImages: TImageList
    Left = 416
    Top = 216
    Bitmap = {
      494C01010A000E00040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA000000
      4200000042000000420000004200000042000000420000004200000042000000
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000008D9396006A6E700050535500484B4D00505355006A6E70008D93
      9600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00A0A7FA007979
      FF00000000000000000000000000000000000000000000000000000000009FA5
      A80066686A006E6B6C00938B8B00B3A9A900938E8E006A6869004A4B4C004245
      4600636769009AA0A30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00A0A7FA007979
      FF007979FF000000420000000000000000000000000000000000989EA0007772
      7200E6E6FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00CFCFCF00797A
      7A0041424300565A5C009AA0A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF009797FF009797FF00DDDDFF00DDDDFF009797FF00DDDDFF00A0A7FA00A0A7
      FA00A0A7FA0000004200000000000000000000000000AAB0B300837B7B00E6E6
      FF00E6E6FF00E1E1FF00E1E1FF00E6E6FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF009C9C9C004142430063676900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF00000042000000000000000000C2CACE00827E7E00E6E6FF00E6E6
      FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00797A7A00424546008D9396000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF009797FF009797FF009797FF009797FF009797FF009797FF009797FF00DDDD
      FF00E6E6FF000000420000000000000000009CA1A300E6E6FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00D2CCCC004A4B4C006C7072000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF00000042000000000000000000898B8C00E6E6FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00645E5E0055585A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF009797FF009797FF009797FF009797FF00DDDDFF009797FF009797FF00DDDD
      FF00E6E6FF0000004200000000000000000097939300E1E1FF00E1E1FF00E1E1
      FF00E6E6FF00E1E1FF006F6FFF006F6FFF006F6FFF006F6FFF006F6FFF006F6F
      FF00E1E1FF00E1E1FF007F7070004B4E4F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF000000420000000000000000009E8C8C00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E6E6FF006F6FFF006F6FFF006F6FFF006F6FFF006F6FFF006F6F
      FF00E1E1FF00E1E1FF00A694940055585A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF009797FF00DDDDFF009797FF00DDDDFF00DDDDFF009797FF009797FF009797
      FF00E6E6FF0000004200000000000000000093888800E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF006F6FFF006F6FFF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00878181006C7072000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF000000420000000000000000008B8A8B00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF006F6FFF006F6FFF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00656464008D9396000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF009797FF00DDDDFF009797FF009797FF009797FF009797FF00DDDDFF009797
      FF00E6E6FF00000042000000000000000000AAB0B200E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF006F6FFF006F6FFF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00686B6C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF0000004200000000000000000000000000888A8B00E1E1FF00E1E1
      FF00E1E1FF00E6E6FF006F6FFF006F6FFF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF0077727200A0A7AA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00E6E6
      FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6FF00E6E6
      FF00E6E6FF00A0A7FA00000000000000000000000000BDC4C7008A8A8A00E1E1
      FF00E1E1FF00E6E6FF006F6FFF006F6FFF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00837B7B009A9FA20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0A7FA00A0A7
      FA00A0A7FA00A0A7FA00A0A7FA00A0A7FA00A0A7FA00A0A7FA00A0A7FA00A0A7
      FA00A0A7FA00A0A7FA0000000000000000000000000000000000BDC4C700888A
      8B00C6C6C600E6E6FF00E6E6FF00E1E1FF00FFE7E700E1E1FF008C8CFF008581
      8200ACB2B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AAB0B200939697009D9C9C008C8989009B98990090919200A2A8AA000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003E3EFF003E3EFF003E3E
      FF003E3EFF003E3EFF003E3EFF003E3EFF003E3EFF003E3EFF003E3EFF003E3E
      FF003E3EFF003E3EFF0000000000000000000000000000000000000000000000
      00000000000000000000000000002828FF002828FF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA000000CA000000CA000000CA000000CA000000CA000000CA000000CA000000
      CA000000CA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006262FF00B5B5FF00B5B5
      FF00B5B5FF00B5B5FF00B5B5FF00B5B5FF00B5B5FF00B5B5FF00B5B5FF00B5B5
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF008080FF006A6A
      FF006A6AFF006A6AFF006A6AFF006A6AFF006A6AFF006A6AFF006A6AFF006A6A
      FF006A6AFF006A6AFF006A6AFF0000000000000000006262FF00D2D2FF00D2D2
      FF00D2D2FF00D2D2FF00D2D2FF00D2D2FF00D2D2FF00D2D2FF00D2D2FF00D2D2
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF008080FF008080
      FF008080FF008080FF008080FF008080FF008080FF008080FF008080FF008080
      FF008080FF008080FF006A6AFF0000000000000000006A6AFF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00D2D2FF00D2D2
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF003E1DD2006060600095959500FFFFFF00FFFFFF00FFFFFF003A19CD00FFFF
      FF00FFFFFF008080FF006A6AFF0000000000000000006A6AFF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00D2D2
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF007A61
      EC002A01DF005339C3006565650093939300FFFFFF003A19CD002F08D800A59D
      C700FFFFFF008080FF006A6AFF0000000000000000007171FF00E8E8FF00E1E1
      FF00E1E1FF00D2D2FF00E1E1FF00E1E1FF00E1E1FF00D2D2FF00E1E1FF00E1E1
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      000000000000000000006060FF006060FF00DFDFFF006060FF002828FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF007A61EC002A01DF005238C30054515F003413C8002D07D700A59DC700FFFF
      FF00FFFFFF008080FF006A6AFF0000000000000000007171FF00E8E8FF00E8E8
      FF00D2D2FF000000FF00A2A2FF00E1E1FF00A2A2FF000000FF00D2D2FF00E1E1
      FF00B5B5FF007171FF0000000000000000000000000000000000000000000000
      00006060FF006060FF008686FF009B9BFF00CECEFF009B9BFF006060FF002828
      FF002828FF000000000000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF00FFFFFF007A60EA002A01DF002D07D7002C06D6006B638D00FFFFFF00FFFF
      FF00FFFFFF008080FF006A6AFF0000000000000000007171FF00E8E8FF00E8E8
      FF00E8E8FF00A2A2FF000000FF004444FF000000FF00A2A2FF00E1E1FF00E1E1
      FF00B5B5FF007171FF0000000000000000000000000000000000000000006060
      FF008686FF009B9BFF009B9BFF009B9BFF00CECEFF009B9BFF008686FF008686
      FF006060FF002828FF0000000000000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF003009D9002A01DF00482CC4007575750092929200FFFF
      FF00FFFFFF008080FF006A6AFF0000000000000000007171FF00E8E8FF00E8E8
      FF00E8E8FF00E8E8FF004444FF000000FF004444FF00E1E1FF00E1E1FF00E1E1
      FF00B5B5FF007171FF00000000000000000000000000000000006060FF008686
      FF009B9BFF009B9BFF00FFFFFF009B9BFF00CECEFF009B9BFF009B9BFF008686
      FF008686FF006060FF002828FF00000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF00FFFFFF003A19CD002F08D800715DCC003610E0005A3ED6007E7B89008686
      8600FFFFFF008080FF006A6AFF0000000000000000008484FF00F0F0FF00F0F0
      FF00E8E8FF00A2A2FF000000FF004444FF000000FF00A2A2FF00E8E8FF00E1E1
      FF00B5B5FF007171FF00000000000000000000000000000000006060FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF006060FF002828FF00000000000000000000000000000000000000
      CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7DFF000000CA00BE7DFF00BE7D
      FF000000CA00000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF003A19CD002A01DF008B81B900FFFFFF00FFFFFF004420E2004B29DE007B73
      9D007D7D7D008080FF006A6AFF0000000000000000008484FF00F0F0FF00F0F0
      FF00D2D2FF000000FF00A2A2FF00E8E8FF00A2A2FF000000FF00D2D2FF00E8E8
      FF00B5B5FF007171FF000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF00000000000000CA000000CA000000
      CA000000CA000000CA000000CA000000CA000000CA000000CA000000CA000000
      CA000000CA000000CA000000CA0000000000000000008080FF00FFFFFF003A18
      CC002A01DF007364B700FFFFFF00FFFFFF00FFFFFF00FFFFFF006041E700360F
      DF00FFFFFF008080FF006A6AFF0000000000000000008484FF00F0F0FF00F0F0
      FF00F0F0FF00D2D2FF00E8E8FF00E8E8FF00E8E8FF00D2D2FF00E8E8FF00E8E8
      FF00B5B5FF007171FF000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      00000000000000000000000000000000CA000000CA0000000000000000000000
      000000000000000000000000000000000000000000008080FF00FFFFFF00FFFF
      FF005B47B600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080FF008080FF0000000000000000008484FF00F0F0FF00F0F0
      FF00F0F0FF00F0F0FF00F0F0FF00E8E8FF00E8E8FF00E8E8FF00D1D1E200D1D1
      E200BEBED6007171FF000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00CECEFF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      00000000000000000000000000000000CA000000CA0000000000000000000000
      000000000000000000000000000000000000000000008080FF008080FF008080
      FF008080FF008080FF008080FF008080FF008080FF008080FF008080FF008080
      FF008080FF008080FF008080FF0000000000000000008484FF00FFFFFF00F0F0
      FF00F0F0FF00F0F0FF00F0F0FF00F0F0FF00E8E8FF00E8E8FF003E3EFF008484
      FF003E3EFF00D1D1E2000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00CECEFF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484FF00FFFFFF00FFFF
      FF00F0F0FF00F0F0FF00F0F0FF00F0F0FF00F0F0FF00F0F0FF008484FF003E3E
      FF00D1D1E200000000000000000000000000000000006060FF006060FF006060
      FF006060FF006060FF006060FF006060FF006060FF006060FF006060FF006060
      FF006060FF006060FF006060FF006060FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484FF008484FF008484
      FF008484FF008484FF008484FF008484FF008484FF008484FF008484FF00D1D1
      E200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005B5BFF005B5BFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008000FF008000FF000000
      0000000000000000000000000000000000000000000000000000C3C2C200ACAA
      A800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAAA800ACAA
      A800ACAAA800ACAAA80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005B5BFF00E1E1FF00E1E1FF005B5BFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000FF008000FF00000000008000FF008000FF008000FF008000
      FF00000000000000000000000000000000000000000000000000E8E7E400F3F1
      EE00F0EEEA00EDEBE800DDF2FC00D9E9F500D9E9F500D9E9F500D9E9F500D9E9
      F500D9E9F500ACAAA80000000000000000000000000000000000000000009E9D
      A000827874009997990000000000000000000000000000000000C0BEBE008B87
      86008F888700D3D3D3000000000000000000000000005B5BFF005B5BFF005B5B
      FF00000000005B5BFF00E1E1FF00E1E1FF00E1E1FF00E1E1FF005B5BFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF00000000008000FF008000FF008000FF008000
      FF008000FF000000000000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00EDEBE800F4F5F600F4F5F600EDEBE800DDF2FC00DDF2
      FC00F4F5F600ACAAA80000000000000000000000000000000000649CBC001D83
      B8004861710060514C007C787800BDBBBB00C8C6C700A3A7AA004A91B3004089
      AF006D696700C3C2C30000000000000000005B5BFF00EFEFEF00EFEFEF005B5B
      FF002F2FFF005B5BFF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF005B5B
      FF00000000000000000000000000000000000000000000000000000000008000
      FF008000FF00000000000000000000000000000000008000FF008000FF000000
      00008000FF008000FF0000000000000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00F3F1EE00807EA300C5D5FA00E8E7E400D5D9DA00D5D9DA00D9E9
      F500D9E9F500ACAAA800000000000000000000000000000000008EB5CC00B3ED
      FC0005BFF0004182A20051403A0069616100767D83003094BC00ACF0FF00269F
      C6006C727900D1D0D00000000000000000005B5BFF00EFEFEF005B5BFF005959
      FF005B5BFF00465CC8005151FF00E1E1FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF005B5BFF0000000000000000000000000000000000000000008000FF008000
      FF000000000000000000000000000000000000000000000000008000FF000000
      0000000000008000FF008000FF00000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00F3F1EE009ECDCF009ECDCF00C5D5FA00C5D5FA00D5D9DA00D5D9
      DA00D9E9F500ACAAA800000000000000000000000000000000000000000082B9
      D10016D0FF0023D4FC002C7FA50038404600529DC10091EBFF000ACFFF003884
      AA0096959700000000000000000000000000000000005B5BFF005B5BFF00EFEF
      EF00EFEFEF00EFEFEF00465CC800D2D2FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF005B5BFF0000000000000000008000FF008000FF008000FF008000
      FF008000FF008000FF0000000000000000000000000000000000000000000000
      0000000000008000FF008000FF00000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00F4F5F6009BE5F0009BE5F00080BEEE00D5D9DA00D5D9DA00D5D9
      DA00D5D9DA00ACAAA800000000000000000000000000000000000000000072A8
      C40075E3FF000FD1FF0045E0FC0065B5D900AEF9FF0046E3FF0009BBEB004659
      6500B6B3B200000000000000000000000000000000005B5BFF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00EFEFEF005151FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF005B5BFF0000000000000000008000FF008000FF008000
      FF008000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00F4F5F60088A9F40088A9F4008080FF009ECDCF00F4F5F600D9E9
      F500D9E9F500ACAAA8000000000000000000000000000000000000000000769D
      B30091C8E60002CCFF002EDBFF0079F0FF0094FDFF005FEBFF00178EBB005445
      3F009D999800CECDCD0000000000000000000000D200EFEFEF005959FF00EFEF
      EF00EFEFEF00EFEFEF00EFEFEF005151FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF005B5BFF0000000000000000008000FF008000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000008000FF008000FF00000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB0088A9F4005353FD004654FF004654FF00E8E7E400DDF2
      FC00DDF2FC00ACAAA80000000000000000000000000000000000AFAEAF005E6E
      7A0040AED40016D1FF0016D3FF0050E6FF0088F9FF007AF4FF001F7FAA003E36
      34005B4C440085818200C7C5C400000000000000D2005959FF00465CC8000000
      D200EFEFEF00EFEFEF00465CC800D2D2FF00E1E1FF00E1E1FF00E1E1FF00E1E1
      FF00E1E1FF00E1E1FF00E1E1FF005B5BFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF008000FF000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FBEFE2005353FD004654FF002424FF00C5D5FA00D9E9
      F500D9E9F500ACAAA80000000000000000000000000088939D003288AF000BBB
      EB0042E2FF0023D7FF0004CDFF003ADFFF0073F2FF0093FDFF0052E4FC001496
      C3002D52670056474100766F6C00B9BABD002F2FFF00465CC800EFEFEF005959
      FF000000D200465CC8005B5BFF00E1E1FF00E1E1FF00E1E1FF00E1E1FF005959
      FF005151FF00E1E1FF005B5BFF000000000000000000000000008000FF008000
      FF00000000000000000000000000000000000000000000000000000000008000
      FF008000FF008000FF008000FF008000FF000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB005353FD004654FF002424FF001E05C900C5D5
      FA00D9E9F500ACAAA8000000000000000000A8CADE0005A4D60041E1FF0090FC
      FF0067EEFF0036DEFF0006CEFF0020D6FF0058E9FF0090FCFF006FF1FF0032DD
      FF0003BEF000298AB4005B646B009E9FA300000000005B5BFF00EFEFEF00EFEF
      EF005959FF005B5BFF00E1E1FF00E1E1FF00E1E1FF00E1E1FF005959FF008686
      FF005959FF005B5BFF00000000000000000000000000000000008000FF008000
      FF0000000000000000008000FF00000000000000000000000000000000000000
      0000000000008000FF008000FF00000000000000000000000000F0EEEA00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB0088A9F4004654FF002424FF002424FF00C5D5
      FA00CFD1F700ACAAA800000000000000000068ACD000B0DFEE00BCE3EE00A7CC
      DD0080B2CC0094BFD40048DCFF000ACFFF0048D8F60080B2CC00BBDCE800B4E0
      EE00B1E7F6008EE2F600527F9B00CCCDCF0000000000000000005B5BFF00EFEF
      EF00EFEFEF005151FF00465CC800E1E1FF00E1E1FF005959FF005959FF008686
      FF005959FF005959FF005959FF00000000000000000000000000000000008000
      FF008000FF00000000008000FF008000FF000000000000000000000000000000
      00008000FF008000FF0000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB005353FD002424FF002424FF001E05
      C900C0CEE100ACAAA80000000000000000007AB2CF005F9CBD005F9BBC005E9B
      BB006B9FBD00438AB30093ECFF0004CDFF0012A4D1003A6E8B006B92A9006C9B
      B7006F9FBB006198B900D2D7DC00000000000000000000000000000000005B5B
      FF005B5BFF00465CC800E1E1FF00E1E1FF00E1E1FF00E1E1FF005959FF008686
      FF005959FF000000000000000000000000000000000000000000000000000000
      00008000FF008000FF008000FF008000FF008000FF00000000008000FF008000
      FF008000FF000000000000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB0088A9F4002424FF002424FF001E05
      C900A8B3F900ACAAA80000000000000000000000000000000000000000000000
      0000000000005897B900A4D9F20013D2FF001889B800726E6E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005B5BFF00E1E1FF00E1E1FF00E1E1FF00E1E1FF005959FF008686
      FF005959FF000000000000000000000000000000000000000000000000000000
      0000000000008000FF008000FF008000FF008000FF00000000008000FF008000
      FF00000000000000000000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB00F3F1EE005353FD002424FF002424
      FF00A8B3F900ACAAA80000000000000000000000000000000000000000000000
      00000000000075A8C60090C4E00027D9FF003687AD008C8C9000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005B5BFF00E1E1FF00E1E1FF005B5BFF005959FF008686
      FF005959FF000000000000000000000000000000000000000000000000000000
      000000000000000000008000FF008000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F3F1EE00FEFC
      FB00FEFCFB00FEFCFB00FEFCFB00FEFCFB00F4F5F60088A9F4005353FD0088A9
      F400ACAAA8000000000000000000000000000000000000000000000000000000
      0000000000009AC1D60073B0D0003FCFF000496F8800B0B3B700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005B5BFF005B5BFF00000000005959FF008686
      FF005959FF000000000000000000000000000000000000000000000000000000
      000000000000000000008000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E8E7E400F4F5
      F600F3F1EE00F3F1EE00F4F5F600EDEBE800D9E9F500C5D5FA00C5D5FA00ACAA
      A800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4CBDF0064ABCE000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C00FF80F00000000C007E00300000000
      C003C00100000000C003800100000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000C003000100000000C003800100000000C003800300000000
      C003C00700000000FFFFF01F00000000FFFFFFFF8003FE3FE007FFFF8003FE3F
      E00780018003FE3FE00780018003FE3FE00780018003FE3FE00780018003FC1F
      E00780018003F007E00780018003E003E00780018003C001E00780018003C001
      E0078001800380008001800180038000FE7F800180038000FE7F800180038000
      FFFFFFFF80078000FFFFFFFF800FFFFFFE7FFF9FC003FFFFFC3FF90FC003E3C3
      881FF107C003C003000FE793C003C0030007CFD9C003E007800303F9C003E007
      800187FFC003E0030000CFF9C003C0010000FFF0C00380000001CFE0C0030000
      8003CDF9C0030000C001E4F3C0030001E007F047C003F83FF807F84FC003F83F
      FC07FCFFC007F83FFE47FDFFC00FFCFF}
  end
  object PopupAddFavorite: TPopupMenu
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    OnPopup = PopupAddFavoritePopup
    Left = 636
    Top = 248
  end
  object PopupTreeCategory: TPopupMenu
    OnPopup = PopupTreeCategoryPopup
    Left = 48
    Top = 246
    object PopupCatAddFav: TMenuItem
      Caption = #12362#27671#12395#20837#12426#12395#36861#21152'(&A)'
      OnClick = PopupCatAddFavClick
    end
    object MenuItem13: TMenuItem
      Caption = '-'
    end
    object PopupCatAddBoard: TMenuItem
      Caption = #12371#12371#12395#26495#12434#36861#21152'(&B)'
      OnClick = PopupCatAddBoardClick
    end
    object PopupCatAddCategory: TMenuItem
      Caption = #26032#35215#12459#12486#12468#12522#12434#36861#21152'(&C)'
      OnClick = PopupCatAddCategoryClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object PopupCatDelCategory: TMenuItem
      Caption = #12371#12398#12459#12486#12468#12522#12434#21066#38500'(&D)'
      OnClick = PopupCatDelCategoryClick
    end
  end
  object ResJumpTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = ResJumpTimerTimer
    Left = 48
    Top = 376
  end
  object PopupDrawLines: TPopupMenu
    Left = 456
    Top = 248
    object MenuItemTransparencyAbone: TMenuItem
      Tag = -1
      Action = actTransparencyAbone
      GroupIndex = 1
      RadioItem = True
    end
    object MenuItemNormalAbone: TMenuItem
      Action = actNormalAbone
      GroupIndex = 1
      RadioItem = True
    end
    object MenuItemHalfAbone: TMenuItem
      Tag = 1
      Action = actHalfAbone
      GroupIndex = 1
      RadioItem = True
    end
    object MenuItemIgnoreAbone: TMenuItem
      Tag = 2
      Action = actIgnoreAbone
      GroupIndex = 1
      RadioItem = True
    end
    object MenuItemImportantResOnly: TMenuItem
      Tag = 3
      Action = actImportantResOnly
      GroupIndex = 1
      RadioItem = True
    end
    object MenuItemAboneOnly: TMenuItem
      Tag = 5
      Action = actAboneOnly
      GroupIndex = 1
      RadioItem = True
    end
    object VN3: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object DrawAll: TMenuItem
      Caption = #20840#12524#12473#34920#31034'(&0)'
      GroupIndex = 1
      Hint = #34920#31034#12524#12473#25968#12434#22793#26356
      OnClick = MenuDrawAllClick
    end
    object Draw50: TMenuItem
      Tag = 50
      Caption = #26368#26032' 50'#12524#12473'(&1)'
      GroupIndex = 1
      Hint = #34920#31034#12524#12473#25968#12434#22793#26356
      OnClick = MenuDrawAllClick
    end
    object Draw100: TMenuItem
      Tag = 100
      Caption = #26368#26032'100'#12524#12473'(&2)'
      GroupIndex = 1
      Hint = #34920#31034#12524#12473#25968#12434#22793#26356
      OnClick = MenuDrawAllClick
    end
    object Draw250: TMenuItem
      Tag = 250
      Caption = #26368#26032'250'#12524#12473'(&3)'
      GroupIndex = 1
      Hint = #34920#31034#12524#12473#25968#12434#22793#26356
      OnClick = MenuDrawAllClick
    end
    object Draw500: TMenuItem
      Tag = 500
      Caption = #26368#26032'500'#12524#12473'(&4)'
      GroupIndex = 1
      Hint = #34920#31034#12524#12473#25968#12434#22793#26356
      OnClick = MenuDrawAllClick
    end
  end
  object FavTreeScrlTimer: TTimer
    Enabled = False
    Interval = 80
    OnTimer = FavTreeScrlTimerTimer
    Left = 48
    Top = 280
  end
  object FavTreeExpndTimer: TTimer
    Enabled = False
    OnTimer = FavTreeExpndTimerTimer
    Left = 80
    Top = 280
  end
  object ApplicationEvents: TApplicationEvents
    OnMessage = ApplicationEventsMessage
    OnMinimize = ApplicationEventsMinimize
    Left = 80
    Top = 312
  end
  object PopupTrush: TPopupMenu
    Left = 664
    Top = 248
    object PopupTrushDeleteFile: TMenuItem
      Action = actRemvoeLog
    end
  end
  object MemoImageList: TImageList
    Left = 80
    Top = 376
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E3E3
      E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E000E0E0E000E3E3E300E3E3E300E6E6E600E6E6E600E3E3E300E6E6E600E6E6
      E600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E000000000000000000000000000000000000000000000000000E6E6E600E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E00000000000000000000000000000000000000000000000000000000000E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E00000000000000000000000000000000000000000000000000000000000E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E000000000000000000000000000000000000000000000000000E6E6E600E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E000E0E0E000E0E0E000E0E0E000E3E3E300E6E6E600E3E3E300E6E6E600E6E6
      E600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D9D900E0E0
      E000E0E0E000E0E0E000E3E3E300E3E3E300E6E6E600E3E3E300E6E6E600E6E6
      E600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E0E0
      E000000000000000000000000000000000000000000000000000E6E6E600E6E6
      E600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E0E0
      E00000000000000000000000000000000000000000000000000000000000E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E3E3
      E30000000000000000000000000000000000000000000000000000000000E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E3E3
      E300000000000000000000000000000000000000000000000000E6E6E600E6E6
      E600E6E6E6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E3E3
      E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E6E6E600E6E6E600E6E6
      E600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0E0E000E3E3
      E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300E6E6E600E6E6E6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      8000FFFF8000FFFF800000000000000000000000000000000000FFFF8000FFFF
      8000FFFF800000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000FFFF00000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      000000000000FFFF00000000000000000000000000000000000000000000FFFF
      8000FFFF8000FFFF800000000000000000000000000000000000FFFF8000FFFF
      8000FFFF800000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF0000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      0000FFFF00000000000000000000000000000000000000000000FFFF8000FFFF
      800000000000FFFF8000FFFF80000000000000000000FFFF8000FFFF80000000
      0000FFFF8000FFFF8000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000FFFF0000FFFF00000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000FFFF8000FFFF
      800000000000FFFF8000FFFF80000000000000000000FFFF8000FFFF80000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000FFFF00000000000000000000FFFF0000FFFF00000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000FFFF8000FFFF
      800000000000FFFF8000FFFF80000000000000000000FFFF8000FFFF80000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000FFFF0000FFFF000000000000FFFF00000000
      0000000000000000000000000000000000000000000000000000FFFF8000FFFF
      80000000000000000000FFFF80000000000000000000FFFF8000000000000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000FFFF8000FFFF
      80000000000000000000FFFF80000000000000000000FFFF8000000000000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF0000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000FFFF8000FFFF
      80000000000000000000FFFF8000FFFF8000FFFF8000FFFF8000000000000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF8000FFFF
      8000000000000000000000000000FFFF8000FFFF800000000000000000000000
      0000FFFF8000FFFF800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      00000000000000000000000000000000000000000000FFFF8000FFFF80000000
      0000000000000000000000000000FFFF8000FFFF800000000000000000000000
      000000000000FFFF8000FFFF80000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF8000FFFF80000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF8000FFFF80000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      00000000000000000000000000000000000000000000FFFF8000FFFF80000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF8000FFFF80000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D6D64008677
      7000988C86000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF009B9B
      FF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF009B9B
      FF009B9BFF009B9BFF00000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF0000000000000000000000B2A9A900756560007B71
      6C0059453A0068564E0073645C0081726B009D928C0000000000000000000000
      000000000000000000002B56FF00000000000000000000000000959595007171
      71007E7E7E009F9F9F0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF00BFBF
      FF00BFBFFF00BFBFFF00BFBFFF00BFBFFF00BFBFFF00BFBFFF00BFBFFF00BFBF
      FF00BFBFFF009B9BFF00000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF0000000000000000000000BF757500CC676700785F
      5D009C9997008A8582007D7773007E726B0056423800A49993009D918C00988B
      85000000000000000000000000006482FF000000000051BBE20051BBE2001093
      BE00296C820048656F00676767006F6F6F007D7D7D009C9C9C00000000000000
      00000000000000000000000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000BF777700CC6767008167
      6700DCBCBC00E2B5B500D1D1D100B1B1B100D2D1D1009BABF700C1BCB900604B
      41008D7C740000000000000000002B56FF000000000051BBE200C4EAF90074D9
      FF005ECDF5005ECDF50051BBE2001093BE0023718B0047646D00666666006F6F
      6F000000000000000000000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000BF797900CC676700775E
      5E00B07E7E00BF5A5A00B1B1B100F3F3F3009BABF7002450FF00EDD7D700B9A3
      A200C5BCB800000000001645FF002B56FF000000000051BBE20096D8F20098EA
      FF0081E5FF0081E5FF0081E5FF0081E5FF0081E5FF0051BBE20051BBE2001093
      BE005F5F5F0000000000000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000000000000000000000000000000000000BF7B7B00CC676700836A
      6A00B5828200B14C4C00D1D1D1009BABF7000839FF002450FF002450FF002450
      FF002450FF000134FF000134FF006482FF000000000051BBE20051BBE200CBF8
      FF0089EFFF0089EFFF0089EFFF0089EFFF0089EFFF0089EFFF0081E6FF0051BB
      E200385E6C0080808000000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF00000000000000000000000000000000000000BF7D7D00CC6767008A72
      7200C7949400A33E3E009BABF7000134FF000134FF000134FF000134FF000134
      FF000134FF000134FF002450FF00000000000000000051BBE20051BBE200C8EE
      F90096FCFF0096FCFF0096FCFF0096FCFF0096FCFF0096FCFF008AF0FF00B9FF
      FF0051BBE2005F5F5F00ADADAD000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF000000000000000000000000000000000000000000FF00
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000BF7F7F00CC6767008465
      6500E4D7D700CEA1A100D1D1D1009BABF7002450FF002450FF008099FF008099
      FF008099FF000000000000000000000000000000000051BBE20077D6FF0051BB
      E200DCFFFF00CEFFFF00C0FFFF00B1FFFF00ADFFFF00ADFFFF009BF2FF00D2FF
      FF0051BBE2001093BE00838383000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000000000000000
      0000FF00000000000000000000000000000000000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000BF818100CC676700A65A
      5A0096646400977F7F00938C8C00C1C1C1009BABF7000134FF00F2D9D900C2A6
      A400BCB0AC000000000000000000000000000000000051BBE2007EE2FF007EE2
      FF0051BBE20051BBE20051BBE200CEF1F900DCFFFF00CCFFFF00B3F2FF00ECFF
      FF00ECFFFF001093BE00959595000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000000000000000
      0000FF00000000000000000000000000000000000000FF000000FF0000000000
      00000000000000000000000000000000000000000000BF838300CC6767009354
      5400A65A5A00B9616100CC676700B9616100DABFBF009BABF700E6B3B300854C
      4900776159000000000000000000000000000000000051BBE20093F9FF0093F9
      FF0093F9FF0015AD28005DD6A40088EEF90051BBE20051BBE20051BBE20051BB
      E20051BBE20051BBE200000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000BF858500CC6767008667
      6700E3E3E300C3C3C300ABA4A400A48A8A00A97D7D00DAC8C800E1B1B100854C
      4900776159000000000000000000000000000000000051BBE200A4FFFF0099FF
      FF0015AD280015AD280015AD280070E2B1009FFFFF0099FFFF0051BBE2000000
      00000000000000000000000000000000000000000000000000009B9BFF00DFDF
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDF
      FF00DFDFFF009B9BFF0000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000BF878700CC676700866E
      6E00C1C1C100C4C4C400BCBCBC00C9C9C900DDDDDD00C5C5C500A65A5A00854C
      490077615900000000000000000000000000000000000000000051BBE20024BC
      480024BC480024BC480015AD280015AD280051BBE20051BBE20051BBE2000000
      00000000000000000000000000000000000000000000000000009B9BFF00F0F0
      FF00DFDFFF00DFDFFF00DFDFFF00DFDFFF00DFDFFF009B9BFF009B9BFF009B9B
      FF009B9BFF009B9BFF0000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000BF898900CC676700866D
      6D00BFBFBF00C2C2C200B9B9B900C1C1C100BDBDBD00BDBDBD00A65A5A00854C
      490078625A000000000000000000000000000000000000000000000000000000
      0000A4E7BA0037CF6A0015AD2800000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF00F0F0
      FF00F0F0FF00F0F0FF00DFDFFF00DFDFFF00DFDFFF009B9BFF00BFBFFF00BFBF
      FF00BFBFFF009B9BFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000BF8B8B00CC676700856C
      6C00C2C2C200E9E9E900E7E7E700EBEBEB00DEDEDE00BBBBBB00A65A5A00864E
      4B007B665E000000000000000000000000000000000000000000000000000000
      00000000000037CF6A0015AD2800000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF00F0F0
      FF00F0F0FF00F0F0FF00F0F0FF00DFDFFF00DFDFFF009B9BFF00BFBFFF00BFBF
      FF009B9BFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000AD878700CC757500B59C
      9C00BEBEBE00BEBEBE00BEBEBE00C9C9C900DEDEDE00BEBEBE00A65A5A008A51
      4E0089756E000000000000000000000000000000000000000000000000000000
      0000000000000000000037CF6A0015AD28000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF00F0F0
      FF00F0F0FF00F0F0FF00F0F0FF00F0F0FF00DFDFFF009B9BFF00BFBFFF009B9B
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D5D5D500E3D6D600B9878700CDAD
      AD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000037CF6A0015AD280000000000000000000000
      00000000000000000000000000000000000000000000000000009B9BFF009B9B
      FF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF009B9BFF000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000C01F000000000000
      C00F000000000000CFC7000000000000CFE7000000000000CFE7000000000000
      CFC7000000000000C00F000000000000C00F000000000000CFCF000000000000
      CFE7000000000000CFE7000000000000CFC7000000000000C00F000000000000
      C01F000000000000FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFE7FE3C7C003C007DE7BE3C7C003C007EE77C993C003FFE7F66FC993FFE3
      FFE7F66FC993FFE3FFE7FA5FCDB3FFE3FFE7FC3FCDB3FFE3FFE7E007CC33FFE3
      FFE7FE7FCE73FFE3FFE7FE7F9E79C003C007C0039FF9C003C007FE7F9FF9C003
      FFFFFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7FFFFFFC003BFF1807DC3FFC003
      BFF1800E803FC003DFE38006800FC003DFE380048007C003EFC780008003C003
      E00780018001C003EF8F80078001C003F78F80078001C003F79F80078003C003
      F71F8007801FC003FB3F8007C01FC003FA3F8007F1FFC003FC7F8007F9FFC007
      FC7F8007FCFFC00FFFFFFF0FFE7FC01F00000000000000000000000000000000
      000000000000}
  end
  object PopupBar: TPopupMenu
    Left = 336
    object MenuPopupBarToolBar: TMenuItem
      Caption = #12484#12540#12523#12496#12540'(&T)'
      Checked = True
      OnClick = MenuViewToolBarToggleVisibleClick
    end
    object MenuPopupBarLinkBar: TMenuItem
      Caption = #12522#12531#12463#12496#12540'(&L)'
      Checked = True
      OnClick = MenuViewLinkBarToggleVisibleClick
    end
    object MenuPopupBarAdressBar: TMenuItem
      Caption = #12450#12489#12524#12473#12496#12540'(&A)'
      Checked = True
      OnClick = MenuViewAddressBarToggleVisibleClick
    end
    object N82: TMenuItem
      Caption = '-'
    end
    object MenuPopupBarMenu: TMenuItem
      Caption = #12513#12491#12517#12540'(&M)'
      Checked = True
      OnClick = MenuViewMenuToggleVisibleClick
    end
  end
  object PopupTaskTray: TPopupMenu
    Left = 80
    Top = 176
    object PopupTaskTrayRestore: TMenuItem
      Caption = #20803#12398#12469#12452#12474#12395#25147#12377'(&R)'
      OnClick = PopupTaskTrayRestoreClick
    end
    object PopupTaskTrayClose: TMenuItem
      Caption = #38281#12376#12427'(&C)'
      OnClick = PopupTaskTrayCloseClick
    end
  end
  object PopupStatusBar: TPopupMenu
    OnPopup = PopupStatusBarPopup
    Left = 16
    Top = 488
    object MenuStatusOpenByBrowser: TMenuItem
      AutoHotkeys = maManual
      Caption = #12502#12521#12454#12470#12540#12391#38283#12367'(&B)'
      OnClick = MenuStatusOpenByBrowserClick
    end
    object MenuStatusOpenByLovelyBrowser: TMenuItem
      Caption = 'LovelyBrowser'#12391#38283#12367'(&L)'
      OnClick = MenuStatusOpenByLovelyBrowserClick
    end
    object MenuStatusCopyURI: TMenuItem
      Caption = 'URL'#12434#12467#12500#12540'(&C)'
      OnClick = MenuStatusCopyURIClick
    end
    object MenuStatusReset: TMenuItem
      Caption = #12491#12517#12540#12473#12496#12540#12434#12522#12475#12483#12488'(&R)'
      OnClick = MenuStatusResetClick
    end
    object N98: TMenuItem
      Caption = '-'
    end
    object N56: TMenuItem
      Caption = #12513#12514#27396#12434#34920#31034'(&M)'
      OnClick = StatusBarClick
    end
    object MenuStatusCmdSep: TMenuItem
      Caption = '-'
    end
  end
  object PopupWritePanel: TPopupMenu
    OnPopup = PopupWritePanelPopup
    Left = 560
    Top = 344
    object MenuWritePanelCanMove: TMenuItem
      Caption = #31227#21205#21487#33021#12395#12377#12427
      OnClick = ToolButtonWriteTitleAutoHideClick
    end
    object MenuWritePanelPos: TMenuItem
      Caption = #12473#12524#12499#12517#12540#12398#19979#12395#37197#32622#12377#12427
      OnClick = MenuWritePanelPosClick
    end
    object MenuWritePanelDisableStatusBar: TMenuItem
      Caption = #12473#12486#12540#12479#12473#12496#12540#38750#34920#31034
      OnClick = MenuWritePanelDisableStatusBarClick
    end
    object MenuWritePanelDisableTopBar: TMenuItem
      Caption = #12488#12483#12503#12496#12540#38750#34920#31034
      OnClick = MenuWritePanelDisableTopBarClick
    end
  end
  object PopupThreSys: TPopupMenu
    OnPopup = PopupThreSysPopup
    Left = 696
    Top = 248
    object actMaxView1: TMenuItem
      Action = actMaxView
    end
    object N84: TMenuItem
      Caption = '-'
    end
    object MenuThreSysMove: TMenuItem
      Caption = #31227#21205'(&M)'
      OnClick = MenuThreSysMoveClick
    end
    object MenuThreSysResize: TMenuItem
      Caption = #12469#12452#12474#22793#26356'(&S)'
      OnClick = MenuThreSysResizeClick
    end
    object N112: TMenuItem
      Caption = '-'
    end
    object MenuThreSysCascade: TMenuItem
      Caption = #37325#12397#12390#34920#31034
      OnClick = MenuWindowCascadeClick
    end
    object MenuThreSysTileVertically: TMenuItem
      Caption = #24038#21491#12395#20006#12409#12390#34920#31034
      OnClick = MenuWindowTileVerticallyClick
    end
    object MenuThreSysTileHorizontally: TMenuItem
      Caption = #19978#19979#12395#20006#12409#12390#34920#31034
      OnClick = MenuWindowTileHorizontallyClick
    end
    object N85: TMenuItem
      Caption = '-'
    end
    object MenuThreSysRestoreAll: TMenuItem
      Caption = #12377#12409#12390#20803#12398#12469#12452#12474#12395#25147#12377
      OnClick = MenuWindowRestoreAllClick
    end
    object MenuThreSysMaximizeAll: TMenuItem
      Caption = #12377#12409#12390#26368#22823#21270
      OnClick = MenuWindowMaximizeAllClick
    end
    object N113: TMenuItem
      Caption = '-'
    end
    object actCloseTab1: TMenuItem
      Action = actCloseTab
    end
  end
  object SearchTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = SearchTimerTimer
    Left = 48
    Top = 208
  end
  object SearchImages: TImageList
    Left = 168
    Top = 88
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002828FF002828FF002828FF00000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009B9BFF00DFDFFF002828FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006060FF006060FF00DFDFFF006060FF002828FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006060FF006060FF008686FF009B9BFF00CECEFF009B9BFF006060FF002828
      FF002828FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006060
      FF008686FF009B9BFF009B9BFF009B9BFF00CECEFF009B9BFF008686FF008686
      FF006060FF002828FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006060FF008686
      FF009B9BFF009B9BFF00FFFFFF009B9BFF00CECEFF009B9BFF009B9BFF008686
      FF008686FF006060FF002828FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006060FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF006060FF002828FF00000000000000000000000000000000000000
      0000000000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      0000000000000000000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00B5B5FF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      0000000000000000000000000000008000000080000000800000008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00CECEFF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006060FF008686FF009B9B
      FF009B9BFF00FFFFFF00FFFFFF00DFDFFF00CECEFF00CECEFF009B9BFF009B9B
      FF008686FF008686FF006060FF002828FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006060FF006060FF006060
      FF006060FF006060FF006060FF006060FF006060FF006060FF006060FF006060
      FF006060FF006060FF006060FF006060FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000000000000000000000000000800000008000000000
      0000000000000000000000800000008000000080000000000000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000080000000000000000000000000000000800000008000000000
      0000000000000000000000800000008000000080000000000000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000080000000000000000000000000000000800000008000000000
      0000000000000080000000800000008000000080000000800000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000000000000000000000000000800000008000000000
      0000000000000080000000800000008000000080000000800000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000000000008000000080000000800000008000000080
      0000008000000080000000000000000000000000000000800000008000000000
      0000000000000080000000800000000000000080000000800000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000080000000800000008000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000000000000800000008000000080000000800000008000000000
      0000008000000080000000000000000000000000000000800000008000000000
      0000008000000080000000800000000000000080000000800000008000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000000000000080000000800000008000000080000000800000000000000000
      0000008000000080000000000000000000000000000000800000008000000000
      0000008000000080000000000000000000000000000000800000008000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000000
      0000008000000080000000800000008000000080000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000000
      0000008000000080000000000000000000000000000000800000008000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000080
      0000008000000080000000000000000000000000000000800000008000000080
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000008000000080
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000800000008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000008000000080
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000008000000080
      0000008000000080000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FE3F007F00000000FE3F003F00000000
      FE3F001F00000000FE3F000F00000000FE3FFC0F00000000FC1FFE0700000000
      F007FF0700000000E003FF0700000000C001FF0700000000C001F80000000000
      8000FC01000000008000FE03000000008000FF07000000008000FF8F00000000
      8000FFDF00000000FFFFFFFF00000000FFFF9FF3FFFF9FF3FFFF9FF3FFFF9FF3
      9FE39C73CFE79C739FC39C73CFE79C739F839833CFC798339F039833CF8F9833
      9E039933CF1F99339C139113CE3F911398339393C03F939390739393C00F9393
      80F38383CFE7838381F387C3CFE787C383F387C3CFE787C387F387C3C00F87C3
      8FF38FE3C03F8FE3FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupSearch: TPopupMenu
    OnPopup = PopupSearchPopup
    Left = 136
    Top = 88
    object MenuSearchExtract: TMenuItem
      Caption = #12524#12473#25277#20986'(&E)'
      GroupIndex = 1
      ShortCut = 16397
      OnClick = MenuSearchItemClick
    end
    object MenuSearchExtractTree: TMenuItem
      Tag = 1
      Caption = #12524#12473#25277#20986'+'#12484#12522#12540'(&T)'
      GroupIndex = 1
      ShortCut = 24589
      OnClick = MenuSearchItemClick
    end
    object N109: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object MenuSearchNext: TMenuItem
      Tag = 2
      Caption = #8595#26908#32034'(&N)'
      GroupIndex = 1
      ShortCut = 114
      OnClick = MenuSearchItemClick
    end
    object MenuSearchPrev: TMenuItem
      Tag = 3
      Caption = #8593#26908#32034'(&P)'
      GroupIndex = 1
      ShortCut = 8306
      OnClick = MenuSearchItemClick
    end
    object N111: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object MenuSearchCopy: TMenuItem
      Tag = 4
      Caption = #12467#12500#12540'(&C)'
      GroupIndex = 1
      ShortCut = 16451
      OnClick = MenuSearchItemClick
    end
    object MenuSearchCut: TMenuItem
      Tag = 5
      Caption = #20999#12426#21462#12426'(&T)'
      GroupIndex = 1
      ShortCut = 16472
      OnClick = MenuSearchItemClick
    end
    object MenuSearchPaste: TMenuItem
      Tag = 6
      Caption = #36028#12426#20184#12369'(&P)'
      GroupIndex = 1
      ShortCut = 16470
      OnClick = MenuSearchItemClick
    end
    object MenuSearchSelectAll: TMenuItem
      Tag = 7
      Caption = #12377#12409#12390#36984#25246'(&A)'
      GroupIndex = 1
      ShortCut = 16449
      OnClick = MenuSearchItemClick
    end
    object MenuSearchClear: TMenuItem
      Tag = 8
      Caption = #12463#12522#12450'(&E)'
      GroupIndex = 1
      ShortCut = 16453
      OnClick = MenuSearchItemClick
    end
    object N92: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object MenuSearchNormal: TMenuItem
      Tag = 9
      Caption = #36890#24120#26908#32034'(&N)'
      GroupIndex = 1
      RadioItem = True
      ShortCut = 16462
      OnClick = MenuSearchItemClick
    end
    object MenuSearchMigemo: TMenuItem
      Tag = 10
      Caption = 'Migemo'#26908#32034'(&M)'
      GroupIndex = 1
      RadioItem = True
      ShortCut = 16461
      OnClick = MenuSearchItemClick
    end
    object MenuSearchRegExp: TMenuItem
      Tag = 11
      Caption = #27491#35215#26908#32034'(&R)'
      GroupIndex = 1
      RadioItem = True
      ShortCut = 16466
      OnClick = MenuSearchItemClick
    end
    object N88: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object MenuSearchIncremental: TMenuItem
      Tag = 12
      Caption = #12452#12531#12463#12522#12513#12531#12479#12523'(&I)'
      GroupIndex = 1
      ShortCut = 16457
      OnClick = MenuSearchItemClick
    end
    object MenuSearchMultiWord: TMenuItem
      Tag = 13
      Caption = #12510#12523#12481#12527#12540#12489'(&W)'
      GroupIndex = 1
      ShortCut = 16471
      OnClick = MenuSearchItemClick
    end
    object MenuSearchIgnoreFullHalf: TMenuItem
      Tag = 14
      Caption = #20840#21322#35282#19968#33268'(&F)'
      GroupIndex = 1
      ShortCut = 16454
      OnClick = MenuSearchItemClick
    end
    object N90: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object MenuSearchClose: TMenuItem
      Tag = 15
      Caption = #38281#12376#12427'(&Q)'
      GroupIndex = 1
      ShortCut = 27
      OnClick = MenuSearchItemClick
    end
  end
  object PopupUrlEdit: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupUrlEditPopup
    Left = 424
    Top = 32
    object MenuUrlEditUndo: TMenuItem
      Caption = #20803#12395#25147#12377'(&U)'
      ShortCut = 16474
      OnClick = MenuUrlEditUndoClick
    end
    object N89: TMenuItem
      Caption = '-'
    end
    object MenuUrlEditCut: TMenuItem
      Caption = #20999#12426#21462#12426'(&T)'
      ShortCut = 16472
      OnClick = MenuUrlEditCutClick
    end
    object MenuUrlEditCopy: TMenuItem
      Caption = #12467#12500#12540'(&C)'
      ShortCut = 16451
      OnClick = MenuUrlEditCopyClick
    end
    object MenuUrlEditPaste: TMenuItem
      Caption = #36028#12426#20184#12369'(&P)'
      ShortCut = 16470
      OnClick = MenuUrlEditPasteClick
    end
    object MenuUrlEditPasteAndGo: TMenuItem
      Caption = #36028#12426#20184#12369#12390#31227#21205'(&G)'
      ShortCut = 16452
      OnClick = MenuUrlEditPasteAndGoClick
    end
    object MenuUrlEditDelete: TMenuItem
      Caption = #21066#38500'(&D)'
      ShortCut = 46
      OnClick = MenuUrlEditDeleteClick
    end
    object N91: TMenuItem
      Caption = '-'
    end
    object MenuUrlEditSelectAll: TMenuItem
      Caption = #12377#12409#12390#36984#25246'(&A)'
      ShortCut = 16449
      OnClick = MenuUrlEditSelectAllClick
    end
  end
  object TrayIcon: TJLTrayIcon
    Visible = False
    PopupMenu = PopupTaskTray
    OnMouseUp = TrayIconMouseUp
    Left = 80
    Top = 208
  end
  object PopupThreReload: TPopupMenu
    Left = 512
    Top = 248
    object U1: TMenuItem
      Action = actCheckNewRes
    end
    object N110: TMenuItem
      Action = actCheckNewResAll
    end
    object N108: TMenuItem
      Action = actTabPtrl
    end
  end
end
