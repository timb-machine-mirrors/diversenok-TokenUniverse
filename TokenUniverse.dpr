program TokenUniverse;

uses
  Vcl.Forms,
  TU.Common in 'Core\TU.Common.pas',
  TU.Handles in 'Core\TU.Handles.pas',
  TU.NativeAPI in 'Core\TU.NativeAPI.pas',
  TU.Processes in 'Core\TU.Processes.pas',
  TU.Tokens in 'Core\TU.Tokens.pas',
  UI.TokenListFrame in 'UI\UI.TokenListFrame.pas' {FrameTokenList: TFrame},
  UI.MainForm in 'UI\UI.MainForm.pas' {FormMain},
  UI.Modal.AccessAndType in 'UI\UI.Modal.AccessAndType.pas' {DialogAccessAndType},
  UI.HandleSearch in 'UI\UI.HandleSearch.pas' {FormHandleSearch},
  UI.Information in 'UI\UI.Information.pas' {InfoDialog},
  UI.ProcessList in 'UI\UI.ProcessList.pas' {ProcessListDialog},
  UI.Run in 'UI\UI.Run.pas' {RunDialog},
  TU.Tokens.Winapi in 'Core\TU.Tokens.Winapi.pas',
  TU.RestartSvc in 'Core\TU.RestartSvc.pas',
  TU.DebugLog in 'Core\TU.DebugLog.pas',
  TU.WtsApi in 'Core\TU.WtsApi.pas',
  TU.Suggestions in 'Core\TU.Suggestions.pas',
  UI.SessionDialog in 'UI\UI.SessionDialog.pas' {SessionDialog},
  UI.Restrict in 'UI\UI.Restrict.pas' {DialogRestrictToken},
  UI.ListViewEx in 'UI\UI.ListViewEx.pas',
  UI.Colors in 'UI\UI.Colors.pas',
  UI.Prototypes in 'UI\UI.Prototypes.pas',
  TU.Credentials in 'Core\TU.Credentials.pas',
  UI.Logon in 'UI\UI.Logon.pas' {LogonDialog},
  TU.LsaApi in 'Core\TU.LsaApi.pas',
  UI.Prototypes.ChildForm in 'UI\UI.Prototypes.ChildForm.pas';

{$R *.res}

begin
  // Running as a service
  if ParamStr(1) = RESVC_PARAM then
  begin
    ReSvcServerMain;
    Exit;
  end;

  // The user delegated us to create a service
  if ParamStr(1) = DELEGATE_PARAM then
  begin
    ReSvcCreateService;
    Exit;
  end;

  // Normal mode
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Token Universe';
  Application.HintHidePause := 20000;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
