
#define FRAME_RGB								0.4 0.5 0.54
#undef	FRAME_ASPECT_RATIO
#define FRAME_ASPECT_RATIO						(854/566)
#define FRAME_DEFAULT_HEIGHT					377
#define FRAME_DEFAULT_WIDTH						( FRAME_DEFAULT_HEIGHT * FRAME_ASPECT_RATIO )
#define FRAME_GREEN_RGB							0.42 0.68 0.46 
#define FRAME_RED_RGB							0.73 0.19 0.19
#define FRAME_LT_GREY_RGB						0.57 0.57 0.57
#define FRAME_GREY_RGB							0.17 0.17 0.17
#define FRAME_ORANGE_RGB						0.96 0.58 0.11
#define FRAME_BG_Y_OFFSET( FRAME_HEIGHT )		( FRAME_HEIGHT * 0.144 )
#define FRAME_TRANSPARENCY						0 0 0 0.3
#define FRAME_HEADER_HEIGHT						45
#define FRAME_BUTTON_WIDTH						190
#define FRAME_BUTTON_HEIGHT						17
#define FRAME_DEFAULT_TITLE_X_OFFSET			15
#define FRAME_CHOICE_Y_START					( -FRAME_DEFAULT_HEIGHT/2 + FRAME_HEADER_HEIGHT + FRAME_DEFAULT_TITLE_X_OFFSET )
#define FRAME_CHOICE_X_START					( -FRAME_DEFAULT_WIDTH/2 + FRAME_DEFAULT_TITLE_X_OFFSET )
#define FRAME_TITLE_WIDTH						200
#define FRAME_TITLE_HEIGHT						20


#define SP_FRAME_OUTER							"menu_sp_lobby_frame_outer_ingame"

#ifndef FRAME_TAB_BG_INGAME
	#define FRAME_TAB_BG_INGAME
#endif // #ifndef FRAME_TAB_BG_INGAME

#ifndef FRAME_TAB_BG
	#define FRAME_TAB_BG
#endif // #ifndef FRAME_TAB_BG

// This should be put first (on bottom) in a menu
#define FRAME_DEFAULT \
		FRAME( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )

#define FRAME( FRAME_WIDTH, FRAME_HEIGHT )																																									\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) ( -( FRAME_HEIGHT + 20 ) / 2 ) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER							\
			background      "menu_mp_lobby_frame_outer_ingame"																																				\
			forecolor       1 1 1 1																																											\
			visible         when( IsInGame() || !dvarBool( ui_multiplayer ) );																																\
			decoration																																														\
			frame           26 0.1 FRAME_SIDE_ALL																																							\
		}																																																	\
		FRAME_TAB_BG_INGAME																																													\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_mp_lobby_frame_inner_ingame"																																				\
			forecolor       1 1 1 1																																											\
			visible         when( IsInGame() || !dvarBool( ui_multiplayer ) );																																\
			decoration																																														\
			frame           26 0.1 FRAME_OPEN_TOP																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) ( -( FRAME_HEIGHT + 20 ) / 2 ) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER							\
			background      "menu_mp_lobby_frame_outer"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !IsInGame() && dvarBool( ui_multiplayer ) );																																\
			decoration																																														\
			frame           26 0.1 FRAME_SIDE_ALL																																							\
		}																																																	\
		FRAME_TAB_BG																																														\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_mp_lobby_frame_inner"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !IsInGame() && dvarBool( ui_multiplayer ) );																																\
			decoration																																														\
			frame           26 0.1 FRAME_OPEN_TOP																																							\
		}																																																	\
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(-FRAME_WIDTH/2) (-FRAME_HEIGHT/2+5) (FRAME_WIDTH) 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			ORIGIN_TITLE \
			forecolor		NEW_FRAME_ORANGE_RGB 1 \
			exp				text( locString( "@MENU_GAME_STARTING_IN_CAPS", dvarInt( "party_timer" ) ) ) \
			textfont		UI_FONT_EXTRABIG \
			textscale		TEXTSIZE_SMALL \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_TOP_CENTER \
			visible			when( dvarBool( ui_multiplayer ) && dvarInt( party_timerVisible ) == 1 && ( dvarInt( "party_timer" ) > 0 ) && !IsInGame() ); \
			decoration \
		}																	

#define FRAME_INNER_SOLID_DEFAULT \
		FRAME_INNER_SOLID( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )
		
#define FRAME_INNER_SOLID( FRAME_WIDTH, FRAME_HEIGHT )																																						\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_mp_lobby_frame_inner_ingame"																																				\
			forecolor       1 1 1 1																																											\
			visible         1																																												\
			decoration																																														\
			frame           26 0.1 FRAME_OPEN_TOP																																							\
		}
		
#define FRAME_SP_DEFAULT \
		FRAME_SP( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )

#define FRAME_SP( FRAME_WIDTH, FRAME_HEIGHT )																																	\
		itemDef																																									\
		{																																										\
			style           WINDOW_STYLE_SHADER_FRAMED																															\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) (-( FRAME_HEIGHT + 20 ) / 2) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      SP_FRAME_OUTER																																		\
			forecolor       1 1 1 1																																				\
			visible         1																																					\
			decoration																																							\
			frame           26 0.1 FRAME_SIDE_ALL																																\
		}																	

#define FRAME_ZOMBIE_DEFAULT \
		FRAME_ZOMBIE( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )

#define FRAME_ZOMBIE( FRAME_WIDTH, FRAME_HEIGHT )																																\
		itemDef																																									\
		{																																										\
			style           WINDOW_STYLE_SHADER_FRAMED																															\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) (-( FRAME_HEIGHT + 20 ) / 2) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_zombie_lobby_frame_outer_ingame"																												\
			forecolor       1 1 1 1																																				\
			visible         1																																					\
			decoration																																							\
			frame           26 0.1 FRAME_SIDE_ALL																																\
		}																																										\
		PREPROC_SHADER_DRAW_VIS_EX(	( -FRAME_WIDTH / 2 ) ( -FRAME_HEIGHT / 2 ) FRAME_WIDTH FRAME_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,	\
									"menu_zom_lobby_blood_big01", 0.8 0 0 0.125, 1, ; )


#define FRAME_TITLE_DEFAULT( titleArg, visArg ) \
		FRAME_TITLE( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, titleArg, visArg )

#define FRAME_TITLE( FRAME_WIDTH, FRAME_HEIGHT, titleArg, visArg )																							\
		itemDef																																				\
		{																																					\
			type			ITEM_TYPE_TEXT																													\
			rect			(-FRAME_WIDTH/2 + FRAME_TITLE_X_OFFSET) (-FRAME_HEIGHT/2 + 2) FRAME_TITLE_WIDTH FRAME_TITLE_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			origin			ORIGIN_TITLE																													\
			forecolor		1 1 1 1																															\
			exp				text( titleArg )																												\
			textfont		UI_FONT_EXTRABIG																												\
			textscale		TEXTSIZE_SUBTITLE																												\
			textstyle		ITEM_TEXTSTYLE_NORMAL																											\
			textalign		ITEM_ALIGN_TOP_LEFT																												\
			visible			visArg																															\
			decoration																																		\
		}

#define FRAME_TITLE_LEFT_DEFAULT( titleArg, visArg ) \
		FRAME_TITLE_LEFT( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, 0, 25, titleArg, visArg )

#define FRAME_TITLE_LEFT( FRAME_WIDTH, FRAME_HEIGHT, xOffset, yOffset, titleArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(CHOICE_X_START+xOffset) (-FRAME_HEIGHT/2 + yOffset) 1 1 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_CENTER \
			origin			ORIGIN_TITLE \
			forecolor		1 1 1 1 \
			exp				text( titleArg ) \
			textfont		UI_FONT_EXTRABIG \
			textscale		TEXTSIZE_TITLE \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_TOP_LEFT \
			visible			visArg \
			decoration \
		}

#define FRAME_SUBTITLE_DEFAULT( titleArg, visArg ) \
		FRAME_SUBTITLE( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, titleArg, visArg )

#define FRAME_SUBTITLE( FRAME_WIDTH, FRAME_HEIGHT, titleArg, visArg )																											\
		itemDef																																									\
		{																																										\
			type			ITEM_TYPE_TEXT																																		\
			rect			(-FRAME_WIDTH/2 + FRAME_TITLE_X_OFFSET) (-FRAME_HEIGHT/2 + 2 + FRAME_TITLE_HEIGHT ) FRAME_TITLE_WIDTH FRAME_TITLE_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			origin			ORIGIN_TITLE																																		\
			forecolor		1 1 1 1																																				\
			exp				text( titleArg )																																	\
			textfont		UI_FONT_NORMAL																																		\
			textscale		TEXTSIZE_DEFAULT																																	\
			textstyle		ITEM_TEXTSTYLE_NORMAL																																\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																																\
			visible			visArg																																				\
			decoration																																							\
		}

#define IN_FRAME_HEADER_DEFAULT( titleArg, visArg ) \
		IN_FRAME_HEADER( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, titleArg, visArg )

#define IN_FRAME_HEADER( FRAME_WIDTH, FRAME_HEIGHT, titleArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(-FRAME_WIDTH/2+15) (-FRAME_HEIGHT/2+FRAME_BG_Y_OFFSET(FRAME_HEIGHT)+25) 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			ORIGIN_TITLE \
			forecolor		FRAME_LT_GREY_RGB 1 \
			exp				text( titleArg ) \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_DEFAULT \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_BOTTOM_LEFT \
			visible			visArg \
			decoration \
		}

#define FRAME_BACK_BUTTON_DEFAULT \
		FRAME_BACK_BUTTON( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )

#ifdef CONSOLE
	#define FRAME_BACK_BUTTON_DEFAULT_ACTION( actionArg ) \
			FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )

	#define FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
			FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )
#else // #ifdef CONSOLE	
	#define FRAME_BUTTON_ACTION_VIS_RECT_ARGS( rectArgs, textArg, actionArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_BUTTON \
			rectArgs \
			text			textArg \
			style			WINDOW_STYLE_FILLED \
			textfont		CHOICE_TEXTFONT  \
			textscale		TEXTSIZE_DEFAULT  \
			textalign		ITEM_ALIGN_MIDDLE_CENTER  \
			forecolor		1 1 1 1 \
			backcolor		1 1 1 0 \
			border			1 \
			bordersize		1 \
			bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA \
			visible 		visArg \
			action			{ play CHOICE_FOCUS_SOUND ; actionArg } \
			mouseEnter		{ play CHOICE_FOCUS_SOUND; setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; } \
			mouseexit		{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; } \
		}
		
	#define FRAME_BUTTON_ACTION_OFFSET_VIS( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, offset_x, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	( CHOICE_X_START-4 ) ( FRAME_HEIGHT / 2 + 13 ) 50 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
			exp		rect X( CHOICE_X_START - 4 + offset_x ) \
			exp		rect W( getTextWidth(locString(textArg),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT)+8 ), \
			textArg, actionArg, visArg )
			
	#define FRAME_BUTTON_ACTION_RIGHT_VIS( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	( FRAME_WIDTH / 2 ) ( FRAME_HEIGHT / 2 + 13 ) 50 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp		rect X( FRAME_WIDTH / 2 - getTextWidth(locString(textArg),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT) - 8 - 4 ) \
			exp		rect W( getTextWidth(locString(textArg),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT)+8 ), \
			textArg, actionArg, visArg )
	
	#define FRAME_BUTTON_ACTION_CENTERED_VIS( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	0 ( FRAME_HEIGHT / 2 + 13 ) 50 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp		rect X( -getTextWidth(locString(textArg),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT) - 4 ) \
			exp		rect W( getTextWidth(locString(textArg),CHOICE_TEXTFONT,TEXTSIZE_DEFAULT)+8 ), \
			textArg, actionArg, visArg )
			
	#define FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, offsetArg, textArg, actionArg, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( ( - FRAME_WIDTH / 2 + FRAME_DEFAULT_TITLE_X_OFFSET + offsetArg ) ), \
			textArg, actionArg, visArg )
			
	#define FRAME_BUTTON_PC_RIGHT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, offsetArg, textArg, actionArg, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( FRAME_WIDTH / 2 - NEW_FRAME_DEFAULT_TITLE_X_OFFSET + (offsetArg) - getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 ), \
			textArg, actionArg, visArg )

	#define FRAME_BUTTON_PC_CENTERED( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		FRAME_BUTTON_ACTION_VIS_RECT_ARGS( \
			rect	0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( -getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) / 2 - 4 ), \
			textArg, actionArg, visArg )
			
	#define FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
		FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, 0, "@PLATFORM_BACK", actionArg, 1 )
		
	#define FRAME_BACK_BUTTON_DEFAULT_ACTION( actionArg ) \
		FRAME_BACK_BUTTON_ACTION( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, actionArg )
#endif // #ifdef CONSOLE

#define FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )																\
		itemDef																										\
		{																											\
			type			ITEM_TYPE_TEXT																			\
			rect			CHOICE_X_START ( FRAME_HEIGHT / 2 ) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			text			"@PLATFORM_BACK"																		\
			textfont		CHOICE_TEXTFONT																			\
			textscale		TEXTSIZE_DEFAULT																		\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																	\
			visible			1																						\
			decoration																								\
		} 	

#define FRAME_CONTINUE_BUTTON_DEFAULT \
		FRAME_CONTINUE_BUTTON( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT )

#define FRAME_CONTINUE_BUTTON( FRAME_WIDTH, FRAME_HEIGHT ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			CHOICE_X_START ( FRAME_HEIGHT / 2 ) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
			text			"@PLATFORM_CONTINUE" \
			textfont		CHOICE_TEXTFONT  \
			textscale		TEXTSIZE_DEFAULT  \
			textalign		ITEM_ALIGN_BOTTOM_LEFT  \
			visible			1  \
			decoration		\
		} 	

#define FRAME_DONE_BUTTON( FRAME_WIDTH, FRAME_HEIGHT ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			CHOICE_X_START ( FRAME_HEIGHT / 2 ) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
			text			"@PLATFORM_DONE" \
			textfont		CHOICE_TEXTFONT  \
			textscale		TEXTSIZE_DEFAULT  \
			textalign		ITEM_ALIGN_BOTTOM_LEFT  \
			visible			1  \
			decoration  \
		}

#define SIGNED_IN_AS \
		SIGNED_IN_AS_VIS( FRAME_DEFAULT_WIDTH, FRAME_DEFAULT_HEIGHT, 1 )

#define SIGNED_IN_AS_VIS( FRAME_WIDTH, FRAME_HEIGHT, visArg )	\
		itemDef													\
		{														\
			name			signedinas							\
			type			ITEM_TYPE_OWNERDRAW_TEXT			\
			rect			( FRAME_WIDTH/2 - FRAME_TITLE_WIDTH -10) (-FRAME_HEIGHT/2 + FRAME_TITLE_HEIGHT) FRAME_TITLE_WIDTH FRAME_TITLE_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			style			WINDOW_STYLE_EMPTY					\
			textscale		TEXTSIZE_SMALL						\
			textalign		ITEM_ALIGN_MIDDLE_RIGHT				\
			textfont		CHOICE_TEXTFONT						\
			forecolor		WHITE								\
			ownerdraw		UI_LOGGEDINUSER						\
			visible			1									\
			decoration											\
		}

#define FRAME_TO_NEXT_FRAME_SLIDE_ACTION( menuFrom, menuTo )								\
		execnow changemenucloseslidedirection menuFrom MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT;	\
		execnow changemenuopenslidedirection menuFrom MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT;	\
		execnow closemenu menuFrom;															\
		execnow changemenuopenslidedirection menuTo MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT;		\
		execnow openmenu menuTo


#define FRAME_BACK_TO_FRAME_SLIDE_ACTION( menuFrom, menuTo )								\
		execnow changemenucloseslidedirection menuFrom MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT;	\
		execnow closemenu menuFrom;															\
		execnow changemenuopenslidedirection menuTo MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT;		\
		execnow openmenu menuTo

#define FRAME_SLIDE_RESET_TOP_TO_BOTTOM( menuName )											\
		execnow changemenucloseslidedirection menuName MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
		execnow changemenuopenslidedirection menuName MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
