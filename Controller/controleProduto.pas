unit controleProduto;

interface

uses
	Classes,
	controleBase,
	classeProduto,
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
  TControleProduto = class(TBase)
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    // Procedimento para cadastrar os dados no banco
    function Insert(const objetoProduto: TProduto) : TProduto;
    // Procedimento para atualizar os dados no banco
    function Update(const objetoProduto: TProduto) : Boolean;
    // Procedimento para excluir os dados no banco
    function Delete(const objetoProduto: TProduto) : Boolean;
    // Procedimento para Carregar produto pelo codigo
    function Select(const objetoProduto: TProduto) : TProduto;
    // Procedimento para Localizar por Descri??o do produto
    function FindByDescricao(const objetoProduto: TProduto) : TProduto;
    // Procedimento para Localizar por Id
    function FindById(const objetoProduto: TProduto) : TProduto;
    // Procedimento para Verificar se existe produto cadastrado com mesma descri??o
    function FoundDescricao(const objetoProduto: TProduto) : Boolean;
    // Procedimento para valida??o em insert
    function ValidaInsert (const objetoProduto : TProduto) : boolean;
    // Procedimento para valida??o em update
    function ValidaUpdate (const objetoProduto : TProduto) : boolean;
    // Procedimento para valida??o em select
    function ValidaSelect (const objetoProduto : TProduto) : boolean;
    // Procedimento para valida??o em delete
    function ValidaDelete (const objetoProduto : TProduto) : boolean;
end;

implementation

{ TControleCliente }

constructor TControleProduto.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TControleProduto.Destroy;
begin
  inherited;
end;

function TControleProduto.Insert(const objetoProduto: TProduto) : TProduto;
var
	Qry:TFDQuery;
begin
  result := TProduto.New;

  if ValidaInsert(objetoProduto) = false then Abort;
  try
      ConexaoDB.StartTransaction;
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:= ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add('INSERT INTO produto ('+
                  ' descricao, '+
                  ' valor_unitario '+
                  ') VALUES ('+
                  ' :descricao, '+
                  ' :valor_unitario '+
                  ')' );
      Qry.ParamByName('descricao').AsString := objetoProduto.Descricao;
      Qry.ParamByName('valor_unitario').AsFloat := objetoProduto.ValorUnitario;
      Try
          Qry.ExecSQL;
          ConexaoDB.Commit;
          //Recupera o ID Gerado no Insert
          Qry.SQL.Clear;
          Qry.SQL.Add('SELECT LAST_INSERT_ID() AS ID');
          Qry.Open;
          objetoProduto.Codigo := Qry.FieldByName('id').AsInteger;
          result := objetoProduto;
      Except
          ConexaoDB.Rollback;
          Result:=TProduto.New;
      End;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleProduto.Update(const objetoProduto: TProduto) : Boolean;
var
	Qry:TFDQuery;
begin
  result := false;

  if ValidaUpdate(objetoProduto) = false then Abort;

  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE produto SET'+
                ' descricao = :descricao, '+
                ' valor_unitario = :valor_unitario '+
                ' WHERE Codigo=:id ');
        ParamByName('id').AsInteger :=objetoProduto.Codigo;
        ParamByName('descricao').AsString:=objetoProduto.Descricao;
        ParamByName('valor_unitario').AsFloat:=objetoProduto.ValorUnitario;

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

function TControleProduto.Delete(const objetoProduto: TProduto) : Boolean;
var 
	Qry:TFDQuery;
begin
  result := false;

  if ValidaDelete(objetoProduto) = false then Abort;

  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin

		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM produto '+
				    'WHERE Codigo=:id ');
		ParamByName('id').AsInteger :=objetoProduto.Codigo;

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

function TControleProduto.FindById(const objetoProduto: TProduto) : TProduto;
var
  Qry:TFDQuery;
begin
  result := TProduto.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'descricao, '+
                  'valor_unitario '+
                  'FROM produto '+
                  'WHERE Codigo=:id');
          ParamByName('id').AsInteger:=objetoProduto.Codigo;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Descricao := Qry.FieldByName('descricao').AsString;
                  result.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
              end;
          Except
              Result:=TProduto.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleProduto.FindByDescricao(const objetoProduto: TProduto) : TProduto;
var
  Qry:TFDQuery;
begin
  result := TProduto.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'descricao, '+
                  'valor_unitario '+
                  'FROM produto '+
                  'WHERE descricao=:descricao');
          ParamByName('descricao').AsString := objetoProduto.descricao;
          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Descricao := Qry.FieldByName('descricao').AsString;
                  result.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
              end;
          Except
              Result:=TProduto.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleProduto.FoundDescricao(const objetoProduto: TProduto) : Boolean;
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
                  'FROM produto '+
                  'WHERE descricao = :descricao');
          ParamByName('descricao').asString := objetoProduto.Descricao;

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

function TControleProduto.Select(const objetoProduto: TProduto): TProduto;
var
  Qry:TFDQuery;
begin
  result := TProduto.New;

  if ValidaSelect(objetoProduto) = false then Abort;
  
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'codigo, '+
                  'descricao, '+
                  'valor_unitario '+
                  'FROM produto '+
                  'WHERE Codigo=:id');
          ParamByName('id').AsInteger:=objetoProduto.Codigo;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Codigo := Qry.FieldByName('codigo').AsInteger;
                  result.Descricao := Qry.FieldByName('descricao').AsString;
                  result.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
              end;
          Except
              Result:=TProduto.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControleProduto.ValidaDelete (const objetoProduto : TProduto) : boolean;
begin
  result := false;
  if objetoProduto.Codigo <= 0 then
    raise Exception.Create('C?digo inv?lido.');

  result := true;
end;

function TControleProduto.ValidaInsert (const objetoProduto : TProduto) : boolean;
begin
  result := false;
  if objetoProduto.Descricao = '' then
    raise Exception.Create('Descri??o do produto n?o pode ficar em branco.');

  if objetoProduto.ValorUnitario <= 0 then
    raise Exception.Create('Valor unitario do produto inv?lido.');

  if (FoundDescricao(objetoProduto)) then
    raise Exception.Create('J? existe um produto cadastrado com esta descri??o!');

  result := true;
end;

function TControleProduto.ValidaSelect (const objetoProduto : TProduto) : boolean;
begin
  result := false;
  if objetoProduto.Codigo <= 0 then
    raise Exception.Create('C?digo do produto inv?lido');

  result := true;
end;

function TControleProduto.ValidaUpdate (const objetoProduto : TProduto) : boolean;
begin
  result := false;
  if objetoProduto.Codigo <= 0 then
    raise Exception.Create('C?digo inv?lido.');

  if objetoProduto.Descricao= '' then
    raise Exception.Create('Descri??o do produto n?o pode ficar em branco.');

  if objetoProduto.ValorUnitario <= 0 then
    raise Exception.Create('Valor unitario do produto inv?lido.');

  result := true;
end;

end.
