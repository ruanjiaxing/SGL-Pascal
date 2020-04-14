
unit sgl;

{$mode objfpc}

interface

uses Windows;

{
  Automatically converted by H2Pas 1.0.0 from sgl.h
  The following command line parameters were used:
    -d
    -p
    sgl.h
}

  { Pointers to basic pascal types, inserted by h2pas conversion program.}
  Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;

  Type
  Pchar  = ^char;
  PCOLORREF  = ^COLORREF;
  PPOINT  = ^POINT;
  PRECT  = ^RECT;
  PSYSTEMTIME  = ^SYSTEMTIME;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {------------------------------------------------------------------------------------------------
  
  SGL (Small GUI Library) is a graphical user interface library that will help you to build Win32 
  applications. It handle most of the burden of the Windows environment and lets you concentrate on 
  creative tasks.
  
  It allows you to easily draw or paint you own objects without having to restart from scratch.
  It introduces almost no new concepts and uses as far as possible the ones of Windows.
  
  Features:
   - attribute inheritance
   - homogeneous set of functions
   - possibility to draw and paint your own controls
  
  Position
  	For top windows, negative coordinates centers the window on the screen; positive values 
  	are pixel coordinates. For other windows and controls, position are grid coordinates.
  	Fine adjustement is posible with alignment and padding control.
  
  Size
  	Positive values are pixel dimensions.
  	For some controls:
  	- null values set automatically the size,
  	- negative values are relative dimensions.
  ------------------------------------------------------------------------------------------------ }
  {---- Public definitions for the SGL kernel ---- }
{$define OEMRESOURCE}  

  const
    SGL_PANEL = 1000;    
    SGL_HIDDENFRAME = SGL_PANEL+1;    
    SGL_ROUNDEDFRAME = SGL_PANEL+2;    

  function SGL_PanelIpaddingSet(hwnd:HWND; ipad:PRECT):longint;cdecl;external;

  function SGL_PanelIpaddingGet(hwnd:HWND; ipad:PRECT):longint;cdecl;external;


  type

    SGL_RESIZECB = function (hwnd:HWND; wOffset:longint; hOffset:longint):longint;cdecl;

  function SGL_ResizeInstall(hwnd:HWND; widthMin:longint; heightMin:longint; resizeCB:SGL_RESIZECB):longint;cdecl;external;

  const
    NONE = 0;    
    STD = 1;    
    ERR = 2;    
    FATAL = 3;    
    QUIT = 4;    

  procedure SGL_Log(mask:longint; fmt:Pchar; args:array of const);cdecl;external;

  procedure SGL_Fatal(_file:Pchar; line:longint; diag:Pchar);cdecl;external;

  procedure SGL_Error(_file:Pchar; line:longint; eresult:longint);cdecl;external;

  { /* Macro returning the number of elements of an array	*/ }
  { #define NELEMS(a) (sizeof(a) / sizeof((a)[0])) }
  {  }
  { /* Macro to check a pointer								*/ }
  { #define PCHECK(p) if ((p) == NULL) SGL_Fatal(__FILE__, __LINE__, "ALLOCATION") ; }
  {  }
  { /* Macro to check the result of a SGL function			*/ }
  { #define CHKERR(m)  SGL_Error(__FILE__, __LINE__, (m)) ;  }
  {  }
  { /* Macro to log an execution time						*/ }
  { #define GCLK(m)  double _t_t = SGL_Timer() ; m ; _t_t = SGL_Timer() - _t_t ; \ }
  { SGL_Log(STD, ":CLK: %-50.50s :%12.4f ms", #m, 1.e3 * _t_t) ; }
  {============== CONSTANT DEFINITIONS ============== }
  { Error codes (< 0)  }
  { internal error							 }
  const
    SGL_ERR_INT = -(1);    
  { allocation error							 }
    SGL_ERR_ALLOC = -(2);    
  { not compatible object					 }
    SGL_ERR_TYPE = -(3);    
  { 1st parameter error						 }
    SGL_ERR_PARM = -(4);    
  { Font attributes [these values are array indexes]  }
    SGL_FONT_NORMAL = 1;    
  { values for SGL_FONT_OPTION				 }
    SGL_FONT_FIXED = 0;    
    SGL_FONT_BOLD = 2;    
    SGL_FONT_ITALIC = 3;    
    SGL_FONT_SYMBOL = 4;    
    SGL_FONT_EXTRA = 5;    
  { values for SGL_FONT_SIZEIX				 }
    SGL_FONT_SMALL = 0;    
    SGL_FONT_LARGE = 2;    
    SGL_FONT_BIG = 3;    
  { Alignment attributes (16 lsb)  }
    SGL_CENTER = 0;    
    SGL_LEFT = 1;    
    SGL_RIGHT = 2;    
    SGL_TOP = SGL_LEFT shl 8;    
    SGL_BOTTOM = SGL_RIGHT shl 8;    
  { Frame border style  }
    SGL_BORDER_NONE = 0;    
    SGL_BORDER_FLAT = 1;    
    SGL_BORDER_RFLAT = 2;    
    SGL_BORDER_BEVEL_UP = 3;    
    SGL_BORDER_BEVEL_DOWN = 4;    
    SGL_BORDER_ETCHED_UP = 5;    
    SGL_BORDER_ETCHED_DOWN = 6;    
  { Size constants	 }
    SGL_WIDTH = 101;    
    SGL_HEIGHT = SGL_WIDTH+1;    
  { Color handling
  
  	Color are defined according to the win32 API, ie:  COLORREF yellow = RGB(255,255,0).
  	System colors are defined by adding 0x80000000 to the GetSysColor() argument.
  	The special value -1 is used to indicate that the object will inherit the color of its parent.
  
   }
    SGL_SYSCOLOR = $80000000;    
    SGL_LTGRAY = SGL_SYSCOLOR or COLOR_BTNFACE;    
    SGL_GRAY = SGL_SYSCOLOR or COLOR_BTNSHADOW;    
    SGL_BLACK = 0;    
    SGL_WHITE = $00ffffff;    
  { Keyboard & mouse status  }
  
  {$MACRO ON}
  
  {$define SGL_KEY_SHIFT:=(GetKeyState(VK_SHIFT) < 0)}
  {$define SGL_KEY_CTRL:=(GetKeyState(VK_CONTROL) < 0)}
  {$define SGL_LBUTTON:=(GetKeyState(VK_LBUTTON) < 0)}
  {$define SGL_MBUTTON:=(GetKeyState(VK_MBUTTON) < 0)}
  {$define SGL_RBUTTON:=(GetKeyState(VK_RBUTTON) < 0)}
  
  {========================================= TYPES == }

  type

    SGL_CB = function (hwnd:HWND; event:UINT; wParam:WPARAM; lParam:LPARAM):longint;cdecl;
    PSGL_CB  = ^SGL_CB;
  { 
  	A callback should return 1 for the fully processed events, and 0 when standard processing
  	is required.
   }
  { context for user drawn objects				 }
  { object status								 }
  { foreground & background dimmed colors		 }
  { text attributes								 }

    PSGL_CONTEXT_T = ^SGL_CONTEXT_T;
    SGL_CONTEXT_T = record
        selected : longint;
        dimmed : longint;
        bgdColor : COLORREF;
        fgdColor : COLORREF;
        fontSizeIx : longint;
        fontStyle : longint;
      end;
  {===================================== FUNCTIONS == }

  Type
    HINSTANCE = HANDLE;
  
  procedure SGL_Init(hInstance:HINSTANCE; iconRsc:Pchar);cdecl;external;

  procedure SGL_Exit;cdecl;external;

  function SGL_New(parent:HWND; _type:longint; style:DWORD; title:Pchar; left:longint; 
             top:longint):HWND;cdecl;external;

  function SGL_Duplicate(parentDest:HWND; childSource:HWND; title:Pchar; left:longint; top:longint):HWND;cdecl;external;

  function SGL_Timer:double;cdecl;external;

  procedure SGL_Layout(hwnd:HWND);cdecl;external;

  function SGL_Redraw(hwnd:HWND):longint;cdecl;external;

  function SGL_Run:longint;cdecl;external;

  procedure SGL_Destroy(hwnd:HWND);cdecl;external;

  { set/get functions		 }
  function SGL_RefSizeGet:longint;cdecl;external;

  procedure SGL_DefPaddingSet(l:longint);cdecl;external;

  function SGL_DefPaddingGet:longint;cdecl;external;

  function SGL_FontLoad(fName:Pchar):longint;cdecl;external;

  function SGL_FontFaceSet(option:longint; name:Pchar):longint;cdecl;external;

  function SGL_FontSizeSet(sizeIx:longint; size:longint):longint;cdecl;external;

  function SGL_FontFaceGet(option:longint; name:Pchar):longint;cdecl;external;

  function SGL_FontHandleGet(hwnd:HWND; sizeIx:longint; option:longint):HFONT;cdecl;external;

  function SGL_FontSizeGet(hwnd:HWND):longint;cdecl;external;

  function SGL_FontHeightGet(hwnd:HWND):longint;cdecl;external;

  function SGL_FontSizeIxSet(hwnd:HWND; sizeIx:longint):longint;cdecl;external;

  function SGL_FontSizeIxGet(hwnd:HWND):longint;cdecl;external;

  function SGL_FontStyleSet(hwnd:HWND; option:longint):longint;cdecl;external;

  function SGL_FontStyleGet(hwnd:HWND):longint;cdecl;external;

  function SGL_PositionSet(hwnd:HWND; left:longint; top:longint):longint;cdecl;external;

  function SGL_PositionGet(hwnd:HWND; left:Plongint; top:Plongint):longint;cdecl;external;

  function SGL_SizeSet(hwnd:HWND; sizeID:longint; size:longint):longint;cdecl;external;

  function SGL_SizeGet(hwnd:HWND; sizeID:longint; size:Plongint):longint;cdecl;external;

  const
    SGL_SAVE_POSITION = 1;    
    SGL_SAVE_SIZE = 2;    

  function SGL_LayoutConfigure(hwnd:HWND; section:Pchar; op:longint):longint;cdecl;external;

  function SGL_AlignmentSet(hwnd:HWND; align:longint):longint;cdecl;external;

  function SGL_AlignmentGet(hwnd:HWND):longint;cdecl;external;

  function SGL_PaddingSet(hwnd:HWND; padding:PRECT):longint;cdecl;external;

  function SGL_PaddingGet(hwnd:HWND; padding:PRECT):longint;cdecl;external;

  function SGL_VisibleSet(hwnd:HWND; visible:longint):longint;cdecl;external;

  function SGL_VisibleGet(hwnd:HWND):longint;cdecl;external;

  procedure SGL_DebugSet(hwnd:HWND; debugLevel:longint);cdecl;external;

  function SGL_DebugGet(hwnd:HWND):longint;cdecl;external;

  function SGL_CursorPositionSet(hwnd:HWND; pt:PPOINT):longint;cdecl;external;

  function SGL_CursorPositionGet(hwnd:HWND; current:longint; pt:PPOINT):longint;cdecl;external;

  function SGL_TitleSet(hwnd:HWND; title:Pchar):longint;cdecl;external;

  function SGL_TitleGet(hwnd:HWND; title:PPchar):longint;cdecl;external;

  function SGL_DimmedSet(hwnd:HWND; dimmed:longint):longint;cdecl;external;

  function SGL_DimmedGet(hwnd:HWND):longint;cdecl;external;

  function SGL_BGcolorSet(hwnd:HWND; color:COLORREF):longint;cdecl;external;

  function SGL_BGcolorGet(hwnd:HWND):longint;cdecl;external;

  function SGL_FGcolorSet(hwnd:HWND; color:COLORREF):longint;cdecl;external;

  function SGL_FGcolorGet(hwnd:HWND):longint;cdecl;external;

  function SGL_BorderStyleSet(hwnd:HWND; style:longint):longint;cdecl;external;

  function SGL_BorderStyleGet(hwnd:HWND):longint;cdecl;external;

  function SGL_BorderThicknessSet(hwnd:HWND; e:longint):longint;cdecl;external;

  function SGL_BorderThicknessGet(hwnd:HWND; e:Plongint):longint;cdecl;external;

  function SGL_BorderColorSet(hwnd:HWND; color:COLORREF):longint;cdecl;external;

  function SGL_BorderColorGet(hwnd:HWND; color:PCOLORREF):longint;cdecl;external;

  function SGL_BorderDraw(hdc:HDC; rect:PRECT; style:longint; width:longint; color:longint; 
             dim:longint):longint;cdecl;external;

  function SGL_CallbackFunctionSet(hwnd:HWND; func:SGL_CB):longint;cdecl;external;

  function SGL_CallbackFunctionGet(hwnd:HWND; func:PSGL_CB):longint;cdecl;external;

  function SGL_CallbackDataSet(hwnd:HWND; dataPtr:pointer):longint;cdecl;external;

  function SGL_CallbackDataGet(hwnd:HWND; dataPtr:Ppointer):longint;cdecl;external;

  function SGL_ContextGet(hwnd:HWND; context:PSGL_CONTEXT_T):longint;cdecl;external;

  { Definitions for different object types  }
  const
    SGL_CTRL_BUTTON = 1200;    
    SGL_CTRL_PUSHBUTTON = SGL_CTRL_BUTTON+1;    
    SGL_CTRL_CHECKBUTTON = SGL_CTRL_BUTTON+2;    
    SGL_CTRL_RADIOBUTTON = SGL_CTRL_BUTTON+3;    

  function SGL_ButtonValueSet(hwnd:HWND; value:longint):longint;cdecl;external;

  function SGL_ButtonValueGet(hwnd:HWND):longint;cdecl;external;

  const
    SGL_CTRL_EDIT = 1300;    

  function SGL_EditTextSet(hwnd:HWND; text:Pchar):longint;cdecl;external;

  function SGL_EditTextAppend(hwnd:HWND; text:Pchar):longint;cdecl;external;

  function SGL_EditTextLengthGet(hwnd:HWND):longint;cdecl;external;

  function SGL_EditTextGet(hwnd:HWND; text:Pchar; maxLen:longint):longint;cdecl;external;

  const
    SGL_CTRL_IMAGE = 1600;    

  function SGL_ImageLoad(hwnd:HWND; fileName:Pchar):longint;cdecl;external;

  function SGL_ImageLoadW(hwnd:HWND; fileName:PWideChar):longint;cdecl;external;

  function SGL_ImageUnload(hwnd:HWND):longint;cdecl;external;

  function SGL_ImageFittingSet(hwnd:HWND; fit:longint):longint;cdecl;external;

  function SGL_ImageFittingGet(hwnd:HWND):longint;cdecl;external;

  function SGL_ImageFrameIndexSet(hwnd:HWND; frameIndex:longint):longint;cdecl;external;

  function SGL_ImageFrameIndexGet(hwnd:HWND):longint;cdecl;external;

  function SGL_ImageFrameCountGet(hwnd:HWND):longint;cdecl;external;

  function SGL_ImagePlay(hwnd:HWND; speed100:longint):longint;cdecl;external;

  { object type										 }
  const
    SGL_CTRL_GRAPH = 1500;    

  type

    SGL_GRAPH_PLOTCB = procedure (hwnd:HWND; hdc:HDC; layer:longint; item:longint);cdecl;
    PSGL_GRAPH_PLOTCB  = ^SGL_GRAPH_PLOTCB;

    SGL_GRAPH_LABELCB = procedure (hwnd:HWND; hdc:HDC; value:double; rect:PRECT; axisID:longint);cdecl;
  { axis definition									 }
  { number of ticks or values						 }

    PSGL_GRAPH_AXIS_T = ^SGL_GRAPH_AXIS_T;
    SGL_GRAPH_AXIS_T = record
        lowValue : double;
        highValue : double;
        interval : double;
        ntick : longint;
        labelCB : SGL_GRAPH_LABELCB;
        grid : longint;
        color : COLORREF;
      end;

  function SGL_GraphAxisSet(hwnd:HWND; axisID:longint; uAxis:PSGL_GRAPH_AXIS_T):longint;cdecl;external;

  function SGL_GraphAxisGet(hwnd:HWND; axisID:longint; uAxis:PSGL_GRAPH_AXIS_T):longint;cdecl;external;

  function SGL_GraphMarginSet(hwnd:HWND; margin:PRECT):longint;cdecl;external;

  function SGL_GraphMarginGet(hwnd:HWND; margin:PRECT):longint;cdecl;external;

  function SGL_GraphPlotRectGet(hwnd:HWND; plotRect:PRECT):longint;cdecl;external;

  function SGL_GraphTickLengthSet(hwnd:HWND; tickLen:longint):longint;cdecl;external;

  function SGL_GraphTickLengthGet(hwnd:HWND; tickLen:Plongint):longint;cdecl;external;

  function SGL_GraphBGcolorSet(hwnd:HWND; layer:longint; bgColor:COLORREF):longint;cdecl;external;

  function SGL_GraphBGcolorGet(hwnd:HWND; layer:longint; bgColor:PCOLORREF):longint;cdecl;external;

  function SGL_GraphPlotFunctionSet(hwnd:HWND; plotFunc:SGL_GRAPH_PLOTCB):longint;cdecl;external;

  function SGL_GraphPlotFunctionGet(hwnd:HWND; plotFunc:PSGL_GRAPH_PLOTCB):longint;cdecl;external;

  function SGL_GraphPlotRequest(hwnd:HWND; layer:longint; item:longint):longint;cdecl;external;

  function SGL_GraphClear(hwnd:HWND; layer:longint):longint;cdecl;external;

  function SGL_GraphUserToPixel(hwnd:HWND; axisID:longint; x:double):longint;cdecl;external;

  function SGL_GraphPixelToUser(hwnd:HWND; axisID:longint; xp:longint; x:Pdouble):longint;cdecl;external;

  const
    SGL_CTRL_OPENGL = 1700;    

  function SGL_OglZoomSet(hwnd:HWND; nFoc:double):longint;cdecl;external;

  function SGL_OglZoomGet(hwnd:HWND; nFoc:Pdouble):longint;cdecl;external;

  function SGL_OglDepthOfFieldSet(hwnd:HWND; zNear:double; zFar:double):longint;cdecl;external;

  function SGL_OglDepthOfFieldGet(hwnd:HWND; zNear:Pdouble; zFar:Pdouble):longint;cdecl;external;

  {================================================================================ EDIT POPUP == }

  type

    SGL_EDITCB = function (virtKey:longint; text:Pchar; textLen:longint; caret:longint; CBdataPtr:pointer):longint;cdecl;

  function SGL_PopupEdit(hwnd:HWND; rect:PRECT; style:DWORD; text:Pchar; textLen:longint; 
             editCB:SGL_EDITCB; CBdataPtr:pointer):HWND;cdecl;external;

  {=========================================================================== DATE-TIME POPUP == }
  { exclusive styles			 }
  const
    SGL_TIME = $100;    
    SGL_DATE = $200;    
  { or-ed styles for date	 }
    SGL_DT_LONG = $80;    
    SGL_DT_CALENDAR = $40;    
    SGL_DT_WEEKNB = $20;    
    SGL_DT_TODAY = $10;    
  { or-ed styles for all		 }
    SGL_DT_NONE = $1;    

  type

    SGL_DTIMECB = procedure (event:longint; datetime:PSYSTEMTIME; CBdataPtr:pointer);cdecl;
  { event values for SGL_DTIMECB				 }
  { popup install						 }

  const
    SGL_DT_INSTALL = 0;    
  { date time delete (case SGL_DT_NONE)	 }
    SGL_DT_DELETE = 1;    
  { date time changed					 }
    SGL_DT_CHANGED = 2;    
  { popup release						 }
    SGL_DT_RELEASE = 3;    
  

  procedure SGL_DATETIME_NONE_SET(dt : SYSTEMTIME);  
  
  function SGL_DATETIME_NONE_IS(dt : SYSTEMTIME) : boolean;  

  function SGL_PopupDatetime(hwnd:HWND; rect:PRECT; style:longint; format:Pchar; datetime:PSYSTEMTIME; 
             dtimeCB:SGL_DTIMECB; CBdataPtr:pointer):HWND;cdecl;external;

  function SGL_DateTimeStringGet(datetime:PSYSTEMTIME; style:longint; format:Pchar; dst:Pchar; max:longint):longint;cdecl;external;

  function SGL_DateTimeNow:SYSTEMTIME;cdecl;external;

  {================================================================================ POPUP MENU == }
  { one of: 0 (default), MF_CHECKED, MF_DISABLED, MF_SEPARATOR	 }
  { option text: ignored if separator, NULL at end				 }

  type
    PSGL_POPUPMENU_OPTIONS_T = ^SGL_POPUPMENU_OPTIONS_T;
    SGL_POPUPMENU_OPTIONS_T = record
        state : longint;
        text : Pchar;
      end;

  function SGL_PopupMenu(hwnd:HWND; option:PSGL_POPUPMENU_OPTIONS_T; rect:PRECT; align:longint):longint;cdecl;external;

  const
    SGL_CTRL_HSEP = 1100;    
    SGL_CTRL_VSEP = SGL_CTRL_HSEP+1;    
  {============================================================================= TABLE CONTROL == }
  {============== CONSTANT DEFINITIONS ============== }
  { object type										 }
    SGL_CTRL_TABLE = 1400;    
  {---- attributes ---------------------------------- }

  type

    SGL_TABLE_FILLCB = procedure (_para1:HWND; _para2:HDC; _para3:longint; _para4:longint; _para5:PRECT);cdecl;
  { table column definition							 }
  { width (0 for end)								 }
  { width unit = pixel            (case > 0)			 }
  {				character height (case < 0)			 }
  { if set: merge with the next column				 }
  { background color									 }

    PSGL_TABLE_COLUMN_T = ^SGL_TABLE_COLUMN_T;
    PPSGL_TABLE_COLUMN_T  = ^PSGL_TABLE_COLUMN_T;
    SGL_TABLE_COLUMN_T = record
        width : longint;
        headerMerge : longint;
        cellNoRightSep : longint;
        cellBGcolor : COLORREF;
      end;

  function SGL_TableColumnsSet(hwnd:HWND; columns:PSGL_TABLE_COLUMN_T):longint;cdecl;external;

  function SGL_TableColumnsGet(hwnd:HWND; columns:PPSGL_TABLE_COLUMN_T):longint;cdecl;external;

  function SGL_TableHeaderHeightSet(hwnd:HWND; linePercent:longint):longint;cdecl;external;

  function SGL_TableHeaderHeightGet(hwnd:HWND):longint;cdecl;external;

  function SGL_TableHeaderBorderThicknessSet(hwnd:HWND; e:longint):longint;cdecl;external;

  function SGL_TableHeaderBorderThicknessGet(hwnd:HWND; e:Plongint):longint;cdecl;external;

  function SGL_TableHeightAdjust(hwnd:HWND; rowMin:longint):longint;cdecl;external;

  function SGL_TableRowNbSet(hwnd:HWND; rowNB:longint):longint;cdecl;external;

  function SGL_TableRowNbGet(hwnd:HWND):longint;cdecl;external;

  function SGL_TableRowShow(hwnd:HWND; row:longint):longint;cdecl;external;

  function SGL_TableSelectionModeSet(hwnd:HWND; selMode:longint):longint;cdecl;external;

  function SGL_TableSelectionModeGet(hwnd:HWND):longint;cdecl;external;

  function SGL_TableSelectionSet(hwnd:HWND; row:longint; col:longint):longint;cdecl;external;

  function SGL_TableSelectionGet(hwnd:HWND; row:Plongint; col:Plongint):longint;cdecl;external;

  function SGL_TableFillFunctionSet(hwnd:HWND; fillFunc:SGL_TABLE_FILLCB):longint;cdecl;external;

  function SGL_TableUpdate(hwnd:HWND; row1:longint; rowNB:longint; col:longint):longint;cdecl;external;

  function SGL_TableHGridSet(hwnd:HWND; rowGrid:longint):longint;cdecl;external;

  function SGL_TableHGridGet(hwnd:HWND):longint;cdecl;external;

  function SGL_TableGridThicknessSet(hwnd:HWND; e:longint):longint;cdecl;external;

  function SGL_TableGridThicknessGet(hwnd:HWND; e:Plongint):longint;cdecl;external;

  function SGL_TableGridColorSet(hwnd:HWND; color:COLORREF):longint;cdecl;external;

  function SGL_TableGridColorGet(hwnd:HWND; color:PCOLORREF):longint;cdecl;external;

  function SGL_TableAltRowSet(hwnd:HWND; dim:longint):longint;cdecl;external;

  function SGL_TableAltRowGet(hwnd:HWND; dim:Plongint):longint;cdecl;external;

  function SGL_TableCellHeightGet(hwnd:HWND):longint;cdecl;external;

  function SGL_TableCellCoordinatesGet(hwnd:HWND; row:Plongint; col:Plongint):longint;cdecl;external;

  function SGL_TableCellRectangleGet(hwnd:HWND; row:longint; col:longint; rect:PRECT):longint;cdecl;external;

  {------------------------------------------------------------------------------------------------
  
  TIPS:
  
  Recommended colors for columns are:
    - editable data:		SGL_WHITE
    - not editable data:	SGL_LTGRAY
  
  Columns labels can be merged:
    - define the text in the rightmost column,
    - set a NULL label to the left columns to be merged with.
  
  The cell width is the column width as defined in the SGL_COLUMN array. This width may include 
  a separation line (bottom and right only).
  
  The data cell (or row) height is unique and depends on the font size.
  
  The color of selected items is the same as a selected menu option. Hidden tables do not show the 
  selected items.
  ------------------------------------------------------------------------------------------------ }
  function SGL_ProfileInit(fileName:Pchar):Pchar;cdecl;external;

  procedure SGL_ProfileStringGet(section:Pchar; key:Pchar; l:Pchar; size:longint);cdecl;external;

  procedure SGL_ProfileStringSet(section:Pchar; key:Pchar; l:Pchar);cdecl;external;

  function SGL_ProfileIntGet(section:Pchar; key:Pchar; defValue:longint):longint;cdecl;external;

  function SGL_ProfileIntSet(section:Pchar; key:Pchar; value:longint; hex:longint):longint;cdecl;external;

  function SGL_ColorDim(color:COLORREF; dimmed:longint):COLORREF;cdecl;external;

  function SGL_ColorInterpolate(color0:COLORREF; color1:COLORREF; k:double):COLORREF;cdecl;external;


  type

    COLORS_CB = procedure (ix:longint; color:COLORREF);cdecl;

  function SGL_ColorsConfigure(colorKey:PPchar; section:Pchar; colorCB:COLORS_CB):longint;cdecl;external;

  procedure SGL_ColorsSet;cdecl;external;


implementation

   
  procedure SGL_DATETIME_NONE_SET(dt : SYSTEMTIME);
  begin
    dt.wYear:=0;
  end;


  function SGL_DATETIME_NONE_IS(dt : SYSTEMTIME) : boolean;
  begin
    SGL_DATETIME_NONE_IS:=(dt.wYear = 0);
  end;


end.
