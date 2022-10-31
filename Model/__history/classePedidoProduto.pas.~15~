unit classePedidoProduto;

interface

uses
  Classes, Dialogs, classeProduto;

type
  TPedidoProduto = class
  private
    // atributos da classe
    FId: integer;
    FNumeroPedido: integer;
    FCodigoProduto: integer;
    FProduto : TProduto;
    FQuantidade: double;
    FValorUnitario: double;
    FValorTotal: double;

    function calculaValorTotal : double;
  public
    // métodos públicos da classe
    constructor Create;
    destructor Destroy; override;
    class function New : TPedidoProduto;

    // propriedades da classe
    property Id: integer read FId write FId;
    property NumeroPedido: integer read FNumeroPedido write FNumeroPedido;
    property CodigoProduto: integer read FCodigoProduto write FCodigoProduto;
    property Produto : TProduto read FProduto write FProduto;
    property Quantidade: double read FQuantidade write FQuantidade;
    property ValorUnitario: double read FValorUnitario write FValorUnitario;
    property ValorTotal: double read calculaValorTotal;
  end;

implementation

uses
  SysUtils;

{ TPedidoProduto }

constructor TPedidoProduto.Create;
begin
  // inicialização dos valores do objeto
  FId := 0;
  FNumeroPedido := 0;
  FCodigoProduto:= 0;
  FProduto := TProduto.Create;
  FQuantidade   := 0;
  FValorUnitario:= 0;
  FValorTotal   := 0;
end;

destructor TPedidoProduto.Destroy;
begin
  inherited;
end;

class function TPedidoProduto.New : TPedidoProduto;
begin
  Result := Self.Create;
end;

function TPedidoProduto.calculaValorTotal : double;
begin
  Result := Self.FQuantidade * Self.FValorUnitario;
end;

end.
