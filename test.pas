program test;

{$mode objfpc}{$H+}

{$linklib libSGL.a}

uses Windows, SGL;

function WinMain (hInst : HINSTANCE; hPInst : HINSTANCE; cmdLine : PSTR; cmdShow : integer):integer;
var
  panel, btn: HWND;
begin
  SGL_Init(hInst, nil) ;

  panel:= SGL_New(0, SGL_PANEL, 0, PChar('SGL'), -1, -1) ;
  btn:= SGL_New(panel, SGL_CTRL_BUTTON, 0, PChar('Hello!'), 0, 0) ;
  SGL_Layout(panel) ;
  SGL_VisibleSet(panel, 1) ;

  SGL_Run() ;
  SGL_Exit() ;
  Result:= 0 ;
end;

begin
  WinMain(GetModuleHandle(nil), 0, PChar('test'), 0);
end.

