// this defines match in q_shared.h
#define AS_UNRANKED		0
#define AS_RANKED		1
#define AS_WAGER	    2
#define AS_FAVORITES	3
#define AS_FRIENDS	    4
#define AS_HISTORY	    5


#define		B_BLACK		BLACK_RGB 0.5
#define		B_GRAY		NEW_FRAME_GREY_RGB 1
#define		B_RED		NEW_FRAME_RED_RGB 1
#define		B_BLUE		NEW_FRAME_BLUE_RGB 1
#define		B_GREEN		NEW_FRAME_GREEN_RGB 1
#define		B_WHITE		WHITE_RGB 1
#define		B_TRANSP	WHITE_RGB 0

#define		BROWSER_HIGHLIGHT_COLOR			WHITE_RGB 0.3

#define		LABEL_BORDER_UNSELECTED_COLOR	B_BLACK
#define		LABEL_BORDER_SELECTED_COLOR		B_BLACK
#define		LABEL_BG_UNSELECTED_COLOR		B_GRAY
#define		LABEL_BG_SELECTED_COLOR			BROWSER_HIGHLIGHT_COLOR
#define		LABEL_TEXT_UNSELECTED_COLOR		B_WHITE
#define		LABEL_TEXT_SELECTED_COLOR		B_WHITE
#define		HL_BORDER_UNSELECTED_COLOR		.1 .1 .1 1
#define		HL_BORDER_SELECTED_COLOR		B_WHITE
#define		HL_BG_UNSELECTED_COLOR			B_TRANSP
#define		HL_BG_SELECTED_COLOR			B_TRANSP

#undef CHOICE_HORIZONTAL_ALIGN 
#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER 

#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN VERTICAL_ALIGN_TOP

#define CONTEXT_MENU \
itemdef \
{ \
		name					server_browser_context_back \
		rect 					0 0 80 80 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP \
		exp						rect H(getContextHeight()) \
		style					WINDOW_STYLE_SHADER \
		background				"menu_mp_popup_window_small" \
		forecolor				0.2 0.2 0.2 1 \
		visible					when( localVarBool( ui_showcontextmenu ) )  \
		decoration \
} \
itemdef \
{ \
		name					dynamic_menu_feeder \
		type					ITEM_TYPE_LISTBOX \
		feeder					FEEDER_DYNAMIC_MENU \
		rect 					0 0 80 80 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP \
		exp						rect H(getContextHeight()) \
		origin					0 0 \
		style					WINDOW_STYLE_FILLED \
		elementwidth			80 \
		elementheight			18 \
		elementtype				LISTBOX_TEXT \
		textstyle				ITEM_TEXTSTYLE_NORMAL \
		textfont				UI_FONT_NORMAL \
		textscale				0.25 \
		forecolor				CHOICE_TEXTCOLOR \
		focusColor				CHOICE_TEXTCOLOR \
		disableColor			CHOICE_TEXTCOLOR \
		noBlinkingHighlight \
		noscrollbars  \
		visible					when( localVarBool( ui_showcontextmenu ) )  \
		modal \
		menuItemsDef \
		{ \
			maxRows 4 \
			menuColDef \
			{ \
				type			MENU_ITEM_TYPE_IMAGE \
				rect			1 1 0 0 ITEM_ALIGN_CENTER ITEM_ALIGN_MIDDLE \
				maxChars		20 \
			} \			
			menuColDef \
			{ \
				type			MENU_ITEM_TYPE_IMAGE_ON_HOVER \							
				rect			1 1 78 18 ITEM_ALIGN_CENTER ITEM_ALIGN_MIDDLE \
				maxChars		20 \
			} \				
			menuColDef	\
			{ \
				type			MENU_ITEM_TYPE_IMAGE_ON_HOVER \
				rect			1 1 0 0 ITEM_ALIGN_CENTER ITEM_ALIGN_MIDDLE \
				maxChars		20 \
			} \
			menuColDef \
			{ \
				type			MENU_ITEM_TYPE_LOC_TEXT \
				rect			1 1 78 18 ITEM_ALIGN_CENTER ITEM_ALIGN_TOP \
				maxChars		20 \
			} \
		} \
		onEvent Join		{	JOIN_SERVER_ACTION; setLocalVarBool ui_showcontextmenu 0; } \
		onEvent JoinReserved{	JOIN_RESERVED_ACTION; setLocalVarBool ui_showcontextmenu 0; } \
		onEvent ServerInfo	{	open newframeserverinfo; setLocalVarBool ui_showcontextmenu 0; } \
		onEvent AddFavorite	{	uiScript addFavorite; setLocalVarBool ui_showcontextmenu 0; } \
		onEvent DeleteFavorite	{	uiScript DeleteFavorite; uiScript RefreshServers; setLocalVarBool ui_showcontextmenu 0; } \
		onEvent Populate \		
		{ \
								execNow	addToFeeder	Join		MENU_JOIN_SERVER; \
								if( !isWagerServer() ) \
								{ \
									execNow addToFeeder JoinReserved PLATFORM_JOIN_RESERVED; \
								} \
								execNow addToFeeder	ServerInfo	MENU_SERVER_INFO; \
								if( dvarInt( ui_netsource ) != AS_FAVORITES ) \
								{ \
									execNow addToFeeder AddFavorite	MENU_ADD_TO_FAVORITES; \
								} \
								if( dvarInt( ui_netsource ) == AS_FAVORITES ) \
								{ \
									execNow addToFeeder DeleteFavorite	MENU_FILESHARE_REMOVE; \
								} \
		} \
		onfocus				{	play CHOICE_FOCUS_SOUND;	} \
		leaveFocus			{	setLocalVarBool ui_showcontextmenu 0;	} \
		onListboxSelectionChange	{	play CHOICE_FOCUS_SOUND; 	} \
		doubleclick			{	play CHOICE_FOCUS_SOUND; execNow raiseFeederEvent;	} \
}

#define TOOLTIP_WINDOW \
itemdef \
{ \
		name					server_browser_tooltip_back \
		rect 					0 0 80 14 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP \
		exp						rect W( getTextWidth(dvarString(ui_browserToolTip),UI_FONT_NORMAL,TEXTSIZE_SMALL) + 4) \
		exp						rect H( getTextHeight(dvarString(ui_browserToolTip),UI_FONT_NORMAL,TEXTSIZE_SMALL)) \
		style					WINDOW_STYLE_SHADER \
		background				"menu_mp_popup_window_small" \
		forecolor				0.2 0.2 0.2 1 \
		visible					when( dvarBool( ui_browserShowToolTip ) && !localVarBool( ui_showcontextmenu ) )  \
		decoration \
} \
itemdef \
{ \
		name					server_browser_tooltip_content \
		type					ITEM_TYPE_TEXT \
		rect 					0 0 80 14 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP \
		exp						rect W( getTextWidth(dvarString(ui_browserToolTip),UI_FONT_NORMAL,TEXTSIZE_SMALL)) \
		exp						rect H( getTextHeight(dvarString(ui_browserToolTip),UI_FONT_NORMAL,TEXTSIZE_SMALL)) \
		exp text				( dvarString(ui_browserToolTip) ) \
		textfont				UI_FONT_NORMAL \
		textscale				TEXTSIZE_SMALL \
		textalign				ITEM_ALIGN_TOP_RIGHT \
		forecolor				1 1 1 1 \
		visible					when( dvarBool( ui_browserShowToolTip ) && !localVarBool( ui_showcontextmenu ) )  \
		decoration \
}

#define SELECTION_IMAGE_FINAL( materialArg )		( "menu_" + materialArg + "_map_select_final" )
#define MAPIMAGE									SELECTION_IMAGE_FINAL( dvarString( ui_browserToolTip ) )

#define MAPTIP_WINDOW \
itemdef \
{ \
		name					server_browser_maptip_back \
		rect 					0 0 190 128 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP \
		style					WINDOW_STYLE_SHADER \
		background				"menu_mp_popup_window_small" \
		forecolor				0.2 0.2 0.2 1 \
		visible					when( dvarBool( ui_browserShowMapTip ) && !localVarBool( ui_showcontextmenu ) )  \
		decoration \
} \
PREPROC_SHADER_DRAW_VIS_EX( 0 0 190 128 ITEM_ALIGN_LEFT ITEM_ALIGN_TOP, MAPIMAGE, 1 1 1 1, when( dvarBool( ui_browserShowMapTip ) && !localVarBool( ui_showcontextmenu ) ), name server_browser_maptip_map; )

#define SORT_RANKED			0
#define SORT_SECURITY		1
#define SORT_PASSWORD		2
#define SORT_HOST			3
#define SORT_MAP			4
#define SORT_CLIENTS		5
#define SORT_GAME			6
#define SORT_REGION			7
#define SORT_PING			8
#define SORT_MOD			9
#define SORT_VOICE			10
#define SORT_FRIENDS		11

#define SORT_ARROW_SIZE		16
#define SORT_UP				1
#define SORT_DOWN			0
#define SORT_ARROWS( inPos, sortEnum ) \
	itemDef \
 	{ \
 		name up_arrow \
 		style WINDOW_STYLE_SHADER \
 		rect inPos SORT_ARROW_SIZE SORT_ARROW_SIZE CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 0 0 \
 		background "ui_arrow_up" \
 		visible when( serverSort() == sortEnum && serverSortDirection() == SORT_DOWN ) \
 		decoration \
 	} \
 	itemDef \
 	{ \
 		name down_arrow \
 		style WINDOW_STYLE_SHADER \
 		rect inPos SORT_ARROW_SIZE SORT_ARROW_SIZE CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 0 0 \
 		background "ui_arrow_down" \
 		visible when( serverSort() == sortEnum && serverSortDirection() == SORT_UP ) \
 		decoration \
 	}

// COLUMN BUTTON / COLUMN HIGHLIGH / SORTING
#define RANKED_SORT_COLUMN \
  	itemDef \
  	{ \
  		name ranked \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_RANKED WIDTH_RANKED_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_UNSELECTED_COLOR \
  		backcolor LABEL_BG_UNSELECTED_COLOR \
  		visible when( serverSort() != SORT_RANKED ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_RANKED ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor rankedColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor rankedColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
  	itemDef \
  	{ \
  		name ranked_selected \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_RANKED WIDTH_RANKED_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_SELECTED_COLOR \
  		backcolor LABEL_BG_SELECTED_COLOR \
  		visible when( serverSort() == SORT_RANKED ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_RANKED ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor rankedColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor rankedColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
	itemDef \
 	{ \
 		name rankedicon \
 		style WINDOW_STYLE_SHADER \
 		rect RANKED_X (LABELS_Y+2) WIDTH_RANKED WIDTH_RANKED CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 1 0 \
 		background "ors" \
 		visible 1 \
 		decoration \
 	}

 #define SECURITY_SORT_COLUMN \
  	itemDef \
  	{ \
  		name security \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_SECURITY WIDTH_SECURITY_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_UNSELECTED_COLOR \
  		backcolor LABEL_BG_UNSELECTED_COLOR \
  		visible when( serverSort() != SORT_SECURITY ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_SECURITY ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor securityColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor securityColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
  	itemDef \
  	{ \
  		name security_selected \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_SECURITY WIDTH_SECURITY_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_SELECTED_COLOR \
  		backcolor LABEL_BG_SELECTED_COLOR \
  		visible when( serverSort() == SORT_SECURITY ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_SECURITY ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor securityColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor securityColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
	itemDef \
 	{ \
 		name securityicon \
 		style WINDOW_STYLE_SHADER \
 		rect SECURITY_X (LABELS_Y+2) WIDTH_SECURITY WIDTH_SECURITY CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 1 0 \
 		background "vac" \
 		visible 1 \
 		decoration \
 	}

 #define PASSWORD_SORT_COLUMN \
  	itemDef \
  	{ \
  		name password \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_PASSWORD WIDTH_PASSWORD_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_UNSELECTED_COLOR \
  		backcolor LABEL_BG_UNSELECTED_COLOR \
  		visible when( serverSort() != SORT_PASSWORD ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_PASSWORD ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor passwordColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor passwordColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
  	itemDef \
  	{ \
  		name password_selected \
  		group grpTabs \
  		type ITEM_TYPE_BUTTON \
  		style WINDOW_STYLE_FILLED \
  		rect ORIGIN_PASSWORD WIDTH_PASSWORD_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
  		forecolor LABEL_TEXT_SELECTED_COLOR \
  		backcolor LABEL_BG_SELECTED_COLOR \
  		visible when( serverSort() == SORT_PASSWORD ) \
  		action \
  		{ \
  			play CHOICE_FOCUS_SOUND ; \
  			uiScript ServerSort SORT_PASSWORD ; \
  		} \
  		mouseEnter { show message_sort ; setitemcolor passwordColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
  		mouseExit { hide message_sort ; setitemcolor passwordColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
  	} \
	itemDef \
 	{ \
 		name passwordicon \
 		style WINDOW_STYLE_SHADER \
 		rect PASSWORD_X (LABELS_Y+2) WIDTH_PASSWORD WIDTH_PASSWORD CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 1 0 \
 		background "lock" \
 		visible 1 \
 		decoration \
 	}

#define SERVERNAME_SORT_COLUMN \
 	itemDef \
 	{ \
 		name server \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		exp text ( getServerCounts() ) \
		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_SERVER WIDTH_SERVER_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
 		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_HOST ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_HOST ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor serverColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
 		mouseExit { hide message_sort ; setitemcolor serverColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name server_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		exp text ( getServerCounts() ) \
		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_SERVER WIDTH_SERVER_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
 		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_HOST ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_HOST ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor serverColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND } \
 		mouseExit { hide message_sort ; setitemcolor serverColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	SORT_ARROWS( ORIGIN_SERVER_ARROW, SORT_HOST )

#define MAPNAME_SORT_COLUMN \
	itemDef \
 	{ \
 		name map \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_MAP_NAME_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_MAP WIDTH_MAP_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_MAP ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_MAP ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor mapColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor mapColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name map_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_MAP_NAME_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_MAP WIDTH_MAP_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_MAP ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_MAP ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor mapColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor mapColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	SORT_ARROWS( ORIGIN_MAP_ARROW, SORT_MAP )

#define PLAYERS_SORT_COLUMN \
 	itemDef \
 	{ \
 		name Players \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_NUMPLAYERS_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_PLAYER WIDTH_PLAYER_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
 		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_CLIENTS ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_CLIENTS ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor playerColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor playerColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name Players_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_NUMPLAYERS_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_PLAYER WIDTH_PLAYER_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
 		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_CLIENTS ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_CLIENTS ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor playerColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor playerColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	SORT_ARROWS( ORIGIN_PLAYER_ARROW, SORT_CLIENTS )

#define GAMETYPE_SORT_COLUMN \
 	itemDef \
 	{ \
 		name Gametype \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_GAMETYPE_CAPS" \
 		LABEL_LABEL_OFFSET \
		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_TYPE WIDTH_TYPE_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
 		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_GAME ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_GAME ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor typeColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor typeColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name Gametype_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_GAMETYPE_CAPS" \
 		LABEL_LABEL_OFFSET \
		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_TYPE WIDTH_TYPE_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
 		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_GAME ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_GAME ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor typeColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor typeColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	SORT_ARROWS( ORIGIN_TYPE_ARROW, SORT_GAME ) 

#define REGION_SORT_COLUMN \
 	itemDef \
 	{ \
 		name Region \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_REGION WIDTH_REGION_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
 		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_REGION ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_REGION ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor regionColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor regionColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name Region_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_REGION WIDTH_REGION_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
 		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_REGION ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_REGION ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor regionColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor regionColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name regionicon \
 		style WINDOW_STYLE_SHADER \
 		rect REGION_X (LABELS_Y+2) WIDTH_REGION WIDTH_REGION CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		origin 1 0 \
 		background "sb_globe" \
 		visible 1 \
 		decoration \
 	}

#define PING_SORT_COLUMN \
 	itemDef \
 	{ \
 		name Ping \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_PING_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_PING WIDTH_PING_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_UNSELECTED_COLOR \
		backcolor LABEL_BG_UNSELECTED_COLOR \
 		visible when( serverSort() != SORT_PING ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_PING ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor pingColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor pingColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	itemDef \
 	{ \
 		name Ping_selected \
 		group grpTabs \
 		type ITEM_TYPE_BUTTON \
 		text "@MENU_PING_CAPS" \
 		LABEL_LABEL_OFFSET \
 		textscale 0.25 \
 		textfont	UI_FONT_NORMAL \
 		style WINDOW_STYLE_FILLED \
 		rect ORIGIN_PING WIDTH_PING_COLUMN LABELS_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
 		textalign ITEM_ALIGN_LEFT \
 		forecolor LABEL_TEXT_SELECTED_COLOR \
		backcolor LABEL_BG_SELECTED_COLOR \
 		visible when( serverSort() == SORT_PING ) \
 		action \
 		{ \
 			play CHOICE_FOCUS_SOUND ; \
 			uiScript ServerSort SORT_PING ; \
 		} \
 		mouseEnter { show message_sort ; setitemcolor pingColumn bordercolor HL_BORDER_SELECTED_COLOR ; play CHOICE_FOCUS_SOUND} \
 		mouseExit { hide message_sort ; setitemcolor pingColumn bordercolor HL_BORDER_UNSELECTED_COLOR } \
 	} \
 	SORT_ARROWS( ORIGIN_PING_ARROW, SORT_PING ) 

// SERVER LISTBOX
#define FILTER_MENU_HEIGHT 76

#define WIDTH_RANKED		14
#define WIDTH_SECURITY		14
#define WIDTH_PASSWORD		14
#define WIDTH_SERVER		240
#define WIDTH_MAP			90
#define WIDTH_PLAYER		55
#define WIDTH_TYPE			45
#define WIDTH_REGION		14 
#define WIDTH_PING			50

#define WIDTH_RANKED_COLUMN		(WIDTH_RANKED + 4)
#define WIDTH_SECURITY_COLUMN	(WIDTH_SECURITY + 4)
#define WIDTH_PASSWORD_COLUMN	(WIDTH_PASSWORD + 4)
#define WIDTH_SERVER_COLUMN		(WIDTH_SERVER + 2)
#define WIDTH_MAP_COLUMN		(WIDTH_MAP + 2)
#define WIDTH_PLAYER_COLUMN		(WIDTH_PLAYER + 2)
#define WIDTH_TYPE_COLUMN		(WIDTH_TYPE + 2)
#define WIDTH_REGION_COLUMN		(WIDTH_REGION + 4)
#define WIDTH_PING_COLUMN		(WIDTH_PING + 2)

#define LABELS_HEIGHT		18
#define LABEL_LABEL_OFFSET	\
	textaligny (LABELS_HEIGHT-4) \
	textalignx 5 \

#define TABLE_X				(SERVER_BROWSER_BODY_X_START-5)
#define TABLE_Y				(SERVER_BROWSER_BODY_Y_START+LABELS_HEIGHT-13)

#define RANKED_X			TABLE_X
#define SECURITY_X			(RANKED_X+WIDTH_RANKED_COLUMN)
#define PASSWORD_X			(SECURITY_X+WIDTH_SECURITY_COLUMN)
#define SERVER_X			(PASSWORD_X+WIDTH_PASSWORD_COLUMN)
#define MAP_X				(SERVER_X+WIDTH_SERVER_COLUMN) 	
#define PLAYER_X			(MAP_X+WIDTH_MAP_COLUMN) 	
#define TYPE_X				(PLAYER_X+WIDTH_PLAYER_COLUMN) 	
#define REGION_X			(TYPE_X+WIDTH_TYPE_COLUMN) 	
#define PING_X				(REGION_X+WIDTH_REGION_COLUMN) 	

// column offsets for listbox
#define RANKED_X_OFFSET		4
#define SECURITY_X_OFFSET	(RANKED_X_OFFSET+WIDTH_RANKED_COLUMN)
#define PASSWORD_X_OFFSET	(SECURITY_X_OFFSET+WIDTH_SECURITY_COLUMN)
#define SERVER_X_OFFSET		(PASSWORD_X_OFFSET+WIDTH_PASSWORD_COLUMN + 4)
#define MAP_X_OFFSET		(SERVER_X_OFFSET+WIDTH_SERVER_COLUMN) 	
#define PLAYER_X_OFFSET		(MAP_X_OFFSET+WIDTH_MAP_COLUMN) 	
#define TYPE_X_OFFSET		(PLAYER_X_OFFSET+WIDTH_PLAYER_COLUMN) 	
#define REGION_X_OFFSET		(TYPE_X_OFFSET+WIDTH_TYPE_COLUMN - 4) 	
#define PING_X_OFFSET		(REGION_X_OFFSET+WIDTH_REGION_COLUMN + 4)

#define SCROLLBAR_SIZE 16 // this is actually set in code with #define SCROLLBAR_SIZE 16

#define TABLE_HEIGHT		(SERVER_BROWSER_HEIGHT-NEW_FRAME_HEADER_HEIGHT-LABELS_HEIGHT)
#define TABLE_WIDTH			(WIDTH_RANKED_COLUMN+WIDTH_PASSWORD_COLUMN+WIDTH_SECURITY_COLUMN+WIDTH_SERVER_COLUMN+WIDTH_MAP_COLUMN+WIDTH_PLAYER_COLUMN+WIDTH_TYPE_COLUMN+WIDTH_REGION_COLUMN+WIDTH_PING_COLUMN+SCROLLBAR_SIZE)
#define TABLE_RECT			TABLE_X TABLE_Y TABLE_WIDTH TABLE_HEIGHT

#define LABELS_Y (TABLE_Y-LABELS_HEIGHT)

#define ORIGIN_RANKED   	RANKED_X	LABELS_Y
#define ORIGIN_SECURITY	   	SECURITY_X	LABELS_Y
#define ORIGIN_PASSWORD   	PASSWORD_X	LABELS_Y
#define ORIGIN_SERVER 	   	SERVER_X	LABELS_Y
#define ORIGIN_MAP 		   	MAP_X		LABELS_Y
#define ORIGIN_PLAYER 	   	PLAYER_X	LABELS_Y
#define ORIGIN_TYPE 	   	TYPE_X		LABELS_Y
#define ORIGIN_REGION	   	REGION_X	LABELS_Y
#define ORIGIN_PING 	   	PING_X		LABELS_Y

#define ORIGIN_SERVER_ARROW (SERVER_X	+ WIDTH_SERVER_COLUMN	- SORT_ARROW_SIZE) LABELS_Y
#define ORIGIN_MAP_ARROW	(MAP_X		+ WIDTH_MAP_COLUMN		- SORT_ARROW_SIZE) LABELS_Y
#define ORIGIN_PLAYER_ARROW (PLAYER_X	+ WIDTH_PLAYER_COLUMN	- SORT_ARROW_SIZE) LABELS_Y
#define ORIGIN_TYPE_ARROW	(TYPE_X		+ WIDTH_TYPE_COLUMN	- SORT_ARROW_SIZE) LABELS_Y
#define ORIGIN_REGION_ARROW	(REGION_X	+ WIDTH_REGION_COLUMN	- SORT_ARROW_SIZE) LABELS_Y
#define ORIGIN_PING_ARROW	(PING_X		+ WIDTH_PING_COLUMN	- SORT_ARROW_SIZE) LABELS_Y

// #define ORIGIN_VOICE 	   	VOICE_X		TABLE_Y
// #define ORIGIN_MOD 		   	MOD_X		TABLE_Y
// #define ORIGIN_PB			PB_X		TABLE_Y

#define HIGHLIGHT_OUTLINE_HEIGHT (LABELS_HEIGHT)

//	SERVER LIST COLUMN OUTLINES	=====================================================================
#define PREPROC_HIGHLIGHT_BOX( pname, prect ) \
		PREPROC_HIGHLIGHT_BOX_RAW( pname, prect, HL_BG_UNSELECTED_COLOR )
#define PREPROC_HIGHLIGHT_BOX_RAW( pname, prect, pcolor )\
	itemDef	{\
		name pname\
		group grpColumn\
		rect prect CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN\
		origin -2 -2 \
		style WINDOW_STYLE_FILLED\
		border 1\
		backcolor pcolor\
		bordercolor HL_BORDER_UNSELECTED_COLOR\
		visible 1	\
		decoration \
	}

#define BROWSER_BG_RECT			TABLE_X TABLE_Y (TABLE_WIDTH-3-SCROLLBAR_SIZE) (TABLE_HEIGHT-2)

#define BROWSER_BG																													\
		PREPROC_SHADER_DRAW( BROWSER_BG_RECT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, "white", 0.3 0.3 0.3 0.8 )				\
		PREPROC_SHADER_DRAW( TABLE_RECT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, "menu_mp_lobby_gamercard_back", 0 0 0 0.5 )

/* SERVER FEEDER LISTBOX OUTLINE ======================================================== */
#define BROWSER_HIGHLIGHT_OUTLINES \
	PREPROC_HIGHLIGHT_BOX( rankedColumn,	ORIGIN_RANKED	WIDTH_RANKED_COLUMN			(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( securityColumn,	ORIGIN_SECURITY WIDTH_SECURITY_COLUMN 		(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( passwordColumn,	ORIGIN_PASSWORD WIDTH_PASSWORD_COLUMN 		(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( serverColumn,  	ORIGIN_SERVER 	WIDTH_SERVER_COLUMN 		(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( mapColumn,  		ORIGIN_MAP 		WIDTH_MAP_COLUMN 			(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( playerColumn,  	ORIGIN_PLAYER 	WIDTH_PLAYER_COLUMN 		(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( typeColumn,  	ORIGIN_TYPE 	WIDTH_TYPE_COLUMN 			(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX( regionColumn,  	ORIGIN_REGION	WIDTH_REGION_COLUMN			(HIGHLIGHT_OUTLINE_HEIGHT+2)) \
	PREPROC_HIGHLIGHT_BOX_RAW( pingColumn,	ORIGIN_PING 	(WIDTH_PING_COLUMN+1)			(HIGHLIGHT_OUTLINE_HEIGHT+2), HL_BG_SELECTED_COLOR)


/* SERVER FEEDER LISTBOX TEXT =========================================================== */
#define BROWSER_LISTBOX( listName, feederType, visArg ) \
	itemDef \
	{ \
		name 			listName \
		type 			ITEM_TYPE_LISTBOX \
		feeder 			feederType \
		rect 			(TABLE_X-4) (TABLE_Y-2) (TABLE_WIDTH+5-SCROLLBAR_SIZE) TABLE_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		style			WINDOW_STYLE_FILLED \
		elementwidth	128 \
		elementheight	14 \
		textfont		UI_FONT_NORMAL \
		textscale		0.25 \
		elementtype		LISTBOX_TEXT \
		forecolor		B_WHITE \
		focusColor		B_WHITE \
		disableColor	B_WHITE \
		selectBorder	B_TRANSP \
		outlinecolor	BROWSER_HIGHLIGHT_COLOR \
		visible 		visArg \
		noBlinkingHighlight \
		usePaging \
		columns	9 \
						RANKED_X_OFFSET		WIDTH_RANKED	20 ITEM_ALIGN_LEFT \
						SECURITY_X_OFFSET	WIDTH_SECURITY	20 ITEM_ALIGN_LEFT \
						PASSWORD_X_OFFSET	WIDTH_PASSWORD	20 ITEM_ALIGN_LEFT \
						SERVER_X_OFFSET		WIDTH_SERVER	32 ITEM_ALIGN_LEFT \
						MAP_X_OFFSET		WIDTH_MAP		20 ITEM_ALIGN_LEFT \
						PLAYER_X_OFFSET		WIDTH_PLAYER	10 ITEM_ALIGN_LEFT \
						TYPE_X_OFFSET		WIDTH_TYPE		22 ITEM_ALIGN_LEFT \
						REGION_X_OFFSET		WIDTH_REGION	20 ITEM_ALIGN_LEFT \
						PING_X_OFFSET		WIDTH_PING		20 ITEM_ALIGN_LEFT \
		execKeyInt K_MOUSE1 { uiScript RefreshServer; } \
		doubleClick 	{ JOIN_SERVER_ACTION; } \
		rightClick 		{ uiScript RefreshServer; setLocalVarBool ui_showcontextmenu 1; execnow showContextItem (dvarString( "ui_serverBrowserMenu" )) dynamic_menu_feeder; execnow showContextItem (dvarString( "ui_serverBrowserMenu" )) server_browser_context_back 0 0; execnow focusItem dynamic_menu_feeder; } \
		state \
        { \
				name				"Maximized" \
				rect 				(TABLE_X-4) (TABLE_Y-2) (TABLE_WIDTH+5-SCROLLBAR_SIZE) TABLE_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
        }   \
		state \
        { \
                name				"Reduced" \
                rect				(TABLE_X-4) (TABLE_Y-2) (TABLE_WIDTH+5-SCROLLBAR_SIZE) (TABLE_HEIGHT-FILTER_MENU_HEIGHT) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
        } \
	}

#define SERVER_BROWSER( listName, feederType, visArg ) \
	BROWSER_LISTBOX( listName, feederType, visArg ) \
	RANKED_SORT_COLUMN \
	SECURITY_SORT_COLUMN \
	PASSWORD_SORT_COLUMN \
	SERVERNAME_SORT_COLUMN \
	MAPNAME_SORT_COLUMN \
	PLAYERS_SORT_COLUMN \
	GAMETYPE_SORT_COLUMN \
	REGION_SORT_COLUMN \
	PING_SORT_COLUMN \
	BROWSER_HIGHLIGHT_OUTLINES \
	CONTEXT_MENU \
	GLOBAL_SERVER_COUNT \
	TOOLTIP_WINDOW \
	MAPTIP_WINDOW
