unit FDBexpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,Grobal2;
type
  TFrmFDBExplore=class(TForm)
    ListBox1: TListBox;
    EdFind: TEdit;
    Label1: TLabel;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListBox2: TListBox;
    BtnRebuild: TButton;
    BtnBlankCount: TButton;
    GroupBox1: TGroupBox;
    BtnAutoClean: TButton;
    Timer1: TTimer;
    BtnCopyRcd: TButton;
    BtnCopyNew: TButton;
    CkLv1: TCheckBox;
    CkLv7: TCheckBox;
    CkLv14: TCheckBox;
    BtnSearch: TButton;

    procedure ListBox1Click(Sender : TObject);
    procedure BtnDelClick(Sender : TObject);
    procedure BtnRebuildClick(Sender : TObject);
    procedure BtnBlankCountClick(Sender : TObject);
    procedure BtnAddClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure BtnAutoCleanClick(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure BtnCopyRcdClick(Sender : TObject);
    procedure BtnCopyNewClick(Sender : TObject);
    procedure EdFindKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);


  private
//    nClearIndex:Integer; //0x324
//    nClearCount:Integer;//0x328

    SList_320:TStringList;
    function ClearHumanItem(var ChrRecord: THumDataInfo):Boolean;
    procedure SearchHumData();

    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmFDBExplore: TFrmFDBExplore;

{This file is generated by DeDe Ver 3.50.02 Copyright (c) 1999-2002 DaFixer}

implementation

uses HumDB, newchr, UsrSoc, frmcpyrcd, DBSMain, DBShare;

{$R *.DFM}

procedure TFrmFDBExplore.SearchHumData();
var
  I: Integer;
  sChrName:String;
begin
  sChrName:=Trim(EdFind.Text);
  if sChrName = ''  then exit;
  ListBox1.Clear;
  ListBox2.Clear;

  try
    if HumDataDB.OpenEx then begin
      HumDataDB.Find(sChrName,ListBox1.Items);
      for I := 0 to ListBox1.Items.Count - 1 do begin
        ListBox2.Items.Add(IntToStr(Integer(ListBox1.Items.Objects[i])));
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmFDBExplore.EdFindKeyPress(Sender: TObject; var Key: Char);
//0x004A55F4
begin
  if Key <> #13 then exit;
   SearchHumData();
end;


procedure TFrmFDBExplore.ListBox1Click(Sender : TObject);
//0x004A5790
begin
  ListBox2.ItemIndex:=ListBox1.ItemIndex;

end;

procedure TFrmFDBExplore.BtnDelClick(Sender : TObject);
//0x004A5A44
var
  nIndex:Integer;
begin
  if ListBox1.ItemIndex <= -1 then exit;
  nIndex:= Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if MessageDlg('是否确认删除人物数据 ' + IntToStr(nIndex) + ' ？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumDataDB.Open then begin
        HumDataDB.Delete(nIndex);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmFDBExplore.BtnRebuildClick(Sender : TObject);//0x004A5B64
begin
  if MessageDlg('在重建数据库过程中，数据库服务器将停止工作，是否确认继续？',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    boAutoClearDB:=False;
    HumDataDB.Rebuild();
    MessageDlg('数据库重建完成！！！',mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmFDBExplore.BtnBlankCountClick(Sender : TObject);
//0x004A5C40
begin
  ListBox1.Clear;
  ListBox2.Clear;
end;

procedure TFrmFDBExplore.BtnAddClick(Sender : TObject);
var
  sChrName:String;
begin
  FrmNewChr.sub_49BD60(sChrName);
  FrmUserSoc.NewChrData(sChrName,0,0,0);

end;

procedure TFrmFDBExplore.FormCreate(Sender : TObject);
//0x004A55B8
begin
  Timer1.Interval:=dwInterval;
  Timer1.Enabled:=True;
  SList_320:=TStringList.Create;
  g_nClearIndex:=0;
  g_nClearCount:=0;
  g_nClearItemIndexCount:=0;
end;

procedure TFrmFDBExplore.BtnAutoCleanClick(Sender : TObject);
//0x004A5D40
begin
  boAutoClearDB:=not boAutoClearDB;
  if boAutoClearDB then BtnAutoClean.Caption:='自动清理'
  else BtnAutoClean.Caption:='停止清理';
end;

procedure TFrmFDBExplore.Timer1Timer(Sender : TObject);
//0x004A5EDC
  function GetDateTime(wM,wD:Word):TDateTime;
  var
    Year, Month, Day: Word;
    i:integer;
  begin
    DecodeDate(Now,Year, Month, Day);
    for I := 0 to wM - 1 do begin
      if Month > 1 then Dec(Month)
      else begin
        Month:=12;
        Dec(Year);
      end;
    end;
    for I := 0 to wD - 1 do begin
      if Day > 1 then Dec(Day)
      else begin
        Day:=28;
        if Month > 1 then Dec(Month)
        else begin
          Month:=12;
          Dec(Year);
        end;
      end;
    end;
    Result:=EncodeDate(Year,Month,Day);
  end;
var
  w32,wDayCount1,wLevel1,w38,wDayCount7,wLevel7,w3E,wDayCount14,wLevel14:Word;
  dt20,dt28,dt30:TDateTime;
  n8,n10:Integer;

  sHumName:String;
  ChrRecord:THumDataInfo;
begin
  if not boAutoClearDB then exit;
  w32:=0;
  w38:=0;
  w3E:=0;
  wDayCount1:=0;
  wDayCount7:=0;
  wDayCount14:=0;
  wLevel1:=0;
  wLevel7:=0;
  wLevel14:=0;
  if CkLv1.Checked then begin
    w32:=nMonth1;
    wDayCount1:=nDay1;
    wLevel1:=nLevel1;
  end;
  if CkLv7.Checked then begin
    w38:=nMonth2;
    wDayCount7:=nDay2;
    wLevel7:=nLevel2;
  end;
  if CkLv14.Checked then begin
    w3E:=nMonth3;
    wDayCount14:=nDay3;
    wLevel14:=nLevel3;
  end;
  dt20:=GetDateTime(w32,wDayCount1);
  dt28:=GetDateTime(w38,wDayCount7);
  dt30:=GetDateTime(w3E,wDayCount14);
  g_nClearRecordCount:=0;
  sHumName:='';
  try
    if HumDataDB.Open then begin
      g_nClearRecordCount:= HumDataDB.Count;
      if g_nClearIndex < g_nClearRecordCount then begin
        n8:=HumDataDB.Get(g_nClearIndex,ChrRecord);
        if n8 >= 0 then begin
          if ((ChrRecord.Header.dCreateDate < dt20) and (ChrRecord.Data.Abil.Level <= wLevel1)) or
             ((ChrRecord.Header.dCreateDate < dt28) and (ChrRecord.Data.Abil.Level <= wLevel7)) or
             ((ChrRecord.Header.dCreateDate < dt30) and (ChrRecord.Data.Abil.Level <= wLevel14)) then begin
             n10:=n8;
             sHumName:=ChrRecord.Header.sName;
             HumDataDB.Delete(n10);
             Inc(g_nClearCount);
           end else begin
             if ClearHumanItem(ChrRecord) then begin
               HumDataDB.Update(g_nClearIndex,ChrRecord);
             end;
           end;
           Inc(g_nClearIndex);
        end;
      end else  g_nClearIndex:=0;
    end;      
  finally
    HumDataDB.Close;
  end;
  if sHumName <> '' then begin
    FrmDBSrv.DelHum(sHumName);
  end;
//  FrmDBSrv.LbAutoClean.Caption:=IntToStr(g_nClearIndex) + '/' + IntToStr(g_nClearCount) + '/' + IntToStr(g_nClearRecordCount);
end;
function TFrmFDBExplore.ClearHumanItem(var ChrRecord:THumDataInfo):Boolean;
var
  I: Integer;
  HumItems:pTHumItems;
  UserItem:pTUserItem;
  Item:pTUserItem;
  SaveList:TStringList;
  ClearList:TList;
  sFileName:String;
  sMsg:String;
begin
  Result:=False;
  ClearList:=nil;

  HumItems:=@ChrRecord.Data.HumItems;
  for I := Low(THumItems) to high(THumItems) do begin
    UserItem:=@HumItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList:=TList.Create;
      New(Item);
      Item^:=UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex:=0;
      Result:=True;
    end;
  end;
  for I := Low(TBagItems) to high(TBagItems) do begin
    UserItem:=@ChrRecord.Data.BagItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList:=TList.Create;
      New(Item);
      Item^:=UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex:=0;
      Result:=True;
    end;
  end;
  for I := Low(TStorageItems) to high(TStorageItems) do begin
    UserItem:=@ChrRecord.Data.StorageItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList:=TList.Create;
      New(Item);
      Item^:=UserItem^;
      ClearList.Add(Item);

      UserItem.wIndex:=0;
      Result:=True;
    end;
  end;
  if Result then begin
    Inc(g_nClearItemIndexCount,ClearList.Count);

    SaveList:=TStringList.Create;
    sFileName:='ClearItemLog.txt';
    if FileExists(sFileName) then begin
      SaveList.LoadFromFile(sFileName);
    end;
    for I := 0 to ClearList.Count - 1 do begin
      UserItem:=ClearList.Items[I];
      sMsg:=ChrRecord.Data.sChrName + #9 + IntToStr(UserItem.wIndex) + #9 + IntToStr(UserItem.MakeIndex);
      SaveList.Insert(0,sMsg);
      Dispose(UserItem);
    end;
    SaveList.SaveToFile(sFileName);
    SaveList.Free;
  end;
  if ClearList <> nil then ClearList.Free;
end;
procedure TFrmFDBExplore.BtnCopyRcdClick(Sender : TObject);
//0x004A6220
var
  sSrcChrName,sDestChrName,sUserID:String;
begin
  if not FrmCopyRcd.sub_49C09C then exit;
  sSrcChrName:=FrmCopyRcd.s2F0;
  sDestChrName:=FrmCopyRcd.s2F4;
  sUserID:=FrmCopyRcd.s2F8;
  if FrmDBSrv.CopyHumData(sSrcChrName,sDestChrName,sUserID) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' 复制成功！！！');
end;

procedure TFrmFDBExplore.BtnCopyNewClick(Sender : TObject);
//0x004A631C
var
  sSrcChrName,sDestChrName,sUserID:String;
begin
  if not FrmCopyRcd.sub_49C09C then exit;
  sSrcChrName:=FrmCopyRcd.s2F0;
  sDestChrName:=FrmCopyRcd.s2F4;
  sUserID:=FrmCopyRcd.s2F8;
  if FrmUserSoc.NewChrData(sDestChrName,0,0,0) and
     FrmDBSrv.CopyHumData(sSrcChrName,sDestChrName,sUserID) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' 复制成功！！！');
end;


procedure TFrmFDBExplore.FormDestroy(Sender: TObject);
begin
  SList_320.Free;
end;

procedure TFrmFDBExplore.BtnSearchClick(Sender: TObject);
begin
    SearchHumData();
end;

end.
