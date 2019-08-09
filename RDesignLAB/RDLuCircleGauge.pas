unit RDLuCircleGauge;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Layouts, FMX.Graphics, FMX.Objects;

type
  TRDLCircleGauge = class(TLayout)
  private
    { Private declarations  }
    FBitmapPanel,
    FBitmapNeedle : TBitmap;
    FTextLabel : string;
    FTextFont : TFont;
    FTextColor : TAlphaColor;
    FTextBottomMargin : integer;

    FValueAngle  : single;

    SizeLay : TLayout;
    PanelImage,
    NeedleImage : TImage;
    LabelText : TText;
    CoverForDesign : TRectangle;

    procedure C2FreeRelease(tarObject: TFmxObject);
    procedure AutoSizeSet();

    procedure SetBitmapPanel(const Value: TBitmap);
    function GetTextLabel: string;
    procedure SetTextLabel(const Value: string);
    procedure SetTextColor(const Value: TAlphaColor);
    procedure SetTextFont(const Value: TFont);
    procedure SetTextBottomMargin(const Value: integer);
    procedure SetBitmapNeedle(const Value: TBitmap);

    procedure SetValueAngle(const Value: single);

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

    property BitmapPanel       : TBitmap read FBitmapPanel write SetBitmapPanel;
    property BitmapNeedle      : TBitmap read FBitmapNeedle write SetBitmapNeedle;
    property TextLabel         : string read GetTextLabel write SetTextLabel;
    property TextFont          : TFont read FTextFont write SetTextFont;
    property TextColor         : TAlphaColor read FTextColor write SetTextColor;
    property TextBottomMargin  : integer read FTextBottomMargin write SetTextBottomMargin;

    property ValueAngle        : single read FValueAngle write SetValueAngle nodefault;

  end;

procedure Register;

implementation

uses
  PSetcontrLAB;


procedure Register;
begin
  RegisterComponents('Rapid Design LAB', [TRDLCircleGauge]);
end;

{ TRDLCircleGauge }

procedure TRDLCircleGauge.C2FreeRelease(tarObject: TFmxObject);
begin
  if Assigned( tarObject ) then
     tarObject.Release;
end;

procedure TRDLCircleGauge.AutoSizeSet();
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


constructor TRDLCircleGauge.Create(AOwner: TComponent);
var
  rs1, rs2 : TResourceStream;
begin
  inherited;

  FValueAngle := -120;

  FBitmapPanel  := TBitmap.Create;
  FBitmapNeedle := TBitmap.Create;

  FTextLabel := 'HUMIDITY(%)';
  FTextFont  := TFont.Create;
  FTextColor := TAlphaColorRec.Whitesmoke;
  FTextBottomMargin := 140;


  if ( FindResource( hInstance, 'IMAGE_P', RT_RCDATA) > 0 ) then
  begin
    rs1 := TResourceStream.Create(hInstance, 'IMAGE_P', RT_RCDATA);  //  System.Types
    try
      FBitmapPanel.LoadFromStream( rs1 );
    finally
      rs1.Free;
    end;
  end;

  if ( FindResource( hInstance, 'IMAGE_N', RT_RCDATA) > 0 ) then
  begin
    rs2 := TResourceStream.Create(hInstance, 'IMAGE_N', RT_RCDATA);  //  System.Types
    try
      FBitmapNeedle.LoadFromStream( rs2 );
    finally
      rs2.Free;
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

  LabelText := TText.Create(SizeLay);
  LabelText.Parent := SizeLay;
  LabelText.Stored := FALSE;
  LabelText.HitTest := FALSE;
  LabelText.Align := TAlignLayout.Center;
  LabelText.AutoSize := TRUE;
  LabelText.WordWrap := FALSE;

  NeedleImage := TImage.Create(PanelImage);
  NeedleImage.Parent := PanelImage;
  NeedleImage.Stored := FALSE;
  NeedleImage.HitTest := FALSE;
  NeedleImage.Align := TAlignLayout.Client;
  NeedleImage.RotationAngle := FValueAngle;


  CoverForDesign := TRectangle.Create( self );   // TText 위에도 다른 컴포넌트 올라가지 않아서 위에 커버 쒸움.
  CoverForDesign.Parent := self;
  CoverForDesign.Stored := FALSE;
  CoverForDesign.Align := TAlignLayout.Contents;
  CoverForDesign.HitTest := FALSE;
  CoverForDesign.Fill.Kind   := TBrushKind.None;
  CoverForDesign.Stroke.Kind := TBrushKind.None;  // 투명처리
  CoverForDesign.BringToFront;
end;

destructor TRDLCircleGauge.Destroy;
begin
  C2FreeRelease( CoverForDesign );
  C2FreeRelease( NeedleImage );
  C2FreeRelease( LabelText );
  C2FreeRelease( PanelImage );
  C2FreeRelease( SizeLay );

  FreeAndNil( FTextFont );
  FreeAndNil( FBitmapNeedle );
  FreeAndNil( FBitmapPanel );

  inherited;
end;


procedure TRDLCircleGauge.Paint;
begin
  inherited;

  AutoSizeSet();

  PanelImage.Bitmap  := FBitmapPanel;
  NeedleImage.Bitmap := FBitmapNeedle;

  LabelText.Text := FTextLabel;
  LabelText.Font := FTextFont;
  LabelText.Color := FTextColor;
  LabelText.Margins.Bottom :=  - ( SizeLay.Height - FTextBottomMargin );
end;

//---------------------------------------------------------------------
procedure TRDLCircleGauge.SetValueAngle(const Value: single);
begin
  FValueAngle := Value;
  NeedleImage.RotationAngle := FValueAngle;
end;

//---------------------------------------------------------------------
procedure TRDLCircleGauge.SetBitmapPanel(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapPanel.Assign(Value);
end;

procedure TRDLCircleGauge.SetBitmapNeedle(const Value: TBitmap);
begin
  if Assigned(Value) then FBitmapNeedle.Assign(Value);
end;

procedure TRDLCircleGauge.SetTextLabel(const Value: string);
begin
  FTextLabel := Value;
end;

procedure TRDLCircleGauge.SetTextColor(const Value: TAlphaColor);
begin
  if Value <> FTextColor then FTextColor := Value;
end;

procedure TRDLCircleGauge.SetTextFont(const Value: TFont);
begin
  if Assigned(Value) then FTextFont.Assign(Value);
end;

procedure TRDLCircleGauge.SetTextBottomMargin(const Value: integer);
begin
  FTextBottomMargin := Value;
end;

function TRDLCircleGauge.GetTextlabel: string;
begin
  Result := FTextLabel;
end;



initialization
  RegisterFMXClasses([TRDLCircleGauge]);


end.
