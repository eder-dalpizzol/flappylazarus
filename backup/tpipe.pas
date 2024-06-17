unit TPipe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  // TPipe class definition (only once)
  TPipe = class
  private
    FTopPipe: TPanel;
    FBottomPipe: TPanel;
    FGap: TPanel;
    FGapHeight, FGapPosition, FPipeWidth: Integer;
    procedure CreatePipes;
  public
    constructor Create(AParent: TWinControl; AGapHeight, APipeWidth: Integer);
    destructor Destroy; override;
    property TopPipe: TPanel read FTopPipe;
    property BottomPipe: TPanel read FBottomPipe;
    property Gap: TPanel read FGap;
  end;

implementation

constructor TPipe.Create(AParent: TWinControl; AGapHeight, APipeWidth: Integer);
begin
  inherited Create;
  FGapHeight := AGapHeight;
  FPipeWidth := APipeWidth;
  FTopPipe := TPanel.Create(AParent);
  FBottomPipe := TPanel.Create(AParent);
  FGap := TPanel.Create(AParent);
  CreatePipes;
end;

destructor TPipe.Destroy;
begin
  FTopPipe.Free;
  FBottomPipe.Free;
  FGap.Free;
  inherited Destroy;
end;

procedure TPipe.CreatePipes;
var
  pipeTopHeight, pipeBottomHeight: Integer;
begin
  // Calculate gap position and pipe heights
  FGapPosition := Random(FTopPipe.Parent.Height - 320) + 100;
  pipeTopHeight := FGapPosition;
  pipeBottomHeight := FTopPipe.Parent.Height - (FGapPosition + FGapHeight);

  // Configure Top Pipe
  with FTopPipe do
  begin
    Parent := FTopPipe.Parent;
    BevelColor := clGreen;
    Color := clLime;
    Width := FPipeWidth;
    Height := pipeTopHeight;
    Left := FTopPipe.Parent.Width;
    Top := 0;
    BevelInner := bvLowered;
    BevelWidth := 2;
    Tag := 10;
  end;

  // Configure Gap
  with FGap do
  begin
    Parent := FTopPipe.Parent;
    Color := clNone; // Or a suitable "sky" color
    Width := 3;
    Height := FGapHeight;
    Left := FTopPipe.Left + FPipeWidth - 3;
    Top := FGapPosition;
    BevelOuter := bvNone;
    Visible := False;
    Tag := 9;
  end;

  // Configure Bottom Pipe
  with FBottomPipe do
  begin
    Parent := FTopPipe.Parent;
    BevelColor := clGreen;
    Color := clLime;
    Width := FPipeWidth;
    Height := pipeBottomHeight;
    Left := FTopPipe.Left;
    Top := FGapPosition + FGapHeight;
    BevelInner := bvLowered;
    BevelWidth := 2;
    Tag := 10;
  end;
end;

end.
