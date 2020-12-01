unit ThreadReceiver;

interface

uses
  System.Classes,
  StompClient;

type
  TThreadResponseString = reference to procedure (Value : iStompFrame); // of Object;

  TThreadReceiver = class(TThread)
  private
    FStompClient: IStompClient;
    FStompFrame: IStompFrame;
    FResponseString : TThreadResponseString;
    procedure SetStompClient(const Value: IStompClient);
  protected
    procedure Execute; override;
  public
    procedure ReceiveAlarmMemo;
    procedure UpdateMessageMemo;
    procedure UpdateMessageIdEdit;
    procedure ResponseString(Value : TThreadResponseString);
    constructor Create(CreateSuspended: Boolean); overload;
    property StompClient: IStompClient read FStompClient write SetStompClient;
  end;

implementation

uses System.SysUtils;

{ TThreadReceiver }

constructor TThreadReceiver.Create(CreateSuspended: Boolean);
begin
  FStompFrame := StompUtils.CreateFrame;
  inherited Create(CreateSuspended);
end;

procedure TThreadReceiver.Execute;
begin
  NameThreadForDebugging('ThreadReceiver');

  while not Terminated do
  begin
    if FStompClient.Receive(FStompFrame, 2000) then
    begin
      Sleep(100);
      Synchronize(ReceiveAlarmMemo);
      Synchronize(UpdateMessageIdEdit);
    end
    else
    begin
      Synchronize(UpdateMessageMemo);
    end;
  end;
end;

procedure TThreadReceiver.ReceiveAlarmMemo;
begin
  FResponseString(FStompFrame);
end;

procedure TThreadReceiver.ResponseString(Value: TThreadResponseString);
begin
  FResponseString := Value;
end;

procedure TThreadReceiver.SetStompClient(const Value: IStompClient);
begin
  FStompClient := Value;
end;

procedure TThreadReceiver.UpdateMessageIdEdit;
begin
  //ReceiverMainForm.MessageIdEdit.Text := FStompFrame.GetHeaders.Value('message-id');
end;

procedure TThreadReceiver.UpdateMessageMemo;
begin
  //ReceiverMainForm.MessageMemo.Lines.Add('Wait Messages....');
end;

end.
