unit uPedidoProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  classePedidoProduto, controlePedidoProduto, classeProduto, controleProduto, uConexao;

type
  TformPedidoProduto = class(TForm)
    pan_produto: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    sta_produto_nome: TStaticText;
    btnConfirmar: TButton;
    btnCancela: TButton;
    edt_quantidade: TEdit;
    edt_codigo_produto: TEdit;
    edt_valor_unitario: TEdit;
    edt_valor_total: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
    procedure msk_quantidadeExit(Sender: TObject);
    procedure edt_quantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edt_codigo_produtoKeyPress(Sender: TObject; var Key: Char);
    procedure edt_codigo_produtoExit(Sender: TObject);
    procedure edt_quantidadeExit(Sender: TObject);
    procedure edt_quantidadeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_valor_unitarioExit(Sender: TObject);
  private
    objetoProduto : TProduto;
    controleProduto: TControleProduto;
    controlePedidoProduto : TControlePedidoProduto;
    function ValorOk(sValor, sCampo: string): boolean;
  public
    objetoPedidoProduto : TPedidoProduto;
  end;

var
  formPedidoProduto: TformPedidoProduto;

implementation

{$R *.dfm}

procedure TformPedidoProduto.btnCancelaClick(Sender: TObject);
begin
  close;
  ModalResult := mrCancel;
end;

procedure TformPedidoProduto.btnConfirmarClick(Sender: TObject);
var
  sCodigo, sQuantidade, sValorUnitario : string;
begin
  sCodigo := edt_codigo_produto.text;
  sCodigo := Trim(sCodigo);
  sQuantidade := edt_quantidade.text;
  sQuantidade := Trim(sQuantidade);
  sValorUnitario := edt_valor_unitario.Text;
  sValorUnitario := Trim(sValorUnitario);
  //Verifica se o codigo do produto est? correto
  if ValorOk(sCodigo,'C?digo do produto') then
  begin
    objetoProduto.Codigo := StrToInt(sCodigo);
    objetoProduto := controleProduto.Select(objetoProduto);
    if objetoProduto.Codigo = 0 then
      Abort
    else
    begin
      objetoPedidoProduto.Produto := objetoProduto;
      objetoPedidoProduto.ValorUnitario := objetoProduto.ValorUnitario;
    end;
  end;
  //Verifica se a quantidade est? correta
  if ValorOk(sQuantidade,'Quantidade') then
    objetoPedidoProduto.Quantidade := StrToFloat(sQuantidade)
  else
    Abort;
  //Verifica se o valor unitario esta correto
  if ValorOk(sQuantidade,'Quantidade') then
    objetoPedidoProduto.ValorUnitario := StrToFloat(sValorUnitario)
  else
    Abort;
  if controlePedidoProduto.ValidaInsert(objetoPedidoProduto) then
  begin
    close;
    ModalResult := mrOk;
  end;
end;

procedure TformPedidoProduto.edt_codigo_produtoExit(Sender: TObject);
var
  sCodigo : string;
begin
  sCodigo := edt_codigo_produto.text;
  sCodigo := Trim(sCodigo);
  if sCodigo <> '' then
  begin
    if ValorOk(sCodigo,'C?digo do produto') then
    begin
      objetoProduto.Codigo := StrToInt(sCodigo);
      objetoProduto := controleProduto.Select(objetoProduto);
      if objetoProduto.Codigo = 0 then
        edt_codigo_produto.text := ''
      else
      begin
        objetoPedidoProduto.CodigoProduto := objetoProduto.Codigo;
        objetoPedidoProduto.Produto := objetoProduto;
        if objetoPedidoProduto.ValorUnitario = 0 then
          objetoPedidoProduto.ValorUnitario := objetoProduto.ValorUnitario;
        sta_produto_nome.Caption := objetoProduto.Descricao;
        edt_valor_unitario.Text := formatfloat('0.00',objetoPedidoProduto.ValorUnitario);
        edt_valor_total.text := formatfloat('0.00',objetoPedidoProduto.ValorTotal);
        edt_codigo_produto.text := formatfloat('000000000',objetoPedidoProduto.CodigoProduto);
      end;
    end else
      edt_codigo_produto.text := '';
  end;
end;

procedure TformPedidoProduto.edt_codigo_produtoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9', #8, #9])) then Key := #0;
end;

procedure TformPedidoProduto.edt_quantidadeExit(Sender: TObject);
begin
  try
      if valorok(edt_quantidade.text,'Quantidade') then
      begin
          objetoPedidoProduto.Quantidade := StrToFloat(edt_quantidade.text);
          edt_valor_total.text := formatfloat('0.00',objetoPedidoProduto.ValorTotal);
      end;
  except
    on e:exception do
    begin
      application.MessageBox('Quantidade inv?lida.','ERRO',Mb_Ok+MB_ICONEXCLAMATION);
      edt_quantidade.text := '0';
    end;

  end;
end;

procedure TformPedidoProduto.edt_quantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9', ',', #8, #9])) OR ( (Key = ',') and (pos(',',TEdit(Sender).Text)>0) ) then Key := #0;
end;

procedure TformPedidoProduto.edt_quantidadeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
  begin
    key := Ord(0);
    btnConfirmar.Click;
  end;
end;

procedure TformPedidoProduto.edt_valor_unitarioExit(Sender: TObject);
begin
  try
      if valorok(edt_valor_unitario.text,'Valor unit?rio') then
      begin
          objetoPedidoProduto.ValorUnitario := StrToFloat(edt_valor_unitario.text);
          edt_valor_total.text := formatfloat('0.00',objetoPedidoProduto.ValorTotal);
      end;
  except
    on e:exception do
    begin
      application.MessageBox('Quantidade inv?lida.','ERRO',Mb_Ok+MB_ICONEXCLAMATION);
      edt_quantidade.text := '0';
    end;

  end;
end;

procedure TformPedidoProduto.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ((ModalResult = mrOk) or (ModalResult = mrCancel));
end;

procedure TformPedidoProduto.FormCreate(Sender: TObject);
begin
  objetoProduto := TProduto.New;
  controleProduto := TControleProduto.Create(dmConexao.conexao);
  objetoPedidoProduto := TPedidoProduto.New;
  controlePedidoProduto := TControlePedidoProduto.Create(dmConexao.conexao);
end;

procedure TformPedidoProduto.FormShow(Sender: TObject);
begin
  try
    edt_codigo_produto.SetFocus;
  except
    edt_quantidade.SetFocus;
  end;
end;

procedure TformPedidoProduto.msk_quantidadeExit(Sender: TObject);
var
  sQuantidade : string;
begin
  sQuantidade := edt_quantidade.text;
  sQuantidade := trim(sQuantidade);
  if ValorOk(sQuantidade,'Quantidade') then
    objetoPedidoProduto.Quantidade := StrToFloat(sQuantidade)
  else
  begin
    objetoPedidoProduto.Quantidade := 0;
    edt_quantidade.Text := '';
  end;


end;

function TformPedidoProduto.ValorOk(sValor, sCampo: string): boolean;
var
  testeValor : double;
begin
  result := false;
  try
    testeValor := StrToFloat(Trim(sValor));
    result := true;
  except
    result := false;
    raise Exception.Create(sCampo+' inv?lido(a).');
  end;

end;

end.
