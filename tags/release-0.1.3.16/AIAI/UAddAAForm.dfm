object AddAAForm: TAddAAForm
  Left = 265
  Top = 197
  Width = 529
  Height = 330
  Caption = 'AAlist'#12395#30331#37682
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 521
    Height = 262
    ActivePage = TabSheetMain
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheetMain: TTabSheet
      Caption = #32232#38598
      object MemoEdit: TMemo
        Left = 0
        Top = 20
        Width = 513
        Height = 215
        Align = alClient
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 1
        OnChange = MemoEditChange
      end
      object PanelTitle: TPanel
        Left = 0
        Top = 0
        Width = 513
        Height = 20
        Align = alTop
        BevelOuter = bvNone
        Caption = 'PanelTitle'
        TabOrder = 0
        object LabelKind: TLabel
          Left = 0
          Top = 0
          Width = 104
          Height = 20
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Layout = tlCenter
        end
        object MemoTitle: TMemo
          Left = 104
          Top = 0
          Width = 409
          Height = 20
          Align = alClient
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
          Font.Style = []
          MaxLength = 255
          ParentFont = False
          TabOrder = 0
          WantReturns = False
          OnChange = MemoTitleChange
        end
      end
    end
    object TabSheetPreview: TTabSheet
      Caption = #12503#12524#12499#12517#12540
      ImageIndex = 1
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 262
    Width = 521
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      521
      41)
    object LabelLines: TLabel
      Left = 8
      Top = 17
      Width = 54
      Height = 12
      Alignment = taCenter
      Caption = 'LabelLines'
      Layout = tlCenter
    end
    object Labelcaution: TLabel
      Left = 80
      Top = 16
      Width = 64
      Height = 12
      Caption = 'Labelcaution'
      Color = clBtnFace
      ParentColor = False
    end
    object ButtonOK: TButton
      Left = 337
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #30331#37682
      ModalResult = 1
      TabOrder = 0
    end
    object ButtonCancel: TButton
      Left = 433
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      TabOrder = 1
    end
  end
end
