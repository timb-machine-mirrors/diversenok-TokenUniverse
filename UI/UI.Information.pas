unit UI.Information;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  Vcl.ComCtrls, Vcl.Buttons, TU.Tokens, System.ImageList, Vcl.ImgList,
  UI.ListViewEx, UI.Prototypes, UI.Prototypes.ChildForm, TU.Common, TU.WtsApi,
  TU.Tokens.Types;

type
  TInfoDialog = class(TChildTaskbarForm)
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    TabGroups: TTabSheet;
    TabPrivileges: TTabSheet;
    StaticUser: TStaticText;
    EditUser: TEdit;
    ButtonClose: TButton;
    ListViewGroups: TListViewEx;
    ListViewPrivileges: TListViewEx;
    TabRestricted: TTabSheet;
    ListViewRestricted: TListViewEx;
    StaticSession: TStaticText;
    StaticIntegrity: TStaticText;
    ComboSession: TComboBox;
    ComboIntegrity: TComboBox;
    ImageList: TImageList;
    BtnSetIntegrity: TSpeedButton;
    BtnSetSession: TSpeedButton;
    PrivilegePopup: TPopupMenu;
    MenuPrivEnable: TMenuItem;
    MenuPrivDisable: TMenuItem;
    MenuPrivRemove: TMenuItem;
    GroupPopup: TPopupMenu;
    MenuGroupEnable: TMenuItem;
    MenuGroupDisable: TMenuItem;
    MenuGroupReset: TMenuItem;
    TabAdvanced: TTabSheet;
    ListViewAdvanced: TListViewEx;
    StaticOwner: TStaticText;
    ComboOwner: TComboBox;
    BtnSetOwner: TSpeedButton;
    BtnSetPrimary: TSpeedButton;
    ComboPrimary: TComboBox;
    StaticPrimary: TStaticText;
    StaticUIAccess: TStaticText;
    ComboUIAccess: TComboBox;
    BtnSetUIAccess: TSpeedButton;
    StaticText1: TStaticText;
    ComboPolicy: TComboBox;
    SpeedButton1: TSpeedButton;
    ListViewGeneral: TListViewEx;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnSetIntegrityClick(Sender: TObject);
    procedure ChangedView(Sender: TObject);
    procedure BtnSetSessionClick(Sender: TObject);
    procedure DoCloseForm(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetStaleColor(Sender: TObject);
    procedure ActionPrivilegeEnable(Sender: TObject);
    procedure ActionPrivilegeDisable(Sender: TObject);
    procedure ActionPrivilegeRemove(Sender: TObject);
    procedure ActionGroupEnable(Sender: TObject);
    procedure ActionGroupDisable(Sender: TObject);
    procedure ActionGroupReset(Sender: TObject);
    procedure ListViewGroupsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure BtnSetUIAccessClick(Sender: TObject);
    procedure BtnSetMandatoryPolicy(Sender: TObject);
    procedure ListViewAdvancedResize(Sender: TObject);
  private
    Token: TToken;
    SessionSource: TSessionSource;
    IntegritySource: TIntegritySource;
    PrivilegesSource: TPrivilegesSource;
    GroupsSource, RestrictedSIDsSource: TGroupsSource;
    procedure ChangedCaption(NewCaption: String);
    procedure ChangedIntegrity(NewIntegrity: TTokenIntegrity);
    procedure ChangedSession(NewSession: Cardinal);
    procedure ChangedUIAccess(NewUIAccess: LongBool);
    procedure ChangedPolicy(NewPolicy: TMandatoryPolicy);
    procedure ChangedPrivileges(NewPrivileges: TPrivilegeArray);
    procedure ChangedGroups(NewGroups: TGroupArray);
    procedure ChangedStatistics(NewStatistics: TTokenStatistics);
    procedure Refresh;
  public
    constructor CreateFromToken(AOwner: TComponent; SrcToken: TToken);
  end;

implementation

uses
  System.UITypes, UI.MainForm, UI.Colors, TU.LsaApi;

{$R *.dfm}

procedure TInfoDialog.ActionGroupDisable(Sender: TObject);
begin
  if ListViewGroups.SelCount <> 0 then
    Token.GroupAdjust(GroupsSource.SelectedGroups, gaDisable);
end;

procedure TInfoDialog.ActionGroupEnable(Sender: TObject);
begin
  if ListViewGroups.SelCount <> 0 then
    Token.GroupAdjust(GroupsSource.SelectedGroups, gaEnable);
end;

procedure TInfoDialog.ActionGroupReset(Sender: TObject);
begin
  if ListViewGroups.SelCount <> 0 then
    Token.GroupAdjust(GroupsSource.SelectedGroups, gaResetDefault);
end;

procedure TInfoDialog.ActionPrivilegeDisable(Sender: TObject);
begin
  if ListViewPrivileges.SelCount <> 0 then
    Token.PrivilegeAdjust(PrivilegesSource.SelectedPrivileges, paDisable);
end;

procedure TInfoDialog.ActionPrivilegeEnable(Sender: TObject);
begin
  if ListViewPrivileges.SelCount <> 0 then
    Token.PrivilegeAdjust(PrivilegesSource.SelectedPrivileges, paEnable);
end;

procedure TInfoDialog.ActionPrivilegeRemove(Sender: TObject);
begin
  if ListViewPrivileges.SelCount <> 0 then
    Token.PrivilegeAdjust(PrivilegesSource.SelectedPrivileges, paRemove);
end;

procedure TInfoDialog.BtnSetIntegrityClick(Sender: TObject);
begin
  try
    Token.InfoClass.IntegrityLevel := IntegritySource.SelectedIntegrity;
    ComboIntegrity.Color := clWindow;
  except
    if Token.InfoClass.Query(tdTokenIntegrity) then
      ChangedIntegrity(Token.InfoClass.Integrity);
    raise;
  end;
end;

procedure TInfoDialog.BtnSetMandatoryPolicy(Sender: TObject);
begin
  try
    if ComboPolicy.ItemIndex = -1 then
      Token.InfoClass.MandatoryPolicy := TMandatoryPolicy(StrToUIntEx(
        ComboPolicy.Text, 'mandatory policy flag'))
    else
      Token.InfoClass.MandatoryPolicy := TMandatoryPolicy(ComboPolicy.ItemIndex);
  except
    if Token.InfoClass.Query(tdTokenMandatoryPolicy) then
      ChangedPolicy(Token.InfoClass.MandatoryPolicy);
    raise;
  end;
end;

procedure TInfoDialog.BtnSetSessionClick(Sender: TObject);
begin
  try
    Token.InfoClass.Session := SessionSource.SelectedSession;
  except
    if Token.InfoClass.Query(tdTokenSessionId) then
      ChangedSession(Token.InfoClass.Session);
    raise;
  end;
end;

procedure TInfoDialog.BtnSetUIAccessClick(Sender: TObject);
begin
  try
    if ComboUIAccess.ItemIndex = -1 then
      Token.InfoClass.UIAccess := LongBool(StrToUIntEx(ComboUIAccess.Text,
        'UIAccess value'))
    else
      Token.InfoClass.UIAccess := LongBool(ComboUIAccess.ItemIndex);
  except
    if Token.InfoClass.Query(tdTokenUIAccess) then
        ChangedUIAccess(Token.InfoClass.UIAccess);
    raise;
  end;
end;

procedure TInfoDialog.ChangedCaption(NewCaption: String);
begin
  Caption := Format('Token Information for "%s"', [NewCaption]);
end;

procedure TInfoDialog.ChangedGroups(NewGroups: TGroupArray);
begin
  TabGroups.Caption := Format('Groups (%d)', [Length(NewGroups)]);
end;

procedure TInfoDialog.ChangedIntegrity(NewIntegrity: TTokenIntegrity);
begin
  ComboIntegrity.Color := clWindow;
  IntegritySource.SetIntegrity(NewIntegrity);
end;

procedure TInfoDialog.ChangedPolicy(NewPolicy: TMandatoryPolicy);
begin
  ComboPolicy.Color := clWindow;

  if (NewPolicy >= TokenMandatoryPolicyOff) and
    (NewPolicy <= TokenMandatoryPolicyValidMask) then
    ComboPolicy.ItemIndex := Integer(NewPolicy)
  else
  begin
    ComboPolicy.ItemIndex := -1;
    ComboPolicy.Text := IntToStr(Integer(NewPolicy));
  end;
end;

procedure TInfoDialog.ChangedPrivileges(NewPrivileges: TPrivilegeArray);
begin
  TabPrivileges.Caption := Format('Privileges (%d)', [Length(NewPrivileges)]);
end;

procedure TInfoDialog.ChangedSession(NewSession: Cardinal);
begin
  ComboSession.Color := clWindow;
  SessionSource.SelectedSession := NewSession;
end;

procedure TInfoDialog.ChangedStatistics(NewStatistics: TTokenStatistics);
begin
  with ListViewAdvanced do
  begin
    Items[2].SubItems[0] := Token.InfoClass.QueryString(tsTokenID);
    Items[3].SubItems[0] := Token.InfoClass.QueryString(tsLogonID);
    Items[4].SubItems[0] := Token.InfoClass.QueryString(tsExprires);
    Items[5].SubItems[0] := Token.InfoClass.QueryString(tsDynamicCharged);
    Items[6].SubItems[0] := Token.InfoClass.QueryString(tsDynamicAvailable);
    Items[7].SubItems[0] := Token.InfoClass.QueryString(tsGroupCount);
    Items[8].SubItems[0] := Token.InfoClass.QueryString(tsPrivilegeCount);
    Items[9].SubItems[0] := Token.InfoClass.QueryString(tsModifiedID);

    Items[12].SubItems[0] := Token.InfoClass.QueryString(tsLogonID);
    Items[13].SubItems[0] := Token.InfoClass.QueryString(tsLogonUserName);

    if Token.InfoClass.Query(tdLogonInfo) and
      Token.InfoClass.LogonSessionInfo.UserPresent then
      Items[13].Hint := TGroupsSource.BuildHint(
        Token.InfoClass.LogonSessionInfo.User, TGroupAttributes(0), False);

    Items[14].SubItems[0] := Token.InfoClass.QueryString(tsLogonAuthPackage);
    Items[15].SubItems[0] := Token.InfoClass.QueryString(tsLogonServer);
    Items[16].SubItems[0] := Token.InfoClass.QueryString(tsLogonType);
    Items[17].SubItems[0] := Token.InfoClass.QueryString(tsLogonWtsSession);
    Items[18].SubItems[0] := Token.InfoClass.QueryString(tsLogonTime);

    // TODO: Error hints
  end;
end;

procedure TInfoDialog.ChangedUIAccess(NewUIAccess: LongBool);
begin
  ComboUIAccess.Color := clWhite;
  ComboUIAccess.ItemIndex := Integer(NewUIAccess = True);
end;

procedure TInfoDialog.ChangedView(Sender: TObject);
begin
  // TODO: What about a new event for this?
  if Token.InfoClass.Query(tdTokenUser) then
    with Token.InfoClass.User, EditUser do
    begin
      Text := SecurityIdentifier.ToString;
      Hint := TGroupsSource.BuildHint(SecurityIdentifier,
        Attributes);

      if Attributes.Contain(GroupUforDenyOnly) then
        Color := clDisabled
      else
        Color := clEnabled;
    end;

  if Token.InfoClass.Query(tdTokenOwner) then
    ComboOwner.Text := Token.InfoClass.Owner.ToString;

  if Token.InfoClass.Query(tdTokenPrimaryGroup) then
      ComboPrimary.Text := Token.InfoClass.PrimaryGroup.ToString;
end;

constructor TInfoDialog.CreateFromToken(AOwner: TComponent; SrcToken: TToken);
begin
  Assert(Assigned(SrcToken));
  Token := SrcToken;
  inherited Create(AOwner);
  Show;
end;

procedure TInfoDialog.DoCloseForm(Sender: TObject);
begin
  Close;
end;

procedure TInfoDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Token.Events.OnStatisticsChange.Delete(ChangedStatistics);
  Token.Events.OnGroupsChange.Delete(ChangedGroups);
  Token.Events.OnPrivilegesChange.Delete(ChangedPrivileges);
  Token.Events.OnPolicyChange.Delete(ChangedPolicy);
  Token.Events.OnIntegrityChange.Delete(ChangedIntegrity);
  Token.Events.OnUIAccessChange.Delete(ChangedUIAccess);
  Token.Events.OnSessionChange.Delete(ChangedSession);
  Token.OnCaptionChange.Delete(ChangedCaption);
  RestrictedSIDsSource.Free;
  GroupsSource.Free;
  PrivilegesSource.Free;
  IntegritySource.Free;
  SessionSource.Free;
  UnsubscribeTokenCanClose(Token);
end;

procedure TInfoDialog.FormCreate(Sender: TObject);
begin
  SubscribeTokenCanClose(Token, Caption);
  SessionSource := TSessionSource.Create(ComboSession);
  IntegritySource := TIntegritySource.Create(ComboIntegrity);
  PrivilegesSource := TPrivilegesSource.Create(ListViewPrivileges);
  GroupsSource := TGroupsSource.Create(ListViewGroups);
  RestrictedSIDsSource := TGroupsSource.Create(ListViewRestricted);

  // "Refresh" queries all the information, stores changeble one in the event
  // handler, and distributes changed one to every existing event listener
  Refresh;

  // Than subscribtion calls our event listeners with the latest availible
  // information that is stored in the event handlers. By doing that in this
  // order we avoid multiple calls while sharing the data between different
  // tokens pointing the same kernel object.
  Token.Events.OnSessionChange.Add(ChangedSession);
  Token.Events.OnUIAccessChange.Add(ChangedUIAccess);
  Token.Events.OnIntegrityChange.Add(ChangedIntegrity);
  Token.Events.OnPolicyChange.Add(ChangedPolicy);
  Token.Events.OnPrivilegesChange.Add(ChangedPrivileges);
  Token.Events.OnGroupsChange.Add(ChangedGroups);
  Token.Events.OnStatisticsChange.Add(ChangedStatistics);
  PrivilegesSource.SubscribeToken(Token);
  GroupsSource.SubscribeToken(Token, gsGroups);
  RestrictedSIDsSource.SubscribeToken(Token, gsRestrictedSIDs);

  Token.OnCaptionChange.Add(ChangedCaption);
  Token.OnCaptionChange.Invoke(Token.Caption);

  TabRestricted.Caption := Format('Restricting SIDs (%d)',
    [ListViewRestricted.Items.Count]);
end;

procedure TInfoDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    Refresh;
end;

procedure TInfoDialog.ListViewAdvancedResize(Sender: TObject);
begin
  // HACK: designs-time AutoSize causes horizontal scrollbar to appear
  ListViewAdvanced.Columns[1].AutoSize := True;
  ListViewRestricted.OnResize := nil;
end;

procedure TInfoDialog.ListViewGroupsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  MenuGroupEnable.Visible := ListViewGroups.SelCount <> 0;
  MenuGroupDisable.Visible := ListViewGroups.SelCount <> 0;
end;

procedure TInfoDialog.Refresh;
begin
  SessionSource.RefreshSessionList(False);

  ListViewGeneral.Items.BeginUpdate;
  with ListViewGeneral do
  begin
    Items[0].SubItems[0] := Token.InfoClass.QueryString(tsObjectAddress);
    Items[1].SubItems[0] := Token.InfoClass.QueryString(tsHandle);
    Items[2].SubItems[0] := Token.InfoClass.QueryString(tsAccess, True);
    Items[3].SubItems[0] := Token.InfoClass.QueryString(tsTokenType);
    Items[4].SubItems[0] := Token.InfoClass.QueryString(tsElevation);
  end;
  ListViewGeneral.Items.EndUpdate;

  ListViewAdvanced.Items.BeginUpdate;
  with ListViewAdvanced do
  begin
    Items[0].SubItems[0] := Token.InfoClass.QueryString(tsSourceName);
    Items[1].SubItems[0] := Token.InfoClass.QueryString(tsSourceLUID);
    Items[10].SubItems[0] := Token.InfoClass.QueryString(tsSandboxInert);
    Items[11].SubItems[0] := Token.InfoClass.QueryString(tsHasRestrictions);
  end;
  ListViewAdvanced.Items.EndUpdate;

  // This triggers InfoClass if the value has changed
  Token.InfoClass.ReQuery(tdTokenIntegrity);
  Token.InfoClass.ReQuery(tdTokenSessionId);
  Token.InfoClass.ReQuery(tdTokenUIAccess);
  Token.InfoClass.ReQuery(tdTokenMandatoryPolicy);
  Token.InfoClass.ReQuery(tdTokenPrivileges);
  Token.InfoClass.ReQuery(tdTokenGroups);
  Token.InfoClass.ReQuery(tdTokenStatistics);

  ChangedView(Token);
end;

procedure TInfoDialog.SetStaleColor(Sender: TObject);
begin
  (Sender as TComboBox).Color := clStale;
end;

end.
