unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, RDLuAnalogClock, FMX.Objects;

type
  TForm2 = class(TForm)
    RDLAnalogClock1: TRDLAnalogClock;
    RDLAnalogClock2: TRDLAnalogClock;
    RDLAnalogClock3: TRDLAnalogClock;
    RDLAnalogClock4: TRDLAnalogClock;
    RDLAnalogClock5: TRDLAnalogClock;
    RDLAnalogClock6: TRDLAnalogClock;
    Circle1: TCircle;
    Layout1: TLayout;
    Text3: TText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

end.
