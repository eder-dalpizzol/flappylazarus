unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlGame: TPanel;
    pnlMain: TPanel;
    SpeedButton1: TSpeedButton;
    timerCreatePipe: TTimer;
    timerUpdate: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlGameClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure timerCreatePipeTimer(Sender: TObject);
    procedure createPipe;
    procedure timerUpdateTimer(Sender: TObject);
    function CheckCollision(pnl: TPanel): Boolean;
  private
    started: boolean;
    jumpMax: Integer;
    jumpSpeed, velocityUpdateCounter: integer;

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.timerCreatePipeTimer(Sender: TObject);
begin
  if started then
    createPipe;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var Score: String;
begin
//
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  jumpSpeed := 0;
  velocityUpdateCounter := 0;
  started :=false;
end;

procedure TfrmMain.pnlGameClick(Sender: TObject);
begin

end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  started := true;
  if jumpSpeed > 5 then
    jumpSpeed := jumpSpeed - 10
  else
  if jumpSpeed > 2 then
    jumpSpeed := jumpSpeed - 7
  else
    jumpSpeed := jumpSpeed -5;
end;


procedure TfrmMain.createPipe;
var
  pipeTop, pipeBottom, gap: TPanel;
  gapHeight, gapPosition, pipeTopHeight, pipeBottomHeight, pipeWidth: integer;
begin
  // Definindo a altura do gap e sua posição vertical
  gapHeight := 200; // Altura do espaço entre os pipes
  gapPosition := Random(frmMain.Height - 400) + 100; // Posição vertical do gap

  // Calculando a altura do pipe superior e inferior
  pipeTopHeight := gapPosition;
  pipeBottomHeight := frmMain.Height - (gapPosition + gapHeight);

  pipeWidth := 80;
  // Criando o pipe superior
  pipeTop := TPanel.Create(Self);
  pipeTop.Parent := pnlMain;
  pipeTop.BevelColor := clgreen;
  pipeTop.Color := clLime;
  pipeTop.Width := pipeWidth;
  pipeTop.Height := pipeTopHeight;
  pipeTop.Left := frmMain.Width;
  pipeTop.Top := 0;
  pipeTop.BevelInner := bvLowered;
  pipeTop.BevelWidth := 5;
  pipeTop.Tag:= 10;

  // Criando o gap
  gap := TPanel.Create(Self);
  gap.Parent := pnlMain;
  gap.Color := clNone; // Defina para uma cor que represente o "céu" ou mantenha clDefault
  gap.Width := 3;
  gap.Height := gapHeight;
  gap.Left := frmMain.Width+pipeWidth-3;
  gap.Top := pipeTopHeight;
  gap.BevelOuter := bvNone;
  gap.Visible:=false;
  gap.tag := 9;

  // Criando o pipe inferior
  pipeBottom := TPanel.Create(Self);
  pipeBottom.Parent := pnlMain;
  pipeBottom.BevelColor := clgreen;
  pipeBottom.Color := clLime;
  pipeBottom.Width := pipeWidth;
  pipeBottom.Height := pipeBottomHeight;
  pipeBottom.Left := frmMain.Width;
  pipeBottom.Top := gapPosition + gapHeight;
  pipeBottom.BevelInner := bvLowered;
  pipeBottom.BevelWidth := 5;
  pipeBottom.Tag:= 10;

  // O evento OnClick aplica-se aos pipes, se necessário
  //pipeTop.OnClick := @Button1Click;
  //pipeBottom.OnClick := @Button1Click;
end;


procedure TfrmMain.timerUpdateTimer(Sender: TObject);
var
  panel: TPanel;

  procedure MovePipes;
  var i: integer;
  begin
    for i := ComponentCount - 1 downto 0 do
    begin
      if ((Components[i] is TPanel) and (Components[i].Tag in [9,10]))  then
      begin
        panel := TPanel(Components[i]);


        panel.Left := panel.Left - 5;

        if CheckCollision(panel) then
        begin
            if panel.Tag = 10 then
              Close
            else
            if panel.tag = 9 then
              Label1.Caption  := IntToStr(StrToInt(Label1.Caption) + 1);
        end;

        if panel.Left < (panel.Width * -1) then
        begin
          panel.Free;
        end;

      end;
    end;
  end;

  procedure applyPhysics;
  var
    i: Integer;
    panel: TPanel;
  begin
    inc(velocityUpdateCounter);
    if velocityUpdateCounter > 6 then
    begin
      jumpSpeed := jumpSpeed + 1;
      velocityUpdateCounter := 0;
    end;

    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TPanel) then
      begin
        panel := TPanel(Components[i]);

        if panel.Tag = 2 then   //player
        begin
          panel.Top := panel.Top + jumpSpeed;

          if panel.Top + panel.Height > Self.Height then
          begin
            panel.Top := Self.Height - panel.Height;
          end;
        end;
      end;
    end;
  end;

begin

  if started then
  begin
    applyPhysics;
    MovePipes;
  end;

end;



function TfrmMain.CheckCollision(pnl: TPanel): Boolean;
var
  Panel1Rect, Panel2Rect: TRect;
  MovingPanel, FixedPanel: TPanel;

  function RectsOverlap(const Rect1, Rect2: TRect): Boolean;
  begin
    Result := not ((Rect1.Right < Rect2.Left) or (Rect1.Left > Rect2.Right) or
                   (Rect1.Bottom < Rect2.Top) or (Rect1.Top > Rect2.Bottom));
  end;
begin
  FixedPanel := pnlGame;

  Panel1Rect := Rect(FixedPanel.Left, FixedPanel.Top, FixedPanel.Left + FixedPanel.Width, FixedPanel.Top + FixedPanel.Height);


  MovingPanel := pnl;

    Panel2Rect := Rect(MovingPanel.Left, MovingPanel.Top, MovingPanel.Left + MovingPanel.Width, MovingPanel.Top + MovingPanel.Height);

    result := RectsOverlap(Panel1Rect, Panel2Rect);


end;

end.

