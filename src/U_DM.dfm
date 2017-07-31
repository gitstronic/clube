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
    Left = 32
    Top = 48
  end
  object aqyUsuarios: TADOQuery
    Connection = adoConexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select id,nome,administrador,senha_entrada from Usuarios')
    Left = 160
    Top = 64
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
end
