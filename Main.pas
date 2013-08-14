unit Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm9 = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FPrevious: string;
    function GetButtonStatus: string;
  end;

var
  Form9: TForm9;

implementation

uses
  Winapi.MMSystem, System.IOUtils;

{$R *.dfm}

procedure TForm9.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm9.Timer1Timer(Sender: TObject);
var
  Current: string;
  LogLine: string;
begin
  Current := GetButtonStatus;
  if FPrevious <> Current then
  begin
    FPrevious := Current;
    LogLine := DateTimeToStr(Now) + ' - ' + Current;
    Memo1.Lines.Add(LogLine);
    TFile.AppendAllText('joystick.log', LogLine + sLineBreak);
  end;
end;

function TForm9.GetButtonStatus: string;
var
  MyJoy: TJoyInfo;
  ErrorResult: MMRESULT;
begin
  ErrorResult := joyGetPos(JOYSTICKID1, @MyJoy);
  if ErrorResult <> JOYERR_NOERROR then
    Exit('ERROR ' + IntToStr(ErrorResult));

  Result := 'Button 1: ';
  if ((MyJoy.wButtons and joy_button1) > 0) then
    Result := Result + 'ON'
  else
    Result := Result + 'OFF';

  Result := Result + ' Button 2: ';
  if ((MyJoy.wButtons and joy_button2) > 0) then
    Result := Result + 'ON'
  else
    Result := Result + 'OFF';
end;

end.
