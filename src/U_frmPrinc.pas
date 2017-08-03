unit U_frmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.ActnList;

type
  TfrmPrinc = class(TForm)
    DSaldos: TDataSource;
    DContaDebito: TDataSource;
    DContaCredito: TDataSource;
    GB: TGroupBox;
    GroupBox2: TGroupBox;
    lblCDeb: TLabel;
    lblCCred: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    dblContaDebito: TDBLookupComboBox;
    dblContaCredito: TDBLookupComboBox;
    btnTransaction: TBitBtn;
    edtValor: TEdit;
    GroupBox3: TGroupBox;
    ledSaldoDebito: TLabeledEdit;
    ledSaldoCredito: TLabeledEdit;
    DBGrid1: TDBGrid;
    btnAtSaldo: TBitBtn;
    acnAtalhos: TActionList;
    acnAtualizaSaldo: TAction;
    procedure btnTransactionClick(Sender: TObject);
    procedure RefreshTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorEnter(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnAtSaldoClick(Sender: TObject);
    procedure acnAtualizaSaldoExecute(Sender: TObject);
  private
    { Private declarations }
    procedure EfetuarTransacao(ContaDebito,ContaCredito: integer; Valor: String);
    procedure AtualizaSaldo;
    function FNumD(Texto, VKey: String; Espaco, Decimal: Integer): String;
    function GetSaldo(id: integer): Real;
    function GetEmpresaId(dbl : TDBLookupCombobox): integer;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

{$R *.dfm}

uses U_DM;

procedure TfrmPrinc.acnAtualizaSaldoExecute(Sender: TObject);
begin
  btnAtSaldo.Click;
end;

procedure TfrmPrinc.AtualizaSaldo;
begin
  with DM.aqySaldos do
    begin
      Close;
      Open;
    end;
  with Dm.aqyContaDebito do
    begin
      Close;
      Open;
    end;
  with DM.aqyContaCredito do
    begin
      Close;
      Open;
    end;
end;

procedure TfrmPrinc.btnAtSaldoClick(Sender: TObject);
begin
  AtualizaSaldo;
end;

procedure TfrmPrinc.btnTransactionClick(Sender: TObject);
begin
  if(Application.MessageBox(PChar('Deseja realmente transferir ' + Trim(edtValor.Text) + ' da Conta:"'
    + dblContaDebito.Text + '" para a Conta: "' + dblContaCredito.Text
    + '"? Essa operação não poderá ser desfeita.'),'Aviso!',MB_ICONWARNING + MB_YESNO)=IdYes)
    then
      begin
        EfetuarTransacao(dblContaDebito.KeyValue,dblContaCredito.KeyValue,edtValor.Text);
        AtualizaSaldo;
      end;
end;

procedure TfrmPrinc.edtValorEnter(Sender: TObject);
begin
  btnTransaction.Default:= False;
end;

procedure TfrmPrinc.edtValorExit(Sender: TObject);
var
  valStr: String;
begin
  btnTransaction.Default:= True;
  valStr:= Copy(edtValor.Text,4,Length(edtValor.Text));
  valStr:= StringReplace(valStr,'.','',[rfReplaceAll, rfIgnoreCase]);
  if(valStr<>'')
    then
      begin
        ledSaldoDebito.Text:= Format('%m',[GetSaldo(dblContaDebito.KeyValue) - StrToFloat(valStr)]);
        ledSaldoCredito.Text:= Format('%m',[GetSaldo(dblContaCredito.KeyValue) + StrToFloat(valStr)]);
      end;
end;

procedure TfrmPrinc.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if pos('R$',edtValor.Text) > 0
    then edtValor.Clear;
  if key = #13
    then
      begin
        edtValor.text := Trim(format('%20s',['R$ '+ Trim(edtValor.text)]));
        btnTransaction.Default:= True;
        btnTransaction.SetFocus;
        exit;
      end;
  if not (key in ['0'..'9',',', #8])
    then key := #0
  else edtvalor.Text:= FNumD(Trim(edtValor.text),key,20,2);
end;

procedure TfrmPrinc.EfetuarTransacao(ContaDebito, ContaCredito: integer; Valor: String);
var
  valStr: String;
  valFloat: Real;
  id_conta: integer;
begin
  if(ContaDebito=ContaCredito)
    then Application.MessageBox('Não é possível realizar uma transação para a mesma conta de origem e destino!','Erro na transação!',MB_ICONERROR + MB_OK)
    else
      begin
        valStr:= Trim(Copy(Valor,3,Length(Valor)));
        valStr:= StringReplace(valStr,'.','',[rfReplaceAll, rfIgnoreCase]);
        try
          if(valStr='')
            then
              begin
                Application.MessageBox('Insira um valor para efetuar a transação!','Erro na transação!',MB_ICONERROR + MB_OK);
                edtValor.SelectAll;
              end
            else
              begin
                valFloat:= StrToFloat(valStr);
                //Transação inicia aqui
                with DM.aqyContasPagar do
                  begin
                    Open;
                    Insert;
                    FieldByName('empresa_id').Value:= GetEmpresaId(dblContaCredito);
                    FieldByName('observacao').Value:= 'Transferência para Conta:' + dblContaCredito.Text;
                    FieldByName('previsao_data').Value:= now;
                    FieldByName('previsao_valor').Value:= valFloat;
                    FieldByName('pagto_tipo').Value:= 0;
                    FieldByName('valor_total').Value:= valFloat;
                    FieldByName('vencimento').Value:= now;
                    FieldByName('conta_corrente_id').Value:= dblContaDebito.KeyValue;
                    FieldByName('alteracao_usu_id').Value:= User.id;
                    FieldByName('alteracao_data').Value:= now;
                    Post;
                  end;
                with DM.aqyContasReceber do
                  begin
                    Open;
                    Insert;
                    FieldByName('pessoa_id').Value:= 1485;
                    FieldByName('vencimento').Value:= now;
                    FieldByName('valor').Value:= valFloat;
                    FieldByName('observacao').Value:= ' Transferência da Conta:' + dblContaDebito.Text;
                    FieldByName('quitado').Value:= True;
                    FieldByName('alteracao_usu_id').Value:= User.id;
                    FieldByName('alteracao_data').Value:= now;
                    Post;
                    Last;
                    id_conta:= FieldByName('id').Value;
                  end;
                with DM.aqyContasReceberPagtos do
                  begin
                    Open;
                    Insert;
                    FieldByName('conta_receber_id').Value:= id_conta;
                    FieldByName('pagto_data').Value:= now;
                    FieldByName('pagto_valor').Value:= valFloat;
                    FieldByName('pagto_tipo').Value:= 0;
                    FieldByName('conta_corrente_id').Value:= dblContaCredito.KeyValue;
                    FieldByName('alteracao_usu_id').Value:= User.id;
                    FieldByName('alteracao_data').Value:= now;
                    Post;
                  end;
                Application.MessageBox('Operação realizada com êxito!','Sucesso na transação!',MB_ICONINFORMATION + MB_OK);
                //Transação termina aqui
                edtValor.Text:= 'R$';
                ledSaldoDebito.Text:= '';
                ledSaldoCredito.Text:= '';
              end;
        except
          On E: Exception do
            begin
              Application.MessageBox(PChar('Ocorreu um durante a transação. Detalhes do erro:'
                + #13 + 'Classe do Erro: ' + E.ClassName + #13 + 'Mensagem: ' + E.Message
                ),'Erro na transação!',MB_ICONERROR + MB_OK);
            end;
        end;
      end;
end;

function TfrmPrinc.FNUMD(Texto, VKey: String; Espaco,
  Decimal: Integer): String;
Var
  vChar, vDiv : String;
  I : Integer;
begin
  vDiv := '1';
  For I := 1 to Decimal do
    vDiv := vDiv + '0';
  if(VKey=#8)
    then
      begin
        vChar := copy(Texto,1,length(Texto)-1);

        while ( pos( ',', vChar ) > 0 ) or ( pos( '.', vChar ) > 0 ) do
          begin
            Delete( vChar, pos( '.', vChar ), 1 );
            Delete( vChar, pos( ',', vChar ), 1 );
          end;
        Result:= Trim(Format('%*.*n',[Espaco,Decimal,StrToFloat(vchar)/StrToInt(vDiv)]));
      end
    else
      begin
        vChar := copy(Texto,1,length(Texto));

        if (vchar = '') or (vchar = '0')
          then vchar := vkey
          else vchar := vchar + vkey;

        while ( pos( ',', vChar ) > 0 ) or ( pos( '.', vChar ) > 0 ) do
          begin
            Delete( vChar, pos( '.', vChar ), 1 );
            Delete( vChar, pos( ',', vChar ), 1 );
          end;
        Result:= Format('%*.*n',[Espaco,Decimal,StrToFloat(vchar)/StrToInt(vDiv)]);
      end;
end;

procedure TfrmPrinc.FormActivate(Sender: TObject);
begin
  GB.Left:= (frmPrinc.Width - GB.Width) div 2;
  GB.Top:= 0;
end;

procedure TfrmPrinc.FormResize(Sender: TObject);
begin
  GB.Left:= (frmPrinc.Width - GB.Width) div 2;
  GB.Top:= 0;
end;

procedure TfrmPrinc.FormShow(Sender: TObject);
begin
  with DM.aqySaldos do
    begin
      Open;
      First;
    end;
  DM.aqySaldosSaldo.currency:= True;
  with DM.aqyContaDebito do
    begin
      Open;
      First;
      dblContaDebito.KeyValue:= FieldByName('id').Value;
    end;
  with DM.aqyContaCredito do
    begin
      Open;
      First;
      dblContaCredito.KeyValue:= FieldByName('id').Value;
    end;
  dblContaDebito.SetFocus;
end;

function TfrmPrinc.GetSaldo(id: integer): Real;
begin
  with DM.aqySaldos do
    begin
      Filtered:= False;
      Filter:= 'id=' + IntToStr(id);
      Filtered:= True;
      Result:= StrToFloat(Trim(FieldByName('Saldo').Text));
      Filtered:= False;
    end;
end;

function TfrmPrinc.GetEmpresaId(dbl: TDBLookupCombobox): integer;
begin
  with DM.aqyEmpresas do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select id,nome,obs,criacao_usu_id,criacao_data from empresas where obs=' + IntToStr(dbl.KeyValue));
      Open;
      if(RecordCount=1)
        then Result:= FieldByName('id').Value
        else
          begin
            if(RecordCount>1)
              then Application.MessageBox('Entradas duplicadas encontradas. Contate o suporte do sistema pelo Email: suporte@registronictec.com.br ou Fone: (34) 3255-6464.','Erro na transação!',MB_ICONERROR + MB_OK)
              else
                begin
                  Insert;
                  FieldByName('nome').Value:= 'Transferência para Conta:' + dbl.Text;
                  FieldByName('obs').Value:= IntToStr(dbl.KeyValue);
                  FieldByName('criacao_usu_id').Value:= User.id;
                  FieldByName('criacao_data').Value:= now;
                  Post;
                  Last;
                  Result:= FieldByName('id').Value;
                end;
          end;
    end;
end;

procedure TfrmPrinc.RefreshTimer(Sender: TObject);
begin
  with DM.aqySaldos do
    begin
      Close;
      Open;
    end;
  with DM.aqyContaDebito do
    begin
      Close;
      Open;
    end;
  with DM.aqyContaCredito do
    begin
      Close;
      Open;
    end;
end;

end.
