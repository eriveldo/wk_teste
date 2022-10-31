object dmConexao: TdmConexao
  OldCreateOrder = False
  Height = 232
  Width = 335
  object conexao: TFDConnection
    Params.Strings = (
      'Database=vendas'
      'Password=adonai@jeova'
      'Server=192.168.10.5'
      'User_Name=root'
      'UseSSL=True'
      'DriverID=Mysql')
    LoginPrompt = False
    Transaction = transaction
    Left = 48
    Top = 32
  end
  object query: TFDQuery
    Connection = conexao
    SQL.Strings = (
      'insert into cliente (nome, cpf) values ('#39'eriveldo'#39','#39'123'#39')')
    Left = 56
    Top = 96
  end
  object transaction: TFDTransaction
    Connection = conexao
    Left = 120
    Top = 56
  end
end
