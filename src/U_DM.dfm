object DM: TDM
  OldCreateOrder = False
  Height = 359
  Width = 537
  object adoConexao: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=registr' +
      'onic;Initial Catalog=SecullumClubeNet_Clube;Data Source=FREED;In' +
      'itial File Name="";Server SPN="";password="regis86"'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 24
    Top = 8
  end
  object aqyUsuarios: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id,nome,administrador,senha_entrada from Usuarios')
    Left = 24
    Top = 56
    object aqyUsuariosid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyUsuariosnome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object aqyUsuariosadministrador: TBooleanField
      FieldName = 'administrador'
    end
    object aqyUsuariossenha_entrada: TStringField
      FieldName = 'senha_entrada'
      Size = 80
    end
  end
  object aqySaldos: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'with a as(select conta_corrente_id,sum(pagto_valor) as Saldo fro' +
        'm contas_receber_pagtos group by conta_corrente_id),'
      
        'b as (select conta_corrente_id,sum(valor_total) as Debito from c' +
        'ontas_pagar group by conta_corrente_id),'
      
        'c as(select contas_correntes.id,contas_correntes.descricao as Co' +
        'ntaCorrente,coalesce(a.Saldo,0.0) as Credito,coalesce(b.Debito,0' +
        '.0) as Debito from contas_correntes full join a on contas_corren' +
        'tes.id=a.conta_corrente_id full join b on contas_correntes.id=b.' +
        'conta_corrente_id)'
      
        'select c.id,c.ContaCorrente,(c.Credito-c.Debito) as Saldo from c' +
        ' order by c.id')
    Left = 24
    Top = 112
    object aqySaldosContaCorrente: TStringField
      FieldName = 'ContaCorrente'
      Size = 50
    end
    object aqySaldosSaldo: TFMTBCDField
      FieldName = 'Saldo'
      ReadOnly = True
      currency = True
      Precision = 20
      Size = 4
    end
  end
  object aqyContaDebito: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id,descricao from contas_correntes')
    Left = 136
    Top = 8
    object aqyContaDebitoid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyContaDebitodescricao: TStringField
      FieldName = 'descricao'
      Size = 50
    end
  end
  object aqyContaCredito: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id,descricao from contas_correntes')
    Left = 136
    Top = 56
    object AutoIncField1: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object StringField1: TStringField
      FieldName = 'descricao'
      Size = 50
    end
  end
  object aqyContasPagar: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select id,empresa_id,observacao,previsao_data,previsao_valor,pag' +
        'to_tipo,valor_total,vencimento,conta_corrente_id,alteracao_usu_i' +
        'd,alteracao_data from contas_pagar')
    Left = 264
    Top = 8
    object aqyContasPagarid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyContasPagarempresa_id: TIntegerField
      FieldName = 'empresa_id'
    end
    object aqyContasPagarobservacao: TStringField
      FieldName = 'observacao'
      Size = 100
    end
    object aqyContasPagarprevisao_data: TDateTimeField
      FieldName = 'previsao_data'
    end
    object aqyContasPagarprevisao_valor: TBCDField
      FieldName = 'previsao_valor'
      Precision = 19
    end
    object aqyContasPagarpagto_tipo: TWordField
      FieldName = 'pagto_tipo'
    end
    object aqyContasPagarvalor_total: TBCDField
      FieldName = 'valor_total'
      Precision = 19
    end
    object aqyContasPagarvencimento: TDateTimeField
      FieldName = 'vencimento'
    end
    object aqyContasPagarconta_corrente_id: TIntegerField
      FieldName = 'conta_corrente_id'
    end
    object aqyContasPagaralteracao_usu_id: TIntegerField
      FieldName = 'alteracao_usu_id'
    end
    object aqyContasPagaralteracao_data: TDateTimeField
      FieldName = 'alteracao_data'
    end
  end
  object aqyContasReceberPagtos: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select id,conta_receber_id,pagto_data,pagto_valor,pagto_tipo,con' +
        'ta_corrente_id,alteracao_usu_id,alteracao_data from contas_receb' +
        'er_pagtos')
    Left = 264
    Top = 104
    object aqyContasReceberPagtosid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyContasReceberPagtosconta_receber_id: TIntegerField
      FieldName = 'conta_receber_id'
    end
    object aqyContasReceberPagtospagto_data: TDateTimeField
      FieldName = 'pagto_data'
    end
    object aqyContasReceberPagtospagto_valor: TBCDField
      FieldName = 'pagto_valor'
      Precision = 19
    end
    object aqyContasReceberPagtospagto_tipo: TWordField
      FieldName = 'pagto_tipo'
    end
    object aqyContasReceberPagtosconta_corrente_id: TIntegerField
      FieldName = 'conta_corrente_id'
    end
    object aqyContasReceberPagtosalteracao_usu_id: TIntegerField
      FieldName = 'alteracao_usu_id'
    end
    object aqyContasReceberPagtosalteracao_data: TDateTimeField
      FieldName = 'alteracao_data'
    end
  end
  object aqyContasReceber: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select id,pessoa_id,vencimento,valor,observacao,quitado,alteraca' +
        'o_usu_id,alteracao_data from contas_receber')
    Left = 264
    Top = 56
    object aqyContasReceberid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyContasReceberpessoa_id: TIntegerField
      FieldName = 'pessoa_id'
    end
    object aqyContasRecebervencimento: TDateTimeField
      FieldName = 'vencimento'
    end
    object aqyContasRecebervalor: TBCDField
      FieldName = 'valor'
      Precision = 19
    end
    object aqyContasReceberobservacao: TStringField
      FieldName = 'observacao'
      Size = 100
    end
    object aqyContasReceberquitado: TBooleanField
      FieldName = 'quitado'
    end
    object aqyContasReceberalteracao_usu_id: TIntegerField
      FieldName = 'alteracao_usu_id'
    end
    object aqyContasReceberalteracao_data: TDateTimeField
      FieldName = 'alteracao_data'
    end
  end
  object aqyEmpresas: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id,nome,obs,criacao_usu_id,criacao_data from empresas')
    Left = 264
    Top = 152
    object aqyEmpresasid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object aqyEmpresasnome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object aqyEmpresasobs: TStringField
      FieldName = 'obs'
      Size = 50
    end
    object aqyEmpresascriacao_usu_id: TIntegerField
      FieldName = 'criacao_usu_id'
    end
    object aqyEmpresascriacao_data: TDateTimeField
      FieldName = 'criacao_data'
    end
  end
end
