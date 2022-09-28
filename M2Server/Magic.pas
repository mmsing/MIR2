unit Magic;

interface

uses
  Windows,Classes,Grobal2,ObjBase,SDK,Math;
type
  TMagicManager = class
  private
    function  MagBigHealing(PlayObject:TBaseObject;nPower,nX,nY:integer): Boolean;
    function  MagPushArround(PlayObject:TBaseObject; nPushLevel: integer): integer;
    function  MagTurnUndead(BaseObject,TargeTBaseObject:TBaseObject;nTargetX,nTargetY:Integer;nLevel:Integer):Boolean;
    function  MagMakeHolyCurtain(BaseObject:TBaseObject;nPower:Integer;nX,nY:Integer):Integer;
    function  MagMakeGroupTransparent(BaseObject:TBaseObject;nX,nY:Integer;nHTime:Integer):Boolean;
    function  MagTamming(BaseObject,TargeTBaseObject:TBaseObject;nTargetX,nTargetY:Integer;nMagicLevel:Integer):Boolean;
    function  MagSaceMove(BaseObject:TBaseObject;nLevel:integer):Boolean;
    function  MagMakeFireCross(PlayObject:TPlayObject;nDamage,nHTime,nX,nY:Integer):Integer;
    function  MagBigExplosion(BaseObject:TBaseObject;nPower,nX,nY:Integer;nRage:Integer):Boolean;
    function  MagElecBlizzard(BaseObject:TBaseObject;nPower:integer):Boolean;
    function  MabMabe(BaseObject,TargeTBaseObject: TBaseObject;nPower,nLevel, nTargetX, nTargetY: Integer):Boolean;
    function  MagMakeSlave(PlayObject:TPlayObject;UserMagic:pTUserMagic):Boolean;
    function  MagMakeClone(PlayObject:TPlayObject;UserMagic:pTUserMagic):Boolean;
    function  MagMakeSinSuSlave(PlayObject:TPlayObject;UserMagic:pTUserMagic):Boolean;
    function  MagMakeAngelSlave(PlayObject:TPlayObject;UserMagic:pTUserMagic):Boolean;
    function  MagWindTebo(PlayObject:TPlayObject;UserMagic:pTUserMagic):Boolean;
    function  MagGroupLightening(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;TargeTBaseObject:TBaseObject; var boSpellFire:Boolean):Boolean;
    function  MagGroupAmyounsul(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;TargeTBaseObject:TBaseObject):Boolean;
    function  MagGroupDeDing(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;TargeTBaseObject:TBaseObject):Boolean;
    function  MagGroupMb(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;TargeTBaseObject:TBaseObject):Boolean;

    function  MagHbFireBall(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;var TargeTBaseObject:TBaseObject):Boolean;

    function  KnockBack(PlayObject:TBaseObject; nPushLevel: integer): integer;
    function  FlameField(BaseObject:TBaseObject;nPower,nX,nY:Integer;nRage:Integer):Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    function  MagMakePrivateTransparent(BaseObject:TBaseObject;nHTime:Integer):Boolean;
    function IsWarrSkill(wMagIdx:Integer):Boolean;
    function DoSpell(PlayObject:TPlayObject;UserMagic:pTUserMagic;nTargetX,nTargetY:Integer;TargeTBaseObject:TBaseObject):Boolean;


  end;
  function MPow(UserMagic:pTUserMagic):Integer;
  function GetPower(nPower:Integer;UserMagic:pTUserMagic):Integer;
  function GetPower13(nInt:Integer;UserMagic:pTUserMagic):Integer;
  function GetRPow(wInt:Integer):Word;
  function CheckAmulet(PlayObject:TPlayObject;nCount:Integer;nType:Integer;var Idx:Integer):Boolean;
  procedure UseAmulet(PlayObject:TPlayObject;nCount:Integer;nType:Integer;var Idx:Integer);

implementation

uses HUtil32, M2Share, Event, Envir, ItmUnit, sysutils;

function MPow(UserMagic:pTUserMagic):Integer;
begin
  Result:=UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
end;
function GetPower(nPower:Integer;UserMagic:pTUserMagic):Integer;
begin
  Result:=ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
end;

function GetPower13(nInt:Integer;UserMagic:pTUserMagic):Integer;
var
  d10:Double;
  d18:Double;
begin
  d10:=nInt / 3.0;
  d18:=nInt - d10;
  Result:=ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 +(UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
end;
function GetRPow(wInt:Integer):Word;
begin
  if HiWord(wInt) > LoWord(wInt) then begin
    Result:=Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
  end else Result:=LoWord(wInt);
end;

//nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
function CheckAmulet(PlayObject:TPlayObject;nCount:Integer;nType:Integer;var Idx:Integer):Boolean;
var
  AmuletStdItem:TItem;
begin
  Result:=False;
  Idx:=0;
  if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
    AmuletStdItem:=UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then begin
      case nType of    
        1: begin
          if (AmuletStdItem.Shape = 5) and (ROUND(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
            Idx:=U_ARMRINGL;
            Result:=True;
            exit;
          end;
        end;
        2: begin
          if (AmuletStdItem.Shape <= 2) and (ROUND(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
            Idx:=U_ARMRINGL;
            Result:=True;
            exit;
          end;
        end;
      end;
    end;
  end;

  if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then begin
    AmuletStdItem:=UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then begin
      case nType of 
        1: begin
          if (AmuletStdItem.Shape = 5) and (ROUND(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
            Idx:=U_BUJUK;
            Result:=True;
            exit;
          end;
        end;
        2: begin
          if (AmuletStdItem.Shape <= 2) and (ROUND(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
            Idx:=U_BUJUK;
            Result:=True;
            exit;
          end;
        end;
      end;
    end;
  end;

end;

//nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
procedure UseAmulet(PlayObject:TPlayObject;nCount:Integer;nType:Integer;var Idx:Integer);
begin
  if PlayObject.m_UseItems[Idx].Dura > nCount * 100 then begin
    Dec(PlayObject.m_UseItems[Idx].Dura,nCount * 100);
    PlayObject.SendMsg(PlayObject,RM_DURACHANGE,Idx,PlayObject.m_UseItems[Idx].Dura,PlayObject.m_UseItems[Idx].DuraMax,0,'');
  end else begin
    PlayObject.m_UseItems[Idx].Dura:=0;
    PlayObject.SendDelItems(@PlayObject.m_UseItems[Idx]);
    PlayObject.m_UseItems[Idx].wIndex:=0;
  end;
end;

function  TMagicManager.MagPushArround (PlayObject:TBaseObject;nPushLevel: integer): integer; //00492204
var
   i, nDir, levelgap, push: integer;
   BaseObject: TBaseObject;
begin
   Result := 0;
   for i:=0 to PlayObject.m_VisibleActors.Count-1 do begin
      BaseObject:= TBaseObject (pTVisibleBaseObject(PlayObject.m_VisibleActors[i]).BaseObject);
      if (abs(PlayObject.m_nCurrX-BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY-BaseObject.m_nCurrY) <= 1) then begin
         if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then begin
            if (PlayObject.m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
               levelgap := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
               if (Random(20) < 6 + nPushLevel * 3 + levelgap) then begin
                  if PlayObject.IsProperTarget(BaseObject) then begin
                     push := 1 + _MAX(0,nPushLevel - 1) + Random(2);
                     nDir:= GetNextDirection (PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
                     BaseObject.CharPushed (nDir, push);
                     Inc (Result);
                  end;
               end;
            end;
         end;
      end;
   end;

end;
function  TMagicManager.MagBigHealing (PlayObject:TBaseObject;nPower,nX,nY:integer): Boolean; //00492E50
var
   i: integer;
   BaseObjectList:TList;
   BaseObject:TBaseObject;
begin
   Result:=False;
   BaseObjectList:= TList.Create;
   PlayObject.GetMapBaseObjects (PlayObject.m_PEnvir,nX,nY,1, BaseObjectList);
   for i:=0 to BaseObjectList.Count-1 do begin
      BaseObject:= TBaseObject (BaseObjectList[i]);
      if PlayObject.IsProperFriend (BaseObject) then begin
         if BaseObject.m_WAbil.HP < BaseObject.m_WAbil.MaxHP then begin
            BaseObject.SendDelayMsg (PlayObject,RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
            Result:=True;
         end;
         if PlayObject.m_boAbilSeeHealGauge then begin
            PlayObject.SendMsg (BaseObject,RM_10414, 0, 0, 0, 0, '');  //?? RM_INSTANCEHEALGUAGE
         end;
      end;
   end;
   BaseObjectList.Free;
end;

constructor TMagicManager.Create;//0049214C
begin

end;

destructor TMagicManager.Destroy;
begin

  inherited;
end;

//�Ƿ�Ϊսʿ����
function TMagicManager.IsWarrSkill(wMagIdx: Integer): Boolean; //492190
begin
  Result:=False;
  if wMagIdx in [SKILL_ONESWORD{3},SKILL_ILKWANG{4},SKILL_YEDO{7},SKILL_ERGUM{12},SKILL_BANWOL{25},SKILL_FIRESWORD{26},SKILL_MOOTEBO{27}, SKILL_CROSSMOON, SKILL_TWINBLADE] then
    Result:=True;
end;

//ִ��ħ������
function TMagicManager.DoSpell(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject):Boolean; //0049350C
var
  boTrain     :Boolean;
  boSpellFail :Boolean;
  boSpellFire :Boolean;
  n14         :Integer;
  n18         :Integer;
  n1C         :Integer;
  nPower      :Integer;
  StdItem     :TItem;
  nAmuletIdx  :Integer;

  function MPow(UserMagic:pTUserMagic):Integer; //004921C8
  begin
    Result:=UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower:Integer):Integer; //00493314
  begin
    Result:=ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
  function GetPower13(nInt:Integer):Integer; //0049338C
  var
    d10:Double;
    d18:Double;
  begin
    d10:=nInt / 3.0;
    d18:=nInt - d10;
    Result:=ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 +(UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
  end;
  function GetRPow(wInt:Integer):Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result:=Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
    end else Result:=LoWord(wInt);
  end;
  procedure sub_4934B4(PlayObject:TPlayObject);
  begin
    if PlayObject.m_UseItems[U_ARMRINGL].Dura < 100 then begin
      PlayObject.m_UseItems[U_ARMRINGL].Dura:=0;
      PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
      PlayObject.m_UseItems[U_ARMRINGL].wIndex:=0;
    end;      
  end;

begin //0049350C
  Result:=False;
  if IsWarrSkill(UserMagic.wMagIdx) then exit;

  if (abs(PlayObject.m_nCurrX - nTargetX) > g_Config.nMagicAttackRage) or (abs(PlayObject.m_nCurrY - nTargetY) > g_Config.nMagicAttackRage) then begin
    exit;
  end;

  PlayObject.SendRefMsg(RM_SPELL,UserMagic.MagicInfo.btEffect,nTargetX,nTargetY,UserMagic.MagicInfo.wMagicId,'');
  if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_boDeath) then TargeTBaseObject:=nil;
  boTrain:=False;
  boSpellFail:=False;
  boSpellFire:=True;
  nPower:=0;
  if (PlayObject.m_nSoftVersionDateEx = 0) and (PlayObject.m_dwClientTick = 0) and (UserMagic.MagicInfo.wMagicId > 40) then exit;

  case UserMagic.MagicInfo.wMagicId of    //
    SKILL_FIREBALL{1},
    SKILL_FIREBALL2{5}: begin //������ �����
      if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
        if PlayObject.IsProperTarget (TargeTBaseObject) then begin
          if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX-nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY-nTargetY) <= 1) then begin
            with PlayObject do begin
                nPower:= GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
                                      SmallInt(HiWord(m_WAbil.MC)-LoWord(m_WAbil.MC)) + 1);
                 //pwr := GetPower (MPow(UserMagic)) + (Lobyte(WAbil.MC) + Random(Hibyte(WAbil.MC)-Lobyte(WAbil.MC) + 1));
                 //Ÿ�� ����, �Ŀ� ȿ����Ÿ��
                 //target.SendDelayMsg (user, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 1200 + _MAX(Abs(CX-xx),Abs(CY-yy)) * 50 );
            end;
          //rm-delaymagic���� selecttarget�� ó���Ѵ�.
            PlayObject.SendDelayMsg (PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, integer(TargeTBaseObject), '', 600);
            if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then boTrain:=True;
          end else
            TargeTBaseObject := nil;
        end else
         TargeTBaseObject := nil;
      end else
        TargeTBaseObject := nil;
    end;
    SKILL_HEALLING{2}: begin  //������
      if TargeTBaseObject = nil then begin
        TargeTBaseObject:=PlayObject;
        nTargetX:=PlayObject.m_nCurrX;
        nTargetY:=PlayObject.m_nCurrY;
      end;
      if PlayObject.IsProperFriend{0FFF3}(TargeTBaseObject) then begin
        nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
                                      SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
        if TargeTBaseObject.m_WAbil.HP < TargeTBaseObject.m_WAbil.MaxHP then begin
          TargeTBaseObject.SendDelayMsg(PlayObject,RM_MAGHEALING,0,nPower,0,0,'',800);
          boTrain:=True;
        end;
        if PlayObject.m_boAbilSeeHealGauge then
          PlayObject.SendMsg(TargeTBaseObject,RM_10414,0,0,0,0,'');
      end;
    end;
    SKILL_AMYOUNSUL{6}: begin  //ʩ����
      (*
      boSpellFail:=True;

      if PlayObject.IsProperTarget(TargeTBaseObject) then begin
        if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
          StdItem:=UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
          if (StdItem <> nil) and (StdItem.StdMode = 25) and (StdItem.Shape <= 2) then begin
            if PlayObject.m_UseItems[U_ARMRINGL].Dura >= 100 then begin
              Dec(PlayObject.m_UseItems[U_ARMRINGL].Dura,100);
              PlayObject.SendMsg(PlayObject,RM_DURACHANGE,5,PlayObject.m_UseItems[U_ARMRINGL].Dura,PlayObject.m_UseItems[U_ARMRINGL].DuraMax,0,'');
              if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then begin
                case StdItem.Shape of
                  1: begin //0493F94
                    nPower:=GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                    TargeTBaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DECHEALTH{�ж����� - �̶�},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
                  end;
                  2: begin //00493FE9
                    nPower:=GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                    TargeTBaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DAMAGEARMOR{�ж����� - �춾},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
                  end;
                end; //0049403C
                if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
                  boTrain:=True;
              end; //00494058
              PlayObject.SetTargetCreat(TargeTBaseObject);
              boSpellFail:=False;
            end; //0049406B
            if PlayObject.m_UseItems[U_ARMRINGL].Dura < 100 then begin
              PlayObject.m_UseItems[U_ARMRINGL].Dura:=0;
              PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
              PlayObject.m_UseItems[U_ARMRINGL].wIndex:=0;
            end;
          end;
        end;
      end;
      *)
      boSpellFail:=True;

      if PlayObject.IsProperTarget(TargeTBaseObject) then begin

        if CheckAmulet(PlayObject,1,2,nAmuletIdx) then begin
          StdItem:=UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
          if StdItem <> nil then begin
          UseAmulet(PlayObject,1,2,nAmuletIdx);

          if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then begin
            case StdItem.Shape of
              1: begin //0493F94
                nPower:=GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                TargeTBaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DECHEALTH{�ж����� - �̶�},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
              end;
              2: begin //00493FE9
                nPower:=GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                TargeTBaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DAMAGEARMOR{�ж����� - �춾},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
              end;
            end; //0049403C
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
              boTrain:=True;
          end; //00494058
          PlayObject.SetTargetCreat(TargeTBaseObject);
          boSpellFail:=False;
          end;
        end; //0049406B
      end;
    end;
    SKILL_FIREWIND{8}: begin  //���ܻ�  00493754
      if MagPushArround(PlayObject,UserMagic.btLevel) > 0 then boTrain:=True;
    end;
    SKILL_FIRE{9}: begin //������ 00493778
      n1C:=GetNextDirection(PlayObject.m_nCurrX,PlayObject.m_nCurrY,nTargetX,nTargetY);
      if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX,PlayObject.m_nCurrY,n1C,1,n14,n18) then begin
        PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX,PlayObject.m_nCurrY,n1C,5,nTargetX,nTargetY);
        nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
                                      SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1);
        if PlayObject.MagPassThroughMagic(n14,n18,nTargetX,nTargetY,n1C,nPower,False) > 0 then
          boTrain:=True;
      end;
    end;
    SKILL_SHOOTLIGHTEN{10}: begin //�����Ӱ 0049386A
      n1C:=GetNextDirection(PlayObject.m_nCurrX,PlayObject.m_nCurrY,nTargetX,nTargetY);
      if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX,PlayObject.m_nCurrY,n1C,1,n14,n18) then begin
        PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX,PlayObject.m_nCurrY,n1C,8,nTargetX,nTargetY);
        nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
                                      SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1);
        if PlayObject.MagPassThroughMagic(n14,n18,nTargetX,nTargetY,n1C,nPower,True) > 0 then
          boTrain:=True;
      end;
    end;
    SKILL_LIGHTENING{11}: begin //�׵��� 0049395C
      if PlayObject.IsProperTarget (TargeTBaseObject) then begin
        if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
          nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
                                      SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1);
          if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
            nPower:=ROUND(nPower * 1.5);
          PlayObject.SendDelayMsg(PlayObject,RM_DELAYMAGIC,nPower,MakeLong(nTargetX,nTargetY),2,Integer(TargeTBaseObject),'',600);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then
            boTrain:=True;
        end else TargeTBaseObject:=nil
      end else TargeTBaseObject:=nil;
    end;
    SKILL_FIRECHARM{13},
    SKILL_HANGMAJINBUB{14},
    SKILL_DEJIWONHO{15},
    SKILL_HOLYSHIELD{16},
    SKILL_SKELLETON{17},
    SKILL_CLOAK{18},
    SKILL_BIGCLOAK{19}: begin //004940BC
      boSpellFail:=True;
      if CheckAmulet(PlayObject,1,1,nAmuletIdx) then begin
        UseAmulet(PlayObject,1,1,nAmuletIdx);
        {
        if BaseObject.m_UseItems[U_ARMRINGL].Dura >= 100 then Dec(BaseObject.m_UseItems[U_ARMRINGL].Dura,100)
        else BaseObject.m_UseItems[U_ARMRINGL].Dura:=0;
        BaseObject.SendMsg(BaseObject,RM_DURACHANGE,U_ARMRINGL,BaseObject.m_UseItems[U_ARMRINGL].Dura,BaseObject.m_UseItems[U_ARMRINGL].DuraMax,0,'');
        }
        case UserMagic.MagicInfo.wMagicId of    //
          SKILL_FIRECHARM{13}: begin //����� 0049415F
            if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX,PlayObject.m_nCurrY,TargeTBaseObject) then begin
              if PlayObject.IsProperTarget(TargeTBaseObject) then begin
                if Random(10) >= TargeTBaseObject.m_nAntiMagic then begin
                  if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
                    nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
                                                   SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC))+ 1);
                    PlayObject.SendDelayMsg(PlayObject,RM_DELAYMAGIC,nPower,MakeLong(nTargetX,nTargetY),2,Integer(TargeTBaseObject),'',1200);
                    if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then
                      boTrain:=True;
                  end; //00494463
                end; //00494463
              end; //00494463
            end else TargeTBaseObject:=nil; //0049426D              
          end;
          SKILL_HANGMAJINBUB{14}: begin //����� 00494277
            nPower:= PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10,SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC))+ 1);
            if PlayObject.MagMakeDefenceArea(nTargetX,nTargetY,3,nPower,1) > 0 then
              boTrain:=True;
          end;
          SKILL_DEJIWONHO{15}: begin //��ʥս���� 004942E5
            nPower:= PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10,SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC))+ 1);
            if PlayObject.MagMakeDefenceArea(nTargetX,nTargetY,3,nPower,0) > 0 then
              boTrain:=True;
          end;
          SKILL_HOLYSHIELD{16}: begin //��ħ�� 00494353
            if MagMakeHolyCurtain(PlayObject,GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 3,nTargetX,nTargetY) > 0 then
              boTrain:=True;
          end;
          SKILL_SKELLETON{17}: begin //�ٻ����� 004943A2
            if MagMakeSlave(PlayObject,UserMagic) then begin
              boTrain:=True;
            end;
            (*
            if not PlayObject.sub_4DD704 then begin
              if PlayObject.MakeSlave(g_Config.sBoneFamm,UserMagic.btLevel,g_Config.nBoneFammCount{1},10 * 24 * 60 * 60) <> nil then
                boTrain:=True;
            end;
            *)
          end;
          SKILL_CLOAK{18}: begin //������ 004943DF
            if MagMakePrivateTransparent(PlayObject,GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
              boTrain:=True;
          end;
          SKILL_BIGCLOAK{19}: begin //����������
            if MagMakeGroupTransparent(PlayObject,nTargetX,nTargetY,GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
              boTrain:=True;
          end;
        end;    // case
        boSpellFail:=False;
      end;
        
    end;
    SKILL_TAMMING{20}: begin //�ջ�֮�� 00493A51
      if PlayObject.IsProperTarget (TargeTBaseObject) then begin
        if MagTamming(PlayObject,TargeTBaseObject,nTargetX,nTargetY,UserMagic.btLevel) then
          boTrain:=True;
      end;
    end;
    SKILL_SPACEMOVE{21}: begin //˲Ϣ�ƶ� 00493ADD
      PlayObject.SendRefMsg(RM_MAGICFIRE,0,MakeWord(UserMagic.MagicInfo.btEffectType,UserMagic.MagicInfo.btEffect),MakeLong(nTargetX,nTargetY),Integer(TargeTBaseObject),'');
      boSpellFire:=False;
      if MagSaceMove(PlayObject,UserMagic.btLevel) then
        boTrain:=True;
    end;
    SKILL_EARTHFIRE{22}: begin  //��ǽ  00493B40
      if MagMakeFireCross(PlayObject,
                          PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
                          SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1),
                          GetPower(10) + (Word(GetRPow(PlayObject.m_WAbil.MC)) shr 1),  //��ǽʱ��
                          nTargetX,
                          nTargetY) > 0 then
        boTrain:=True;
    end;
    SKILL_FIREBOOM{23}: begin //���ѻ��� 00493BD5
      if MagBigExplosion(PlayObject,
                         PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1),
                         nTargetX,
                         nTargetY,
                         g_Config.nFireBoomRage{1}) then
        boTrain:=True;
    end;
    SKILL_LIGHTFLOWER{24}: begin //�����׹� 00493CB1
      if MagElecBlizzard(PlayObject,PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1)) then
        boTrain:=True;
    end;
    SKILL_SHOWHP{28}: begin   //������ʾ
      if (TargeTBaseObject <> nil) and not TargeTBaseObject.m_boShowHP then begin
        if Random(6) <= (UserMagic.btLevel + 3) then begin
          TargeTBaseObject.m_dwShowHPTick:=GetTickCount();
          TargeTBaseObject.m_dwShowHPInterval:=GetPower13(GetRPow(PlayObject.m_WAbil.SC) * 2 + 30) * 1000;
          TargeTBaseObject.SendDelayMsg(TargeTBaseObject,RM_DOOPENHEALTH,0,0,0,0,'',1500);
          boTrain:=True;
        end;
      end;        
    end;
    SKILL_BIGHEALLING{29}: begin //Ⱥ�������� 00493E42
      nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
                                    SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
      if MagBigHealing(PlayObject,nPower,nTargetX,nTargetY) then boTrain:=True;
    end;
    SKILL_SINSU{30}: begin //�ٻ����� 00494476
      boSpellFail:=True;
      //
      if CheckAmulet(PlayObject,5,1,nAmuletIdx) then begin   //����������ϵĻ���������Ƿ���ڻ����5��
        UseAmulet(PlayObject,5,1,nAmuletIdx);   //ʹ�û������5�����Ļ��������, 1�����
        {
        if BaseObject.m_UseItems[U_ARMRINGL].Dura >= 500 then Dec(BaseObject.m_UseItems[U_ARMRINGL].Dura,500)
        else BaseObject.m_UseItems[U_ARMRINGL].Dura:=0;
        BaseObject.SendMsg(BaseObject,RM_DURACHANGE,5,BaseObject.m_UseItems[U_ARMRINGL].Dura,BaseObject.m_UseItems[U_ARMRINGL].DuraMax,0,'');
        }
//        if (UserMagic.MagicInfo.wMagicId = 30) and not PlayObject.sub_4DD704 then begin
          if MagMakeSinSuSlave(PlayObject,UserMagic) then begin  //���޳ɹ����������ʿ�����б���
            boTrain:=True;
          end;
//          if PlayObject.MakeSlave(g_Config.sDogz,UserMagic.btLevel,1,10 * 24 * 60 * 60) <> nil then
//            boTrain:=True;
//        end;
        boSpellFail:=False;
      end;
    end;
    SKILL_ANGEL: begin
      boSpellFail:=True;
      if CheckAmulet(PlayObject,2,1,nAmuletIdx) then begin
        UseAmulet(PlayObject,2,1,nAmuletIdx);

        if MagMakeAngelSlave(PlayObject,UserMagic) then
          boTrain:=True;

        boSpellFail:=False;
      end;
    end;
    SKILL_SHIELD{31}: begin //ħ���� 00493D15
      if PlayObject.MagBubbleDefenceUp(UserMagic.btLevel,GetPower(GetRPow(PlayObject.m_WAbil.MC) + 15)) then
            boTrain:=True;
    end;
    SKILL_KILLUNDEAD{32}:begin //00493A97  ʥ����
      if PlayObject.IsProperTarget (TargeTBaseObject) then begin
        if MagTurnUndead(PlayObject,TargeTBaseObject,nTargetX,nTargetY,UserMagic.btLevel) then
          boTrain:=True;
      end;
    end;
    SKILL_SNOWWIND{33}: begin //00493C43 ������
      if MagBigExplosion(PlayObject,
                         PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1),
                         nTargetX,
                         nTargetY,
                         g_Config.nSnowWindRange{1}) then
        boTrain:=True;
    end;
    SKILL_UNAMYOUNSUL{34}: begin //�ⶾ��
      if TargeTBaseObject = nil then begin
        TargeTBaseObject:=PlayObject;
        nTargetX:=PlayObject.m_nCurrX;
        nTargetY:=PlayObject.m_nCurrY;
      end;

      if PlayObject.IsProperFriend(TargeTBaseObject) then begin
        if Random(7) - (UserMagic.btLevel + 1) < 0 then begin
          if TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] <> 0 then begin
            TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH]:=1;
            boTrain:=True;
          end;
          if TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0 then begin
            TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR]:=1;
            boTrain:=True;
          end;
          if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then begin
            TargeTBaseObject.m_wStatusTimeArr[POISON_STONE]:=1;
            boTrain:=True;
          end;
        end;
      end;

    end;
    SKILL_WINDTEBO{35}: if MagWindTebo(PlayObject,UserMagic) then boTrain:=True;

    //����
    SKILL_MABE{36}: begin
      with PlayObject do begin
         nPower:= GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
                               SmallInt(HiWord(m_WAbil.MC)-LoWord(m_WAbil.MC)) + 1);
      end;
      if MabMabe(PlayObject,TargeTBaseObject,nPower,UserMagic.btLevel,nTargetX,nTargetY) then
        boTrain:=True;
    end;
    SKILL_GROUPLIGHTENING{37 Ⱥ���׵���}: begin
      if MagGroupLightening(PlayObject,UserMagic,nTargetX, nTargetY,TargeTBaseObject,boSpellFire) then
        boTrain:=True;
    end;
    SKILL_GROUPAMYOUNSUL{38 Ⱥ��ʩ����}: begin
      if MagGroupAmyounsul(PlayObject,UserMagic,nTargetX, nTargetY,TargeTBaseObject) then
        boTrain:=True;
    end;
    SKILL_GROUPDEDING{39 �ض�}: begin
      if MagGroupDeDing(PlayObject,UserMagic,nTargetX, nTargetY,TargeTBaseObject) then
        boTrain:=True;
    end;
   { SKILL_41: begin  //ʨ�Ӻ�
      if MagGroupMb(PlayObject,UserMagic,nTargetX, nTargetY,TargeTBaseObject) then
        boTrain:=True;
    end; }
    SKILL_43:
      begin //�ƿս�

      end;
      
    //��ʦ
    SKILL_44: begin  //�����
      if MagHbFireBall(PlayObject,UserMagic,nTargetX, nTargetY,TargeTBaseObject) then boTrain:=True;
    end;
    SKILL_45: begin  //�����
      if PlayObject.IsProperTarget (TargeTBaseObject) then begin
        if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
          nPower:= PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
                                      SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1);
          if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
            nPower:=ROUND(nPower * 1.5);
          PlayObject.SendDelayMsg(PlayObject,RM_DELAYMAGIC,nPower,MakeLong(nTargetX,nTargetY),2,Integer(TargeTBaseObject),'',600);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then
            boTrain:=True;
        end else TargeTBaseObject:=nil
      end else TargeTBaseObject:=nil;
    end;
    SKILL_46: begin  //������
      if MagMakeClone(PlayObject,UserMagic) then begin
        boTrain:=True;
      end;
    end;
    SKILL_47: begin  //��������
      if MagBigExplosion(PlayObject,
                         PlayObject.GetAttackPower (GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1),
                         nTargetX,
                         nTargetY,
                         g_Config.nFireBoomRage{1}) then
        boTrain:=True;
    end;

    //��ʿ
    SKILL_ENERGYREPULSOR: begin  //������
      if MagPushArround(PlayObject,UserMagic.btLevel) > 0 then boTrain:=True;
    end;
    SKILL_49: begin  //������
      boTrain:=True;
    end;
    SKILL_UENHANCER: begin  //�޼�����
      boSpellFail:=True;
      if TargeTBaseObject = nil then begin
        TargeTBaseObject:=PlayObject;
        nTargetX:=PlayObject.m_nCurrX;
        nTargetY:=PlayObject.m_nCurrY;
      end;
      if PlayObject.IsProperFriend(TargeTBaseObject) then begin
        if CheckAmulet(PlayObject,1,1,nAmuletIdx) then begin
          UseAmulet(PlayObject,1,1,nAmuletIdx);

          nPower := (UserMagic.btLevel + 1) {* 2} + Random(UserMagic.btLevel);
          n14 := PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10,SmallInt(HiWord(PlayObject.m_WAbil.SC)-LoWord(PlayObject.m_WAbil.SC))+ 1);
          if TargeTBaseObject.AttPowerUp(nPower, n14) then
            boTrain:=True;

          boSpellFail:=False;
        end;
      end;
    end;
    SKILL_51: begin  //����ٻ���
      boTrain:=True;
    end;
    SKILL_52: begin  //������
      boTrain:=True;
    end;
    SKILL_53: begin  //����ٻ���
      boTrain:=True;
    end;
    SKILL_54: begin  //������
      boTrain:=True;
    end;
  end;
  if boSpellFail then exit;
  if boSpellFire then begin
    PlayObject.SendRefMsg(RM_MAGICFIRE,0,
                        MakeWord(UserMagic.MagicInfo.btEffectType,UserMagic.MagicInfo.btEffect),
                        MakeLong(nTargetX,nTargetY),
                        Integer(TargeTBaseObject),
                        '');
  end;
  if (UserMagic.btLevel < 3) and (boTrain) then begin
    if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= PlayObject.m_Abil.Level then begin
      PlayObject.TrainSkill(UserMagic,Random(3) + 1);
      if not PlayObject.CheckMagicLevelup(UserMagic) then begin
        PlayObject.SendDelayMsg(PlayObject,RM_MAGIC_LVEXP,0,UserMagic.MagicInfo.wMagicId,UserMagic.btLevel,UserMagic.nTranPoint,'',1000);
      end;
    end;
  end;
  Result:=True;
    
end;

function TMagicManager.MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer):Boolean; //004930E8
var
  I                :Integer;
  BaseObjectList   :TList;
  TargeTBaseObject :TBaseObject;
begin
  Result:=False;
  if BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT{0x70}] > 0 then exit;   //4930FE
  BaseObjectList:=TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,BaseObject.m_nCurrX,BaseObject.m_nCurrY,9,BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and (TargeTBaseObject.m_TargetCret = BaseObject) then begin
      if (abs(TargeTBaseObject.m_nCurrX - BaseObject.m_nCurrX) > 1) or
         (abs(TargeTBaseObject.m_nCurrY - BaseObject.m_nCurrY) > 1) or
         (Random(2) = 0) then begin
        TargeTBaseObject.m_TargetCret:=nil;
      end;
    end;
  end;
  BaseObjectList.Free;
  BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT{0x70}]:=nHTime; //004931D2
  BaseObject.m_nCharStatus:=BaseObject.GetCharStatus();
  BaseObject.StatusChanged();
  BaseObject.m_boHideMode:=True;
  BaseObject.m_boTransparent:=True;
  Result:=True;
end;


//
//ħ�����ջ�֮��
//
//�ջ�֮�⼼���޸ģ�
// 1.�����ջ����ĳɹ��ʡ�
// 2.���ӹ����б�ʱ�� ����ɫ24�� => 3����Сʱ����ɫ30�� => 4����Сʱ����ɫ40�� => 5����Сʱ����
// 3.�Ѿ������˵ĳ�����˲������ջ�ó�����ǳ����ѱ䡣
// �޸�ʱ��: 2020,2,4
// �޸���: Davy (LZX)
function TMagicManager.MagTamming(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean; //00492368
var
  n14:Integer;
  nSpiritMutinyTime:Integer; //��ʦ�����б�ʱ�䣬��λ������
begin
  Result:=False;
  
   if (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and (Random(4 - nMagicLevel) = 0)  then begin   //ֻ�й���û������ʱ���������ջ󣨷�ֹ�������˵ĳ��

      // ((TargeTBaseObject.m_Master = nil) or (TargeTBaseObject.m_Master = BaseObject)) 
      TargeTBaseObject.m_TargetCret:=nil;

      //ԭ������δ����ù�������ױ���ס���о���̫�� ������ȡ��ʧ
      //  if TargeTBaseObject.m_Master = BaseObject then begin    //if 1
      //     TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);    //��ס����
      //     Result:=True;
      //  end else begin    //if-else1

       //MainOutMessage('1 --->');   //watch 1

       if Random(2) = 0 then begin
         if TargeTBaseObject.m_Abil.Level <= BaseObject.m_Abil.Level + 2 then begin   //����ĵȼ���Ҫ���ڹ���ȼ�2��

         //MainOutMessage('2');   //watch 2

          // if Random(3) = 0 then begin
          if Random(1) = 0 then begin

            //MainOutMessage('3');  //watch 3

            // if Random((BaseObject.m_Abil.Level + 20) + (nMagicLevel * 5)) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel{10}) then begin
            if RandomRange(BaseObject.m_Abil.Level, (BaseObject.m_Abil.Level + 20)) + (nMagicLevel * 5) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel{10}) then begin

               //MainOutMessage('4');  //watch 4

               if not(TargeTBaseObject.m_boNoTame) and   //Ŀ������Ƿ��ѱ�ѵ��������Ѿ������˵ĳ��˵���Ǳ��ѱ�ѵ���ģ�m_boNoTameΪTRUE��
                 (TargeTBaseObject.m_btLifeAttrib <> LA_UNDEAD) and                                                             
                 (TargeTBaseObject.m_Abil.Level <= g_Config.nMagTammingLevel{50}) and   //����ȼ�С�ڻ�������޶��ȼ�
                 (BaseObject.m_SlaveList.Count < g_Config.nMagTammingCount{(nMagicLevel + 2)}) then begin

                 //MainOutMessage('5');   //watch 5

                 n14:= TargeTBaseObject.m_WAbil.MaxHP div g_Config.nMagTammingHPRate{100};  //��Ŀ�����Ѫ���ǹ涨Ѫ���ı���

                 if n14 <= 2 then n14:=2  //������Ѫ��Խ��Խ����
                 else Inc(n14,n14);       //n14 + n14 --> n14  ����Ѫ�����ڹ涨Ѫ��ʱ�������ջ��Ѷ�

                if (TargeTBaseObject.m_Master <> BaseObject) and (Random(n14) = 0) then begin
                
                  TargeTBaseObject.BreakCrazyMode();
                  if TargeTBaseObject.m_Master <> nil then begin
                    TargeTBaseObject.m_WAbil.HP:=TargeTBaseObject.m_WAbil.HP div 10;
                  end;
                  TargeTBaseObject.m_Master:=BaseObject;
                  //���㷨ʦ�������б�ʱ�䡣 ��ʦ�����б�ʱ���뷨ʦ�ȼ������ջ�֮���ħ���ȼ��йء�
                  //TargeTBaseObject.m_dwMasterRoyaltyTick:=LongWord((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60 * 1000) + GetTickCount;   //ԭ��ʱ�㷨

                  //�ջ�֮�� �����б�ʱ�䣺�µļ�ʱ�㷨
                  //60*1000(����) = 1 ���� ,(nMagicLevel shl 2)��ʾħ���ȼ�������λ��ÿ��һλ��2��ʱ�䵥λ������
                  //�ջ�֮�⣺��ɫ13����ʼ��ħ��1��18����ʼ��ħ��2 ��24����ʼ��ħ��3
                  //��ɫ13�� => 1Сʱ38�� + 0��13�����; ��ɫ24�� => 3Сʱ24�� + 0��24�����; ��ɫ30�� => 4Сʱ + 0��30�����; ��ɫ40�� => 5Сʱ + 0��30�������
                  nSpiritMutinyTime := LongWord( RandomRange( 0, BaseObject.m_Abil.Level ) + 60 * (BaseObject.m_Abil.Level div 10) + (nMagicLevel shl 2) * 5 );  //������
                  TargeTBaseObject.m_dwMasterRoyaltyTick := LongWord( nSpiritMutinyTime * 60 * 1000 ) + GetTickCount;  //60 * 1000(����) = 1���� �������б�ʱ��

                  TargeTBaseObject.m_btSlaveMakeLevel:=nMagicLevel;
                  if TargeTBaseObject.m_dwMasterTick = 0 then TargeTBaseObject.m_dwMasterTick:=GetTickCount();
                  TargeTBaseObject.BreakHolySeizeMode();
                  
                  if LongWord(1500 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nWalkSpeed) then begin
                    TargeTBaseObject.m_nWalkSpeed:=1500 - nMagicLevel * 200;
                  end;

                  if LongWord(2000 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nNextHitTime) then begin
                    TargeTBaseObject.m_nNextHitTime:=2000 - nMagicLevel * 200;
                  end;

                  TargeTBaseObject.RefShowName();

                  TargeTBaseObject.m_boNoTame := True;            //���ù���ѱ��
                  BaseObject.m_SlaveList.Add(TargeTBaseObject);   //�ջ����ɹ�
                  
                end else begin //004925F2
                  if Random(14) = 0 then begin
                     TargeTBaseObject.m_WAbil.HP:=0;     //���ﱻ����
                  end;

                  //MainOutMessage('6');  //watch 6
                end;
              end else begin //00492615
                 if (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then begin   //���й���Ϊ����ϵ ���絾���ˣ�
                    TargeTBaseObject.m_WAbil.HP:=0;        //���ﱻ����
                 end;

                 //MainOutMessage('7');  //watch 7
              end;
            end else begin //00492641
              if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then begin //���й���Ϊ�ǲ���ϵ ���綤��è��
                 TargeTBaseObject.OpenCrazyMode(Random(20) + 10);  //�����ŭ�����ֱ��ɫ
              end;

              //MainOutMessage('8');   //watch 8
             end;
          end else begin //00492674
             if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then begin   //���й���Ϊ�ǲ���ϵ
                TargeTBaseObject.OpenCrazyMode(Random(20) + 10);  //�����ŭ�����ֱ��ɫ
             end;

             //MainOutMessage('9');   //watch 9
          end;
        end; //004926B0

      end else begin //00492699
         //TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);    
         TargeTBaseObject.OpenHolySeizeMode(Random(nMagicLevel * 5 + 10) * 1000);   //���ﱻ��ס�����ֱ��ɫ

         //MainOutMessage('10');  //watch 10
      end;
      Result:=True;
      
   // end;      //if-else1  end.

   end else begin
     if Random(2) = 0 then Result:=True;   //����
   end;
    
end;

function TMagicManager.MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nLevel: Integer): Boolean; //004926D4
var
  n14:Integer;
begin
  Result:=False;
  if TargeTBaseObject.m_boSuperMan or not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then exit;
  TAnimalObject(TargeTBaseObject).Struck{FFEC}(BaseObject);
  if TargeTBaseObject.m_TargetCret = nil then begin
    TAnimalObject(TargeTBaseObject).m_boRunAwayMode:=True;
    TAnimalObject(TargeTBaseObject).m_dwRunAwayStart:=GetTickCount();
    TAnimalObject(TargeTBaseObject).m_dwRunAwayTime:=10 * 1000;
  end;
  BaseObject.SetTargetCreat(TargeTBaseObject);
  if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
    if TargeTBaseObject.m_Abil.Level < g_Config.nMagTurnUndeadLevel then begin
      n14:=BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
      if Random(100) < ((nLevel shl 3) - nLevel + 15 + n14) then begin
        TargeTBaseObject.SetLastHiter(BaseObject);
        TargeTBaseObject.m_WAbil.HP:=0;
        Result:=True;
      end
    end;
  end; //004927CB
end;

function TMagicManager.MagWindTebo(PlayObject: TPlayObject;
  UserMagic: pTUserMagic): Boolean;
var
  PoseBaseObject:TBaseObject;
begin
  Result:=False;
  PoseBaseObject:=PlayObject.GetPoseCreate;
  if (PoseBaseObject <> nil) and
     (PoseBaseObject <> PlayObject) and
     (not PoseBaseObject.m_boDeath) and
     (not PoseBaseObject.m_boGhost) and
     (PlayObject.IsProperTarget(PoseBaseObject)) and
     (not PoseBaseObject.m_boStickMode) then begin
    if (abs(PlayObject.m_nCurrX - PoseBaseObject.m_nCurrX) <= 1) and
       (abs(PlayObject.m_nCurrY - PoseBaseObject.m_nCurrY) <= 1) and
       (PlayObject.m_Abil.Level > PoseBaseObject.m_Abil.Level) then begin
      if Random(20) < UserMagic.btLevel * 6 + 6 + (PlayObject.m_Abil.Level - PoseBaseObject.m_Abil.Level) then begin
        PoseBaseObject.CharPushed(GetNextDirection(PlayObject.m_nCurrX,PlayObject.m_nCurrY,PoseBaseObject.m_nCurrX,PoseBaseObject.m_nCurrY),_MAX(0,UserMagic.btLevel -1) + 1);
        Result:=True;
      end;
    end;
  end;
end;

function TMagicManager.MagSaceMove(BaseObject: TBaseObject;
  nLevel: integer): Boolean; //04927D8
var
  Envir      :TEnvirnoment;
  PlayObject :TPlayObject;
begin
  Result:=False;
  if Random(11) < nLevel * 2 + 4 then begin
    BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE2,0,0,0,0,'');
    if BaseObject is TPlayObject then begin
      Envir:=BaseObject.m_PEnvir;
      BaseObject.MapRandomMove(BaseObject.m_sHomeMap,1);
      if (Envir <> BaseObject.m_PEnvir) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        PlayObject:=TPlayObject(BaseObject);
        PlayObject.m_boTimeRecall:=False;
      end;
    end;
    Result:=True;
  end; //00492899
end;

function TMagicManager.MagGroupAmyounsul(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I              :Integer;
  BaseObjectList :TList;
  BaseObject     :TBaseObject;
  nPower         :Integer;
  StdItem        :TItem;
  nAmuletIdx     :Integer;
begin
  Result:=False;
  BaseObjectList:=TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir,nTargetX,nTargetY,_MAX(1,UserMagic.btLevel),BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    BaseObject:=TBaseObject(BaseObjectList.Items[I]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget (BaseObject) then begin
      if CheckAmulet(PlayObject,1,2,nAmuletIdx) then begin
        StdItem:=UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
        if StdItem <> nil then begin
        UseAmulet(PlayObject,1,2,nAmuletIdx);
        if Random(BaseObject.m_btAntiPoison + 7) <= 6 then begin
          case StdItem.Shape of
            1: begin
              nPower:=GetPower13(40,UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
              BaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DECHEALTH{�ж����� - �̶�},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
            end;
            2: begin
              nPower:=GetPower13(30,UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
              BaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DAMAGEARMOR{�ж����� - �춾},nPower,Integer(PlayObject),ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)){UserMagic.btLevel},'',1000);
            end;
          end;
          if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
            Result:=True;
            //BaseObject.SetLastHiter(PlayObject);
            //PlayObject.SetTargetCreat(BaseObject);
          end;
        end;
        PlayObject.SetTargetCreat(BaseObject);
      end;
    end;
  end;
  BaseObjectList.Free;
end;


function TMagicManager.MagGroupDeDing(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I              :Integer;
  BaseObjectList :TList;
  BaseObject     :TBaseObject;
  nPower         :Integer;
begin
  Result         :=False;
  BaseObjectList :=TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir,nTargetX,nTargetY,_MAX(1,UserMagic.btLevel),BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    BaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget (BaseObject) then begin
      nPower:=PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.DC),SmallInt((HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC))));
      if (Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint) then begin
        nPower:=0;
      end;
      if nPower > 0 then begin
        nPower:=BaseObject.GetHitStruckDamage(PlayObject,nPower);
      end;
      if nPower > 0 then begin     //004C21FC
        BaseObject.StruckDamage(nPower);
        PlayObject.SendDelayMsg(PlayObject,RM_DELAYMAGIC,nPower,MakeLong(BaseObject.m_nCurrX,BaseObject.m_nCurrY),1,Integer(BaseObject),'',200);
      end;
      if BaseObject.m_btRaceServer >= RC_ANIMAL then
        Result:=True;
    end;
    PlayObject.SendRefMsg(RM_10205,0,BaseObject.m_nCurrX,BaseObject.m_nCurrY,1,'');
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagGroupLightening(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject;var boSpellFire:Boolean): Boolean;
var
  I: Integer;
  BaseObjectList:TList;
  BaseObject:TBaseObject;
  nPower:Integer;
begin
  Result:=False;
  boSpellFire:=False;
  BaseObjectList:=TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir,nTargetX,nTargetY,_MAX(1,UserMagic.btLevel),BaseObjectList);
  PlayObject.SendRefMsg(RM_MAGICFIRE,0,
                        MakeWord(UserMagic.MagicInfo.btEffectType,UserMagic.MagicInfo.btEffect),
                        MakeLong(nTargetX,nTargetY),
                        Integer(TargeTBaseObject),
                        '');
  for I := 0 to BaseObjectList.Count - 1 do begin
    BaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget (BaseObject) then begin
      if (Random(10) >= BaseObject.m_nAntiMagic) then begin
        nPower:=PlayObject.GetAttackPower(GetPower(MPow(UserMagic),UserMagic) + LoWord(PlayObject.m_WAbil.MC),
                                         SmallInt(HiWord(PlayObject.m_WAbil.MC)-LoWord(PlayObject.m_WAbil.MC))+ 1);
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower:=ROUND(nPower * 1.5);

        PlayObject.SendDelayMsg(PlayObject,RM_DELAYMAGIC,nPower,MakeLong(BaseObject.m_nCurrX,BaseObject.m_nCurrY),2,Integer(BaseObject),'',600);
        if BaseObject.m_btRaceServer >= RC_ANIMAL then
          Result:=True;
      end;
      if (BaseObject.m_nCurrX <> nTargetX) or (BaseObject.m_nCurrY <> nTargetY) then
        PlayObject.SendRefMsg(RM_10205,0,BaseObject.m_nCurrX,BaseObject.m_nCurrY,4{type},'');
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagHbFireBall(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargetBaseObject: TBaseObject): Boolean;
var
  nPower   :Integer;
  nDir     :Integer;
  levelgap :Integer;
  push     :Integer;
begin
  Result:=False;
  if not PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargetBaseObject) then begin
    TargeTBaseObject := nil;
    exit;
  end;
  if not PlayObject.IsProperTarget (TargeTBaseObject) then begin
    TargeTBaseObject := nil;
    exit;
  end;
  if (TargeTBaseObject.m_nAntiMagic > Random(10)) or (abs(TargeTBaseObject.m_nCurrX-nTargetX) > 1) or (abs(TargeTBaseObject.m_nCurrY-nTargetY) > 1) then begin
    TargeTBaseObject := nil;
    exit;
  end;
  with PlayObject do begin
    nPower:= GetAttackPower(GetPower(MPow(UserMagic),UserMagic) + LoWord(m_WAbil.MC),
                            SmallInt(HiWord(m_WAbil.MC)-LoWord(m_WAbil.MC)) + 1);
  end;
  PlayObject.SendDelayMsg (PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
  if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result:=True;

  if (PlayObject.m_Abil.Level > TargetBaseObject.m_Abil.Level) and (not TargetBaseObject.m_boStickMode) then begin
    levelgap := PlayObject.m_Abil.Level - TargetBaseObject.m_Abil.Level;
    if (Random(20) < 6 + UserMagic.btLevel * 3 + levelgap) then begin
      push := Random(UserMagic.btLevel) - 1;
      if push > 0 then begin
        nDir:= GetNextDirection (PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargetBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
        PlayObject.SendDelayMsg (PlayObject, RM_DELAYPUSHED, nDir, MakeLong(nTargetX, nTargetY), push, Integer(TargeTBaseObject), '', 600);
      end;
    end;
  end;
end;

//��ǽ
function TMagicManager.MagMakeFireCross(PlayObject: TPlayObject; nDamage,
  nHTime, nX,nY: Integer): Integer; //00492C9C
var
  FireBurnEvent:TFireBurnEvent;
ResourceString
  sDisableInSafeZoneFireCross = '��ȫ��������ʹ��...';
begin
  Result:=0;
  if g_Config.boDisableInSafeZoneFireCross and PlayObject.InSafeZone(PlayObject.m_PEnvir,nX,nY) then begin
    PlayObject.SysMsg(sDisableInSafeZoneFireCross,c_Red,t_Notice);
    exit;
  end;
  if PlayObject.m_PEnvir.GetEvent(nX,nY-1) = nil then begin
    FireBurnEvent:=TFireBurnEvent.Create(PlayObject,nX,nY-1,ET_FIRE,nHTime * 1000 ,nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //0492CFC   x
  if PlayObject.m_PEnvir.GetEvent(nX-1,nY) = nil then begin
    FireBurnEvent:=TFireBurnEvent.Create(PlayObject,nX-1,nY,ET_FIRE,nHTime * 1000 ,nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //0492D4D
  if PlayObject.m_PEnvir.GetEvent(nX,nY) = nil then begin
    FireBurnEvent:=TFireBurnEvent.Create(PlayObject,nX,nY,ET_FIRE,nHTime * 1000 ,nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492D9C
  if PlayObject.m_PEnvir.GetEvent(nX+1,nY) = nil then begin
    FireBurnEvent:=TFireBurnEvent.Create(PlayObject,nX+1,nY,ET_FIRE,nHTime * 1000 ,nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492DED
  if PlayObject.m_PEnvir.GetEvent(nX,nY+1) = nil then begin
    FireBurnEvent:=TFireBurnEvent.Create(PlayObject,nX,nY+1,ET_FIRE,nHTime * 1000 ,nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492E3E
  Result:=1;
end;

function TMagicManager.MagBigExplosion(BaseObject: TBaseObject; nPower, nX,
  nY: Integer; nRage: Integer): Boolean; //00492F4C
var
  I                :Integer;
  BaseObjectList   :TList;
  TargeTBaseObject :TBaseObject;
begin
  Result         := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,nX,nY,nRage,BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperTarget(TargeTBaseObject) then begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject,RM_MAGSTRUCK,0,nPower,0,0,'');
      Result:=True;
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagElecBlizzard(BaseObject: TBaseObject;
  nPower: integer): Boolean; //00493010
var
  I                :Integer;
  BaseObjectList   :TList;
  TargeTBaseObject :TBaseObject;
  nPowerPoint      :Integer;
begin
  Result         := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,BaseObject.m_nCurrX,BaseObject.m_nCurrY,g_Config.nElecBlizzardRange{2},BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject:=TBaseObject(BaseObjectList.Items[I]);
    if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then begin
      nPowerPoint:=nPower div 10;
    end else nPowerPoint:=nPower;
      
    if BaseObject.IsProperTarget(TargeTBaseObject) then begin
      //BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject,RM_MAGSTRUCK,0,nPowerPoint,0,0,'');
      Result:=True;
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagMakeHolyCurtain(BaseObject:TBaseObject;nPower:Integer;nX,nY:Integer): Integer; //004928C0
var
  I                :Integer;
  BaseObjectList   :TList;
  TargeTBaseObject :TBaseObject;
  MagicEvent       :pTMagicEvent;
  HolyCurtainEvent :THolyCurtainEvent;
begin
  Result:=0;
  if BaseObject.m_PEnvir.CanWalk(nX,nY,True) then begin
    BaseObjectList:=TList.Create;
    MagicEvent:=nil;
    BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,nX,nY,1,BaseObjectList);
    for I := 0 to BaseObjectList.Count - 1 do begin
      TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
      if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and
         ((Random(4) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level) and
         {(TargeTBaseObject.m_Abil.Level < 50) and}
         (TargeTBaseObject.m_Master = nil) then begin
        TargeTBaseObject.OpenHolySeizeMode(nPower * 1000);
        if MagicEvent = nil then begin
          New(MagicEvent);
          FillChar(MagicEvent^,SizeOf(TMagicEvent),#0);
          MagicEvent.BaseObjectList:=TList.Create;
          MagicEvent.dwStartTick:=GetTickCount();
          MagicEvent.dwTime:=nPower * 1000;
        end;
        MagicEvent.BaseObjectList.Add(TargeTBaseObject);
        Inc(Result);
      end else begin //00492A02
        Result:=0;
      end;
    end;
    BaseObjectList.Free;
    if (Result > 0) and (MagicEvent <> nil) then begin
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX - 1,nY - 2,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[0]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX + 1,nY - 2,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[1]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX - 2,nY - 1,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[2]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX + 2,nY - 1,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[3]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX - 2,nY + 1,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[4]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX + 2,nY + 1,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[5]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX - 1,nY + 2,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[6]:=HolyCurtainEvent;
      HolyCurtainEvent:=THolyCurtainEvent.Create(BaseObject.m_PEnvir,nX + 1,nY + 2,ET_HOLYCURTAIN,nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[7]:=HolyCurtainEvent;
      UserEngine.m_MagicEventList.Add(MagicEvent);
    end else begin
      if MagicEvent <> nil then begin
        MagicEvent.BaseObjectList.Free;
        Dispose(MagicEvent);
      end;
    end;
  end;    
end;

function TMagicManager.MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY,
  nHTime: Integer): Boolean; //0049320C
var
  I: Integer;
  BaseObjectList:TList;
  TargeTBaseObject:TBaseObject;
begin
  Result:=False;
  BaseObjectList:=TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,nX,nY,1,BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperFriend(TargeTBaseObject) then begin
      if TargeTBaseObject.m_wStatusTimeArr[STATE_TRANSPARENT{0x70}] = 0 then begin //00493287
        TargeTBaseObject.SendDelayMsg(TargeTBaseObject,RM_TRANSPARENT,0,nHTime,0,0,'',800);
        Result:=True;
      end;
    end
  end;
  BaseObjectList.Free;
end;
//=====================================================================================
//���ƣ�
//���ܣ�
//������
//     BaseObject       ħ��������
//     TargeTBaseObject �ܹ�����ɫ
//     nPower           ħ������С
//     nLevel           ���������ȼ�
//     nTargetX         Ŀ������X
//     nTargetY         Ŀ������Y
//����ֵ��
//=====================================================================================
function TMagicManager.MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower,nLevel,
  nTargetX, nTargetY: Integer): Boolean;
var
  nLv:Integer;
begin
  Result:=False;
  if BaseObject.MagCanHitTarget(BaseObject.m_nCurrX, BaseObject.m_nCurrY, TargeTBaseObject) then begin
    if BaseObject.IsProperTarget (TargeTBaseObject) then begin
      if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX-nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY-nTargetY) <= 1) then begin
        BaseObject.SendDelayMsg (BaseObject, RM_DELAYMAGIC, nPower div 3, MakeLong(nTargetX, nTargetY), 2, integer(TargeTBaseObject), '', 600);
        if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
          nLv:=BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
          if (Random(g_Config.nMabMabeHitRandRate{100}) < _MAX(g_Config.nMabMabeHitMinLvLimit,(nLevel * 8) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
         // if (Random(100) < ((nLevel shl 3) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
            if (Random(g_Config.nMabMabeHitSucessRate{21}) < nLevel * 2 + 4) then begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                BaseObject.SetPKFlag(BaseObject);
                BaseObject.SetTargetCreat(TargeTBaseObject);
              end;
              TargeTBaseObject.SetLastHiter(BaseObject);
              nPower:=TargeTBaseObject.GetMagStruckDamage(BaseObject,nPower);
              BaseObject.SendDelayMsg (BaseObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, integer(TargeTBaseObject), '', 600);
              if not TargeTBaseObject.m_boUnParalysis then
                TargeTBaseObject.SendDelayMsg(BaseObject,RM_POISON,POISON_STONE{�ж����� - ���},nPower div g_Config.nMabMabeHitMabeTimeRate{20} + Random(nLevel),Integer(BaseObject),nLevel,'',650);
              Result:=True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//�����޼����ʿ�����б���
function TMagicManager.MagMakeSinSuSlave(PlayObject: TPlayObject;
  UserMagic: pTUserMagic): Boolean;
var
  I: Integer;
  sMonName:String;
  nMakelevel,nExpLevel:Integer;
  nCount:Integer;
  dwRoyaltySec:LongWord;
begin
  Result:=False;
  if not PlayObject.sub_4DD704 then begin
    sMonName:=g_Config.sDragon;
    nMakelevel:=UserMagic.btLevel;
    nExpLevel:=UserMagic.btLevel;
    nCount:=g_Config.nDragonCount;
    dwRoyaltySec:=10 * 24 * 60 * 60;
    for I := Low(g_Config.DragonArray) to High(g_Config.DragonArray) do begin
      if g_Config.DragonArray[I].nHumLevel = 0 then break;
      if PlayObject.m_Abil.Level >= g_Config.DragonArray[I].nHumLevel then begin
        sMonName:=g_Config.DragonArray[I].sMonName;
        nExpLevel:=g_Config.DragonArray[I].nLevel;
        nCount:=g_Config.DragonArray[I].nCount;
      end;
    end;

    if PlayObject.MakeSlave(sMonName,nMakelevel,nExpLevel,nCount,dwRoyaltySec) <> nil then
      Result:=True
    else
      PlayObject.RecallSlave(sMonName);
  end;
//          if PlayObject.MakeSlave(g_Config.sDogz,UserMagic.btLevel,1,10 * 24 * 60 * 60) <> nil then
//            boTrain:=True;
end;

function TMagicManager.MagMakeSlave(PlayObject: TPlayObject;UserMagic:pTUserMagic):Boolean;
var
  I: Integer;
  sMonName:String;
  nMakeLevel,nExpLevel:Integer;
  nCount:Integer;
  dwRoyaltySec:LongWord;
begin
  Result:=False;
  if not PlayObject.sub_4DD704 then begin
   sMonName:=g_Config.sSkeleton;
   nMakeLevel:=UserMagic.btLevel;
   nExpLevel:=UserMagic.btLevel;
   nCount:=g_Config.nSkeletonCount;
   dwRoyaltySec:=10 * 24 * 60 * 60;
   for I := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do begin
     if g_Config.SkeletonArray[I].nHumLevel = 0 then break;
     if PlayObject.m_Abil.Level >= g_Config.SkeletonArray[I].nHumLevel then begin
       sMonName:=g_Config.SkeletonArray[I].sMonName;
       nExpLevel:=g_Config.SkeletonArray[I].nLevel;
       nCount:=g_Config.SkeletonArray[I].nCount;
     end;
   end;

   if PlayObject.MakeSlave(sMonName,nMakeLevel,nExpLevel,nCount,dwRoyaltySec) <> nil then
     Result:=True;
  end;
end;



function TMagicManager.MagMakeClone(PlayObject: TPlayObject;UserMagic:pTUserMagic):Boolean;
var
  {I: Integer;
  sMonName:String;
  nMakeLevel,nExpLevel:Integer;
  nCount:Integer;
  dwRoyaltySec:LongWord;}
  PlayClone:TPlayCloneObject;
begin
  Result:=False;
  {if not PlayObject.sub_4DD704 then begin
   sMonName:=g_Config.sSkeleton;
   nMakeLevel:=UserMagic.btLevel;
   nExpLevel:=UserMagic.btLevel;
   nCount:=g_Config.nSkeletonCount;
   dwRoyaltySec:=10 * 24 * 60 * 60;
   for I := Low(g_Config.SkeletonArray) to High(g_Config.SkeletonArray) do begin
     if g_Config.SkeletonArray[I].nHumLevel = 0 then break;
     if PlayObject.m_Abil.Level >= g_Config.SkeletonArray[I].nHumLevel then begin
       sMonName:=g_Config.SkeletonArray[I].sMonName;
       nExpLevel:=g_Config.SkeletonArray[I].nLevel;
       nCount:=g_Config.SkeletonArray[I].nCount;
     end;       
   end;}

   PlayClone := TPlayCloneObject.Create(PlayObject);
   Result:=True;
end;


function TMagicManager.MagMakeAngelSlave(PlayObject: TPlayObject;UserMagic:pTUserMagic):Boolean;
var
  I: Integer;
  sMonName:String;
  nMakeLevel,nExpLevel:Integer;
  dwRoyaltySec:LongWord;
begin
  Result:=False;
  if not PlayObject.sub_4DD704 then begin
   sMonName:=g_Config.sAngel;
   nMakeLevel:=UserMagic.btLevel;
   nExpLevel:=UserMagic.btLevel;
   //nCount:=g_Config.nSkeletonCount;
   dwRoyaltySec:=10 * 24 * 60 * 60;

   if PlayObject.MakeSlave(sMonName,nMakeLevel,nExpLevel,1,dwRoyaltySec) <> nil then
     Result:=True;
  end;
end;



function TMagicManager.MagGroupMb(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I              :Integer;
  BaseObjectList :TList;
  BaseObject     :TBaseObject;
  nPower         :Integer;
  StdItem        :pTStdItem;
  nTime          :Integer;
begin
  Result:=False;
  BaseObjectList:=TList.Create;
  nTime:= 5 * UserMagic.btLevel + 1;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir,PlayObject.m_nCurrX,PlayObject.m_nCurrY,UserMagic.btLevel + 2,BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    BaseObject:=TBaseObject(BaseObjectList.Items[I]);
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) and (not g_Config.boGroupMbAttackPlayObject) then Continue;
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget (BaseObject) then begin
      if not BaseObject.m_boUnParalysis and (Random(BaseObject.m_btAntiPoison) = 0) then begin
        if (BaseObject.m_Abil.Level < PlayObject.m_Abil.Level) or (Random(PlayObject.m_Abil.Level - BaseObject.m_Abil.Level) = 0) then begin
          BaseObject.MakePosion(POISON_STONE,nTime,0);
          BaseObject.m_boFastParalysis:=True;
        end;
      end;
    end;
    if (BaseObject.m_btRaceServer >= RC_ANIMAL) then
      Result:=True;
  end;
  BaseObjectList.Free;
end;




function  TMagicManager.KnockBack (PlayObject:TBaseObject;nPushLevel: integer): integer; //00492204
var
   i, nDir, levelgap, push: integer;
   BaseObject: TBaseObject;
   UserMagic:pTUsermagic;
begin
  Result := 0;
  for i:=0 to PlayObject.m_VisibleActors.Count-1 do begin
    BaseObject:= TBaseObject (pTVisibleBaseObject(PlayObject.m_VisibleActors[i]).BaseObject);
    if (abs(PlayObject.m_nCurrX-BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY-BaseObject.m_nCurrY) <= 1) then begin
      if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then begin
        if (PlayObject.m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
          // levelgap := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
          // if (Random(20) < 6 + nPushLevel * 3 + levelgap) then begin
          if Random(20) < ((nPushLevel * 4) + 6) then begin
            if PlayObject.IsProperTarget(BaseObject) then begin
              push := nPushLevel + 2;
              nDir:= GetNextDirection (PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
              BaseObject.CharPushed(nDir, push);
              Inc (Result);
            end;
          end;
        end;
      end;
    end;
  end;
end;




function TMagicManager.FlameField(BaseObject:TBaseObject;nPower,nX,nY:Integer;nRage:Integer): Boolean;
var
  I                :Integer;
  BaseObjectList   :TList;
  TargeTBaseObject :TBaseObject;
begin
  Result         := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir,nX,nY,nRage,BaseObjectList);
  for I := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperTarget(TargeTBaseObject) then begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject,RM_MAGSTRUCK,0,nPower,0,0,'');
      Result:=True;
    end;
  end;
  BaseObjectList.Free;
end;



end.

