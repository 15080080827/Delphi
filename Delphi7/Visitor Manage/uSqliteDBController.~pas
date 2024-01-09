unit uSqliteDBController;

interface

uses
  Windows, Forms, Messages, SysUtils, Variants, Classes,  SQLite3, SQLiteTable3,
  uClassEncrypt;

type
  TSqliteDBController = class

  private
    sqliteDBConn: TSQLiteDatabase;    // SqliteDB连接
  public
    GUserID, GPassword: String;
    constructor Create();
    destructor Destory();

    procedure getUserInfo();
    procedure setUserInfo(userid, password: String);
  end;

implementation

{ TSqliteDBController }

constructor TSqliteDBController.Create;
var
  sqliteDBPath: String;
begin
  // sqliteDB连接
  sqliteDBPath := ExtractFilepath(Application.ExeName)+ 'ini.db3';
  sqliteDBConn := TSQLiteDatabase.Create(sqliteDBPath);
end;

destructor TSqliteDBController.Destory;
begin
  if Assigned(sqliteDBConn) then
    sqliteDBConn.Free;
end;

procedure TSqliteDBController.getUserInfo();
var
  i: Integer;
  sqliteTable: TSQLiteTable;
  sEncryptPassword: String;
begin
  sqliteTable := sqliteDBConn.GetTable('select userid, password from userinfo where id = 1 ');
  try
    if sqliteTable.Count > 0 then
    begin
      for i := 0 to sqliteTable.Count - 1 do
      begin
        GUserID := Utf8ToAnsi(sqliteTable.FieldAsString(sqliteTable.FieldIndex['userid']));
        sEncryptPassword := Utf8ToAnsi(sqliteTable.FieldAsString(sqliteTable.FieldIndex['password'])); // 加密后的password
        GPassword := UnEncrypKey(sEncryptPassword, 'KeyAA1AA');

        sqliteTable.Next;
      end;
    end;
  finally
    sqliteTable.Free;
  end;
end;

procedure TSqliteDBController.setUserInfo(userid, password: String);
var
  i: Integer;
  sqliteTable: TSQLiteTable;
begin
  sqliteDBConn.ExecSQL('update userinfo set userid = ''' + userid + ''', password = ''' + password + ''' where id = 1 ');
end;

end.
