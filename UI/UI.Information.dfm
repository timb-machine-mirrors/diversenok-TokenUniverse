object InfoDialog: TInfoDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Information about'
  ClientHeight = 339
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    402
    339)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 396
    Height = 306
    ActivePage = TabGeneral
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabGeneral: TTabSheet
      Caption = 'General'
      DesignSize = (
        388
        278)
      object BtnSetIntegrity: TSpeedButton
        Left = 359
        Top = 139
        Width = 23
        Height = 21
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000000000000000000000010000000000000000000016A5
          440026B255002EB75D002FB85E0052C7630053C7640053C8640056CC670057CC
          68005BD26E005CD36E0056DE6D005FD4710062DA750056E970005AEB73005FED
          780066E07B0066E67C0069E07D0065EE7D0068EA7F0063C382006DCB8C006CE5
          80006CEA830069EC80006CED830074E4870071EA850070EE860073ED890074EF
          8A0081D38D0082D48D009BE2A60098EEA7009DE8A9009AEDA8009EEFAB009DF0
          AB009EF2AD00A0F4AF00A3F2B100A1F4B000A7F4B50000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF18FFFFFFFFFFFFFFFFFFFFFFFFFFFF04
          04FFFFFFFFFFFFFFFFFFFFFFFFFF042A04FFFFFFFFFFFFFFFFFFFFFFFF042516
          04FFFFFFFFFFFFFFFFFFFFFF02260C13040303030303030303FFFF02240D0E1D
          262D2D2B2B2A2A2A2503012307090B0E14191A1A1511100F2A03FF012306070B
          0E13141E20201E1A2D04FFFF0123070901010101010121112B03FFFFFF012306
          01FFFFFFFF011F102A03FFFFFFFF012301FFFFFFFF011A0F2A03FFFFFFFFFF01
          01FFFFFFFF012E2A2503FFFFFFFFFFFF17FFFFFFFFFF040403FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = BtnSetIntegrityClick
      end
      object BtnSetSession: TSpeedButton
        Left = 359
        Top = 167
        Width = 23
        Height = 21
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000000000000000000000010000000000000000000016A5
          440026B255002EB75D002FB85E0052C7630053C7640053C8640056CC670057CC
          68005BD26E005CD36E0056DE6D005FD4710062DA750056E970005AEB73005FED
          780066E07B0066E67C0069E07D0065EE7D0068EA7F0063C382006DCB8C006CE5
          80006CEA830069EC80006CED830074E4870071EA850070EE860073ED890074EF
          8A0081D38D0082D48D009BE2A60098EEA7009DE8A9009AEDA8009EEFAB009DF0
          AB009EF2AD00A0F4AF00A3F2B100A1F4B000A7F4B50000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF18FFFFFFFFFFFFFFFFFFFFFFFFFFFF04
          04FFFFFFFFFFFFFFFFFFFFFFFFFF042A04FFFFFFFFFFFFFFFFFFFFFFFF042516
          04FFFFFFFFFFFFFFFFFFFFFF02260C13040303030303030303FFFF02240D0E1D
          262D2D2B2B2A2A2A2503012307090B0E14191A1A1511100F2A03FF012306070B
          0E13141E20201E1A2D04FFFF0123070901010101010121112B03FFFFFF012306
          01FFFFFFFF011F102A03FFFFFFFF012301FFFFFFFF011A0F2A03FFFFFFFFFF01
          01FFFFFFFF012E2A2503FFFFFFFFFFFF17FFFFFFFFFF040403FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      end
      object StaticUser: TStaticText
        Left = 7
        Top = 89
        Width = 30
        Height = 17
        Caption = 'User:'
        TabOrder = 0
      end
      object EditUser: TEdit
        Left = 94
        Top = 85
        Width = 288
        Height = 21
        Margins.Right = 6
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 1
        Text = 'Unknown User'
      end
      object StaticSID: TStaticText
        Left = 7
        Top = 116
        Width = 50
        Height = 17
        Caption = 'User SID:'
        TabOrder = 2
      end
      object EditSID: TEdit
        Left = 94
        Top = 112
        Width = 288
        Height = 21
        Margins.Right = 6
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 3
        Text = 'Unknown SID'
      end
      object StaticObjAddr: TStaticText
        Left = 7
        Top = 17
        Width = 81
        Height = 17
        Caption = 'Object address:'
        TabOrder = 4
      end
      object EditObjAddr: TEdit
        Left = 94
        Top = 17
        Width = 288
        Height = 17
        Margins.Right = 6
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        AutoSize = False
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 5
        Text = 'Unknown address'
      end
      object StaticSession: TStaticText
        Left = 7
        Top = 170
        Width = 44
        Height = 17
        Caption = 'Session:'
        TabOrder = 6
      end
      object StaticElevation: TStaticText
        Left = 248
        Top = 17
        Width = 50
        Height = 17
        Caption = 'Elevated:'
        TabOrder = 7
      end
      object StaticVirtualization: TStaticText
        Left = 248
        Top = 63
        Width = 57
        Height = 17
        Caption = 'Virtualized:'
        TabOrder = 8
      end
      object StaticIntegrity: TStaticText
        Left = 7
        Top = 143
        Width = 75
        Height = 17
        Caption = 'Integrity level:'
        TabOrder = 9
      end
      object StaticUIAccess: TStaticText
        Left = 248
        Top = 40
        Width = 52
        Height = 17
        Caption = 'UIAccess:'
        TabOrder = 10
      end
      object StaticType: TStaticText
        Left = 7
        Top = 63
        Width = 62
        Height = 17
        Caption = 'Token type:'
        TabOrder = 11
      end
      object ComboSession: TComboBox
        Left = 94
        Top = 167
        Width = 262
        Height = 21
        AutoComplete = False
        Anchors = [akLeft, akTop, akRight]
        ItemIndex = 1
        TabOrder = 12
        Text = '1: Console (Domain\User)'
        Items.Strings = (
          '0: Services'
          '1: Console (Domain\User)')
      end
      object ComboIntegrity: TComboBox
        Left = 94
        Top = 139
        Width = 262
        Height = 21
        AutoComplete = False
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 13
        Text = 'Unknown integrity level'
        Items.Strings = (
          'Untrusted (0x0000)'
          'Low (0x1000)'
          'Medium (0x2000)'
          'Medium Plus (0x2100)'
          'High (0x3000)'
          'System (0x4000)')
      end
      object StaticHandle: TStaticText
        Left = 7
        Top = 40
        Width = 70
        Height = 17
        Caption = 'Handle value:'
        TabOrder = 14
      end
      object EditHandle: TEdit
        Left = 94
        Top = 40
        Width = 145
        Height = 17
        Margins.Right = 6
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        AutoSize = False
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 15
        Text = 'Unknown handle'
      end
      object EditType: TEdit
        Left = 94
        Top = 63
        Width = 145
        Height = 17
        Margins.Right = 6
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        AutoSize = False
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 16
        Text = 'Unknown token type'
      end
    end
    object TabGroups: TTabSheet
      Caption = 'Groups'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListViewGroups: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 382
        Height = 272
        Align = alClient
        Columns = <
          item
            Caption = 'Group name'
            Width = 220
          end
          item
            Caption = 'Flags'
            Width = 140
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabPrivileges: TTabSheet
      Caption = 'Privileges'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListViewPrivileges: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 382
        Height = 272
        Align = alClient
        Columns = <
          item
            Caption = 'Privilege name'
            Width = 180
          end
          item
            Caption = 'Flags'
            Width = 140
          end
          item
            Caption = 'Description'
            Width = 230
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabRestricted: TTabSheet
      Caption = 'Restricted SIDs'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListViewRestricted: TListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 382
        Height = 272
        Align = alClient
        Columns = <
          item
            Caption = 'User or Group'
            Width = 220
          end
          item
            Caption = 'Flags'
            Width = 140
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object ButtonClose: TButton
    Left = 323
    Top = 311
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 1
    OnClick = ButtonCloseClick
  end
  object ComboBoxView: TComboBox
    Left = 3
    Top = 313
    Width = 158
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemIndex = 0
    TabOrder = 2
    Text = 'Resolve users and groups'
    OnChange = ChangedView
    Items.Strings = (
      'Resolve users and groups'
      'Show SIDs')
  end
  object ImageList: TImageList
    Left = 175
    Top = 235
  end
end
