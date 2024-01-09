unit ufrmBrightness;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SUIButton, jpeg, ExtCtrls, SUIMgr, SUIForm;


type
  TRampArray = array[0..2] of array[byte] of word;
var
  origRampArray: TRampArray;

type
  TfrmBrightness = class(TForm)
    sfrmBrightness: TsuiForm;
    pnl_ts1_Client: TPanel;
    img1: TImage;
    btnReturn: TsuiButton;
    btnAdd: TsuiButton;
    btnSub: TsuiButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSubClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
    iBrightness: Integer;
    function SetBrightness(wBrightness: word): boolean;
  public
    { Public declarations }
  end;

var
  frmBrightness: TfrmBrightness;

implementation

uses
  ufrmMain;

{$R *.dfm}

procedure TfrmBrightness.FormCreate(Sender: TObject);
var
  DC: HDC;
begin
  DC := GetDC(0);
  try
    GetDeviceGammaRamp(DC, origRampArray);
  finally
    ReleaseDC(0, DC);
  end;

  iBrightness := 50;
end;

function TfrmBrightness.SetBrightness(wBrightness: word): boolean;
var
  RampArray: TRampArray;
  i, Value: integer;
  DC: HDC;
begin
  for i := 0 to MAXBYTE do
  begin
    Value := i * ( wBrightness + 128 );

    if ( Value > MAXWORD ) then
      Value := MAXWORD;

    RampArray[0][i] := Value;
    RampArray[1][i] := Value;
    RampArray[2][i] := Value;
  end;

  DC := GetDC(0);

  try
    Result := SetDeviceGammaRamp(DC, RampArray);
  finally
    ReleaseDC( 0, DC );
  end;
end;

procedure TfrmBrightness.btnAddClick(Sender: TObject);
begin
  iBrightness := iBrightness + 10;
  SetBrightness(iBrightness);
end;

procedure TfrmBrightness.btnSubClick(Sender: TObject);
begin
  iBrightness := iBrightness - 10;
  SetBrightness(iBrightness);
end;

procedure TfrmBrightness.btnReturnClick(Sender: TObject);
var
  DC: HDC;
begin
  DC := GetDC(0);
  try
    SetDeviceGammaRamp(DC, origRampArray);
  finally
    ReleaseDC(0, DC);
  end;
end;

end.
