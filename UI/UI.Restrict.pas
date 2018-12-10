unit UI.Restrict;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, TU.Common, TU.Tokens, UI.ListViewEx, UI.Prototypes,
  UI.Prototypes.ChildForm, System.ImageList, Vcl.ImgList, Vcl.Menus;

type
  TDialogRestrictToken = class(TChildForm)
    CheckBoxDisableMaxPriv: TCheckBox;
    CheckBoxSandboxInert: TCheckBox;
    CheckBoxLUA: TCheckBox;
    CheckBoxWriteOnly: TCheckBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    PageControl1: TPageControl;
    TabSheetSidDisable: TTabSheet;
    TabSheetSidRestict: TTabSheet;
    TabSheetPrivDelete: TTabSheet;
    ListViewPrivileges: TListViewEx;
    ListViewRestrictSID: TListViewEx;
    ListViewDisableSID: TListViewEx;
    ButtonAddSID: TButton;
    PopupMenu: TPopupMenu;
    MenuEdit: TMenuItem;
    MenuRemove: TMenuItem;
    CheckBoxUsual: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DoCloseForm(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonAddSIDClick(Sender: TObject);
    procedure ListViewRestrictSIDContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuRemoveClick(Sender: TObject);
    procedure MenuEditClick(Sender: TObject);
  private
    Token: TToken;
    DisableGoupsSource, RestrictGroupsSource: TGroupsSource;
    PrivilegesSource: TPrivilegesSource;
    function GetFlags: Cardinal;
    procedure ChangedCaption(NewCaption: String);
  public
    constructor CreateFromToken(AOwner: TComponent; SrcToken: TToken);
  end;

implementation

uses
  UI.MainForm, System.UITypes, UI.Modal.PickUser, TU.Tokens.Types;

{$R *.dfm}

{ TDialogRestrictToken }

procedure TDialogRestrictToken.ButtonAddSIDClick(Sender: TObject);
begin
  RestrictGroupsSource.AddGroup(TDialogPickUser.Execute(Self, True)).Checked :=
    True;
end;

procedure TDialogRestrictToken.ButtonOKClick(Sender: TObject);
const
  NO_SANBOX_INERT = 'The resulting token doesn''t contain SandboxInert flag ' +
    'despite you tried to enable it. Looks like this action requires ' +
    'SeTcbPrivilege on your system.';
var
  NewToken: TToken;
begin
  NewToken := TToken.CreateRestricted(Token, GetFlags,
    DisableGoupsSource.CheckedGroups,
    RestrictGroupsSource.CheckedGroups,
    PrivilegesSource.CheckedPrivileges);

  FormMain.Frame.AddToken(NewToken);

  // Check whether SandboxInert was actually enabled
  if CheckBoxSandboxInert.Checked then
    if NewToken.InfoClass.Query(tdTokenSandBoxInert) and
      not NewToken.InfoClass.SandboxInert then
      begin
        Hide;
        MessageDlg(NO_SANBOX_INERT, mtWarning, [mbOK], 0);
      end;

  Close;
end;

procedure TDialogRestrictToken.ChangedCaption(NewCaption: String);
begin
  Caption := Format('Create restricted token for "%s"', [NewCaption]);
end;

constructor TDialogRestrictToken.CreateFromToken(AOwner: TComponent;
  SrcToken: TToken);
begin
  Token := SrcToken;
  inherited Create(AOwner);
  Show;
end;

procedure TDialogRestrictToken.DoCloseForm(Sender: TObject);
begin
  Close;
end;

procedure TDialogRestrictToken.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Token.OnCaptionChange.Delete(ChangedCaption);
  PrivilegesSource.Free;
  RestrictGroupsSource.Free;
  DisableGoupsSource.Free;
  UnsubscribeTokenCanClose(Token);
end;

procedure TDialogRestrictToken.FormCreate(Sender: TObject);
var
  UserItem: TGroup;
  Found: Boolean;
  RestrInd, ItemInd: Integer;
begin
  SubscribeTokenCanClose(Token, Caption);

  DisableGoupsSource := TGroupsSource.Create(ListViewDisableSID);
  RestrictGroupsSource := TGroupsSource.Create(ListViewRestrictSID);
  PrivilegesSource := TPrivilegesSource.Create(ListViewPrivileges);

  DisableGoupsSource.SubscribeToken(Token, gsGroups);
  RestrictGroupsSource.SubscribeToken(Token, gsGroups);
  PrivilegesSource.SubscribeToken(Token);

  Token.OnCaptionChange.Add(ChangedCaption);
  ChangedCaption(Token.Caption);

  // The user can also be disabled and restricted
  if Token.InfoClass.Query(tdTokenUser) then
  begin
    UserItem.SecurityIdentifier := Token.InfoClass.User.SecurityIdentifier;
    UserItem.Attributes := Token.InfoClass.User.Attributes;
    DisableGoupsSource.AddGroup(UserItem);
    RestrictGroupsSource.AddGroup(UserItem);
  end;

  // If the token has restricting SIDs then check them. It can also contain
  // manually added items that are not part of the group list. Add them here.
  if Token.InfoClass.Query(tdTokenRestrictedSids) then
    with Token.InfoClass do
      for RestrInd := 0 to High(RestrictedSids) do
      begin
        Found := False;

        // Find and check it
        for ItemInd := 0 to ListViewRestrictSID.Items.Count - 1 do
          if RestrictedSids[RestrInd].SecurityIdentifier.SID =
            RestrictGroupsSource.Group[ItemInd].SecurityIdentifier.SID then
          begin
            ListViewRestrictSID.Items[ItemInd].Checked := True;
            Found := True;
            Break;
          end;

      // The restricting SID was not found in the list, add and check it
      if not Found then
        RestrictGroupsSource.AddGroup(RestrictedSids[RestrInd]).Checked := True;
    end;
end;

function TDialogRestrictToken.GetFlags: Cardinal;
const
  DISABLE_MAX_PRIVILEGE = 1;
  SANDBOX_INERT = 2;
  LUA_TOKEN = 4;
  WRITE_RESTRICTED = 8; // TODO: Check windows version, this value depends on it
begin
  Result := 0;
  if CheckBoxDisableMaxPriv.Checked then
    Result := Result or DISABLE_MAX_PRIVILEGE;
  if CheckBoxSandboxInert.Checked then
    Result := Result or SANDBOX_INERT;
  if CheckBoxLUA.Checked then
    Result := Result or LUA_TOKEN;
  if not CheckBoxWriteOnly.Checked then
    Result := Result or WRITE_RESTRICTED;
end;

procedure TDialogRestrictToken.ListViewRestrictSIDContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  with ListViewRestrictSID do
  begin
    // Only one item can be edited at a time
    MenuEdit.Enabled := (SelCount = 1);

    // Show context menu only if selection contains removable/editable items
    for i := 0 to Items.Count - 1 do
      if Items[i].Selected then
        Handled := Handled or RestrictGroupsSource.IsAdditional(i);

    Handled := not Handled;
  end;
end;

procedure TDialogRestrictToken.MenuEditClick(Sender: TObject);
begin
  with ListViewRestrictSID, RestrictGroupsSource do
    if Assigned(ListViewRestrictSID.Selected) then
      Group[ListViewRestrictSID.Selected.Index] := TDialogPickUser.Execute(Self,
        Group[Selected.Index]);
end;

procedure TDialogRestrictToken.MenuRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  with ListViewRestrictSID do
  begin
    // deletion changes indexes, go downwards
    for i := Items.Count - 1 downto 0 do
      if Items[i].Selected and RestrictGroupsSource.IsAdditional(i) then
        RestrictGroupsSource.RemoveGroup(i);
  end;
end;

end.
