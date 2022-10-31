program Projeto;

uses
  Vcl.Forms,
  uPedido in 'View\uPedido.pas' {formPedido},
  controleBase in 'Controller\controleBase.pas',
  controleCliente in 'Controller\controleCliente.pas',
  classeCliente in 'Model\classeCliente.pas',
  uConexao in 'Controller\dataModule\uConexao.pas' {dmConexao: TDataModule},
  classeProduto in 'Model\classeProduto.pas',
  classePedido in 'Model\classePedido.pas',
  classePedidoProduto in 'Model\classePedidoProduto.pas',
  controleProduto in 'Controller\controleProduto.pas',
  controlePedidoProduto in 'Controller\controlePedidoProduto.pas',
  controlePedido in 'Controller\controlePedido.pas',
  uPedidoProduto in 'View\uPedidoProduto.pas' {formPedidoProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TformPedido, formPedido);
  Application.CreateForm(TformPedidoProduto, formPedidoProduto);
  Application.Run;
end.
