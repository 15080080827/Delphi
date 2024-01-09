unit udmMain;

interface

uses
  SysUtils, Classes, DB, DBAccess, Uni, MemDS;

type
  TdmMain = class(TDataModule)
    UniQuery1: TUniQuery;
    UniConnection1: TUniConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{$R *.dfm}

end.
