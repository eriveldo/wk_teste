unit classeProduto;

interface

uses
  Classes, Dialogs;

type
  TProduto = class
  private
    // atributos da classe
    FCodigo: integer;
    FDescricao: string;
    FValorUnitario: double;
  public
    // métodos públicos da classe
    constructor Create;
    destructor Destroy; override;
    class function New : TProduto;

    // propriedades da classe
    property Codigo: integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property ValorUnitario: double read FValorUnitario write FValorUnitario;
  end;

implementation

uses
  SysUtils;

{ TProduto }

constructor TProduto.Create;
begin
  // inicialização dos valores do objeto
  FCodigo    := 0;
  FDescricao := '';
  FValorUnitario := 0;
end;

destructor TProduto.Destroy;
begin
  inherited;
end;

class function TProduto.New : TProduto;
begin
  Result := Self.Create;
end;

end.
