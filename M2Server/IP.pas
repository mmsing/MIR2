unit IP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, StrUtils, DateUtils, shellapi, untTQQWry;

type
  TFormIP = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Buttonip: TButton;
    Label1: TLabel;
    procedure ButtonipClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; x,
      y: Integer);
    procedure Label1MouseLeave(Sender: TObject);
  private
    QQWry: TQQWry;
{ Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  FormIP: TFormIP;

implementation

{$R *.dfm}


procedure TFormIP.Open;

begin
  TFormIP.Create(Owner);
  ShowModal;
end;


procedure TFormIP.ButtonipClick(Sender: TObject);
var

  slIPData: TStringList;
  IPRecordID: int64;
  StartIPDataID, EndIPDataID: int64;
  TimeCounter: dword;
begin

//    if Edit1.Text = '' then begin
//      Application.MessageBox('�����IP��ַ��ʽ����ȷ������', '������Ϣ', MB_OK + MB_ICONERROR);
//     Exit;
//    end;
  if FileExists('.\QQWry.dat') then
  begin
  end else
  begin
    Memo1.Lines.Add('IP���ݿ��ļ�<QQWry.dat>δ�ҵ����޷����в�ѯ��');
  end;



 //Screen.Cursor:=crHourglass;
 //IP��ַ->��ַ��Ϣ
  begin
    try
      QQWry := TQQWry.Create(Edit1.Text);
      IPRecordID := QQWry.GetIPDataID(Edit1.Text);
      slIPData := TStringList.Create;
      QQWry.GetIPDataByIPRecordID(IPRecordID, slIPData);
      QQWry.Destroy;
      //Memo1.Lines.Add(Format('ID: %d IP: %s - %s ����: %s ����: %s',
      //  [IPRecordID, slIPData[0], slIPData[1], slIPData[2], slIPData[3]]));  //ID: 119581 IP: 127.0.0.1 - 127.0.0.1 ����: ������ַ ����: CZ88.NET

      Memo1.Lines.Add(Format('ID: %d IP: %s - %s ����: %s',
        [IPRecordID, slIPData[0], slIPData[1], slIPData[2]]));

      slIPData.Free;
    except
      on E: Exception do
      begin
  //msgbox(E.Message, OKOnly + Critical, '����');

        Application.MessageBox('�����IP��ַ��ʽ����ȷ������', '������Ϣ', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    Exit;
  end;
end;
procedure TFormIP.Label1Click(Sender: TObject);
begin
  // ShellExecute(Application.Handle, 'Open', PChar('http://update.***.net/soft/qqwry.rar'), nil, nil, sw_ShowNormal);
end;

procedure TFormIP.Label1MouseMove(Sender: TObject; Shift: TShiftState; x,
  y: Integer);
begin
  //Label1.Font.Color := clRed;
  Label1.Font.Color := clBlue;
end;

procedure TFormIP.Label1MouseLeave(Sender: TObject);
begin
  Label1.Font.Color := clBlue;
end;

end.
