#ifndef ALT_PANEL
#define ALT_PANEL				0
#endif


#undef	LOCAL_NOT_IN_CAC
#define LOCAL_NOT_IN_CAC		( !menuisopen("menu_cac_custom") )
#undef	LOCAL_IN_CAC
#define LOCAL_IN_CAC			( menuisopen("menu_cac_custom") )

#ifndef BUTTON_Y_FILTER
#define BUTTON_Y_FILTER			0
#endif

#undef NAV_FONT
#ifdef SPLITSCREEN_ENABLED
	#define NAV_FONT			UI_FONT_SMALL
#else
	#define NAV_FONT			UI_FONT_NORMAL
#endif	


#undef FILTER_RECT
#undef LEFT_ARROW_RECT

#undef Y_OFFSET
#define Y_OFFSET				201

#ifdef CONSOLE
	#define FILTER_RECT			(-90) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
	#define LEFT_ARROW_RECT		0 -20 16 16
#else
	#define FILTER_RECT			0 0 80 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	#define LEFT_ARROW_RECT		-270 -26 16 16
#endif

#ifndef SWITCH_TO_WAVES
#define SWITCH_TO_WAVES setdvar next_lb_menu_name menu_leaderboard_waves;
#endif //#ifndef SWITCH_TO_WAVES

#ifndef SWITCH_TO_POINTS
#define SWITCH_TO_POINTS setdvar next_lb_menu_name menu_leaderboard_points;
#endif //#ifndef SWITCH_TO_POINTS

#ifndef TOGGLE_LEADERBOARD_TYPE
#define TOGGLE_LEADERBOARD_TYPE( mapTypeArg, execStringArg )	\
	execNow execStringArg;										\
	if( dvarString( "lb_type" ) == mapTypeArg )					\
	{															\
		SWITCH_TO_WAVES											\
	}															\
	else														\
	{															\
		SWITCH_TO_POINTS										\
	}
#endif //#ifndef TOGGLE_LEADERBOARD_TYPE

#ifndef TOGGLE_LEADERBOARD_TYPE_LEFT	
#define TOGGLE_LEADERBOARD_TYPE_LEFT											\
	if( dvarString( lb_mapname ) == zombie_theater )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_theater_waves, "toggle lb_type 1 0" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_pentagon )						\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_pentagon_waves, "toggle lb_type 7 6" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombietron )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombietron_waves, "toggle lb_type 4 3" )		\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_cosmodrome )						\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_cosmodrome_waves, "toggle lb_type 22 21" ) \
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_coast )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_coast_waves, "toggle lb_type 25 24" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_temple )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_temple_waves, "toggle lb_type  28 27" )	\
	}																			\
	closeImmediate self;														\
	execnow openmenuImmediate ( dvarString( next_lb_menu_name ) );				\
	execnow "downloadingleaderboard";
#endif //#ifndef TOGGLE_LEADERBOARD_TYPE_LEFT

#ifndef TOGGLE_LEADERBOARD_TYPE_RIGHT
#define TOGGLE_LEADERBOARD_TYPE_RIGHT											\
	if( dvarString( lb_mapname ) == zombie_theater )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_theater_waves, "toggle lb_type 0 1" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_pentagon )						\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_pentagon_waves, "toggle lb_type 6 7" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombietron )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombietron_waves, "toggle lb_type 3 4" )		\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_cosmodrome )						\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_cosmodrome_waves, "toggle lb_type 21 22" )		\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_coast )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_coast_waves, "toggle lb_type 24 25" )	\
	}																			\
	elseif( dvarString( lb_mapname ) == zombie_temple )							\
	{																			\
		TOGGLE_LEADERBOARD_TYPE( zombie_temple_waves, "toggle lb_type 27 28" )	\
	}																			\
	closeImmediate self;														\
	execnow openmenuImmediate ( dvarString( next_lb_menu_name ) );				\
	execnow "downloadingleaderboard";
#endif //#ifndef TOGGLE_LEADERBOARD_TYPE_RIGHT


		// change filter Y button for leaderboards
		itemDef
		{
			name			change_filter
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_CHANGE_FILTER"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			rect			FILTER_RECT
			visible			when( BUTTON_Y_FILTER );
#ifdef CONSOLE
			decoration
			execKeyInt BUTTON_Y
#else
			action
#endif
			{
				play CHOICE_FOCUS_SOUND;
				open menu_lb_filter;
			}

			execKeyInt BUTTON_LSHLDR
			{
				TOGGLE_LEADERBOARD_TYPE_LEFT
			}
			execKeyInt BUTTON_RSHLDR
			{
				TOGGLE_LEADERBOARD_TYPE_RIGHT
			}
		}

#ifdef CONSOLE
		#ifndef BUTTON_X_GOTOTOP
		#define BUTTON_X_GOTOTOP	0
		#endif

		#ifndef BUTTON_ACCEPT
		#define BUTTON_ACCEPT		0
		#endif
			
		#undef BUTTONS_X_START
		#define BUTTONS_X_START		-200
		// jump to top X button for leaderboards
		itemDef
		{
			name			goto_top
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_GOTOTOP"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_CENTER
			rect			60 ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_X_GOTOTOP );
			decoration
		}
		
		itemDef
		{
			name			accept_button
			type			ITEM_TYPE_TEXT
			text			"@PLATFORM_SELECT"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_CENTER
			rect			(-165) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_ACCEPT );
			decoration
		}

		itemDef
		{
			name			pgup
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_PGUP_OR_DOWN"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_LEFT
			rect			( LEADERBOARD_WIDTH / 2 - 150 ) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_PGUP || BUTTON_PGDOWN );
			decoration
		}
		
		
#endif // #ifdef CONSOLE

#ifdef PC

	#ifndef BACK_ENABLE
	#define BACK_ENABLE	1
	#endif

	#ifndef BACK_OPEN
	#define BACK_OPEN	open main_text;
	#endif
	
	itemDef 
	{
		style			WINDOW_STYLE_SHADER
		rect			0 -20 16 16 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
		origin			0 0
		background		"ui_arrow_left"
		forecolor		1 1 1 1
		visible			when(BACK_ENABLE);
		decoration
	}

	itemDef 
	{
		type			ITEM_TYPE_BUTTON
		rect			18 -24 40 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
		origin			0 0
		exp				rect W( getTextWidth(locString("@PLATFORM_BACK"),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT)+8 )
		text			"@PLATFORM_BACK"
		textfont		CHOICE_TEXTFONT
		textscale		TEXTSIZE_DEFAULT
		textalign		ITEM_ALIGN_MIDDLE_CENTER
		visible			when(BACK_ENABLE);
		style			WINDOW_STYLE_FILLED
		forecolor		1 1 1 1
		backcolor		1 1 1 0
		border			1
		bordersize		1
		bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA
		mouseEnter		{ play CHOICE_FOCUS_SOUND; setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; }
		mouseexit		{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; }
		action 
		{
#ifdef ON_ESC
			ON_ESC
#else
			play CHOICE_FOCUS_SOUND;
			close self;
			BACK_OPEN
#endif
			if (IsInGame() && !dvarBool( ui_multiplayer ))
			{
				open "pausedmenu";
			}
		}	
	}
	
#endif // #ifdef PC
