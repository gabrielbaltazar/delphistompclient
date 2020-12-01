unit GBStomp.Messenger.RequestParam;

interface

uses
  GBStomp.Interfaces,
  StompClient,
  System.SysUtils,
  System.Classes,
  System.JSON;

type TGBStompRequestParam = class(TInterfacedObject, IGBStompMessengerRequest)

  private
    FHeaders   : TStrings;
    FProperties: TStrings;
    FBody      : string;
    FExchange  : string;
    FQueue     : string;
    FRoute     : String;

  protected
    function Headers: TStrings;
    function Properties: TStrings;
    function Body(Value: string): IGBStompMessengerRequest; overload;
    function Body: string; overload;

    function Exchange: string; overload;
    function Exchange(Value: String): IGBStompMessengerRequest; overload;

    function Queue: string; overload;
    function Queue(Value: String): IGBStompMessengerRequest; overload;

    function Route: String; overload;
    function Route(Value: String): IGBStompMessengerRequest; overload;

  public
    constructor create;
    class function New: IGBStompMessengerRequest;
    destructor Destroy; override;

end;

implementation

{ TGBStompRequestParam }

function TGBStompRequestParam.Body(Value: string): IGBStompMessengerRequest;
begin
  result := Self;
  FBody  := Value;
end;

function TGBStompRequestParam.Body: string;
begin
  result := FBody;
end;

constructor TGBStompRequestParam.create;
begin
  FHeaders    := TStringList.Create;
  FProperties := TStringList.Create;
end;

destructor TGBStompRequestParam.Destroy;
begin
  FHeaders.Free;
  FProperties.Free;
  inherited;
end;

function TGBStompRequestParam.Exchange(Value: String): IGBStompMessengerRequest;
begin
  result    := Self;
  FExchange := Value;
end;

function TGBStompRequestParam.Exchange: string;
begin
  result := FExchange;
end;

function TGBStompRequestParam.Headers: TStrings;
begin
  result := FHeaders;
end;

class function TGBStompRequestParam.New: IGBStompMessengerRequest;
begin
  result := Self.create;
end;

function TGBStompRequestParam.Properties: TStrings;
begin
  result := FProperties;
end;

function TGBStompRequestParam.Queue: string;
begin
  result := FQueue;
end;

function TGBStompRequestParam.Queue(Value: String): IGBStompMessengerRequest;
begin
  result := Self;
  FQueue := Value;
end;

function TGBStompRequestParam.Route(Value: String): IGBStompMessengerRequest;
begin
  result := Self;
  FRoute := Value;
end;

function TGBStompRequestParam.Route: String;
begin
  result := FRoute;
end;

end.
