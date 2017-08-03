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
    aqySaldos: TADOQuery;
    aqyContaDebito: TADOQuery;
    aqyContaDebitoid: TAutoIncField;
    aqyContaDebitodescricao: TStringField;
    aqyContaCredito: TADOQuery;
    AutoIncField1: TAutoIncField;
    StringField1: TStringField;
    aqyContasPagar: TADOQuery;
    aqyContasReceberPagtos: TADOQuery;
    aqyContasPagarid: TAutoIncField;
    aqyContasPagarobservacao: TStringField;
    aqyContasPagarprevisao_data: TDateTimeField;
    aqyContasPagarprevisao_valor: TBCDField;
    aqyContasPagarpagto_tipo: TWordField;
    aqyContasPagarvalor_total: TBCDField;
    aqyContasPagarvencimento: TDateTimeField;
    aqyContasPagarconta_corrente_id: TIntegerField;
    aqyContasPagaralteracao_usu_id: TIntegerField;
    aqyContasPagaralteracao_data: TDateTimeField;
    aqyContasReceber: TADOQuery;
    aqyContasReceberid: TAutoIncField;
    aqyContasRecebervencimento: TDateTimeField;
    aqyContasRecebervalor: TBCDField;
    aqyContasReceberobservacao: TStringField;
    aqyContasReceberquitado: TBooleanField;
    aqyContasReceberalteracao_usu_id: TIntegerField;
    aqyContasReceberalteracao_data: TDateTimeField;
    aqyContasReceberPagtosid: TAutoIncField;
    aqyContasReceberPagtosconta_receber_id: TIntegerField;
    aqyContasReceberPagtospagto_data: TDateTimeField;
    aqyContasReceberPagtospagto_valor: TBCDField;
    aqyContasReceberPagtospagto_tipo: TWordField;
    aqyContasReceberPagtosconta_corrente_id: TIntegerField;
    aqyContasReceberPagtosalteracao_usu_id: TIntegerField;
    aqyContasReceberPagtosalteracao_data: TDateTimeField;
    aqySaldosContaCorrente: TStringField;
    aqySaldosSaldo: TFMTBCDField;
    aqyContasReceberpessoa_id: TIntegerField;
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
