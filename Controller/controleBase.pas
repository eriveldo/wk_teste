unit controleBase;

interface

uses
  Classes,
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
  SysUtils,
  Data.DB;

type

  TBase = class
  private
    F_ConexaoDB:TFDConnection;
    function getGuidId: String;
    function GuidCreate : string;
  public
    destructor Destroy; override;
  protected
    property ConexaoDB :TFDConnection    read F_ConexaoDB     write F_ConexaoDB;
    property GuidId:String              read getGuidId;
  end;


implementation


function TBase.getGuidId: String;
var Qry:TFDQuery;
    sSelect:String;
begin
  Result:='';
  sSelect := ' SELECT UUID() AS UUID ';
  try
    try
      Qry:=TFDQuery.Create(nil);
      Qry.Connection:=ConexaoDB;
      Qry.SQL.Clear;
      Qry.SQL.Add(sSelect);
      Qry.Open;
      Result:=UpperCase(Qry.FieldByName('UUID').AsString);
    finally
      Qry.Close;
      if Assigned(Qry) then
         FreeAndNil(Qry);
    end;
  except
     Result := UpperCase(GuidCreate());
  end;

end;

function TBase.GuidCreate: string;
var
  ID: TGUID;
begin
  ID.NewGuid;
  Result :=StringReplace(StringReplace(GUIDToString(ID),'}','',[rfReplaceAll]),'{','',[rfReplaceAll]);
end;

destructor TBase.Destroy;
begin
  inherited Destroy;
end;

end.

