unit RDLuPolygon;

interface

uses
  System.SysUtils, System.Classes,  System.Types, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Objects, FMX.Filter.Effects;

type
  TPolygonType = ( VerticesNo3, VerticesNo4, VerticesNo5, VerticesNo6, VerticesNo7, VerticesNo8, VerticesNo9, VerticesNo10, VerticesNo11, VerticesNo12 );

type
  TRDLPolygon = class(TLayout)
  private
    { Private declarations }

    FColorFill   : TAlphaColor;
    FPolygonType : TPolygonType;

    PolyImage : TImage;
    FillEffect : TFillRGBEffect;

    procedure C2FreeRelease(tarObject: TFmxObject);
    procedure PolygonType_Set( pType : TPolygonType );

    procedure SetColorFill(const Value: TAlphaColor);
    procedure SetPolygonType(const Value: TPolygonType);


  protected
    { Protected declarations }
    procedure Paint; override;

  public
    { Public declarations }

    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;

  published
    { Published declarations }
    property Size;
    property Width;
    property Height;
    property Position;

    property ColorFill       : TAlphaColor read FColorFill write SetColorFill;
    property PolygonType     : TPolygonType read FPolygonType write SetPolygonType;

  end;

procedure Register;

implementation

uses
  PSetcontrLAB;


procedure Register;
begin
  RegisterComponents('Rapid Design LAB', [TRDLPolygon]);
end;

{ TRDLPolygon }

procedure TRDLPolygon.C2FreeRelease(tarObject: TFmxObject);
begin
  if Assigned( tarObject ) then
     tarObject.Release;
end;

constructor TRDLPolygon.Create(AOwner: TComponent);
begin
  inherited;

  self.Width  := 120;
  self.Height := 120;

  FColorFill := TAlphaColorRec.Orange;
  FPolygonType := TPolygonType.VerticesNo5;

  PolyImage := TImage.Create(self);
  PolyImage.Parent := self;
  PolyImage.Stored := FALSE;
  PolyImage.HitTest := FALSE;
  PolyImage.Align := TAlignLayout.Client;

  FillEffect := TFillRGBEffect.Create( PolyImage );
  FillEffect.Parent := PolyImage;
  FillEffect.Stored := FALSE;
  FillEffect.Enabled := TRUE;

  PolygonType_Set( FPolygonType );
end;

destructor TRDLPolygon.Destroy;
begin
  C2FreeRelease( FillEffect );
  C2FreeRelease( PolyImage );

  inherited;
end;

procedure TRDLPolygon.Paint;
begin
  inherited;

  PolyImage.Width := 100;
  PolyImage.Height := 100;

  FillEffect.Color := FColorFill;
end;

procedure TRDLPolygon.SetColorFill(const Value: TAlphaColor);
begin
  FColorFill := Value;
end;

procedure TRDLPolygon.SetPolygonType(const Value: TPolygonType);
begin
  FPolygonType := Value;

  PolygonType_Set( FPolygonType );
end;


//---------------------------------------------------------------------------------
procedure TRDLPolygon.PolygonType_Set( pType : TPolygonType );
var
  rs : TResourceStream;
  vertex : integer;
  rsName : UnicodeString;
begin
  case pType of
    TPolygonType.VerticesNo3 : vertex := 3;
    TPolygonType.VerticesNo4 : vertex := 4;
    TPolygonType.VerticesNo5 : vertex := 5;
    TPolygonType.VerticesNo6 : vertex := 6;
    TPolygonType.VerticesNo7 : vertex := 7;
    TPolygonType.VerticesNo8 : vertex := 8;
    TPolygonType.VerticesNo9 : vertex := 9;
    TPolygonType.VerticesNo10 : vertex := 10;
    TPolygonType.VerticesNo11 : vertex := 11;
    TPolygonType.VerticesNo12 : vertex := 12;
  end;

  rsName := 'POLYGON_' + vertex.ToString;

  if ( FindResource( hInstance, PWideChar(rsName), RT_RCDATA) > 0 ) then
  begin
    rs := TResourceStream.Create(hInstance, rsName, RT_RCDATA);  //  System.Types
    try
      PolyImage.Bitmap.LoadFromStream( rs );
    finally
      rs.Free;
    end;
  end;
end;

initialization
  RegisterFMXClasses([TRDLPolygon]);


end.
