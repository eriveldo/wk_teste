unit cVenda;

interface

uses Classes,
     Controls,
     ExtCtrls,
     Dialogs,
     cBase,
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
     uUtils,
     cBomba,
     uMsg,
     System.Variants;


type
  TVenda = class(TBase)
  private
	F_id:Integer;
	F_datavenda:TDateTime;
	F_bomba_id:Integer;
	F_qtdlitro:Double;
	F_valorlitro:Double;
	F_percimposto:Double;
	F_bomba : TBomba;
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;

    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
    function VerificaSeExiste(vDescricao : String) : boolean;

  published
    property id : Integer read F_id write F_id ;
	property datavenda : TDateTime read F_datavenda write F_datavenda ;
	property bomba_id : Integer read F_bomba_id write F_bomba_id ;
	property qtdlitro : Double read F_qtdlitro write F_qtdlitro ;
	property valorlitro : Double read F_valorlitro write F_valorlitro ;
	property percimposto : Double read F_percimposto write F_percimposto ;
	property bomba : TBomba read F_bomba write F_bomba ;
end;

implementation


{$region 'Constructor e Destructor'}
constructor TVenda.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TVenda.Destroy;
begin

  inherited;
end;
{$endRegion}

{$region 'CRUD'}
//Verifica se tipo de combustivel existe utilizando a descricao
function TVenda.VerificaSeExiste(vDescricao : String) : boolean;
var Qry:TFDQuery;
begin
  try
  	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin
		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('SELECT id ');
		SQL.Add('FROM VENDA ');
		SQL.Add('WHERE DESCRICAO = :descricao');
		ParamByName('descricao').asString := vDescricao;

		Try
		  Open;

		  if RecordCount>0 then
		  begin
			 result := true
		  end else
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

//Apaga registro utilizando o id
//Retorna TRUE se der certo ou FALSE caso não
function TVenda.Apagar: Boolean;
var Qry:TFDQuery;
begin
  if MessageNoYes('Apagar o Registro: '+#13+#13+
                  'Venda: '  +FormatFloat('000000',F_id),mtConfirmation)=mrNo then
  begin
	 Result:=false;
     abort;
  end;
  try
	Qry:=TFDQuery.Create(nil);
	with Qry do
	begin
		Result:=true;

		Connection:=ConexaoDB;
		SQL.Clear;
		SQL.Add('DELETE FROM VENDA '+
				    'WHERE ID=:id ');
		ParamByName('id').AsInteger :=F_id;
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

//Atualiza o registro com base no ID
//Retorna TRUE se tudo der certo ou FALSE caso não
function TVenda.Atualizar: Boolean;
var Qry:TFDQuery;
begin

  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('UPDATE VENDA SET'+
                {CamposUpdate}
				' DATAVENDA = :datavenda, '+
				' BOMBA_ID = :bomba_id, '+
				' QTDLITRO = :qtdlitro, '+
				' VALORLITRO = :valorlitro, '+
				' PERCIMPOSTO = :percimposto '+
                ' WHERE ID=:id ');
        ParamByName('id').AsInteger     :=Self.F_id;
		ParamByName('datavenda').AsDate  :=Self.F_datavenda;
		ParamByName('bomba_id').AsInteger  :=Self.F_bomba_id;
		ParamByName('qtdlitro').AsFloat  :=Self.F_qtdlitro;
		ParamByName('valorlitro').AsFloat  :=Self.F_valorlitro;
		ParamByName('percimposto').AsFloat  :=Self.F_percimposto;

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

//Insere os dados
//Retorna o ID gerado ou -1 em caso de erro
function TVenda.Inserir: Boolean;
var Qry:TFDQuery;
begin
  try
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('INSERT INTO VENDA ('+
				' datavenda, '+
				' bomba_id, '+
				' qtdlitro, '+
				' valorlitro, '+
				' percimposto '+
				') VALUES ('+
				' :datavenda, '+
				' :bomba_id, '+
				' :qtdlitro, '+
				' :valorlitro, '+
				' :percimposto '+
				')' );
		ParamByName('datavenda').AsDate  :=Self.F_datavenda;
		ParamByName('bomba_id').AsInteger  :=Self.F_bomba_id;
		ParamByName('qtdlitro').AsFloat  :=Self.F_qtdlitro;
		ParamByName('valorlitro').AsFloat  :=Self.F_valorlitro;
		ParamByName('percimposto').AsFloat  :=Self.F_percimposto;

        Try
          ConexaoDB.StartTransaction;
          ExecSQL;
          Result:=true;
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

//Carrega os dados utilizando o ID
//Retorna TRUE se tudo der certo e FALSE em caso de erro
function TVenda.Selecionar(id: Integer): Boolean;
var Qry:TFDQuery;
oBomba : TBomba;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    with Qry do
    begin
        Connection:=ConexaoDB;
        SQL.Clear;
        SQL.Add('SELECT '+
                'ID, '+
                'DATAVENDA, '+
                'BOMBA_ID, '+
                'QTDLITRO, '+
                'VALORLITRO, '+
                'PERCIMPOSTO '+
                'FROM VENDA '+
                'WHERE ID=:id');
        ParamByName('id').AsInteger:=id;
        Try
          Open;
          Self.F_id := Qry.FieldByName('id').AsInteger;
          Self.F_datavenda := Qry.FieldByName('datavenda').AsDateTime;
          Self.F_bomba_id := Qry.FieldByName('bomba_id').AsInteger;
          Self.F_qtdlitro := Qry.FieldByName('qtdlitro').AsFloat;
          Self.F_valorlitro := Qry.FieldByName('valorlitro').AsFloat;
          Self.F_percimposto := Qry.FieldByName('percimposto').AsFloat;
          oBomba := TBomba.Create(ConexaoDB);
          oBomba.Selecionar(Self.F_bomba_id);
          Self.F_bomba := oBomba;

        Except
          Result:=false;
        End;
	end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

end.

