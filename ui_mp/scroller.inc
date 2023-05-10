// Global X and Y
#ifdef CONSOLE
#define TICKER_X_START				0//-120	// From Left Edge
#define TICKER_Y_START				370		// From Top
#else
#define TICKER_X_START				10//-120 // From Left Edge
#define TICKER_Y_START				410		 // From Top
#endif

// Offsets to Global X and Y (keeps items in place when global X and y change
#define TICKER_X_OFFSET				60		// From left edge. Header stops here and message starts
#define TICKER_HEADER_TEXT_X_OFFET	10		// Header text offset from left corner

#define TICKER_TEXT_Y_OFFSET		14		// Offset from top	

// Width and heights
#define TICKER_SPACER_WIDTH			3		// Space between the end of Header section and start of main Message text
#define TICKER_END_SPACER_WIDTH		17
#ifdef CONSOLE
#define TICKER_MESSAGE_WIDTH		576		// Main message and main message background width
#define TICKER_MESSAGE_BG_WIDTH     576
#else
#define TICKER_MESSAGE_WIDTH		566		// Main message and main message background width
#define TICKER_MESSAGE_BG_WIDTH     566
#endif
#define TICKER_HEADER_TEXT_WIDTH	48		// Header text width
#define TICKER_HEIGHT				18		// Height of everything is the same.

itemDef
{
	name			tickerBackground
	style			WINDOW_STYLE_FILLED
	rect			(TICKER_X_START + TICKER_X_OFFSET + TICKER_SPACER_WIDTH) TICKER_Y_START TICKER_MESSAGE_BG_WIDTH TICKER_HEIGHT	HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP	
    backcolor		0 0 1 0.15	
	visible			1
	decoration
}
itemDef
{
	name			ticker
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE
	rect			(TICKER_X_START + TICKER_X_OFFSET + TICKER_SPACER_WIDTH) (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) TICKER_MESSAGE_WIDTH TICKER_HEIGHT	HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP	
	autowrapped
    textfont		UI_FONT_SMALL
    textscale       0.25
	visible			1			
	decoration
}

itemDef
{
	name			tickerCategoryHeader
	style			WINDOW_STYLE_FILLED
	rect			TICKER_X_START TICKER_Y_START TICKER_X_OFFSET TICKER_HEIGHT		
	backcolor		0 0 0 1	
	visible			1
	decoration
}
itemDef
{
	name			tickerCategorySpacerHeader
	style			WINDOW_STYLE_FILLED
	rect			(TICKER_X_START + TICKER_X_OFFSET) TICKER_Y_START TICKER_SPACER_WIDTH TICKER_HEIGHT		
	backcolor		0 0 1 0.15	
	visible			1
	decoration
}
itemDef
{
	name			tickerEndSpacer
	style			WINDOW_STYLE_FILLED
	rect			(TICKER_X_START + TICKER_X_OFFSET + TICKER_SPACER_WIDTH+ TICKER_MESSAGE_WIDTH) TICKER_Y_START TICKER_END_SPACER_WIDTH TICKER_HEIGHT		
	backcolor		0 0 1 0.15	
	visible			1
	decoration
}
itemDef
{
	name			tickerHeaderText
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE_CATEGORY
	rect			(TICKER_X_START + TICKER_HEADER_TEXT_X_OFFET) (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) TICKER_HEADER_TEXT_WIDTH TICKER_HEIGHT
	textscale		0.25
	textalign		ITEM_ALIGN_RIGHT
	textalignx		-3
	visible			1
	decoration
}