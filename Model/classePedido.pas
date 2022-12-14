unit classePedido;

interface

uses
  Classes, Dialogs, classePedidoProduto, classeCliente;

type
  TPedido = class(TObject)
  private
    // atributos da classe
    FNumeroPedido: integer;
    FDataEmissao: TDate;
    FCodigoCliente: integer;
    FCliente : TCliente;
    FValorTotal: double;
    FProdutos : TList;
    function Total : double;
  public
    // m?todos p?blicos da classe
    constructor Create;
    destructor Destroy; override;
    class function New : TPedido;

    // propriedades da classe
    property NumeroPedido: integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: integer read FCodigoCliente write FCodigoCliente;
    property Cliente : TCliente read FCliente write FCliente;
    property ValorTotal: double read Total;
    property Produtos : TList read FProdutos write FProdutos;
  end;

implementation

uses
  SysUtils;

{ TPedido }

constructor TPedido.Create;
begin
  // inicializa??o dos valores do objeto
  FNumeroPedido := 0;
  FDataEmissao  := 0;
  FCodigoCliente:= 0;
  FValorTotal   := 0;
  FProdutos := TList.Create;
  FCliente := TCliente.New;
end;

destructor TPedido.Destroy;
begin
  inherited;
end;

class function TPedido.New : TPedido;
begin
  Result := Self.Create;
end;

function TPedido.Total : double;
var
total : double;
i : integer;
objetoPedidoProduto : TPedidoProduto;
begin
  result := 0;
  try
    for I := 0 to Self.FProdutos.Count -1 do
    begin
      objetoPedidoProduto := Self.FProdutos.Items[i];
      result := result + objetoPedidoProduto.Quantidade * objetoPedidoProduto.ValorUnitario;
    end;
  except
    result := 0;
  end;
end;

end.
