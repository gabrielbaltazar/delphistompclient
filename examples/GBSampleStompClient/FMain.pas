unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  GBStomp.Interfaces;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    edtPubQueue: TEdit;
    Label1: TLabel;
    edtPubExchange: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtHost: TEdit;
    Label4: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    Label5: TLabel;
    btnConnect: TButton;
    btnSendExchangeMessage: TButton;
    btnSendQueueMessage: TButton;
    mmoSendMessage: TMemo;
    Label6: TLabel;
    edtSubscribeQueue: TEdit;
    btnSubscribeQueue: TButton;
    mmoSubscribeQueue: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSubscribeQueueClick(Sender: TObject);
    procedure btnSendQueueMessageClick(Sender: TObject);
    procedure btnSendExchangeMessageClick(Sender: TObject);
  private
    FMessenger: IGBStompMessenger;

    procedure OnReceiveMessage(AParam: IGBStompMessengerResponseParam);
    procedure Log(Value: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  FMessenger.Disconnect;
  FMessenger
    .Host(edtHost.Text)
    .Username(edtUsername.Text)
    .Password(edtPassword.Text)
    .OnLog(Log)
    .Connect;

  ShowMessage('Conectado');
end;

procedure TfrmMain.btnSendExchangeMessageClick(Sender: TObject);
var
  pub: IGBStompMessenger;
  request: IGBStompMessengerRequest;
begin
  pub := NewStompMessenger;
  pub.Host(edtHost.Text)
     .Username(edtUsername.Text)
     .Password(edtPassword.Text)
     .Connect;

  request := NewRequestMessage;
  request
    .Exchange(edtPubExchange.Text)
    .Route('routeTeste')
    .Body(mmoSendMessage.Lines.Text);

  pub.SendExchangeMessage(request);
end;

procedure TfrmMain.btnSendQueueMessageClick(Sender: TObject);
var
  pub: IGBStompMessenger;
  request: IGBStompMessengerRequest;
begin
  pub := NewStompMessenger;
  pub.Host(edtHost.Text)
     .Username(edtUsername.Text)
     .Password(edtPassword.Text)
     .Connect;

  request := NewRequestMessage;
  request
    .Queue(edtPubQueue.Text)
    .Body(mmoSendMessage.Lines.Text);

  pub.SendQueueMessage(request);
end;

procedure TfrmMain.btnSubscribeQueueClick(Sender: TObject);
begin
  FMessenger.Subscribe(edtSubscribeQueue.Text, OnReceiveMessage);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMessenger := NewStompMessenger;
end;

procedure TfrmMain.Log(Value: String);
begin
  mmoSubscribeQueue.Lines.Add(Value);
end;

procedure TfrmMain.OnReceiveMessage(AParam: IGBStompMessengerResponseParam);
begin
  mmoSubscribeQueue.Lines.Text := AParam.Body;
end;

end.
