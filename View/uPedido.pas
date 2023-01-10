unit uPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  controlePedido, classePedido, classeProduto, controleCliente, classeCliente, classePedidoProduto, uConexao,
  Vcl.Grids, Vcl.Mask, Vcl.ExtCtrls, inifiles;

type
  TformPedido = class(TForm)
    pan_pedido: TPanel;
    Label1: TLabel;
    btnAbrirPedido: TButton;
    Label2: TLabel;
    msk_data_emissao: TMaskEdit;
    Label3: TLabel;
    sta_cliente_nome: TStaticText;
    GroupBox1: TGroupBox;
    gri_produtos: TStringGrid;
    Panel2: TPanel;
    btnAdiciona: TButton;
    btnAtualizar: TButton;
    btnExcluir: TButton;
    Panel3: TPanel;
    Label4: TLabel;
    edt_total_geral: TEdit;
    Panel1: TPanel;
    Panel4: TPanel;
    btnSalvar: TButton;
    btnLimpar: TButton;
    edt_codigo_cliente: TEdit;
    edt_numero_pedido: TEdit;
    btnCancelarPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAbrirPedidoClick(Sender: TObject);
    procedure btnAdicionaClick(Sender: TObject);
    procedure msk_data_emissaoExit(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure gri_produtosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_codigo_clienteKeyPress(Sender: TObject; var Key: Char);
    procedure edt_numero_pedidoKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure edt_codigo_clienteExit(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure edt_codigo_clienteKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edt_numero_pedidoExit(Sender: TObject);
    procedure gri_produtosKeyPress(Sender: TObject; var Key: Char);
  private
    objetoPedido : TPedido;
    controlePedido : TControlePedido;
    controleCliente : TControleCliente;
    NovoID : integer;
    objetoCliente : TCliente;
    objetoProduto : TProduto;
    arquivoConfig : TIniFile;
    function DataOk ( sData : string ) : boolean;
    function ValorOk (sValor, sCampo : string) : boolean;
    procedure limpaCampos;
    procedure limpaObjetos;
    procedure dadosGrid;
    function pastaSis : string; //recupera pasta do sistema
  public
    { Public declarations }
  end;

var
  formPedido: TformPedido;

implementation

{$R *.dfm}

uses uPedidoProduto, uInformePedido;
procedure TformPedido.btnAbrirPedidoClick(Sender: TObject);
var
  strNumeroPedido : string;
begin
  try
    with formInformePedido do
    begin
      formInformePedido:= TformInformePedido.Create(Self);
      Caption := 'Abrir Pedido';
      ShowModal;
      if ModalResult = mrOk then
      begin
          strNumeroPedido := edt_numero_pedido.text;
      end;
    end;
  finally
    if Assigned(formInformePedido) then
       formInformePedido.Destroy;
  end;  
  if strNumeroPedido = '' then
    Abort;
  if ValorOk(strNumeroPedido,'Número do pedido') then
  begin
      objetoPedido.NumeroPedido := StrToInt(strNumeroPedido);
      //Define o número do pedido e tenta carregar os dados
      objetoPedido := controlePedido.Select(objetoPedido);
      if objetoPedido.NumeroPedido > 0  then
      begin
          limpaCampos;
          edt_numero_pedido.text := formatfloat('000000000',objetoPedido.NumeroPedido);
          msk_data_emissao.text := FormatDateTime('dd/mm/yyyy',objetoPedido.DataEmissao);
          edt_codigo_cliente.text := IntToStr(objetoPedido.CodigoCliente);
          sta_cliente_nome.Caption := objetoPedido.Cliente.Nome;
          gri_produtos.RowCount := objetoPedido.Produtos.Count+1;
          dadosGrid;
          edt_total_geral.text := formatfloat('0.00',objetoPedido.ValorTotal);
          if edt_codigo_cliente.Text = '' then
          begin
            btnAbrirPedido.Visible := true;
            btnCancelarPedido.Visible := true;
          end else
          begin
            btnAbrirPedido.Visible := false;
            btnCancelarPedido.Visible := false;
          end;
      end else
      begin
        application.MessageBox('Pedido não encontrado','ERRO',Mb_Ok+MB_ICONEXCLAMATION);
        limpaCampos;
        limpaObjetos;
        edt_numero_pedido.SetFocus;
      end;
  end;

end;

procedure TformPedido.btnAdicionaClick(Sender: TObject);
begin
  try
    with formPedidoProduto do
    begin
      formPedidoProduto:= TformPedidoProduto.Create(Self);
      ShowModal;

      if ModalResult = mrOk then
      begin
          objetoPedido.Produtos.Add(objetoPedidoProduto);
          gri_produtos.RowCount := objetoPedido.Produtos.Count + 1;
          dadosGrid;
      end;
    end;
  finally
    if Assigned(formPedidoProduto) then
       formPedidoProduto.Destroy;
  end;
end;

procedure TformPedido.btnAtualizarClick(Sender: TObject);
var
  item : integer;
begin
  try
    item := StrToInt(gri_produtos.Cells[0,gri_produtos.row])-1;
  except
    Application.MessageBox('Nenhum produto para atualizar','AVISO',Mb_Ok+Mb_IconExclamation);
    Abort;
  end;
  try
    with formPedidoProduto do
    begin
      formPedidoProduto:= TformPedidoProduto.Create(Self);
      formPedidoProduto.objetoPedidoProduto := objetoPedido.Produtos.Items[item];
      edt_codigo_produto.text := formatfloat('000000000',objetoPedidoProduto.CodigoProduto);
      edt_codigo_produto.Enabled := false;
      sta_produto_nome.Caption := objetoPedidoProduto.Produto.Descricao;
      edt_quantidade.Text := formatfloat('0.00',objetoPedidoProduto.Quantidade);
      edt_valor_unitario.Text := formatfloat('0.00',objetoPedidoProduto.ValorUnitario);
      edt_valor_total.text := formatfloat('0.00',objetoPedidoProduto.ValorTotal);
      ShowModal;
      if ModalResult = mrOk then
      begin
          objetoPedido.Produtos.Items[item] := objetoPedidoProduto;
          dadosGrid;
      end;
    end;
  finally
    if Assigned(formPedidoProduto) then
       formPedidoProduto.Destroy;
  end;
end;

procedure TformPedido.btnCancelarPedidoClick(Sender: TObject);
var
  strNumeroPedido : string;
begin
  try
    with formInformePedido do
    begin
      formInformePedido:= TformInformePedido.Create(Self);
      Caption := 'Cancelar Pedido';
      ShowModal;
      if ModalResult = mrOk then
      begin
          strNumeroPedido := edt_numero_pedido.text;
      end;
    end;
  finally
    if Assigned(formInformePedido) then
       formInformePedido.Destroy;
  end;  
  if strNumeroPedido = '' then
    Abort;
  if ValorOk(strNumeroPedido,'Número do pedido') then
  begin
      objetoPedido.NumeroPedido := StrToInt(strNumeroPedido);
      //Define o número do pedido e tenta carregar os dados
      objetoPedido := controlePedido.Select(objetoPedido);
      if objetoPedido.NumeroPedido > 0  then
      begin
        if Application.MessageBox(pchar('Confirma o cancelamento do pedido: '+FormatFloat('000000000',objetoPedido.NumeroPedido)+' ?'),'AVISO',Mb_YesNo+Mb_IconExclamation) = mrNo then Abort;
        controlePedido.Delete(objetoPedido);
        application.MessageBox('Pedido cancelado com sucesso','AVISO',Mb_OK+MB_ICONINFORMATION);
        limpaObjetos;
      end else
      begin
        application.MessageBox('Pedido não encontrado','AVISO',Mb_OK+MB_ICONEXCLAMATION);
      end;
  end;
  limpaCampos;
  limpaObjetos;
end;

procedure TformPedido.btnLimparClick(Sender: TObject);
begin
  btnAbrirPedido.Visible := true;
  btnCancelarPedido.Visible := true;
  limpaCampos;
  limpaObjetos;
  edt_numero_pedido.SetFocus;
end;

procedure TformPedido.btnExcluirClick(Sender: TObject);
var
  item : integer;
begin
  try
    item := StrToInt(gri_produtos.Cells[0,gri_produtos.row])-1;
  except
    Application.MessageBox('Nenhum produto para excluir','AVISO',Mb_Ok+Mb_IconExclamation);
    Abort;
  end;
  if Application.MessageBox(pchar('Confirma exclusão do produto: '+gri_produtos.Cells[2,gri_produtos.row]),'AVISO',Mb_YesNo+Mb_IconExclamation) = mrNo then Abort;
  //Apaga o item selecionado do grid
  //Ajust o grid
  if gri_produtos.RowCount > 2 then
    gri_produtos.RowCount := gri_produtos.RowCount - 1;
  objetoPedido.Produtos.Delete(item);
  dadosGrid;
end;

procedure TformPedido.btnSalvarClick(Sender: TObject);
begin
  //Verifica se esta alterando um pedido(numero_pedido encontrado no banco) ou salvando um novo 
    if (objetoPedido.NumeroPedido = 0) then
    begin
        if StrToInt(edt_numero_pedido.Text) <> NovoID then
        begin
          raise Exception.Create('Número do pedido fora de sequencia');
        end;
        objetoPedido.NumeroPedido := NovoID;
        objetoPedido := controlePedido.Insert(objetoPedido);
        if objetoPedido.NumeroPedido > 0 then
        begin
          application.MessageBox(Pchar('Pedido nr: '+formatfloat('000000000',objetoPedido.NumeroPedido)+' salvo com sucesso!'),'AVISO',Mb_Ok+MB_ICONINFORMATION);
        end;
        limpaCampos;
        limpaObjetos;
        edt_numero_pedido.SetFocus;
        btnAbrirPedido.Visible := true;
        btnCancelarPedido.Visible := true;    
    end else
    begin
        if controlePedido.Update(objetoPedido) then
        begin
          application.MessageBox(Pchar('Pedido nr: '+formatfloat('000000000',objetoPedido.NumeroPedido)+' atualizado com sucesso!'),'AVISO',Mb_Ok+MB_ICONINFORMATION);
          limpaCampos;
          limpaObjetos;
          edt_numero_pedido.SetFocus;
          btnAbrirPedido.Visible := true;
          btnCancelarPedido.Visible := true;
        end;
  end;
end;

procedure TformPedido.dadosGrid;
var
i : integer;
begin
  gri_produtos.Cells[0,1] := '';
  gri_produtos.Cells[1,1] := '';
  gri_produtos.Cells[2,1] := '';
  gri_produtos.Cells[3,1] := '';
  gri_produtos.Cells[4,1] := '';
  gri_produtos.Cells[5,1] := '';

  for i := 0 to objetoPedido.Produtos.count -1 do
  begin
      gri_produtos.Cells[0,i+1] := IntToStr(i+1);
      gri_produtos.Cells[1,i+1] := IntToStr(TPedidoProduto(objetoPedido.Produtos.items[i]).Produto.Codigo);
      gri_produtos.Cells[2,i+1] := TPedidoProduto(objetoPedido.Produtos.items[i]).Produto.Descricao;
      gri_produtos.Cells[3,i+1] := FormatFloat('0.00',TPedidoProduto(objetoPedido.Produtos.items[i]).Quantidade);
      gri_produtos.Cells[4,i+1] := FormatFloat('0.00',TPedidoProduto(objetoPedido.Produtos.items[i]).ValorUnitario);
      gri_produtos.Cells[5,i+1] := FormatFloat('0.00',TPedidoProduto(objetoPedido.Produtos.items[i]).ValorTotal);
  end;
  edt_total_geral.text := formatfloat('0.00',objetoPedido.ValorTotal);

end;

function TformPedido.DataOk(sData: string): boolean;
//Verifica se a data está ok retornando verdadeiro ou falso
var
  testeData : TDate;
begin
  result := false;
  try
    testeData := StrToDate(Trim(msk_data_emissao.text));
    result := true;
  except
    result := false;
    raise Exception.Create('Data inválida.');
  end;
end;

procedure TformPedido.edt_codigo_clienteExit(Sender: TObject);
var
  sCodigo : string;
begin
  sCodigo := edt_codigo_cliente.Text;
  sCodigo := Trim(sCodigo);
  if sCodigo <> '' then
  begin
      if ValorOk(sCodigo,'Número do pedido') then
      begin
          objetoCliente.Codigo := StrToInt(sCodigo);
          try
              objetoCliente := controleCliente.Select(objetoCliente);
          except
              on e:exception do
              begin
                application.MessageBox(Pchar(e.Message),'ERRO',Mb_Ok+MB_ICONEXCLAMATION);
              end;
          end;
          if objetoCliente.Codigo = 0 then
          begin
              edt_codigo_cliente.text := '';
              sta_cliente_nome.Caption := '';
          end else
          begin
              objetoPedido.CodigoCliente := objetoCliente.Codigo;
              objetoPedido.Cliente := objetoCliente;
              sta_cliente_nome.Caption := objetoCliente.Nome;
              edt_codigo_cliente.Text := formatfloat('000000000',objetoCliente.Codigo);
          end;
      end;
  end;
end;

procedure TformPedido.edt_codigo_clienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9', #8, #9])) then Key := #0;
end;

procedure TformPedido.edt_codigo_clienteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sTexto : string;
begin
  sTexto := '';
  sTexto := edt_codigo_cliente.text;
  sTexto := Trim(sTexto);
  if sTexto = '' then
  begin
    btnAbrirPedido.Visible := true;
    btnCancelarPedido.Visible := true;
  end else
  begin
    btnAbrirPedido.Visible := false;
    btnCancelarPedido.Visible := false;
  end;
end;

procedure TformPedido.edt_numero_pedidoExit(Sender: TObject);
var
  i : integer;
begin
  try
    i := StrToInt(edt_numero_pedido.text);
  except
    Application.MessageBox('Número do pedido inválido','ERRO',Mb_Ok+Mb_IconExclamation);
    i := NovoID;
  end;
  edt_numero_pedido.text := formatfloat('00000000',i);  
end;

procedure TformPedido.edt_numero_pedidoKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9', #8, #9])) then Key := #0;
end;

procedure TformPedido.limpaCampos;
begin
  NovoID := controlePedido.GerarNumeroPedido;
  edt_numero_pedido.text := formatfloat('00000000',NovoID);
  
  msk_data_emissao.text := '';
  edt_codigo_cliente.text := '';
  sta_cliente_nome.Caption := '';
  edt_total_geral.text := 'R$ 0,00';
  gri_produtos.RowCount := 2;
  with gri_produtos do
  begin
    Cells[0,0] := 'Item';
    Cells[1,0] := 'Cód. Produto';
    Cells[2,0] := 'Produto';
    Cells[3,0] := 'Quant.';
    Cells[4,0] := 'Vlr Unit.';
    Cells[5,0] := 'Vlr Total';
    Cells[0,1] := '';
    Cells[1,1] := '';
    Cells[2,1] := '';
    Cells[3,1] := '';
    Cells[4,1] := '';
    Cells[5,1] := '';
  end;
end;

procedure TformPedido.limpaObjetos;
begin
  objetoPedido := TPedido.New;
  objetoCliente:= TCliente.New;
  objetoProduto:= TProduto.New;
  controlePedido :=  TControlePedido.Create(dmConexao.conexao);
  controleCliente := TControleCliente.Create(dmConexao.conexao);
end;

procedure TformPedido.msk_data_emissaoExit(Sender: TObject);
begin
  try
    if DataOk(msk_data_emissao.edittext) = false then
      msk_data_emissao.text := ''
    else
      objetoPedido.DataEmissao := StrToDate(msk_data_emissao.EditText);
  except
    on e:exception do
    begin
      msk_data_emissao.text := '';
      application.MessageBox('Data inválida.','ERRO',Mb_ok+MB_ICONEXCLAMATION);
    end;
  end;
end;

function TformPedido.pastaSis : string;
begin
  result := extractfilepath(application.exename);
end;

function TformPedido.ValorOk(sValor, sCampo: string): boolean;
var
  testeValor : double;
begin
  result := false;
  try
    testeValor := StrToFloat(Trim(sValor));
    result := true;
  except
    result := false;
    raise Exception.Create(sCampo + ' inválido(a).');
  end;

end;

procedure TformPedido.FormCreate(Sender: TObject);
var
  fDriverId, fServer, fPort, fUseSSL, fDatabase, fUser_name, fPassword : string;
begin

  //Verifica se existe arquivo de configuração do sistema e pergunta se quer resetar

  //Caso não exista solicita ao usuário o cadastro das informações
  arquivoConfig := TIniFile.Create(pastaSis+'\config.ini');
  if (fileexists(pastaSis+'\config.ini')) then
  begin
    with arquivoConfig do
    begin
        //Verifica campo DriverID do arquivo .ini
        fDriverid := ReadString('CONFIG','DriverID','');
        while (fDriverId = '') do
        begin
          fDriverID := InputBox('Configuração: DriverID','DriverID: ','MySQL');
          WriteString('CONFIG','DriverID',fDriverID);
        end;
        //Verifica campo Server do arquivo .ini
        fServer := ReadString('CONFIG','Server','');
        while (fServer = '') do
        begin
          fServer := InputBox('Configuração: Server','Server: ','localhost');
          WriteString('CONFIG','Server',fServer);
        end;
        //Vericia campo Port do arquivo .ini
        fPort := ReadString('CONFIG','Port','');
        while (fPort = '') do
        begin
          fPort := InputBox('Configuração: Port','Port: ','3306');
          WriteString('CONFIG','Port',fPort);
        end;
        //Verifica campo UseSSL do arquivo .ini
        fUseSSL := ReadString('CONFIG','UseSSL','');
        while (fUseSSL = '') do
        begin
          fUseSSL := InputBox('Configuração: UseSSL','UseSSL: ','True');
          WriteString('CONFIG','UseSSL',fUseSSL);
        end;
        //Verifica campo Database do arquivo .ini
        fDatabase := ReadString('CONFIG','Database','');
        while (fDatabase = '') do
        begin
          fDatabase := InputBox('Configuração: Database','Database: ','venda');
          WriteString('CONFIG','Database',fDatabase);
        end;
        //Verifica campo User_name do arquivo .ini
        fUser_name := ReadString('CONFIG','User_name','');
        while (fUser_name = '') do
        begin
          fUser_name := InputBox('Configuração: User_name','User_name: ','root');
          WriteString('CONFIG','User_name',fUser_name);
        end;
        //Verifica campo Password do arquivo .ini
        fPassword := ReadString('CONFIG','Password','');
        while (fPassword = '') do
        begin
          fPassword := InputBox('Configuração: Password','Password: ','1234');
          WriteString('CONFIG','Password',fPassword);
        end;
    end;
  end else
  begin
    with arquivoConfig do
    begin

      //Verifica campo DriverID do arquivo .ini
      fDriverid := ReadString('CONFIG','DriverID','');
      while (fDriverId = '') do
      begin
        fDriverID := InputBox('Configuração: DriverID','DriverID: ','MySQL');
        WriteString('CONFIG','DriverID',fDriverID);
      end;
      //Verifica campo Server do arquivo .ini
      fServer := ReadString('CONFIG','Server','');
      while (fServer = '') do
      begin
        fServer := InputBox('Configuração: Server','Server: ','localhost');
        WriteString('CONFIG','Server',fServer);
      end;
      //Vericia campo Port do arquivo .ini
      fPort := ReadString('CONFIG','Port','');
      while (fPort = '') do
      begin
        fPort := InputBox('Configuração: Port','Port: ','3306');
        WriteString('CONFIG','Port',fPort);
      end;
      //Verifica campo UseSSL do arquivo .ini
      fUseSSL := ReadString('CONFIG','UseSSL','');
      while (fUseSSL = '') do
      begin
        fUseSSL := InputBox('Configuração: UseSSL','UseSSL: ','True');
        WriteString('CONFIG','UseSSL',fUseSSL);
      end;
      //Verifica campo Database do arquivo .ini
      fDatabase := ReadString('CONFIG','Database','');
      while (fDatabase = '') do
      begin
        fDatabase := InputBox('Configuração: Database','Database: ','venda');
        WriteString('CONFIG','Database',fDatabase);
      end;
      //Verifica campo User_name do arquivo .ini
      fUser_name := ReadString('CONFIG','User_name','');
      while (fUser_name = '') do
      begin
        fUser_name := InputBox('Configuração: User_name','User_name: ','root');
        WriteString('CONFIG','User_name',fUser_name);
      end;
      //Verifica campo Password do arquivo .ini
      fPassword := ReadString('CONFIG','Password','');
      while (fPassword = '') do
      begin
        fPassword := InputBox('Configuração: Password','Password: ','1234');
        WriteString('CONFIG','Password',fPassword);
      end;

    end;
  end;

  arquivoConfig.Free;
  try
    with dmConexao.conexao do
    begin
      Params.clear;
      Params.Add('DriverID='+fDriverId);
      Params.Add('Server='+fServer);
      Params.Add('Port='+fPort);
      Params.Add('UseSSL='+fUseSSL);
      Params.Add('Database='+fDatabase);
      Params.Add('User_name='+fUser_name);
      Params.Add('Password='+fPassword);
      Connected := true;
    end;
  except
    //Exceção de erro na configuração do sistema
    application.MessageBox('Erro de conexão com o banco de dados','Erro ao conectar',Mb_Ok+MB_ICONWARNING);
    //Reseta as configurações do sistema
    if application.MessageBox('Resetar as configurações do sistema?','AVISO',Mb_YesNo+MB_ICONEXCLAMATION) = mrYes then
    begin
        deletefile(pastaSis+'\config.ini');
    end;
    application.Terminate;
  end;

  limpaObjetos;
  limpaCampos;
end;

procedure TformPedido.gri_produtosKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    btnAtualizar.Click;    
  end;
end;

procedure TformPedido.gri_produtosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_delete then
  begin
    key := Ord(0);
    btnExcluir.Click;
  end;
  if key = vk_insert then
  begin
    key := Ord(0);
    btnAdiciona.Click;
  end;
end;

end.
