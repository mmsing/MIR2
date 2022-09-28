unit grobal2;

interface
uses
  Windows, Classes, strUtils, JSocket;

const
//�汾��
  VERSION_NUMBER = 20020522;
  CLIENT_VERSION_NUMBER = 120040918;
  //�ͻ��˷��͵�����
  CM_POWERBLOCK = 0; //Damian

  MapNameLen    = 16;
  ActorNameLen  = 14;

  DR_UP         =0;
  DR_UPRIGHT    =1;
  DR_RIGHT      =2;
  DR_DOWNRIGHT  =3;
  DR_DOWN       =4;
  DR_DOWNLEFT   =5;
  DR_LEFT       =6;
  DR_UPLEFT     =7;

  U_DRESS       = 0;    //�·�
  U_WEAPON      = 1;    //����
  U_RIGHTHAND   = 2;    //����
  U_NECKLACE    = 3;    //����
  U_HELMET      = 4;    //ͷ��
  U_ARMRINGL    = 5;    //���ֽ�ָ
  U_ARMRINGR    = 6;    //���ֽ�ָ
  U_RINGL       = 7;    //���ָ
  U_RINGR       = 8;    //�ҽ�ָ
  U_BUJUK       = 9;    //�Ż����λ��
  U_BELT        = 10;   //����
  U_BOOTS       = 11;   //Ь��
  U_CHARM       = 12;   //��ʯ

  DEFBLOCKSIZE  = 16;
  BUFFERSIZE    = 10000;

  LOGICALMAPUNIT= 40;

  UNITX         = 48;
  UNITY         = 32;

  HALFX         = 24;
  HALFY         = 16;

  MAXBAGITEM    = 46;  //52; //�����������Ʒ������������������Ҫ���������õ�������ͬ
  HOWMANYMAGICS = 20;
  USERITEMMAX   = 46;
  MaxSkillLevel = 3;
  MAX_STATUS_ATTRIBUTE = 12;

  ITEM_WEAPON           = 0;
  ITEM_ARMOR		= 1;
  ITEM_ACCESSORY	= 2;
  ITEM_ETC		= 3;
  ITEM_GOLD		= 10;

  POISON_DECHEALTH      = 0;  //�ж����� - �̶�
  POISON_DAMAGEARMOR    = 1;  //�ж����� - �춾
  POISON_LOCKSPELL	= 2;
  POISON_DONTMOVE	= 4;
  POISON_STONE		= 5;
  POISON_68             = 68;
  


  STATE_TRANSPARENT	= 8;
  STATE_DEFENCEUP	= 9;
  STATE_MAGDEFENCEUP	= 10;
  STATE_BUBBLEDEFENCEUP	= 11;

  STATE_STONE_MODE	= $00000001;
  STATE_OPENHEATH	= $00000002;  //ü�� ��������

  ET_DIGOUTZOMBI    = 1;   //���� ���İ� ���� ����
  ET_MINE           = 2;   //������ ����Ǿ� ����
  ET_PILESTONES     = 3;   //��������
  ET_HOLYCURTAIN    = 4;   //���
  ET_FIRE           = 5;
  ET_SCULPEICE      = 6;   //�ָ����� ������ ����

  RCC_MERCHANT     = 50;
  RCC_GUARD        = 12;
  RCC_USERHUMAN    = 0;



  CM_QUERYUSERSTATE     = 82;



  CM_QUERYUSERNAME      = 80;  //��ѯ�û�����
  CM_QUERYBAGITEMS      = 81;  //��ѯ��������

  CM_QUERYCHR           = 100;  //��ѯ����
  CM_NEWCHR             = 101;   //������
  CM_DELCHR             = 102;   //ɾ������
  CM_SELCHR             = 103;  //ѡ������
  CM_SELECTSERVER       = 104;  //ѡ�������

  CM_OPENDOOR           = 1002;  //����
  CM_SOFTCLOSE          = 1009;

  CM_DROPITEM           = 1000;  //������Ʒ
  CM_PICKUP             = 1001;  //����
  CM_TAKEONITEM	        = 1003;  //����/����/���� ��Ʒ
  CM_TAKEOFFITEM        = 1004;   //������Ʒ
  CM_1005               = 1005;
  CM_EAT                = 1006;  //����Ʒ
  CM_BUTCH              = 1007;
  CM_MAGICKEYCHANGE	= 1008;     //�ı�ħ������

  CM_CLICKNPC           = 1010;   //���NPC???
  CM_MERCHANTDLGSELECT  = 1011;   // NPC Tag Click ѡ�����˹��ܴ���
  CM_MERCHANTQUERYSELLPRICE = 1012;   //��ѯ���������˵ļ۸�
  CM_USERSELLITEM       = 1013;     //ѡ����Ʒ
  CM_USERBUYITEM        = 1014;     //������Ʒ
  CM_USERGETDETAILITEM  = 1015;      //????????????????????????
  CM_DROPGOLD           = 1016;      //�������
  CM_1017               = 1017;
  CM_LOGINNOTICEOK      = 1018;    //������Ϸ����ȷ����ť
  CM_GROUPMODE          = 1019;    //����ģʽ
  CM_CREATEGROUP        = 1020;    //��������
  CM_ADDGROUPMEMBER     = 1021;    //��ӱ����Ա
  CM_DELGROUPMEMBER     = 1022;    //ɾ�������Ա
  CM_USERREPAIRITEM     = 1023;    //������Ʒ
  CM_MERCHANTQUERYREPAIRCOST = 1024;   //��ѯ����۸�
  CM_DEALTRY            = 1025;    //���׿�ʼ
  CM_DEALADDITEM        = 1026;     //���������Ʒ
  CM_DEALDELITEM        = 1027;     //����ɾ����Ʒ
  CM_DEALCANCEL         = 1028;     //����ȡ��
  CM_DEALCHGGOLD        = 1029;     //���׸ı���
  CM_DEALEND            = 1030;     //�������
  CM_USERSTORAGEITEM    = 1031;     //�û��洢��Ʒ
  CM_USERTAKEBACKSTORAGEITEM = 1032;  //�Ӳֿ�ȡ����Ʒ
  CM_WANTMINIMAP        = 1033;       //��С��ͼ
  CM_USERMAKEDRUGITEM   = 1034;    //������ҩ��Ʒ
  CM_OPENGUILDDLG       = 1035;    //���лᴰ��
  CM_GUILDHOME          = 1036;    //�л���ҳ
  CM_GUILDMEMBERLIST    = 1037;    //�л��Ա�б�
  CM_GUILDADDMEMBER     = 1038;    //����л��Ա
  CM_GUILDDELMEMBER     = 1039;    //ɾ���л��Ա
  CM_GUILDUPDATENOTICE  = 1040;    //�����л���Ϣ
  CM_GUILDUPDATERANKINFO= 1041;    //�����л�ȼ�/������Ϣ????
  CM_1042               = 1042;
  CM_ADJUST_BONUS       = 1043;
  CM_GUILDALLY          = 1044;    //�л����
  CM_GUILDBREAKALLY     = 1045;    //�л����
  CM_SPEEDHACKUSER      = 10430; //??

  CM_PROTOCOL           = 2000;
  CM_IDPASSWORD         = 2001;    //�����û���/����
  CM_ADDNEWUSER         = 2002;
  CM_CHANGEPASSWORD     = 2003;     //��������
  CM_UPDATEUSER         = 2004;

  CM_THROW              = 3005;   //Ͷ��
  CM_TURN               = 3010;    //ת
  CM_WALK               = 3011;    //��·
  CM_SITDOWN            = 3012;    //��
  CM_RUN                = 3013;    //��
  CM_HIT                = 3014;    //��
  CM_HEAVYHIT           = 3015;
  CM_BIGHIT             = 3016;
  CM_SPELL              = 3017;    //ħ��
  CM_POWERHIT           = 3018;    //��ɱ
  CM_LONGHIT            = 3019;    //��ɱ

  CM_WIDEHIT            = 3024;  //����
  CM_FIREHIT            = 3025;

  CM_SAY                = 3030;  //˵��


  SM_41                 = 4;
  SM_THROW              = 5;
  SM_RUSH               = 6;
  SM_RUSHKUNG           = 7;//
  SM_FIREHIT            = 8;    //�һ�
  SM_BACKSTEP           = 9;   //��·���ɹ�????
  SM_TURN               = 10;   //ת������
  SM_WALK               = 11;   //��
  SM_SITDOWN            = 12;   //��
  SM_RUN                = 13;    //��
  SM_HIT                = 14;   //��
  SM_HEAVYHIT           = 15;//
  SM_BIGHIT             = 16;//
  SM_SPELL              = 17;   //ʹ��ħ��
  SM_POWERHIT           = 18;   //��ɱ
  SM_LONGHIT            = 19;   //��ɱ
  SM_DIGUP              = 20;   //��ȡ
  SM_DIGDOWN            = 21;   //����?????????
  SM_FLYAXE             = 22;    //???????????????
  SM_LIGHTING           = 23;   //����?????????????
  SM_WIDEHIT            = 24;   //����
  SM_CRSHIT             = 25;
  SM_TWINHIT            = 26;
  
  

  SM_ALIVE              = 27;//
  SM_MOVEFAIL           = 28;//
  SM_HIDE               = 29;//
  SM_DISAPPEAR          = 30;  //��Ʒ��ʧ??????
  SM_STRUCK             = 31;   //����
  SM_DEATH              = 32;
  SM_SKELETON           = 33;    // SM_DEATH ʬ��??ʬ��
  SM_NOWDEATH           = 34;

  SM_HEAR               = 40;   //����˵��
  SM_FEATURECHANGED     = 41;    //��ò??����??�ı�???????????
  SM_USERNAME           = 42;    //�û���??�����???????
  SM_43                 = 43;
  SM_WINEXP             = 44;    //ʤ��ָ��???ɱ�ֻ�õľ���ֵ???????????????
  SM_LEVELUP            = 45;    //�ȼ�����
  SM_DAYCHANGING        = 46;    //�������ڸı�????

  SM_LOGON              = 50;     //��¼ע��
  SM_NEWMAP             = 51;     //�µ�ͼ
  SM_ABILITY            = 52;     //����
  SM_HEALTHSPELLCHANGED = 53;     //��Ѫ��Ѫ �ı�
  SM_MAPDESCRIPTION     = 54;     //��ͼ����,��ͼ����
  SM_SPELL2             = 117;

  SM_SYSMESSAGE         = 100;    //ϵͳ��Ϣ
  SM_GROUPMESSAGE       = 101;     //�����Ϣ
  SM_CRY                = 102;     //��
  SM_WHISPER            = 103;     //˽��
  SM_GUILDMESSAGE       = 104;      //�л���Ϣ

  SM_ADDITEM            = 200;      //�����Ʒ
  SM_BAGITEMS           = 201;      //������Ʒ
  SM_DELITEM            = 202;      //ɾ����Ʒ????
  SM_UPDATEITEM         = 203;
  SM_ADDMAGIC           = 210;     //���ħ��
  SM_SENDMYMAGIC        = 211;      //�������ħ��
  SM_DELMAGIC           = 212;

  SM_CERTIFICATION_SUCCESS = 500;
  SM_CERTIFICATION_FAIL = 501;
  SM_ID_NOTFOUND        = 502;    //IDδ����,�û�������
  SM_PASSWD_FAIL        = 503;    //�������
  SM_NEWID_SUCCESS      = 504;    //������ID�ɹ�
  SM_NEWID_FAIL         = 505;    //��IDʧ��
  SM_CHGPASSWD_SUCCESS  = 506;    //��������ɹ�
  SM_CHGPASSWD_FAIL     = 507;    //��������ʧ��
  SM_QUERYCHR           = 520;     //��ѯ����(2�˴���)
  SM_NEWCHR_SUCCESS     = 521;     //��������ɹ�
  SM_NEWCHR_FAIL        = 522;     //��������ʧ��
  SM_DELCHR_SUCCESS     = 523;     //ɾ������ɹ�
  SM_DELCHR_FAIL        = 524;     //ɾ������ʧ��
  SM_STARTPLAY          = 525;      //��ʼ��Ϸ
  SM_STARTFAIL          = 526;       //������Ϸʧ��
  SM_QUERYCHR_FAIL      = 527;       //��ѯ����ʧ��
  SM_OUTOFCONNECTION    = 528;      //�����ѶϿ�
  SM_PASSOK_SELECTSERVER= 529;      //�û���/���� ��֤ͨ��
  SM_SELECTSERVER_OK    = 530;      //������ѡ��ɹ�
  SM_NEEDUPDATE_ACCOUNT = 531;      //��Ҫ����_˵��????
  SM_UPDATEID_SUCCESS   = 532;      //����ID�ɹ�?????
  SM_UPDATEID_FAIL      = 533;      //����IDʧ��???????



  SM_DROPITEM_SUCCESS   = 600;    //������Ʒ�ɹ�
  SM_DROPITEM_FAIL      = 601;    //������Ʒʧ��

  SM_ITEMSHOW           = 610;    //��ʾ��Ʒ
  SM_ITEMHIDE           = 611;    //���ϵ���Ʒ��ʧ

  SM_OPENDOOR_OK        = 612;    //���ųɹ�
  SM_OPENDOOR_LOCK      = 613;
  SM_CLOSEDOOR          = 614;

  SM_TAKEON_OK          = 615;    //���ϴ��ϳɹ�
  SM_TAKEON_FAIL        = 616;     //��ʧ��
  SM_TAKEOFF_OK         = 619;     //���³ɹ�
  SM_TAKEOFF_FAIL       = 620;     //����ʧ��
  SM_SENDUSEITEMS       = 621;     //���ϴ�����Ʒ
  SM_WEIGHTCHANGED      = 622;     //���������ı�
  SM_CLEAROBJECTS       = 633;     //�������??????????
  SM_CHANGEMAP          = 634;     //��ͼ�ı�
  SM_EAT_OK             = 635;     //����Ʒ�ɹ�
  SM_EAT_FAIL           = 636;     //����Ʒʧ��
  SM_BUTCH              = 637;
  SM_MAGICFIRE          = 638;     //ħ����?????????????
  SM_MAGICFIRE_FAIL     = 639;     //ħ����ʧ��?????????????
  SM_MAGIC_LVEXP        = 640;      //ħ���ȼ�
  SM_DURACHANGE         = 642;
  SM_MERCHANTSAY        = 643;      //����˵��
  SM_MERCHANTDLGCLOSE   = 644;      //���˴��ڹر�
  SM_SENDGOODSLIST      = 645;      //�����б�
  SM_SENDUSERSELL       = 646;      //�û�����
  SM_SENDBUYPRICE       = 647;      //����۸�
  SM_USERSELLITEM_OK    = 648;      //�û�������Ʒ�ɹ�
  SM_USERSELLITEM_FAIL  = 649;      //�û�������Ʒʧ��
  SM_BUYITEM_SUCCESS    = 650;      //�û�������Ʒ�ɹ�
  SM_BUYITEM_FAIL       = 651;      //�û�����ʧ��
  SM_SENDDETAILGOODSLIST= 652;     //��ϸ�����б�
  SM_GOLDCHANGED        = 653;     //��Ҹı�
  SM_CHANGELIGHT        = 654;      //�ı�����????
  SM_LAMPCHANGEDURA     = 655;
  SM_CHANGENAMECOLOR    = 656;      //�ı䱦����ɫ?????
  SM_CHARSTATUSCHANGED  = 657;
  SM_SENDNOTICE         = 658;      //������Ϸ��������
  SM_GROUPMODECHANGED   = 659;
  SM_CREATEGROUP_OK     = 660;    //��������ɹ�
  SM_CREATEGROUP_FAIL   = 661;    //��������ʧ��
  SM_GROUPADDMEM_OK     = 662;
  SM_GROUPDELMEM_OK     = 663;
  SM_GROUPADDMEM_FAIL   = 664;
  SM_GROUPDELMEM_FAIL   = 665;
  SM_GROUPCANCEL        = 666;    //����ȡ��??????????
  SM_GROUPMEMBERS       = 667;     //�����Ա
  SM_SENDUSERREPAIR     = 668;
  SM_USERREPAIRITEM_OK  = 669;
  SM_USERREPAIRITEM_FAIL= 670;
  SM_SENDREPAIRCOST     = 671;
  SM_DEALMENU           = 673;
  SM_DEALTRY_FAIL       = 674;
  SM_DEALADDITEM_OK     = 675;
  SM_DEALADDITEM_FAIL   = 676;
  SM_DEALDELITEM_OK     = 677;
  SM_DEALDELITEM_FAIL   = 678;
  SM_DEALCANCEL         = 681;
  SM_DEALREMOTEADDITEM  = 682;
  SM_DEALREMOTEDELITEM  = 683;
  SM_DEALCHGGOLD_OK     = 684;
  SM_DEALCHGGOLD_FAIL   = 685;
  SM_DEALREMOTECHGGOLD  = 686;
  SM_DEALSUCCESS        = 687;
  SM_SENDUSERSTORAGEITEM= 700;
  SM_STORAGE_OK         = 701;
  SM_STORAGE_FULL       = 702;
  SM_STORAGE_FAIL       = 703;
  SM_SAVEITEMLIST       = 704;
  SM_TAKEBACKSTORAGEITEM_OK = 705;
  SM_TAKEBACKSTORAGEITEM_FAIL = 706;
  SM_TAKEBACKSTORAGEITEM_FULLBAG = 707;

  SM_AREASTATE          = 766;    //����״̬
  SM_MYSTATUS           = 708;

  SM_DELITEMS           = 709;    //ɾ����Ʒ??????
  SM_READMINIMAP_OK     = 710;
  SM_READMINIMAP_FAIL   = 711;
  SM_SENDUSERMAKEDRUGITEMLIST = 712;
  SM_MAKEDRUG_SUCCESS   = 713;
  SM_MAKEDRUG_FAIL      = 714;

  SM_716                = 716;

  

  SM_CHANGEGUILDNAME    = 750;     //�ı��л�����
  SM_SENDUSERSTATE      = 751;
  SM_SUBABILITY         = 752;
  SM_OPENGUILDDLG       = 753;     //���лᴰ��
  SM_OPENGUILDDLG_FAIL  = 754;    //���лᴰ��ʧ��
  SM_SENDGUILDMEMBERLIST= 756;    //�л��Ա�б�
  SM_GUILDADDMEMBER_OK  = 757;     //�л���ӳ�Ա�ɹ�
  SM_GUILDADDMEMBER_FAIL= 758;     //�л���ӳ�Աʧ��
  SM_GUILDDELMEMBER_OK  = 759;    //�л�ɾ����Ա�ɹ�
  SM_GUILDDELMEMBER_FAIL= 760;     //�л�ɾ����Աʧ��
  SM_GUILDRANKUPDATE_FAIL= 761;    //�л�ȼ�/���и���ʧ��
  SM_BUILDGUILD_OK      = 762;     //�����л�ɹ�
  SM_BUILDGUILD_FAIL    = 763;      //�����л�ʧ��
  SM_DONATE_OK          = 764;
  SM_DONATE_FAIL        = 765;

  SM_MENU_OK            = 767;//?
  SM_GUILDMAKEALLY_OK   = 768;    //�����л�ͬ�˳ɹ�
  SM_GUILDMAKEALLY_FAIL = 769;    //�����л�ͬ��ʧ��
  SM_GUILDBREAKALLY_OK  = 770;     //ɾ���л�ͬ�˳ɹ�
  SM_GUILDBREAKALLY_FAIL= 771;     //ɾ���л�ͬ��ʧ��
  SM_DLGMSG             = 772;     //������Ϣ????��������???????
  SM_SPACEMOVE_HIDE     = 800;
  SM_SPACEMOVE_SHOW     = 801;
  SM_RECONNECT          = 802;//
  SM_GHOST              = 803;
  SM_SHOWEVENT          = 804;    //��ʾ�¼�????????
  SM_HIDEEVENT          = 805;    //�����¼�?????????
  SM_SPACEMOVE_HIDE2    = 806;
  SM_SPACEMOVE_SHOW2    = 807;
  SM_TIMECHECK_MSG      = 810;
  SM_ADJUST_BONUS       = 811; //?

  SM_OPENHEALTH         = 1100;      //�򿪽���????????
  SM_CLOSEHEALTH        = 1101;      //�رս���???????
  SM_CHANGEFACE         = 1104;
  SM_BREAKWEAPON        = 1102;
  SM_INSTANCEHEALGUAGE  = 1103; //??
  SM_VERSION_FAIL       = 1106;

  SM_ITEMUPDATE         = 1500;
  SM_MONSTERSAY         = 1501;   //����˵��




  SM_EXCHGTAKEON_OK=65023;
  SM_EXCHGTAKEON_FAIL=65024;


  SM_TEST=65037;
  SM_ACTION_MIN = 65070;
  SM_ACTION_MAX = 65071;
  SM_ACTION2_MIN=65072;
  SM_ACTION2_MAX =65073;

  CM_SERVERREGINFO = 65074;

  //-------------------------------------

  CM_GETGAMELIST = 5001;
  SM_SENDGAMELIST = 5002;
  CM_GETBACKPASSWORD = 5003;
  SM_GETBACKPASSWD_SUCCESS = 5005;
  SM_GETBACKPASSWD_FAIL    = 5006;
  SM_SERVERCONFIG = 5007;
  SM_GAMEGOLDNAME = 5008;
  SM_PASSWORD     = 5009;
  SM_HORSERUN     = 5010;
  
  UNKNOWMSG           = 199;
  //���¼�����ȷ
  SS_OPENSESSION      = 100;
  SS_CLOSESESSION     = 101;
  SS_KEEPALIVE        = 104;
  SS_KICKUSER         = 111;
  SS_SERVERLOAD       = 113;

  SS_200              = 200;
  SS_201              = 201;
  SS_202              = 202;
  SS_203              = 203;
  SS_204              = 204;
  SS_205              = 205;
  SS_206              = 206;
  SS_207              = 207;
  SS_208              = 208;
  SS_209              = 209;
  SS_210              = 210;
  SS_211              = 211;
  SS_212              = 212;
  SS_213              = 213;
  SS_214              = 214;
  SS_WHISPER          = 299;//?????


  //����ȷ
  //Damian
  SS_SERVERINFO       = 103;
  SS_SOFTOUTSESSION   = 102;
  //SS_SERVERINFO       = 30001;
  //SS_SOFTOUTSESSION   = 30002;
  SS_LOGINCOST        = 30002;

  //Damian
  DBR_FAIL            = 2000;
  DB_LOADHUMANRCD     = 100;
  DB_SAVEHUMANRCD     = 101;
  DB_SAVEHUMANRCDEX   = 102;//?
  DBR_LOADHUMANRCD    = 1100;
  DBR_SAVEHUMANRCD    = 1102; //?
  {DBR_FAIL            = 31001;
  DB_LOADHUMANRCD     = 31002;
  DB_SAVEHUMANRCD     = 31003;
  DB_SAVEHUMANRCDEX   = 31004;
  DBR_LOADHUMANRCD    = 31005;
  DBR_SAVEHUMANRCD    = 31006;}


  SG_FORMHANDLE       = 32001;
  SG_STARTNOW         = 32002;
  SG_STARTOK          = 32003;
  SG_CHECKCODEADDR    = 32004;
  SG_USERACCOUNT      = 32005;
  SG_USERACCOUNTCHANGESTATUS = 32006;
  SG_USERACCOUNTNOTFOUND     = 32007;

  GS_QUIT             = 32101;
  GS_USERACCOUNT      = 32102;
  GS_CHANGEACCOUNTINFO = 32103;

type
//-----------------------------------------
  pTDefaultMessage=^TDefaultMessage;
  TDefaultMessage = record
    Recog    :Integer;
    Ident    :Word;
    Param    :Word;
    Tag      :Word;
    Series   :Word;
  end;

  TChrMsg =record
    Ident    :Integer;
    X        :Integer;
    Y        :Integer;
    Dir      :Integer;
    State    :Integer;
    feature  :Integer;
    saying   :String;
    Sound    :Integer;
  end;
  PTChrMsg = ^TChrMsg;

  pTOStdItem=^TOStdItem;
  TOStdItem =record      //OK
    Name         :String[14];
    StdMode      :Byte;   //��Ʒ����(<=3ʱ�����ڿ��������ʾ)
    Shape        :Byte;    //����
    Weight       :Byte;    //����
    AniCount     :Byte;
    Source       :Byte;
    Reserved     :Byte;
    NeedIdentify :Byte;     //��Ҫ����
    Looks        :Word;
    DuraMax      :Word;     //���־�
    AC           :Word;      //��
    MAC          :Word;      //ħ��
    DC           :Word;      //����
    MC           :Word;      //ħ
    SC           :Word;      //��
    Need         :Byte;
    NeedLevel    :Byte;     //��Ҫ�ȼ�
    Price        :UINT;      //�۸�
  end;

  pTStdItem=^TStdItem;
  TStdItem=packed record                //60 bytes
     Name               :String[20];    //15 ��Ʒ����
     StdMode            :Byte;          //1  ��Ʒ����
     Shape              :Byte;          //1  ������
     Weight             :Byte;          //1  ����
     AniCount           :Byte;          //1
     Source             :shortint;      //1  ������ʥֵ
     reserved           :byte;          //1
     NeedIdentify       :byte;          //1  ������������
     Looks              :Word;          //2  ��ۣ���Items.WIL�е�ͼƬ����
     DuraMax            :DWord;         //4  �־���
     AC                 :Dword;         //4  ���� ��λ������׼ȷ ��λ����������
     MAC                :Dword;         //4  ��ħ ��λ�������ٶ� ��λ����������
     DC                 :Dword;         //4  ����
     MC                 :Dword;         //4  ħ��
     SC                 :DWord;         //4 ����
     Need               :DWord;         //4  ����Ҫ�� 0���ȼ� 1�������� 2��ħ���� 3��������
     NeedLevel          :DWord;         //4  NeedҪ����ֵ
     Price              :UINT;       //4  �۸�
  end;

  PTClientItem =^TClientItem;
  TClientItem = record  //OK
    S         :TStdItem;
    MakeIndex :Integer;
    Dura      :Word;
    DuraMax   :Word;
  end;

  TOClientItem=record
    S         :TOStdItem;
    MakeIndex :Integer;
    Dura      :Word;
    DuraMax   :Word;
  end;

  TUserStateInfo =record        //OK
    Feature       :Integer;
    UserName      :String[19];
    GuildName     :String[14];
    GuildRankName :String[14];
    NameColor     :Word;
    UseItems      :array [0..12] of TClientItem;
  end;
  TUserCharacterInfo =record
    Name:String[19];
    Job:Byte;
    Hair:Byte;
    Level:Byte;
    Sex:Byte;
  end;
  TUserEntry =record
    sAccount      :String[10];
    sPassword     :String[10];
    sUserName     :String[20];
    sSSNo         :String[14];
    sPhone        :String[14];
    sQuiz         :String[20];
    sAnswer       :String[12];
    sEMail        :String[40];
  end;
  TUserEntryAdd =record
    sQuiz2        :String[20];
    sAnswer2      :String[12];
    sBirthDay     :String[10];
    sMobilePhone  :String[15];
    sMemo         :String[40];
    sMemo2        :String[40];
  end;

  TOUserStateInfo = record
    Feature       :Integer;
    UserName      :String[19];
    GuildName     :String[14];
    GuildRankName :String[14];
    NameColor     :Word;
    UseItems      :array [0..8] of TOClientItem;
  end;

  TDropItem =record
    X:Integer;
    Y:Integer;
    Id:integer;
    Looks:integer;
    Name:String;
    FlashTime:Dword;
    FlashStepTime:Dword;
    FlashStep:Integer;
    BoFlash:Boolean;
  end;
  PTDropItem = ^TDropItem;

  pTMagic=^TMagic;
  TMagic =record        //ħ��
    wMagicID:Word;     //���
    sMagicName:String[12];   //���� 12
    btEffectType:Byte;
    btEffect:Byte;     //Ч��
    wSpell:Word;     //ħ��
    wPower:Word;
    TrainLevel:Array[0..3] of Byte;    //������Ҫ�ĵȼ�
    MaxTrain:Array[0..3] of Integer;     //����
    btTrainLv:Byte;
    btJob:Byte;
    dwDelayTime:Integer;
    btDefSpell:Byte;
    btDefPower:Byte;
    wMaxPower:Word;
    btDefMaxPower:Byte;
    sDescr:String[15];
  end;
  TClientMagic = record //84
    Key    :Char;
    Level  :Byte;
    CurTrain:Integer;
    Def    :TMagic;
  end;
  PTClientMagic = ^TClientMagic;


  pTNakedAbility=^TNakedAbility;
  TNakedAbility =record
    DC    :Word;
    MC    :Word;
    SC    :Word;
    AC    :Word;
    MAC   :Word;
    HP    :Word;
    MP    :Word;
    Hit   :Byte;
    Speed :integer;
    X2    :byte;
  end;

  TOAbility =record  //OK    //Size 40
    Level         :Word;  //0x198
    AC            :Word;  //0x19A
    MAC           :Word;  //0x19C
    DC            :Word;  //0x19E
    MC            :Word;  //0x1A0
    SC            :Word;  //0x1A2
    HP            :Word;  //0x1A4
    MP            :Word;  //0x1A6
    MaxHP         :Word;  //0x1A8
    MaxMP         :Word;  //0x1AA
    dw1AC         :Dword;  //0x1AC
    Exp           :Dword;  //0x1B0
    MaxExp        :Dword;  //0x1B4
    Weight        :Word;  //0x1B8
    MaxWeight     :Word;  //0x1BA
    WearWeight    :Byte;  //0x1BC
    MaxWearWeight :Byte;  //0x1BD
    HandWeight    :Byte;  //0x1BE
    MaxHandWeight :Byte;  //0x1BF
  end;
        //for db

    //end

  TShortMessage = record
    Ident    :Word;
    wMsg     :Word;
  end;

  TMessageBodyW = record
    Param1:Word;
    Param2:Word;
    Tag1:Word;
    Tag2:Word;
  end;

  TMessageBodyWL = record       //16  0x10
    lParam1    :Integer;
    lParam2    :Integer;
    lTag1      :Integer;
    lTag2      :Integer;
  end;

  TCharDesc =record
    Feature  :Integer;
    Status   :Integer;
  end;
  TClientGoods = record
    Name    :String;
    SubMenu :Integer;
    Price   :Integer;
    Stock   :Integer;
    Grade   :Integer;
  end;
  pTClientGoods=^TClientGoods;

  

  //֧��4�����������ֵ
  pTAbility=^TAbility;
  TAbility= packed record         //50Bytes
     Level              :Word;    //1  2  �ȼ�
     AC                 :DWord;   //3  6
     MAC                :DWord;   //7  10
     DC                 :DWord;   //11 14
     MC                 :DWord;   //15 18
     SC                 :DWord;   //19 22
     HP                 :Word;    //23 24 ����ֵ
     MP                 :Word;    //25 26 ħ��ֵ
     MaxHP              :Word;    //27 28
     MaxMP              :Word;    //29 30
     Exp                :DWord;   //31 34 ��ǰ����
     MaxExp             :DWord;   //35 38 �����
     Weight             :Word;    //39 40 ������
     MaxWeight          :Word;    //41 42 �����������
     WearWeight         :Word;    //43 44   ��ǰ����
     MaxWearWeight      :Word;    //45 46   �����
     HandWeight         :Word;    //47 48    ����
     MaxHandWeight      :Word;    //49 50   �������
  end;

  //---------------------------------------------

type
  TProgamType=(tDBServer,tLoginSrv,tLogServer,tM2Server,tLoginGate,
    tLoginGate1,tSelGate,tSelGate1,tRunGate,tRunGate1,tRunGate2,
    tRunGate3,tRunGate4,tRunGate5,tRunGate6,tRunGate7);

  //�����ɫ��Ϣ��¼ͷ
  TRecordHeader = packed record
     sAccount:String[16];
     sName:String[20];
     nSelectID:integer;
     dCreateDate:TDateTime;
     boDeleted:boolean;
     UpdateDate:TDateTime;
     CreateDate:TDateTime;
  end;

  //�ʺ�--��ɫ��Ϣ��¼
  THumInfo = record
     boDeleted:Boolean;
     boSelected:Boolean;
     sAccount:String[10];
     dModDate:TDateTime;
     sChrName:String[20];
     btCount:Byte;
     Header:TRecordHeader;
  end;

  pTUserItem=^TUserItem;
  TUserItem=record                         //=24
    MakeIndex       :Integer;              //+4
    wIndex          :Word;                 //+2
    Dura            :word;                 //+2
    DuraMax         :Word;                 //+2
    btValue         :Array[0..13] of byte; //+14
    //sPrefix     :String[10];
  end;

  THumanUseItems=array[0..12] of TUserItem;
  THumItems=array[0..12] of TUserItem;    //����װ����Ʒ����(13��)

  pTHumItems=^THumItems;
  pTBagItems=^TBagItems;
  //TBagItems=array[0..54-12] of  TUserItem;  //0..42 (43��)
  TBagItems=array[0..45] of  TUserItem;       //0..45 (46��)

  pTStorageItems=^TStorageItems;
  TStorageItems=array[0..49] of TUserItem;

  pTUserMagic=^TUserMagic;
  TUserMagic=record
    MagicInfo:pTMagic;
    btLevel:byte;
    wMagIdx:word;
    nTranPoint:integer;
    btKey:byte;
  end;

  pTHumMagic=^THumMagic;
  THumMagic=Array[0..HOWMANYMAGICS-1] of TUserMagic;

  pTHumMagicInfo=^THumMagicInfo;
  THumMagicInfo=TUserMagic;

  TStatusTime=array [0..MAX_STATUS_ATTRIBUTE - 1] of Word;

  TQuestUnit=array[0..127] of Byte;

  TQuestFlag=array[0..127] of Byte;


  //Correct structure..
  {

  unknown: array[0..3] of byte; //δ֪
    LastTime: TDateTime; //����½ʱ��
    szCharName: string[15]; //��ɫ����
    szCharName1: string[14]; //��ɫ����1
    szMapName: string[16]; //���ǵ�ͼ
    nCX:     word;     //���ǵ�ͼx����
    nCY:     word;     //���ǵ�ͼy����
    nDirection: byte;  // ����
    szHair:  byte;     //ͷ��
    Sex:     byte;     //�Ա�
    btJob:   byte;     //ְҵ
    dwGold:  longword; //��Ǯ

    szLevel: byte;     //�ȼ�
    unknown1: byte;    //����
    AC:      word;
    MAC:     word;
    MinAttack: byte;   // ��С������
    MaxAttack: byte;   // ��󹥻���
    MinMagic: byte;    // ��Сħ��
    MaxMagic: byte;    // ���ħ��
    MinDao:  byte;     // ��С����
    MaxDao:  byte;     // ������
    HP:      word;     // ����ֵ
    MP:      word;     // ħ��ֵ
    MaxHP:   word;     // �������ֵ
    NowMaxMagic: word; // ���ħ��ֵ
    unknown2: array[0..3] of byte; // �����
    nExp:    longword; // ����ֵ
    UpExp:   longword; // �������辭��ֵ
    unknown3: array[0..31] of byte; // �����



    ReTurnMap: string[17];
    ReTurnX: word;
    ReTurnY: word;


    Neck:    string[85]; // ����
    PK:      word;
    unknown4: array[0..8] of byte; // �����
    Id:      string[10];
    unknown5: array[0..90] of byte; //δ֪
    wife:    string[14];
    unkonwn6: word;
    divorce: byte;
    unknown7: byte;
    DivorecCode: byte;

    Unknown8: array[0..106] of byte;
    szTakeItem: array[0..54] of TUSERITEM;
    Magic12: array[0..19] of TMagic;
    KeepGoods: array[0..49] of TUSERITEM;
    }
    
  pTHumData=^THumData;
  THumData = packed record       //3164
    sChrName        :String[ActorNameLen];
    sCurMap         :String[MapNameLen];
    wCurX           :Word;
    wCurY           :Word;
    btDir           :Byte;
    btHair          :Byte;
    btSex           :Byte;
    btJob           :Byte;
    nGold           :Integer;

    Abil            :TAbility;         //+40
    wStatusTimeArr  :TStatusTime;
    sHomeMap        :String[MapNameLen];
    wHomeX          :Word;
    wHomeY          :Word;
    BonusAbil       :TNakedAbility;     //+20
    nBonusPoint     :Integer;
    btCreditPoint   :Byte;            //����
    btReLevel       :Byte;

    // ȡ����� ��ʦͽϵͳ���������
    // ����1.50û�н���ʦͽϵͳ�� 1.70����ֽ���ʦͽϵͳ
    // sMasterName     :String[ActorNameLen];
    // boMaster        :Boolean;
    // sDearName       :String[ActorNameLen];
    // btMarryCount    :Byte; // ������

    sStoragePwd     :String[10];

    nGameGold       :Integer;
    nGamePoint      :Integer;
    nPayMentPoint   :Integer;
    nPKPoint        :Integer;

    btAllowGroup    :Byte;
    btF9            :Byte;
    btAttatckMode   :Byte;
    btIncHealth     :Byte;
    btIncSpell      :Byte;
    btIncHealing    :Byte;
    btFightZoneDieCount:Byte;
    btEE            :Byte;
    btEF            :Byte;

    sAccount        :String[16];
    boLockLogon     :Boolean;

    wContribution   :Word;
    nHungerStatus   :Integer;
    boAllowGuildReCall:Boolean;
    wGroupRcallTime :Word;
    dBodyLuck       :TDateTime;
    boAllowGroupReCall:Boolean;
    QuestUnitOpen   :TQuestUnit;
    QuestUnit       :TQuestUnit;
    QuestFlag       :TQuestFlag;

//    btMarryCount    :Byte;       //�Ƶ�ǰ�棬һ��ɾ�� 2022-6-14

    HumItems        :THumItems;
    BagItems        :TBagItems;
    Magic           :THumMagic;
    StorageItems    :TStorageItems;
  end;

  THumDataInfo= packed record
    Header:TRecordHeader;
    Data:THumData;
  end;

// BUG: ��MudUtil��д��Ľṹͬ�������ֶδ�λ����ɾ���˶���,����MudUtil::GetChrList�������ݴ���
// lzx2022 - Modified by Davy 2022-6-4
//  pTQuickID=^TQuickID;
//  TQuickID=record
//    nSelectID:integer;
//    sAccount:String[16];
//    nIndex:integer;
//    sChrName:String[20];
//  end;

  pTGlobaSessionInfo=^TGlobaSessionInfo;
  TGlobaSessionInfo=record
     sAccount:String[16];
     nSessionID:integer;
     boLoadRcd:Boolean;
     boStartPlay:Boolean;
     sIPaddr:String[15];
     n24:integer;
     dwAddTick:DWord;
     dAddDate:TDateTime;
  end;

  TCheckCode = packed record
     dwThread0:DWord;
     sThread0:String;
  end;

  TAccountDBRecord = record
     Header:TRecordHeader;
     nErrorCount:integer;
     dwActionTick:DWord;
     UserEntry:TUserEntry;
     UserEntryAdd:TUserEntryAdd;
  end;

  pTConnInfo=^TConnInfo;
  TConnInfo=record

  end;

  pTQueryChr=^TQueryChr;
  TQueryChr=packed record
    btClass:Byte;
    btHair:Byte;
    btGender:Byte;
    btLevel:Byte;
    sName:String[19];
  end;

Const
  //Damian
  RUNGATECODE = $AA55AA55;

  GM_OPEN             = 1;
  GM_CLOSE            = 2;
  GM_CHECKSERVER      = 3;// Send check signal to Server
  GM_CHECKCLIENT      = 4;// Send check signal to Client
  GM_DATA             = 5;
  GM_SERVERUSERINDEX  = 6;
  GM_RECEIVE_OK       = 7;
  GM_TEST             = 20;

  {RUNGATECODE = 1;

  GM_CHECKCLIENT = 7001;
  GM_DATA        = 7002;
  GM_OPEN        = 7003;
  GM_CLOSE       = 7004;
  GM_CHECKSERVER = 7005;
  GM_SERVERUSERINDEX = 7006;
  GM_RECEIVE_OK  = 7007;
  GM_TEST        = 7008;}

type
  pTMsgHeader=^TMsgHeader;
  TMsgHeader = record
    dwCode:DWord;
    nSocket:integer;
    wGSocketIdx:word;
    wIdent:word;
    wUserListIndex:word;
    nLength:integer;
  end;

//M2Server

Const

  GROUPMAX        = 11;

  CM_42HIT        = 42;

  CM_PASSWORD     = 2001;
  CM_CHGPASSWORD  = 2002;
  CM_SETPASSWORD  = 2004;


  CM_HORSERUN     = 3035;     //------------δ֪��Ϣ��
  CM_CRSHIT       = 3036;     //------------δ֪��Ϣ��
  CM_3037         = 3037;
  CM_TWINHIT      = 3038;
  CM_QUERYUSERSET = 3040;

  //Damian
//ȡ���Ĳ�������ָ������  lzx2022 - delete by Davy 2022-6-12
//  SM_PLAYDICE    = 8001;

  SM_PASSWORDSTATUS = 8002;
  SM_NEEDPASSWORD = 8003; 
  SM_GETREGINFO = 8004;

  DATA_BUFSIZE        = 1024;

  RUNGATEMAX          = 8;

  //MAX_STATUS_ATTRIBUTE = 13;
  MAXMAGIC             = 54;

  PN_GETRGB            = 'GetRGB';
  PN_GAMEDATALOG       = 'GameDataLog';
  PN_SENDBROADCASTMSG  = 'SendBroadcastMsg';

  sSTRING_GOLDNAME     = 'Gold';
  MAXLEVEL             = 500;
  SLAVEMAXLEVEL        = 50;

  LOG_GAMEGOLD         = 1;
  LOG_GAMEPOINT        = 2;

  //RC_ANIMAL            = 50;
  //RC_PEACENPC          = 15;
  //RC_MONSTER           = 80;
  //RC_PLAYOBJECT        = 1;
  //RC_NPC               = 10;
  //RC_GUARD             = 12;
  //RC_ARCHERGUARD       = 52;

  RC_PLAYOBJECT  = 0;
  RC_GUARD       = 11;
  RC_PEACENPC    = 15;
  RC_ANIMAL      = 50;
  RC_MONSTER     = 80;
  RC_NPC         = 10;
  RC_ARCHERGUARD = 112;


  RM_TURN              = 10001;
  RM_WALK              = 10002;
  RM_HORSERUN          = 50003;
  RM_RUN               = 10003;
  RM_HIT               = 10004;
  RM_BIGHIT            = 10006;
  RM_HEAVYHIT          = 10007;
  RM_SPELL             = 10008;
  RM_SPELL2            = 10009;
  RM_MOVEFAIL          = 10010;
  RM_LONGHIT           = 10011;
  RM_WIDEHIT           = 10012;
  RM_FIREHIT           = 10014;
  RM_CRSHIT            = 10015;
  RM_DEATH             = 10021;
  RM_SKELETON          = 10024;

  RM_LOGON             = 10050;
  RM_ABILITY           = 10051;
  RM_HEALTHSPELLCHANGED= 10052;
  RM_DAYCHANGING       = 10053;

  RM_10101             = 10101;
  RM_WEIGHTCHANGED     = 10115;
  RM_FEATURECHANGED    = 10116;
  RM_BUTCH             = 10119;
  RM_MAGICFIRE         = 10120;
  RM_MAGICFIREFAIL     = 10121;
  RM_SENDMYMAGIC       = 10122;

  RM_MAGIC_LVEXP       = 10123;
  RM_DURACHANGE        = 10125;
  RM_MERCHANTDLGCLOSE  = 10127;
  RM_SENDGOODSLIST     = 10128;
  RM_SENDUSERSELL      = 10129;
  RM_SENDBUYPRICE      = 10130;
  RM_USERSELLITEM_OK   = 10131;
  RM_USERSELLITEM_FAIL = 10132;
  RM_BUYITEM_SUCCESS   = 10133;
  RM_BUYITEM_FAIL      = 10134;
  RM_SENDDETAILGOODSLIST=10135;
  RM_GOLDCHANGED       = 10136;
  RM_CHANGELIGHT       = 10137;
  RM_LAMPCHANGEDURA    = 10138;
  RM_CHARSTATUSCHANGED = 10139;
  RM_GROUPCANCEL       = 10140;
  RM_SENDUSERREPAIR    = 10141;

  RM_SENDUSERSREPAIR   = 50142;
  RM_SENDREPAIRCOST    = 10142;
  RM_USERREPAIRITEM_OK = 10143;
  RM_USERREPAIRITEM_FAIL=10144;
  RM_USERSTORAGEITEM   = 10146;
  RM_USERGETBACKITEM   = 10147;
  RM_SENDDELITEMLIST   = 10148;
  RM_USERMAKEDRUGITEMLIST=10149;
  RM_MAKEDRUG_SUCCESS  = 10150;
  RM_MAKEDRUG_FAIL     = 10151;
  RM_ALIVE             = 10153;

  RM_10155             = 10155;
  RM_DIGUP             = 10200;
  RM_DIGDOWN           = 10201;
  RM_FLYAXE            = 10202;
  RM_LIGHTING          = 10204;
  RM_10205             = 10205;

  RM_CHANGEGUILDNAME   = 10301;
  RM_SUBABILITY        = 10302;
  RM_BUILDGUILD_OK     = 10303;
  RM_BUILDGUILD_FAIL   = 10304;
  RM_DONATE_OK         = 10305;
  RM_DONATE_FAIL       = 10306;

  RM_MENU_OK           = 10309;

  RM_RECONNECTION      = 10332;
  RM_HIDEEVENT         = 10333;
  RM_SHOWEVENT         = 10334;

  RM_10401             = 10401;
  RM_OPENHEALTH        = 10410;
  RM_CLOSEHEALTH       = 10411;
  RM_BREAKWEAPON       = 10413;
  RM_10414             = 10414;
  RM_CHANGEFACE        = 10415;
  RM_PASSWORD          = 10416;

//ȡ���Ĳ�������ָ������  lzx2022 - delete by Davy 2022-6-12
//  RM_PLAYDICE          = 10500;

  RM_HEAR              = 11001;
  RM_WHISPER           = 11002;
  RM_CRY               = 11003;
  RM_SYSMESSAGE        = 11004;
  RM_GROUPMESSAGE      = 11005;
  RM_SYSMESSAGE2       = 11006;
  RM_GUILDMESSAGE      = 11007;
  RM_SYSMESSAGE3       = 11008;
  RM_MERCHANTSAY       = 11009;


  RM_ZEN_BEE           = 8020;
  RM_DELAYMAGIC        = 8021;
  RM_STRUCK            = 8018;
  RM_MAGSTRUCK_MINE    = 8030;
  RM_MAGHEALING        = 8034;

  RM_POISON            = 8037;
  
  RM_DOOPENHEALTH      = 8040;
  RM_SPACEMOVE_FIRE2   = 8042;
  RM_DELAYPUSHED       = 8043;
  RM_MAGSTRUCK         = 8044;
  RM_TRANSPARENT       = 8045;

  RM_DOOROPEN          = 8046;
  RM_DOORCLOSE         = 8047;
  RM_DISAPPEAR         = 8061;
  RM_SPACEMOVE_FIRE    = 8062;
  RM_SENDUSEITEMS      = 8074;
  RM_WINEXP            = 8075;
  RM_ADJUST_BONUS      = 8078;
  RM_ITEMSHOW          = 8082;
  RM_GAMEGOLDCHANGED   = 8084;
  RM_ITEMHIDE          = 8085;
  RM_LEVELUP           = 8086;

  RM_CHANGENAMECOLOR   = 8090;
  RM_PUSH              = 8092;

  RM_CLEAROBJECTS      = 8097;
  RM_CHANGEMAP         = 8098;
  RM_SPACEMOVE_SHOW2   = 8099;
  RM_SPACEMOVE_SHOW    = 8100;
  RM_USERNAME          = 8101;
  RM_MYSTATUS          = 8102;
  RM_STRUCK_MAG        = 8103;
  RM_RUSH              = 8104;
  RM_RUSHKUNG          = 8105;
  RM_PASSWORDSTATUS    = 8106;
  RM_POWERHIT          = 8107;

  RM_41                = 9041;
  RM_TWINHIT           = 9042;
  RM_43                = 9043;


  OS_EVENTOBJECT       = 1;
  OS_MOVINGOBJECT      = 2;
  OS_ITEMOBJECT        = 3;
  OS_GATEOBJECT        = 4;
  OS_MAPEVENT          = 5;
  OS_DOOR              = 6;
  OS_ROON              = 7;


  //���ܱ�ţ���ȷ��
  SKILL_FIREBALL       = 1;       //������
  SKILL_HEALLING       = 2;        //ʲôħ��
  SKILL_ONESWORD       = 3;        //�ڹ��ķ�
  SKILL_ILKWANG        = 4;       //��������
  SKILL_FIREBALL2      = 5;         //�����
  SKILL_AMYOUNSUL      = 6;        //ʩ����
  SKILL_YEDO           = 7;        //��ɱ����
  SKILL_FIREWIND       = 8;       //���ܻ�
  SKILL_FIRE           = 9;       ////������
  SKILL_SHOOTLIGHTEN   = 10;      //�����Ӱ
  SKILL_LIGHTENING     = 11;       //�׵���
  SKILL_ERGUM          = 12;       //��ɱ����
  SKILL_FIRECHARM      = 13;       //�����
  SKILL_HANGMAJINBUB   = 14;      //�����
  SKILL_DEJIWONHO      = 15;      //��ʥս����
  SKILL_HOLYSHIELD     = 16;     //��ħ��
  SKILL_SKELLETON      = 17;    //�ٻ�����
  SKILL_CLOAK          = 18;     //������
  SKILL_BIGCLOAK       = 19;    //����������
  SKILL_TAMMING        = 20;    //�ջ�֮��
  SKILL_SPACEMOVE      = 21;    //˲Ϣ�ƶ�
  SKILL_EARTHFIRE      = 22;    //��ǽ
  SKILL_FIREBOOM       = 23;     //���ѻ���
  SKILL_LIGHTFLOWER    = 24;    //�����׹�
  SKILL_BANWOL         = 25;    //�����䵶
  SKILL_FIRESWORD      = 26;    //�һ𽣷�
  SKILL_MOOTEBO        = 27;    //Ұ����ײ
  SKILL_SHOWHP         = 28;    //������ʾ
  SKILL_BIGHEALLING    = 29;   //Ⱥ��������
  SKILL_SINSU          = 30;  //ʲôħ��
  SKILL_SHIELD         = 31;   //ħ����
  SKILL_KILLUNDEAD     = 32;  //ʥ����
  SKILL_SNOWWIND       = 33;  //������
  SKILL_CROSSMOON      = 34; //˫��ն
  SKILL_WINDTEBO       = 35;  //ʲôħ��
  SKILL_UENHANCER      = 36; //�޼�����
  SKILL_ENERGYREPULSOR = 37;   //������
  SKILL_TWINBLADE      = 38;  //���ն
  SKILL_GROUPDEDING    = 39; //�ض�
  SKILL_UNAMYOUNSUL    = 40; //�ⶾ��
  SKILL_ANGEL          = 41; //ʲôħ��
  SKILL_GROUPLIGHTENING= 42; //Ⱥ���׵���
  SKILL_43             = 43;
  SKILL_44             = 44; //FrostCrunch
  SKILL_45             = 45; //FlameDisruptor
  SKILL_46             = 46; //Mirroring
  SKILL_47             = 47;
  SKILL_GROUPAMYOUNSUL = 48;   //Ⱥ��ʩ����
  SKILL_49             = 49;
  SKILL_MABE           = 50;   //����
  SKILL_51             = 51;
  SKILL_52             = 52;
  SKILL_53             = 53;
  SKILL_54             = 54;
  SKILL_55             = 55;
  SKILL_REDBANWOL      = 56;     //ʲô����
  SKILL_57             = 57;
  SKILL_58             = 58;
  SKILL_59             = 59;


  LA_UNDEAD            = 1;

  sENCYPTSCRIPTFLAG= '��֪����ʲô�ַ���';
  sSTATUS_FAIL     = '+FAIL/';
  sSTATUS_GOOD     = '+GOOD/';

type
  PTMapItem=^TMapItem;
  TMapItem=record
    Name            :String[40];
    Looks           :word;
    AniCount        :byte;
    Reserved        :integer;
    Count           :integer;
    DropBaseObject  :TObject;
    OfBaseObject    :TObject;
    dwCanPickUpTick :Dword;
    UserItem        :TUserItem;
  end;

  pTDoorStatus=^TDoorStatus;
  TDoorStatus=record
    bo01:boolean;
    n04:integer;
    boOpened:Boolean;
    dwOpenTick:dword;
    nRefCount:integer;
  end;

  pTDoorInfo=^TDoorInfo;
  TDoorInfo=record
    nX,nY:Integer;
    Status:pTDoorStatus;
    n08:integer;
  end;

  pTMapFlag=^TMapFlag;
  TMapFlag=record
     boSAFE:Boolean;
     nL:integer;
     nNEEDSETONFlag:integer;
     nNeedONOFF:integer;
     nMUSICID:integer;
     boDarkness:boolean;
     boDayLight:boolean;
     boFightZone:boolean;
     boFight3Zone:boolean;
     boQUIZ:boolean;
     boNORECONNECT:boolean;
     sNoReConnectMap:string;
     boMUSIC:boolean;
     boEXPRATE:boolean;
     nEXPRATE:integer;
     boPKWINLEVEL:boolean;
     nPKWINLEVEL:integer;
     boPKWINEXP:boolean;
     nPKWINEXP:integer;
     boPKLOSTLEVEL:boolean;
     nPKLOSTLEVEL:integer;
     boPKLOSTEXP:boolean;
     nPKLOSTEXP:integer;
     boDECHP:boolean;
     nDECHPPOINT:integer;
     nDECHPTIME:integer;
     boINCHP:boolean;
     nINCHPPOINT:integer;
     nINCHPTIME:integer;
     boDECGAMEGOLD:boolean;
     nDECGAMEGOLD:integer;
     nDECGAMEGOLDTIME:integer;
     boDECGAMEPOINT:boolean;
     nDECGAMEPOINT:integer;
     nDECGAMEPOINTTIME:integer;
     boINCGAMEGOLD:boolean;
     nINCGAMEGOLD:integer;
     nINCGAMEGOLDTIME:integer;
     boINCGAMEPOINT:boolean;
     nINCGAMEPOINT:integer;
     nINCGAMEPOINTTIME:integer;
     boRUNHUMAN:boolean;
     boRUNMON:boolean;
     boNEEDHOLE:boolean;
     boNORECALL:boolean;
     boNOGUILDRECALL:boolean;
     boNODEARRECALL:boolean;
     boNOMASTERRECALL:boolean;
     boNORANDOMMOVE:boolean;
     boNODRUG:boolean;
     boMINE:boolean;
     boMINE2:boolean;
     boNOPOSITIONMOVE:boolean;
     boNODROPITEM:boolean;
     boNOTHROWITEM:boolean;
     boNOHORSE:Boolean;
     boNOCHAT:Boolean;
  end;

  TAddAbility=record //Damian
     wHP,wMP:Word;
     wHitPoint,wSpeedPoint:Word;
     wAC,wMAC,wDC,wMC,wSC:DWord;
     wAntiPoison,wPoisonRecover,
     wHealthRecover,wSpellRecover:Word;
     wAntiMagic:Word;
     btLuck,btUnLuck:Byte;
     btWeaponStrong:BYTE;
     nHitSpeed:Word;
     btUndead:Byte;

     Weight,WearWeight,HandWeight:Word;
  end;


  TMsgColor=(c_Red,c_Green,c_Blue,c_White);
  TMsgType=(t_System,t_Notice,t_Hint,t_Say,t_Castle,t_Cust,t_GM,t_Mon);

  pTProcessMessage=^TProcessMessage;
  TProcessMessage=record
     wIdent:word;
     wParam:word;
     nParam1:integer;
     nParam2:integer;
     nParam3:integer;
     dwDeliveryTime:dword;
     BaseObject:TObject;
     boLateDelivery:Boolean;
     sMsg:String;
  end;

  pTSessInfo=^TSessInfo;
  TSessInfo=record
     nSessionID       :Integer;
     sAccount         :String[10];
     sIPaddr          :String;
     nPayMent         :integer;
     nPayMode         :integer;
     nSessionStatus   :integer;
     dwStartTick      :dword;
     dwActiveTick     :dword;
     nRefCount        :integer;
     nSocket          :integer;
     nGateIdx         :integer;
     nGSocketIdx      :integer;
     dwNewUserTick    :dword;
     nSoftVersionDate :integer;
  end;

  TScriptQuestInfo=record
     wFlag:word;
     btValue:byte;
     nRandRage:integer;
  end;
  TQuestInfo=array of TScriptQuestInfo;

  pTScript=^TScript;
  TScript=record
     boQuest:boolean;
     QuestInfo:TQuestInfo;
     RecordList:TList;
     nQuest:Integer;
  end;

  pTGameCmd=^TGameCmd;
  TGameCmd=record
     sCmd           :String;
     nPerMissionMin :integer;
     nPerMissionMax :integer;
  end;

  pTLoadDBInfo=^TLoadDBInfo;
  TLoadDBInfo=record
    nGateIdx:integer;
    nSocket:integer;
    sAccount:String[10];
    sCharName:String[20];
    nSessionID:integer;
    sIPaddr:String[15];
    nSoftVersionDate:integer;
    nPayMent:integer;
    nPayMode:integer;
    nGSocketIdx:integer;
    dwNewUserTick:dword;
    PlayObject:TObject;
    nReLoadCount:Integer;
  end;

  pTGoldChangeInfo=^TGoldChangeInfo;
  TGoldChangeInfo=record
     sGameMasterName:string;
     sGetGoldUser:String;
     nGold:integer;
  end;

  pTSaveRcd=^TSaveRcd;
  TSaveRcd=record
    sAccount:String[16];
    sChrName:String[20];
    nSessionID:integer;
    PlayObject:TObject;
    HumanRcd:THumDataInfo;
    nReTryCount:integer;
  end;

  pTMonGenInfo=^TMonGenInfo;
  TMonGenInfo=record
     sMapName:String;
     nX,nY:Integer;
     sMonName:String;
     nRange:Integer;
     nCount:Integer;
     dwZenTime:dword;
     nMissionGenRate:integer;
     CertList:TList;
     Envir:TObject;
     nRace:integer;
     dwStartTick:dword;
  end;

  pTMonInfo=^TMonInfo;
  TMonInfo=record
    ItemList:TList;
    sName:String;
    btRace:Byte;
    btRaceImg:byte;
    wAppr:word;
    wLevel:word;
    btLifeAttrib:byte;
    wCoolEye:word;
    dwExp:dword;
    wHP,wMP:word;
    wAC,wMAC,wDC,wMaxDC,wMC,wSC:Word;
    wSpeed,wHitPoint,wWalkSpeed,wWalkStep,wWalkWait,wAttackSpeed:Word;
    wAntiPush:Word;
    boAggro,boTame:Boolean;
  end;

  pTMonItem=^TMonItem;
  TMonItem=record
    MaxPoint:integer;
    SelPoint:integer;
    ItemName:String[14];
    Count:integer;
  end;

  pTUnbindInfo=^TUnbindInfo;
  TUnbindInfo=record
    nUnbindCode  :Integer;
    sItemName    :String[14];
  end;

  TSlaveInfo=record
    sSlaveName:String;
    btSlaveLevel:byte;
    dwRoyaltySec:dword;
    nKillCount:integer;
    btSlaveExpLevel:byte;
    nHP,nMP:integer;
  end;
  pTSlaveInfo=^TSlaveInfo;

  pTSwitchDataInfo=^TSwitchDataInfo;
  TSwitchDataInfo=record
     sMap:String;
     wX,wY:word;
     Abil:TAbility;
     sChrName:String;
     nCode:integer;
     boC70:boolean;
     boBanShout:boolean;
     boHearWhisper:boolean;
     boBanGuildChat:boolean;
     boAdminMode:boolean;
     boObMode:boolean;
     BlockWhisperArr:array of string;
     SlaveArr:array of TSlaveInfo;
     StatusValue:Array [0..5] of word;
     StatusTimeOut:array [0..5] of LongWord;
  end;

  TIPaddr=record
    sIpaddr:String;
    dIPaddr:String;
  end;

  pTGateInfo=^TGateInfo;
  TGateInfo=record
    boUsed:Boolean;
    Socket:TCustomWinSocket;
    sAddr :String;
    nPort :integer;
    n520  :integer;
    UserList :TList;
    nUserCount :Integer;
    Buffer:Pchar;
    nBuffLen:integer;
    BufferList:TList;
    boSendKeepAlive:Boolean;
    nSendChecked:integer;
    nSendBlockCount:integer;
    dwStartTime:dword;
    nSendMsgCount:integer;
    nSendRemainCount:integer;
    dwSendTick:Dword;
    nSendMsgBytes:integer;
    nSendBytesCount:integer;
    nSendedMsgCount:integer;
    nSendCount:integer;
    dwSendCheckTick:dword;
  end;

  pTGateUserInfo=^TGateUserInfo;
  TGateUserInfo=record
     PlayObject:TObject;
     nSessionID:integer;
     sAccount:String[10];
     nGSocketIdx:integer;
     sIPaddr:string[15];
     boCertification:boolean;
     sCharName:String[20];
     nClientVersion:integer;
     SessInfo:pTSessInfo;
     nSocket:integer;
     FrontEngine:TObject;
     UserEngine:TObject;
     dwNewUserTick:Dword;
  end;

  TClassProc=procedure(Sender:TObject);


  TCheckVersion=class

  end;

  TGameDataLog=function (p:Pchar;len:integer):Boolean;
  TMainMessageProc=procedure (Msg:PChar;nMsgLen:Integer;nMode:Integer);stdcall;
  TFindProcTableProc=function (ProcName:PChar;nNameLen:Integer):Pointer;stdcall;
  TSetProcTableProc=function(ProcAddr:Pointer;ProcName:PChar;nNameLen:Integer):Boolean;stdcall;
  TFindObj=function(ObjName:PChar;nNameLen:Integer):TObject;stdcall;
  TPlugInit=function (hnd:THandle;p:TMainMessageProc;p2:TFindProcTableProc;p3:TSetProcTableProc;p4:TFindOBj):Pchar;
  TDeCryptString=Procedure (src:Pointer;dest:pointer;srcLen:integer;var destLen:Integer);
  TMsgProc=procedure (Msg:PChar;nMsgLen:Integer;nMode:Integer);stdcall;
  TFindProc=function(sProcName:Pchar;len:Integer):Pointer;
  TSetProc=function (ProcAddr:Pointer;ProcName:PChar;len:integer):Boolean;

  TSpitMap=array [0..7] of array[0..4,0..4] of integer;

  TLevelNeedExp=Array[1..500] of dword;

  TClientConf=record
     boClientCanSet    :boolean;
     boRunHuman        :boolean;
     boRunMon          :boolean;
     boRunNpc          :boolean;
     boWarRunAll       :boolean;
     btDieColor        :byte;
     wSpellTime        :word;
     wHitIime          :word;
     wItemFlashTime    :word;
     btItemSpeed       :byte;
     boCanStartRun     :boolean;
     boParalyCanRun    :boolean;
     boParalyCanWalk   :boolean;
     boParalyCanHit    :boolean;
     boParalyCanSpell  :boolean;
     boShowRedHPLable  :boolean;
     boShowHPNumber    :boolean;
     boShowJobLevel    :boolean;
     boDuraAlert       :boolean;
     boMagicLock       :boolean;
     boAutoPuckUpItem  :boolean;
  end;

  TRecallMigic=record
    nHumLevel:integer;
    sMonName:String;
    nCount:integer;
    nLevel:integer;
  end;

  pTM2Config=^TM2Config;
  pTThreadInfo=^TThreadInfo;
  TThreadInfo=Record
    dwRunTick       :dword;
    boTerminaled    :boolean;
    nRunTime        :integer;
    nMaxRunTime     :integer;
    boActived       :boolean;
    nRunFlag        :integer;
    Config          :pTM2Config;
    hThreadHandle   :THandle;
    dwThreadID      :dword;
  end;

  TGlobaDyMval=Array of word;

  TM2Config=record
    nConfigSize             :integer;
    sServerName             :String;
    sServerIPaddr           :String;
    sWebSite                :String;
    sBbsSite                :String;
    sClientDownload         :String;
    sQQ                     :String;
    sPhone                  :String;
    sBankAccount0           :String;
    sBankAccount1           :String;
    sBankAccount2           :String;
    sBankAccount3           :String;
    sBankAccount4           :String;
    sBankAccount5           :String;
    sBankAccount6           :String;
    sBankAccount7           :String;
    sBankAccount8           :String;
    sBankAccount9           :String;
    nServerNumber           :integer;
    boVentureServer         :boolean;
    boTestServer            :boolean;
    boServiceMode           :boolean;
    boNonPKServer           :boolean;
    nTestLevel              :integer;
    nTestGold               :integer;
    nTestUserLimit          :integer;
    nSendBlock              :integer;
    nCheckBlock             :integer;
    boDropLargeBlock        :Boolean;
    nAvailableBlock         :integer;
    nGateLoad               :integer;
    nUserFull               :integer;
    nZenFastStep            :integer;
    sGateAddr               :String[15];
    nGatePort               :integer;
    sDBAddr                 :String[15];
    nDBPort                 :integer;
    sIDSAddr                :String[15];
    nIDSPort                :integer;
    sMsgSrvAddr             :String[15];
    nMsgSrvPort             :integer;
    sLogServerAddr          :String[15];
    nLogServerPort          :integer;
    boDiscountForNightTime  :boolean;
    nHalfFeeStart           :integer;
    nHalfFeeEnd             :integer;
    boViewHackMessage       :Boolean;
    boViewAdmissionFailure  :Boolean;
    sBaseDir                :String;
    sGuildDir               :String;
    sGuildFile              :String;
    sVentureDir             :String;
    sConLogDir              :String;
    sCastleDir              :String;
    sCastleFile             :String;
    sEnvirDir               :String;
    sMapDir                 :String;
    sNoticeDir              :String;
    sLogDir                 :String;
    sPlugDir                :String;
    sClientFile1            :String;
    sClientFile2            :String;
    sClientFile3            :String;
    sClothsMan              :String[14];
    sClothsWoman            :String[14];
    sWoodenSword            :String[14];
    sCandle                 :String[14];
    sBasicDrug              :String[14];
    sGoldStone              :String[14];
    sSilverStone            :String[14];
    sSteelStone             :String[14];
    sCopperStone            :String[14];
    sBlackStone             :String[14];
    sGemStone1              :String[14];
    sGemStone2              :String[14];
    sGemStone3              :String[14];
    sGemStone4              :String[14];

    sZuma                   :Array[0..3] of String[ActorNameLen];
    sBee                    :String[ActorNameLen];
    sSpider                 :String[ActorNameLen];
    sWomaHorn               :String[14];
    sZumaPiece              :String[14];
    sGameGoldName           :String;
    sGamePointName          :String;
    sPayMentPointName       :String;
    DBSocket                :integer;
    nHealthFillTime         :integer;
    nSpellFillTime          :integer;
    nMonUpLvNeedKillBase    :integer;
    nMonUpLvRate            :integer;
    MonUpLvNeedKillCount    :Array[0..7] of integer;
    SlaveColor              :Array[0..8] of Byte;
    dwNeedExps              :TLevelNeedExp;
    WideAttack              :Array[0..2] of integer;
    CrsAttack               :Array [0..6] of integer;
    SpitMap                 :TSpitMap;
    sHomeMap                :String;
    nHomeX                  :integer;
    nHomeY                  :integer;
    sRedHomeMap             :String;
    nRedHomeX               :integer;
    nRedHomeY               :integer;
    sRedDieHomeMap          :String;
    nRedDieHomeX            :integer;
    nRedDieHomeY            :integer;

    boJobHomePoint          :Boolean;
    sWarriorHomeMap         :String;
    nWarriorHomeX           :integer;
    nWarriorHomeY           :integer;
    sWizardHomeMap          :String;
    nWizardHomeX            :integer;
    nWizardHomeY            :integer;
    sTaoistHomeMap          :String;
    nTaoistHomeX            :integer;
    nTaoistHomeY            :integer;
    dwDecPkPointTime        :dword;
    nDecPkPointCount        :integer;
    dwPKFlagTime            :dword;
    nKillHumanAddPKPoint    :integer;
    nKillHumanDecLuckPoint  :integer;
    dwDecLightItemDrugTime  :dword;
    nSafeZoneSize           :integer;
    nStartPointSize         :integer;
    dwHumanGetMsgTime       :dword;
    nGroupMembersMax        :integer;
    sFireBallSkill          :String[12];
    sHealSkill              :String[12];
    sRingSkill              :Array[0..10] of String[12];
    ReNewNameColor          :Array[0..9] of byte;
    dwReNewNameColorTime    :dword;
    boReNewChangeColor      :boolean;
    boReNewLevelClearExp    :boolean;
    BonusAbilofWarr,
    BonusAbilofWizard,
    BonusAbilofTaos,
    NakedAbilofWarr,
    NakedAbilofWizard,
    NakedAbilofTaos         :TNakedAbility;
    nUpgradeWeaponMaxPoint  :integer;
    nUpgradeWeaponPrice     :integer;
    dwUPgradeWeaponGetBackTime     :dword;
    nClearExpireUpgradeWeaponDays  :integer;
    nUpgradeWeaponDCRate           :integer;
    nUpgradeWeaponDCTwoPointRate   :integer;
    nUpgradeWeaponDCThreePointRate :integer;
    nUpgradeWeaponSCRate           :integer;
    nUpgradeWeaponSCTwoPointRate   :integer;
    nUpgradeWeaponSCThreePointRate :integer;
    nUpgradeWeaponMCRate           :integer;
    nUpgradeWeaponMCTwoPointRate   :integer;
    nUpgradeWeaponMCThreePointRate :integer;
    dwProcessMonstersTime          :dword;
    dwRegenMonstersTime            :dword;
    nMonGenRate                    :integer;
    nProcessMonRandRate            :integer;
    nProcessMonLimitCount          :integer;
    nSoftVersionDate               :integer;
    boCanOldClientLogon            :boolean;
    dwConsoleShowUserCountTime     :dword;
    dwShowLineNoticeTime           :dword;
    nLineNoticeColor               :integer;
    nStartCastleWarDays            :integer;
    nStartCastlewarTime            :integer;
    dwShowCastleWarEndMsgTime      :dword;
    dwCastleWarTime                :dword;
    dwGetCastleTime                :dword;
    dwGuildWarTime                 :dword;
    nBuildGuildPrice               :integer;
    nGuildWarPrice                 :integer;
    nMakeDurgPrice                 :integer;
    nHumanMaxGold                  :integer;
    nHumanTryModeMaxGold           :integer;
    nTryModeLevel                  :integer;
    boTryModeUseStorage            :boolean;
    nCanShoutMsgLevel              :integer;
    boShowMakeItemMsg              :boolean;
    boShutRedMsgShowGMName         :boolean;
    nSayMsgMaxLen                  :integer;
    dwSayMsgTime                   :dword;
    nSayMsgCount                   :integer;
    dwDisableSayMsgTime            :dword;
    nSayRedMsgMaxLen               :integer;
    boShowGuildName                :boolean;
    boShowRankLevelName            :boolean;
    boMonSayMsg                    :boolean;
    nStartPermission               :integer;
    boKillHumanWinLevel            :boolean;
    boKilledLostLevel              :boolean;
    boKillHumanWinExp              :boolean;
    boKilledLostExp                :boolean;
    nKillHumanWinLevel             :integer;
    nKilledLostLevel               :integer;
    nKillHumanWinExp               :integer;
    nKillHumanLostExp              :integer;
    nHumanLevelDiffer              :integer;
    nMonsterPowerRate              :integer;
    nItemsPowerRate                :integer;
    nItemsACPowerRate              :integer;
    boSendOnlineCount              :boolean;
    nSendOnlineCountRate           :integer;
    dwSendOnlineTime               :dword;
    dwSaveHumanRcdTime             :dword;
    dwHumanFreeDelayTime           :dword;
    dwMakeGhostTime                :dword;
    dwClearDropOnFloorItemTime     :dword;
    dwFloorItemCanPickUpTime       :dword;
    boPasswordLockSystem           :boolean;  //�Ƿ��������뱣��ϵͳ
    boLockDealAction               :boolean;  //�Ƿ��������ײ���
    boLockDropAction               :boolean;  //�Ƿ���������Ʒ����
    boLockGetBackItemAction        :boolean;  //�Ƿ�����ȡ�ֿ����
    boLockHumanLogin               :boolean;  //�Ƿ������߲���
    boLockWalkAction               :boolean;  //�Ƿ������߲���
    boLockRunAction                :boolean;  //�Ƿ������ܲ���
    boLockHitAction                :boolean;  //�Ƿ�������������
    boLockSpellAction              :boolean;  //�Ƿ�����ħ������
    boLockSendMsgAction            :boolean;  //�Ƿ���������Ϣ����
    boLockUserItemAction           :boolean;  //�Ƿ�����ʹ����Ʒ����
    boLockInObModeAction           :boolean;  //����ʱ��������״̬
    nPasswordErrorCountLock        :integer;  //����������󳬹� ָ����������������
    boPasswordErrorKick            :boolean;  //����������󳬹�������������
    nSendRefMsgRange               :integer;
    boDecLampDura                  :boolean;
    boHungerSystem                 :boolean;
    boHungerDecHP                  :boolean;
    boHungerDecPower               :boolean;
    boDiableHumanRun               :boolean;
    boRunHuman                     :boolean;
    boRunMon                       :boolean;
    boRunNpc                       :boolean;
    boRunGuard                     :boolean;
    boWarDisHumRun                 :boolean;
    boGMRunAll                     :boolean;
    boSafeZoneRunAll               :Boolean;
    dwTryDealTime                  :dword;
    dwDealOKTime                   :dword;
    boCanNotGetBackDeal            :boolean;
    boDisableDeal                  :boolean;
    nMasterOKLevel                 :integer;
    nMasterOKCreditPoint           :integer;
    nMasterOKBonusPoint            :integer;
    boPKLevelProtect               :boolean;
    nPKProtectLevel                :integer;
    nRedPKProtectLevel             :integer;
    nItemPowerRate                 :integer;
    nItemExpRate                   :integer;
    nScriptGotoCountLimit          :integer;
    btHearMsgFColor                :byte; //ǰ��
    btHearMsgBColor                :byte; //����
    btWhisperMsgFColor             :byte; //ǰ��
    btWhisperMsgBColor             :byte; //����
    btGMWhisperMsgFColor           :byte; //ǰ��
    btGMWhisperMsgBColor           :byte; //����
    btCryMsgFColor                 :byte; //ǰ��
    btCryMsgBColor                 :byte; //����
    btGreenMsgFColor               :byte; //ǰ��
    btGreenMsgBColor               :byte; //����
    btBlueMsgFColor                :byte; //ǰ��
    btBlueMsgBColor                :byte; //����
    btRedMsgFColor                 :byte; //ǰ��
    btRedMsgBColor                 :byte; //����
    btGuildMsgFColor               :byte; //ǰ��
    btGuildMsgBColor               :byte; //����
    btGroupMsgFColor               :byte; //ǰ��
    btGroupMsgBColor               :byte; //����
    btCustMsgFColor                :byte; //ǰ��
    btCustMsgBColor                :byte; //����
    nMonRandomAddValue             :integer;
    nMakeRandomAddValue            :integer;
    nWeaponDCAddValueMaxLimit      :integer;
    nWeaponDCAddValueRate          :integer;
    nWeaponMCAddValueMaxLimit      :integer;
    nWeaponMCAddValueRate          :integer;
    nWeaponSCAddValueMaxLimit      :integer;
    nWeaponSCAddValueRate          :integer;
    nDressDCAddRate                :integer;
    nDressDCAddValueMaxLimit       :integer;
    nDressDCAddValueRate           :integer;
    nDressMCAddRate                :integer;
    nDressMCAddValueMaxLimit       :integer;
    nDressMCAddValueRate           :integer;
    nDressSCAddRate                :integer;
    nDressSCAddValueMaxLimit       :integer;
    nDressSCAddValueRate           :integer;
    nNeckLace202124DCAddRate                    :integer;
    nNeckLace202124DCAddValueMaxLimit           :integer;
    nNeckLace202124DCAddValueRate               :integer;
    nNeckLace202124MCAddRate                    :integer;
    nNeckLace202124MCAddValueMaxLimit           :integer;
    nNeckLace202124MCAddValueRate               :integer;
    nNeckLace202124SCAddRate                    :integer;
    nNeckLace202124SCAddValueMaxLimit           :integer;
    nNeckLace202124SCAddValueRate               :integer;
    nNeckLace19DCAddRate                    :integer;
    nNeckLace19DCAddValueMaxLimit           :integer;
    nNeckLace19DCAddValueRate               :integer;
    nNeckLace19MCAddRate                    :integer;
    nNeckLace19MCAddValueMaxLimit           :integer;
    nNeckLace19MCAddValueRate               :integer;
    nNeckLace19SCAddRate                    :integer;
    nNeckLace19SCAddValueMaxLimit           :integer;
    nNeckLace19SCAddValueRate               :integer;
    nArmRing26DCAddRate                    :integer;
    nArmRing26DCAddValueMaxLimit           :integer;
    nArmRing26DCAddValueRate               :integer;
    nArmRing26MCAddRate                    :integer;
    nArmRing26MCAddValueMaxLimit           :integer;
    nArmRing26MCAddValueRate               :integer;
    nArmRing26SCAddRate                    :integer;
    nArmRing26SCAddValueMaxLimit           :integer;
    nArmRing26SCAddValueRate               :integer;
    nRing22DCAddRate                    :integer;
    nRing22DCAddValueMaxLimit           :integer;
    nRing22DCAddValueRate               :integer;
    nRing22MCAddRate                    :integer;
    nRing22MCAddValueMaxLimit           :integer;
    nRing22MCAddValueRate               :integer;
    nRing22SCAddRate                    :integer;
    nRing22SCAddValueMaxLimit           :integer;
    nRing22SCAddValueRate               :integer;
    nRing23DCAddRate                    :integer;
    nRing23DCAddValueMaxLimit           :integer;
    nRing23DCAddValueRate               :integer;
    nRing23MCAddRate                    :integer;
    nRing23MCAddValueMaxLimit           :integer;
    nRing23MCAddValueRate               :integer;
    nRing23SCAddRate                    :integer;
    nRing23SCAddValueMaxLimit           :integer;
    nRing23SCAddValueRate               :integer;
    nHelMetDCAddRate                    :integer;
    nHelMetDCAddValueMaxLimit           :integer;
    nHelMetDCAddValueRate               :integer;
    nHelMetMCAddRate                    :integer;
    nHelMetMCAddValueMaxLimit           :integer;
    nHelMetMCAddValueRate               :integer;
    nHelMetSCAddRate                    :integer;
    nHelMetSCAddValueMaxLimit           :integer;
    nHelMetSCAddValueRate               :integer;
    nUnknowHelMetACAddRate              :integer;
    nUnknowHelMetACAddValueMaxLimit     :integer;
    nUnknowHelMetMACAddRate             :integer;
    nUnknowHelMetMACAddValueMaxLimit    :integer;
    nUnknowHelMetDCAddRate              :integer;
    nUnknowHelMetDCAddValueMaxLimit     :integer;
    nUnknowHelMetMCAddRate              :integer;
    nUnknowHelMetMCAddValueMaxLimit     :integer;
    nUnknowHelMetSCAddRate              :integer;
    nUnknowHelMetSCAddValueMaxLimit     :integer;
    nUnknowRingACAddRate                :integer;
    nUnknowRingACAddValueMaxLimit       :integer;
    nUnknowRingMACAddRate               :integer;
    nUnknowRingMACAddValueMaxLimit      :integer;
    nUnknowRingDCAddRate                :integer;
    nUnknowRingDCAddValueMaxLimit       :integer;
    nUnknowRingMCAddRate                :integer;
    nUnknowRingMCAddValueMaxLimit       :integer;
    nUnknowRingSCAddRate                :integer;
    nUnknowRingSCAddValueMaxLimit       :integer;
    nUnknowNecklaceACAddRate            :integer;
    nUnknowNecklaceACAddValueMaxLimit   :integer;
    nUnknowNecklaceMACAddRate           :integer;
    nUnknowNecklaceMACAddValueMaxLimit  :integer;
    nUnknowNecklaceDCAddRate            :integer;
    nUnknowNecklaceDCAddValueMaxLimit   :integer;
    nUnknowNecklaceMCAddRate            :integer;
    nUnknowNecklaceMCAddValueMaxLimit   :integer;
    nUnknowNecklaceSCAddRate            :integer;
    nUnknowNecklaceSCAddValueMaxLimit   :integer;
    nMonOneDropGoldCount                :integer;
    nMakeMineHitRate                    :integer; //�ڿ�������
    nMakeMineRate                       :integer; //�ڿ���
    nStoneTypeRate                      :integer;
    nStoneTypeRateMin                   :integer;
    nGoldStoneMin                       :integer;
    nGoldStoneMax                       :integer;
    nSilverStoneMin                     :integer;
    nSilverStoneMax                     :integer;
    nSteelStoneMin                      :integer;
    nSteelStoneMax                      :integer;
    nBlackStoneMin                      :integer;
    nBlackStoneMax                      :integer;
    nStoneMinDura                       :integer;
    nStoneGeneralDuraRate               :integer;
    nStoneAddDuraRate                   :integer;
    nStoneAddDuraMax                    :integer;
    nWinLottery6Min                     :integer;
    nWinLottery6Max                     :integer;
    nWinLottery5Min                     :integer;
    nWinLottery5Max                     :integer;
    nWinLottery4Min                     :integer;
    nWinLottery4Max                     :integer;
    nWinLottery3Min                     :integer;
    nWinLottery3Max                     :integer;
    nWinLottery2Min                     :integer;
    nWinLottery2Max                     :integer;
    nWinLottery1Min                     :integer;
    nWinLottery1Max                     :integer;//16180 + 1820;
    nWinLottery1Gold                    :integer;
    nWinLottery2Gold                    :integer;
    nWinLottery3Gold                    :integer;
    nWinLottery4Gold                    :integer;
    nWinLottery5Gold                    :integer;
    nWinLottery6Gold                    :integer;
    nWinLotteryRate                     :integer;
    nWinLotteryCount                    :integer;
    nNoWinLotteryCount                  :integer;
    nWinLotteryLevel1                   :integer;
    nWinLotteryLevel2                   :integer;
    nWinLotteryLevel3                   :integer;
    nWinLotteryLevel4                   :integer;
    nWinLotteryLevel5                   :integer;
    nWinLotteryLevel6                   :integer;
    GlobalVal                           :Array[0..19] of integer;
    nItemNumber                         :integer;
    nItemNumberEx                       :integer;
    nGuildRecallTime                    :integer;
    nGroupRecallTime                    :integer;
    boControlDropItem                   :boolean;
    boInSafeDisableDrop                 :boolean;
    nCanDropGold                        :integer;
    nCanDropPrice                       :integer;
    boSendCustemMsg                     :boolean;
    boSubkMasterSendMsg                 :boolean;
    nSuperRepairPriceRate               :integer; //���޼۸���
    nRepairItemDecDura                  :integer; //��ͨ������־���(�س־����޼������ٳ��Դ���Ϊ������ֵ)
    boDieScatterBag                     :boolean;
    nDieScatterBagRate                  :integer;
    boDieRedScatterBagAll               :boolean;
    nDieDropUseItemRate                 :integer;
    nDieRedDropUseItemRate              :integer;
    boDieDropGold                       :boolean;
    boKillByHumanDropUseItem            :boolean;
    boKillByMonstDropUseItem            :boolean;
    boKickExpireHuman                   :boolean;
    nGuildRankNameLen                   :integer;
    nGuildMemberMaxLimit                :integer;
    nGuildNameLen                       :integer;
    nCastleNameLen                      :Integer;
    nAttackPosionRate                   :integer;
    nAttackPosionTime                   :integer;
    dwRevivalTime                       :dword; //������ʱ��
    boUserMoveCanDupObj                 :boolean;
    boUserMoveCanOnItem                 :boolean;
    dwUserMoveTime                      :integer;
    dwPKDieLostExpRate                  :integer;
    nPKDieLostLevelRate                 :integer;
    btPKFlagNameColor                   :Byte;
    btPKLevel1NameColor                 :Byte;
    btPKLevel2NameColor                 :Byte;
    btAllyAndGuildNameColor             :Byte;
    btWarGuildNameColor                 :Byte;
    btInFreePKAreaNameColor             :Byte;
    boSpiritMutiny                      :boolean;
    dwSpiritMutinyTime                  :dword;
    nSpiritPowerRate                    :integer;
    boMasterDieMutiny                   :boolean;
    nMasterDieMutinyRate                :integer;
    nMasterDieMutinyPower               :integer;
    nMasterDieMutinySpeed               :integer;
    boBBMonAutoChangeColor              :boolean;
    dwBBMonAutoChangeColorTime          :integer;
    boOldClientShowHiLevel              :boolean;
    boShowScriptActionMsg               :boolean;
    nRunSocketDieLoopLimit              :integer;
    boThreadRun                         :boolean;
    boShowExceptionMsg                  :boolean;
    boShowPreFixMsg                     :boolean;
    nMagicAttackRage                    :integer; //ħ��������Χ
    sSkeleton                           :String[ActorNameLen];
    nSkeletonCount                      :integer;
    SkeletonArray                       :array[0..9] of TRecallMigic;
    sDragon                             :String[ActorNameLen];
    sDragon1                            :String[ActorNameLen];
    nDragonCount                        :integer;
    DragonArray                         :array[0..9] of TRecallMigic;
    sAngel                              :String[ActorNameLen];
    nAmyOunsulPoint                     :integer;
    boDisableInSafeZoneFireCross        :boolean;
    boGroupMbAttackPlayObject           :boolean;
    boGroupMbAttackBaoBao               :Boolean;
    dwPosionDecHealthTime               :dword;
    nPosionDamagarmor                   :integer;//�к춾�ų־ü���������ʵ�ʴ�СΪ 12 / 10��
    boLimitSwordLong                    :boolean;
    nSwordLongPowerRate                 :integer;
    nFireBoomRage                       :integer;
    nSnowWindRange                      :integer;
    nElecBlizzardRange                  :integer;
    nMagTurnUndeadLevel                 :integer; //ʥ�Թ���ȼ�����
    nMagTammingLevel                    :integer; //�ջ�֮�����ȼ�����
    nMagTammingTargetLevel              :integer; //�ջ�������ȼ����ʣ�������ԽС����Խ��
    nMagTammingHPRate                   :integer; //�ɹ�����=�������HP ���� �˱��ʣ��˱���Խ���ջ����Խ��
    nMagTammingCount                    :integer;
    nMabMabeHitRandRate                 :integer;
    nMabMabeHitMinLvLimit               :integer;
    nMabMabeHitSucessRate               :integer;
    nMabMabeHitMabeTimeRate             :integer;
    sCastleName                         :String;
    sCastleHomeMap                      :String;
    nCastleHomeX                        :integer;
    nCastleHomeY                        :integer;
    nCastleWarRangeX                    :integer;
    nCastleWarRangeY                    :integer;
    nCastleTaxRate                      :integer;
    boGetAllNpcTax                      :boolean;
    nHireGuardPrice                     :integer;
    nHireArcherPrice                    :integer;
    nCastleGoldMax                      :integer;
    nCastleOneDayGold                   :integer;
    nRepairDoorPrice                    :integer;
    nRepairWallPrice                    :integer;
    nCastleMemberPriceRate              :integer;
    nMaxHitMsgCount                     :integer;
    nMaxSpellMsgCount                   :integer;
    nMaxRunMsgCount                     :integer;
    nMaxWalkMsgCount                    :integer;
    nMaxTurnMsgCount                    :integer;
    nMaxSitDonwMsgCount                 :integer;
    nMaxDigUpMsgCount                   :integer;
    boSpellSendUpdateMsg                :boolean;
    boActionSendActionMsg               :boolean;
    boKickOverSpeed                     :boolean;
    btSpeedControlMode                  :integer;
    nOverSpeedKickCount                 :integer;
    dwDropOverSpeed                     :dword;
    dwHitIntervalTime                   :dword; //�������
    dwMagicHitIntervalTime              :dword; //ħ�����
    dwRunIntervalTime                   :dword; //�ܲ����
    dwWalkIntervalTime                  :dword; //��·���
    dwTurnIntervalTime                  :dword; //��������
    boControlActionInterval             :boolean;
    boControlWalkHit                    :boolean;
    boControlRunLongHit                 :boolean;
    boControlRunHit                     :boolean;
    boControlRunMagic                   :boolean;
    dwActionIntervalTime                :dword; //��ϲ������
    dwRunLongHitIntervalTime            :dword; //��λ��ɱ���
    dwRunHitIntervalTime                :dword; //��λ�������
    dwWalkHitIntervalTime               :dword; //��λ�������
    dwRunMagicIntervalTime              :dword; //��λħ�����
    boDisableStruck                     :boolean; //����ʾ������������
    boDisableSelfStruck                 :boolean; //�Լ�����ʾ������������
    dwStruckTime                        :dword; //��������ͣ��ʱ��
    dwKillMonExpMultiple                :dword; //ɱ�־��鱶��
    dwRequestVersion                    :dword;
    boHighLevelKillMonFixExp            :boolean;
    boHighLevelGroupFixExp              :Boolean;
    boAddUserItemNewValue               :boolean;
    sLineNoticePreFix                   :String;
    sSysMsgPreFix                       :String;
    sGuildMsgPreFix                     :String;
    sGroupMsgPreFix                     :String;
    sHintMsgPreFix                      :String;
    sGMRedMsgpreFix                     :String;
    sMonSayMsgpreFix                    :String;
    sCustMsgpreFix                      :String;
    sCastleMsgpreFix                    :String;
    sGuildNotice                        :String;
    sGuildWar                           :String;
    sGuildAll                           :String;
    sGuildMember                        :String;
    sGuildMemberRank                    :String;
    sGuildChief                         :String;
    boKickAllUser                       :boolean;
    boTestSpeedMode                     :boolean;
    ClientConf                          :TClientConf;
    nWeaponMakeUnLuckRate               :integer;
    nWeaponMakeLuckPoint1               :integer;
    nWeaponMakeLuckPoint2               :integer;
    nWeaponMakeLuckPoint3               :integer;
    nWeaponMakeLuckPoint2Rate           :integer;
    nWeaponMakeLuckPoint3Rate           :integer;
    boCheckUserItemPlace                :boolean;
    nClientKey                          :integer;
    nLevelValueOfTaosHP                 :integer;
    nLevelValueOfTaosHPRate             :double;
    nLevelValueOfTaosMP                 :integer;
    nLevelValueOfWizardHP               :integer;
    nLevelValueOfWizardHPRate           :double;
    nLevelValueOfWarrHP                 :integer;
    nLevelValueOfWarrHPRate             :double;
    nProcessMonsterInterval             :integer;
    boCheckFail                         :Boolean;
    nAppIconCrc                         :integer;
    boIDSocketConnected                 :Boolean;
    UserIDSection                       :TRTLCriticalSection;
    sIDSocketRecvText                   :String;
    IDSocket                            :integer;
    nIDSocketRecvIncLen                 :integer;
    nIDSocketRecvMaxLen                 :integer;
    nIDSocketRecvCount                  :integer;
    nIDReceiveMaxTime                   :integer;
    nIDSocketWSAErrCode                 :integer;
    nIDSocketErrorCount                 :integer;
    nLoadDBCount                        :integer;
    nLoadDBErrorCount                   :integer;
    nSaveDBCount                        :integer;
    nDBQueryID                          :integer;
    UserEngineThread                    :TThreadInfo;
    IDSocketThread                      :TThreadInfo;
    DBSocketThread                      :TThreadInfo;
    boDBSocketConnected                 :boolean;
    nDBSocketRecvIncLen                 :integer;
    nDBSocketRecvMaxLen                 :integer;
    sDBSocketRecvText                   :String;
    boDBSocketWorking                   :boolean;
    nDBSocketRecvCount                  :integer;
    nDBReceiveMaxTime                   :integer;
    nDBSocketWSAErrCode                 :integer;
    nDBSocketErrorCount                 :integer;
    nServerFile_CRCB                    :integer;
    nClientFile1_CRC                    :integer;
    nClientFile2_CRC                    :integer;
    nClientFile3_CRC                    :integer;
    GlobaDyMval                         :TGlobaDyMval;
    nM2Crc                              :integer;
    nCheckLicenseFail                   :integer;
    dwCheckTick                         :LongWord;
    nCheckFail                          :Integer;
    boDropGoldToPlayBag                 :Boolean;
    boSendCurTickCount                  :Boolean;
    dwSendWhisperTime                   :LongWord;
    nSendWhisperPlayCount               :Integer;
    boMoveCanDupObj                     :Boolean;
    nProcessTick                        :integer;
    nProcessTime                        :integer;
    nDBSocketSendLen                    :Integer;
  end;


  TGameCommand=record
    DATA,
    PRVMSG,
    ALLOWMSG,
    LETSHOUT,
    LETTRADE,
    LETGUILD,
    ENDGUILD,
    BANGUILDCHAT,
    AUTHALLY,
    AUTH,
    AUTHCANCEL,
    DIARY,
    USERMOVE,
    SEARCHING,
    ALLOWGROUPCALL,
    GROUPRECALLL,
    ALLOWGUILDRECALL,
    GUILDRECALLL,
    UNLOCKSTORAGE,
    UNLOCK,
    LOCK,
    PASSWORDLOCK,
    SETPASSWORD,
    CHGPASSWORD,
    CLRPASSWORD,
    UNPASSWORD,
    MEMBERFUNCTION,
    MEMBERFUNCTIONEX,
    DEAR,
    ALLOWDEARRCALL,
    DEARRECALL,
    MASTER,
    ALLOWMASTERRECALL,
    MASTERECALL,
    ATTACKMODE,
    REST,
    TAKEONHORSE,
    TAKEOFHORSE,
    HUMANLOCAL,
    MOVE,
    POSITIONMOVE,
    INFO,
    MOBLEVEL,
    MOBCOUNT,
    HUMANCOUNT,
    MAP,
    KICK,
    TING,
    SUPERTING,
    MAPMOVE,
    SHUTUP,
    RELEASESHUTUP,
    SHUTUPLIST,
    GAMEMASTER,
    OBSERVER ,
    SUEPRMAN,
    LEVEL,
    SABUKWALLGOLD,
    RECALL,
    REGOTO,
    SHOWFLAG,
    SHOWOPEN,
    SHOWUNIT,
    ATTACK,
    MOB,
    MOBNPC,
    DELNPC,
    NPCSCRIPT,
    RECALLMOB,
    LUCKYPOINT,

//ȡ����Ʊ����
//    LOTTERYTICKET,

    RELOADGUILD,
    RELOADLINENOTICE,
    RELOADABUSE,
    BACKSTEP,
    BALL,
    FREEPENALTY,
    PKPOINT,
    INCPKPOINT,
    CHANGELUCK,
    HUNGER,
    HAIR,
    TRAINING,
    DELETESKILL,
    CHANGEJOB,
    CHANGEGENDER,
    NAMECOLOR,
    MISSION,
    MOBPLACE,
    TRANSPARECY,
    DELETEITEM,
    LEVEL0,
    CLEARMISSION,
    SETFLAG,
    SETOPEN,
    SETUNIT,
    RECONNECTION,
    DISABLEFILTER,
    CHGUSERFULL,
    CHGZENFASTSTEP,
    CONTESTPOINT,
    STARTCONTEST,
    ENDCONTEST,
    ANNOUNCEMENT,
    OXQUIZROOM,
    GSA,
    CHANGEITEMNAME,
    DISABLESENDMSG,
    ENABLESENDMSG,
    DISABLESENDMSGLIST,
    KILL,
    MAKE,
    SMAKE,
    BONUSPOINT,
    DELBONUSPOINT,
    RESTBONUSPOINT,
    FIREBURN,
    TESTFIRE,
    TESTSTATUS,
    DELGOLD,
    ADDGOLD,
    DELGAMEGOLD,
    ADDGAMEGOLD,
    GAMEGOLD,
    GAMEPOINT,
    CREDITPOINT,
    TESTGOLDCHANGE,
    REFINEWEAPON,
    RELOADADMIN,
    RELOADNPC,
    RELOADMANAGE,
    RELOADROBOTMANAGE,
    RELOADROBOT,
    RELOADMONITEMS,
    RELOADDIARY,
    RELOADITEMDB,
    RELOADMAGICDB,
    RELOADMONSTERDB,
    RELOADMINMAP,
    REALIVE,
    ADJUESTLEVEL,
    ADJUESTEXP,
    ADDGUILD,
    DELGUILD,
    CHANGESABUKLORD,
    FORCEDWALLCONQUESTWAR,
    ADDTOITEMEVENT,
    ADDTOITEMEVENTASPIECES,
    ITEMEVENTLIST,
    STARTINGGIFTNO,
    DELETEALLITEMEVENT,
    STARTITEMEVENT,
    ITEMEVENTTERM,
    ADJUESTTESTLEVEL,
    TRAININGSKILL,
    OPDELETESKILL,
    CHANGEWEAPONDURA,
    RELOADGUILDALL,
    WHO,
    TOTAL,
    TESTGA,
    MAPINFO,
    SBKDOOR,
    CHANGEDEARNAME,
    CHANGEMASTERNAME,
    STARTQUEST,
    SETPERMISSION,
    CLEARMON,
    RENEWLEVEL,
    DENYIPLOGON,
    DENYACCOUNTLOGON,
    DENYCHARNAMELOGON,
    DELDENYIPLOGON,
    DELDENYACCOUNTLOGON,
    DELDENYCHARNAMELOGON,
    SHOWDENYIPLOGON,
    SHOWDENYACCOUNTLOGON,
    SHOWDENYCHARNAMELOGON,
    VIEWWHISPER,
    SPIRIT,
    SPIRITSTOP,
    SETMAPMODE,
    SHOWMAPMODE,
    TESTSERVERCONFIG,
    SERVERSTATUS ,
    TESTGETBAGITEM,
    CLEARBAG,
    SHOWUSEITEMINFO,
    BINDUSEITEM,
    MOBFIREBURN,
    TESTSPEEDMODE,
    LOCKLOGON    :TGameCmd;
  end;

  TIPLocal=procedure (sIPaddr:Pchar;sLocal:Pchar;len:integer);

  pTAdminInfo=^TAdminInfo;
  TAdminInfo=record
    nLv:integer;
    sChrName:String[20];
    sIPaddr:String[15];
  end;

  pTMonDrop=^TMonDrop;
  TMonDrop=record
    sItemName:String[14];
    nDropCount:integer;
    nNoDropCount:integer;
    nCountLimit:integer;
  end;

  TMonStatus=(s_KillHuman,s_UnderFire,s_Die,s_MonGen);

  pTMonSayMsg=^TMonSayMsg;
  TMonSayMsg=record
    State:TMonStatus;
    Color:TMsgColor;
    nRate:integer;
    sSayMsg:String;
  end;


  TVarType=(vNone,VInteger,VString);
  pTDynamicVar=^TDynamicVar;
  TDynamicVar=record
     sName:String;
     VarType:TVarType;
     nInternet:Integer;
     sString:String;
  end;

  pTItemName=^TItemName;
  TItemName=record
    nMakeIndex:integer;
    nItemIndex:integer;
    sItemName:String[14];
  end;

  TLoadHuman=record
    sAccount:String[16];
    sChrName:String[20];
    sUserAddr:String[15];
    nSessionID:integer;
  end;

  pTSrvNetInfo=^TSrvNetInfo;
  TSrvNetInfo=record
    sIPaddr  :String;
    nPort    :Integer;
  end;

  pTUserOpenInfo=^TUserOpenInfo;
  TUserOpenInfo=record
     sChrName:String[20];
     LoadUser:TLoadDBInfo;
     HumanRcd:THumDataInfo;
  end;

  pTGateObj=^TGateObj;
  TGateObj=record
     DEnvir:TObject;
     nDMapX,
     nDMapY:integer;
     boFlag:Boolean;
  end;

  pTMapQuestInfo=^TMapQuestInfo;
  TMapQuestInfo=record
     nFlag:integer;
     nValue:integer;
     sMonName:string[ActorNameLen];
     sItemName:String[14];
     boGrouped:boolean;
     NPC:TObject;
  end;

  //Damian
  TRegInfo = record
    sKey:String;
    sServerName:String;
    sRegSrvIP:String[15];
    nRegPort:Integer;
  end;
 //����Feature���Եķֽ�ͺϳɣ���32λ����16λΪRace��Appr,
//   ��16λ�У�������λ��ʾHair,������6λ��ʾDress,����6λ��ʾWeapon��
//   ��Race=0ʱ,Dress mod 2 ��ʾ�Ա�
//   Race=0ʱ����Ҳ����Ů���е�����Ӧ����ż����Ů��������
//*******��Feature�Ľ��Ϳ����Լ����壬��Raceȡֵ����0..90��Appr:0..9
//*******Hair�����6�ַ��ͣ�3600��ͼƬ��ÿ600��ͼƬһ�ַ��ͣ�����Ů��3
//*******Dress������������Hum.WIL�б�ʾ���ж�����ͼƬ���ж����ַ�װ��Hum.WIL������չ
//*******Weapon��������Weapon.WIL���������ͼƬ��ͬ���ģ�ÿ600����Ӧһ��Appr������Ů
//*********����40800����Ӧ68����������Ů�ϼƣ�

  pTPowerBlock = ^TPowerBlock;
  TPowerBlock = array[0..100-1] of Word; //Damian

  function MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:word):TDefaultMessage;
  function APPRfeature(cfeature:integer):Word;
  function RACEfeature(cfeature:integer):Byte;
  function HAIRfeature(cfeature:integer):Byte;
  function DRESSfeature(cfeature:integer):Byte;
  function WEAPONfeature(cfeature:integer):Byte;
  function Horsefeature(cfeature:integer):Byte;
  function Effectfeature(cfeature:integer):Byte;
  function MakeHumanFeature(btRaceImg,btDress,btWeapon,btHair:Byte):Integer;
  function MakeMonsterFeature(btRaceImg,btWeapon:Byte;wAppr:Word):Integer;


implementation

function  MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:word):TDefaultMessage;
begin
    result.Ident:=Msg;
    result.Param:=Param;
    result.Tag:=Tag;
    result.Series:=Series;
    result.Recog:=Recog;
end;

function WEAPONfeature(cfeature:integer):Byte;
begin
  Result:=HiByte(cfeature);
end;
function DRESSfeature(cfeature:integer):Byte;
begin
  Result:= HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature:integer):Word;
begin
  Result:=HiWord(cfeature);
end;
function HAIRfeature(cfeature:integer):Byte;
begin
  Result:=HiWord(cfeature);
end;
function RACEfeature(cfeature:integer):Byte;
begin
  Result:=cfeature;
end;

function Horsefeature(cfeature:integer):Byte;
begin
  Result:=LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature:integer):Byte;
begin
  Result:=HiByte(LoWord(cfeature));
end;

function MakeHumanFeature(btRaceImg,btDress,btWeapon,btHair:Byte):Integer;
begin
  Result:=MakeLong(MakeWord(btRaceImg,btWeapon),MakeWord(btHair,btDress));
end;
function MakeMonsterFeature(btRaceImg,btWeapon:Byte;wAppr:Word):Integer;
begin
  Result:=MakeLong(MakeWord(btRaceImg,btWeapon),wAppr);
end;

end.

