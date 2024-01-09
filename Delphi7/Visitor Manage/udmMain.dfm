object dmMain: TdmMain
  OldCreateOrder = False
  Left = 598
  Top = 341
  Height = 230
  Width = 353
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    Left = 173
    Top = 47
  end
  object UniConnection1: TUniConnection
    ProviderName = 'Oracle'
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Username = 'bran'
    Server = '10.1.11.88:1521:orcl'
    LoginPrompt = False
    Left = 45
    Top = 47
    EncryptedPassword = 'BDFF8DFF9EFF91FFCFFFCFFFCFFFCEFF'
  end
end
