object formPedidoProduto: TformPedidoProduto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Produto'
  ClientHeight = 101
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Roboto'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pan_produto: TPanel
    Left = 0
    Top = 0
    Width = 551
    Height = 101
    Align = alTop
    TabOrder = 0
    object Label5: TLabel
      Left = 9
      Top = 7
      Width = 102
      Height = 14
      Caption = 'C'#243'digo do produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 45
      Top = 53
      Width = 61
      Height = 14
      Alignment = taRightJustify
      Caption = 'Quantidade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 137
      Top = 53
      Width = 73
      Height = 14
      Alignment = taRightJustify
      Caption = 'Valor Unit'#225'rio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 256
      Top = 53
      Width = 58
      Height = 14
      Alignment = taRightJustify
      Caption = 'Valor Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sta_produto_nome: TStaticText
      Left = 113
      Top = 25
      Width = 426
      Height = 22
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 2
    end
    object btnConfirmar: TButton
      Left = 387
      Top = 66
      Width = 75
      Height = 25
      Caption = 'Confirmar'
      TabOrder = 4
      OnClick = btnConfirmarClick
    end
    object btnCancela: TButton
      Left = 464
      Top = 66
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 5
      OnClick = btnCancelaClick
    end
    object edt_quantidade: TEdit
      Left = 10
      Top = 69
      Width = 97
      Height = 23
      Alignment = taRightJustify
      TabOrder = 1
      OnExit = edt_quantidadeExit
      OnKeyPress = edt_quantidadeKeyPress
      OnKeyUp = edt_quantidadeKeyUp
    end
    object edt_codigo_produto: TEdit
      Left = 10
      Top = 24
      Width = 97
      Height = 23
      Alignment = taRightJustify
      TabOrder = 0
      OnExit = edt_codigo_produtoExit
      OnKeyPress = edt_codigo_produtoKeyPress
    end
    object edt_valor_unitario: TEdit
      Left = 113
      Top = 69
      Width = 97
      Height = 23
      Alignment = taRightJustify
      TabOrder = 3
      OnExit = edt_valor_unitarioExit
      OnKeyPress = edt_quantidadeKeyPress
    end
    object edt_valor_total: TEdit
      Left = 217
      Top = 69
      Width = 97
      Height = 23
      Alignment = taRightJustify
      ReadOnly = True
      TabOrder = 6
      OnExit = edt_quantidadeExit
      OnKeyPress = edt_quantidadeKeyPress
    end
  end
end
