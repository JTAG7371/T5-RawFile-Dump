
#include "ui/framestyle.inc"
#include "ui_mp/newframe.inc"
#include "ui/frame.inc"

#undef COLUMN_TITLE_Y
#define COLUMN_TITLE_Y -80

#undef COLUMN_TITLE_X
#define COLUMN_TITLE_X -245

#ifndef BASE_LB_TYPES_COUNT
#define BASE_LB_TYPES_COUNT int(tableLookup( "mp/gameTypesTable.csv", 0, "maxnum_gametype", 1 ))
#endif 

#undef LEADERBOARD_HEIGHT 
#define LEADERBOARD_HEIGHT NEW_FRAME_DEFAULT_HEIGHT

#undef LEADERBOARD_WIDTH 
#define LEADERBOARD_WIDTH ( LEADERBOARD_HEIGHT * FRAME_ASPECT_RATIO )

#undef CHOICE_HORIZONTAL_ALIGN 
#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

#undef CHOICE_VERTICAL_ALIGN 
#define CHOICE_VERTICAL_ALIGN VERTICAL_ALIGN_CENTER

#undef LEADERBOARD_GAMEMODE_TITLE_Y_START 
#define LEADERBOARD_GAMEMODE_TITLE_Y_START (-LEADERBOARD_HEIGHT/2+40)


#ifdef PS3
#define LEADERBOARD_TITLE_TEXTFONT		UI_FONT_SMALL
#else //#ifdef PS3
#define LEADERBOARD_TITLE_TEXTFONT		UI_FONT_NORMAL
#endif //#ifdef PS3

#undef GET_LEADERBOARD_GAMEMODE_TITLE
#ifdef CONSOLE
	#define GET_LEADERBOARD_GAMEMODE_TITLE getLbTypeWithButtons()
#else // #ifdef CONSOLE
	#define GET_LEADERBOARD_GAMEMODE_TITLE "@" + tableLookup( "mp/gameTypesTable.csv", 1, dvarString( lb_type ), 3 )
#endif // #ifdef CONSOLE

#define LEADERBOARD_MINREQ_TEXT \
		itemDef \
		{ \
			name			lb_minreq_text \
			type			ITEM_TYPE_TEXT \
			rect			(-LEADERBOARD_WIDTH/2+2) (LEADERBOARD_HEIGHT/2-20) 500 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			forecolor		1 1 1 1 \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_SMALL \
			textstyle		CHOICE_TEXTSTYLE \ 
			textalign		ITEM_ALIGN_MIDDLE_CENTER \
			exp				text( GetLeaderboardMinReqText( dvarString("lb_type"), dvarInt("lb_typeByResetPeriod") ) );	\
			visible			when( !dvarBool( lb_prestige ) || ( dvarBool( lb_prestige ) && isItemPurchased(getItemIndex("FEATURE_PRESTIGE_LB")) ) ) \
			decoration  \
		} \
		itemDef \
		{ \
			name			lb_minreq_text \
			type			ITEM_TYPE_TEXT \
			rect			(-LEADERBOARD_WIDTH/2+17) (LEADERBOARD_HEIGHT/2-20) 500 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			forecolor		1 1 1 1 \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_SMALL \
			textstyle		CHOICE_TEXTSTYLE \ 
			textalign		ITEM_ALIGN_MIDDLE_CENTER \
			exp				text( locString( "MPUI_PRESTIGE_LB_PURCHASE_CONF", getItemCost(getItemIndex("FEATURE_PRESTIGE_LB")) ) );	\
			visible			when( ( dvarBool( lb_prestige ) && !isItemPurchased(getItemIndex("FEATURE_PRESTIGE_LB")) ) ) \
			decoration  \
		} \
		PREPROC_SHADER_DRAW_VIS_EX( (-LEADERBOARD_WIDTH/2+10) (LEADERBOARD_HEIGHT/2-15) 10 10 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "ui_arrow_right", 1 1 1 0.4, when( dvarInt("lb_type") <= (BASE_LB_TYPES_COUNT-1) && GetLeaderboardMinReqText( dvarString("lb_type"), dvarInt("lb_typeByResetPeriod") ) != "" ), ; )
			
#undef LEADERBOARD_GAMEMODE_TITLE
#ifdef PC
	#define LEADERBOARD_GAMEMODE_TITLE( titleArg, leftClickActionArg, rightClickActionArg ) \
		SIMPLE_CHOICE_BUTTON_ARROWS_CENTERED( titleArg, 0, -128, 240, GET_LEADERBOARD_GAMEMODE_TITLE, \
			1, leftClickActionArg, rightClickActionArg ) \
		LEADERBOARD_MINREQ_TEXT
#else //#ifdef PC
	#define LEADERBOARD_GAMEMODE_TITLE( titleArg, leftClickActionArg, rightClickActionArg ) \
		itemDef \
		{ \
			name			gamemode_title \
			type			ITEM_TYPE_TEXT \
			rect			-250 -126 500 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			forecolor		COLOR_TITLE \
			textfont		LEADERBOARD_TITLE_TEXTFONT \
			textscale		TEXTSIZE_DEFAULT  \
			textstyle		CHOICE_TEXTSTYLE \
			textalign		ITEM_ALIGN_MIDDLE_CENTER \
			exp				text( GET_LEADERBOARD_GAMEMODE_TITLE ) \
			visible			1 \
			decoration  \
		} \
		LEADERBOARD_MINREQ_TEXT
#endif //#ifdef PC		


#undef LEADERBOARD_SELECT_ACTION 
#define LEADERBOARD_SELECT_ACTION( menuName ) \
		execnow set selectedPlayerXuid ( getfeederdata( "xuid" ) ); \
		execnow set selectedFriendName ( getfeederdata( "name" ) ); \
		if( dvarInt("ui_leaderboardFeederCountNotZero") == 1 ) \
		{ \
			if( getfeederdata( "xuid" ) != getXuid() ) \
			{ \
				execnow changemenuopenslidedirection menu_playercard MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT; \
				execNow openMenu menu_playercard; \
			} \
			else \
			{ \
				execnow changemenuopenslidedirection menu_playercard_self MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT; \
				execNow openMenu menu_playercard_self; \
			} \
			CHANGE_MENU_SLIDE_DIRECTION( menuName, MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT, MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT ) \
			close self; \
		} 

#undef LEADERBOARD_LIST_X_START
#define LEADERBOARD_LIST_X_START ( -LEADERBOARD_WIDTH/2 + 15 )

#undef LEADERBOARD_LIST_Y_START
#define LEADERBOARD_LIST_Y_START ( -80 )

#undef LIST_WIDTH
#define LIST_WIDTH 535

#undef LIST_HEIGHT
#define LIST_HEIGHT 240

#define TAB_BG_PAD				5
#define FILTER_1_WIDTH				( (LEADERBOARD_FILTER_SETTINGS_X+53) + getTextWidth( getLBFilter(), CHOICE_TEXTFONT, TEXTSIZE_SMALL ) + (TAB_BG_PAD) )
#define DURATION_2_WIDTH			( FILTER_1_WIDTH + getTextWidth( locString( "@MPUI_AND" ), CHOICE_TEXTFONT, TEXTSIZE_SMALL ) + (TAB_BG_PAD) ) 
#include "ui_mp/popupstyle.inc"

#define LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_1	getTextWidth( locString( "@MPUI_FILTER_SET" ), CHOICE_TEXTFONT, TEXTSIZE_SMALL )
#define LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_2	getTextWidth( getLBFilter(), CHOICE_TEXTFONT, TEXTSIZE_SMALL )
#define LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_3	getTextWidth( locString( "@MPUI_AND" ), CHOICE_TEXTFONT, TEXTSIZE_SMALL )
#define LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_4	getTextWidth( getLBTypeByDuration(), CHOICE_TEXTFONT, TEXTSIZE_SMALL )
#define LEADERBOARD_FILTER_SETTINGS_DESC_HEIGHT		10

#define LEADERBOARD_FILTER_SETTINGS_DESC_X_1_START	( ( FRAME_DEFAULT_WIDTH / 2 ) - 185 )
#define LEADERBOARD_FILTER_SETTINGS_DESC_X_2_START	( LEADERBOARD_FILTER_SETTINGS_DESC_X_1_START + LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_1 + TAB_BG_PAD )
#define LEADERBOARD_FILTER_SETTINGS_DESC_X_3_START	( LEADERBOARD_FILTER_SETTINGS_DESC_X_2_START + LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_2 + TAB_BG_PAD )
#define LEADERBOARD_FILTER_SETTINGS_DESC_X_4_START	( LEADERBOARD_FILTER_SETTINGS_DESC_X_3_START + LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_3 + TAB_BG_PAD )
#define LEADERBOARD_FILTER_SETTINGS_DESC_Y			( ( -FRAME_DEFAULT_HEIGHT / 2 ) + 47 )

#undef LEADERBOARD_FILTER_SETTINGS_DESC
#define LEADERBOARD_FILTER_SETTINGS_DESC	\
	PREPROC_TEXT_DRAW_ADV_VIS_EX(	LEADERBOARD_FILTER_SETTINGS_DESC_X_1_START,LEADERBOARD_FILTER_SETTINGS_DESC_Y,LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_1,LEADERBOARD_FILTER_SETTINGS_DESC_HEIGHT,HORIZONTAL_ALIGN_CENTER,VERTICAL_ALIGN_CENTER, locString( "@MPUI_FILTER_SET" ),	TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, LEADERBOARD_TITLE_COLOR, 1, ; ) 	\
	PREPROC_TEXT_DRAW_ADV_VIS_EX(	LEADERBOARD_FILTER_SETTINGS_DESC_X_2_START,LEADERBOARD_FILTER_SETTINGS_DESC_Y,LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_2,LEADERBOARD_FILTER_SETTINGS_DESC_HEIGHT,HORIZONTAL_ALIGN_CENTER,VERTICAL_ALIGN_CENTER, getLBFilter(),					TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1, 1, ; ) 	\
	PREPROC_TEXT_DRAW_ADV_VIS_EX(	LEADERBOARD_FILTER_SETTINGS_DESC_X_3_START,LEADERBOARD_FILTER_SETTINGS_DESC_Y,LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_3,LEADERBOARD_FILTER_SETTINGS_DESC_HEIGHT,HORIZONTAL_ALIGN_CENTER,VERTICAL_ALIGN_CENTER, locString( "@MPUI_AND" ),			TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, LEADERBOARD_TITLE_COLOR, 1, ; )	\
	PREPROC_TEXT_DRAW_ADV_VIS_EX(	LEADERBOARD_FILTER_SETTINGS_DESC_X_4_START,LEADERBOARD_FILTER_SETTINGS_DESC_Y,LEADERBOARD_FILTER_SETTINGS_DESC_WIDTH_4,LEADERBOARD_FILTER_SETTINGS_DESC_HEIGHT,HORIZONTAL_ALIGN_CENTER,VERTICAL_ALIGN_CENTER, getLBTypeByDuration(),			TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1, 1, ; )

#undef COMMON_LB_COLUMNS 
#define COMMON_LB_COLUMNS \
		LEADERBOARD_COL_TITLE_VIS( (COLUMN_TITLE_X-22) COLUMN_TITLE_Y, "@MPUI_RANK", ITEM_ALIGN_LEFT, 1 ) \
		LEADERBOARD_COL_TITLE_VIS( (COLUMN_TITLE_X+50) COLUMN_TITLE_Y, "@MPUI_LEVEL", ITEM_ALIGN_LEFT, 1 ) \
		LEADERBOARD_COL_TITLE_VIS( (COLUMN_TITLE_X+88) COLUMN_TITLE_Y, "@XBOXLIVE_PLAYER", ITEM_ALIGN_LEFT, 1 ) \
		LEADERBOARD_COL_TITLE_VIS( (COLUMN_TITLE_X+290) (COLUMN_TITLE_Y-13.5), "@MPUI_SCORE_PER_MINUTE", ITEM_ALIGN_RIGHT, 1 )
		
#undef LB_BOTTOM_BAR
#ifdef CONSOLE
	#define LB_BOTTOM_BAR( FRAME_WIDTH, FRAME_HEIGHT, backActionArg, filterActionArg )
#else // #ifdef CONSOLE
	#define LB_BOTTOM_BAR( FRAME_WIDTH, FRAME_HEIGHT, backActionArg, filterActionArg )				\
	/* Back Button */																				\
	NEW_FRAME_BACK_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, backActionArg )						\
	/* Filter Button */																				\
	NEW_FRAME_FILTER_BUTTON_ACTION( FRAME_WIDTH, FRAME_HEIGHT, "@PLATFORM_FILTER", filterActionArg )\
	NEW_FRAME_HOME_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, setFocus leaderboard )						\
	NEW_FRAME_PGDN_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, setFocus leaderboard )						\
	NEW_FRAME_PGUP_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, setFocus leaderboard )
#endif // #ifdef CONSOLE


#include "ui_mp/popupstyle.inc"
#include "ui/choices_setup_popmenu.menu"

#undef CHANGE_LB_FILTER
#define CHANGE_LB_FILTER \
	execKeyInt BUTTON_A \
	{ \
		if( ( milliseconds() - dvarInt( leaderBoardLastFetchTime ) ) > MIN_DELAY_FOR_LB_READ ) \
		{ \
			execNow set leaderBoardLastFetchTime ( milliseconds() ); \
			execnow "downloadingleaderboard"; \
			play CHOICE_FOCUS_SOUND; \
			execNow set lb_filter ( dvarInt( lb_filter_scroll ) ); \
		} \
	}
	
#undef CHANGE_LB_PERIOD_TYPE
#define CHANGE_LB_PERIOD_TYPE \
	execKeyInt BUTTON_A \
	{ \
		if( ( milliseconds() - dvarInt( leaderBoardLastFetchTime ) ) > MIN_DELAY_FOR_LB_READ ) \
		{ \
			execNow set leaderBoardLastFetchTime ( milliseconds() ); \
			execnow "downloadingleaderboard"; \
			execNow set lb_typeByResetPeriod ( dvarInt( lb_typeByResetPeriod_scroll ) ); \
			uiScript RefreshLeaderboards; \
		} \
	}

#undef CHANGE_LB_TYPE_DEC
#define CHANGE_LB_TYPE_DEC \
	if( ( milliseconds() - dvarInt( leaderBoardLastFetchTime ) ) > MIN_DELAY_FOR_LB_READ ) \
	{ \
		execNow set leaderBoardLastFetchTime ( milliseconds() ); \
		execNow "toggle lb_type 13 9 8 7 6 5 4 3 2 1 0"; \
		closeImmediate self; \
        setdvar lb_common_menu_prefix "menu_leaderboard_"; \
		if( dvarInt("lb_type") > (BASE_LB_TYPES_COUNT-1) ) \
		{ \
			execNow set baseLbType (tableLookup( "mp/gameTypesTable.csv", 0, (dvarInt("lb_type")-BASE_LB_TYPES_COUNT), 1 )); \
		} \
		else \ 
		{ \ 
			execNow set baseLbType (dvarString("lb_type")); \
		} \
        setdvar leaderboard_menu_name dvarString( lb_common_menu_prefix + baseLbType ) \
		execnow openmenuImmediate (dvarString(leaderboard_menu_name)); \
		execnow "downloadingleaderboard"; \
	}

#undef CHANGE_LB_TYPE_INC
#define CHANGE_LB_TYPE_INC \
	if( ( milliseconds() - dvarInt( leaderBoardLastFetchTime ) ) > MIN_DELAY_FOR_LB_READ ) \
	{ \
		execNow set leaderBoardLastFetchTime ( milliseconds() ); \
		execNow "toggle lb_type 0 1 2 3 4 5 6 7 8 9 13"; \
		closeImmediate self; \
	    setdvar lb_common_menu_prefix "menu_leaderboard_"; \
		if( dvarInt("lb_type") > (BASE_LB_TYPES_COUNT-1) ) \
		{ \
			execNow set baseLbType (tableLookup( "mp/gameTypesTable.csv", 0, (dvarInt("lb_type")-BASE_LB_TYPES_COUNT), 1 )); \
		} \
		else \ 
		{ \ 
			execNow set baseLbType (dvarString("lb_type")); \
		} \
        setdvar leaderboard_menu_name dvarString( lb_common_menu_prefix + baseLbType ) \
		execnow openmenuImmediate (dvarString(leaderboard_menu_name)); \
		execnow "downloadingleaderboard"; \
	}

#undef	CHOICE_BUTTON_NAME
#define CHOICE_BUTTON_NAME		"menu_lb_filter"
#undef	MENUDEF_NAME
#define MENUDEF_NAME			menu_lb_filter
#undef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X 100000
#undef CHOICE_Y_START
#define CHOICE_Y_START		40

#undef ON_APPLY_ACTION
#define ON_APPLY_ACTION																		\
	if( ( milliseconds() - dvarInt( leaderBoardLastFetchTime ) ) > MIN_DELAY_FOR_LB_READ )	\
	{																						\
		execNow set leaderBoardLastFetchTime ( milliseconds() );							\
		execnow "downloadingleaderboard";													\
		execNow set lb_typeByResetPeriod ( dvarInt( lb_typeByResetPeriod_scroll ) );		\
		execNow set lb_filter ( dvarInt( lb_filter_scroll ) );								\
		uiScript RefreshLeaderboards;														\
	}																						\
	close self;
	
menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( menu_lb_filter, ;, ;, 1 )
		SYSTEM_POPUP_TITLE_VIS( "@MPUI_LB_FILTER", 1 )

		execKeyInt BUTTON_A 
		{ 
			ON_APPLY_ACTION
			}

		FRAME_CHOICE_DVARFLOATLIST_VIS( 1, "@MPUI_LB_PLAYERS", lb_filter_scroll, { "@MPUI_LB_EVERYONE_CAPS" 0 "@MPUI_LB_FRIENDS_ONLY_CAPS" 1 }, ;, 1 )
		
		FRAME_CHOICE_DVARFLOATLIST_VIS( 2, "@MPUI_DURATION_CAPS", lb_typeByResetPeriod_scroll, { "@MPUI_LB_ALL_TIME" 0 "@MPUI_LB_WEEKLY" 1 "@MPUI_LB_MONTHLY" 2 }, ;, 1 )
		
#ifdef PC
		SYSTEM_POPUP_BACK_BUTTON
		SYSTEM_POPUP_BUTTON2( "@PLATFORM_LB_APPLY_FILTER", ON_APPLY_ACTION, 1 )
#else //#ifdef PC
		GAMEPAD_BUTTON( 0 185 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "@PLATFORM_BACK", BUTTON_B{ close self; }, when ( 1 ) )
		
		itemDef
		{
			name			accept_button
			type			ITEM_TYPE_TEXT
			text			"@PLATFORM_LB_APPLY_FILTER"
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_CENTER
			rect			100 185 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
			visible			when( 1 );
			decoration
		}
#endif //#ifdef PC
}
