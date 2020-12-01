program GBSampleStompClient;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {frmMain},
  GBStomp.Interfaces in '..\..\source\GBStomp.Interfaces.pas',
  GBStomp.Messenger.RequestParam in '..\..\source\GBStomp.Messenger.RequestParam.pas',
  GBStomp.Messenger.ResponseParam in '..\..\source\GBStomp.Messenger.ResponseParam.pas',
  GBStomp.StompClient in '..\..\source\GBStomp.StompClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
