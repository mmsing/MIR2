object frmGeneralConfig: TfrmGeneralConfig
  Left = 218
  Top = 153
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '��������'
  ClientHeight = 158
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNet: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = '�������ã����������Ч��'
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = '���ص�ַ:'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = '���ض˿�:'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 66
      Height = 12
      Caption = '�������˿�:'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 66
      Height = 12
      Caption = '��������ַ:'
    end
    object EditGateIPaddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      Hint = 
        '��ַһ��Ĭ��Ϊ 0.0.0.0 ,ͨ������Ҫ����'#13#10'����������ж��IP��ַʱ,������Ϊ������'#13#10'��һ��IP,��ʵ��ͬ�Ϳڲ�ͬI' +
        'P�İ�.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      Hint = '���ض��⿪�ŵĶ˿ں�,�˶˿ڱ�׼Ϊ 7200,'#13#10'�˶˿ڿ��Ը����Լ���Ҫ������޸�.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      Hint = '��Ϸ�������Ķ˿�,�˶˿ڱ�׼Ϊ 5000,'#13#10'���ʹ�õ���Ϸ���������޸Ĺ�,���Ϊ'#13#10'��Ӧ�Ķ˿ھ�����.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      Hint = '��Ϸ������IP��ַ,����ǵ������з���'#13#10'����ʱ,һ����� 127.0.0.1 .'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = '��������'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = '����:'
    end
    object LabelShowLogLevel: TLabel
      Left = 8
      Top = 44
      Width = 66
      Height = 12
      Caption = '��־��ϸ��:'
    end
    object LabelShowBite: TLabel
      Left = 8
      Top = 92
      Width = 78
      Height = 12
      Caption = '������ʾ��λ:'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      Hint = '�����������ʾ������,������ֻ������ʾ'#13#10'��ʱ����������;.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '��L����'
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      Hint = '����������־��ʾ��ϸ�ȼ�.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxShowBite: TComboBox
      Left = 88
      Top = 88
      Width = 57
      Height = 20
      Hint = '��������������ʾ�ļ������������ʾ��λ'
      Style = csDropDownList
      ItemHeight = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Items.Strings = (
        'KB'
        'B')
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Hint = '���浱ǰ����,������������һ������'#13#10'����ʱ��Ч'
    Caption = 'ȷ��(&O)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
