object ChottoForm: TChottoForm
  Left = 501
  Top = 129
  Width = 476
  Height = 293
  Caption = #12385#12423#12387#12392#35211#12427#12499#12517#12540#12527#12540
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    468
    266)
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 468
    Height = 266
    ActivePage = TabSheet
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    object TabSheet: TTabSheet
      Caption = 'TabSheet'
    end
  end
  object ButtonOpen: TButton
    Left = 418
    Top = 1
    Width = 50
    Height = 18
    Anchors = [akTop, akRight]
    Caption = #38283#12367
    TabOrder = 0
    OnClick = ButtonOpenClick
  end
end
