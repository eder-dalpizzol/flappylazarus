unit uGame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, BGRAImageList, RTTICtrls;

type

  { TfrmGame }

  TfrmGame = class(TForm)
    BGRAImageList1: TBGRAImageList;
    bird: TImage;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    pnlMain: TPanel;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    timerCreatePipe: TTimer;
    timerUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TIImage1Click(Sender: TObject);
    procedure timerCreatePipeTimer(Sender: TObject);
    procedure createPipe;
    procedure timerUpdateTimer(Sender: TObject);
    function CheckCollision(pnl: TPanel): Boolean;
  private
    started: boolean;
    jumpSpeed, velocityUpdateCounter: integer;

  public

  end;

var
  frmGame: TfrmGame;

implementation

{$R *.lfm}

{ TfrmGame }

procedure TfrmGame.timerCreatePipeTimer(Sender: TObject);
begin
  if started then
    createPipe;
end;

procedure TfrmGame.FormCreate(Sender: TObject);
begin
  jumpSpeed := 0;
  velocityUpdateCounter := 0;
  started :=false;
end;

procedure TfrmGame.Panel1Click(Sender: TObject);
begin

end;

procedure TfrmGame.SpeedButton1Click(Sender: TObject);
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

procedure TfrmGame.TIImage1Click(Sender: TObject);
begin

end;


procedure TfrmGame.createPipe;
var
  pipeTop, pipeBottom, gap: TPanel;
  gapHeight, gapPosition, pipeTopHeight, pipeBottomHeight, pipeWidth: integer;
begin
  // Definindo a altura do gap e sua posição vertical
  gapHeight := 200; // Altura do espaço entre os pipes
  gapPosition := Random(frmGame.Height - 400) + 100; // Posição vertical do gap

  // Calculando a altura do pipe superior e inferior
  pipeTopHeight := gapPosition;
  pipeBottomHeight := frmGame.Height - (gapPosition + gapHeight);

  pipeWidth := 80;
  // Criando o pipe superior
  pipeTop := TPanel.Create(Self);
  pipeTop.Parent := pnlMain;
  pipeTop.BevelColor := clgreen;
  pipeTop.Color := clLime;
  pipeTop.Width := pipeWidth;
  pipeTop.Height := pipeTopHeight;
  pipeTop.Left := frmGame.Width;
  pipeTop.Top := 0;
  pipeTop.BevelInner := bvLowered;
  pipeTop.BevelWidth := 2;
  pipeTop.Tag:= 10;

  // Criando o gap
  gap := TPanel.Create(Self);
  gap.Parent := pnlMain;
  gap.Color := clNone; // Defina para uma cor que represente o "céu" ou mantenha clDefault
  gap.Width := 3;
  gap.Height := gapHeight;
  gap.Left := frmGame.Width+pipeWidth-3;
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
  pipeBottom.Left := frmGame.Width;
  pipeBottom.Top := gapPosition + gapHeight;
  pipeBottom.BevelInner := bvLowered;
  pipeBottom.BevelWidth := 2;
  pipeBottom.Tag:= 10;

  // O evento OnClick aplica-se aos pipes, se necessário
  //pipeTop.OnClick := @Button1Click;
  //pipeBottom.OnClick := @Button1Click;
end;


procedure TfrmGame.timerUpdateTimer(Sender: TObject);
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
            begin

              Label1.Caption  := IntToStr(StrToInt(Label1.Caption) + 1);
              Label2.Caption  := FloatToStr(round((strtoint(Label1.Caption)) / 9));
            end;
        end;

        if panel.Left < (panel.Width * -1) then
        begin
          panel.Free;
        end;

      end;
      if (Components[i] is TImage) and (TImage(Components[i]).Tag = 3) then
      begin
        TImage(Components[i]).Left := TImage(Components[i]).Left - 1;
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
      if (Components[i] is TImage) then
      begin


        if TImage(Components[i]).Tag = 2 then   //player
        begin
          TImage(Components[i]).Top := TImage(Components[i]).Top + jumpSpeed;

          if TImage(Components[i]).Top + TImage(Components[i]).Height > Self.Height then
          begin
            TImage(Components[i]).Top := Self.Height - TImage(Components[i]).Height;
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



function TfrmGame.CheckCollision(pnl: TPanel): Boolean;
var
  Panel1Rect, Panel2Rect: TRect;
  MovingPanel: TPanel;
  BirdRect: TImage;

  function RectsOverlap(const Rect1, Rect2: TRect): Boolean;
  begin
       Result := not ((Rect1.Right < Rect2.Left) or (Rect1.Left > Rect2.Right) or
                   (Rect1.Bottom < Rect2.Top) or (Rect1.Top > Rect2.Bottom));
  end;
begin
  BirdRect := bird;

  Panel1Rect := Rect(BirdRect.Left, BirdRect.Top, BirdRect.Left + BirdRect.Width, BirdRect.Top + BirdRect.Height);


  MovingPanel := pnl;

  Panel2Rect := Rect(MovingPanel.Left, MovingPanel.Top, MovingPanel.Left + MovingPanel.Width, MovingPanel.Top + MovingPanel.Height);

  result := RectsOverlap(Panel1Rect, Panel2Rect);
end;

end.

