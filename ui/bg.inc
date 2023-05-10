//temp
//itemDef
//{
//	style			WINDOW_STYLE_SHADER
//	rect			0 0 1000 600 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
//	background		"white"
//	forecolor		0.3 0.3 0.3 1
//	visible			1
//	decoration
//}

// BOX OUTLINE ======================================================================================================================
#define BOX_COLOR					1 1 1
#define BOX_LINE_ALPHA				0.1
#define BOX_CORNER_ALPHA			0.2


#define LEFT_X_START				-78
#define RIGHT_X_START_WS			13
#ifdef PC
	#define RIGHT_X_START				-8
#else //#ifdef PC
	#define RIGHT_X_START				3
#endif //#ifdef PC

#define TOP_Y_START					7
#define BOTTOM_Y_START				-40

#define LEFT_LINE_START_X			LEFT_X_START
#define RIGHT_LINE_START_X_WS		(RIGHT_X_START_WS+2)
#define RIGHT_LINE_START_X			(RIGHT_X_START+2)
#define LINE_START_Y				(TOP_Y_START+12)

#define LINE_SIZE					1
#define BOX_HEIGHT					364

// Left line
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			LEFT_LINE_START_X LINE_START_Y LINE_SIZE BOX_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_LINE_ALPHA
	visible			1
	decoration
}
// WIDESCREEN
// Right line
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			RIGHT_LINE_START_X_WS LINE_START_Y LINE_SIZE BOX_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_LINE_ALPHA
	visible			when( dvarbool( widescreen ) )
	decoration
}
// STANDARD
// Right line
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			RIGHT_LINE_START_X LINE_START_Y LINE_SIZE BOX_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_LINE_ALPHA
	visible			when( !dvarbool( widescreen ) )
	decoration
}

#define CORNER_VERT_WIDTH			3
#define CORNER_VERT_HEIGHT			12
#define CORNER_HORIZ_WIDTH			CORNER_VERT_HEIGHT
#define CORNER_HORIZ_HEIGHT			CORNER_VERT_WIDTH

// Top Left Corner
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			(LEFT_X_START+CORNER_VERT_WIDTH) TOP_Y_START (CORNER_HORIZ_WIDTH-CORNER_VERT_WIDTH) CORNER_HORIZ_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			1
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			LEFT_X_START TOP_Y_START CORNER_VERT_WIDTH CORNER_VERT_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			1
	decoration
}

// WIDESCREEN
// Top Right Corner
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			(RIGHT_X_START_WS-(CORNER_HORIZ_WIDTH-CORNER_VERT_WIDTH)) TOP_Y_START (CORNER_HORIZ_WIDTH-CORNER_VERT_WIDTH) CORNER_HORIZ_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			when( dvarbool( widescreen ) )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			RIGHT_X_START_WS TOP_Y_START CORNER_VERT_WIDTH CORNER_VERT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			when( dvarbool( widescreen ) )
	decoration
}
// STANDARD
// Top Right Corner
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			(RIGHT_X_START-(CORNER_HORIZ_WIDTH-CORNER_VERT_WIDTH)) TOP_Y_START (CORNER_HORIZ_WIDTH-CORNER_VERT_WIDTH) CORNER_HORIZ_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			when( !dvarbool( widescreen ) )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			RIGHT_X_START TOP_Y_START CORNER_VERT_WIDTH CORNER_VERT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	background		"white"
	forecolor		BOX_COLOR BOX_CORNER_ALPHA
	visible			when( !dvarbool( widescreen ) )
	decoration
}
