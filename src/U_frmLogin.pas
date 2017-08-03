unit U_frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls, Crypto_TLB;

type
  TfrmLogin = class(TForm)
    LOGIN: TLabeledEdit;
    PASS: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    STATUS: TStatusBar;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses U_DM;

procedure TfrmLogin.BitBtn1Click(Sender: TObject);
var
  Crypt: ICrypto;
begin
  with DM.aqyUsuarios do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select id,nome,administrador,senha_entrada from Usuarios where nome=' + CHAR(39) + LOGIN.Text + CHAR(39));
      Open;
      if(RecordCount=0)
        then
          begin
            STATUS.Panels[0].Text:= 'Usuário ou senha inválidos.';
            LOGIN.SetFocus;
            LOGIN.SelectAll;
            PASS.Clear;
          end
        else
          begin
            Crypt:= CoModuloCriptografia.Create();
            if((PASS.Text= Crypt.DecryptData(FieldByName('senha_entrada').Text,'SecAcesso')){and(FieldByName('administrador').Value=1)})
              then
                begin
                  ModalResult:= mrOk;
                  User.id:= FieldByName('id').Value;
                  User.nome:= FieldByName('nome').Value;
                end
              else
                begin
                  STATUS.Panels[0].Text:= 'Usuário ou senha inválidos.';
                  LOGIN.SetFocus;
                  LOGIN.SelectAll;
                  PASS.Clear;
                end;
            Crypt:= nil;
          end;
    end;
end;

end.
