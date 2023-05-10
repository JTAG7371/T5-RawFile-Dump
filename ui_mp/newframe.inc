

// This should be put first (on bottom) in a menu
#undef	NEW_FRAME
#define NEW_FRAME( FRAME_WIDTH, FRAME_HEIGHT )																																								\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) ( -( FRAME_HEIGHT + 20 ) / 2 ) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER							\
			background      "menu_sp_lobby_frame_outer_ingame"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( dvarBool( zombietron ) || ( !IsInGame() && !dvarBool( ui_multiplayer ) ) );																																							\
			decoration																																														\
			frame           26 0.1 FRAME_SIDE_ALL																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_sp_lobby_frame_inner_ingame"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( dvarBool( zombietron ) || ( !IsInGame() && !dvarBool( ui_multiplayer ) ) );																																							\
			decoration																																														\
			frame           26 0.1 FRAME_OPEN_TOP																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) ( -( FRAME_HEIGHT + 20 ) / 2 ) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER							\
			background      "menu_mp_lobby_frame_outer_ingame"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !dvarBool( zombietron ) && IsInGame() );																																							\
			decoration																																														\
			frame           26 0.1 FRAME_SIDE_ALL																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_mp_lobby_frame_inner_ingame"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !dvarBool( zombietron ) && IsInGame() );																																							\
			decoration																																														\
			frame           26 0.1 FRAME_OPEN_TOP																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -( FRAME_WIDTH + 20 ) / 2 ) ( -( FRAME_HEIGHT + 20 ) / 2 ) ( FRAME_WIDTH + 20 ) ( FRAME_HEIGHT + 20 ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER							\
			background      "menu_mp_lobby_frame_outer"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !IsInGame() && dvarBool( ui_multiplayer ) );																																							\
			decoration																																														\
			frame           26 0.1 FRAME_SIDE_ALL																																							\
		}																																																	\
		itemDef																																																\
		{																																																	\
			style           WINDOW_STYLE_SHADER_FRAMED																																						\
			rect            ( -FRAME_WIDTH / 2 ) ( ( -FRAME_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT ) FRAME_WIDTH ( FRAME_HEIGHT - NEW_FRAME_HEADER_HEIGHT ) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			background      "menu_mp_lobby_frame_inner"																																						\
			forecolor       1 1 1 1																																											\
			visible         when( !IsInGame() && dvarBool( ui_multiplayer ) );																																							\
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
		
#undef	NEW_FRAME_TITLE
#define NEW_FRAME_TITLE( FRAME_WIDTH, FRAME_HEIGHT, titleArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(-FRAME_WIDTH/2+NEW_FRAME_DEFAULT_TITLE_X_OFFSET) (-FRAME_HEIGHT/2+2) 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			ORIGIN_TITLE \
			forecolor		1 1 1 1 \
			exp				text( titleArg ) \
			textfont		UI_FONT_EXTRABIG \
			textscale		TEXTSIZE_SUBTITLE \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_TOP_LEFT \
			visible			visArg \
			decoration \
		}


#undef	NEW_FRAME_SUBTITLE
#define NEW_FRAME_SUBTITLE( FRAME_WIDTH, FRAME_HEIGHT, titleArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(-FRAME_WIDTH/2+NEW_FRAME_DEFAULT_TITLE_X_OFFSET) (-FRAME_HEIGHT/2+NEW_FRAME_BG_Y_OFFSET(FRAME_HEIGHT)-5) 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			ORIGIN_TITLE \
			forecolor		1 1 1 0.5 \
			exp				text( titleArg ) \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_DEFAULT \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_BOTTOM_LEFT \
			visible			visArg \
			decoration \
		}

#undef	NEW_FRAME_BACK_BUTTON_ACTION
#undef	NEW_FRAME_BACK_BUTTON_DEFAULT_ACTION
#ifdef CONSOLE
	#define NEW_FRAME_BACK_BUTTON_DEFAULT_ACTION( actionArg ) \
			NEW_FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )

	#define NEW_FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
			NEW_FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )
#else // #ifdef CONSOLE
	#define NEW_FRAME_BACK_BUTTON_DEFAULT_ACTION( actionArg ) \
			NEW_FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, actionArg )

	#undef	NEW_FRAME_BUTTON_PC_ALL
	#define NEW_FRAME_BUTTON_PC_ALL( rectArg, textArg, textfontArg, textScaleArg, textAlignArg, actionArg, visArg ) \
		itemDef																						\
		{																							\
			type			ITEM_TYPE_BUTTON														\
			rect			rectArg																	\
			exp				rect W( getTextWidth(locString(textArg),textfontArg,textScaleArg)+8 )	\
			origin			0 0																		\
			text			textArg																	\
			textfont		textfontArg																\
			textscale		textScaleArg															\
			textalign		textAlignArg															\
			visible			visArg																	\
			style			WINDOW_STYLE_FILLED														\
			forecolor		1 1 1 1																	\
			backcolor		1 1 1 0																	\
			border			1																		\
			bordersize		1																		\
			bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA								\
			action																					\
			{																						\
				play CHOICE_FOCUS_SOUND;															\
				actionArg;																			\
			}																						\
			mouseEnter	{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; play CHOICE_FOCUS_SOUND; } \
			mouseexit	{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; }		\
		}
	
	#undef	NEW_FRAME_BUTTON_PC_LEFT_OFFSET
	#define NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, offsetArg, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_ALL( 0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( ( -FRAME_WIDTH / 2 + NEW_FRAME_DEFAULT_TITLE_X_OFFSET + offsetArg ) ), \
			textArg, \
			CHOICE_TEXTFONT, TEXTSIZE_DEFAULT, ITEM_ALIGN_MIDDLE_CENTER, \
			actionArg, \
			visArg )

	#undef	NEW_FRAME_BUTTON_PC_RIGHT_OFFSET
	#define NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, offsetArg, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_ALL( 0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( FRAME_WIDTH / 2 - NEW_FRAME_DEFAULT_TITLE_X_OFFSET + (offsetArg) - getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 ), \
			textArg, \
			CHOICE_TEXTFONT, TEXTSIZE_DEFAULT, ITEM_ALIGN_MIDDLE_CENTER, \
			actionArg, \
			visArg )
			
	#undef	NEW_FRAME_BUTTON_PC_CENTERED
	#define NEW_FRAME_BUTTON_PC_CENTERED( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_ALL( 0 ( FRAME_HEIGHT / 2 + 4 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( -getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) / 2 - 4 ), \
			textArg, \
			CHOICE_TEXTFONT, TEXTSIZE_DEFAULT, ITEM_ALIGN_MIDDLE_CENTER, \
			actionArg, \
			visArg )

	#undef	NEW_FRAME_BACK_BUTTON_ACTION
	#define NEW_FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, 0, "@PLATFORM_BACK", actionArg, 1 )

	#undef	NEW_FRAME_BUTTON_INTER_SPACING
	#define NEW_FRAME_BUTTON_INTER_SPACING 20

	#undef	NEW_FRAME_BUTTON_AFTER_BACK_OFFSET
	#define NEW_FRAME_BUTTON_AFTER_BACK_OFFSET ( getTextWidth( locString( "@PLATFORM_BACK" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 + NEW_FRAME_BUTTON_INTER_SPACING )
#endif // #ifdef CONSOLE


#undef	NEW_FRAME_BACK_BUTTON
#define NEW_FRAME_BACK_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )																	\
		itemDef																												\
		{																													\
			type			ITEM_TYPE_TEXT																					\
			rect			( -FRAME_WIDTH / 2 + NEW_FRAME_DEFAULT_TITLE_X_OFFSET ) ( FRAME_HEIGHT / 2 ) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			text			"@PLATFORM_BACK"																				\
			textfont		CHOICE_TEXTFONT																					\
			textscale		TEXTSIZE_DEFAULT																				\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																			\
			visible			1																								\
			decoration																										\
		}

#undef NEW_FRAME_FILTER_BUTTON_ACTION
#ifdef CONSOLE
	#define NEW_FRAME_FILTER_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg )	\
			NEW_FRAME_FILTER_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg )
#else // #ifdef CONSOLE
	#define NEW_FRAME_FILTER_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg ) \
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_BUTTON_AFTER_BACK_OFFSET, textArg, actionArg, 1 )
#endif // #ifdef CONSOLE

#undef NEW_FRAME_BACK_BUTTON_ACTION_PC_VIS
#define NEW_FRAME_BACK_BUTTON_ACTION_PC_VIS( actionArg, visArg )												\
itemDef																								\
	{																								\
		type			ITEM_TYPE_BUTTON															\
		rect			4 216 60 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_CENTER						\
		exp				rect W( getTextWidth(locString("@PLATFORM_BACK"),UI_FONT_NORMAL,TEXTSIZE_DEFAULT)+8 ) \
		origin			0 0																			\
		text			"@PLATFORM_BACK"															\
		textfont		UI_FONT_NORMAL																\
		textscale		TEXTSIZE_DEFAULT															\
		textalign		ITEM_ALIGN_MIDDLE_CENTER														\
		visible			visArg																			\
		style			WINDOW_STYLE_FILLED															\
		forecolor		1 1 1 1																		\
		backcolor		1 1 1 0																		\
		border			1								\
		bordersize		1								\
		bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA \
		mouseEnter		{ play CHOICE_FOCUS_SOUND; setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; } \
		mouseexit		{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; } \
		action { play CHOICE_FOCUS_SOUND; actionArg }												\
	}
	
#undef NEW_FRAME_BACK_BUTTON_ACTION_PC
#define NEW_FRAME_BACK_BUTTON_ACTION_PC( actionArg )												\
	NEW_FRAME_BACK_BUTTON_ACTION_PC_VIS( actionArg, 1 )

#undef  NEW_FRAME_FILTER_BUTTON
#define NEW_FRAME_FILTER_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg )														\
		itemDef																															\
		{																																\
			type			ITEM_TYPE_TEXT																								\
			rect			( -FRAME_WIDTH / 2 + 64 + 3 ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			exp				text( textArg )																								\
			textfont		CHOICE_TEXTFONT																								\
			textscale		TEXTSIZE_DEFAULT																							\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																						\
			visible			1																											\
			decoration																													\
		}																																\
		itemDef																															\
		{																																\
			type			ITEM_TYPE_BUTTON_NO_TEXT																					\
			rect			0 0 0 0																										\
			visible			1																											\
			decoration																													\
			execKeyInt BUTTON_X { actionArg }																							\
		}
		
#undef NEW_FRAME_FILE_OPTIONS_BUTTON_ACTION
#ifdef CONSOLE
	#define NEW_FRAME_FILE_OPTIONS_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
			NEW_FRAME_FILE_OPTIONS_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )
#else // #ifdef CONSOLE
	#undef	NEW_FRAME_FILE_OPTIONS_BUTTON_OFFSET
	#define NEW_FRAME_FILE_OPTIONS_BUTTON_OFFSET ( getTextWidth( locString( "@PLATFORM_BACK" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 + NEW_FRAME_BUTTON_INTER_SPACING )
	#define NEW_FRAME_FILE_OPTIONS_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_FILE_OPTIONS_BUTTON_OFFSET, textArg, actionArg, visArg )
#endif // #ifdef CONSOLE

#undef  NEW_FRAME_FILE_OPTIONS_BUTTON
#define NEW_FRAME_FILE_OPTIONS_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )				\
		itemDef																								\
		{																									\
			type			ITEM_TYPE_TEXT																	\
			rect			-200 ( FRAME_HEIGHT / 2 ) 110 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			text			textArg																			\
			textfont		UI_FONT_NORMAL																	\
			textscale		TEXTSIZE_DEFAULT																\
			textalign		ITEM_ALIGN_MIDDLE_CENTER														\
			visible			visArg																			\
			decoration																						\
		} 

#undef NEW_FRAME_PREVIOUS_MATCH_BUTTON_ACTION
#ifdef CONSOLE
	#define NEW_FRAME_PREVIOUS_MATCH_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
			NEW_FRAME_PREVIOUS_MATCH_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )
#else // #ifdef CONSOLE
	#undef	NEW_FRAME_PREVIOUS_MATCH_BUTTON_OFFSET
	#define NEW_FRAME_PREVIOUS_MATCH_BUTTON_OFFSET ( NEW_FRAME_FILE_OPTIONS_BUTTON_OFFSET + getTextWidth( locString( "@PLATFORM_FILE_OPTIONS" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 + NEW_FRAME_BUTTON_INTER_SPACING )
	#define NEW_FRAME_PREVIOUS_MATCH_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_PREVIOUS_MATCH_BUTTON_OFFSET, textArg, actionArg, visArg )
#endif // #ifdef CONSOLE

#undef  NEW_FRAME_PREVIOUS_MATCH_BUTTON
#define NEW_FRAME_PREVIOUS_MATCH_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )								\
		itemDef																													\
		{																														\
			type			ITEM_TYPE_TEXT																						\
			rect			-80 ( FRAME_HEIGHT / 2 + 16 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER					\
			text			textArg																								\
			textfont		UI_FONT_NORMAL																						\
			textscale		TEXTSIZE_DEFAULT																					\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																				\
			visible			visArg																								\
			decoration																											\
		} 
		
#undef NEW_FRAME_COMPARE_FRIEND_BUTTON_ACTION
#ifdef CONSOLE
	#define NEW_FRAME_COMPARE_FRIEND_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
			NEW_FRAME_COMPARE_FRIEND_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )
#else // #ifdef CONSOLE
	#define NEW_FRAME_COMPARE_FRIEND_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_BUTTON_AFTER_BACK_OFFSET, textArg, actionArg, visArg )
#endif // #ifdef CONSOLE

#undef  NEW_FRAME_COMPARE_FRIEND_BUTTON
#define NEW_FRAME_COMPARE_FRIEND_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, textArg, actionArg, visArg )										\
		itemDef																															\
		{																																\
			type			ITEM_TYPE_TEXT																								\
			rect			( -FRAME_WIDTH / 2 + 64 + 3 ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			exp				text( textArg )																								\
			textfont		CHOICE_TEXTFONT																								\
			textscale		TEXTSIZE_DEFAULT																							\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																						\
			visible			visArg																										\
			decoration																													\
		}
		
#undef	NEW_FRAME_DONE_BUTTON
#define NEW_FRAME_DONE_BUTTON( FRAME_WIDTH, FRAME_HEIGHT )																	\
		itemDef																												\
		{																													\
			type			ITEM_TYPE_TEXT																					\
			rect			( -FRAME_WIDTH / 2 + NEW_FRAME_DEFAULT_TITLE_X_OFFSET ) ( FRAME_HEIGHT / 2 ) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			text			"@PLATFORM_DONE"																				\
			textfont		CHOICE_TEXTFONT																					\
			textscale		TEXTSIZE_DEFAULT																				\
			textalign		ITEM_ALIGN_BOTTOM_LEFT																			\
			visible			1																								\
			decoration																										\
		}

#undef	NEW_FRAME_BUTTON_BAR_VIS
#define NEW_FRAME_BUTTON_BAR_VIS( FRAME_WIDTH, FRAME_HEIGHT, X, textArg, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			( ( -FRAME_WIDTH / 2 ) + X ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
			exp             text( textArg ) \
			textfont		CHOICE_TEXTFONT  \
			textscale		TEXTSIZE_DEFAULT  \
			textalign		ITEM_ALIGN_BOTTOM_LEFT  \
			visible			when( visArg )  \
			decoration  \
		}

#undef	NEW_FRAME_BUTTON_BAR
#define NEW_FRAME_BUTTON_BAR( FRAME_WIDTH, FRAME_HEIGHT, X, textArg ) \
		NEW_FRAME_BUTTON_BAR_VIS( FRAME_WIDTH, FRAME_HEIGHT, X, textArg, 1 )

#undef	NEW_FRAME_HOME_BUTTON_OFFSET
#undef	NEW_FRAME_PGDN_BUTTON_OFFSET
#undef	NEW_FRAME_PGUP_BUTTON_OFFSET
#define NEW_FRAME_HOME_BUTTON_OFFSET ( 0 )
#define NEW_FRAME_PGDN_BUTTON_OFFSET ( -NEW_FRAME_HOME_BUTTON_OFFSET - getTextWidth( locString( "@MPUI_LB_HOME" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 - NEW_FRAME_BUTTON_INTER_SPACING )
#define NEW_FRAME_PGUP_BUTTON_OFFSET ( NEW_FRAME_PGDN_BUTTON_OFFSET - getTextWidth( locString( "@MPUI_LB_PGDN" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 - NEW_FRAME_BUTTON_INTER_SPACING )

#undef	NEW_FRAME_HOME_BUTTON
#define NEW_FRAME_HOME_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
	NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_HOME_BUTTON_OFFSET, "@MPUI_LB_HOME", actionArg; execKeyPress K_KP_HOME, 1 )

#undef	NEW_FRAME_PGDN_BUTTON
#define NEW_FRAME_PGDN_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
	NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_PGDN_BUTTON_OFFSET, "@MPUI_LB_PGDN", actionArg; execKeyPress K_KP_PGDN, 1 )

#undef	NEW_FRAME_PGUP_BUTTON
#define NEW_FRAME_PGUP_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, actionArg ) \
	NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, NEW_FRAME_PGUP_BUTTON_OFFSET, "@MPUI_LB_PGUP", actionArg; execKeyPress K_KP_PGUP, 1 )
		
#undef	CHOICE_TEXTSTYLE
#define	CHOICE_TEXTSTYLE						ITEM_TEXTSTYLE_NORMAL
#undef	CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN					HORIZONTAL_ALIGN_CENTER
#undef	CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN					VERTICAL_ALIGN_CENTER

#undef	NEW_FRAME_BUTTON_HEIGHT
#define NEW_FRAME_BUTTON_HEIGHT					17

#undef	NEW_FRAME_BUTTON_SPACING
#define NEW_FRAME_BUTTON_SPACING				2

#undef	NEW_FRAME_SEPARATED_BUTTON_SPACING
#define NEW_FRAME_SEPARATED_BUTTON_SPACING		20

#undef	NEW_FRAME_BUTTON_NAME
#define NEW_FRAME_BUTTON_NAME					"new_frame_button_"

#undef	GET_NEW_FRAME_BUTTON_NAME
#define GET_NEW_FRAME_BUTTON_NAME( itemIndex )	NEW_FRAME_BUTTON_NAME#itemIndex

#undef	NEW_FRAME_TRANSPARENT_STATE
#define NEW_FRAME_TRANSPARENT_STATE( rgbArg )	\
		state									\
		{										\
			name		Transparent				\
			forecolor	rgbArg 0				\
		}


#undef	NEW_FRAME_BUTTON_BG
#define NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg ) \
		itemDef \
		{ \
			name		NEW_FRAME_BUTTON_NAME#itemIndex \
			style		WINDOW_STYLE_SHADER \
			rect		rectArg \
			forecolor	NEW_FRAME_BUTTON_BG_COLOR \
			background	"white" \
			visible		when( !( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex ) && visArg ); \
			decoration \
			extraArg \
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 ) \
		} \
		itemDef \
		{ \
			name		NEW_FRAME_BUTTON_NAME#itemIndex \
			style		WINDOW_STYLE_SHADER \
			rect		rectArg \
			forecolor	NEW_FRAME_BUTTON_HIGHLIGHT_COLOR \
			background	"white" \
			visible		when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg ); \
			decoration \
			extraArg \
			NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ) \
		}

#undef	NEW_FRAME_BUTTON_BG_CUSTOM_HIGHLIGHT
#define	NEW_FRAME_BUTTON_BG_CUSTOM_HIGHLIGHT( itemIndex, rectArg, visArg, hlVisArg, extraArg ) \
		itemDef \
		{ \
			name		NEW_FRAME_BUTTON_NAME#itemIndex \
			style		WINDOW_STYLE_SHADER \
			rect		rectArg \
			forecolor	NEW_FRAME_BUTTON_BG_COLOR \
			background	"white" \
			visible		when( !( hlVisArg ) && visArg ); \
			decoration \
			extraArg \
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 ) \
		} \
		itemDef \
		{ \
			name		NEW_FRAME_BUTTON_NAME#itemIndex \
			style		WINDOW_STYLE_SHADER \
			rect		rectArg \
			forecolor	NEW_FRAME_BUTTON_HIGHLIGHT_COLOR \
			background	"white" \
			visible		when( ( hlVisArg ) && visArg ); \
			decoration \
			extraArg \
			NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ) \
		}
		
#undef	NEW_FRAME_BUTTON_TEXT
#define NEW_FRAME_BUTTON_TEXT( itemIndex, rectArg, textArg, textSizeArg, textAlignArg, visArg, extraArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			name			NEW_FRAME_BUTTON_NAME#itemIndex \
			rect			rectArg \
			exp				text( textArg ); \
			textfont		CHOICE_TEXTFONT \
			textscale		textSizeArg \
			textstyle		CHOICE_TEXTSTYLE \
			textAlign		textAlignArg \
			forecolor		NEW_FRAME_BUTTON_TEXT_COLOR \
			visible			when( visArg ); \
			decoration		\
			extraArg		\
			NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ) \
		}

#undef	NEW_FRAME_BUTTON
#define NEW_FRAME_BUTTON( itemIndex, rectArg, textArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg )					\
		NEW_FRAME_BUTTON_COLOR( itemIndex, rectArg, textArg, NEW_FRAME_BUTTON_TEXT_RGB, NEW_FRAME_BUTTON_TEXT_ALPHA, NEW_FRAME_BUTTON_TEXT_HIGHLIGHT_COLOR, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg )

#undef	NEW_FRAME_BUTTON_COLOR
#define NEW_FRAME_BUTTON_COLOR( itemIndex, rectArg, textArg, rgbArg, alphaArg, highlightedColorArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg )	\
		NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg )																								\
		CHOICE_ACCEPT_HINT_NAMED_RECT_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, visArg, extraArg )															\
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX(	itemIndex, rectArg, NEW_FRAME_BUTTON_NAME,																		\
												textArg, rgbArg alphaArg,																								\
												actionArg, onFocusArg, onLeaveFocusArg,																			\
												when( visArg );, NEW_FRAME_TRANSPARENT_STATE( rgbArg ); navArg extraArg )							\
		itemDef																																					\
		{																																						\
			type			ITEM_TYPE_TEXT																														\
			name			NEW_FRAME_BUTTON_NAME#itemIndex																										\
			rect			rectArg																																\
			exp				text( textArg );																													\
			textfont		CHOICE_TEXTFONT																														\
			textscale		CHOICE_TEXTSIZE																													\
			textstyle		CHOICE_TEXTSTYLE																													\
			textAlign		CHOICE_TEXTALIGN																													\
			textAlignX		CHOICE_TEXT_OFFSET_X																												\
			forecolor		highlightedColorArg																													\
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg );														\
			decoration																																			\
			extraArg																																			\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 )																												\
		} 

#undef	NEW_FRAME_BUTTON_COLOR_NOICON
#define NEW_FRAME_BUTTON_COLOR_NOICON( itemIndex, rectArg, textArg, rgbArg, alphaArg, highlightedColorArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg ) \
		NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg ) \
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, textArg, rgbArg alphaArg, actionArg, onFocusArg, onLeaveFocusArg, when( visArg );, NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ); navArg extraArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			name			NEW_FRAME_BUTTON_NAME#itemIndex \
			rect			rectArg \
			exp				text( textArg ); \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_DEFAULT \
			textstyle		CHOICE_TEXTSTYLE \
			textAlign		CHOICE_TEXTALIGN \
			textAlignX		CHOICE_TEXT_OFFSET_X \
			forecolor		highlightedColorArg \
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg ); \
			decoration		\
			extraArg		\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 ) \
	} 

#undef	NEW_FRAME_BUTTON_NOICON
#define NEW_FRAME_BUTTON_NOICON( itemIndex, rectArg, textArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg ) \
		NEW_FRAME_BUTTON_COLOR_NOICON( itemIndex, rectArg, textArg, 1 1 1, 1, 0 0 0 1, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg )

#undef	NEW_FRAME_BUTTON_CUSTOM_HIGHLIGHT
#define	NEW_FRAME_BUTTON_CUSTOM_HIGHLIGHT( itemIndex, rectArg, textArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, hlVisArg, navArg, extraArg ) \
		NEW_FRAME_BUTTON_COLOR_CUSTOM_HIGHLIGHT( itemIndex, rectArg, textArg, NEW_FRAME_BUTTON_TEXT_RGB, NEW_FRAME_BUTTON_TEXT_ALPHA, NEW_FRAME_BUTTON_TEXT_HIGHLIGHT_COLOR, actionArg, onFocusArg, onLeaveFocusArg, visArg, hlVisArg, navArg, extraArg )

#undef	NEW_FRAME_BUTTON_COLOR_CUSTOM_HIGHLIGHT
#define NEW_FRAME_BUTTON_COLOR_CUSTOM_HIGHLIGHT( itemIndex, rectArg, textArg, rgbArg, alphaArg, highlightedColorArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, hlVisArg, navArg, extraArg )	\
		NEW_FRAME_BUTTON_BG_CUSTOM_HIGHLIGHT( itemIndex, rectArg, visArg, hlVisArg, extraArg )																	\
		CHOICE_ACCEPT_HINT_NAMED_RECT_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, visArg, extraArg )															\
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX(	itemIndex, rectArg, NEW_FRAME_BUTTON_NAME,																		\
												textArg, rgbArg alphaArg,																						\
												actionArg, onFocusArg, onLeaveFocusArg,																			\
												when( visArg );, NEW_FRAME_TRANSPARENT_STATE( rgbArg ); navArg extraArg )										\
		itemDef																																					\
		{																																						\
			type			ITEM_TYPE_TEXT																														\
			name			NEW_FRAME_BUTTON_NAME#itemIndex																										\
			rect			rectArg																																\
			exp				text( textArg );																													\
			textfont		CHOICE_TEXTFONT																														\
			textscale		CHOICE_TEXTSIZE																														\
			textstyle		CHOICE_TEXTSTYLE																													\
			textAlign		CHOICE_TEXTALIGN																													\
			textAlignX		CHOICE_TEXT_OFFSET_X																												\
			forecolor		highlightedColorArg																													\
			visible			when( hlVisArg && visArg );																											\
			decoration																																			\
			extraArg																																			\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 )																												\
		} 
		
#undef	NEW_FRAME_NEWICON_VIS
#define NEW_FRAME_NEWICON_VIS( itemIndex, visArg, extraArgs ) \
		CHOICE_NEWICON_VIS(	itemIndex, "menu_mp_lobby_new", when( visArg ); extraArgs; NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ); )

#undef	NEWICON_WIDTH			
#define NEWICON_WIDTH				(CHOICE_SIZE_Y*2)
#undef	NEWICON_HEIGHT
#define NEWICON_HEIGHT				CHOICE_SIZE_Y

#undef	NEW_FRAME_NEWICON_RECT_VIS
#define NEW_FRAME_NEWICON_RECT_VIS( px, py, pw, ph, palign, visArg, extraArgs )			\
		PREPROC_SHADER_DRAW_VIS_EX(	(px+pw) (py) NEWICON_WIDTH NEWICON_HEIGHT palign,	\
									"menu_mp_lobby_new", 1 1 1 1,						\
									when( visArg );,									\
									extraArgs; NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ); )	

#undef	NEW_FRAME_LOCKEDICON_VIS
#define NEW_FRAME_LOCKEDICON_VIS( itemIndex, visArg, extraArgs ) \
		CHOICE_LOCKEDICON_VIS(	itemIndex, "menu_mp_lobby_locked", when( visArg ); extraArgs; NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ); )

#undef	NEW_FRAME_LOCKEDICON_RECT_VIS
#define NEW_FRAME_LOCKEDICON_RECT_VIS( px, py, pw, ph, palign, visArg, extraArgs )				\
		PREPROC_SHADER_DRAW_VIS_EX(	(px+pw) (py+ph/2-LOCK_SIZE/2) LOCK_SIZE LOCK_SIZE palign,	\
									"menu_mp_lobby_locked", 1 1 1 1,							\
									when( visArg );,											\
									extraArgs; NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ) )

#undef	NEW_FRAME_DBUTTON
#define NEW_FRAME_DBUTTON( itemIndex, rectArg, textArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg ) \
		NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg ) \
		CHOICE_ACCEPT_HINT_NAMED_RECT_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, visArg, extraArg ) \
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, textArg, MEDIUM_GRAY, actionArg, onFocusArg, onLeaveFocusArg, when( visArg );, NEW_FRAME_TRANSPARENT_STATE( 0 0 0 ); navArg extraArg ) 
		
#undef	NEW_FRAME_BUTTON_NOICON_EXECKEY
#define NEW_FRAME_BUTTON_NOICON_EXECKEY( itemIndex, rectArg, textArg, actionArg, onFocusArg, onLeaveFocusArg, visArg, navArg, extraArg, execKeyArgs ) \
		NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg ) \
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, rectArg, NEW_FRAME_BUTTON_NAME, textArg, 1 1 1 1, actionArg, onFocusArg, onLeaveFocusArg, when( visArg );, NEW_FRAME_TRANSPARENT_STATE( 1 1 1 ); navArg extraArg execKeyArgs) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			name			NEW_FRAME_BUTTON_NAME#itemIndex \
			rect			rectArg \
			exp				text( textArg ); \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_DEFAULT \
			textstyle		CHOICE_TEXTSTYLE \
			textAlign		CHOICE_TEXTALIGN \
			textAlignX		CHOICE_TEXT_OFFSET_X \
			forecolor		0 0 0 1 \
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg ); \
			decoration		\
			extraArg		\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 ) \
		}

#undef	NEW_DVARSLIDER
#define NEW_DVARSLIDER( itemIndex, rectArg, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg ) \
		NEW_DVARSLIDER_VIS( itemIndex, rectArg, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg, 1 )

#undef	NEW_DVARSLIDER_VIS
#define NEW_DVARSLIDER_VIS( itemIndex, rectArg, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg, visArg ) \
		NEW_DVARSLIDER_VIS_EX( itemIndex, rectArg, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg, ;, visArg )

#undef	NEW_DVARSLIDER_VIS_EX
#define NEW_DVARSLIDER_VIS_EX( itemIndex, rectArg, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg, extraArg, visArg )									\
		NEW_FRAME_BUTTON_BG( itemIndex, rectArg, visArg, extraArg )																								\
		itemDef																																					\
		{																																						\
			type			ITEM_TYPE_SLIDER																													\
			dvarfloat		dvarArg defaultArg minArg maxArg																									\
			rect			CHOICE_ORIGIN( itemIndex ) (CHOICE_SIZE_X) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN								\
			textalign		ITEM_ALIGN_MIDDLE_LEFT																												\
			textalignx		(CHOICE_SIZE_X-140) /*(-(CHOICE_TEXT_OFFSET_X))*/																					\
			textscale		CHOICE_TEXTSIZE																														\
			textstyle		ITEM_TEXTSTYLE_NORMAL																												\
			style			WINDOW_STYLE_FILLED																													\
			forecolor		CHOICE_TEXTCOLOR																													\
			visible			when( visArg )																														\
			onFocus																																				\
			{																																					\
				play CHOICE_FOCUS_SOUND;																														\
				setLocalVarInt ui_highlight itemIndex;																											\
				setLocalVarString ui_choicegroup CHOICE_GROUP;																									\				
				onFocusArg																																		\
			}																																					\
			extraArg																																			\
		}																																						\
		itemDef																																					\
		{																																						\
			type			ITEM_TYPE_TEXT																														\
			name			NEW_FRAME_BUTTON_NAME#itemIndex																										\
			rect			rectArg																																\
			exp				text( textArg );																													\
			textfont		CHOICE_TEXTFONT																														\
			textscale		TEXTSIZE_DEFAULT																													\
			textstyle		CHOICE_TEXTSTYLE																													\
			textAlign		CHOICE_TEXTALIGN																													\
			textAlignX		CHOICE_TEXT_OFFSET_X																												\
			forecolor		0 0 0 1																																\
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg );														\
			decoration																																			\
			extraArg																																			\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 )																												\
		}																																						\
		itemDef																																					\
		{																																						\
			type			ITEM_TYPE_TEXT																														\
			name			NEW_FRAME_BUTTON_NAME#itemIndex																										\
			rect			rectArg																																\
			exp				text( textArg );																													\
			textfont		CHOICE_TEXTFONT																														\
			textscale		TEXTSIZE_DEFAULT																													\
			textstyle		CHOICE_TEXTSTYLE																													\
			textAlign		CHOICE_TEXTALIGN																													\
			textAlignX		CHOICE_TEXT_OFFSET_X																												\
			forecolor		1 1 1 1																																\
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) != itemIndex && visArg );														\
			decoration																																			\
			extraArg																																			\
			NEW_FRAME_TRANSPARENT_STATE( 0 0 0 )																												\
		}																																						

