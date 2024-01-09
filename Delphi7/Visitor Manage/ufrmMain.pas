unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdIPWatch, ExtCtrls, SUIDlg, ImgList, Menus, SUIMainMenu,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, SUIMgr,
  StdCtrls, SUIMemo, SUIButton, ComCtrls, SUITreeView, Buttons,
  SUIEdit, SUIImagePanel, SUIForm, AAFont, AACtrls, auAutoUpgrader, auHTTP,
  Grids, SUIGrid, DB, DBAccess, Uni, UniProvider, OracleUniProvider, MemDS, ufrmLogin,
  IniFiles, uMD5, ShellAPI, ufrmBrightness, udmMain, uLog, uSqliteDBController, uClassEncrypt,
  SUIPopupMenu, uCommon, GIFImage;

type
  TSysStatus = (ssLogin, ssChangeUser, ssRun);
  
  TfrmMain = class(TForm)
    sfrmMain: TsuiForm;
    pnlPnlBottom: TPanel;
    img1: TImage;
    lblComputer: TLabel;
    lbl7: TLabel;
    lblDateTime: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl_Alarm: TLabel;
    spnl1: TsuiPanel;
    pnlToolButton: TPanel;
    img2: TImage;
    spnlLeft: TsuiPanel;
    btnUser: TSpeedButton;
    AALabel1: TAALabel;
    lstUser: TsuiTreeView;
    spnl3: TsuiPanel;
    spnl4: TsuiPanel;
    suiBuiltInFileTheme1: TsuiBuiltInFileTheme;
    IdTCPClient: TIdTCPClient;
    suiMainMenu1: TsuiMainMenu;
    miN1: TMenuItem;
    miN11: TMenuItem;
    ilList1: TImageList;
    tmrTimer: TTimer;
    IdIPWatch1: TIdIPWatch;
    suiMessageDialog1: TsuiMessageDialog;
    N1: TMenuItem;
    miCheckUpdate: TMenuItem;
    miExit: TMenuItem;
    Label1: TLabel;
    AAScrollText1: TAAScrollText;
    auAutoUpgrader1: TauAutoUpgrader;
    Label2: TLabel;
    suiPanel1: TsuiPanel;
    suiStringGrid1: TsuiStringGrid;
    btnQuery: TsuiButton;
    edtQuery: TsuiEdit;
    Label3: TLabel;
    miSkin1: TMenuItem;
    miSkin2: TMenuItem;
    N6: TMenuItem;
    miSkin3: TMenuItem;
    suiBuiltInFileTheme2: TsuiBuiltInFileTheme;
    M1: TMenuItem;
    miChangePassword: TMenuItem;
    F1: TMenuItem;
    miBrightness: TMenuItem;
    AALabel2: TAALabel;
    pnl1: TPanel;
    btnRelease: TsuiButton;
    btnOut: TsuiButton;
    btnRefresh: TsuiButton;
    miChangeUser: TMenuItem;
    N2: TMenuItem;
    H1: TMenuItem;
    lblCountTime: TLabel;
    AALabel4: TAALabel;
    suiPopupMenu1: TsuiPopupMenu;
    miPrint: TMenuItem;
    btnExport: TsuiButton;
    SaveDialog1: TSaveDialog;
    miRefresh: TMenuItem;
    N5: TMenuItem;
    miExport: TMenuItem;
    pnlGif: TPanel;
    imgGif: TImage;
    btn1: TButton;
    tmrGif: TTimer;
    procedure miCheckUpdateClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure tmrTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnQueryClick(Sender: TObject);
    procedure suiStringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnUserClick(Sender: TObject);
    procedure lstUserClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure suiStringGrid1SelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure miSkin1Click(Sender: TObject);
    procedure miSkin2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure miChangeUserClick(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnOutClick(Sender: TObject);
    procedure miBrightnessClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
    procedure miPrintClick(Sender: TObject);
    procedure tmrGifTimer(Sender: TObject);
  private
    Global_Form_Height, Global_Form_Width: Integer; // ҳ��߶ȡ�ҳ����
    Global_SkinType: Integer; // Ƥ��
    ffrmLogin: TfrmLogin;
    fUserID, fUserName: string;  // ��¼�����û���
    fSysStatus: TSysStatus;  // ϵͳ״̬
    GifImage1: TGIFImage; // Gif����
    Fdm: TdmMain;  // oracle DB
    FMouseX, FMouseY: Integer;  // ���λ��
    tmrGifFlag: Integer; // �ж��Ƿ���Ҫ���ض���
    FChooseID, FChooseStatus, FReleaseTime, FOutTime: String;   // ѡ���е�ID��ѡ���е�ǩ��״̬������ʱ�䡢�볧ʱ��
    FChooseRow: Integer;
    SqliteDBController: TSqliteDBController;
    function GetHostName(var sHostName: string): Boolean;
    procedure SetNodeValue(Node: TTreeNode; Value: Integer);
    procedure DrawGridCell(sg: TsuiStringGrid; ACol, ARow: Integer; Rect: TRect);
    function CheckUserPrivilege: Boolean;
    function CheckUser(sUser, sPassword: string): Boolean;
    procedure SetFormSkin(skin: Integer);
    procedure Delay(mSecs: Integer);
    procedure SetScreenGif();
  public
    function GetNodeValue(Node: TTreeNode): Integer;
    procedure ReadIni();
    procedure AppMessageHandler(var Msg:TMsg;var Handled:Boolean);
    function ShowMessage(sMessage: string; IconType: TsuiIconType = suiNone;
      ButtonCount: Integer = 1; Caption: string = 'ϵͳ��ʾ'): Integer;
  end;

var
  frmMain: TfrmMain;

const
  WM_TRAYMSG = WM_USER + 101;
  _week: array[1..7] of string = ('������', '����һ', '���ڶ�', '������', '������', '������', '������');

implementation

{$R *.dfm}

procedure TfrmMain.miCheckUpdateClick(Sender: TObject);
begin
  if not auAutoUpgrader1.CheckUpdate(false) then
  begin
    ShowMessage('��ǰ�������°汾��', suiInformation);
  end;
end;

function TfrmMain.ShowMessage(sMessage: string; IconType: TsuiIconType;
  ButtonCount: Integer; Caption: string): Integer;
begin
  suiMessageDialog1.Text := sMessage;

  suiMessageDialog1.Caption := Caption;
  suiMessageDialog1.IconType := IconType;
  suiMessageDialog1.ButtonCount := ButtonCount;
  suiMessageDialog1.Button1Caption := 'ȷ��';

  if suiMessageDialog1.ButtonCount = 2 then
  begin
    suiMessageDialog1.Button2Caption := 'ȡ��';
  end;

  Result := suiMessageDialog1.ShowModal;
end;

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  if ShowMessage(PChar('�˳�ϵͳ����'), suiHelp, 2) <> mrOK then
    Exit;

  Application.Terminate;
end;

procedure TfrmMain.tmrTimerTimer(Sender: TObject);
begin
  lblDateTime.Caption := 'ʱ��: ' + FormatDateTime('yyyy��mm��dd��', Now)
    + '(' + _week[DayOfWeek(Date)] + ')' + FormatDateTime(' hh:mm:ss', Now);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  sComputerName: String;
begin
  // �ײ�: ʱ��
  tmrTimer.Enabled := true;

  // �ײ�: ��������IP
  GetHostName(sComputerName);
  lblComputer.Caption := '������: ' + sComputerName + ' ' + '(' + IdIPWatch1.LocalIP + ')';

  // DB����
  Fdm := TdmMain.Create(nil);
  with Fdm do
  begin
    UniConnection1.Close;
    UniConnection1.Server := '10.1.11.88';
    UniConnection1.Username := 'bran';
    UniConnection1.Password := 'Bran0001';
    UniConnection1.Open;
  end;

  suiStringGrid1.Cells[1, 0] := '�Ƿ���ɣ�';
  suiStringGrid1.Cells[2, 0] := '6λ�ÿ���';
  suiStringGrid1.Cells[3, 0] := '����';
  suiStringGrid1.Cells[4, 0] := '�ֻ���';
  suiStringGrid1.Cells[5, 0] := '��λ';
  suiStringGrid1.Cells[6, 0] := '���֤';
  suiStringGrid1.Cells[7, 0] := '��������';
  suiStringGrid1.Cells[8, 0] := '����';
  suiStringGrid1.Cells[9, 0] := '���ƺ�';
  suiStringGrid1.Cells[10, 0] := '�Ӵ���';
  suiStringGrid1.Cells[11, 0] := '�Ӵ����ֻ�';

  // ��¼��
  FfrmLogin := TfrmLogin.Create(nil);

  // �Զ�����
  auAutoUpgrader1.CheckUpdate(true);

  // ini�ļ�
  if not FileExists('visitor.ini') then
  begin
    with TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'visitor.ini') do
    try
      WriteInteger('Form', 'Height', 700);
      WriteInteger('Form', 'Width', 1300);

      WriteInteger('FormSkin', 'Skin', 0);
    finally
      Free;
    end;
  end;

  // ��ȡ�����ļ�
  ReadIni();

  case Global_SkinType of
  0: miSkin1.Checked := True;
  1: miSkin2.Checked := True;
  else
    miSkin3.Checked := True;
  end;
  SetFormSkin(Global_SkinType);

  // ����sqlite����ȡ��¼�˺š�����
  SqliteDBController := TSqliteDBController.Create();
  SqliteDBController.getUserInfo();

  // ʱ��
  tmrGifFlag := 0;

  // GIF����
  GifImage1 := TGIFImage.Create;
 // SetScreenGif;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ShowMessage('�˳�ϵͳ����', suiHelp, 2) = mrOk;
end;

function TfrmMain.GetHostName(var sHostName: string): Boolean;
var
  lpHostName: PAnsiChar;
  nSize: DWORD;
begin
  nSize := MAX_COMPUTERNAME_LENGTH + 1;
  New(lpHostName);
  GetMem(lpHostName, 128);
  if (GetComputerName(lpHostName, nSize)) then
  begin
    sHostName := lpHostName;
    result := True;
  end
  else
  begin
    result := False;
  end;
  FreeMem(lpHostName, 128);
end;

procedure TfrmMain.btnQueryClick(Sender: TObject);
var
  iRow: Integer;
  ibegin, iend: Int64;
  iCount: string;
begin
  // ��ʼʱ��
  ibegin := GetTickCount;

  for iRow := 1 to suiStringGrid1.RowCount - 1  do
    suiStringGrid1.Rows[iRow].Clear;

  suiStringGrid1.RowCount := 2;

  with Fdm.UniQuery1 do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('select requeststatus, randomletter, visitorname, visitormobile, visitorcompany, ');
    SQL.Add('visitorcard, reason, tools, carno, gsname, gsmobile, id, releasetime, outtime from ecologyoa.oa_visitor_gs_v ');
    SQL.Add('where 1 = 1 ');
    SQL.Add('and value = :userid ');
    ParamByName('userid').DataType:= ftString;
    ParamByName('userid').asstring := fUserID; // �û���¼��
    if Trim(edtQuery.Text) <> '' then
    begin
      SQL.Add('and (visitormobile = :param or visitorcard = :param or randomletter = :param) ');
      ParamByName('param').DataType:= ftString;
      ParamByName('param').asstring :=  Trim(edtQuery.Text);
    end;    
    Open;

    Fdm.UniQuery1.Last;
    suiStringGrid1.RowCount := RecordCount + 1;
    if RecordCount <= 0 then
      suiStringGrid1.RowCount := RecordCount + 2;

  //  suiStringGrid1.ColCount := Fields.Count + 1;  // id ��չʾ
    suiStringGrid1.FixedRows := 1;
    Fdm.UniQuery1.First;

    for iRow := 0 to RecordCount - 1 do
    begin
      suiStringGrid1.Cells[0, iRow + 1] := IntToStr(iRow + 1);
      suiStringGrid1.Cells[1, iRow + 1] := FieldByName('requeststatus').AsString;
      suiStringGrid1.Cells[2, iRow + 1] := FieldByName('randomletter').AsString;
      suiStringGrid1.Cells[3, iRow + 1] := FieldByName('visitorname').AsString;
      suiStringGrid1.Cells[4, iRow + 1] := FieldByName('visitormobile').AsString;
      suiStringGrid1.Cells[5, iRow + 1] := FieldByName('visitorcompany').AsString;
      suiStringGrid1.Cells[6, iRow + 1] := FieldByName('visitorcard').AsString;
      suiStringGrid1.Cells[7, iRow + 1] := FieldByName('reason').AsString;
      suiStringGrid1.Cells[8, iRow + 1] := FieldByName('tools').AsString;
      suiStringGrid1.Cells[9, iRow + 1] := FieldByName('carno').AsString;
      suiStringGrid1.Cells[10, iRow + 1] := FieldByName('gsname').AsString;
      suiStringGrid1.Cells[11, iRow + 1] := FieldByName('gsmobile').AsString;
      suiStringGrid1.Cells[12, iRow + 1] := FieldByName('id').AsString;
      suiStringGrid1.Cells[13, iRow + 1] := FieldByName('releasetime').AsString;
      suiStringGrid1.Cells[14, iRow + 1] := FieldByName('outtime').AsString;
      Next;
    end;

  {
    for iRow := 0 to RecordCount-1 do
    begin
      for jCol:=0 to Fields.Count -1 do
        suiStringGrid1.Cells[jCol + 1, iRow + 1] := Fields[jCol].Value;

      Next;
    end;       }


    Close;
  end;

  // ����ʱ��
  iend := GetTickCount;

  iCount := IntToStr(iend - ibegin);

  lblCountTime.Caption := iCount + ' ����';

  WriteLog('VisitorManage', '��ѯ��¼��ʱ: ' + iCount + ' ����', Info);

  // gif����չʾ
  tmrGifFlag := 0;
  pnlGif.Visible := False;
end;

procedure TfrmMain.suiStringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  DrawGridCell(suiStringGrid1, ACol, ARow, Rect);
end;

procedure TfrmMain.DrawGridCell(sg: TsuiStringGrid; ACol, ARow: Integer;
  Rect: TRect);
var
  aText: string;
begin
  aText := sg.Cells[ACol, ARow];
  with sg do
  begin
    if ColWidths[ACol] < Canvas.TextWidth(aText) + 4 then
      ColWidths[ACol] := Canvas.TextWidth(aText) + 6;
    if RowHeights[aRow] < Canvas.TextHeight(aText) then
      RowHeights[aRow] := Canvas.TextHeight(aText) + 4;

    Canvas.FillRect(Rect);
    if (ARow = 0) or (ACol = 0) then
      Canvas.TextOut((Rect.Left + Rect.Right - Canvas.TextWidth(aText)) div 2,
        Rect.Top + 5, aText)
    else
      Canvas.TextOut(Rect.Left + 4, Rect.Top + 5, aText);
  end;
end;

procedure TfrmMain.SetNodeValue(Node: TTreeNode; Value: Integer);
begin
  Node.Data := Pointer(Value);
end;

procedure TfrmMain.btnUserClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  lstUser.Items.Clear;
  AALabel1.Caption := '���շÿ�(' + FormatDateTime('YYYY-MM-DD', Now) + ')';
  
  with Fdm.UniQuery1 do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('select info, id, value from ecologyoa.oa_visitor_gs_today_v ');
    SQL.Add('where value = :param1 ');
    ParamByName('param1').DataType:= ftString;
    ParamByName('param1').AsString := fUserID;
    Open;
    while not Eof do
    begin
      Node := lstUser.Items.Add(nil, Fields[0].AsString);
      SetNodeValue(Node, Fields[1].AsInteger);
      Next;
    end;
    Close;
  end;
end;

procedure TfrmMain.lstUserClick(Sender: TObject);
var
  Value: integer;
  Node: TTreeNode;
begin
  Node := lstUser.Selected;
  Value := GetNodeValue(Node);
end;

function TfrmMain.GetNodeValue(Node: TTreeNode): Integer;
begin
  if Node <> nil then
    Result := Integer(Node.Data);
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if fSysStatus = ssRun then
    exit;

  if not CheckUserPrivilege then
    Application.Terminate;

  ShowMessage('��¼�ɹ���', suiInformation);
  lbl_Alarm.Caption := fUserName;
  FSysStatus := ssRun;
end;

function TfrmMain.CheckUserPrivilege: Boolean;
var
  sUser: String;
  sEncryptPassword: string;
begin
  result := false;
  with ffrmLogin do
  begin
    repeat
      edtUser.Text := SqliteDBController.GUserID;
      edtPassword.Text := SqliteDBController.GPassword;
      
      if ffrmLogin.ShowModal <> mrOk then
        exit;
      sUser := edtUser.Text;
    until CheckUser(sUser, edtPassword.Text);

    // ��¼��¼��
    sEncryptPassword := EncrypKey(edtPassword.Text, 'KeyAA1AA');
    SqliteDBController.setUserInfo(sUser, sEncryptPassword);

    result := True;
  end;
end;

function TfrmMain.CheckUser(sUser, sPassword: string): Boolean;
begin
  result := False;
  with Fdm.UniQuery1 do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('select loginid, password, lastname from ecologyoa.oa_visitor_hrmresource_app_v ');
    SQL.Add('where loginid = :loginid and password = ecologyoa.md5(:password) and rownum = 1 ');
    ParamByName('loginid').DataType:= ftString;
    ParamByName('loginid').AsString := Trim(sUser);

    ParamByName('password').DataType:= ftString;
    ParamByName('password').AsString := Trim(sPassword);
    OPEN;
    if RecordCount = 0 then
    begin
      Close;
      exit;
    end;
    
    fUserID := FieldByName('loginid').AsString;
    fUserName:= FieldByName('lastname').AsString;

    Close;
  end;

  Result := True;
end;

procedure TfrmMain.suiStringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    Exit;

  FChooseID := suiStringGrid1.Cells[12, ARow];  // ID
  FChooseStatus := suiStringGrid1.Cells[1, ARow];   // �Ƿ�ɷ���
  FReleaseTime := suiStringGrid1.Cells[13, ARow];  // ����ʱ��
  FOutTime := suiStringGrid1.Cells[14, ARow];   // �볧ʱ��
  FChooseRow := ARow;  // ѡ�е���

  if Trim(FReleaseTime) <> '' then
    btnRelease.Enabled := False
  else
    btnRelease.Enabled := True;

  if Trim(FOutTime) <> '' then
    btnOut.Enabled := False
  else
    btnOut.Enabled := True;

  AAScrollText1.Text.Lines.Clear;
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>�Ƿ���볧: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[1, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>6λ�ÿ���: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[2, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��      ��: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[3, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��  ��  ��: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[4, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��      λ: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[5, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��  ��  ֤: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[6, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left> ��������: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[7, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��      ��: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[8, ARow]);
  AAScrollText1.Text.Lines.Add('');

    AAScrollText1.Text.Lines.Add('<Title2><Left>�� �� ��: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[9, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>��  ��  ��: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[10, ARow]);
  AAScrollText1.Text.Lines.Add('');

  AAScrollText1.Text.Lines.Add('<Title2><Left>�Ӵ����ֻ�: ');
  AAScrollText1.Text.Lines.Add('<Title1><Left>  ' + suiStringGrid1.Cells[11, ARow]);
  AAScrollText1.Text.Lines.Add('');
end;

procedure TfrmMain.miSkin1Click(Sender: TObject);
begin
  miSkin1.Checked := True;

  Global_SkinType := 0;
  with TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'visitor.ini') do
  try
    WriteInteger('FormSkin', 'Skin', 0);
  finally
    Free;
  end;

  SetFormSkin(Global_SkinType);
end;

procedure TfrmMain.miSkin2Click(Sender: TObject);
begin
  miSkin2.Checked := True;

  Global_SkinType := 1;
  with TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'visitor.ini') do
  try
    WriteInteger('FormSkin', 'Skin', 1);
  finally
    Free;
  end;

  SetFormSkin(Global_SkinType);
end;

procedure TfrmMain.ReadIni;
var
  ini: TiniFile;
  FileName: string;
begin
  FileName := ExtractFilePath(paramstr(0)) + 'visitor.ini';
  ini := TInifile.Create(FileName);
  try
    Global_Form_Height := ini.ReadInteger('Form', 'Height', 700);
    Global_Form_Width := ini.ReadInteger('Form', 'Width', 1300);

    Global_SkinType := ini.ReadInteger('FormSkin', 'Skin', 0);
  finally
    ini.Free;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  iFormHeight, iFormWidth: Integer;
begin
  iFormHeight := Self.Height;
  iFormWidth := Self.Width;

  with TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'visitor.ini') do
  try
    WriteInteger('Form', 'Height', iFormHeight);
    WriteInteger('Form', 'Width', iFormWidth);
  finally
    Free;
  end;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  btnUser.Click;
  btnQuery.Click;
end;

procedure TfrmMain.miChangeUserClick(Sender: TObject);
begin
  fSysStatus := ssChangeUser;
end;

procedure TfrmMain.H1Click(Sender: TObject);
var
  HelpURL: string;
begin
  HelpURL := 'http://oa.jp-solar.com:9080/';
  ShellExecute(Application.Handle, PChar('open'), PChar(HelpURL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.btnReleaseClick(Sender: TObject);
begin
  if FChooseStatus = 'ǩ����' then
  begin
    if ShowMessage('������δǩ��, �Ƿ�ȷ�Ϸ��У�', suiHelp, 2) = mrCancel then
      Exit;
  end;

  with Fdm.UniQuery1 do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('update ecologyoa.oa_visitor_t set releasetime = sysdate ');
    SQL.Add('where id = :idx and rownum = 1 ');
    ParamByName('idx').DataType:= ftString;
    ParamByName('idx').asstring := FChooseID;
    ExecSQL();
    Close;
  end;

  btnRelease.Enabled := False;
  suiStringGrid1.Cells[13, FChooseRow] := 'SDFSDFSDFSDF';
end;

procedure TfrmMain.btnOutClick(Sender: TObject);
begin
  if ShowMessage('ȷ�Ͽͻ��볧��', suiHelp, 2) = mrCancel then
    Exit;

  with Fdm.UniQuery1 do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('update ecologyoa.oa_visitor_t set outtime = sysdate ');
    SQL.Add('where id = :idx and rownum = 1 ');
    ParamByName('idx').DataType:= ftString;
    ParamByName('idx').asstring := FChooseID;
    ExecSQL();
    Close;
  end;

  btnOut.Enabled := False;
  suiStringGrid1.Cells[14, FChooseRow] := 'SDFSDFSDFSDF';
end;

procedure TfrmMain.miBrightnessClick(Sender: TObject);
var
  frmBrightness: TfrmBrightness;
begin
  frmBrightness := TfrmBrightness.Create(nil);
  try
    with frmBrightness do
    begin
      ShowModal;
    end;
  finally
    frmBrightness.Free;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(SqliteDBController) then
    FreeAndNil(SqliteDBController);

  if Assigned(GifImage1) then
    FreeAndNil(GifImage1);
end;

procedure TfrmMain.SetFormSkin(skin: Integer);
var
  BuiltInFileTheme: TsuiBuiltInFileTheme;
begin
  case skin of
  0: BuiltInFileTheme := suiBuiltInFileTheme1;
  1: BuiltInFileTheme := suiBuiltInFileTheme2;
  end;

  sfrmMain.FileTheme := BuiltInFileTheme;
  btnRefresh.FileTheme := BuiltInFileTheme;
  spnlLeft.FileTheme := BuiltInFileTheme;
  btnQuery.FileTheme := BuiltInFileTheme;
  btnRelease.FileTheme := BuiltInFileTheme;
  btnOut.FileTheme := BuiltInFileTheme;
  spnl4.FileTheme := BuiltInFileTheme;
  suiStringGrid1.FileTheme := BuiltInFileTheme;
  lstUser.FileTheme := BuiltInFileTheme;
  suiMessageDialog1.FileTheme := BuiltInFileTheme;
  suiMainMenu1.FileTheme := BuiltInFileTheme;
  suiPopupMenu1.FileTheme := BuiltInFileTheme;
  btnExport.FileTheme := BuiltInFileTheme;
end;

procedure TfrmMain.btnExportClick(Sender: TObject);
var
  ibegin, iend: Int64;
  iCount: string;
begin
  if not SaveDialog1.Execute then
    Exit;

  ibegin := GetTickCount;
  SaveToExcel(SaveDialog1.FileName, suiStringGrid1);
  iend := GetTickCount;

  iCount := IntToStr(iend - ibegin);
  lblCountTime.Caption := iCount + ' ����';
  WriteLog('VisitorManage', '������¼��ʱ: ' + iCount + ' ����', Info);
end;

procedure TfrmMain.miRefreshClick(Sender: TObject);
begin
  btnUser.Click;
  btnQuery.Click;
end;

procedure TfrmMain.miExportClick(Sender: TObject);
begin
  if not SaveDialog1.Execute then
    Exit;

  SaveToExcel(SaveDialog1.FileName, suiStringGrid1);
end;

procedure TfrmMain.miPrintClick(Sender: TObject);
begin
  if not SaveDialog1.Execute then
    Exit;

  SaveToExcel(SaveDialog1.FileName, suiStringGrid1);
end;

procedure TfrmMain.Delay(mSecs: Integer);
var 
  Tick: DWord;
  Event: THandle;
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    Tick := GetTickCount + DWord(mSecs);
    while (mSecs > 0) and (MsgWaitForMultipleObjects(1, Event, False, mSecs, QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      mSecs := Tick - GetTickcount;
    end;
  finally
    CloseHandle(Event);
  end;
end;

procedure TfrmMain.SetScreenGif;
begin
  try
    // ���ض���
    GifImage1.LoadFromFile('secgif.gif');
    imgGif.Picture.Assign(GifImage1);
    TGIFImage(imgGif.Picture.Graphic).Animate := True;
  finally

  end;
end;

procedure TfrmMain.AppMessageHandler(var Msg: TMsg; var Handled: Boolean);
begin
  if (msg.message = WM_MOUSEMOVE) or (msg.message = WM_KEYDOWN) then
  begin
    pnlGif.Visible := False;
    tmrGifFlag := 0;
  end;
end;

procedure TfrmMain.tmrGifTimer(Sender: TObject);
begin
  tmrGifFlag := tmrGifFlag + 1;

  // 5�����޲���>>չʾ����
  if tmrGifFlag >= 300 then
    pnlGif.Visible := True
  else
    pnlGif.Visible := False;
end;

end.
