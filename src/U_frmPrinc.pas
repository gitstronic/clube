unit U_frmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.ActnList,
  frxClass, frxDBSet;

type TCfg = record
  Servico,Pessoa: integer;
end;

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
    gbCfg: TGroupBox;
    ledPessoa: TLabeledEdit;
    btnSavePerson: TBitBtn;
    dblServico: TDBLookupComboBox;
    Label3: TLabel;
    lblNome: TLabel;
    DServico: TDataSource;
    acnConfigurar: TAction;
    btnCancel: TBitBtn;
    frxRecibos: TfrxReport;
    frdRecibos: TfrxDBDataset;
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
    procedure btnSavePersonClick(Sender: TObject);
    procedure ledPessoaChange(Sender: TObject);
    procedure acnConfigurarExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    Cfg: TCfg;
    procedure EfetuarTransacao(ContaDebito,ContaCredito: integer; Valor: String);
    procedure AtualizaSaldo;
    function FNumD(Texto, VKey: String; Espaco, Decimal: Integer): String;
    function GetSaldo(id: integer): Real;
    function GetEmpresaId: integer;
    function LoadCfg(Arquivo: String): TCfg;
    procedure SaveCfg(Arquivo: String);
    procedure ImprimirRecibo;
    function ValorExtenso(vlr: real): String;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

{$R *.dfm}

uses U_DM, IniFiles;

procedure TfrmPrinc.acnAtualizaSaldoExecute(Sender: TObject);
begin
  btnAtSaldo.Click;
end;

procedure TfrmPrinc.acnConfigurarExecute(Sender: TObject);
begin
  gbCfg.Visible:= not(gbCfg.Visible);
  if(gbCfg.Visible)
    then
      begin
        with DM.aqyServicos do
          begin
            Close;
            SQL.Clear;
            SQl.Add('select id,descricao from servicos order by descricao');
            Open;
            First;
          end;
        dblServico.KeyValue:= Cfg.Servico;
        with DM.aqyPessoas do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select id,n_identificador,nome from pessoas where id=' + IntToStr(Cfg.Pessoa));
            Open;
            lblNome.Caption:= FieldByName('nome').Value;
            ledPessoa.Text:= FieldByName('n_identificador').Text;
          end;
      end;
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

procedure TfrmPrinc.btnCancelClick(Sender: TObject);
begin
  gbCfg.Visible:= False;
end;

procedure TfrmPrinc.btnSavePersonClick(Sender: TObject);
begin
  Cfg.Servico:= dblServico.KeyValue;
  Cfg.Pessoa:= DM.aqyPessoas.FieldByName('id').Value;
  SaveCFG('CCConfig.ini');
  gbCfg.Visible:= False;
end;

procedure TfrmPrinc.btnTransactionClick(Sender: TObject);
begin
  if(Application.MessageBox(PChar('Deseja realmente transferir ' + Trim(edtValor.Text) + ' da Conta:"'
    + dblContaDebito.Text + '" para a Conta: "' + dblContaCredito.Text
    + '"? Essa opera��o n�o poder� ser desfeita.'),'Aviso!',MB_ICONWARNING + MB_YESNO)=IdYes)
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
    then Application.MessageBox('N�o � poss�vel realizar uma transa��o para a mesma conta de origem e destino!','Erro na transa��o!',MB_ICONERROR + MB_OK)
    else
      begin
        valStr:= Trim(Copy(Valor,3,Length(Valor)));
        valStr:= StringReplace(valStr,'.','',[rfReplaceAll, rfIgnoreCase]);
        try
          if(valStr='')
            then
              begin
                Application.MessageBox('Insira um valor para efetuar a transa��o!','Erro na transa��o!',MB_ICONERROR + MB_OK);
                edtValor.SelectAll;
              end
            else
              begin
                valFloat:= StrToFloat(valStr);
                //Transa��o inicia aqui
                with DM.aqyContasPagar do
                  begin
                    Open;
                    Insert;
                    FieldByName('empresa_id').Value:= GetEmpresaId;
                    FieldByName('observacao').Value:= dblContaCredito.Text;
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
                    FieldByName('servico_id').Value:= Cfg.Servico;
                    FieldByName('pessoa_id').Value:= Cfg.Pessoa;
                    FieldByName('vencimento').Value:= now;
                    FieldByName('valor').Value:= valFloat;
                    FieldByName('observacao').Value:= ' Transfer�ncia da Conta:' + dblContaDebito.Text;
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
                Application.MessageBox('Opera��o realizada com �xito!','Sucesso na transa��o!',MB_ICONINFORMATION + MB_OK);
                with DM.aqyRecibos do
                  begin
                    Open;
                    Insert;
                    FieldByName('valor').Value:= valFloat;
                    FieldByName('conta_origem').Value:= dblContaDebito.KeyValue;
                    FieldByName('conta_destino').Value:= dblContaCredito.KeyValue;
                    FieldByName('data_operacao').Value:= Now;
                    Post;
                    Last;
                  end;
                //Transa��o termina aqui
                if(Application.MessageBox('Imprimir recibo da transa��o?','Confirma��o',MB_ICONQUESTION + MB_YESNO)=IdYes)
                  then
                    begin
                      ImprimirRecibo;
                    end;
                edtValor.Text:= 'R$';
                ledSaldoDebito.Text:= '';
                ledSaldoCredito.Text:= '';
                valFloat:= 0.0;
              end;
        except
          On E: Exception do
            begin
              Application.MessageBox(PChar('Ocorreu um durante a transa��o. Detalhes do erro:'
                + #13 + 'Classe do Erro: ' + E.ClassName + #13 + 'Mensagem: ' + E.Message
                ),'Erro na transa��o!',MB_ICONERROR + MB_OK);
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
  gbCfg.Left:= (frmPrinc.Width - gbCfg.Width) div 2;
end;

procedure TfrmPrinc.FormResize(Sender: TObject);
begin
  GB.Left:= (frmPrinc.Width - GB.Width) div 2;
  GB.Top:= 0;
  gbCfg.Left:= (frmPrinc.Width - gbCfg.Width) div 2;
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
  Cfg:= LoadCFG('CCConfig.ini');
  if((Cfg.Servico=0) or (Cfg.Pessoa=0))
    then
      begin
        Application.MessageBox('Configura��o incompleta, favor configurar as op��es para o funcionamento correto do sistema!','Aviso!',MB_ICONWARNING + MB_OK);
        gbCfg.Visible:= True;
        with DM.aqyServicos do
          begin
            Close;
            SQL.Clear;
            SQl.Add('select id,descricao from servicos order by descricao');
            Open;
            First;
            dblServico.KeyValue:= FieldByName('id').Value;
          end;
      end;
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

procedure TfrmPrinc.ImprimirRecibo;
begin
  with DM.aqyRecibosPrint do
    begin
      Open;
      DM.aqyRecibosPrintvalor.currency:= True;
      Last;
      frxRecibos.ShowReport(True);
      Close;
    end;
end;

procedure TfrmPrinc.ledPessoaChange(Sender: TObject);
begin
  with DM.aqyPessoas do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select top(1) id,n_identificador,nome from pessoas where n_identificador like ' + Char(39) + ledPessoa.Text + '%' + Char(39));
      Open;
      lblNome.Caption:= FieldByName('nome').Text;
    end;
end;

function TfrmPrinc.LoadCfg(Arquivo: String): TCfg;
var
  Ini: TIniFile;
  Archive: String;
  Gone: TCfg;
begin
  Archive:= ExtractFilePath(Application.ExeName) + Arquivo;
  if(FileExists(Archive))
    then
      begin
        Ini:= TIniFile.Create(Archive);
        Gone.Servico:= Ini.ReadInteger('RECEBER','SERVICO',0);
        Gone.Pessoa:= Ini.ReadInteger('RECEBER','PESSOA',0);
        Result:= Gone;
      end
    else
      begin
        Gone.Servico:= 0;
        Gone.Pessoa:= 0;
        Result:= Gone;
      end;
end;

function TfrmPrinc.GetEmpresaId: integer;
begin
  with DM.aqyEmpresas do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select id,nome,obs,criacao_usu_id,criacao_data from empresas where obs=1');
      Open;
      if(RecordCount=1)
        then Result:= FieldByName('id').Value
        else
          begin
            if(RecordCount>1)
              then Application.MessageBox('Entradas duplicadas encontradas. Contate o suporte do sistema pelo Email: suporte@registronictec.com.br ou Fone: (34) 3255-6464.','Erro na transa��o!',MB_ICONERROR + MB_OK)
              else
                begin
                  Insert;
                  FieldByName('nome').Value:= 'Transfer�ncia para Conta';
                  FieldByName('obs').Value:= 1;
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

procedure TfrmPrinc.SaveCfg(Arquivo: String);
var
  Ini: TIniFile;
  Archive: String;
  Gone: TCfg;
begin
  Archive:= ExtractFilePath(Application.ExeName) + Arquivo;
  Ini:= TIniFile.Create(Archive);
  Ini.WriteInteger('RECEBER','SERVICO',Cfg.Servico);
  Ini.WriteInteger('RECEBER','PESSOA',Cfg.Pessoa);
  Ini.UpdateFile;
  Ini.Free;
end;

function TfrmPrinc.ValorExtenso(vlr: real): String;
const
  unidade: array[1..19] of string = ('um', 'dois', 'tr�s', 'quatro', 'cinco',
             'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
             'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
             'dezessete', 'dezoito', 'dezenove');
  centena: array[1..9] of string = ('cento', 'duzentos', 'trezentos',
             'quatrocentos', 'quinhentos', 'seiscentos',
             'setecentos', 'oitocentos', 'novecentos');
  dezena: array[2..9] of string = ('vinte', 'trinta', 'quarenta', 'cinquenta',
             'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array[0..4] of string = ('', 'mil', 'milh�o', 'bilh�o', 'trilh�o');
  qualificaP: array[0..4] of string = ('', 'mil', 'milh�es', 'bilh�es', 'trilh�es');
var
  inteiro: Int64;
  resto: real;
  vlrS, s, saux, vlrP, centavos: string;
  n, unid, dez, cent, tam, i: integer;
  umReal, tem: boolean;
begin
  if (vlr = 0)
    then
      begin
        Result := 'zero';
        exit;
      end;

  inteiro := trunc(vlr); // parte inteira do valor
  resto := vlr - inteiro; // parte fracion�ria do valor
  vlrS := inttostr(inteiro);
  if (length(vlrS) > 15)
    then
      begin
        Result := 'Erro: valor superior a 999 trilh�es.';
        exit;
      end;

  s := '';
  centavos := inttostr(round(resto * 100));

  // definindo o extenso da parte inteira do valor
  i := 0;
  umReal := false; tem := false;
  while (vlrS <> '0') do
    begin
      tam := length(vlrS);
      // retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
      // 1a. parte = 789 (centena)
      // 2a. parte = 456 (mil)
      // 3a. parte = 123 (milh�es)
      if (tam > 3)
        then
          begin
            vlrP := copy(vlrS, tam-2, tam);
            vlrS := copy(vlrS, 1, tam-3);
          end
        else
          begin // �ltima parte do valor
            vlrP := vlrS;
            vlrS := '0';
          end;
      if (vlrP <> '000')
        then
          begin
            saux := '';
            if (vlrP = '100')
              then saux := 'cem'
              else
                begin
                  n := strtoint(vlrP);        // para n = 371, tem-se:
                  cent := n div 100;          // cent = 3 (centena trezentos)
                  dez := (n mod 100) div 10;  // dez  = 7 (dezena setenta)
                  unid := (n mod 100) mod 10; // unid = 1 (unidade um)
                  if (cent <> 0)
                    then saux := centena[cent];
                  if ((dez <> 0) or (unid <> 0))
                    then
                      begin
                        if ((n mod 100) <= 19)
                          then
                            begin
                              if (length(saux) <> 0)
                                then saux := saux + ' e ' + unidade[n mod 100]
                                else saux := unidade[n mod 100];
                            end
                          else
                            begin
                              if (length(saux) <> 0)
                                then saux := saux + ' e ' + dezena[dez]
                                else saux := dezena[dez];
                              if (unid <> 0)
                                then
                                  if (length(saux) <> 0)
                                    then saux := saux + ' e ' + unidade[unid]
                                    else saux := unidade[unid];
                            end;
                    end;
                end;
            if ((vlrP = '1') or (vlrP = '001'))
              then
                begin
                  if (i = 0) // 1a. parte do valor (um real)
                    then umReal := true
                    else saux := saux + ' ' + qualificaS[i];
                end
              else
                if (i <> 0)
                  then saux := saux + ' ' + qualificaP[i];
                if (length(s) <> 0)
                  then s := saux + ', ' + s
                  else s := saux;
          end;
      if (((i = 0) or (i = 1)) and (length(s) <> 0))
        then tem := true; // tem centena ou mil no valor
      i := i + 1; // pr�ximo qualificador: 1- mil, 2- milh�o, 3- bilh�o, ...
    end;

  if (length(s) <> 0)
    then
      begin
        if (umReal)
          then s := s + ' real'
          else
            if (tem)
              then s := s + ' reais'
              else s := s + ' de reais';
      end;
  // definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
    then
      begin
        if (length(s) <> 0) // se n�o � valor somente com centavos
          then s := s + ' e ';
        if (centavos = '1')
          then s := s + 'um centavo'
          else
            begin
              n := strtoint(centavos);
              if (n <= 19)
                then s := s + unidade[n]
                else
                  begin                 // para n = 37, tem-se:
                    unid := n mod 10;   // unid = 37 % 10 = 7 (unidade sete)
                    dez := n div 10;    // dez  = 37 / 10 = 3 (dezena trinta)
                    s := s + dezena[dez];
                    if (unid <> 0)
                      then s := s + ' e ' + unidade[unid];
                  end;
              s := s + ' centavos';
            end;
      end;
  Result := s;
end;

end.
