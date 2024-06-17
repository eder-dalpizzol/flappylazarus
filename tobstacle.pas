unit TObstacle; // Renamed from TPipe

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  // TObstacle class definition (renamed from TPipe)
  TObstacle = class
  private
    FTopObstacle: TPanel;
    FBottomObstacle: TPanel;
    FGap: TPanel;
    FGapHeight, FGapPosition, FObstacleWidth: Integer;
    procedure CreateObstacles; // Renamed from CreatePipes
  public
    constructor Create(AParent: TWinControl; AGapHeight, AObstacleWidth: Integer);
    destructor Destroy; override;
    property TopObstacle: TPanel read FTopObstacle; // Renamed from TopPipe
    property BottomObstacle: TPanel read FBottomObstacle; // Renamed from BottomPipe
    property Gap: TPanel read FGap;
  end;

implementation

constructor TObstacle.Create(AParent: TWinControl; AGapHeight, AObstacleWidth: Integer);
begin
  inherited Create;
  FGapHeight := AGapHeight;
  FObstacleWidth := AObstacleWidth;
  FTopObstacle := TPanel.Create(AParent);
  FBottomObstacle := TPanel.Create(AParent);
  FGap := TPanel.Create(AParent);
  CreateObstacles; // Call the internal obstacle creation method
end;

destructor TObstacle.Destroy;
begin
  FTopObstacle.Free;
  FBottomObstacle.Free;
  FGap.Free;
  inherited Destroy;
end;

procedure TObstacle.CreateObstacles; // Renamed from CreatePipes
var
  obstacleTopHeight, obstacleBottomHeight: Integer;
begin
  // Calculate gap position and obstacle heights
  FGapPosition := Random(FTopObstacle.Parent.Height - 320) + 100;
  obstacleTopHeight := FGapPosition;
  obstacleBottomHeight := FTopObstacle.Parent.Height - (FGapPosition + FGapHeight);

  // Configure Top Obstacle
  with FTopObstacle do
  begin
    Parent := FTopObstacle.Parent;
    BevelColor := clGreen;
    Color := clLime;
    Width := FObstacleWidth;
    Height := obstacleTopHeight;
    Left := FTopObstacle.Parent.Width;
    Top := 0;
    BevelInner := bvLowered;
    BevelWidth := 2;
    Tag := 10;
  end;

  // Configure Gap
  with FGap do
  begin
    Parent := FTopObstacle.Parent;
    Color := clNone; // Or a suitable "sky" color
    Width := 3;
    Height := FGapHeight;
    Left := FTopObstacle.Left + FObstacleWidth - 3;
    Top := FGapPosition;
    BevelOuter := bvNone;
    Visible := False;
    Tag := 9;
  end;

  // Configure Bottom Obstacle
  with FBottomObstacle do
  begin
    Parent := FTopObstacle.Parent;
    BevelColor := clGreen;
    Color := clLime;
    Width := FObstacleWidth;
    Height := obstacleBottomHeight;
    Left := FTopObstacle.Left;
    Top := FGapPosition + FGapHeight;
    BevelInner := bvLowered;
    BevelWidth := 2;
    Tag := 10;
  end;
end;

end.
