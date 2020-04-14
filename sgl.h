/*------------------------------------------------------------------------------------------------

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
------------------------------------------------------------------------------------------------*/

/*---- Public definitions for the SGL kernel ----*/

#define OEMRESOURCE
#include <windows.h>
#include <stdarg.h>


#define SGL_PANEL			1000
#define SGL_HIDDENFRAME		(SGL_PANEL + 1)
#define SGL_ROUNDEDFRAME	(SGL_PANEL + 2)

int SGL_PanelIpaddingSet(HWND hwnd, RECT *ipad);
int SGL_PanelIpaddingGet(HWND hwnd, RECT *ipad);

typedef int (*SGL_RESIZECB)(HWND hwnd, int wOffset, int hOffset) ;
int SGL_ResizeInstall(HWND hwnd, int widthMin, int heightMin, SGL_RESIZECB resizeCB);


#define NONE	0
#define STD		1
#define ERR		2
#define FATAL   3
#define QUIT	4

void SGL_Log(int mask, char *fmt,...) ;
void SGL_Fatal(char *file, int line, char *diag) ;
void SGL_Error(char *file, int line, int eresult) ; 

								/* Macro returning the number of elements of an array	*/
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))

								/* Macro to check a pointer								*/
#define PCHECK(p) if ((p) == NULL) SGL_Fatal(__FILE__, __LINE__, "ALLOCATION") ;

								/* Macro to check the result of a SGL function			*/
#define CHKERR(m) { SGL_Error(__FILE__, __LINE__, (m)) ; }

								/* Macro to log an execution time						*/
#define GCLK(m) { double _t_t = SGL_Timer() ; m ; _t_t = SGL_Timer() - _t_t ; \
					SGL_Log(STD, ":CLK: %-50.50s :%12.4f ms", #m, 1.e3 * _t_t) ;}


											/*============== CONSTANT DEFINITIONS ==============*/
/* Error codes (< 0) */

#define SGL_ERR_INT		-1							/* internal error							*/
#define SGL_ERR_ALLOC	-2							/* allocation error							*/
#define SGL_ERR_TYPE	-3							/* not compatible object					*/
#define SGL_ERR_PARM	-4							/* 1st parameter error						*/

/* Font attributes [these values are array indexes] */

#define SGL_FONT_NORMAL		1

#define SGL_FONT_FIXED		0						/* values for SGL_FONT_OPTION				*/
#define SGL_FONT_BOLD		2
#define SGL_FONT_ITALIC		3
#define SGL_FONT_SYMBOL		4
#define SGL_FONT_EXTRA		5


#define SGL_FONT_SMALL		0						/* values for SGL_FONT_SIZEIX				*/
#define SGL_FONT_LARGE		2
#define SGL_FONT_BIG		3

/* Alignment attributes (16 lsb) */

#define SGL_CENTER			0
#define SGL_LEFT			1
#define SGL_RIGHT			2
#define SGL_TOP				(SGL_LEFT << 8)
#define SGL_BOTTOM			(SGL_RIGHT << 8)

/* Frame border style */

#define SGL_BORDER_NONE			0
#define SGL_BORDER_FLAT			1
#define SGL_BORDER_RFLAT		2
#define SGL_BORDER_BEVEL_UP		3
#define SGL_BORDER_BEVEL_DOWN	4
#define SGL_BORDER_ETCHED_UP	5
#define SGL_BORDER_ETCHED_DOWN	6

/* Size constants	*/

#define SGL_WIDTH	101
#define SGL_HEIGHT	(SGL_WIDTH + 1)

/* Color handling

	Color are defined according to the win32 API, ie:  COLORREF yellow = RGB(255,255,0).
	System colors are defined by adding 0x80000000 to the GetSysColor() argument.
	The special value -1 is used to indicate that the object will inherit the color of its parent.

*/
#define SGL_SYSCOLOR	0x80000000
#define SGL_LTGRAY		(SGL_SYSCOLOR | COLOR_BTNFACE)
#define SGL_GRAY		(SGL_SYSCOLOR | COLOR_BTNSHADOW)
#define SGL_BLACK		0
#define SGL_WHITE		0x00ffffff

/* Keyboard & mouse status */

#define SGL_KEY_SHIFT (GetKeyState(VK_SHIFT) < 0)
#define SGL_KEY_CTRL  (GetKeyState(VK_CONTROL) < 0)
#define SGL_LBUTTON   (GetKeyState(VK_LBUTTON) < 0)
#define SGL_MBUTTON   (GetKeyState(VK_MBUTTON) < 0)
#define SGL_RBUTTON   (GetKeyState(VK_RBUTTON) < 0)


											/*========================================= TYPES ==*/

typedef int (*SGL_CB)(HWND hwnd, UINT event, WPARAM wParam, LPARAM lParam);
/* 
	A callback should return 1 for the fully processed events, and 0 when standard processing
	is required.
*/

typedef struct									/* context for user drawn objects				*/
{
	int selected;								/* object status								*/
	int dimmed;
	COLORREF bgdColor, fgdColor;				/* foreground & background dimmed colors		*/
	int fontSizeIx, fontStyle;					/* text attributes								*/
} SGL_CONTEXT_T;

											/*===================================== FUNCTIONS ==*/

void SGL_Init(HINSTANCE hInstance, char *iconRsc);
void SGL_Exit(void);

HWND SGL_New(HWND parent, int type, DWORD style, char *title, int left, int top);
HWND SGL_Duplicate(HWND parentDest, HWND childSource, char *title, int left, int top);

double SGL_Timer(void);

void SGL_Layout(HWND hwnd);
int SGL_Redraw(HWND hwnd);
int SGL_Run(void);
void SGL_Destroy(HWND hwnd);
																	/* set/get functions		*/
int SGL_RefSizeGet(void);
void SGL_DefPaddingSet(int l);
int SGL_DefPaddingGet(void);

int SGL_FontLoad(char* fName);
int SGL_FontFaceSet(int option, char *name);
int SGL_FontSizeSet(int sizeIx, int size);
int SGL_FontFaceGet(int option, char *name);
HFONT SGL_FontHandleGet(HWND hwnd, int sizeIx, int option);
int SGL_FontSizeGet(HWND hwnd);
int SGL_FontHeightGet(HWND hwnd);
int SGL_FontSizeIxSet(HWND hwnd, int sizeIx);
int SGL_FontSizeIxGet(HWND hwnd);
int SGL_FontStyleSet(HWND hwnd, int option);
int SGL_FontStyleGet(HWND hwnd);

int SGL_PositionSet(HWND hwnd, int left, int top);
int SGL_PositionGet(HWND hwnd, int *left, int *top);

int SGL_SizeSet(HWND hwnd, int sizeID, int size);
int SGL_SizeGet(HWND hwnd, int sizeID, int *size);

#define SGL_SAVE_POSITION	1
#define SGL_SAVE_SIZE		2
int SGL_LayoutConfigure(HWND hwnd, char *section, int op);

int SGL_AlignmentSet(HWND hwnd, int align);
int SGL_AlignmentGet(HWND hwnd);
int SGL_PaddingSet(HWND hwnd, RECT *padding);
int SGL_PaddingGet(HWND hwnd, RECT *padding);

int SGL_VisibleSet(HWND hwnd, int visible);
int SGL_VisibleGet(HWND hwnd);

void SGL_DebugSet(HWND hwnd, int debugLevel);
int SGL_DebugGet(HWND hwnd);

int SGL_CursorPositionSet(HWND hwnd, POINT *pt);
int SGL_CursorPositionGet(HWND hwnd, int current, POINT *pt);

int SGL_TitleSet(HWND hwnd, char* title);
int SGL_TitleGet(HWND hwnd, char** title);

int SGL_DimmedSet(HWND hwnd, int dimmed);
int SGL_DimmedGet(HWND hwnd);

int SGL_BGcolorSet(HWND hwnd, COLORREF color);
int SGL_BGcolorGet(HWND hwnd);
int SGL_FGcolorSet(HWND hwnd, COLORREF color);
int SGL_FGcolorGet(HWND hwnd);

int SGL_BorderStyleSet(HWND hwnd, int style);
int SGL_BorderStyleGet(HWND hwnd);
int SGL_BorderThicknessSet(HWND hwnd, int e);
int SGL_BorderThicknessGet(HWND hwnd, int *e);
int SGL_BorderColorSet(HWND hwnd, COLORREF color);
int SGL_BorderColorGet(HWND hwnd, COLORREF *color);
int SGL_BorderDraw(HDC hdc, RECT *rect, int style, int width, int color, int dim);

int SGL_CallbackFunctionSet(HWND hwnd, SGL_CB func);
int SGL_CallbackFunctionGet(HWND hwnd, SGL_CB *func);
int SGL_CallbackDataSet(HWND hwnd, void *dataPtr);
int SGL_CallbackDataGet(HWND hwnd, void ** dataPtr);

int SGL_ContextGet(HWND hwnd, SGL_CONTEXT_T *context);


/* Definitions for different object types */


#define SGL_CTRL_BUTTON			1200
#define SGL_CTRL_PUSHBUTTON		(SGL_CTRL_BUTTON + 1)
#define SGL_CTRL_CHECKBUTTON	(SGL_CTRL_BUTTON + 2)
#define SGL_CTRL_RADIOBUTTON	(SGL_CTRL_BUTTON + 3)

int SGL_ButtonValueSet(HWND hwnd, int value) ;
int SGL_ButtonValueGet(HWND hwnd) ;

#define SGL_CTRL_EDIT 1300

int SGL_EditTextSet(HWND hwnd, char *text);
int SGL_EditTextAppend(HWND hwnd, char *text);
int SGL_EditTextLengthGet(HWND hwnd);
int SGL_EditTextGet(HWND hwnd, char *text, int maxLen);

#define SGL_CTRL_IMAGE 1600

int SGL_ImageLoad(HWND hwnd, char* fileName) ;
int SGL_ImageLoadW(HWND hwnd, wchar_t* fileName) ;
int SGL_ImageUnload(HWND hwnd) ;

int SGL_ImageFittingSet(HWND hwnd, int fit) ;
int SGL_ImageFittingGet(HWND hwnd) ;

int SGL_ImageFrameIndexSet(HWND hwnd, int frameIndex) ;
int SGL_ImageFrameIndexGet(HWND hwnd) ;
int SGL_ImageFrameCountGet(HWND hwnd) ;

int SGL_ImagePlay(HWND hwnd, int speed100) ;

#define SGL_CTRL_GRAPH	1500				/* object type										*/

typedef void (*SGL_GRAPH_PLOTCB)(HWND hwnd, HDC hdc, int layer, int item);
typedef void (*SGL_GRAPH_LABELCB)(HWND hwnd, HDC hdc, double value, RECT *rect, int axisID);

typedef struct								/* axis definition									*/
{
	double lowValue;
	double highValue;
	double interval;
	int ntick;								/* number of ticks or values						*/
	SGL_GRAPH_LABELCB labelCB ;
	int grid;
	COLORREF color;
} SGL_GRAPH_AXIS_T;

int SGL_GraphAxisSet(HWND hwnd, int axisID, SGL_GRAPH_AXIS_T* uAxis);
int SGL_GraphAxisGet(HWND hwnd, int axisID, SGL_GRAPH_AXIS_T* uAxis);
int SGL_GraphMarginSet(HWND hwnd, RECT *margin);
int SGL_GraphMarginGet(HWND hwnd, RECT *margin);
int SGL_GraphPlotRectGet(HWND hwnd, RECT *plotRect);
int SGL_GraphTickLengthSet(HWND hwnd, int tickLen);
int SGL_GraphTickLengthGet(HWND hwnd, int *tickLen);
int SGL_GraphBGcolorSet(HWND hwnd, int layer, COLORREF bgColor);
int SGL_GraphBGcolorGet(HWND hwnd, int layer, COLORREF *bgColor);
int SGL_GraphPlotFunctionSet(HWND hwnd, SGL_GRAPH_PLOTCB plotFunc);
int SGL_GraphPlotFunctionGet(HWND hwnd, SGL_GRAPH_PLOTCB *plotFunc);
int SGL_GraphPlotRequest(HWND hwnd, int layer, int item);
int SGL_GraphClear(HWND hwnd, int layer);
int SGL_GraphUserToPixel(HWND hwnd, int axisID, double x);
int SGL_GraphPixelToUser(HWND hwnd, int axisID, int xp, double *x);

#define SGL_CTRL_OPENGL 1700

int SGL_OglZoomSet(HWND hwnd, double nFoc) ;
int SGL_OglZoomGet(HWND hwnd, double *nFoc) ;

int SGL_OglDepthOfFieldSet(HWND hwnd, double zNear, double zFar) ;
int SGL_OglDepthOfFieldGet(HWND hwnd, double *zNear, double *zFar) ;

/*================================================================================ EDIT POPUP ==*/

typedef int (*SGL_EDITCB)(int virtKey, char* text, int textLen, int caret, void* CBdataPtr) ;

HWND SGL_PopupEdit(HWND hwnd, RECT *rect, DWORD style, char *text, int textLen, 
					SGL_EDITCB editCB, void* CBdataPtr) ;

/*=========================================================================== DATE-TIME POPUP ==*/

#define SGL_TIME		0x100										/* exclusive styles			*/
#define SGL_DATE		0x200

#define SGL_DT_LONG		0x80										/* or-ed styles for date	*/
#define SGL_DT_CALENDAR	0x40
#define SGL_DT_WEEKNB	0x20
#define SGL_DT_TODAY	0x10

#define SGL_DT_NONE		0x1											/* or-ed styles for all		*/

typedef void (*SGL_DTIMECB)(int event, SYSTEMTIME *datetime, void* CBdataPtr) ;
													/* event values for SGL_DTIMECB				*/
#define SGL_DT_INSTALL	0								/* popup install						*/
#define SGL_DT_DELETE	1								/* date time delete (case SGL_DT_NONE)	*/
#define SGL_DT_CHANGED	2								/* date time changed					*/
#define SGL_DT_RELEASE	3								/* popup release						*/

#define SGL_DATETIME_NONE_SET(dt) (dt).wYear = 0
#define SGL_DATETIME_NONE_IS(dt) ((dt).wYear == 0)

HWND SGL_PopupDatetime(HWND hwnd, RECT *rect, int style, char *format, SYSTEMTIME *datetime,
						SGL_DTIMECB dtimeCB, void* CBdataPtr) ;

int SGL_DateTimeStringGet(SYSTEMTIME *datetime, int style, char *format, char* dst, int max) ;
SYSTEMTIME SGL_DateTimeNow(void) ;

/*================================================================================ POPUP MENU ==*/

typedef struct
{
	int  state ;				/* one of: 0 (default), MF_CHECKED, MF_DISABLED, MF_SEPARATOR	*/
	char *text ;				/* option text: ignored if separator, NULL at end				*/
} SGL_POPUPMENU_OPTIONS_T ;

int SGL_PopupMenu(HWND hwnd, SGL_POPUPMENU_OPTIONS_T* option, RECT *rect, int align) ;

#define SGL_CTRL_HSEP	1100
#define SGL_CTRL_VSEP	(SGL_CTRL_HSEP + 1)

/*============================================================================= TABLE CONTROL ==*/

											/*============== CONSTANT DEFINITIONS ==============*/

#define SGL_CTRL_TABLE		1400			/* object type										*/

											/*---- attributes ----------------------------------*/

typedef void (*SGL_TABLE_FILLCB)(HWND, HDC, int, int, RECT*);

typedef struct								/* table column definition							*/
{
	int  width;								/* width (0 for end)								*/
											/* width unit = pixel            (case > 0)			*/
											/*				character height (case < 0)			*/

	int headerMerge;						/* if set: merge with the next column				*/
	int cellNoRightSep;
	COLORREF cellBGcolor;					/* background color									*/
} SGL_TABLE_COLUMN_T;

int SGL_TableColumnsSet(HWND hwnd, SGL_TABLE_COLUMN_T* columns);
int SGL_TableColumnsGet(HWND hwnd, SGL_TABLE_COLUMN_T** columns);
int SGL_TableHeaderHeightSet(HWND hwnd, int linePercent);
int SGL_TableHeaderHeightGet(HWND hwnd);
int SGL_TableHeaderBorderThicknessSet(HWND hwnd, int e);
int SGL_TableHeaderBorderThicknessGet(HWND hwnd, int *e);
int SGL_TableHeightAdjust(HWND hwnd, int rowMin);
int SGL_TableRowNbSet(HWND hwnd, int rowNB);
int SGL_TableRowNbGet(HWND hwnd);
int SGL_TableRowShow(HWND hwnd, int row);
int SGL_TableSelectionModeSet(HWND hwnd, int selMode);
int SGL_TableSelectionModeGet(HWND hwnd);
int SGL_TableSelectionSet(HWND hwnd, int row, int col);
int SGL_TableSelectionGet(HWND hwnd, int *row, int *col);
int SGL_TableFillFunctionSet(HWND hwnd, SGL_TABLE_FILLCB fillFunc);
int SGL_TableUpdate(HWND hwnd, int row1, int rowNB, int col);
int SGL_TableHGridSet(HWND hwnd, int rowGrid);
int SGL_TableHGridGet(HWND hwnd);
int SGL_TableGridThicknessSet(HWND hwnd, int e);
int SGL_TableGridThicknessGet(HWND hwnd, int *e);
int SGL_TableGridColorSet(HWND hwnd, COLORREF color);
int SGL_TableGridColorGet(HWND hwnd, COLORREF *color);
int SGL_TableAltRowSet(HWND hwnd, int dim);
int SGL_TableAltRowGet(HWND hwnd, int *dim);
int SGL_TableCellHeightGet(HWND hwnd);
int SGL_TableCellCoordinatesGet(HWND hwnd, int *row, int *col);
int SGL_TableCellRectangleGet(HWND hwnd, int row, int col, RECT *rect);

/*------------------------------------------------------------------------------------------------

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
------------------------------------------------------------------------------------------------*/

char *SGL_ProfileInit(char *fileName) ;
void SGL_ProfileStringGet(char *section, char *key, char *l, int size);
void SGL_ProfileStringSet(char *section, char *key, char *l);
int SGL_ProfileIntGet(char *section, char *key, int defValue);
int SGL_ProfileIntSet(char *section, char *key, int value, int hex);

COLORREF SGL_ColorDim(COLORREF color, int dimmed);
COLORREF SGL_ColorInterpolate(COLORREF color0, COLORREF color1, double k);

typedef void (*COLORS_CB)(int ix, COLORREF color) ;
int SGL_ColorsConfigure(char **colorKey, char *section, COLORS_CB colorCB) ;
void SGL_ColorsSet(void) ;
