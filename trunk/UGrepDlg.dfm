inherited GrepDlg: TGrepDlg
  Left = 272
  Top = 164
  Caption = #12525#12464#26908#32034
  ClientHeight = 312
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object GrepPanel: TPanel
    Left = 0
    Top = 56
    Width = 537
    Height = 254
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'GrepPanel'
    TabOrder = 1
    Visible = False
    object SettingPanel: TPanel
      Left = 344
      Top = 0
      Width = 193
      Height = 254
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object CheckBoxPopup: TCheckBox
        Left = 10
        Top = 196
        Width = 175
        Height = 12
        Caption = #36969#24403#12395#12509#12483#12503#12450#12483#12503'(&P)'
        TabOrder = 2
        OnClick = CheckBoxPopupClick
      end
      object PopupDetailPanel: TPanel
        Left = 16
        Top = 208
        Width = 169
        Height = 49
        BevelOuter = bvNone
        TabOrder = 3
        object Label1: TLabel
          Left = 30
          Top = 10
          Width = 129
          Height = 12
          Caption = #12524#12473#12414#12391#12398#36899#32154#12434#12414#12392#12417#12289
        end
        object Label2: TLabel
          Left = 100
          Top = 30
          Width = 34
          Height = 12
          Caption = #20491#12414#12391
        end
        object Label5: TLabel
          Left = 4
          Top = 30
          Width = 59
          Height = 12
          Caption = '1'#12473#12524#12395#12388#12365
        end
        object PopupMaxSeqEdit: TEdit
          Left = 2
          Top = 8
          Width = 25
          Height = 20
          MaxLength = 8
          TabOrder = 0
          OnKeyPress = NumOnlyKeyPress
        end
        object PopupEachThreMaxEdit: TEdit
          Left = 70
          Top = 23
          Width = 25
          Height = 20
          MaxLength = 8
          TabOrder = 1
          OnKeyPress = NumOnlyKeyPress
        end
      end
      object RadioGroupSearchRange: TJLXPRadioGroup
        Left = 8
        Top = 112
        Width = 177
        Height = 57
        Caption = #26908#32034#31684#22258
        ItemIndex = 0
        Items.Strings = (
          #12473#12524#12479#12452#12488#12523#65291#12524#12473#20869#23481'(&R)'
          #12473#12524#12479#12452#12488#12523#12398#12415'(&T)')
        TabOrder = 1
      end
      object RadioGroupTarget: TJLXPRadioGroup
        Left = 8
        Top = 4
        Width = 177
        Height = 101
        Caption = #31777#26131#36984#25246
        ItemIndex = 0
        Items.Strings = (
          '&1 '#12450#12463#12486#12451#12502#12394#26495
          '&2 '#12479#12502#12391#38283#12356#12390#12356#12427#26495
          '&3 '#12362#27671#12395#20837#12426#12398#26495
          '&4 '#20840#21462#24471#12525#12464)
        TabOrder = 0
        OnClick = RadioGroupTargetClick
      end
      object CheckBoxShowDirect: TCheckBox
        Left = 10
        Top = 176
        Width = 97
        Height = 17
        Caption = #12524#12473#34920#31034
        TabOrder = 4
        OnClick = CheckBoxShowDirectClick
      end
    end
    object TargetPanel: TPanel
      Left = 0
      Top = 0
      Width = 344
      Height = 254
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 63
        Height = 12
        Caption = #36861#21152#20505#35036'(&S)'
        FocusControl = TreeView
      end
      object Label4: TLabel
        Left = 184
        Top = 8
        Width = 62
        Height = 12
        Caption = #26908#32034#23550#35937'(&L)'
        FocusControl = ListBox
      end
      object TreeView: TTreeView
        Left = 8
        Top = 24
        Width = 169
        Height = 233
        Indent = 19
        MultiSelect = True
        MultiSelectStyle = [msControlSelect, msShiftSelect, msVisibleOnly]
        PopupMenu = TreePopupMenu
        ReadOnly = True
        RightClickSelect = True
        TabOrder = 3
        OnContextPopup = TreeViewContextPopup
        OnDblClick = TreeViewDblClick
        OnKeyDown = TreeViewKeyDown
      end
      object ListBox: TListBox
        Left = 184
        Top = 24
        Width = 153
        Height = 233
        ItemHeight = 12
        MultiSelect = True
        PopupMenu = ListPopupMenu
        TabOrder = 1
        OnDblClick = ListBoxDblClick
        OnExit = ListBoxExit
        OnKeyDown = ListBoxKeyDown
        OnMouseDown = ListBoxMouseDown
      end
      object ButtonAdd: TButton
        Left = 96
        Top = 4
        Width = 75
        Height = 17
        Caption = #36861#21152'(&A)'
        TabOrder = 2
        TabStop = False
        OnClick = TreePopupAddClick
      end
      object ButtonDelete: TButton
        Left = 256
        Top = 4
        Width = 75
        Height = 17
        Caption = #21066#38500'(&D)'
        TabOrder = 0
        TabStop = False
        OnClick = ListPopupDeleteClick
      end
    end
  end
  object ExtractPanel: TPanel
    Left = 0
    Top = 36
    Width = 537
    Height = 20
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 2
    object CheckBoxIncludeRef: TCheckBox
      Left = 11
      Top = 0
      Width = 177
      Height = 17
      Caption = #38306#36899#12524#12473#12418#21547#12417#12427'('#12484#12522#12540#21270')'
      TabOrder = 0
      OnClick = CheckBoxIncludeRefClick
    end
    object CheckBoxSaveHistroy: TCheckBox
      Left = 234
      Top = 1
      Width = 112
      Height = 17
      Caption = #26908#32034#23653#27508#12434#20445#23384
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ComboBoxOption: TComboBox
      Left = 400
      Top = 0
      Width = 128
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 2
      Text = #36890#24120#26908#32034
      Items.Strings = (
        #36890#24120#26908#32034
        #27491#35215#34920#29694
        #12510#12523#12481#12527#12540#12489'(AND)'
        #12510#12523#12481#12527#12540#12489'(OR)')
    end
  end
  object ListPopupMenu: TPopupMenu
    Left = 296
    Top = 248
    object ListPopupDelete: TMenuItem
      Caption = #21066#38500'(&D)'
      OnClick = ListPopupDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ListPopupClear: TMenuItem
      Caption = #19968#35239#12398#12463#12522#12450'(&C)'
      OnClick = ListPopupClearClick
    end
  end
  object TreePopupMenu: TPopupMenu
    Left = 136
    Top = 248
    object TreePopupAdd: TMenuItem
      Caption = #36861#21152'(&A)'
      OnClick = TreePopupAddClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object TreePopupExpand: TMenuItem
      Caption = #20840#12390#23637#38283'(&E)'
      OnClick = TreePopupExpandClick
    end
    object TreePopupCollapse: TMenuItem
      Caption = #20840#12390#32302#23567'(&C)'
      OnClick = TreePopupCollapseClick
    end
  end
end
