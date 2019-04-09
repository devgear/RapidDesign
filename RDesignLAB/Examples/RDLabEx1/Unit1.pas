unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, RDLuCircleGauge, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls;
type
  TForm1 = class(TForm)
    RDLCircleGauge1: TRDLCircleGauge;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    RDLCircleGauge2: TRDLCircleGauge;
    Text1: TText;
    Text2: TText;
    Rectangle1: TRectangle;
    RDLCircleGauge3: TRDLCircleGauge;
    RDLCircleGauge4: TRDLCircleGauge;
    TrackBar3: TTrackBar;
    RDLCircleGauge5: TRDLCircleGauge;
    RDLCircleGauge6: TRDLCircleGauge;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    Rectangle2: TRectangle;
    Text3: TText;
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


//-------------------------------------------------------------------------------------------------------------------------
//  TRDCircleGauge.ValueAngle := ( Value - MinValue ) * ( EndAngle - StartAngle ) / ( MaxValue - MinValue ) + StartAngle
// -------------------------------------------------------------------------------------------------------------------------

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  RDLCircleGauge1.ValueAngle :=  ( TrackBar1.Value - TrackBar1.Min ) * ( 126 - (-126) ) / ( TrackBar1.Max - TrackBar1.Min )  + (-126);
  Text1.Text := TrackBar1.Value.ToString;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  RDLCircleGauge2.ValueAngle :=  ( TrackBar2.Value - TrackBar2.Min ) * ( 120 - (-120) ) / ( TrackBar2.Max - TrackBar2.Min )  + (-120);
  Text2.Text := TrackBar2.Value.ToString;
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
  RDLCircleGauge3.ValueAngle :=  ( TrackBar3.Value - TrackBar3.Min ) * ( 120 - (-120) ) / ( TrackBar3.Max - TrackBar3.Min )  + (-120) ;
  RDLCircleGauge3.TextLabel := 'HUMIDITY ' +  TrackBar3.Value.ToString + ' %';
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
  RDLCircleGauge4.ValueAngle :=  ( TrackBar4.Value - TrackBar4.Min ) * ( 470 - 180 ) / ( TrackBar4.Max - TrackBar4.Min )  + 180 ;
  RDLCircleGauge4.TextLabel := TrackBar4.Value.ToString;
 end;

procedure TForm1.TrackBar5Change(Sender: TObject);
begin
  RDLCircleGauge5.ValueAngle :=  ( TrackBar5.Value - TrackBar5.Min ) * ( 136 - (-136) ) / ( TrackBar5.Max - TrackBar5.Min )  + (-136);
end;

procedure TForm1.TrackBar6Change(Sender: TObject);
begin
  RDLCircleGauge6.ValueAngle :=  ( TrackBar6.Value - TrackBar6.Min ) * ( 128 - (-132) ) / ( TrackBar6.Max - TrackBar6.Min )  + (-132);
  RDLCircleGauge6.TextLabel := Format( '%.2f', [TrackBar6.Value] );
end;

end.
