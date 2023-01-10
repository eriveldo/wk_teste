unit controlePedido;

interface

uses
	Classes,
	controleBase,
  controlePedidoProduto,
  controleCliente,
	classePedido,
  classePedidoProduto,
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
  TControlePedido = class(TBase)
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    // Procedimento para cadastrar os dados no banco
    function Insert(const objetoPedido: TPedido) : TPedido;
    // Procedimento para atualizar os dados no banco
    function Update(const objetoPedido: TPedido) : Boolean;
    // Procedimento para excluir os dados no banco
    function Delete(const objetoPedido: TPedido) : Boolean;
    // Procedimento para carregar produto pelo codigo do produto
    function Select(const objetoPedido: TPedido) : TPedido;
    // Procedimento para inserir produto
    function InsertProduto(const objetoPedido : TPedido; const objetoPedidoProduto : TPedidoProduto ) : TPedido;
    // Procedimento para atualizar produto
    function UpdateProduto(const objetoPedido : TPedido; const item : integer; const objetoPedidoProduto : TPedidoProduto ) : TPedido;
    // Procedimento para excluir produto
    function DeleteProduto(const objetoPedido : TPedido; const item : integer) : TPedido;
    // Procedimento para validação em insert
    function ValidaInsert (const objetoPedido : TPedido) : boolean;
    // Procedimento para validação em update
    function ValidaUpdate (const objetoPedido : TPedido) : boolean;
    // Procedimento para validação em select
    function ValidaSelect (const objetoPedido : TPedido) : boolean;
    // Procedimento para validação em delete
    function ValidaDelete (const objetoPedido : TPedido) : boolean;
    // Procedumento para verificar se existe o numero do pedido
    function ExistNumeroPedido(const numero_pedido : integer) : boolean;
    // Procedimento para gerar um novo número para o pedido
    function GerarNumeroPedido : integer;
    // Funções auxiliares para controle de inserção em tabelas relacionadas
    function InNot(const objetoPedido : TPedido):String;
    function DeleteItens(const objetoPedido: TPedido): Boolean;
    function ExistItem(const objetoPedidoProduto : TPedidoProduto ): Boolean;

end;

implementation

{ TControleCliente }

constructor TControlePedido.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TControlePedido.Destroy;
begin
  inherited;
end;

function TControlePedido.Insert(const objetoPedido: TPedido) : TPedido;
var
	Qry:TFDQuery;
  objetoControlePedidoProduto : TControlePedidoProduto;
  objetoPedidoProduto : TPedidoProduto;
  i : integer;
begin
  result := TPedido.New;
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);
  objetoPedidoProduto := TPedidoProduto.New;

  if ValidaInsert(objetoPedido) = false then
  begin
    objetoPedido.NumeroPedido := 0;
    Abort;
  end;

  try
      ConexaoDB.StartTransaction;
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:= ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add('INSERT INTO pedido ('+
                  ' numero_pedido, '+
                  ' data_emissao, '+
                  ' codigo_cliente, '+
                  ' valor_total '+
                  ') VALUES ('+
                  ' :numero_pedido, '+
                  ' :data_emissao, '+
                  ' :codigo_cliente, '+
                  ' :valor_total '+
                  ')' );
      Qry.ParamByName('numero_pedido').AsInteger := objetoPedido.NumeroPedido;
      Qry.ParamByName('data_emissao').AsDate := objetoPedido.DataEmissao;
      Qry.ParamByName('codigo_cliente').AsInteger := objetoPedido.CodigoCliente;
      Qry.ParamByName('valor_total').AsFloat := objetoPedido.ValorTotal;

      Try
          Qry.ExecSQL;

          //Inserindo os produtos do pedido
          for I := 0 to objetoPedido.Produtos.Count -1 do
          begin
            objetoPedidoProduto := objetoPedido.Produtos.Items[i];
            objetoPedidoProduto.NumeroPedido := objetoPedido.NumeroPedido;
            objetoControlePedidoProduto.Insert(objetoPedidoProduto);
          end;

          ConexaoDB.Commit;
          result := objetoPedido;
      Except
          ConexaoDB.Rollback;
          Result:=TPedido.New;
          raise Exception.Create('Erro ao salvar os dados.');
      End;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedido.Update(const objetoPedido: TPedido) : Boolean;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
  objetoPedidoProduto : TPedidoProduto;
	Qry:TFDQuery;
  i : integer;
begin
  result := false;
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);
  objetoPedidoProduto := TPedidoProduto.New;

  if ValidaUpdate(objetoPedido) = false then Abort;

  try
    Result:=false;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE pedido SET'+
                ' data_emissao = :data_emissao, '+
                ' codigo_cliente = :codigo_cliente, '+
                ' valor_total = :valor_total '+
                ' WHERE numero_pedido=:id ');
        ParamByName('id').AsInteger :=objetoPedido.NumeroPedido;
        ParamByName('data_emissao').AsDate:=objetoPedido.DataEmissao;
        ParamByName('codigo_cliente').AsInteger:=objetoPedido.CodigoCliente;
        ParamByName('valor_total').AsFloat := objetoPedido.ValorTotal;

        Try
          ConexaoDB.StartTransaction;
          ExecSQL;

          //Apaga os itens excluidos do pedido
          DeleteItens(objetoPedido);

          //Promove a atualização dos produtos (caso já esteja cadastrado) ou inserção (caso não esteja cadastrado)
          for I := 0 to objetoPedido.Produtos.Count -1 do
          begin
            objetoPedidoProduto := objetoPedido.Produtos.Items[i];
            objetoPedidoProduto.NumeroPedido := objetoPedido.NumeroPedido;
            if ExistItem(objetoPedidoProduto) then
              objetoControlePedidoProduto.Update(objetoPedidoProduto)
            else
            begin
              objetoControlePedidoProduto.Insert(objetoPedidoProduto);
            end;
          end;

          ConexaoDB.Commit;
          result := true;
        Except
          ConexaoDB.Rollback;
          Result:=false;
          raise Exception.Create('Erro ao salvar os dados.');
        End;
	  end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedido.Delete(const objetoPedido: TPedido) : Boolean;
var 
	Qry:TFDQuery;
begin
  //A trigger do MySql fica responsavel por excluir os produtos do pedido
  result := false;

  if ValidaDelete(objetoPedido) = false then Abort;

  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin

		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM pedido '+
				    'WHERE numero_pedido =:id ');
		ParamByName('id').AsInteger :=objetoPedido.NumeroPedido;

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

function TControlePedido.Select(const objetoPedido: TPedido): TPedido;
var
  Qry:TFDQuery;
  objetoControleCliente : TControleCliente;
  objetoControlePedidoProduto : TControlePedidoProduto;
begin
  result := TPedido.New;
  objetoControleCliente := TControleCliente.Create(ConexaoDB);
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);
  if ValidaSelect(objetoPedido) = false then Abort;

  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'numero_pedido, '+
                  'data_emissao, '+
                  'codigo_cliente, '+
                  'valor_total '+
                  'FROM pedido '+
                  'WHERE numero_pedido=:id');
          ParamByName('id').AsInteger:=objetoPedido.NumeroPedido;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.NumeroPedido := Qry.FieldByName('numero_pedido').AsInteger;
                  result.DataEmissao := Qry.FieldByName('data_emissao').AsDateTime;
                  result.CodigoCliente := Qry.FieldByName('codigo_cliente').AsInteger;
                  result.Cliente.Codigo := result.CodigoCliente;
                  result.Cliente := objetoControleCliente.Select(result.Cliente);
                  result.Produtos:= objetoControlePedidoProduto.LoadProdutos(result.NumeroPedido);
              end;
          Except
              Result:=TPedido.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedido.InsertProduto(const objetoPedido : TPedido; const objetoPedidoProduto: TPedidoProduto): TPedido;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
begin
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);

  if objetoControlePedidoProduto.ValidaInsert(objetoPedidoProduto) = false then Abort;

  result := objetoPedido;
  result.Produtos.Add(objetoPedidoProduto);

end;

function TControlePedido.UpdateProduto(const objetoPedido : TPedido; const item: integer; const objetoPedidoProduto : TPedidoProduto): TPedido;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
begin
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);

  if objetoControlePedidoProduto.ValidaUpdate(objetoPedidoProduto) = false then Abort;

  result := objetoPedido;
  result.Produtos.Items[item] := objetoPedidoProduto;

end;

function TControlePedido.DeleteProduto(const objetoPedido : TPedido; const item : integer): TPedido;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
begin
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);

  if objetoControlePedidoProduto.ValidaDelete(objetoPedido.Produtos.Items[item]) = false then Abort;

  result := objetoPedido;
  result.Produtos.Delete(item);
end;

function TControlePedido.ValidaDelete(const objetoPedido: TPedido): boolean;
begin
  result := false;
  if objetoPedido.NumeroPedido <= 0 then
    raise Exception.Create('Numero do pedido inválido');

  result := true;
end;

function TControlePedido.ValidaInsert(const objetoPedido: TPedido): boolean;
begin
  result := false;
  if objetoPedido.NumeroPedido <= 0 then
    raise Exception.Create('Número do pedido inválido.');

  if objetoPedido.DataEmissao <= 0 then
  begin
    objetoPedido.NumeroPedido := 0;
    raise Exception.Create('Data da emissão inválida.');
  end;

  if objetoPedido.CodigoCliente <= 0 then
  begin
    objetoPedido.NumeroPedido := 0;
    raise Exception.Create('Código do cliente inválido.');
  end;

  if objetoPedido.Produtos.Count <= 0 then
  begin
    objetoPedido.NumeroPedido := 0;
    raise Exception.Create('Pedido sem itens cadastrados.');
  end;
  result := true;
end;

function TControlePedido.ValidaSelect(const objetoPedido: TPedido): boolean;
begin
  result := false;
  if objetoPedido.NumeroPedido <= 0 then
    raise Exception.Create('Numero do pedido inválido');

  result := true;
end;

function TControlePedido.ValidaUpdate(const objetoPedido: TPedido): boolean;
begin
  result := false;
  if objetoPedido.NumeroPedido <= 0 then
    raise Exception.Create('Número do pedido inválido.');

  if objetoPedido.DataEmissao <= 0 then
    raise Exception.Create('Data da emissão inválida.');

  if objetoPedido.CodigoCliente <= 0 then
    raise Exception.Create('Código do cliente inválido.');

  if objetoPedido.Produtos.Count <= 0 then
    raise Exception.Create('Pedido sem itens cadastrados.');

  result := true;
end;

function TControlePedido.InNot(const objetoPedido: TPedido): String;
var
  sInNot:String;
  i : integer;
begin
  sInNot:=EmptyStr;
  for I := 0 to objetoPedido.Produtos.Count -1 do
  begin
    if sInNot=EmptyStr then
       sInNot := TPedidoProduto(objetoPedido.Produtos.Items[i]).Id.ToString
    else
       sInNot := sInNot +','+TPedidoProduto(objetoPedido.Produtos.Items[i]).Id.ToString;
  end;
  Result:=sInNot;
end;

function TControlePedido.ExistItem(const objetoPedidoProduto : TPedidoProduto): Boolean;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
  vPedidoProduto : TPedidoProduto;
begin
  result := false;
  objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);
  vPedidoProduto := TPedidoProduto.New;
  try
    vPedidoProduto := objetoControlePedidoProduto.FindById(objetoPedidoProduto);
    result := (vPedidoProduto.Id > 0);
  except;
    result := false;
  end;
end;

function TControlePedido.ExistNumeroPedido(
  const numero_pedido: integer): boolean;
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
          SQL.Add('SELECT numero_pedido from pedido '+
                  'WHERE numero_pedido=:id');
          ParamByName('id').AsInteger:= numero_pedido;

          Try
              Open;
              if (RecordCount > 0) then
                result := true;
          Except
              Result := false;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedido.GerarNumeroPedido: integer;
var
  Qry:TFDQuery;
begin
  Result:=0;
  try

    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT numero_pedido ultimo '+
                'FROM pedido '+
                'ORDER BY numero_pedido DESC LIMIT 1');
    Try
      Qry.Open;
      if (Qry.RecordCount > 0 ) then
          result := Qry.FieldByName('ultimo').AsInteger+1
      else
          result := 1;

    Except
      Result:=0;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedido.DeleteItens(const objetoPedido: TPedido): Boolean;
var
  objetoControlePedidoProduto : TControlePedidoProduto;
  Qry:TFDQuery;
  sNoID:String;
begin
  Result:=false;
  try
    objetoControlePedidoProduto := TControlePedidoProduto.Create(ConexaoDB);

    //Pega os id's que precisam ser excluidos
    sNoID:= InNot(objetoPedido);

    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' DELETE '+
                '   FROM pedido_produto '+
                '  WHERE '+
                '    Id NOT IN ('+sNoID+') and numero_pedido = '+IntToStr(objetoPedido.NumeroPedido));
    Try
      Qry.ExecSQL;
    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;

end;

end.
