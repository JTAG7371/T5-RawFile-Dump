	

	// TICKER BACKGROUND
	#undef TICKER_X_START
	#undef TICKER_Y_START

	#ifdef CONSOLE
		#define TICKER_X_START				( -77 - ( IsInGame() * 47 ) )		// From Left Edge
		#define TICKER_Y_START				-40									// From Top
	#else
		#define TICKER_X_START				( -77 - ( IsInGame() * 47 ) )		// From Center
		#define TICKER_Y_START				-100								// From Bottom
	#endif
	
	#define TICKER_MESSAGE_BG_WIDTH_WS		455
	#define TICKER_MESSAGE_BG_WIDTH			355
	#define TICKER_BACKGROUND_HEIGHT		15
	#define IS_WIDESCREEN					dvarbool( widescreen )

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