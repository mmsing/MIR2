unit CastleManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Grids, AddGuild ,Guild;

type
  TfrmCastleManage = class(TForm)
    GroupBox1: TGroupBox;
    ListViewCastle: TListView;
    GroupBox2: TGroupBox;
    PageControlCastle: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    EditOwenGuildName: TEdit;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    EditTotalGold: TSpinEdit;
    EditTodayIncome: TSpinEdit;
    Label7: TLabel;
    EditTechLevel: TSpinEdit;
    Label8: TLabel;
    EditPower: TSpinEdit;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    Edit1: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Edit3: TEdit;
    btnSaveSetting: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    Gridactcastle: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    btnSaveCastleInfo: TButton;
    grp1: TGroupBox;
    ListViewGuard: TListView;
    btnRefresh: TButton;
    procedure ListViewCastleClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnSaveCastleInfoClick(Sender: TObject);
    procedure btnSaveSettingClick(Sender: TObject);

  private
    procedure RefCastleList;
    procedure RefCastleInfo;
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmCastleManage: TfrmCastleManage;

implementation

uses Castle, M2Share, ObjMon2;

{$R *.dfm}
var
  CurCastle: TUserCastle;
  boRefing: Boolean;
{ TfrmCastleManage }




procedure TfrmCastleManage.Open;
begin
  Gridactcastle.Cells[0, 0] := '���';
  Gridactcastle.Cells[1, 0] := '�л�����';
  Gridactcastle.Cells[2, 0] := '����ʱ��';
  RefCastleList();
  ShowModal;
end;

procedure TfrmCastleManage.RefCastleInfo;
var
  i, ii: Integer;
  ListItem: TListItem;
  ObjUnit: pTObjUnit;
  CastleDoor : TCastleDoor;
begin
  if CurCastle = nil then Exit;
  boRefing := True;

  //����װ̬
  if CurCastle.m_MasterGuild = nil then EditOwenGuildName.Text := ''
  else EditOwenGuildName.Text := CurCastle.m_MasterGuild.sGuildName;      //�����л�

  EditTotalGold.Value := CurCastle.m_nTotalGold;         //�ʽ�����
  EditTodayIncome.Value := CurCastle.m_nTodayIncome;     //��������
  EditTechLevel.Value := CurCastle.m_nTechLevel;         //�ȼ�
  EditPower.Value := CurCastle.m_nPower;                 //��Դ

  //����״̬
  ListViewGuard.Clear;
  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '0';
  if CurCastle.m_MainDoor.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_MainDoor.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_MainDoor.BaseObject.m_nCurrX, CurCastle.m_MainDoor.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_MainDoor.BaseObject.m_WAbil.HP, CurCastle.m_MainDoor.BaseObject.m_WAbil.MaxHP]));

    CastleDoor :=  TCastleDoor(CurCastle.m_MainDoor.BaseObject);
    if CurCastle.m_MainDoor.BaseObject.m_boDeath then
    begin
       ListItem.SubItems.Add('�ٻ�');
    end else
     if CastleDoor.m_boOpened then
    begin
       ListItem.SubItems.Add('��');
    end else
    begin
       ListItem.SubItems.Add('�ر�');
    end;

    {
    if CurCastle.m_MainDoor.BaseObject.m_boDeath then
    begin
       ListItem.SubItems.Add('��');
    end else
    if (CurCastle.m_DoorStatus <> nil) and CurCastle.m_DoorStatus.boOpened then
    begin
      ListItem.SubItems.Add('��');
    end else
    begin
      ListItem.SubItems.Add('�ر�');
    end;
    }
     
  end else
  begin
    ListItem.SubItems.Add(CurCastle.m_MainDoor.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_MainDoor.nX, CurCastle.m_MainDoor.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '1';
  if CurCastle.m_LeftWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_LeftWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_LeftWall.BaseObject.m_nCurrX, CurCastle.m_LeftWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_LeftWall.BaseObject.m_WAbil.HP, CurCastle.m_LeftWall.BaseObject.m_WAbil.MaxHP]));
  end else
  begin
    ListItem.SubItems.Add(CurCastle.m_LeftWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_LeftWall.nX, CurCastle.m_LeftWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '2';
  if CurCastle.m_CenterWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_CenterWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_CenterWall.BaseObject.m_nCurrX, CurCastle.m_CenterWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_CenterWall.BaseObject.m_WAbil.HP, CurCastle.m_CenterWall.BaseObject.m_WAbil.MaxHP]));
  end else
  begin
    ListItem.SubItems.Add(CurCastle.m_CenterWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_CenterWall.nX, CurCastle.m_CenterWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;

  ListItem := ListViewGuard.Items.Add;
  ListItem.Caption := '3';
  if CurCastle.m_RightWall.BaseObject <> nil then
  begin
    ListItem.SubItems.Add(CurCastle.m_RightWall.BaseObject.m_sCharName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_RightWall.BaseObject.m_nCurrX, CurCastle.m_RightWall.BaseObject.m_nCurrY]));
    ListItem.SubItems.Add(Format('%d/%d', [CurCastle.m_RightWall.BaseObject.m_WAbil.HP, CurCastle.m_RightWall.BaseObject.m_WAbil.MaxHP]));
  end else
  begin
    ListItem.SubItems.Add(CurCastle.m_RightWall.sName);
    ListItem.SubItems.Add(Format('%d:%d', [CurCastle.m_RightWall.nX, CurCastle.m_RightWall.nY]));
    ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
  end;
  for i := Low(CurCastle.m_Archer) to High(CurCastle.m_Archer) do
  begin
    ObjUnit := @CurCastle.m_Archer[i];
    ListItem := ListViewGuard.Items.Add;
    ListItem.Caption := IntToStr(i + 4);
    if ObjUnit.BaseObject <> nil then
    begin
      ListItem.SubItems.Add(ObjUnit.BaseObject.m_sCharName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.BaseObject.m_nCurrX, ObjUnit.BaseObject.m_nCurrY]));
      ListItem.SubItems.Add(Format('%d/%d', [ObjUnit.BaseObject.m_WAbil.HP, ObjUnit.BaseObject.m_WAbil.MaxHP]));
    end else
    begin
      ListItem.SubItems.Add(ObjUnit.sName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.nX, ObjUnit.nY]));
      ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
    end;
  end;
  for ii := Low(CurCastle.m_Guard) to High(CurCastle.m_Guard) do
  begin
    ObjUnit := @CurCastle.m_Guard[ii];
    ListItem := ListViewGuard.Items.Add;
    ListItem.Caption := IntToStr(i + 4);
    if ObjUnit.BaseObject <> nil then
    begin
      ListItem.SubItems.Add(ObjUnit.BaseObject.m_sCharName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.BaseObject.m_nCurrX, ObjUnit.BaseObject.m_nCurrY]));
      ListItem.SubItems.Add(Format('%d/%d', [ObjUnit.BaseObject.m_WAbil.HP, ObjUnit.BaseObject.m_WAbil.MaxHP]));
    end else
    begin
      ListItem.SubItems.Add(ObjUnit.sName);
      ListItem.SubItems.Add(Format('%d:%d', [ObjUnit.nX, ObjUnit.nY]));
      ListItem.SubItems.Add(Format('%d/%d', [0, 0]));
    end;
  end;

  //����
  Edit4.Text := CurCastle.m_sName;      //�Ǳ���
  
  if CurCastle.m_MasterGuild = nil then EditOwenGuildName.Text := ''
  else Edit5.Text := CurCastle.m_MasterGuild.sGuildName;      //�����л�

  Edit1.Text := CurCastle.m_sPalaceMap;    //�ʹ����ڵ�ͼ��
  Edit6.Text := CurCastle.m_sHomeMap;      //�л�سǵ��ͼ
  SpinEdit1.Value := CurCastle.m_nHomeX;   //�س����� X
  SpinEdit2.Value := CurCastle.m_nHomeY;  //�س����� Y

  Edit3.Text := CurCastle.m_sSecretMap;   //�ܵ���ͼ

  boRefing := False;
end;

procedure TfrmCastleManage.RefCastleList;
var
  i: Integer;
  UserCastle: TUserCastle;
  ListItem: TListItem;
begin
  g_CastleManager.Lock;
  try
    for i := 0 to g_CastleManager.m_CastleList.Count - 1 do
    begin
      UserCastle := TUserCastle(g_CastleManager.m_CastleList.Items[i]);
      ListItem := ListViewCastle.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.AddObject(UserCastle.m_sConfigDir, UserCastle);
      ListItem.SubItems.Add(UserCastle.m_sName)
    end;
  finally
    g_CastleManager.UnLock;
  end;
end;

procedure TfrmCastleManage.ListViewCastleClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem := ListViewCastle.Selected;
  if ListItem = nil then Exit;
  CurCastle := TUserCastle(ListItem.SubItems.Objects[0]);
  RefCastleInfo();
end;

procedure TfrmCastleManage.btnRefreshClick(Sender: TObject);
begin
  RefCastleInfo();
end;


procedure TfrmCastleManage.Button2Click(Sender: TObject);
var
  FromAddGuild: TFromAddGuild;
begin
  FromAddGuild :=  TFromAddGuild.Create(Owner);
  FromAddGuild.Top := Top + 20;
  FromAddGuild.Left := Left;
  FromAddGuild.Open();
  FromAddGuild.Free;
end;

//����Ǳ���Ϣ
procedure TfrmCastleManage.btnSaveCastleInfoClick(Sender: TObject);

begin

    //�Ǳ�������Ϊ��
    if CurCastle = nil then begin
        Application.MessageBox( PChar('����û��ѡ��Ǳ�!'),'������Ϣ',MB_OK + MB_ICONERROR);
        Exit;
     end;

    CurCastle.m_nTotalGold := EditTotalGold.Value;         //�ʽ�����
    CurCastle.m_nTodayIncome := EditTodayIncome.Value;     //��������
    CurCastle.m_nTechLevel := EditTechLevel.Value;         //�ȼ�
    CurCastle.m_nPower := EditPower.Value;                 //��Դ

    CurCastle.SaveConfigFile();                            //��������

    Application.MessageBox( '����״̬�ѱ���','��Ϣ',MB_OK + MB_ICONINFORMATION);

end;

//����Ǳ�����
procedure TfrmCastleManage.btnSaveSettingClick(Sender: TObject);
var
 Guild: TGUild;
 sGuildName : string;
 isOK : Integer;
begin

    //�Ǳ�������Ϊ��
     if CurCastle = nil then begin
        Application.MessageBox( PChar('����û��ѡ��Ǳ�!'),'������Ϣ',MB_OK + MB_ICONERROR);
        Exit;
     end;

    sGuildName := Edit5.Text ;
    Guild := g_GuildManager.FindGuild( sGuildName );
    if (Guild = nil) and (CurCastle.m_MasterGuild = nil) then begin
       Application.MessageBox( PChar(sGuildName + '  �л᲻���ڣ�'),'������Ϣ',MB_OK + MB_ICONWARNING);

    end  else if (Guild = nil) and (CurCastle.m_MasterGuild <> nil) then begin
     isOK :=  Application.MessageBox( PChar(sGuildName +'  �л᲻���ڣ���ȷ���Ƿ񱣴棿������潫������Ǳ��������лᡣ'),'��Ϣ',MB_OKCANCEL + MB_ICONERROR);
       if  isOK = 1 then begin
          CurCastle.m_sOwnGuild :='��Ϸ����';               //��ճǱ���������
          CurCastle.m_MasterGuild := nil;
          CurCastle.SaveConfigFile();                       //��������

          Edit5.Text := '';      //��������л������
       end;
    end  else begin
      //ע�⣺�Ǳ���ͼ���л�سǵ��ͼ���ǹ̶��Ĳ����޸� �� ��������޸ĳǱ��������л�

      CurCastle.m_nHomeX := SpinEdit1.Value;    //�س����� X
      CurCastle.m_nHomeY := SpinEdit2.Value  ;  //�س����� Y

      CurCastle.m_sPalaceMap := Edit1.Text;    //�ʹ����ڵ�ͼ 
      CurCastle.m_sSecretMap := Edit3.Text;    //�ܵ���ͼ
      
      CurCastle.m_MasterGuild := Guild;
      CurCastle.m_sOwnGuild   := sGuildName;
      
      CurCastle.SaveConfigFile();
      Application.MessageBox( '�����ѱ���','��Ϣ',MB_OK + MB_ICONINFORMATION);
      
    end;
 end;
 
end.
