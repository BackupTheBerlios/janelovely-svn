object ImageViewPreference: TImageViewPreference
  Left = 286
  Top = 168
  BorderStyle = bsDialog
  Caption = #12452#12513#12540#12472#12499#12517#12540#12450#35373#23450
  ClientHeight = 323
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object btOK: TButton
    Left = 297
    Top = 295
    Width = 60
    Height = 20
    Caption = #12424#12429#12375
    Default = True
    TabOrder = 0
    OnClick = DoOK
  end
  object btCancel: TButton
    Left = 364
    Top = 295
    Width = 60
    Height = 20
    Caption = #12420#12417#12427
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 430
    Height = 289
    ActivePage = TabSheetDanger
    TabIndex = 6
    TabOrder = 2
    object TabSheetGeneral: TTabSheet
      Caption = #25805#20316
      object Label6: TLabel
        Left = 6
        Top = 173
        Width = 203
        Height = 12
        Caption = #22806#37096#12499#12517#12540#12450'('#30011#20687#12434'Alt+'#12463#12522#12483#12463#12391#36215#21205')'
      end
      object cbEnableFolding: TCheckBox
        Left = 13
        Top = 24
        Width = 199
        Height = 14
        Caption = #38750#12450#12463#12486#12451#12502#12395#12394#12387#12383#12425#25240#12426#12383#12383#12416
        TabOrder = 1
        OnClick = cbEnableFoldingClick
      end
      object cbAdjustToWindow: TCheckBox
        Left = 13
        Top = 110
        Width = 186
        Height = 14
        Caption = #30011#20687#12434#12454#12451#12531#12489#12454#12395#21512#12431#12379#12427
        TabOrder = 5
      end
      object cbScrollOpposite: TCheckBox
        Left = 199
        Top = 110
        Width = 147
        Height = 14
        Caption = #12489#12521#12483#12464#12392#36870#12395#12473#12463#12525#12540#12523
        TabOrder = 6
      end
      object btSelectExternalViewer: TButton
        Left = 346
        Top = 186
        Width = 20
        Height = 20
        Caption = '...'
        TabOrder = 10
        OnClick = SelectExternalViewer
      end
      object cbActivateViewerIfURLHasLoaded: TCheckBox
        Left = 32
        Top = 64
        Width = 192
        Height = 12
        Caption = #26082#35501'URL'#12463#12522#12483#12463#12391#12450#12463#12486#12451#12502#21270
        TabOrder = 3
      end
      object cbKeepTabVisible: TCheckBox
        Left = 32
        Top = 84
        Width = 154
        Height = 14
        Caption = #25240#12426#12383#12383#12415#26178#12395#12479#12502#12434#34920#31034
        TabOrder = 4
        OnClick = cbKeepTabVisibleClick
      end
      object ebExternalViewer: TEdit
        Left = 6
        Top = 186
        Width = 334
        Height = 20
        TabOrder = 9
      end
      object cbCloseAllTabIfFormClosed: TCheckBox
        Left = 13
        Top = 130
        Width = 173
        Height = 13
        Caption = #12499#12517#12540#12450#12434#38281#12376#12383#12425#12479#12502#12434#38281#12376#12427
        TabOrder = 7
      end
      object cbAlwaysProtect: TCheckBox
        Left = 13
        Top = 150
        Width = 129
        Height = 12
        Caption = #12487#12501#12457#12523#12488#12391#12514#12470#12452#12463
        TabOrder = 8
      end
      object cbHiddenMode: TCheckBox
        Left = 32
        Top = 44
        Width = 199
        Height = 13
        Caption = 'URL'#12463#12522#12483#12463#12391#12499#12517#12540#12450#12434#38283#12363#12394#12356
        TabOrder = 2
      end
      object Button1: TButton
        Left = 6
        Top = 211
        Width = 99
        Height = 20
        Caption = 'MenuConfig'#26360#20986
        TabOrder = 11
        OnClick = Button1Click
      end
      object cbDisableTitleBar: TCheckBox
        Left = 13
        Top = 4
        Width = 148
        Height = 14
        Caption = #12479#12452#12488#12523#12496#12540#12434#34920#31034#12375#12394#12356
        TabOrder = 0
      end
    end
    object TabSheetTab: TTabSheet
      Caption = #12479#12502','#12510#12540#12463
      ImageIndex = 3
      object Label11: TLabel
        Left = 104
        Top = 208
        Width = 117
        Height = 12
        Caption = #12514#12470#12452#12463#12479#12452#12523#12398#22823#12365#12373
      end
      object rgTabStyle: TRadioGroup
        Left = 13
        Top = 6
        Width = 161
        Height = 78
        Caption = #12479#12502#12398#24418#24335
        ItemIndex = 0
        Items.Strings = (
          #12479#12502
          #12508#12479#12531
          #12501#12521#12483#12488#12508#12479#12531)
        TabOrder = 0
      end
      object cbImageTab: TCheckBox
        Left = 102
        Top = 38
        Width = 65
        Height = 14
        Caption = #30011#20687#12479#12502
        TabOrder = 2
      end
      object cbEnableMultiLineTab: TCheckBox
        Left = 102
        Top = 19
        Width = 65
        Height = 14
        Caption = #35079#25968#21015
        TabOrder = 1
      end
      object cbContinuousTabChange: TCheckBox
        Left = 102
        Top = 96
        Width = 257
        Height = 14
        Caption = #36890#24120#30011#20687#12392#26360#24235#30011#20687#12391#36899#32154#30340#12395#12479#12502#31227#21205#12377#12427
        TabOrder = 5
        OnClick = cbContinuousTabChangeClick
      end
      object rgTabSelectAllType: TRadioGroup
        Left = 186
        Top = 6
        Width = 160
        Height = 78
        Caption = #12300#20840#12390#12510#12540#12463#12301#12398#26360#24235#20966#29702
        Items.Strings = (
          #26360#24235#12501#12449#12452#12523#12434#36984#25246
          #26360#24235#20869#12398#30011#20687#12434#36984#25246
          #12393#12385#12425#12418#36984#25246#12375#12394#12356)
        TabOrder = 3
      end
      object cbShowDialogToSaveHighlightTab: TCheckBox
        Left = 102
        Top = 116
        Width = 257
        Height = 14
        Caption = #12510#12540#12463#30011#20687#12434#25805#20316#12377#12427#26178#12399#12480#12452#12450#12525#12464#12434#34920#31034
        TabOrder = 6
      end
      object rgShrinkType: TRadioGroup
        Left = 13
        Top = 93
        Width = 77
        Height = 61
        Caption = #32302#23567#34920#31034
        ItemIndex = 0
        Items.Strings = (
          #39640#21697#20301
          #39640#36895)
        TabOrder = 4
      end
      object cbUseTabNavigateIcon: TCheckBox
        Left = 102
        Top = 136
        Width = 244
        Height = 14
        Caption = #12490#12499#12466#12540#12471#12519#12531#12450#12452#12467#12531#12434#20351#12358
        TabOrder = 7
      end
      object cbGoLeftWhenTabClose: TCheckBox
        Left = 102
        Top = 156
        Width = 251
        Height = 17
        Caption = #12479#12502#12434#38281#12376#12383#26178#12395#24038#12398#12479#12502#12434#12450#12463#12486#12451#12502#21270
        TabOrder = 8
      end
      object seProtectMosaicSize: TSpinEdit
        Left = 256
        Top = 204
        Width = 49
        Height = 21
        MaxValue = 100
        MinValue = 1
        TabOrder = 10
        Value = 1
      end
      object cbConnectedTabEdge: TCheckBox
        Left = 102
        Top = 176
        Width = 235
        Height = 17
        Caption = #12479#12502#19968#35239#12398#20001#31471#12391#21453#23550#12398#31471#12395#31227#21205
        TabOrder = 9
      end
    end
    object TabSheetArchive: TTabSheet
      Caption = #26360#24235','#36890#20449
      ImageIndex = 1
      object Label2: TLabel
        Left = 6
        Top = 122
        Width = 109
        Height = 12
        Caption = #12518#12540#12470#12540#12456#12540#12472#12455#12531#12488
      end
      object Label1: TLabel
        Left = 163
        Top = 174
        Width = 82
        Height = 12
        Caption = #12522#12480#12452#12524#12463#12488#22238#25968
      end
      object Label3: TLabel
        Left = 6
        Top = 174
        Width = 81
        Height = 12
        Caption = #12479#12452#12512#12450#12454#12488'('#31186')'
      end
      object Label7: TLabel
        Left = 6
        Top = 18
        Width = 65
        Height = 12
        Caption = #26360#24235#12501#12449#12452#12523
      end
      object Label12: TLabel
        Left = 8
        Top = 204
        Width = 60
        Height = 12
        Caption = #26368#22823#25509#32154#25968
      end
      object cmbUserAgent: TComboBox
        Left = 6
        Top = 142
        Width = 360
        Height = 20
        ItemHeight = 12
        TabOrder = 2
        Items.Strings = (
          'Mozilla/4.0 (compatible; MSIE 5.0; Win32)'
          'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)'
          'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)'
          'Mozilla/4.79 [en] (Win98; I)'
          'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.2b)')
      end
      object seRedirectMaximum: TSpinEdit
        Left = 253
        Top = 171
        Width = 49
        Height = 21
        MaxValue = 20
        MinValue = 0
        TabOrder = 4
        Value = 0
      end
      object seTimeOut: TSpinEdit
        Left = 96
        Top = 171
        Width = 49
        Height = 21
        MaxValue = 300
        MinValue = 20
        TabOrder = 3
        Value = 20
      end
      object clbArchiveEnabled: TCheckListBox
        Left = 6
        Top = 30
        Width = 360
        Height = 46
        Color = clBtnFace
        Columns = 6
        ItemHeight = 12
        TabOrder = 0
      end
      object cbUseIndividualStatusBar: TCheckBox
        Left = 186
        Top = 92
        Width = 180
        Height = 13
        Caption = #26360#24235#12395#12473#12486#12540#12479#12473#12496#12540#12434#34920#31034
        TabOrder = 1
      end
      object seConnectionLimit: TSpinEdit
        Left = 96
        Top = 200
        Width = 49
        Height = 21
        MaxValue = 5
        MinValue = 1
        TabOrder = 5
        Value = 1
      end
    end
    object TabSheetThread: TTabSheet
      Caption = #12473#12524#35239#25805#20316
      ImageIndex = 5
      object Label4: TLabel
        Left = 179
        Top = 68
        Width = 12
        Height = 12
        Caption = #32294
      end
      object Label5: TLabel
        Left = 250
        Top = 68
        Width = 32
        Height = 12
        Caption = #215#12288#27178
      end
      object cbSwapShiftCtrl: TCheckBox
        Left = 6
        Top = 8
        Width = 360
        Height = 13
        Caption = 'Ctrl+URL'#12463#12522#12483#12463#12391#12514#12470#12452#12463'('#35299#38500':Ctrl'#12463#12522#12483#12463#12289#12502#12521#12454#12470':Shift+URL)'
        TabOrder = 0
      end
      object cbOpenImagesOnly: TCheckBox
        Left = 6
        Top = 28
        Width = 353
        Height = 13
        Caption = #12300#36984#25246#31684#22258#12398#65333#65330#65324#12434#20840#12390#38283#12367#12301#12398#23550#35937#12434#30011#20687#12392#26360#24235#12395#38480#23450
        TabOrder = 1
      end
      object cbShowImageHint: TCheckBox
        Left = 6
        Top = 48
        Width = 219
        Height = 14
        Caption = #12473#12524#30011#38754#12398#12498#12531#12488#12391#30011#20687#24773#22577#12434#34920#31034#12377#12427
        TabOrder = 2
      end
      object cbShowImageOnImageHint: TCheckBox
        Left = 48
        Top = 68
        Width = 129
        Height = 14
        Caption = #12498#12531#12488#12395#30011#20687#12434#34920#31034
        TabOrder = 3
        OnClick = cbShowImageOnImageHintClick
      end
      object seImageHintHeigtht: TSpinEdit
        Left = 198
        Top = 63
        Width = 46
        Height = 21
        MaxValue = 999
        MinValue = 100
        TabOrder = 4
        Value = 300
      end
      object seImageHintWidth: TSpinEdit
        Left = 288
        Top = 63
        Width = 46
        Height = 21
        MaxValue = 999
        MinValue = 100
        TabOrder = 5
        Value = 300
      end
      object cbDisableDeleteTmpAlart: TCheckBox
        Left = 198
        Top = 218
        Width = 155
        Height = 13
        Caption = #12501#12449#12452#12523#21066#38500#12434#30906#35469#12375#12394#12356
        TabOrder = 11
      end
      object cbDeleteTmpOnStartUp: TCheckBox
        Left = 8
        Top = 218
        Width = 180
        Height = 13
        Caption = #36215#21205#32066#20102#26178#12395#12486#12531#12509#12521#12522#21066#38500
        TabOrder = 10
        OnClick = cbDeleteTmpOnStartUpClick
      end
      object cbForceToUseViewer: TCheckBox
        Left = 8
        Top = 132
        Width = 257
        Height = 17
        Caption = #20840#12390#12398#25313#24373#23376#12434#12499#12517#12540#12450#12391#20966#29702#12377#12427
        TabOrder = 8
      end
      object cbOpenURLOnMouseOver: TCheckBox
        Left = 8
        Top = 152
        Width = 305
        Height = 17
        Caption = #12510#12454#12473#12458#12540#12496#12540#12391#30011#20687#12434#38283#12367'('#36215#21205#12487#12501#12457#12523#12488#12398#12398#35373#23450')'
        TabOrder = 9
      end
      object cbShowCacheOnImageHint: TCheckBox
        Left = 48
        Top = 88
        Width = 257
        Height = 17
        Caption = #12461#12515#12483#12471#12517#24773#22577#12434#12498#12531#12488#12395#21033#29992#12377#12427
        TabOrder = 6
      end
      object cbDisableImageViewer: TCheckBox
        Left = 8
        Top = 112
        Width = 177
        Height = 17
        Caption = #30011#20687#12499#12517#12540#12450#12434#28961#21177#12395#12377#12427
        TabOrder = 7
      end
    end
    object TabSheetQuickSave: TTabSheet
      Caption = #12463#12452#12483#12463#20445#23384
      ImageIndex = 2
      object ToolBar1: TToolBar
        Left = 390
        Top = 0
        Width = 32
        Height = 262
        Align = alRight
        AutoSize = True
        ButtonHeight = 20
        ButtonWidth = 32
        Caption = 'ToolBar1'
        EdgeInner = esNone
        EdgeOuter = esNone
        Flat = True
        ShowCaptions = True
        TabOrder = 0
        object btnUp: TToolButton
          Left = 0
          Top = 0
          Caption = #8593
          Enabled = False
          ImageIndex = 0
          Wrap = True
          OnClick = btnUpClick
        end
        object btnDown: TToolButton
          Left = 0
          Top = 20
          Caption = #8595
          Enabled = False
          ImageIndex = 1
          Wrap = True
          OnClick = btnDownClick
        end
        object btnMakeNew: TToolButton
          Left = 0
          Top = 40
          Caption = 'NEW'
          ImageIndex = 2
          Wrap = True
          OnClick = btnMakeNewClick
        end
        object btnEdit: TToolButton
          Left = 0
          Top = 60
          Caption = 'EDIT'
          Enabled = False
          ImageIndex = 3
          Wrap = True
          OnClick = btnEditClick
        end
        object btnDelete: TToolButton
          Left = 0
          Top = 80
          Caption = 'DEL'
          Enabled = False
          ImageIndex = 4
          Wrap = True
          OnClick = btnDeleteClick
        end
      end
      object lvQuickSPList: TListView
        Left = 0
        Top = 0
        Width = 390
        Height = 262
        Align = alClient
        Columns = <
          item
            Caption = #12461#12515#12503#12471#12519#12531
            Width = 100
          end
          item
            AutoSize = True
            Caption = #22580#25152
          end>
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnChange = lvQuickSPListChange
      end
    end
    object TabSheetCache: TTabSheet
      Caption = #12461#12515#12483#12471#12517
      ImageIndex = 6
      object lbLifeSpanOfCache: TLabel
        Left = 16
        Top = 62
        Width = 132
        Height = 12
        Caption = #12461#12515#12483#12471#12517#12398#26377#21177#26399#38480'('#26085')'
      end
      object LabelCachePath: TLabel
        Left = 8
        Top = 176
        Width = 119
        Height = 12
        Caption = #12461#12515#12483#12471#12517#20445#23384#12501#12457#12523#12480
      end
      object seLifeSpanOfCache: TSpinEdit
        Left = 160
        Top = 58
        Width = 65
        Height = 21
        MaxValue = 9999
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object cbUseViewCache: TCheckBox
        Left = 16
        Top = 8
        Width = 177
        Height = 17
        Caption = #12461#12515#12483#12471#12517#12434#20351#29992#12377#12427
        TabOrder = 0
      end
      object GroupBoxCachePriority: TGroupBox
        Left = 8
        Top = 88
        Width = 337
        Height = 73
        Caption = #12461#12515#12483#12471#12517#12398#26356#26032#30906#35469#12434#12375#12394#12356#25313#24373#23376
        TabOrder = 3
        object LabelCachePriority: TLabel
          Left = 16
          Top = 41
          Width = 102
          Height = 12
          Caption = #12381#12398#20182'(";"'#12391#21306#20999#12427')'
        end
        object cbPrioryCacheImage: TCheckBox
          Left = 120
          Top = 16
          Width = 81
          Height = 17
          Caption = #30011#20687
          TabOrder = 1
        end
        object cbPrioryCacheArchive: TCheckBox
          Left = 224
          Top = 16
          Width = 65
          Height = 17
          Caption = #26360#24235
          TabOrder = 2
        end
        object edPrioryCacheExtention: TEdit
          Left = 128
          Top = 37
          Width = 193
          Height = 20
          TabOrder = 3
        end
        object cbPrioryCacheWhole: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = #20840#12390
          TabOrder = 0
          OnClick = cbPrioryCacheWholeClick
        end
      end
      object edCachePath: TEdit
        Left = 8
        Top = 192
        Width = 313
        Height = 20
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
        OnKeyDown = edCachePathKeyDown
      end
      object btnSelectCachePath: TButton
        Left = 328
        Top = 192
        Width = 35
        Height = 17
        Caption = #35373#23450
        TabOrder = 5
        OnClick = btnSelectCachePathClick
      end
      object cbCacheSelectedFileOnly: TCheckBox
        Left = 16
        Top = 32
        Width = 297
        Height = 17
        Caption = #25351#23450#12375#12383#12501#12449#12452#12523#12384#12369#12461#12515#12483#12471#12517#12377#12427
        TabOrder = 1
      end
    end
    object TabSheetDanger: TTabSheet
      Caption = #23455#39443#23460
      ImageIndex = 4
      object Label8: TLabel
        Left = 7
        Top = 53
        Width = 129
        Height = 12
        Caption = #35501#12415#36796#12414#12428#12383'SusiePlugin'
      end
      object cbInvisibleTab: TCheckBox
        Left = 8
        Top = 8
        Width = 154
        Height = 13
        Caption = #12479#12502#12434#34920#31034#12375#12394#12356
        TabOrder = 0
        OnClick = HitobashiraAlart
      end
      object cbDisableAlartAtOpenWithRelation: TCheckBox
        Left = 8
        Top = 27
        Width = 297
        Height = 17
        Caption = #12300'Windows'#12398#38306#36899#12389#12369#12391#38283#12367#12301#12391#35686#21578#12434#34920#31034#12375#12394#12356
        TabOrder = 2
        OnClick = cbDisableAlartAtOpenWithRelationClick
      end
      object cbEnableFlashMovie: TCheckBox
        Left = 192
        Top = 4
        Width = 153
        Height = 17
        Caption = 'FLASH'#12512#12540#12499#12540#20877#29983
        TabOrder = 1
      end
      object ListViewSusie: TListView
        Left = 0
        Top = 71
        Width = 420
        Height = 150
        Columns = <
          item
            Caption = 'Format'
          end
          item
            Caption = 'Ext'
          end
          item
            Caption = 'Plugin'
            Width = 155
          end
          item
            Caption = 'FileName'
            Width = 155
          end>
        ReadOnly = True
        TabOrder = 3
        ViewStyle = vsReport
      end
    end
  end
end
