#ifndef BUTTON_Y_FILTER
#define BUTTON_Y_FILTER		0
#endif
		
#undef FILTER_RECT
#define FILTER_RECT 90 -4 0 0

#ifndef MIN_DELAY_FOR_LB_READ
#define MIN_DELAY_FOR_LB_READ 300
#endif 

#ifndef BASE_LB_TYPES_COUNT
#define BASE_LB_TYPES_COUNT int(tableLookup( "mp/gameTypesTable.csv", 0, "maxnum_gametype", 1 ))
#endif 

#undef FRAME_ASPECT_RATIO
#define FRAME_ASPECT_RATIO (854/566)

#undef NEW_FRAME_DEFAULT_HEIGHT
#define NEW_FRAME_DEFAULT_HEIGHT 377


#undef NEW_FRAME_DEFAULT_WIDTH
#define NEW_FRAME_DEFAULT_WIDTH ( NEW_FRAME_DEFAULT_HEIGHT * FRAME_ASPECT_RATIO )

#ifndef LEADERBOARD_HEIGHT
#define LEADERBOARD_HEIGHT NEW_FRAME_DEFAULT_HEIGHT
#endif 

#ifndef LEADERBOARD_WIDTH
#define LEADERBOARD_WIDTH ( LEADERBOARD_HEIGHT * FRAME_ASPECT_RATIO )
#endif 

		// change filter Y button for leaderboards
		itemDef
		{
			name			change_filter
			type			ITEM_TYPE_BUTTON
#ifdef CONSOLE
			text			"@PLATFORM_CHANGE_FILTER"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			rect			(-70) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
#endif
			visible			when( BUTTON_Y_FILTER );
			decoration

			execKeyInt BUTTON_Y
			{
				open menu_lb_filter;
			}
			execKeyInt BUTTON_LSHLDR
			{ 
				CHANGE_LB_TYPE_DEC
			}
			execKeyInt BUTTON_RSHLDR
			{
				CHANGE_LB_TYPE_INC
			}
		}

#ifdef CONSOLE
		#ifndef BUTTON_X_GOTOTOP
		#define BUTTON_X_GOTOTOP	0
		#endif

		#ifndef BUTTON_ACCEPT
		#define BUTTON_ACCEPT		0
		#endif
				
		// jump to top X button for leaderboards
		itemDef
		{
			name			goto_top
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_GOTOTOP"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_CENTER
			rect			70 ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_X_GOTOTOP );
			decoration
		}
		
		itemDef
		{
			name			accept_button
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_VIEW_PLAYER_CARD"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_CENTER
			rect			(-145) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_ACCEPT );
			decoration
		}
		
		#ifndef BUTTON_PGUP
		#define BUTTON_PGUP		0
		#endif
		#ifndef BUTTON_PGDOWN
		#define BUTTON_PGDOWN	0
		#endif
				
		#ifndef	BUTTON_REFRESH
		#define BUTTON_REFRESH	0
		#endif
				
		#ifndef	BUTTON_CREATE
		#define BUTTON_CREATE	0
		#endif
				
		// refresh button for systemlink 
		itemDef
		{
			name			refresh
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_REFRESH"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_RIGHT
			rect			-20 -4 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_REFRESH );
			decoration
		}		

		// create server button for systemlink 
		itemDef
		{
			name			create
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_CREATE_SERVER"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_RIGHT
			rect			-80 -4 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_CREATE );
			decoration
		}		

		// page up or down button
		itemDef
		{
			name			pgup
			type			ITEM_TYPE_BUTTON
			text			"@PLATFORM_PGUP_OR_DOWN"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_LEFT
			rect			( LEADERBOARD_WIDTH / 2 - 140 ) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			visible			when( BUTTON_PGUP || BUTTON_PGDOWN );
			decoration
		}
		
		itemDef 
		{ 
			type			ITEM_TYPE_TEXT 
			rect			( -LEADERBOARD_WIDTH / 2 + 16 ) ( LEADERBOARD_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  
			text			"@PLATFORM_BACK" 
			textfont		CHOICE_TEXTFONT  
			textscale		TEXTSIZE_DEFAULT  
			textalign		ITEM_ALIGN_BOTTOM_LEFT  
			visible			when( ( dvarint( "xblive_wagermatch" ) != 1 ) || ( dvarint( party_timerVisible ) == 0 ) )  
			decoration		
		} 	
#endif
		
#ifdef PC

#undef LB_BUMPER_BUTTONS
#define LB_BUMPER_BUTTONS(px, py, pwidth ) \
	/* Cycle buttons */ \
	itemDef \
	{ \
		name			"LB" \
		type			ITEM_TYPE_BUTTON \
		style			WINDOW_STYLE_SHADER \
		background		"ui_arrow_left" \
		rect			px py 16 16 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
		origin			0 0 \
		forecolor		1 1 1 1 \
		mouseEnter 		{ play CHOICE_FOCUS_SOUND; } \
		action			{ execkeyhandler BUTTON_LSHLDR } \
		visible			when( BUTTON_Y_FILTER ); \
	} \
	itemDef \
	{ \
		name			"RB" \
		type			ITEM_TYPE_BUTTON \
		style			WINDOW_STYLE_SHADER \
		background		"ui_arrow_right" \
		rect			(px+pwidth) py 16 16 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
		origin			0 0 \
		forecolor		1 1 1 1 \
		mouseEnter 		{ play CHOICE_FOCUS_SOUND; } \
		action			{ execkeyhandler BUTTON_RSHLDR } \
		visible			when( BUTTON_Y_FILTER ); \
	}

	itemDef
	{
		name			change_lb_filter
		type			ITEM_TYPE_BUTTON
		rect			64 -24 70 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
		origin			0 0
		text			"@PLATFORM_CHANGE_FILTER"
		textfont		CHOICE_TEXTFONT
		textscale		TEXTSIZE_DEFAULT
		textalign		ITEM_ALIGN_BOTTOM_LEFT
		visible			when( BUTTON_Y_FILTER );
		mouseEnter 		{ play CHOICE_FOCUS_SOUND; }
		action
		{
			execkeyhandler BUTTON_Y
		}
	}

	LB_BUMPER_BUTTONS(18, -40, 100 )

#ifndef BACK_ENABLE
#define BACK_ENABLE	1
#endif

#ifndef BACK_OPEN
#define BACK_OPEN	open main_text;
#endif
	itemDef 
	{
		type			ITEM_TYPE_BUTTON
		rect			4 216 60 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_CENTER
		exp				rect W( getTextWidth(locString("@PLATFORM_BACK"),UI_FONT_NORMAL,TEXTSIZE_DEFAULT)+8 )
		origin			0 0
		text			"@PLATFORM_BACK"
		textfont		UI_FONT_NORMAL
		textscale		TEXTSIZE_DEFAULT
		textalign		ITEM_ALIGN_MIDDLE_CENTER
		visible			when(BACK_ENABLE);
		style			WINDOW_STYLE_FILLED
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
		}	
	}

#endif // #ifdef PC

