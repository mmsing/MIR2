unit ConfigMerchant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,ObjNpc, StrUtils, SDK, HUtil32;

type
  TfrmConfigMerchant = class(TForm)
    ListBoxMerChant: TListBox;
    Label1: TLabel;
    GroupBoxNPC: TGroupBox;
    Label2: TLabel;
    EditScriptName: TEdit;
    Label3: TLabel;
    EditMapName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditShowName: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    CheckBoxOfCastle: TCheckBox;
    ComboBoxDir: TComboBox;
    EditImageIdx: TSpinEdit;
    EditX: TSpinEdit;
    EditY: TSpinEdit;
    GroupBoxScript: TGroupBox;
    MemoScript: TMemo;
    ButtonScriptSave: TButton;
    GroupBox3: TGroupBox;
    CheckBoxBuy: TCheckBox;
    CheckBoxSell: TCheckBox;
    CheckBoxStorage: TCheckBox;
    CheckBoxGetback: TCheckBox;
    CheckBoxMakedrug: TCheckBox;
    CheckBoxUpgradenow: TCheckBox;
    CheckBoxGetbackupgnow: TCheckBox;
    CheckBoxRepair: TCheckBox;
    CheckBoxS_repair: TCheckBox;
    ButtonReLoadNpc: TButton;
    ButtonSave: TButton;
    CheckBoxDenyRefStatus: TCheckBox;
    Label9: TLabel;
    EditPriceRate: TSpinEdit;
    Label10: TLabel;
    EditMapDesc: TEdit;
    CheckBoxSendMsg: TCheckBox;
    CheckBoxAutoMove: TCheckBox;
    Label11: TLabel;
    EditMoveTime: TSpinEdit;
    ButtonClearTempData: TButton;
    ButtonRecover: TButton;
    procedure ListBoxMerChantClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure CheckBoxDenyRefStatusClick(Sender: TObject);
    procedure EditXChange(Sender: TObject);
    procedure EditYChange(Sender: TObject);
    procedure EditShowNameChange(Sender: TObject);
    procedure EditImageIdxChange(Sender: TObject);
    procedure CheckBoxOfCastleClick(Sender: TObject);
    procedure CheckBoxBuyClick(Sender: TObject);
    procedure CheckBoxSellClick(Sender: TObject);
    procedure CheckBoxGetbackClick(Sender: TObject);
    procedure CheckBoxStorageClick(Sender: TObject);
    procedure CheckBoxUpgradenowClick(Sender: TObject);
    procedure CheckBoxGetbackupgnowClick(Sender: TObject);
    procedure CheckBoxRepairClick(Sender: TObject);
    procedure CheckBoxS_repairClick(Sender: TObject);
    procedure CheckBoxMakedrugClick(Sender: TObject);
    procedure EditPriceRateChange(Sender: TObject);
    procedure ButtonScriptSaveClick(Sender: TObject);
    procedure ButtonReLoadNpcClick(Sender: TObject);
    procedure EditScriptNameChange(Sender: TObject);
    procedure EditMapNameChange(Sender: TObject);
    procedure ComboBoxDirChange(Sender: TObject);
    procedure MemoScriptChange(Sender: TObject);
    procedure CheckBoxSendMsgClick(Sender: TObject);
    procedure CheckBoxAutoMoveClick(Sender: TObject);
    procedure EditMoveTimeChange(Sender: TObject);
    procedure ButtonClearTempDataClick(Sender: TObject);
    procedure ListBoxMerChantDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxMerChantMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    procedure ButtonRecoverClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    SelMerchant:TMerchant;
    RecoverMerchantList: TGList; //��ʼNPC���ݷݣ����ڻָ��޸ģ�lzxsz2022 - Add by davy 2022-5-22

    boOpened:Boolean;
    boModValued:Boolean;
    bIsNpcChanged:Boolean;
    
    procedure ModValue();
    procedure uModValue();
    procedure RefListBoxMerChant();
    procedure ClearMerchantData();
    procedure LoadScriptFile();
    procedure ChangeScriptAllowAction();

    //ListBox��¼�޸ı�� lzxsz2022 -  Add  ydavy b2022-5-22
    procedure SetModifiedTag(ItemIndex: Integer);
    procedure DelModifiedTag(ItemIndex: Integer);
    function IsModifiedTag(ItemIndex: Integer):Boolean;
    function BackupRecoverMerchant(): Integer;

    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmConfigMerchant: TfrmConfigMerchant;

implementation

uses UsrEngn, M2Share, LocalDB;

{$R *.dfm}

{ TfrmConfigMerchant }
//�����޸ı�ǡ��Զ��壺�����Ӹ��س�����Ϊ�޸ı��
procedure TfrmConfigMerchant.SetModifiedTag(ItemIndex: Integer);
begin
  if(ItemIndex >=0) then
  begin
     if (IsModifiedTag(ItemIndex) = False) then
     begin
        ListBoxMerChant.Items.Strings[ItemIndex] :=  ListBoxMerChant.Items.Strings[ItemIndex] + #13;  //#13�ӻس���
     end;
     
     bIsNpcChanged := True;
  end;
end; 

//ɾ���޸ı��
procedure TfrmConfigMerchant.DelModifiedTag(ItemIndex: Integer);
var
   strItemText : String;
begin
  if(ItemIndex >=0) then
  begin
     if (IsModifiedTag(ItemIndex) = True) then
     begin
        strItemText := ListBoxMerChant.Items.Strings[ItemIndex];
        ListBoxMerChant.Items.Strings[ItemIndex] := LeftStr(strItemText,Length(strItemText)-1);
     end;
  end;
end;

//�Ƿ����޸ı��
function TfrmConfigMerchant.IsModifiedTag(ItemIndex: Integer):Boolean;
var
   TagChar : String;
begin
  if(ItemIndex >=0) then
    begin
      TagChar :=  RightStr(ListBoxMerChant.Items.Strings[ItemIndex],1);
      if ( TagChar = #13 ) then
       begin
         result := True;  //#13�ӻس���
         Exit;  //������Return
       end
   end;

   result := False;
end;

procedure TfrmConfigMerchant.ModValue;
begin
  if(bIsNpcChanged = True) then
  begin
     ButtonSave.Enabled:=True;
     ButtonRecover.Enabled:=True;
  end;

  ButtonScriptSave.Enabled:=True;
end;

procedure TfrmConfigMerchant.uModValue;
begin
  if(bIsNpcChanged = False) then
  begin
    ButtonSave.Enabled:=False;
    ButtonRecover.Enabled:=False;
  end;

  ButtonScriptSave.Enabled:=False;
end;

//����NPC���ڻָ������ݡ����ڷ����޸ģ��ָ�ԭ�����ݡ�lzx2022 - Add By 2022-5-22
function TfrmConfigMerchant.BackupRecoverMerchant(): Integer;
var
  Merchant: TMerchant;
  tMerchantNPC : TMerchant;
  I: Integer;
begin

     RecoverMerchantList := TGList.Create;

     for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
       Merchant := TMerchant.Create;
       tMerchantNPC:=TMerchant(UserEngine.m_MerchantList.Items[I]);

       Merchant.m_sScript   := Copy(tMerchantNPC.m_sScript, 0, Length(tMerchantNPC.m_sScript));
       Merchant.m_sMapName  := Copy(tMerchantNPC.m_sMapName, 0, Length(tMerchantNPC.m_sMapName));
       Merchant.m_nCurrX    := tMerchantNPC.m_nCurrX;
       Merchant.m_nCurrY    := tMerchantNPC.m_nCurrY;
       Merchant.m_sCharName := Copy(tMerchantNPC.m_sCharName, 0, Length(tMerchantNPC.m_sCharName));
       Merchant.m_nFlag     := tMerchantNPC.m_nFlag;
       Merchant.m_wAppr     := tMerchantNPC.m_wAppr;
       Merchant.m_boCastle  := tMerchantNPC.m_boCastle;

       RecoverMerchantList.Add(Merchant);
     end;
   Result := 1;
end;


//�Ի����ʱ�Զ����øú���
procedure TfrmConfigMerchant.Open;
var
  Merchant: TMerchant;
  I: Integer;
begin
  boOpened:=False;
  uModValue();
  CheckBoxDenyRefStatus.Checked:=False;

  SelMerchant:=nil;
  RefListBoxMerChant;  //��ʼNPC���б�

  //���ݻָ���NPC���ݣ����ڻָ��޸ġ�lzx2022 - Add By 2022-5-22
  BackupRecoverMerchant();

  boOpened:=True;
  ShowModal;
end;


procedure TfrmConfigMerchant.ButtonClearTempDataClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('�Ƿ�ȷ�����NPC��ʱ���ݣ�'),'ȷ����Ϣ',MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    ClearMerchantData();
  end;
end;

{
 //�ñ����¼�����дԭ��NCP�����ļ���������ֻ�޸���Ӧ�ļ�¼�������ã������µġ�
 //lzxsz2022 - modified by davy 2022-5-21
procedure TfrmConfigMerchant.ButtonSaveClick_old(Sender: TObject);
var
  I:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  sIsCastle:String;
  sCanMove:String;
begin
  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
       // if Merchant.m_sMapName = '0' then Continue;  //??? ����BUG���ڡ�����������0�ŵ�ͼ��NCP���Ǵ���ġ� modified 2022-05-19

       //NCP�б����һ����¼��QFunction NCP����������
       //QFunction	0	0	0	QFunction	0	0	0	0	0
       if Merchant.m_sCharName = 'QFunction' then Continue;   //lzxsz2022 - Modifyed by davy 2022-05-19

    //lzxsz - Modified by davy 2022-5-20 
    //ȡ��PNC�Զ��ƶ�����,������ÿ��ܻ����ҷ��������������
    //  if Merchant.m_boCastle then sIsCastle:='1'
    //  else sIsCastle:='0';
    //  if Merchant.m_boCanMove then sCanMove:='1'
    // else sCanMove:='0';

      //#N ��ʾʮ����N��ʾ��Ascii �ַ���#9��ʾtab����
      //#10��ʾ���С�#13��ʾ�س���#32 ��ʾ�ո�
      SaveList.Add(Merchant.m_sScript + #9 +
                   Merchant.m_sMapName + #9 +
                   IntToStr(Merchant.m_nCurrX) + #9 +
                   IntToStr(Merchant.m_nCurrY) + #9 +
                   Merchant.m_sCharName + #9 +
                   IntToStr(Merchant.m_nFlag) + #9 +
                   IntToStr(Merchant.m_wAppr) + #9 +
                   sIsCastle // + #9+
                   
               //    sCanMove + #9 +
               //    IntToStr(Merchant.m_dwMoveTime)
                   )
    end;
    SaveList.SaveToFile(sMerchantFile);
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
  SaveList.Free;
  uModValue();
end;
}


//ɾ���ظ��ķָ���������ָ���֮��ո��Ǹ���������Ϊ�ָ����ظ����ᱻɾ���ո�ͺ���ķָ���
Function DelSameDelimiter(Ch : Char; S : String) : String;
 Var
  I : Integer;
  len : Integer;
begin
 I := 1;
 len := Length(S);
 
 While I <= len do
  begin
    If (S[I] = CH) and ((S[I+1] = CH) or (S[I+1] = ' ')) then
     begin
         //����ָ��������ַ�����ͬ�ķָ������ǿո�ɾ����ͷָ�����ո�
         Delete(S, I+1, 1);
     end //��ס���ﲻ�ܼӷֺ�
    Else         
      begin
         I := I + 1;
      end; //����Ҫ�ӷֺ�
  end;
 result := S;
end;

function GetLstBoxIndex(LstBox: TListBox): Integer;
begin
  Result:=-1;
  Result:=LstBox.ItemIndex;
end;

{
//�ñ����¼�������дԭ��NCP�����ļ������޸���Ӧ�ļ�¼��
//������ȡ��CPN�ƶ���������(sCanMove)�������ÿ��ܻ������Ϸ��NCPλ�û��ҡ�
// lzxsz2022 - add by davy 2022-5-21
procedure TfrmConfigMerchant.ButtonSaveClick_old(Sender: TObject);
var
  I,N:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  //sCanMove:String;

  sLineText:String;
  sFirst:String;
  AttributeList :TStrings;

  //�޸Ĳ��� ,ԭ����
  sScript,   sOldScript   : String;
  sMapName,  sOldMapName  : String;
  sNpcName,  sOldNpcName  : String;
  sNpcCurrX, sOldNpcCurrX : String;
  sNpcCurrY, sOldNpcCurrY : String;
  sFlag,     sOldFlag     : String;
  sAppr,     sOldAppr     : String;
  sIsCastle, sOldIsCastle : String;

  sSelNpcName : String;      //ListBoxѡ�е�NPC����
  
 // sFileNpcName   : String;     //�ļ��е�NPC����
 // nSelIdx : Integer;
  sSelItemText : String;
begin

  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;          //NPC�ı�����
  SaveList.LoadFromFile(sMerchantFile);
  
  AttributeList := TStringList.Create;   //NPC�����б�

  UserEngine.m_MerchantList.Lock;
  try

  for N := 0 to ListBoxMerChant.Items.Count -1 do  //for1
  begin
    if(IsModifiedTag(N) = False) then      //if1
      begin
        continue;
      end
    else
     begin
       SelMerchant := TMerchant(ListBoxMerChant.Items.Objects[N]);
       sScript     := SelMerchant.m_sScript;            //0
       sMapName    := SelMerchant.m_sMapName;           //1
       sNpcCurrX   := IntToStr(SelMerchant.m_nCurrX);   //2
       sNpcCurrY   := IntToStr(SelMerchant.m_nCurrY);   //3
       sNpcName    := SelMerchant.m_sCharName;          //4
       sFlag       := IntToStr(SelMerchant.m_nFlag);    //5 ����
       sAppr       := IntToStr(SelMerchant.m_wAppr);    //6

       If SelMerchant.m_boCastle = True then  sIsCastle := '1' //7
       else    sIsCastle := '0';

       //��ȡԭ��δ�޸�ǰ��NPC������
       sSelItemText :=  ListBoxMerChant.Items.Strings[N];
       sSelNpcName := Trim(LeftStr(sSelItemText,Pos('-', sSelItemText)-1));  //��ȡNCP����
   
    end; //if1
 
    //�������ļ����ҳ�Ҫ�޸ĵ�NCP,�������޸ı���

     for I := 0 to SaveList.Count -1 do     //for2
     begin

      // sLine := SaveList[I];
      // sLine := Trim(sLine);
      // sFirst := LeftStr(sLine,1);

      sLineText := Trim(SaveList[I]);
      
      if (sLineText <> '') and (sLineText[1] <> ';') then     //if2
       begin
         sLineText := GetValidStr3(sLineText, sOldScript, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldMapName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrX, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrY, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldFlag, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldAppr, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sIsCastle, [' ', #9]);

         // sLine := DelSameDelimiter(#9,sLine);    //ɾ���ظ��ķָ���
         // AttributeList.Delimiter := #9;          //TAB �ַ�, ˮƽ�Ʊ��
         // AttributeList.DelimitedText := sLine;

         // sFileNpcName := Trim(AttributeList[4]);  //�����ļ��е�NCP����

          if (sOldNpcName = sSelNpcName)        and   //[4]
             (sOldScript = sScript)    and
             (sOldMapName = sMapName)   and
             (sOldNpcCurrX = sNpcCurrX)  and
             (sOldNpcCurrY = sNpcCurrY)  and
             (sOldFlag = sFlag)      and
             (sOldAppr = sAppr)      and
             (sIsCastle = sIsCastle)
          then
          begin
             AttributeList[0] := sScript;
             AttributeList[1] := sMapName;
             AttributeList[2] := sNpcCurrX;
             AttributeList[3] := sNpcCurrY;
             AttributeList[4] := sNpcName;

             AttributeList[5] := sFlag;
             AttributeList[6] := sAppr;
             AttributeList[7] := sIsCastle;

             //Copy(SaveList[I],0 ,Length(AttributeList.DelimitedText));
             SaveList[I] := AttributeList.DelimitedText;
             break;
          end;
      end;   //if2
   end;  //for2
 end;  //for1
    
    //��NCP���õ��޸ı��浽�ļ���
    SaveList.SaveToFile(sMerchantFile);

    //ˢ��NPC�б�
    ListBoxMerChant.Clear;
    SelMerchant:=nil;
    RefListBoxMerChant;

    //���ü�¼�ı���Ϊ�޸ı�
    bIsNpcChanged := False;

   finally
     UserEngine.m_MerchantList.UnLock;
   end;

    SaveList.Free;
    AttributeList.Free;

  uModValue();


end;

}


{
procedure TfrmConfigMerchant.ButtonSaveClick_modify1(Sender: TObject);
var
  I,N:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  //sCanMove:String;
  sLine:String;
  sFirst:String;
  AttributeList :TStrings;

  sScript   : String;
  sMapName  : String;
  sNpcName  : String;
  sNpcCurrX : String;
  sNpcCurrY : String;
  sFlag     : String;
  sAppr     : String;
  sIsCastle : String;

  sSelNpcOldName : String;
  sIniNpcName    : String;
 // nSelIdx : Integer;
  sSelItemText : String;
begin

  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;          //NPC�ı�����
  SaveList.LoadFromFile(sMerchantFile);

  AttributeList := TStringList.Create;   //NPC�����б�

  UserEngine.m_MerchantList.Lock;
  try

  for N := 0 to ListBoxMerChant.Items.Count -1 do  //for1
  begin
    if(IsModifiedTag(N) = False) then      //if1
      begin
        continue;
      end
    else
     begin
       SelMerchant := TMerchant(ListBoxMerChant.Items.Objects[N]);
       sScript     := SelMerchant.m_sScript;            //0
       sMapName    := SelMerchant.m_sMapName;           //1
       sNpcCurrX   := IntToStr(SelMerchant.m_nCurrX);   //2
       sNpcCurrY   := IntToStr(SelMerchant.m_nCurrY);   //3
       sNpcName    := SelMerchant.m_sCharName;          //4
       sFlag       := IntToStr(SelMerchant.m_nFlag);    //5 ����
       sAppr       := IntToStr(SelMerchant.m_wAppr);    //6

       If SelMerchant.m_boCastle = True then  sIsCastle := '1' //7
       else    sIsCastle := '0';

       //��ȡԭ��δ�޸�ǰ��NPC������
       sSelItemText :=  ListBoxMerChant.Items.Strings[N];
       sSelNpcOldName := Trim(LeftStr(sSelItemText,Pos('-', sSelItemText)-1));  //��ȡNCP����

    end; //if1

    //�������ļ����ҳ�Ҫ�޸ĵ�NCP,�������޸ı���

     for I := 0 to SaveList.Count -1 do     //for2
     begin

       sLine := SaveList[I];
       sLine := Trim(sLine);
       sFirst := LeftStr(sLine,1);

       if (sLine <> '') and (sFirst <> ';')    then    //if2
       begin

          sLine := DelSameDelimiter(#9,sLine);    //ɾ���ظ��ķָ���
          AttributeList.Delimiter := #9;          //TAB �ַ�, ˮƽ�Ʊ��
          AttributeList.DelimitedText := sLine;
          sIniNpcName := Trim(AttributeList[4]);  //�����ļ��е�NCP����

          if (sIniNpcName = sSelNpcOldName)        and   //[4]
             (Trim(AttributeList[0]) = sScript)    and
             (Trim(AttributeList[1]) = sMapName)   and
             (Trim(AttributeList[2]) = sNpcCurrX)  and
             (Trim(AttributeList[3]) = sNpcCurrY)  and
             (Trim(AttributeList[5]) = sFlag)      and
             (Trim(AttributeList[6]) = sAppr)      and
             (Trim(AttributeList[7]) = sIsCastle)
          then
          begin
             AttributeList[0] := sScript;
             AttributeList[1] := sMapName;
             AttributeList[2] := sNpcCurrX;
             AttributeList[3] := sNpcCurrY;
             AttributeList[4] := sNpcName;

             AttributeList[5] := sFlag;
             AttributeList[6] := sAppr;
             AttributeList[7] := sIsCastle;

             //Copy(SaveList[I],0 ,Length(AttributeList.DelimitedText));
             SaveList[I] := AttributeList.DelimitedText;
             break;
          end;
      end;   //if2
   end;  //for2
 end;  //for1

    //��NCP���õ��޸ı��浽�ļ���
    SaveList.SaveToFile(sMerchantFile);

    //ˢ��NPC�б�
    ListBoxMerChant.Clear;
    SelMerchant:=nil;    
    RefListBoxMerChant;

    //���ü�¼�ı���Ϊ�޸ı�
    bIsNpcChanged := False;

   finally
     UserEngine.m_MerchantList.UnLock;
   end;

    SaveList.Free;
    AttributeList.Free;

  uModValue();

 end;

}

//�ñ����¼�������дԭ��NCP�����ļ������޸���Ӧ�ļ�¼��
//������ȡ��CPN�ƶ�������(sCanMove)��
// lzxsz2022 - add by davy 2022-5-21
procedure TfrmConfigMerchant.ButtonSaveClick(Sender: TObject);
var
  I,N:Integer;
  SaveList:TStringList;
  Merchant:TMerchant;
  sMerchantFile:String;
  //sCanMove:String;

  sLineText:String;
  sFirst:String;
  AttributeList :TStrings;

  //ԭ���� ����Դ�����ļ���
  sOldScript   : String;
  sOldMapName  : String;
  sOldNpcName  : String;
  sOldNpcCurrX : String;
  sOldNpcCurrY : String;

  //�ԱȲ��� ����Դ�����ļ�ListBox�ı���
  sComNpcName : String;      //ListBox�ı���NPC����
  sComNpcCurrX : String;     //ListBox�ı���NPC����X
  sComNpcCurrY : String;     //ListBox�ı���NPC����X
  sComMapName   :  String;   //ListBox�ı���NPC��ͼ��
  
  sSelIsCastle :  String;    //�޸Ĳ����Ƿ����Ǳ�

  post1, post2, post3 : Integer;
    
   sSelItemText : String;
   OldItemIndex : Integer;
begin

  sMerchantFile:=g_Config.sEnvirDir + 'Merchant.txt';
  SaveList:=TStringList.Create;          //NPC�ı�����
  SaveList.LoadFromFile(sMerchantFile);

  OldItemIndex :=  ListBoxMerChant.ItemIndex;
  
  UserEngine.m_MerchantList.Lock;
  try

    //�������ļ����ҳ�Ҫ�޸ĵ�NCP,�������޸ı���
     N:=0;
     for I := 0 to SaveList.Count -1 do     //for2
     begin

      sLineText := Trim(SaveList[I]);
      
      if (sLineText <> '') and (sLineText[1] <> ';') then     //if2
       begin
         sLineText := GetValidStr3(sLineText, sOldScript, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldMapName, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrX, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcCurrY, [' ', #9]);
         sLineText := GetValidStr3(sLineText, sOldNpcName, [' ', #9]);

        //��ListBox�ı�����ȡ�Ƚϲ�����ԭ��δ�޸ĵĲ�����
        sSelItemText :=  ListBoxMerChant.Items.Strings[N];
        //��ʽ������ - ��ͼ (x:y)
        post1 := Pos('-', sSelItemText);        
        sComNpcName := Trim(LeftStr(sSelItemText,post1 - 1));  //NCP����

        post2 := Pos('(', sSelItemText);
        sComMapName := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //��ͼ����
        
        post1 := post2;
        post2 := Pos(':', sSelItemText);
        sComNpcCurrX := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //X����

        post1 := post2;
        post2 := Pos(')', sSelItemText);
        sComNpcCurrY := Trim(MidStr(sSelItemText,post1+1, post2-post1-1));  //Y����

        if (sOldNpcName  = sComNpcName)   and
           (sOldMapName  = sComMapName)   and
           (sOldNpcCurrX = sComNpcCurrX) and
           (sOldNpcCurrY = sComNpcCurrY)
          then
          begin

        SelMerchant := TMerchant(ListBoxMerChant.Items.Objects[N]);

        if (SelMerchant.m_boCastle = true) then  sSelIsCastle := '1'
        else     sSelIsCastle := '0';
        
        SaveList[I] :=  SelMerchant.m_sScript + #9 +
                        SelMerchant.m_sMapName + #9 +
                        IntToStr(SelMerchant.m_nCurrX) + #9 +
                        IntToStr(SelMerchant.m_nCurrY) + #9 +
                        SelMerchant.m_sCharName + #9 +
                        IntToStr(SelMerchant.m_nFlag) + #9 +
                        IntToStr(SelMerchant.m_wAppr) + #9 +
                        sSelIsCastle;

           Inc(N);   //������1
          end;
      end;   //if2
   end;  //for2

   //��NCP���õ��޸ı��浽�ļ���
   SaveList.SaveToFile(sMerchantFile);
   BackupRecoverMerchant();  //���±�������

  //ˢ��NPC�б�
    ListBoxMerChant.Clear;
    SelMerchant:=nil;
    RefListBoxMerChant; //ˢ��

    ListBoxMerChant.SetFocus; //���ý���
    ListBoxMerChant.Selected[OldItemIndex]:=True ;  //����ѡ�������
    ListBoxMerChantClick(Sender); //���õ���¼�

    //���ü�¼�ı���Ϊ�޸ı�
    bIsNpcChanged := False;

   finally
     UserEngine.m_MerchantList.UnLock;
   end;

   SaveList.Free;

  uModValue();

end;



//�ָ�NCP���޸ġ����ڱ���֮ǰ���С�lzxsz2022 - Add By davy 2022-5-22
procedure TfrmConfigMerchant.ButtonRecoverClick(Sender: TObject);
var
  I, N : Integer;
  Merchant:TMerchant;
  OldMerchant:TMerchant;
  OldItemIndex:Integer;
begin

  OldItemIndex :=  ListBoxMerChant.ItemIndex;
  ListBoxMerChant.Clear;   //��Ҫ
  SelMerchant:=nil;

  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to RecoverMerchantList.Count - 1 do begin
      OldMerchant:=TMerchant(RecoverMerchantList.Items[I]);
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);

      Merchant.m_sScript   := Copy(OldMerchant.m_sScript, 0, Length(OldMerchant.m_sScript));
      Merchant.m_sMapName  := Copy(OldMerchant.m_sMapName, 0, Length(OldMerchant.m_sMapName));
      Merchant.m_nCurrX    := OldMerchant.m_nCurrX;
      Merchant.m_nCurrY    := OldMerchant.m_nCurrY;
      Merchant.m_sCharName := Copy(OldMerchant.m_sCharName, 0, Length(OldMerchant.m_sCharName));
      Merchant.m_nFlag     := OldMerchant.m_nFlag;
      Merchant.m_wAppr     := OldMerchant.m_wAppr;
      Merchant.m_boCastle  := OldMerchant.m_boCastle;

      if  (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;
        
      ListBoxMerChant.Items.AddObject(Merchant.m_sCharName + ' - ' + Merchant.m_sMapName + ' (' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')',Merchant );
    end;   //for
  finally
    UserEngine.m_MerchantList.UnLock;
  end;

  ListBoxMerChant.SetFocus; //���ý���
  ListBoxMerChant.Selected[OldItemIndex]:=True ;  //����ѡ�������
  ListBoxMerChantClick(Sender); //���õ���¼�
    
  //���ü�¼�ı���Ϊ�޸ı�
  bIsNpcChanged := False;
  uModValue();

end;


procedure TfrmConfigMerchant.ClearMerchantData;
var
  I: Integer;
  Merchant:TMerchant;
begin
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
      Merchant.ClearData();
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

procedure TfrmConfigMerchant.RefListBoxMerChant;
var
  I: Integer;
  Merchant:TMerchant;
begin
  UserEngine.m_MerchantList.Lock;
  try
    for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(UserEngine.m_MerchantList.Items[I]);
      //if (Merchant.m_sMapName = '0') and (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;  //Bug �����ų���0�ŵ�ͼ��0�ŵ�ͼ�Ǵ��ڵģ�0���Ǳ���ʡ��
      if (Merchant.m_nCurrX = 0) and (Merchant.m_nCurrY = 0) then Continue;    //lzxsz2022 - Mydified by Davy 2022-5-22

      ListBoxMerChant.Items.AddObject(Merchant.m_sCharName + ' - ' + Merchant.m_sMapName + ' (' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')',Merchant );
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;

end;

procedure TfrmConfigMerchant.ListBoxMerChantClick(Sender: TObject);
var
  nSelIndex:Integer;
begin
  CheckBoxDenyRefStatus.Checked:=False;
  uModValue();
  boOpened:=False;
  nSelIndex:=ListBoxMerChant.ItemIndex;
  if nSelIndex < 0 then exit;
  SelMerchant:=TMerchant(ListBoxMerChant.Items.Objects[nSelIndex]);  //ѡ���NPC
  EditScriptName.Text:=SelMerchant.m_sScript;
  EditMapName.Text:=SelMerchant.m_sMapName;
  EditMapDesc.Text:=SelMerchant.m_PEnvir.sMapDesc;
  EditX.Value:=SelMerchant.m_nCurrX;
  EditY.Value:=SelMerchant.m_nCurrY;
  EditShowName.Text:=SelMerchant.m_sCharName;
  ComboBoxDir.ItemIndex:=SelMerchant.m_nFlag;
  EditImageIdx.Value:=SelMerchant.m_wAppr;
  CheckBoxOfCastle.Checked:=SelMerchant.m_boCastle;
  //CheckBoxAutoMove.Checked:=SelMerchant.m_boCanMove;
  //EditMoveTime.Value:=SelMerchant.m_dwMoveTime;
  
  CheckBoxBuy.Checked:=SelMerchant.m_boBuy;
  CheckBoxSell.Checked:=SelMerchant.m_boSell;
  CheckBoxGetback.Checked:=SelMerchant.m_boGetback;
  CheckBoxStorage.Checked:=SelMerchant.m_boStorage;
  CheckBoxUpgradenow.Checked:=SelMerchant.m_boUpgradenow;
  CheckBoxGetbackupgnow.Checked:=SelMerchant.m_boGetBackupgnow;
  CheckBoxRepair.Checked:=SelMerchant.m_boRepair;
  CheckBoxS_repair.Checked:=SelMerchant.m_boS_repair;
  CheckBoxMakedrug.Checked:=SelMerchant.m_boMakeDrug;
  CheckBoxSendMsg.Checked:=SelMerchant.m_boSendmsg;

  EditPriceRate.Value:=SelMerchant.m_nPriceRate;
  MemoScript.Clear;
  ButtonReLoadNpc.Enabled:=False;
  LoadScriptFile();

  GroupBoxNPC.Enabled:=True;
  GroupBoxScript.Enabled:=True;

  boOpened:=True;
end;

procedure TfrmConfigMerchant.FormCreate(Sender: TObject);
begin
  ComboBoxDir.Items.Add('0');
  ComboBoxDir.Items.Add('1');
  ComboBoxDir.Items.Add('2');
  ComboBoxDir.Items.Add('3');
  ComboBoxDir.Items.Add('4');
  ComboBoxDir.Items.Add('5');
  ComboBoxDir.Items.Add('6');
  ComboBoxDir.Items.Add('7');

end;


procedure TfrmConfigMerchant.CheckBoxDenyRefStatusClick(Sender: TObject);
begin
  if SelMerchant <> nil then begin
    SelMerchant.m_boDenyRefStatus:=CheckBoxDenyRefStatus.Checked;
  end;
end;

//�޸�NPC��X����
procedure TfrmConfigMerchant.EditXChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nCurrX:=EditX.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC��Y����
procedure TfrmConfigMerchant.EditYChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nCurrY:=EditY.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC��ʾ����
procedure TfrmConfigMerchant.EditShowNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sCharName:=Trim(EditShowName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC����
procedure TfrmConfigMerchant.EditImageIdxChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_wAppr:=EditImageIdx.Value;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC�ű�
procedure TfrmConfigMerchant.EditScriptNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sScript:=Trim(EditScriptName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC��ͼ
procedure TfrmConfigMerchant.EditMapNameChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_sMapName:=Trim(EditMapName.Text);
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC����
procedure TfrmConfigMerchant.ComboBoxDirChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_nFlag:=ComboBoxDir.ItemIndex;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//�޸�NPC�Ƿ����ڳǱ�
procedure TfrmConfigMerchant.CheckBoxOfCastleClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boCastle:=CheckBoxOfCastle.Checked;
  SetModifiedTag(ListBoxMerChant.ItemIndex); //�����޸ı�ǣ�lzxsz2022 - Modified By Davy 2022-5-22
  ModValue();
end;

//ȡ��NCP�ƶ������á�lzxsz-2022 Modifyed By Davy 2022-5-22
procedure TfrmConfigMerchant.CheckBoxAutoMoveClick(Sender: TObject);
begin
  //if not boOpened or (SelMerchant =nil) then exit;
  //SelMerchant.m_boCanMove:=CheckBoxAutoMove.Checked;
  //ModValue();
end;

//ȡ��NCP�ƶ�ʱ���������á�lzxsz-2022 Modifyed By Davy 2022-5-22
procedure TfrmConfigMerchant.EditMoveTimeChange(Sender: TObject);
begin
 // if not boOpened or (SelMerchant =nil) then exit;
 // SelMerchant.m_dwMoveTime:=EditMoveTime.Value;
 // ModValue();
end;

procedure TfrmConfigMerchant.LoadScriptFile;
var
  I: Integer;
  sScriptFile:String;
  LoadList:TStringList;
  LineText:String;
  boNoHeader:Boolean;
begin
  if SelMerchant = nil then exit;
  sScriptFile:=g_Config.sEnvirDir + 'Market_Def\' + SelMerchant.m_sScript + '-' + SelMerchant.m_sMapName + '.txt';
  MemoScript.Visible:=False;
  LineText:='(';
  if SelMerchant.m_boBuy then LineText:=LineText + sBUY + ' ';
  if SelMerchant.m_boSell then LineText:=LineText + sSELL + ' ';
  if SelMerchant.m_boMakeDrug then LineText:=LineText + sMAKEDURG + ' ';
  if SelMerchant.m_boStorage then LineText:=LineText + sSTORAGE + ' ';
  if SelMerchant.m_boGetback then LineText:=LineText + sGETBACK + ' ';
  if SelMerchant.m_boUpgradenow then LineText:=LineText + sUPGRADENOW + ' ';
  if SelMerchant.m_boGetBackupgnow then LineText:=LineText + sGETBACKUPGNOW + ' ';
  if SelMerchant.m_boRepair then LineText:=LineText + sREPAIR + ' ';
  if SelMerchant.m_boS_repair then LineText:=LineText + sSUPERREPAIR + ' ';
  if SelMerchant.m_boSendmsg then LineText:=LineText + sSL_SENDMSG + ' ';  
  LineText:=LineText + ')';
  MemoScript.Lines.Add(LineText);
  LineText:='%' + IntToStr(SelMerchant.m_nPriceRate);
  MemoScript.Lines.Add(LineText);
  for I := 0 to SelMerchant.m_ItemTypeList.Count - 1 do begin
    LineText:='+' + IntToStr(Integer(SelMerchant.m_ItemTypeList.Items[I]));
    MemoScript.Lines.Add(LineText);
  end;
  if FileExists(sScriptFile) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sScriptFile);
    boNoHeader:=False;
    for I := 0 to LoadList.Count - 1 do begin
      LineText:=LoadList.Strings[I];
      if (LineText = '') or (LineText[1] = ';') then Continue;

      if (LineText[1] = '[') or (LineText[1] = '#') then boNoHeader:=True;
      if boNoHeader then begin
        MemoScript.Lines.Add(LineText);
      end;

    end;
    LoadList.Free;
  end;
  MemoScript.Visible:=True;
end;

procedure TfrmConfigMerchant.ChangeScriptAllowAction;
var
  LineText:String;
begin
  if (SelMerchant = nil) or (MemoScript.Lines.Count <=0 ) then exit;
  LineText:='(';
  if SelMerchant.m_boBuy then LineText:=LineText + sBUY + ' ';
  if SelMerchant.m_boSell then LineText:=LineText + sSELL + ' ';
  if SelMerchant.m_boMakeDrug then LineText:=LineText + sMAKEDURG + ' ';
  if SelMerchant.m_boStorage then LineText:=LineText + sSTORAGE + ' ';
  if SelMerchant.m_boGetback then LineText:=LineText + sGETBACK + ' ';
  if SelMerchant.m_boUpgradenow then LineText:=LineText + sUPGRADENOW + ' ';
  if SelMerchant.m_boGetBackupgnow then LineText:=LineText + sGETBACKUPGNOW + ' ';
  if SelMerchant.m_boRepair then LineText:=LineText + sREPAIR + ' ';
  if SelMerchant.m_boS_repair then LineText:=LineText + sSUPERREPAIR + ' ';
  if SelMerchant.m_boSendmsg then LineText:=LineText + sSL_SENDMSG + ' ';  
  LineText:=LineText + ')';
  MemoScript.Lines[0]:=LineText;
end;

procedure TfrmConfigMerchant.CheckBoxBuyClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boBuy:=CheckBoxBuy.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxSellClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boSell:=CheckBoxSell.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxGetbackClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boGetback:=CheckBoxGetback.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxStorageClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boStorage:=CheckBoxStorage.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxUpgradenowClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boUpgradenow:=CheckBoxUpgradenow.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxGetbackupgnowClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boGetBackupgnow:=CheckBoxGetbackupgnow.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxRepairClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boRepair:=CheckBoxRepair.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxS_repairClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boS_repair:=CheckBoxS_repair.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxMakedrugClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boMakeDrug:=CheckBoxMakedrug.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.CheckBoxSendMsgClick(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  SelMerchant.m_boSendmsg:=CheckBoxSendMsg.Checked;
  ModValue();
  ChangeScriptAllowAction();
end;

procedure TfrmConfigMerchant.EditPriceRateChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
    
  SelMerchant.m_nPriceRate:=EditPriceRate.Value;
  MemoScript.Lines[1]:='%' + IntToStr(SelMerchant.m_nPriceRate);
  ModValue();

end;

procedure TfrmConfigMerchant.ButtonScriptSaveClick(Sender: TObject);
var
  sScriptFile:String;
begin
  sScriptFile:=g_Config.sEnvirDir + 'Market_Def\' + SelMerchant.m_sScript + '-' + SelMerchant.m_sMapName + '.txt';
  MemoScript.Lines.SaveToFile(sScriptFile);
  uModValue();
  ButtonReLoadNpc.Enabled:=True;
end;

procedure TfrmConfigMerchant.ButtonReLoadNpcClick(Sender: TObject);
begin
  if (SelMerchant =nil) then exit;
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    SelMerchant.ClearScript;
    SelMerchant.LoadNPCScript;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
  ButtonReLoadNpc.Enabled:=False;
end;

procedure TfrmConfigMerchant.MemoScriptChange(Sender: TObject);
begin
  if not boOpened or (SelMerchant =nil) then exit;
  ModValue();
end;

//�ı��ı���ʾ��ɫ
procedure TfrmConfigMerchant.ListBoxMerChantDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin

   if (Index >=0) then
   begin
     if (IsModifiedTag(Index) = True) then
     begin
         ListBoxMerChant.Canvas.Font.Color := clRed;
         ListBoxMerChant.Canvas.Font.Size :=10;
         ListBoxMerChant.Canvas.TextRect(Rect, Rect.Left, Rect.Top, ListBoxMerChant.Items[Index]);
     end
   else
       ListBoxMerChant.Canvas.Font.Color := clBlack;
       ListBoxMerChant.Canvas.Font.Size :=10;      
       ListBoxMerChant.Canvas.TextRect(Rect, Rect.Left, Rect.Top, ListBoxMerChant.Items[Index]);
    end;

end;

procedure TfrmConfigMerchant.ListBoxMerChantMeasureItem(
  Control: TWinControl; Index: Integer; var Height: Integer);
begin
     Height :=16;  //ListBox �и�
end;

 
//�رմ����¼�
procedure TfrmConfigMerchant.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Result : Integer;
begin

    if( bIsNpcChanged = True) then
    begin
       Result := Application.MessageBox('����NCP���ݱ��޸ģ��Ƿ񱣴��˳���','����',MB_ICONWARNING+MB_YesNo);
       if Result = IDYES then  begin
           ButtonScriptSaveClick(Sender);   //����
        end   else  begin
            ButtonRecoverClick(Sender);     //�ָ�
        end;
    end;
end;

end.
