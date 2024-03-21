unit uMenu;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls, uGame;

type

  { TfrmMenu }

  TfrmMenu = class(TForm)
    Image1: TImage;
    imglist: TImageList;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private

  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

procedure TfrmMenu.SpeedButton1Click(Sender: TObject);
begin
  try
    frmGame:=TfrmGame.Create(Self);
    try
      frmGame.ShowModal;
    finally
      frmGame.Release;
      frmGame:=nil;
    end;
  finally
    FreeAndNil(frmGame);
  end;

end;

end.

