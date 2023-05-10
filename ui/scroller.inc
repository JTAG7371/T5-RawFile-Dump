// Global X and Y
#undef TICKER_X_START
#undef TICKER_Y_START

#ifdef CONSOLE
	#define TICKER_X_START				( -77 - ( IsInGame() * 47 ) )		// From Left Edge
	#define TICKER_Y_START				-40									// From Top
#else
	#define TICKER_X_START				( -77 - ( IsInGame() * 47 ) )		// From Center
	#define TICKER_Y_START				-100								// From Bottom
#endif

// Offsets to Global X and Y (keeps items in place when global X and y change
#define TICKER_X_OFFSET					0				// From left edge. Header stops here and message starts
#define TICKER_HEADER_TEXT_X_OFFSET		5				// Header text offset from left corner
#define TICKER_TEXT_Y_OFFSET			13				// Offset from top	

// Width and heights
#define TICKER_SPACER_WIDTH				7				// Space between the end of Header section and start of main Message text
#define TICKER_END_SPACER_WIDTH			17

#define TICKER_MESSAGE_BG_WIDTH_WS		455
#ifdef PC
	#define TICKER_MESSAGE_BG_WIDTH			391
#else //#ifdef PC
	#define TICKER_MESSAGE_BG_WIDTH			355
#endif //#ifdef PC

#define TICKER_HEADER_TEXT_WIDTH		55																	// Header text rect width
#define TICKER_HEADER_VAR_TEXT_WIDTH	( dvarInt( tickerHeaderWidth ) + TICKER_HEADER_TEXT_X_OFFSET )		// Actual width of header text, plus offset for gap

#define TICKER_MESSAGE_WIDTH_WS			(TICKER_MESSAGE_BG_WIDTH_WS - TICKER_HEADER_VAR_TEXT_WIDTH - 2 )	// Main message and main message background width
#define TICKER_MESSAGE_WIDTH			(TICKER_MESSAGE_BG_WIDTH - TICKER_HEADER_VAR_TEXT_WIDTH - 2 )		// Main message and main message background width

#define TICKER_HEIGHT					12				// Height of everything is the same.
#define TICKER_BACKGROUND_HEIGHT		15
#define IS_WIDESCREEN					dvarbool( widescreen )

// TICKER BACKGROUND
// WIDESCREEN
itemDef
{
	name			tickerBackground
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE																							
	rect			0 (TICKER_Y_START) TICKER_MESSAGE_BG_WIDTH_WS TICKER_BACKGROUND_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START ) 
	forecolor		0 0 0 0.6																									
	exp				material( "menu_mp_bar_shadow" )
	visible			when( IS_WIDESCREEN )
	decoration
}


//STANDARD
itemDef
{
	name			tickerBackground
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE																							
	rect			0 (TICKER_Y_START) TICKER_MESSAGE_BG_WIDTH TICKER_BACKGROUND_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START ) 
	forecolor		0 0 0 0.6																									
	exp				material( "menu_mp_bar_shadow" )
	visible			when( !IS_WIDESCREEN )
	decoration
}


// TICKER HEADER
// WIDESCREEN
itemDef
{
	name			tickerHeaderText
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE_CATEGORY
	rect			0 (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) TICKER_HEADER_TEXT_WIDTH (TICKER_HEIGHT-1) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START + TICKER_HEADER_TEXT_X_OFFSET ) 
	textscale		0.25
	textalign		ITEM_ALIGN_LEFT
	forecolor		0.97 0.58 0.18 1 
	backcolor		0.5 0.5 0.5 0.1
	textalignx		-3
	visible			when( IS_WIDESCREEN )
	decoration
}


//STANDARD
itemDef
{
	name			tickerHeaderText
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE_CATEGORY
	rect			0 (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) TICKER_HEADER_TEXT_WIDTH (TICKER_HEIGHT-1) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START + TICKER_HEADER_TEXT_X_OFFSET ) 
	textscale		0.25
	textalign		ITEM_ALIGN_LEFT
	forecolor		0.97 0.58 0.18 1 
	backcolor		0.5 0.5 0.5 0.1
	textalignx		-3
	visible			when( !IS_WIDESCREEN )
	decoration
}


// TICKER TEXT
// WIDESCREEN
itemDef
{
	name			ticker
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE
	rect			0 (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) 0 TICKER_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START + TICKER_X_OFFSET + TICKER_HEADER_VAR_TEXT_WIDTH ) 
	exp				rect W( TICKER_MESSAGE_WIDTH_WS )
	autowrapped
	textfont		UI_FONT_SMALL
	textscale		0.25
	visible			when( IS_WIDESCREEN )
	decoration
}


//STANDARD
itemDef
{
	name			ticker
	type			ITEM_TYPE_OWNERDRAW_TEXT
	ownerdraw		UI_SCROLLING_MESSAGE
	rect			0 (TICKER_Y_START + TICKER_TEXT_Y_OFFSET) 0 (TICKER_HEIGHT-1) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	exp				rect X( TICKER_X_START + TICKER_X_OFFSET + TICKER_HEADER_VAR_TEXT_WIDTH )
	exp				rect W( TICKER_MESSAGE_WIDTH )
	autowrapped
	textfont		UI_FONT_SMALL
	textscale		0.25
	visible			when( !IS_WIDESCREEN )
	decoration
}
