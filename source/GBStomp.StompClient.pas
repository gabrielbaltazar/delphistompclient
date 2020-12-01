unit GBStomp.StompClient;

interface

uses
  GBStomp.Interfaces,
  GBStomp.Messenger.RequestParam,
  GBStomp.Messenger.ResponseParam,
  StompClient,
  ThreadReceiver,
  System.Generics.Collections,
  System.SysUtils;

type TGBStompMessenger = class(TInterfacedObject, IGBStompMessenger)

  private
    procedure OnResponse(StompFrame: IStompFrame);

    procedure Log(ALogText: string); overload;
    procedure Log(ALogText: string; const Args: array of const); overload;

  protected
    FQueueList      : TDictionary<String, TOnMessengerReceive>;
    FHost           : string;
    FUsername       : string;
    FPassword       : string;
    FOnLog          : TOnMessengerLog;
    FStompClient    : IStompClient;
    FThreadReceiver : TThreadReceiver;

    function GetStompClient: IStompClient;

    property Client: IStompClient read GetStompClient;

    function Host    (Value: String): IGBStompMessenger;
    function Username(Value: String): IGBStompMessenger;
    function Password(Value: String): IGBStompMessenger;

    function Connect    : IGBStompMessenger;
    function Disconnect : IGBStompMessenger;

    function SendExchangeMessage(AExName, ARoute, AMessage: String): IGBStompMessenger; overload;
    function SendExchangeMessage(Request: IGBStompMessengerRequest): IGBStompMessenger; overload;

    function SendQueueMessage(AQueue, AMessage: String): IGBStompMessenger; overload;
    function SendQueueMessage(Request: IGBStompMessengerRequest): IGBStompMessenger; overload;

    function Subscribe  (AQueueName: string; AOnReceive: TOnMessengerReceive): IGBStompMessenger;
    function UnSubscribe(AQueueName: String): IGBStompMessenger;
    function UnSubscribeAll: IGBStompMessenger;

    function OnLog(Value: TOnMessengerLog): IGBStompMessenger;
  public
    constructor create;
    class function New: IGBStompMessenger;
    destructor Destroy; override;
end;

implementation

{ TGBStompMessenger }

function TGBStompMessenger.Connect: IGBStompMessenger;
begin
  try
    result := Self;
    if not Client.Connected then
    begin
      Log('Connecting on Server %s', [FHost]);
      Client.SetHost(FHost)
            .SetUserName(FUsername)
            .SetPassword(FPassword)
            .Connect;

      Log('Connected on Server %s', [FHost]);
    end;
  except
    on e : Exception do
    begin
      e.Message := 'Error on Connect: ' + e.Message;
      Log(e.Message);
      raise;
    end;
  end;
end;

constructor TGBStompMessenger.create;
begin
  FHost     := '127.0.0.1';
  FUsername := 'guest';
  FPassword := 'guest';
end;

destructor TGBStompMessenger.Destroy;
begin
  UnSubscribeAll;
  FQueueList.Free;
  FThreadReceiver.Free;
  inherited;
end;

function TGBStompMessenger.Disconnect: IGBStompMessenger;
begin
  result := Self;
  Client.Disconnect;
  Log('Disconnected on Server');
end;

function TGBStompMessenger.GetStompClient: IStompClient;
begin
  if not Assigned(FStompClient) then
    FStompClient := StompUtils.StompClient;
  result := FStompClient;
end;

function TGBStompMessenger.Host(Value: String): IGBStompMessenger;
begin
  result := Self;
  FHost  := Value;
end;

procedure TGBStompMessenger.Log(ALogText: string; const Args: array of const);
begin
  Log(Format(ALogText, Args));
end;

procedure TGBStompMessenger.Log(ALogText: string);
begin
  if not Assigned(FOnLog) then
    Exit;

  FOnLog(ALogText);
end;

class function TGBStompMessenger.New: IGBStompMessenger;
begin
  result := Self.Create;
end;

function TGBStompMessenger.OnLog(Value: TOnMessengerLog): IGBStompMessenger;
begin
  result := Self;
  FOnLog := Value;
end;

procedure TGBStompMessenger.OnResponse(StompFrame: IStompFrame);
var
  responseParam: IGBStompMessengerResponseParam;
  queueName    : string;
  onReceive    : TOnMessengerReceive;
begin
  responseParam := TGBStompMessengerResponseParam.New(StompFrame);
  queueName     := Copy(StompFrame.MessageID, 10, Pos('@', StompFrame.MessageID) - 10);

  if FQueueList.TryGetValue(queueName, onReceive) then
    onReceive(responseParam);
end;

function TGBStompMessenger.Password(Value: String): IGBStompMessenger;
begin
  result    := Self;
  FPassword := Value;
end;

function TGBStompMessenger.SendExchangeMessage(Request: IGBStompMessengerRequest): IGBStompMessenger;
var
  headers : IStompHeaders;
  i: Integer;
begin
  result := Self;
  if not Client.Connected then
    Connect;

  headers := StompUtils.Headers;
  for i := 0 to Pred(Request.Headers.Count) do
    headers.Add(Request.Headers.Names[i], Request.Headers.ValueFromIndex[i]);

  Client.Send(Format('/exchange/%s/%s', [Request.Exchange, Request.Route]),
              Request.Body,
              headers);
end;

function TGBStompMessenger.SendExchangeMessage(AExName, ARoute, AMessage: String): IGBStompMessenger;
begin
  Result := Self;
  if not Client.Connected then
    Connect;

  Client.Send(Format('/exchange/%s/%s', [AExName, ARoute]),
              AMessage);
end;

function TGBStompMessenger.SendQueueMessage(AQueue, AMessage: String): IGBStompMessenger;
begin
  Result := Self;
  if not Client.Connected then
    Connect;

  Client.Send(Format('/queue/%s', [AQueue]),
              AMessage);
end;

function TGBStompMessenger.SendQueueMessage(Request: IGBStompMessengerRequest): IGBStompMessenger;
var
  headers : IStompHeaders;
  i: Integer;
begin
  result := Self;
  if not Client.Connected then
    Connect;

  headers := StompUtils.Headers;
  for i := 0 to Pred(Request.Headers.Count) do
    headers.Add(Request.Headers.Names[i], Request.Headers.ValueFromIndex[i]);

  Client.Send(Format('/queue/%s', [Request.Queue]),
              Request.Body,
              headers);
end;

function TGBStompMessenger.Subscribe(AQueueName: string; AOnReceive: TOnMessengerReceive): IGBStompMessenger;
begin
  result := Self;
  if not Client.Connected then
    Connect;

  if not Assigned(FThreadReceiver) then
  begin
    FThreadReceiver := TThreadReceiver.Create(True);
    FThreadReceiver.StompClient := Self.Client;
    FThreadReceiver.ResponseString(Self.OnResponse);

    if not FThreadReceiver.Started then
      FThreadReceiver.Start;
  end;

  if not Assigned(FQueueList) then
    FQueueList := TDictionary<String, TOnMessengerReceive>.Create;

  FQueueList.AddOrSetValue(AQueueName, AOnReceive);
  Client.Subscribe('/queue/' + AQueueName);

  Log('Listening a %s queue', [AQueueName]);
end;

function TGBStompMessenger.UnSubscribe(AQueueName: String): IGBStompMessenger;
begin
  result := Self;
  Client.Unsubscribe('/queue/' + AQueueName);

  if FQueueList.ContainsKey(AQueueName) then
    FQueueList.Remove(AQueueName);

  Log('Unsubscribe a %s queue', [AQueueName]);
end;

function TGBStompMessenger.UnSubscribeAll: IGBStompMessenger;
var
  Queue : string;
begin
  result := Self;
  if Assigned(FQueueList) then
  begin
    for Queue in FQueueList.Keys do
      UnSubscribe(Queue);
  end;
end;

function TGBStompMessenger.Username(Value: String): IGBStompMessenger;
begin
  result := Self;
  FUsername := Value;
end;

end.
