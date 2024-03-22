unit uGame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, BGRAImageList, BCLabel, BGRASpeedButton, RTTICtrls;

type

  { TfrmGame }

  TfrmGame = class(TForm)
    Label1: TLabel;
    lbl: TBCLabel;
    BGRAImageList1: TBGRAImageList;
    bird: TImage;
    Panel1: TPanel;
    pnlMain: TPanel;
    SpeedButton1: TSpeedButton;
    timerCreatePipe: TTimer;
    timerUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure timerCreatePipeTimer(Sender: TObject);
    procedure createPipe;
    procedure timerUpdateTimer(Sender: TObject);
    function CheckCollision(pnl: TPanel): Boolean;
    function CheckCollision(img: TImage): Boolean;
    function RectsOverlap(const Rect1, Rect2: TRect): Boolean;
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

  procedure moveBg;
  var i: integer;
      bg: TImage;
  begin
    for i := ComponentCount - 1 downto 0 do
    begin
      if (Components[i] is TImage) and (TImage(Components[i]).Tag = 3) then
      begin
        bg := TImage(Components[i]);
        bg.Left := bg.Left - 1;

        if bg.Left <= (bg.Width * -1) then
        begin
          bg.Free;
        end;
      end;
    end;
  end;


begin
  if started then
  begin
    moveBg;
    createPipe;
  end;
end;

procedure TfrmGame.FormCreate(Sender: TObject);
  procedure createBg;
  var i, Left: integer;
      bg: TImage;
  begin
    Left  := 0;
    for i := 0 to 3 do
    begin
      bg := TImage.Create(Self);
      bg.Parent := pnlMain;
      bg.imageindex := 1; 
      bg.Images := BGRAImageList1;
      bg.Left := Left;
      bg.Top := 0;
      bg.Width := 601;
      bg.Height := 1000;
      bg.Tag := 3;
      bg.ImageWidth := 601;
      bg.SendToBack;

      Left := Left + 601;
    end;

  end;
begin
  createBg;
  jumpSpeed := 0;
  velocityUpdateCounter := 0;
  started :=false;
end;

procedure TfrmGame.Label1Click(Sender: TObject);
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

procedure TfrmGame.createPipe;
var
  pipeTop, pipeBottom, gap: TPanel;
  gapHeight, gapPosition, pipeTopHeight, pipeBottomHeight, pipeWidth: integer;
  beerTop, beerBot: TImage;
begin
  // the height of the gap
  gapHeight := 200; // Altura do espaço entre os pipes
  gapPosition := Random(frmGame.Height - 400) + 100; // Posição vertical do gap

  // Calculating the height of the superior  and inferior pipe
  pipeTopHeight := gapPosition;
  pipeBottomHeight := frmGame.Height - (gapPosition + gapHeight);

  pipeWidth := 100;

  beerTop := TImage.Create(Self);
  beerTop.Parent := pnlMain;
  beerTop.Width := 100;
  beerTop.Height := 300;
  beerTop.imageindex := 2;
  beerTop.Images := BGRAImageList1;
  beerTop.Imagewidth := 300;
  beerTop.Top := pipeTopHeight - beerTop.Height;
  beerTop.Left := frmGame.Width;
  beerTop.Visible := true;
  beerTop.Tag := 10;

   //Creating the top pipe
   //pipeTop := TPanel.Create(Self);
   //pipeTop.Parent := pnlMain;
   //pipeTop.BevelColor := clgreen;
   //pipeTop.Color := clLime;
   //pipeTop.Width := round(pipeWidth/4);
   //pipeTop.Height := pipeTopHeight - 280;
   //pipeTop.Left := frmGame.Width + Round(pipeWidth / 3);
   //pipeTop.Top := 0;
   //pipeTop.BevelInner := bvLowered;
   //pipeTop.BevelWidth := 2;
   //pipeTop.Tag:= 10;

  // Creating the gap
  gap := TPanel.Create(Self);
  gap.Parent := pnlMain;
  gap.Color := clBlack;
  gap.Width := 3;
  gap.Height := gapHeight;
  gap.Left := frmGame.Width+pipeWidth-3;
  gap.Top := pipeTopHeight;
  gap.BevelOuter := bvNone;
  gap.Visible:=false;
  gap.tag := 9;

  beerBot := TImage.Create(Self);
  beerBot.Parent := pnlMain;
  beerBot.Width := 100;
  beerBot.Height := 300;
  beerBot.imageindex := 3;
  beerBot.Images := BGRAImageList1;
  beerBot.Imagewidth := 300;
  beerBot.Top := gapPosition + gapHeight;
  beerBot.Left := frmGame.Width;
  beerBot.Visible := true;
  beerBot.Tag := 10;

  // Criando o pipe inferior
  //pipeBottom := TPanel.Create(Self);
  //pipeBottom.Parent := pnlMain;
  //pipeBottom.BevelColor := clgreen;
  //pipeBottom.Color := clLime;
  //pipeBottom.Width := pipeWidth;
  //pipeBottom.Height := pipeBottomHeight;
  //pipeBottom.Left := frmGame.Width;
  //pipeBottom.Top := gapPosition + gapHeight;
  //pipeBottom.BevelInner := bvLowered;
  //pipeBottom.BevelWidth := 2;
  //pipeBottom.Tag:= 10;

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

              // Label1.Caption  := IntToStr(StrToInt(Label1.Caption) + 1);
              // lbl.Caption  := FloatToStr(round((strtoint(Label1.Caption)) / 9));
              lbl.Caption  := IntToStr((strtoint(lbl.Caption) + 1));
              panel.free;
              Break;
            end;
        end;

        if panel.Left < (panel.Width * -1) then
        begin
          panel.Free;
        end;

        //panel.free;
      end;

      if (Components[i] is TImage) and (TImage(Components[i]).Tag = 10) then
      begin
        TImage(Components[i]).Left := TImage(Components[i]).Left - 5;

        if CheckCollision(TImage(Components[i])) then
        begin
            if TImage(Components[i]).Tag = 10 then
              Close ;
        end;

        if TImage(Components[i]).Left < (TImage(Components[i]).Width * -1) then
        begin
          TImage(Components[i]).Free;
        end;
      end;
    end;
  end;

  procedure applyPhysics;
  var
    i: Integer;
  begin
    inc(velocityUpdateCounter);
    if velocityUpdateCounter > 6 then
    begin
      jumpSpeed := jumpSpeed + 1;
      velocityUpdateCounter := 0;
    end;

    for i := 0 to ComponentCount - 1 do
    begin
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
begin
  BirdRect := bird;

  Panel1Rect := Rect(BirdRect.Left, BirdRect.Top, BirdRect.Left + BirdRect.Width, BirdRect.Top + BirdRect.Height);


  MovingPanel := pnl;

  Panel2Rect := Rect(MovingPanel.Left, MovingPanel.Top, MovingPanel.Left + MovingPanel.Width, MovingPanel.Top + MovingPanel.Height);

  result := RectsOverlap(Panel1Rect, Panel2Rect);
end;

function TfrmGame.CheckCollision(img: TImage): Boolean;
var
  Panel1Rect, Panel2Rect: TRect;
  MovingPanel: TImage;
  BirdRect: TImage;
begin
  BirdRect := bird;

  Panel1Rect := Rect(BirdRect.Left, BirdRect.Top, BirdRect.Left + BirdRect.Width, BirdRect.Top + BirdRect.Height);


  MovingPanel := img;

  Panel2Rect := Rect(MovingPanel.Left, MovingPanel.Top, MovingPanel.Left + MovingPanel.Width, MovingPanel.Top + MovingPanel.Height);

  result := RectsOverlap(Panel1Rect, Panel2Rect);
end;

function TfrmGame.RectsOverlap(const Rect1, Rect2: TRect): Boolean;
begin
     Result := not ((Rect1.Right < Rect2.Left) or (Rect1.Left > Rect2.Right) or
                 (Rect1.Bottom < Rect2.Top) or (Rect1.Top > Rect2.Bottom));
end;

end.

