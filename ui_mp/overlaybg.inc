#ifndef PC
	#define GRADIENT_LEFT_LINE_X	-290
	#define GRADIENT_LEFT_LINE_Y	29
	#define BOTTOM_LINE_Y			443
	#define INDIV_COL_GRADIENT_Y	137
	#define SHOW_BG	1
	#define OVERLAY_RECT			0 65 640 355
#else
	#define GRADIENT_LEFT_LINE_X	-290
	#define GRADIENT_LEFT_LINE_Y	65
	#define BOTTOM_LINE_Y			419
	#define INDIV_COL_GRADIENT_Y	174
	#define OVERLAY_RECT			-100 65 840 355

	#ifndef PC_INGAME
		#define SHOW_BG	1
	#else
		#define SHOW_BG	0
	#endif

#endif

#define OVERLAY_BACKGROUND \
	OVERLAY_BACKGROUND_VIS( 1 ) \

#define OVERLAY_BACKGROUND_VIS( visArg ) \
	/*fade out*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			-600 -800 2000 2000 0 0 \
		forecolor		/*COLOR_FADEOUT*/ 0 0 0 0.65 \
		background		"white" \
		visible			when( visArg ); \
		decoration \
	} \
	/*top white line*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 64 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	} \
	/*overlay texture*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			OVERLAY_RECT HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		background		"white" \
		forecolor		DARK_GRAY \
		visible			when( dvarBool( ui_multiplayer ) && SHOW_BG ) \
		decoration \
	} \
	/*bottom white line*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 BOTTOM_LINE_Y 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	}

#define OVERLAY_BACKGROUND_NO_FADE \
		OVERLAY_BACKGROUND_NO_FADE_VIS( 1 )
		
#define OVERLAY_BACKGROUND_NO_FADE_VIS( visArg ) \
		OVERLAY_BACKGROUND_NO_FADE_VIS_BG( visArg, SHOW_BG )

#define OVERLAY_BACKGROUND_NO_FADE_VIS_BG( visArg, showBG ) \
	/*top white line*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 64 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	} \
	/*overlay texture*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 65 640 355 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		background		"menu_background_mp_tank_blurred" \
		forecolor		1 1 1 1 \
		visible			when( showBG ); \
		decoration \
	} \
	/*bottom white line*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 BOTTOM_LINE_Y 640 0.5 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	}

#ifdef PC_INGAME
	#define VISIBLE_INGAME 1
#else
	#define VISIBLE_INGAME 0
#endif
// Letterbox background...
#define BACKGROUND_BLACK_LETTERBOX_BLURWORLD( blurWorldArg ) \
	BACKGROUND_BLACK_LETTERBOX_BLURWORLD_VIS( blurWorldArg, 1 )

#define BACKGROUND_BLACK_LETTERBOX_BLURWORLD_VIS( blurWorldArg, showArg )	\
		blurWorld		blurWorldArg \
	itemDef \
	{ \
		style			WINDOW_STYLE_FILLED \
		rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		backcolor		0 0 0 0 \
		visible			1 \
		decoration \
	} \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			-107 0 854 64 0 0\
		forecolor		1 1 1 1 \
		background		"menu_black_line" \
		visible			showArg \
		decoration \
	} \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			-107 420 854 70 0 0\
		forecolor		1 1 1 1 \
		background		"menu_black_line" \
		visible			showArg \
		decoration \
	} \
	/*top white line*/ \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 64 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	} \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		rect			0 BOTTOM_LINE_Y 640 1 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
		forecolor		0.5 0.5 0.5 0.65  \
		background		"menu_white_line_faded" \
		visible			when( visArg ); \
		decoration \
	}

#define OVERLAY_BACKGROUND_GRID \
	/*overlay texture*/  \
	itemDef  \
	{  \
		style			WINDOW_STYLE_SHADER  \
		rect			-100 65 840 360 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN  \
		background		"white"  \
		forecolor		DARK_GRAY \
		visible			1  \
		decoration  \
	}  \
	/*title background*/  \
	itemDef  \
	{  \
		style			WINDOW_STYLE_SHADER  \
		rect			0 63 640 32 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN  \
		forecolor		0 0 0 1   \
		background		"white"  \
		visible			1;  \
		decoration  \
	}  \
	/*top white line*/   \
	itemDef   \
	{   \
		style			WINDOW_STYLE_SHADER   \
		rect			0 63 640 2 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN   \
		forecolor		1 1 1 1    \
		background		"white"   \
		visible			1;   \
		decoration   \
	}  \
	/*bottom white line*/  \
	itemDef  \
	{  \
		style			WINDOW_STYLE_SHADER  \
		rect			0 422 640 2 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN  \
		forecolor		1 1 1 1   \
		background		"white"  \
		visible			1  \
		decoration  \
	} \
	/* bottom black bg */ \
	itemDef   \
	{   \
		style			WINDOW_STYLE_SHADER   \
		rect			0 424 640 60 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN   \
		forecolor		0 0 0 1    \
		background		"white"   \
		visible			1  \
		decoration   \
	} 