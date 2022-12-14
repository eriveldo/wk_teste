unit classeCliente;

interface

uses
  Classes, Dialogs;

type
  TCliente = class
  private
    // atributos da classe
    FCodigo: integer;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    // m?todos p?blicos da classe
    constructor Create;
    destructor Destroy; override;
    class function New : TCliente;

    // propriedades da classe
    property Codigo: integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

implementation

uses
  SysUtils;

{ TCliente }

constructor TCliente.Create;
begin
  // inicializa??o dos valores do objeto
  FCodigo := 0;
  FNome   := '';
  FCidade := '';
  FUF     := '';
end;

destructor TCliente.Destroy;
begin
  inherited;
end;

class function TCliente.New : TCliente;
begin
  Result := Self.Create;
end;

end.
