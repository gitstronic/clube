unit U_frmSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Crypto_TLB,
  Vcl.StdCtrls;

type TDBInfo = record
  TipoBanco,Servidor,AutenticacaoWindows,Usuario,Senha,NomeBanco: String;
end;

type
  TfrmSplash = class(TForm)
    AppStart: TTimer;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure AppStartTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    DB: TDBInfo;
    function Dir: String;
    function CarregaINISecullum(Arquivo: String): boolean;
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.dfm}

uses U_DM,Utils;

procedure TfrmSplash.AppStartTimer(Sender: TObject);
var
  Crypt: ICrypto;
begin
  AppStart.Enabled:= False;
  Label1.Caption:= 'Versão: ' + VersaoExe(Application.ExeName);
  Application.ProcessMessages;
  if(CarregaINISecullum('conexao_db.ini')) //Carregar Configurações
    then
      begin
        try
          Crypt:= CoModuloCriptografia.Create();
          if(DB.Senha<>'')
            then DB.Senha:= Crypt.DecryptData(DB.Senha,'SecDB');
          with DM.adoConexao do
            begin
              Close;
              ConnectionString:= 'Provider=SQLOLEDB.1;Password=' + DB.Senha + ';Persist Security Info=True;User ID=' + DB.Usuario + ';Initial Catalog=' + DB.NomeBanco + ';Data Source=' + DB.Servidor;
              Connected:= True;
            end;
          frmSplash.ModalResult:=mrOk;
        except
          On E: Exception do
            begin
              Application.MessageBox(PChar('Erro ao conectar com o banco de dados. Contate o suporte técnico. Detalhes do erro: '+ #13 + E.ClassName + #13 + E.Message),PChar(Application.Title + ' - Erro'),MB_ICONERROR + MB_OK);
              ErrorLog(E.ClassName + ' - ' + E.Message);
              Application.Terminate;
            end;
        end;
      end
    else
      begin
        Application.MessageBox(PChar('Arquivo de configurações não encontrado. Contate o suporte técnico.'),PChar(Application.Title + ' - Erro'),MB_ICONERROR + MB_OK);
        Application.Terminate;
      end;
  Crypt:= nil;
end;

function TfrmSplash.CarregaINISecullum(Arquivo: String): boolean;
var
  Conteudo: TStringList;
  I: Integer;
begin
  if(FileExists(Dir + Arquivo))
    then
      begin
        Conteudo:= TStringList.Create;
        Conteudo.LoadFromFile(Dir + Arquivo);
        for I := 0 to Conteudo.Count-1 do
          begin
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='TIPOBANCO')
              then DB.TipoBanco:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='SERVIDOR')
              then DB.Servidor:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='SQLSERVER_AUTENTICACAO_WINDOWS')
              then DB.AutenticacaoWindows:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='USUARIO')
              then DB.Usuario:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='SENHA')
              then DB.Senha:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
            if(Copy(Conteudo[I],1,AnsiPos(':',Conteudo[I])-1)='NOME_BANCO')
              then DB.NomeBanco:= Copy(Conteudo[I],AnsiPos(':',Conteudo[I])+1,Length(Conteudo[I]));
          end;
        Result:= True;
      end
    else Result:= False;
end;

function TfrmSplash.Dir: String;
begin
  Result:= ExtractFilePath(Application.ExeName);
end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  AppStart.Enabled:= True;
end;

end.
