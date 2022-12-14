unit controlePedidoProduto;

interface

uses
	Classes,
	controleBase,
	classeProduto,
  classePedidoProduto,
  controleProduto,
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
  TControlePedidoProduto = class(TBase)
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    // Procedimento para cadastrar os dados no banco
    function Insert(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
    // Procedimento para atualizar os dados no banco
    function Update(const objetoPedidoProduto: TPedidoProduto) : Boolean;
    // Procedimento para excluir os dados no banco
    function Delete(const objetoPedidoProduto: TPedidoProduto) : Boolean;
    // Procedimento para Localizar por N?mero do Pedido e C?digo do Produto
    function FindByPedidoProduto(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
    // Procedimento para Localizar por Id
    function FindById(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
    // Procedimento para valida??o em insert
    function ValidaInsert (const objetoPedidoProduto : TPedidoProduto) : boolean;
    // Procedimento para valida??o em update
    function ValidaUpdate (const objetoPedidoProduto : TPedidoProduto) : boolean;
    // Procedimento para valida??o em delete
    function ValidaDelete (const objetoPedidoProduto : TPedidoProduto) : boolean;
    // Procedimento para carregar lista
    function LoadProdutos (const numero_pedido : integer) : TList;

end;

implementation

{ TControleCliente }

constructor TControlePedidoProduto.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TControlePedidoProduto.Destroy;
begin
  inherited;
end;

function TControlePedidoProduto.Insert(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
var
	Qry:TFDQuery;
begin
  result := TPedidoProduto.New;

  if ValidaInsert(objetoPedidoProduto) = false then Abort;

  try
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:= ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add('INSERT INTO pedido_produto ('+
                  ' numero_pedido, '+
                  ' codigo_produto, '+
                  ' quantidade, '+
                  ' valor_unitario, '+
                  ' valor_total '+
                  ') VALUES ('+
                  ' :numero_pedido, '+
                  ' :codigo_produto, '+
                  ' :quantidade, '+
                  ' :valor_unitario, '+
                  ' :valor_total '+
                  ')' );
      Qry.ParamByName('numero_pedido').AsInteger := objetoPedidoProduto.NumeroPedido;
      Qry.ParamByName('codigo_produto').AsInteger := objetoPedidoProduto.CodigoProduto;
      Qry.ParamByName('quantidade').AsFloat := objetoPedidoProduto.Quantidade;
      Qry.ParamByName('valor_unitario').AsFloat := objetoPedidoProduto.ValorUnitario;
      Qry.ParamByName('valor_total').AsFloat := objetoPedidoProduto.ValorTotal;

      Try
          Qry.ExecSQL;
          //Recupera o ID Gerado no Insert
          Qry.SQL.Clear;
          Qry.SQL.Add('SELECT LAST_INSERT_ID() AS ID');
          Qry.Open;
          objetoPedidoProduto.Id := Qry.FieldByName('id').AsInteger;
          result := objetoPedidoProduto;
      Except
          Result:=TPedidoProduto.New;
      End;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.LoadProdutos(
  const numero_pedido: integer): TList;
var
  i : integer;
  Qry:TFDQuery;
  objetoPedidoProduto : TPedidoProduto;
  objetoControleProduto : TControleProduto;
  objetoProduto : TProduto;
begin
  result := TList.Create;
  objetoPedidoProduto := TPedidoProduto.New;
  objetoControleProduto := TControleProduto.Create(ConexaoDB);
  objetoProduto := TProduto.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  'id, '+
                  'numero_pedido, '+
                  'codigo_produto, '+
                  'quantidade, '+
                  'valor_unitario, '+
                  'valor_total '+
                  'FROM pedido_produto '+
                  'WHERE numero_pedido = :id '+
                  'ORDER BY id ');
          ParamByName('id').AsInteger := numero_pedido;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  while not (eof) do
                  begin
                      //Dados dos produtos do pedido
                      objetoPedidoProduto := TPedidoProduto.New;
                      objetoProduto := TProduto.New;
                      objetoPedidoProduto.Id := Qry.FieldByName('id').AsInteger;
                      objetoPedidoProduto.NumeroPedido := Qry.FieldByName('numero_pedido').AsInteger;
                      objetoPedidoProduto.CodigoProduto := Qry.FieldByName('codigo_produto').AsInteger;
                      objetoPedidoProduto.Quantidade := Qry.FieldByName('quantidade').AsFloat;
                      objetoPedidoProduto.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
                      //Dados do produto espec?fico
                      objetoProduto.Codigo := objetoPedidoProduto.CodigoProduto;
                      objetoPedidoProduto.Produto := objetoControleProduto.Select(objetoProduto);
                      result.Add(objetoPedidoProduto);
                      next;
                  end;
              end;
          Except
              Result:=TList.Create;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.Update(const objetoPedidoProduto: TPedidoProduto) : Boolean;
var
	Qry:TFDQuery;
begin
  result := false;

  if ValidaUpdate(objetoPedidoProduto) = false then Abort;

  try
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE pedido_produto SET'+
                ' numero_pedido = :numero_pedido, '+
                ' codigo_produto= :codigo_produto, '+
                ' quantidade = :quantidade, '+
                ' valor_unitario = :valor_unitario, '+
                ' valor_total = :valor_total '+
                ' WHERE Id=:id ');
        ParamByName('id').AsInteger :=objetoPedidoProduto.Id;
        ParamByName('numero_pedido').AsInteger :=objetoPedidoProduto.NumeroPedido;
        ParamByName('codigo_produto').AsInteger :=objetoPedidoProduto.CodigoProduto;
        ParamByName('quantidade').AsFloat :=objetoPedidoProduto.Quantidade;
        ParamByName('valor_unitario').AsFloat :=objetoPedidoProduto.ValorUnitario;
        ParamByName('valor_total').AsFloat :=objetoPedidoProduto.ValorTotal;

        Try
          ExecSQL;
          Result:=true;
        Except
          Result:=false;
        End;
	  end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.Delete(const objetoPedidoProduto: TPedidoProduto) : Boolean;
var 
	Qry:TFDQuery;
begin
  result := false;

  if ValidaDelete(objetoPedidoProduto) = false then Abort;
  
  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin
		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM pedido_produto '+
				    'WHERE Id=:id ');
		ParamByName('id').AsInteger :=objetoPedidoProduto.Id;

		Try
			ExecSQL;
			Result:=true;
		Except
			Result:=false;
		End;
	end;
  finally
	if Assigned(Qry) then
	   FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.FindById(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
var
  Qry:TFDQuery;
begin
  result := TPedidoProduto.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  ' id, '+
                  ' numero_pedido, '+
                  ' codigo_produto, '+
                  ' quantidade, '+
                  ' valor_unitario '+
                  'FROM pedido_produto '+
                  'WHERE id =:id');
          ParamByName('id').AsInteger:=objetoPedidoProduto.Id;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Id := Qry.FieldByName('id').AsInteger;
                  result.NumeroPedido := Qry.FieldByName('numero_pedido').AsInteger;
                  result.CodigoProduto:= Qry.FieldByName('codigo_produto').AsInteger;
                  result.Quantidade := Qry.FieldByName('quantidade').AsFloat;
                  result.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
              end;
          Except
              Result:=TPedidoProduto.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.FindByPedidoProduto(const objetoPedidoProduto: TPedidoProduto) : TPedidoProduto;
var
  Qry:TFDQuery;
begin
  result := TPedidoProduto.New;
  try
      Qry:=TFDQuery.Create(nil);
      with Qry do
      begin
          Connection:=ConexaoDB;
          SQL.Clear;
          SQL.Add('SELECT '+
                  ' id, '+
                  ' numero_pedido, '+
                  ' codigo_produto, '+
                  ' quantidade, '+
                  ' valor_unitario '+
                  'FROM pedido_produto '+
                  'WHERE Codigo=:id');
          ParamByName('id').AsInteger:=objetoPedidoProduto.Id;

          Try
              Open;
              if (RecordCount > 0) then
              begin
                  result.Id := Qry.FieldByName('id').AsInteger;
                  result.NumeroPedido := Qry.FieldByName('numero_pedido').AsInteger;
                  result.CodigoProduto:= Qry.FieldByName('codigo_produto').AsInteger;
                  result.Quantidade := Qry.FieldByName('quantidade').AsFloat;
                  result.ValorUnitario := Qry.FieldByName('valor_unitario').AsFloat;
              end;
          Except
              Result:=TPedidoProduto.New;
          End;
      end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TControlePedidoProduto.ValidaDelete(
  const objetoPedidoProduto: TPedidoProduto): boolean;
begin
  result := false;
  if objetoPedidoProduto.Id <= 0 then
    raise Exception.Create('ID inv?lido.');

  result := true;
end;

function TControlePedidoProduto.ValidaInsert(
  const objetoPedidoProduto: TPedidoProduto): boolean;
begin
  result := false;

  if objetoPedidoProduto.CodigoProduto = 0 then
    raise Exception.Create('C?digo do produto n?o pode ficar em branco.');

  if objetoPedidoProduto.Quantidade <= 0 then
    raise Exception.Create('Quantidade n?o pode ser menor do que 1.');

  if objetoPedidoProduto.ValorUnitario <= 0 then
    raise Exception.Create('Valor unitario do produto inv?lido.');

  result := true;
end;

function TControlePedidoProduto.ValidaUpdate(
  const objetoPedidoProduto: TPedidoProduto): boolean;
begin
  result := false;
  if objetoPedidoProduto.Id <= 0 then
    raise Exception.Create('Id inv?lido.');

  if objetoPedidoProduto.NumeroPedido = 0 then
    raise Exception.Create('N?mero do pedido n?o pode ficar em branco.');

  if objetoPedidoProduto.CodigoProduto = 0 then
    raise Exception.Create('C?digo do produto n?o pode ficar em branco.');

  if objetoPedidoProduto.Quantidade <= 0 then
    raise Exception.Create('Quantidade inv?lida.');

  if objetoPedidoProduto.ValorUnitario <= 0 then
    raise Exception.Create('Valor unitario do produto inv?lido.');

  result := true;
end;

end.
