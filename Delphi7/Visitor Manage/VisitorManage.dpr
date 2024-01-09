program VisitorManage;

uses
  Windows,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmBrightness in 'ufrmBrightness.pas' {frmBrightness},
  ufrmLogin in 'ufrmLogin.pas' {frmLogin},
  udmMain in 'udmMain.pas' {dmMain: TDataModule},
  uSqliteDBController in 'uSqliteDBController.pas',
  ufrmChangePassword in 'ufrmChangePassword.pas' {frmChangePassword};

{$R *.res}

var
  MutexHandle: THandle;

begin
  MutexHandle := CreateMutex(nil, True, '�����ÿ�ͨ��ϵͳ');

  if (MutexHandle <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    Application.MessageBox('�����Ѿ�����, ��ȷ���رմ˴���!', 'ϵͳ��ʾ:', MB_OK);
    CloseHandle(MutexHandle);
    Exit;
  end;

  Application.Initialize;
  Application.Title := '�����ÿ�ͨ��ϵͳ';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmBrightness, frmBrightness);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmChangePassword, frmChangePassword);
  Application.Run;
end.
