object WriteForm: TWriteForm
  Left = 346
  Top = 188
  Width = 492
  Height = 339
  Caption = #12473#12524#12395#12459#12461#12467
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS UI Gothic'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnHide = FormHide
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  DesignSize = (
    484
    312)
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 484
    Height = 261
    ActivePage = TabSheetMain
    Align = alClient
    MultiLine = True
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheetMain: TTabSheet
      Caption = #26360#12365#36796#12415
      object Memo: TMemo
        Left = 0
        Top = 68
        Width = 476
        Height = 166
        Align = alClient
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
        OnChange = MemoChange
        OnKeyDown = MemoKeyDown
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 476
        Height = 40
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object SubjectPanel: TPanel
          Left = 0
          Top = 20
          Width = 476
          Height = 20
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          BorderWidth = 8
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS UI Gothic'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            476
            20)
          object TitleLabel: TLabel
            Left = 8
            Top = 4
            Width = 44
            Height = 12
            Caption = #65408#65394#65412#65433'(&T):'
            FocusControl = EditSubjectBox
          end
          object EditSubjectBox: TEdit
            Left = 56
            Top = 0
            Width = 346
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnChange = EditBoxChange
          end
        end
        object ThreadTitlePanel: TPanel
          Left = 0
          Top = 0
          Width = 476
          Height = 20
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          BorderWidth = 8
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS UI Gothic'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 40
        Width = 476
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          476
          28)
        object Label1: TLabel
          Left = 7
          Top = 8
          Width = 42
          Height = 12
          Caption = #21517#21069'(&N):'
          FocusControl = EditNameBox
        end
        object Label2: TLabel
          Left = 258
          Top = 8
          Width = 47
          Height = 12
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #12513#12540#12523'(&M):'
          FocusControl = EditMailBox
        end
        object CheckBoxSage: TCheckBox
          Left = 413
          Top = 6
          Width = 57
          Height = 17
          Anchors = [akTop, akRight]
          Caption = 'sage(&S)'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = CheckBoxSageClick
        end
        object EditNameBox: TComboBox
          Left = 56
          Top = 3
          Width = 193
          Height = 20
          AutoComplete = False
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 12
          TabOrder = 0
          OnCloseUp = EditNameBoxCloseUp
        end
        object EditMailBox: TComboBox
          Left = 315
          Top = 3
          Width = 85
          Height = 20
          AutoComplete = False
          Anchors = [akTop, akRight]
          ItemHeight = 12
          TabOrder = 1
          Text = 'sage'
        end
      end
    end
    object TabSheetPreview: TTabSheet
      Caption = #12503#12524#12499#12517#12540
      ImageIndex = 3
    end
    object TabSheetLocalRule: TTabSheet
      Caption = #12525#12540#12459#12523#12523#12540#12523
      ImageIndex = 1
    end
    object TabSheetSettingTxt: TTabSheet
      Caption = 'SETTING.TXT'
      ImageIndex = 4
      object SettingTxt: TMemo
        Left = 0
        Top = 0
        Width = 476
        Height = 234
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheetResult: TTabSheet
      Caption = #26360#12365#36796#12415#32080#26524
      ImageIndex = 2
      object Result: TMemo
        Left = 0
        Top = 0
        Width = 475
        Height = 234
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyDown = MemoKeyDown
        OnMouseMove = FormMouseMove
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 261
    Width = 484
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object CheckBoxTop: TCheckBox
      Left = 138
      Top = 4
      Width = 75
      Height = 26
      Caption = #26368#21069#38754'(&F)'
      Enabled = False
      TabOrder = 1
      OnClick = CheckBoxTopClick
    end
    object ToolBar1: TJLXPToolBar
      Left = 8
      Top = 4
      Width = 115
      Height = 22
      Align = alNone
      AutoSize = True
      Caption = 'ToolBarTool'
      EdgeBorders = []
      Flat = True
      TabOrder = 2
      Transparent = True
      Wrapable = False
      object ToolButtonRecordNameMail: TToolButton
        Left = 0
        Top = 0
        Hint = #12467#12486#12495#12531#35352#25014
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButtonRecordNameMailClick
      end
      object ToolButtonTrim: TToolButton
        Left = 23
        Top = 0
        Hint = #26411#23614#25972#24418
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButtonTrimClick
      end
      object ToolButtonWriteWait: TToolButton
        Left = 46
        Top = 0
        Caption = 'ToolButtonWriteWait'
        ImageIndex = 6
        OnClick = ToolButtonWriteWaitClick
      end
      object ToolButtonNameWarn: TToolButton
        Left = 69
        Top = 0
        Hint = #12467#12486#12495#12531#35686#21578#26377#21177
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButtonNameWarnClick
      end
      object ToolButtonBeLogin: TToolButton
        Left = 92
        Top = 0
        Hint = 'BeLogin'
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButtonBeLoginClick
      end
    end
    object Panel3: TPanel
      Left = 304
      Top = 0
      Width = 180
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonWrite: TButton
        Left = 14
        Top = 5
        Width = 74
        Height = 25
        Action = writeActWrite
        Caption = #26360#12365#36796#12415'(&W)'
        TabOrder = 0
      end
      object ButtonCancel: TButton
        Left = 96
        Top = 5
        Width = 74
        Height = 25
        Action = writeActCancel
        TabOrder = 1
      end
    end
  end
  object WStatusBar: TJLXPStatusBar
    Left = 0
    Top = 293
    Width = 484
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 110
      end
      item
        Style = psOwnerDraw
        Width = 110
      end
      item
        Width = 50
      end>
    SimplePanel = False
    OnDrawPanel = WStatusBarDrawPanel
  end
  object AAList: TListBox
    Left = 32
    Top = 100
    Width = 210
    Height = 120
    Anchors = []
    BevelInner = bvNone
    BevelKind = bkFlat
    BorderStyle = bsNone
    IntegralHeight = True
    ItemHeight = 12
    TabOrder = 3
    Visible = False
    OnExit = AAListExit
    OnKeyDown = AAListKeyDown
    OnMouseUp = AAListMouseUp
  end
  object ActionList: TActionList
    Left = 240
    Top = 280
    object writeActWrite: TAction
      Caption = #26360#12365#36796#12416'(&W)'
      OnExecute = ButtonWriteClick
    end
    object writeActCancel: TAction
      Caption = #12420#12417#12427'(&C)'
      OnExecute = ButtonCancelClick
    end
    object writeActFocusThread: TAction
      Caption = #12473#12524#12395#12501#12457#12540#12459#12473#12434#25147#12377'(&T)'
      OnExecute = writeActFocusThreadExecute
    end
    object writeActShowAAList: TAction
      Caption = 'AA'#12522#12473#12488#12398#34920#31034
      Hint = 'AA'#12522#12473#12488#12398#34920#31034
      ShortCut = 16416
      OnExecute = writeActShowAAListExecute
    end
  end
end
