unit DlgConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,MShare,DWinCtl;

type
  TfrmDlgConfig = class(TForm)
    DlgList: TListBox;
    Label1: TLabel;
    GameWindowName: TGroupBox;
    EditTop: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    EditLeft: TSpinEdit;
    EditHeight: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    EditWidth: TSpinEdit;
    EditImage: TSpinEdit;
    Label6: TLabel;
    ButtonShow: TButton;
    GroupBox1: TGroupBox;
    EditTestX: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditTestY: TSpinEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    EditSpellTime: TSpinEdit;
    EditHitTime: TSpinEdit;
    GroupBox3: TGroupBox;
    CheckBoxDrawTileMap: TCheckBox;
    CheckBoxDrawDropItem: TCheckBox;
    GroupBox4: TGroupBox;
    Label11: TLabel;
    EditKey: TEdit;
    Label12: TLabel;
    EditServerName: TEdit;
    Label13: TLabel;
    EditRegIPaddr: TEdit;
    Label14: TLabel;
    EditRegPort: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure DlgListClick(Sender: TObject);
    procedure EditTopChange(Sender: TObject);
    procedure EditLeftChange(Sender: TObject);
    procedure EditWidthChange(Sender: TObject);
    procedure EditHeightChange(Sender: TObject);
    procedure EditImageChange(Sender: TObject);
    procedure ButtonShowClick(Sender: TObject);
    procedure EditTestYChange(Sender: TObject);
    procedure EditTestXChange(Sender: TObject);
    procedure EditSpellTimeChange(Sender: TObject);
    procedure EditHitTimeChange(Sender: TObject);
    procedure CheckBoxDrawTileMapClick(Sender: TObject);
    procedure CheckBoxDrawDropItemClick(Sender: TObject);
  private
    GameControl:pTControlInfo;
    boChange:Boolean;
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmDlgConfig: TfrmDlgConfig;

implementation

uses FState, ClMain;

{$R *.dfm}

{ TfrmDlgConfig }

procedure TfrmDlgConfig.Open;
begin
  EditTestX.Value:=g_nTestX;
  EditTestY.Value:=g_nTestY;
  EditSpellTime.Value:=g_dwSpellTime;
  EditHitTime.Value:=g_nHitTime;

  CheckBoxDrawTileMap.Checked:=g_boDrawTileMap;
  CheckBoxDrawDropItem.Checked:=g_boDrawDropItem;
  EditKey.Text        :=g_RegInfo.sKey;
  EditServerName.Text :=g_RegInfo.sServerName;
  EditRegIPaddr.Text  :=g_RegInfo.sRegSrvIP;
  EditRegPort.Text    :=IntToStr(g_RegInfo.nRegPort);

  //ShowModal();
  Show;

end;

procedure TfrmDlgConfig.FormCreate(Sender: TObject);
begin
  GameControl:=nil;
  boChange:=False;
  DlgList.AddItem('��Ϸ����̨',TObject(@DlgConf.DBottom));
  DlgList.AddItem('����״̬��ť',TObject(@DlgConf.DMyState));
  DlgList.AddItem('���ﱳ����ť',TObject(@DlgConf.DMyBag));
  DlgList.AddItem('���＼�ܰ�ť',TObject(@DlgConf.DMyMagic));
  DlgList.AddItem('��Ϸѡ�ť',TObject(@DlgConf.DOption));
  DlgList.AddItem('С��ͼ��ť',TObject(@DlgConf.DBotMiniMap));
  DlgList.AddItem('���װ�ť',TObject(@DlgConf.DBotTrade));
  DlgList.AddItem('�лᰴť',TObject(@DlgConf.DBotGuild));
  DlgList.AddItem('��Ӱ�ť',TObject(@DlgConf.DBotGroup));
  DlgList.AddItem('���Ե�����ť',TObject(@DlgConf.DBotPlusAbil));
//  DlgList.AddItem('���Ѱ�ť',TObject(@DlgConf.DBotFriend));    //lzx 2019-11-10
  DlgList.AddItem('����������ť',TObject(@DlgConf.DBotMemo));
  DlgList.AddItem('�˳���Ϸ��ť',TObject(@DlgConf.DBotExit));
  DlgList.AddItem('С����Ϸ��ť',TObject(@DlgConf.DBotLogout));
  DlgList.AddItem('�����Ʒ��ťһ',TObject(@DlgConf.DBotLogout));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt1));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt2));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt3));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt4));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt5));
  DlgList.AddItem('�����Ʒ��ť��',TObject(@DlgConf.DBelt6));

  DlgList.AddItem('���ܿ�ݼ����ô���',TObject(@DlgConf.DKeySelDlg));
  DlgList.AddItem('��ݼ����ô���ͼ��',TObject(@DlgConf.DKsIcon));
  DlgList.AddItem('��ݼ����ô���F1',TObject(@DlgConf.DKsF1));
  DlgList.AddItem('��ݼ����ô���F2',TObject(@DlgConf.DKsF2));
  DlgList.AddItem('��ݼ����ô���F3',TObject(@DlgConf.DKsF3));
  DlgList.AddItem('��ݼ����ô���F4',TObject(@DlgConf.DKsF4));
  DlgList.AddItem('��ݼ����ô���F5',TObject(@DlgConf.DKsF5));
  DlgList.AddItem('��ݼ����ô���F6',TObject(@DlgConf.DKsF6));
  DlgList.AddItem('��ݼ����ô���F7',TObject(@DlgConf.DKsF7));
  DlgList.AddItem('��ݼ����ô���F8',TObject(@DlgConf.DKsF8));
  DlgList.AddItem('��ݼ����ô���Ctrl+F1',TObject(@DlgConf.DKsConF1));
  DlgList.AddItem('��ݼ����ô���Ctrl+F2',TObject(@DlgConf.DKsConF2));
  DlgList.AddItem('��ݼ����ô���Ctrl+F3',TObject(@DlgConf.DKsConF3));
  DlgList.AddItem('��ݼ����ô���Ctrl+F4',TObject(@DlgConf.DKsConF4));
  DlgList.AddItem('��ݼ����ô���Ctrl+F5',TObject(@DlgConf.DKsConF5));
  DlgList.AddItem('��ݼ����ô���Ctrl+F6',TObject(@DlgConf.DKsConF6));
  DlgList.AddItem('��ݼ����ô���Ctrl+F7',TObject(@DlgConf.DKsConF7));
  DlgList.AddItem('��ݼ����ô���Ctrl+F8',TObject(@DlgConf.DKsConF8));
  DlgList.AddItem('��ݼ����ô��������ť',TObject(@DlgConf.DKsNone));
  DlgList.AddItem('��ݼ����ô���ȷ����ť',TObject(@DlgConf.DKsOk));

  DlgList.AddItem('�Զ��崰�ڹرհ�ť',TObject(@DlgConf.DChgGamePwdClose));

  DlgList.AddItem('���䰴ť',TObject(@DlgConf.DBotMemo));
  DlgList.AddItem('��Ʒ��',TObject(@DlgConf.DItemGrid));
  DlgList.AddItem('��Ʒ���رհ�ť',TObject(@DlgConf.DClosebag));
  DlgList.AddItem('��Ʒ�����',TObject(@DlgConf.DGold));

  Self.ParentWindow:=FrmMain.Handle;
end;

procedure TfrmDlgConfig.DlgListClick(Sender: TObject);
begin
  boChange:=False;
  GameWindowName.Caption:=DlgList.Items.Strings[DlgList.ItemIndex];
  GameControl:=pTControlInfo(DlgList.Items.Objects[DlgList.ItemIndex]);
  EditTop.Value:=GameControl.Top;
  EditLeft.Value:=GameControl.Left;
  EditWidth.Value:=GameControl.Width;
  EditHeight.Value:=GameControl.Height;
  EditImage.Value:=GameControl.Image;
  if GameControl <> nil then GameWindowName.Enabled:=True;
    
  boChange:=True;
end;

procedure TfrmDlgConfig.EditTopChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Top:=EditTop.Value;
  GameControl.Obj.Top:=GameControl.Top;
end;

procedure TfrmDlgConfig.EditLeftChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Left:=EditLeft.Value;
  GameControl.Obj.Left:=GameControl.Left;

end;

procedure TfrmDlgConfig.EditWidthChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Width:=EditWidth.Value;
  GameControl.Obj.Width:=GameControl.Width;
end;

procedure TfrmDlgConfig.EditHeightChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Height:=EditHeight.Value;
  GameControl.Obj.Height:=GameControl.Height;
end;

procedure TfrmDlgConfig.EditImageChange(Sender: TObject);
begin
  if not boChange then exit;
  GameControl.Image:=EditImage.Value;
  GameControl.Obj.SetImgIndex(g_WMainImages,GameControl.Image);
end;

procedure TfrmDlgConfig.ButtonShowClick(Sender: TObject);
begin
  if GameControl <> nil then begin
    GameControl.Obj.Visible:= not GameControl.Obj.Visible;
  end;
    
end;

procedure TfrmDlgConfig.EditTestYChange(Sender: TObject);
begin
  g_nTestY:=EditTestY.Value;
end;

procedure TfrmDlgConfig.EditTestXChange(Sender: TObject);
begin
  g_nTestX:=EditTestX.Value;
end;

procedure TfrmDlgConfig.EditSpellTimeChange(Sender: TObject);
begin
  g_dwSpellTime:=EditSpellTime.Value;
end;

procedure TfrmDlgConfig.EditHitTimeChange(Sender: TObject);
begin
  g_nHitTime:=EditHitTime.Value;
end;

procedure TfrmDlgConfig.CheckBoxDrawTileMapClick(Sender: TObject);
begin
  g_boDrawTileMap:=CheckBoxDrawTileMap.Checked;
end;

procedure TfrmDlgConfig.CheckBoxDrawDropItemClick(Sender: TObject);
begin
  g_boDrawDropItem:=CheckBoxDrawDropItem.Checked;
end;

end.
