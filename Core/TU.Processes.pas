unit TU.Processes;

interface

uses
  Winapi.Windows;

{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

const
  PROCESS_QUERY_LIMITED_INFORMATION = $1000;
  THREAD_QUERY_INFORMATION = $0040;
  NT_FILENAME_MAX = 32767;

type
  /// <summary> A record to store process information. </summary>
  TProcessItem = record
    ImageName: String;
    PID: Cardinal;
    ParentPID: Cardinal;
    CreateTime: Int64;
    HandleCount: Cardinal;
    SessionId: Cardinal;
    function QueryFullName: string; overload;
    class function QueryFullName(PID: Cardinal): string; overload; static;
  end;
  PProcessItem = ^TProcessItem;

  /// <summary> Stores a snapshot of all processes on the system. </summary>
  TProcessList = class
  protected
    FCount: integer;
    FItems: array of TProcessItem;
    function GetItem(i: integer): TProcessItem;
  public
    /// <summary> Create a snapshot of all processes on the system. </summary>
    /// <exception> This constructor doesn't raise any exceptions. </exception>
    constructor Create;

    property Items[i: integer]: TProcessItem read GetItem; default;
    property Count: integer read FCount;

    /// <summary> Obtains an executable name by a PID. </summary>
    function FindName(PID: Cardinal): String;

    /// <summary> Obtains a PID by an executable name. </summary>
    function FindPID(ImageName: String): Cardinal;
  end;

function QueryFullProcessImageNameW(hProcess: THandle; dwFlags: Cardinal;
  lpExeName: PWideChar; var lpdwSize: Cardinal): LongBool; stdcall;
  external kernel32;

implementation

uses
  TU.NativeAPI, TU.Common, System.SysUtils;

var
  FilenameBuffer: PWideChar;

{ TProcessList }

constructor TProcessList.Create;
var
  Buffer, SysInfo: PSystemProcessInformation;
  BufferSize: NativeUInt;
  ReturnLength: Cardinal;
  Status: NTSTATUS;
  i: integer;
begin
  Buffer := nil;
  BufferSize := 0;

  // TODO: Spanshot only processes of current session

  // Query the information or it's size until we pass a suitable buffer for a
  // system call or get an unexpected error
  while True do
  begin
    Status := NtQuerySystemInformation(SystemProcessInformation, Buffer,
      BufferSize, ReturnLength);
    if (Status = STATUS_BUFFER_TOO_SMALL) or
      (Status = STATUS_INFO_LENGTH_MISMATCH) then
    begin
      FreeMem(Buffer);

      // Do not allocate too big buffers.
      if ReturnLength > BUFFER_LIMIT then
      begin
        Status := STATUS_IMPLEMENTATION_LIMIT;
        Break;
      end;

      BufferSize := ReturnLength;
      Buffer := AllocMem(BufferSize);
    end
    else
      Break;
  end;

  // We have exited the loop. It means that we either succeeded (and the buffer
  // is valid) or failed (and the buffer should be cleaned up).

  if not NT_SUCCESS(Status) then
  begin
    FreeMem(Buffer);

    OutputDebugString(PChar(Format('Process snapshot failed with 0x%0.8x',
      [Status])));
    Exit;
  end;

  try
    FCount := 0;
    SysInfo := Buffer;

    // Count the processes
    while True do
    begin
      Inc(FCount);
      if SysInfo.NextEntryOffset = 0 then
        Break;
      SysInfo := @PByteArray(SysInfo)[SysInfo.NextEntryOffset];
    end;

    // Allocate memory
    SetLength(FItems, FCount);

    // Save each process information
    i := 0;
    SysInfo := Buffer;
    while True do
    with FItems[i] do
    begin
      SetString(ImageName, SysInfo.ImageName.Buffer,
        SysInfo.ImageName.Length div SizeOf(WChar));

      if ImageName = '' then
        ImageName := 'System Idle Process';

      PID := SysInfo.ProcessId;
      ParentPID := SysInfo.InheritedFromProcessId;
      CreateTime := SysInfo.CreateTime;
      HandleCount := SysInfo.HandleCount;
      SessionId := SysInfo.SessionId;

      if SysInfo.NextEntryOffset = 0 then
        Break;

      SysInfo := @PByteArray(SysInfo)[SysInfo.NextEntryOffset];
      Inc(i);
    end;
  finally
    FreeMem(Buffer);
  end;
end;

function TProcessList.FindName(PID: Cardinal): String;
var
  i: integer;
begin
  for i := 0 to High(FItems) do
    if FItems[i].PID = PID then
      Exit(FItems[i].ImageName);

  Result := 'Unknown process';
end;

function TProcessList.FindPID(ImageName: String): Cardinal;
var
  i: integer;
begin
  for i := 0 to High(FItems) do
    if FItems[i].ImageName = ImageName then
      Exit(FItems[i].PID);

  Result := 0;
end;

function TProcessList.GetItem(i: integer): TProcessItem;
begin
  Result := FItems[i];
end;

{ TProcessItem }

function TProcessItem.QueryFullName: string;
begin
  Result := QueryFullName(PID);
end;

class function TProcessItem.QueryFullName(PID: Cardinal): string;
var
  hProcess: THandle;
  BufferSize: Cardinal;
begin
  Result := '';

  hProcess := OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, False, PID);

  if hProcess <> 0 then
  begin
    BufferSize := NT_FILENAME_MAX;

    if QueryFullProcessImageNameW(hProcess, 0, FilenameBuffer, BufferSize) then
      SetString(Result, FilenameBuffer, BufferSize);

    CloseHandle(hProcess);
  end;
end;

initialization
  // We allocate the buffer for quering full process names only once to prevent
  // intensive re-allocations if the amount of processes on the system is high.
  GetMem(FilenameBuffer, (NT_FILENAME_MAX + 1) * SizeOf(WideChar));
finalization
  FreeMem(FilenameBuffer);
end.
