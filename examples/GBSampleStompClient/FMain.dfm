object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmMain'
  ClientHeight = 391
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 713
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 87
      Height = 35
      Margins.Left = 10
      Align = alLeft
      Caption = 'Messenger'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 19
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 713
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 167
      Top = 77
      Width = 32
      Height = 13
      Caption = 'Queue'
    end
    object Label2: TLabel
      Left = 10
      Top = 77
      Width = 47
      Height = 13
      Caption = 'Exchange'
    end
    object Label3: TLabel
      Left = 10
      Top = 21
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label4: TLabel
      Left = 167
      Top = 21
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object Label5: TLabel
      Left = 324
      Top = 21
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label6: TLabel
      Left = 391
      Top = 77
      Width = 32
      Height = 13
      Caption = 'Queue'
    end
    object edtPubQueue: TEdit
      Left = 167
      Top = 92
      Width = 151
      Height = 21
      TabOrder = 0
      Text = 'teste'
    end
    object edtPubExchange: TEdit
      Left = 10
      Top = 92
      Width = 151
      Height = 21
      TabOrder = 1
      Text = 'exteste'
    end
    object edtHost: TEdit
      Left = 10
      Top = 36
      Width = 151
      Height = 21
      TabOrder = 2
      Text = '127.0.0.1'
    end
    object edtUsername: TEdit
      Left = 167
      Top = 36
      Width = 151
      Height = 21
      TabOrder = 3
      Text = 'guest'
    end
    object edtPassword: TEdit
      Left = 324
      Top = 36
      Width = 151
      Height = 21
      TabOrder = 4
      Text = 'guest'
    end
    object btnConnect: TButton
      Left = 481
      Top = 34
      Width = 96
      Height = 25
      Caption = 'Connect'
      TabOrder = 5
      OnClick = btnConnectClick
    end
    object btnSendExchangeMessage: TButton
      Left = 10
      Top = 119
      Width = 151
      Height = 25
      Caption = 'Send Exchange Message'
      TabOrder = 6
      OnClick = btnSendExchangeMessageClick
    end
    object btnSendQueueMessage: TButton
      Left = 167
      Top = 119
      Width = 151
      Height = 25
      Caption = 'Send Queue Message'
      TabOrder = 7
      OnClick = btnSendQueueMessageClick
    end
    object mmoSendMessage: TMemo
      Left = 10
      Top = 150
      Width = 308
      Height = 187
      TabOrder = 8
    end
    object edtSubscribeQueue: TEdit
      Left = 391
      Top = 92
      Width = 151
      Height = 21
      TabOrder = 9
      Text = 'teste'
    end
    object btnSubscribeQueue: TButton
      Left = 391
      Top = 119
      Width = 151
      Height = 25
      Caption = 'Subscribe Queue'
      TabOrder = 10
      OnClick = btnSubscribeQueueClick
    end
    object mmoSubscribeQueue: TMemo
      Left = 391
      Top = 150
      Width = 308
      Height = 187
      TabOrder = 11
    end
  end
end
