unit uInformePedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TformInformePedido = class(TForm)
    edt_numero_pedido: TEdit;
    Label3: TLabel;
    btnOk: TButton;
    btnCancelar: TButton;
    procedure edt_numero_pedidoKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formInformePedido: TformInformePedido;

implementation

{$R *.dfm}

procedure TformInformePedido.btnOkClick(Sender: TObject);
begin
  if edt_numero_pedido.text <> '' then
  begin
    close;
    ModalResult := mrOk;
  end;
end;

procedure TformInformePedido.edt_numero_pedidoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9', #8, #9])) then Key := #0;
end;

end.
