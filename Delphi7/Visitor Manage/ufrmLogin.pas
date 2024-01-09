unit ufrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, SUIMgr, SUIForm, jpeg, SUIButton,
  AAFont, AACtrls;

type
  TfrmLogin = class(TForm)
    sfrmLogin: TsuiForm;
    pnl1: TPanel;
    img1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    bvl1: TBevel;
    edtUser: TEdit;
    edtPassword: TEdit;
    pnl2: TPanel;
    btnOK: TsuiButton;
    btnClose: TsuiButton;
    AALabel1: TAALabel;
    procedure FormActivate(Sender: TObject);
    procedure edtUserKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.FormActivate(Sender: TObject);
begin
 // edtUser.Text := '';
 // edtPassword.Text := '';
 // edtUser.SetFocus;
 // edtUser.SelectAll;
 
  edtPassword.SetFocus
end;

procedure TfrmLogin.edtUserKeyPress(Sender: TObject; var Key: Char);
begin
  IF KEY = #13 then
    selectNext(TWinControl(Sender),True,True);
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  IF KEY = #13 then
  begin
    selectNext(TWinControl(Sender),True,True);
    btnOk.Click;
  end;
end;

end.
