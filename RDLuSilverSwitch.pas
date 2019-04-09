unit RDLuSilverSwitch;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Types,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Objects, FMX.Graphics;

type
  TRDLSilverSwitch = class(TLayout)
  private
    FOnChange   : TNotifyEvent;
    FColorOFF,
    FColorOn      : TAlphaColor;
    FIsChecked    : Boolean;

    SizeLay   : TRectangle;
    BackRound : TRoundRect;
    SWCircle  : TCircle;

    { Private declarations }
    procedure C2FreeRelease(tarObject: TFmxObject);
    procedure AutoSizeSet;
    procedure SwitchMode_Set;
    procedure Check_Set;

    procedure SetColorOff(const Value: TAlphaColor);
    procedure SetColorON(const Value: TAlphaColor);
    procedure SetIsChecked(const Value: Boolean);

  protected
    { Protected declarations }
    procedure Paint; override;
    procedure Click; override;

    procedure Change(Sender: TObject); dynamic;

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

    property OnChange        : TNotifyEvent read FOnChange write FOnChange;
    property ColorOFF        : TAlphaColor read FColorOFF write SetColorOFF;
    property ColorON         : TAlphaColor read FColorON  write SetColorON;
    property IsChecked       : Boolean read FIsChecked write SetIsChecked;

  end;

procedure Register;

implementation

Uses
  PSetcontrLAB;

procedure Register;
begin
  RegisterComponents('Rapid Design LAB', [TRDLSilverSwitch]);
end;

procedure TRDLSilverSwitch.C2FreeRelease(tarObject: TFmxObject);
begin
  if Assigned( tarObject ) then
     tarObject.Release;
end;

procedure TRDLSilverSwitch.AutoSizeSet();
var
  baseL : single;
begin
  if self.Width <= self.Height then
  begin
    baseL := self.Width;

    SizeLay.Width  := baseL;
    SizeLay.Height := baseL / 2;

    SizeLay.Position.X := 0;
    SizeLay.Position.Y := self.Height/2 - SizeLay.Height/2;
  end
  else
  begin
    baseL := self.Height;

    SizeLay.Width  := baseL * 2;
    SizeLay.Height := baseL;

    SizeLay.Position.Y := 0;
    SizeLay.Position.X := self.Width/2 - SizeLay.Width/2;
  end;
end;

{ TRDLSwitch }

constructor TRDLSilverSwitch.Create(AOwner: TComponent);
var
  rs : TResourceStream;
begin
  inherited;

  FIsChecked  := FALSE;

  FColorOFF    := $FFc0c0c0;
  FColorON     := $FFDC143C;

  self.Width   := 80;
  self.Height  := 40;
  self.HitTest := TRUE;

  SizeLay := TRectangle.Create(self);
  SizeLay.Parent := self;
  SizeLay.Stored := FALSE;
  SizeLay.Width  := self.Width;
  SizeLay.Height := self.Height;
  SizeLay.HitTest := FALSE;
  SizeLay.Fill.Kind   := TBrushKind.None;
  SizeLay.Stroke.Kind := TBrushKind.None;

  BackRound := TRoundRect.Create(SizeLay);
  BackRound.Parent := SizeLay;
  BackRound.Stored  := FALSE;
  BackRound.HitTest := FALSE;
  BackRound.Align   := TAlignLayout.Contents;
  BackRound.Stroke.Kind := TBrushKind.None;
  BackRound.Fill.Color   := FColorOFF;

  SWCircle := TCircle.Create(SizeLay);
  SWCircle.Parent  := SizeLay;
  SWCircle.Stored  := FALSE;
  SWCircle.HitTest := FALSE;
  SWCircle.Align   := TAlignLayout.Left;
  SWCircle.Stroke.Kind := TBrushKind.None;
  SWCircle.Fill.Kind   := TBrushKind.Bitmap;
  SWCircle.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;

  if ( FindResource( hInstance, 'SWITCH_C', RT_RCDATA) > 0 ) then
  begin
    rs := TResourceStream.Create(hInstance, 'SWITCH_C', RT_RCDATA);  //  System.Types
    try
      SWCircle.Fill.Bitmap.Bitmap.LoadFromStream( rs );
    finally
      rs.Free;
    end;
  end;

end;

destructor TRDLSilverSwitch.Destroy;
begin
  C2FreeRelease( SWCircle );
  C2FreeRelease( BackRound );
  C2FreeRelease( SizeLay );

  inherited;
end;

procedure TRDLSilverSwitch.Paint;
begin
  inherited;

  AutoSizeSet();
  SwitchMode_Set();
  Check_Set();
end;


procedure TRDLSilverSwitch.Click;
begin
  FIsChecked := not FIsChecked;

  Change( self );
  Check_Set();

  inherited;
end;

procedure TRDLSilverSwitch.Change(Sender: TObject);
begin
  if Assigned( FOnChange ) then
     FOnChange( self );

  Check_Set();
end;

//--------------------------------------------------------------
procedure TRDLSilverSwitch.SetColorOFF(const Value: TAlphaColor);
begin
  if Value <> FColorOFF then FColorOFF := Value;
end;

procedure TRDLSilverSwitch.SetColorON(const Value: TAlphaColor);
begin
  if Value <> FColorON then FColorON := Value;
end;


procedure TRDLSilverSwitch.SetIsChecked(const Value: Boolean);
begin
  if Value <> FIsChecked then
  begin
    FIsChecked := Value;

    if not (csLoading in ComponentState) then
       Change( self );
  end;
end;


//---------------------------------------------
procedure TRDLSilverSwitch.SwitchMode_Set();
var
  rate : single;
begin
  rate := SizeLay.Height * 0.2; // 20%

  SWCircle.Margins.Left   := -rate;
  SWCircle.Margins.Right  := -rate;
  SWCircle.Margins.Top    := -rate / 2;
  SWCircle.Margins.Bottom := -rate / 2;
  SWCircle.Width  := SizeLay.Height + SizeLay.Height * 0.2;
  SWCircle.Height := SWCircle.Width;
end;

procedure TRDLSilverSwitch.Check_Set();
begin
  if FIsChecked then                       // On
  begin
    SWCircle.Align := TAlignLayout.Right;
    BackRound.Fill.Color := FColorON;
  end
  else                                     // Off
  begin
    SWCircle.Align := TAlignLayout.Left;
    BackRound.Fill.Color := FColorOFF;
  end;
end;



initialization
  RegisterFMXClasses([TRDLSilverSwitch]);


end.
