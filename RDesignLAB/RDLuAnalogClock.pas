unit RDLuAnalogClock;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Graphics, FMX.Objects;

type
  TRDLAnalogClock = class(TLayout)
  private
    { Private declarations }
    FTimer : TTimer;

    FBitmapPanel,
    FBitmapHour,
    FBitmapMinute,
    FBitmapSecond : TBitmap;

    SizeLay : TLayout;
    PanelImage,
    HourImage,
    MinuteImage,
    SecondImage    : TImage;
    CoverForDesign : TRectangle;

    procedure C2FreeRelease(tarObject: TFmxObject);
    procedure AutoSizeSet();
    procedure OnTimer(Sender : TObject );

    procedure SetBitmapPanel(const Value: TBitmap);
    procedure SetBitmapHour(const Value: TBitmap);
    procedure SetBitmapMinute(const Value: TBitmap);
    procedure SetBitmapSecond(const Value: TBitmap);

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

    property BitmapClock       : TBitmap read FBitmapPanel write SetBitmapPanel;
    property BitmapHour        : TBitmap read FBitmapHour write SetBitmapHour;
    property BitmapMinute      : TBitmap read FBitmapMinute write SetBitmapMinute;
    property BitmapSecond      : TBitmap read FBitmapSecond write SetBitmapSecond;



  end;

procedure Register;

implementation

uses
  PSetcontrLAB;


procedure Register;
begin
  RegisterComponents('Rapid Design LAB', [TRDLAnalogClock]);
end;

{ TRDLCircleGauge }

procedure TRDLAnalogClock.C2FreeRelease(tarObject: TFmxObject);
begin
  if Assigned( tarObject ) then
     tarObject.Release;
end;

procedure TRDLAnalogClock.AutoSizeSet();
var
  baseL : single;
begin
  if self.Width <= self.Height then
  begin
    baseL := self.Width;
    SizeLay.Position.X := 0;
    SizeLay.Position.Y := self.Height/2 - baseL/2;
  end
  else
  begin
    baseL := self.Height;
    SizeLay.Position.Y := 0;
    SizeLay.Position.X := self.Width/2 - baseL/2;
  end;

  SizeLay.Width  := baseL;
  SizeLay.Height := baseL;
end;


constructor TRDLAnalogClock.Create(AOwner: TComponent);
var
  rsP, rsH, rsM, rsS : TResourceStream;
begin
  inherited;

  FBitmapPanel  := TBitmap.Create;
  FBitmapHour   := TBitmap.Create;
  FBitmapMinute := TBitmap.Create;
  FBitmapSecond := TBitmap.Create;

  if ( FindResource( hInstance, 'IMAGE_CLOCK', RT_RCDATA) > 0 ) then
  begin
    rsP := TResourceStream.Create(hInstance, 'IMAGE_CLOCK', RT_RCDATA);  //  System.Types
    try
      FBitmapPanel.LoadFromStream( rsP );
    finally
      rsP.Free;
    end;
  end;

  if ( FindResource( hInstance, 'IMAGE_HOUR', RT_RCDATA) > 0 ) then
  begin
    rsH := TResourceStream.Create(hInstance, 'IMAGE_HOUR', RT_RCDATA);
    try
      FBitmapHour.LoadFromStream( rsH );
    finally
      rsH.Free;
    end;
  end;

  if ( FindResource( hInstance, 'IMAGE_MIN', RT_RCDATA) > 0 ) then
  begin
    rsM := TResourceStream.Create(hInstance, 'IMAGE_MIN', RT_RCDATA);
    try
      FBitmapMinute.LoadFromStream( rsM );
    finally
      rsM.Free;
    end;
  end;

  if ( FindResource( hInstance, 'IMAGE_SEC', RT_RCDATA) > 0 ) then
  begin
    rsS := TResourceStream.Create(hInstance, 'IMAGE_SEC', RT_RCDATA);
    try
      FBitmapSecond.LoadFromStream( rsS );
    finally
      rsS.Free;
    end;
  end;

  self.HitTest := TRUE;
  self.Width  := 240;
  self.Height := self.Width;

  SizeLay := TLayout.Create(self);
  SizeLay.Parent := self;
  SizeLay.Stored := FALSE;
  SizeLay.Width  := self.Width;
  SizeLay.Height := self.Height;

  PanelImage := TImage.Create(SizeLay);
  PanelImage.Parent := SizeLay;
  PanelImage.Stored := FALSE;
  PanelImage.HitTest := FALSE;
  PanelImage.Align := TAlignLayout.Client;

  HourImage := TImage.Create(PanelImage);
  HourImage.Parent := PanelImage;
  HourImage.Stored := FALSE;
  HourImage.HitTest := FALSE;
  HourImage.Align := TAlignLayout.Client;
  HourImage.RotationAngle := -60;

  MinuteImage := TImage.Create(PanelImage);
  MinuteImage.Parent := PanelImage;
  MinuteImage.Stored := FALSE;
  MinuteImage.HitTest := FALSE;
  MinuteImage.Align := TAlignLayout.Client;
  MinuteImage.RotationAngle := 60;

  SecondImage := TImage.Create(PanelImage);
  SecondImage.Parent := PanelImage;
  SecondImage.Stored := FALSE;
  SecondImage.HitTest := FALSE;
  SecondImage.Align := TAlignLayout.Client;
  SecondImage.RotationAngle := 180;

  CoverForDesign := TRectangle.Create( self );
  CoverForDesign.Parent := self;
  CoverForDesign.Stored := FALSE;
  CoverForDesign.Align := TAlignLayout.Contents;
  CoverForDesign.HitTest := FALSE;
  CoverForDesign.Fill.Kind   := TBrushKind.None;
  CoverForDesign.Stroke.Kind := TBrushKind.None;
  CoverForDesign.BringToFront;

  if not (csDesigning in ComponentState) then
  begin
    FTimer := TTimer.Create(AOwner);
    FTimer.OnTimer := OnTimer;
    FTimer.Interval := 1000;
    FTimer.Enabled := True;
  end;

end;

destructor TRDLAnalogClock.Destroy;
begin
  C2FreeRelease( CoverForDesign );
  C2FreeRelease( PanelImage );
  C2FreeRelease( SizeLay );

  FreeAndNil( FBitmapHour );
  FreeAndNil( FBitmapMinute );
  FreeAndNil( FBitmapHour );
  FreeAndNil( FBitmapPanel );

  FreeAndNil( FTimer );

  inherited;
end;

procedure TRDLAnalogClock.Paint;
begin
  inherited;

  AutoSizeSet();

  PanelImage.Bitmap  := FBitmapPanel;
  HourImage.Bitmap   := FBitmapHour;
  MinuteImage.Bitmap := FBitmapMinute;
  SecondImage.Bitmap := FBitmapSecond;
end;

procedure TRDLAnalogClock.OnTimer(Sender: TObject);
var
  CurTime : TTime;
  hourSet, MinSet : Integer;
begin
  CurTime := now;

  hourSet := FormatDateTime( 'hh', CurTime ).ToInteger;
  hourSet := hourSet mod 12;

  minSet := FormatDateTime( 'nn', CurTime ).ToInteger;

  MinuteImage.RotationAngle  := minSet * 6;
  HourImage.RotationAngle := hourSet * 30 + minSet * 0.5;
  SecondImage.RotationAngle  := FormatDateTime( 'ss', CurTime ).ToInteger * 6;
end;



//---------------------------------------------------------------------
procedure TRDLAnalogClock.SetBitmapPanel(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapPanel.Assign(Value);
end;

procedure TRDLAnalogClock.SetBitmapHour(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapHour.Assign(Value);
end;

procedure TRDLAnalogClock.SetBitmapMinute(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapMinute.Assign(Value);
end;

procedure TRDLAnalogClock.SetBitmapSecond(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapSecond.Assign(Value);
end;


initialization
  RegisterFMXClasses([TRDLAnalogClock]);


end.
