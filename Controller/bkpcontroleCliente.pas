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
    function ValidarCPF(numCPF: string): boolean;
    // Procedimento para cadastrar os dados no banco
    function Insert(const objetoCliente: TCliente) : TCliente;
    // Procedimento para atualizar os dados no banco
    function Update(const objetoCliente: TCliente) : Boolean;
    // Procedimento para excluir os dados no banco
    function Delete(const objetoCliente: TCliente) : Boolean;
    // Procedimento para Localizar por Nome
    function FindByNome(const objetoCliente: TCliente) : TCliente;
    // Procedimento para Localizar por Id
    function FindById(const objetoCliente: TCliente) : TCliente;
    // Procedimento para Verificar se existe cliente cadastrado com mesmo nome
    function FoundNome(const objetoCliente: TCliente) : Boolean;
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
  if objetoCliente.Nome= '' then
    raise Exception.Create('Nome do cliente não pode ficar em branco.');

  if (FoundNome(objetoCliente)) then
    raise Exception.Create('Já existe um cliente cadastrado com este nome!');

  try
      ConexaoDB.StartTransaction;
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:= ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add('INSERT INTO cliente ('+
                  ' nome, '+
                  ' cpf '+
                  ') VALUES ('+
                  ' :nome, '+
                  ' :cpf '+
                  ')' );
      Qry.ParamByName('nome').AsString  :=objetoCliente.Nome;
      Try
          Qry.ExecSQL;
          ConexaoDB.Commit;
          //Recupera o ID Gerado no Insert
          Qry.SQL.Clear;
          Qry.SQL.Add('SELECT LAST_INSERT_ID() AS ID');
          Qry.Open;
          //objetoCliente.Id := Qry.FieldByName('id').AsInteger;
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
{  if objetoCliente.Id <= 0 then
    raise Exception.Create('Id inválido.');}

  if objetoCliente.Nome= '' then
    raise Exception.Create('Preencha o nome do cliente.');

  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE cliente SET'+
                ' nome = :nome, '+
                ' cpf = :cpf '+
                ' WHERE ID=:id ');
{        ParamByName('id').AsInteger :=objetoCliente.Id;
        ParamByName('nome').AsString:=objetoCliente.Nome;
        ParamByName('cpf').AsString:=objetoCliente.CPF;
}

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
{
  if objetoCliente.Id <= 0 then
    raise Exception.Create('Id inválido.');
}
  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin

		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM cliente '+
				    'WHERE ID=:id ');
{
		ParamByName('id').AsInteger :=objetoCliente.Id;
}
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
                  'id, '+
                  'nome, '+
                  'cpf '+
                  'FROM cliente '+
                  'WHERE id=:id');
{
          ParamByName('id').AsInteger:=objetoCliente.Id;
}
          Try
              Open;
              if (RecordCount > 0) then
              begin
{
                  result.Id := Qry.FieldByName('id').AsInteger;
                  result.Nome := Qry.FieldByName('nome').AsString;
                  result.CPF := Qry.FieldByName('cpf').AsString;
}
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
                  'id, '+
                  'nome, '+
                  'cpf '+
                  'FROM cliente '+
                  'WHERE nome=:nome');
          ParamByName('nome').AsString:=objetoCliente.nome;
          Try
              Open;
              if (RecordCount > 0) then
              begin
{
                  result.Id := Qry.FieldByName('id').AsInteger;
                  result.Nome := Qry.FieldByName('nome').AsString;
                  result.CPF := Qry.FieldByName('cpf').AsString;
}
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
  //carregarDados
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT id '+
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

function TControleCliente.ValidarCPF(numCPF: string): boolean;
var
	cpf: string;
	x, total, dg1, dg2: Integer;
	ret: boolean;
begin
  ret := True;
  cpf := StringReplace(numCPF, '-', '', [rfReplaceAll]);
  cpf := StringReplace(cpf, '.', '', [rfReplaceAll]);
  if Trim(cpf) = '' then
    ret := False;
  for x := 1 to Length(numCPF) do
	  if not (numCPF[x] in ['0'..'9', '-', '.', ' ']) then
		  ret := False;
  if ret then
	begin
	  ret := True;
	  cpf := '';
	  for x := 1 to Length(numCPF) do
		  if numCPF[x] in ['0'..'9'] then
			  cpf := cpf + numCPF[x];
	  if Length(cpf) <> 11 then
		  ret := False;
	  if ret then
		begin
		  //1° dígito
		  total := 0;
		  for x := 1 to 9 do
			total := total + (StrToInt(cpf[x]) * x);
		  dg1 := total mod 11;
		  if dg1 = 10 then
			  dg1 := 0;
		  //2° dígito
		  total := 0;
		  for x := 1 to 8 do
			  total := total + (StrToInt(cpf[x + 1]) * (x));
		  total := total + (dg1 * 9);
		  dg2 := total mod 11;
		  if dg2 = 10 then
			  dg2 := 0;
		  //Validação final
		  if (dg1 = StrToInt(cpf[10])) and (dg2 = StrToInt(cpf[11])) then
			ret := True
		  else
			ret := False;
			  //Inválidos
			case AnsiIndexStr(cpf,['00000000000','11111111111','22222222222','33333333333','44444444444','55555555555','66666666666','77777777777','88888888888','99999999999']) of
				0..9: ret := False;
			end;
		end else
		begin
			  //Se não informado deixa passar
			  if cpf = '' then
				  ret := True;
		end;
	end;
  result := ret;
end;

end.
