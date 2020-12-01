program GBSampleStompClient;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {Form1},
  GBStomp.Interfaces in '..\..\source\GBStomp.Interfaces.pas',
  GBStomp.Messenger.RequestParam in '..\..\source\GBStomp.Messenger.RequestParam.pas',
  GBStomp.Messenger.ResponseParam in '..\..\source\GBStomp.Messenger.ResponseParam.pas',
  GBStomp.StompClient in '..\..\source\GBStomp.StompClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
