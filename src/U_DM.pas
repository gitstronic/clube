unit U_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,Crypto_TLB;

type TUser = record
  id: Integer;
  nome: String;
end;

type
  TDM = class(TDataModule)
    adoConexao: TADOConnection;
    aqyUsuarios: TADOQuery;
    aqyUsuariosnome: TStringField;
    aqyUsuariosadministrador: TBooleanField;
    aqyUsuariossenha_entrada: TStringField;
    aqyUsuariosid: TAutoIncField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;
  User: TUser;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
