object formInformePedido: TformInformePedido
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Pedido'
  ClientHeight = 144
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 83
    Top = 30
    Width = 113
    Height = 14
    Caption = 'N'#250'mero do pedido'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edt_numero_pedido: TEdit
    Left = 88
    Top = 48
    Width = 97
    Height = 24
    Alignment = taRightJustify
    TabOrder = 0
    OnKeyPress = edt_numero_pedidoKeyPress
  end
  object btnOk: TButton
    Left = 58
    Top = 91
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancelar: TButton
    Left = 139
    Top = 91
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
end
