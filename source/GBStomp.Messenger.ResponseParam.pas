unit GBStomp.Messenger.ResponseParam;

interface

uses
  GBStomp.Interfaces,
  StompClient,
  System.SysUtils,
  System.Classes,
  System.JSON;

type TGBStompMessengerResponseParam = class(TInterfacedObject, IGBStompMessengerResponseParam)

  private
    FStompFrame: IStompFrame;
    FHeaders   : TStrings;
    FJSONValue : TJSONValue;

    procedure setHeaders;
  protected
    function MessageID  : string;
    function Body       : string;
    function Headers    : TStrings;
    function JSONValue  : TJSONValue;
    function JSONObject : TJSONObject;
    function JSONArray  : TJSONArray;

  public
    constructor create(AStompFrame: IStompFrame);
    class function New(AStompFrame: IStompFrame): IGBStompMessengerResponseParam;
    destructor Destroy; override;
end;

implementation

{ TGBStompMessengerResponseParam }

function TGBStompMessengerResponseParam.Body: string;
begin
  result := FStompFrame.Body;
end;

constructor TGBStompMessengerResponseParam.create(AStompFrame: IStompFrame);
begin
  FStompFrame := AStompFrame;
  setHeaders;
end;

destructor TGBStompMessengerResponseParam.Destroy;
begin
  FHeaders.Free;
  FJSONValue.Free;
  inherited;
end;

function TGBStompMessengerResponseParam.Headers: TStrings;
begin
  result := FHeaders;
end;

function TGBStompMessengerResponseParam.JSONArray: TJSONArray;
begin
  result := JSONValue as TJSONArray;
end;

function TGBStompMessengerResponseParam.JSONObject: TJSONObject;
begin
  result := JSONValue as TJSONObject;
end;

function TGBStompMessengerResponseParam.JSONValue: TJSONValue;
begin
  if not Assigned(FJSONValue) then
    FJSONValue := TJSONObject.ParseJSONValue(FStompFrame.Body);
  result := FJSONValue;
end;

function TGBStompMessengerResponseParam.MessageID: string;
begin
  result := FStompFrame.MessageID;
end;

class function TGBStompMessengerResponseParam.New(AStompFrame: IStompFrame): IGBStompMessengerResponseParam;
begin
  result := Self.create(AStompFrame);
end;

procedure TGBStompMessengerResponseParam.setHeaders;
var
  i: Integer;
begin
  FHeaders := TStringList.Create;
  for i := 0 to Pred(FStompFrame.Headers.Count) do
  begin
    FHeaders.AddPair(FStompFrame.Headers.GetAt(i).Key,
                     FStompFrame.Headers.GetAt(i).Value);
  end;
end;

end.
