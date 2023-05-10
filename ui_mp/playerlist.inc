

#define ELEMENT_HEIGHT					16
#define PLAYERLIST_WIDTH				235

#define COLUMN_SCORE_WIDTH				34
#define RANK_BG_WIDTH					33
#define COLUMN_NAME_WIDTH				(PLAYERLIST_WIDTH - COLUMN_SCORE_WIDTH - RANK_BG_WIDTH)
#define PLAYER_FEEDER_Y					16

#define BACKGROUND_TEXTURE_COLOR		0 0 0 0.7
#define COLUMN_HEADER_COLOR				1 1 1 1

#undef PLAYERLIST_SELECTED_ACTIONS
#define PLAYERLIST_SELECTED_ACTIONS																							\
				doubleClick	{																								\
					if ( IsGuest() )																						\
					{																										\
						open error_guest_popmenu;																			\
					}																										\
					else																									\
					{																										\
						execNow set selectedPlayerXuid ( dvarString( "highlightedPlayerXuid" ) );							\
						execNow set selectedFriendName ( dvarString( "highlightedPlayerName" ) );							\	
						execNow set selectedFriendClanTag ( dvarString( "highlightedPlayerClanTag" ) );						\	
						if( dvarString( "selectedPlayerXuid" ) != "0" && !IsGuestByXUID( getfeederdata( "xuid" ) ) )		\
						{																									\			
							if( dvarString( "selectedPlayerXuid" ) != getXuid() )											\
							{																									\
								execnow changemenuopenslidedirection menu_playercard MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;		\
								open menu_playercard;																			\
							}																									\
							else																								\
							{																									\
								if ( dvarInt( xblive_basictraining ) )															\
								{																								\
									execnow changemenuopenslidedirection menu_playercard_self_basictraining MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
									open "menu_playercard_self_basictraining";													\
								}																								\
								else																							\
								{																								\
									execnow changemenuopenslidedirection menu_playercard_self MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
									open "menu_playercard_self";																\
								}																								\
							}																									\
						}																										\
					}																											\
				}																												\
				PAD_LEFT
		

#ifndef PLAYERLIST_SCOREVIS
	#define PLAYERLIST_SCOREVIS			((!dvarbool( party_timerVisible ) || !dvarbool( party_teambased ) || !dvarbool( party_autoteams )) && !dvarInt( splitscreen ))
#endif

#ifndef FEEDER_MENU_NAME
	#define FEEDER_MENU_NAME			"playerlist.inc needs a menu name defined"
#endif

#ifdef PARTY_THEME
	#define PLATING_COLOR				0.3 0.225 0.2 1
	#define HL_COLOR					1 0.85 0.825 0.2
	#define PARTY_LABEL_COLOR			1 0.925 0.7 0.07
	#define PARTY_LABEL_SCALE			1.75
#else
	#define PLATING_COLOR				0.175 0.2 0.25 1
	#define HL_COLOR					0.85 0.85 0.925 0.2
	#define PARTY_LABEL_COLOR			0.9 0.925 1 0.07
	#define PARTY_LABEL_SCALE			1.75
#endif

#ifdef SPLITSCREEN_PLAYERLIST

	#undef PLATING_COLOR				
	#undef HL_COLOR			
	#undef PARTY_LABEL_COLOR			
	#undef PARTY_LABEL					
	#undef PARTY_LABEL_SCALE			
	#define PLATING_COLOR				0.2 0.2 0.225 1
	#define HL_COLOR					0.85 0.85 0.925 0.2
	#define PARTY_LABEL_COLOR			0.9 0.925 1 0.07
	#define PARTY_LABEL					""
	#define PARTY_LABEL_SCALE			1.75
	
	#ifndef PS3
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT			149
	#else
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT			310
	#endif
#endif

#define PLAYERLIST_PARTYFEEDER( feederName, feederArg, yOffsetArg, heightArg, disableColorArg, backColorArg, actionsArg, visArg )			\	
		itemDef																																\
		{																																	\
			name			feederName																										\
			type			ITEM_TYPE_LISTBOX																								\
			feeder			feederArg																										\
			rect			(-PLAYERLIST_WIDTH) yOffsetArg PLAYERLIST_WIDTH heightArg HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP				\
			elementwidth	300																												\
			elementheight	ELEMENT_HEIGHT																									\
			elementtype		LISTBOX_TEXT																									\
			textfont		UI_FONT_SMALL																									\
			textscale		FONTSCALE_LOBBY																									\
			forecolor		1 1 1 1																											\
			focusColor		1 1 1 1																											\
			disableColor	disableColorArg																									\
			outlinecolor	0 0 0 0																											\
			backcolor		0 0 0 0																											\
			visible			when( visArg )																									\
			dvarTest		ui_selectlobby																									\
			enableDvar		{ "1" }																											\
			noscrollbars																													\
			noBlinkingHighlight																												\
			/*					x		y		w					h	len		horzAlign			vertAlign*/								\
			userarea	8		-35		0		18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* controller icon	*/	\
								-17		0		18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* talking icon		*/	\
								0		0		PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* background		*/	\
								0		0		PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* alternating bg	*/	\
								0		0		RANK_BG_WIDTH		18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank bg			*/	\
								-5		-2.5	18					18	2		ITEM_ALIGN_RIGHT	ITEM_ALIGN_TOP	/* rank				*/	\
								14		0		18					18	3		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank icon		*/	\
								34		-2.5	COLUMN_NAME_WIDTH	18	40		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* player name		*/	\
			onFocus																															\
			{																																\
				hide selection_left;																										\
				show selection_right;																										\
				exec set ui_hint_text "@MPUI_SELECTED_PLAYER_DESC";																			\				
				exec set ui_show_arrow 1;																									\
				exec "updateListboxPos "FEEDER_MENU_NAME;																					\
			}																																\
			leaveFocus																														\
			{																																\
				CLEARUIHINT;																												\
				focusFirst;																													\
			}																																\
			onListboxSelectionChange { play CHOICE_FOCUS_SOUND; }																			\
			actionsArg																														\
		}

#define	SCORE_START_X	(PLAYERLIST_WIDTH-COLUMN_SCORE_WIDTH-4)
		
#define PLAYERLIST_LOBBYFEEDER( feederName, feederArg, yOffsetArg, heightArg, disableColorArg, backColorArg, actionsArg, visArg )					\	
		itemDef																																		\
		{																																			\
			name			feederName																												\
			type			ITEM_TYPE_LISTBOX																										\
			feeder			feederArg																												\
			rect			(-PLAYERLIST_WIDTH) yOffsetArg PLAYERLIST_WIDTH heightArg HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP						\
			elementwidth	300																														\
			elementheight	ELEMENT_HEIGHT																											\
			elementtype		LISTBOX_TEXT																											\
			textfont		UI_FONT_SMALL																											\
			textscale		FONTSCALE_LOBBY																											\
			forecolor		1 1 1 1																													\
			focusColor		1 1 1 1																													\
			disableColor	disableColorArg																											\
			outlinecolor	0 0 0 0																													\
			backcolor		0 0 0 0																													\
			visible			when( visArg )																											\
			dvarTest		ui_selectlobby																											\
			enableDvar		{ "1" }																													\
			noscrollbars																															\
			noBlinkingHighlight																														\
			/*					x				y		w					h	len		horzAlign			vertAlign*/								\
			userarea	9		-35				0		18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* controller icon	*/	\
								-17				0		18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* talking icon		*/	\
								0				0		PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* background		*/	\
								0				0		PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* alternating bg	*/	\
								0				0		RANK_BG_WIDTH		18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank bg			*/	\
								-5				-2.5	18					18	2		ITEM_ALIGN_RIGHT	ITEM_ALIGN_TOP	/* rank				*/	\
								14				0		18					18	3		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank icon		*/	\
								34				-2.5	COLUMN_NAME_WIDTH	18	40		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* player name		*/	\
								SCORE_START_X	-2.5	COLUMN_SCORE_WIDTH	18	9		ITEM_ALIGN_RIGHT	ITEM_ALIGN_TOP	/* score			*/	\
			onFocus																																	\
			{																																		\
				hide selection_left;																												\
				show selection_right;																												\
				exec set ui_hint_text "@MPUI_SELECTED_PLAYER_DESC";																					\				
				exec set ui_show_arrow 1;																											\
				exec "updateListboxPos "FEEDER_MENU_NAME;																							\
				}																																		\
			leaveFocus																																\
			{																																		\
				CLEARUIHINT;																														\
				focusFirst;																															\
			}																																		\
			onListboxSelectionChange { play CHOICE_FOCUS_SOUND; }																					\
			actionsArg																																\
		}

	
#define TEAM_ICON_SIZE			96
#define TEAM_ICON_START_X		( (-PLAYERLIST_WIDTH/2) - (TEAM_ICON_SIZE/2) )
#define ICON_OFFSET_Y			17

#define PLAYERLIST_TEAMICON( pshader, py, pvis )																																	\	
		PREPROC_SHADER_DRAW_VIS_EX( TEAM_ICON_START_X ( PLAYER_FEEDER_Y + ICON_OFFSET_Y + py ) TEAM_ICON_SIZE TEAM_ICON_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,	\
									pshader, .8 .8 .8 .5,																															\
									pvis, ; )
	

#ifndef SPLITSCREEN_PLAYERLIST

		PREPROC_TEXT_DRAW(	(-PLAYERLIST_WIDTH) (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 90 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
							dvarString( party_partyPlayerCount ), 
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, COLUMN_HEADER_COLOR )
							
		PREPROC_TEXT_DRAW_VIS(	-50 (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 50 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
								"@MPUI_SCORE_CAPS", 
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_RIGHT, COLUMN_HEADER_COLOR,
								when( PLAYERLIST_SCOREVIS ) )

#else	// #ifndef SPLITSCREEN_PLAYERLIST
									
		PREPROC_TEXT_DRAW(	(-PLAYERLIST_WIDTH) (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 90 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
							dvarString( splitscreen_partyPlayerCount ), 
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, COLUMN_HEADER_COLOR )
	
		PREPROC_TEXT_DRAW_VIS(	-50 (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 50 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
								"@MPUI_SCORE_CAPS", 
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_RIGHT, COLUMN_HEADER_COLOR,
								when( PLAYERLIST_SCOREVIS ) )

#endif	//	#ifndef SPLITSCREEN_PLAYERLIST


#define LOBBY_LIST_BOX_HEIGHT	342
#define TEAM_LIST_BOX_HEIGHT	167
		
#ifndef SPLITSCREEN_PLAYERLIST
		#define TEAMBASED				( dvarbool( party_teambased ) && dvarbool( party_autoteams ) )
		#define COUNTDOWN				( dvarbool( party_timerVisible ) )
		#define PLAYERLIST_PARTYVIS		( !InLobby() && !dvarBool( xblive_autojoin ) )
		#define SHOW_TEAMS				( COUNTDOWN && TEAMBASED )
		#define PLAYERLIST_MEMBERVIS	( !SHOW_TEAMS && InLobby())
		#define PLAYERLIST_TEAMSVIS		( SHOW_TEAMS && InLobby())
		#define MAP_USING_SOG_NVA		( tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "junglemarines" )
		#define MAP_USING_CUBANS		( tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "cubans" )
		#define MAP_USING_OPS_SPETS		( !MAP_USING_SOG_NVA && !MAP_USING_CUBANS )
		
		PLAYERLIST_PARTYFEEDER( "partyList", FEEDER_PARTY_MEMBERS,		PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_PARTYVIS )
		PLAYERLIST_PARTYFEEDER( "partyList", FEEDER_AUTOJOIN_MEMBERS,	PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, dvarBool( xblive_autojoin ) )

		PLAYERLIST_LOBBYFEEDER( "lobbyList", FEEDER_LOBBY_MEMBERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_MEMBERVIS )

		
		// This is a dummy itemDef that is used to set the focus back on the buttons in the menu when the teams split
		itemDef
		{
			name		highlight_controller
			style		WINDOW_STYLE_SHADER
			rect		0 0 0 0
			visible 	1
			decoration

			state
			{
				name	state_1
				onEnter
				{
					if( hasfocus( "lobbyList" ) && PLAYERLIST_TEAMSVIS )
					{
						focusFirst;
					}
					else
					{
						changeState state_2 50;
					}
				}
			}			
			state
			{
				name	state_2
				onEnter
				{
					if( hasfocus( "lobbyList" ) && PLAYERLIST_TEAMSVIS )
					{
						focusFirst;
					}
					else
					{
						changeState state_1 50;
					}
				}
			}
		}

		PLAYERLIST_TEAMICON( "menu_mp_lobby_sog",		0, when(PLAYERLIST_TEAMSVIS && MAP_USING_SOG_NVA	&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_op40",		0, when(PLAYERLIST_TEAMSVIS && MAP_USING_CUBANS		&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_ops",		0, when(PLAYERLIST_TEAMSVIS && MAP_USING_OPS_SPETS	&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_nva",		0, when(PLAYERLIST_TEAMSVIS && MAP_USING_SOG_NVA	&& player( teamname ) == "TEAM_AXIS")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_tropas",	0, when(PLAYERLIST_TEAMSVIS && MAP_USING_CUBANS		&& player( teamname ) == "TEAM_AXIS")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_spets",		0, when(PLAYERLIST_TEAMSVIS && MAP_USING_OPS_SPETS	&& player( teamname ) == "TEAM_AXIS")	)
		
		PLAYERLIST_LOBBYFEEDER( "myMembersList", FEEDER_MYTEAM_MEMBERS, PLAYER_FEEDER_Y, TEAM_LIST_BOX_HEIGHT, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, ;, PLAYERLIST_TEAMSVIS )

		PLAYERLIST_TEAMICON( "menu_mp_lobby_nva",		TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_SOG_NVA		&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_tropas",	TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_CUBANS		&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_spets",		TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_OPS_SPETS	&& player( teamname ) == "TEAM_ALLIES")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_sog",		TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_SOG_NVA		&& player( teamname ) == "TEAM_AXIS")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_op40",		TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_CUBANS		&& player( teamname ) == "TEAM_AXIS")	)
		PLAYERLIST_TEAMICON( "menu_mp_lobby_ops",		TEAM_LIST_BOX_HEIGHT, when(PLAYERLIST_TEAMSVIS && MAP_USING_OPS_SPETS	&& player( teamname ) == "TEAM_AXIS")	)
		
		PLAYERLIST_LOBBYFEEDER( "enemyMembersList", FEEDER_ENEMY_MEMBERS, (PLAYER_FEEDER_Y + 0 + TEAM_LIST_BOX_HEIGHT), 180, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, ;, PLAYERLIST_TEAMSVIS )
	
#else

		#define PLAYERLIST_TEAMSVIS		1

		PLAYERLIST_LOBBYFEEDER( "splitscreen_playerlist", FEEDER_SPLITSCREENPLAYERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, 1 1 1 1, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, 1 )
		
#endif // #ifndef SPLITSCREEN_PLAYERLIST
	
	// party host icon
#ifdef SHOW_PRIVATE_PARTY_HOST
		#define HOST_ICON_SIZE		14
		PREPROC_SHADER_DRAW_VIS_EX( ( -HOST_ICON_SIZE) ( PLAYER_FEEDER_Y + 4 ) HOST_ICON_SIZE HOST_ICON_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,
									"ui_host", 0.825 0.825 0.825 0.7,
									when( !dvarBool( xblive_autojoin ) ), ; )
#endif	
	
#include "ui_mp/popup_player_info.inc"

#define CURRENT_LIST_INDEX \
		max( GetFeederData( "partyList", "selection"), GetFeederData( "lobbyList", "selection"), GetFeederData( "myMembersList", "selection") )

#define HIGHLIGHT_INFO_Y_START		(PLAYER_FEEDER_Y + 4)			// + 4 is to make up for that weird playlist hackery in Item_ListBox_PaintTextElem
#define HIGHLIGHT_INFO_Y_OFFSET		(ELEMENT_HEIGHT / 2)			
#define HIGHLIGHT_INFO_Y			( PLAYER_FEEDER_Y + HIGHLIGHT_INFO_Y_OFFSET + ( ELEMENT_HEIGHT * CURRENT_LIST_INDEX ) - ( PLAYER_INFO_HEIGHT / 2 ) )

	PLAYER_INFO_ADV( (-PLAYERLIST_WIDTH), HIGHLIGHT_INFO_Y, HORIZONTAL_ALIGN_RIGHT, VERTICAL_ALIGN_TOP, ( hasfocus( "partyList" ) || hasfocus( "lobbyList" ) ) )





