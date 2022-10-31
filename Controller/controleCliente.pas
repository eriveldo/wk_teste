unit controleCliente;

interface

uses
	Classes,
	controleBase,
	classeCliente,
	Controls,
	ExtCtrls,
	Dialogs,
	SysUtils,
	FireDAC.Stan.Error,
	FireDAC.UI.Intf,
	FireDAC.Phys.Intf,
	FireDAC.Stan.Def,
	FireDAC.Stan.Pool,
	FireDAC.Stan.Async,
	FireDAC.Phys,
	FireDAC.Phys.FB,
	FireDAC.Phys.FBDef,
	FireDAC.VCLUI.Wait,
	FireDAC.Comp.Client,
	FireDAC.Stan.Intf,
	FireDAC.Stan.Option,
	Data.DB,
  StrUtils,
	System.Variants;
  

type
  TControleCliente = class(TBase)
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    // Procedimento para cadastrar os dados no banco
    function Insert(const objetoCliente: TCliente) : TCliente;
    // Procedimento para atualizar os dados no banco
    function Update(const objetoCliente: TCliente) : Boolean;
    // Procedimento para excluir os dados no banco
    function Delete(const objetoCliente: TCliente) : Boolean;
    // Procedimento para Carregar cliente pelo codigo
    function Select(const objetoCliente: TCliente) : TCliente;
    // Procedimento para Localizar por Nome
    function FindByNome(const objetoCliente: TCliente) : TCliente;
    // Procedimento para Localizar por Id
    function FindById(const objetoCliente: TCliente) : TCliente;
    // Procedimento para Verificar se existe cliente cadastrado com mesmo nome
    function FoundNome(const objetoCliente: TCliente) : Boolean;
    // Procedimento para validação em insert
    function ValidaInsert (const objetoCliente : TCliente) : boolean;
    // Procedimento para validação em update
    function ValidaUpdate (const objetoCliente : TCliente) : boolean;
    // Procedimento para validação em select
    function ValidaSelect (const objetoCliente : TCliente) : boolean;
    // Procedimento para validação em delete
    function ValidaDelete (const objetoCliente : TCliente) : boolean;

end;

implementation

{ TControleCliente }

constructor TControleCliente.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TControleCliente.Destroy;
begin
  inherited;
end;

function TControleCliente.Insert(const objetoCliente: TCliente) : TCliente;
var
	Qry:TFDQuery;
begin
  result := TCliente.New;

  if ValidaInsert(objetoCliente) = false then Abort;

  try
      ConexaoDB.StartTransaction;
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:= ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add('INSERT INTO cliente ('+
                  ' nome, '+
                  ' cidade, '+
                  ' uf '+
                  ') VALUES ('+
                  ' :nome, '+
                  ' :cidade, '+
                  ' :uf '+
                  ')' );
      Qry.ParamByName('nome').AsString  :=objetoCliente.Nome;
      Qry.ParamByName('cidade').AsString  :=objetoCliente.Cidade;
      Qry.ParamByName('uf').AsString  :=objetoCliente.UF;
      Try
          Qry.ExecSQL;
          ConexaoDB.Commit;
          //Recupera o ID Gerado no Insert
          Qry.SQL.Clear;
          Qry.SQL.Add('SELECT LAST_INSERT_ID() AS ID');
          Qry.Open;
          objetoCliente.Codigo := Qry.FieldByName('id').AsInteger;
          result := objetoCliente;
      Except
          ConexaoDB.Rollback;
          Result:=TCliente.New;
      End;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;


function TControleCliente.Update(const objetoCliente: TCliente) : Boolean;
var 
	Qry:TFDQuery;
begin
  result := false;

  if ValidaUpdate(objetoCliente) = false then Abort;

  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE cliente SET'+
                ' nome = :nome, '+
                ' cidade = :cidade, '+
                ' uf = :uf '+
                ' WHERE Codigo=:id ');
        ParamByName('id').AsInteger :=objetoCliente.Codigo;
        ParamByName('nome').AsString:=objetoCliente.Nome;
        ParamByName('cidade').AsString:=objetoCliente.Cidade;
        ParamByName('uf').AsString:=objetoCliente.UF;

        Try
          ConexaoDB.StartTransaction;
          ExecSQL;
          ConexaoDB.Commit;
        Except
          ConexaoDB.Rollback;
          Result:=false;
        End;
	  end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleCliente.Delete(const objetoCliente: TCliente) : Boolean;
var 
	Qry:TFDQuery;
begin
  result := false;

  if ValidaDelete(objetoCliente) = false then Abort;

  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin

		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM cliente '+
				    'WHERE Codigo=:id ');
		ParamByName('id').AsInteger :=objetoCliente.Codigo;

		Try
			ConexaoDB.StartTransaction;
			ExecSQL;
			ConexaoDB.Commit;
			Result:=true;
		Except
			ConexaoDB.Rollback;
			Result:=false;
		End;
	end;
  finally
	if Assigned(Qry) then
	   FreeAndNil(Qry);
  end;
end;

function TControleCliente.FindById(const objetoCliente: TCliente) : TCliente;
var
  Qry:TFDQuery;
begin
  result := TCliente.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'nome, '+
                  'cidade, '+
                  'uf '+
                  'FROM cliente '+
                  'WHERE Codigo=:id');
          ParamByName('id').AsInteger:=objetoCliente.Codigo;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Nome := Qry.FieldByName('nome').AsString;
                  result.Cidade := Qry.FieldByName('cidade').AsString;
                  result.UF := Qry.FieldByName('uf').AsString;
              end;
          Except
              Result:=TCliente.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleCliente.FindByNome(const objetoCliente: TCliente) : TCliente;
var
  Qry:TFDQuery;
begin
  result := TCliente.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'nome, '+
                  'cpf '+
                  'FROM cliente '+
                  'WHERE nome=:nome');
          ParamByName('nome').AsString := objetoCliente.nome;
          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Nome := Qry.FieldByName('nome').AsString;
                  result.Cidade := Qry.FieldByName('cidade').AsString;
                  result.UF := Qry.FieldByName('uf').AsString;
              end;
          Except
              Result:=TCliente.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleCliente.FoundNome(const objetoCliente: TCliente) : Boolean;
var
	Qry:TFDQuery;
begin
  result := false;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT codigo '+
                  'FROM cliente '+
                  'WHERE nome = :nome');
          ParamByName('nome').asString := objetoCliente.nome;

          Try
              Open;
              if (RecordCount > 0) then
                result := true
              else
                result := false;

          Except
              Result:=false;
          End;
      end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleCliente.Select(const objetoCliente: TCliente): TCliente;
var
  Qry:TFDQuery;
begin
  result := TCliente.new;
  if ValidaSelect(objetoCliente) = false then Abort;
  
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'nome, '+
                  'cidade, '+
                  'uf '+
                  'FROM cliente '+
                  'WHERE Codigo=:id');
          ParamByName('id').AsInteger:=objetoCliente.Codigo;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Nome := Qry.FieldByName('nome').AsString;
                  result.Cidade := Qry.FieldByName('cidade').AsString;
                  result.UF := Qry.FieldByName('uf').AsString;
              end;
          Except
              Result:=TCliente.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleCliente.ValidaDelete(const objetoCliente: TCliente): boolean;
begin
  result := false;
  if objetoCliente.Codigo <= 0 then
    raise Exception.Create('Código inválido.');

  result := true;
end;

function TControleCliente.ValidaInsert(const objetoCliente: TCliente): boolean;
begin
  result := false;
  if objetoCliente.Nome= '' then
    raise Exception.Create('Nome do cliente não pode ficar em branco.');

  if (FoundNome(objetoCliente)) then
    raise Exception.Create('Já existe um cliente cadastrado com este nome!');

  result := true;
end;

function TControleCliente.ValidaSelect(const objetoCliente: TCliente): boolean;
begin
  result := false;
  if objetoCliente.Codigo <= 0 then
    raise Exception.Create('Código do cliente inválido.');

  result := true;
end;

function TControleCliente.ValidaUpdate(const objetoCliente: TCliente): boolean;
begin
  result := false;
  if objetoCliente.Codigo <= 0 then
    raise Exception.Create('Código inválido.');

  if objetoCliente.Nome= '' then
    raise Exception.Create('Nome do cliente não pode ficar em branco.');

  result := true;
end;

end.
