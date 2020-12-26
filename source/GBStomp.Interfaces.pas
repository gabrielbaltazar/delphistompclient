unit GBStomp.Interfaces;

interface

uses
  System.Classes,
  System.JSON;

type
  IGBStompMessengerRequest = interface;
  IGBStompMessengerResponseParam = interface;

  TOnMessengerReceive = reference to procedure (AParam: IGBStompMessengerResponseParam);
  TOnMessengerLog = reference to procedure (Value: string);

  IGBStompMessenger = interface
    ['{E7605D97-361D-4FAB-A57C-0C0E6706A04A}']
    function Host(Value: String): IGBStompMessenger;
    function Username(Value: String): IGBStompMessenger;
    function Password(Value: String): IGBStompMessenger;

    function Connect: IGBStompMessenger;
    function Disconnect: IGBStompMessenger;

    function SendExchangeMessage(AExchange, ARoute, AMessage: String): IGBStompMessenger; overload;
    function SendExchangeMessage(Request: IGBStompMessengerRequest): IGBStompMessenger; overload;

    function SendQueueMessage(AQueue, AMessage: String): IGBStompMessenger; overload;
    function SendQueueMessage(Request: IGBStompMessengerRequest): IGBStompMessenger; overload;

    function Subscribe  (AQueueName: string; AOnReceive: TOnMessengerReceive): IGBStompMessenger;
    function UnSubscribe(AQueueName: String): IGBStompMessenger;
    function UnSubscribeAll: IGBStompMessenger;

    function OnLog(Value: TOnMessengerLog): IGBStompMessenger;
  end;

  IGBStompMessengerRequest = interface
    ['{B6B3FF56-F79E-431A-8EAB-45A0DAEC7750}']
    function Headers: TStrings;
    function Properties: TStrings;

    function Body(Value: String): IGBStompMessengerRequest; overload;
    function Body: string; overload;

    function Exchange(Value: String): IGBStompMessengerRequest; overload;
    function Exchange: string; overload;

    function Queue(Value: String): IGBStompMessengerRequest; overload;
    function Queue: String; overload;

    function Route: String; overload;
    function Route(Value: String): IGBStompMessengerRequest; overload;
  end;

  IGBStompMessengerResponseParam = interface
    ['{D8FE1950-2306-4DCB-A0C6-48BCE5EB7D7A}']
    function MessageID  : string;
    function Body       : string;
    function Headers    : TStrings;
    function JSONObject : TJSONObject;
    function JSONArray  : TJSONArray;
  end;

function NewStompMessenger: IGBStompMessenger;
function NewRequestMessage: IGBStompMessengerRequest;

implementation

uses
  GBStomp.StompClient,
  GBStomp.Messenger.RequestParam;

function NewStompMessenger: IGBStompMessenger;
begin
  result := TGBStompMessenger.New;
end;

function NewRequestMessage: IGBStompMessengerRequest;
begin
  result := TGBStompRequestParam.New;
end;

end.
