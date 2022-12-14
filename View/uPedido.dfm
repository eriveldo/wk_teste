object formPedido: TformPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Pedido'
  ClientHeight = 473
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object pan_pedido: TPanel
    Left = 0
    Top = 0
    Width = 668
    Height = 457
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 23
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
    object Label2: TLabel
      Left = 16
      Top = 79
      Width = 100
      Height = 14
      Caption = 'Data da emiss'#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 119
      Top = 79
      Width = 107
      Height = 14
      Caption = 'C'#243'digo do cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnAbrirPedido: TButton
      Left = 121
      Top = 39
      Width = 88
      Height = 25
      Caption = 'Abrir pedido'
      TabOrder = 3
      OnClick = btnAbrirPedidoClick
    end
    object msk_data_emissao: TMaskEdit
      Left = 16
      Top = 96
      Width = 95
      Height = 24
      Alignment = taRightJustify
      EditMask = '!99/99/9999;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      OnExit = msk_data_emissaoExit
    end
    object sta_cliente_nome: TStaticText
      Left = 223
      Top = 97
      Width = 426
      Height = 22
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 5
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 136
      Width = 633
      Height = 281
      Caption = 'Produtos'
      TabOrder = 6
      object gri_produtos: TStringGrid
        Left = 2
        Top = 50
        Width = 629
        Height = 200
        Align = alClient
        ColCount = 6
        DefaultColWidth = 60
        RowCount = 2
        TabOrder = 0
        OnKeyPress = gri_produtosKeyPress
        OnKeyUp = gri_produtosKeyUp
        ColWidths = (
          60
          87
          237
          60
          75
          82)
      end
      object Panel2: TPanel
        Left = 2
        Top = 18
        Width = 629
        Height = 32
        Align = alTop
        TabOrder = 1
        object btnAdiciona: TButton
          Left = 3
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Inserir'
          TabOrder = 0
          OnClick = btnAdicionaClick
        end
        object btnAtualizar: TButton
          Left = 80
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Atualizar'
          TabOrder = 1
          OnClick = btnAtualizarClick
        end
        object btnExcluir: TButton
          Left = 157
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnExcluirClick
        end
      end
      object Panel3: TPanel
        Left = 2
        Top = 250
        Width = 629
        Height = 29
        Align = alBottom
        TabOrder = 2
        object Label4: TLabel
          Left = 430
          Top = 7
          Width = 65
          Height = 14
          Alignment = taRightJustify
          Caption = 'Total Geral'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edt_total_geral: TEdit
          Left = 501
          Top = 2
          Width = 114
          Height = 24
          Alignment = taRightJustify
          TabOrder = 0
          Text = 'R$ 0,00'
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 423
      Width = 668
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 7
      object Panel4: TPanel
        Left = 16
        Top = 3
        Width = 633
        Height = 31
        TabOrder = 0
        object btnSalvar: TButton
          Left = 5
          Top = 2
          Width = 112
          Height = 25
          Caption = 'Gravar Pedido'
          TabOrder = 0
          OnClick = btnSalvarClick
        end
        object btnLimpar: TButton
          Left = 123
          Top = 2
          Width = 75
          Height = 25
          Cancel = True
          Caption = 'Limpar'
          TabOrder = 1
          OnClick = btnLimparClick
        end
      end
    end
    object edt_codigo_cliente: TEdit
      Left = 119
      Top = 96
      Width = 97
      Height = 24
      Alignment = taRightJustify
      TabOrder = 2
      OnExit = edt_codigo_clienteExit
      OnKeyPress = edt_codigo_clienteKeyPress
      OnKeyUp = edt_codigo_clienteKeyUp
    end
    object edt_numero_pedido: TEdit
      Left = 16
      Top = 40
      Width = 97
      Height = 24
      Alignment = taRightJustify
      ReadOnly = True
      TabOrder = 0
      OnExit = edt_numero_pedidoExit
      OnKeyPress = edt_numero_pedidoKeyPress
    end
    object btnCancelarPedido: TButton
      Left = 212
      Top = 39
      Width = 109
      Height = 25
      Caption = 'Cancelar pedido'
      TabOrder = 4
      OnClick = btnCancelarPedidoClick
    end
  end
end
