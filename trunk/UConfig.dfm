object UIConfig: TUIConfig
  Left = 306
  Top = 149
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #35373#23450
  ClientHeight = 383
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object OkButton: TButton
    Left = 304
    Top = 332
    Width = 81
    Height = 25
    Caption = #12424#12429#12375
    Default = True
    TabOrder = 2
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 400
    Top = 332
    Width = 81
    Height = 25
    Cancel = True
    Caption = #12420#12417#12427
    TabOrder = 3
    OnClick = CancelButtonClick
  end
  object PageControl: TPageControl
    Left = 118
    Top = 8
    Width = 393
    Height = 321
    ActivePage = SheetNet
    Style = tsFlatButtons
    TabOrder = 1
    TabStop = False
    OnChange = PageControlChange
    object SheetNet: TTabSheet
      Caption = #36890#20449
      TabVisible = False
      object Label6: TLabel
        Left = 16
        Top = 176
        Width = 122
        Height = 12
        Caption = #21463#20449#12479#12452#12512#12450#12454#12488'('#12511#12522#31186')'
      end
      object Label9: TLabel
        Left = 16
        Top = 208
        Width = 101
        Height = 12
        Caption = #12508#12540#12489#19968#35239#21462#24471'URL'
      end
      object Label42: TLabel
        Left = 16
        Top = 260
        Width = 121
        Height = 12
        Caption = #21463#20449#12496#12483#12501#12449#12469#12452#12474'(KB)'
      end
      object EditReadTimeout: TEdit
        Left = 151
        Top = 171
        Width = 65
        Height = 20
        TabOrder = 2
      end
      object EditBBSMenuURL: TEdit
        Left = 16
        Top = 224
        Width = 329
        Height = 20
        TabOrder = 3
      end
      object CheckBoxNetOnline: TCheckBox
        Left = 16
        Top = 8
        Width = 153
        Height = 17
        Caption = #12458#12531#12521#12452#12531
        TabOrder = 0
      end
      object CheckBoxNetUseReadCGI: TCheckBox
        Left = 16
        Top = 280
        Width = 369
        Height = 25
        Caption = 'ISDN/56K'#12514#12487#12512'( read.cgi )'
        TabOrder = 4
        Visible = False
      end
      object GroupBoxProxy: TGroupBox
        Left = 16
        Top = 24
        Width = 361
        Height = 137
        TabOrder = 1
        object Label1: TLabel
          Left = 120
          Top = 45
          Width = 12
          Height = 12
          Caption = #39894
        end
        object Label2: TLabel
          Left = 312
          Top = 45
          Width = 31
          Height = 12
          Caption = #12509#12540#12488
        end
        object Label10: TLabel
          Left = 32
          Top = 64
          Width = 36
          Height = 12
          Caption = #21463#20449#29992
        end
        object Label11: TLabel
          Left = 32
          Top = 88
          Width = 36
          Height = 12
          Caption = #36865#20449#29992
        end
        object Label22: TLabel
          Left = 8
          Top = 112
          Width = 64
          Height = 12
          Caption = 'SSL('#35469#35388#29992')'
        end
        object CheckBoxNetUseProxy: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Proxy'#12434#20351#12358
          TabOrder = 0
        end
        object EditProxyServer: TEdit
          Left = 88
          Top = 61
          Width = 201
          Height = 20
          TabOrder = 1
        end
        object EditProxyPort: TEdit
          Left = 296
          Top = 61
          Width = 49
          Height = 20
          TabOrder = 2
        end
        object EditProxyPortForWriting: TEdit
          Left = 296
          Top = 85
          Width = 49
          Height = 20
          TabOrder = 4
        end
        object EditProxyServerForWriting: TEdit
          Left = 88
          Top = 85
          Width = 201
          Height = 20
          TabOrder = 3
        end
        object EditProxyServerForSSL: TEdit
          Left = 88
          Top = 109
          Width = 201
          Height = 20
          TabOrder = 5
        end
        object EditProxyPortForSSL: TEdit
          Left = 296
          Top = 109
          Width = 49
          Height = 20
          TabOrder = 6
        end
        object CheckBoxNetNoCache: TCheckBox
          Left = 128
          Top = 16
          Width = 217
          Height = 17
          Caption = 'Proxy'#20351#29992#26178#12395#12461#12515#12483#12471#12517#12434#20351#29992#12375#12394#12356
          TabOrder = 7
        end
      end
      object EditRecvBufferSize: TEdit
        Left = 151
        Top = 255
        Width = 65
        Height = 20
        MaxLength = 3
        TabOrder = 5
      end
    end
    object SheetPath: TTabSheet
      Caption = #12497#12473
      ImageIndex = 2
      TabVisible = False
      object Label7: TLabel
        Left = 32
        Top = 38
        Width = 79
        Height = 12
        Caption = #12502#12521#12454#12470#12398#12497#12473
      end
      object Label36: TLabel
        Left = 32
        Top = 102
        Width = 258
        Height = 12
        Caption = #12525#12464#12392#12508#12540#12489#19968#35239#12398#12501#12457#12523#12480' ('#27425#22238#36215#21205#26178#12363#12425#26377#21177')'
      end
      object Label37: TLabel
        Left = 32
        Top = 169
        Width = 206
        Height = 12
        Caption = #12473#12461#12531#12398#12501#12457#12523#12480' ('#27425#22238#36215#21205#26178#12363#12425#26377#21177')'
      end
      object Label44: TLabel
        Left = 35
        Top = 248
        Width = 156
        Height = 12
        Caption = #8251#12473#12524#34920#31034#12399#26032#35215#12479#12502#12424#12426#26377#21177
        Visible = False
      end
      object Label45: TLabel
        Left = 35
        Top = 270
        Width = 282
        Height = 12
        Caption = #8251#12450#12452#12467#12531#39006#12399#36215#21205#20013#12399#26368#24460#12395#25351#23450#12375#12383#12418#12398#12364#27531#12426#12414#12377
        Visible = False
      end
      object CheckBoxBrowserSpecified: TCheckBox
        Left = 24
        Top = 2
        Width = 177
        Height = 25
        Caption = #12502#12521#12454#12470#12434#25351#23450#12377#12427
        TabOrder = 0
      end
      object EditBrowserPath: TEdit
        Left = 32
        Top = 57
        Width = 289
        Height = 20
        TabOrder = 1
      end
      object ButtonSelBrowser: TButton
        Left = 328
        Top = 53
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 2
        OnClick = ButtonSelBrowserClick
      end
      object EditLogBasePath: TEdit
        Left = 32
        Top = 125
        Width = 289
        Height = 20
        TabOrder = 3
      end
      object ButtonSelLogBaseFolder: TButton
        Tag = 1
        Left = 328
        Top = 122
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 4
        OnClick = ButtonSelFolderClick
      end
      object ButtonSelSkinFolder: TButton
        Tag = 2
        Left = 328
        Top = 188
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 6
        OnClick = ButtonSelFolderClick
      end
      object SkinPathBox: TComboBox
        Left = 32
        Top = 191
        Width = 289
        Height = 20
        ItemHeight = 12
        TabOrder = 5
      end
    end
    object SheetAction: TTabSheet
      Caption = #21205#20316
      ImageIndex = 4
      TabVisible = False
      object GroupBox2: TGroupBox
        Left = 16
        Top = 76
        Width = 361
        Height = 62
        Caption = #12473#12524#19968#35239
        TabOrder = 0
        object CheckBoxOprSelPreviousThread: TCheckBox
          Left = 32
          Top = 34
          Width = 289
          Height = 17
          Caption = #26368#24460#12395#35211#12383#12473#12524#12398#20301#32622#12395#12472#12515#12531#12503#12391#12365#12427#12392#12356#12356#12394
          TabOrder = 1
        end
        object CheckBoxOprShowSubjectCache: TCheckBox
          Left = 32
          Top = 8
          Width = 233
          Height = 25
          Caption = #20445#23384#12375#12390#12356#12427#12473#12524#19968#35239#12434#26368#21021#12395#34920#31034#12377#12427
          TabOrder = 2
          Visible = False
        end
        object CheckBoxOprOpenThreWNewView: TCheckBox
          Left = 32
          Top = 16
          Width = 201
          Height = 17
          Caption = #26032#12375#12356#12479#12502#12391#12473#12524#12434#38283#12367
          TabOrder = 0
        end
      end
      object GroupBox3: TGroupBox
        Left = 16
        Top = 144
        Width = 361
        Height = 104
        Caption = #12473#12524
        TabOrder = 1
        object Label47: TLabel
          Left = 32
          Top = 75
          Width = 114
          Height = 12
          Caption = #26082#24471#12473#12524#12398#34920#31034#12524#12473#25968
        end
        object CheckBoxOprScrollToNewRes: TCheckBox
          Left = 32
          Top = 34
          Width = 225
          Height = 17
          Caption = #26032#30528#12395#12472#12515#12531#12503#12377#12427
          TabOrder = 1
        end
        object RadioButtonOprScrollTop: TRadioButton
          Left = 184
          Top = 34
          Width = 81
          Height = 17
          Caption = #19978#12395#20986#12377
          TabOrder = 2
        end
        object RadioButtonOprScrollBottom: TRadioButton
          Left = 272
          Top = 34
          Width = 81
          Height = 17
          Caption = #19979#12395#20986#12377
          TabOrder = 3
        end
        object CheckBoxOprJumpToPrev: TCheckBox
          Left = 32
          Top = 16
          Width = 201
          Height = 17
          Caption = #35211#12390#12356#12383#12392#12371#12429#12395#12472#12515#12531#12503#12377#12427
          TabOrder = 0
        end
        object CheckBoxOprCheckNewWRedraw: TCheckBox
          Left = 32
          Top = 52
          Width = 225
          Height = 17
          Caption = #26032#30528#12481#12455#12483#12463#26178#12395#26082#24471#12524#12473#12434#25551#12365#30452#12377
          TabOrder = 4
        end
        object ComboBoxOprDrawLines: TComboBox
          Left = 160
          Top = 72
          Width = 97
          Height = 20
          Style = csDropDownList
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          ItemHeight = 12
          ParentFont = False
          TabOrder = 5
          Items.Strings = (
            #20840#12524#12473#34920#31034
            #26368#26032' 50'#12524#12473
            #26368#26032'100'#12524#12473
            #26368#26032'250'#12524#12473
            #26368#26032'500'#12524#12473)
        end
      end
      object GroupBox6: TGroupBox
        Left = 16
        Top = 256
        Width = 361
        Height = 49
        Caption = #12362#27671#12395#20837#12426
        TabOrder = 2
        object CheckBoxOprOpenFavWNewView: TCheckBox
          Left = 32
          Top = 16
          Width = 241
          Height = 25
          Caption = #26032#12375#12356#12479#12502#12391#38283#12367
          TabOrder = 0
        end
      end
      object GroupBox11: TGroupBox
        Left = 16
        Top = 8
        Width = 361
        Height = 62
        Caption = #26495#19968#35239
        TabOrder = 3
        object CheckBoxOprBoardExpandOneCategory: TCheckBox
          Left = 32
          Top = 34
          Width = 201
          Height = 17
          Caption = #12459#12486#12468#12522#12434#19968#12388#12375#12363#38283#12363#12394#12356
          TabOrder = 0
        end
        object CheckBoxOprOpenBoardWNewTab: TCheckBox
          Left = 32
          Top = 16
          Width = 201
          Height = 17
          Caption = #26032#12375#12356#12479#12502#12391#26495#12434#38283#12367
          TabOrder = 1
        end
      end
    end
    object SheetOperation: TTabSheet
      Caption = #25805#20316
      ImageIndex = 5
      TabVisible = False
      object GroupBox4: TGroupBox
        Left = 8
        Top = 40
        Width = 228
        Height = 121
        Caption = #26495#12395#38306#12377#12427#25805#20316
        TabOrder = 1
        object Label12: TLabel
          Left = 10
          Top = 21
          Width = 82
          Height = 12
          Hint = #12484#12522#12540#12391#12398#12463#12522#12483#12463
          Caption = #12471#12531#12464#12523#12463#12522#12483#12463
          ParentShowHint = False
          ShowHint = True
        end
        object Label13: TLabel
          Left = 10
          Top = 45
          Width = 72
          Height = 12
          Hint = #12484#12522#12540#12391#12398#12480#12502#12523#12463#12522#12483#12463
          Caption = #12480#12502#12523#12463#12522#12483#12463
        end
        object Label14: TLabel
          Left = 10
          Top = 93
          Width = 35
          Height = 12
          Hint = #12450#12489#12524#12473#30452#25171#12385#12289#12473#12524#20869#12522#12531#12463#31561
          Caption = #12381#12398#20182
          ParentShowHint = False
          ShowHint = True
        end
        object Label41: TLabel
          Left = 10
          Top = 69
          Width = 71
          Height = 12
          Hint = #26495#35239#12513#12491#12517#12540#12289#12522#12531#12463#12496#12540#12363#12425#38283#12367#12392#12365
          Caption = #65426#65414#65389#65392#12539#65432#65437#65400#65418#65438#65392
          ParentShowHint = False
          ShowHint = True
        end
        object ComboBoxOprBrdClick: TComboBox
          Left = 103
          Top = 16
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #28961#12369#12428#12400#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprBrdDblClk: TComboBox
          Left = 103
          Top = 40
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 1
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #28961#12369#12428#12400#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprBrdOther: TComboBox
          Left = 103
          Top = 88
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 3
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #28961#12369#12428#12400#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprBrdMenu: TComboBox
          Left = 103
          Top = 64
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 2
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #28961#12369#12428#12400#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 176
        Width = 228
        Height = 121
        Caption = #12473#12524#12395#38306#12377#12427#25805#20316
        TabOrder = 2
        object Label15: TLabel
          Left = 10
          Top = 44
          Width = 72
          Height = 12
          Hint = #12484#12522#12540#12289#12473#12524#35239#12391#12398#12480#12502#12523#12463#12522#12483#12463
          Caption = #12480#12502#12523#12463#12522#12483#12463
        end
        object Label16: TLabel
          Left = 10
          Top = 21
          Width = 82
          Height = 12
          Hint = #12484#12522#12540#12289#12473#12524#35239#12391#12398#12463#12522#12483#12463
          Caption = #12471#12531#12464#12523#12463#12522#12483#12463
        end
        object Label17: TLabel
          Left = 10
          Top = 92
          Width = 35
          Height = 12
          Hint = #12450#12489#12524#12473#30452#25171#12385#12289#12473#12524#20869#12522#12531#12463#31561
          Caption = #12381#12398#20182
          ParentShowHint = False
          ShowHint = True
        end
        object Label38: TLabel
          Left = 10
          Top = 68
          Width = 71
          Height = 12
          Hint = #12362#27671#12395#20837#12426#12513#12491#12517#12540#12289#12522#12531#12463#12496#12540#12363#12425#38283#12367#12392#12365
          Caption = #65426#65414#65389#65392#12539#65432#65437#65400#65418#65438#65392
          ParentShowHint = False
          ShowHint = True
        end
        object ComboBoxOprThrClick: TComboBox
          Left = 103
          Top = 16
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #36969#23452#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprThrDblClk: TComboBox
          Left = 103
          Top = 40
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 1
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #36969#23452#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprThrOther: TComboBox
          Left = 103
          Top = 88
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 3
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #36969#23452#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
        object ComboBoxOprThrMenu: TComboBox
          Left = 103
          Top = 64
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 2
          Items.Strings = (
            #28961#21177
            #24120#12395#12525#12540#12459#12523
            #36969#23452#21462#24471
            #26356#26032#12481#12455#12483#12463)
        end
      end
      object CheckBoxCatSingleClick: TCheckBox
        Left = 16
        Top = 1
        Width = 241
        Height = 17
        Caption = #12471#12531#12464#12523#12463#12522#12483#12463#12391#12459#12486#12468#12522#12540#12434#38283#12367
        TabOrder = 0
      end
      object GroupBox15: TGroupBox
        Left = 244
        Top = 40
        Width = 140
        Height = 137
        Caption = #12473#12524#12434#35023#12391#38283#12367
        TabOrder = 3
        object CheckBoxOprThreBgOpen: TCheckBox
          Left = 8
          Top = 20
          Width = 125
          Height = 17
          Caption = #12473#12524#35239#65288#65404#65437#65400#65438#65433#65400#65432#65391#65400#65289
          TabOrder = 0
        end
        object CheckBoxOprFavBgOpen: TCheckBox
          Left = 8
          Top = 42
          Width = 125
          Height = 17
          Caption = #12362#27671#12395#20837#12426
          TabOrder = 1
        end
        object CheckBoxOprClosedBgOpen: TCheckBox
          Left = 8
          Top = 64
          Width = 125
          Height = 17
          Caption = #38281#12376#12383#12473#12524
          TabOrder = 2
        end
        object CheckBoxOprAddrBgOpen: TCheckBox
          Left = 8
          Top = 86
          Width = 125
          Height = 17
          Caption = #12450#12489#12524#12473#12496#12540#30452#25171#12385
          TabOrder = 3
        end
        object CheckBoxOprUrlBgOpen: TCheckBox
          Left = 8
          Top = 108
          Width = 125
          Height = 17
          Caption = #12473#12524#20869#12522#12531#12463
          TabOrder = 4
        end
      end
      object GroupBox19: TGroupBox
        Left = 244
        Top = 184
        Width = 140
        Height = 113
        Caption = #12522#12525#12540#12489#21046#38480
        TabOrder = 4
        object Label65: TLabel
          Left = 9
          Top = 27
          Width = 62
          Height = 12
          Caption = #12473#12524#12483#12489#19968#35239
        end
        object Label66: TLabel
          Left = 12
          Top = 66
          Width = 57
          Height = 12
          Caption = #12524#12473#34920#31034#27396
        end
        object Label67: TLabel
          Left = 120
          Top = 27
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label68: TLabel
          Left = 120
          Top = 66
          Width = 12
          Height = 12
          Caption = #31186
        end
        object SpinEditListReloadInterval: TSpinEdit
          Left = 78
          Top = 23
          Width = 41
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object SpinEditThreadReloadInterval: TSpinEdit
          Left = 78
          Top = 61
          Width = 41
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
      end
      object CheckBoxoptCheckNewResSingleClick: TCheckBox
        Left = 16
        Top = 20
        Width = 193
        Height = 17
        Caption = #26356#26032#12398#12354#12427#12473#12524#12434#36984#25246#12391#12522#12525#12540#12489
        TabOrder = 5
      end
    end
    object SheetTabOperation: TTabSheet
      Caption = #12479#12502#25805#20316
      ImageIndex = 17
      TabVisible = False
      object Label54: TLabel
        Left = 40
        Top = 120
        Width = 81
        Height = 12
        Hint = #12484#12522#12540#12391#12398#12463#12522#12483#12463
        Caption = #12479#12502#12434#38281#12376#12383#12392#12365
        ParentShowHint = False
        ShowHint = True
      end
      object GroupBox14: TGroupBox
        Left = 24
        Top = 8
        Width = 305
        Height = 89
        Caption = #12479#12502#12434#36861#21152#12377#12427#20301#32622
        TabOrder = 0
        object Label49: TLabel
          Left = 32
          Top = 21
          Width = 24
          Height = 12
          Hint = #12484#12522#12540#12391#12398#12463#12522#12483#12463
          Caption = #36890#24120
          ParentShowHint = False
          ShowHint = True
        end
        object Label53: TLabel
          Left = 32
          Top = 53
          Width = 73
          Height = 12
          Hint = #12484#12522#12540#12391#12398#12480#12502#12523#12463#12522#12483#12463
          Caption = #12479#12502#12363#12425#38283#12367#26178
        end
        object ComboBoxOprAddPosNormal: TComboBox
          Left = 136
          Top = 16
          Width = 129
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          Items.Strings = (
            #20808#38957
            #12450#12463#12486#12451#12502#12398#24038
            #12450#12463#12486#12451#12502#12398#21491
            #26368#24460)
        end
        object ComboBoxOprAddPosRelative: TComboBox
          Left = 136
          Top = 48
          Width = 129
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 1
          Items.Strings = (
            #20808#38957
            #12450#12463#12486#12451#12502#12398#24038
            #12450#12463#12486#12451#12502#12398#21491
            #26368#24460)
        end
      end
      object ComboBoxOprClosePos: TComboBox
        Left = 160
        Top = 116
        Width = 129
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 1
        Items.Strings = (
          #24038#12434#12450#12463#12486#12451#12502
          #21491#12434#12450#12463#12486#12451#12502)
      end
    end
    object SheetForTest: TTabSheet
      Caption = #12381#12398#20182
      ImageIndex = 1
      TabVisible = False
      object LabelRecyclableCount: TLabel
        Left = 16
        Top = 265
        Width = 172
        Height = 12
        Caption = #35299#25918#12375#12394#12356#12391#20445#25345#12377#12427#26495#24773#22577#12398#25968
        FocusControl = SpinEditRecyclableCount
      end
      object Label57: TLabel
        Left = 16
        Top = 286
        Width = 108
        Height = 12
        Caption = #12300#12385#12423#12387#12392#35211#12427#12301#12398#31684#22258
      end
      object CheckBoxComm: TCheckBox
        Left = 16
        Top = 3
        Width = 185
        Height = 17
        Caption = #12385#12423#12387#12392#12488#12524#12540#12473#36861#21152
        TabOrder = 0
      end
      object CheckBoxOprDisableTabInView: TCheckBox
        Left = 16
        Top = 21
        Width = 353
        Height = 17
        Caption = #12393#12358#12379#12472#12515#12531#12503#12391#12365#12394#12356#12363#12425#12473#12524#20869'TAB'#12461#12540#25805#20316#12434#28961#21177#12395#12377#12427
        TabOrder = 1
      end
      object CheckBoxOptEnableBoardMenu: TCheckBox
        Left = 16
        Top = 50
        Width = 249
        Height = 17
        Caption = #26495#35239#12513#12491#12517#12540#12395#12508#12540#12489#19968#35239#12434#23637#38283#12377#12427
        TabOrder = 2
      end
      object CheckBoxOptSaveLastItems: TCheckBox
        Left = 16
        Top = 96
        Width = 273
        Height = 19
        Caption = #32066#20102#26178#12395#38283#12356#12390#12356#12383#12473#12524#12539#26495#12434#27425#22238#36215#21205#26178#12395#38283#12367
        TabOrder = 4
      end
      object CheckBoxOptAllowFavoriteDuplicate: TCheckBox
        Left = 16
        Top = 133
        Width = 241
        Height = 17
        Caption = #12362#27671#12395#20837#12426#12398#37325#35079#12434#35377#21487#12377#12427
        TabOrder = 5
      end
      object CheckBoxOptEnableFavMenu: TCheckBox
        Left = 16
        Top = 67
        Width = 217
        Height = 17
        Caption = #12513#12491#12517#12540#12395#12362#27671#12395#20837#12426#12434#23637#38283#12377#12427
        TabOrder = 3
      end
      object SpinEditRecyclableCount: TSpinEdit
        Left = 199
        Top = 259
        Width = 57
        Height = 21
        MaxValue = 99
        MinValue = 0
        TabOrder = 6
        Value = 0
      end
      object EditOptChottoView: TEdit
        Left = 136
        Top = 282
        Width = 41
        Height = 20
        TabOrder = 7
      end
      object CheckBoxoptSetFocusOnWriteMemo: TCheckBox
        Left = 16
        Top = 190
        Width = 281
        Height = 24
        Caption = #12522#12525#12540#12489#24460#12395#12501#12457#12540#12459#12473#12434#12513#12514#27396#12395#21512#12431#12379#12427
        TabOrder = 8
      end
      object CheckBoxOldOnCheckNew: TCheckBox
        Left = 16
        Top = 218
        Width = 305
        Height = 17
        Caption = #12522#12525#12540#12489#12377#12427#38555#12395#12381#12428#12414#12391#12398#12524#12473#12434#12377#12409#12390#26082#35501#12395#12377#12427
        TabOrder = 9
      end
      object CheckBoxReadIfScrollBottom: TCheckBox
        Left = 16
        Top = 236
        Width = 289
        Height = 17
        Caption = #26368#24460#12414#12391#12473#12463#12525#12540#12523#12375#12383#12473#12524#12434#26082#35501#12395
        TabOrder = 10
      end
      object CheckBoxHideInTaskTray: TCheckBox
        Left = 16
        Top = 150
        Width = 241
        Height = 17
        Caption = #26368#23567#21270#26178#12399#12479#12473#12463#12488#12524#12452#12395#26684#32013
        TabOrder = 11
      end
    end
    object SheetWrite: TTabSheet
      Caption = #26360#12365#36796#12415
      ImageIndex = 11
      TabVisible = False
      object Label31: TLabel
        Left = 16
        Top = 160
        Width = 24
        Height = 12
        Caption = #21517#21069
      end
      object Label32: TLabel
        Left = 232
        Top = 160
        Width = 33
        Height = 12
        Caption = #12513#12540#12523
      end
      object Label33: TLabel
        Left = 16
        Top = 120
        Width = 102
        Height = 12
        Caption = #12300#12371#12428#12395#12524#12473#12301#12398#35352#21495
      end
      object Label34: TLabel
        Left = 24
        Top = 296
        Width = 337
        Height = 12
        Caption = #8251#26360#12365#36796#12415#26178#12395'Shift'#25276#12375#12391#12381#12398#12392#12365#12398#21517#21069#12392#12513#12540#12523#12364#36861#21152#12373#12428#12414#12377
      end
      object Label48: TLabel
        Left = 32
        Top = 32
        Width = 4
        Height = 12
      end
      object CheckBoxWrtRecordWriting: TCheckBox
        Left = 16
        Top = 8
        Width = 225
        Height = 17
        Caption = #26360#12365#36796#12415#23653#27508#12434' kakikomi.txt'#12395#20445#23384#12377#12427
        TabOrder = 0
      end
      object MemoWrtNameList: TMemo
        Left = 16
        Top = 176
        Width = 201
        Height = 113
        ScrollBars = ssVertical
        TabOrder = 6
        WordWrap = False
      end
      object MemoWrtMailList: TMemo
        Left = 232
        Top = 176
        Width = 137
        Height = 113
        ScrollBars = ssVertical
        TabOrder = 7
        WordWrap = False
      end
      object CheckBoxWrtDefaultSage: TCheckBox
        Left = 16
        Top = 80
        Width = 153
        Height = 17
        Caption = #12487#12501#12457#12523#12488#12391'sage'#12481#12455#12483#12463
        TabOrder = 3
      end
      object EditWrtReplyMark: TEdit
        Left = 128
        Top = 120
        Width = 57
        Height = 20
        TabOrder = 5
        Text = '>>'
      end
      object CheckBoxTstCloseOnSuccess: TCheckBox
        Left = 16
        Top = 32
        Width = 249
        Height = 17
        Caption = #26360#36796#12415#12364#25104#21151#12375#12383#27671#12364#12377#12427#26178#12395#12399#38281#12376#12427
        TabOrder = 1
      end
      object CheckBoxWrtShowThreadTitle: TCheckBox
        Left = 16
        Top = 56
        Width = 161
        Height = 17
        Caption = #12473#12524#12483#12489#12479#12452#12488#12523#12497#12493#12523#34920#31034
        TabOrder = 2
      end
      object CheckBoxWrtFmUseTaskBar: TCheckBox
        Left = 200
        Top = 80
        Width = 153
        Height = 17
        Caption = #12479#12473#12463#12496#12540#12434#20351#12358
        TabOrder = 4
      end
      object CheckBoxWrtUseDefaultName: TCheckBox
        Left = 56
        Top = 160
        Width = 145
        Height = 12
        Caption = '1'#34892#30446#12434#65411#65438#65420#65387#65433#65412#12398#21517#21069#12395
        TabOrder = 8
      end
      object CheckBoxDiscrepancyWarning: TCheckBox
        Left = 200
        Top = 104
        Width = 97
        Height = 17
        Caption = #35492#29190#35686#21578
        TabOrder = 9
      end
      object CheckBoxDisableStatusBar: TCheckBox
        Left = 200
        Top = 128
        Width = 161
        Height = 17
        Caption = #12473#12486#12540#12479#12473#12496#12540#38750#34920#31034
        TabOrder = 10
      end
    end
    object SheetUserInfo: TTabSheet
      Caption = 'User'
      ImageIndex = 7
      TabVisible = False
      object GroupBoxUser: TGroupBox
        Left = 32
        Top = 24
        Width = 321
        Height = 105
        Caption = #65298#12385#12419#12435#12397#12427
        TabOrder = 0
        object Label19: TLabel
          Left = 64
          Top = 29
          Width = 41
          Height = 12
          Alignment = taRightJustify
          Caption = 'User ID:'
        end
        object Label20: TLabel
          Left = 54
          Top = 53
          Width = 51
          Height = 12
          Alignment = taRightJustify
          Caption = 'Password:'
        end
        object EditUserID: TEdit
          Left = 112
          Top = 21
          Width = 169
          Height = 20
          TabOrder = 0
        end
        object EditPassword: TEdit
          Left = 112
          Top = 45
          Width = 169
          Height = 20
          PasswordChar = '*'
          TabOrder = 1
        end
        object CheckBoxAutoAuth: TCheckBox
          Left = 48
          Top = 80
          Width = 105
          Height = 17
          Caption = #12525#12464#12452#12531
          TabOrder = 2
          OnClick = CheckBoxAutoAuthClick
        end
        object ButtonManualConnect: TButton
          Left = 176
          Top = 72
          Width = 105
          Height = 25
          Caption = #25163#21205#12391#20877#25361#25126
          Enabled = False
          TabOrder = 3
          Visible = False
          OnClick = ButtonManualConnectClick
        end
        object ButtonResetSID: TButton
          Left = 184
          Top = 72
          Width = 99
          Height = 25
          Hint = #21462#24471#12375#12383'SID'#12434#30772#26820#12375#12414#12377
          Caption = #12525#12464#12450#12454#12488'('#23436#20840')'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = ButtonResetSIDClick
        end
      end
      object GroupBoxRem: TGroupBox
        Left = 32
        Top = 144
        Width = 321
        Height = 97
        Caption = 'Password'#12364#22793#12395#12394#12387#12383#26178#12395#25147#12379#12427#12424#12358#12395#12539#12539#12539
        TabOrder = 1
        object Label21: TLabel
          Left = 19
          Top = 24
          Width = 86
          Height = 12
          Alignment = taRightJustify
          Caption = #21512#35328#33865'(6'#23383#20197#19978')'
        end
        object EditPassphrase: TEdit
          Left = 112
          Top = 24
          Width = 169
          Height = 20
          PasswordChar = '*'
          TabOrder = 0
          OnChange = EditPassphraseChange
        end
        object ButtonRemenberPasswd: TButton
          Left = 216
          Top = 56
          Width = 97
          Height = 25
          Caption = #12371#12428#12391#24605#12356#20986#12377
          Enabled = False
          TabOrder = 1
          OnClick = ButtonRemenberPasswdClick
        end
        object PanelStat: TPanel
          Left = 8
          Top = 56
          Width = 81
          Height = 25
          BevelOuter = bvLowered
          TabOrder = 2
        end
        object CheckBoxSetPassphrase: TCheckBox
          Left = 104
          Top = 56
          Width = 105
          Height = 25
          Caption = #12371#12428#12391#35226#12360#12427
          Enabled = False
          TabOrder = 3
        end
      end
    end
    object SheetHint: TTabSheet
      Caption = #12402#12435#12392
      ImageIndex = 3
      TabVisible = False
      object LabelAutoEnableNesting: TLabel
        Left = 232
        Top = 12
        Width = 48
        Height = 12
        Caption = #33258#21205#22810#27573
      end
      object LabelHoverTime: TLabel
        Left = 320
        Top = 12
        Width = 46
        Height = 12
        Caption = #24453#12385#26178#38291
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 80
        Width = 361
        Height = 225
        Caption = #12401#12367#12426
        TabOrder = 7
        object Label3: TLabel
          Left = 8
          Top = 48
          Width = 92
          Height = 12
          Caption = #26368#22823#34920#31034#24133'(pixel)'
        end
        object Label4: TLabel
          Left = 8
          Top = 80
          Width = 92
          Height = 12
          Caption = #26368#22823#34920#31034#39640'(pixel)'
        end
        object Label5: TLabel
          Left = 208
          Top = 48
          Width = 144
          Height = 12
          Caption = #26368#22823#12496#12452#12488#25968'(GET'#12398#26178#12384#12369#65289
        end
        object Label8: TLabel
          Left = 208
          Top = 112
          Width = 107
          Height = 12
          Caption = #34920#31034#24453#12385#26178#38291'('#12511#12522#31186')'
        end
        object Label23: TLabel
          Left = 16
          Top = 176
          Width = 181
          Height = 12
          Caption = 'GET'#12363#12425#38500#22806#12377#12427#25313#24373#23376'(","'#21306#20999#12426')'
        end
        object CheckBoxUseHint4URL: TCheckBox
          Left = 8
          Top = 16
          Width = 281
          Height = 25
          Caption = 'HTML'#12509#12483#12503#12450#12483#12503#12434#20351#12358
          TabOrder = 0
        end
        object EditMaxHintWidth: TEdit
          Left = 112
          Top = 48
          Width = 81
          Height = 20
          TabOrder = 1
          Text = 'EditMaxHintWidth'
        end
        object EditMaxHintHeight: TEdit
          Left = 112
          Top = 80
          Width = 81
          Height = 20
          TabOrder = 2
          Text = 'EditMaxHintHeight'
        end
        object RadioGroupMethod: TRadioGroup
          Left = 16
          Top = 112
          Width = 193
          Height = 49
          Caption = #21462#24471#26041#27861
          TabOrder = 3
        end
        object RadioButtonHintUseGet: TRadioButton
          Left = 120
          Top = 128
          Width = 65
          Height = 17
          Caption = 'GET'
          TabOrder = 5
        end
        object RadioButtonHintUseHead: TRadioButton
          Left = 40
          Top = 128
          Width = 73
          Height = 17
          Caption = 'HEAD'
          TabOrder = 4
        end
        object EditHintMaxSize: TEdit
          Left = 232
          Top = 72
          Width = 65
          Height = 20
          TabOrder = 6
          Text = 'EditHintMaxSize'
        end
        object EditHintWaitTime: TEdit
          Left = 232
          Top = 136
          Width = 81
          Height = 20
          TabOrder = 7
          Text = 'EditHintWaitTime'
        end
        object EditHintCancelGetExt: TEdit
          Left = 16
          Top = 189
          Width = 337
          Height = 20
          TabOrder = 8
        end
      end
      object CheckBoxHintEnabled: TCheckBox
        Left = 8
        Top = 8
        Width = 217
        Height = 25
        Caption = #12498#12531#12488#34920#31034#65288#12473#12524#20869#65289#12434#26377#21177#12395#12377#12427
        TabOrder = 0
      end
      object CheckBoxHint4OtherThread: TCheckBox
        Left = 24
        Top = 30
        Width = 193
        Height = 25
        Caption = #20182#12473#12524#12398#12522#12531#12463#12418#12509#12483#12503#12450#12483#12503#12377#12427
        TabOrder = 1
      end
      object CheckBoxNestingPopUp: TCheckBox
        Left = 24
        Top = 56
        Width = 121
        Height = 17
        Caption = #22810#27573#12509#12483#12503#12450#12483#12503
        TabOrder = 2
      end
      object SpinEditHintHoverTime: TSpinEdit
        Left = 320
        Top = 32
        Width = 49
        Height = 21
        Enabled = False
        MaxValue = 1000
        MinValue = 0
        TabOrder = 4
        Value = 0
      end
      object CheckBoxAutoEnableNesting: TCheckBox
        Left = 232
        Top = 32
        Width = 81
        Height = 17
        Caption = #12473#12524#12499#12517#12540
        TabOrder = 3
        OnClick = CheckBoxAutoEnableNestingClick
      end
      object SpinEditHintHintHoverTime: TSpinEdit
        Left = 320
        Top = 56
        Width = 49
        Height = 21
        Enabled = False
        MaxValue = 1000
        MinValue = 0
        TabOrder = 6
        Value = 0
      end
      object CheckBoxHintAutoEnableNesting: TCheckBox
        Left = 232
        Top = 56
        Width = 81
        Height = 17
        Caption = #12498#12531#12488
        TabOrder = 5
        OnClick = CheckBoxHintAutoEnableNestingClick
      end
    end
    object SheetAbone: TTabSheet
      Caption = #12354#12412#12540#12435
      ImageIndex = 10
      TabVisible = False
      object ButtonAddNGWord: TButton
        Left = 107
        Top = 280
        Width = 75
        Height = 25
        Caption = #36861#21152'(&A)'
        TabOrder = 2
        OnClick = ButtonAddNGWordClick
      end
      object ButtonDeleteNGWord: TButton
        Left = 211
        Top = 280
        Width = 75
        Height = 25
        Caption = #21066#38500'(&D)'
        TabOrder = 3
        OnClick = ButtonDeleteNGWordClick
      end
      object EditNG: TEdit
        Left = 8
        Top = 256
        Width = 377
        Height = 20
        TabOrder = 1
      end
      object PageControlNGWord: TPageControl
        Left = 0
        Top = 0
        Width = 385
        Height = 249
        ActivePage = Sheet_NGName
        Align = alTop
        TabIndex = 0
        TabOrder = 0
        object Sheet_NGName: TTabSheet
          Caption = 'NGName'
          object ListBoxNGName: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Style = lbOwnerDrawFixed
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            PopupMenu = PopupNGWord
            TabOrder = 0
            OnClick = ListBoxNGWordClick
            OnDrawItem = ListBoxNGNameDrawItem
            OnMouseDown = ListBoxNGNameMouseDown
            OnMouseMove = ListBoxNGWordMouseMove
          end
        end
        object Sheet_NGAddr: TTabSheet
          Caption = 'NGAddr'
          ImageIndex = 2
          object ListBoxNGAddr: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Style = lbOwnerDrawFixed
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            PopupMenu = PopupNGWord
            TabOrder = 0
            OnClick = ListBoxNGWordClick
            OnDrawItem = ListBoxNGNameDrawItem
            OnMouseMove = ListBoxNGWordMouseMove
          end
        end
        object Sheet_NGWord: TTabSheet
          Caption = 'NGWord'
          ImageIndex = 1
          object ListBoxNGWord: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Style = lbOwnerDrawFixed
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            PopupMenu = PopupNGWord
            TabOrder = 0
            OnClick = ListBoxNGWordClick
            OnDrawItem = ListBoxNGNameDrawItem
            OnMouseMove = ListBoxNGWordMouseMove
          end
        end
        object Sheet_NGid: TTabSheet
          Caption = 'NGid'
          ImageIndex = 3
          object ListBoxNGid: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Style = lbOwnerDrawFixed
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            PopupMenu = PopupNGWord
            TabOrder = 0
            OnClick = ListBoxNGWordClick
            OnDrawItem = ListBoxNGNameDrawItem
            OnMouseMove = ListBoxNGWordMouseMove
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'NGEx'
          ImageIndex = 4
          object ListBoxNGEx: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Style = lbOwnerDrawFixed
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            PopupMenu = PopupNGWord
            TabOrder = 0
            OnClick = ListBoxNGWordClick
            OnDrawItem = ListBoxNGNameDrawItem
            OnMouseMove = ListBoxNGWordMouseMove
          end
        end
        object NGThread: TTabSheet
          Caption = 'NGThread'
          ImageIndex = 6
          object ListBoxNGThread: TListBox
            Left = 0
            Top = 0
            Width = 377
            Height = 222
            Align = alClient
            ItemHeight = 12
            MultiSelect = True
            TabOrder = 0
          end
        end
        object Sheet_Option: TTabSheet
          Caption = 'Option'
          ImageIndex = 5
          object Label60: TLabel
            Left = 24
            Top = 112
            Width = 154
            Height = 12
            Caption = 'NGName,Addr,Word'#12398#26399#38480'('#26085')'
          end
          object Label61: TLabel
            Left = 24
            Top = 176
            Width = 123
            Height = 12
            Caption = #12487#12501#12457#12523#12488#12398#12354#12412#12540#12435#27861
          end
          object Label62: TLabel
            Left = 24
            Top = 144
            Width = 83
            Height = 12
            Caption = 'NGID'#12398#26399#38480'('#26085')'
          end
          object CheckBoxLinkAbone: TCheckBox
            Left = 32
            Top = 73
            Width = 97
            Height = 17
            Caption = #36899#37782#12354#12412#65374#12435
            TabOrder = 0
          end
          object cbPermanentNG: TCheckBox
            Left = 8
            Top = 22
            Width = 281
            Height = 17
            Caption = 'NG'#12434#12354#12412#65374#12435'(NG'#12527#12540#12489#12434#21066#38500#12375#12390#12418#24489#27963#12375#12394#12356')'
            TabOrder = 1
            OnClick = cbPermanentNGClick
          end
          object cbPermanentMarking: TCheckBox
            Left = 32
            Top = 49
            Width = 305
            Height = 17
            Caption = #37325#35201#12461#12540#12527#12540#12489#12434#21547#12416#12524#12473#12434#33258#21205#30340#12395#12481#12455#12483#12463#12377#12427
            TabOrder = 2
          end
          object seNGItemLifeSpan: TSpinEdit
            Left = 192
            Top = 108
            Width = 65
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 3
            Value = 0
          end
          object seNGIDLifeSpan: TSpinEdit
            Left = 192
            Top = 140
            Width = 65
            Height = 21
            MaxValue = 0
            MinValue = 0
            TabOrder = 4
            Value = 0
          end
          object cmbAboneLevel: TComboBox
            Left = 168
            Top = 170
            Width = 113
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 5
            Items.Strings = (
              #12392#12358#12417#12356
              #12405#12388#12358
              #12413#12387#12407#12354#12387#12407
              #12373#12412#12426)
          end
        end
      end
      object CheckBoxViewTransparencyAbone: TCheckBox
        Left = 8
        Top = 285
        Width = 97
        Height = 17
        Caption = #36879#26126#12354#12412#12540#12435
        TabOrder = 4
      end
    end
    object SheetCommand: TTabSheet
      Caption = #12467#12510#12531#12489
      ImageIndex = 13
      TabVisible = False
      object Label35: TLabel
        Left = 264
        Top = 296
        Width = 112
        Height = 12
        Caption = '*'#27425#22238#36215#21205#26178#12363#12425#26377#21177
      end
      object ValueListCommand: TValueListEditor
        Left = 16
        Top = 0
        Width = 361
        Height = 185
        KeyOptions = [keyEdit, keyAdd, keyDelete]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        TitleCaptions.Strings = (
          #12467#12510#12531#12489#21517
          #23455#34892#12377#12427#12467#12510#12531#12489)
        OnKeyDown = ValueListCommandKeyDown
        OnSelectCell = ValueListCommandSelectCell
        ColWidths = (
          150
          205)
      end
      object ButtonCmdAdd: TButton
        Left = 24
        Top = 280
        Width = 81
        Height = 25
        Caption = #36861#21152'(&A)'
        TabOrder = 4
        OnClick = ButtonCmdAddClick
      end
      object ButtonCmdDel: TButton
        Left = 296
        Top = 208
        Width = 81
        Height = 25
        Caption = #21066#38500'(&D)'
        TabOrder = 1
        OnClick = ButtonCmdDelClick
      end
      object EditCmdName: TLabeledEdit
        Left = 16
        Top = 208
        Width = 249
        Height = 20
        EditLabel.Width = 51
        EditLabel.Height = 12
        EditLabel.Caption = #12467#12510#12531#12489#21517
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 2
      end
      object EditCmdExe: TLabeledEdit
        Left = 16
        Top = 248
        Width = 249
        Height = 20
        EditLabel.Width = 85
        EditLabel.Height = 12
        EditLabel.Caption = #23455#34892#12377#12427#12467#12510#12531#12489
        LabelPosition = lpAbove
        LabelSpacing = 3
        TabOrder = 3
      end
      object ButtonCmdIns: TButton
        Left = 120
        Top = 280
        Width = 75
        Height = 25
        Caption = #25407#20837'(&I)'
        TabOrder = 5
        OnClick = ButtonCmdInsClick
      end
      object ButtonCmdUp: TButton
        Left = 296
        Top = 248
        Width = 25
        Height = 25
        Caption = #8593
        TabOrder = 6
        TabStop = False
        OnClick = ButtonCmdUpClick
      end
      object ButtonCmdDown: TButton
        Left = 336
        Top = 248
        Width = 25
        Height = 25
        Caption = #8595
        TabOrder = 7
        TabStop = False
        OnClick = ButtonCmdDownClick
      end
    end
    object SheetMouse: TTabSheet
      Caption = #12510#12454#12473
      ImageIndex = 9
      TabVisible = False
      object CheckBoxMseUseWheelTabChange: TCheckBox
        Left = 16
        Top = 0
        Width = 257
        Height = 17
        Caption = #12479#12502#19978#12507#12452#12540#12523#22238#36578#12391#12479#12502#20999#12426#26367#12360
        TabOrder = 0
      end
      object GroupBox12: TGroupBox
        Left = 16
        Top = 40
        Width = 361
        Height = 265
        Caption = #12510#12454#12473#12472#12455#12473#12481#12515#12540
        TabOrder = 1
        object Label40: TLabel
          Left = 104
          Top = 56
          Width = 88
          Height = 12
          Caption = #23455#34892#12377#12427#12513#12491#12517#12540
        end
        object Label39: TLabel
          Left = 104
          Top = 16
          Width = 64
          Height = 12
          Caption = #12472#12455#12473#12481#12515#12540
        end
        object Label27: TLabel
          Left = 240
          Top = 100
          Width = 44
          Height = 12
          Caption = #12510#12540#12472#12531
        end
        object LabelMsePlace: TLabel
          Left = 72
          Top = 100
          Width = 24
          Height = 12
          Caption = #22580#25152
        end
        object ComboBoxMseMenus: TComboBox
          Left = 104
          Top = 69
          Width = 105
          Height = 20
          Style = csDropDownList
          DropDownCount = 12
          ItemHeight = 0
          TabOrder = 1
        end
        object ComboBoxMseGestures: TComboBox
          Left = 104
          Top = 29
          Width = 201
          Height = 20
          ItemHeight = 12
          TabOrder = 0
          OnChange = ComboBoxMseGesturesChange
          OnDropDown = ComboBoxMseGesturesDropDown
          OnKeyDown = ComboBoxMseGesturesKeyDown
          OnSelect = ComboBoxMseGesturesSelect
          Items.Strings = (
            'LeftClick'
            'WheelClick'
            'WheelUp'
            'WheelDown'
            'Side1'
            'Side1R'
            'Side2'
            'Side2R')
        end
        object ButtonMseLeft: TButton
          Left = 12
          Top = 48
          Width = 25
          Height = 25
          Caption = #8592
          TabOrder = 7
          TabStop = False
          OnClick = ButtonMseArrowClick
        end
        object ButtonMseClear: TButton
          Left = 40
          Top = 48
          Width = 25
          Height = 25
          Caption = '&C'
          TabOrder = 8
          TabStop = False
          OnClick = ButtonMseClearClick
        end
        object ButtonMseUp: TButton
          Left = 40
          Top = 20
          Width = 25
          Height = 25
          Caption = #8593
          TabOrder = 9
          TabStop = False
          OnClick = ButtonMseArrowClick
        end
        object ButtonMseDown: TButton
          Left = 40
          Top = 76
          Width = 25
          Height = 25
          Caption = #8595
          TabOrder = 10
          TabStop = False
          OnClick = ButtonMseArrowClick
        end
        object ButtonMseRight: TButton
          Left = 68
          Top = 48
          Width = 25
          Height = 25
          Caption = #8594
          TabOrder = 11
          TabStop = False
          OnClick = ButtonMseArrowClick
        end
        object EditMseGestureMargin: TEdit
          Left = 288
          Top = 96
          Width = 57
          Height = 20
          TabOrder = 3
        end
        object ValueListMouseGesture: TValueListEditor
          Left = 8
          Top = 120
          Width = 345
          Height = 105
          DefaultRowHeight = 16
          KeyOptions = [keyUnique]
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
          TabOrder = 4
          TitleCaptions.Strings = (
            #12472#12455#12473#12481#12515#12540
            #12513#12491#12517#12540)
          ColWidths = (
            122
            217)
        end
        object ComboBoxMseSubMenus: TComboBox
          Left = 216
          Top = 69
          Width = 137
          Height = 20
          Style = csDropDownList
          DropDownCount = 12
          ItemHeight = 0
          TabOrder = 2
          OnDropDown = ComboBoxMseSubMenusDropDown
        end
        object ButtonMseAdd: TButton
          Left = 168
          Top = 232
          Width = 75
          Height = 25
          Caption = #36861#21152'(&A)'
          TabOrder = 5
          OnClick = ButtonMseAddClick
        end
        object ButtonMseDelete: TButton
          Left = 256
          Top = 232
          Width = 75
          Height = 25
          Caption = #21066#38500'(&D)'
          TabOrder = 6
          OnClick = ButtonMseDeleteClick
        end
        object ComboBoxMsePlace: TComboBox
          Left = 104
          Top = 96
          Width = 105
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          ItemIndex = 0
          TabOrder = 12
          Text = #25351#23450#12394#12375
          OnSelect = ComboBoxMsePlaceSelect
          Items.Strings = (
            #25351#23450#12394#12375
            #26495#19968#35239
            #12473#12524#19968#35239
            #12473#12524#34920#31034#27396
            #26360#12365#36796#12415#31379
            #30011#20687#31379)
        end
      end
      object CheckBoxWheelScrollUnderCursor: TCheckBox
        Left = 16
        Top = 18
        Width = 313
        Height = 17
        Caption = #12459#12540#12477#12523#12398#19979#12395#12354#12427#12506#12452#12531#12434#12507#12452#12540#12523#12473#12463#12525#12540#12523
        TabOrder = 2
      end
    end
    object SheetDangerous: TTabSheet
      Caption = #12525#12464#25972#29702
      ImageIndex = 6
      TabVisible = False
      object CheckBoxDatDelOOTLog: TCheckBox
        Left = 72
        Top = 184
        Width = 249
        Height = 25
        Caption = #30058#21495#12418#21360#12418#20184#12356#12390#12394#12356#12525#12464#12434#36969#24403#12395#28040#12377
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 32
        Top = 24
        Width = 345
        Height = 145
        TabStop = False
        BorderStyle = bsNone
        Color = cl3DLight
        Ctl3D = False
        Lines.Strings = (
          #35686#21578#65306
          ''
          #19979#35352#12398#12481#12455#12483#12463#12508#12483#12463#12473#12434#12481#12455#12483#12463#12377#12427#12392#12289#26126#31034#30340#12354#12427#12356#12399
          #26263#40665#12398#20869#12395'('#65439#1076#65439')'#12391#12394#12356#26495#65288#12473#12524#19968#35239#65289#12434#21442#29031#12375#12383#38555#12395#12289
          #12381#12398#26495#12398#20013#12391#8220#21360#8221#12364#20184#12356#12390#12362#12425#12378#29694#24441#12473#12524#19968#35239#24773#22577
          '(subject.txt)'#12395#12418#36617#12387#12390#12356#12394#12356#12525#12464#12501#12449#12452#12523#12434#32207#12390#21066#38500#12375#12414#12377#12290
          ''
          'subject.txt'#12398#21462#24471#12395#22833#25943#12375#12383#22580#21512#12420#12289#12469#12540#12496#31227#36578#12364#12354#12387#12383
          #22580#21512#12395#20104#26399#12379#12378#12525#12464#12434#22833#12358#24656#12428#12364#12354#12426#12414#12377#12290
          ''
          #24847#21619#19981#26126#12384#65402#65438#65433#65383'!!! '#12394#22580#21512#12399#27770#12375#12390#12481#12455#12483#12463#12375#12394#12356#12391#19979#12373#12356#12290)
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
    end
    object SheetTab: TTabSheet
      Caption = #12479#12502
      ImageIndex = 8
      TabVisible = False
      object Label24: TLabel
        Left = 24
        Top = 40
        Width = 65
        Height = 12
        Caption = #12473#12524#12398#12479#12502#24133
      end
      object Label25: TLabel
        Left = 256
        Top = 40
        Width = 53
        Height = 12
        Caption = #12479#12502#12398#39640#12373
      end
      object Label26: TLabel
        Left = 160
        Top = 40
        Width = 72
        Height = 12
        Caption = '( 0 : '#25351#23450#12394#12375')'
      end
      object Label28: TLabel
        Left = 24
        Top = 112
        Width = 77
        Height = 12
        Caption = #12473#12524#35239#12398#12479#12502#24133
      end
      object Label29: TLabel
        Left = 256
        Top = 112
        Width = 53
        Height = 12
        Caption = #12479#12502#12398#39640#12373
      end
      object Label30: TLabel
        Left = 160
        Top = 112
        Width = 72
        Height = 12
        Caption = '( 0 : '#25351#23450#12394#12375')'
      end
      object Label18: TLabel
        Left = 24
        Top = 72
        Width = 174
        Height = 12
        Caption = #12473#12524#12479#12502#12398#26368#22823#25991#23383#25968' ('#24133'0'#12398#12392#12365')'
      end
      object CheckBoxStlTabMultiline: TCheckBox
        Left = 24
        Top = 8
        Width = 185
        Height = 17
        Caption = #12479#12502#12434#35079#25968#27573#34920#31034#12395#12377#12427
        TabOrder = 0
      end
      object EditStlTabHeight: TEdit
        Left = 328
        Top = 40
        Width = 41
        Height = 20
        TabOrder = 2
        Text = '20'
      end
      object EditStlTabWidth: TEdit
        Left = 112
        Top = 40
        Width = 41
        Height = 20
        TabOrder = 1
        Text = '0'
      end
      object EditStlListTabWidth: TEdit
        Left = 112
        Top = 112
        Width = 41
        Height = 20
        TabOrder = 4
        Text = '0'
      end
      object EditStlListTabHeight: TEdit
        Left = 328
        Top = 112
        Width = 41
        Height = 20
        TabOrder = 5
        Text = '20'
      end
      object RadioGroupTreeTabStyle: TRadioGroup
        Left = 24
        Top = 184
        Width = 97
        Height = 105
        Caption = #12484#12522#12540#12479#12502
        Items.Strings = (
          #12479#12502
          #12508#12479#12531
          #12501#12521#12483#12488
          #38750#34920#31034)
        TabOrder = 6
      end
      object RadioGroupListTabStyle: TRadioGroup
        Left = 144
        Top = 184
        Width = 97
        Height = 105
        Caption = #12473#12524#35239#12479#12502
        Items.Strings = (
          #12479#12502
          #12508#12479#12531
          #12501#12521#12483#12488
          #38750#34920#31034)
        TabOrder = 7
      end
      object RadioGroupThreadTabStyle: TRadioGroup
        Left = 264
        Top = 184
        Width = 97
        Height = 105
        Caption = #12473#12524#12479#12502
        Items.Strings = (
          #12479#12502
          #12508#12479#12531
          #12501#12521#12483#12488
          #38750#34920#31034)
        TabOrder = 8
      end
      object EditOptCharsInTab: TEdit
        Left = 208
        Top = 72
        Width = 97
        Height = 20
        TabOrder = 3
      end
    end
    object SheetStyle: TTabSheet
      Caption = #12473#12479#12452#12523
      ImageIndex = 16
      TabVisible = False
      object CheckBoxStlThreadToolBar: TCheckBox
        Left = 16
        Top = 120
        Width = 249
        Height = 17
        Caption = #12473#12524#12483#12489#12484#12540#12523#12496#12540#12434#34920#31034#12377#12427
        TabOrder = 1
      end
      object CheckBoxStlThreadTitle: TCheckBox
        Left = 16
        Top = 144
        Width = 281
        Height = 17
        Caption = #12473#12524#12479#12452#12488#12523#12434#12484#12540#12523#12496#12540#12398#38563#12395#34920#31034#12377#12427
        TabOrder = 2
      end
      object GroupBox10: TGroupBox
        Left = 16
        Top = 16
        Width = 337
        Height = 89
        Caption = #12450#12452#12467#12531#34920#31034
        TabOrder = 0
        object CheckBoxStlLinkBarIcons: TCheckBox
          Left = 16
          Top = 64
          Width = 97
          Height = 17
          Caption = #12522#12531#12463#12496#12540
          TabOrder = 4
        end
        object CheckBoxStlTreeIcons: TCheckBox
          Left = 16
          Top = 24
          Width = 89
          Height = 17
          Caption = #12484#12522#12540
          TabOrder = 0
        end
        object CheckBoxStlTabIcons: TCheckBox
          Left = 168
          Top = 24
          Width = 97
          Height = 17
          Caption = #12479#12502
          TabOrder = 1
        end
        object CheckBoxStlListMarkIcons: TCheckBox
          Left = 16
          Top = 44
          Width = 105
          Height = 17
          Caption = #12473#12524#35239'('#12510#12540#12463')'
          TabOrder = 2
        end
        object CheckBoxStlListTitleIcons: TCheckBox
          Left = 168
          Top = 44
          Width = 145
          Height = 17
          Caption = #12473#12524#35239'('#12479#12452#12488#12523#12452#12513#12540#12472')'
          TabOrder = 3
        end
        object CheckBoxStlMenuIcons: TCheckBox
          Left = 168
          Top = 64
          Width = 153
          Height = 17
          Caption = #12513#12491#12517#12540'  ('#8251#37325#12356#12391#12377')'
          TabOrder = 5
        end
      end
      object CheckBoxStlListExtraBackColor: TCheckBox
        Left = 16
        Top = 168
        Width = 177
        Height = 17
        Caption = #12473#12524#35239#12398#32972#26223#12434#33394#20998#12369#12377#12427
        TabOrder = 3
      end
      object MemoListOdd: TMemo
        Left = 208
        Top = 168
        Width = 113
        Height = 17
        TabStop = False
        Alignment = taCenter
        BevelEdges = [beLeft, beTop, beRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 4
      end
      object MemoListEven: TMemo
        Left = 208
        Top = 185
        Width = 113
        Height = 17
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 5
      end
      object Button1: TButton
        Tag = 101
        Left = 328
        Top = 168
        Width = 25
        Height = 17
        Caption = '...'
        TabOrder = 6
        OnClick = ButtonColorClick
      end
      object Button2: TButton
        Tag = 102
        Left = 328
        Top = 185
        Width = 25
        Height = 17
        Caption = '...'
        TabOrder = 7
        OnClick = ButtonColorClick
      end
      object CheckBoxStlShowTreeMarks: TCheckBox
        Left = 16
        Top = 216
        Width = 281
        Height = 17
        Caption = #12484#12522#12540#12395#65291#35352#21495#12392#28857#32218#12434#34920#31034#12377#12427
        TabOrder = 8
      end
      object CheckBoxStlSmallLogPanel: TCheckBox
        Left = 16
        Top = 240
        Width = 129
        Height = 17
        Caption = #12488#12524#12540#12473#12434#32302#23567#12377#12427
        TabOrder = 9
      end
      object RadioButtonLogPanelUnderBoard: TRadioButton
        Left = 168
        Top = 240
        Width = 97
        Height = 17
        Caption = #26495#19968#35239#12398#19979
        TabOrder = 10
      end
      object RadioButtonLogPanelUnderThread: TRadioButton
        Left = 272
        Top = 240
        Width = 105
        Height = 17
        Caption = #12473#12524#19968#35239#12398#19979
        TabOrder = 11
      end
    end
    object SheetColors: TTabSheet
      Caption = #33394#12539#12501#12457#12531#12488
      ImageIndex = 10
      TabVisible = False
      object Label43: TLabel
        Left = 24
        Top = 298
        Width = 336
        Height = 12
        Caption = #8251#12473#12524#12499#12517#12540#12398#12501#12457#12531#12488#12398#31278#39006#12399#12473#12461#12531#12289#22823#12365#12373#12399#31379#12513#12491#12517#12540#12391#35373#23450
      end
      object GroupBox7: TGroupBox
        Left = 16
        Top = 0
        Width = 169
        Height = 289
        Caption = #12503#12524#12499#12517#12540
        TabOrder = 0
        object MemoLog: TMemo
          Left = 8
          Top = 95
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 0
        end
        object MemoTextView: TMemo
          Left = 8
          Top = 123
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 1
        end
        object MemoList: TMemo
          Left = 8
          Top = 68
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 2
        end
        object MemoFavorite: TMemo
          Left = 8
          Top = 41
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 3
        end
        object MemoTree: TMemo
          Left = 8
          Top = 15
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 4
        end
        object MemoDefault: TMemo
          Left = 8
          Top = 261
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          BorderStyle = bsNone
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
        end
        object MemoThreadTitle: TMemo
          Left = 8
          Top = 151
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 6
        end
        object MemoWrite: TMemo
          Left = 8
          Top = 207
          Width = 153
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 7
        end
        object MemoHint: TMemo
          Left = 8
          Top = 234
          Width = 105
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 8
        end
        object MemoHintFix: TMemo
          Left = 120
          Top = 234
          Width = 41
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 9
        end
        object MemoWriteMemo: TMemo
          Left = 8
          Top = 179
          Width = 153
          Height = 23
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 10
        end
      end
      object GroupBox8: TGroupBox
        Left = 192
        Top = 0
        Width = 81
        Height = 289
        Caption = #12501#12457#12531#12488
        TabOrder = 1
        object ButtonTraceFont: TButton
          Tag = 3
          Left = 8
          Top = 73
          Width = 65
          Height = 25
          Caption = #12488#12524#12540#12473'...'
          TabOrder = 2
          OnClick = ButtonFontClick
        end
        object ButtonListFont: TButton
          Tag = 2
          Left = 8
          Top = 43
          Width = 65
          Height = 25
          Caption = #12473#12524#35239'...'
          TabOrder = 1
          OnClick = ButtonFontClick
        end
        object ButtonDefFont: TButton
          Tag = 4
          Left = 8
          Top = 227
          Width = 65
          Height = 25
          Caption = #12381#12398#20182'...'
          TabOrder = 5
          OnClick = ButtonFontClick
        end
        object ButtonTreeFont: TButton
          Tag = 1
          Left = 8
          Top = 13
          Width = 65
          Height = 25
          Caption = #12484#12522#12540'...'
          TabOrder = 0
          OnClick = ButtonFontClick
        end
        object ButtonAllFonts: TButton
          Tag = 10
          Left = 8
          Top = 257
          Width = 65
          Height = 25
          Caption = #12377#12409#12390'...'
          TabOrder = 6
          OnClick = ButtonFontClick
        end
        object ButtonThreadTitleFont: TButton
          Tag = 11
          Left = 8
          Top = 104
          Width = 65
          Height = 25
          Caption = #65405#65434#65408#65394#65412#65433'...'
          TabOrder = 3
          OnClick = ButtonFontClick
        end
        object ButtonWriteFont: TButton
          Tag = 5
          Left = 8
          Top = 134
          Width = 65
          Height = 25
          Caption = #26360#12365#36796#12415'...'
          TabOrder = 4
          OnClick = ButtonFontClick
        end
        object ButtonHintFont: TButton
          Tag = 200
          Left = 8
          Top = 196
          Width = 33
          Height = 25
          Caption = #12498#12531#12488
          TabOrder = 7
          OnClick = ButtonFontClick
        end
        object ButtonHintFontLink: TButton
          Tag = 201
          Left = 48
          Top = 196
          Width = 25
          Height = 25
          Caption = 'Lnk'
          TabOrder = 8
          OnClick = ButtonFontClick
        end
        object ButtonWriteMemoFont: TButton
          Tag = 300
          Left = 7
          Top = 165
          Width = 65
          Height = 25
          Caption = #12513#12514#27396
          TabOrder = 9
          OnClick = ButtonFontClick
        end
      end
      object GroupBox9: TGroupBox
        Left = 280
        Top = 0
        Width = 89
        Height = 289
        Caption = #32972#26223#33394
        TabOrder = 2
        object ButtonTextColor: TButton
          Tag = 5
          Left = 14
          Top = 134
          Width = 65
          Height = 25
          Caption = #12473#12524#12499#12517#12540'...'
          TabOrder = 4
          OnClick = ButtonColorClick
        end
        object ButtonListColor: TButton
          Tag = 3
          Left = 14
          Top = 73
          Width = 65
          Height = 25
          Caption = #12473#12524#35239'...'
          TabOrder = 2
          OnClick = ButtonColorClick
        end
        object ButtonFavoriteColor: TButton
          Tag = 2
          Left = 14
          Top = 43
          Width = 65
          Height = 25
          Caption = #12362#27671#12395#20837#12426'...'
          TabOrder = 1
          OnClick = ButtonColorClick
        end
        object ButtonLogColor: TButton
          Tag = 4
          Left = 14
          Top = 104
          Width = 65
          Height = 25
          Caption = #12488#12524#12540#12473'...'
          TabOrder = 3
          OnClick = ButtonColorClick
        end
        object ButtonTreeColor: TButton
          Tag = 1
          Left = 14
          Top = 13
          Width = 65
          Height = 25
          Caption = #26495#35239'...'
          TabOrder = 0
          OnClick = ButtonColorClick
        end
        object ButtonAllColors: TButton
          Tag = 10
          Left = 14
          Top = 257
          Width = 65
          Height = 25
          Caption = #12377#12409#12390'...'
          TabOrder = 6
          OnClick = ButtonColorClick
        end
        object ButtonThreadTitleColor: TButton
          Tag = 11
          Left = 14
          Top = 165
          Width = 65
          Height = 25
          Caption = #65405#65434#65408#65394#65412#65433'...'
          TabOrder = 5
          OnClick = ButtonColorClick
        end
        object ButtonHintColor: TButton
          Tag = 200
          Left = 14
          Top = 227
          Width = 35
          Height = 25
          Caption = #12498#12531#12488
          TabOrder = 7
          OnClick = ButtonColorClick
        end
        object ButtonHintColorFix: TButton
          Tag = 201
          Left = 56
          Top = 227
          Width = 23
          Height = 25
          Caption = #22266
          TabOrder = 8
          OnClick = ButtonColorClick
        end
        object ButtonWriteMemoColor: TButton
          Tag = 300
          Left = 14
          Top = 196
          Width = 65
          Height = 25
          Caption = #12513#12514#27396
          TabOrder = 9
          OnClick = ButtonColorClick
        end
      end
    end
    object SheetDoe: TTabSheet
      Caption = 'Doe'
      ImageIndex = 15
      TabVisible = False
      object Label46: TLabel
        Left = 40
        Top = 8
        Width = 150
        Height = 12
        Caption = #19978#19979#12473#12463#12525#12540#12523#26178#12395#27531#12377#34892#25968
      end
      object Label55: TLabel
        Left = 48
        Top = 240
        Width = 196
        Height = 12
        Caption = #12502#12521#12454#12470#12398#12501#12457#12531#12488#12469#12452#12474'('#26368#23567#8594#26368#22823')'
      end
      object EditViewVerticalCaretMargin: TEdit
        Left = 208
        Top = 8
        Width = 57
        Height = 20
        TabOrder = 0
      end
      object GroupBox13: TGroupBox
        Left = 40
        Top = 40
        Width = 217
        Height = 169
        Caption = #12473#12463#12525#12540#12523
        TabOrder = 1
        object LabelViewScrollSmoothness: TLabel
          Left = 32
          Top = 60
          Width = 69
          Height = 12
          Caption = #12473#12512#12540#12474#12493#12473
        end
        object LabelViewScrollFrameRate: TLabel
          Left = 32
          Top = 84
          Width = 74
          Height = 12
          Caption = #12501#12524#12540#12512#12524#12540#12488
        end
        object RadioButtonViewLineScroll: TRadioButton
          Left = 16
          Top = 16
          Width = 169
          Height = 17
          Caption = #27425#12398#34892#25968#12372#12392#12473#12463#12525#12540#12523
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButtonViewPageScroll: TRadioButton
          Left = 16
          Top = 112
          Width = 153
          Height = 17
          Caption = #65297#12506#12540#12472#12372#12392#12473#12463#12525#12540#12523
          TabOrder = 1
        end
        object EditViewScrollLines: TEdit
          Left = 120
          Top = 34
          Width = 57
          Height = 20
          TabOrder = 2
        end
        object SpinEditViewScrollSmoothness: TSpinEdit
          Left = 120
          Top = 56
          Width = 57
          Height = 21
          MaxValue = 32
          MinValue = 1
          TabOrder = 3
          Value = 3
        end
        object SpinEditViewScrollFrameRate: TSpinEdit
          Left = 120
          Top = 80
          Width = 57
          Height = 21
          MaxValue = 150
          MinValue = 0
          TabOrder = 4
          Value = 60
        end
        object CheckBoxViewEnableAutoScroll: TCheckBox
          Left = 16
          Top = 136
          Width = 193
          Height = 17
          Caption = #12458#12540#12488#12473#12463#12525#12540#12523#12434#26377#21177#12395#12377#12427
          TabOrder = 5
        end
      end
      object CheckBoxCaretVisible: TCheckBox
        Left = 48
        Top = 216
        Width = 137
        Height = 17
        Caption = #12461#12515#12524#12483#12488#12434#34920#31034#12377#12427
        TabOrder = 2
      end
      object EditZoomPoint0: TEdit
        Left = 56
        Top = 256
        Width = 33
        Height = 20
        TabOrder = 3
      end
      object EditZoomPoint1: TEdit
        Left = 96
        Top = 256
        Width = 33
        Height = 20
        TabOrder = 4
      end
      object EditZoomPoint2: TEdit
        Left = 136
        Top = 256
        Width = 33
        Height = 20
        TabOrder = 5
      end
      object EditZoomPoint3: TEdit
        Left = 176
        Top = 256
        Width = 33
        Height = 20
        TabOrder = 6
      end
      object EditZoomPoint4: TEdit
        Left = 216
        Top = 256
        Width = 33
        Height = 20
        TabOrder = 7
      end
    end
    object SheetColumn: TTabSheet
      Caption = #12473#12524#35239#38917#30446
      ImageIndex = 16
      TabVisible = False
      object Label50: TLabel
        Left = 49
        Top = 2
        Width = 78
        Height = 12
        Caption = #27531#12387#12390#12356#12427#38917#30446
      end
      object Label51: TLabel
        Left = 256
        Top = 2
        Width = 80
        Height = 12
        Caption = #36984#25246#12373#12428#12383#38917#30446
      end
      object LabelCheckNewThreadInHour: TLabel
        Left = 68
        Top = 228
        Width = 234
        Height = 12
        Caption = #26178#38291#20197#20869#12395#31435#12387#12383#12473#12524#12434#65281#12391#12481#12455#12483#12463'(0'#12391#28961#21177')'
      end
      object Label69: TLabel
        Left = 11
        Top = 255
        Width = 54
        Height = 12
        Caption = #26495#12398#12477#12540#12488
      end
      object Label70: TLabel
        Left = 168
        Top = 255
        Width = 150
        Height = 12
        Caption = #12525#12464#19968#35239#12289#12362#27671#12395#20837#12426#12398#12477#12540#12488
      end
      object ListBoxClmnRest: TListBox
        Left = 31
        Top = 21
        Width = 121
        Height = 153
        ItemHeight = 12
        Items.Strings = (
          '0 = '#65281
          '1 = '#30058#21495
          '2 = '#12479#12452#12488#12523
          '3 = '#12524#12473
          '4 = '#21462#24471
          '5 = '#26032#30528
          '6 = '#26368#32066#21462#24471
          '7 = '#26368#32066#26360#36796
          '8 = since'
          '9 = '#26495
          '10 = '#21218#12356
          '11 = '#22679#12524#12473)
        TabOrder = 0
        OnKeyDown = ListBoxClmnRestKeyDown
      end
      object ListBoxClmnSelected: TListBox
        Left = 237
        Top = 21
        Width = 121
        Height = 153
        ItemHeight = 12
        TabOrder = 1
        OnKeyDown = ListBoxClmnSelectedKeyDown
      end
      object ButtonClmnAdd: TButton
        Left = 170
        Top = 67
        Width = 49
        Height = 25
        Caption = '>>'
        TabOrder = 2
        TabStop = False
        OnClick = ButtonClmnAddClick
      end
      object ButtonClmnDel: TButton
        Left = 170
        Top = 99
        Width = 49
        Height = 25
        Caption = '<<'
        TabOrder = 3
        TabStop = False
        OnClick = ButtonClmnDelClick
      end
      object ButtonClmnUp: TButton
        Left = 265
        Top = 182
        Width = 25
        Height = 25
        Caption = #8593
        TabOrder = 4
        TabStop = False
        OnClick = ButtonClmnUpClick
      end
      object ButtonClmnDown: TButton
        Left = 309
        Top = 182
        Width = 25
        Height = 25
        Caption = #8595
        TabOrder = 5
        TabStop = False
        OnClick = ButtonClmnDownClick
      end
      object seCheckNewThreadInHour: TSpinEdit
        Left = 6
        Top = 223
        Width = 57
        Height = 21
        MaxValue = 96
        MinValue = 0
        TabOrder = 6
        Value = 0
      end
      object CheckBoxCheckThreadMadeAfterLstMdfy2: TCheckBox
        Left = 8
        Top = 196
        Width = 185
        Height = 17
        Caption = #26032#35215#12395#31435#12387#12383#12473#12524#12434#65281#12391#12481#12455#12483#12463
        TabOrder = 7
      end
      object ComboBoxDefSortColumn: TComboBox
        Left = 8
        Top = 272
        Width = 121
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 1
        TabOrder = 8
        Text = #30058#21495#38918
        Items.Strings = (
          #65281
          #30058#21495#38918
          #12479#12452#12488#12523
          #12524#12473
          #21462#24471
          #26032#30528
          #26368#32066#21462#24471
          #26368#32066#26360#36796
          'since'
          #26495
          #21218#12356
          #22679#12524#12473)
      end
      object ComboBoxDefFuncSortColumn: TComboBox
        Left = 165
        Top = 272
        Width = 145
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 1
        TabOrder = 9
        Text = #30058#21495#38918
        Items.Strings = (
          #65281
          #30058#21495#38918
          #12479#12452#12488#12523
          #12524#12473
          #21462#24471
          #26032#30528
          #26368#32066#21462#24471
          #26368#32066#26360#36796
          'since'
          #26495
          #21218#12356
          #22679#12524#12473)
      end
    end
    object SheetForView: TTabSheet
      Caption = #12381#12398#20182'2'
      ImageIndex = 17
      TabVisible = False
      object LabelLenofOutLineRes: TLabel
        Left = 16
        Top = 30
        Width = 171
        Height = 12
        Caption = #12450#12454#12488#12521#12452#12531#12391#34920#31034#12377#12427#12524#12473#12398#38263#12373
      end
      object Label58: TLabel
        Left = 129
        Top = 67
        Width = 36
        Height = 12
        Caption = #34920#31034#25968
      end
      object Label59: TLabel
        Left = 16
        Top = 262
        Width = 265
        Height = 12
        Caption = #12300#9675#9675#12434#12377#12409#12390#38283#12367#12301#12391#38283#12367#12473#12524#12483#12489#12398#19978#38480'(0'#12391#28961#21046#38480')'
      end
      object Label63: TLabel
        Left = 265
        Top = 100
        Width = 42
        Height = 12
        Caption = #12375#12365#12356#25968
      end
      object CheckBoxAllowTreeDup: TCheckBox
        Left = 16
        Top = 1
        Width = 249
        Height = 17
        Caption = #12484#12522#12540#12289#12450#12454#12488#12521#12452#12531#34920#31034#12391#37325#35079#12434#35377#21487#12377#12427
        TabOrder = 0
      end
      object SpinEditLenofOutLineRes: TSpinEdit
        Left = 202
        Top = 25
        Width = 65
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object ShowDayOfWeekCheckBox: TCheckBox
        Left = 16
        Top = 235
        Width = 145
        Height = 17
        Caption = #25237#31295#26085#12395#26332#26085#12434#20184#12369#12427
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBoxIDPopUp: TCheckBox
        Left = 15
        Top = 65
        Width = 98
        Height = 17
        Caption = 'ID'#12509#12483#12503#12450#12483#12503
        TabOrder = 3
      end
      object SpinEditIDPopUpMaxCount: TSpinEdit
        Left = 174
        Top = 62
        Width = 59
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 0
      end
      object SpinEditOpenNewResThreadLimit: TSpinEdit
        Left = 291
        Top = 257
        Width = 65
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 0
      end
      object CheckBoxColordNumber: TCheckBox
        Left = 16
        Top = 161
        Width = 153
        Height = 17
        Caption = #12522#12531#12463#12373#12428#12383#12524#12473#30058#12434#30528#33394
        TabOrder = 6
      end
      object MemoLinkedNumColor: TMemo
        Left = 140
        Top = 188
        Width = 93
        Height = 20
        TabStop = False
        Alignment = taCenter
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsUnderline]
        Lines.Strings = (
          '100')
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object ButtonColordNumber: TButton
        Left = 233
        Top = 188
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 8
        OnClick = ButtonColordNumberClick
      end
      object CheckBoxIDPopOnMOver: TCheckBox
        Left = 253
        Top = 64
        Width = 97
        Height = 17
        Caption = #12510#12454#12473#12458#12540#12496#12540
        TabOrder = 9
      end
      object CheckBoxIDLinkColor: TCheckBox
        Left = 41
        Top = 97
        Width = 89
        Height = 17
        Caption = #12522#12531#12463#12398#30528#33394
        TabOrder = 10
      end
      object MemoIDLinkColorMany: TMemo
        Left = 140
        Top = 96
        Width = 93
        Height = 21
        Alignment = taCenter
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        Lines.Strings = (
          #30330#35328#12364#22810#12356'ID')
        ParentFont = False
        ReadOnly = True
        TabOrder = 11
      end
      object MemoIDLinkColorNone: TMemo
        Left = 140
        Top = 123
        Width = 93
        Height = 21
        Alignment = taCenter
        Lines.Strings = (
          #30330#35328#12364'1'#12398'ID')
        ReadOnly = True
        TabOrder = 12
      end
      object ButtonIDLinkColorMany: TButton
        Left = 232
        Top = 96
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 13
        OnClick = ButtonIDLinkColorManyClick
      end
      object ButtonIDLinkColorNone: TButton
        Left = 233
        Top = 123
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 14
        OnClick = ButtonIDLinkColorNoneClick
      end
      object SpinEditIDLinkThreshold: TSpinEdit
        Left = 313
        Top = 95
        Width = 49
        Height = 21
        MaxValue = 50
        MinValue = 2
        TabOrder = 15
        Value = 5
      end
      object CheckBoxQuickMerge: TCheckBox
        Left = 169
        Top = 235
        Width = 192
        Height = 17
        Caption = #39640#36895'Merge('#8251#20877#36215#21205#24460#12395#26377#21177')'
        TabOrder = 16
      end
    end
    object SheetTabColor: TTabSheet
      Caption = #12479#12502#12398#33394
      ImageIndex = 19
      TabVisible = False
      object GroupBox16: TGroupBox
        Left = 0
        Top = 0
        Width = 385
        Height = 297
        Align = alCustom
        Caption = #12479#12502#12398#33394
        TabOrder = 0
        object Label56: TLabel
          Left = 288
          Top = 56
          Width = 66
          Height = 12
          Alignment = taCenter
          Caption = #12486#12461#12473#12488#12398#33394
          Layout = tlCenter
        end
        object ButtonProcessText: TButton
          Tag = 4
          Left = 272
          Top = 161
          Width = 97
          Height = 22
          Caption = #26356#26032#20013
          TabOrder = 0
          OnClick = ButtonTextColorClick
        end
        object ButtonNewText: TButton
          Tag = 2
          Left = 272
          Top = 101
          Width = 97
          Height = 22
          Caption = #26032#30528#12354#12427#26178
          TabOrder = 1
          OnClick = ButtonTextColorClick
        end
        object ButtonDefaultText: TButton
          Tag = 1
          Left = 272
          Top = 73
          Width = 97
          Height = 22
          Caption = #12487#12501#12457#12523#12488
          TabOrder = 2
          OnClick = ButtonTextColorClick
        end
        object GroupBox17: TGroupBox
          Left = 18
          Top = 16
          Width = 120
          Height = 201
          Align = alCustom
          Caption = #12450#12463#12486#12451#12502#12398#26178
          TabOrder = 3
          object MemoDefaultActive: TMemo
            Left = 8
            Top = 56
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 1
          end
          object MemoNewActive: TMemo
            Left = 8
            Top = 85
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 2
          end
          object MemoProcessActive: TMemo
            Left = 8
            Top = 143
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 3
          end
          object ButtonActiveBack: TButton
            Tag = 1
            Left = 24
            Top = 20
            Width = 75
            Height = 25
            Caption = #32972#26223#33394
            TabOrder = 0
            OnClick = ButtonBackColorClick
          end
          object MemoDisableWriteActive: TMemo
            Left = 8
            Top = 172
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 4
          end
          object MemoNew2Active: TMemo
            Left = 8
            Top = 113
            Width = 105
            Height = 22
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 5
          end
        end
        object GroupBox18: TGroupBox
          Left = 144
          Top = 16
          Width = 120
          Height = 201
          Caption = #12450#12463#12486#12451#12502#12376#12419#12394#12356#26178
          TabOrder = 4
          object MemoDefaultNoActive: TMemo
            Left = 8
            Top = 56
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 1
          end
          object MemoNewNoActive: TMemo
            Left = 8
            Top = 85
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 2
          end
          object MemoProcessNoActive: TMemo
            Left = 8
            Top = 144
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 3
          end
          object ButtonNoActiveBack: TButton
            Tag = 2
            Left = 24
            Top = 20
            Width = 75
            Height = 25
            Caption = #32972#26223#33394
            TabOrder = 0
            OnClick = ButtonBackColorClick
          end
          object MemoDisableWriteNoAcitve: TMemo
            Left = 8
            Top = 172
            Width = 105
            Height = 22
            TabStop = False
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 4
          end
          object MemoNew2NoActive: TMemo
            Left = 8
            Top = 115
            Width = 105
            Height = 22
            Alignment = taCenter
            ReadOnly = True
            TabOrder = 5
          end
        end
        object ButtonDisableWriteText: TButton
          Tag = 5
          Left = 272
          Top = 189
          Width = 97
          Height = 22
          Caption = #26360#12365#36796#12417#12394#12356
          TabOrder = 5
          OnClick = ButtonTextColorClick
        end
        object MemoWriteWait: TMemo
          Left = 152
          Top = 225
          Width = 105
          Height = 22
          TabStop = False
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 6
        end
        object ButtonWriteWait: TButton
          Tag = 3
          Left = 272
          Top = 225
          Width = 92
          Height = 22
          Caption = 'WriteWait'#20013
          TabOrder = 7
          OnClick = ButtonBackColorClick
        end
        object MemoAutoReload: TMemo
          Left = 152
          Top = 257
          Width = 105
          Height = 22
          Alignment = taCenter
          ReadOnly = True
          TabOrder = 8
        end
        object ButtonAutoReload: TButton
          Tag = 4
          Left = 272
          Top = 257
          Width = 92
          Height = 22
          Caption = #12458#12540#12488#12522#12525#12540#12489#20013
          TabOrder = 9
          OnClick = ButtonBackColorClick
        end
        object ButtonNew2Text: TButton
          Tag = 3
          Left = 272
          Top = 131
          Width = 97
          Height = 22
          Caption = #26356#26032#12354#12427#26178
          TabOrder = 10
          OnClick = ButtonTextColorClick
        end
      end
    end
    object SheetFavPatrol: TTabSheet
      Caption = #26356#26032#65409#65386#65391#65400
      ImageIndex = 20
      TabVisible = False
      object CheckBoxFavPatrolOpenNewResThread: TCheckBox
        Left = 8
        Top = 34
        Width = 257
        Height = 17
        Caption = #26356#26032#65409#65386#65391#65400#24460#12395#26356#26032#12398#12354#12427#12473#12524#12483#12489#12434#12377#12409#12390#38283#12367
        TabOrder = 0
      end
      object CheckBoxFavPatrolMessageBox: TCheckBox
        Left = 8
        Top = 98
        Width = 249
        Height = 17
        Caption = #26356#26032#65409#65386#65391#65400#23436#20102#12398#30906#35469#12480#12452#12450#12525#12464#12434#34920#31034#12377#12427
        TabOrder = 1
      end
      object CheckBoxFavPatrolOpenBack: TCheckBox
        Left = 8
        Top = 66
        Width = 201
        Height = 17
        Caption = #26356#26032#65409#65386#65391#65400#12434#12496#12483#12463#12464#12521#12454#12531#12489#12391#34892#12358
        TabOrder = 2
      end
      object CheckBoxFavPatrolCheckServerDown: TCheckBox
        Left = 8
        Top = 2
        Width = 321
        Height = 17
        Caption = #26356#26032#65409#65386#65391#65400#21069#12395#12469#12540#12496#12540#12364#33853#12385#12390#12394#12356#12363#12481#12455#12483#12463#12377#12427
        TabOrder = 3
      end
    end
  end
  object TreeView: TTreeView
    Left = 8
    Top = 8
    Width = 110
    Height = 345
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeViewChange
    Items.Data = {
      030000001D0000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      048AEE967B1D0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      00048B40945C1D0000000000000000000000FFFFFFFFFFFFFFFF000000000000
      0000048A4F8ACF}
  end
  object OpenDialog: TOpenDialog
    Filter = #12502#12521#12454#12470'(*.exe)|*.exe|'#12377#12409#12390'(*.*)|*.*'
    Left = 128
    Top = 336
  end
  object PopupNGWord: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupNGWordPopup
    Left = 44
    Top = 332
    object MenuDeleteNGWord: TMenuItem
      Caption = #21066#38500'(&D)'
      OnClick = ButtonDeleteNGWordClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuNGWordNormal: TMenuItem
      Caption = #36890#24120#12354#12412#12540#12435'(&A)'
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuNGWordTypeClick
    end
    object MenuNGWordTransparent: TMenuItem
      Tag = 2
      Caption = #36879#26126#12354#12412#12540#12435'(&T)'
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuNGWordTypeClick
    end
    object MenuNGWordLife: TMenuItem
      Caption = #26377#21177#26399#38291'(&L)'
      GroupIndex = 1
      object MenuNGWordLifeDef: TMenuItem
        Tag = -1
        Caption = #12487#12501#12457#12523#12488
        GroupIndex = 1
        RadioItem = True
        OnClick = NGWordLifeClick
      end
      object MenuNGWordLife3: TMenuItem
        Tag = 3
        Caption = '3'#26085
        GroupIndex = 1
        RadioItem = True
        OnClick = NGWordLifeClick
      end
      object MenuNGWordLife14: TMenuItem
        Tag = 14
        Caption = '2'#36913#38291
        GroupIndex = 1
        RadioItem = True
        OnClick = NGWordLifeClick
      end
      object MenuNGWordLife60: TMenuItem
        Tag = 60
        Caption = '2'#12534#26376
        GroupIndex = 1
        RadioItem = True
        OnClick = NGWordLifeClick
      end
      object MenuNGWordLifeForever: TMenuItem
        Caption = #28961#26399#38480
        GroupIndex = 1
        RadioItem = True
        OnClick = NGWordLifeClick
      end
    end
    object MenuNGWordMarking: TMenuItem
      Tag = 4
      Caption = #37325#35201#12524#12473'(&M)'
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuNGWordTypeClick
    end
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 156
    Top = 336
  end
  object FontDialog: TFontDialog
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 80
    Top = 336
  end
end
