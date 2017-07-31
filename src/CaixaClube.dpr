program CaixaClube;

uses
  Vcl.Forms,
  Vcl.Controls,
  U_frmPrinc in 'U_frmPrinc.pas' {frmPrinc},
  U_frmSplash in 'U_frmSplash.pas' {frmSplash},
  U_frmLogin in 'U_frmLogin.pas' {frmLogin},
  U_DM in 'U_DM.pas' {DM: TDataModule},
  Utils in '..\..\Common Files\Utils.pas',
  Crypto_TLB in 'C:\Users\Projetos\Documents\RAD Studio\9.0\Imports\Crypto_TLB.pas',
  mscorlib_TLB in 'C:\Users\Projetos\Documents\RAD Studio\9.0\Imports\mscorlib_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title:= 'Caixa Clube';
  Application.Hint:= Application.Title;
  Application.CreateForm(TDM,DM);
  frmSplash:= TfrmSplash.Create(Application);
  if(frmSplash.ShowModal=mrOk)
    then
      begin
        Application.CreateForm(TfrmLogin,frmLogin);
        if(frmLogin.ShowModal=mrOk)
          then
            begin
              frmLogin.Free;
              Application.CreateForm(TfrmPrinc,frmPrinc);
              frmSplash.Free;
              Application.Run;
            end
          else Application.Terminate;
      end
    else Application.Terminate;
end.
