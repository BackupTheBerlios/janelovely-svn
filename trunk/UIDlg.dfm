object InputDlg: TInputDlg
  Left = 202
  Top = 105
  BorderStyle = bsToolWindow
  Caption = #26908#32034
  ClientHeight = 36
  ClientWidth = 537
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object InputPanel: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button: TButton
      Left = 504
      Top = 8
      Width = 25
      Height = 17
      Caption = 'OK'
      TabOrder = 0
      OnClick = ButtonClick
    end
    object Edit: TComboBoxEx
      Left = 8
      Top = 8
      Width = 489
      Height = 21
      ItemsEx.CaseSensitive = False
      ItemsEx.SortType = stNone
      ItemsEx = <>
      StyleEx = []
      ItemHeight = 16
      TabOrder = 1
      OnKeyDown = EditKeyDown
      OnKeyPress = EditKeyPress
      DropDownCount = 8
    end
  end
end
